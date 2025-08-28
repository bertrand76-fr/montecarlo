variable "resource_group_name" {
  description = "Nom du Resource Group (utilisé comme suffixe)"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "environment" {
  description = "Environnement"
  type        = string
}

variable "app_service_plan_name_prefix" {
  description = "Préfixe du nom du App Service Plan"
  type        = string
  default     = "asp"
}

variable "sku_name" {
  description = "SKU du App Service Plan"
  type        = string
  default     = "B1"
}