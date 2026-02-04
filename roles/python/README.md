# Role: python

Purpose: install Python 3, pip, pipx, and common Python tooling.

* Feature flag: `enable_python` (default: yes)
* Tags: `python`
* Key vars: `python_packages_apt`, `python_tools_pipx`, `python_packages_pip`

Usage:

* Run only this role: `ansible-playbook main.yml --tags python`
* Adjust packages in `group_vars/all.yml` under Python sections.
