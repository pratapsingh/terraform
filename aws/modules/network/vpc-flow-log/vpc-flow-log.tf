variable "vpc_name" { }
variable "vpc_id" { }
variable "iam_role_arn" { }

resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.vpc_name}-log-group"
}

resource "aws_flow_log" "vpc_flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.log_group.name}"
  #iam_role_arn   = "${aws_iam_role.flow_log_role.arn}"
  iam_role_arn   = "${var.iam_role_arn}"
  vpc_id         = "${var.vpc_id}"
  traffic_type   = "ALL"
}

output "flow-log-id" { value = "${aws_flow_log.vpc_flow_log.id}"}