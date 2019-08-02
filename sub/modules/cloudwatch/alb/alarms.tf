locals {
  alb_readable_name = "${element(split("/",var.alb_name), 1)}"
}

resource "aws_cloudwatch_metric_alarm" "RejectedConnectionCount" {
  alarm_name          = "ALB: Rejected connections for ${local.alb_readable_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "RejectedConnectionCount"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
  }

  period             = "60"
  statistic          = "Sum"
  threshold          = "10"
  treat_missing_data = "notBreaching"
  alarm_description  = "Rejected connections for ${local.alb_readable_name}"
  alarm_actions      = "${var.alarm_actions}"
  ok_actions         = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "ClientTLSNegotiationErrorCount" {
  alarm_name          = "ALB: TLS connection errors for ${local.alb_readable_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ClientTLSNegotiationErrorCount"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
  }

  period             = "60"
  statistic          = "Sum"
  threshold          = "30"
  treat_missing_data = "notBreaching"
  alarm_description  = "ALB: TLS connection errors for ${local.alb_readable_name}"
  alarm_actions      = "${var.alarm_actions}"
  ok_actions         = "${var.alarm_actions}"
}

//resource "aws_cloudwatch_metric_alarm" "HTTPCode_ELB_4XX_Count" {
//  alarm_name          = "ALB: 4xx count for ${local.alb_readable_name}"
//  comparison_operator = "GreaterThanOrEqualToThreshold"
//  evaluation_periods  = "2"
//  metric_name         = "HTTPCode_ELB_4XX_Count"
//  namespace           = "AWS/ApplicationELB"
//
//  dimensions {
//    LoadBalancer = "${var.alb_name}"
//  }
//
//  period             = "60"
//  statistic          = "Sum"
//  threshold          = "30"
//  treat_missing_data = "notBreaching"
//  alarm_description  = "ALB: 4xx count for ${local.alb_readable_name}"
//  alarm_actions      = "${var.alarm_actions}"
//  ok_actions         = "${var.alarm_actions}"
//}

resource "aws_cloudwatch_metric_alarm" "HTTPCode_ELB_5XX_Count" {
  alarm_name          = "ALB: 5xx count for ${local.alb_readable_name}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"

  dimensions {
    LoadBalancer = "${var.alb_name}"
  }

  period             = "60"
  statistic          = "Sum"
  threshold          = "20"
  treat_missing_data = "notBreaching"
  alarm_description  = "ALB: 5xx count for ${local.alb_readable_name}"
  alarm_actions      = "${var.alarm_actions}"
  ok_actions         = "${var.alarm_actions}"
}
