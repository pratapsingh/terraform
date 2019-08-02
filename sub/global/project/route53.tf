//@see :https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/migrate-dns-domain-in-use.html

resource "aws_route53_zone" "primary" {
  name = "${var.domainname}"
}
