terraform {
  required_version = ">= 1.0"

  required_providers {
    scalr = {
      source  = "registry.scalr.dev/scalr/scalr"
      version = "1.0.0-rc-develop"
    }
  }
}

variable "account_id" {
  type    = string
  default = "acc-svrcncgh453bi8g"
}
variable "prefix" {
  type    = string
  default = "master"
}

resource "scalr_provider_configuration" "scalr" {
  name                   = "scalrpcfg"
  account_id             = var.account_id
  export_shell_variables = false
  environments           = ["*"]
  scalr {
    token    = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ1c2VyIiwianRpIjoiYXQtdTU4a3Rsa2U4NHZqdDYwIn0.rRI-EjxLrgdePjX8cKM1ALBPIuiOk4TL3SQwMycEmcE"
    hostname = "38f40dabbcc2.test-env.scalr.com"
  }
}
resource "scalr_environment" "scalrpcfgtest" {
  name                    = "pcfg-test-${prefix}"
  account_id              = var.account_id
  cost_estimation_enabled = false
}

resource "scalr_workspace" "scalrpcfgtest" {
  name              = "workspace-pcfg-test-${prefix}"
  environment_id    = scalr_environment.scalrpcfgtest.id
  auto_apply        = false
  operations        = false
  vcs_provider_id   = data.scalr_vcs_provider.test.id
  working_directory = "scalr_pcfg_create_workspace"
  vcs_repo {
    identifier = "DayS1eeper/provider_configuration_aws_profiles_test"
    branch     = "master"
  }

  provider_configuration {
    id = scalr_provider_configuration.scalr.id
  }
}
resource "scalr_variable" "bucket_name_ak_v3" {
  key            = "prefix"
  value          = "slave"
  category       = "terraform"
  environment_id = scalr_environment.scalrpcfgtest.id
  workspace_id   = scalr_workspace.scalrpcfgtest.id
}
