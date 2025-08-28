resource "azurerm_storage_account" "main" {
  name                     = "${var.storage_account_prefix}${var.resource_group_name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Environment = var.environment
    Module      = "storage"
  }
}

resource "azurerm_storage_queue" "main" {
  name                 = "${var.queue_prefix}-${var.resource_group_name}"
  storage_account_name = azurerm_storage_account.main.name
}