variable "project_name" {}
variable "environment_name" {}

variable "route53_zone_id" {
  description = "Zone ID for the Route53 Hosted Zone"
}

variable "domain_name" {
  description = "Domain Names for webapp"
}

variable "ecs_cluster_id" {
  description = "ID of ECS cluster to deploy to."
}

variable "env_vars" {
  description = "Environment variables for this component"
}

variable "ecs_role" {
  default     = "ecsServiceRole"
  description = "Name for ECS Role"
}

variable "elb_access_log_s3_bucket" {
  description = "S3 bucket for ELB's access logs."
}

variable "subnets" {
  type = "list"
}

variable "ssl_certificate" {
  description = "SSL certificate to use"
}

variable "elb_security_groups" {
  type = "list"
}

variable "nginx_docker_image" {}
variable "env_new_relic_app_name" {}
variable "desired_count" {}

variable "webapp_memory" {
  default = "768"
}

variable "vpc_id" {}
