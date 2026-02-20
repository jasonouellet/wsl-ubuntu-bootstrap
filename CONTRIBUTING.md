# Contributing to WSL Ubuntu Bootstrap

Thank you for your interest in contributing to WSL Ubuntu Bootstrap!
This document provides guidelines for contributing to this project.

## 🎯 Ways to Contribute

* Report bugs and issues
* Suggest new features or enhancements
* Submit bug fixes
* Add new roles or improve existing ones
* Improve documentation
* Add tests and validation

## 📋 Before You Start

1. Check existing [issues](../../issues) and [pull requests](../../pulls)
   to avoid duplicates
2. For major changes, open an issue first to discuss your proposal
3. Ensure you have a working Ansible environment (Ubuntu/Debian)

## 🔧 Development Setup

### Prerequisites

```bash
# Install Ansible
sudo apt update
sudo apt install ansible

# Clone the repository
git clone https://github.com/jasonouellet/wsl-ubuntu-bootstrap.git
cd wsl-ubuntu-bootstrap

# Test the playbook
ansible-playbook main.yml --check -K
```

### Project Structure

```text
wsl-ubuntu-bootstrap/
├── main.yml              # Main playbook
├── roles/                # Ansible roles
│   ├── common/           # Base system
│   ├── python/           # Python environment
│   └── ...
├── group_vars/           # Configuration variables
└── tests/                # Test scripts
```

## 📝 Coding Standards

### Ansible Best Practices

1. **Use YAML lint**: Validate YAML syntax with `yamllint`
2. **Follow Ansible-lint**: Run `ansible-lint` before committing
3. **Idempotency**: Ensure tasks can run multiple times safely
4. **Variables**: Use descriptive names in `snake_case`
5. **Documentation**: Comment complex logic

### Role Structure

Each role should follow this structure:

```text
role-name/
├── defaults/
│   └── main.yml          # Default variables
├── tasks/
│   └── main.yml          # Tasks
├── handlers/
│   └── main.yml          # Handlers (if needed)
└── README.md             # Role documentation (optional)
```

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```text
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**

* `feat`: New feature
* `fix`: Bug fix
* `docs`: Documentation changes
* `style`: Code style changes (formatting, etc.)
* `refactor`: Code refactoring
* `test`: Adding or updating tests
* `chore`: Maintenance tasks

**Examples:**

```text
feat(python): add support for Python 3.12
fix(azure-cli): correct GPG key installation
docs(readme): update installation instructions
```

## 🧪 Testing

### Test Individual Roles

```bash
# Test a specific role
./test-role.sh <role-name> -K

# Example
./test-role.sh python -K run
```

### Test All Roles

```bash
# Dry-run
./test-roles.sh

# Full execution
./test-roles.sh run
```

### Validate Project

```bash
./validate.sh
```

## 🚀 Release Process

Releases are automated and driven by Release Please and tags.

### Prerequisites

* Write access to the repository (merge to `main`)
* Conventional Commits on merged PRs
* CHANGELOG.md updated as part of the release PR

### How to trigger a release

1. Merge PRs into `main` using Conventional Commits
2. Release Please creates or updates a release PR
3. Review and merge the release PR
4. On merge, Release Please creates tag `vX.Y.Z` and a GitHub release
5. The tag triggers the release workflow, which validates CHANGELOG and finalizes the release

### Manual release (fallback)

If you need to run the release workflow manually, use the `workflow_dispatch`
trigger in GitHub Actions, but the preferred path is to merge the release PR.

## 📤 Submitting Changes

### Pull Request Process

1. **Fork the repository** and create a feature branch

   ```bash
   git checkout -b feat/my-new-feature
   ```

2. **Make your changes** following the coding standards

3. **Test thoroughly**

   ```bash
   ansible-playbook main.yml --check -K
   ./validate.sh
   ```

4. **Commit your changes** with clear messages

   ```bash
   git commit -m "feat(nodejs): add Node.js 20 LTS support"
   ```

5. **Push to your fork**

   ```bash
   git push origin feat/my-new-feature
   ```

6. **Open a Pull Request** with:
   * Clear description of changes
   * Reference to related issues
   * Test results
   * Screenshots (if applicable)

### Pull Request Checklist

* [ ] Code follows project style guidelines
* [ ] All tests pass successfully
* [ ] Documentation updated (README, CHANGELOG)
* [ ] Commit messages follow conventions
* [ ] No merge conflicts with main branch
* [ ] Added tests for new functionality (if applicable)

## 🐛 Reporting Bugs

When reporting bugs, please include:

1. **Description**: Clear description of the issue
2. **Steps to Reproduce**: Detailed steps to reproduce the bug
3. **Expected Behavior**: What you expected to happen
4. **Actual Behavior**: What actually happened
5. **Environment**:
   * OS version (e.g., Ubuntu 24.04)
   * Ansible version
   * WSL version (if applicable)
6. **Logs**: Relevant error messages or logs
7. **Configuration**: Relevant `group_vars` settings

## 💡 Feature Requests

When suggesting features:

1. **Use Case**: Describe the problem you're trying to solve
2. **Proposed Solution**: Your suggested approach
3. **Alternatives**: Other solutions you've considered
4. **Additional Context**: Screenshots, examples, or references

## 📖 Documentation

Good documentation is crucial:

* Update README.md for user-facing changes
* Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/)
* Add inline comments for complex logic
* Include examples in role documentation

## 🔍 Code Review

All submissions require review. We aim to:

* Respond to PRs within 48 hours
* Provide constructive feedback
* Merge approved changes promptly

## 📜 License

By contributing, you agree that your contributions will be licensed under the
project's [MIT License](LICENSE).

## 🙏 Recognition

Contributors will be recognized in:

* CHANGELOG.md for their contributions
* GitHub contributors page
* Release notes for significant features

## ❓ Questions?

* Open an issue for questions
* Check existing documentation
* Review closed issues for solutions

Thank you for contributing! 🎉
