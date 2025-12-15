#!/usr/bin/env python
"""
PythonAnywhere Web App Reload Script
Automatically reloads your web app after deployment

Requirements:
    pip install pythonanywhere

Usage:
    python reload_webapp.py
    
Or set PA_API_TOKEN environment variable
"""

import os
import sys

try:
    from pythonanywhere.api import Webapp
except ImportError:
    print("❌ Error: pythonanywhere package not installed")
    print("Install it with: pip install pythonanywhere")
    sys.exit(1)

# Configuration
USERNAME = os.environ.get('PA_USERNAME', 'mdhabibullahmahmudncs')
DOMAIN = f'{USERNAME}.pythonanywhere.com'
API_TOKEN = os.environ.get('PA_API_TOKEN')

if not API_TOKEN:
    print("❌ Error: PA_API_TOKEN environment variable not set")
    print("\nGet your API token from:")
    print("https://www.pythonanywhere.com/account/#api_token")
    print("\nThen set it:")
    print("export PA_API_TOKEN='your-token-here'")
    sys.exit(1)

try:
    print(f"🔄 Reloading {DOMAIN}...")
    webapp = Webapp(DOMAIN, API_TOKEN)
    webapp.reload()
    print(f"✅ {DOMAIN} reloaded successfully!")
    print(f"🌐 Visit: https://{DOMAIN}/api/")
except Exception as e:
    print(f"❌ Error reloading web app: {e}")
    sys.exit(1)
