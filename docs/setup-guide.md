# Infrastructure Setup and Deployment Guide

## Prerequisites

### Azure Setup
1. Azure subscription with appropriate permissions
2. Service Principal or Managed Identity for GitHub Actions
3. Storage account for Terraform state (recommended)

### Required Azure Resources (Pre-deployment)
```bash
# Create resource group for Terraform state
az group create --name observer-tfstate-rg --location "East US"

# Create storage account for Terraform state
az storage account create \
  --name observertfstate \
  --resource-group observer-tfstate-rg \
  --location "East US" \
  --sku Standard_LRS

# Create container for Terraform state
az storage container create \
  --name tfstate \
  --account-name observertfstate
```

### GitHub Secrets Configuration

#### Required Secrets
Set up these secrets in your GitHub repository:

```
AZURE_CLIENT_ID=<service-principal-client-id>
AZURE_TENANT_ID=<azure-tenant-id>
AZURE_SUBSCRIPTION_ID=<azure-subscription-id>
```

#### OIDC Configuration
For secretless authentication, configure OIDC:

1. Create App Registration in Azure AD
2. Configure federated credentials for GitHub Actions
3. Assign appropriate permissions to the service principal

## Deployment Process

### 1. Initial Setup
```bash
# Clone the repository
git clone https://github.com/organicastudio/observer-infra
cd observer-infra

# Initialize Terraform (if running locally)
cd infrastructure
terraform init \
  -backend-config="resource_group_name=observer-tfstate-rg" \
  -backend-config="storage_account_name=observertfstate" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=staging.terraform.tfstate"
```

### 2. Staging Deployment
Staging is automatically deployed when changes are merged to main branch.

### 3. Production Deployment
Production deployment requires manual approval:

1. Go to Actions tab in GitHub
2. Select "Deploy to Production" workflow
3. Click "Run workflow"
4. Type "CONFIRM" when prompted
5. Approve deployment in the production environment

## Environment Management

### GitHub Environments Setup
Configure these environments in GitHub repository settings:

#### Staging Environment
- No protection rules (auto-deploy)
- Environment variables as needed
- Secrets for staging-specific configurations

#### Production Environment
- Required reviewers (recommended: 2+ approvers)
- Deployment timeout: 30 minutes
- Environment variables for production
- Production-specific secrets

### Branch Protection
Configure main branch protection:
- Require pull request reviews
- Require status checks to pass
- Restrict pushes to specific users/teams
- Require branches to be up to date before merging

## Security Best Practices

### Secrets Management
- Use Azure Key Vault for application secrets
- Store infrastructure secrets in GitHub Secrets
- Rotate secrets regularly
- Use OIDC instead of service principal secrets when possible

### Network Security
- Virtual networks with proper subnetting
- Network Security Groups with minimal required access
- Application Gateway for SSL termination
- Private endpoints for sensitive resources (future enhancement)

### Access Control
- RBAC for Azure resources
- GitHub team-based access control
- Environment-specific approvers
- Audit logging enabled

## Monitoring and Observability

### Log Analytics
- Centralized logging for all resources
- Different retention policies per environment
- Custom queries and alerts

### Application Insights
- Application performance monitoring
- Dependency tracking
- Custom telemetry and metrics

### Alerting
- Infrastructure health alerts
- Performance degradation alerts
- Security alerts for suspicious activity

## Troubleshooting

### Common Issues

#### Terraform State Lock
If Terraform state is locked:
```bash
# List locks
az storage blob list --container-name tfstate --account-name observertfstate

# Force unlock (use with caution)
terraform force-unlock <lock-id>
```

#### GitHub Actions Failures
- Check Azure permissions
- Verify secrets configuration
- Review Terraform plan for conflicts
- Check resource quotas and limits

#### Network Connectivity
- Verify subnet configurations
- Check NSG rules
- Validate routing tables
- Test DNS resolution

### Support Contacts
- Infrastructure Team: [infrastructure@example.com]
- On-call Support: [oncall@example.com]
- Emergency Escalation: [emergency@example.com]