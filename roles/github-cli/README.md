# Role: github-cli

Purpose: install GitHub CLI (gh) for automation and GPG key upload.

- Feature flag: `enable_github_cli` (default: yes)
- Tags: `github-cli`
- Key vars: `github_cli_gpg_key_id`, `github_cli_upload_gpg_key`

Usage:

- Run only this role: `ansible-playbook main.yml --tags github-cli`
- To upload a key, set `github_cli_upload_gpg_key: yes` and provide
  `github_cli_gpg_key_id`.
