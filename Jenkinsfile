pipeline {
  agent any
      environment {		
        VAULT_ADDR = "http://127.0.0.1:8200"
    }
  stages {
    stage('Validar imagen packer del servidor web') {
        steps {
		withCredentials([string(credentialsId: 'vaultlogin', variable: 'vault_token')])
		{
            sh '''
				vault login ${vault_token}
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				export appkey=$(vault kv get -field=appkey snipeit/app)
				packer validate packer/snipeitweb.json
				'''
        }
		}
    }
    stage('Crear imagen packer del servidor web en AWS') {
		when { branch "ampuero" }
        steps {
		withCredentials([string(credentialsId: 'vaultlogin', variable: 'vault_token')])
		{
            sh '''
				export VAULT_TOKEN = ${vault_token}
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				export appkey=$(vault kv get -field=appkey snipeit/app)
				packer build -var aws_access_key=$aws_access_key -var aws_secret_key=$aws_secret_key -var mysqlpassword=$mysqlpassword -var appkey=$appkey packer/snipeitweb.json 
				'''
        }
		}
    }
	stage('Validar imagen packer del servidor de base de datos') {
        steps {
		withCredentials([string(credentialsId: 'vaultlogin', variable: 'vault_token')])
        {
			sh '''
				export VAULT_TOKEN = ${vault_token}
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				packer validate packer/snipeitdb.json
				'''
        }
		}
    }
    stage('Crear imagen packer del servidor de base de datos en AWS') {
		when { branch "ampuero" }
        steps {
		withCredentials([string(credentialsId: 'vaultlogin', variable: 'vault_token')])
		{
            sh '''
				export VAULT_TOKEN = ${vault_token}
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				packer build -var aws_access_key=$aws_access_key -var aws_secret_key=$aws_secret_key -var mysqlpassword=$mysqlpassword packer/snipeitdb.json 
				'''
        }
		}
    }
    stage('Ejecutar plan de infraestructura de Terraform') {
      steps{ 
	  withCredentials([sshUserPrivateKey(credentialsId: "aws-credenciales-ssh-ops", keyFileVariable: 'aws_ssh_key')])
	  withCredentials([string(credentialsId: 'vaultlogin', variable: 'vault_token')])
	  {
            sh '''
			   export VAULT_TOKEN = ${vault_token}
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
	stage('Despliegue en AWS del plan de Terraform') {
      steps{ 
	  withCredentials([sshUserPrivateKey(credentialsId: "aws-credenciales-ssh-ops", keyFileVariable: 'aws_ssh_key')])
	  withCredentials([string(credentialsId: 'vaultlogin', variable: 'vault_token')])
	  {
            sh '''
			   export VAULT_TOKEN = ${vault_token}
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
	stage('Destruir todos los recursos de Terraform') {
	  when { branch "feature/destroy" }
      steps{ 
	  withCredentials([sshUserPrivateKey(credentialsId: "aws-credenciales-ssh-ops", keyFileVariable: 'aws_ssh_key')])
	  withCredentials([string(credentialsId: 'vaultlogin', variable: 'vault_token')])
	  {
            sh '''
			   export VAULT_TOKEN = ${vault_token}
			   export AWS_ACCESS_KEY_ID=$(vault kv get -field=ampuops aws/access_key)
			   export AWS_SECRET_ACCESS_KEY=$(vault kv get -field=ampuops aws/secret_key)
			   cat ${aws_ssh_key} > ampuops.pem
			   terraform init
               terraform destroy -auto-approve
            '''
        }      
    }
	}
  }
}
