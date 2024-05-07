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
                    try {
                        sh 'nc -zv localhost 80'
                        echo "Port 80 is open"
                    } catch (Exception e) {
                        error "Port 80 is closed: ${e.message}"
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
                                if (fileExists('Application/Application')) {
                                    dir('Application') {
                                        sh 'git pull origin main'
                                    }
                                } else {
                                    sh 'git clone https://github.com/MatveyGuralskiy/Auto-Deploy.git Application'
                                }
                                dir('Application/Application') {
                                    sh 'docker build -t auto-deploy:V1.0 .'
                                }
                                sh 'echo "Application created to Docker Image"'
                            }
                        }
                    } catch (Exception e) {
                        error "Failed to clone repository or build Docker image: ${e.message}"
                    }
                }
            }
        }
        stage('Rename and Push Docker Image to DockerHub') {
            steps {
                script {
                    try {
                        withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                            sh 'docker tag auto-deploy:V1.0 matveyguralskiy/auto-deploy:V1.0'
                            sh 'docker push matveyguralskiy/auto-deploy:V1.0'
                            echo "Docker Image uploaded"
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
                        sh 'docker pull matveyguralskiy/auto-deploy:V1.0'
                        sh 'docker run -d --name test-container -p 7000:80 matveyguralskiy/auto-deploy:V1.0'
                        def response = sh(script: 'curl -s -o /dev/null -w "%{http_code}" localhost', returnStdout: true).trim()
                        if (response == '200') {
                            echo "Application page is accessible"
                        } else {
                            error "Failed to access application page. HTTP status code: ${response}"
                        }
                        sh 'docker rm -f test-container'
                        echo "Docker Container Test Success"
                    } catch (Exception e) {
                        error "Failed to test Docker container: ${e.message}"
                    }
                }
            }
        }
    }
}
