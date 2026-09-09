@echo off
REM ==========================================
REM   إعداد Slack للتنبيهات
REM   قناة: #odoo-alerts
REM ==========================================
echo.
echo ==========================================
echo   إعداد Slack للتنبيهات
echo ==========================================
echo.

REM الخطوة 1: إنشاء مساحة عمل Slack
echo الخطوة 1: إنشاء مساحة عمل Slack
echo 1. اذهب إلى: https://slack.com/create
echo 2. أنشئ مساحة عمل مجانية
echo 3. أنشئ قناة: #odoo-alerts
echo.

REM الخطوة 2: إنشاء Incoming Webhook
echo الخطوة 2: إنشاء Incoming Webhook
echo 1. اذهب إلى: https://api.slack.com/apps
echo 2. اضغط "Create New App"
echo 3. اختر "From scratch"
echo 4. اسم التطبيق: تنبيهات Odoo
echo 5. مساحة العمل: اختر مساحة عملك
echo 6. اذهب إلى "Incoming Webhooks"
echo 7. قم بتفعيل "Activate Incoming Webhooks"
echo 8. اضغط "Add New Webhook to Workspace"
echo 9. اختر القناة: #odoo-alerts
echo 10. انسخ عنوان URL الخاص بـ Webhook
echo.

REM الخطوة 3: الحصول على Webhook URL
set /p SLACK_WEBHOOK="أدخل عنوان URL الخاص بـ Slack Webhook: "

REM الخطوة 4: إنشاء سكريبت التنبيه
echo.
echo الخطوة 4: إنشاء سكريبت التنبيه...
(
echo @echo off
echo REM إرسال تنبيه إلى Slack
echo REM الاستخدام: slack_alert.bat "رسالة التنبيه"
echo set MESSAGE=%%1
echo for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set dt=%%I
echo set TIMESTAMP=%%dt:~0,4%%-%%dt:~4,2%%-%%dt:~6,2%% %%dt:~8,2%%:%%dt:~10,2%%:%%dt:~12,2%%
echo curl -X POST -H "Content-type: application/json" --data "{\"text\":\"🤖 *تنبيه Odoo*\n\n*الوقت:* %TIMESTAMP%\n*الرسالة:* %MESSAGE%\n\n*النظام:* إدارة المخازن\"}" %SLACK_WEBHOOK%
) > "%TEMP%\slack_alert.bat"

echo.
echo ==========================================
echo   تم إعداد تنبيهات Slack بنجاح!
echo ==========================================
echo.
echo اختبر الاتصال:
echo slack_alert.bat "تم تكوين التنبيهات بنجاح!"
echo.
echo أنواع التنبيهات المكونة:
echo 1. تنبيهات حالة النظام
echo 2. تحذيرات المخزون المنخفض
echo 3. حالة النسخ الاحتياطي
echo 4. إشعارات الخطأ
echo.
pause
