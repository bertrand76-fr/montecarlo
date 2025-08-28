output "id" {
  description = "ID du App Service Plan"
  value       = azurerm_app_service_plan.main.id
}

output "name" {
  description = "Nom du App Service Plan"
  value       = azurerm_app_service_plan.main.name
}