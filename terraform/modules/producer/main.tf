resource "azurerm_function_app" "main" {
  name                       = "${var.function_name_prefix}-${var.resource_group_name}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = var.app_service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  version                    = "~3"
  os_type                    = "linux"

  site_config {
    linux_fx_version = "Python|${var.runtime_version}"
  }

  tags = {
    Environment = var.environment
    Module      = "producer"
  }
}

module "producer" {
  source                      = "./modules/producer"
  resource_group_name         = module.resource_group.name
  location                    = module.resource_group.location
  environment                 = var.environment
  storage_account_name        = module.storage.storage_account_name
  storage_account_access_key  = module.storage.storage_account_connection_string
  app_service_plan_id         = module.app_service.id
  function_name_prefix        = "producer"
  runtime_version             = "3.11"
  depends_on                  = [module.storage, module.app_service]
}