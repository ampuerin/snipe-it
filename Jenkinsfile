pipeline {
  agent any
      environment {
        VAULT_ADDR = "http://127.0.0.1:8200"
        VAULT_TOKEN = "s.6EXFh9aVAbR3ItgoPBqvhMbS"
    }
  stages {
    stage('Validate web-node Packer AMI') {
        steps {
            sh '''
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				export appkey=$(vault kv get -field=appkey snipeit/app)
				packer validate snipeitweb.json
				'''
        }
    }
    stage('Create web-node Packer AMI') {
		when { branch "feature/ampueroweb" }
        steps {
            sh '''
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				export appkey=$(vault kv get -field=appkey snipeit/app)
				packer build -var aws_access_key=$aws_access_key -var aws_secret_key=$aws_secret_key -var mysqlpassword=$mysqlpassword -var appkey=$appkey snipeitweb.json 
				'''
        }
    }
	stage('Validate database node Packer AMI') {
        steps {
            sh '''
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				packer validate snipeitdb.json
				'''
        }
    }
    stage('Create database node Packer AMI') {
		when { branch "feature/ampuerodb" }
        steps {
            sh '''
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				packer build -var aws_access_key=$aws_access_key -var aws_secret_key=$aws_secret_key -var mysqlpassword=$mysqlpassword snipeitdb.json 
				'''
        }
    }
    stage('Infrastructure plan with Terraform') {
      steps{ 
	  withCredentials([sshUserPrivateKey(credentialsId: "2b5c9bb1-79fc-4bca-9de8-7f268e2fa1fa", keyFileVariable: 'aws_ssh_key')])
	  {
            sh '''
			   export AWS_ACCESS_KEY_ID=$(vault kv get -field=ampuops aws/access_key)
			   export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=ampuops aws/secret_key)
			   cat ${aws_ssh_key} > ampuops.pem
			   terraform init
			   terraform plan
               terraform apply -auto-approve
            '''
        }      
    }
	}
	stage('Deployment in AWS Cloud with Terraform') {
      steps{ 
	  withCredentials([sshUserPrivateKey(credentialsId: "2b5c9bb1-79fc-4bca-9de8-7f268e2fa1fa", keyFileVariable: 'aws_ssh_key')])
	  {
            sh '''
			   export AWS_ACCESS_KEY_ID=$(vault kv get -field=ampuops aws/access_key)
			   export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=ampuops aws/secret_key)
			   cat ${aws_ssh_key} > ampuops.pem
			   terraform init
			   terraform plan
               terraform apply -auto-approve
            '''
        }      
    }
	}
  }
}
