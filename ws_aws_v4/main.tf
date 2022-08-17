terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.22"
    }
  }
}

variable "bucket_name" {
  type = string
}


# for role_delegation test
provider "aws" {
  alias  = "role_delegation"
  region = "us-east-1"
}

variable "aws_v4_object_role_delegation" {
  type = string
}

resource "aws_s3_bucket_object" "role_delegation" {
  provider = aws.role_delegation
  bucket   = var.bucket_name
  key      = var.aws_v4_object_role_delegation
  content  = "aws_v4_object_role_delegation content"
}

# for AwsTrustedEntityType=aws_service test
provider "aws" {
  alias  = "instance_profile"
  region = "us-east-1"
}

variable "aws_v4_object_instance_profile" {
  type = string
}

variable "create_instance_profile_resource" {
  type    = bool
  default = true
}

resource "aws_s3_bucket_object" "instance_profile" {
  count    = var.create_instance_profile_resource ? 1 : 0
  provider = aws.instance_profile
  bucket   = var.bucket_name
  key      = var.aws_v4_object_instance_profile
  content  = "aws_v4_object_instance_profile content"
}

# for access keys test
provider "aws" {
  alias  = "access_keys"
  region = "us-east-1"
}

variable "aws_v4_object_access_keys" {
  type = string
}

resource "aws_s3_bucket_object" "access_keys" {
  provider = aws.access_keys
  bucket   = var.bucket_name
  key      = var.aws_v4_object_access_keys
  content  = "aws_v4_object_access_keys content"
}

# FOR export_shell_variables test
provider "aws" {
  region = "us-east-1"
}

variable "aws_v4_object_export_shell_variables" {
  type = string
}

resource "null_resource" "export_shell_variables" {
  triggers = {
    obj_name    = var.aws_v4_object_export_shell_variables
    bucket_name = var.bucket_name
  }

  provisioner "local-exec" {
    command = "echo 'aws_v4_object_export_shell_variables content' >> obj.txt && aws s3 cp obj.txt s3://${var.bucket_name}/${var.aws_v4_object_export_shell_variables}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.triggers.bucket_name}/${self.triggers.obj_name}"
  }
}