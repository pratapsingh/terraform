variable "name" { }
variable "assume_role_policy_file" { }

resource "aws_iam_role" "iam-role" {
  name               = "${var.name}-role"
  assume_role_policy = "${file("${path.module}/${var.assume_role_policy_file}")}"
}

resource "aws_iam_instance_profile" "instance-profile" {
  name  = "${aws_iam_role.iam-role.name}"
  role = "${aws_iam_role.iam-role.name}"
}

output "iam-role-name" { value = "${aws_iam_role.iam-role.name}" }
output "iam-role-arn" { value = "${aws_iam_role.iam-role.arn}" }