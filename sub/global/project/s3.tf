/* Create a bucket for IAC state this is global resource */

resource "aws_s3_bucket" "project-state" {
  bucket = "${var.project_name}-state"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name         = "${var.project_name}-state"
    Environment  = "${var.project_environment}"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "project-state" {
  value = "${aws_s3_bucket.project-state.id}"
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "${var.project_name}-cloudtrail"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name         = "${var.project_name}-cloudtrail"
    Environment  = "${var.project_environment}"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "cloudtrail" {
  value = "${aws_s3_bucket.cloudtrail.id}"
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = "${aws_s3_bucket.cloudtrail.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20131101",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.cloudtrail.id}"
        },
        {
            "Sid": "AWSCloudTrailWrite20131101",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::${aws_s3_bucket.cloudtrail.id}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
EOF
}

resource "aws_s3_bucket" "project-devops" {
  bucket = "${var.project_name}-devops"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags {
    Name         = "${var.project_name}-devops"
    Environment  = "${var.project_environment}"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "project-devops" {
  value = "${aws_s3_bucket.project-devops.id}"
}

#ELB/ALB Access log bucket
data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_access_log_s3_bucket" {
  bucket = "${var.project_name}-logs"
  acl    = "private"

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${var.project_name}-logs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  versioning {
    enabled = false
  }

  /*
                  server_side_encryption_configuration {
                    rule {
                      apply_server_side_encryption_by_default {
                        sse_algorithm = "None"
                      }
                    }
                  }
                */
  tags {
    Name         = "${var.project_name}-logs"
    Environment  = "${var.project_environment}"
    BusinessUnit = "${var.tag_BusinessUnit}"
    Creator      = "${var.tag_Creator}"
    Stack        = "${var.tag_Stack}"
    TechTeam     = "${var.tag_TechTeam}"
  }
}

output "elb_access_log_s3_bucket" {
  value = "${aws_s3_bucket.elb_access_log_s3_bucket.id}"
}
