# observer-infra
Centralize all IaC, networking, CAE, and CI/CD

## 🛡️ Guardrails and Security

This repository implements comprehensive guardrails to protect the main branch and ensure secure deployments.

### Branch Protection

The main branch is protected with:
- ✅ Required status checks via GitHub Actions workflows
- ✅ Automated validation on all pull requests
- ✅ Security scanning and infrastructure validation
- ✅ Required reviews (configure in GitHub repository settings)

### Environment Strategy

#### 🟢 Staging Environment
- **Automatic deployment** on push to main branch
- Used for testing and validation
- No manual approval required
- Deployed via `.github/workflows/deploy-staging.yml`

#### 🔴 Production Environment  
- **Manual approval required** for all deployments
- Protected environment with review gates
- Triggered via manual workflow dispatch
- Deployed via `.github/workflows/deploy-production.yml`

### 🔐 OIDC Authentication with Azure

This repository uses OpenID Connect (OIDC) for secure, secretless authentication with Azure.

#### Benefits of OIDC:
- ❌ No stored secrets or service principal keys
- ✅ Short-lived tokens with automatic rotation
- ✅ Enhanced security and auditability
- ✅ Reduced credential management overhead

#### Setup Instructions:

1. **Create Azure AD Application**:
   ```bash
   az ad app create --display-name "observer-infra-github-actions"
   ```

2. **Configure Federated Identity Credentials**:
   ```bash
   # For staging environment (main branch)
   az ad app federated-credential create \
     --id <APP_ID> \
     --parameters '{
       "name": "observer-infra-staging",
       "issuer": "https://token.actions.githubusercontent.com",
       "subject": "repo:organicastudio/observer-infra:ref:refs/heads/main",
       "description": "GitHub Actions - Staging",
       "audiences": ["api://AzureADTokenExchange"]
     }'

   # For production environment (manual dispatch)
   az ad app federated-credential create \
     --id <APP_ID> \
     --parameters '{
       "name": "observer-infra-production",
       "issuer": "https://token.actions.githubusercontent.com",
       "subject": "repo:organicastudio/observer-infra:environment:production",
       "description": "GitHub Actions - Production", 
       "audiences": ["api://AzureADTokenExchange"]
     }'
   ```

3. **Assign Azure Permissions**:
   ```bash
   # Assign appropriate roles to the service principal
   az role assignment create \
     --role "Contributor" \
     --assignee <APP_ID> \
     --scope "/subscriptions/<SUBSCRIPTION_ID>"
   ```

4. **Configure GitHub Environment Variables**:
   
   Navigate to: `Settings → Environments` and add these variables:
   
   **For both staging and production environments**:
   - `AZURE_CLIENT_ID`: Your Azure AD application client ID
   - `AZURE_TENANT_ID`: Your Azure AD tenant ID
   - `AZURE_SUBSCRIPTION_ID`: Your Azure subscription ID

5. **Configure Production Environment Protection**:
   
   In GitHub repository settings:
   - Go to `Settings → Environments → production`
   - Enable "Required reviewers"
   - Add team members who can approve production deployments
   - Set deployment timeout if needed

## 🚀 Deployment Workflows

### Staging Deployment
Automatically triggered on push to main branch:
```bash
# Happens automatically when PR is merged to main
git push origin main
```

### Production Deployment
Manually triggered with approval required:
1. Go to `Actions` tab in GitHub
2. Select "Deploy to Production" workflow
3. Click "Run workflow"
4. Type "DEPLOY" to confirm
5. Wait for manual approval from designated reviewers
6. Deployment proceeds after approval

## 📋 Required Repository Settings

To complete the guardrails setup, configure these repository settings:

### Branch Protection Rules (Settings → Branches)
- ✅ Protect main branch
- ✅ Require status checks: "required-checks"
- ✅ Require branches to be up to date before merging  
- ✅ Require linear history
- ✅ Include administrators

### Environment Protection (Settings → Environments)
- ✅ Create "staging" environment (no protection rules)
- ✅ Create "production" environment with:
  - Required reviewers
  - Deployment timeout (optional)

## 🔍 Monitoring and Observability

All deployment workflows include:
- Pre-deployment validation
- Post-deployment health checks
- Comprehensive logging
- Success/failure notifications

## 📖 Additional Resources

- [GitHub Environments Documentation](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Azure OIDC with GitHub Actions](https://docs.microsoft.com/en-us/azure/active-directory/workload-identities/workload-identity-federation-create-trust-github)
- [Branch Protection Rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/defining-the-mergeability-of-pull-requests/about-protected-branches)
