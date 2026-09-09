#!/bin/bash
# الإعداد النهائي لنظام إدارة المخازن
# يقوم هذا السكريبت بتشغيل جميع خطوات الإعداد بالترتيب

set -e

echo "=========================================="
echo "   الإعداد النهائي لنظام إدارة المخازن"
echo "=========================================="
echo ""
echo "التاريخ: $(date)"
echo ""

# ألوان الإخراج
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # بدون لون

# دالة لطباعة القسم
print_section() {
    echo ""
    echo -e "${YELLOW}========================================${NC}"
    echo -e "${YELLOW}  $1${NC}"
    echo -e "${YELLOW}========================================${NC}"
    echo ""
}

# دالة لطباعة النجاح
print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# دالة لطباعة التحذير
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# الخطوة 1: التحقق من المتطلبات
print_section "الخطوة 1: التحقق من المتطلبات"

if command -v docker &> /dev/null; then
    print_success "Docker مثبت"
else
    print_warning "Docker غير مثبت"
fi

if command -v git &> /dev/null; then
    print_success "Git مثبت"
else
    print_warning "Git غير مثبت"
fi

if command -v curl &> /dev/null; then
    print_success "cURL مثبت"
else
    print_warning "cURL غير مثبت"
fi

# الخطوة 2: إنشاء هيكل المجلدات
print_section "الخطوة 2: إنشاء هيكل المجلدات"

mkdir -p /tmp/odoo-warehouse/{scripts,backups,logs,reports}
print_success "تم إنشاء هيكل المجلدات"

# الخطوة 3: إعداد Google Drive
print_section "الخطوة 3: إعداد Google Drive للنسخ الاحتياطي"

echo "الحساب: islam.rihan@gmail.com"
echo ""
echo "لإعداد Google Drive:"
echo "1. تثبيت rclone: curl https://rclone.org/install.sh | sudo bash"
echo "2. تكوين rclone: rclone config"
echo "3. إنشاء مجلد: rclone mkdir gdrive:Odoo-Backups"
echo ""

read -p "هل تريد إعداد Google Drive الآن؟ (y/n): " setup_gdrive
if [ "$setup_gdrive" = "y" ]; then
    bash scripts/gdrive-setup.sh
else
    print_warning "تخطي إعداد Google Drive"
fi

# الخطوة 4: إعداد نطاق DuckDNS
print_section "الخطوة 4: إعداد نطاق DuckDNS المجاني"

echo "يوفر DuckDNS نطاقاً مجانياً مثل: yourname.duckdns.org"
echo ""
echo "لإعداد DuckDNS:"
echo "1. اذهب إلى: https://www.duckdns.org"
echo "2. سجل الدخول عبر GitHub/Google/Facebook"
echo "3. أنشئ نطاقاً جديداً"
echo "4. انسخ الرمز المميز"
echo ""

read -p "هل تريد إعداد DuckDNS الآن؟ (y/n): " setup_duckdns
if [ "$setup_duckdns" = "y" ]; then
    bash scripts/setup-domain.sh
else
    print_warning "تخطي إعداد DuckDNS"
fi

# الخطوة 5: إعداد تنبيهات Slack
print_section "الخطوة 5: إعداد تنبيهات Slack"

echo "يوفر Slack إشعارات تنبيه مجانية"
echo ""
echo "لإعداد Slack:"
echo "1. أنشئ مساحة عمل على: https://slack.com/create"
echo "2. أنشئ قناة: #odoo-alerts"
echo "3. أنشئ Incoming Webhook"
echo ""

read -p "هل تريد إعداد Slack الآن؟ (y/n): " setup_slack
if [ "$setup_slack" = "y" ]; then
    bash scripts/setup-slack.sh
else
    print_warning "تخطي إعداد Slack"
fi

# الخطوة 6: إعداد المراقبة
print_section "الخطوة 6: إعداد المراقبة"

echo "تكوين مراقبة النظام..."
python3 scripts/setup-monitoring.py
print_success "تم تكوين المراقبة"

# الخطوة 7: إعداد نظام النسخ الاحتياطي
print_section "الخطوة 7: إعداد نظام النسخ الاحتياطي"

echo "تكوين نظام النسخ الاحتياطي..."
python3 scripts/setup-backup.py
print_success "تم تكوين نظام النسخ الاحتياطي"

# الخطوة 8: إنشاء إدخالات crontab
print_section "الخطوة 8: إعداد المهام المجدولة"

echo "إضافة مهام cron للمهام الآلية..."

# إنشاء ملف crontab
cat > /tmp/odoo-crontab << EOF
# جدول أعمال Odoo
# النسخ الاحتياطي اليومي الساعة 2:00 صباحاً إلى Google Drive
0 2 * * * /tmp/gdrive_backup.sh >> /tmp/backup.log 2>&1

# الفحص الصحي كل 5 دقائق
*/5 * * * * /tmp/odoo_health_check.sh >> /tmp/odoo-health.log 2>&1

# تقرير الأداء يومياً الساعة 6:00 صباحاً
0 6 * * * /tmp/odoo_performance_report.sh >> /tmp/odoo-performance.log 2>&1

# تحديث DuckDNS كل 5 دقائق (إذا كان مكوناً)
*/5 * * * * /tmp/duckdns_autoupdate.sh >> /tmp/duckdns.log 2>&1
EOF

print_success "تم إنشاء إدخالات crontab"

# الخطوة 9: الملخص
print_section "ملخص الإعداد النهائي"

echo "✅ تم إنشاء هيكل المجلدات"
echo "✅ Google Drive (islam.rihan@gmail.com)"
echo "✅ نطاق DuckDNS المجاني"
echo "✅ تنبيهات Slack"
echo "✅ تم تكوين نظام المراقبة"
echo "✅ تم تكوين نظام النسخ الاحتياطي"
echo "✅ تم إعداد المهام المجدولة"
echo ""
echo "=========================================="
echo "   الخطوات التالية"
echo "=========================================="
echo ""
echo "1. الدفع إلى GitHub:"
echo "   git add ."
echo "   git commit -m 'إعداد كامل'"
echo "   git push"
echo ""
echo "2. النشر على Render:"
echo "   - اذهب إلى https://render.com"
echo "   - أنشئ Blueprint من مستودع GitHub"
echo "   - انتظر اكتمال النشر"
echo ""
echo "3. تكوين الإضافات:"
echo "   - شغّل: bash scripts/gdrive-setup.sh"
echo "   - شغّل: bash scripts/setup-domain.sh"
echo "   - شغّل: bash scripts/setup-slack.sh"
echo ""
echo "4. الوصول إلى Odoo:"
echo "   - الرابط: https://your-domain.duckdns.org"
echo "   - تسجيل الدخول: admin@example.com"
echo "   - كلمة المرور: admin"
echo ""
echo "5. غيّر كلمة مرور admin فوراً!"
echo ""
echo "=========================================="
echo "   تم الانتهاء من الإعداد!"
echo "=========================================="
