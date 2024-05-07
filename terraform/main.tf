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
data "aws_ami" "Latest_Amazon" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Create 4 EC2 Instances
resource "aws_instance" "Webserver-A" {
  count             = 2
  ami               = data.aws_ami.Latest_Amazon.id
  instance_type     = var.Instance_type
  subnet_id         = aws_subnet.Subnet_A.id
  security_groups   = [aws_security_group.SG_AutoDeploy.id]
  availability_zone = "${var.Region}a"
  tags = {
    Name = "Webserver A ${count.index + 1}"
  }
}

resource "aws_instance" "Webserver-B" {
  count             = 2
  ami               = data.aws_ami.Latest_Amazon.id
  instance_type     = var.Instance_type
  subnet_id         = aws_subnet.Subnet_B.id
  security_groups   = [aws_security_group.SG_AutoDeploy.id]
  availability_zone = "${var.Region}b"
  tags = {
    Name = "Webserver B ${count.index + 1}"
  }
}

#-----------ALB-------------

# Create Target Group for Availability zone A
resource "aws_lb_target_group" "TargetGroup_A" {
  name     = "TargetGroup_A"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC_AutoDeploy.id
}

# Attach Target Group A
resource "aws_lb_target_group_attachment" "TargetGroup_A_Attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.TargetGroup_A.arn
  target_id        = aws_instance.Webserver-A[0-1].id
}

# Create Target Group for Availability zone B
resource "aws_lb_target_group" "TargetGroup_B" {
  name     = "TargetGroup_B"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.VPC_AutoDeploy.id
}

# Attach Target Group B
resource "aws_lb_target_group_attachment" "TargetGroup_B_Attach" {
  count            = 2
  target_group_arn = aws_lb_target_group.TargetGroup_B.arn
  target_id        = aws_instance.WebserverB[0-1].id
}

# Create Application LoadBalancer
resource "aws_lb" "ALB" {
  name               = "Application Load Balancer"
  load_balancer_type = "application"
  subnets            = [ aws_subnet.Subnet_A, aws_subnet.Subnet_B]
  security_groups    = [aws_security_group..id]
  availability_zones = "${var.Region}a"  ,"${var.Region}b"
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate..arn
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
resource "aws_cloudwatch_metric_alarm" "alb_cpu_utilization_alarm" {
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

#-----------SLS-------------

resource "aws_acm_certificate" "Application_SSL" {
  domain_name       = "website.matveyguralskiy.com"
  validation_method = "DNS"
  tags = {
    Name = "Application SSL Certificate"
  }
}


data "aws_acm_certificate_validation" "Application_SSL_Validation" {
  certificate_arn = aws_acm_certificate.Application_SSL.arn
}

output "Application_SSL_DNS_Validation" {
  value = data.aws_acm_certificate_validation.Application_SSL_Validation.resource_record_name
}

data "aws_route53_zone" "Application_Zone" {
  
  
}

resource "aws_route53_record" "example_validation" {
  zone_id = "YOUR_ZONE_ID"
  name    = data.aws_acm_certificate_validation.example.resource_record_name
  type    = data.aws_acm_certificate_validation.example.resource_record_type
  ttl     = "300"
  records = [data.aws_acm_certificate_validation.example.resource_record_value]
}



resource "aws_route53_record" "website_cert_validation" {
  zone_id = "YOUR_ZONE_ID"
  name    = data.aws_acm_certificate_validation.website_cert_validation.resource_record_name
  type    = data.aws_acm_certificate_validation.website_cert_validation.resource_record_type
  ttl     = "300"
  records = [data.aws_acm_certificate_validation.website_cert_validation.resource_record_value]
}

resource "aws_route53_record" "website_alias" {
  zone_id = "YOUR_ZONE_ID"
  name    = "website.matveyguralskiy.com"
  type    = "A"

  alias {
    name                   = aws_lb.website_lb.dns_name
    zone_id                = aws_lb.website_lb.zone_id
    evaluate_target_health = true
  }
}

*/
