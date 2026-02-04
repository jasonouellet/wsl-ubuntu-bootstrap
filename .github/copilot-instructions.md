# WSL Ubuntu Bootstrap - AI Agent Instructions

## Project Overview

This is an **Ansible playbook** automating DevOps environment setup on
WSL/Debian/Ubuntu systems. It orchestrates independent roles that install
tools (Python, Node.js, .NET, Terraform, containers, Azure CLI, GitHub CLI,
SSL/TLS, maintenance). The playbook is idempotent, follows Ansible best
practices, and supports selective execution via tags and role enablement.

## Architecture & Key Patterns

### 1. Role-Based Organization

Each role in `roles/` is **independent** with a consistent structure:

```text
role-name/
├── defaults/main.yml      # Default role variables (can be overridden)
├── tasks/main.yml         # Main installation logic
├── handlers/main.yml      # Event handlers (triggered by task notifications)
├── vars/                  # Role-specific variables (not in defaults/)
└── README.md              # Role documentation (optional)

```

**Roles Available**:

* `common` - Base system packages, sudo configuration, OS validation
* `ssl-config` - SSL/TLS and CA certificate configuration
* `python` - Python 3, pipx, pip packages, and CLI tools
* `nodejs` - Node.js via NodeSource, npm, and build tools
* `dotnet` - .NET SDK installation
* `terraform` - Terraform and all Hashicorp tools
  (Vault, Consul, Nomad, Packer, Boundary)
* `azure-cli` - Azure CLI with repository and GPG key
* `github-cli` - GitHub CLI for automation
* `containers` - OCI tools (buildah, skopeo)
* `maintenance` - System updates and cron configuration

**Critical Pattern**: Roles are conditionally executed via Ansible tags and
boolean gates in [main.yml](main.yml):

```yaml
- name: python
  tags: python
  when: enable_python  # Variable: enable_python (in group_vars/all.yml)

```

**Variable Naming Convention**: All role enable flags follow pattern:
`enable_<role-name>` (e.g., `enable_python`, `enable_terraform`,
`enable_azure_cli`)

### 2. Variable Architecture

Variables follow a **hierarchical override system**:

1. **Role defaults** (`roles/<role>/defaults/main.yml`):
   * Provide fallback values
   * Always include a default enable flag: `enable_<role>: yes`

2. **Global variables** ([group_vars/all.yml](group_vars/all.yml)):
   * Contains ALL package lists, URLs, and shared configuration
   * Prefixed by component: `python_packages_apt`, `terraform_packages`,
     `nodejs_version`
   * Enable flags: `enable_python`, `enable_terraform`, etc.

3. **Custom variables** (`group_vars/custom.yml`):
   * User-created file (copy from `custom.yml.example`)
   * Overrides `all.yml` for environment-specific settings
   * Example: disable specific roles, change Node.js version, set custom CA cert

**Critical Rule**:

* **NO hardcoded values in tasks** - always use variables
* All URLs, package versions, and paths must reference `group_vars/`
* Role-specific variables can be in role `defaults/` or `vars/`

### 3. Task Patterns

All roles follow this execution sequence:

1. **Prepare**: Create directories, download GPG keys, add APT repositories
2. **Install**: Use `ansible.builtin.apt`, `ansible.builtin.pip`, or
   `ansible.builtin.shell` modules
3. **Verify**: Run version checks or status commands (register output, use
   `changed_when: false`)
4. **Display**: Show installed versions via `ansible.builtin.debug`

**Key Module Usage**:

```yaml
# Package installation (idempotent)
- name: Install Python packages (APT)
  ansible.builtin.apt:
    name: "{{ python_packages_apt }}"
    state: present
    update_cache: true
  tags:
    - python
    - packages

# GPG key management (modern method with dearmoring)
- name: Add Hashicorp GPG key
  ansible.builtin.get_url:
    url: "{{ hashicorp_apt_key }}"
    dest: /tmp/hashicorp-archive-keyring.asc

- name: Convert and install GPG key
  ansible.builtin.shell: |
    gpg --dearmor < /tmp/hashicorp-archive-keyring.asc > /etc/apt/keyrings/hashicorp.gpg
  args:
    creates: /etc/apt/keyrings/hashicorp.gpg

# Repository addition (modern signed method)
- name: Add Hashicorp APT repository
  ansible.builtin.apt_repository:
    repo: >
      deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp.gpg]
      {{ hashicorp_apt_repo_url }} {{ distro_codename }} main

# Verification (read-only, never changes)
- name: Verify package installation
  ansible.builtin.command: dpkg -l git
  changed_when: false
  tags:
    - common
    - test

```

**Important Patterns**:

* Use `update_cache: true` when adding repositories
* Use `changed_when: false` for verification/status checks
* Use `args: creates: /path` to prevent re-running shell commands
* Always tag verification tasks with `test` tag
* Avoid deprecated `apt_key` module - use modern `signed-by=` method

### 4. Tag System

Every task must have **at least one tag**. Tags enable selective execution and filtering.

**Tag Categories**:

| Category | Purpose | Examples |
|----------|---------|----------|
| **Role Tags** | Execute entire role | `common`, `python`, `nodejs`, `terraform`, `dotnet`, `azure-cli`, `github-cli`, `containers`,`ssl-config`, `maintenance` |
| **Cross-cutting** | Shared operations | `packages`, `repository`, `gpg`, `setup` |
| **Security** | Sensitive operations | `security`, `sudo`, `ssl` |
| **Testing** | Verification/diagnostics | `test`, `verify` |
| **Always** | Special - runs every execution | `always` (rarely used, pre/post_tasks only) |

**Usage Examples**:

```bash
# Execute specific role
ansible-playbook main.yml --tags python

# Execute multiple roles
ansible-playbook main.yml --tags "nodejs,terraform"

# Skip maintenance role
ansible-playbook main.yml --skip-tags maintenance

# Execute only package installations
ansible-playbook main.yml --tags packages

# Dry-run with specific tags
ansible-playbook main.yml --tags terraform --check

```

**Tagging Rules**:

* Role-level tasks: include role name tag (e.g., `tags: [python, packages]`)
* Cross-role tasks: use secondary tags (e.g., `tags: [repository, gpg]`)
* Always tag with primary role - secondary tags are optional but recommended

### 5. Repository and Key Management

All roles use the **modern APT key method** (signed-by=) instead of
deprecated `apt_key` module:

```yaml
# Step 1: Download GPG key
- name: Add Hashicorp GPG key
  ansible.builtin.get_url:
    url: "{{ hashicorp_apt_key }}"
    dest: /tmp/hashicorp-archive-keyring.asc
  tags: [terraform, hashicorp, gpg]

# Step 2: Convert to binary format (dearmor)
- name: Convert and install Hashicorp GPG key
  ansible.builtin.shell: |
    gpg --dearmor < /tmp/hashicorp-archive-keyring.asc > /etc/apt/keyrings/hashicorp-archive-keyring.gpg
  args:
    creates: /etc/apt/keyrings/hashicorp-archive-keyring.gpg
  tags: [terraform, hashicorp, gpg]

# Step 3: Add repository with signed-by reference
- name: Add Hashicorp APT repository (modern method)
  ansible.builtin.apt_repository:
    repo: >
      deb [arch=amd64 signed-by=/etc/apt/keyrings/hashicorp-archive-keyring.gpg]
      {{ hashicorp_apt_repo_url }} {{ distro_codename }} main
    filename: hashicorp
    state: present
    update_cache: yes
  tags: [terraform, hashicorp, packages, repository]

```

**Key Patterns**:

* Store GPG key URLs in `group_vars/all.yml` (e.g., `hashicorp_apt_key`, `azure_cli_apt_key`)
* Use `creates:` argument to prevent re-running gpg dearmor
* Always reference `{{ distro_codename }}` (auto-detected from `ansible_lsb.codename`)
* Use `filename:` parameter for clean repository management
* Add `update_cache: yes` after repository changes

**Real-world Examples**:

* [Terraform/Hashicorp](roles/terraform/tasks/main.yml)
* [Azure CLI](roles/azure-cli/tasks/main.yml)
* [Node.js (setup script)](roles/nodejs/tasks/main.yml)

### 6. Conditional System Checks and Sudo Management

The playbook validates prerequisites and manages sudo configuration:

```yaml
# System validation (in common role)
- name: Check if system is Ubuntu/Debian
  ansible.builtin.fail:
    msg: "This playbook is only supported on Debian-based systems."
  when: ansible_os_family != "Debian"
  tags: [always, common]

# Sudo NOPASSWD configuration (allows passwordless execution)
- name: Configure sudo NOPASSWD for current user
  ansible.builtin.lineinfile:
    path: "/etc/sudoers.d/{{ ansible_user_id }}"
    line: "{{ ansible_user_id }} ALL=(ALL) NOPASSWD:ALL"
    create: true
    owner: root
    group: root
    mode: '0440'
    validate: 'visudo -cf %s'  # Critical: validates sudoers syntax
  when: common_configure_nopasswd_sudo | default(true)
  tags: [common, sudo, security]

```

**Important Notes**:

* First run requires `-K` flag: `ansible-playbook main.yml -K`
* Subsequent runs work without `-K` if `common_configure_nopasswd_sudo: yes`
* To disable auto-sudo config, set `common_configure_nopasswd_sudo: no` in `custom.yml`
* Always validate sudoers with `visudo -cf %s` to prevent lockout
* Gather OS facts early with tag `always` in common role

## Critical Workflows

### Running the Playbook

```bash
# 1. Validate syntax and lint (run before execution)
./validate.sh
# Output: Checks Ansible version, syntax, ansible-lint rules

# 2. Dry-run (no changes applied) - always run first!
ansible-playbook main.yml --check

# 3. First execution (prompts for sudo password)
ansible-playbook main.yml -K
# -K flag: asks for sudo password (use only on first run)

# 4. Subsequent runs (no password needed if NOPASSWD configured)
ansible-playbook main.yml

# 5. Selective execution by role
ansible-playbook main.yml --tags python
ansible-playbook main.yml --tags "terraform,nodejs"

# 6. Skip specific roles
ansible-playbook main.yml --skip-tags maintenance

# 7. Dry-run with specific tags
ansible-playbook main.yml --tags terraform --check

# 8. Verbose output for debugging
ansible-playbook main.yml -vv  # More verbose
ansible-playbook main.yml -vvv # Maximum verbosity

```

**Important**: Always run `--check` first, review output, then execute without `--check`.

### Testing Individual Roles

```bash
# Available commands:
./test-role.sh <role-name> [-K] [run]

# Usage examples:
./test-role.sh python              # Dry-run, no sudo prompt
./test-role.sh terraform -K        # Dry-run, with sudo prompt
./test-role.sh nodejs -K run       # Execute (will make changes), with sudo

# Available roles:
# - common
# - ssl-config
# - python
# - containers
# - terraform
# - dotnet
# - nodejs
# - azure-cli
# - github-cli
# - maintenance

```

**Dry-run Mode** (`--check`):

* Simulates changes without applying them
* Useful for previewing what will be installed
* Some tasks may skip or behave differently in check mode

### Configuration Customization

**Recommended Workflow**:

1. Copy example to custom config:

   ```bash
   cp group_vars/custom.yml.example group_vars/custom.yml
   ```

2. Edit `group_vars/custom.yml` to override defaults:

   ```yaml
   # Disable specific roles
   enable_maintenance: no
   enable_ssl_config: no

   # Override versions
   nodejs_version: "20"  # Default is "22"

   # Configure sudo behavior
   common_configure_nopasswd_sudo: no  # Requires password every time

   # Set custom CA certificate (optional)
   ssl_ca_cert_name: "company-root-ca.crt"
   ```

3. Run playbook:

   ```bash
   ansible-playbook main.yml --check
   ansible-playbook main.yml -K
   ```

**Variable Override Priority** (highest to lowest):

1. `group_vars/custom.yml` (your customizations)
2. `group_vars/all.yml` (project defaults)
3. Role `defaults/main.yml` (role fallbacks)

## Important Configuration Details

### Ansible Configuration ([ansible.cfg](ansible.cfg))

Key settings that affect execution:

```properties
[defaults]
inventory = hosts                    # Use local hosts file
host_key_checking = True             # Verify SSH keys (safe for local)
roles_path = roles                   # Find roles in ./roles/ directory
remote_user = root                   # Connect as root (local execution)
forks = 10                          # Run 10 parallel tasks (speeds up install)
fact_caching = jsonfile             # Cache system facts for 24h
fact_caching_connection = .ansible/facts
fact_caching_timeout = 86400        # Prevents repeated fact gathering
force_color = True                  # Colored output for readability
display_skipped_hosts = True        # Show skipped tasks
interpreter_python = auto_silent    # Auto-detect Python (no warnings)

[callbacks]
stdout_callback = yaml              # Output format (readable)
callbacks_enabled = profile_tasks    # Show task execution time

```

**Impact**:

* `forks = 10` speeds up package installations and parallel role execution
* `fact_caching` reduces repeated system info gathering
* `connection: local` (default, set in main.yml) - runs on localhost without SSH
* These settings should **NOT be modified** for normal usage

### Sudo Configuration

The `common` role auto-configures **sudoers for NOPASSWD** if enabled:

**Default Behavior** (`common_configure_nopasswd_sudo: yes`):

* Automatically adds `/etc/sudoers.d/<user>` with `NOPASSWD:ALL`
* Validates sudoers syntax with `visudo -cf %s` to prevent lockout
* After first run, subsequent runs don't require `-K` flag
* **Recommended for development/WSL environments**

**Disabling Auto-Config**:

```yaml
# In group_vars/custom.yml
common_configure_nopasswd_sudo: no

```

* Requires `-K` flag on every run
* Recommended for production/sensitive systems

**Manual Verification**:

```bash
sudo visudo -cf /etc/sudoers.d/$(whoami)  # Check validity
sudo cat /etc/sudoers.d/$(whoami)        # View current config

```

### Distribution Compatibility

**Supported Systems**:

* Debian 11+ (Bullseye)
* Ubuntu 22.04+ (Jammy)
* Ubuntu 24.04+ (Noble)
* WSL 2 with Ubuntu/Debian

**Validation**:

```yaml
# Automatic check in common role
- name: Check if system is Ubuntu/Debian
  ansible.builtin.fail:
    msg: "This playbook is only supported on Debian-based systems."
  when: ansible_os_family != "Debian"

```

**Auto-Detected Variables**:

* `ansible_os_family` → "Debian" (used for validation)
* `ansible_lsb.codename` → "focal", "jammy", etc. (used for repo URLs)
* `ansible_lsb.description` → "Ubuntu 22.04.1 LTS" (displayed in output)

### Package Management

**Three Installation Methods**:

1. **APT** (system packages):

   ```yaml
   - name: Install Python packages (APT)
     ansible.builtin.apt:
       name: "{{ python_packages_apt }}"
       state: present
       update_cache: true
   ```

   * Uses system package manager
   * Best for dependencies, system libraries

2. **PIP** (Python packages):

   ```yaml
   - name: Install Python packages (pip)
     ansible.builtin.pip:
       name: "{{ python_packages_pip }}"
       state: present
   ```

   * Uses Python package manager
   * Used for Python development tools

3. **PIPX** (Isolated CLI tools):

   ```yaml
   - name: Install Python CLI tools via pipx
     ansible.builtin.shell: |
       export PATH="$PATH:~/.local/bin"
       pipx install "{{ item }}" --force
     loop: "{{ python_tools_pipx }}"
   ```

   * Installs CLI tools in isolated environments
   * Prevents dependency conflicts
   * Used for: ansible-lint, pre-commit, black, yamllint
   * Path managed via .bashrc

**Important**: Python CLI tools (ansible-lint, pre-commit) use pipx to prevent
version conflicts with project-specific requirements.

### Distro-Specific Variables

All package repositories reference `{{ distro_codename }}`:

```yaml
hashicorp_apt_repo_url: "https://apt.releases.hashicorp.com"
# Real URL becomes: https://apt.releases.hashicorp.com jammy main

```

**Why**: Ubuntu/Debian use codenames (focal, jammy, noble) instead of version numbers.
Auto-detection prevents hardcoding and supports multiple distributions.

### SSL/TLS and CA Certificates

**Optional**: Add organization CA certificate:

```yaml
# In group_vars/custom.yml
ssl_ca_cert_name: "company-root-ca.crt"

```

**Process**:

1. Place `company-root-ca.crt` in project root
2. Role copies to `/usr/local/share/ca-certificates/`
3. Runs `update-ca-certificates` to register globally
4. SSL/TLS tools automatically trust the certificate

**Default**: `ssl_ca_cert_name: ""` (empty = skip installation)

## Common Modifications & Patterns

### Adding a New Package

**To system packages** (installed via apt):

1. Add package name to appropriate list in [group_vars/all.yml](group_vars/all.yml):

   ```yaml
   common_packages_linux:
     - git
     - curl
     - wget
     - jq
     - tree                    # Add new package here
   ```

2. Reference in task (always use variables, never hardcode):

   ```yaml
   - name: Install base Linux packages
     ansible.builtin.apt:
       name: "{{ common_packages_linux }}"
       state: present
       autoclean: true
     tags: [common, packages]
   ```

3. Test the specific role:

   ```bash
   ./test-role.sh common --check
   ./test-role.sh common -K run
   ```

4. Validate with ansible-lint:

   ```bash
   ./validate.sh
   ```

**To Python packages** (pip):

1. Add to `python_packages_pip` in `group_vars/all.yml`
2. Task already references the variable - no code changes needed

**To Python CLI tools** (pipx - recommended for tools):

1. Add to `python_tools_pipx` in `group_vars/all.yml`
2. Installs in isolated environment, prevents conflicts

### Creating New Role

**Minimal Role Structure**:

```bash
mkdir -p roles/new-role/{defaults,tasks,handlers,vars}

```

**1. Create role defaults** (`roles/new-role/defaults/main.yml`):

```yaml
---
# Enable/disable this role via playbook
enable_new_role: yes

# Role-specific variables
new_role_package_name: some-package
new_role_version: "1.0"
new_role_packages:
  - package1
  - package2

```

**2. Create tasks** (`roles/new-role/tasks/main.yml`):

```yaml
---
- name: Install new-role packages
  ansible.builtin.apt:
    name: "{{ new_role_packages }}"
    state: present
  tags:
    - new-role
    - packages

- name: Verify installation
  ansible.builtin.command: "{{ new_role_package_name }} --version"
  register: new_role_version_check
  changed_when: false
  tags:
    - new-role
    - test

- name: Display version
  ansible.builtin.debug:
    msg: "{{ new_role_package_name }} version: {{ new_role_version_check.stdout }}"
  tags:
    - new-role

```

**3. Update main.yml** to add role:

```yaml
  roles:
    # ... existing roles ...

    - name: new-role
      tags: new-role
      when: enable_new_role

```

**4. Add variables to [group_vars/all.yml](group_vars/all.yml)**:

```yaml
# Add with other enable flags
enable_new_role: yes

# Add package lists
new_role_packages:
  - package1
  - package2
  - package3

```

**5. Test**:

```bash
./validate.sh                  # Check syntax
./test-role.sh new-role --check
./test-role.sh new-role -K run

```

### Handling External URLs and GPG Keys

**Pattern**: All URLs and keys must be in variables (never hardcoded):

1. **Store URL in variables**:

   ```yaml
   # In group_vars/all.yml
   terraform_apt_key: https://apt.releases.hashicorp.com/gpg
   terraform_apt_repo_url: "https://apt.releases.hashicorp.com"
   ```

2. **Download GPG key**:

   ```yaml
   - name: Add Terraform GPG key
     ansible.builtin.get_url:
       url: "{{ terraform_apt_key }}"
       dest: /tmp/terraform-keyring.asc
       owner: root
       group: root
       mode: '0644'
     tags: [terraform, gpg]
   ```

3. **Convert with gpg dearmor** (modern method):

   ```yaml
   - name: Convert and install Terraform GPG key
     ansible.builtin.shell: |
       gpg --dearmor < /tmp/terraform-keyring.asc > /etc/apt/keyrings/terraform.gpg
     args:
       creates: /etc/apt/keyrings/terraform.gpg
     tags: [terraform, gpg]
   ```

4. **Add repository with signed-by**:

   ```yaml
   - name: Add Terraform APT repository
     ansible.builtin.apt_repository:
       repo: >
         deb [arch=amd64 signed-by=/etc/apt/keyrings/terraform.gpg]
         {{ terraform_apt_repo_url }} {{ distro_codename }} main
       filename: terraform
       state: present
       update_cache: yes
     tags: [terraform, packages, repository]
   ```

**Key Points**:

* Use `creates:` to prevent re-running dearmor step
* Always use `{{ distro_codename }}` for distribution detection
* Never use deprecated `apt_key` module
* Store URLs and keys in `group_vars/all.yml`

### Modifying Installed Versions

**Node.js Version**:

```yaml
# In group_vars/custom.yml
nodejs_version: "20"  # Changed from default "22"

```

* Automatically changes repository setup script URL

**Python Packages**:

```yaml
# In group_vars/custom.yml
python_packages_apt:
  - python3-full
  - python3-pip
  # Remove unwanted packages

```

**Hashicorp Tools**:

```yaml
# In group_vars/custom.yml
hashicorp_packages:
  - terraform
  - vault
  # Remove boundary, consul, nomad if not needed

```

### Handling Secrets and Credentials

**Never commit credentials**. Use `group_vars/custom.yml`:

```yaml
# In group_vars/custom.yml (add to .gitignore)
ssl_ca_cert_name: "company-root-ca.crt"  # File in project root
# API keys, tokens: not needed for basic bootstrap

```

**For Azure/GitHub credentials**: Not required for initial setup.
Add after bootstrap using CLI commands:

```bash
az login
gh auth login

```

## File References

| File | Purpose |
|------|---------|
| [main.yml](main.yml) | Playbook entry point - orchestrates all 9 roles |
| [group_vars/all.yml](group_vars/all.yml) | Global variables (packages, URLs, enable flags) |
| [group_vars/custom.yml.example](group_vars/custom.yml.example) | Customization template (copy to custom.yml) |
| [roles/*/tasks/main.yml](roles) | Core installation logic for each role |
| [roles/*/defaults/main.yml](roles) | Role-specific default variables |
| [ansible.cfg](ansible.cfg) | Ansible runtime config (cache, parallelism, callbacks) |
| [hosts](hosts) | Inventory file (localhost for local execution) |
| [validate.sh](validate.sh) | Pre-execution validation (syntax, lint) |
| [test-role.sh](test-role.sh) | Individual role testing with dry-run support |
| [test-roles.sh](test-roles.sh) | Test all roles sequentially |
| [.ansible-lint](.ansible-lint) | Code quality rules configuration |

## Role Directory Reference

| Role | Purpose | Key Variables |
|------|---------|----------------|
| `common` | Base system, sudo, validation | common_packages_linux |
| `python` | Python 3, pipx, pip tools | python_packages_apt, pipx |
| `nodejs` | Node.js, build tools | nodejs_version, nodejs_packages |
| `dotnet` | .NET SDK | dotnet_packages |
| `terraform` | Terraform + Hashicorp suite | hashicorp_packages |
| `azure-cli` | Azure CLI | azure_cli_apt_key |
| `github-cli` | GitHub CLI | Minimal config (repo setup in task) |
| `containers` | OCI tools (buildah, skopeo) | `container_packages` |
| `ssl-config` | SSL/TLS, CA certificates | `ssl_ca_cert_name`, `ssl_ca_cert_path` |
| `maintenance` | System updates, cron | `maintenance_enable_auto_update` |

## Quick Command Reference

```bash
# Validation & Testing
./validate.sh                                    # Full validation
ansible-playbook main.yml --syntax-check       # Syntax only
ansible-lint main.yml -v                        # Lint only

# Dry-run (preview changes)
ansible-playbook main.yml --check               # Full playbook
./test-role.sh python --check                   # Single role

# Execution (with sudo)
ansible-playbook main.yml -K                    # First run
ansible-playbook main.yml                       # Subsequent runs
./test-role.sh nodejs -K run                    # Single role

# Selective Execution
ansible-playbook main.yml --tags python         # Single role by tag
ansible-playbook main.yml --tags "python,nodejs"  # Multiple roles
ansible-playbook main.yml --skip-tags maintenance  # Skip role

# Debug & Verbose Output
ansible-playbook main.yml -vv                   # Verbose
ansible-playbook main.yml -vvv                  # Very verbose
ansible-playbook main.yml --tags test           # Run verifications only

# Configuration
cp group_vars/custom.yml.example group_vars/custom.yml  # Create custom config

```

## Common Issues & Solutions

### Issue: "This playbook is only supported on Debian-based systems"

**Cause**: Running on non-Debian (CentOS, Fedora, etc.)
**Solution**: Only supported on Debian/Ubuntu. Use WSL with Ubuntu if on Windows.

### Issue: "sudo: no password was provided, but a password is required"

**Cause**: First run without `-K` flag, NOPASSWD not configured yet
**Solution**: Use `ansible-playbook main.yml -K` on first run

### Issue: "ansible-lint: command not found"

**Cause**: Python tools not installed via pipx yet
**Solution**: Run `./validate.sh` from the repo directory, or install python role first

### Issue: "gpg: can't connect to the agent"

**Cause**: GPG agent not running in WSL/container
**Solution**: This usually resolves itself; if persistent, try `gpg-agent --daemon`

### Issue: "Repository URL not found" when adding APT repos

**Cause**: Distribution codename not detected correctly
**Solution**: Run `cat /etc/os-release` to verify `UBUNTU_CODENAME` or `VERSION_CODENAME`

### Issue: "ansible_lsb facts not gathered"

**Cause**: `lsb-release` package missing (should not happen)
**Solution**: The `common` role installs it; ensure common runs first

## Debugging Tips

**Enable maximum verbosity**:

```bash
ansible-playbook main.yml -vvv --check

```

**Run single task**:

```bash
ansible-playbook main.yml --tags python --step
# Prompts to execute each task

```

**Check facts gathered**:

```bash
ansible -m ansible.builtin.setup localhost | grep ansible_lsb

```

**Validate sudoers configuration**:

```bash
sudo visudo -cf /etc/sudoers.d/$(whoami)

```

**Check package installation**:

```bash
dpkg -l | grep terraform    # Check specific package
apt list --installed | grep python  # List all with name pattern

```

**View ansible cache**:

```bash
cat .ansible/facts/localhost.json | python -m json.tool

```

## Code Quality & Best Practices

### Validation Process

Before committing or executing, always run:

```bash
./validate.sh

```

This script validates:

* **Ansible version** ≥ 2.16 (uses modern syntax)
* **Playbook syntax** (YAML parsing)
* **ansible-lint** checks (code quality rules)

Configuration: [.ansible-lint](.ansible-lint)

**Common lint rules**:

* Task names must be meaningful (not `command: ...`)
* Tasks must have tags
* Handlers must exist before being notified
* Variable names must follow conventions
* YAML indentation must be consistent

### Naming Conventions

**Playbooks & Roles**:

* Lowercase with hyphens: `ssl-config`, `azure-cli`, `github-cli`
* Match directory names exactly

**Variables**:

* Lowercase with underscores: `python_packages_apt`, `nodejs_version`
* Prefix by component: `python_*`, `terraform_*`, `azure_*`
* Enable flags: `enable_<role>` (e.g., `enable_terraform`)

**Tasks**:

* Descriptive, lowercase: "Install Python packages (APT)"
* Not abbreviated or cryptic
* Include action and target

**Tags**:

* Lowercase: `python`, `packages`, `gpg`, `security`
* Primary tag = role name
* Secondary tags describe operation type

### Idempotency

All tasks must be idempotent (safe to run multiple times):

**Idempotent**:

```yaml
# ✅ GOOD: apt idempotent by default
- name: Install package
  ansible.builtin.apt:
    name: terraform
    state: present

# ✅ GOOD: File task with state=present
- name: Create config file
  ansible.builtin.lineinfile:
    path: /etc/config
    line: "setting: value"
    state: present

```

**Non-Idempotent** (avoid these patterns):

```yaml
# ❌ BAD: Running shell without safeguards
- name: Install package
  ansible.builtin.shell: apt-get install terraform

# ❌ BAD: Changed_when always true
- name: Run setup
  ansible.builtin.command: ./setup.sh
  changed_when: true  # Always reports changed

# ✅ FIXED:
- name: Run setup
  ansible.builtin.command: ./setup.sh
  args:
    creates: /opt/app  # Only run if /opt/app doesn't exist
  changed_when: false  # Setup output not reliable

```

### Task Structure Best Practices

**Standard Task Template**:

```yaml
---
- name: [Brief description of what task does]
  ansible.builtin.<module>:
    [module-specific parameters]
  [when: condition]                  # Optional: conditional execution
  [become: yes/no]                   # Optional: privilege elevation
  changed_when: [condition]          # For read-only operations: false
  failed_when: [condition]           # Optional: custom failure detection
  register: [variable_name]          # Optional: capture output
  tags:                              # REQUIRED
    - primary-role
    - secondary-tag
  [loop: "{{ list }}"]              # Optional: iterate
  [environment: ...]                 # Optional: set env vars

```

**Example from python role**:

```yaml
- name: Install Python CLI tools via pipx
  ansible.builtin.shell: |
    export PATH="$PATH:~/.local/bin"
    pipx install "{{ item }}" --force
  loop: "{{ python_tools_pipx }}"
  environment:
    HOME: /root
  changed_when: false
  tags:
    - python
    - packages

```

### Verification Tasks

Always include verification after installation:

```yaml
- name: Check Terraform installation
  ansible.builtin.command: terraform --version
  register: terraform_version_check
  changed_when: false              # This is read-only
  failed_when: false               # Don't fail, just check
  tags:
    - terraform
    - test

- name: Display Terraform version
  ansible.builtin.debug:
    msg: "Terraform installed: {{ terraform_version_check.stdout_lines }}"
  tags:
    - terraform

```

**Key Patterns**:

* Use `changed_when: false` for verification/check tasks
* Use `failed_when: false` to capture output without failing
* Always register output for display
* Tag verification with both role name and `test` tag

### Comments and Documentation

**Header Comment for Roles**:

```yaml
---
# =========================================
# Role: python
# =========================================
# Installs Python 3, pip, and development
# tools including ansible-lint, pre-commit
# for code quality.
#
# Key Components:
# - python3-full: Complete Python 3 suite
# - pipx: Isolated CLI tool installation
# - python_tools_pipx: CLI tools (ansible-lint, pre-commit)
#
# See: group_vars/all.yml for package lists

```

**Task Comments** (use sparingly):

```yaml
# Set PATH for CLI tools installed by pipx
- name: Add pipx to user PATH
  ansible.builtin.lineinfile:
    path: "/home/{{ python_real_user_home }}/.bashrc"
    line: 'export PATH="$HOME/.local/bin:$PATH"'
    state: present
  tags:
    - python
    - packages

```

### Error Handling

**Fail Fast**:

```yaml
# System validation (should fail early)
- name: Check if system is Ubuntu/Debian
  ansible.builtin.fail:
    msg: "This playbook is only supported on Debian-based systems."
  when: ansible_os_family != "Debian"
  tags: [always]

```

**Graceful Degradation**:

```yaml
# Non-critical tasks can fail gracefully
- name: Ensure pipx path (non-blocking)
  ansible.builtin.command: pipx ensurepath --force
  failed_when: false              # Don't fail
  changed_when: false             # Don't report changed
  tags: [python, packages]

```

### Testing & Validation Workflow

1. **Syntax check**:

   ```bash
   ansible-playbook main.yml --syntax-check
   ```

2. **Lint check**:

   ```bash
   ./validate.sh
   ```

3. **Dry-run (check mode)**:

   ```bash
   ./test-role.sh <role-name> --check
   # or for full playbook:
   ansible-playbook main.yml --check
   ```

4. **Actual execution**:

   ```bash
   ./test-role.sh <role-name> -K run
   ```

5. **Verification**:

   ```bash
   # Run with test tag to verify installation
   ansible-playbook main.yml --tags test
   ```
