output "kubernetes_gateway" {
  value       = kubernetes_manifest.default
  description = "Kubernetes Gateway resource"
}
