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

# Check required files FIRST (before syntax check)
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

# Check playbook syntax (now that required files exist)
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

# Check roles structure
echo "✓ Checking roles structure..."
required_roles=("common" "ssl-config" "python" "containers" "terraform" "dotnet" "nodejs" "azure-cli" "github-cli" "maintenance")
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
    if ! ansible-lint main.yml roles/ --config-file .ansible-lint; then
        echo -e "${RED}✗ ansible-lint found errors${NC}"
        exit 1
    fi
    echo ""
fi

# Check CA certificate (if configured)
echo "✓ Checking CA certificate configuration..."
# Extract ssl_ca_cert_name from group_vars/all.yml
if grep -q "ssl_ca_cert_name:" group_vars/all.yml; then
    CERT_NAME=$(grep "^ssl_ca_cert_name:" group_vars/all.yml | sed 's/ssl_ca_cert_name: //;s/"//g;s/'"'"'//g' | xargs)
    if [[ -z "$CERT_NAME" ]] || [[ "$CERT_NAME" == "null" ]] || [[ "$CERT_NAME" == "" ]]; then
        echo -e "  ${YELLOW}⚠${NC} No CA certificate configured (ssl_ca_cert_name is empty)"
        echo "     ssl-config role will be skipped"
    elif [[ -f "$CERT_NAME" ]]; then
        echo -e "  ${GREEN}✓${NC} CA certificate found ($CERT_NAME)"
    else
        echo -e "  ${RED}✗${NC} CA certificate not found ($CERT_NAME)"
        exit 1
    fi
else
    echo -e "  ${YELLOW}⚠${NC} ssl_ca_cert_name not configured - ssl-config role will be skipped"
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
