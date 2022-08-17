resource "aws_iam_role" "ec2_role" {
  name               = "ec2_role"
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

resource "aws_iam_instance_profile" "instance_profile" {
  name = "scalr_agent_pcfg_test"
  role = aws_iam_role.instance_profile.name
}

resource "aws_instance" "agent_instance" {
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.instance_profile.name
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
