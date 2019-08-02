data "template_file" "webapp" {
  template = "${file("${path.module}/webapp.json")}"

  vars {
    env-vars               = "${var.env_vars}"
    webapp-docker-image    = "${data.aws_ecs_container_definition.webapp.image}"
    nginx-docker-image     = "${var.nginx_docker_image}"
    env-new-relic-app-name = "${var.env_new_relic_app_name}"
    webapp-memory          = "${var.webapp_memory}"
  }
}

resource "aws_ecs_task_definition" "webapp" {
  family                = "${var.project_name}-${var.environment_name}-webapp"
  container_definitions = "${data.template_file.webapp.rendered}"
}

data "aws_ecs_container_definition" "webapp" {
  task_definition = "${var.project_name}-${var.environment_name}-webapp"
  container_name  = "webapp"
}

output "taskdef_arn" {
  value = "${aws_ecs_task_definition.webapp.arn}"
}

output "containerdef_tag" {
  value = "${data.aws_ecs_container_definition.webapp.image_digest}"
}

data "template_file" "collectstatic" {
  template = "${file("${path.module}/collectstatic.json")}"

  vars {
    env-vars     = "${var.env_vars}"
    docker-image = "${data.aws_ecs_container_definition.webapp.image}"
  }
}

resource "aws_ecs_task_definition" "collectstatic" {
  family                = "${var.project_name}-${var.environment_name}-collectstatic"
  container_definitions = "${data.template_file.collectstatic.rendered}"
}

output "collectstatic_taskdef_arn" {
  value = "${aws_ecs_task_definition.collectstatic.arn}"
}

data "template_file" "migrate" {
  template = "${file("${path.module}/migrate.json")}"

  vars {
    env-vars     = "${var.env_vars}"
    docker-image = "${data.aws_ecs_container_definition.webapp.image}"
  }
}

resource "aws_ecs_task_definition" "migrate" {
  family                = "${var.project_name}-${var.environment_name}-migrate"
  container_definitions = "${data.template_file.migrate.rendered}"
}

output "migrate_taskdef_arn" {
  value = "${aws_ecs_task_definition.migrate.arn}"
}

data "template_file" "https_redirector" {
  template = "${file("${path.module}/https_redirector.json")}"
}

resource "aws_ecs_task_definition" "https_redirector" {
  family                = "${var.project_name}-${var.environment_name}-webapp-default"
  container_definitions = "${data.template_file.https_redirector.rendered}"
}
