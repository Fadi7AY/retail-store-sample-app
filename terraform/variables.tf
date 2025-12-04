# terraform/variables.tf
variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "key_name" {
  type        = string
  description = "Name of existing EC2 key pair to use for SSH"
  default     = "retail-store-cluster"
}

variable "instance_type" {
  type    = string
  default = "t2.medium"
}
