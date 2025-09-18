#!/bin/bash

# Azure OIDC Setup Script for observer-infra
# This script helps set up OIDC authentication between GitHub Actions and Azure

set -e

echo "🔐 Azure OIDC Setup for observer-infra"
echo "======================================"

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it first:"
    echo "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if user is logged in
if ! az account show &> /dev/null; then
    echo "❌ Please log in to Azure CLI first:"
    echo "   az login"
    exit 1
fi

echo "✅ Azure CLI is available and logged in"

# Get current subscription info
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
TENANT_ID=$(az account show --query tenantId -o tsv)

echo "📋 Current Azure Context:"
echo "   Subscription ID: $SUBSCRIPTION_ID"
echo "   Tenant ID: $TENANT_ID"

# Prompt for GitHub repository details
read -p "📝 Enter GitHub repository (format: owner/repo) [organicastudio/observer-infra]: " REPO
REPO=${REPO:-"organicastudio/observer-infra"}

# Create Azure AD Application
echo "🔨 Creating Azure AD Application..."
APP_NAME="observer-infra-github-actions"

# Check if app already exists
if az ad app list --display-name "$APP_NAME" --query "[0].appId" -o tsv | grep -q .; then
    echo "ℹ️  Application '$APP_NAME' already exists"
    APP_ID=$(az ad app list --display-name "$APP_NAME" --query "[0].appId" -o tsv)
else
    APP_ID=$(az ad app create --display-name "$APP_NAME" --query appId -o tsv)
    echo "✅ Created application: $APP_ID"
fi

# Create service principal if it doesn't exist
if ! az ad sp show --id "$APP_ID" &> /dev/null; then
    echo "🔨 Creating service principal..."
    az ad sp create --id "$APP_ID"
    echo "✅ Service principal created"
fi

# Configure federated identity credentials for staging
echo "🔨 Configuring federated credentials for staging environment..."
STAGING_CRED_NAME="observer-infra-staging"

# Remove existing credential if it exists
az ad app federated-credential delete --id "$APP_ID" --federated-credential-id "$STAGING_CRED_NAME" 2>/dev/null || true

# Create staging federated credential
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters "{
    \"name\": \"$STAGING_CRED_NAME\",
    \"issuer\": \"https://token.actions.githubusercontent.com\",
    \"subject\": \"repo:$REPO:ref:refs/heads/main\",
    \"description\": \"GitHub Actions - Staging Environment\",
    \"audiences\": [\"api://AzureADTokenExchange\"]
  }"

echo "✅ Staging federated credential configured"

# Configure federated identity credentials for production
echo "🔨 Configuring federated credentials for production environment..."
PRODUCTION_CRED_NAME="observer-infra-production"

# Remove existing credential if it exists
az ad app federated-credential delete --id "$APP_ID" --federated-credential-id "$PRODUCTION_CRED_NAME" 2>/dev/null || true

# Create production federated credential  
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters "{
    \"name\": \"$PRODUCTION_CRED_NAME\",
    \"issuer\": \"https://token.actions.githubusercontent.com\",
    \"subject\": \"repo:$REPO:environment:production\",
    \"description\": \"GitHub Actions - Production Environment\",
    \"audiences\": [\"api://AzureADTokenExchange\"]
  }"

echo "✅ Production federated credential configured"

# Assign Contributor role
echo "🔨 Assigning Contributor role to service principal..."
az role assignment create \
  --role "Contributor" \
  --assignee "$APP_ID" \
  --scope "/subscriptions/$SUBSCRIPTION_ID" || echo "ℹ️  Role assignment may already exist"

echo "✅ Role assignment completed"

echo ""
echo "🎉 OIDC Setup Complete!"
echo "====================="
echo ""
echo "📋 GitHub Environment Variables to Configure:"
echo "   Go to: GitHub → Settings → Environments → staging & production"
echo ""
echo "   AZURE_CLIENT_ID: $APP_ID"
echo "   AZURE_TENANT_ID: $TENANT_ID"
echo "   AZURE_SUBSCRIPTION_ID: $SUBSCRIPTION_ID"
echo ""
echo "📋 Next Steps:"
echo "   1. Configure the above variables in both GitHub environments"
echo "   2. Set up branch protection rules"
echo "   3. Configure production environment with required reviewers"
echo "   4. Test the workflows with a sample deployment"
echo ""
echo "📖 For detailed instructions, see the README.md file"