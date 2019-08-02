variable "tg_name" {
  description = "Name of the Target Group"
}

variable "alb_name" {
  description = "Name of the ALB"
}

variable "alarm_actions" {
  type    = "list"
  default = ["arn:aws:sns:us-east-1:128959313907:production-alerts"]
}

variable "threshold_latency" {
  description = "Latency Threshold (in seconds)"
}

variable "threshold_request_count" {
  description = "Threshold number of requests"
}
