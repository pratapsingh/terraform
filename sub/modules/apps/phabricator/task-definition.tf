data "template_file" "webapp" {
  template = "${file("${path.module}/webapp.json")}"

  vars {
    oauth2_proxy_docker_image = "${var.oauth2_proxy_docker_image}"
    oauth2_proxy_env_vars     = "${var.oauth2_proxy_env_vars}"
  }
}

resource "aws_ecs_task_definition" "webapp" {
  family                = "${var.project_name}-${var.environment_name}-phabricator"
  container_definitions = "${data.template_file.webapp.rendered}"
  cpu                   = 192
  memory                = 512
}

output "taskdef_arn" {
  value = "${aws_ecs_task_definition.webapp.arn}"
}
