variable "project_name" {
  default = "windli"
}

variable "region" {
  default = "us-east-1"
}

variable "project_environment" {
  default = "prod"
}

variable "state_bucket_name" {
  default = "windli-state"
}

variable "tag_BusinessUnit" {
  default = "marketing"
}

variable "tag_Creator" {
  default = "devops-tf"
}

variable "tag_Stack" {
  default = "web"
}

variable "tag_TechTeam" {
  default = "ui"
}

variable "role_name" {
  default = "default_s3"
}

variable "domainname" {
  default = "windli.com"
}
