resource "null_resource" "download_agent_deb" {
  provisioner "local-exec" {
    command = "gsutil cp ${var.package_url} agent.deb"
  }
}

data "aws_ami" "ubuntu" {

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name

  tags = {
    Name = "aws_pcfg_test"
  }
}
