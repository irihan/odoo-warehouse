@echo off
REM ==========================================
REM   إعداد DuckDNS المجاني
REM   نطاق: yourname.duckdns.org
REM ==========================================
echo.
echo ==========================================
echo   إعداد DuckDNS المجاني
echo ==========================================
echo.

REM الخطوة 1: إنشاء حساب DuckDNS
echo الخطوة 1: إنشاء ح_ACCOUNT DuckDNS
echo 1. اذهب إلى: https://www.duckdns.org
echo 2. سجل الدخول عبر GitHub/Google/Facebook
echo 3. في قسم "Domains"، اكتب الاسم المطلوب
echo    مثال: irihan-warehouse
echo 4. اضغط "add domain"
echo 5. انسخ الرمز المميز
echo.

REM الخطوة 2: الحصول على الرمز المميز
set /p DUCKDNS_DOMAIN="أدخل اسم النطاق (بدون .duckdns.org): "
set /p DUCKDNS_TOKEN="أدخل رمز DuckDNS المميز: "

REM الخطوة 3: تحديث العنوان IP
echo.
echo الخطوة 3: تحديث عنوان IP...
curl "https://www.duckdns.org/update?domains=%DUCKDNS_DOMAIN%&token=%DUCKDNS_TOKEN%&ip="

REM الخطوة 4: إنشاء سكريبت التحديث التلقائي
echo.
echo الخطوة 4: إنشاء سكريبت التحديث التلقائي...
(
echo @echo off
echo REM تحديث DuckDNS تلقائياً (كل 5 دقائق)
echo curl "https://www.duckdns.org/update?domains=%DUCKDNS_DOMAIN%&token=%DUCKDNS_TOKEN%&ip="
) > "%TEMP%\duckdns_update.bat"

echo.
echo ==========================================
echo   تم إعداد DuckDNS بنجاح!
echo ==========================================
echo.
echo نطاقك: https://%DUCKDNS_DOMAIN%.duckdns.org
echo.
echo الخطوات التالية:
echo 1. اذهب إلى لوحة تحكم Render
echo 2. اضغط على خدمة Odoo
echo 3. اذهب إلى "Settings" ^> "Custom Domains"
echo 4. أضف: %DUCKDNS_DOMAIN%.duckdns.org
echo 5. سيوفر لك Render قيمة CNAME
echo 6. عد إلى DuckDNS وأضف سجل CNAME
echo.
echo تم! يمكنك الآن الوصول إلى Odoo على:
echo https://%DUCKDNS_DOMAIN%.duckdns.org
echo.
pause
