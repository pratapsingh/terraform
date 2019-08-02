resource "aws_lb_target_group_attachment" "alb" {
  target_group_arn = "${aws_alb_target_group.apps.arn}"
  target_id        = "${var.instance_id}"
  port             = "${var.alb_port}"
}

output "alb_target_id" {
  value = "${aws_lb_target_group_attachment.alb.id}"
}
