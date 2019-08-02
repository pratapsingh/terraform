resource "aws_alb_target_group" apps {
  name = "${var.project_name}-${var.environment_name}-${var.type}-${var.tg_name}-alb-tg"

  // this port is a dummy value because we're using this in EC2
  port                 = "${var.alb_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "60"

  health_check {
    path                = "/"
    healthy_threshold   = "10"
    unhealthy_threshold = "2"
    timeout             = "5"
    interval            = "30"
    matcher             = "200"
  }

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

resource "aws_alb_listener" apps {
  load_balancer_arn = "${var.alb_id}"

  port     = "${var.alb_port}"
  protocol = "HTTP"

  #  ssl_policy        = "ELBSecurityPolicy-2016-08"
  #  certificate_arn   = "${var.ssl_certificate}"

  default_action {
    target_group_arn = "${aws_alb_target_group.apps.id}"
    type             = "forward"
  }
}

output "alb_listener_arn" {
  value = "${aws_alb_listener.apps.arn}"
}

output "alb_target_group" {
  value = "${aws_alb_target_group.apps.arn}"
}
