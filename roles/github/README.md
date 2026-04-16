# Role: github

Installs and verifies GitHub terminal tooling:

* **GitHub CLI (`gh`)**
* **GitHub Copilot CLI (`gh copilot`)**

Copilot is managed **with GitHub CLI** (always together). There is no separate
Copilot enable/disable option in this role anymore.

## What this role does

| Step | Ansible module | Description |
| --- | --- | --- |
| apt GPG key | `get_url` | Downloads the signing key for the official GitHub CLI apt repository |
| apt repository | `apt_repository` | Adds the `cli.github.com/packages/` repository |
| Install `gh` | `apt` | Installs the `gh` package from the official repository |
| Detect Copilot mode | `command` | Detects whether `gh copilot` is built-in or extension-based |
| Auth check | `command` | Checks `gh auth status` to decide whether extension install is possible |
| Install/upgrade extension (legacy mode) | `command` | Installs/upgrades `github/gh-copilot` only when needed |
| Verify | `command` | Validates `gh --version` and `gh copilot --version` |

## Variables

| Variable | Default | Description |
| --- | --- | --- |
| `enable_github_cli` | `yes` | Enable/disable the whole GitHub tooling role (`gh` + Copilot CLI) |

## Available tags

| Tag | Scope |
| --- | --- |
| `github` | All tasks in the role |
| `copilot-cli` | Copilot-related tasks |
| `packages` | Installation tasks |
| `gpg` | apt GPG key task |
| `repository` | apt repository task |
| `test` | Verification and display tasks |

## Usage

```bash
# Run the full role
ansible-playbook main.yml --tags github
```

## Authentication behavior

* If `gh copilot` is built-in (modern `gh`), no extension install is needed.
* If extension mode is required, the role asks you to authenticate with
  `gh auth login` if needed, then rerun the role.
* The role always prints guidance about the correct upgrade command:
  * built-in mode: upgrade `gh` via apt
  * extension mode: `gh extension upgrade github/gh-copilot`

## After installation

```bash
# Verify installations
gh --version
gh copilot --version

# Authenticate GitHub CLI (recommended to use Copilot features)
gh auth login

# Launch Copilot
gh copilot
```

## Prerequisites

* Ubuntu/Debian (official GitHub CLI apt repository)
* Internet access to download packages
* An active GitHub Copilot subscription to use Copilot features
