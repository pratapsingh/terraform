resource "aws_alb_target_group" "webapp" {
  name = "${var.project_name}-${var.environment_name}-phabricator-tg"

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

resource "aws_alb_listener_rule" "webapp" {
  listener_arn = "${var.alb_listener_arn}"
  priority     = 75

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.webapp.id}"
  }

  condition {
    field  = "host-header"
    values = ["${var.domain_name}"]
  }
}

output "tg_arn_suffix" {
  value = "${aws_alb_target_group.webapp.arn_suffix}"
}
