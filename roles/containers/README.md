# Role: containers

Purpose: install OCI tooling (Buildah, Skopeo).

- Feature flag: `enable_containers` (default: yes)
- Tags: `containers`
- Key vars: `container_packages`

Usage:

- Run only this role: `ansible-playbook main.yml --tags containers`
- Customize packages in `group_vars/all.yml`.
