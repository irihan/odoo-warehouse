#!/bin/bash
# إعداد Google Drive للنسخ الاحتياطي
# الحساب: islam.rihan@gmail.com

echo "=========================================="
echo "   إعداد Google Drive للنسخ الاحتياطي"
echo "   الحساب: islam.rihan@gmail.com"
echo "=========================================="
echo ""

# الخطوة 1: تثبيت rclone
echo "الخطوة 1: تثبيت rclone..."
if ! command -v rclone &> /dev/null; then
    echo "تثبيت rclone..."
    curl https://rclone.org/install.sh | sudo bash
else
    echo "✅ rclone مثبت بالفعل"
fi

# الخطوة 2: تكوين rclone
echo ""
echo "الخطوة 2: تكوين rclone لـ Google Drive"
echo "شغّل الأوامر التالية بالترتيب:"
echo ""
echo "1. شغّل: rclone config"
echo "2. اضغط 'n' لإنشاء ند جديد"
echo "3. الاسم: gdrive"
echo "4. التخزين: Google Drive"
echo "5. Client ID: (اتركه فارغاً)"
echo "6. Client Secret: (اتركه فارغاً)"
echo "7. النطاق: 1 (وصول كامل)"
echo "8. مجلد الجذر: (اتركه فارغاً)"
echo "9. حساب الخدمة: لا"
echo "10. تكوين متقدم: لا"
echo "11. تكوين تلقائي: نعم (سيفتح المتصفح)"
echo "12. تكوين كمحرك فريق: لا"
echo "13. التأكيد: نعم"
echo ""

# الخطوة 3: إنشاء مجلد النسخ الاحتياطي
echo "الخطوة 3: إنشاء مجلد النسخ الاحتياطي في Google Drive..."
echo "بعد تكوين rclone، شغّل:"
echo "rclone mkdir gdrive:Odoo-Backups"
echo ""

# الخطوة 4: اختبار الاتصال
echo "الخطوة 4: اختبار الاتصال..."
echo "شغّل: rclone lsd gdrive:"
echo "إذا رأيت مجلد Odoo-Backups، فهذا يعني نجاح الاتصال"
echo ""

# الخطوة 5: إنشاء سكريبت النسخ الاحتياطي
cat > /tmp/gdrive_backup.sh << 'EOF'
#!/bin/bash
# سكريبت النسخ الاحتياطي إلى Google Drive
# الحساب: islam.rihan@gmail.com

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
echo "الرفع إلى Google Drive (islam.rihan@gmail.com)..."
rclone copy $BACKUP_FILE $GDRIVE_PATH/

# التحقق من الرفع
if rclone ls $GDRIVE_PATH/$(basename $BACKUP_FILE) | grep -q "$(basename $BACKUP_FILE)"; then
    echo "✅ تم الرفع بنجاح إلى Google Drive!"
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

echo "✅ تم النسخ الاحتياطي بنجاح!"
echo "الملفات في Google Drive:"
rclone ls $GDRIVE_PATH/
EOF

chmod +x /tmp/gdrive_backup.sh

# الخطوة 6: إنشاء سكريبت الاستعادة
cat > /tmp/gdrive_restore.sh << 'EOF'
#!/bin/bash
# سكريبت الاستعادة من Google Drive
# الحساب: islam.rihan@gmail.com

set -e

# التكوين
BACKUP_DIR="/tmp/backups"
GDRIVE_PATH="gdrive:Odoo-Backups"

# عرض النسخ الاحتياطية المتاحة
echo "النسخ الاحتياطية المتاحة في Google Drive (islam.rihan@gmail.com):"
rclone ls $GDRIVE_PATH/ --include "odoo_backup_*.sql.gz" | sort -r

# الحصول على ملف النسخة الاحتياطية من المستخدم
read -p "أدخل اسم ملف النسخة الاحتياطية: " BACKUP_FILE

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

echo "✅ تمت الاستعادة بنجاح!"
echo "يرجى إعادة تشغيل خدمة Odoo لتطبيق التغييرات."
EOF

chmod +x /tmp/gdrive_restore.sh

echo ""
echo "=========================================="
echo "   تم إعداد Google Drive بنجاح!"
echo "=========================================="
echo ""
echo "ملفات الإعداد:"
echo "1. /tmp/gdrive_backup.sh - سكريبت النسخ الاحتياطي"
echo "2. /tmp/gdrive_restore.sh - سكريبت الاستعادة"
echo ""
echo "الخطوات التالية:"
echo "1. تكوين rclone: rclone config"
echo "2. إنشاء مجلد: rclone mkdir gdrive:Odoo-Backups"
echo "3. اختبار النسخ الاحتياطي: /tmp/gdrive_backup.sh"
echo "4. اختبار الاستعادة: /tmp/gdrive_restore.sh"
echo ""
echo "جدولة النسخ الاحتياطي اليومي:"
echo "أضف هذا السطر إلى crontab:"
echo "0 2 * * * /tmp/gdrive_backup.sh >> /tmp/backup.log 2>&1"
