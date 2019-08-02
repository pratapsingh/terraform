resource "aws_security_group" "internal" {
  name        = "${var.project_name}-${var.environment_name}-sg-internal"
  description = "Allow internal traffic within each other."
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${var.project_name}-${var.environment_name}-sg-internal"
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }

  # SSH from bastion server
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  # Docker's published ports. We always use random host ports with docker,
  # hence we need to whitelist the complete possible port list.
  ingress {
    from_port       = 32768
    to_port         = 60999
    protocol        = "tcp"
    security_groups = ["${aws_security_group.public.id}", "${aws_security_group.private_lb.id}"]
  }

  # Postgres database access to all our applications & bastion
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    self            = true
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  # MySQL database access to all our applications & bastion
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    self            = true
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  # Redis access to all our applications & bastion
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    self            = true
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  # Allow outgoing to all (public + internal)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }
}

output "internal_security_group_id" {
  value = "${aws_security_group.internal.id}"
}

resource "aws_security_group" "public" {
  name        = "${var.project_name}-${var.environment_name}-sg-public"
  description = "Allow HTTP + HTTPS traffic. Public facing."
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${var.project_name}-${var.environment_name}-sg-public"
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }

  # Allow HTTP traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }

  # Allow HTTPS traffic
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }

  # Allow outgoing to all (public + internal)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }
}

output "public_security_group_id" {
  value = "${aws_security_group.public.id}"
}

resource "aws_security_group" "private_lb" {
  name        = "${var.project_name}-${var.environment_name}-private-lb"
  description = "Private Load Balancers. Allows HTTP traffic on port 80 only."
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${var.project_name}-${var.environment_name}-private-lb"
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }

  # NOTE: Declare ingress and egress rules using `aws_security_group_rule`
}

# Allow private load balancers to be accessed from other apps
resource "aws_security_group_rule" private_lb_app_access {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.private_lb.id}"
  source_security_group_id = "${aws_security_group.internal.id}"
}

# Allow private load balancers to be accessed from other bastion
resource "aws_security_group_rule" private_lb_bastion_access {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = "${aws_security_group.private_lb.id}"
  source_security_group_id = "${aws_security_group.bastion.id}"
}

# Allow private load balancers to access all (public + internal)
resource "aws_security_group_rule" private_lb_egress {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.private_lb.id}"
  cidr_blocks       = ["${var.default_destination_cidr}"]
}

output "private_lb_security_group_id" {
  value = "${aws_security_group.private_lb.id}"
}

resource "aws_security_group" "bastion" {
  name        = "${var.project_name}-${var.environment_name}-sg-bastion"
  description = "Allow SSH access to bastion"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${var.project_name}-${var.environment_name}-sg-bastion"
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }

  # Allow SSH from everywhere.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }

  # Allow outgoing to all (public + internal)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }
}

output "bastion_security_group_id" {
  value = "${aws_security_group.bastion.id}"
}

resource "aws_security_group" "blog" {
  name        = "${var.project_name}-${var.environment_name}-sg-blog"
  description = "Allow SSH access to blog"

  #description = "Allow SSH access from bastion and HTTP access from ALB to blog"
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${var.project_name}-${var.environment_name}-sg-blog"
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }

  # Allow SSH from bastion.
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]
  }

  # Allow access to HTTP directly.
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.blog-alb.id}"]
  }

  # NFS access (to use with AWS EFS)
  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    self      = true
  }

  # MySQL access
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    self      = true
  }

  # Allow outgoing to all (public + internal)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }
}

output "blog_security_group_id" {
  value = "${aws_security_group.blog.id}"
}

resource "aws_security_group" "blog-alb" {
  name        = "${var.project_name}-${var.environment_name}-sg-blog-alb"
  description = "Allow public access to blog ALB"
  vpc_id      = "${aws_vpc.vpc.id}"

  tags {
    Name      = "${var.project_name}-${var.environment_name}-sg-blog-alb"
    Project   = "${var.project_name}"
    Env       = "${var.environment_name}"
    Terraform = "true"
  }

  # Allow access to HTTPS.
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }

  # Allow outgoing to all (public + internal)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.default_destination_cidr}"]
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"
}

output "blog_alb_security_group_id" {
  value = "${aws_security_group.blog-alb.id}"
}
