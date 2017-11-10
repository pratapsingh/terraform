variable "name" { }
variable "description" { }
variable "policy_file" { }

resource "aws_iam_policy" "iam-policy" {
  name        = "${var.name}-policy"
  description = "${var.description}"
  policy      = "${file("${path.module}/${var.policy_file}")}"
}

output "iam-policy-name" { value = "${aws_iam_policy.iam-policy.name}" }
output "iam-policy-arn" { value = "${aws_iam_policy.iam-policy.arn}" }