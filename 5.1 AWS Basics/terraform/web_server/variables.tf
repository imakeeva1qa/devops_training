variable "region" {
  default = "eu-central-1"
}

variable "service_name" {
  default = "ec2"
}

variable "project" {
  default = "aws-basic"
}

variable bucket_list                         {
  type = list(string)
  default = ["deletemebucket-9919238777512"]
}
