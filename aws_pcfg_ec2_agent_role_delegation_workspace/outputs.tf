output "ec2_pub_ip" {
    value = aws_instance.agent-server.public_ip
}