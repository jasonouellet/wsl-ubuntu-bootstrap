# Role: common

Purpose: base system setup, sudo configuration, dev tools.

* Feature flag: `enable_common` (default: yes)
* Tags: `common`
* Key vars: `common_configure_nopasswd_sudo`, `common_packages_linux`

Usage:

* Run only this role: `ansible-playbook main.yml --tags common`
* Configure sudo NOPASSWD: adjust `common_configure_nopasswd_sudo` in `group_vars/all.yml`.
