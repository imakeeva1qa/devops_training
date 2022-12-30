resource "aws_launch_configuration" "web" {
  name_prefix                 = "web-"
  image_id                    = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.ssh-key.key_name
  security_groups             = [data.terraform_remote_state.vpc.outputs.aws_security_group]
  associate_public_ip_address = true
  user_data                   = file("../scripts/provision.sh")

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "web" {
  name             = "${aws_launch_configuration.web.name}-asg"
  min_size         = 1
  desired_capacity = 2
  max_size         = 4

  health_check_type = "ELB"
#  load_balancers = [
#    aws_lb.elb.id
#  ]
  launch_configuration = aws_launch_configuration.web.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  vpc_zone_identifier = data.terraform_remote_state.vpc.outputs.public_subnets

  lifecycle {
    create_before_destroy = true
    ignore_changes = [load_balancers, target_group_arns]
  }

  tag {
    key                 = "Name"
    value               = "web-asg"
    propagate_at_launch = true
  }
}
