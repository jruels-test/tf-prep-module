mock_provider "aws" {}

# Skip the child module entirely and supply its outputs.
override_module {
  target = module.tags
  outputs = {
    tags = { team = "test", managed_by = "terraform" }
  }
}

override_data {
  target = data.aws_caller_identity.current
  values = {
    arn = "arn:aws:iam::111122223333:role/deployer"
  }
}

variables {
  bucket_name         = "logs-dev-01"
  expected_account_id = "111122223333"
}

run "plan_sees_overridden_arn" {
  command = plan

  override_resource {
    target          = aws_s3_bucket.this
    override_during = plan
    values = {
      arn = "arn:aws:s3:::logs-dev-01"
    }
  }

  assert {
    condition     = output.bucket_from_arn == "logs-dev-01"
    error_message = "With override_during = plan, the ARN is known at plan."
  }

  assert {
    condition     = aws_s3_bucket.this.tags["team"] == "test"
    error_message = "Tags must come from the overridden module."
  }
}
