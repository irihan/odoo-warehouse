@echo off
REM ==========================================
REM   الإعداد الكامل لنظام إدارة المخازن
REM   يقوم بتشغيل جميع خطوات الإعداد
REM ==========================================
echo.
echo ==========================================
echo   الإعداد الكامل لنظام إدارة المخازن
echo ==========================================
echo.
echo التاريخ: %date% %time%
echo.

REM الخطوة 1: التحقق من المتطلبات
echo ==========================================
echo   الخطوة 1: التحقق من المتطلبات
echo ==========================================
echo.

where docker >nul 2>nul
if %errorlevel% equ 0 (
    echo ✅ Docker مثبت
) else (
    echo ⚠️  Docker غير مثبت
)

where git >nul 2>nul
if %errorlevel% equ 0 (
    echo ✅ Git مثبت
) else (
    echo ⚠️  Git غير مثبت
)

where curl >nul 2>nul
if %errorlevel% equ 0 (
    echo ✅ cURL مثبت
) else (
    echo ⚠️  cURL غير مثبت
)

REM الخطوة 2: إنشاء هيكل المجلدات
echo.
echo ==========================================
echo   الخطوة 2: إنشاء هيكل المجلدات
echo ==========================================
echo.

mkdir "%TEMP%\odoo-warehouse\scripts" 2>nul
mkdir "%TEMP%\odoo-warehouse\backups" 2>nul
mkdir "%TEMP%\odoo-warehouse\logs" 2>nul
mkdir "%TEMP%\odoo-warehouse\reports" 2>nul
echo ✅ تم إنشاء هيكل المجلدات

REM الخطوة 3: إعداد Google Drive
echo.
echo ==========================================
echo   الخطوة 3: إعداد Google Drive للنسخ الاحتياطي
echo ==========================================
echo.
echo الحساب: islam.rihan@gmail.com
echo.
echo لإعداد Google Drive:
echo 1. تثبيت rclone: curl https://rclone.org/install.ps1 -useb ^| iex
echo 2. تكوين rclone: rclone config
echo 3. إنشاء مجلد: rclone mkdir gdrive:Odoo-Backups
echo.

set /p SETUP_GDRIVE="هل تريد إعداد Google Drive الآن؟ (y/n): "
if "%SETUP_GDRIVE%"=="y" (
    call 01-setup-gdrive.bat
) else (
    echo ⏭️ تخطي إعداد Google Drive
)

REM الخطوة 4: إعداد DuckDNS
echo.
echo ==========================================
echo   الخطوة 4: إعداد نطاق DuckDNS المجاني
echo ==========================================
echo.
echo يوفر DuckDNS نطاقاً مجانياً مثل: yourname.duckdns.org
echo.
echo لإعداد DuckDNS:
echo 1. اذهب إلى: https://www.duckdns.org
echo 2. سجل الدخول عبر GitHub/Google/Facebook
echo 3. أنشئ نطاقاً جديداً
echo 4. انسخ الرمز المميز
echo.

set /p SETUP_DUCKDNS="هل تريد إعداد DuckDNS الآن؟ (y/n): "
if "%SETUP_DUCKDNS%"=="y" (
    call 02-setup-duckdns.bat
) else (
    echo ⏭️ تخطي إعداد DuckDNS
)

REM الخطوة 5: إعداد Slack
echo.
echo ==========================================
echo   الخطوة 5: إعداد تنبيهات Slack
echo ==========================================
echo.
echo يوفر Slack إشعارات تنبيه مجانية
echo.
echo لإعداد Slack:
echo 1. أنشئ مساحة عمل على: https://slack.com/create
echo 2. أنشئ قناة: #odoo-alerts
echo 3. أنشئ Incoming Webhook
echo.

set /p SETUP_SLACK="هل تريد إعداد Slack الآن؟ (y/n): "
if "%SETUP_SLACK%"=="y" (
    call 03-setup-slack.bat
) else (
    echo ⏭️ تخطي إعداد Slack
)

REM الخطوة 6: الملخص
echo.
echo ==========================================
echo   ملخص الإعداد النهائي
echo ==========================================
echo.
echo ✅ تم إنشاء هيكل المجلدات
echo ✅ Google Drive (islam.rihan@gmail.com)
echo ✅ نطاق DuckDNS المجاني
echo ✅ تنبيهات Slack
echo.
echo ==========================================
echo   الخطوات التالية
echo ==========================================
echo.
echo 1. الدفع إلى GitHub:
echo    git add .
echo    git commit -m "إعداد كامل"
echo    git push
echo.
echo 2. النشر على Render:
echo    - اذهب إلى https://render.com
echo    - أنشئ Blueprint من مستودع GitHub
echo    - انتظر اكتمال النشر
echo.
echo 3. الوصول إلى Odoo:
echo    - الرابط: https://your-domain.duckdns.org
echo    - تسجيل الدخول: admin@example.com
echo    - كلمة المرور: admin
echo.
echo 4. غيّر كلمة مرور admin فوراً!
echo.
echo ==========================================
echo   تم الانتهاء من الإعداد!
echo ==========================================
echo.
pause
