# Kubernetes Gateway Terraform Module

Terraform module to manage [Kubernetes Gateway](https://kubernetes.io/docs/concepts/services-networking/gateway/) resource (GKE batteries included).

## Usage

```hcl
module "example" {
  source  = "Tensho/gateway/kubernetes"
  version = "0.4.1"

  name       = "example"
  namespace  = "gateway-system"
  class_name = "gke-l7-global-external-managed"
  
  addresses = [
    {
      type  = "NamedAddress"
      value = "example-ingress-static-ip"
    }
  ]
  
  annotations = {
    "networking.gke.io/certmap" = "example"
  }
  
  listeners = [
    {
      name     = "http"
      protocol = "HTTP"
      port     = 80
    },
    {
      name     = "https"
      protocol = "HTTPS"
      port     = 443
    }
  ]
  
  ssl_policy = "example"
  
  http_to_https_redirect = true
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
| [kubernetes_manifest.gcp_gateway_policy](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |
| [kubernetes_manifest.redirect_http_to_https_route](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addresses"></a> [addresses](#input\_addresses) | List of addresses for the Gateway. Supports type: IPAddress, NamedAddress, Hostname. | <pre>list(object({<br/>    type  = string<br/>    value = string<br/>  }))</pre> | `null` | no |
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Gateway annotations | `map(string)` | `{}` | no |
| <a name="input_class_name"></a> [class\_name](#input\_class\_name) | Gateway class name | `string` | n/a | yes |
| <a name="input_http_to_https_redirect"></a> [http\_to\_https\_redirect](#input\_http\_to\_https\_redirect) | Redirect HTTP traffic from an infrastructure namespace | `string` | `false` | no |
| <a name="input_listeners"></a> [listeners](#input\_listeners) | Gateway listeners | `any` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Gateway name | `string` | `"main"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace | `string` | `"default"` | no |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | GKE GCPGatewayPolicy SSL policy name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubernetes_gateway"></a> [kubernetes\_gateway](#output\_kubernetes\_gateway) | Kubernetes Gateway resource |
<!-- END_TF_DOCS -->

## Contributing

This project uses [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/).

### Prerequisites

* [`terraform`](https://www.terraform.io/downloads.html)
* [`gcloud`](https://cloud.google.com/sdk/gcloud/reference/)
* [`pre-commit`](https://pre-commit.com/)
* [`terraform-docs`](https://terraform-docs.io/)
* [`tflint`](https://github.com/terraform-linters/tflint)

#### Pre-Commit Hooks Installation

```shell
pre-commit install
```

#### Provider Authentication

##### Kubernetes

```shell
export KUBE_CONFIG_PATHS=~/.kube/config
```

##### Google Cloud Platform

```shell
gcloud auth application-default login
export GOOGLE_PROJECT=terraform-test
```

### Development & Testing

> [!NOTE]
> The current test setup targets GCP/GKE.

By default, when you run the `terraform test` command, Terraform looks for `*.tftest.hcl` files in both the root directory 
and in the `tests` directory.

```shell
terraform init
terraform test # run all tests
terraform test -filter test/gke.tftest.hcl -verbose # run specific test
```
