resource "kubernetes_manifest" "default" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "Gateway"

    metadata = {
      namespace   = var.namespace
      name        = var.name
      annotations = var.annotations
    }

    spec = {
      gatewayClassName = var.class_name
      listeners        = var.listeners
    }
  }

  wait {
    fields = {
      "status.addresses[0].value" = "^(\\d+(\\.|$)){4}"
    }
  }
}

# Doesn't work as Gateway resource requires "spec" field on PATCH action
# resource "kubernetes_annotations" "default" {
#   api_version = kubernetes_manifest.default.manifest.apiVersion
#   kind        = kubernetes_manifest.default.manifest.kind
#
#   metadata {
#     namespace = kubernetes_manifest.default.manifest.metadata.namespace
#     name      = kubernetes_manifest.default.manifest.metadata.name
#   }
#
#   annotations = {
#     "foo" = "bar"
#   }
# }
