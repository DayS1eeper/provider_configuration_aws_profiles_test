resource "aws_iam_user" "export_shell_vars" {
  name = "scal_aws_pcfg_access_keys_test"
}

resource "aws_iam_access_key" "export_shell_vars" {
  user = aws_iam_user.export_shell_vars.name
}

resource "aws_iam_user_policy" "ak" {
  name = "allow_crud_obj3_obj4"
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
        "Resource" : ["arn:aws:s3:::${var.bucket_name}/obj3", "arn:aws:s3:::${var.bucket_name}/obj4"]
      }
    ]
  })
}
