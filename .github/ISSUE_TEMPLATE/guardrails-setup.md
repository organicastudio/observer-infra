---
name: Guardrails Setup Checklist
about: Track completion of repository guardrails setup
title: 'Complete Guardrails Configuration for observer-infra'
labels: ['setup', 'security', 'guardrails']
assignees: ''
---

## Repository Guardrails Setup Checklist

This issue tracks the completion of security guardrails for the observer-infra repository.

### ✅ GitHub Actions Workflows (Automated)
- [x] Branch protection workflow created
- [x] Staging deployment workflow created  
- [x] Production deployment workflow created
- [x] OIDC authentication configured in workflows

### 🔧 Manual Configuration Required

#### Branch Protection Rules
- [ ] Navigate to `Settings → Branches`
- [ ] Add protection rule for `main` branch
- [ ] Enable "Require status checks to pass before merging"
- [ ] Select "required-checks" as required status check
- [ ] Enable "Require branches to be up to date before merging"
- [ ] Enable "Require linear history" 
- [ ] Enable "Include administrators"

#### Azure AD Application Setup
- [ ] Create Azure AD application for GitHub Actions
- [ ] Configure federated identity credentials for staging
- [ ] Configure federated identity credentials for production
- [ ] Assign appropriate Azure roles (e.g., Contributor)
- [ ] Note down: Client ID, Tenant ID, Subscription ID

#### GitHub Environments
- [ ] Navigate to `Settings → Environments`
- [ ] Create "staging" environment (no protection rules needed)
- [ ] Create "production" environment
- [ ] Configure production environment with required reviewers
- [ ] Add environment variables to both environments:
  - [ ] `AZURE_CLIENT_ID`
  - [ ] `AZURE_TENANT_ID` 
  - [ ] `AZURE_SUBSCRIPTION_ID`

### 🧪 Testing
- [ ] Create test PR to verify branch protection works
- [ ] Test staging deployment (should auto-deploy on main push)
- [ ] Test production deployment (should require manual approval)
- [ ] Verify OIDC authentication works with Azure

### 📋 Documentation
- [x] README.md updated with guardrails documentation
- [x] Setup instructions provided
- [x] Environment configuration documented

### ✅ Verification
- [ ] All required status checks pass
- [ ] Staging deployments work automatically  
- [ ] Production deployments require approval
- [ ] OIDC authentication eliminates need for stored secrets

---

## Notes

Add any additional notes or customizations needed for your specific Azure setup.

Close this issue once all checklist items are completed and verified working.