resource "kubernetes_manifest" "default" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "Gateway"

    metadata = {
      namespace   = var.namespace
      name        = var.name
      annotations = var.annotations
    }

    spec = merge(
      {
        gatewayClassName = var.class_name
        listeners        = var.listeners
      },
      var.addresses == null ? {} : {
        addresses = var.addresses
      }
    )
  }

  computed_fields = [
    "metadata.labels",
    "metadata.annotations",
    "spec.addresses",
  ]

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

# Redirect HTTP traffic from an infrastructure namespace
# https://cloud.google.com/kubernetes-engine/docs/how-to/deploying-gateways#redirect_http_traffic_from_an_infrastructure_namespace
resource "kubernetes_manifest" "redirect_http_to_https_route" {
  count = var.http_to_https_redirect ? 1 : 0

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "HTTPRoute"

    metadata = {
      namespace = var.namespace
      name      = "http-to-https-redirect"
    }

    spec = {
      parentRefs = [
        {
          kind        = "Gateway"
          namespace   = var.namespace
          name        = var.name
          sectionName = "http"
        }
      ]

      rules = [
        {
          filters = [
            {
              type = "RequestRedirect"

              requestRedirect = {
                scheme = "https"
              }
            }
          ]
        }
      ]
    }
  }
}
