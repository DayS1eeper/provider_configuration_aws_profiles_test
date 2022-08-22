variable "test_name" {
  type = string
}

variable "environment_id" {
  type = string
}

variable "vcs_provider_id" {
  type = string
}

variable "working_directory" {
  type = string
}

variable "provider_configurations" {
  type = list(object({
    id                   = string
    alias                = string
    object_to_create_key = string
  }))
}

variable "bucket_name" {
  type = string
}

variable "agent_pool_id" {
  type = string
  default = null
}