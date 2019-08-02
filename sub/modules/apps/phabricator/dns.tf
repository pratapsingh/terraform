resource "aws_route53_record" "webapp" {
  zone_id = "${var.route53_zone_id}"
  name    = "${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${var.alb_dns_name}"
    zone_id                = "${var.alb_zone_id}"
    evaluate_target_health = false
  }
}

output "dns_name" {
  value = "${aws_route53_record.webapp.fqdn}"
}
