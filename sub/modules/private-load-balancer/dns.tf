resource "aws_route53_record" "apps" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${aws_alb.apps.dns_name}"
    zone_id                = "${aws_alb.apps.zone_id}"
    evaluate_target_health = false
  }
}

output "dns_name" {
  value = "${aws_route53_record.apps.fqdn}"
}
