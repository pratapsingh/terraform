variable "rds_instance" {
  description = "Full name of the RDS DB instance"
}

variable "rds_short_name" {
  description = "Short name of the RDS DB instance"
}

variable "threshold_cpu_utilization" {
  default = "70"
}

variable "threshold_database_connections" {}

variable "threshold_disk_queue_depth" {
  default = "20"
}

variable "threshold_free_storage_space" {}
variable "threshold_freeable_memory" {}

variable "threshold_read_latency" {
  default = "0.02"
}

variable "threshold_write_latency" {
  default = "0.3"
}

variable "threshold_transaction_log_disk_usage" {
  description = "Threshold in bytes"
  default     = "1500000000"
}

variable "threshold_oldest_replication_slot" {
  default = "15000"
}

variable "threshold_replica_lag" {
  description = "Replica lag on read replica"
  default     = "20"
}

variable "is_read_replica" {
  description = "Set to 1 if RDS instance is a read replica"
  default     = 0
}

variable "alarm_actions" {
  type    = "list"
  default = ["arn:aws:sns:us-east-1:128959313907:production-alerts"]
}
