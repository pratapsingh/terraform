variable "env" { }
variable "type" { }
variable "ami_id" { }
variable "instance_type" { }
variable "instance_name" { }
variable "team" { }
variable "key_name" { }
variable "iam_role" { }
variable "subnets" { type = "list" }
variable "server_count" { }
variable "security_groups" { type = "list" }
variable "root_vol_size" { }
variable "root_vol_type" { }
variable "eip" { default = "false" }
variable "zone_id" { }
variable "zone_name" { }

data "template_file" "openvpn" {
  count      = "${var.server_count}"
  template   = "${file("${path.module}/openvpn.tpl")}"
  vars {
    env      = "${var.env}"
    project  = "${var.type}"
    hostname = "${var.instance_name}-${count.index+1}"
  }
}

resource "aws_instance" "instance" {
  count         = "${var.server_count}"
  ami           = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  tags {
    Name        = "${var.instance_name}-${count.index+1}"
    Environment = "${var.env}"
    Team        = "${var.team}"
    Terraform   = true
  }

  key_name               = "${var.key_name}"
  vpc_security_group_ids = ["${var.security_groups}"]
  subnet_id              = "${element(var.subnets, count.index % 2)}"
  user_data              = "${element(data.template_file.openvpn.*.rendered, count.index)}"
  iam_instance_profile   = "${var.iam_role}"
  # Root Volume
  root_block_device {
    volume_type           = "${var.root_vol_type}"
    volume_size           = "${var.root_vol_size}"
    delete_on_termination = "true"
  }
}

resource "aws_eip" "eip" {
  count    = "${var.eip ? "${var.server_count}" : 0}"
  instance = "${element(aws_instance.instance.*.id, count.index)}"
  vpc      = true
}

resource "aws_route53_record" "private-dns" {
  count   = "${var.server_count}"
  zone_id = "${var.zone_id}"
  name    = "${var.instance_name}-${count.index+1}.${var.zone_name}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.instance.*.private_ip, count.index)}"]
}

output "instance-id" { value = "${aws_instance.instance.*.id}"}
output "elastic-public-ip" { value = "${aws_eip.eip.*.public_ip}"}
output "instance-public-ip" { value = "${aws_instance.instance.*.public_ip}"}
output "instance-private-fqdn" { value = "${aws_route53_record.private-dns.*.fqdn}"}