# ------------- create aws user that can assume role that has permission to create and delete s3://<bucket_name>/obj1 (obj2) --------------
resource "random_string" "external_id" {
  length  = 10
  special = false
}


resource "aws_iam_user" "role_delegation_test" {
  name = "scal_aws_pcfg_role_delegation_test"
}

resource "aws_iam_access_key" "role_delegation_test" {
  user = aws_iam_user.role_delegation_test.name
}

resource "aws_iam_role" "role_delegation_test" {
  name = "scal_aws_pcfg_role_delegation_test"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_user.role_delegation_test.arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = random_string.external_id.id
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "role_delegation_test" {
  name = "allow_crud_obj1_obj2"
  role = aws_iam_role.role_delegation_test.id

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
          "arn:aws:s3:::${var.bucket_name}/obj1",
          "arn:aws:s3:::${var.bucket_name}/obj2",
        ]
      },
    ]
  })
  provisioner "local-exec" {
    command = "sleep 3"
  }
}

# ------------- provider configuration --------------
resource "scalr_provider_configuration" "rd" {
  name                   = "aws_obj1_obj2"
  account_id             = var.account_id
  export_shell_variables = false
  environments           = ["*"]
  aws {
    account_type        = "regular"
    credentials_type    = "role_delegation"
    access_key          = aws_iam_access_key.role_delegation_test.id
    secret_key          = aws_iam_access_key.role_delegation_test.secret
    role_arn            = aws_iam_role.role_delegation_test.arn
    external_id         = random_string.external_id.id
    trusted_entity_type = "aws_account"
  }
  depends_on = [
    aws_iam_role_policy.role_delegation_test
  ]
}

# -------------------------- workspaces with aws role delegation, account entity type, have access to obj1, obj2
# ------- ws with aws provider v3, should create obj1
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
# ------- ws with aws provider v4, should create obj2
resource "scalr_workspace" "rd_v4" {
  name              = "workspace-pcfg-rd_v4"
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
    id = scalr_provider_configuration.rd.id
  }
}
resource "scalr_variable" "object_name_rd_v4" {
  key            = "object_name"
  value          = "obj2"
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.rd_v4.id
}
resource "scalr_variable" "bucket_name_rd_v4" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.rd_v4.id
}
