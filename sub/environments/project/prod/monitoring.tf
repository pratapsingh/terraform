module "prod-cloudwatch" {
  source       = "../../../modules/cloudwatch/ecs-cluster"
  cluster_name = "${module.vpc.ecs_cluster_name}"
}

module "private_alb_alarms" {
  source   = "../../../modules/cloudwatch/alb"
  alb_name = "${module.private-load-balancer.alb_arn_suffix}"
}

module "apps_alb_alarms" {
  source   = "../../../modules/cloudwatch/alb"
  alb_name = "${module.apps-load-balancer.alb_arn_suffix}"
}

module "nat_gateway_cloudwatch" {
  source             = "../../../modules/cloudwatch/NAT"
  NAT_Gateway        = "prod"
  nat_cacheclusterid = "${module.vpc.nat_cacheclusterid}"
  alarm_actions      = "${var.alarm_actions}"
}
