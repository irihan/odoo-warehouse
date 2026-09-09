#!/bin/bash
# Restore script for Odoo on Render
# This script restores a database backup

echo "=== Starting Odoo Restore ==="
echo "Date: $(date)"

# Check if backup file exists
if [ ! -f "$1" ]; then
    echo "Error: Backup file not found!"
    echo "Usage: ./restore.sh /path/to/backup.sql.gz"
    exit 1
fi

# Decompress backup
echo "Decompressing backup..."
gunzip -c $1 > /tmp/odoo_restore.sql

# Restore database
echo "Restoring database..."
psql -h $HOST -U $USER -d $DB_NAME < /tmp/odoo_restore.sql

# Cleanup
echo "Cleaning up..."
rm /tmp/odoo_restore.sql

echo "=== Restore Complete ==="
echo "Date: $(date)"
echo "Please restart Odoo service for changes to take effect."
