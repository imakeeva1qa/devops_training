output "ubuntu-ami-id" {
  value = data.aws_ami.ubuntu.id
}


output "aws_instance" {
  value = aws_instance.gitlab.public_ip
}
