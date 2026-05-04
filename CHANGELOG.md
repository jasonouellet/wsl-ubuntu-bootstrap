# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- markdownlint-disable MD024 -->

## Unreleased

## [0.5.1] - 2026-05-04

### Fixed

* Fixed `github` role GPG key task failing with `chgrp failed: failed to look up group _apt` on Ubuntu
  environments where the `_apt` group is absent: changed `group` to `root` and `mode` to `0644`
* Fixed `k8s` role checksum download 404 errors caused by upstream GitHub release asset renames:
  * `istio`: replaced `checksums.txt` with per-asset `.sha256` file (`{{ k8s_istioctl_download_url }}.sha256`)
  * `calico`: replaced `checksums` with `SHA256SUMS` (uppercase, actual asset name)
  * `k9s`: replaced `checksums.txt` with `checksums.sha256`
  * `argocd`: replaced `checksums.txt` with `cli_checksums.txt`
  * `kubectx`/`kubens`: aligned download URLs to tarball assets (`kubectx_v..._linux_x86_64.tar.gz`)
    and added `unarchive` install tasks; updated `group_vars/all.yml` download URLs accordingly
* Fixed all `k8s` role checksum extraction tasks failing with `/bin/sh: set: Illegal option -o pipefail`
  on Ubuntu (dash shell): replaced all `shell` tasks using `set -o pipefail | grep | awk` with
  portable `command` tasks using `awk` regex matching across all k8s installer task files
  (`install-argocd.yml`, `install-calico.yml`, `install-cilium.yml`, `install-falcoctl.yml`,
  `install-kind.yml`, `install-kubectx.yml`, `install-kubescape.yml`, `install-kustomize.yml`)
* Fixed Hashicorp APT repository conflict (`Conflicting values set for option Signed-By`) caused by
  duplicate entries with different `signed-by` key paths in `/etc/apt/sources.list.d/hashicorp.list`
* Fixed `ansible-playbook --check` in Ubuntu environment with multiple tasks
  that were silently skipped due to Jinja2 3.0.x changes in string handling and
  undefined variable behavior:
  * Replaced `!= ''` string comparisons with `| length > 0` in `main.yml` and
    `ssl-config` role for Jinja2 3.0.x compatibility
  * Added `check_mode: false` to version verification tasks in `python`,
    `nodejs`, and `ssl-config` roles to prevent silent skips during `--check`
  * Added `failed_when: false` and `check_mode: false` to OCI tool checks in
    `containers` role; use `| default()` filter on `stdout` references
  * Guarded `github` and `containers` version display tasks against missing
    `stdout` in check mode or before installation
  * Fixed `nodejs_npm_path.rc` condition with `is defined` guard

### Changed

* Simplified `.NET` distribution condition checks in `dotnet` role: removed
  intermediate `set_fact` variables `dotnet_is_debian_13` / `dotnet_is_debian_12`
  in favour of inline conditions

## [0.5.0] - 2026-05-02

### Added

* Added Renovate configuration in `.renovaterc.json` for variable-driven
  dependency updates in `group_vars/all.yml`
* Added scheduled Renovate workflow `.github/workflows/renovate.yml`:
  * Weekly execution on Sunday at 04:00 UTC
  * Manual execution via `workflow_dispatch`
* Added `renovate-validate` job in CI:
  * Runs Renovate in local dry-run mode
  * Publishes a markdown summary table in workflow job summary
  * Uploads validation artifacts (`renovate-local.log`, summary markdown)
  * Posts or updates a PR comment with the validation summary
* Added dynamic checksum verification for Kubernetes binary installers by
  downloading official upstream checksum files at install time

### Changed

* Improved workflow runtime safety with concurrency controls and explicit timeout settings
* Bumped `github/codeql-action` from 4.35.2 to 4.35.3 (patch)
* Bumped `SonarSource/sonarqube-scan-action` from 7.1.0 to 8.0.0 (major)

### Fixed

* Resolved Sonar and shell quality issues in CI and scripts (`validate-sonar-version.sh`, `auto-update.sh`)

## [0.4.0] - 2026-04-29

### Added

* Added new `k8s` role to install Kubernetes and cloud-native CLI tooling
* Added Kubernetes tooling installation support for:
  * `kubectl` (APT via `pkgs.k8s.io`)
  * `helm` (APT via Helm Buildkite repository)
  * `istioctl` (GitHub release binary)
  * `calicoctl` (GitHub release binary)
  * `k9s` (GitHub release binary)
  * `kubectx` and `kubens` (GitHub release binaries)
  * `argocd` (GitHub release binary)
  * `kind` (GitHub release binary)
  * `kustomize` (GitHub release binary)
* Added optional Kubernetes tooling flags and installers for:
  * `kubescape` (`k8s_enable_kubescape`)
  * `falcoctl` (`k8s_enable_falcoctl`)
  * `cilium` (`k8s_enable_cilium`)
* Added role documentation for Kubernetes tooling in `roles/k8s/README.md`

## [0.3.0] - 2026-04-24

### Changed

* Replaced the previous release-please PR flow with an automated tag-first release flow:
  * `.github/workflows/tag-release.yml` validates `CHANGELOG.md`,
    calculates version with GitVersion, pushes `vX.Y.Z` tags on `main`, and
    publishes GitHub releases with version-scoped notes from `CHANGELOG.md`
* Set GitVersion semantic bump rules:
  * `feat:` -> minor
  * `feat!:` or `BREAKING CHANGE:` -> major
  * `fix:` -> patch
* Added bump visibility in the tag workflow logs with an explicit detected bump type (major/minor/patch)
* Added CI guard logic to detect releasable commits and verify `CHANGELOG.md` updates
* Added fail-fast validation in `tag-release.yml` to require an exact
  `CHANGELOG.md` heading for the GitVersion-calculated release version before
  tag and release publication

### Fixed

* Made the CI changelog guard non-blocking by emitting a GitHub Actions
  warning instead of failing the pipeline when releasable changes are missing
  changelog updates

### Removed

* Removed the `release-please.yml` workflow from the release automation path
* Removed the standalone `.github/workflows/release.yml` workflow to avoid
  duplicated release logic

## [0.2.3] - 2026-04-23

### Changed

* Translated documentation to English for consistency across repository guides
* Improve auto-release processing with release-please tool

## [0.2.2] - 2026-04-17

### Fixed

* **CI Stability**: Resolved CI pipeline issues to restore successful validation and release flow

## [0.2.1] - 2026-04-17

### Changed

* **Release Automation**: Upgraded and improved auto-release workflows for more reliable versioning and publication

## [0.2.0] - 2026-04-15

### Added

* **Debian 13 (Trixie) Support**: Full compatibility with Debian 13 including distribution-specific installation methods
* **Modular Role Architecture**: Split `dotnet` and `azure-cli` roles into separate task files for better maintainability
  * `main.yml`: Distribution detection and orchestration
  * `install-<method>.yml`: Method-specific implementations
* **GitHub Copilot CLI Support**: Added `copilot` installation and verification to the GitHub tooling role

### Changed

* **.NET SDK Installation**: Dual installation paths based on distribution
  * **Debian 13**: Microsoft installation script method with ICU library dependencies
  * **Debian 12/Ubuntu**: APT repository method (existing)
* **Azure CLI Installation**: Dual installation paths based on distribution
  * **Debian 13**: APT repository method with Microsoft-supported fallback suite (`bookworm`)
  * **Debian 12/Ubuntu**: APT repository method (existing)
* **APT Keyrings**: Centralized `/etc/apt/keyrings/` directory creation in `common` role
* **GitHub Role Naming**: Renamed role and primary tag from `github-cli` to
  `github` to better reflect support for both `gh` and `copilot`
* **Python Role (pipx scope)**: pipx-managed CLI tools are now installed
  globally for all users using shared paths (`/opt/pipx` and
  `/usr/local/bin`) instead of user-scoped locations

### Fixed

* Corrected ICU library dependency for .NET on Debian 13 (`libicu76` instead of `libicu72`)
* Fixed user detection in sudo context for pipx installations (`SUDO_USER` environment variable)
* Resolved Microsoft package repository unavailability for Debian 13 with alternative methods
* Fixed `pre-commit` availability mismatch where tools were installed under
  root context only; tools are now exposed through shared global pipx bin path

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

<!-- markdownlint-enable MD024 -->
