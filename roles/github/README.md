# Role: github

Installs and verifies two complementary GitHub command-line tools:

- **GitHub CLI (`gh`)** — interact with the GitHub API (repos, PRs, issues, authentication).
- **GitHub Copilot CLI (`copilot`)** — AI coding agent directly in the terminal, powered by GitHub Copilot.

## What this role does

| Step | Ansible module | Description |
|---|---|---|
| apt GPG key | `get_url` | Downloads the signing key for the official GitHub CLI apt repository |
| apt repository | `apt_repository` | Adds the `cli.github.com/packages/` repository |
| Install `gh` | `apt` | Installs the `gh` package from the official repository |
| Download Copilot CLI install script | `get_url` | Downloads `https://gh.io/copilot-install` to `/tmp/` |
| Install Copilot CLI | `command` | Runs the install script, places `copilot` in `/usr/local/bin/` |
| Verify | `command` | Displays installed versions of `gh` and `copilot` |

## Variables

| Variable | Default | Description |
|---|---|---|
| `enable_github_cli` | `yes` | Enable/disable installation of `gh` |
| `enable_copilot_cli` | `yes` | Enable/disable installation of `copilot` |

## Available tags

| Tag | Scope |
|---|---|
| `github` | All tasks in the role |
| `copilot-cli` | Copilot CLI tasks only |
| `packages` | Installation tasks |
| `gpg` | apt GPG key task |
| `repository` | apt repository task |
| `test` | Version verification and display tasks |

## Usage

```bash
# Run the full role
ansible-playbook main.yml --tags github

# Install Copilot CLI only
ansible-playbook main.yml --tags copilot-cli

# Disable Copilot CLI installation
ansible-playbook main.yml --tags github -e enable_copilot_cli=no
```

## After installation

```bash
# Verify installations
gh --version
copilot --version

# Authenticate GitHub CLI
gh auth login

# Launch GitHub Copilot CLI (uses gh authentication if already logged in)
copilot
```

## Prerequisites

- Ubuntu/Debian (official GitHub CLI apt repository)
- Internet access to download packages and the install script
- An active GitHub Copilot subscription to use `copilot`
