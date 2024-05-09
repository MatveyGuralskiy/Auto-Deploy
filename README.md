
<div align="center">

  <img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Logo.png?raw=true" alt="logo" width="400" height="auto" />
  <h1>Auto-Deploy Project</h1>
  
  <p>
    Automated Application deployment system using tools such as <strong>Docker, Jenkins, Terraform, AWS, Git, GitHub</strong>
  </p>
  <p>
    <img src="https://img.shields.io/badge/AWS-coral" alt="AWS">&nbsp;
    <img src="https://img.shields.io/badge/Docker-blue" alt="Docker">&nbsp;
    <img src="https://img.shields.io/badge/Jenkins-tomato" alt="Jenkins">&nbsp;
    <img src="https://img.shields.io/badge/Terraform-mediumpurple" alt="Terraform">&nbsp;
    <img src="https://img.shields.io/badge/GitHub-black"  alt="GitHub">&nbsp;
    <img src="https://img.shields.io/badge/Git-darkred"  alt="Git">&nbsp;
    <img src="https://img.shields.io/badge/CSS-skyblue" alt="CSS">&nbsp;
    <img src="https://img.shields.io/badge/HTML-hotpink" alt="HTML">&nbsp;
  </p>
</div>

  <p align="center">
    <br>
    <a href="https://www.linkedin.com/in/matveyguralskiy/">LinkedIn</a>
    .
    <a href="https://github.com/MatveyGuralskiy/Auto-Deploy-Website/issues">Report Bug</a>
    ·
    <a href="https://matveyguralskiy.com">My Website</a>
  </p>
<br>

<h2>🔍 About the Project</h2>
My project is all about making things easier for developers. Whenever there's a new update on GitHub, a program called Jenkins gets to work. It runs tests to make sure everything's still working smoothly. Then, it takes those files and turns them into special packages called Docker images. These images are stored online on something called Docker Hub.

After that, we check to make sure everything still works with those Docker images. Next up, we use a tool called Terraform to set up all the necessary computer stuff on Amazon Web Services (AWS). Finally, we end up with a fully functional website that you can access using a simple web address. It's all secure, too, with encryption and all that, and it's spread across four servers, each running those Docker packages we made earlier.

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Demonstration.png?raw=true">
<br>
<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Website-V1.2-31.png?raw=true">
<h2>3 Steps of Project and Detail Demonstartion</h2>
<br>
<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Step-1.png?raw=true">
<br>
<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Step-2.png?raw=true">
<br>
<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Step-3.png?raw=true">
<br>
<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Detail-Demonstarion.png?raw=true">
<br>

### 📱 Application for Docker Image Built With

* HTML
* CSS

## 🚀 Getting Started

### 👣 Steps
- [ ] Create Master-Instance in AWS
- [ ] Install Jenkins, Docker, Terraform and nginx on Instance
- [ ] Go to Jenkins Dashboard and create Job with Pipeline and use GitHub Plugin
- [ ] Create Repository of your Project in GitHub and connect Jenkins with WebHook 
- [ ] Create Jenkinsfile in Repository
- [ ] Add Credentials in Jenkins of AWS, DockerHub, GitHub
- [ ] Write Dockerfile
- [ ] Copy to Jenkinsfile my pipeline
- [ ] Create Empty Repository in DockerHub
- [ ] Create in service Certificate Manager SSL Certificate and make DNS Validation with Route53
- [ ] Create Bash script for Bootstrapping for Instances to install docker and pull Image from DockerHub
- [ ] Run Jenkins Job
- [ ] Make changes in GitHub repository to see Auto-Deploy of Project

#### Create Master Instance
- [x] Create Master-Instance in AWS
      
Create Security group with ports: 80, 8080, 22, 7000

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Security-Group-1.png?raw=true">

Go to AWS EC2 Instances and run Ubuntu Image with Instance type "t3.small"

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Master-Instance-2.png?raw=true">

Create Key-pair in AWS and copy the Private Key for SSH connection

Go to EC2 Instance Console and copy PublicIP

Connect with Protocol SSH to Instance (for example use MobaXterm)


#### Install Jenkins, Docker, Terraform and nginx on Instance
- [x] Install Jenkins, Docker, Terraform and nginx on Instance

Install nginx for Testing
```
sudo apt update
sudo apt install nginx
```

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Master-SSH-3.png?raw=true">

Install Jenkins + Java
```
# Install Java
sudo apt update
sudo apt install fontconfig openjdk-17-jre

#Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins
# To check if Jenkins works
java --version
jenkins --version
```

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Master-SSH-4.png?raw=true">

Install Docker
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install Docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# To Add User to Docker
sudo usermod -aG docker $USER
# To Add Jenkins User to Docker
sudo usermod -aG docker jenkins
# After that Reboot your Instance
# To check if Docker works
docker images
```

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Master-SSH-5.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Master-SSH-6-2.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Reboot-Master-23.png?raw=true">

Install Terraform
```
sudo snap install terraform --classic
terraform --version
```

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Master-SSH-6.png?raw=true">

#### Go to Jenkins Dashboard and create Job with Pipeline and use GitHub Plugin
- [x] Go to Jenkins Dashboard and create Job with Pipeline and use GitHub Plugin
Go to AWS EC2 Instance Console to the PublicIP and copy him

Open Browser and put the PublicIP:8080 and start to sign up and install Plugins

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-7.png?raw=true">

Create Job with Pipeline and choose GitHub and Copy repository link and path to Jenkins

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-8.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-9.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-10.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-11.png?raw=true">

#### Create Repository of your Project in GitHub and connect Jenkins with WebHook
- [x] Create Repository of your Project in GitHub and connect Jenkins with WebHook
In GitHub Repository go to Setting --> Webhook and enter the http://PublicIP:8080/github-webhook/

Now every commit you push in GitHub automatically will run Jenkins Job

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/GitHub-Webhook-16.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/GitHub-Webhook-17.png?raw=true">

#### Create Jenkinsfile in Repository
- [x] Create Jenkinsfile in Repository
In GitHub repository create Jenkinsfile or Jenkinsfile.groovy and don't forget in Jenkins Job enter the path to the file

#### Add Credentials in Jenkins of AWS, DockerHub, GitHub
- [x] Add Credentials in Jenkins of AWS, DockerHub, GitHub

Go to Dashboard --> Manage --> Credentials --> Global --> Add credentials

Add credentials for DockerHub and GitHub just email + password

Now for AWS I created IAM profile and download for him Access key and Secret key

So to use them for authorization I used in Credentials type of Secret text and create one for Access Key and the second one for Secret Key

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-12.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-13.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-14.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Jenkins-15.png?raw=true">

#### Write Dockerfile
- [x] Write Dockerfile
To package your Application to Docker Image you need Dockerfile inside Application directory

You can use my Dockerfile from repository,

He use Amazon Linux Distribution, he makes updates and install Apache Webserver

and at the end he just copy all files from directory and package them to Docker Image, He also uses port 80 to made Webserver


#### Copy to Jenkinsfile my pipeline
- [x] Copy to Jenkinsfile my pipeline
Go to my repository directory Jenkins and use my Jenkinsfile, of course modified it for personal use


#### Create Empty Repository in DockerHub
- [x] Create Empty Repository in DockerHub
Go to DockerHub and Create simple Repository to upload Images of Application from Jenkins

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/DockerHub-18.png?raw=true">

#### Create in service Certificate Manager SSL Certificate and make DNS Validation with Route53
- [x] Create in service Certificate Manager SSL Certificate and make DNS Validation with Route53
Before to work with project you need DNS Domain for usage

Go to AWS Console Certificate Manager and make Request and enter DNS name

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Certificate-Manager-19.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Certificate-Manager-20.png?raw=true">

Click to Certificate and Click at the button "Create Record in Route53"

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Certificate-Manager-21.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Certificate-Manager-22.png?raw=true">

In terraform file *variables.tf* change the arn to arn of Certificate you get

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Certificate-ARN-24.png?raw=true">

#### Create Bash script for Bootstrapping for Instances to install docker and pull Image from DockerHub
- [x] Create Bash script for Bootstrapping for Instances to install docker and pull Image from DockerHub
You can use my Script from repository go to directory Bash --> bootstrapping.sh

Now our Ubuntu Instances will Install Docker and our Docker Image from DockerHub and run it on port 80

#### Run Jenkins Job
- [x] Run Jenkins Job
After everything you get all files, Run the Job in Jenkins and enjoy your Application full Deployment:)

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Run-Job-25.png?raw=true">

Now go to your DNS name for example: "website.matveyguralskiy.com" and you can see your Application in Port 443

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Website-V1.0-27.png?raw=true">

with SSL Certificate and if you go to Port 80 Application Load Balancer of AWS will make Redirect to Port 443

Your DockerHub will be look like that

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/DockerHub-28.png?raw=true">

#### Make changes in GitHub repository to see Auto-Deploy of Project
- [x] Make changes in GitHub repository to see Auto-Deploy of Project
For example change the Docker version in Jenkinsfile and change HTML file of Application

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Change-Version-26.png?raw=true">

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Website-V1.2-31.png?raw=true">

Now Your Intances will upload new version of Application


And DockerHub get now new versions of Project

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/DockerHub-29.png?raw=true">

It's all Jobs in Jenkins

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Run-Jobs-30.png?raw=true">

In AWS Console Route53 get new Record because of Terraform

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Route53-32.png?raw=true">

It's All List of Instances

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Instances-33.png?raw=true">
<h2>🎬 View Demo</h2>
<p>Comming soon...</p>


<h2>📂 Repository</h2>
<p>
  |-- /Application

  |-- /Bash

  |-- /Jenkins

  |-- /Screens

  |-- /terraform

  |-- LICENSE

  |-- README.md

</p>



## 📚 Acknowledgments
Documentations for you to make the project

* [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
* [AWS for begginers](https://aws.amazon.com/getting-started/)
* [Terraform work with AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Docker Build Images](https://docs.docker.com/build/)
* [DockerHub Registry](https://docs.docker.com/docker-hub/)
* [Git Control your code](https://git-scm.com/doc)
* [HTML to build Application](https://developer.mozilla.org/en-US/docs/Web/HTML)
* [CSS to style Application](https://developer.mozilla.org/en-US/docs/Web/CSS)
* [SSH connect to Instances](https://www.ssh.com/academy/ssh/command)


<h2>📢 Additional Information</h2>
<p>
  I hope you liked my project, don’t forget to rate it and if you notice a code malfunction or any other errors.
  
  Don’t hesitate to correct them and be able to improve your project for others
</p>

## 📩 Contact

Email - <a href="mailto:mathewguralskiy@gmail.com">Contact</a>

GitHub - <a href="https://github.com/MatveyGuralskiy" target="_blank">Profile</a>

LinkedIn - <a href="https://www.linkedin.com/in/matveyguralskiy/" target="_blank">Profile</a>

Instagram - <a href="https://www.instagram.com/matvey_guralskiy/" target="_blank">Profile</a>

<h2>© License</h2>
<p>
Distributed under the MIT license. See LICENSE.txt for more information.
</p>
