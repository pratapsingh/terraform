variable "env" { }
variable "type" { }
variable "ami_id" { }
variable "instance_type" { }
variable "instance_name" { }
variable "team" { }
variable "key_name" { }
variable "subnets" { type = "list" }
variable "server_count" { }
#variable "availability_zone" { }
variable "security_groups" { type = "list" }
variable "root_vol_size" { }
variable "root_vol_type" { }
#variable "log_vol_size" { }
#variable "log_vol_type" { }
#variable "log_vol_delete_on_termination" { }
#variable "app_vol_size" { }
#variable "app_vol_delete_on_termination" { }
#variable "app_vol_type" { }
variable "eip" { default = "false" }

data "template_file" "openvpn" {
  template = "${file("openvpn.tpl")}"
  vars {
    env = "${var.env}"
    project = "${var.type}"
  }
}

resource "aws_instance" "instance" {
  count = "${var.server_count}"
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  #availability_zone "${var.availability_zone}"
  tags {
    Name = "${var.instance_name}-${count.index+1}"
    Environment = "${var.env}"
    Team = "${var.team}"
    Terraform = true
  }

  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${var.security_groups}"]
  subnet_id = "${element(var.subnets, count.index % 2)}"
  user_data     = "${data.template_file.openvpn.rendered}"
  #associate_public_ip_address = "${var.public_ip}"

  # Root Volume
  root_block_device {
    volume_type = "${var.root_vol_type}"
    volume_size = "${var.root_vol_size}"
    delete_on_termination = "true"
  }

  ## Volume for App Data
  #ebs_block_device {
  #  device_name = "/dev/sdb"
  #  volume_type = "${var.app_vol_type}"
  #  volume_size = "${var.app_vol_size}"
  #  delete_on_termination = "${var.app_vol_delete_on_termination}"
  #}
#
  ## Volume for Logs Data
  #ebs_block_device {
  #  device_name = "/dev/sdc"
  #  volume_type = "${var.log_vol_type}"
  #  volume_size = "${var.log_vol_size}"
  #  delete_on_termination = "${var.log_vol_delete_on_termination}"
  #}
}

 resource "aws_eip" "eip" {
   count    = "${var.eip ? "${var.server_count}" : 0}"
   instance = "${element(aws_instance.instance.*.id, count.index)}"
   vpc      = true
 }

output "instance-id" { value = "${aws_instance.instance.*.id}"}
output "elastic-public-ip" { value = "${aws_eip.eip.*.public_ip}"}
output "instance-public-ip" { value = "${aws_instance.instance.*.public_ip}"}