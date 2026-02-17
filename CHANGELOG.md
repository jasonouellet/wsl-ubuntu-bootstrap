# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

* **Debian 13 (Trixie) Support**: Full compatibility with Debian 13 including distribution-specific installation methods
* **Modular Role Architecture**: Split `dotnet` and `azure-cli` roles into separate task files for better maintainability
  * `main.yml`: Distribution detection and orchestration
  * `install-<method>.yml`: Method-specific implementations

### Changed

* **.NET SDK Installation**: Dual installation paths based on distribution
  * **Debian 13**: Microsoft installation script method with ICU library dependencies
  * **Debian 12/Ubuntu**: APT repository method (existing)
* **Azure CLI Installation**: Dual installation paths based on distribution
  * **Debian 13**: Python pipx method (PEP 668 compliant)
  * **Debian 12/Ubuntu**: APT repository method (existing)
* **APT Keyrings**: Centralized `/etc/apt/keyrings/` directory creation in `common` role

### Fixed

* Corrected ICU library dependency for .NET on Debian 13 (`libicu76` instead of `libicu72`)
* Fixed user detection in sudo context for pipx installations (`SUDO_USER` environment variable)
* Resolved Microsoft package repository unavailability for Debian 13 with alternative methods

## [0.1.0] - 2026-01-30

### Initial Release

* Role-based architecture with 8 independent Ansible roles:
  * **common**: Base packages, system configuration, automatic sudo NOPASSWD setup
  * **ssl-config**: CA certificates, OpenSSL configuration
  * **python**: Python 3, pip, virtualenv, development tools
  * **containers**: Buildah, Skopeo (OCI-compliant tools)
  * **terraform**: HashiCorp stack (Terraform, Packer, Vault, Consul, Boundary, Nomad)
  * **dotnet**: .NET SDK 8.0
  * **github-cli**: GitHub CLI
  * **nodejs**: Node.js 22 LTS with npm
  * **azure-cli**: Microsoft Azure CLI
* Modern GPG key management with `signed-by` syntax and `/etc/apt/keyrings/` directory
* Automatic conversion of ASCII-armored GPG keys to binary format
* Feature flags for granular component control (`enable_*` variables in `group_vars/all.yml`)
* Full check mode (dry-run) support with `--check` flag
* Granular execution control via tags (e.g., `--tags azure-cli`)
* Testing utilities:
  * `test-role.sh`: Individual role testing
  * `test-roles.sh`: Comprehensive test suite
  * `validate.sh`: Project structure validation
* Development tools:
  * `.gitignore`: Comprehensive exclusions for Ansible artifacts
  * `.gitattributes`: Cross-platform line ending normalization
* Complete documentation in `README.md` with quick start, and examples
* Change documentation in `CHANGELOG.md`
* Release pipeline with automatic versioning and CHANGELOG validation
* Support for both automatic (release-please) and manual tag-based releases
* CI validation for CHANGELOG updates with releasable commits
* Configured trunk-based development workflow (main branch only)
