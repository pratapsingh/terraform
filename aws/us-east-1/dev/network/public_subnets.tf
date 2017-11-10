module "public-subnet" {
  source                 = "../../../modules/network/public-subnet"
  type                   = "elb"
  env                    = "${var.env}"
  team                     = "Production"
  region                 = "${var.region}"
  name                   = "${module.vpc.vpc-name}-public"
  vpc_id                 = "${module.vpc.vpc-id}"
  cidr                   = "${lookup(var.public_subnets_cidr, "public" )}"
  vpc_cidr_number        = "${lookup(var.vpc_cidr_number, var.env )}"
  azs                    = "${lookup(var.azs, var.region)}"
  subnet_count           = "${lookup(var.subnet_count, var.env)}"
  public_route_table_id  = "${module.internet-gateway.public-route-table-id}"
}

output "public-subnet-subnet-ids" { value = "${module.public-subnet.subnet-ids}" }
output "public-subnet-subnet-azs" { value = "${module.public-subnet.subnet-azs}" }
output "public-subnet-subnet-cidrs" { value = "${module.public-subnet.subnet-cidrs}" }
