@echo off
REM ==========================================
REM   إعداد Google Drive للنسخ الاحتياطي
REM   الحساب: islam.rihan@gmail.com
REM ==========================================
echo.
echo ==========================================
echo   إعداد Google Drive للنسخ الاحتياطي
echo   الحساب: islam.rihan@gmail.com
echo ==========================================
echo.

REM الخطوة 1: تثبيت rclone
echo الخطوة 1: تثبيت rclone...
where rclone >nul 2>nul
if %errorlevel% neq 0 (
    echo تثبيت rclone...
    powershell -Command "iwr https://rclone.org/install.ps1 -useb | iex"
) else (
    echo ✅ rclone مثبت بالفعل
)

REM الخطوة 2: تكوين rclone
echo.
echo الخطوة 2: تكوين rclone لـ Google Drive
echo شغّل الأوامر التالية بالترتيب:
echo.
echo 1. شغّل: rclone config
echo 2. اضغط 'n' لإنشاء ند جديد
echo 3. الاسم: gdrive
echo 4. التخزين: Google Drive
echo 5. Client ID: (اتركه فارغاً)
echo 6. Client Secret: (اتركه فارغاً)
echo 7. النطاق: 1 (وصول كامل)
echo 8. مجلد الجذر: (اتركه فارغاً)
echo 9. حساب الخدمة: لا
echo 10. تكوين متقدم: لا
echo 11. تكوين تلقائي: نعم (سيفتح المتصفح)
echo 12. تكوين كمحرك فريق: لا
echo 13. التأكيد: نعم
echo.

REM الخطوة 3: إنشاء مجلد النسخ الاحتياطي
echo الخطوة 3: إنشاء مجلد النسخ الاحتياطي في Google Drive...
echo بعد تكوين rclone، شغّل:
echo rclone mkdir gdrive:Odoo-Backups
echo.

REM الخطوة 4: اختبار الاتصال
echo الخطوة 4: اختبار الاتصال...
echo شغّل: rclone lsd gdrive:
echo إذا رأيت مجلد Odoo-Backups، فهذا يعني نجاح الاتصال
echo.

echo ==========================================
echo   تم إعداد Google Drive بنجاح!
echo ==========================================
echo.
echo الخطوات التالية:
echo 1. تكوين rclone: rclone config
echo 2. إنشاء مجلد: rclone mkdir gdrive:Odoo-Backups
echo 3. اختبار الاتصال: rclone lsd gdrive:
echo.
pause
