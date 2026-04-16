# Dependabot Configuration

Dependabot automates project dependency updates via GitHub.

## Overview

Dependabot automatically creates pull requests to update:

* **GitHub Actions** (workflows CI/CD)
* **Python packages** (pip)
* **Docker images** (future, if containerization is added)

## Configuration

### Schedule

```yaml
- Day: Wednesday
- Time: 03:00 UTC (GitHub Actions), 03:15 UTC (Python)
- Frequency: Weekly
```

### Update Strategy

| Ecosystem | Auto-merge | PR Limit | Labels |
| --- | --- | --- | --- |
| **github-actions** | ✅ Auto (toutes versions) | 5 | `dependencies`, `github-actions` |
| **pip** | ❌ Manuel | 5 | `dependencies`, `python` |
| **docker** | N/A (commenté) | - | - |

## Workflow

### For GitHub Actions

1. Dependabot **detects** new versions every Wednesday
2. Creates a **PR with available updates**
3. **Auto-merges** minor/patch updates (v1.2.3 → v1.2.4)
4. PRs remain **manual** for major changes (v1.2.3 → v2.0.0)

Example:

```
deps(github-actions): bump actions/checkout from v4.0.0 to v4.1.0
deps(github-actions): bump aquasecurity/trivy-action from master to v0.16.0
```

### For Python pip

1. Dependabot **scans** Python dependencies
2. Creates a **PR for each available update**
3. **Requires manual review** before merge
4. Useful for future dependencies (ansible-core, etc.)

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
