# Pull Request

## Description

<!-- Provide a clear and concise description of your changes -->

## Type of Change

<!-- Mark the relevant option with an 'x' -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing
  functionality to not work as expected)
- [ ] Documentation update
- [ ] Code refactoring
- [ ] Performance improvement
- [ ] Test addition or update
- [ ] Chore (maintenance, dependencies, etc.)

## Related Issue

<!-- Link to the related issue(s) -->

Fixes #
Relates to #

## Changes Made

<!-- List the main changes in this PR -->

- ...
- ...
- ...

## Testing

<!-- Describe how you tested your changes -->

### Test Environment

- **OS**: Ubuntu 24.04 / 22.04 / WSL2
- **Ansible Version**:
- **Test Method**: Check mode / Full execution / Both

### Test Commands

```bash
# Commands you ran to test
ansible-playbook main.yml --check -K
./validate.sh
./test-role.sh <role-name> run
```

### Test Results

```text
# Paste test output or summary
PLAY RECAP *******************************************************
localhost                  : ok=X    changed=Y    unreachable=0    failed=0
```

## Checklist

<!-- Mark completed items with an 'x' -->

### General

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings or errors
- [ ] Any dependent changes have been merged and published

### Testing & Validation

- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing tests pass locally with my changes
- [ ] I have tested with `--check` mode (dry-run)
- [ ] I have tested with full execution

### Ansible Specifics

- [ ] Tasks are idempotent (can run multiple times safely)
- [ ] Used ansible-lint to validate playbook
- [ ] Followed Ansible naming conventions
- [ ] Added appropriate tags for selective execution
- [ ] Used handlers where appropriate
- [ ] Variables are well documented in defaults/main.yml or group_vars
- [ ] Role is tested independently

### Documentation

- [ ] README.md updated (if applicable)
- [ ] CHANGELOG.md updated following [Keep a Changelog](https://keepachangelog.com/)
- [ ] Role-specific documentation added/updated (if applicable)
- [ ] Comments added to complex code
- [ ] Examples provided (if applicable)

## Screenshots

<!-- If applicable, add screenshots to help explain your changes -->

## Breaking Changes

<!-- If this PR includes breaking changes, describe them here -->

**None** / **Yes, see below:**

- ...
- ...

## Migration Guide

<!-- If breaking changes exist, provide migration steps -->

```bash
# Steps to migrate from previous version
```

## Additional Context

<!-- Add any other context about the PR here -->

## Reviewer Notes

<!-- Special instructions or areas for reviewers to focus on -->

---

**By submitting this pull request, I confirm that:**

- [ ] I have read and agree to the [Code of Conduct](../CODE_OF_CONDUCT.md)
- [ ] I have read the [Contributing Guidelines](../CONTRIBUTING.md)
- [ ] My contribution is licensed under the project's [MIT License](../LICENSE)
