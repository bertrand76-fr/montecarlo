output "producer_name" {
  description = "Nom de la Function App"
  value       = azurerm_function_app.main.name
}

output "producer_default_hostname" {
  description = "Endpoint de la Function App"
  value       = azurerm_function_app.main.default_hostname
}