//Create VPN Gateway for on-prem connectivity

//Create Customer gateway for on-prem site connection
resource "aws_customer_gateway" "customer_gateway" {
  bgp_asn    = 65000
  ip_address = "${var.static_public_gateway_ip_address}"
  type       = "ipsec.1"

  tags {
    Name         = "${var.project_name}-${var.environment_name}-${var.cgw_name}-cgw"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }

  lifecycle {
    ignore_changes = ["customer_gateway", "id", "ip_address"]
  }
}
