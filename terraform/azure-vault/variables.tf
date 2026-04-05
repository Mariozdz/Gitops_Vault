variable "subscription_id" {
  type = string
}

variable "resource_group_name" {
  type    = string
  default = "rg-aks-cilium"
}

variable "location" {
  type    = string
  default = "westus3"
}

variable "my_public_ip_cidr" {
  type        = string
  description = "Tu IP pública en formato CIDR, por ejemplo 203.0.113.10/32"
}