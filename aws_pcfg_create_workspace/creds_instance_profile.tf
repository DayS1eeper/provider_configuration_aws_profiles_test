resource "random_string" "instance_profile" {
  length  = 10
  special = false
}

resource "aws_iam_role" "instance_profile" {
  name = "scal_aws_pcfg_instance_profile"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect    = "Allow",
        Principal = { "AWS" : "${aws_iam_role.ec2_role.arn}" }
      },
    ]
  })
}

resource "aws_iam_role_policy" "instance_profile" {
  name = "allow_crud_instance_profile"
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
          "arn:aws:s3:::${var.bucket_name}/${var.obj_instance_profile_v3_agent}",
          "arn:aws:s3:::${var.bucket_name}/${var.obj_instance_profile_v4_agent}",
        ]
      },
    ]
  })
}

resource "scalr_provider_configuration" "instance_profile" {
  name         = "instance_profile"
  account_id   = var.account_id
  environments = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "role_delegation"
    role_arn         = aws_iam_role.instance_profile.arn
    # external_id         = random_string.external_id.id
    trusted_entity_type = "aws_service"
  }
  depends_on = [
    aws_iam_role_policy.instance_profile
  ]
}
