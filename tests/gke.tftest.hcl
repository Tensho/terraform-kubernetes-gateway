variables {
  name       = "test"
  namespace  = "default"
  class_name = "gke-l7-global-external-managed"

  listeners = [
    {
      name     = "http"
      protocol = "HTTP"
      port     = 80
    }
  ]
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "basic" {
  assert {
    condition     = length(kubernetes_manifest.default) != 0
    error_message = "Gateway resource has not been created"
  }
}

run "addresses_empty" {
  # To Kubernetes API
  assert {
    condition     = !contains(keys(kubernetes_manifest.default.manifest.spec), "addresses")
    error_message = "manifest spec does not contain 'address' when input is null"
  }

  # From Kubernetes API
  assert {
    condition     = kubernetes_manifest.default.object.spec.addresses == null
    error_message = "object spec has empty 'addresses' when input is null"
  }
}

run "addresses_present" {
  variables {
    addresses = [
      {
        type  = "NamedAddress"
        value = "test"
      }
    ]
  }

  # To Kubernetes API
  assert {
    condition     = kubernetes_manifest.default.manifest.spec.addresses[0].value == "test"
    error_message = "manifest spec has 'addresses' when input is present"
  }

  # From Kubernetes API
  assert {
    condition     = kubernetes_manifest.default.object.spec.addresses[0].value == "test"
    error_message = "object spec has 'addresses' when input is present"
  }
}

run "annotations" {
  variables {
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
  }

  # To Kubernetes API
  assert {
    condition     = contains(keys(kubernetes_manifest.default.manifest.metadata.annotations), "networking.gke.io/certmap")
    error_message = "manifest metadata contains 'annotations' when input is present"
  }

  # From Kubernetes API
  assert {
    condition = alltrue([
      contains(keys(kubernetes_manifest.default.object.metadata.annotations), "networking.gke.io/certmap"),
      contains(keys(kubernetes_manifest.default.object.metadata.annotations), "networking.gke.io/addresses"),
      contains(keys(kubernetes_manifest.default.object.metadata.annotations), "networking.gke.io/forwarding-rules")
    ])
    error_message = "object metadata contains 'annotations' along with other GoogleGKEGatewayController values when input is present"
  }
}

run "ssl_policy" {
  variables {
    ssl_policy = "test"
  }

  assert {
    condition     = length(kubernetes_manifest.gcp_gateway_policy) != 0
    error_message = "GCPGatewayPolicy (SSL policy) resource has not been created"
  }
}

run "http_to_https_redirect" {
  variables {
    http_to_https_redirect = true
  }

  assert {
    condition     = length(kubernetes_manifest.redirect_http_to_https_route) != 0
    error_message = "HTTPRoute (HTTP-to-HTTPS redirect) resource has not been created"
  }
}
