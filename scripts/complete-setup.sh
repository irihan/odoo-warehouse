#!/bin/bash
# Complete Setup Script for Odoo Warehouse
# This script runs all setup steps in order

set -e

echo "=========================================="
echo "   Odoo Warehouse Complete Setup"
echo "=========================================="
echo ""
echo "Date: $(date)"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to print section
print_section() {
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  $1${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
}

# Function to print success
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Function to print error
print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Check prerequisites
print_section "Step 1: Checking Prerequisites"

if command -v docker &> /dev/null; then
    print_success "Docker is installed"
else
    print_warning "Docker is not installed"
fi

if command -v git &> /dev/null; then
    print_success "Git is installed"
else
    print_warning "Git is not installed"
fi

if command -v curl &> /dev/null; then
    print_success "cURL is installed"
else
    print_warning "cURL is not installed"
fi

# Step 2: Create directory structure
print_section "Step 2: Creating Directory Structure"

mkdir -p /tmp/odoo-warehouse/{scripts,backups,logs,reports}
print_success "Directory structure created"

# Step 3: Setup DuckDNS Domain
print_section "Step 3: Setting up DuckDNS Domain"

echo "DuckDNS provides a free domain like: yourname.duckdns.org"
echo ""
echo "To setup DuckDNS:"
echo "1. Go to: https://www.duckdns.org"
echo "2. Login with GitHub/Google/Facebook"
echo "3. Create a new domain"
echo "4. Copy the token"
echo ""

read -p "Do you want to setup DuckDNS now? (y/n): " setup_duckdns
if [ "$setup_duckdns" = "y" ]; then
    bash scripts/setup-domain.sh
else
    print_warning "Skipping DuckDNS setup"
fi

# Step 4: Setup Slack Alerts
print_section "Step 4: Setting up Slack Alerts"

echo "Slack provides free alert notifications"
echo ""
echo "To setup Slack:"
echo "1. Create workspace at: https://slack.com/create"
echo "2. Create channel: #odoo-alerts"
echo "3. Create Incoming Webhook"
echo ""

read -p "Do you want to setup Slack now? (y/n): " setup_slack
if [ "$setup_slack" = "y" ]; then
    bash scripts/setup-slack.sh
else
    print_warning "Skipping Slack setup"
fi

# Step 5: Setup Google Drive Backup
print_section "Step 5: Setting up Google Drive Backup"

echo "Google Drive provides free cloud storage for backups"
echo ""
echo "To setup Google Drive:"
echo "1. Enable Google Drive API"
echo "2. Create OAuth credentials"
echo "3. Configure rclone"
echo ""

read -p "Do you want to setup Google Drive now? (y/n): " setup_gdrive
if [ "$setup_gdrive" = "y" ]; then
    bash scripts/setup-gdrive.sh
else
    print_warning "Skipping Google Drive setup"
fi

# Step 6: Setup Monitoring
print_section "Step 6: Setting up Monitoring"

echo "Configuring system monitoring..."
python3 scripts/setup-monitoring.py
print_success "Monitoring configured"

# Step 7: Setup Backup System
print_section "Step 7: Setting up Backup System"

echo "Configuring backup system..."
python3 scripts/setup-backup.py
print_success "Backup system configured"

# Step 8: Create crontab entries
print_section "Step 8: Setting up Scheduled Tasks"

echo "Adding cron jobs for automated tasks..."

# Create crontab file
cat > /tmp/odoo-crontab << EOF
# Odoo Warehouse Crontab
# Daily backup at 2:00 AM
0 2 * * * /tmp/gdrive_backup.sh >> /tmp/odoo-backup.log 2>&1

# Health check every 5 minutes
*/5 * * * * /tmp/odoo_health_check.sh >> /tmp/odoo-health.log 2>&1

# Performance report daily at 6:00 AM
0 6 * * * /tmp/odoo_performance_report.sh >> /tmp/odoo-performance.log 2>&1

# DuckDNS update every 5 minutes (if configured)
*/5 * * * * /tmp/duckdns_autoupdate.sh >> /tmp/duckdns.log 2>&1
EOF

print_success "Crontab entries created"

# Step 9: Summary
print_section "Setup Summary"

echo "✅ Directory structure created"
echo "✅ DuckDNS domain (if configured)"
echo "✅ Slack alerts (if configured)"
echo "✅ Google Drive backup (if configured)"
echo "✅ Monitoring system configured"
echo "✅ Backup system configured"
echo "✅ Scheduled tasks created"
echo ""
echo "=========================================="
echo "   Next Steps"
echo "=========================================="
echo ""
echo "1. Push to GitHub:"
echo "   git add ."
echo "   git commit -m 'Complete setup'"
echo "   git push"
echo ""
echo "2. Deploy to Render:"
echo "   - Go to https://render.com"
echo "   - Create Blueprint from GitHub repo"
echo "   - Wait for deployment"
echo ""
echo "3. Configure extras:"
echo "   - Run: bash scripts/setup-domain.sh"
echo "   - Run: bash scripts/setup-slack.sh"
echo "   - Run: bash scripts/setup-gdrive.sh"
echo ""
echo "4. Access Odoo:"
echo "   - URL: https://your-domain.duckdns.org"
echo "   - Login: admin@example.com"
echo "   - Password: admin"
echo ""
echo "5. Change admin password immediately!"
echo ""
echo "=========================================="
echo "   Setup Complete!"
echo "=========================================="
