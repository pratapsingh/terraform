variable "zone_id" { }
variable "vpc_id" { }

resource "aws_route53_zone_association" "association" {
  zone_id = "${var.zone_id}"
  vpc_id  = "${var.vpc_id}"
}

output "hosted-zone-association-id" { value = "${aws_route53_zone_association.association.id}" }