# Role: github-cli

Purpose: install GitHub CLI (`gh`) for automation and authentication.

* Feature flag: `enable_github_cli` (default: yes)
* Tags: `github-cli`

Usage:

* Run only this role: `ansible-playbook main.yml --tags github-cli`
* Verify installation: `gh --version`
* Authenticate: `gh auth login`
