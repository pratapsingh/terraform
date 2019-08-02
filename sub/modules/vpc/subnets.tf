// Subnets with public IP address
resource "aws_subnet" "public-subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  count                   = "${var.pub_subnet_count}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, var.newbits, count.index)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name         = "${var.project_name}-${var.environment_name}-public-subnet-${count.index}${element(split(",", var.azs), count.index % 2 )}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public-subnet.*.id}"]
}

output "pub-subnet-ids" {
  value = "${join(",", aws_subnet.public-subnet.*.id)}"
}

output "public_subnet_cidr_blocks" {
  value = ["${aws_subnet.public-subnet.*.cidr_block}"]
}

//Allow public subnet to connect to internt
resource "aws_route_table_association" "public" {
  count     = "${var.pub_subnet_count}"
  subnet_id = "${element(aws_subnet.public-subnet.*.id, count.index)}"

  //  route_table_id = "${aws_vpc.vpc.public_route_table_id}"
  route_table_id = "${aws_route_table.public_route.id}"

  lifecycle {
    create_before_destroy = true
  }
}

// Subnets with no internet access (incoming or outgoing)
resource "aws_subnet" "private-subnet" {
  vpc_id = "${aws_vpc.vpc.id}"

  count                   = "${var.priv_subnet_count}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, var.newbits, count.index + length(var.availability_zones))}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags = {
    Name         = "${var.project_name}-${var.environment_name}-private-subnet-${count.index}${element(split(",", var.azs), count.index % 2 )}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private-subnet.*.id}"]
}

output "private_subnet_cidr_blocks" {
  value = ["${aws_subnet.private-subnet.*.cidr_block}"]
}

// Subnets with outgoing internet access via NAT gateway.
resource "aws_subnet" "protected_subnets" {
  vpc_id = "${aws_vpc.vpc.id}"

  count                   = "${var.prot_subnet_count}"
  cidr_block              = "${cidrsubnet(var.vpc_cidr, var.newbits, count.index + 2 * length(var.availability_zones) + 2)}"
  availability_zone       = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = false

  tags = {
    Name         = "${var.project_name}-${var.environment_name}-protected-subnet-${count.index}${element(split(",", var.azs), count.index % 2 )}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

# Allow internet routes from protected subnets using NAT gateway
resource "aws_route_table_association" "app_subnet_route" {
  count          = "${var.prot_subnet_count}"
  subnet_id      = "${element(aws_subnet.protected_subnets.*.id, count.index)}"
  route_table_id = "${element(split(",", var.nat_gateway_ids), count.index)}"
  count          = "${length(var.availability_zones)}"
}

output "protected_subnet_ids" {
  value = ["${aws_subnet.protected_subnets.*.id}"]
}

output "protected_subnet_cidr_blocks" {
  value = ["${aws_subnet.protected_subnets.*.cidr_block}"]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags = {
    Name         = "${var.project_name}-${var.environment_name}-igw"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "internet_gateway_id" {
  value = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "${var.igw_default_destination_cidr}"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
  }

  tags {
    Name         = "${var.project_name}-${var.environment_name}-public-route-table"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

#Add route to public route table 
resource "aws_route" "public_route" {
  route_table_id         = "${aws_route_table.public_route.id}"
  destination_cidr_block = "${var.default_static_vpn_route_cidr}"
  gateway_id             = "${var.vpn_gateway_id}"
}

//Create tag for default network acl
resource "aws_default_network_acl" "default" {
  default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name         = "${var.project_name}-${var.environment_name}-default-acl"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

//Adding tags to default route tables
resource "aws_default_route_table" "default_route" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name         = "default-do-not-use"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}
