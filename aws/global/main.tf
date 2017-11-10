variable "env"  { }
variable "shared_credentials_file" { }
variable "profile" { }
variable "region" { }

provider "aws" {
  profile                  = "${var.profile}"
  shared_credentials_file  = "${var.shared_credentials_file}"
  region                   = "${var.region}"
}

terraform {
  backend "s3" {
    bucket  = "be-iac-state"
    key     = "global/terraform.tfstate"
    region  = "us-west-1"
    profile = "devops"
  }
}