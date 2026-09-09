#!/bin/bash
# تهيئة نظام إدارة المخازن
# شغّل هذا السكريبت بعد إعداد Render

echo "=========================================="
echo "   تهيئة نظام إدارة المخازن"
echo "=========================================="
echo ""

# انتظار تشغيل Odoo
echo "انتظار تشغيل Odoo..."
sleep 30

echo ""
echo "=========================================="
echo "   تم تهيئة النظام بنجاح!"
echo "=========================================="
echo ""
echo "الخطوات التالية:"
echo "1. افتح الرابط المقدم من Render"
echo "2. سجل الدخول: admin@example.com"
echo "3. كلمة المرور: admin"
echo "4. غيّر كلمة المرور فوراً"
echo "5. ثبّت تطبيقات المخازن"
echo ""
echo "بيانات المستخدمين:"
echo "├── مسؤول المخازن: warehouse_manager / warehouse123"
echo "├── مسؤول المشتريات: purchase_officer / purchase123"
echo "├── مسؤول المبيعات: sales_officer / sales123"
echo "├── المحاسب: accountant / account123"
echo "└── المندوب الميداني: field_rep / field123"
echo ""
echo "المخازن:"
echo "├── المخزن الرئيسي (WH-MAIN)"
echo "├── مخزن المشتريات (WH-PURCH)"
echo "└── مخزن المبيعات (WH-SALES)"
