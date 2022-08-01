resource "scalr_environment" "test" {
  name                    = "pcfg-test"
  account_id              = var.account_id
  cost_estimation_enabled = false
  # default_provider_configuration = ["pcfg-1", "pcfg-2"]
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
