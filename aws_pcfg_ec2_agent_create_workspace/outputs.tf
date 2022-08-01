output "role_delegation_ec2_connect_cmd" {
  value = "ssh -oStrictHostKeyChecking=no -i linux-key-pair.pem ubuntu@${aws_instance.service_role_delegation_test.public_ip}"
}
output "export_shell_vars_ec2_connect_cmd" {
  value = "ssh -oStrictHostKeyChecking=no -i linux-key-pair.pem ubuntu@${aws_instance.agent_export_shell_vars_test.public_ip}"
}