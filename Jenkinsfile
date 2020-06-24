pipeline {
    agent any
    environment {
        AWS_KEY = vault path: 'aws/access_key', key: 'ampuops'
		AWS_SECRET = vault path: 'aws/secret_key', key: 'ampuops'
    }
    stages {
        stage("read vault key") {
            steps {
				withCredentials([
				[
				$class: 'VaultTokenCredentialBinding',
				credentialsId: '2908293b-770d-4346-b436-4f6ec62d524c',
				vaultAddr: 'http://127.0.0.1:8200'
				]
				])
				{
                echo "${AWS_KEY}"
				echo "${AWS_SECRET}"
				}
			}	
		}
		stage('Crear imagen inmutable del servidor web con Packer') {
			steps {
				{
				sh 'packer validate snipeitweb.json'
				sh 'packer build snipeitweb.json'
				}
			}
		}
		stage('Crear imagen inmutable del servidor de base de datos con Packer') {
			steps {
			{
				sh 'packer validate snipeitdb.json'
				sh 'packer build snipeitdb.json'
			}
		}
		}
		stage('Despliegue en AWS con Terraform') {
			steps {			
				sh '''
					terraform init
					terraform plan
					terraform apply -auto-approve -var access_key=${AWS_KEY} -var secret_key=${AWS_SECRET}
				'''
			}
		}
    }
}