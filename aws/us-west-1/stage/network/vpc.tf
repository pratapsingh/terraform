module "vpc" {
  source = "../../../modules/network/vpc"
  region     = "${var.region}"
  env        = "${var.env}"
  team       = "Production"
  vpc_name   = "${var.vpc_name}-${var.env}"
  vpc_cidr   = "${lookup(var.vpc_cidr, var.env)}"
  fqdn       = "${var.fqdn}"
}

output "vpc-id"   { value = "${module.vpc.vpc-id}" }
output "vpc-cidr" { value = "${module.vpc.vpc-cidr}" }
output "vpc-name" {value = "${module.vpc.vpc-name}"}
output "vpc-default-route-table-id"   { value = "${module.vpc.vpc-default-route-table-id}" }
output "vpc-default-security-group-id"   { value = "${module.vpc.vpc-default-security-group-id}" }

module "flow-log" {
  source = "../../../modules/network/vpc-flow-log"
  vpc_id            = "${module.vpc.vpc-id}"
  vpc_name          = "${module.vpc.vpc-name}"
  iam_role_arn      = "${data.terraform_remote_state.global.flow-log-role-iam-role-arn}"
}

output "flow-log-id"   { value = "${module.flow-log.flow-log-id}" }

#Hosted Zone Association will only work if hosted zone is already created with mgmt vpc
module "private-hosted-zone-association" {
  source        = "../../../modules/util/route53/private-hosted-zone-association"
  zone_id       = "${data.terraform_remote_state.mgmt-network.hosted-zone-id}"
  vpc_id        = "${module.vpc.vpc-id}"
}

module "nat-gateway" {
  source = "../../../modules/network/nat-gateway"
  env               = "${var.env}"
  team              = "Production"
  vpc_id            = "${module.vpc.vpc-id}"
  name              = "${module.vpc.vpc-name}"
  azs               = "${lookup(var.azs, var.region)}"
  public_subnet_ids = "${module.public-subnet.subnet-ids}"
}

module "internet-gateway" {
  source = "../../../modules/network/internet-gateway"
  env               = "${var.env}"
  team              = "Production"
  vpc_id            = "${module.vpc.vpc-id}"
  name              = "${module.vpc.vpc-name}"
}
