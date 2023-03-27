Create CLI-driven scalr workspace with access_keys credentials type aws provider configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_scalr"></a> [scalr](#requirement\_scalr) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_scalr"></a> [scalr](#provider\_scalr) | ~> 1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_access_key.pcfg_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_access_key) | resource |
| [aws_iam_user.pcfg_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user_policy.pcfg_user](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy) | resource |
| scalr_provider_configuration.aws_acces_keyss_with_export | resource |
| scalr_workspace.workspace | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | n/a | `string` | `"acc-svrcncgh453bi8g"` | no |
| <a name="input_environment_id"></a> [environment\_id](#input\_environment\_id) | n/a | `string` | `"env-svrcnchebt61e30"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ws"></a> [ws](#output\_ws) | n/a |
<!-- END_TF_DOCS -->