data "aws_ami" "coreos_stable" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["595879546273"] // CoreOS
}

data "template_file" "user-data" {
  template = "${file("${path.module}/user-data.yml")}"

  vars {
    # ECS agent:
    ecs-agent-docker-tag = "${var.ecs_agent_docker_tag}"
    ecs-cluster-name     = "${var.ecs_cluster_name}"

    # Logspout:
    logspout-docker-tag = "${var.logspout_docker_tag}"

    # Papertrail forwarder:
    syslog-host = "${var.papertrail_host}"
    syslog-port = "${var.papertrail_port}"

    # project_name and environment_name of tagging
    tf-project-name     = "${var.project_name}"
    tf-environment-name = "${var.environment_name}"
    tf-role-name        = "app"

    # manage-users script
    manage-users-script = "${base64encode(file("${path.module}/manage-users"))}"

    sshd-config = "${base64encode(file("${path.module}/sshd_config"))}"

    # ECS Config to enable IAM role for tasks
    ecs-config = "${base64encode(file("${path.module}/ecs.config"))}"

    ssh-iam-group = "${aws_iam_group.ssh.name}"
  }
}

// IAM group that lists the users who will have SSH access to these servers.
resource "aws_iam_group" "ssh" {
  name = "${var.environment_name}-ssh-ecs${var.name_suffix}"
}

resource "aws_launch_configuration" "ecs" {
  name_prefix                 = "${var.project_name}-${var.environment_name}-lc-ecs-"
  image_id                    = "${data.aws_ami.coreos_stable.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  security_groups             = ["${var.security_groups}"]
  user_data                   = "${data.template_file.user-data.rendered}"
  associate_public_ip_address = false
  enable_monitoring           = true

  root_block_device {
    volume_size = "${var.instance_root_volume_size}"
    volume_type = "gp2"
  }

  lifecycle {
    create_before_destroy = true
  }
}

output "ecs_launch_configuration.id" {
  value = "${aws_launch_configuration.ecs.id}"
}
