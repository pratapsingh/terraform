variable "environment_name" {}
variable "name" {}

variable "alarm_actions" {
  type    = "list"
  default = ["arn:aws:sns:us-east-1:128959313907:windli-staging-alerts"]
}
