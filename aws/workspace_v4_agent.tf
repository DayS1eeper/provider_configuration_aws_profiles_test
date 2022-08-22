# Runs must be success

module "pcfg_v4_agent_aws_account_creds" {
  source      = "./modules/aws-account-entity-credentials"
  bucket_name = var.bucket_name
  test_name   = "v4_agent_all"
  creds_name  = "aws_account"
}

resource "scalr_provider_configuration" "v4_agent_aws_account" {
  name         = "v4_agent_aws_account"
  account_id   = var.account_id
  environments = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = module.pcfg_v4_agent_aws_account_creds.access_key_id
    secret_key       = module.pcfg_v4_agent_aws_account_creds.secret_access_key
  }
}

module "pcfg_v4_agent_export_shell_variables_creds" {
  source      = "./modules/aws-account-entity-credentials"
  bucket_name = var.bucket_name
  test_name   = "v4_agent_all"
  creds_name  = "export_shell_variables"
}

resource "scalr_provider_configuration" "v4_agent_export_shell_variables" {
  name                   = "v4_agent_export_shell_variables"
  account_id             = var.account_id
  environments           = ["*"]
  export_shell_variables = true
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = module.pcfg_v4_agent_export_shell_variables_creds.access_key_id
    secret_key       = module.pcfg_v4_agent_export_shell_variables_creds.secret_access_key
  }
}

resource "aws_iam_role_policy" "v4_agent_aws_service" {
  name = "pcfg_test_v4_agent_object"
  role = aws_iam_role.instance_profile.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectAttributes",
          "s3:GetObjectTagging"
        ]
        Effect = "Allow",
        Resource = [
          "arn:aws:s3:::${var.bucket_name}/v4_agent_all/aws_service",
        ]
      },
    ]
  })
}

resource "scalr_provider_configuration" "v4_agent_aws_service" {
  name         = "v4_agent_instance_profile"
  account_id   = var.account_id
  environments = ["*"]
  aws {
    account_type        = "regular"
    credentials_type    = "role_delegation"
    role_arn            = aws_iam_role.instance_profile.arn
    trusted_entity_type = "aws_service"
  }
  depends_on = [
    aws_iam_role_policy.v4_agent_aws_service
  ]
}

module "workspace_v4_agent" {
  source            = "./modules/scalr-workspace"
  test_name         = "v4_agent"
  agent_pool_id     = scalr_agent_pool.agent_pool.id
  environment_id    = scalr_environment.test.id
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  working_directory = "aws/workspace_sources/v3_all"
  bucket_name       = var.bucket_name
  provider_configurations = [
    {
      id                   = scalr_provider_configuration.v4_agent_aws_account.id,
      alias                = "aws_account",
      object_to_create_key = module.pcfg_v4_agent_aws_account_creds.object_path,
    },
    {
      id                   = scalr_provider_configuration.v4_agent_export_shell_variables.id,
      alias                = "export_shell_variables",
      object_to_create_key = module.pcfg_v4_agent_export_shell_variables_creds.object_path,
    },
    {
      id                   = scalr_provider_configuration.v4_agent_aws_service.id,
      alias                = "aws_service",
      object_to_create_key = "v4_agent_all/aws_service",
    },
  ]
}
