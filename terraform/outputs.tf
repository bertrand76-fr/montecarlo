# Monte Carlo Platform - Outputs
# ÉTAPE 1 - Minimal: Outputs pour Resource Group

# Resource Group Information
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = module.resource_group.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = module.resource_group.location
}

output "resource_group_id" {
  description = "ID of the created resource group"
  value       = module.resource_group.id
}

output "resource_group_tags" {
  description = "Tags associated with the resource group"
  value       = module.resource_group.tags
}

# Environment Information
output "environment" {
  description = "Environment name"
  value       = var.environment
}

# Deployment Information
output "deployment_timestamp" {
  description = "Timestamp of the deployment"
  value       = timestamp()
}

# Summary Output for Pipeline
output "deployment_summary" {
  description = "Résumé du déploiement"
  value = {
    resource_group = module.resource_group.name
    location       = module.resource_group.location
    tags           = module.resource_group.tags
    id             = module.resource_group.id
  }
}