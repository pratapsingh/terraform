// Enable Flow Logs for all interfaces in the VPC.
resource "aws_flow_log" "flow_log" {
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_log_group.name}"
  iam_role_arn   = "${aws_iam_role.logs_iam_role.arn}"
  vpc_id         = "${aws_vpc.vpc.id}"
  traffic_type   = "ALL"
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name = "${var.project_name}-${var.environment_name}-vpc-flow-logs"

  tags {
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }
}

resource "aws_iam_role" "logs_iam_role" {
  name = "${var.project_name}-${var.environment_name}-vpc-flow-logs"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "logs_policy" {
  name = "${var.project_name}-${var.environment_name}-vpc-flow-logs"
  role = "${aws_iam_role.logs_iam_role.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
