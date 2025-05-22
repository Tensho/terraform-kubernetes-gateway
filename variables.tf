variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
  default     = "default"
}

variable "name" {
  type        = string
  description = "Gateway name"
  default     = "main"
}

variable "class_name" {
  type        = string
  description = "Gateway class name"
}

variable "listeners" {
  type        = any
  description = "Gateway listeners"
}

variable "annotations" {
  type        = map(string)
  description = "Gateway annotations"
  default     = {}
}