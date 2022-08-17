resource "aws_iam_user" "export_shell_vars" {
  name = "scal_aws_pcfg_export_shell_vars_test"
}

resource "aws_iam_access_key" "export_shell_vars" {
  user = aws_iam_user.export_shell_vars.name
}

resource "aws_iam_user_policy" "export_shell_vars" {
  name = "allow_crud_export_shell_vars"
  user = aws_iam_user.export_shell_vars.name

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
        "Resource" : [
          "arn:aws:s3:::${var.bucket_name}/${var.obj_export_shell_vars_v3}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_export_shell_vars_v4}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_export_shell_vars_v3_agent}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_export_shell_vars_v4_agent}",
        ]
      }
    ]
  })
}

resource "scalr_provider_configuration" "export_shell_vars" {
  name                   = "export_shell_vars"
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
