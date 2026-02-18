# Role: azure-cli

Purpose: install Azure CLI from Microsoft packages.

* Feature flag: `enable_azure_cli` (default: yes)
* Tags: `azure-cli`
* Key vars: `azure_cli_apt_key`, `azure_cli_apt_repo_base`
* Reference: <https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux>

## Installation Methods

This role supports multiple distributions with different installation methods:

### Debian 13 (Trixie)
* **Method**: pipx installation (Python)
* **Why**: Microsoft does not yet provide APT repository for Debian 13
* **File**: `tasks/install-pip.yml`
* **Dependencies**: python3, python3-pip, python3-venv, pipx, libffi-dev, python3-dev, build-essential
* **Location**: `~/.local/bin/az` (pipx venv)
* **Global symlink**: `/usr/local/bin/az`

### Debian 12 (Bookworm) & Ubuntu
* **Method**: Microsoft APT repository
* **File**: `tasks/install-apt-repo.yml`
* **Repository**: `packages.microsoft.com/repos/azure-cli`
* **GPG Key**: Managed in `/etc/apt/keyrings/microsoft-azure-cli.gpg`

## Architecture

```
roles/azure-cli/tasks/
├── main.yml              # Orchestrator - detects distribution and delegates
├── install-pip.yml       # pipx-based installation for Debian 13
└── install-apt-repo.yml  # APT repository installation for Debian 12/Ubuntu
```

## Usage

```bash
# Run only this role
ansible-playbook main.yml --tags azure-cli

# Test in dry-run mode
ansible-playbook main.yml --tags azure-cli --check

# Verbose mode for debugging
ansible-playbook main.yml --tags azure-cli -vvv
```

## Configuration

Azure repo/key values live in `group_vars/all.yml`:

```yaml
azure_cli_apt_key: "https://packages.microsoft.com/keys/microsoft.asc"
azure_cli_apt_repo_base: "https://packages.microsoft.com/repos/azure-cli"
```

## Verification

After installation, verify with:

```bash
az version  # Should display azure-cli version
az login    # Authenticate with Azure (interactive)
```

