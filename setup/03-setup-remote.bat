@echo off
REM ==========================================
REM   إعداد الوصول عن بعد (Cloudflare Tunnel)
REM ==========================================
echo.
echo ==========================================
echo   إعداد الوصول عن بعد
REM ==========================================
echo.

REM التحقق من cloudflared
echo التحقق من Cloudflared...
cloudflared version >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️ Cloudflared غير مثبت
    echo.
    echo لتنزيل Cloudflared:
    echo 1. افتح المتصفح
    echo 2. اذهب إلى: https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/
    echo 3. حمل الإصدار المناسب لـ Windows
    echo 4. ثبّته
    echo.
    echo بعد التثبيت، شغّل هذا السكريبت مرة أخرى
    echo.
    pause
    exit /b 1
)

echo ✅ Cloudflared مثبت

REM إنشاء نفق Cloudflare
echo.
echo إنشاء نفق Cloudflare...
echo سيظهر رابط مجاني مثل: https://abc123.trycloudflare.com
echo.
echo شغّل هذا الأمر في نافذة PowerShell أخرى:
echo cloudflared tunnel --url http://localhost:8069
echo.
echo ثم انسخ الرابط وافتحه في المتصفح
echo.
echo ==========================================
echo   اضغط أي زر لإغلاق هذه النافذة
echo ==========================================
pause
