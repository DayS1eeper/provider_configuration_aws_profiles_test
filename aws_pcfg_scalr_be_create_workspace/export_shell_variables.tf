# ------------- create aws user that has permission to create and delete s3://<bucket_name>/obj5 --------------

resource "aws_iam_user" "export_shell_variables" {
  name = "scal_aws_pcfg_export_shell_variables_test"
}

resource "aws_iam_access_key" "export_shell_variables" {
  user = aws_iam_user.export_shell_variables.name
}

resource "aws_iam_user_policy" "export_shell_variables" {
  name = "allow_crud_obj5"
  user = aws_iam_user.export_shell_variables.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectAttributes",
          "s3:GetObjectTagging"
        ],
        "Effect" : "Allow",
        "Resource" : ["arn:aws:s3:::${var.bucket_name}/obj5"]
      }
    ]
  })
}

# ------------- provider configuration --------------
resource "scalr_provider_configuration" "export_shell_variables" {
  name                   = "aws_obj5"
  account_id             = var.account_id
  export_shell_variables = true
  environments           = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = aws_iam_access_key.export_shell_variables.id
    secret_key       = aws_iam_access_key.export_shell_variables.secret
  }
  depends_on = [
    aws_iam_user_policy.ak
  ]
}

# -------------------------- workspace with export shell variables, have access to obj5
resource "scalr_workspace" "export_shell_variables" {
  name              = "export_shell_variables"
  environment_id    = scalr_environment.test.id
  auto_apply        = false
  operations        = false
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  working_directory = "ws_aws_export_shell_vars"
  vcs_repo {
    identifier = "DayS1eeper/scalr_terraform_provider_configuration_samples"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.export_shell_variables.id
  }
}
resource "scalr_variable" "object_name_export_shell_variables" {
  key            = "object_name"
  value          = "obj5"
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.export_shell_variables.id
}
resource "scalr_variable" "bucket_name_export_shell_variables" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.export_shell_variables.id
}
