variable "peer_src_vpc_id" {
  type = "string"

  description = "The VPC to peer from."
}

variable "peer_src_route_tables" {
  type = "list"

  description = "List of route tables from the peer_src VPC"
}

variable "peer_dst_vpc_id" {
  type = "string"

  description = "The VPC ID to peer to."
}

variable "peer_dst_route_tables" {
  type = "list"

  description = "List of route tables from the peer to VPC."
}

variable "auto_accept" {
  type = "string"

  description = "Specify whether or not connections should be automatically accepted"

  default = true
}

variable "peer_src_vpc_region" {
  type = "string"

  description = "Region of the source VPC"
}

variable "peer_dst_vpc_region" {
  type = "string"

  description = "Region of the destination VPC"
}

variable create_peering_connection {
  type = "string"

  description = "Whether or not to make the connection, can set to false to remove peering connection"

  default = true
}

variable "dst_in_same_account" {
  type = "string"

  description = "Whether or not the destination VPC is in the same account (skip destination route tables if so)"

  default = false
}
