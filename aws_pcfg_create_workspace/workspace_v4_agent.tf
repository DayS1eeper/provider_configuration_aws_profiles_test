resource "scalr_workspace" "v4_agent" {
  name              = "v4_agent"
  environment_id    = scalr_environment.test.id
  auto_apply        = false
  operations        = false
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  agent_pool_id     = scalr_agent_pool.agent_pool.id
  working_directory = "ws_aws_v4"
  vcs_repo {
    identifier = "DayS1eeper/scalr_terraform_provider_configuration_samples"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.export_shell_vars.id
  }
  provider_configuration {
    id    = scalr_provider_configuration.instance_profile.id
    alias = "instance_profile"
  }
  provider_configuration {
    id    = scalr_provider_configuration.access_keys.id
    alias = "access_keys"
  }
  provider_configuration {
    id    = scalr_provider_configuration.role_delegation.id
    alias = "role_delegation"
  }
}

resource "scalr_variable" "v4_agent_bucket" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v4_agent.id
}

# object names
resource "scalr_variable" "v4_agent_obj_role_delegation" {
  key            = "aws_v4_object_role_delegation"
  value          = var.obj_role_delegation_v4_agent
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v4_agent.id
}

resource "scalr_variable" "v4_agent_obj_access_keys" {
  key            = "aws_v4_object_access_keys"
  value          = var.obj_access_keys_v4_agent
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v4_agent.id
}

resource "scalr_variable" "v4_agent_obj_instance_profile" {
  key            = "aws_v4_object_instance_profile"
  value          = var.obj_instance_profile_v4_agent
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v4_agent.id
}

resource "scalr_variable" "v4_agent_obj_export_shell_vars" {
  key            = "aws_v4_object_export_shell_variables"
  value          = var.obj_export_shell_vars_v4_agent
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v4_agent.id
}
