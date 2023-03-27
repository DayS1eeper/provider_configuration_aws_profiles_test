terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.io/scalr/scalr"
      version = "~> 1.0"
    }
  }
}

variable "account_id" {
  type    = string
  default = "acc-svrcncgh453bi8g"
}


variable "environment_id" {
  type    = string
  default = "env-svrcnchebt61e30"
}

resource "aws_iam_user" "pcfg_user" {
  name = "test_aws_access_keys_provider_configuration_iam_access"
}

resource "aws_iam_access_key" "pcfg_user" {
  user = aws_iam_user.pcfg_user.name
}

resource "aws_iam_user_policy" "pcfg_user" {
  name = "test_aws_access_keys_provider_configuration_iam_access"
  user = aws_iam_user.pcfg_user.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "iam:GetUser",
        ],
        "Effect" : "Allow",
        "Resource" : [
          aws_iam_user.pcfg_user.arn,
        ]
      }
    ]
  })
}


resource "scalr_provider_configuration" "aws_acces_keyss_with_export" {
  name                   = "aws_access_keys_with_export"
  account_id             = var.account_id
  environments           = ["*"]
  export_shell_variables = true
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = aws_iam_access_key.pcfg_user.id
    secret_key       = aws_iam_access_key.pcfg_user.secret
  }
}

resource "scalr_workspace" "workspace" {
  name           = "test_aws_access_keys_pcfg_iam_access"
  environment_id = var.environment_id

  provider_configuration {
    id = scalr_provider_configuration.aws_acces_keyss_with_export.id
  }
}

output "ws" {
  value = scalr_workspace.workspace.id
}