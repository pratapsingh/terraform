data "terraform_remote_state" "global" {
  backend = "s3"

  config {
    bucket  = "windli-state"
    key     = "global/terraform.tfstate"
    region  = "us-east-1"
    profile = "default"
  }
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "windli-state"
    region  = "us-east-1"
    key     = "global/terraform.tfstate"
  }
}
