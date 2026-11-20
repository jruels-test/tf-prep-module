# Runs with no AWS credentials. Realistic defaults keep arn_parse happy.
mock_provider "aws" {
  mock_resource "aws_s3_bucket" {
    defaults = {
      arn = "arn:aws:s3:::logs-dev-01"
    }
  }

  mock_data "aws_caller_identity" {
    defaults = {
      account_id = "111122223333"
      arn        = "arn:aws:iam::111122223333:role/deployer"
    }
  }
}

variables {
  bucket_name         = "logs-dev-01"
  expected_account_id = "111122223333"
}

run "bucket_name_round_trips" {
  assert {
    condition     = output.bucket_from_arn == "logs-dev-01"
    error_message = "The bucket name parsed from the ARN must match the input."
  }
}

run "rejects_wrong_account" {
  command = plan

  variables {
    expected_account_id = "999999999999"
  }

  expect_failures = [aws_s3_bucket.this]
}

run "rejects_bad_name" {
  command = plan

  variables {
    bucket_name = "Logs_Dev"
  }

  expect_failures = [var.bucket_name]
}
