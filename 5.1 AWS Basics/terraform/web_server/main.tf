terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "ec2/terraform.tfstate"
    region = "eu-west-1"
  }
}

# EC2 (2 servers for each public subnet)
resource "aws_instance" "server" {
  for_each               = toset(data.aws_subnets.public_subnets.ids)
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.ssh-key.key_name
  subnet_id              = each.value
  security_groups        = [data.aws_security_groups.web-sg.ids[0]]
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
  #    source      = "../provision/"
  #    destination = "/tmp"
  #  }

  tags = {
    Name = "server-${var.project}-${each.value}"
  }
}
