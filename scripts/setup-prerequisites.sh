#!/bin/bash

# Observer Infrastructure Setup Script
# This script sets up the required Azure resources for the Observer infrastructure

set -e

# Configuration
RESOURCE_GROUP="observer-tfstate-rg"
STORAGE_ACCOUNT="observertfstate"
CONTAINER_NAME="tfstate"
LOCATION="East US"

echo "🚀 Setting up Observer Infrastructure prerequisites..."

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it first."
    exit 1
fi

# Check if logged in to Azure
if ! az account show &> /dev/null; then
    echo "🔑 Please log in to Azure CLI..."
    az login
fi

# Get current subscription
SUBSCRIPTION=$(az account show --query id -o tsv)
echo "📋 Using subscription: $SUBSCRIPTION"

# Create resource group for Terraform state
echo "📁 Creating resource group: $RESOURCE_GROUP"
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --tags \
        "Purpose=TerraformState" \
        "Project=Observer" \
        "ManagedBy=Script"

# Create storage account for Terraform state
echo "💾 Creating storage account: $STORAGE_ACCOUNT"
az storage account create \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2 \
    --allow-blob-public-access false \
    --tags \
        "Purpose=TerraformState" \
        "Project=Observer" \
        "ManagedBy=Script"

# Create container for Terraform state
echo "📦 Creating storage container: $CONTAINER_NAME"
az storage container create \
    --name "$CONTAINER_NAME" \
    --account-name "$STORAGE_ACCOUNT" \
    --public-access off

echo "✅ Prerequisites setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. Configure GitHub repository secrets:"
echo "   - AZURE_CLIENT_ID"
echo "   - AZURE_TENANT_ID" 
echo "   - AZURE_SUBSCRIPTION_ID"
echo ""
echo "2. Set up GitHub Environments:"
echo "   - staging (no protection rules)"
echo "   - production (with required reviewers)"
echo ""
echo "3. Configure branch protection for main branch"
echo ""
echo "4. Test deployment by creating a PR or merging to main"