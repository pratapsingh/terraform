# Route53' Private Hosted Zone to access internal services with domain names.
# see: http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/vpc-dns.html#vpc-private-hosted-zones
resource "aws_route53_zone" "private" {
  name    = "private.windli.com"
  vpc_id  = "${aws_vpc.vpc.id}"
  comment = "Private Hosted Zone for ${var.environment_name}"

  tags {
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "private_route53_zone_id" {
  value = "${aws_route53_zone.private.zone_id}"
}

output "private_route53_zone_name" {
  value = "${aws_route53_zone.private.name}"
}
