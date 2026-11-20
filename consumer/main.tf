# Replace OWNER/REPO with your repository, and the ref with your release tag.
module "bucket" {
  source              = "git::https://github.com/OWNER/REPO.git//modules/bucket?ref=v0.2.0"
  bucket_name         = "logs-consumer-01"
  expected_account_id = "111122223333"
}
