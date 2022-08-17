resource "scalr_workspace" "v3_no_agent" {
  name              = "v3_no_agent"
  environment_id    = scalr_environment.test.id
  auto_apply        = false
  operations        = false
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  working_directory = "ws_aws_v3"
  vcs_repo {
    identifier = "DayS1eeper/scalr_terraform_provider_configuration_samples"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.export_shell_vars.id
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

resource "scalr_variable" "v3_no_agent_bucket" {
  key            = "bucket_name"
  value          = var.bucket_name
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v3_no_agent.id
}

# object names
resource "scalr_variable" "v3_no_agent_obj_role_delegation" {
  key            = "aws_v3_object_role_delegation"
  value          = var.obj_role_delegation_v3
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v3_no_agent.id
}

resource "scalr_variable" "v3_no_agent_obj_access_keys" {
  key            = "aws_v3_object_access_keys"
  value          = var.obj_access_keys_v3
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v3_no_agent.id
}

resource "scalr_variable" "v3_no_agent_obj_instance_profile" {
  key            = "aws_v3_object_instance_profile"
  value          = ""
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v3_no_agent.id
}

resource "scalr_variable" "v3_no_agent_obj_export_shell_vars" {
  key            = "aws_v3_object_export_shell_variables"
  value          = var.obj_export_shell_vars_v3
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v3_no_agent.id
}

# do not create resource that require instance profile creds
resource "scalr_variable" "v3_no_agent_create_instance_profile_resource" {
  key            = "create_instance_profile_resource"
  value          = false
  category       = "terraform"
  environment_id = scalr_environment.test.id
  workspace_id   = scalr_workspace.v3_no_agent.id
}
