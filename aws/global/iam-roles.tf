module "ec2-s3-artifacts-read-role" {
  source                   = "../modules/util/iam/role"
  name                     = "ec2-s3-artifacts-read"
  assume_role_policy_file  = "ec2-assume-role-policy.json"
}

output "ec2-s3-artifacts-read-role-name" { value = "${module.ec2-s3-artifacts-read-role.iam-role-name}" }
output "ec2-s3-artifacts-read-role-arn" { value = "${module.ec2-s3-artifacts-read-role.iam-role-arn}" }

module "ec2-s3-devops-read-role" {
  source                   = "../modules/util/iam/role"
  name                     = "ec2-s3-devops-read"
  assume_role_policy_file  = "ec2-assume-role-policy.json"
}

output "ec2-s3-devops-read-role-name" { value = "${module.ec2-s3-devops-read-role.iam-role-name}" }
output "ec2-s3-devops-read-role-arn" { value = "${module.ec2-s3-devops-read-role.iam-role-arn}" }

module "production-jenkins-server-role" {
  source                   = "../modules/util/iam/role"
  name                     = "production-jenkins-server"
  assume_role_policy_file  = "ec2-assume-role-policy.json"
}

output "production-jenkins-server-role-name" { value = "${module.production-jenkins-server-role.iam-role-name}" }
output "production-jenkins-server-role-arn" { value = "${module.production-jenkins-server-role.iam-role-arn}" }

module "production-devops-server-role" {
  source                   = "../modules/util/iam/role"
  name                     = "production-devops-server"
  assume_role_policy_file  = "ec2-assume-role-policy.json"
}

output "production-devops-server-role-name" { value = "${module.production-devops-server-role.iam-role-name}" }
output "production-devops-server-role-arn" { value = "${module.production-devops-server-role.iam-role-arn}" }

module "production-openvpn-server-role" {
  source                   = "../modules/util/iam/role"
  name                     = "production-openvpn-server"
  assume_role_policy_file  = "ec2-assume-role-policy.json"
}

output "production-openvpn-server-role-name" { value = "${module.production-openvpn-server-role.iam-role-name}" }
output "production-openvpn-server-role-arn" { value = "${module.production-openvpn-server-role.iam-role-arn}" }
