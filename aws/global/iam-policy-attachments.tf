resource "aws_iam_policy_attachment" "s3-artifacts-read-only" {
  name       = "s3-artifacts-read-only-attachment"
  users      = []
  roles      = ["${module.ec2-s3-artifacts-read-role.iam-role-name}"]
  groups     = []
  policy_arn = "${module.s3-artifacts-read-policy.iam-policy-arn}"
}

resource "aws_iam_policy_attachment" "s3-artifacts-read-write" {
  name       = "s3-artifacts-read-write-attachment"
  users      = []
  roles      = ["${module.production-jenkins-server-role.iam-role-name}"]
  groups     = []
  policy_arn = "${module.s3-artifacts-read-write-policy.iam-policy-arn}"
}

resource "aws_iam_policy_attachment" "s3-devops-read-only" {
  name       = "s3-devops-read-only-attachment"
  users      = []
  roles      = ["${module.production-openvpn-server-role.iam-role-name}"]
  groups     = []
  policy_arn = "${module.s3-devops-read-policy.iam-policy-arn}"
}

resource "aws_iam_policy_attachment" "s3-devops-read-write" {
  name       = "s3-devops-read-write-attachment"
  users      = []
  roles      = ["${module.production-devops-server-role.iam-role-name}"]
  groups     = []
  policy_arn = "${module.s3-devops-read-write-policy.iam-policy-arn}"
}
