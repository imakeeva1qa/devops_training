terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "web_server_aws/terraform.tfstate"
    region = "eu-west-1"
  }
}


resource "aws_key_pair" "ssh-key-web" {
  key_name   = "ssh-key-web-aws"
  public_key = file("~/.ssh/ssh-key-web.pub")
}


resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "ssh-key-web-aws"
  vpc_security_group_ids = [aws_security_group.web_server-sg.id]
  user_data              = file("../scripts/provision_web_server.sh")

  tags = {
    Name = "web_server"
  }
}


resource "aws_security_group" "web_server-sg" {
  name = "web_server-sg"

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
    Name = "web_server sg"
  }
}
