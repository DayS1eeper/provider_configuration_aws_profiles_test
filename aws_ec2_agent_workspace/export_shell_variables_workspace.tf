resource "scalr_agent_pool" "agent_export_shell_vars_test" {
  name           = "agent_export_shell_vars_test"
  account_id     = var.account_id
  environment_id = scalr_environment.test.id
}
resource "scalr_agent_pool_token" "agent_export_shell_vars_test" {
  description   = "Agent token used in ec2 agent"
  agent_pool_id = scalr_agent_pool.agent_export_shell_vars_test.id
}

resource "scalr_provider_configuration" "export_shell_variables" {
  name                   = "aws_obj3_obj4"
  account_id             = var.account_id
  export_shell_variables = true
  environments           = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = aws_iam_access_key.export_shell_vars.id
    secret_key       = aws_iam_access_key.export_shell_vars.secret
  }
}
resource "scalr_workspace" "agent_export_shell_vars_test" {
  name              = "agent_export_shell_vars_test"
  environment_id    = scalr_environment.test.id
  auto_apply        = false
  operations        = false
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  agent_pool_id     = scalr_agent_pool.agent_export_shell_vars_test.id
  working_directory = "ws_aws_export_shell_vars"
  vcs_repo {
    identifier = "DayS1eeper/scalr_terraform_provider_configuration_samples"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.export_shell_variables.id
  }
}
resource "scalr_variable" "object_name_export_shell_vars_test" {
  key            = "object_name"
  value          = "obj3"
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.agent_export_shell_vars_test.id
}
resource "scalr_variable" "bucket_name_export_shell_vars_test" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.agent_export_shell_vars_test.id
}
