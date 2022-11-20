provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}


resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = file("C:/Users/User/.ssh/id_rsa.pub")
}

data "aws_ami" "ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}


resource "aws_instance" "nginx" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "ssh-key"
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  user_data              = file("scripts/provision.sh")

  tags = {
    Name = "nginx"
  }
}


resource "aws_security_group" "nginx-sg" {
  name = "nginx-sg"

  dynamic "ingress" {
    for_each = ["80", "8080", "22"]
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
    Name = "Nginx SG"
  }
}
