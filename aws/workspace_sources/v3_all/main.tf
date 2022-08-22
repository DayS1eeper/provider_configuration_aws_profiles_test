terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.55.0"
    }
  }
}

variable "bucket_name" {
  type = string
}

# for aws_service entity type
provider "aws" {
  alias  = "aws_service"
  region = "us-east-1"
}

variable "object_aws_service" {
  type = string
}

resource "aws_s3_bucket_object" "aws_service" {
  provider = aws.aws_service
  bucket   = var.bucket_name
  key      = var.object_aws_service
  content  = "object_aws_service content"
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
variable "export_shell_variables_object_path" {
  type = string
}
module "export_shell_variables" {
  source      = "../modules/s3_obj_export_shell_variables"
  object_path = var.export_shell_variables_object_path
  bucket_name = var.bucket_name
}