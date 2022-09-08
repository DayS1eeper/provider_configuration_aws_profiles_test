resource "scalr_workspace" "workspace" {
  name              = var.test_name
  environment_id    = var.environment_id
  auto_apply        = true
  vcs_provider_id   = var.vcs_provider_id
  working_directory = var.working_directory
  agent_pool_id     = var.agent_pool_id
  terraform_version = var.terraform_version
  vcs_repo {
    identifier = "mihunvlad/scalr_pcfg_test_samples"
    branch     = "master"
  }
  dynamic "provider_configuration" {
    for_each = toset(var.provider_configurations)
    content {
      id    = provider_configuration.value["id"]
      alias = provider_configuration.value["alias"]
    }
  }
}

resource "scalr_variable" "bucket_name" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = var.environment_id
  workspace_id   = scalr_workspace.workspace.id
}

# object names
resource "scalr_variable" "object_names" {
  count          = length(var.provider_configurations)
  key            = var.provider_configurations[count.index].variable_object_name
  value          = var.provider_configurations[count.index].object_to_create
  category       = "terraform"
  environment_id = var.environment_id
  workspace_id   = scalr_workspace.workspace.id
}

resource "scalr_variable" "enable_log" {
  key            = "TF_LOG"
  value          = "TRACE"
  category       = "shell"
  environment_id = var.environment_id
  workspace_id   = scalr_workspace.workspace.id
}
