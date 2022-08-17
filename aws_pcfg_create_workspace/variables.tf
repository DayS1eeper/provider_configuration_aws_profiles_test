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
  default = "scalrpcfgtest12345"
}

variable "agent_name" {
  type    = string
  default = "pcfg_test"
}

variable "obj_role_delegation_v3" {
  type    = string
  default = "obj_role_delegation_v3"
}
variable "obj_role_delegation_v4" {
  type    = string
  default = "obj_role_delegation_v4"
}

variable "obj_access_keys_v3" {
  type    = string
  default = "obj_access_keys_v3"
}

variable "obj_access_keys_v4" {
  type    = string
  default = "obj_access_keys_v4"
}

variable "obj_export_shell_vars_v3" {
  type    = string
  default = "obj_export_shell_vars_v3"
}

variable "obj_export_shell_vars_v4" {
  type    = string
  default = "obj_export_shell_vars_v4"
}

# for agent runs

variable "obj_role_delegation_v3_agent" {
  type    = string
  default = "obj_role_delegation_v3_agent"
}
variable "obj_role_delegation_v4_agent" {
  type    = string
  default = "obj_role_delegation_v4_agent"
}

variable "obj_instance_profile_v3_agent" {
  type    = string
  default = "obj_instance_profile_v3_agent"
}

variable "obj_instance_profile_v4_agent" {
  type    = string
  default = "obj_instance_profile_v4_agent"
}

variable "obj_access_keys_v3_agent" {
  type    = string
  default = "obj_access_keys_v3_agent"
}

variable "obj_access_keys_v4_agent" {
  type    = string
  default = "obj_access_keys_v4_agent"
}

variable "obj_export_shell_vars_v3_agent" {
  type    = string
  default = "obj_export_shell_vars_v3_agent"
}

variable "obj_export_shell_vars_v4_agent" {
  type    = string
  default = "obj_export_shell_vars_v4_agent"
}
