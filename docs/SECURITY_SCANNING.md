# Security & Quality Scanning

Ce projet utilise plusieurs outils pour assurer la qualité et la sécurité du code.

## Scanning Tools

### 1. **CodeQL** (Static Code Analysis)

* 🔬 **Analyse** :
  * Vulnérabilités de sécurité (injection, XSS, etc.)
  * Bugs de logique et patterns dangereux
  * Code quality issues
* 🎯 **Langages** : Python, JavaScript/TypeScript
* 📊 **Résultats** : GitHub Security → Code scanning alerts
* ⏱️ **Exécution** : À chaque PR, push sur main, et hebdomadaire (lundi)
* 🔐 **Query Pack** : `security-and-quality` (GitHub Advanced Security)

### 2. **Trivy** (Filesystem Scanner)

* 🔍 **Scans** :
  * Vulnérabilités (CVE database)
  * Secrets (API keys, tokens, credentials)
  * Misconfigurations
* 📊 **Résultats** : Uploadés vers GitHub Code Scanning (onglet "Security" → "Code scanning")
* 🎯 **Exclusions** : `.git`, `.github`, `node_modules`, `.ansible`

### 3. **Detect-Secrets** (Pre-commit hook)

* 🔐 **Prévient** : L'accidental commit de credentials
* 📋 **Baseline** : `.secrets.baseline` liste les secrets connus/intentionnels
* 🛑 **Bloque** : Tout type de tokens (AWS, Azure, GitHub, private keys, etc.)
* ⚙️ **Plugins** : 25+ détecteurs de secrets activés

### 4. **SBOM Generation** (Anchore Syft)

* 📦 **Génère** : Software Bill of Materials (SPDX JSON)
* 📥 **Stockage** : Artifact disponible 30 jours (onglet "Artifacts")
* 🔗 **Utilité** : Traçabilité open source, audit de licence, inventory des composants
* 📋 **Format** : SPDX 2.2 (standard industrie)

### 5. **SonarCloud**

* 🔬 **Analyse** : Qualité de code, code smells, duplications
* ⚡ **Couverture** : Ansible, Shell, YAML, Python, Markdown
* 📊 **Dashboard** : <https://sonarcloud.io/project/overview?id=jasonouellet_wsl-ubuntu-bootstrap>

### 6. **Ansible-lint**

* ✅ **Valide** : Syntax Ansible, best practices
* ⚙️ **Config** : `.ansible-lint`
* 🏷️ **Profil** : production (strict)

### 7. **Yamllint**

* 💯 **Format** : 120 chars max, indentation, etc.
* ⚙️ **Config** : `.yamllint`

### 8. **Shellcheck**

* 🐚 **Scripts** : Détecte les bugs shell courants
* 📊 **Sévérité** : Warning et au-dessus

### 9. **Markdownlint**

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

Le workflow `codeql.yml` exécute en parallèle :

1. 🔬 CodeQL analysis (Python + JavaScript/TypeScript)
2. 📊 Upload vers GitHub Security → Code scanning

### Résultats

| Outil | Emplacement |
| --- | --- |
| CodeQL | Security → Code Scanning |
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

# CodeQL (nécessite CodeQL CLI installé)
# Note: CodeQL s'exécute principalement dans GitHub Actions
# Pour installation locale: https://github.com/github/codeql-cli-binaries
codeql database create codeql-db --language=python,javascript
codeql database analyze codeql-db --format=sarif-latest --output=results.sarif
```

## Ressources

* [CodeQL Documentation](https://codeql.github.com/docs/)
* [Trivy Documentation](https://aquasecurity.github.io/trivy/)
* [Detect-Secrets](https://github.com/Yelp/detect-secrets)
* [SBOM/Syft](https://github.com/anchore/syft)
* [SonarCloud](https://sonarcloud.io/)
* [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning)
