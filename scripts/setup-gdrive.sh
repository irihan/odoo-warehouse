#!/bin/bash
# Google Drive Backup Setup
# Automatically backup Odoo to Google Drive

echo "=== Google Drive Backup Setup ==="
echo ""

# Step 1: Enable Google Drive API
echo "Step 1: Enable Google Drive API"
echo "1. Go to: https://console.cloud.google.com"
echo "2. Create a new project: 'Odoo Backup'"
echo "3. Go to 'APIs & Services' → 'Library'"
echo "4. Search for 'Google Drive API'"
echo "5. Click 'Enable'"
echo ""

# Step 2: Create Credentials
echo "Step 2: Create Credentials"
echo "1. Go to 'APIs & Services' → 'Credentials'"
echo "2. Click 'Create Credentials' → 'OAuth client ID'"
echo "3. Application type: 'Desktop app'"
echo "4. Name: 'Odoo Backup'"
echo "5. Click 'Create'"
echo "6. Download the JSON file"
echo "7. Rename it to 'credentials.json'"
echo ""

# Step 3: Install rclone
echo "Step 3: Installing rclone..."
if ! command -v rclone &> /dev/null; then
    curl https://rclone.org/install.sh | sudo bash
else
    echo "rclone is already installed"
fi

# Step 4: Configure rclone
echo ""
echo "Step 4: Configure rclone for Google Drive"
echo "Run: rclone config"
echo ""
echo "Follow these steps:"
echo "1. Press 'n' for new remote"
echo "2. Name: gdrive"
echo "3. Storage: Google Drive"
echo "4. Client ID: (leave blank)"
echo "5. Client Secret: (leave blank)"
echo "6. Scope: 1 (full access)"
echo "7. Root folder ID: (leave blank)"
echo "8. Service account: No"
echo "9. Edit advanced config: No"
echo "10. Auto config: Yes (browser will open)"
echo "11. Configure as team drive: No"
echo "12. Confirm: Yes"
echo ""

# Step 5: Create backup script
cat > /tmp/gdrive_backup.sh << 'EOF'
#!/bin/bash
# Google Drive Backup Script
# Backs up Odoo database to Google Drive

set -e

# Configuration
BACKUP_DIR="/tmp/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/odoo_backup_$DATE.sql.gz"
GDRIVE_PATH="gdrive:Odoo-Backups"

# Create backup directory
mkdir -p $BACKUP_DIR

# Create database backup
echo "Creating database backup..."
pg_dump -h $HOST -U $USER -d $DB_NAME | gzip > $BACKUP_FILE

# Check backup size
BACKUP_SIZE=$(du -h $BACKUP_FILE | cut -f1)
echo "Backup created: $BACKUP_FILE (Size: $BACKUP_SIZE)"

# Upload to Google Drive
echo "Uploading to Google Drive..."
rclone copy $BACKUP_FILE $GDRIVE_PATH/

# Verify upload
if rclone ls $GDRIVE_PATH/$(basename $BACKUP_FILE) | grep -q "$(basename $BACKUP_FILE)"; then
    echo "✅ Upload successful!"
else
    echo "❌ Upload failed!"
    exit 1
fi

# Remove old local backups
echo "Cleaning old local backups..."
find $BACKUP_DIR -name "odoo_backup_*.sql.gz" -mtime +7 -delete

# Remove old Google Drive backups (keep last 30 days)
echo "Cleaning old Google Drive backups..."
rclone delete $GDRIVE_PATH --min-age 30d --include "odoo_backup_*.sql.gz"

echo "Backup completed successfully!"
echo "Files in Google Drive:"
rclone ls $GDRIVE_PATH/
EOF

chmod +x /tmp/gdrive_backup.sh

# Step 6: Create restore script
cat > /tmp/gdrive_restore.sh << 'EOF'
#!/bin/bash
# Google Drive Restore Script
# Restores Odoo database from Google Drive backup

set -e

# Configuration
BACKUP_DIR="/tmp/backups"
GDRIVE_PATH="gdrive:Odoo-Backups"

# List available backups
echo "Available backups in Google Drive:"
rclone ls $GDRIVE_PATH/ --include "odoo_backup_*.sql.gz" | sort -r

# Get backup file from user
read -p "Enter backup filename (e.g., odoo_backup_20260909_020000.sql.gz): " BACKUP_FILE

# Download from Google Drive
echo "Downloading backup from Google Drive..."
rclone copy $GDRIVE_PATH/$BACKUP_FILE $BACKUP_DIR/

# Check if download successful
if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    echo "Error: Download failed!"
    exit 1
fi

# Decompress if needed
if [[ $BACKUP_FILE == *.gz ]]; then
    echo "Decompressing backup..."
    gunzip -c $BACKUP_DIR/$BACKUP_FILE > $BACKUP_DIR/odoo_restore.sql
    RESTORE_FILE="$BACKUP_DIR/odoo_restore.sql"
else
    RESTORE_FILE="$BACKUP_DIR/$BACKUP_FILE"
fi

# Restore database
echo "Restoring database..."
psql -h $HOST -U $USER -d $DB_NAME < $RESTORE_FILE

# Cleanup
echo "Cleaning up..."
rm -f $BACKUP_DIR/odoo_restore.sql

echo "Restore completed successfully!"
echo "Please restart Odoo service for changes to take effect."
EOF

chmod +x /tmp/gdrive_restore.sh

echo ""
echo "=== Google Drive Backup Setup Complete ==="
echo ""
echo "Files created:"
echo "1. /tmp/gdrive_backup.sh - Backup script"
echo "2. /tmp/gdrive_restore.sh - Restore script"
echo ""
echo "Next steps:"
echo "1. Configure rclone: rclone config"
echo "2. Create folder in Google Drive: 'Odoo-Backups'"
echo "3. Test backup: /tmp/gdrive_backup.sh"
echo "4. Test restore: /tmp/gdrive_restore.sh"
echo ""
echo "Schedule daily backup (add to crontab):"
echo "0 2 * * * /tmp/gdrive_backup.sh >> /tmp/backup.log 2>&1"
