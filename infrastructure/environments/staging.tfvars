environment         = "staging"
location            = "East US"
resource_group_name = "observer-staging-rg"

vnet_address_space           = ["10.0.0.0/16"]
app_gateway_subnet_prefix    = "10.0.1.0/24"
container_apps_subnet_prefix = "10.0.2.0/23"

tags = {
  Environment = "staging"
  Project     = "observer"
  ManagedBy   = "terraform"
}