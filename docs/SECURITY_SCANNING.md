# Security & Quality Scanning

This project uses multiple tools to ensure code quality and security.

## Scanning Tools

### 1. **Trivy** (Filesystem Scanner)

* 🔍 **Scans**:
  * Vulnerabilities (CVE database)
  * Secrets (API keys, tokens, credentials)
  * Misconfigurations
* 📊 **Results**: Uploaded to GitHub Code Scanning (Security tab → Code scanning)
* 🎯 **Exclusions**: `.git`, `.github`, `node_modules`, `.ansible`

### 2. **Detect-Secrets** (Pre-commit hook)

* 🔐 **Prevents**: Accidental credential commits
* 📋 **Baseline**: `.secrets.baseline` lists known/intentional secrets
* 🛑 **Blocks**: All token types (AWS, Azure, GitHub, private keys, etc.)
* ⚙️ **Plugins**: 25+ secret detectors enabled

### 3. **SBOM Generation** (Anchore Syft)

* 📦 **Generates**: Software Bill of Materials (SPDX JSON)
* 📥 **Storage**: Artifact available for 30 days (Artifacts tab)
* 🔗 **Utility**: Open-source traceability, license audit, component inventory
* 📋 **Format**: SPDX 2.2 (industry standard)

### 4. **SonarCloud**

* 🔬 **Analysis**: Code quality, code smells, duplications
* ⚡ **Coverage**: Ansible, Shell, YAML, Python, Markdown
* 📊 **Dashboard**: <https://sonarcloud.io/project/overview?id=jasonouellet_wsl-ubuntu-bootstrap>
* 🧩 **Imports**: SARIF via `sonar.sarifReportPaths` (`ci-results` directory)

### 5. **CodeQL**

* 🧭 **Analysis**: GitHub security engine
* 📄 **Output**: SARIF
* 📊 **Results**: GitHub Security → Code Scanning

### 6. **Ansible-lint**

* ✅ **Validates**: Ansible syntax, best practices
* ⚙️ **Config**: `.ansible-lint`
* 🏷️ **Profile**: production (strict)

### 7. **Yamllint**

* 💯 **Format**: 120 chars max, indentation, etc.
* ⚙️ **Config**: `.yamllint`

### 8. **Shellcheck**

* 🐚 **Scripts**: Detects common shell bugs
* 📊 **Severity**: Warning and above

### 9. **Markdownlint**

* 📝 **Markup**: Well-formed Markdown

## CI Workflow

### Execution (GitHub Actions)

The `ci.yml` workflow runs all tools in this order:

1. ✅ Pre-commit hooks (yamllint, shellcheck, markdownlint, detect-secrets)
2. ✅ Ansible-lint
3. ✅ Playbook syntax check
4. ✅ Playbook dry-run
5. 🔍 Trivy scan (vulnerabilities + secrets + misconfig)
6. 📦 SBOM generation
7. ✅ CodeQL scan (separate job, SARIF)
8. ✅ SonarCloud scan (imports Trivy/CodeQL SARIF when available)
9. ⚠️ CHANGELOG guard warning for releasable commits without changelog updates (non-blocking)

### Results

| Tool | Location |
| --- | --- |
| CodeQL | Security → Code Scanning |
| Trivy | Security → Code Scanning |
| SBOM | Artifacts (30 jours) |
| SonarCloud | [View on SonarCloud](https://sonarcloud.io/project/jasonouellet_wsl-ubuntu-bootstrap) |
| Logs | Actions → Job Logs |

## Secrets Management

### Detect-Secrets Baseline

If you have an intentional secret to ignore:

```bash
# Add to allowlist (after verification)
detect-secrets audit .secrets.baseline
```

## Local Testing

### Run validations locally

```bash
# Pre-commit (all hooks)
pre-commit run --all-files

# Ansible-lint
ansible-lint main.yml -v

# Trivy (requires Trivy installed)
trivy fs . --severity HIGH,CRITICAL

# Detect-secrets
detect-secrets scan
```

## Resources

* [Trivy Documentation](https://aquasecurity.github.io/trivy/)
* [Detect-Secrets](https://github.com/Yelp/detect-secrets)
* [SBOM/Syft](https://github.com/anchore/syft)
* [SonarCloud](https://sonarcloud.io/)
* [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning)
