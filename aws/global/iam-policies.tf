module "s3-artifacts-read-policy" {
  source              = "../modules/util/iam/policy"
  name                = "s3-artifacts-read"
  description         = "S3 artifacts read policy"
  policy_file         = "s3-artifacts-read-only.json"
}

output "s3-artifacts-read-policy-name" { value = "${module.s3-artifacts-read-policy.iam-policy-name}" }
output "s3-artifacts-read-policy-arn" { value = "${module.s3-artifacts-read-policy.iam-policy-arn}" }

module "s3-artifacts-read-write-policy" {
  source              = "../modules/util/iam/policy"
  name                = "s3-artifacts-read-write"
  description         = "S3 artifacts read write policy"
  policy_file         = "s3-artifacts-read-write.json"
}

output "s3-artifacts-read-write-policy-name" { value = "${module.s3-artifacts-read-write-policy.iam-policy-name}" }
output "s3-artifacts-read-write-policy-arn" { value = "${module.s3-artifacts-read-write-policy.iam-policy-arn}" }

module "s3-devops-read-policy" {
  source              = "../modules/util/iam/policy"
  name                = "s3-devops-read"
  description         = "S3 devops read policy"
  policy_file         = "s3-devops-read-only.json"
}

output "s3-devops-read-policy-name" { value = "${module.s3-devops-read-policy.iam-policy-name}" }
output "s3-devops-read-policy-arn" { value = "${module.s3-devops-read-policy.iam-policy-arn}" }

module "s3-devops-read-write-policy" {
  source              = "../modules/util/iam/policy"
  name                = "s3-devops-read-write"
  description         = "S3 devops read write policy"
  policy_file         = "s3-devops-read-write.json"
}

output "s3-devops-read-write-policy-name" { value = "${module.s3-devops-read-write-policy.iam-policy-name}" }
output "s3-devops-read-write-policy-arn" { value = "${module.s3-devops-read-write-policy.iam-policy-arn}" }