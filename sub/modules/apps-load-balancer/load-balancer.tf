resource "aws_alb" apps {
  name = "${var.project_name}-${var.environment_name}-apps"

  access_logs {
    bucket  = "${var.elb_access_log_s3_bucket}"
    prefix  = "${var.project_name}-${var.environment_name}-apps-alb"
    enabled = true
  }

  security_groups = ["${var.elb_security_groups}"]

  subnets = ["${var.subnets}"]

  internal = false

  enable_deletion_protection = true

  tags {
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }
}

resource "aws_alb_target_group" apps {
  name = "${var.project_name}-${var.environment_name}-apps-alb-tg"

  // this port is a dummy value because we're using this in ECS
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "60"

  health_check {
    path                = "/ping"
    healthy_threshold   = "10"
    unhealthy_threshold = "2"
    timeout             = "5"
    interval            = "30"
    matcher             = "200"
  }

  tags {
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }
}

resource "aws_alb_listener" apps {
  load_balancer_arn = "${aws_alb.apps.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "${var.ssl_certificate}"

  default_action {
    target_group_arn = "${aws_alb_target_group.apps.id}"
    type             = "forward"
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

output "alb_listener_arn" {
  value = "${aws_alb_listener.apps.arn}"
}
