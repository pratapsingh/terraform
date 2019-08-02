//VPN Connection
//@see:  https://docs.aws.amazon.com/vpn/latest/s2svpn/VPNTunnels.html

resource "aws_vpn_connection" "main" {
  vpn_gateway_id      = "${var.vpn_gateway_id}"
  customer_gateway_id = "${var.customer_gateway_id}"

  type               = "ipsec.1"
  static_routes_only = true

  tags {
    Name         = "${var.project_name}-${var.environment_name}-${var.cgw_name}-vpn"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }

//Ignoring changes as this might cause production outage hence by default any changes to ignored list will not cause any change in vpn tunnel
  lifecycle {
    ignore_changes = [
      "customer_gateway_id",
      "id",
      "vpn_gateway_id",
      "aws_customer_gateway",
    ]
  }
}

//VPN Connection route
resource "aws_vpn_connection_route" "office" {
  destination_cidr_block = "${var.default_static_vpn_route_cidr}"
  vpn_connection_id      = "${aws_vpn_connection.main.id}"
}
