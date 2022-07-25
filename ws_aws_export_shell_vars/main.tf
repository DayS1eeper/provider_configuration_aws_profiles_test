terraform {
  required_version = ">= 1.0"
}
variable "bucket_name" {
  type = string
}
variable "object_name" {
  type = string
}
resource "null_resource" "create_obj" {
  provisioner "local-exec" {
    command = "echo 'obj ${var.object_name}' >> obj.txt && aws s3 cp obj.txt s3://${var.bucket_name}/${var.object_name}"
  }
  provisioner "local-exec" {
    when = destroy
    command = "aws s3 rm s3://${var.bucket_name}/${var.object_name}"
  }
}