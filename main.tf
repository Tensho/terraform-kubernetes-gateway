resource "kubernetes_manifest" "default" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1beta1"
    kind       = "Gateway"

    metadata = {
      namespace = var.namespace
      name      = var.name
    }

    spec = {
      gatewayClassName = var.gateway_class_name
      listeners        = var.gateway_listeners
    }
  }

  wait {
    fields = {
      "status.addresses[0].value" = "^(\\d+(\\.|$)){4}"
    }
  }
}
