module "ecsBastion" {
  source = "../../modules/iam/ecsBastion"
}

module "ecsInstanceRole" {
  source = "../../modules/iam/ecsInstanceRole"
}
