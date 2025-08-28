output "name" {
  description = "Nom de la Function App"
  value       = azurerm_function_app.main.name
}

output "default_hostname" {
  description = "Endpoint de la Function App"
  value       = azurerm_function_app.main.default_hostname
}