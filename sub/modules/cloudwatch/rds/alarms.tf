resource "aws_cloudwatch_metric_alarm" "CPUUtilization" {
  alarm_name          = "RDS: ${var.rds_short_name} %CPU util"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "60"
  statistic         = "Average"
  threshold         = "${var.threshold_cpu_utilization}"
  alarm_description = "%CPU utilization of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "DatabaseConnections" {
  alarm_name          = "RDS: ${var.rds_short_name} high db connections"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "${var.threshold_database_connections}"
  alarm_description = "No. of database connections of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "DiskQueueDepth" {
  alarm_name          = "RDS: ${var.rds_short_name} high disk qdepth"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "60"
  statistic         = "Average"
  threshold         = "${var.threshold_disk_queue_depth}"
  alarm_description = "Disk queue depth of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "FreeStorageSpace" {
  alarm_name          = "RDS: ${var.rds_short_name} low free storage space"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "900"
  statistic         = "Average"
  threshold         = "${var.threshold_free_storage_space}"
  alarm_description = "Free storage space of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "FreeableMemory" {
  alarm_name          = "RDS: ${var.rds_short_name} low freeable memory"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "900"
  statistic         = "Average"
  threshold         = "${var.threshold_freeable_memory}"
  alarm_description = "Freeable memory of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "ReadLatency" {
  alarm_name          = "RDS: ${var.rds_short_name} high read latency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "${var.threshold_read_latency}"
  alarm_description = "Read latency of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "WriteLatency" {
  alarm_name          = "RDS: ${var.rds_short_name} high write latency"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "${var.threshold_write_latency}"
  alarm_description = "Write latency of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "ReplicaLag" {
  count               = "${var.is_read_replica}"
  alarm_name          = "RDS: ${var.rds_short_name} high replica lag"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "ReplicaLag"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "${var.threshold_replica_lag}"
  alarm_description = "Replica lag of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "TransactionLogsDiskUsage" {
  alarm_name          = "RDS: ${var.rds_short_name} high transaction logs disk usage"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "TransactionLogsDiskUsage"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "${var.threshold_transaction_log_disk_usage}"
  alarm_description = "Transaction Logs Disk Usage of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}

resource "aws_cloudwatch_metric_alarm" "OldestReplicationSlotLag" {
  alarm_name          = "RDS: ${var.rds_short_name} oldest replication slot lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "OldestReplicationSlotLag"
  namespace           = "AWS/RDS"

  dimensions {
    DBInstanceIdentifier = "${var.rds_instance}"
  }

  period            = "300"
  statistic         = "Average"
  threshold         = "${var.threshold_oldest_replication_slot}"
  alarm_description = "Oldest Replication Slot Lag of the RDS instance ${var.rds_instance}"
  alarm_actions     = "${var.alarm_actions}"
  ok_actions        = "${var.alarm_actions}"
}
