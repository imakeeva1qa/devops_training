terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "app_server/terraform.tfstate"
    region = "eu-west-1"
  }
}


resource "aws_key_pair" "ssh-key-app" {
  key_name   = "ssh-key-app"
  public_key = file("~/.ssh/ssh-key-web.pub")
}


resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "ssh-key-app"
  vpc_security_group_ids = [aws_security_group.app_server-sg.id]
  user_data              = file("../provision/provision_app_server.sh")
  iam_instance_profile   = aws_iam_instance_profile.profile.name

#  connection {
#    type = "ssh"
#    user = "ubuntu"
#    host = self.public_ip
#    private_key = file("~/.ssh/my_ssh_key")
#    timeout     = "1m"
#  }
#
#  provisioner "file" {
#    source      = "../provision/"
#    destination = "/tmp"
#  }

  tags = {
    Name = "app_server"
  }
}


resource "aws_security_group" "app_server-sg" {
  name = "app_server-sg"

  dynamic "ingress" {
    for_each = ["22"]
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
    Name = "app_server sg"
  }
}
