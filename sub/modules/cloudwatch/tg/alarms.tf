locals {
  tg_readable_name = "${element(split("/",var.tg_name), 1)}"
}

resource "aws_cloudwatch_metric_alarm" "TargetConnectionErrorCount" {
  alarm_name          = "TG: ${local.tg_readable_name} connection error count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TargetConnectionErrorCount"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
    TargetGroup  = "${var.tg_name}"
  }

  period             = "60"
  statistic          = "Sum"
  threshold          = "5"
  treat_missing_data = "notBreaching"
  alarm_description  = "Target connection error count at target group ${local.tg_readable_name}"
  alarm_actions      = "${var.alarm_actions}"
  ok_actions         = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "TargetResponseTime" {
  alarm_name          = "TG: ${local.tg_readable_name} response time"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
    TargetGroup  = "${var.tg_name}"
  }

  period             = "300"
  statistic          = "Average"
  threshold          = "${var.threshold_latency}"
  treat_missing_data = "notBreaching"
  alarm_description  = "Target response time at the target group ${local.tg_readable_name}"
  alarm_actions      = "${var.alarm_actions}"
  ok_actions         = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "RequestCount" {
  alarm_name          = "TG: ${local.tg_readable_name} request count"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
    TargetGroup  = "${var.tg_name}"
  }

  period            = "60"
  statistic         = "Sum"
  threshold         = "${var.threshold_request_count}"
  alarm_description = "No. of current items in the target group ${local.tg_readable_name}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "HealthyHostCount" {
  alarm_name          = "TG: ${local.tg_readable_name} no healthy hosts"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthyHostCount"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
    TargetGroup  = "${var.tg_name}"
  }

  period            = "60"
  statistic         = "Minimum"
  threshold         = "0"
  alarm_description = "No Healthy hosts for ${local.tg_readable_name}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_Target_5XX_Count" {
  alarm_name          = "TG: 5xx count (by app) for ${local.tg_readable_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
    TargetGroup  = "${var.tg_name}"
  }

  period             = "60"
  statistic          = "Sum"
  threshold          = "10"
  treat_missing_data = "notBreaching"
  alarm_description  = "TG: 5xx count (by app) for ${local.tg_readable_name}"
  alarm_actions      = "${var.alarm_actions}"
  ok_actions         = "${var.alarm_actions}"
}
