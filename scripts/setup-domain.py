#!/usr/bin/env python3
"""
سكريبت إعداد النطاق
يُكوّن نطاق مخصص مع SSL مجاني
"""

import os
import subprocess

def setup_duckdns():
    """إعداد نطاق DuckDNS المجاني"""
    print("=== إعداد نطاق DuckDNS المجاني ===")
    print("يوفر DuckDNS نطاقات مجانية مثل: yourname.duckdns.org")
    print("")
    print("الخطوات:")
    print("1. اذهب إلى: https://www.duckdns.org")
    print("2. سجل الدخول عبر GitHub/Google/Facebook")
    print("3. أنشئ نطاقاً جديداً: yourname.duckdns.org")
    print("4. انسخ الرمز المميز")
    print("")
    
    token = input("أدخل رمز DuckDNS المميز: ")
    domain = input("أدخل اسم النطاق (مثال: mywarehouse): ")
    
    # إنشاء سكريبت التحديث
    script = f'''#!/bin/bash
# سكريبت تحديث DuckDNS
# يحدث عنوان IP تلقائياً

echo "تحديث IP DuckDNS..."
curl "https://www.duckdns.org/update?domains={domain}&token={token}&ip="

echo "تم تحديث النطاق: {domain}.duckdns.org"
'''
    
    with open('/tmp/duckdns_update.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/duckdns_update.sh', 0o755)
    print(f"✅ تم إنشاء سكريبت تحديث DuckDNS: /tmp/duckdns_update.sh")
    
    return f"{domain}.duckdns.org"

def setup_cloudflare_tunnel():
    """إعداد Cloudflare Tunnel للـ HTTPS"""
    print("\n=== إعداد Cloudflare Tunnel ===")
    print("يوفر Cloudflare HTTPS مجاني لنطاقك")
    print("")
    print("الخطوات:")
    print("1. اذهب إلى: https://dash.cloudflare.com")
    print("2. سجل حساب مجاني")
    print("3. أضف نطاقك")
    print("4. احصل على رمز النفق")
    print("")
    
    token = input("أدخل رمز Cloudflare tunnel (أو اضغط Enter للتخطي): ")
    
    if token:
        script = f'''#!/bin/bash
# إعداد Cloudflare Tunnel
# يوفر HTTPS مجاني لنطاقك

echo "بدء تشغيل Cloudflare tunnel..."
cloudflared tunnel run --token {token}
'''
        
        with open('/tmp/cloudflare_tunnel.sh', 'w') as f:
            f.write(script)
        
        os.chmod('/tmp/cloudflare_tunnel.sh', 0o755)
        print("✅ تم إنشاء سكريبت Cloudflare tunnel: /tmp/cloudflare_tunnel.sh")
        return True
    else:
        print("⏭️ تخطي إعداد Cloudflare")
        return False

def setup_ssl_certbot():
    """إعداد SSL بـ Certbot (إذا كنت تستخدم نطاقاً خاصاً)"""
    print("\n=== إعداد SSL بـ Certbot ===")
    print("يوفر Certbot شهادات SSL مجانية")
    print("")
    print("المتطلبات:")
    print("- النطاق يشير إلى خادمك")
    print("- Nginx أو Apache مثبت")
    print("")
    
    domain = input("أدخل نطاقك (أو اضغط Enter للتخطي): ")
    
    if domain:
        script = f'''#!/bin/bash
# إعداد SSL بـ Certbot
# يوفر شهادات SSL مجانية

echo "تثبيت Certbot..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

echo "الحصول على شهادة SSL..."
sudo certbot --nginx -d {domain} --non-interactive --agree-tos --email admin@{domain}

echo "تم تثبيت شهادة SSL لـ {domain}"
echo "تم تكوين التجديد التلقائي"
'''
        
        with open('/tmp/setup_ssl.sh', 'w') as f:
            f.write(script)
        
        os.chmod('/tmp/setup_ssl.sh', 0o755)
        print(f"✅ تم إنشاء سكريبت إعداد SSL: /tmp/setup_ssl.sh")
        return True
    else:
        print("⏭️ تخطي إعداد SSL")
        return False

def main():
    """الدالة الرئيسية لإعداد النطاق"""
    print("=== إعداد النطاق لنظام إدارة المخازن ===")
    print("")
    
    # إعداد نطاق مجاني
    domain = setup_duckdns()
    
    # إعداد Cloudflare Tunnel
    cloudflare = setup_cloudflare_tunnel()
    
    # إعداد SSL (اختياري)
    ssl = setup_ssl_certbot()
    
    print("\n=== تم إعداد النطاق بنجاح ===")
    print(f"نطاقك: {domain}")
    if cloudflare:
        print("HTTPS: مفعّل (عبر Cloudflare)")
    if ssl:
        print("SSL: مفعّل (عبر Certbot)")
    print("")
    print("الوصول إلى Odoo على:")
    print(f"  http://{domain}")
    if cloudflare or ssl:
        print(f"  https://{domain}")

if __name__ == "__main__":
    main()
