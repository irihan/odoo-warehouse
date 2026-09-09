#!/bin/bash
# DuckDNS Free Domain Setup
# Provides: yourname.duckdns.org

echo "=== DuckDNS Free Domain Setup ==="
echo ""

# Step 1: Create DuckDNS account
echo "Step 1: Create DuckDNS Account"
echo "1. Go to: https://www.duckdns.org"
echo "2. Click 'Login' (top right)"
echo "3. Sign in with GitHub/Google/Facebook"
echo ""

# Step 2: Create domain
echo "Step 2: Create Domain"
echo "1. After login, you'll see the DuckDNS panel"
echo "2. In 'Domains' section, type your desired name"
echo "   Example: irihan-warehouse"
echo "3. Click 'add domain'"
echo "4. Copy your token (shown next to domain)"
echo ""

# Step 3: Get token
read -p "Enter your DuckDNS token: " DUCKDNS_TOKEN
read -p "Enter your domain name (without .duckdns.org): " DUCKDNS_DOMAIN

# Step 4: Update IP
echo ""
echo "Step 3: Updating IP address..."
curl -s "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip="

# Step 5: Create auto-update script
cat > /tmp/duckdns_autoupdate.sh << EOF
#!/bin/bash
# Auto-update DuckDNS IP (runs every 5 minutes)
curl -s "https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip="
EOF

chmod +x /tmp/duckdns_autoupdate.sh

echo ""
echo "=== DuckDNS Setup Complete ==="
echo "Your domain: https://$DUCKDNS_DOMAIN.duckdns.org"
echo ""
echo "Next steps:"
echo "1. Go to Render Dashboard"
echo "2. Click on your Odoo service"
echo "3. Go to 'Settings' → 'Custom Domains'"
echo "4. Add: $DUCKDNS_DOMAIN.duckdns.org"
echo "5. Render will provide a CNAME value"
echo "6. Go back to DuckDNS and add CNAME record"
echo ""
echo "Done! Your Odoo is now accessible at:"
echo "https://$DUCKDNS_DOMAIN.duckdns.org"
