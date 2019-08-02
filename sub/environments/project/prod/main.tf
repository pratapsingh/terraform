provider "aws" {
  version = "~> 1.19"
  region  = "us-east-1"
}

provider "template" {
  version = "~> 1.0"
}

data "template_file" "public_key" {
  template = "${file("${path.module}/template_files/public_key.tpl")}"
}

data "template_file" "shared_env_vars" {
  template = "${file("${path.module}/template_files/env.json")}"
}

data "template_file" "oauth2_proxy_env_vars" {
  template = "${file("${path.module}/template_files/oauth2-proxy-env.json")}"
}

module "vpc" {
  source                        = "../../../modules/vpc"
  project_name                  = "${var.project_name}"
  environment_name              = "${var.environment_name}"
  vpc_cidr                      = "${var.vpc_cidr}"
  tag_BusinessUnit              = "${var.tag_BusinessUnit}"
  tag_Creator                   = "${var.tag_Creator}"
  tag_Stack                     = "${var.tag_Stack}"
  tag_TechTeam                  = "${var.tag_TechTeam}"
  pub_subnet_count              = "${var.pub_subnet_count}"
  priv_subnet_count             = "${var.priv_subnet_count}"
  prot_subnet_count             = "${var.prot_subnet_count}"
  azs                           = "${lookup(var.azs, var.region)}"
  pub-subnet-ids                = "${module.vpc.pub-subnet-ids}"
  nat_gateway_ids               = "${module.vpc.aws_route_nat_access_ids}"
  newbits                       = "${var.newbits}"
  key_pair_name                 = "${var.key_pair_name}"
  public_key                    = "${data.template_file.public_key.rendered}"
  ssh_internal_range            = "${var.ssh_internal_range}"
  vpn_gateway_id                = "${module.vpc.vpn_gateway_id}"
  default_static_vpn_route_cidr = "${var.default_static_vpn_route_cidr}"
  region                        = "${var.region}"
  default_destination_cidr      = "${var.default_destination_cidr}"
  availability_zones            = "${var.availability_zones}"
  igw_default_destination_cidr  = "${var.igw_default_destination_cidr}"
}

module "private-load-balancer" {
  source                   = "../../../modules/private-load-balancer"
  project_name             = "${var.project_name}"
  environment_name         = "${var.environment_name}"
  elb_access_log_s3_bucket = "${var.elb_access_log_s3_bucket}"
  elb_security_groups      = ["${module.vpc.public_security_group_id}"]
  subnets                  = ["${module.vpc.protected_subnet_ids}"]
  route53_zone_id          = "${module.vpc.private_route53_zone_id}"
  domain_name              = "private-${module.vpc.private_route53_zone_name}"

  #  subnets                  = ["${data.terraform_remote_state.production.protected_subnet_ids}"]
  #  route53_zone_id          = "${data.terraform_remote_state.production.private_route53_zone_id}"
  #  domain_name              = "private-${data.terraform_remote_state.production.private_route53_zone_name}"
  type = "ops"

  vpc_id           = "${module.vpc.vpc_id}"
  subnets          = ["${module.vpc.public_subnet_ids}"]
  tag_BusinessUnit = "${var.tag_BusinessUnit}"
  tag_Creator      = "${var.tag_Creator}"
  tag_Stack        = "${var.tag_Stack}"
  tag_TechTeam     = "${var.tag_TechTeam}"
}

module "apps-load-balancer" {
  source                   = "../../../modules/apps-load-balancer"
  project_name             = "${var.project_name}"
  environment_name         = "${var.environment_name}"
  elb_access_log_s3_bucket = "${var.elb_access_log_s3_bucket}"
  elb_security_groups      = ["${module.vpc.public_security_group_id}"]
  vpc_id                   = "${module.vpc.vpc_id}"
  subnets                  = "${module.vpc.public_subnet_ids}"
  ssl_certificate          = "${var.default_ssl_certificate}"
  route53_zone_id          = "${var.route53_zone_id}"
  domain_name              = "apps.windli.com"
}

module "launch_configs" {
  source                    = "../../../modules/launch_configs"
  project_name              = "${var.project_name}"
  environment_name          = "${var.environment_name}"
  security_groups           = ["${module.vpc.internal_security_group_id}"]
  subnets                   = "${module.vpc.protected_subnet_ids}"
  ecs_cluster_name          = "${module.vpc.ecs_cluster_name}"
  papertrail_host           = "${var.papertrail_host}"
  papertrail_port           = "${var.papertrail_port}"
  min_size                  = "1"
  max_size                  = "2"
  desired_capacity          = "2"
  instance_type             = "t3.large"
  instance_root_volume_size = "20"
  name_suffix               = "-1"
  sns_arn                   = "${var.sns_arn}"
}

module "bastion" {
  source                    = "../../../modules/bastion"
  project_name              = "${var.project_name}"
  environment_name          = "${var.environment_name}"
  security_groups           = ["${module.vpc.bastion_security_group_id}"]
  subnets                   = "${module.vpc.public_subnet_ids}"
  papertrail_host           = "${var.papertrail_host}"
  papertrail_port           = "${var.papertrail_port}"
  min_size                  = "1"
  max_size                  = "2"
  desired_capacity          = "1"
  instance_type             = "t2.nano"
  instance_root_volume_size = "20"
  sns_arn                   = "${var.sns_arn}"
  key_pair_name             = "${var.key_pair_name}"
}

module "webapp" {
  source                   = "../../../modules/apps/webapp"
  project_name             = "${var.project_name}"
  environment_name         = "${var.environment_name}"
  ecs_cluster_id           = "${module.vpc.ecs_cluster_id}"
  elb_security_groups      = ["${module.vpc.public_security_group_id}"]
  vpc_id                   = "${module.vpc.vpc_id}"
  subnets                  = "${module.vpc.public_subnet_ids}"
  elb_access_log_s3_bucket = "${var.elb_access_log_s3_bucket}"
  env_vars                 = "${data.template_file.shared_env_vars.rendered}"
  ssl_certificate          = "${var.default_ssl_certificate}"
  route53_zone_id          = "${var.route53_zone_id}"
  nginx_docker_image       = "${var.docker_repo}/${var.nginx_webapp_artifact}"
  env_new_relic_app_name   = "Windli"
  domain_name              = "www.windli.com"
  desired_count            = "1"
}

module "phabricator" {
  source                    = "../../../modules/apps/phabricator"
  project_name              = "${var.project_name}"
  environment_name          = "${var.environment_name}"
  ecs_cluster_id            = "${module.vpc.ecs_cluster_id}"
  vpc_id                    = "${module.vpc.vpc_id}"
  desired_count             = "1"
  route53_zone_id           = "${var.route53_zone_id}"
  domain_name               = "phab.windli.com"
  alb_dns_name              = "${module.webapp.alb_dns_name}"
  alb_zone_id               = "${module.webapp.alb_zone_id}"
  alb_listener_arn          = "${module.webapp.alb_listener_arn}"
  oauth2_proxy_docker_image = "${var.docker_repo}/${var.oauth2_proxy_artifact}"
  oauth2_proxy_env_vars     = "${data.template_file.oauth2_proxy_env_vars.rendered}"
}
