resource "aws_vpc_endpoint" "s3" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "com.amazonaws.${var.region}.s3"

  #  vpc_endpoint_type = "Interface"

  # security_group_ids = [
  #    "${aws_security_group.internal.id}",
  #  ]

  #  private_dns_enabled = true
}
