output "access_key_id" {
  value     = aws_iam_access_key.access_keys.id
  sensitive = true
}

output "secret_access_key" {
  value     = aws_iam_access_key.access_keys.secret
  sensitive = true
}

output "object_path" {
  value = local.object_path
}
