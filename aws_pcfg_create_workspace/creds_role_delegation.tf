resource "random_string" "role_delegation" {
  length  = 10
  special = false
}

resource "aws_iam_user" "role_delegation" {
  name = "scal_aws_pcfg_role_delegation_test"
}

resource "aws_iam_access_key" "role_delegation" {
  user = aws_iam_user.role_delegation.name
}

resource "aws_iam_role" "role_delegation" {
  name = "scal_aws_pcfg_role_delegation"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect    = "Allow",
        Principal = { "AWS" : "${aws_iam_user.role_delegation.arn}" },
        Condition = {
          "StringEquals" : {
            "sts:ExternalId" : "${random_string.role_delegation.id}"
          }
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "role_delegation" {
  name = "allow_crud_role_delegation"
  role = aws_iam_role.role_delegation.id

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
          "arn:aws:s3:::${var.bucket_name}/${var.obj_role_delegation_v3}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_role_delegation_v4}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_role_delegation_v3_agent}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_role_delegation_v4_agent}",
        ]
      },
    ]
  })
}

resource "scalr_provider_configuration" "role_delegation" {
  name         = "role_delegation"
  account_id   = var.account_id
  environments = ["*"]
  aws {
    account_type        = "regular"
    credentials_type    = "role_delegation"
    access_key          = aws_iam_access_key.role_delegation.id
    secret_key          = aws_iam_access_key.role_delegation.secret
    role_arn            = aws_iam_role.role_delegation.arn
    external_id         = random_string.role_delegation.id
    trusted_entity_type = "aws_account"
  }
  depends_on = [
    aws_iam_role_policy.role_delegation
  ]
}
