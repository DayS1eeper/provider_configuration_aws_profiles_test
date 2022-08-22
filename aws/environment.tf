resource "scalr_environment" "test" {
  name                    = "pcfg-test"
  account_id              = var.account_id
  cost_estimation_enabled = false
}
data "scalr_vcs_provider" "test" {
  name       = "pcfg_test"
  account_id = var.account_id
}

resource "scalr_agent_pool" "agent_pool" {
  name           = "pcfg_test_agent_pool"
  account_id     = var.account_id
  environment_id = scalr_environment.test.id
}

resource "scalr_agent_pool_token" "agent_token" {
  description   = "Agent token used in ec2 agent"
  agent_pool_id = scalr_agent_pool.agent_pool.id
}
