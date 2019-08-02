provider "aws" {
  region = "${var.region}"
}

// Data source to get current AWS account details.
// @see: https://www.terraform.io/docs/providers/aws/d/caller_identity.html
data "aws_caller_identity" "current" {}

/**
 * Password Policy for IAM users of this AWS account.
 *
 * @see: https://www.terraform.io/docs/providers/aws/r/iam_account_password_policy.html
 * @see: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_passwords_account-policy.html
 */
resource "aws_iam_account_password_policy" "project" {
  minimum_password_length        = 12
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  max_password_age               = 90
  password_reuse_prevention      = 5
  hard_expiry                    = false
}

/**
 * CloudTrail setup for all AWS regions (current & future).
 *
 * @see: https://www.terraform.io/docs/providers/aws/r/cloudtrail.html
 * @see: https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html
 */
resource "aws_cloudtrail" "default" {
  name                       = "Default"
  s3_bucket_name             = "${var.project_name}-cloudtrail"
  is_multi_region_trail      = true
  enable_log_file_validation = true
  depends_on                 = ["aws_s3_bucket_policy.cloudtrail"]
}

/**
 * CloudWatch Billing alarms to monitor AWS charges using Amazon CloudWatch.
 *
 * @see: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html
 */
module "billing_alerts" {
  source = "../../modules/cloudwatch/billing"
}
