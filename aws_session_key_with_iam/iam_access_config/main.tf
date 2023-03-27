terraform {
  backend "remote" {
    hostname     = "" # ENTER HOSTNAME
    organization = "env-svrcnchebt61e30"
    token        = "" # ENTER TOKEN
    workspaces {
      name = "test_aws_access_keys_pcfg_iam_access"
    }
  }
}

resource "null_resource" "export_shell_variables" {
  provisioner "local-exec" {
    command = "aws iam get-user >> user.json"
  }
}

data "local_file" "user" {
  filename   = "user.json"
  depends_on = [null_resource.export_shell_variables]
}

output "user" {
  value = data.local_file.user.content
}
