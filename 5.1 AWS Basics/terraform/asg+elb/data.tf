data "terraform_remote_state" "ec2" {
  backend = "s3"

  config = {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "ec2/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

data "aws_vpcs" "vpc" {
  tags = {
    Project = "aws-basic"
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.vpc.ids[0]]
  }

  tags = {
    Name = "private-subnet-${var.project}"
    Project = var.project
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.vpc.ids[0]]
  }

  tags = {
    Name = "public-subnet-${var.project}"
    Project = var.project
  }
}

