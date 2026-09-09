#!/bin/bash
# Monitoring script for Odoo on Render
# This script checks system health

echo "=== System Health Check ==="
echo "Date: $(date)"

# Check Odoo service
echo "Checking Odoo service..."
curl -s -o /dev/null -w "%{http_code}" http://localhost:8069
if [ $? -eq 0 ]; then
    echo "✅ Odoo is running"
else
    echo "❌ Odoo is not responding"
fi

# Check database connection
echo "Checking database connection..."
psql -h $HOST -U $USER -d $DB_NAME -c "SELECT 1;" > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Database connection OK"
else
    echo "❌ Database connection failed"
fi

# Check disk space
echo "Checking disk space..."
df -h | grep -E "^/dev/.*\s/[0-9]+%"

# Check memory usage
echo "Checking memory usage..."
free -h

echo "=== Health Check Complete ==="
echo "Date: $(date)"
