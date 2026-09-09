#!/usr/bin/env python3
"""
سكريبت إعداد المراقبة
يُكوّن مراقبة النظام والتنبيهات
"""

import os
import json

def create_monitoring_config():
    """إنشاء تكوين المراقبة"""
    config = {
        "monitoring_enabled": True,
        "check_interval": 300,  # 5 دقائق
        "alerts": {
            "email_enabled": True,
            "email_recipients": ["islam.rihan@gmail.com"],
            "slack_enabled": False,
            "slack_webhook": ""
        },
        "thresholds": {
            "cpu_usage": 80,
            "memory_usage": 80,
            "disk_usage": 80,
            "database_connections": 100
        }
    }
    
    with open('/tmp/odoo_monitoring_config.json', 'w') as f:
        json.dump(config, f, indent=4)
    
    print("✅ تم إنشاء تكوين المراقبة")
    return config

def create_health_check_script():
    """إنشاء سكريبت الفحص الصحي"""
    script = '''#!/bin/bash
# سكريبت الفحص الصحي لـ Odoo
# يراقب صحة النظام ويرسل تنبيهات

set -e

# التكوين
LOG_FILE="/tmp/odoo_health.log"
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEMORY=80
ALERT_THRESHOLD_DISK=80

# الحصول على الطابع الزمني الحالي
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# التحقق من خدمة Odoo
echo "[$TIMESTAMP] فحص خدمة Odoo..." >> $LOG_FILE
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8069 | grep -q "200\|302"; then
    echo "[$TIMESTAMP] ✅ Odoo يعمل" >> $LOG_FILE
else
    echo "[$TIMESTAMP] ❌ Odoo لا يستجيب" >> $LOG_FILE
fi

# التحقق من اتصال قاعدة البيانات
echo "[$TIMESTAMP] فحص اتصال قاعدة البيانات..." >> $LOG_FILE
if psql -h $HOST -U $USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1; then
    echo "[$TIMESTAMP] ✅ اتصال قاعدة البيانات جيد" >> $LOG_FILE
else
    echo "[$TIMESTAMP] ❌ فشل اتصال قاعدة البيانات" >> $LOG_FILE
fi

# التحقق من استخدام المعالج
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
if [ $(echo "$CPU_USAGE > $ALERT_THRESHOLD_CPU" | bc) -eq 1 ]; then
    echo "[$TIMESTAMP] ⚠️ استخدام معالج مرتفع: $CPU_USAGE%" >> $LOG_FILE
fi

# التحقق من استخدام الذاكرة
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if [ $(echo "$MEMORY_USAGE > $ALERT_THRESHOLD_MEMORY" | bc) -eq 1 ]; then
    echo "[$TIMESTAMP] ⚠️ استخدام ذاكرة مرتفع: $MEMORY_USAGE%" >> $LOG_FILE
fi

# التحقق من مساحة القرص
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt $ALERT_THRESHOLD_DISK ]; then
    echo "[$TIMESTAMP] ⚠️ استخدام قرص مرتفع: $DISK_USAGE%" >> $LOG_FILE
fi

echo "[$TIMESTAMP] تم الانتهاء من الفحص الصحي" >> $LOG_FILE
'''
    
    with open('/tmp/odoo_health_check.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_health_check.sh', 0o755)
    print("✅ تم إنشاء سكريبت الفحص الصحي")

def create_alert_script():
    """إنشاء سكريبت إشعارات التنبيه"""
    script = '''#!/bin/bash
# سكريبت إشعارات التنبيه لـ Odoo
# يرسل تنبيهات عند اكتشاف مشاكل

set -e

# التكوين
LOG_FILE="/tmp/odoo_health.log"
ALERT_EMAIL="islam.rihan@gmail.com"
SLACK_WEBHOOK=""

# التحقق من التنبيهات في السجل
ALERTS=$(grep "⚠️\|❌" $LOG_FILE | tail -20)

if [ -n "$ALERTS" ]; then
    echo "=== تنبيهات حالة نظام Odoo ==="
    echo "التاريخ: $(date)"
    echo ""
    echo "$ALERTS"
    
    # إرسال تنبيه بالبريد الإلكتروني (إذا كان مكوناً)
    if [ -n "$ALERT_EMAIL" ]; then
        echo "$ALERTS" | mail -s "تنبيه حالة نظام Odoo" $ALERT_EMAIL
    fi
    
    # إرسال تنبيه Slack (إذا كان مكوناً)
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST -H 'Content-type: application/json' \\
            --data "{\"text\":\"تنبيه حالة نظام Odoo:\\n$ALERTS\"}" \\
            $SLACK_WEBHOOK
    fi
fi
'''
    
    with open('/tmp/odoo_alert.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_alert.sh', 0o755)
    print("✅ تم إنشاء سكريبت التنبيه")

def create_performance_report():
    """إنشاء سكريبت تقرير الأداء"""
    script = '''#!/bin/bash
# تقرير أداء Odoo
# ينشئ مقاييس أداء يومية

set -e

# التكوين
REPORT_DIR="/tmp/odoo_reports"
DATE=$(date +%Y%m%d)
REPORT_FILE="$REPORT_DIR/performance_$DATE.txt"

# إنشاء مجلد التقارير
mkdir -p $REPORT_DIR

# إنشاء التقرير
echo "=== تقرير أداء Odoo ===" > $REPORT_FILE
echo "التاريخ: $(date)" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "=== موارد النظام ===" >> $REPORT_FILE
echo "استخدام المعالج:" >> $REPORT_FILE
top -bn1 | grep "Cpu(s)" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "استخدام الذاكرة:" >> $REPORT_FILE
free -h >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "استخدام القرص:" >> $REPORT_FILE
df -h / >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "=== إحصائيات قاعدة البيانات ===" >> $REPORT_FILE
psql -h $HOST -U $USER -d $DB_NAME -c "SELECT count(*) as total_users FROM res_users;" >> $REPORT_FILE
psql -h $HOST -U $USER -d $REPORT_FILE -c "SELECT count(*) as total_products FROM product_template;" >> $REPORT_FILE
psql -h $HOST -U $USER -d $DB_NAME -c "SELECT count(*) as total_stock_moves FROM stock_move WHERE state='done';" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "=== اكتمل التقرير ===" >> $REPORT_FILE
echo "تم حفظ التقرير في: $REPORT_FILE"

cat $REPORT_FILE
'''
    
    with open('/tmp/odoo_performance_report.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_performance_report.sh', 0o755)
    print("✅ تم إنشاء سكريبت تقرير الأداء")

def main():
    """الدالة الرئيسية لإعداد المراقبة"""
    print("=== إعداد نظام المراقبة ===")
    
    create_monitoring_config()
    create_health_check_script()
    create_alert_script()
    create_performance_report()
    
    print("\n=== تم إعداد المراقبة ===")
    print("الخطوات التالية:")
    print("1. تكوين مستلمي التنبيهات")
    print("2. إعداد تكامل Slack (اختياري)")
    print("3. جدولة الفحوصات الصحية")
    print("4. مراجعة تقارير الأداء")

if __name__ == "__main__":
    main()
