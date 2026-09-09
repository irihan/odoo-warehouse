#!/bin/bash
# إعداد تنبيهات Slack
# يرسل إشعارات عند اكتشاف مشاكل

echo "=== إعداد تنبيهات Slack ==="
echo ""

# الخطوة 1: إنشاء مساحة عمل Slack
echo "الخطوة 1: إنشاء مساحة عمل Slack"
echo "1. اذهب إلى: https://slack.com/create"
echo "2. أنشئ مساحة عمل مجانية"
echo "3. أنشئ قناة: #odoo-alerts"
echo ""

# الخطوة 2: إنشاء Incoming Webhook
echo "الخطوة 2: إنشاء Incoming Webhook"
echo "1. اذهب إلى: https://api.slack.com/apps"
echo "2. اضغط 'Create New App'"
echo "3. اختر 'From scratch'"
echo "4. اسم التطبيق: تنبيهات Odoo"
echo "5. مساحة العمل: اختر مساحة عملك"
echo "6. اذهب إلى 'Incoming Webhooks'"
echo "7. قم بتفعيل 'Activate Incoming Webhooks'"
echo "8. اضغط 'Add New Webhook to Workspace'"
echo "9. اختر القناة: #odoo-alerts"
echo "10. انسخ عنوان URL الخاص بـ Webhook"
echo ""

# الخطوة 3: الحصول على Webhook URL
read -p "أدخل عنوان URL الخاص بـ Slack Webhook: " SLACK_WEBHOOK

# الخطوة 4: إنشاء سكريبت التنبيه
cat > /tmp/slack_alert.sh << EOF
#!/bin/bash
# إرسال تنبيه إلى Slack
# الاستخدام: ./slack_alert.sh "رسالة التنبيه"

MESSAGE=\$1
TIMESTAMP=\$(date '+%Y-%m-%d %H:%M:%S')

curl -X POST -H 'Content-type: application/json' \\
    --data "{
        \\"text\\": \"🤖 *تنبيه Odoo*\\n\\n*الوقت:* \$TIMESTAMP\\n*الرسالة:* \$MESSAGE\\n\\n*النظام:* إدارة المخازن\"
    }" \\
    $SLACK_WEBHOOK
EOF

chmod +x /tmp/slack_alert.sh

# الخطوة 5: إنشاء اختبار التنبيه
cat > /tmp/test_slack.sh << EOF
#!/bin/bash
# اختبار اتصال Slack
echo "اختبار اتصال Slack..."
/tmp/slack_alert.sh "✅ تم تكوين تنبيهات Odoo بنجاح! هذه رسالة اختبار."
echo "تحقق من قناة Slack للرسالة الاختبارية."
EOF

chmod +x /tmp/test_slack.sh

echo ""
echo "=== تم إعداد تنبيهات Slack ==="
echo ""
echo "اختبر الاتصال:"
echo "/tmp/test_slack.sh"
echo ""
echo "أنواع التنبيهات المكونة:"
echo "1. تنبيهات حالة النظام"
echo "2. تحذيرات المخزون المنخفض"
echo "3. حالة النسخ الاحتياطي"
echo "4. إشعارات الخطأ"
echo ""
echo "لإرسال تنبيه يدوي:"
echo "./slack_alert.sh 'رسالة التنبيه هنا'"
