module "private-subnet-devops" {
  source                   = "../../../modules/network/private-subnet"
  type                     = "web"
  env                      = "${var.env}"
  team                     = "Production"
  region                   = "${var.region}"
  name                     = "${module.vpc.vpc-name}-private-devops"
  vpc_id                   = "${module.vpc.vpc-id}"
  cidr                     = "${lookup(var.private_subnets_cidr, "devops" )}"
  vpc_cidr_number          = "${lookup(var.vpc_cidr_number, var.env )}"
  azs                      = "${lookup(var.azs, var.region)}"
  subnet_count             = "${lookup(var.subnet_count, var.env)}"
  private_route_table_ids  = "${module.nat-gateway.route-table-ids}"
}

output "private-subnet-web-subnet-ids" { value = "${module.private-subnet-devops.subnet-ids}" }
output "private-subnet-web-subnet-azs" { value = "${module.private-subnet-devops.subnet-azs}" }
output "private-subnet-web-subnet-cidrs" { value = "${module.private-subnet-devops.subnet-cidrs}" }
