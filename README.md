# observer-infra

Infrastructure as Code repository for centralized IaC, networking, CAE, and CI/CD management.

## Overview

This repository contains infrastructure definitions and automation tools for the observer platform.

## Structure

- Infrastructure as Code templates and configurations
- Network topology definitions  
- Container Application Environment (CAE) specifications
- CI/CD pipeline configurations

## Usage

Follow standard infrastructure deployment practices. No emoji or non-standard characters are used in this repository to maintain professional documentation standards.

# App Gateway + AKS AGIC Validation Guide

## 1. TLS Certificate

- Ensure the Key Vault secret exists:
  - Vault: `kv-observer-prod-we-001`
  - Secret Name: `observer-tls-cert`
  - Use "latest" version for AppGW listener

> **Note:**  
> The certificate must be stored as a secret named `observer-tls-cert` in the Key Vault `kv-observer-prod-we-001`.  
> When configuring the Application Gateway listener, reference the "latest" version of this secret to ensure you use the most current certificate.

## 2. DNS Records

- Create A records for:
  - `observer-api.internal` → AppGW private IP (e.g. `10.10.10.X`)
  - `observer-admin.internal` → AppGW private IP (e.g. `10.10.10.X`)

- Example (Azure CLI):
  ```sh
  az network private-dns record-set a add-record \
    --zone-name observer.internal \
    --resource-group <rg> \
    --record-set-name observer-api \
    --ipv4-address 10.10.10.X
  ```

## 3. App Gateway Health Probes

- In Azure Portal, navigate to the App Gateway backend pool
- Confirm health probe for `observer-brain-api` is green
- If not, review probe configuration and backend health

## 4. AKS AGIC Integration

- AGIC enabled in Bicep
- AGIC mapped to the internal AppGW resource
- Minimal Ingress objects in Kubernetes; AGIC syncs to AppGW

## 5. Test Access

- From VNet or on-prem, run:
  ```sh
  curl -vk https://observer-api.internal/health/ready
  ```
  - Should return HTTP 200 OK and valid TLS

## Troubleshooting

- **TLS errors**: Check Key Vault access policies and secret version in listener config
- **DNS issues**: Ensure A records match AppGW private IP and domain
- **Probe failures**: Verify backend targets are reachable and healthy

---

_Questions? Reach out in the PR comments or tag @organicastudio._
