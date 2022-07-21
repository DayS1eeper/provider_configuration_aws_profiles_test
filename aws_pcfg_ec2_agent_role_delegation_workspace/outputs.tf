output "ec2_connect_cmd" {
    value = "ssh -oStrictHostKeyChecking=no -i linux-key-pair.pem ubuntu@${aws_instance.agent-server.public_ip}"
}