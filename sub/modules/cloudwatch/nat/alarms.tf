resource "aws_cloudwatch_metric_alarm" "ErrorPortAllocation" {
  alarm_name          = "NAT_Gateway: ${var.NAT_Gateway} port allocation failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "ErrorPortAllocation"
  namespace           = "AWS/NAT"
  datapoints_to_alarm = "1"

  dimensions {
    CacheClusterId = "${var.nat_cacheclusterid}"
  }

  period            = "60"
  statistic         = "Average"
  threshold         = "0"
  alarm_description = "Port Allocation failed for ${var.NAT_Gateway}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "PacketsDropCount" {
  alarm_name          = "NAT_Gateway: ${var.NAT_Gateway} drop in packets count"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "PacketsDropCount"
  namespace           = "AWS/NAT"
  datapoints_to_alarm = "1"

  dimensions {
    CacheClusterId = "${var.nat_cacheclusterid}"
  }

  period            = "60"
  statistic         = "Average"
  threshold         = "0"
  alarm_description = "packets drops count ${var.NAT_Gateway}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}
