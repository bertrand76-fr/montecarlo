# Monte Carlo Platform - Variables
# ÉTAPE 1 - Minimal: Variables pour Resource Group

variable "resource_group_name" {
  description = "Resource Group name from Azure DevOps variable RG_MONTECARLO"
  type        = string
  
  validation {
    condition     = length(var.resource_group_name) > 0 && can(regex("^[a-zA-Z0-9_.-]+$", var.resource_group_name))
    error_message = "Resource Group name must be non-empty and contain only letters, numbers, underscores, periods, and hyphens."
  }
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "France Central"
  
  validation {
    condition = contains([
      "France Central",
      "West Europe", 
      "East US",
      "East US 2",
      "West US 2"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}