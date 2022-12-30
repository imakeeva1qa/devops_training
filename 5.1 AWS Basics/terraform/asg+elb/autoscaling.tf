resource "aws_autoscaling_policy" "cpu-up-policy" {
  name                   = format("cpu-up-policy-%s", var.project)
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-up-alarm" {
  alarm_name          = format("cpu-alarm-%s", var.project)
  alarm_description   = format("cpu-down-alarm-%s", var.project)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu-up-policy.arn]
}


# scale down alarm
resource "aws_autoscaling_policy" "cpu-down-policy" {
  name                   = format("cpu-down-policy-%s", var.project)
  autoscaling_group_name = aws_autoscaling_group.web.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "30"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-down-alarm" {
  alarm_name          = format("cpu-down-alarm-%s", var.project)
  alarm_description   = format("cpu-down-alarm-%s", var.project)
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "15"
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.web.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu-down-policy.arn]
}
