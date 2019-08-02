// EIP to be used for NAT Gateway.
resource "aws_eip" "nat_eip" {
  vpc   = true
  count = "${length(split(",", var.azs))}" # Comment out count to only have 1 NAT

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name         = "${var.project_name}-${var.environment_name}-nat-eip-${count.index+1}${element(split(",", var.azs), count.index % 2 )}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    Role         = "nat"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  #  allocation_id = "${aws_eip.nat_eip.id}"                  # Comment out count to only have 1 NAT
  #  subnet_id     = "${aws_subnet.public-subnet.*.id[0]}"    # Comment out count to only have 1 NAT 
  count = "${length(split(",", var.azs))}" # Comment out count to only have multiple NAT

  allocation_id = "${element(aws_eip.nat_eip.*.id, count.index)}"           # Comment out count to only have  NAT per az 
  subnet_id     = "${element(split(",", var.pub-subnet-ids), count.index)}" # Comment out count to only have NAT per az

  tags {
    Name         = "${var.project_name}-${var.environment_name}-nat-${count.index+1}${element(split(",", var.azs), count.index % 2 )}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    Role         = "nat"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }

  depends_on = ["aws_internet_gateway.internet_gateway"]
}

# NAT Route Table
resource "aws_route_table" "nat_access" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "${length(split(",", var.azs))}"

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name         = "${var.project_name}-${var.environment_name}-nat-route-table-${count.index+1}${element(split(",", var.azs), count.index % 2 )}"
    Project      = "${var.project_name}"
    Env          = "${var.environment_name}"
    Terraform    = "true"
    Role         = "nat"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

# Allow complete access to internet (Private subnets)
resource "aws_route" "nat_access" {
  count                  = "${length(split(",", var.azs))}"
  route_table_id         = "${element(aws_route_table.nat_access.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat_gateway.*.id, count.index)}"
}

//Single nat output
//output "nat_cacheclusterid" {
//  value = "${aws_nat_gateway.nat_gateway.id}"
//}

//Multiple nat output
output "nat_cacheclusterid" {
  value = "${join(",", aws_nat_gateway.nat_gateway.*.id)}"
}

output "aws_route_nat_access_ids" {
  value = "${join(",", aws_route.nat_access.*.route_table_id)}"
}
