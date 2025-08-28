# Monte Carlo Platform 

module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
  environment         = var.environment
}

module "storage" {
  source                  = "./modules/storage"
  resource_group_name     = module.resource_group.name
  location                = module.resource_group.location
  environment             = var.environment
  storage_account_prefix  = "storage"
  queue_prefix            = "queue"
  depends_on              = [module.resource_group]
}

module "app_service" {
  source                       = "./modules/app_service"
  resource_group_name          = module.resource_group.name
  location                     = module.resource_group.location
  environment                  = var.environment
  app_service_plan_name_prefix = "asp"
  sku_name                     = "B1"
  depends_on                   = [module.resource_group]
}

