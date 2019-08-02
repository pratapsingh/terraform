variable "project_name" {}

variable "environment_name" {}

variable "availability_zones" {
  description = "Availability zones"
  type        = "list"
#  default     = ["ap-south-1a", "ap-south-1b"]
}

variable "default_destination_cidr" {
  description = "Default destination CIDR For all internal traffic within VPC"
#  default     = "10.0.100.0/24"
}

variable "igw_default_destination_cidr" {
  description = "Default destination CIDR"
#  default     = "0.0.0.0/0"
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
}

variable "tag_BusinessUnit" {}

variable "tag_Creator" {}

variable "tag_Stack" {}

variable "tag_TechTeam" {}

variable "pub_subnet_count" {}

variable "priv_subnet_count" {}

variable "prot_subnet_count" {}

variable "pub-subnet-ids" {}

variable "azs" {}

variable "nat_gateway_ids" {}

variable "newbits" {}

variable "key_pair_name" {}

variable "public_key" {}
variable "ssh_internal_range" {}
variable "vpn_gateway_id" {}
variable "default_static_vpn_route_cidr" {}

variable "region" {}
