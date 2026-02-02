# Role: dotnet

Purpose: install .NET SDK.

- Feature flag: `enable_dotnet` (default: yes)
- Tags: `dotnet`
- Key vars: `dotnet_packages`, `dotnet_ppa_repo`

Usage:

- Run only this role: `ansible-playbook main.yml --tags dotnet`
- Adjust SDK versions in `group_vars/all.yml`.
