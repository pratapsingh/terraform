variable "name" { default = "public" }
variable "region" { }
variable "env" { }
variable "type" { }
variable "team" { }
variable "vpc_id" { }
variable "cidr" { }
variable "vpc_cidr_number" { }
variable "azs" { }
variable "subnet_count" { }
variable "public_route_table_id" { }

resource "aws_subnet" "public" {
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
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
  count          = "${var.subnet_count}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${var.public_route_table_id}"
  lifecycle {
    create_before_destroy = true
  }
}

output "subnet-ids" { value = "${join(",", aws_subnet.public.*.id)}" }
output "subnet-azs" { value = "${join(",", aws_subnet.public.*.availability_zone)}" }
output "subnet-cidrs" { value = "${join(",", aws_subnet.public.*.cidr_block)}" }