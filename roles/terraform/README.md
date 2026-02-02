# Role: terraform

Purpose: install Terraform and related HashiCorp tools.

* Feature flag: `enable_terraform` (default: yes)
* Tags: `terraform`
* Key vars: `hashicorp_packages`, `hashicorp_apt_key`, `hashicorp_apt_repo_url`

Usage:

* Run only this role: `ansible-playbook main.yml --tags terraform`
* Adjust packages in `group_vars/all.yml` under Hashicorp Tools.
