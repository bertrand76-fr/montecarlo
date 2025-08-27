# Monte Carlo Platform - Resource Group Creation
# ÉTAPE 1 - Minimal: Resource Group uniquement

# Resource Group principal
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "Monte Carlo Platform"
    CreatedBy   = "Terraform"
    Purpose     = "Distributed Computing Demo"
  }
}

