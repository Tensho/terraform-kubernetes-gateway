variable "name" {
  type        = string
  description = "Global name"
  default     = "main"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "default"
}

variable "gateway_class_name" {
  type        = string
  description = "Gateway class name"
}

variable "gateway_listeners" {
  type        = any
  description = "Gateway listeners"
}
