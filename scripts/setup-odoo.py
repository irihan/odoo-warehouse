#!/usr/bin/env python3
"""
Odoo Warehouse Setup Script
Run this script to configure the warehouse system
"""

import xmlrpc.client
import sys

# Configuration
URL = 'http://localhost:8069'
DB = 'odoo'
ADMIN_EMAIL = 'admin@example.com'
ADMIN_PASSWORD = 'admin'

def xmlrpc_connect():
    """Connect to Odoo via XML-RPC"""
    try:
        common = xmlrpc.client.ServerProxy(f'{URL}/xmlrpc/2/common')
        uid = common.authenticate(DB, ADMIN_EMAIL, ADMIN_PASSWORD, {})
        models = xmlrpc.client.ServerProxy(f'{URL}/xmlrpc/2/object')
        return uid, models
    except Exception as e:
        print(f"Connection failed: {e}")
        sys.exit(1)

def create_user(models, uid, name, login, email, password, groups):
    """Create a new user"""
    try:
        user_id = models.execute_kw(DB, uid, ADMIN_PASSWORD,
            'res.users', 'create', [{
                'name': name,
                'login': login,
                'email': email,
                'password': password,
                'groups_id': [(6, 0, groups)]
            }])
        print(f"✅ Created user: {name} (ID: {user_id})")
        return user_id
    except Exception as e:
        print(f"❌ Failed to create user {name}: {e}")
        return None

def create_warehouse(models, uid, name, code):
    """Create a new warehouse"""
    try:
        warehouse_id = models.execute_kw(DB, uid, ADMIN_PASSWORD,
            'stock.warehouse', 'create', [{
                'name': name,
                'code': code
            }])
        print(f"✅ Created warehouse: {name} (ID: {warehouse_id})")
        return warehouse_id
    except Exception as e:
        print(f"❌ Failed to create warehouse {name}: {e}")
        return None

def setup_users(models, uid):
    """Setup all users"""
    print("\n=== Setting up Users ===")
    
    users = [
        ("Warehouse Manager", "warehouse_manager", "warehouse@example.com", "warehouse123", [32, 33]),
        ("Purchase Officer", "purchase_officer", "purchase@example.com", "purchase123", [23, 24]),
        ("Sales Officer", "sales_officer", "sales@example.com", "sales123", [17, 18]),
        ("Accountant", "accountant", "account@example.com", "account123", [20, 21]),
        ("Field Representative", "field_rep", "field@example.com", "field123", [33])
    ]
    
    for user in users:
        create_user(models, uid, *user)

def setup_warehouses(models, uid):
    """Setup warehouses"""
    print("\n=== Setting up Warehouses ===")
    
    warehouses = [
        ("Main Warehouse", "WH-MAIN"),
        ("Purchase Warehouse", "WH-PURCH"),
        ("Sales Warehouse", "WH-SALES")
    ]
    
    for warehouse in warehouses:
        create_warehouse(models, uid, *warehouse)

def main():
    """Main setup function"""
    print("=== Odoo Warehouse Setup ===")
    print("Starting setup...")
    
    # Connect to Odoo
    uid, models = xmlrpc_connect()
    print(f"✅ Connected to Odoo (UID: {uid})")
    
    # Setup users
    setup_users(models, uid)
    
    # Setup warehouses
    setup_warehouses(models, uid)
    
    print("\n=== Setup Complete ===")
    print("Next steps:")
    print("1. Login to Odoo")
    print("2. Install required apps (Inventory, Purchase, Sales)")
    print("3. Configure operation types")
    print("4. Add products")
    print("5. Test the system")

if __name__ == "__main__":
    main()
