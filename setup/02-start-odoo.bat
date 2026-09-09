@echo off
REM ==========================================
REM   تشغيل نظام إدارة المخازن
REM ==========================================
echo.
echo ==========================================
echo   تشغيل نظام إدارة المخازن
echo ==========================================
echo.

REM التحقق من Docker
echo التحقق من Docker...
docker --version >nul 2>nul
if %errorlevel% neq 0 (
    echo ❌ Docker غير مثبت!
    echo يرجى تثبيت Docker Desktop أولاً
    echo https://www.docker.com/products/docker-desktop
    echo.
    pause
    exit /b 1
)

echo ✅ Docker مثبت

REM الانتقال إلى مجلد المشروع
echo.
echo الانتقال إلى مجلد المشروع...
cd /d "E:\AI Working Files\OpenCode_Files\OmniRoute\odoo-warehouse"

REM تشغيل Docker
echo.
echo تشغيل النظام...
docker-compose up -d

echo.
echo ==========================================
echo   تم تشغيل النظام بنجاح!
echo ==========================================
echo.
echo للدخول إلى النظام:
echo 1. افتح المتصفح
echo 2. اذهب إلى: http://localhost:8069
echo 3. البريد الإلكتروني: admin@example.com
echo 4. كلمة المرور: admin
echo.
echo للوصول من أجهزة أخرى:
echo 1. احصل على عنوان IP لجهازك
echo 2. اذهب إلى: http://YOUR_IP:8069
echo.
echo ==========================================
echo   اضغط أي زر لإغلاق هذه النافذة
echo ==========================================
pause
