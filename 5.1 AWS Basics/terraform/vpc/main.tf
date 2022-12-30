terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "vpc/terraform.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  #  enable_dns_hostnames = true
  #  enable_dns_support   = true
  tags = {
    Name = "vpc-${var.project}"
  }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnet_map

  map_public_ip_on_launch = true

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = {
    Name   = "public-subnet-${var.project}"
    Subnet = "${each.key}-${each.value}"
  }
}

resource "aws_subnet" "private" {
  for_each = var.private_subnet_map

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key

  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 4, each.value)

  tags = {
    Name   = "private-subnet-${var.project}"
    Subnet = "${each.key}-${each.value}"
  }
}
