# Role: dotnet

Purpose: install .NET SDK.

* Feature flag: `enable_dotnet` (default: yes)
* Tags: `dotnet`
* Key vars: `dotnet_packages`
* Reference: <https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-install>

Usage:

* Run only this role: `ansible-playbook main.yml --tags dotnet`
* Adjust SDK versions in `group_vars/all.yml`.
