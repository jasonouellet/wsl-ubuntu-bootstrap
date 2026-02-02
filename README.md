# WSL Ubuntu Bootstrap

Ansible playbook to automate the complete configuration of a development
environment on WSL (Windows Subsystem for Linux) or any Debian/Ubuntu
distribution.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Ansible](https://img.shields.io/badge/Ansible-2.16%2B-red.svg)](https://www.ansible.com/)

## 📚 Documentation

- [Contributing Guidelines](CONTRIBUTING.md) - How to contribute to the project
- [Code of Conduct](CODE_OF_CONDUCT.md) - Community behavior standards
- [Security Policy](SECURITY.md) - Security policy and vulnerability reporting
- [Support](SUPPORT.md) - How to get help
- [Changelog](CHANGELOG.md) - Version history and changes

## 🎯 Objective

This project automatically configures all necessary tools for a modern
DevOps development environment, including:

- **Languages & Runtimes**: Python 3, Node.js, .NET SDK
- **Infrastructure as Code**: Terraform and complete Hashicorp suite
- **Cloud Tools**: Azure CLI
- **Containers**: Buildah, Skopeo (OCI)
- **Security**: CA certificates, SSL/TLS configuration
- **Base system**: Essential packages, sudo configuration

## 📁 Project Structure

```text
wsl-ubuntu-bootstrap/
├── main.yml                    # Main playbook orchestrating all roles
├── hosts                       # Inventory (localhost)
├── ansible.cfg                 # Optimized Ansible configuration
├── .ansible-lint               # Code quality rules
├── .gitignore                  # Files to ignore (credentials, etc.)
├── README.md                   # Complete documentation
├── validate.sh                 # Project validation script
├── test-role.sh                # Individual role testing script
├── test-roles.sh               # All roles testing script
├── *.crt                       # Organization CA certificate(s)
│                               # optional, not committed to git
├── group_vars/
│   ├── all.yml                 # Global variables
│   ├── custom.yml.example      # Customization example
│   └── local.yml.example       # Local credentials example
└── roles/
    ├── common/                 # Base system, essential packages
    │   ├── defaults/           # Default variables
    │   ├── tasks/              # Installation tasks
    │   ├── handlers/           # Event handlers
    │   └── vars/               # Role variables
    ├── ssl-config/             # SSL/TLS configuration and CA certificates
    ├── python/                 # Python 3 and pip packages
    ├── containers/             # OCI tools (buildah, skopeo)
    ├── terraform/              # Terraform and Hashicorp tools
    ├── dotnet/                 # .NET SDK
    ├── nodejs/                 # Node.js runtime and npm
    ├── azure-cli/              # Azure CLI
    └── maintenance/            # Automated maintenance (auto-update)
```

## 🚀 Quick Start

### Prerequisites

```bash
# Install Ansible
sudo apt-get update && sudo apt-get install -y ansible

# (Optional) Install ansible-lint for code quality
sudo apt-get install -y ansible-lint
```

### Complete Installation

```bash
# Navigate to project directory
cd wsl-ubuntu-bootstrap

# First execution (with sudo password)
ansible-playbook main.yml -K

# Subsequent executions (sudo NOPASSWD automatically configured)
ansible-playbook main.yml
```

### Validation Before Installation

```bash
# Validate syntax and structure
./validate.sh

# Dry-run mode to see changes without applying them
ansible-playbook main.yml --check
```

## 🔧 Usage

### Main Commands

```bash
# Complete installation of all components
ansible-playbook main.yml

# Verbose mode for debugging
ansible-playbook main.yml -vvv

# Install a specific component
ansible-playbook main.yml --tags nodejs
ansible-playbook main.yml --tags terraform
ansible-playbook main.yml --tags azure-cli

# Exclude a component from installation
ansible-playbook main.yml --skip-tags dotnet

# Syntax validation
ansible-playbook main.yml --syntax-check

# Quality check with ansible-lint
ansible-lint main.yml roles/
```

### Test Scripts

```bash
# Test a specific role in dry-run mode
./test-role.sh nodejs

# Test a role in execution mode
./test-role.sh terraform run

# Test all roles sequentially
./test-roles.sh
```

## ⚙️ Configuration

### Automatic sudo Configuration

The `common` role automatically configures sudo NOPASSWD for the current user
during first execution. This avoids having to enter the sudo password for each
command.

**To disable this feature**, edit `group_vars/all.yml`:

```yaml
configure_nopasswd_sudo: no
```

### Component Customization

Edit `group_vars/all.yml` to customize the installation:

```yaml
# Enable/disable components
enable_dotnet: no          # Disable .NET
enable_containers: no      # Disable OCI tools
enable_terraform: yes      # Enable Terraform

# Modify versions
nodejs_version: "20"       # Use Node.js 20 LTS instead of 22

# Add additional Python packages
python_packages_pip:
  - pre-commit
  - yamllint
  - black
  - pytest              # Additional package
  - requests            # Additional package

# Add Linux packages
common_packages_linux:
  - ca-certificates
  - curl
  - git
  - htop                # Additional package
  - vim                 # Additional package
```

### Advanced Customization

For complex modifications, create a `group_vars/custom.yml` file:

```bash
cp group_vars/custom.yml.example group_vars/custom.yml
# Edit custom.yml with your configurations
ansible-playbook main.yml -e @group_vars/custom.yml
```

## 📦 Available Roles

<!-- markdownlint-disable MD013 -->
| Role | Description | Content |
|------|-------------|------|
| [**common**](roles/common/README.md) | Base system | Essential packages, OS checks, sudo configuration |
| [**ssl-config**](roles/ssl-config/README.md) | SSL/TLS | CA certificates, OpenSSL configuration |
| [**python**](roles/python/README.md) | Python | Python 3, pip, virtualenv, pre-commit, yamllint |
| [**containers**](roles/containers/README.md) | OCI Containers | Buildah, Skopeo |
| [**terraform**](roles/terraform/README.md) | Hashicorp | Terraform, Packer, Vault, Consul, Boundary, Nomad |
| [**dotnet**](roles/dotnet/README.md) | .NET | .NET SDK 8.0 |
| [**nodejs**](roles/nodejs/README.md) | Node.js | Node.js 22 LTS, npm, compilation toolchain |
| [**azure-cli**](roles/azure-cli/README.md) | Azure | Azure CLI for Microsoft Azure cloud management |
| [**github-cli**](roles/github-cli/README.md) | GitHub | GitHub CLI for repository automation and management |
| [**maintenance**](roles/maintenance/README.md) | Maintenance | Daily automatic updates (cron 3 AM) |
<!-- markdownlint-enable MD013 -->

## 🎨 Features

### ✅ Modern Architecture

- **Modular**: Each component in an independent and reusable role
- **Idempotent**: Multiple executions without side effects
- **Configurable**: Feature flags and centralized variables
- **Testable**: Validation scripts and per-role testing

### ✅ Ansible Best Practices

- Role-based structure following industry standards
- Centralized variables in `group_vars/`
- Handlers for system notifications
- Granular tags for selective execution
- Quality configuration with ansible-lint
- Full check mode (dry-run) support

### ✅ Security

- GPG keys with modern method (`signed-by`)
- Key storage in `/etc/apt/keyrings/` (Ubuntu 22.04+ standard)
- Automatic conversion of ASCII keys to binary format
- Secure and controllable sudo configuration
- CA certificate validation

### ✅ Error Handling

- OS verification (Debian/Ubuntu only)
- `block/rescue` blocks for error handling
- `ignore_errors` for non-critical tasks
- Explicit error messages

## 📋 CA Certificates (Optional)

If your organization uses an internal CA certificate, you can configure it by:

1. **Set the certificate filename** in `group_vars/all.yml`:

```yaml
ssl_ca_cert_name: "your-company-root-ca.crt"
```

1. **Place the certificate file** in the playbook root directory with the same name:

```bash
cp /path/to/your-company-root-ca.crt ./
```

The `ssl-config` role will automatically:

- Check if the certificate file exists
- Install it in `/usr/local/share/ca-certificates/`
- Update the system trust chain

**To disable certificate installation**, leave `ssl_ca_cert_name` empty:

```yaml
ssl_ca_cert_name: ""
```

**Note**: Certificate files (`*.crt`) are automatically ignored by git to prevent
accidentally committing sensitive certificates.

## 🧪 Testing and Validation

```bash
# Complete project validation
./validate.sh

# Test a role in dry-run
./test-role.sh terraform

# Test a role in execution mode
./test-role.sh terraform run

# Test all roles
./test-roles.sh

# Lint Ansible code
ansible-lint main.yml roles/
```

## 🔗 Resources

### Ansible

- [Ansible Documentation](https://docs.ansible.com/ansible/latest/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
- [Ansible Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html)
- [Ansible Galaxy](https://galaxy.ansible.com/) - Share Ansible roles

### Project

- [Issues](../../issues) - Report bugs or request features
- [Pull Requests](../../pulls) - Submit contributions
- [Discussions](../../discussions) - Community questions and discussions

## 🤝 Contribution

Contributions are welcome! Check [CONTRIBUTING.md](CONTRIBUTING.md) for:

- How to set up the development environment
- Code standards and best practices
- Pull Request submission process
- Testing guidelines

To report security issues, see [SECURITY.md](SECURITY.md).

## 📞 Support

Need help? Check [SUPPORT.md](SUPPORT.md) for:

- Documentation and resources
- Common troubleshooting
- How to get help
- Expected response times

## 📄 License

This project follows Ansible 2024+ standards and best practices.

To contribute:

1. Create a new role in `roles/`
2. Follow existing structure (tasks, defaults, handlers)
3. Add the role in `main.yml`
4. Test with `./test-role.sh <new-role>`
5. Update this README
