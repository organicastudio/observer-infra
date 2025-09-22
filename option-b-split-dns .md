# Option B: Split DNS for macOS Clients with Azure Private DNS & Private Resolver

*Created: 2025-09-20*

## Step 1 — Azure Setup

1. **Create Private DNS zone and link VNets**
    - Zone: `observer.internal`
    - Link to hub VNet and AKS/Container Apps VNets (registration disabled)

2. **Add A-records**
    - `observer-api.internal` → `<AppGW_private_IP>`
    - `observer-admin.internal` → `<AppGW_private_IP>`

3. **Deploy Azure DNS Private Resolver (inbound endpoint)**
    - In hub VNet subnet (e.g., `snet-dns-resolver`)
    - Note the inbound endpoint IP (`RESOLVER_IP`)

### Azure CLI Example
```sh
RG=rg-observer-prod-we
ZONE=observer.internal
HUB_VNET_ID="/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/vnet-observer-hub"
AKS_VNET_ID="/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/vnet-observer-aks"
APPGW_IP="<10.10.10.10>"

az network private-dns zone create -g "$RG" -n "$ZONE"
az network private-dns link vnet create -g "$RG" -n link-hub -z "$ZONE" -v "$HUB_VNET_ID" --registration-enabled false
az network private-dns link vnet create -g "$RG" -n link-aks -z "$ZONE" -v "$AKS_VNET_ID" --registration-enabled false
az network private-dns record-set a add-record -g "$RG" -z "$ZONE" -n observer-api   -a "$APPGW_IP"
az network private-dns record-set a add-record -g "$RG" -z "$ZONE" -n observer-admin -a "$APPGW_IP"

INBOUND_SUBNET_ID="/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/vnet-observer-hub/subnets/snet-dns-resolver"
az network dns-resolver create -g "$RG" -n dnspr-observer-hub --virtual-network "$HUB_VNET_ID"
az network dns-resolver inbound-endpoint create -g "$RG" --dns-resolver-name dnspr-observer-hub -n inbound \
  --ip-configurations subnet="$INBOUND_SUBNET_ID"
az network dns-resolver inbound-endpoint show -g "$RG" --dns-resolver-name dnspr-observer-hub -n inbound \
  --query "properties.ipConfigurations[0].privateIpAddress" -o tsv
```

## Step 2 — macOS Per-Domain Resolver

1. **Get `RESOLVER_IP`** from Azure step above.
2. **Ensure network reachability** to `RESOLVER_IP` on UDP/TCP 53 (VPN/private link).
3. **Configure macOS resolver:**
    ```sh
    sudo mkdir -p /etc/resolver
    sudo sh -c 'cat >/etc/resolver/observer.internal <<EOF
    nameserver RESOLVER_IP
    timeout 2
    search_order 1
    EOF'
    ```
    Replace `RESOLVER_IP` with the actual private IP.

4. **Flush DNS cache and test:**
    ```sh
    sudo dscacheutil -flushcache
    sudo killall -HUP mDNSResponder
    dig observer-api.internal +short
    dig observer-admin.internal +short
    ```
    Both should return the AppGW private IP.

## High Availability: Dual Inbound Endpoints

### Azure CLI
```sh
INBOUND_SUBNET_ID_2="/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/vnet-observer-hub/subnets/snet-dns-resolver-2"
az network dns-resolver inbound-endpoint create \
  -g "$RG" --dns-resolver-name dnspr-observer-hub -n inbound-2 \
  --ip-configurations subnet="$INBOUND_SUBNET_ID_2"

az network dns-resolver inbound-endpoint list \
  -g "$RG" --dns-resolver-name dnspr-observer-hub \
  --query "[].properties.ipConfigurations[].privateIpAddress" -o tsv
```

### macOS Dual Resolver
```sh
sudo mkdir -p /etc/resolver
sudo sh -c 'cat >/etc/resolver/observer.internal <<EOF
nameserver IP1
nameserver IP2
timeout 3
search_order 1
EOF'
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```
Replace `IP1` and `IP2` with both inbound endpoint private IPs.

## Verification

- On Mac (VPN/private path):  
  `nslookup observer-api.internal` → AppGW private IP  
  `nslookup observer-admin.internal` → AppGW private IP

- On AKS pod/VM:  
  `nslookup observer-api.internal`

- AppGW health:  
  ```sh
  az network application-gateway backend-health show -g rg-observer-prod-we -n agw-observer-ingress -o table
  ```

- TLS binding:  
  ```sh
  az network application-gateway ssl-cert list -g rg-observer-prod-we --gateway-name agw-observer-ingress -o table
  ```
  Should show `kv-observer-prod-we-001/secrets/observer-tls-cert (latest)`

## Troubleshooting

- **No answer on Mac:**  
  - Check `/etc/resolver/observer.internal` points to `RESOLVER_IP`  
  - Verify VPN/route allows UDP/TCP 53  
  - Try `dig @RESOLVER_IP observer-api.internal`

- **Wrong answer:**  
  - Check A-records in Private DNS zone  
  - Verify VNet links exist, registration disabled

- **Reachability fails:**  
  - Ensure private network connectivity

- **Intermittent timeouts:**  
  - Add second inbound endpoint IP for HA  
  - Increase timeout in `/etc/resolver/observer.internal` if needed

## Team Rollout (optional)

- Distribute `/etc/resolver/observer.internal` via MDM to macOS devices
- For mixed platforms, use central conditional forwarding on on-prem DNS servers

---

_Questions? Reach out in the PR comments or tag @organicastudio._