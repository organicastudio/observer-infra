#!/bin/bash

# Infrastructure Cleanup Script
# This script destroys infrastructure in the specified environment

set -e

# Check if environment is provided
if [ -z "$1" ]; then
    echo "❌ Usage: $0 <environment>"
    echo "   Environment: staging or production"
    exit 1
fi

ENVIRONMENT=$1

# Validate environment
if [[ "$ENVIRONMENT" != "staging" && "$ENVIRONMENT" != "production" ]]; then
    echo "❌ Invalid environment. Must be 'staging' or 'production'"
    exit 1
fi

# Confirmation for production
if [ "$ENVIRONMENT" = "production" ]; then
    echo "⚠️  WARNING: You are about to destroy the PRODUCTION environment!"
    echo "This action is irreversible and will delete all resources."
    read -p "Type 'DESTROY-PRODUCTION' to confirm: " confirmation
    if [ "$confirmation" != "DESTROY-PRODUCTION" ]; then
        echo "❌ Confirmation failed. Aborting."
        exit 1
    fi
fi

echo "🧹 Cleaning up $ENVIRONMENT environment..."

# Navigate to infrastructure directory
cd "$(dirname "$0")/../infrastructure"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "❌ Terraform is not installed. Please install it first."
    exit 1
fi

# Initialize Terraform
echo "⚙️  Initializing Terraform..."
terraform init \
    -backend-config="resource_group_name=observer-tfstate-rg" \
    -backend-config="storage_account_name=observertfstate" \
    -backend-config="container_name=tfstate" \
    -backend-config="key=${ENVIRONMENT}.terraform.tfstate"

# Plan destroy
echo "📋 Planning destruction..."
terraform plan -destroy -var-file="environments/${ENVIRONMENT}.tfvars" -out="${ENVIRONMENT}-destroy.tfplan"

# Show plan and ask for confirmation
echo "📖 Destruction plan created. Review the plan above."
read -p "Do you want to proceed with destruction? (yes/no): " proceed

if [ "$proceed" != "yes" ]; then
    echo "❌ Destruction cancelled."
    exit 1
fi

# Apply destruction
echo "💥 Destroying infrastructure..."
terraform apply "${ENVIRONMENT}-destroy.tfplan"

# Clean up plan file
rm -f "${ENVIRONMENT}-destroy.tfplan"

echo "✅ $ENVIRONMENT environment cleanup complete!"

if [ "$ENVIRONMENT" = "production" ]; then
    echo "🎯 Production environment has been destroyed."
    echo "   All data and resources have been permanently deleted."
fi