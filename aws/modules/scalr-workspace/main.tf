resource "scalr_workspace" "workspace" {
  name              = var.test_name
  environment_id    = var.environment_id
  auto_apply        = true
  vcs_provider_id   = var.vcs_provider_id
  working_directory = var.working_directory
  agent_pool_id     = var.agent_pool_id
  vcs_repo {
    identifier = "DayS1eeper/scalr_terraform_provider_configuration_samples"
    branch     = "master"
  }
  dynamic "provider_configuration" {
    for_each = var.provider_configurations
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
  for_each       = var.provider_configurations
  key            = "object_${each.value.alias}"
  value          = each.value.object_to_create_key
  category       = "terraform"
  environment_id = var.environment_id
  workspace_id   = scalr_workspace.workspace.id
}
