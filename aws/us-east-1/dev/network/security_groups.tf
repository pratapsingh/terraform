module "sg-ssh" {
  source              = "../../../modules/network/security-group"
  env                 = "${var.env}"
  team                = "Production"
  name                = "${var.vpc_name}-${var.env}-ssh"
  description         = "Local ssh access"
  vpc_id              = "${module.vpc.vpc-id}"
  vpc_cidr            = "${module.vpc.vpc-cidr}"
  ingress_ports       = ["22"]
  ingress_protocol    = "tcp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_sgid_ports       = [ ]
  ingress_sgid_protocol    = "tcp"
  source_security_group_id = [ ]
}

output "sg-ssh-security-group-id" {
  value = "${module.sg-ssh.security-group-id}"
}

# module "sg-api" {
#   source              = "../../../modules/network/security-group"
#   env                 = "${var.env}"
#   team                = "Production"
#   name                = "${var.vpc_name}-${var.env}-api"
#   description         = "test"
#   vpc_id              = "${module.vpc.vpc-id}"
#   vpc_cidr            = "${module.vpc.vpc-cidr}"
#   ingress_ports       = ["80","443"]
#   ingress_protocol    = "tcp"
#   ingress_cidr_blocks = ["0.0.0.0/0","0.0.0.0/0"]
#   ingress_sgid_ports       = ["80","443"]
#   ingress_sgid_protocol    = "tcp"
#   source_security_group_id = ["${module.sg-web.security-group-id}","${module.sg-web.security-group-id}"]
# }
#
# output "sg-api-security-group-id" {
#   value = "${module.sg-api.security-group-id}"
# }
