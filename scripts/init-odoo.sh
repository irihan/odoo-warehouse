#!/bin/bash
# Script to initialize Odoo warehouse configuration
# Run this after Render deployment is complete

echo "=== Odoo Warehouse Initialization Script ==="

# Wait for Odoo to be ready
echo "Waiting for Odoo to start..."
sleep 30

echo "Odoo should be running now!"
echo ""
echo "Next steps:"
echo "1. Access Odoo at the URL provided by Render"
echo "2. Login with admin@example.com / admin"
echo "3. Go to Apps and install: Inventory, Purchase, Sales"
echo "4. Configure warehouses and users"
echo ""
echo "=== Setup Complete ==="
