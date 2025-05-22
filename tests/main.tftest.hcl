variables {
  name = "test"
  namespace = "default"
  class_name = "gke-l7-global-external-managed"
  addresses = [
    {
      type  = "NamedAddress"
      value = "main-ingress-static-ip"
    }
  ]
  annotations = {
    "networking.gke.io/certmap" = "main"
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

# TODO: Create a setup
# 1) address
# 2) certificate map

run "execute" {
  assert {
    condition     = length(kubernetes_manifest.gateway) != 0
    error_message = "Gateway resource has not been created"
  }
}
