variable "name" { }
variable "env" { }
variable "team" { }
variable "description" { }
variable "vpc_id" { }
variable "vpc_cidr" { }
variable "ingress_ports" { type = "list" }
variable "ingress_protocol" { }
variable "ingress_cidr_blocks" { type = "list" }
variable "ingress_sgid_ports" { type = "list" }
variable "ingress_sgid_protocol" { }
variable "source_security_group_id" { type = "list" }

resource "aws_security_group" "sg" {
  name        = "${var.name}-sg"
  description = "${var.description}"
  vpc_id      = "${var.vpc_id}"
  tags {
    Name            = "${var.name}-sg"
    Environment     = "${var.env}"
    Team            = "${var.team}"
    Terraform       = true
  }
}

resource "aws_security_group_rule" "ingress-cidr" {
  count                    = "${length(var.ingress_ports)}"
  type                     = "ingress"
  from_port                = "${element(var.ingress_ports, count.index)}"
  to_port                  = "${element(var.ingress_ports, count.index)}"
  protocol                 = "${var.ingress_protocol}"
  cidr_blocks              = ["${element(var.ingress_cidr_blocks, count.index)}"]
  security_group_id        = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "ingress-sgid" {
  count                    = "${length(var.ingress_sgid_ports)}"
  type                     = "ingress"
  from_port                = "${element(var.ingress_sgid_ports, count.index)}"
  to_port                  = "${element(var.ingress_sgid_ports, count.index)}"
  protocol                 = "${var.ingress_sgid_protocol}"
  source_security_group_id = "${element(var.source_security_group_id, count.index)}"
  security_group_id        = "${aws_security_group.sg.id}"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.sg.id}"
}

output "security-group-id" { value = "${aws_security_group.sg.id}" }