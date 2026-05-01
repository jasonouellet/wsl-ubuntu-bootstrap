# Dependabot Configuration

Dependabot automates project dependency updates via GitHub.

This repository uses **both** Dependabot and Renovate:

* **Dependabot**: ecosystem-native updates (`github-actions`, `pre-commit`)
* **Renovate**: repository variable-driven updates from `group_vars/all.yml`

## Overview

Dependabot automatically creates pull requests to update:

* **GitHub Actions** (workflows CI/CD)
* **pre-commit hooks** (`.pre-commit-config.yaml`)

## Configuration

### Schedule

```yaml
- Day: Saturday (GitHub Actions), Monday (pre-commit)
- Time: 03:00 and 03:15 (UTC)
- Frequency: Weekly
```

### Update Strategy

| Ecosystem | Auto-merge | PR Limit | Labels |
| --- | --- | --- | --- |
| **github-actions** | ❌ Manual | 5 | `dependencies`, `github-actions` |
| **pre-commit** | ❌ Manual | 5 | `dependencies`, `pre-commit` |

## Workflow

### For GitHub Actions

1. Dependabot **detects** new versions every Saturday
2. Creates a **PR with available updates**
3. **Auto-merges** minor/patch updates (v1.2.3 → v1.2.4)
4. PRs remain **manual** for major changes (v1.2.3 → v2.0.0)

Example:

```
deps(github-actions): bump actions/checkout from v4.0.0 to v4.1.0
deps(github-actions): bump aquasecurity/trivy-action from master to v0.16.0
```

### For pre-commit hooks

1. Dependabot **scans** pinned hook versions in `.pre-commit-config.yaml`
2. Creates a **PR for each available update**
3. **Requires manual review** before merge
4. Keeps developer tooling and lint hook versions current

### For role and tool versions in group_vars/all.yml

Dependabot does not update custom Ansible variable versions in this repository.
Those updates are handled by Renovate (`.renovaterc.json` + `renovate.yml` workflow).

## GitHub UI - Check Status

### Dependency Alerts

Menu: **Security** → **Dependabot alerts**

Shows:

* ✅ Healthy dependencies
* ⚠️ Updates available
* 🔴 Vulnerabilities detected

### Generated Pull Requests

Menu: **Pull requests** → Filter `label:dependencies`

Shows all Dependabot PRs

## Local Configuration (optional)

### Temporarily disable Dependabot

Edit `.github/dependabot.yml` and comment out sections

### Test the configuration

GitHub automatically validates the syntax. Errors appear in:
**Settings** → **Code security & analysis** → **Dependabot** → **Alerts**

## Relation with Renovate

Use both tools with separate responsibilities:

* Dependabot for ecosystem-native dependency manifests
* Renovate for variable-driven versions and custom regex managers

## Best Practices

### DO

* Review Dependabot PRs quickly (they often catch vulnerabilities)
* Let CI/CD workflows validate before accepting
* Group minor updates when possible

### AVOID

* Disabling Dependabot (unless there is a critical reason)
* Ignoring security alerts
* Merging without tests

## Example Generated PRs

```
[Dependabot] deps(github-actions): bump SonarSource/sonarcloud-github-action from v2.0.0 to v2.1.0

This PR updates the sonarcloud-github-action GitHub Action to v2.1.0.

Release Notes: https://github.com/SonarSource/sonarcloud-github-action/releases/tag/v2.1.0
```

## Resources

* [GitHub Dependabot Docs](https://docs.github.com/en/code-security/dependabot)
* [Dependabot Configuration Docs](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-dependency-updates)
* [Supported Package Managers](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates#supported-repositories-and-ecosystems)
