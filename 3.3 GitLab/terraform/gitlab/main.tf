terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "gitlab/terraform.tfstate"
    region = "eu-west-1"
  }
}


resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key-gitlab"
  public_key = file("~/.ssh/my_ssh_key.pub")
}


resource "aws_instance" "gitlab" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.xlarge"
  key_name               = "ssh-key"
  vpc_security_group_ids = [aws_security_group.gitlab-sg.id]
  user_data              = file("../provision/provision.sh")
  iam_instance_profile   = aws_iam_instance_profile.profile.name

  root_block_device {
    volume_size = 16
  }

    connection {
    type = "ssh"
    user = "ubuntu"
    host = self.public_ip
    private_key = file("~/.ssh/my_ssh_key")
    timeout     = "1m"
  }

  provisioner "file" {
    source      = "../provision/"
    destination = "/tmp"
  }

  tags = {
    Name = "gitlab"
  }
}


resource "aws_security_group" "gitlab-sg" {
  name = "gitlab-sg"

  dynamic "ingress" {
    for_each = ["80", "443", "22", "2224", "8081"]
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
    Name = "gitlab sg"
  }
}
