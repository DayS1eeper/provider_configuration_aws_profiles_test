terraform {
  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-develop"
    }
  }
}

resource "scalr_workspace" "workspace" {
  name           = "agent-test"
  environment_id = var.env_id
  auto_apply     = true
  agent_pool_id  = scalr_agent_pool.agent_pool.id
  provider_configuration {
    id = scalr_provider_configuration.this.id
  }
}

resource "aws_iam_user" "this" {
  name = "scalr-pcfg-test"
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "bucketAdm"
  users      = [aws_iam_user.this.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}



resource "scalr_provider_configuration" "this" {
  name         = "aws_pcfg"
  account_id   = var.account_id
  environments = ["*"]
  aws {
    account_type     = "regular"
    credentials_type = "access_keys"
    access_key       = aws_iam_access_key.this.id
    secret_key       = aws_iam_access_key.this.secret
  }
}


resource "scalr_agent_pool" "agent_pool" {
  name           = "pcfg_test"
  account_id     = var.account_id
  environment_id = var.env_id
}


resource "scalr_agent_pool_token" "agent_token" {
  description   = "Agent token used in ec2 agent"
  agent_pool_id = scalr_agent_pool.agent_pool.id
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

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    self        = false
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "linux-key-pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ${aws_key_pair.key_pair.key_name}.pem"
  }
}

resource "null_resource" "download_agent_deb" {
    triggers = {
        package_url = var.package_url
    }
    provisioner "local-exec" {
        command = "gsutil cp ${var.package_url} agent.deb"
    }
    provisioner "local-exec" {
        when    = "destroy"
        command = "rm agent.deb"
    }
}

resource "aws_instance" "agent_instance" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.ubuntu.id
  vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
  key_name               = aws_key_pair.key_pair.key_name
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.key_pair.private_key_pem
  }

  provisioner "file" {
    source      = "${abspath(path.root)}/agent.deb"
    destination = "/tmp/agent.deb"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install awscli -y -qq",
      "sudo dpkg -i /tmp/agent.deb",
      "sudo scalr-agent configure --token=${scalr_agent_pool_token.agent_token.token} --url=https://${var.scalr_hostname} --agent-name=${var.agent_name}",
      "sudo systemctl start scalr-agent",
    ]
  }
  tags = {
    Name = "Agent_service_role_delegation_test"
  }

  depends_on = [
    null_resource.download_agent_deb
  ]
}

output "ec2_connect_cmd" {
  value = "ssh -oStrictHostKeyChecking=no -i linux-key-pair.pem ubuntu@${aws_instance.agent_instance.public_ip}"
}
