variable "ampuopskey" {}

provider "aws" {
  region = "eu-central-1"
}

terraform {
 backend "s3" {
  bucket = "terraform-jenkins-dev"
  encrypt = false
  key = "snipeit/terraform.tfstate"
  region = "eu-central-1"
 }
}

resource "aws_security_group" "web-nodes" {
  name = "web-nodes"
  description = "Web Security Group"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }    
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "mysql-node" {
  name = "mysql-node"
  description = "mysqldb Security Group"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "mysqlwall" {
  type              = "ingress"
  from_port         = 3306
  to_port           = 3306
  protocol          = "tcp"
  security_group_id = "${aws_security_group.mysql-node.id}"
  source_security_group_id = "${aws_security_group.web-nodes.id}"
}

data "aws_ami" "latest-mysql" {
most_recent = true
owners = ["030267169855"]

  filter {
      name   = "name"
      values = ["mysql-snipeit*"]
  }
}
data "aws_ami" "latest-web-snipeit" {
most_recent = true
owners = ["030267169855"]

  filter {
      name   = "name"
      values = ["web-php-snipeit*"]
  }
}

resource "aws_instance" "snipeit-mysql-node" {
  
  ami           = "${data.aws_ami.latest-mysql.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.mysql-node.name}"]
  key_name = "ampuops"
  iam_instance_profile = "packer_s3"
  
  tags = {
    Name = "snipeit-mysql"
  }
}
resource "aws_instance" "snipeit-web-node" {

  ami = "${data.aws_ami.latest-web-snipeit.id}"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.web-nodes.name}"]
  key_name = "ampuops"
  iam_instance_profile = "packer_s3"
  
  tags = {
    Name = "snipeit-php"
  }
  provisioner "remote-exec" {
  inline = [
   "sed 's/localhost/${aws_instance.snipeit-mysql-node.private_ip}/g' /var/www/snipeit/.env > ~/.env",
   "sudo cp /home/ubuntu/.env /var/www/snipeit/.env"
   ]
  connection {
    host		= "${aws_instance.snipeit-web-node.public_dns}"
    type        = "ssh"
    user        = "ubuntu"
    private_key = "${var.ampuopskey}"
  }
 }
}
