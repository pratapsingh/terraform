resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
  alarm_name          = "ECS: ${var.cluster_name} %CPU util"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "60"
  alarm_description = "%CPU utilization of the ECS cluster ${var.cluster_name}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "CPUReservation" {
  alarm_name          = "ECS: ${var.cluster_name} high CPU reservation"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "80"
  alarm_description = "CPU reservation of the ECS cluster ${var.cluster_name}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "MemoryReservation" {
  alarm_name          = "ECS: ${var.cluster_name} high MEM reservation"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "MemoryReservation"
  namespace           = "AWS/ECS"

  dimensions {
    ClusterName = "${var.cluster_name}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "80"
  alarm_description = "MEM reservation of the ECS cluster ${var.cluster_name}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}
