# Main file for network setup
# <Variables> #
# <Global> #
variable "env"  { }
variable "shared_credentials_file" { }
variable "profile" { }
variable "region" { }
variable "ami" { }
variable "key_name" { }
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
# </Global> #
# <VPC> #
variable "vpc_name" { default = "production" }
variable "vpc_cidr" {
  type = "map"
  default = {
    prod = "10.51.0.0/16"
    stage = "10.11.0.0/16"
    dev = "10.9.0.0/16"
    mgmt = "10.0.0.0/16"
  }
}
variable "vpc_cidr_number" {
  type = "map"
  default = {
    prod = "51"
    stage = "11"
    dev = "9"
    mgmt = "0"
  }
}
variable "fqdn" {
  default = ""
  description = "Will make <hostname>.<fqdn> resolvable to private ip"
}
# </VPC> #
# <Subnets> #
variable "type" { default = "" }
variable "private_subnets_cidr" {
  type = "map"
  default = {
    middleware = "2"
    web = "3"
    api = "4"
    data = "5"
    devops = ""
  }
}
variable "public_subnets_cidr" {
  type = "map"
  default = {
    public = "1"
  }
}
variable "subnet_count" {
  type = "map"
  default = {
    prod = 4
    stage = 2
    dev = 2
    mgmt = 2
  }
}
# </Subnets> #
# </Variables>#
provider "aws" {
  profile                  = "${var.profile}"
  shared_credentials_file  = "${var.shared_credentials_file}"
  region                   = "${var.region}"
}

terraform {
  backend "s3" {
    bucket  = "be-iac-state"
    key     = "us-west-1/mgmt/compute/terraform.tfstate"
    region  = "us-west-1"
    profile = "devops"
  }
}

data "terraform_remote_state" "mgmt-network" {
  backend = "s3"
  config {
    bucket  = "be-iac-state"
    key     = "us-west-1/${var.env}/network/terraform.tfstate"
    region  = "us-west-1"
    profile = "devops"
  }
}
