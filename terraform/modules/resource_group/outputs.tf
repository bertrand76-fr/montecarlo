output "name" {
  description = "Nom du Resource Group"
  value       = azurerm_resource_group.main.name
}

output "id" {
  description = "ID du Resource Group"
  value       = azurerm_resource_group.main.id
}