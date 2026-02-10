# Dependabot Configuration

Dependabot automatise les mises à jour des dépendances du projet via GitHub.

## Vue d'ensemble

Dependabot crée automatiquement des Pull Requests pour mettre à jour :

* **GitHub Actions** (workflows CI/CD)
* **Python packages** (pip)
* **Docker images** (futur, si containerisation)

## Configuration

### Schedule

```yaml
- Jour : Mercredi
- Heure : 03:00 UTC (GitHub Actions), 03:15 UTC (Python)
- Fréquence : Hebdomadaire
```

### Stratégie de mise à jour

| Écosystème | Auto-merge | Limite PRs | Étiquettes |
| --- | --- | --- | --- |
| **github-actions** | ✅ Auto (toutes versions) | 5 | `dependencies`, `github-actions` |
| **pip** | ❌ Manuel | 5 | `dependencies`, `python` |
| **docker** | N/A (commenté) | - | - |

## Workflow

### Pour GitHub Actions

1. Dependabot **détecte** les nouvelles versions chaque mercredi
2. Crée une **PR avec les mises à jour disponibles**
3. **Auto-merge** des mises à jour mineures/patches (v1.2.3 → v1.2.4)
4. PR reste **manuelle** pour les changements majeurs (v1.2.3 → v2.0.0)

Exemple :

```
deps(github-actions): bump actions/checkout from v4.0.0 to v4.1.0
deps(github-actions): bump aquasecurity/trivy-action from master to v0.16.0
```

### Pour Python pip

1. Dependabot **scanne** les dépendances Python
2. Crée une **PR pour chaque mise à jour disponible**
3. **Nécessite une revue manuelle** avant merge
4. Utile pour futures dépendances (ansible-core, etc.)

## GitHubUI - Vérifier l'état

### Alertes de dépendances

Menu : **Security** → **Dependabot alerts**

Affiche :

* ✅ Dépendances saines
* ⚠️ Mises à jour disponibles
* 🔴 Vulnérabilités détectées

### Pull Requests générées

Menu : **Pull requests** → Filtre `label:dependencies`

Affiche toutes les PR Dependabot

## Configuration locale (optionnel)

### Désactiver Dependabot temporairement

Éditer `.github/dependabot.yml` et commenter les sections

### Tester la configuration

GitHub valide automatiquement la syntaxe. Erreurs affichées dans :
**Settings** → **Code security & analysis** → **Dependabot** → **Alerts**

## Bonnes pratiques

### À FAIRE

* Reviser les PRs Dependabot rapidement (détecte souvent des vulnérabilités)
* Laisser les workflows CI/CD valider antes d'accepter
* Grouper les mises à jour mineures si possible

### À ÉVITER

* Désactiver Dependabot (sauf raison fondamentale)
* Ignorer les alertes de sécurité
* Fusionner sans passer les tests

## Exemples de PR générées

```
[Dependabot] deps(github-actions): bump SonarSource/sonarcloud-github-action from v2.0.0 to v2.1.0

This PR updates the sonarcloud-github-action GitHub Action to v2.1.0.

Release Notes: https://github.com/SonarSource/sonarcloud-github-action/releases/tag/v2.1.0
```

## Ressources

* [GitHub Dependabot Docs](https://docs.github.com/en/code-security/dependabot)
* [Dependabot Configuration Docs](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-dependency-updates)
* [Supported Package Managers](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates#supported-repositories-and-ecosystems)
