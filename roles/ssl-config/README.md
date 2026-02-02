# Role: ssl-config

Purpose: manage SSL/TLS configuration and optional organization CA.

- Feature flag: `enable_ssl_config` (default: yes)
- Tags: `ssl-config`
- Key vars: `ssl_ca_cert_name`, `ssl_openssl_config_path`, `ssl_ca_cert_path`

Usage:

- Provide CA file in project root named as `ssl_ca_cert_name`.
- Run only this role: `ansible-playbook main.yml --tags ssl-config`.
