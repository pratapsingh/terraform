variable "name" { }
variable "env" { }
variable "team" { }
variable "vpc_id" { }

resource "aws_route53_zone" "private-zone" {
  name = "${var.name}"
  vpc_id = "${var.vpc_id}"
  tags {
    Name = "${replace(var.name,".","-")}-private-zone"
    Environment = "${var.env}"
    Team = "${var.team}"
    Terraform = true
  }
}

output "hosted-zone-id" { value = "${aws_route53_zone.private-zone.zone_id}" }
output "hosted-zone-name" { value = "${var.name}" }
output "hosted-zone-name-servers" { value = "${aws_route53_zone.private-zone.name_servers}" }