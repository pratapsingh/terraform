#--------------------------------------------------------------
# This module creates all resources necessary for a VPC
#--------------------------------------------------------------

variable "env"  { }
variable "team"  { }
variable "vpc_name" { default = "production" }
variable "vpc_cidr" { }
variable "fqdn" { }
variable "region" { }

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags {
    Name    = "${var.vpc_name}-vpc"
    Environment = "${var.env}"
    Team            = "${var.team}"
    Terraform = true
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_dhcp_options" "dhcp-options" {
  domain_name = "${var.fqdn}"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags {
    Name        = "${var.vpc_name}-vpc-dhcp-options"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform   = true
  }
}

resource "aws_vpc_dhcp_options_association" "dns-resolver" {
  vpc_id          = "${aws_vpc.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp-options.id}"
}

resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"
  tags {
    Name        = "${var.vpc_name}-default-route"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform   = true
  }
}

resource "aws_default_security_group" "default_security_group" {
  vpc_id = "${aws_vpc.vpc.id}"
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name        = "${var.vpc_name}-default-sg"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform   = true
  }
}

output "vpc-id"   { value = "${aws_vpc.vpc.id}" }
output "vpc-cidr" { value = "${aws_vpc.vpc.cidr_block}" }
output "vpc-name" {value = "${var.vpc_name}"}
output "vpc-default-route-table-id"   { value = "${aws_vpc.vpc.default_route_table_id}" }
output "vpc-default-security-group-id"   { value = "${aws_vpc.vpc.default_rsecurity_group_id}" }
