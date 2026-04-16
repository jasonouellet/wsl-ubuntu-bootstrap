#!/bin/bash
# Validate that sonar-project.properties version matches CHANGELOG.md
# Usage: ./validate-sonar-version.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

CHANGELOG_FILE="$REPO_ROOT/CHANGELOG.md"
SONAR_CONFIG="$REPO_ROOT/sonar-project.properties"

# Extract latest version from CHANGELOG (first released version, skip Unreleased)
CHANGELOG_VERSION=$(grep -m 1 '## \[[0-9]' "$CHANGELOG_FILE" | grep -oP '(?<=\[)[0-9]+\.[0-9]+\.[0-9]+(?=\])' || true)

# Extract version from sonar-project.properties
SONAR_VERSION=$(grep '^sonar.projectVersion=' "$SONAR_CONFIG" | cut -d'=' -f2)

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Validating SonarCloud Version Sync"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "CHANGELOG.md version:      $CHANGELOG_VERSION"
echo "sonar-project.properties:  $SONAR_VERSION"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -z "$CHANGELOG_VERSION" ]; then
  echo "⚠  Warning: Could not extract version from CHANGELOG.md"
  echo "   This might indicate no released versions exist yet."
  exit 0
fi

if [ "$CHANGELOG_VERSION" != "$SONAR_VERSION" ]; then
  echo "❌ Error: Version mismatch!"
  echo ""
  echo "   Action required:"
  echo "   1. Update sonar-project.properties:"
  echo "      sonar.projectVersion=$CHANGELOG_VERSION"
  echo ""
  echo "   2. Commit and push the changes"
  exit 1
fi

echo "✅ Version check passed: $SONAR_VERSION matches CHANGELOG.md"
exit 0
