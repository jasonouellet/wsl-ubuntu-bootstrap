#!/bin/bash
# =========================================
# Test Each Role Individually
# =========================================

set -e

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ROLES=(
    "common"
    "ssl-config"
    "python"
    "containers"
    "terraform"
    "dotnet"
    "nodejs"
    "azure-cli"
)

echo "=========================================="
echo "Testing Ansible Roles Individually"
echo "=========================================="
echo ""

# Check if -K flag should be used
SUDO_FLAG=""
if [[ "$1" == "-K" ]] || [[ "$1" == "--ask-become-pass" ]]; then
    SUDO_FLAG="-K"
    echo -e "${YELLOW}Will prompt for sudo password${NC}"
    echo ""
fi

# Mode: check or run
MODE="${2:-check}"
if [[ "$MODE" == "run" ]]; then
    MODE_FLAG=""
    echo -e "${BLUE}Running in EXECUTE mode${NC}"
else
    MODE_FLAG="--check"
    echo -e "${BLUE}Running in CHECK mode (dry-run)${NC}"
fi
echo ""

# Test each role
for role in "${ROLES[@]}"; do
    echo "=========================================="
    echo -e "${BLUE}Testing role: $role${NC}"
    echo "=========================================="
    
    if ansible-playbook main.yml --tags "$role" $MODE_FLAG $SUDO_FLAG -v; then
        echo -e "${GREEN}✓ Role '$role' - PASSED${NC}"
        echo ""
    else
        echo -e "${RED}✗ Role '$role' - FAILED${NC}"
        echo ""
        
        # Ask if we should continue
        read -p "Continue testing other roles? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    sleep 1
done

echo "=========================================="
echo -e "${GREEN}All roles tested!${NC}"
echo "=========================================="
