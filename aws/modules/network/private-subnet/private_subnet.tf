variable "name" { default = "private" }
variable "region" { }
variable "env" { }
variable "team" { }
variable "type" { }
variable "vpc_id" { }
variable "cidr" { }
variable "vpc_cidr_number" { }
variable "azs" { }
variable "subnet_count" { }
variable "private_route_table_ids" { }

resource "aws_subnet" "private" {
  count             = "${var.subnet_count}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "10.${var.vpc_cidr_number}.${var.cidr}${count.index+1}.0/24"
  availability_zone = "${var.region}${element(split(",", var.azs), count.index % 2 )}"
  tags {
    Name = "${var.name}-${count.index+1}${element(split(",", var.azs), count.index % 2 )}"
    Environment = "${var.env}"
    Team       = "${var.team}"
    Terraform = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route_table_association" "private" {
  count          = "${var.subnet_count}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(split(",", var.private_route_table_ids), count.index)}"
  lifecycle {
    create_before_destroy = true
  }
}

output "subnet-ids" { value = "${join(",", aws_subnet.private.*.id)}" }
output "subnet-azs" { value = "${join(",", aws_subnet.private.*.availability_zone)}" }
output "subnet-cidrs" { value = "${join(",", aws_subnet.private.*.cidr_block)}" }