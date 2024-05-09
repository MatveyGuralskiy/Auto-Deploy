#!/bin/bash

#Script for EC2 Instances to run Docker Containers with Application
#-------------------------------------
#Created by Matvey Guralskiy

#Install Docker with script
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# To run docker
sudo systemctl start docker
sudo systemctl enable docker
# To Install my Application from DockerHub
sudo docker pull matveyguralskiy/auto-deploy:V1.1
# To run the Docker Container on port HTTP
sudo docker run -d -p 80:80 matveyguralskiy/auto-deploy:V1.1