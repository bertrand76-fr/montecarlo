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

variable "storage_account_prefix" {
  description = "Préfixe du Storage Account"
  type        = string
  default     = "st"
}

variable "queue_prefix" {
  description = "Préfixe de la Storage Queue"
  type        = string
  default     = "queue"
}