# Runs must be success

module "pcfg_v4_no_agent_aws_account_creds" {
  source      = "./modules/aws-account-entity-credentials"
  bucket_name = var.bucket_name
  test_name   = "v4_no_agent_all"
  creds_name  = "aws_account"
}

resource "scalr_provider_configuration" "v4_no_agent_aws_account" {
  name         = "v4_no_agent_aws_account"
  account_id   = var.account_id
  environments = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = module.pcfg_v4_no_agent_aws_account_creds.access_key_id
    secret_key       = module.pcfg_v4_no_agent_aws_account_creds.secret_access_key
  }
}

module "pcfg_v4_no_agent_export_shell_variables_creds" {
  source      = "./modules/aws-account-entity-credentials"
  bucket_name = var.bucket_name
  test_name   = "v4_no_agent_all"
  creds_name  = "export_shell_variables"
}

resource "scalr_provider_configuration" "v4_no_agent_export_shell_variables" {
  name                   = "v4_no_agent_export_shell_variables"
  account_id             = var.account_id
  environments           = ["*"]
  export_shell_variables = true
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = module.pcfg_v4_no_agent_export_shell_variables_creds.access_key_id
    secret_key       = module.pcfg_v4_no_agent_export_shell_variables_creds.secret_access_key
  }
}

module "workspace_v4_no_agent" {
  source            = "./modules/scalr-workspace"
  test_name         = "v4_no_agent"
  environment_id    = scalr_environment.test.id
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  working_directory = "aws/workspace_sources/v4_no_aws_service_creds"
  bucket_name       = var.bucket_name
  provider_configurations = [
    {
      id                   = scalr_provider_configuration.v4_no_agent_aws_account.id,
      alias                = "aws_account",
      variable_object_name = "object_aws_account",
      object_to_create     = module.pcfg_v4_no_agent_aws_account_creds.object_path,
    },
    {
      id                   = scalr_provider_configuration.v4_no_agent_export_shell_variables.id,
      alias                = "",
      variable_object_name = "object_export_shell_variables",
      object_to_create     = module.pcfg_v4_no_agent_export_shell_variables_creds.object_path,
    },
  ]
}
