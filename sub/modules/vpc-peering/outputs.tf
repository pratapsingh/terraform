output "peering_connection_id" {
  value = "${aws_vpc_peering_connection.default.*.id}"
}

output "src_vpc_cidr" {
  value = "${data.aws_vpc.peer_src_vpc.cidr_block}"
}

output "dst_vpc_cidr" {
  value = "${data.aws_vpc.peer_dst_vpc.cidr_block}"
}
