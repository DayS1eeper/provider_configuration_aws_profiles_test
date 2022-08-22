resource "null_resource" "export_shell_variables" {
  triggers = {
    object_path = var.object_path
    bucket_name = var.bucket_name
  }

  provisioner "local-exec" {
    command = "echo 'object_export_shell_variables content' >> obj.txt && aws s3 cp obj.txt s3://${var.bucket_name}/${var.object_path}"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rm s3://${self.triggers.bucket_name}/${self.triggers.object_path}"
  }
}