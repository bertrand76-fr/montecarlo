# Monte Carlo Platform - Terraform Configuration
# ÉTAPE 1 - Minimal: Providers et versions

terraform {
  required_version = ">= 1.6.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
  
  # Backend configuration pour state storage
  backend "azurerm" {
    # Configuration fournie par le pipeline Azure DevOps:
    # resource_group_name  = "rg-terraform-state"
    # storage_account_name = "sttfstatedev" 
    # container_name       = "tfstate"
    # key                 = "montecarlo.terraform.tfstate"
  }
}

# Provider Azure Resource Manager
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}