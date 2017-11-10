variable "env"  { }
variable "team"   { }
variable "source_vpc_id" { }
variable "dest_vpc_id" { }
variable "source_vpc_name" { }
variable "dest_vpc_name" { }

resource "aws_vpc_peering_connection" "vpc-peering" {
  peer_vpc_id   = "${var.dest_vpc_id}"
  vpc_id        = "${var.source_vpc_id}"
  auto_accept   = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }
  tags {
    Name        = "${var.source_vpc_name}-${var.dest_vpc_name}-vpc-peering"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform   = true
  }
}

output "peering-status" { value = "${aws_vpc_peering_connection.vpc-peering.accept_status}"}