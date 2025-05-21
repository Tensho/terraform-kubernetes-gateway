# Kubernetes Gateway Terraform Module

Terraform module to manage [Kubernetes Gateway](https://kubernetes.io/docs/concepts/services-networking/gateway/) resource (batteries included).

## Usage

```hcl
module "example" {
  source  = "Tensho/gateway/kubernetes"
  version = "1.0.0"

  name = "Example"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.36.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [kubernetes_manifest.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gateway_class_name"></a> [gateway\_class\_name](#input\_gateway\_class\_name) | Gateway class name | `string` | n/a | yes |
| <a name="input_gateway_listeners"></a> [gateway\_listeners](#input\_gateway\_listeners) | Gateway listeners | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Global name | `string` | `"main"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace | `string` | `"default"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes_gateway"></a> [kubernetes\_gateway](#output\_kubernetes\_gateway) | Kubernetes Gateway resource |
<!-- END_TF_DOCS -->

## Contributing

This project uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).

### Prerequisites

#### MacOS

```shell
brew install pre-commit terraform-docs tflint
pre-commit install --install-hooks
tflint --init
```

#### Provider Authentication

```shell
export KUBE_CONFIG_PATHS=~/.kube/config
```

### Development

```shell
cd examples/
terraform init
terraform apply
terraform destroy
```

### Testing

```shell
terraform init
terraform test
terraform test -filter main.tftest.hcl -verbose
```
