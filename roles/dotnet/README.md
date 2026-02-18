# Role: dotnet

Purpose: install .NET SDK.

* Feature flag: `enable_dotnet` (default: yes)
* Tags: `dotnet`
* Key vars: `dotnet_packages`
* Reference: <https://learn.microsoft.com/en-us/dotnet/core/install/linux-debian>

## Installation Methods

This role supports multiple distributions with different installation methods:

### Debian 13 (Trixie)
* **Method**: Official Microsoft installation script
* **Why**: Microsoft does not yet provide APT repository for Debian 13
* **File**: `tasks/install-debian-13.yml`
* **Dependencies**: libicu76, libc6, libgcc-s1, libgssapi-krb5-2, libssl3t64, libstdc++6, zlib1g
* **Location**: `/usr/local/dotnet`
* **Global PATH**: Configured via `/etc/profile.d/dotnet.sh`

### Debian 12 (Bookworm) & Ubuntu
* **Method**: Microsoft APT repository
* **File**: `tasks/install-apt-repo.yml`
* **Repository**: `packages.microsoft.com/{debian|ubuntu}/<version>/prod`
* **GPG Key**: Managed in `/etc/apt/keyrings/microsoft-archive-keyring.gpg`

## Architecture

```
roles/dotnet/tasks/
├── main.yml                 # Orchestrator - detects distribution and delegates
├── install-debian-13.yml    # Script-based installation for Debian 13
└── install-apt-repo.yml     # APT repository installation for Debian 12/Ubuntu
```

## Usage

```bash
# Run only this role
ansible-playbook main.yml --tags dotnet

# Test in dry-run mode
ansible-playbook main.yml --tags dotnet --check

# Verbose mode for debugging
ansible-playbook main.yml --tags dotnet -vvv
```

## Configuration

Adjust SDK versions in `group_vars/all.yml`:

```yaml
dotnet_packages:
  - dotnet-sdk-8.0
```

## Verification

After installation, verify with:

```bash
dotnet --version  # Should display 8.0.x
```

