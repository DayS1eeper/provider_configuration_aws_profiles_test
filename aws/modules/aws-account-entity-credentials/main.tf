locals {
  common_name = "scalr_aws_pcfg_test_${var.test_name}_${var.creds_name}"
  object_path = "${var.bucket_name}/${var.test_name}/${var.creds_name}"
}

resource "aws_iam_user" "access_keys" {
  name = local.common_name
}

resource "aws_iam_access_key" "access_keys" {
  user = aws_iam_user.access_keys.name
}

resource "aws_iam_user_policy" "access_keys" {
  name = local.common_name
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
          "arn:aws:s3:::${local.object_path}",
        ]
      }
    ]
  })
}
