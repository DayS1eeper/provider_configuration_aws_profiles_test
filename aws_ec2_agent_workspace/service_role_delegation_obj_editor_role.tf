resource "random_string" "external_id" {
  length  = 10
  special = false
}

resource "aws_iam_role" "object_editor" {
  name = "scal_aws_pcfg_role_delegation_test_object_editor"
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

resource "aws_iam_role_policy" "object_editor" {
  name = "allow_crud_obj1_obj2"
  role = aws_iam_role.object_editor.id

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
