# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name          = azurerm_resource_group.main.name
  location                     = var.location
  project_name                 = var.project_name
  environment                  = var.environment
  vnet_address_space           = var.vnet_address_space
  app_gateway_subnet_prefix    = var.app_gateway_subnet_prefix
  container_apps_subnet_prefix = var.container_apps_subnet_prefix
  tags                         = var.tags
}

# Security Module (Key Vault)
module "security" {
  source = "./modules/security"

  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  project_name               = var.project_name
  environment                = var.environment
  key_vault_admin_object_ids = var.key_vault_admin_object_ids
  tags                       = var.tags
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  project_name        = var.project_name
  environment         = var.environment
  tags                = var.tags
}

# Container Apps Module
module "container_apps" {
  source = "./modules/container-apps"

  resource_group_name        = azurerm_resource_group.main.name
  location                   = var.location
  project_name               = var.project_name
  environment                = var.environment
  container_apps_subnet_id   = module.networking.container_apps_subnet_id
  log_analytics_workspace_id = module.monitoring.workspace_id
  tags                       = var.tags
}

# Application Gateway Module
module "app_gateway" {
  source = "./modules/app-gateway"

  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  project_name          = var.project_name
  environment           = var.environment
  app_gateway_subnet_id = module.networking.app_gateway_subnet_id
  key_vault_id          = module.security.key_vault_id
  tags                  = var.tags
}