#!/usr/bin/env python3
"""
Odoo Backup Setup Script
Configures automatic daily backups
"""

import os
import json
from datetime import datetime

def create_backup_config():
    """Create backup configuration file"""
    config = {
        "backup_enabled": True,
        "backup_schedule": "0 2 * * *",  # Daily at 2:00 AM
        "backup_retention_days": 7,
        "backup_location": "/tmp/backups",
        "backup_database": True,
        "backup_filestore": True,
        "backup_compress": True,
        "backup_upload_cloud": False,
        "cloud_provider": None,
        "cloud_bucket": None
    }
    
    with open('/tmp/odoo_backup_config.json', 'w') as f:
        json.dump(config, f, indent=4)
    
    print("✅ Backup configuration created")
    return config

def create_backup_script():
    """Create automated backup script"""
    script = '''#!/bin/bash
# Automated Odoo Backup Script
# Runs daily at 2:00 AM UTC

set -e

# Configuration
BACKUP_DIR="/tmp/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/odoo_backup_$DATE.sql.gz"
RETENTION_DAYS=7

# Create backup directory
mkdir -p $BACKUP_DIR

# Create database backup
echo "Creating database backup..."
pg_dump -h $HOST -U $USER -d $DB_NAME | gzip > $BACKUP_FILE

# Check backup size
BACKUP_SIZE=$(du -h $BACKUP_FILE | cut -f1)
echo "Backup created: $BACKUP_FILE (Size: $BACKUP_SIZE)"

# Remove old backups
echo "Cleaning old backups..."
find $BACKUP_DIR -name "odoo_backup_*.sql.gz" -mtime +$RETENTION_DAYS -delete

# List current backups
echo "Current backups:"
ls -lh $BACKUP_DIR/odoo_backup_*.sql.gz

echo "Backup completed successfully!"
'''
    
    with open('/tmp/odoo_backup.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_backup.sh', 0o755)
    print("✅ Backup script created")

def create_restore_script():
    """Create restore script"""
    script = '''#!/bin/bash
# Odoo Restore Script
# Usage: ./restore.sh /path/to/backup.sql.gz

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/backup.sql.gz"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f $BACKUP_FILE ]; then
    echo "Error: Backup file not found!"
    exit 1
fi

echo "Restoring from: $BACKUP_FILE"

# Decompress if needed
if [[ $BACKUP_FILE == *.gz ]]; then
    echo "Decompressing backup..."
    gunzip -c $BACKUP_FILE > /tmp/odoo_restore.sql
    RESTORE_FILE="/tmp/odoo_restore.sql"
else
    RESTORE_FILE=$BACKUP_FILE
fi

# Restore database
echo "Restoring database..."
psql -h $HOST -U $USER -d $DB_NAME < $RESTORE_FILE

# Cleanup
if [ -f "/tmp/odoo_restore.sql" ]; then
    rm /tmp/odoo_restore.sql
fi

echo "Restore completed successfully!"
echo "Please restart Odoo service for changes to take effect."
'''
    
    with open('/tmp/odoo_restore.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_restore.sh', 0o755)
    print("✅ Restore script created")

def main():
    """Main setup function"""
    print("=== Setting up Backup System ===")
    
    create_backup_config()
    create_backup_script()
    create_restore_script()
    
    print("\n=== Backup Setup Complete ===")
    print("Next steps:")
    print("1. Configure backup location")
    print("2. Set up cloud storage (optional)")
    print "3. Test backup and restore")

if __name__ == "__main__":
    main()
