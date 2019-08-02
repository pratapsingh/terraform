variable "region" {}

variable "project_name" {
  description = "Name of the project"
}

variable "environment_name" {
  description = "Environment name"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC. Use private addresses only"
}

variable "availability_zones" {
  description = "Comma separated list of vailability zones where subnets and instances are present"
  type        = "list"
  default     = ["us-wast-1a", "us-east-1b"]
}

variable "default_destination_cidr" {
  description = "Default destination CIDR"
  default     = "0.0.0.0/0"
}

variable "elb_access_log_s3_bucket" {
  description = "S3 bucket to store ELB access logs."
  default     = "windli-logs"
}

# Papertrail
variable "papertrail_host" {
  description = "Host for Papertrail's log destination"
}

variable "papertrail_port" {
  description = "Port for Papertrail's log destination"
}

variable "default_ssl_certificate" {
  default     = "arn:aws:acm:us-east-1:128959313907:certificate/1afbeceb-1222-40e3-98ba-ca61c5d0decc"
  description = "SSL certificate to use"
}

variable "route53_zone_id" {
  default     = "Z23ZENPJNQYYT2"
  description = "Route53 Zone ID for the hosted zone"
}

variable "docker_repo" {
  default     = "128959313907.dkr.ecr.us-east-1.amazonaws.com"
  description = "Our private docker registry"
}

# oauth2-proxy
variable "oauth2_proxy_artifact" {}

variable "sns_arn" {
  default = "arn:aws:sns:us-east-1:128959313907:production-alerts"
}

variable "alarm_actions" {
  type    = "list"
  default = ["arn:aws:sns:us-east-1:128959313907:production-alerts"]
}

variable "tag_BusinessUnit" {
  default = "marketing"
}

variable "tag_Creator" {
  default = "devops-tf"
}

variable "tag_Stack" {
  default = "devops"
}

variable "tag_TechTeam" {
  default = "ui"
}

variable "static_public_gateway_ip_address" {
  default = "4.4.4.4"
}

variable "cgw_name" {
  default = "windli-tunnel"
}

variable "default_static_vpn_route_cidr" {
  default = "10.100.0.0/24"
}

variable "pub_subnet_count" {
  default = "2"
}

variable "priv_subnet_count" {
  default = "2"
}

variable "prot_subnet_count" {
  default = "4"
}

variable "azs" {
  type = "map"

  default = {
    eu-west-1      = "a,b,c"
    ap-southeast-1 = "a,b"
    ap-southeast-2 = "a,b"
    eu-central-1   = "a,b"
    ap-northeast-1 = "a,b,c"
    us-east-1      = "a,b,c,d,e"
    sa-east-1      = "a,b,c"
    us-west-1      = "b,c"
    us-west-2      = "a,b,c"
    us-east-2      = "a,b"
    ca-central-1   = "a,b"
    eu-west-2      = "a,b"
    ap-northeast-2 = "a,b"
    ap-south-1     = "a,b"
  }
}

variable "newbits" {
  default = "4"
}

variable "key_pair_name" {
  default = "devops"
}

variable "ssh_internal_range" {
  default = "10.0.0.0/16"
}

variable "domain_name" {
  default = "windli.com"
}

variable "vol_snapshot" {}

variable "nginx_webapp_artifact" {}

variable "ecs_cluster_name" {}

variable "igw_default_destination_cidr" {}
