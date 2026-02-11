# Role: maintenance

Purpose: install daily auto-update script and cron job.

* Feature flag: `enable_maintenance` (default: yes)
* Tags: `maintenance`, `test`
* Key vars: `maintenance_enable_auto_update`

Usage:

* Run only this role: `ansible-playbook main.yml --tags maintenance`
* Auto-update runs daily at 03:00; disable via `maintenance_enable_auto_update: no`.
