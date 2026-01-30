# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-01-30

### Added

- Role-based architecture with 8 independent Ansible roles:
  - **common**: Base packages, system configuration, automatic sudo NOPASSWD setup
  - **ssl-config**: CA certificates, OpenSSL configuration
  - **python**: Python 3, pip, virtualenv, development tools
  - **containers**: Buildah, Skopeo (OCI-compliant tools)
  - **terraform**: HashiCorp stack (Terraform, Packer, Vault, Consul, Boundary, Nomad)
  - **dotnet**: .NET SDK 8.0
  - **nodejs**: Node.js 22 LTS with npm
  - **azure-cli**: Microsoft Azure CLI
- Modern GPG key management with `signed-by` syntax and `/etc/apt/keyrings/` directory
- Automatic conversion of ASCII-armored GPG keys to binary format
- Feature flags for granular component control (`enable_*` variables in `group_vars/all.yml`)
- Full check mode (dry-run) support with `--check` flag
- Granular execution control via tags (e.g., `--tags azure-cli`)
- Testing utilities:
  - `test-role.sh`: Individual role testing
  - `test-roles.sh`: Comprehensive test suite
  - `validate.sh`: Project structure validation
- Development tools:
  - `.gitignore`: Comprehensive exclusions for Ansible artifacts
  - `.gitattributes`: Cross-platform line ending normalization
- Complete documentation in `README.md` with quick start, and examples
- Change documentation in `CHANGELOG.md`
