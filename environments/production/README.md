# Production Environment Configuration

## Overview
The production environment hosts live workloads and requires manual approval for deployments.

## Manual Approval Required
- All deployments require manual approval through GitHub Environments
- Protected with environment-specific policies
- Enhanced security and monitoring

## Resources
- Resource Group: `observer-production-rg`
- Virtual Network: `10.1.0.0/16`
- Location: East US
- Environment Tag: `production`

## Security
- Enhanced Key Vault protection with purge protection
- Network security groups with restrictive rules
- RBAC-based access control
- Audit logging enabled

## Monitoring
- Log Analytics workspace with 90-day retention
- Application Insights with advanced features
- Production-grade alerting and monitoring
- Performance monitoring and optimization

## Deployment Process
1. Changes tested in staging environment
2. Manual trigger of production deployment workflow
3. Required approvers must approve deployment
4. Automated deployment with rollback capability