variable "environment_name" {}
variable "project_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "iam_instance_profile" {}
variable "application" {}
variable "type" {}

variable "subnets" {
  type = "list"
}

variable "user_data" {
  type = "list"
}

variable "server_count" {}

variable "security_groups" {
  type = "list"
}

variable "root_vol_size" {}
variable "root_vol_type" {}
variable "root_vol_delete_on_termination" {}
variable "log_vol_size" {}
variable "log_vol_type" {}
variable "log_vol_snapshot" {}
variable "log_vol_delete_on_termination" {}
variable "app_vol_size" {}
variable "app_vol_type" {}
variable "app_vol_snapshot" {}
variable "app_vol_delete_on_termination" {}
variable "zone_id" {}
variable "zone_name" {}

variable "eip" {
  default = "false"
}

variable "tag_BusinessUnit" {}
variable "tag_Creator" {}
variable "tag_Stack" {}
variable "tag_TechTeam" {}
