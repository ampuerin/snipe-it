pipeline {
    agent any
    stages {
		stage('Crear imagen inmutable del servidor web con Packer') {
			steps {
				sh 'packer validate snipeitweb.json'
				sh 'packer build snipeitweb.json'
			}
		}
		stage('Crear imagen inmutable del servidor de base de datos con Packer') {
			steps {
				sh 'packer validate snipeitdb.json'
				sh 'packer build snipeitdb.json'
			}
		}
		stage('Despliegue en AWS con Terraform') {
			steps {
			withCredentials([
				usernamePassword(credentialsId: 'ada90a34-30ef-47fb-8a7f-a97fe69ff93f', passwordVariable: 'AWS_SECRET', usernameVariable: 'AWS_KEY')
			]){			
				sh '''
					terraform init
					terraform plan
					terraform apply -auto-approve
				'''
			}
			}
		}
    }
}