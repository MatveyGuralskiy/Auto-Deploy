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
