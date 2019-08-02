resource "aws_cloudwatch_metric_alarm" "cpuUtilization" {
  alarm_name          = "${var.environment_name}-${var.name}-instance-cpuUtilization"
  alarm_description   = "EC2 CPU utilization alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  actions_enabled = true
  alarm_actions   = "${var.alarm_actions}"
}
