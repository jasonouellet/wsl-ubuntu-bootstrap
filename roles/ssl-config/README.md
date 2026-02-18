# Role: ssl-config

Purpose: manage SSL/TLS configuration and optional organization CA.

* Feature flag: `enable_ssl_config` (default: yes)
* Tags: `ssl-config`
* Key vars: `ssl_ca_cert_name`, `ssl_openssl_config_path`, `ssl_ca_cert_path`

Usage:

* Provide CA file in project root named as `ssl_ca_cert_name`.
* Run only this role: `ansible-playbook main.yml --tags ssl-config`.

## HTTPS Connectivity Test (Optional)

By default, the role tests HTTPS connectivity after installing the CA certificate using both curl and Python. You can control this behavior:

- `ssl_test_connectivity`: Enable/disable HTTPS tests (default: yes)
- `ssl_test_url`: URL to test (default: https://github.com)

Example to disable or change the test in your `group_vars/custom.yml`:

```yaml
ssl_test_connectivity: no
ssl_test_url: "https://example.com"
```
