# Release Process

Ce projet utilise une approche **hybride de release** :

- **Release-Please** crée automatiquement les PRs avec versions
- **CI Validation** s'assure que le CHANGELOG a été mis à jour
- **Release Workflow** crée la release GitHub une fois le PR mergé

## Workflow de Release

### 1. Commits et PRs

Utilisez les [conventional commits](https://www.conventionalcommits.org/) :

```bash
# Nouvelle feature
git commit -m "feat: add support for AWS deployment"

# Bug fix
git commit -m "fix: resolve ansible-lint yaml validation errors"

# Breaking change
git commit -m "feat!: redesign role structure

BREAKING CHANGE: old role format no longer supported"

# Documentation
git commit -m "docs: update installation instructions"

# CI/CD
git commit -m "ci: add release validation job"
```

### 2. Release-Please crée automatiquement un PR

- Analyse les commits depuis la dernière release
- Crée un PR avec :
  - Version bump (MAJOR.MINOR.PATCH)
  - CHANGELOG mis à jour
  - Tag approprié
- Vous merchez simplement le PR

### 3. CI Validation

**Lors de chaque commit/PR**, le CI vérifie :

- ✅ Linting (ansible-lint, yamllint, shellcheck, markdownlint)
- ✅ Syntax check du playbook
- ✅ CHANGELOG a section `[Unreleased]`
- ✅ Si `feat:` ou `fix:` existent, CHANGELOG est à jour

### 4. Release Automatique

Une fois le PR mergé :

1. Release-Please crée un tag `v1.2.3` sur main
2. Le workflow `release.yml` :
   - Valide que CHANGELOG a été modifié
   - Crée une GitHub Release avec le contenu du CHANGELOG
   - Les utilisateurs peuvent télécharger les assets

## Formats de Commits Reconnus

| Type | Version | Changelog | Description |
|------|---------|-----------|-------------|
| `feat:` | MINOR | ✅ | New feature |
| `fix:` | PATCH | ✅ | Bug fix |
| `feat!:` | MAJOR | ✅ | Breaking change |
| `docs:` | - | ✅ | Documentation |
| `ci:` | - | ✅ | CI/CD |
| `refactor:` | - | ✅ | Code refactoring |
| `perf:` | - | ✅ | Performance |
| `test:` | - | ✅ | Tests |
| `chore:` | - | ❌ | Chores |

## Manuellement Déclencher une Release

Si vous voulez créer une release manuellement :

```bash
# Créer un tag
git tag v1.2.3 -m "Release version 1.2.3"

# Pousser le tag (déclenche le workflow)
git push origin v1.2.3
```

## CHANGELOG.md Format

Le CHANGELOG suit [Keep a Changelog](https://keepachangelog.com/) :

```markdown
## [Unreleased]

### Added
- New features

### Fixed
- Bug fixes

### Changed
- Changes

### Removed
- Removed features

## [1.2.3] - 2026-02-02

### Added
- Initial release
```

## Processus Recommandé

1. **Développez** avec commits conventionnels
2. **Créez un PR** sur main
3. **CI Valide** tout (linting + CHANGELOG)
4. **Merger le PR**
5. **Release-Please crée un PR de release**
6. **Merger le PR de release** → Release GitHub automatique ✅

## Semantic Versioning

- **MAJOR** : Breaking changes (0→1.0.0)
- **MINOR** : New features, backward compatible (1.0.0→1.1.0)
- **PATCH** : Bug fixes only (1.0.0→1.0.1)

## Troubleshooting

**Q: Release-Please ne crée pas de PR**
→ Vérifiez que vous avez des commits `feat:` ou `fix:` depuis la dernière release

**Q: CHANGELOG check échoue**
→ Assurez-vous que CHANGELOG.md a une section `## [Unreleased]`

**Q: Je veux créer une release maintenant**
→ Créez manuellement un tag : `git tag v1.2.3 && git push origin v1.2.3`
