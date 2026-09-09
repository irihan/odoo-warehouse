#!/bin/bash
# Slack Alerts Setup for Odoo
# Sends notifications when issues are detected

echo "=== Slack Alerts Setup ==="
echo ""

# Step 1: Create Slack Workspace
echo "Step 1: Create Slack Workspace"
echo "1. Go to: https://slack.com/create"
echo "2. Create a free workspace"
echo "3. Create a channel: #odoo-alerts"
echo ""

# Step 2: Create Incoming Webhook
echo "Step 2: Create Incoming Webhook"
echo "1. Go to: https://api.slack.com/apps"
echo "2. Click 'Create New App'"
echo "3. Choose 'From scratch'"
echo "4. App Name: Odoo Alerts"
echo "5. Workspace: Select your workspace"
echo "6. Go to 'Incoming Webhooks'"
echo "7. Toggle 'Activate Incoming Webhooks' ON"
echo "8. Click 'Add New Webhook to Workspace'"
echo "9. Select channel: #odoo-alerts"
echo "10. Copy the Webhook URL"
echo ""

# Step 3: Get Webhook URL
read -p "Enter your Slack Webhook URL: " SLACK_WEBHOOK

# Step 4: Create alert script
cat > /tmp/slack_alert.sh << EOF
#!/bin/bash
# Send alert to Slack
# Usage: ./slack_alert.sh "Alert message"

MESSAGE=\$1
TIMESTAMP=\$(date '+%Y-%m-%d %H:%M:%S')

curl -X POST -H 'Content-type: application/json' \\
    --data "{
        \\"text\\": \"🤖 *Odoo Alert*\\n\\n*Time:* \$TIMESTAMP\\n*Message:* \$MESSAGE\\n\\n*System:* Odoo Warehouse Management\"
    }" \\
    $SLACK_WEBHOOK
EOF

chmod +x /tmp/slack_alert.sh

# Step 5: Create test alert
cat > /tmp/test_slack.sh << EOF
#!/bin/bash
# Test Slack connection
echo "Testing Slack connection..."
/tmp/slack_alert.sh "✅ Odoo alerts configured successfully! This is a test message."
echo "Check your Slack channel for the test message."
EOF

chmod +x /tmp/test_slack.sh

echo ""
echo "=== Slack Setup Complete ==="
echo ""
echo "Test the connection:"
echo "/tmp/test_slack.sh"
echo ""
echo "Alert types configured:"
echo "1. System health alerts"
echo "2. Low stock warnings"
echo "3. Backup status"
echo "4. Error notifications"
echo ""
echo "To send manual alert:"
echo "./slack_alert.sh 'Your alert message here'"
