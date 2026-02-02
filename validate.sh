#!/bin/bash
# =========================================
# Validation Script for Ansible Playbook
# =========================================

set -e

echo "======================================"
echo "WSL Bootstrap Validation"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Ansible is installed
echo -n "✓ Checking Ansible installation... "
if command -v ansible-playbook &> /dev/null; then
    echo -e "${GREEN}OK${NC}"
    ansible-playbook --version | head -1
else
    echo -e "${RED}FAILED${NC}"
    echo "  Please install Ansible: sudo apt-get install -y ansible"
    exit 1
fi
echo ""

# Check if ansible-lint is installed
echo -n "✓ Checking ansible-lint installation... "
if command -v ansible-lint &> /dev/null; then
    echo -e "${GREEN}OK${NC}"
    ansible-lint --version | head -1
else
    echo -e "${YELLOW}WARNING${NC}"
    echo "  Optional: Install ansible-lint: sudo apt-get install -y ansible-lint"
fi
echo ""

# Check playbook syntax
echo "✓ Validating playbook syntax..."
ansible-playbook main.yml -i hosts --syntax-check
echo ""

# Check inventory
echo "✓ Validating inventory..."
if [[ -f "hosts" ]]; then
    echo -e "${GREEN}  ✓ Inventory file found${NC}"
else
    echo -e "${RED}  ✗ Inventory file not found${NC}"
    exit 1
fi
echo ""

# Check required files
echo "✓ Checking required files..."
required_files=("main.yml" "ansible.cfg" "group_vars/all.yml" "hosts")
for file in "${required_files[@]}"; do
    if [[ -f "$file" ]]; then
        echo -e "  ${GREEN}✓${NC} $file"
    else
        echo -e "  ${RED}✗${NC} $file"
        exit 1
    fi
done
echo ""

# Check roles structure
echo "✓ Checking roles structure..."
required_roles=("common" "ssl-config" "python" "containers" "terraform" "dotnet" "nodejs" "azure-cli" "github-cli")
for role in "${required_roles[@]}"; do
    if [[ -d "roles/$role/tasks" ]]; then
        echo -e "  ${GREEN}✓${NC} roles/$role/tasks"
    else
        echo -e "  ${RED}✗${NC} roles/$role/tasks"
        exit 1
    fi
done
echo ""

# Run ansible-lint if available
if command -v ansible-lint &> /dev/null; then
    echo "✓ Running ansible-lint..."
    ansible-lint main.yml roles/ --config-file .ansible-lint || true
    echo ""
fi

# Check ca certificate
echo "✓ Checking CA certificate..."
if [[ -f "ia-root-ca.crt" ]]; then
    echo -e "  ${GREEN}✓${NC} CA certificate found (ia-root-ca.crt)"
else
    echo -e "  ${YELLOW}⚠${NC} CA certificate not found - ssl-config role will be skipped or fail"
    echo "     Place your certificate as 'ia-root-ca.crt' in the project root"
fi
echo ""

echo "======================================"
echo -e "${GREEN}✓ All validations passed!${NC}"
echo "======================================"
echo ""
echo "Next steps:"
echo "1. Run playbook: ansible-playbook main.yml"
echo "2. Run with check: ansible-playbook main.yml --check"
echo "3. Run specific role: ansible-playbook main.yml --tags nodejs"
echo "4. Run with verbose: ansible-playbook main.yml -vvv"
echo ""
