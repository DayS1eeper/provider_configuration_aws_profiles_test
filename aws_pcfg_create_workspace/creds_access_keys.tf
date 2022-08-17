resource "aws_iam_user" "access_keys" {
  name = "scal_aws_pcfg_access_keys_test"
}

resource "aws_iam_access_key" "access_keys" {
  user = aws_iam_user.access_keys.name
}

resource "aws_iam_user_policy" "access_keys" {
  name = "allow_crud_access_keys"
  user = aws_iam_user.access_keys.name

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
          "arn:aws:s3:::${var.bucket_name}/${var.obj_access_keys_v3}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_access_keys_v4}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_access_keys_v3_agent}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_access_keys_v4_agent}",
        ]
      }
    ]
  })
}


resource "scalr_provider_configuration" "access_keys" {
  name         = "access_keys"
  account_id   = var.account_id
  environments = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = aws_iam_access_key.access_keys.id
    secret_key       = aws_iam_access_key.access_keys.secret
  }
}
