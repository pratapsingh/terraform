variable "name"              { default = "nat-gateway" }
variable "env"               { }
variable "team"              { }
variable "azs"               { }
variable "vpc_id"            { }
variable "public_subnet_ids" { }

resource "aws_eip" "nat-gateway" {
  vpc   = true
  count = "${length(split(",", var.azs))}" # Comment out count to only have 1 NAT
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id = "${element(aws_eip.nat-gateway.*.id, count.index)}"
  subnet_id     = "${element(split(",", var.public_subnet_ids), count.index)}"
  count = "${length(split(",", var.azs))}"
  tags {
    Name = "${var.name}-nat-${count.index+1}"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${var.vpc_id}"
  count = "${length(split(",", var.azs))}"
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${element(aws_nat_gateway.nat-gateway.*.id, count.index)}"
  }
  tags      {
    Name = "${var.name}-private-route-${element(split(",", var.azs), count.index)}"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

output "nat-gateway-ids" { value = "${join(",", aws_nat_gateway.nat-gateway.*.id)}" }
output "route-table-ids" { value = "${join(",", aws_route_table.private.*.id)}" }
