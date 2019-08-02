resource "aws_ecs_service" "webapp" {
  name                               = "phabricator"
  cluster                            = "${var.ecs_cluster_id}"
  task_definition                    = "${aws_ecs_task_definition.webapp.arn}"
  desired_count                      = "${var.desired_count}"
  iam_role                           = "${var.ecs_role}"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50

  load_balancer {
    target_group_arn = "${aws_alb_target_group.webapp.id}"
    container_name   = "phabricator-auth-proxy"
    container_port   = 4180
  }
}

output "service_arn" {
  value = "${aws_ecs_service.webapp.id}"
}

output "service_name" {
  value = "${aws_ecs_service.webapp.name}"
}
