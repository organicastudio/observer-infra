# Observer Infrastructure

This repository contains all Infrastructure as Code (IaC), networking configurations, Container App Environment (CAE) setups, and CI/CD workflows for the Observer platform.

## Repository Structure

```
observer-infra/
├── infrastructure/          # Terraform modules and configurations
│   ├── modules/            # Reusable Terraform modules
│   └── environments/       # Environment-specific configurations
├── networking/             # Network configurations and rules
├── container-apps/         # Container App Environment configurations
├── .github/workflows/      # GitHub Actions CI/CD pipelines
├── environments/           # Environment-specific settings
│   ├── staging/           # Staging environment configs
│   └── production/        # Production environment configs
├── docs/                  # Documentation
└── scripts/               # Utility scripts
```

## Getting Started

### Prerequisites

- Azure CLI installed and authenticated
- Terraform >= 1.0
- GitHub CLI (optional)
- Appropriate Azure permissions

### Deployment Workflow

1. **Staging Environment**: Automatically deployed on PR merge to main
2. **Production Environment**: Manual approval required through GitHub Environments

### Security

- OIDC authentication configured for secretless Azure deployments
- Branch protection enabled on main branch
- Environment-based approval workflows
- Sensitive values stored in Azure Key Vault

## Environments

### Staging
- Auto-deployment enabled
- Used for integration testing and validation
- Accessible to development team

### Production
- Manual approval required
- Protected with environment-specific policies
- Production-grade security and monitoring

## Contributing

1. Create feature branch from main
2. Make changes following the established patterns
3. Test in staging environment
4. Create PR with appropriate reviewers
5. Deploy to production after approval

## Infrastructure Components

- **Application Gateway**: Layer 7 load balancing and SSL termination
- **Key Vault**: Secrets and certificate management  
- **Container Apps**: Serverless container hosting
- **Virtual Network**: Network isolation and security
- **Log Analytics**: Monitoring and observability

## Support

For questions or issues, please create an issue in this repository or contact the infrastructure team.
