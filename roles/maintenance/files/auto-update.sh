#!/bin/bash
# =========================================
# Automated System Update Script
# =========================================
# Updates APT packages, pip packages, and npm packages
# Designed to run as a daily cron job

set -e

LOG_FILE="/var/log/auto-update.log"

# Function to log messages with current timestamp
log() {
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
}

log "=========================================="
log "Starting automated system update"
log "=========================================="

# Update APT packages
log "Updating APT package cache..."
apt-get update -qq 2>&1 | tee -a "$LOG_FILE"

log "Upgrading APT packages..."
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -qq 2>&1 | tee -a "$LOG_FILE"

log "Cleaning up APT cache..."
apt-get autoremove -y -qq 2>&1 | tee -a "$LOG_FILE"
apt-get autoclean -y -qq 2>&1 | tee -a "$LOG_FILE"

# Update pip packages (global)
log "Updating global pip packages..."
if command -v pip3 &> /dev/null; then
    pip3 list --outdated --format=freeze 2>/dev/null | grep -v '^\-e' | cut -d = -f 1 | xargs -r -n1 pip3 install -U 2>&1 | tee -a "$LOG_FILE" || log "No pip packages to update"
fi

# Update npm packages (global)
log "Updating global npm packages..."
if command -v npm &> /dev/null; then
    npm update -g 2>&1 | tee -a "$LOG_FILE" || log "No npm packages to update"
fi

# Update Hashicorp tools if available
log "Checking for Hashicorp tools updates..."
if command -v terraform &> /dev/null; then
    DEBIAN_FRONTEND=noninteractive apt-get install --only-upgrade -y terraform packer vault consul boundary nomad 2>&1 | tee -a "$LOG_FILE" || log "No Hashicorp updates available"
fi

# Update Azure CLI if available
log "Checking for Azure CLI updates..."
if command -v az &> /dev/null; then
    DEBIAN_FRONTEND=noninteractive apt-get install --only-upgrade -y azure-cli 2>&1 | tee -a "$LOG_FILE" || log "No Azure CLI updates available"
fi

log "=========================================="
log "Automated system update completed"
log "=========================================="
