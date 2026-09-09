#!/usr/bin/env python3
"""
Odoo Monitoring Setup Script
Configures system monitoring and alerts
"""

import os
import json

def create_monitoring_config():
    """Create monitoring configuration"""
    config = {
        "monitoring_enabled": True,
        "check_interval": 300,  # 5 minutes
        "alerts": {
            "email_enabled": False,
            "email_recipients": [],
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
    
    print("✅ Monitoring configuration created")
    return config

def create_health_check_script():
    """Create health check script"""
    script = '''#!/bin/bash
# Odoo Health Check Script
# Monitors system health and sends alerts

set -e

# Configuration
LOG_FILE="/tmp/odoo_health.log"
ALERT_THRESHOLD_CPU=80
ALERT_THRESHOLD_MEMORY=80
ALERT_THRESHOLD_DISK=80

# Get current timestamp
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Check Odoo service
echo "[$TIMESTAMP] Checking Odoo service..." >> $LOG_FILE
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8069 | grep -q "200\|302"; then
    echo "[$TIMESTAMP] ✅ Odoo is running" >> $LOG_FILE
else
    echo "[$TIMESTAMP] ❌ Odoo is not responding" >> $LOG_FILE
fi

# Check database connection
echo "[$TIMESTAMP] Checking database connection..." >> $LOG_FILE
if psql -h $HOST -U $USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1; then
    echo "[$TIMESTAMP] ✅ Database connection OK" >> $LOG_FILE
else
    echo "[$TIMESTAMP] ❌ Database connection failed" >> $LOG_FILE
fi

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
if [ $(echo "$CPU_USAGE > $ALERT_THRESHOLD_CPU" | bc) -eq 1 ]; then
    echo "[$TIMESTAMP] ⚠️ High CPU usage: $CPU_USAGE%" >> $LOG_FILE
fi

# Check memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if [ $(echo "$MEMORY_USAGE > $ALERT_THRESHOLD_MEMORY" | bc) -eq 1 ]; then
    echo "[$TIMESTAMP] ⚠️ High memory usage: $MEMORY_USAGE%" >> $LOG_FILE
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt $ALERT_THRESHOLD_DISK ]; then
    echo "[$TIMESTAMP] ⚠️ High disk usage: $DISK_USAGE%" >> $LOG_FILE
fi

echo "[$TIMESTAMP] Health check completed" >> $LOG_FILE
'''
    
    with open('/tmp/odoo_health_check.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_health_check.sh', 0o755)
    print("✅ Health check script created")

def create_alert_script():
    """Create alert notification script"""
    script = '''#!/bin/bash
# Odoo Alert Notification Script
# Sends alerts when issues are detected

set -e

# Configuration
LOG_FILE="/tmp/odoo_health.log"
ALERT_EMAIL="admin@example.com"
SLACK_WEBHOOK=""

# Check for alerts in log
ALERTS=$(grep "⚠️\|❌" $LOG_FILE | tail -20)

if [ -n "$ALERTS" ]; then
    echo "=== Odoo System Alerts ==="
    echo "Date: $(date)"
    echo ""
    echo "$ALERTS"
    
    # Send email alert (if configured)
    if [ -n "$ALERT_EMAIL" ]; then
        echo "$ALERTS" | mail -s "Odoo System Alert" $ALERT_EMAIL
    fi
    
    # Send Slack alert (if configured)
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST -H 'Content-type: application/json' \
            --data "{\"text\":\"Odoo System Alert:\\n$ALERTS\"}" \
            $SLACK_WEBHOOK
    fi
fi
'''
    
    with open('/tmp/odoo_alert.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_alert.sh', 0o755)
    print("✅ Alert script created")

def create_performance_report():
    """Create performance report script"""
    script = '''#!/bin/bash
# Odoo Performance Report
# Generates daily performance metrics

set -e

# Configuration
REPORT_DIR="/tmp/odoo_reports"
DATE=$(date +%Y%m%d)
REPORT_FILE="$REPORT_DIR/performance_$DATE.txt"

# Create report directory
mkdir -p $REPORT_DIR

# Generate report
echo "=== Odoo Performance Report ===" > $REPORT_FILE
echo "Date: $(date)" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "=== System Resources ===" >> $REPORT_FILE
echo "CPU Usage:" >> $REPORT_FILE
top -bn1 | grep "Cpu(s)" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Memory Usage:" >> $REPORT_FILE
free -h >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "Disk Usage:" >> $REPORT_FILE
df -h / >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "=== Database Statistics ===" >> $REPORT_FILE
psql -h $HOST -U $USER -d $DB_NAME -c "SELECT count(*) as total_users FROM res_users;" >> $REPORT_FILE
psql -h $HOST -U $USER -d $DB_NAME -c "SELECT count(*) as total_products FROM product_template;" >> $REPORT_FILE
psql -h $HOST -U $USER -d $DB_NAME -c "SELECT count(*) as total_stock_moves FROM stock_move WHERE state='done';" >> $REPORT_FILE
echo "" >> $REPORT_FILE

echo "=== Report Complete ===" >> $REPORT_FILE
echo "Report saved to: $REPORT_FILE"

cat $REPORT_FILE
'''
    
    with open('/tmp/odoo_performance_report.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/odoo_performance_report.sh', 0o755)
    print("✅ Performance report script created")

def main():
    """Main monitoring setup function"""
    print("=== Setting up Monitoring System ===")
    
    create_monitoring_config()
    create_health_check_script()
    create_alert_script()
    create_performance_report()
    
    print("\n=== Monitoring Setup Complete ===")
    print("Next steps:")
    print("1. Configure alert recipients")
    print("2. Set up Slack integration (optional)")
    print("3. Schedule health checks")
    print("4. Review performance reports")

if __name__ == "__main__":
    main()
