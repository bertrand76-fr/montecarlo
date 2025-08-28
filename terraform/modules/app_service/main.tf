resource "azurerm_app_service_plan" "main" {
  name                = "${var.app_service_plan_name_prefix}-${var.resource_group_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Basic"
    size = var.sku_name
  }

  tags = {
    Environment = var.environment
    Module      = "app_service"
  }
}