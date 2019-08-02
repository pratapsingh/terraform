resource "aws_instance" "instance" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.instance_type}"
  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.security_groups}"]
  subnet_id              = "${var.subnet}"
  user_data              = "${var.user_data}"
  iam_instance_profile   = "${var.iam_instance_profile}"

  tags {
    Name         = "${var.environment_name}-${var.project_name}-${var.application}-${var.type}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    Role         = "nat"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }

  volume_tags {
    Name         = "${var.environment_name}-${var.project_name}-${var.application}-${var.type}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    Role         = "nat"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }

  # Root Volume
  root_block_device {
    volume_type           = "${var.root_vol_type}"
    volume_size           = "${var.root_vol_size}"
    delete_on_termination = "${var.root_vol_delete_on_termination}"
  }

  # Volume for App Data
  ebs_block_device {
    device_name           = "/dev/sdb"
    volume_type           = "${var.app_vol_type}"
    volume_size           = "${var.app_vol_size}"
    snapshot_id           = "${var.app_vol_snapshot}"
    delete_on_termination = "${var.app_vol_delete_on_termination}"
  }

  # Volume for Logs Data
  ebs_block_device {
    device_name           = "/dev/sdc"
    volume_type           = "${var.log_vol_type}"
    volume_size           = "${var.log_vol_size}"
    snapshot_id           = "${var.log_vol_snapshot}"
    delete_on_termination = "${var.log_vol_delete_on_termination}"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = ["user_data", "ami", "ebs_block_device"]
  }
}

resource "aws_eip" "eip" {
  count    = "${var.eip ? 1 : 0}"
  instance = "${aws_instance.instance.id}"
  vpc      = true
}

resource "aws_route53_record" "private-dns" {
  zone_id = "${var.zone_id}"
  name    = "${var.environment_name}-${var.project_name}.${var.zone_name}-${var.application}-${var.type}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.instance.private_ip}"]
}

output "instance-hostname" {
  value = "${var.environment_name}-${var.project_name}"
}

output "instance-id" {
  value = "${aws_instance.instance.id}"
}

output "elastic-public-ip" {
  value = "${aws_eip.eip.public_ip}"
}

output "instance-private-ip" {
  value = "${aws_instance.instance.private_ip}"
}
