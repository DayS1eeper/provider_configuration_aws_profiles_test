variable "package_url" {
  type        = string
  description = "url to agent package, e.g. 'gs://fatmouse/omnibus/pkg/fix-scalrcore-22600/31442/scalr-agent_0.1.25.b31442-1_amd64.deb'"
}
variable "scalr_hostname" {
  type = string
}
variable "account_id" {
  type    = string
  default = "acc-svrcncgh453bi8g"
}

variable "bucket_name" {
  type    = string
  default = "scalrpcfgtest123"
}

variable "agent_name" {
  type    = string
  default = "agent_service_role_delegaion_test"
}
variable "agent_name_export_shell_vars_test" {
  type    = string
  default = "agent_export_shell_vars_test"
}
