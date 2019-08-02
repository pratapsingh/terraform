//Create Default VGW
resource "aws_vpn_gateway" "vpn_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name         = "${var.project_name}-${var.environment_name}-vgw"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "vpn_gateway_id" {
  value = "${aws_vpn_gateway.vpn_gateway.id}"
}
