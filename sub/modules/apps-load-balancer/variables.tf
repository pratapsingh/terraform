variable "project_name" {}
variable "environment_name" {}

variable "elb_access_log_s3_bucket" {
  description = "S3 bucket for ELB's access logs"
}

variable "elb_security_groups" {
  type = "list"
}

variable "subnets" {
  type = "list"
}

variable "vpc_id" {}

variable "ssl_certificate" {
  description = "SSL certificate to use"
}

variable "route53_zone_id" {}
variable "domain_name" {}
