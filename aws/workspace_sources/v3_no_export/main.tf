terraform {
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
