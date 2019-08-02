variable "project_name" {}
variable "environment_name" {}

variable "subnets" {
  type = "list"
}

variable "ecs_cluster_name" {}

variable "instance_type" {
  description = "Name of the AWS instance type"
}

variable "iam_instance_profile" {
  default     = "ecsInstanceRole"
  description = "The IAM Instance Profile (e.g. right side of Name = AmazonECSContainerInstanceRole)"
}

variable "instance_root_volume_size" {
  default     = "16"
  description = "Instance root block volume size in GB"
}

# Autoscaling group:
variable "min_size" {
  description = "Minimum number of instances to run in the group"
}

variable "max_size" {
  description = "Maximum number of instances to run in the group"
}

variable "desired_capacity" {
  description = "Desired number of instances to run in the group"
}

variable "health_check_grace_period" {
  default     = "300"
  description = "Time after instance comes into service before checking health"
}

# ECS:
variable "security_groups" {
  type = "list"
}

# ECS agent
variable "ecs_agent_docker_tag" {
  default     = "latest"
  description = "Docker tag to use for ECS Agent"
}

# Logspout
variable "logspout_docker_tag" {
  default     = "latest"
  description = "Docker tag to use for Logspout instance"
}

# Papertrail
variable "papertrail_host" {
  description = "Host for Papertrail's log destination"
}

variable "papertrail_port" {
  description = "Port for Papertrail's log destination"
}

variable "name_suffix" {
  default = ""
}

variable "sns_arn" {}
