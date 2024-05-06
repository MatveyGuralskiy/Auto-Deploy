pipeline {
    agent any
    
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        GITHUB_CREDENTIALS = credentials('github')
    }

    stages {
        stage('Testing Port 80') {
            steps {
                script {
                    sh 'echo "Starting to Testing"'
                    def portStatus = sh(script: 'nc -zv localhost 80', returnStatus: true)
                    if (portStatus == 0) {
                        echo "Port 80 is open"
                    } else {
                        error "Port 80 is closed"
                    }
                    sh 'echo "Test was Success"'
                }
            }
        }
        stage('Clone Repository and Build Docker Image') {
            steps {
                dir('docker-image') {
                    sh 'echo "Starting to Clone and Build Image"'
                    sh 'git clone https://github.com/MatveyGuralskiy/Auto-Deploy.git Application'
                    sh 'docker build -t auto-deploy:V1.0 .'
                    sh 'echo "Application created to Docker Image"'
                }
            }
        }
        stage('Push Docker Image to DockerHub') {
            steps {
                script {
                    sh 'echo "Starting to Push Image to DockerHub"'
                    sh 'docker tag auto-deploy:V1.0 matveyguralskiy/auto-deploy:V1.0'
                    sh 'docker push matveyguralskiy/auto-deploy:V1.0'
                    sh 'echo "Docker Image uploaded"'
                }
            }
        }
        stage('Deploy Infrastructure with Terraform') {
            steps {
                script {
                    dir('Terraform') {
                        sh 'echo "Starting Terraform deployment"'
                        sh 'git clone https://github.com/MatveyGuralskiy/Auto-Deploy.git Terraform'
                        sh 'terraform init'
                        sh 'terraform plan -out=tfplan'
                        sh 'terraform apply tfplan'
                        sh 'echo "Terraform deployment completed"'
                    }
                }
            }
        }
        stage('Configure Infrastructure with Ansible') {
            steps {
                script {
                    dir('Ansible') {
                        sh 'echo "Starting Ansible configuration"'
                        sh 'ansible-playbook playbook.yml'
                        sh 'echo "Ansible configuration completed"'
                    }
                }
            }
        }
    }
}