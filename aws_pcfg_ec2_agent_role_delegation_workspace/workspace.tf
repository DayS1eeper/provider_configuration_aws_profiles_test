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
resource "scalr_provider_configuration" "rd" {
  name                   = "aws_obj1_obj2"
  account_id             = var.account_id
  export_shell_variables = false
  environments           = ["*"]
  aws {
    account_type        = "regular"
    credentials_type    = "role_delegation"
    role_arn            = aws_iam_role.role_delegation_agent_ec2.arn
    external_id         = random_string.external_id.id
    trusted_entity_type = "aws_service"
  }
  depends_on = [
    aws_iam_role_policy.role_delegation_agent_ec2
  ]
}
resource "scalr_workspace" "rd_v3" {
  name              = "workspace-pcfg-rd_v3"
  environment_id    = scalr_environment.test.id
  auto_apply        = false
  operations        = false
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  working_directory = "ws_aws_v3"
  vcs_repo {
    identifier = "DayS1eeper/scalr_terraform_provider_configuration_samples"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.rd.id
  }
}
resource "scalr_variable" "object_name_rd_v3" {
  key            = "object_name"
  value          = "obj1"
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.rd_v3.id
}
resource "scalr_variable" "bucket_name_rd_v3" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.rd_v3.id
}
resource "scalr_agent_pool" "default" {
  name           = "default-pool"
  account_id     = var.account_id
  environment_id = scalr_environment.test.id
}
resource "scalr_agent_pool_token" "default" {
  description   = "Agent token used in ec2 agent"
  agent_pool_id = scalr_agent_pool.default.id
}