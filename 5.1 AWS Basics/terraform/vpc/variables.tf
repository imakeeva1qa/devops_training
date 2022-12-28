variable "region" {
  default = "eu-central-1"
}

variable "service_name" {
  default = "vpc"
}

variable "project" {
  default = "aws-basic"
}

variable "public_subnet_map" {
  type = map(number)
  default = {
    "eu-central-1a" = 1
    "eu-central-1b" = 2
  }
}

variable "private_subnet_map" {
  type = map(number)
  default = {
    "eu-central-1a" = 3
  }
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
}
