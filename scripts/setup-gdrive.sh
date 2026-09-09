#!/bin/bash
# إعداد النسخ الاحتياطي إلى Google Drive
# النسخ الاحتياطي التلقائي إلى Google Drive

echo "=== إعداد النسخ الاحتياطي إلى Google Drive ==="
echo ""

# الخطوة 1: تفعيل Google Drive API
echo "الخطوة 1: تفعيل Google Drive API"
echo "1. اذهب إلى: https://console.cloud.google.com"
echo "2. أنشئ مشروع جديد: 'نسخ احتياطي Odoo'"
echo "3. اذهب إلى 'APIs & Services' → 'Library'"
echo "4. ابحث عن 'Google Drive API'"
echo "5. اضغط 'Enable'"
echo ""

# الخطوة 2: إنشاء بيانات الاعتماد
echo "الخطوة 2: إنشاء بيانات اعتماد"
echo "1. اذهب إلى 'APIs & Services' → 'Credentials'"
echo "2. اضغط 'Create Credentials' → 'OAuth client ID'"
echo "3. نوع التطبيق: 'Desktop app'"
echo "4. الاسم: 'نسخ احتياطي Odoo'"
echo "5. اضغط 'Create'"
echo "6. حمل ملف JSON"
echo "7. أعد تسميته إلى 'credentials.json'"
echo ""

# الخطوة 3: تثبيت rclone
echo "الخطوة 3: تثبيت rclone..."
if ! command -v rclone &> /dev/null; then
    curl https://rclone.org/install.sh | sudo bash
else
    echo "rclone مثبت بالفعل"
fi

# الخطوة 4: تكوين rclone
echo ""
echo "الخطوة 4: تكوين rclone لـ Google Drive"
echo "شغّل: rclone config"
echo ""
echo "اتبع هذه الخطوات:"
echo "1. اضغط 'n' لإنشاء ند جديد"
echo "2. الاسم: gdrive"
echo "3. التخزين: Google Drive"
echo "4. Client ID: (اتركه فارغاً)"
echo "5. Client Secret: (اتركه فارغاً)"
echo "6. النطاق: 1 (وصول كامل)"
echo "7. مجلد الجذر: (اتركه فارغاً)"
echo "8. حساب الخدمة: لا"
echo "9. تكوين متقدم: لا"
echo "10. تكوين تلقائي: نعم (سيفتح المتصفح)"
echo "11. تكوين كمحرك فريق: لا"
echo "12. التأكيد: نعم"
echo ""

# الخطوة 5: إنشاء سكريبت النسخ الاحتياطي
cat > /tmp/gdrive_backup.sh << 'EOF'
#!/bin/bash
# سكريبت النسخ الاحتياطي إلى Google Drive
# يت备份 قاعدة بيانات Odoo إلى Google Drive

set -e

# التكوين
BACKUP_DIR="/tmp/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/odoo_backup_$DATE.sql.gz"
GDRIVE_PATH="gdrive:Odoo-Backups"

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
rclone copy $BACKUP_FILE $GDRIVE_PATH/

# التحقق من الرفع
if rclone ls $GDRIVE_PATH/$(basename $BACKUP_FILE) | grep -q "$(basename $BACKUP_FILE)"; then
    echo "✅ تم الرفع بنجاح!"
else
    echo "❌ فشل الرفع!"
    exit 1
fi

# حذف النسخ المحلية القديمة
echo "حذف النسخ المحلية القديمة..."
find $BACKUP_DIR -name "odoo_backup_*.sql.gz" -mtime +7 -delete

# حذف النسخ القديمة من Google Drive (الاحتفاظ بآخر 30 يوماً)
echo "حذف النسخ القديمة من Google Drive..."
rclone delete $GDRIVE_PATH --min-age 30d --include "odoo_backup_*.sql.gz"

echo "تم النسخ الاحتياطي بنجاح!"
echo "الملفات في Google Drive:"
rclone ls $GDRIVE_PATH/
EOF

chmod +x /tmp/gdrive_backup.sh

# الخطوة 6: إنشاء سكريبت الاستعادة
cat > /tmp/gdrive_restore.sh << 'EOF'
#!/bin/bash
# سكريبت الاستعادة من Google Drive
# يستعيد قاعدة بيانات Odoo من النسخة الاحتياطية في Google Drive

set -e

# التكوين
BACKUP_DIR="/tmp/backups"
GDRIVE_PATH="gdrive:Odoo-Backups"

# عرض النسخ الاحتياطية المتاحة
echo "النسخ الاحتياطية المتاحة في Google Drive:"
rclone ls $GDRIVE_PATH/ --include "odoo_backup_*.sql.gz" | sort -r

# الحصول على ملف النسخة الاحتياطية من المستخدم
read -p "أدخل اسم ملف النسخة الاحتياطية (مثال: odoo_backup_20260909_020000.sql.gz): " BACKUP_FILE

# التنزيل من Google Drive
echo "تنزيل النسخة الاحتياطية من Google Drive..."
rclone copy $GDRIVE_PATH/$BACKUP_FILE $BACKUP_DIR/

# التحقق من نجاح التنزيل
if [ ! -f "$BACKUP_DIR/$BACKUP_FILE" ]; then
    echo "خطأ: فشل التنزيل!"
    exit 1
fi

# فك الضغط إذا لزم الأمر
if [[ $BACKUP_FILE == *.gz ]]; then
    echo "فك ضغط النسخة الاحتياطية..."
    gunzip -c $BACKUP_DIR/$BACKUP_FILE > $BACKUP_DIR/odoo_restore.sql
    RESTORE_FILE="$BACKUP_DIR/odoo_restore.sql"
else
    RESTORE_FILE="$BACKUP_DIR/$BACKUP_FILE"
fi

# استعادة قاعدة البيانات
echo "استعادة قاعدة البيانات..."
psql -h $HOST -U $USER -d $DB_NAME < $RESTORE_FILE

# التنظيف
echo "التنظيف..."
rm -f $BACKUP_DIR/odoo_restore.sql

echo "تمت الاستعادة بنجاح!"
echo "يرجى إعادة تشغيل خدمة Odoo لتطبيق التغييرات."
EOF

chmod +x /tmp/gdrive_restore.sh

echo ""
echo "=== تم إعداد النسخ الاحتياطي إلى Google Drive ==="
echo ""
echo "الملفات التي تم إنشاؤها:"
echo "1. /tmp/gdrive_backup.sh - سكريبت النسخ الاحتياطي"
echo "2. /tmp/gdrive_restore.sh - سكريبت الاستعادة"
echo ""
echo "الخطوات التالية:"
echo "1. تكوين rclone: rclone config"
echo "2. إنشاء مجلد في Google Drive: 'Odoo-Backups'"
echo "3. اختبار النسخ الاحتياطي: /tmp/gdrive_backup.sh"
echo "4. اختبار الاستعادة: /tmp/gdrive_restore.sh"
echo ""
echo "جدولة النسخ الاحتياطي اليومي (أضف إلى crontab):"
echo "0 2 * * * /tmp/gdrive_backup.sh >> /tmp/backup.log 2>&1"
