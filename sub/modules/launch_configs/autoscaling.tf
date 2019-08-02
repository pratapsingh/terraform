resource "aws_autoscaling_group" "ecs" {
  name = "${var.project_name}-${var.environment_name}-ecs-asg${var.name_suffix}"

  vpc_zone_identifier = ["${var.subnets}"]

  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  desired_capacity          = "${var.desired_capacity}"
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.ecs.name}"
  health_check_grace_period = "${var.health_check_grace_period}"
  termination_policies      = ["OldestLaunchConfiguration", "OldestInstance", "Default"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Env"
    value               = "${var.environment_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Project"
    value               = "${var.project_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.project_name}-${var.environment_name}-ecs"
    propagate_at_launch = true
  }

  tag {
    key                 = "Terraform"
    value               = "true"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_notification" "cloudwatch_alarm" {
  group_names = [
    "${aws_autoscaling_group.ecs.name}",
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
  ]

  topic_arn = "${var.sns_arn}"
}

output "autoscaling.id" {
  value = "${aws_autoscaling_group.ecs.id}"
}

output "asg_name" {
  value = "${aws_autoscaling_group.ecs.name}"
}
