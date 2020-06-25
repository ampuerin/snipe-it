pipeline {
  agent any
      environment {
        VAULT_ADDR = "http://127.0.0.1:8200"
        VAULT_TOKEN = "s.6EXFh9aVAbR3ItgoPBqvhMbS"
    }
  stages {
    stage('Create Packer AMI') {
        steps {
            sh '''
				packer build snipeitweb.json
				packer build snipeitdb.json
				'''
        }
    }
    stage('AWS Deployment') {
      steps {
            sh '''
               export AWS_KEY=$(vault kv get -field=ampuops aws/access_key)
			   export AWS_SECRET=$(vault kv get -field=ampuops aws/secret_key)
			   terraform init
               terraform apply -auto-approve -var access_key=$AWS_KEY -var secret_key=$AWS_SECRET
            '''
        }      
    }
  }
}