#!/usr/bin/env python3
"""
Odoo Domain Setup Script
Configures custom domain with SSL
"""

import os
import subprocess

def setup_duckdns():
    """Setup free DuckDNS domain"""
    print("=== Setting up DuckDNS Domain ===")
    print("DuckDNS provides free domains like: yourname.duckdns.org")
    print("")
    print("Steps:")
    print("1. Go to https://www.duckdns.org")
    print("2. Login with GitHub/Google/Facebook")
    print("3. Create a new domain: yourname.duckdns.org")
    print("4. Copy the token")
    print("")
    
    token = input("Enter your DuckDNS token: ")
    domain = input("Enter your domain (e.g., mywarehouse): ")
    
    # Create update script
    script = f'''#!/bin/bash
# DuckDNS Update Script
# Updates IP address automatically

echo "Updating DuckDNS IP..."
curl "https://www.duckdns.org/update?domains={domain}&token={token}&ip="

echo "Domain updated: {domain}.duckdns.org"
'''
    
    with open('/tmp/duckdns_update.sh', 'w') as f:
        f.write(script)
    
    os.chmod('/tmp/duckdns_update.sh', 0o755)
    print(f"✅ DuckDNS update script created: /tmp/duckdns_update.sh")
    
    return f"{domain}.duckdns.org"

def setup_cloudflare_tunnel():
    """Setup Cloudflare Tunnel for HTTPS"""
    print("\n=== Setting up Cloudflare Tunnel ===")
    print("Cloudflare provides free HTTPS for your domain")
    print("")
    print("Steps:")
    print("1. Go to https://dash.cloudflare.com")
    print("2. Sign up for free account")
    print("3. Add your domain")
    print("4. Get tunnel token")
    print("")
    
    token = input("Enter your Cloudflare tunnel token (or press Enter to skip): ")
    
    if token:
        script = f'''#!/bin/bash
# Cloudflare Tunnel Setup
# Provides free HTTPS for your domain

echo "Starting Cloudflare tunnel..."
cloudflared tunnel run --token {token}
'''
        
        with open('/tmp/cloudflare_tunnel.sh', 'w') as f:
            f.write(script)
        
        os.chmod('/tmp/cloudflare_tunnel.sh', 0o755)
        print("✅ Cloudflare tunnel script created: /tmp/cloudflare_tunnel.sh")
        return True
    else:
        print("⏭️ Skipping Cloudflare setup")
        return False

def setup_ssl_certbot():
    """Setup SSL with Certbot (if using own domain)"""
    print("\n=== Setting up SSL with Certbot ===")
    print("Certbot provides free SSL certificates")
    print("")
    print("Prerequisites:")
    print("- Domain pointing to your server")
    print("- Nginx or Apache installed")
    print("")
    
    domain = input("Enter your domain (or press Enter to skip): ")
    
    if domain:
        script = f'''#!/bin/bash
# Certbot SSL Setup
# Provides free SSL certificates

echo "Installing Certbot..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

echo "Obtaining SSL certificate..."
sudo certbot --nginx -d {domain} --non-interactive --agree-tos --email admin@{domain}

echo "SSL certificate installed for {domain}"
echo "Auto-renewal configured"
'''
        
        with open('/tmp/setup_ssl.sh', 'w') as f:
            f.write(script)
        
        os.chmod('/tmp/setup_ssl.sh', 0o755)
        print(f"✅ SSL setup script created: /tmp/setup_ssl.sh")
        return True
    else:
        print("⏭️ Skipping SSL setup")
        return False

def main():
    """Main domain setup function"""
    print("=== Domain Setup for Odoo Warehouse ===")
    print("")
    
    # Setup free domain
    domain = setup_duckdns()
    
    # Setup Cloudflare Tunnel
    cloudflare = setup_cloudflare_tunnel()
    
    # Setup SSL (optional)
    ssl = setup_ssl_certbot()
    
    print("\n=== Domain Setup Complete ===")
    print(f"Your domain: {domain}")
    if cloudflare:
        print("HTTPS: Enabled (via Cloudflare)")
    if ssl:
        print("SSL: Enabled (via Certbot)")
    print("")
    print("Access your Odoo at:")
    print(f"  http://{domain}")
    if cloudflare or ssl:
        print(f"  https://{domain}")

if __name__ == "__main__":
    main()
