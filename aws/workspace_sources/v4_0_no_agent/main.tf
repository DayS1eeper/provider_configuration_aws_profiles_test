terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }
}

variable "bucket_name" {
  type = string
}

# for aws_account entity type
provider "aws" {
  alias  = "aws_account"
  region = "us-east-1"
}

variable "object_aws_account" {
  type = string
}

resource "aws_s3_bucket_object" "aws_account" {
  provider = aws.aws_account
  bucket   = var.bucket_name
  key      = var.object_aws_account
  content  = "object_aws_account content"
}

# for export_shell_variables=true
variable "object_export_shell_variables" {
  type = string
}
module "export_shell_variables" {
  source      = "../modules/s3_obj_export_shell_variables"
  object_path = var.object_export_shell_variables
  bucket_name = var.bucket_name
}