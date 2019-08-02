resource "aws_alb_target_group" "default" {
  name = "${var.project_name}-${var.environment_name}-webapp-default"

  // this port is a dummy value because we're using this in ECS
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "60"

  health_check {
    path                = "/ping"
    healthy_threshold   = "2"
    unhealthy_threshold = "3"
    timeout             = "10"
    interval            = "30"
    matcher             = "200,301,404"
  }

  tags {
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }
}

resource "aws_alb_target_group" "webapp" {
  name = "${var.project_name}-${var.environment_name}-webapp-alb-tg"

  // this port is a dummy value because we're using this in ECS
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "60"

  health_check {
    path                = "/ping"
    healthy_threshold   = "2"
    unhealthy_threshold = "3"
    timeout             = "10"
    interval            = "30"
    matcher             = "200"
  }

  tags {
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }
}

resource "aws_alb" "webapp" {
  name = "${var.project_name}-${var.environment_name}-webapp"

  access_logs {
    bucket  = "${var.elb_access_log_s3_bucket}"
    prefix  = "${var.project_name}-${var.environment_name}-webapp-alb"
    enabled = true
  }

  security_groups = ["${var.elb_security_groups}"]

  subnets = ["${var.subnets}"]

  enable_deletion_protection = true

  tags {
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }
}

resource "aws_alb_listener" "webapp-insecure" {
  load_balancer_arn = "${aws_alb.webapp.id}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener" "webapp" {
  load_balancer_arn = "${aws_alb.webapp.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${var.ssl_certificate}"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "www_ssl" {
  listener_arn = "${aws_alb_listener.webapp.arn}"
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.webapp.arn}"
  }

  condition {
    field  = "host-header"
    values = ["${var.domain_name}"]
  }
}

output "alb_name" {
  value = "${aws_alb.webapp.name}"
}

output "alb_arn_suffix" {
  value = "${aws_alb.webapp.arn_suffix}"
}

output "alb_dns_name" {
  value = "${aws_alb.webapp.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.webapp.zone_id}"
}

output "alb_listener_arn" {
  value = "${aws_alb_listener.webapp.arn}"
}

output "alb_http_listener_arn" {
  value = "${aws_alb_listener.webapp-insecure.arn}"
}

output "tg_arn_suffix" {
  value = "${aws_alb_target_group.webapp.arn_suffix}"
}
