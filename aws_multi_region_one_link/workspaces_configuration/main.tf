terraform {
  backend "remote" {
    hostname     = "" # ENTER HOSTNAME
    organization = "env-v0ntua2h2kk2sbiae"
    token        = "." # ENTER TOKEN
    workspaces {
      name = "agent-test"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}
provider "aws" {
    alias = "east2"
    region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
    bucket = "my-tf-test-bucket12341234"
}
resource "aws_s3_bucket" "example2" {
    provider = aws.east2
    bucket = "my-tf-test-bucket1234333234r12342134"
}

resource "null_resource" "create_bucket_cli" {
    triggers = {
        bucket_name = "fromcli234123412341243"
    }
    provisioner "local-exec" {
        command = "aws s3api create-bucket --bucket fromcli234123412341243"
    }
    provisioner "local-exec" {
        when    = destroy
        command = "aws s3api delete-bucket --bucket fromcli234123412341243"
    }
}

