variables {
  name       = "test"
  namespace  = "default"
  class_name = "gke-l7-global-external-managed"

  addresses = [
    {
      type  = "NamedAddress"
      value = "test"
    }
  ]

  annotations = {
    "networking.gke.io/certmap" = "test"
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

  ssl_policy = "test"

  http_to_https_redirect = true
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "execute" {
  assert {
    condition     = length(kubernetes_manifest.default) != 0
    error_message = "Gateway resource has not been created"
  }

  assert {
    condition     = length(kubernetes_manifest.gcp_gateway_policy) != 0
    error_message = "GCPGatewayPolicy (SSL policy) resource has not been created"
  }

  assert {
    condition     = length(kubernetes_manifest.redirect_http_to_https_route) != 0
    error_message = "HTTPRoute (HTTP-to-HTTPS redirect) resource has not been created"
  }
}
