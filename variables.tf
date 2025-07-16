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

variable "addresses" {
  type = list(object({
    type  = string
    value = string
  }))
  description = "List of addresses for the Gateway. Supports type: IPAddress, NamedAddress, Hostname."
  default     = null
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

########################################
# GKE
########################################
variable "ssl_policy" {
  type        = string
  description = "GKE GCPGatewayPolicy SSL policy name"
  default     = null
}
