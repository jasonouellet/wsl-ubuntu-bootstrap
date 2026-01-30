---
name: Bug Report
about: Report a bug or unexpected behavior
title: '[BUG] '
labels: bug
assignees: ''
---

## Bug Description

<!-- A clear and concise description of the bug -->

## Environment

- **OS**: Ubuntu 24.04 / 22.04 / WSL2
- **Ansible Version**: [Run `ansible --version`]
- **WSL Version** (if applicable): [Run `wsl --version` in PowerShell]
- **Playbook Version**: [e.g., 0.1.0]

## Steps to Reproduce

1. ...
2. ...
3. ...
4. ...

## Expected Behavior

<!-- What you expected to happen -->

## Actual Behavior

<!-- What actually happened -->

## Error Output

<!-- Paste the full error message or output -->

```text
# Error output here
```

## Configuration

<!-- Relevant settings from group_vars/all.yml -->

```yaml
enable_python: yes
enable_nodejs: yes
# ... other relevant settings
```

## Logs

<!-- If applicable, attach logs -->

```bash
# Run with verbose output
ansible-playbook main.yml -vvv

# Or role-specific test
./test-role.sh <role-name> -K
```

## What I've Tried

<!-- List troubleshooting steps you've already taken -->

- [ ] Ran `./validate.sh`
- [ ] Tested with `--check` mode
- [ ] Checked existing issues
- [ ] Reviewed documentation
- [ ] Tried with fresh installation

## Additional Context

<!-- Any other context, screenshots, or information -->

## Possible Solution

<!-- If you have ideas on how to fix this, share them here -->
