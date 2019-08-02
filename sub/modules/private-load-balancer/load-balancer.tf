resource "aws_alb" apps {
  name = "${var.project_name}-${var.environment_name}-${var.type}-apps"

  access_logs {
    bucket  = "${var.elb_access_log_s3_bucket}"
    prefix  = "${var.project_name}-${var.environment_name}-${var.type}-apps-alb"
    enabled = true
  }

  security_groups = ["${var.elb_security_groups}"]

  subnets = ["${var.subnets}"]

  internal = true

  enable_deletion_protection = true

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

output "alb_name" {
  value = "${aws_alb.apps.name}"
}

output "alb_arn_suffix" {
  value = "${aws_alb.apps.arn_suffix}"
}

output "alb_dns_name" {
  value = "${aws_alb.apps.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.apps.zone_id}"
}

output "aws_lb_id" {
  value = "${aws_alb.apps.id}"
}
