Configuration for testing AWS IAM access with minimal required permissions set (see: pcfg_user in [create workspace configuration](../scalr_workspace/main.tf)).
AWS credentials is expected to be exported as shell variables.

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.export_shell_variables](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [local_file.user](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_user"></a> [user](#output\_user) | n/a |
<!-- END_TF_DOCS -->