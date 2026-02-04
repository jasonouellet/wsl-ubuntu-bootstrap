# Role: azure-cli

Purpose: install Azure CLI from Microsoft packages.

* Feature flag: `enable_azure_cli` (default: yes)
* Tags: `azure-cli`
* Key vars: `azure_cli_apt_key`, `azure_cli_apt_repo_base`

Usage:

* Run only this role: `ansible-playbook main.yml --tags azure-cli`
* Azure repo/key values live in `group_vars/all.yml`.
