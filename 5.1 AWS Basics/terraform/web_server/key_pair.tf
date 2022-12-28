resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key-${var.project}"
  public_key = file("~/.ssh/my_ssh_key.pub")
}
