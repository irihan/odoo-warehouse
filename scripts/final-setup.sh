#!/bin/bash
# Final Setup Script for Odoo Warehouse
# This script completes the entire setup process

set -e

echo "=== Odoo Warehouse Final Setup ==="
echo "Date: $(date)"
echo ""

# Step 1: Verify all files
echo "Step 1: Verifying files..."
if [ -f "render.yaml" ] && [ -f "Dockerfile" ] && [ -f "SETUP-GUIDE.md" ]; then
    echo "✅ All required files present"
else
    echo "❌ Missing required files"
    exit 1
fi

# Step 2: Check scripts
echo ""
echo "Step 2: Checking scripts..."
SCRIPTS=(
    "scripts/init-odoo.sh"
    "scripts/backup.sh"
    "scripts/restore.sh"
    "scripts/monitor.sh"
    "scripts/setup-odoo.py"
    "scripts/setup-backup.py"
    "scripts/setup-domain.py"
    "scripts/setup-monitoring.py"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        echo "✅ $script"
    else
        echo "❌ Missing: $script"
    fi
done

# Step 3: Make scripts executable
echo ""
echo "Step 3: Making scripts executable..."
chmod +x scripts/*.sh
chmod +x scripts/*.py
echo "✅ Scripts are now executable"

# Step 4: Create README
echo ""
echo "Step 4: Creating README..."
cat > README.md << 'EOF'
# Odoo Warehouse Management System

A complete warehouse management system for charitable organizations with 5 users.

## Features

- **Inventory Management**: Track stock levels, movements, and valuations
- **Purchase Management**: Manage purchase orders and supplier relationships
- **Sales Management**: Handle sales orders and customer relationships
- **Accounting Integration**: Track financial transactions
- **Reporting**: Generate comprehensive reports

## System Requirements

- **Platform**: Render.com (Free Tier)
- **Database**: PostgreSQL (Free Tier)
- **Storage**: 1GB (included)
- **Users**: 5 concurrent users

## Installation

1. Fork or clone this repository
2. Create a Render account at https://render.com
3. Create a new Blueprint from this repository
4. Wait for deployment to complete
5. Access your Odoo instance

## Default Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@example.com | admin |
| Warehouse Manager | warehouse_manager | warehouse123 |
| Purchase Officer | purchase_officer | purchase123 |
| Sales Officer | sales_officer | sales123 |
| Accountant | accountant | account123 |
| Field Representative | field_rep | field123 |

## Configuration

### Users
- Warehouse Manager: Full inventory access
- Purchase Officer: Purchase order management
- Sales Officer: Sales order management
- Accountant: Financial reporting
- Field Representative: Limited access for field operations

### Warehouses
- Main Warehouse (WH-MAIN): Central storage
- Purchase Warehouse (WH-PURCH): Incoming goods
- Sales Warehouse (WH-SALES): Outgoing goods

## Backup

Daily backups are automatically created at 2:00 AM UTC.

To manually backup:
```bash
./scripts/backup.sh
```

To restore from backup:
```bash
./scripts/restore.sh /path/to/backup.sql.gz
```

## Monitoring

Health checks run every 5 minutes. Alerts are sent when:
- CPU usage exceeds 80%
- Memory usage exceeds 80%
- Disk usage exceeds 80%
- Database connections exceed 100

## Support

For issues or questions, please refer to the SETUP-GUIDE.md file.

## License

This project is open source and available for use by charitable organizations.
EOF

echo "✅ README.md created"

# Step 5: Create .env.example
echo ""
echo "Step 5: Creating environment configuration..."
cat > .env.example << 'EOF'
# Database Configuration
DB_HOST=localhost
DB_PORT=5432
DB_NAME=odoo
DB_USER=odoo
DB_PASSWORD=your_password_here

# Odoo Configuration
ODOO_ADMIN_PASSWORD=your_admin_password_here
ODOO_LONGPOLLING_PORT=8072

# Backup Configuration
BACKUP_RETENTION_DAYS=7
BACKUP_LOCATION=/tmp/backups

# Monitoring Configuration
ALERT_EMAIL=admin@example.com
HEALTH_CHECK_INTERVAL=300
EOF

echo "✅ .env.example created"

# Step 6: Summary
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Files created:"
ls -la
echo ""
echo "Scripts available:"
ls -la scripts/
echo ""
echo "Next steps:"
echo "1. Push changes to GitHub"
echo "2. Create Render Blueprint"
echo "3. Wait for deployment"
echo "4. Access Odoo at the provided URL"
echo "5. Login with default credentials"
echo "6. Change admin password"
echo "7. Configure users and warehouses"
echo "8. Start using the system!"
echo ""
echo "For detailed instructions, see SETUP-GUIDE.md"
