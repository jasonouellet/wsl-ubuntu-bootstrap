# Role: azure-cli

Purpose: install Azure CLI from Microsoft packages.

* Feature flag: `enable_azure_cli` (default: yes)
* Tags: `azure-cli`
* Key vars: `azure_cli_apt_key`, `azure_cli_apt_repo_base`
* Reference: <https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux>

## Installation Method

This role now uses a single installation method:

* **Method**: Microsoft APT repository
* **File**: `tasks/install-apt-repo.yml`
* **Repository**: `packages.microsoft.com/repos/azure-cli`
* **GPG Key**: Managed in `/etc/apt/keyrings/microsoft-azure-cli.gpg`

## Distribution handling

According to Microsoft Learn, Azure CLI APT packages are currently tested on:

* **Debian**: 11 (Bullseye), 12 (Bookworm)
* **Ubuntu**: 22.04 (Jammy), 24.04 (Noble)

For newer Debian or Ubuntu releases where no package is yet published, the
role keeps a version check and falls back to the latest documented repository
suite:

* newer **Debian** releases use `bookworm`
* newer **Ubuntu** releases use `jammy`

If `enable_external_repositories` is disabled, the role fails explicitly because
the official Microsoft installation method requires the Microsoft package
repository.

## Architecture

```
roles/azure-cli/tasks/
├── main.yml              # Orchestrator - selects repository suite
│                         # and validates prerequisites
└── install-apt-repo.yml  # Microsoft APT repository installation
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
azure_cli_apt_repo_base: "https://packages.microsoft.com/repos/azure-cli/"
```

## Verification

After installation, verify with:

```bash
az version  # Should display azure-cli version
az login    # Authenticate with Azure (interactive)
```
