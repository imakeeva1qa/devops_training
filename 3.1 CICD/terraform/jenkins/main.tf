terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "jenkins/terraform.tfstate"
    region = "eu-west-1"
  }
}


resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = file("~/.ssh/my_ssh_key.pub")
}


resource "aws_instance" "jenkins" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = "ssh-key"
  vpc_security_group_ids = [aws_security_group.jenkins-sg.id]
  user_data              = file("../scripts/provision.sh")
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
#    source      = "../scripts/"
#    destination = "/tmp"
#  }

  tags = {
    Name = "jenkins"
  }
}


resource "aws_security_group" "jenkins-sg" {
  name = "jenkins-sg"

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
    Name = "jenkins sg"
  }
}
