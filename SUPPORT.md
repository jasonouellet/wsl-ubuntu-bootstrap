# Support

## Getting Help

Thank you for using WSL Ubuntu Bootstrap! Here's how to get help:

## 📚 Documentation

First, check the project documentation:

* **[README.md](README.md)** - Installation, usage, and configuration
* **[CONTRIBUTING.md](CONTRIBUTING.md)** - Development and contribution guidelines
* **[CHANGELOG.md](CHANGELOG.md)** - Version history and changes

## 🔍 Before Asking for Help

1. **Search existing issues**: Your question might already be answered
   * [Open Issues](../../issues)
   * [Closed Issues](../../issues?q=is%3Aissue+is%3Aclosed)

2. **Check the documentation**: Review README and role-specific docs

3. **Run validation**: Use the included validation script

   ```bash
   ./validate.sh
   ```

4. **Test in check mode**: Verify your configuration

   ```bash
   ansible-playbook main.yml --check -K
   ```

## 💬 Ways to Get Support

### Community Support (Free)

For general questions, feature requests, and discussions:

1. **GitHub Discussions** (Recommended)
   * General questions
   * Feature ideas
   * Show and tell
   * Community help

2. **GitHub Issues** (For bugs and problems)
   * Bug reports
   * Installation issues
   * Configuration problems
   * Unexpected behavior

### What to Include

When asking for help, please provide:

**Environment:**

* OS: Ubuntu 24.04 LTS, Debian 13 (Trixie), or compatible Debian-based distribution
* Ansible version: 2.16.3 or higher
* WSL version: WSL2 (if applicable)

**Problem:**

Clear description of the issue

**Steps to Reproduce:**

1. Step one
2. Step two
3. ...

**Expected Behavior:**

What you expected to happen

**Actual Behavior:**

What actually happened

**Configuration:**

```yaml
# Relevant group_vars/all.yml settings
enable_python: yes
enable_nodejs: yes
```

**Logs/Output:**

```text
Error messages or relevant output
```

**What I've Tried:**

* Checked documentation
* Ran validate.sh
* Searched existing issues

## 🐛 Reporting Bugs

See [CONTRIBUTING.md](CONTRIBUTING.md#-reporting-bugs) for detailed guidelines.

**Quick checklist:**

* [ ] Searched existing issues
* [ ] Tested with latest version
* [ ] Included environment details
* [ ] Provided reproduction steps
* [ ] Attached relevant logs

## 💡 Feature Requests

See [CONTRIBUTING.md](CONTRIBUTING.md#-feature-requests) for guidelines.

**Use the feature request template:**

* Problem/Use case
* Proposed solution
* Alternatives considered
* Additional context

## 🔧 Troubleshooting

### Common Issues

#### 1. Ansible Not Found

```bash
# Install Ansible
sudo apt update
sudo apt install ansible
```

#### 2. Permission Denied

```bash
# First run requires sudo password
ansible-playbook main.yml -K

# Subsequent runs (after NOPASSWD is configured)
ansible-playbook main.yml
```

#### 3. GPG Key Errors

```bash
# Check key installation
ls -la /etc/apt/keyrings/
apt-key list
```

#### 4. Role Fails in Check Mode

Some tasks need actual execution:

```bash
# Skip check mode for fact-gathering tasks
# This is handled automatically in the playbook
```

### Debug Mode

Run with verbose output:

```bash
# Basic verbosity
ansible-playbook main.yml -v

# More details
ansible-playbook main.yml -vv

# Maximum verbosity
ansible-playbook main.yml -vvv
```

### Test Individual Roles

```bash
# Test one role at a time
./test-role.sh common
./test-role.sh python
./test-role.sh nodejs
```

## 📖 Additional Resources

### Official Documentation

* [Ansible Documentation](https://docs.ansible.com/)
* [Ubuntu WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
* [Terraform Documentation](https://www.terraform.io/docs)
* [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)

### Tutorials and Guides

* [Getting Started with Ansible](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)
* [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)
* [WSL Best Practices](https://docs.microsoft.com/en-us/windows/wsl/best-practices)

## ⏱️ Response Times

This is a community-driven project. Typical response times:

* **Issues**: 24-48 hours for initial response
* **Pull Requests**: 48-72 hours for review
* **Discussions**: Community-dependent

## 🤝 Contributing

The best way to get help is to help others!

* Answer questions in discussions
* Help triage issues
* Improve documentation
* Submit bug fixes

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## 📬 Contact

* **GitHub Issues**: For bugs and problems
* **GitHub Discussions**: For questions and ideas
* **Pull Requests**: For contributions

**Note**: This project does not offer:

* Private support contracts
* On-call assistance
* Guaranteed response times
* Implementation services

## 🙏 Thank You

Thank you for using WSL Ubuntu Bootstrap!
We appreciate your patience and understanding as this is a community-maintained project.

---

**Need immediate help?**

1. Check the README.md troubleshooting section
2. Run `./validate.sh`
3. Search closed issues
4. Open a new issue with details

We're here to help! 🎉
