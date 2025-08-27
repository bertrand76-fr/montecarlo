variable "resource_group_name" {
  description = "Nom du Resource Group"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "environment" {
  description = "Environnement (ex: dev, prod)"
  type        = string
}