# module "compute-web" {
#   source                   = "../../../modules/compute/common"
#   type                     = "web"
#   count                    = 2
#   env                      = "${var.env}"
#   ami_id                   = "${var.ami}"
#   instance_type            = "t2.micro"
#   instance_name            = "web-test"
#   team                     = "DevOps"
#   key_name                 = "${var.key_name}"
#   subnets                  = ["${split(",",data.terraform_remote_state.network.private-subnet-web-subnet-ids)}"]
#   security_groups          = ["${data.terraform_remote_state.network.sg-web-security-group-id}"]
#   availability_zone        = "ap-south-1a"
#   root_vol_size            = "10"
#   root_vol_type            = "standard"
#   log_vol_size             = "10"
#   log_vol_type             = "gp2"
#   app_vol_size             = "10"
#   app_vol_type             = "gp2"
# }
#
# output "compute-web-instance-id" { value = "${module.compute-web.instance-id}"}
# output "compute-web-public-ip" { value = "${module.compute-web.public-ip}"}

 module "compute-web" {
   source                   = "../../../modules/compute/common"
   type                     = "web"
   count                    = 1
   env                      = "${var.env}"
   ami_id                   = "${var.ami}"
   eip                      = true
   instance_type            = "t2.micro"
   instance_name            = "web-test"
   team                     = "DevOps"
   key_name                 = "${var.key_name}"
   subnets                  = ["${split(",",data.terraform_remote_state.network.public-subnet-subnet-ids)}"]
   security_groups          = ["${data.terraform_remote_state.network.sg-web-security-group-id}"]
   availability_zone        = "ap-south-1a"
   root_vol_size            = "10"
   root_vol_type            = "standard"
   log_vol_size             = "10"
   log_vol_type             = "gp2"
   app_vol_size             = "10"
   app_vol_type             = "gp2"
 }

 output "compute-web-instance-id" { value = "${module.compute-web.instance-id}"}
 output "compute-web-instance-public-ip" { value = "${module.compute-web.instance-public-ip}"}
 output "compute-web-elastic-public-ip" { value = "${module.compute-web.elastic-public-ip}"}
