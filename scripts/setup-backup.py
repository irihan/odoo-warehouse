#!/usr/bin/env python3
"""
سكريبت إعداد النسخ الاحتياطي
يُكوّن النسخ الاحتياطي التلقائي اليومي
"""

import os
import json
from datetime import datetime

def create_backup_config():
    """إنشاء ملف تكوين النسخ الاحتياطي"""
    config = {
        "backup_enabled": True,
        "backup_schedule": "0 2 * * *",  # يومياً الساعة 2:00 صباحاً
        "backup_retention_days": 7,
        "backup_location": "/tmp/backups",
        "backup_database": True,
        "backup_filestore": True,
        "backup_compress": True,
        "backup_upload_cloud": True,
        "cloud_provider": "Google Drive",
        "cloud_account": "islam.rihan@gmail.com",
        "cloud_bucket": "Odoo-Backups"
    }
    
    with open('/tmp/odoo_backup_config.json', 'w') as f:
        json.dump(config, f, indent=4)
    
    print("✅ تم إنشاء تكوين النسخ الاحتياطي")
    return config

def create_backup_script():
    """إنشاء سكريبت النسخ الاحتياطي التلقائي"""
    script = '''#!/bin/bash
# سكريبت النسخ الاحتياطي التلقائي
# يعمل يومياً الساعة 2:00 صباحاً UTC

set -e

# التكوين
BACKUP_DIR="/tmp/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/odoo_backup_$DATE.sql.gz"
RETENTION_DAYS=7

# إنشاء مجلد النسخ الاحتياطي
mkdir -p $BACKUP_DIR

# إنشاء نسخة احتياطية من قاعدة البيانات
echo "إنشاء نسخة احتياطية من قاعدة البيانات..."
pg_dump -h $HOST -U $USER -d $DB_NAME | gzip > $BACKUP_FILE

# التحقق من حجم النسخة الاحتياطية
BACKUP_SIZE=$(du -h $BACKUP_FILE | cut -f1)
echo "تم إنشاء النسخة الاحتياطية: $BACKUP_FILE (الحجم: $BACKUP_SIZE)"

# الرفع إلى Google Drive
echo "الرفع إلى Google Drive..."
rclone copy $BACKUP_FILE gdrive:Odoo-Backups/

# حذف النسخ القديمة
echo "حذف النسخ القديمة..."
find $BACKUP_DIR -name "odoo_backup_*.sql.gz" -mtime +$RETENTION_DAYS -delete

# عرض النسخ الحالية
echo "النسخ الحالية:"
ls -lh $BACKUP_DIR/odoo_backup_*.sql.gz

echo "تم النسخ الاحتياطي بنجاح!"
'''
    
    with open('/tmp/odoo_backup.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_backup.sh', 0o755)
    print("✅ تم إنشاء سكريبت النسخ الاحتياطي")

def create_restore_script():
    """إنشاء سكريبت الاستعادة"""
    script = '''#!/bin/bash
# سكريبت استعادة Odoo
# الاستخدام: ./restore.sh /path/to/backup.sql.gz

set -e

if [ -z "$1" ]; then
    echo "الاستخدام: $0 /path/to/backup.sql.gz"
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f $BACKUP_FILE ]; then
    echo "خطأ: ملف النسخة الاحتياطي غير موجود!"
    exit 1
fi

echo "الاستعادة من: $BACKUP_FILE"

# فك الضغط إذا لزم الأمر
if [[ $BACKUP_FILE == *.gz ]]; then
    echo "فك ضغط النسخة الاحتياطية..."
    gunzip -c $BACKUP_FILE > /tmp/odoo_restore.sql
    RESTORE_FILE="/tmp/odoo_restore.sql"
else
    RESTORE_FILE=$BACKUP_FILE
fi

# استعادة قاعدة البيانات
echo "استعادة قاعدة البيانات..."
psql -h $HOST -U $USER -d $DB_NAME < $RESTORE_FILE

# التنظيف
if [ -f "/tmp/odoo_restore.sql" ]; then
    rm /tmp/odoo_restore.sql
fi

echo "تمت الاستعادة بنجاح!"
echo "يرجى إعادة تشغيل خدمة Odoo لتطبيق التغييرات."
'''
    
    with open('/tmp/odoo_restore.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_restore.sh', 0o755)
    print("✅ تم إنشاء سكريبت الاستعادة")

def main():
    """الدالة الرئيسية للإعداد"""
    print("=== إعداد نظام النسخ الاحتياطي ===")
    
    create_backup_config()
    create_backup_script()
    create_restore_script()
    
    print("\n=== تم إعداد النسخ الاحتياطي ===")
    print("الخطوات التالية:")
    print("1. تحديد موقع النسخ الاحتياطي")
    print("2. إعداد التخزين السحابي (اختياري)")
    print("3. اختبار النسخ الاحتياطي والاستعادة")

if __name__ == "__main__":
    main()
