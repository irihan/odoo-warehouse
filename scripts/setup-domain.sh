#!/bin/bash
# إعداد نطاق DuckDNS المجاني
# يوفر نطاقاً مثل: yourname.duckdns.org

echo "=== إعداد نطاق DuckDNS المجاني ==="
echo ""

# الخطوة 1: إنشاء حساب DuckDNS
echo "الخطوة 1: إنشاء حساب DuckDNS"
echo "1. اذهب إلى: https://www.duckdns.org"
echo "2. اضغط 'Login' (في الأعلى)"
echo "3. سجل الدخول عبر GitHub/Google/Facebook"
echo ""

# الخطوة 2: إنشاء النطاق
echo "الخطوة 2: إنشاء النطاق"
echo "1. بعد تسجيل الدخول، سترى لوحة DuckDNS"
echo "2. في قسم 'Domains'، اكتب الاسم المطلوب"
echo "   مثال: irihan-warehouse"
echo "3. اضغط 'add domain'"
echo "4. انسخ الرمز المميز (يظهر بجوار النطاق)"
echo ""

# الخطوة 3: الحصول على الرمز المميز
read -p "أدخل رمز DuckDNS المميز: " DUCKDNS_TOKEN
read -p "أدخل اسم النطاق (بدون .duckdns.org): " DUCKDNS_DOMAIN

# الخطوة 4: تحديث العنوان IP
echo ""
echo "الخطوة 3: تحديث عنوان IP..."
curl -s "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip="

# الخطوة 5: إنشاء سكريبت التحديث التلقائي
cat > /tmp/duckdns_autoupdate.sh << EOF
#!/bin/bash
# تحديث DuckDNS تلقائياً (كل 5 دقائق)
curl -s "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip="
EOF

chmod +x /tmp/duckdns_autoupdate.sh

echo ""
echo "=== تم إعداد DuckDNS بنجاح ==="
echo "نطاقك: https://$DUCKDNS_DOMAIN.duckdns.org"
echo ""
echo "الخطوات التالية:"
echo "1. اذهب إلى لوحة تحكم Render"
echo "2. اضغط على خدمة Odoo الخاصة بك"
echo "3. اذهب إلى 'Settings' → 'Custom Domains'"
echo "4. أضف: $DUCKDNS_DOMAIN.duckdns.org"
echo "5. سيوفر لك Render قيمة CNAME"
echo "6. عد إلى DuckDNS وأضف سجل CNAME"
echo ""
echo "تم! يمكنك الآن الوصول إلى Odoo على:"
echo "https://$DUCKDNS_DOMAIN.duckdns.org"
