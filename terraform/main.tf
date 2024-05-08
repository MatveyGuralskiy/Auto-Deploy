#---------------------------
#Auto-Deploy Project
#Created by Matvey Guralskiy
#---------------------------

#Work with AWS
provider "aws" {
  region = var.Region
  default_tags {
    tags = {
      Owner   = "Matvey Guralskiy"
      Created = "Terraform"
    }
  }
}

#-----------VPC-------------

# Create VPC
resource "aws_vpc" "VPC_AutoDeploy" {
  cidr_block = var.CIDR_VPC
  tags = {
    Name = "VPC AutoDeploy"
  }
}

# Create Internet Gateway and Automatically Attach
resource "aws_internet_gateway" "IG_AutoDeploy" {
  vpc_id = aws_vpc.VPC_AutoDeploy.id
  tags = {
    Name = "IG AutoDeploy"
  }
}

# Create 2 Public Subnets in different Availability Zones: A, B
resource "aws_subnet" "Subnet_A" {
  vpc_id            = aws_vpc.VPC_AutoDeploy.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "${var.Region}a"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "Subnet_B" {
  vpc_id            = aws_vpc.VPC_AutoDeploy.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.Region}b"
  # Enable Auto-assigned IPv4
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet 2"
  }
}

# Create Route Table for Subnets
resource "aws_route_table" "Public_RouteTable" {
  vpc_id = aws_vpc.VPC_AutoDeploy.id
  route {
    cidr_block = var.CIDR_VPC
    gateway_id = "local"
  }
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IG_AutoDeploy.id
  }
  tags = {
    Name = "Public RouteTable"
  }
}

# Attach Subnets to Route Table
resource "aws_route_table_association" "RouteTable_Attach_Subnet_A" {
  subnet_id      = aws_subnet.Subnet_A.id
  route_table_id = aws_route_table.Public_RouteTable.id
}

resource "aws_route_table_association" "RouteTable_Attach_Subnet_B" {
  subnet_id      = aws_subnet.Subnet_B.id
  route_table_id = aws_route_table.Public_RouteTable.id
}

#-----------EC2-------------

# Security Group for EC2 Instances
resource "aws_security_group" "SG_AutoDeploy" {
  name        = "SG AutoDeploy"
  description = "Security Group - Firewall, For Project Auto-Deploy"
  vpc_id      = aws_vpc.VPC_AutoDeploy.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Security Group Auto-Deploy"
  }
}

# Image for EC2 Instance
data "aws_ami" "Latest_Ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Create 4 EC2 Instances
resource "aws_instance" "Webserver_A" {
  count             = 2
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Instance_type
  subnet_id         = aws_subnet.Subnet_A.id
  security_groups   = [aws_security_group.SG_AutoDeploy.id]
  availability_zone = "${var.Region}a"
  # Bash script to install Docker Image
  user_data = file("../Bash/bootstrapping.sh")
  tags = {
    Name = "Webserver A ${count.index + 1}"
  }
}

resource "aws_instance" "Webserver_B" {
  count             = 2
  ami               = data.aws_ami.Latest_Ubuntu.id
  instance_type     = var.Instance_type
  subnet_id         = aws_subnet.Subnet_B.id
  security_groups   = [aws_security_group.SG_AutoDeploy.id]
  availability_zone = "${var.Region}b"
  # Bash script to install Docker Image
  user_data = file("../Bash/bootstrapping.sh")
  tags = {
    Name = "Webserver B ${count.index + 1}"
  }
}

#-----------ALB-------------

# Create Target Group for EC2 Instances
resource "aws_lb_target_group" "TG_Webserver" {
  name     = "Target-Group-Webserver"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC_AutoDeploy.id
  tags = {
    Name = "TG-Webserver"
  }
}

# Attach EC2 Instances to Target Group 
resource "aws_lb_target_group_attachment" "TG_Attach_Webserver_A" {
  count            = 2
  target_group_arn = aws_lb_target_group.TG_Webserver.arn
  target_id        = aws_instance.Webserver_A[count.index].id
}

resource "aws_lb_target_group_attachment" "TG_Attach_Webserver_B" {
  count            = 2
  target_group_arn = aws_lb_target_group.TG_Webserver.arn
  target_id        = aws_instance.Webserver_B[count.index].id
}

# Create Application LoadBalancer
resource "aws_lb" "ALB" {
  name               = "Application-Load-Balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.SG_AutoDeploy.id]

  subnet_mapping {
    subnet_id = aws_subnet.Subnet_A.id
  }

  subnet_mapping {
    subnet_id = aws_subnet.Subnet_B.id
  }

}

#Load Balancer Default port 443
resource "aws_lb_listener" "Webserver-HTTPS" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.Certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG_Webserver.arn
  }
}

# Redirect HTTP to HTTPS
resource "aws_lb_listener" "Redirect_HTTP" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# Route53 Hosted zone
data "aws_route53_zone" "Hosted_Zone" {
  name = "matveyguralskiy.com"
}

#Zone ID for Validation
output "zone_id" {
  value = data.aws_route53_zone.Hosted_Zone.zone_id
}

resource "aws_route53_record" "Website_Record" {
  zone_id = data.aws_route53_zone.Hosted_Zone.zone_id
  name    = "website.matveyguralskiy.com"
  type    = "A"
  alias {
    name                   = aws_lb.ALB.dns_name
    zone_id                = aws_lb.ALB.zone_id
    evaluate_target_health = true
  }
}

#-----------SNS-------------

# SNS Topic
resource "aws_sns_topic" "ALB_Alarm" {
  name = "ALB-ALARM"
}

# SNS Email
resource "aws_sns_topic_subscription" "Gmail_Alarm" {
  topic_arn = aws_sns_topic.ALB_Alarm.arn
  protocol  = "email"
  endpoint  = "mathewguralskiy@gmail.com"
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "CloudWatch_Alarm" {
  alarm_name          = "ALBCPUUtilizationAlarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  # For ALB
  namespace         = "AWS/ApplicationELB"
  period            = 300
  statistic         = "Average"
  threshold         = 80
  alarm_description = "Alarm if ALB CPU Utilization greater than 80%"
  alarm_actions     = [aws_sns_topic.ALB_Alarm.arn]
}

#----------------SSL-----------------
/*
# Create SSL with AWS Certificate Manager
resource "aws_acm_certificate" "Website_Certificate" {
  domain_name       = "website.matveyguralskiy.com"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "Website_Certificate_Validation" {
  certificate_arn         = aws_acm_certificate.Website_Certificate.arn
  validation_record_fqdns = [for option in aws_acm_certificate.Website_Certificate.domain_validation_options : option.resource_record_name]
}

resource "aws_route53_record" "certificate_validation" {
  zone_id = data.aws_route53_zone.Hosted_Zone.zone_id
  ttl     = 60
  name    = tolist(aws_acm_certificate_validation.Website_Certificate_Validation.validation_record_fqdns)[0].resource_record_name
  records = [tolist(aws_acm_certificate_validation.Website_Certificate_Validation.validation_record_fqdns)[0].resource_record_value]
  type    = "CNAME"
}

*/
