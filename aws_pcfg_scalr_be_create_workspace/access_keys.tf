# ------------- create aws user that has permission to create and delete s3://<bucket_name>/obj3 (obj4) --------------

resource "aws_iam_user" "access_keys_test" {
  name = "scal_aws_pcfg_access_keys_test"
}

resource "aws_iam_access_key" "access_keys_test" {
  user = aws_iam_user.access_keys_test.name
}

resource "aws_iam_user_policy" "ak" {
  name = "allow_crud_obj3_obj4"
  user = aws_iam_user.access_keys_test.name

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
        "Resource" : ["arn:aws:s3:::${var.bucket_name}/obj3", "arn:aws:s3:::${var.bucket_name}/obj4"]
      }
    ]
  })
}

# ------------- provider configuration --------------
resource "scalr_provider_configuration" "ak" {
  name                   = "aws_obj3_obj4"
  account_id             = var.account_id
  export_shell_variables = false
  environments           = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = aws_iam_access_key.access_keys_test.id
    secret_key       = aws_iam_access_key.access_keys_test.secret
  }
  depends_on = [
    aws_iam_user_policy.ak
  ]
}

# -------------------------- workspaces with aws access keys credential type, have access to obj3, obj4
# ------- ws with aws provider v3, should create obj3
resource "scalr_workspace" "ak_v3" {
  name              = "workspace-pcfg-ak_v3"
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
    id = scalr_provider_configuration.ak.id
  }
}
resource "scalr_variable" "object_name_ak_v3" {
  key            = "object_name"
  value          = "obj3"
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.ak_v3.id
}
resource "scalr_variable" "bucket_name_ak_v3" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.ak_v3.id
}
# ------- ws with aws provider v4, should create obj4
resource "scalr_workspace" "ak_v4" {
  name              = "workspace-pcfg-ak_v4"
  environment_id    = scalr_environment.test.id
  auto_apply        = false
  operations        = false
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  working_directory = "ws_aws_v4"
  vcs_repo {
    identifier = "DayS1eeper/scalr_terraform_provider_configuration_samples"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.ak.id
  }
}
resource "scalr_variable" "object_name_ak_v4" {
  key            = "object_name"
  value          = "obj4"
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.ak_v4.id
}
resource "scalr_variable" "bucket_name_ak_v4" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.ak_v4.id
}
