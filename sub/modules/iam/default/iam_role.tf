//Template files for policy
data "template_file" "ec2-assume-role-policy" {
  template = "${file("${path.module}/policy.ec2-principal.tpl")}"
}

data "template_file" "role_policy" {
  template = "${file("${path.module}/policy.${var.role_name}.tpl")}"

  vars {
    default_s3_bucket = "${var.default_s3_bucket}"
  }
}

//Create instance profile for role to be attached to instance
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${aws_iam_role.iam_role.name}"
  role = "${aws_iam_role.iam_role.name}"
}

//Create role with assumed policy
resource "aws_iam_role" "iam_role" {
  name               = "${var.role_name}"
  assume_role_policy = "${data.template_file.ec2-assume-role-policy.rendered}"
  description        = "EC2: IAM role created for instance"
}

//Attache inline policy to role
resource "aws_iam_role_policy" "policy" {
  name   = "${var.role_name}_role_policy"
  role   = "${aws_iam_role.iam_role.id}"
  policy = "${data.template_file.role_policy.rendered}"
}

output "ec2-role-name" {
  value = "${aws_iam_role.iam_role.name}"
}

output "ec2-role-arn" {
  value = "${aws_iam_role.iam_role.arn}"
}
