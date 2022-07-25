resource "scalr_environment" "test" {
  name                    = "pcfg-agent-test"
  account_id              = var.account_id
  cost_estimation_enabled = false
}
data "scalr_vcs_provider" "test" {
  name       = "pcfg_test"
  account_id = var.account_id
}
resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = "aws_pcfg_test"
  }
}
