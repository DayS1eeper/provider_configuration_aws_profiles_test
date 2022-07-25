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

resource "aws_iam_instance_profile" "service_role_delegation_test" {
  name = "scalr_agent_service_role_delegation_test"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "service_role_delegation_test" {
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.service_role_delegation_test.name
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
      "sudo dpkg -i /tmp/agent.deb",
      "sudo scalr-agent configure --token=${scalr_agent_pool_token.service_role_delegation_test.token} --url=https://${var.scalr_hostname} --agent-name=${var.agent_name}",
      "sudo systemctl start scalr-agent"
    ]
  }
  tags = {
    Name = "Agent_service_role_delegation_test"
  }

  depends_on = [
    null_resource.download_agent_deb
  ]

}
