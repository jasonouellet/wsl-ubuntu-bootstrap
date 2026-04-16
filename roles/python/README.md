# Role: python

Purpose: install Python 3, pip, pipx, and common Python tooling.

* Feature flag: `enable_python` (default: yes)
* Tags: `python`
* Key vars: `python_packages_apt`, `python_tools_pipx`, `python_packages_pip`

## pipx installation scope

Python CLI tools managed by `pipx` are installed **globally** for all users:

* `PIPX_HOME=/opt/pipx`
* `PIPX_BIN_DIR=/usr/local/bin`

This makes tools like `pre-commit`, `ansible-lint`, and `yamllint`
available from a shared system path instead of per-user `~/.local/bin`.

## Verification

After role execution, you can validate availability with:

* `[tool cli] --version`
* `which [tool cli]` (expected: `/usr/local/bin/[tool cli]`)

Usage:

* Run only this role: `ansible-playbook main.yml --tags python`
* Adjust packages in `group_vars/all.yml` under Python sections.
