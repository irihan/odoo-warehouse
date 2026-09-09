#!/usr/bin/env python3
"""
سكريبت إعداد Odoo
شغّل هذا السكريبت لتكوين نظام إدارة المخازن
"""

import xmlrpc.client
import sys

# التكوين
URL = 'http://localhost:8069'
DB = 'odoo'
ADMIN_EMAIL = 'admin@example.com'
ADMIN_PASSWORD = 'admin'

def xmlrpc_connect():
    """الاتصال بـ Odoo عبر XML-RPC"""
    try:
        common = xmlrpc.client.ServerProxy(f'{URL}/xmlrpc/2/common')
        uid = common.authenticate(DB, ADMIN_EMAIL, ADMIN_PASSWORD, {})
        models = xmlrpc.client.ServerProxy(f'{URL}/xmlrpc/2/object')
        return uid, models
    except Exception as e:
        print(f"فشل الاتصال: {e}")
        sys.exit(1)

def create_user(models, uid, name, login, email, password, groups):
    """إنشاء مستخدم جديد"""
    try:
        user_id = models.execute_kw(DB, uid, ADMIN_PASSWORD,
            'res.users', 'create', [{
                'name': name,
                'login': login,
                'email': email,
                'password': password,
                'groups_id': [(6, 0, groups)]
            }])
        print(f"✅ تم إنشاء المستخدم: {name} (المعرف: {user_id})")
        return user_id
    except Exception as e:
        print(f"❌ فشل إنشاء المستخدم {name}: {e}")
        return None

def create_warehouse(models, uid, name, code):
    """إنشاء مخزن جديد"""
    try:
        warehouse_id = models.execute_kw(DB, uid, ADMIN_PASSWORD,
            'stock.warehouse', 'create', [{
                'name': name,
                'code': code
            }])
        print(f"✅ تم إنشاء المخزن: {name} (المعرف: {warehouse_id})")
        return warehouse_id
    except Exception as e:
        print(f"❌ فشل إنشاء المخزن {name}: {e}")
        return None

def setup_users(models, uid):
    """إعداد جميع المستخدمين"""
    print("\n=== إعداد المستخدمين ===")
    
    users = [
        ("مسؤول المخازن", "warehouse_manager", "warehouse@example.com", "warehouse123", [32, 33]),
        ("مسؤول المشتريات", "purchase_officer", "purchase@example.com", "purchase123", [23, 24]),
        ("مسؤول المبيعات", "sales_officer", "sales@example.com", "sales123", [17, 18]),
        ("المحاسب", "accountant", "account@example.com", "account123", [20, 21]),
        ("المندوب الميداني", "field_rep", "field@example.com", "field123", [33])
    ]
    
    for user in users:
        create_user(models, uid, *user)

def setup_warehouses(models, uid):
    """إعداد المخازن"""
    print("\n=== إعداد المخازن ===")
    
    warehouses = [
        ("المخزن الرئيسي", "WH-MAIN"),
        ("مخزن المشتريات", "WH-PURCH"),
        ("مخزن المبيعات", "WH-SALES")
    ]
    
    for warehouse in warehouses:
        create_warehouse(models, uid, *warehouse)

def main():
    """الدالة الرئيسية للإعداد"""
    print("=== إعداد نظام إدارة المخازن ===")
    print("بدء الإعداد...")
    
    # الاتصال بـ Odoo
    uid, models = xmlrpc_connect()
    print(f"✅ تم الاتصال بـ Odoo (المعرف: {uid})")
    
    # إعداد المستخدمين
    setup_users(models, uid)
    
    # إعداد المخازن
    setup_warehouses(models, uid)
    
    print("\n=== تم الانتهاء من الإعداد ===")
    print("الخطوات التالية:")
    print("1. تسجيل الدخول إلى Odoo")
    print("2. تثبيت التطبيقات المطلوبة (المخازن، المشتريات، المبيعات)")
    print("3. تكوين أنواع العمليات")
    print("4. إضافة المنتجات")
    print("5. اختبار النظام")

if __name__ == "__main__":
    main()
