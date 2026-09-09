#!/bin/bash
# Backup script for Odoo on Render
# This script creates daily backups of the database

echo "=== Starting Odoo Backup ==="
echo "Date: $(date)"

# Database backup
echo "Creating database backup..."
pg_dump -h $HOST -U $USER -d $DB_NAME > /tmp/odoo_backup_$(date +%Y%m%d).sql

# Compress backup
echo "Compressing backup..."
gzip /tmp/odoo_backup_$(date +%Y%m%d).sql

# Upload to cloud storage (configure your storage here)
echo "Uploading backup..."
# aws s3 cp /tmp/odoo_backup_$(date +%Y%m%d).sql.gz s3://your-bucket/backups/

# Cleanup old backups (keep last 7 days)
echo "Cleaning old backups..."
find /tmp -name "odoo_backup_*.sql.gz" -mtime +7 -delete

echo "=== Backup Complete ==="
echo "Date: $(date)"
