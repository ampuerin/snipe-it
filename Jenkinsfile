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
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
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
				export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			    export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
				export mysqlpassword=$(vault kv get -field=dbkey snipeit/mysql)
				export appkey=$(vault kv get -field=appkey snipeit/app)
				packer build -var aws_access_key=$aws_access_key -var aws_secret_key=$aws_secret_key -var mysqlpassword=$mysqlpassword appkey=$appkey snipeitweb.json 
				packer build -var aws_access_key=$aws_access_key -var aws_secret_key=$aws_secret_key -var mysqlpassword=$mysqlpassword snipeitdb.json 
				'''
        }
    }
    stage('AWS Deployment') {
      steps {
            sh '''
			   export aws_access_key=$(vault kv get -field=ampuops aws/access_key)
			   export aws_secret_key=$(vault kv get -field=ampuops aws/secret_key)
			   terraform init -var access_key=$aws_access_key -var secret_key=$aws_secret_key
               terraform apply -auto-approve -var access_key=$aws_access_key -var secret_key=$aws_secret_key
            '''
        }      
    }
  }
}