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

variable "storage_account_name" {
  description = "Nom du Storage Account"
  type        = string
}

variable "storage_account_access_key" {
  description = "Clé d'accès du Storage Account"
  type        = string
}

variable "app_service_plan_id" {
  description = "ID du App Service Plan"
  type        = string
}

variable "function_name_prefix" {
  description = "Préfixe du nom de la Function"
  type        = string
  default     = "producer"
}

variable "runtime_version" {
  description = "Version du runtime Python"
  type        = string
  default     = "3.11"
}