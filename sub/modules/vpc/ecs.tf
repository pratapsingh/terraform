resource "aws_ecs_cluster" "apps" {
  name = "${var.project_name}-${var.environment_name}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.apps.id}"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.apps.name}"
}
