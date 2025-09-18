variable "environment" {
  description = "Environment name (staging, production)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "observer"
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "app_gateway_subnet_prefix" {
  description = "Application Gateway subnet prefix"
  type        = string
  default     = "10.0.1.0/24"
}

variable "container_apps_subnet_prefix" {
  description = "Container Apps subnet prefix"
  type        = string
  default     = "10.0.2.0/23"
}

variable "key_vault_admin_object_ids" {
  description = "Object IDs with Key Vault admin permissions"
  type        = list(string)
  default     = []
}