resource "aws_instance" "agent_export_shell_vars_test" {
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
      "sudo apt-get update",
      "sudo apt-get install awscli",
      "sudo dpkg -i /tmp/agent.deb",
      "sudo systemctl start scalr-agent",
      "sudo scalr-agent configure --token=${scalr_agent_pool_token.agent_export_shell_vars_test.token} --url=https://${var.scalr_hostname} --agent-name=${var.agent_name_export_shell_vars_test}",
      "sudo systemctl restart scalr-agent"
    ]
  }

  depends_on = [
    null_resource.download_agent_deb
  ]

}
