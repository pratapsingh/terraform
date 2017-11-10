module "flow-log-role" {
  source                   = "../modules/util/iam/flow-log-role"
  role_name                = "flow-log-role"
}

output "flow-log-role-iam-role-id" { value = "${module.flow-log-role.iam-role-id}"}
output "flow-log-role-iam-role-arn" { value = "${module.flow-log-role.iam-role-arn}"}
output "flow-log-role-iam-policy-id" { value = "${module.flow-log-role.iam-policy-id}"}
output "flow-log-role-iam-policy-name" { value = "${module.flow-log-role.iam-policy-name}"}
output "flow-log-role-iam-policy-role" { value = "${module.flow-log-role.iam-policy-role}"}