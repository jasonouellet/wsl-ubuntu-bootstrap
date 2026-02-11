# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Currently supported versions:

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

The WSL Ubuntu Bootstrap team takes security seriously.
We appreciate your efforts to responsibly disclose your findings.

### How to Report

**Please DO NOT report security vulnerabilities through public GitHub issues.**

Instead, please report security vulnerabilities by:

1. **Opening a private security advisory** on GitHub:
   * Go to the repository's Security tab
   * Click "Report a vulnerability"
   * Fill out the advisory form

2. **Or by email** (if private advisory is not available):
   * Contact the maintainers directly through their GitHub profiles
   * Include detailed information about the vulnerability

### What to Include

Please include the following information in your report:

* **Description**: Clear description of the vulnerability
* **Impact**: Potential impact of the vulnerability
* **Steps to Reproduce**: Detailed steps to reproduce the issue
* **Affected Components**: Which roles or files are affected
* **Severity**: Your assessment of severity (Critical/High/Medium/Low)
* **Proof of Concept**: Code or commands demonstrating the vulnerability
* **Suggested Fix**: Your recommendation for fixing the issue (if any)

### Response Timeline

* **Initial Response**: Within 48 hours
* **Confirmation**: Within 7 days
* **Fix Timeline**: Depends on severity
  * Critical: Immediate action (24-48 hours)
  * High: Within 1 week
  * Medium: Within 2 weeks
  * Low: Within 30 days

## Security Considerations

### Credential Management

This project handles sensitive operations. Please be aware:

1. **Never commit credentials** to the repository
   * API keys
   * Passwords
   * Private keys
   * Tokens

2. **Use Ansible Vault** for sensitive variables

   ```bash
   ansible-vault create group_vars/vault.yml
   ```

3. **Check .gitignore** before committing
   * Ensure sensitive files are excluded
   * Review: `group_vars/local.yml`, `*.key`, `*.pem`

### Sudo/Privilege Escalation

The playbook requires `sudo` access:

1. **NOPASSWD Configuration**
   * The `common` role auto-configures sudo NOPASSWD
   * Review `/etc/sudoers.d/` files regularly
   * Only use on trusted, development environments

2. **WSL Considerations**
   * WSL2 environments are generally isolated
   * Still follow security best practices
   * Limit network exposure

### Package Repositories

This project adds third-party repositories:

1. **GPG Key Verification**
   * All keys are verified during installation
   * Keys stored in `/etc/apt/keyrings/` (modern approach)
   * Review `roles/*/tasks/main.yml` for key sources

2. **Repository URLs**
   * HashiCorp: `https://apt.releases.hashicorp.com`
   * Microsoft Azure: `https://packages.microsoft.com`
   * NodeSource: `https://deb.nodesource.com`

### Auto-Update Script

The maintenance role installs a daily auto-update cronjob:

1. **Review the script**: `/usr/local/bin/auto-update.sh`
2. **Check logs**: `/var/log/auto-update.log`
3. **Disable if needed**: Set `maintenance_enable_auto_update: no`

### Network Security

1. **SSL/TLS Certificates**
   * Custom CA certificates can be installed
   * Placed in `/usr/local/share/ca-certificates/`
   * Review certificate sources

2. **HTTPS-Only**
   * All package downloads use HTTPS
   * APT repositories use secure transport

## Known Security Considerations

### Development Environment Focus

This playbook is designed for **development environments**, particularly WSL:

* ⚠️ **Not recommended for production servers**
* ⚠️ **Sudo NOPASSWD is enabled by default**
* ⚠️ **Auto-updates may break dependencies**

### Recommended Practices

For development use:

* ✅ Use on isolated WSL instances
* ✅ Keep WSL updated regularly
* ✅ Backup important data
* ✅ Review changes before applying

For production use:

* ❌ Disable NOPASSWD sudo
* ❌ Disable auto-updates
* ❌ Review all roles thoroughly
* ❌ Test in staging first

## Security Updates

Security updates are released as patch versions (e.g., 0.1.1).

**Subscribe to notifications:**

* Watch the repository for releases
* Check CHANGELOG.md for security-related changes

## Third-Party Dependencies

This project relies on:

* Ansible (automation engine)
* APT packages from Ubuntu/Debian
* Third-party repositories (HashiCorp, Microsoft, NodeSource)
* Python packages via pip
* NPM packages (if installed)

**Responsibility:**

* We ensure secure installation practices
* Upstream vulnerabilities are outside our control
* Monitor security advisories for dependencies

## Secure Development

Contributors should:

1. **Review all changes** that handle:
   * Credentials
   * File permissions
   * Network connections
   * Privilege escalation

2. **Test security features**:

   ```bash
   # Verify GPG keys
   apt-key list

   # Check file permissions
   ls -la /etc/sudoers.d/

   # Review crontabs
   sudo crontab -l
   ```

3. **Follow least privilege principle**
   * Use minimal permissions
   * Avoid wildcards in sudoers
   * Validate file paths

## Disclosure Policy

* Security issues are handled privately until fixed
* Credit given to reporters (unless anonymity requested)
* Public disclosure after patch is released
* Security advisories published on GitHub

## Additional Resources

* [Ansible Security Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#best-practices-for-security)
* [Ubuntu Security](https://ubuntu.com/security)
* [WSL Security](https://docs.microsoft.com/en-us/windows/wsl/security)

---

**Last Updated**: January 30, 2026

Thank you for helping keep WSL Ubuntu Bootstrap secure! 🔒
