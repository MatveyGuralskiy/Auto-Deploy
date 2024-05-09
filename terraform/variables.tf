variable "Region" {
  type        = string
  description = "AWS Region to work"
  default     = "eu-west-3"
}

variable "Instance_type" {
  type        = string
  description = "EC2 Instance type"
  default     = "t2.micro"
}

variable "CIDR_VPC" {
  type        = string
  description = "My CIDR Block of AWS VPC"
  default     = "10.0.0.0/16"
}

variable "Certificate" {
  type        = string
  description = "Your HTTPS Certificate Amazon ARN"
  default     = "arn:aws:acm:eu-west-3:381491938951:certificate/a64d56aa-56ab-49b4-b8fa-92feb145348c"
}
