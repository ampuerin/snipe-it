pipeline {
    agent any
    stages {
        stage("Comienzo") {
            steps {
                echo "Hola"
			}	
		}
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
				sh '''
					terraform init
					terraform plan
					terraform apply -auto-approve
				'''
			}
		}
    }
}