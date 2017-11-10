variable "env"  { }
variable "team"   { }
variable "vpc_id" { }
variable "name" { }

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = "${var.vpc_id}"
  tags {
    Name    = "${var.name}-vpc-ig"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${var.vpc_id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.internet-gateway.id}"
  }
  tags {
    Name = "${var.name}-public-route"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform = true
  }
}

output "internet-gateway-id" { value = "${aws_internet_gateway.internet-gateway.id}" }
output "public-route-table-id" {value = "${aws_route_table.public.id}"}
