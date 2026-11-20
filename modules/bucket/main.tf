terraform {
  required_version = ">= 1.11"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40"
    }
  }
}

variable "bucket_name" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3-63 lowercase letters, numbers, dots, or hyphens, such as logs-dev-01."
  }
}

variable "expected_account_id" {
  description = "The account this bucket is allowed to live in."
  type        = string
}

variable "team" {
  type    = string
  default = "platform"
}

data "aws_caller_identity" "current" {}

# A stand-in for a slow child module that tests can skip.
module "tags" {
  source = "./modules/tags"
  team   = var.team
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = module.tags.tags

  lifecycle {
    precondition {
      condition     = provider::aws::arn_parse(data.aws_caller_identity.current.arn).account_id == var.expected_account_id
      error_message = "This configuration is running in the wrong AWS account."
    }
  }
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}

output "bucket_from_arn" {
  value = provider::aws::arn_parse(aws_s3_bucket.this.arn).resource
}
