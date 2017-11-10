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

module "sg-openvpn" {
  source              = "../../../modules/network/security-group"
  env                 = "${var.env}"
  team                = "Production"
  name                = "${var.vpc_name}-${var.env}-openvpn"
  description         = "OpenVPN Access"
  vpc_id              = "${module.vpc.vpc-id}"
  vpc_cidr            = "${module.vpc.vpc-cidr}"
  ingress_ports       = ["1194"]
  ingress_protocol    = "udp"
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_sgid_ports       = [ ]
  ingress_sgid_protocol    = "tcp"
  source_security_group_id = [ ]
}

output "sg-openvpn-security-group-id" {
  value = "${module.sg-openvpn.security-group-id}"
}
