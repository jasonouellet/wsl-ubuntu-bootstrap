# WSL Ubuntu Bootstrap - AI Agent Instructions

## Project Overview

This is an **Ansible playbook** automating DevOps environment setup on
WSL/Debian/Ubuntu systems. It orchestrates 8 independent roles that install
tools (Python, Node.js, .NET, Terraform, containers, Azure CLI, SSL/TLS,
maintenance).

## Architecture & Key Patterns

### 1. Role-Based Organization

Each role in `roles/` is **independent** with a consistent structure:

```text
role-name/
├── defaults/main.yml    # Default variables (can be overridden)
├── tasks/main.yml       # Main installation logic
├── handlers/main.yml    # Event handlers (triggered by tasks)
├── vars/                # Role-specific variables
```

**Critical Pattern**: Roles are conditionally executed via Ansible tags and
boolean gates in [main.yml](main.yml):

```yaml
- name: python
  tags: python
  when: enable_python  # Variable in group_vars/all.yml
```

### 2. Variable Architecture

* **Global variables**: [group_vars/all.yml](group_vars/all.yml) - contains
  ALL package lists, URLs, and configuration
* **Custom variables**: Users create `group_vars/custom.yml` (copy from
  `custom.yml.example`) for environment-specific overrides
* **No hardcoded values** in tasks - always reference variables

### 3. Task Patterns

All roles follow this execution sequence:

1. **Prepare**: Create directories, download GPG keys, add APT repositories
2. **Install**: Use `ansible.builtin.apt` or `ansible.builtin.pip` modules
3. **Verify**: Run version checks or status commands (register output, use
   `changed_when: false`)
4. **Display**: Show installed versions via `ansible.builtin.debug`

Example from [python role](roles/python/tasks/main.yml):

```yaml
- name: Install Python packages (APT)
  ansible.builtin.apt:
    name: "{{ python_packages_apt }}"  # Variable from all.yml
    state: present
```

### 4. Tag System

Every task must have tags. Common tags:

* `common`, `python`, `nodejs`, `terraform`, `dotnet`, `azure-cli`,
  `containers`, `ssl-config`, `maintenance`
* `packages`, `repository`, `gpg` (cross-cutting concerns)
* `security`, `sudo` (for sensitive operations)

Usage: `ansible-playbook main.yml --tags python` or
`ansible-playbook main.yml --skip-tags maintenance`

### 5. Repository and Key Management

Roles use the **modern APT key method**:

```yaml
- name: Add repository with signed GPG key
  ansible.builtin.apt_repository:
    repo: "deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp.gpg] main"
```

See [terraform role](roles/terraform/tasks/main.yml) for example.
**Avoid deprecated `apt_key` module**.

### 6. Conditional System Checks

All playbooks validate prerequisites:

```yaml
- name: Check if system is Ubuntu/Debian
  ansible.builtin.fail:
    msg: "This playbook is only supported on Debian-based systems."
  when: ansible_os_family != "Debian"
  tags:
    - always
```

## Critical Workflows

### Running the Playbook

```bash
# Syntax validation (includes ansible-lint checks)
./validate.sh

# Dry-run (no changes applied)
ansible-playbook main.yml --check

# First execution (prompts for sudo password)
ansible-playbook main.yml -K

# Selective execution by role
ansible-playbook main.yml --tags nodejs
ansible-playbook main.yml --skip-tags maintenance --check
```

### Testing Individual Roles

```bash
./test-role.sh <role-name> [-K] [run]
./test-role.sh python              # Dry-run without sudo
./test-role.sh terraform -K        # Dry-run with sudo
./test-role.sh nodejs -K run       # Execute with changes
```

### Configuration Customization

1. Copy `group_vars/custom.yml.example` → `group_vars/custom.yml`
2. Edit to override variables: `enable_maintenance: no`,
   `nodejs_version: "20"`, etc.
3. Variables in `custom.yml` override `all.yml` defaults

## Important Configuration Details

### Ansible Configuration

File: [ansible.cfg](ansible.cfg)

* `connection: local` (no remote SSH)
* `fact_caching: jsonfile` (caches system info in `.ansible/facts/`)
* Fact cache timeout: 86400s (24 hours)
* Parallel execution: 10 forks for concurrent installs

### Sudo Configuration

The `common` role auto-configures **sudoers for NOPASSWD** if
`configure_nopasswd_sudo: yes` (default in
[all.yml](group_vars/all.yml)). This allows subsequent playbook runs
without `-K` flag. Security: sudoers file validated with `visudo -cf %s`.

### Distribution Compatibility

* Targets: Debian/Ubuntu (validates `ansible_os_family == "Debian"`)
* Distro codename auto-detected: `ansible_lsb.codename` → used for package
  repo selection
* Playbook detects and displays: OS family, distro description, LSB info

### Python Packages

The role installs both APT and pip packages:

* **APT**: `python3-full`, `python3-pip`, `python3-virtualenv`,
  `python3-setuptools`
* **PIP**: Pre-commit, linters (pylint, black), documentation tools
  (mkdocs, plantuml-markdown)
* Executable path: `/usr/bin/pip3` (explicit in tasks)

### Package Lists Location

All package lists are in `group_vars/all.yml`:

* `common_packages_linux` - base system
* `python_packages_apt` and `python_packages_pip` - Python ecosystem
* `hashicorp_packages` - Terraform, Vault, Nomad, Consul, Boundary, Packer
* `container_packages` - Buildah, Skopeo (OCI tools)
* `dotnet_packages` - .NET SDK
* `nodejs_packages` - build tools (gcc, g++, make)

## Common Modifications

### Adding a New Package

1. Add to appropriate list in [group_vars/all.yml](group_vars/all.yml)
2. Reference via variable in task: `name: "{{ list_name }}"`
3. Add tags to task: `tags: [role-name, packages]`
4. Test: `./test-role.sh role-name --check`

### Creating New Role

1. Create `roles/new-role/{defaults,tasks,handlers,vars}/main.yml`
2. Add installation tasks with tags (always include role name tag)
3. Reference variables from [all.yml](group_vars/all.yml) or role `defaults/`
4. Update [main.yml](main.yml): add role block with
   `when: enable_new_role` condition
5. Add variable to [all.yml](group_vars/all.yml): `enable_new_role: yes`

### Handling External URLs/Keys

* Store URLs in variables (`group_vars/all.yml`)
* Use `ansible.builtin.get_url` for downloads with checksums when possible
* GPG keys downloaded, converted with `gpg --dearmor`, stored in
  `/etc/apt/keyrings/`
* Never hardcode tokens/credentials (use `group_vars/custom.yml` for secrets)

## File References

| File | Purpose |
|------|---------|
| [main.yml](main.yml) | Playbook entry point - orchestrates all roles |
| [group_vars/all.yml](group_vars/all.yml) | Global variables (packages, URLs, enable flags) |
| [roles/*/tasks/main.yml](roles) | Core installation logic for each role |
| [validate.sh](validate.sh) | Pre-execution validation (Ansible, ansible-lint, syntax) |
| [test-role.sh](test-role.sh) | Role-level testing with dry-run support |
| [ansible.cfg](ansible.cfg) | Ansible runtime config (cache, callbacks, SSH) |

## Code Quality

* **Validation**: `./validate.sh` runs ansible-lint (see
  [.ansible-lint](.ansible-lint))
* **Naming**: Tasks use YAML style (lowercase, dash-separated) and
  descriptive names
* **Idempotency**: All tasks designed to be repeatable - use `state: present`,
  `changed_when: false` for read-only operations
* **Comments**: Header comments in `.yml` files document playbook intent and
  usage examples
