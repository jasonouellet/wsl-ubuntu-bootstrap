# 🔒 Security Hardening & Enhancement Roadmap

This document outlines recommended security hardening measures and additional
tooling enhancements for the WSL Ubuntu Bootstrap development environment.

## 📋 Overview

As a development environment bootstrap, this playbook prioritizes ease of setup
and functionality. This guide provides optional enhancements for:

* **Security Hardening**: Production-grade security controls
* **Developer Tools**: Quality-of-life improvements
* **Compliance**: Audit and logging capabilities
* **Secret Management**: Secure credential handling

---

## 🔴 PRIORITY 1 - Critical Hardening

### 1. SSH Hardening

**Purpose**: Secure SSH access to prevent unauthorized access

```yaml
# New role: ssh-hardening
ssh_hardening_tasks:
  - Disable password authentication (SSH keys only)
  - Disable root login
  - Configure session timeout (ClientAliveInterval)
  - Disable X11 forwarding by default
  - Limit concurrent sessions
  - Optional: Change SSH port from default 22
  - Optional: IP whitelisting for specific networks
```

**Risk Level**: HIGH | **Effort**: LOW | **Impact**: Critical

### 2. Firewall Configuration (UFW)

**Purpose**: Network-level access control

```yaml
# Enhance common role or create: firewall
firewall_tasks:
  - Enable UFW (Uncomplicated Firewall)
  - Default: Deny incoming, Allow outgoing
  - Allow SSH (22)
  - Allow HTTP (80) if needed
  - Allow HTTPS (443)
  - Development ports (8000-9000): Allow from localhost
  - Node.js dev (3000): Allow from localhost
  - Python Flask/Django (5000): Allow from localhost
  - Optional: Rate limiting on SSH port
```

**Risk Level**: HIGH | **Effort**: LOW | **Impact**: High

### 3. GPG & SSH Key Management

**Purpose**: Secure cryptographic key generation and management

```yaml
# Enhance github-cli role or create: key-management
key_management_tasks:
  - Generate SSH keys if missing (ed25519 preferred)
  - Configure GPG key for commit signing
  - Validate key fingerprints
  - Setup ssh-agent for key caching
  - Configure git commit.gpgSign = true
  - Optional: Hardware security keys (YubiKey) integration
```

**Risk Level**: MEDIUM | **Effort**: MEDIUM | **Impact**: High

---

## 🟡 PRIORITY 2 - Defensive Security & Secrets

### 4. Git Secrets Detection

**Purpose**: Prevent accidental credential/secret commits

```yaml
# Enhance python role (pre-commit configuration):
secret_scanning_tools:
  - gitleaks: Detect hardcoded secrets and API keys
  - detect-secrets: Secret pattern detection
  - checkov: Infrastructure-as-Code security scanning
  - truffleHog: Detect secrets in git history

# Implementation:
# Add to pre-commit hooks in group_vars/all.yml
# All tools run before git commit
```

**Risk Level**: HIGH | **Effort**: LOW | **Impact**: Critical

**Example pre-commit configuration**:

```yaml
repos:
  - repo: https://github.com/Yelp/detect-secrets
    rev: v1.4.0
    hooks:
      - id: detect-secrets
        args: ['--baseline', '.secrets.baseline']

  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

### 5. Secret Management (Development)

**Purpose**: Secure local credential and sensitive data management

```yaml
# New role: secrets-management
secrets_tools:
  - 1password-cli: Commercial password manager CLI
    OR
  - bitwarden-cli: Open-source password manager CLI
    OR
  - pass: Unix password manager

  - direnv: Load environment variables per directory
  - dotenv-linter: Validate .env files
```

**Risk Level**: MEDIUM | **Effort**: MEDIUM | **Impact**: High

### 6. Audit & Logging

**Purpose**: Track system changes and detect anomalies

```yaml
# New role: audit-logging
audit_tasks:
  - Install auditd (kernel audit daemon)
  - Monitor sudo executions
  - Monitor SSH login attempts
  - Monitor file access to sensitive directories
  - Configure log retention (1 month minimum)
  - Setup auditbeat for log aggregation
```

**Risk Level**: MEDIUM | **Effort**: MEDIUM | **Impact**: Medium

### 7. Fail2Ban / Intrusion Detection

**Purpose**: Protect against brute-force attacks

```yaml
# Add to common role
fail2ban_tasks:
  - Install fail2ban
  - SSH jail (block after 5 failed attempts)
  - Configure ban duration (30 minutes)
  - Enable email notifications
```

**Risk Level**: MEDIUM | **Effort**: LOW | **Impact**: Medium

---

## 🟡 PRIORITY 2 - Developer Tooling

### 8. Container Security

**Purpose**: Secure container image building and scanning

```yaml
# Enhance containers role
container_security_tools:
  - Trivy: Container image vulnerability scanner
  - Grype: Software vulnerability detection
  - Syft: Software bill of materials (SBOM) generator
  - Podman: Rootless container alternative to Docker
  - OCI policy enforcement
```

**Example**:

```bash
trivy image --severity HIGH,CRITICAL my-image:latest
grype my-image:latest
```

### 9. API Development Tools

**Purpose**: Improve HTTP/API development experience

```yaml
# New role: api-tools
api_dev_tools:
  - httpie: User-friendly HTTP CLI (better than curl)
  - grpcurl: gRPC command-line client
  - mkcert: HTTPS certificates for local development
  - Insomnia CLI: REST/GraphQL API client
  - openapi-cli: OpenAPI specification validation
```

**Risk Level**: LOW | **Effort**: LOW | **Impact**: DX improvement

### 10. Version Managers

**Purpose**: Manage multiple language versions per project

```yaml
# New role: version-managers
version_management:
  - asdf: Universal version manager (Node, Python, Go, etc.)
    Alternative: nvm + pyenv + goenv (separate)
  - direnv: Automatic environment setup per directory
  - mise: Rust-based version manager (alternative to asdf)
```

**Example .tool-versions file**:

```text
nodejs 20.10.0
python 3.11.7
terraform 1.6.0
```

---

## 🟢 PRIORITY 3 - Quality of Life

### 11. Terminal & Shell Enhancement

**Purpose**: Improve shell productivity and aesthetics

```yaml
# Enhance common role
shell_enhancements:
  - zsh: Feature-rich shell (or keep bash)
  - oh-my-zsh: Zsh framework with plugins
  - starship: Modern shell prompt
  - fzf: Fuzzy file finder
  - bat: Cat replacement with syntax highlighting
  - ripgrep: Faster grep alternative
  - eza: Modern ls replacement
  - tldr: Simplified man pages
  - thefuck: Autocorrect shell commands
```

### 12. Development Utilities

**Purpose**: Common dev tools

```yaml
# Add to appropriate roles
dev_utilities:
  - httpie-cli: Better curl
  - jq-alternative (yq): YAML processor
  - vscode-server: Remote VS Code
  - lazygit: Terminal UI for git
  - bottom: System monitor (alternative to top)
  - lnav: Log file navigator
```

### 13. Documentation Tools

**Purpose**: Enhanced MkDocs setup (already included)

```yaml
# Verify in group_vars/all.yml - Already configured:
- mkdocs
- mkdocs-material
- mkdocs-techdocs-core
- mkdocs-macros-plugin
- plantuml-markdown
- markdown-graphviz-inline
```

---

## ⚙️ Configuration Best Practices

### 1. Feature Flags

All hardening roles should include feature flags to allow opt-in:

```yaml
enable_ssh_hardening: yes
enable_firewall: yes
enable_audit_logging: no
```

### 2. Testing Before Production

```bash
# Dry-run mode to preview changes
ansible-playbook main.yml --check

# Test individual hardening role
./test-role.sh ssh-hardening

# Verify no breaking changes
ssh localhost "echo 'SSH still works'"
```

### 3. Gradual Rollout

* Test in non-critical environment first
* Enable one hardening measure at a time
* Monitor logs for unexpected behavior
* Document any application-specific exceptions

---

## 🚨 Security Considerations

### SSH Key Generation

* Use **ed25519** (modern, compact, secure)
* Avoid RSA unless legacy compatibility needed
* Protect private keys with strong passphrases
* Store public keys in `~/.ssh/authorized_keys`

### Firewall Rules

* Default to **deny**, explicitly allow what's needed
* Use **source IP restrictions** when possible
* Log firewall drops for debugging
* Test connectivity before deploying broadly

### Secret Management

* **Never** store secrets in git (even encrypted)
* Use environment variables or secret managers
* Rotate secrets regularly
* Audit secret access logs

### Auditing

* Retain logs for **minimum 30 days**
* Monitor for unusual sudo activity
* Alert on failed SSH login attempts
* Track file modifications in `/etc/ssh/` and other sensitive paths

---

## 📚 References

### Security Standards

* [CIS Benchmarks](https://www.cisecurity.org/benchmarks/)
* [OWASP DevSecOps](https://owasp.org/www-project-devsecops-guideline/)
* [NSA/CISA Cybersecurity Guidance](https://www.nsa.gov/cybersecurity/support-tools-and-services/security-advisories/)

### Ansible Security

* [Ansible Security Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#security)
* [Ansible vault for secrets](https://docs.ansible.com/ansible/latest/user_guide/vault.html)

### Tools

* [SSH Hardening Guide](https://man.openbsd.org/sshd_config)
* [UFW Documentation](https://help.ubuntu.com/community/UFW)
* [Pre-commit Framework](https://pre-commit.com/)
* [Gitleaks](https://github.com/gitleaks/gitleaks)

---

## 🤝 Contributing Hardening Improvements

When implementing these enhancements, follow the existing patterns and always
validate with linters before committing.

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details.

---

**Last Updated**: 2026-02-03
**Status**: Planning
**Maintained by**: WSL Ubuntu Bootstrap Team
