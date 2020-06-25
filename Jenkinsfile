pipeline {
  agent any
      environment {
        VAULT_ADDR = "http://127.0.0.1:8200"
        VAULT_TOKEN = "s.6EXFh9aVAbR3ItgoPBqvhMbS"
    }
  stages {
    stage('Validate Packer AMI') {
        steps {
            sh '''
				export AWS_KEY=$(vault kv get -field=ampuops aws/access_key)
			    export AWS_SECRET=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				export appkey=$(vault kv get -field=appkey snipeit/app)
				packer validate snipeitweb.json
				packer validate snipeitdb.json
				'''
        }
    }
    stage('Create Packer AMI') {
        steps {
            sh '''
				export AWS_KEY=$(vault kv get -field=ampuops aws/access_key)
			    export AWS_SECRET=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				export appkey=$(vault kv get -field=appkey snipeit/app)
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