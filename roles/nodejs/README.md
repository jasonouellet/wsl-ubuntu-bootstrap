# Role: nodejs

Purpose: install Node.js runtime, npm, and build toolchain.

* Feature flag: `enable_nodejs` (default: yes)
* Tags: `nodejs`
* Key vars: `nodejs_version`, `nodejs_packages`, `nodejs_global_npm_packages`

Usage:

* Run only this role: `ansible-playbook main.yml --tags nodejs`
* Change Node.js version via `nodejs_version` in `group_vars/all.yml`.
