//Create default key pair for the VPC so that all instance shoudl have this key pair
resource "aws_key_pair" "devops" {
  key_name   = "${var.key_pair_name}"
  public_key = "${var.public_key}"
}
