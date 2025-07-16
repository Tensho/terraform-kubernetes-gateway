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
      addresses        = var.addresses
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

resource "kubernetes_manifest" "gcp_gateway_policy" {
  count = var.ssl_policy != null ? 1 : 0

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "GCPGatewayPolicy"

    metadata = {
      namespace = var.namespace
      name      = var.name
    }

    spec = {
      default = {
        sslPolicy = var.ssl_policy
      }

      targetRef = {
        group = "gateway.networking.k8s.io"
        kind  = "Gateway"
        name  = var.name
      }
    }
  }
}
