variable "role_name" { }

resource "aws_iam_role" "flow_log_role" {
  name = "${var.role_name}"

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

output "iam-role-id" { value = "${aws_iam_role.flow_log_role.id}"}
output "iam-role-arn" { value = "${aws_iam_role.flow_log_role.arn}"}

resource "aws_iam_role_policy" "flow_log_policy" {
  name = "flow-log-policy"
  role = "${aws_iam_role.flow_log_role.id}"

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

output "iam-policy-id" { value = "${aws_iam_role_policy.flow_log_policy.id}"}
output "iam-policy-name" { value = "${aws_iam_role_policy.flow_log_policy.name}"}
output "iam-policy-role" { value = "${aws_iam_role_policy.flow_log_policy.role}"}
