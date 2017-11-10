module "vpc-peering-mgmt-prod" {
  source          = "../../../modules/network/vpc-peering"
  env             = "${var.env}"
  team            = "Production"
  source_vpc_id   = "${module.vpc.vpc-id}"
  source_vpc_name = "mgmt"
  dest_vpc_id     = "${data.terraform_remote_state.prod-network.vpc-id}"
  dest_vpc_name   = "prod"
}

module "vpc-peering-mgmt-stage" {
  source          = "../../../modules/network/vpc-peering"
  env             = "${var.env}"
  team            = "Production"
  source_vpc_id   = "${module.vpc.vpc-id}"
  source_vpc_name = "mgmt"
  dest_vpc_id     = "${data.terraform_remote_state.stage-network.vpc-id}"
  dest_vpc_name   = "stage"
}

module "vpc-peering-prod-stage" {
  source          = "../../../modules/network/vpc-peering"
  env             = "${var.env}"
  team            = "Production"
  source_vpc_id   = "${data.terraform_remote_state.prod-network.vpc-id}"
  source_vpc_name = "prod"
  dest_vpc_id     = "${data.terraform_remote_state.stage-network.vpc-id}"
  dest_vpc_name   = "stage"
}
