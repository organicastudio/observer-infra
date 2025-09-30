# Ansible Configuration

This directory contains Ansible playbooks and configurations for system automation.

## Usage

Standard Ansible workflow for configuration management and deployment automation.

### Prerequisites

- Ansible 2.9 or higher
- SSH access to target hosts
- Inventory file properly configured

### Basic Commands
```bash
# Run playbook
ansible-playbook -i inventory playbook.yml

# Check mode (dry run)
ansible-playbook -i inventory playbook.yml --check

# Target specific hosts
ansible-playbook -i inventory playbook.yml --limit webservers
```

### Directory Structure
```
ansible/
├── inventory/           # Host definitions
├── group_vars/          # Group variables
├── host_vars/           # Host-specific variables
├── roles/               # Role definitions
├── playbooks/           # Playbook files
└── ansible.cfg          # Configuration file
## Repository Policy

- No emoji in documentation, code, commits, or PRs
- No raster images (PNG, JPG, GIF, etc.)
- No vector objects with embedded raster data (SVGs must be pure vector)
- All assets and guides adhere to professional, iconoclast standards

Professional documentation standards maintained—no emoji or special formatting characters.
# Ansible Configuration

This directory contains Ansible playbooks and configurations for system automation.

## Usage

Standard Ansible workflow for configuration management and deployment automation.

## Repository Policy

- No emoji in documentation, code, commits, or PRs
- No raster images (PNG, JPG, GIF, etc.)
- No vector objects with embedded raster data (SVGs must be pure vector)
- All assets and guides adhere to professional, iconoclast standards

Professional documentation standards maintained—no emoji or special formatting characters.# Ansible Configuration

This directory contains Ansible playbooks and configurations for system automation.

## Usage

Standard Ansible workflow for configuration management and deployment automation.

## Repository Policy

- No emoji in documentation, code, commits, or PRs
- No raster images (PNG, JPG, GIF, etc.)
- No vector objects with embedded raster data (SVGs must be pure vector)
- All assets and guides adhere to professional, iconoclast standards

Professional documentation standards maintained—no emoji or special formatting characters.
# Ansible Configuration

This directory contains Ansible playbooks and configurations for system automation.

## Usage

Standard Ansible workflow for configuration management and deployment automation.

### Prerequisites
- Ansible 2.9 or higher
- SSH access to target hosts
- Inventory file properly configured

### Basic Commands
```bash
# Run playbook
ansible-playbook -i inventory playbook.yml

# Check mode (dry run)
ansible-playbook -i inventory playbook.yml --check

# Target specific hosts
ansible-playbook -i inventory playbook.yml --limit webservers
```

### Directory Structure
```
ansible/
├── inventory/           # Host definitions
├── group_vars/          # Group variables
├── host_vars/           # Host-specific variables
├── roles/               # Role definitions
├── playbooks/           # Playbook files
└── ansible.cfg          # Configuration file
```

## Repository Policy

- No emoji in documentation, code, commits, or PRs
- No raster images (PNG, JPG, GIF, etc.)
- No vector objects with embedded raster data (SVGs must be pure vector)
- All assets and guides adhere to professional, iconoclast standards

Professional documentation standards maintained—no emoji or special formatting characters.

---

## Example: Add A Record to Azure Private DNS

To add an A record to a private DNS zone in Azure, use:

```sh
az network private-dns record-set a add-record \
  --zone-name observer.internal \
  --resource-group <rg> \
  --record-set-name observer-api \
  --ipv4-address 10.10.10.X
```

Replace `<rg>` with your resource group and `10.10.10.X` with your AppGW private IP.