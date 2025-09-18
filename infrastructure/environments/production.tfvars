environment         = "production"
location            = "East US"
resource_group_name = "observer-production-rg"

vnet_address_space           = ["10.1.0.0/16"]
app_gateway_subnet_prefix    = "10.1.1.0/24"
container_apps_subnet_prefix = "10.1.2.0/23"

tags = {
  Environment = "production"
  Project     = "observer"
  ManagedBy   = "terraform"
}