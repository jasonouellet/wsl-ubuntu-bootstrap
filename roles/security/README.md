# Security Scanning Tools Role

Installs and configures security scanning tools for vulnerability detection, secret scanning,
and SBOM generation.

## Dependencies

This role depends on the **python** role, which provides:

* `pipx` - Python CLI application installer (from common role)

The dependency is automatically managed via `meta/main.yml`. When you include the security role,
the python role will be executed first to ensure pipx is available.

## Installation Method

This role uses **official upstream installation methods**:

### Trivy Installation

* Downloads GPG key from official Aqua Security repository
* Adds official Trivy APT repository with signature verification
* Installs via package manager (recommended for production)
* Ref: [Trivy Installation - Debian/Ubuntu](https://trivy.dev/docs/latest/getting-started/installation/#debianubuntu-official)

### Syft Installation

* Uses official Anchore installer script
* Downloads binary directly from `get.anchore.io`
* Creates isolated installation in `/usr/local/bin`
* Ref: [Syft Installation Guide](https://oss.anchore.com/docs/installation/syft/)

## Tools Installed

### Trivy

* **Purpose**: Vulnerability and secret scanner
* **Source**: Official Aqua Security Debian repository
* **Features**:
  * Scans for known vulnerabilities (CVE database)
  * Detects exposed secrets and credentials
  * Supports container images, filesystems, and configuration files
  * Fast and lightweight scanning

### Syft

* **Purpose**: Generate Software Bill of Materials (SBOM)
* **Source**: Official Anchore installer script
* **Installation**: Binary downloaded and installed to `/usr/local/bin/syft`
* **Features**:
  * Generates SBOM in multiple formats (CycloneDX, SPDX, Syft JSON)
  * Analyzes software artifacts for dependencies
  * Integrates with supply chain security tools
  * Provides visibility into software composition

### Detect-Secrets

* **Purpose**: Secret detection and prevention
* **Source**: Installed via pipx in this role
* **Installation**: For current user via `pipx install`
* **Features**:
  * Installed via pipx for isolation
  * Detects 25+ patterns (API keys, passwords, tokens)
  * Git hook integration via pre-commit
  * Baseline configuration to prevent false positives
  * Prevents accidental secret commits

## Configuration

* **Enable/Disable**: Set `security_enable: yes/no` in `group_vars/all.yml`
* **Packages**: Controlled via `security_scanning_packages` variable
* **Pre-commit**: Automatically configured when running pre-commit hooks

## Usage

### Trivy Scanning

```bash
trivy fs /path/to/scan                    # Scan filesystem for vulnerabilities
trivy image myimage:latest                 # Scan container image
trivy fs --format json --output results.json /path/to/scan  # Scan with JSON output
```

### Syft SBOM Generation

```bash
syft -o cyclonedx-json /path/to/scan > sbom.json      # Generate CycloneDX SBOM
syft -o spdx-json /path/to/scan > sbom-spdx.json      # Generate SPDX SBOM
syft -o help                                           # Show format support
```

### Secret Detection with Detect-Secrets

```bash
detect-secrets scan > .secrets.baseline                              # Initialize baseline
detect-secrets baseline validate .secrets.baseline                   # Validate baseline
pre-commit run detect-secrets --all-files                            # Hook via pre-commit
```

## Tags

* `security` - All security-related tasks
* `packages` - Package installation
* `gpg` - GPG key and repository setup
* `test` - Verification and version checks

## Role Variables

| Variable | Default | Description |
| --- | --- | --- |
| `security_enable` | `yes` | Enable/disable this role |
| `security_scanning_packages` | `[trivy]` | APT packages to install |
| `syft_installer_url` | URL | Syft official installer script URL |
| `trivy_apt_key` | URL | Trivy GPG key URL |

## See Also

* [Security Scanning Documentation](../../docs/SECURITY_SCANNING.md)
* [Detect-Secrets Configuration](../../docs/SECURITY_SCANNING.md#detect-secrets)
* [Trivy Documentation](https://trivy.dev/docs/latest/getting-started/installation/)
* [Syft Documentation](https://github.com/anchore/syft)
