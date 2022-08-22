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
