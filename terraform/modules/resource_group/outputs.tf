output "name" {
  description = "Nom du Resource Group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "Région Azure du Resource Group"
  value       = azurerm_resource_group.main.location
}

output "tags" {
  description = "Tags du Resource Group"
  value       = azurerm_resource_group.main.tags
}

output "id" {
  description = "ID du Resource Group"
  value       = azurerm_resource_group.main.id
}