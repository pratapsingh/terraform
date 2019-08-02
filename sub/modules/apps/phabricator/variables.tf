variable "project_name" {}
variable "environment_name" {}

variable "route53_zone_id" {
  description = "Zone ID for Route53 Hosted Zone"
}

variable "domain_name" {
  description = "Domain name for the service"
}

variable "ecs_cluster_id" {
  description = "ID of ECS cluster to deploy to"
}

variable "ecs_role" {
  default     = "ecsServiceRole"
  description = "Name of ECS service IAM Role"
}

variable "desired_count" {
  default     = "1"
  description = "Number of docker instances of this service to run"
}

variable "vpc_id" {}

variable "alb_dns_name" {}
variable "alb_zone_id" {}
variable "alb_listener_arn" {}

variable "oauth2_proxy_docker_image" {}
variable "oauth2_proxy_env_vars" {}
