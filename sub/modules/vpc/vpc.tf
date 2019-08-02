resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true              # Needed because we use private hosted zones (Route53)
  enable_dns_support   = true              # Needed because we use private hosted zones (Route53)
  enable_classiclink   = false

  tags {
    Name         = "${var.project_name}-${var.environment_name}-vpc"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}
