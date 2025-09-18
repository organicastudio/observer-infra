# Networking Configuration

This directory contains networking configurations and documentation for the Observer infrastructure.

## Network Architecture

### Virtual Network Design
```
observer-[environment]-vnet
├── Application Gateway Subnet (10.x.1.0/24)
├── Container Apps Subnet (10.x.2.0/23)
├── Private Endpoints Subnet (future - 10.x.4.0/24)
└── Management Subnet (future - 10.x.5.0/24)
```

### Address Spaces
- **Staging**: 10.0.0.0/16
- **Production**: 10.1.0.0/16

## Components

### Application Gateway
- **Purpose**: Layer 7 load balancing and SSL termination
- **Subnet**: Dedicated subnet with NSG rules for management traffic
- **Features**: WAF, SSL offloading, URL-based routing
- **Monitoring**: Integrated with Log Analytics

### Network Security Groups

#### Application Gateway NSG
- Allows Azure Application Gateway management traffic (ports 65200-65535)
- Allows HTTP (80) and HTTPS (443) inbound traffic
- Denies all other inbound traffic by default

### Container Apps Integration
- Dedicated subnet for Container Apps Environment
- Subnet delegation for Microsoft.App/environments
- Network isolation for container workloads
- Integration with Virtual Network for private communication

## Security Considerations

### Network Segmentation
- Separate subnets for different tiers
- Network Security Groups for traffic filtering
- Application-level security through Container Apps
- Future: Private endpoints for sensitive resources

### DNS Configuration
- Azure-provided DNS for resource resolution
- Custom DNS zones for application domains
- Integration with Application Gateway for SSL termination

### Monitoring and Logging
- Network Watcher for traffic analysis
- NSG flow logs for security monitoring
- Application Gateway logs for request tracking
- Container Apps network telemetry

## Future Enhancements

### Private Endpoints
- Azure Key Vault private endpoint
- Storage account private endpoints
- Azure Container Registry private endpoint
- SQL Database private endpoint (if applicable)

### Advanced Security
- Azure Firewall for outbound traffic control
- DDoS Protection Standard
- Web Application Firewall policies
- Network security monitoring and alerting

### Multi-Region Setup
- Virtual Network peering between regions
- Traffic Manager for global load balancing
- Disaster recovery network configuration
- Cross-region backup and replication