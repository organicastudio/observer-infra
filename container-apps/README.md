# Container Apps Configuration

This directory contains configuration files and templates for Azure Container Apps.

## Structure

```
container-apps/
├── environments/        # Environment-specific container app configs
├── templates/          # Reusable container app templates
└── README.md          # This file
```

## Container Apps Environment

The Container Apps Environment is provisioned through the Terraform infrastructure and provides:

- Managed Kubernetes environment
- Integrated with Virtual Network
- Log Analytics integration
- Automatic scaling and load balancing

## Application Deployment

### Using GitHub Actions
Applications can be deployed using GitHub Actions workflows that:
1. Build container images
2. Push to Azure Container Registry
3. Deploy to Container Apps Environment
4. Configure ingress and scaling rules

### Direct Deployment
```bash
# Example container app deployment
az containerapp create \
  --name my-app \
  --resource-group observer-staging-rg \
  --environment observer-staging-cae \
  --image nginx:latest \
  --target-port 80 \
  --ingress external
```

## Best Practices

### Configuration
- Use environment variables for configuration
- Store secrets in Azure Key Vault
- Configure health checks and readiness probes
- Set appropriate resource limits

### Scaling
- Configure auto-scaling rules based on metrics
- Set minimum and maximum replica counts
- Use horizontal scaling for stateless applications
- Monitor scaling events and adjust as needed

### Security
- Use managed identity for Azure resource access
- Network isolation through Virtual Network integration
- Enable container app security features
- Regular security scanning of container images

## Monitoring

### Built-in Monitoring
- Container Apps provides built-in metrics
- Integration with Azure Monitor
- Log streaming and diagnostics
- Performance monitoring

### Custom Monitoring
- Application-specific metrics
- Custom dashboards in Azure Monitor
- Alerting rules for application health
- Distributed tracing integration