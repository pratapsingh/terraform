# Basic environment configuration
project_name             = "windli"
environment_name         = "prod"
vpc_cidr                 = "172.16.0.0/24"
default_destination_cidr = "0.0.0.0/0"
availability_zones       = ["us-east-1a", "us-east-1b", "us-east-1c"]
elb_access_log_s3_bucket = "windli-logs"
papertrail_host          = "logs.papertrailapp.com"
papertrail_port          = "27849"
region = "us-east-1"
ecs_cluster_name         = "windli"
igw_default_destination_cidr = "0.0.0.0/0"
vol_snapshot            = ""
# Flower specific settings
redis_url         = ""

# Deployment artifacts
nginx_webapp_artifact           = "nginx-proxy:2.3"
nginx_admin_artifact            = "nginx-proxy:2.3"
oauth2_proxy_artifact           = "oauth2-proxy:v1"
rdstail_artifact                = "windli/rdstail:2019.04"

# Service specific env vars
