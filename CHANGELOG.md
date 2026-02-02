# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 (2026-02-02)


### Features

* add markdownlint-cli2 via npm and configure pre-commit hooks ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* upgrade to Node.js v22.22.0 via NodeSource ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))


### Bug Fixes

* codify markdownlint YAML config in Ansible ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* configure ansible-lint with proper dependencies ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* correct ansible-lint yaml[truthy] and command-instead-of-shell violations ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* correct indentation in nodejs role verify block ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* correct remaining yaml[truthy] violations in nodejs and python roles ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* remove markdownlint-cli from python packages (npm tool, not python) ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* resolve all linting errors in workflows and documentation ([d57325f](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/d57325f38d9cd16da556b02cdf0dde9244e7d1fc))
* shell linter ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* use ansible-lint in pre-commit hooks ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))
* use markdownlint-cli2 v0.13.0 compatible with Node.js 18+ ([32c5d5e](https://github.com/jasonouellet/wsl-ubuntu-bootstrap/commit/32c5d5ea148e04e1b177bb604fdf01a8ca7d0bb4))

## [Unreleased]

### Added

- Release pipeline with automatic versioning and CHANGELOG validation
- Support for both automatic (release-please) and manual tag-based releases
- CI validation for CHANGELOG updates with releasable commits
- Hybrid release workflow requiring CHANGELOG updates

### Fixed

- Corrected YAML boolean values (yes/no → true/false) for ansible-lint compliance
- Fixed command vs shell module usage in NodeSource setup task
- Resolved Node.js version consistency (v22.22.0 with npm 10.9.4)

### Changed

- Configured trunk-based development workflow (main branch only)
- Updated CI/CD to support manual trigger via workflow_dispatch

## [0.1.0] - 2026-01-30

### Initial Release

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
