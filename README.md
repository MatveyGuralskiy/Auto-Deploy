
<div align="center">

  <img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Screens/Logo.png?raw=true" alt="logo" width="400" height="auto" />
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

<img src="https://github.com/MatveyGuralskiy/Auto-Deploy/blob/main/Screens/Screens/Demonstration.png?raw=true">
<br>

### 📱 Application for Docker Image Built With

* HTML
* CSS

## 🚀 Getting Started

### 👣 Steps
- [x] Create Master-Instance in AWS
- [x] Install Jenkins, Docker, Terraform and nginx on Instance
- [x] Go to Jenkins Dashboard and create Job with Pipeline and use GitHub Plugin
- [x] Create Repository of your Project in GitHub and connect Jenkins with WebHook 
- [x] Create Jenkinsfile in Repository
- [x] Add Credentials in Jenkins of AWS, DockerHub, GitHub
- [x] Copy to Jenkinsfile my pipeline
- [x] Create Empty Repository in DockerHub
- [x] Create in service Certificate Manager SSL Certificate and make DNS Validation with Route53
- [x] Create Bash script for Bootstapping for Instances to install docker and pull Image from DockerHub
- [x] Run Jenkins Job
- [x] Make changes in GitHub repository to see Auto-Deploy of Project

#### Create Master Instance
- [x] Create Master-Instance in AWS
      
Create Security group with ports: 80, 8080, 22, 7000

Go to AWS EC2 Instances and run Ubuntu Image with Instance type "t3.small"

Create Key-pair in AWS and copy the Private Key for SSH connection

Connect with Protocol SSH to Instance (for example use MobaXterm)

- [x] Install Jenkins, Docker, Terraform and nginx on Instance

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
