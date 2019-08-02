resource "aws_route53_record" "webapp" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.webapp.dns_name}"
    zone_id                = "${aws_alb.webapp.zone_id}"
    evaluate_target_health = false
  }
}

output "webapp.route53.dns_names" {
  value = ["${aws_route53_record.webapp.*.fqdn}"]
}
