module "private-subnet-web" {
  source                   = "../../../modules/network/private-subnet"
  type                     = "web"
  env                      = "${var.env}"
  team                     = "Production"
  region                   = "${var.region}"
  name                     = "${module.vpc.vpc-name}-private-web"
  vpc_id                   = "${module.vpc.vpc-id}"
  cidr                     = "${lookup(var.private_subnets_cidr, "web" )}"
  vpc_cidr_number          = "${lookup(var.vpc_cidr_number, var.env )}"
  azs                      = "${lookup(var.azs, var.region)}"
  subnet_count             = "${lookup(var.subnet_count, var.env)}"
  private_route_table_ids  = "${module.nat-gateway.route-table-ids}"
}

output "private-subnet-web-subnet-ids" { value = "${module.private-subnet-web.subnet-ids}" }
output "private-subnet-web-subnet-azs" { value = "${module.private-subnet-web.subnet-azs}" }
output "private-subnet-web-subnet-cidrs" { value = "${module.private-subnet-web.subnet-cidrs}" }

module "private-subnet-api" {
  source                   = "../../../modules/network/private-subnet"
  type                     = "api"
  env                      = "${var.env}"
  team                     = "Production"
  region                   = "${var.region}"
  name                     = "${module.vpc.vpc-name}-private-api"
  vpc_id                   = "${module.vpc.vpc-id}"
  cidr                     = "${lookup(var.private_subnets_cidr, "api" )}"
  vpc_cidr_number          = "${lookup(var.vpc_cidr_number, var.env )}"
  azs                      = "${lookup(var.azs, var.region)}"
  subnet_count             = "${lookup(var.subnet_count, var.env)}"
  private_route_table_ids  = "${module.nat-gateway.route-table-ids}"
}

output "private-subnet-api-subnet-ids" { value = "${module.private-subnet-api.subnet-ids}" }
output "private-subnet-api-subnet-azs" { value = "${module.private-subnet-api.subnet-azs}" }
output "private-subnet-api-subnet-cidrs" { value = "${module.private-subnet-api.subnet-cidrs}" }
