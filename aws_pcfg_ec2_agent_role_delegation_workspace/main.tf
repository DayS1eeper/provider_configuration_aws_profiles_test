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


resource "null_resource" "download_agent_deb" {
  provisioner "local-exec" {
    command = "gsutil cp ${var.package_url} agent.deb"
  }
}

resource "aws_instance" "agent-server" {
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_agent.id
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
      "sudo systemctl start scalr-agent",
      "sudo scalr-agent configure --token=${scalr_agent_pool_token.default.token} --url=https://${var.scalr_hostname} --agent-name=${var.agent_name}",
      "sudo systemctl restart scalr-agent"
    ]
  }

  depends_on = [
    null_resource.download_agent_deb
  ]

}
