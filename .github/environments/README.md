# Environment Configuration

This directory contains environment-specific configuration for the observer-infra repository.

## Environments

### Staging Environment
- **Name**: `staging`
- **Deployment**: Automatic on push to main branch
- **Protection rules**: None (auto-deploy)
- **URL**: Will be configured based on your Azure setup

### Production Environment  
- **Name**: `production`
- **Deployment**: Manual approval required
- **Protection rules**: 
  - Required reviewers (to be configured in GitHub settings)
  - Manual approval gate
- **URL**: Will be configured based on your Azure setup

## OIDC Configuration

The workflows use OpenID Connect (OIDC) for secure, secretless authentication with Azure. 

### Required Environment Variables

Configure these variables in your GitHub repository settings under "Environments":

- `AZURE_CLIENT_ID`: The client ID of your Azure AD application
- `AZURE_TENANT_ID`: Your Azure AD tenant ID  
- `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID

### Setup Instructions

See the main README.md for complete OIDC setup instructions.