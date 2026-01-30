#!/bin/bash
# =========================================
# Quick Test Single Role
# =========================================
# Usage:
#   ./test-role.sh common
#   ./test-role.sh nodejs -K
#   ./test-role.sh azure-cli -K run

ROLE="$1"
SUDO_FLAG=""
MODE="--check"

if [[ -z "$ROLE" ]]; then
    echo "Usage: $0 <role-name> [-K] [run]"
    echo ""
    echo "Available roles:"
    echo "  - common"
    echo "  - ssl-config"
    echo "  - python"
    echo "  - containers"
    echo "  - terraform"
    echo "  - dotnet"
    echo "  - nodejs"
    echo "  - azure-cli"
    echo ""
    echo "Examples:"
    echo "  $0 common              # Dry-run without sudo"
    echo "  $0 nodejs -K           # Dry-run with sudo prompt"
    echo "  $0 azure-cli -K run    # Execute with sudo prompt"
    exit 1
fi

# Parse arguments
shift
while [[ $# -gt 0 ]]; do
    case $1 in
        -K|--ask-become-pass)
            SUDO_FLAG="-K"
            shift
            ;;
        run|execute)
            MODE=""
            shift
            ;;
        *)
            shift
            ;;
    esac
done

echo "=========================================="
echo "Testing role: $ROLE"
if [[ -z "$MODE" ]]; then
    echo "Mode: EXECUTE (will make changes)"
else
    echo "Mode: CHECK (dry-run)"
fi
echo "=========================================="
echo ""

ansible-playbook main.yml --tags "$ROLE" $MODE $SUDO_FLAG -v
