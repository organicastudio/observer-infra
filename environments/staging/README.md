# Staging Environment Configuration

## Overview
The staging environment is used for integration testing and validation before production deployments.

## Auto-Deployment
- Automatically deployed when changes are merged to the main branch
- No manual approval required
- Enables rapid iteration and testing

## Resources
- Resource Group: `observer-staging-rg`
- Virtual Network: `10.0.0.0/16`
- Location: East US
- Environment Tag: `staging`

## Access
- Development team has access
- Used for pre-production testing
- Integration with test data

## Monitoring
- Log Analytics workspace with 30-day retention
- Application Insights enabled
- Basic monitoring and alerting