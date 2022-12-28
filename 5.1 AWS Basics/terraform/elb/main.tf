terraform {
  backend "s3" {
    bucket = "rmshtc-tfstate-bucket-8837182"
    key    = "elb/terraform.tfstate"
    region = "eu-west-1"
  }
}

resource "aws_lb" "elb" {
  name               = "elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb-sg.id]
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnets
  tags = {
    Name = "elb-${var.project}"
  }
}

resource "aws_lb_target_group" "target-group" {
  name     = "target-grp"
  port     = 80
  protocol = "HTTP"
  vpc_id   = local.vpc_id
  health_check {
    path = "/"
    port = "80"
    protocol = "HTTP"
    healthy_threshold = 2
    unhealthy_threshold = 2
    interval = 5
    timeout = 4
    matcher = "200-308"
  }
}

resource "aws_lb_target_group_attachment" "target" {
  for_each = toset(data.terraform_remote_state.ec2.outputs.server_ids)
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = each.value
  port             = 80
}

resource "aws_lb_listener" "elb_listener" {
  load_balancer_arn = aws_lb.elb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}
