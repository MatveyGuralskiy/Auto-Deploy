pipeline {
    agent any
    
    // credentials
    environment {
        DOCKER_HUB_CREDENTIALS = credentials('dockerhub')
        GITHUB_CREDENTIALS = credentials('github')
    }

    stages {
        stage('Testing Port 80') {
            steps {
                script {
                    try {
                        sh 'echo "Starting to Testing Port 80"'
                        def portStatus = sh(script: 'nc -zv localhost 80', returnStatus: true)
                        if (portStatus == 0) {
                            echo "Port 80 is open"
                        } else {
                            error "Port 80 is closed"
                        }
                        sh 'echo "Port 80 Test Success"'
                    } catch (Exception e) {
                        error "Failed to test port 80: ${e.message}"
                    }
                }
            }
        }
        stage('Clone Repository and Build Docker Image') {
            steps {
                script {
                    try {
                        dir('Docker-Image') {
                            sh 'echo "Starting to Clone and Build Image"'
                            withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GITHUB_USERNAME', passwordVariable: 'GITHUB_PASSWORD')]) {
                                if (fileExists('Application')) {
                                    // If repository already consist, update it
                                    dir('Auto-Deploy') {
                                        dir('Application') {
                                             if (!fileExists('Dockerfile')) {
                                            error "Dockerfile not found in the repository."
                                            }
                                            sh 'git pull origin main'
                                        }
                                    }
                                } else {
                                    sh 'git clone https://github.com/MatveyGuralskiy/Auto-Deploy.git'
                                }
                                // Build Docker Image
                                dir('Auto-Deploy') {
                                    dir('Application') {
                                        sh 'docker build -t auto-deploy:V1.0 .'
                                    }
                                }
                                sh 'echo "Application created to Docker Image"'
                            }
                        }
                    } catch (Exception e) {
                        error "Failed to clone repository or build Docker image ${e.message}"
                    }
                }
            }
        }
        stage('Rename and Push Docker Image to DockerHub') {
            steps {
                script {
                    try {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh 'echo "Starting to Rename and Push Image to DockerHub"'
                            sh 'docker tag auto-deploy:V1.0 matveyguralskiy/auto-deploy:V1.0'
                            sh 'docker push matveyguralskiy/auto-deploy:V1.0'
                            sh 'echo "Docker Image uploaded"'
                        }
                    } catch (Exception e) {
                        error "Failed to push Docker image to DockerHub: ${e.message}"
                    }
                }
            }
        }
        stage('Testing Docker Container') {
            steps {
                script {
                    try {
                        sh 'echo "Starting to Test Docker Container"'
                        // Download Image from DockerHub
                        sh 'docker pull matveyguralskiy/auto-deploy:V1.0'
                        // Run Docker Image on port 80
                        sh 'docker run -d --name test-container -p 80:80 matveyguralskiy/auto-deploy:V1.0'
                        // Testing with curl
                        def response = sh(script: 'curl -s -o /dev/null -w "%{http_code}" localhost', returnStdout: true).trim()
                        if (response == '200') {
                            echo "Application page is accessible"
                        } else {
                            error "Failed to access application page. HTTP status code: ${response}"
                        }
                        // Terminate Docker Container
                        sh 'docker rm -f test-container'
                        sh 'echo "Docker Container Test Success"'
                    } catch (Exception e) {
                        error "Failed to test Docker container: ${e.message}"
                    }
                }
            }
        }
    }
}
