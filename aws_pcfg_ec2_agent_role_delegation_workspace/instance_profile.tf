resource "random_string" "external_id" {
  length  = 10
  special = false
}

resource "aws_iam_role" "role_delegation_agent_ec2" {
  name = "scal_aws_pcfg_role_delegation_test"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "role_delegation_agent_ec2" {
  name = "allow_crud_obj1_obj2"
  role = aws_iam_role.role_delegation_agent_ec2.id

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

resource "aws_iam_instance_profile" "ec2_agent" {
  name = "ec2_agent"
  role = aws_iam_role.role_delegation_agent_ec2.name
}
