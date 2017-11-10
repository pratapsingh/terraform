module "compute-web" {
   source                        = "../../../modules/compute/openvpn"
   type                          = "openvpn"
   server_count                  = 1
   env                           = "${var.env}"
   ami_id                        = "${var.ami}"
   eip                           = true
   instance_type                 = "t2.micro"
   instance_name                 = "openvpn"
   team                          = "DevOps"
   iam_role                      = "production-openvpn-server-role"
   key_name                      = "${var.key_name}"
   subnets                       = ["${split(",",data.terraform_remote_state.mgmt-network.public-subnet-subnet-ids)}"]
   security_groups               = ["${data.terraform_remote_state.mgmt-network.sg-openvpn-security-group-id}","${data.terraform_remote_state.mgmt-network.sg-ssh-security-group-id}"]
   root_vol_size                 = "40"
   root_vol_type                 = "standard"
   zone_id                       = "${data.terraform_remote_state.mgmt-network.hosted-zone-id}"
   zone_name                     = "${data.terraform_remote_state.mgmt-network.hosted-zone-name}"
 }

 output "compute-web-instance-id" { value = "${module.compute-web.instance-id}"}
 output "compute-web-instance-public-ip" { value = "${module.compute-web.instance-public-ip}"}
 output "compute-web-instance-private-fqdn" { value = "${module.compute-web.instance-private-fqdn}"}
 output "compute-web-elastic-public-ip" { value = "${module.compute-web.elastic-public-ip}"}
