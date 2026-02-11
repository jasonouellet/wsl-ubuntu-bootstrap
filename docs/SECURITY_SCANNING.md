# Security & Quality Scanning

Ce projet utilise plusieurs outils pour assurer la qualité et la sécurité du code.

## Scanning Tools

### 1. **Trivy** (Filesystem Scanner)

* 🔍 **Scans** :
  * Vulnérabilités (CVE database)
  * Secrets (API keys, tokens, credentials)
  * Misconfigurations
* 📊 **Résultats** : Uploadés vers GitHub Code Scanning (onglet "Security" → "Code scanning")
* 🎯 **Exclusions** : `.git`, `.github`, `node_modules`, `.ansible`

### 2. **Detect-Secrets** (Pre-commit hook)

* 🔐 **Prévient** : L'accidental commit de credentials
* 📋 **Baseline** : `.secrets.baseline` liste les secrets connus/intentionnels
* 🛑 **Bloque** : Tout type de tokens (AWS, Azure, GitHub, private keys, etc.)
* ⚙️ **Plugins** : 25+ détecteurs de secrets activés

### 3. **SBOM Generation** (Anchore Syft)

* 📦 **Génère** : Software Bill of Materials (SPDX JSON)
* 📥 **Stockage** : Artifact disponible 30 jours (onglet "Artifacts")
* 🔗 **Utilité** : Traçabilité open source, audit de licence, inventory des composants
* 📋 **Format** : SPDX 2.2 (standard industrie)

### 4. **SonarCloud**

* 🔬 **Analyse** : Qualité de code, code smells, duplications
* ⚡ **Couverture** : Ansible, Shell, YAML, Python, Markdown
* 📊 **Dashboard** : <https://sonarcloud.io/project/overview?id=jasonouellet_wsl-ubuntu-bootstrap>

### 5. **Ansible-lint**

* ✅ **Valide** : Syntax Ansible, best practices
* ⚙️ **Config** : `.ansible-lint`
* 🏷️ **Profil** : production (strict)

### 6. **Yamllint**

* 💯 **Format** : 120 chars max, indentation, etc.
* ⚙️ **Config** : `.yamllint`

### 7. **Shellcheck**

* 🐚 **Scripts** : Détecte les bugs shell courants
* 📊 **Sévérité** : Warning et au-dessus

### 8. **Markdownlint**

* 📝 **Markup** : Markdown bien formé

## Workflow CI

### Exécution (GitHub Actions)

Le workflow `ci.yml` exécute tous les outils dans cet ordre :

1. ✅ Pre-commit hooks (yamllint, shellcheck, markdownlint, detect-secrets)
2. ✅ Ansible-lint
3. ✅ Playbook syntax check
4. ✅ Playbook dry-run
5. ✅ Sonar version validation
6. ✅ SonarCloud scan
7. 🔍 Trivy scan (vulnerabilities + secrets)
8. 📦 SBOM generation

### Résultats

| Outil | Emplacement |
| --- | --- |
| Trivy | Security → Code Scanning |
| SBOM | Artifacts (30 jours) |
| SonarCloud | [View on SonarCloud](https://sonarcloud.io/project/jasonouellet_wsl-ubuntu-bootstrap) |
| Logs | Actions → Job Logs |

## Secrets Management

### Detected-Secrets Baseline

Si vous avez un secret intentionnel à ignorer :

```bash
# Mettre en whitelist (après vérification)
detect-secrets audit .secrets.baseline
```

## Local Testing

### Exécuter les validations localement

```bash
# Pre-commit (tous les hooks)
pre-commit run --all-files

# Ansible-lint
ansible-lint main.yml -v

# Trivy (nécessite Trivy installé)
trivy fs . --severity HIGH,CRITICAL

# Detect-secrets
detect-secrets scan
```

## Ressources

* [Trivy Documentation](https://aquasecurity.github.io/trivy/)
* [Detect-Secrets](https://github.com/Yelp/detect-secrets)
* [SBOM/Syft](https://github.com/anchore/syft)
* [SonarCloud](https://sonarcloud.io/)
* [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning)
