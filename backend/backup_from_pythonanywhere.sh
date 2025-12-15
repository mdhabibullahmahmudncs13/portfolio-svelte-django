#!/bin/bash

# Backup Database from PythonAnywhere
# Run this script to download your production data

echo "🔄 Backing up database from PythonAnywhere..."

# SSH into PythonAnywhere and export data
ssh habib29far@ssh.pythonanywhere.com << 'ENDSSH'
cd ~/portfolio-svelte-django/backend
source ~/.virtualenvs/portfolio-env/bin/activate
python manage.py dumpdata api --indent 2 --output ~/data_backup.json
echo "✓ Data exported on PythonAnywhere"
ENDSSH

# Download the backup file
echo "📥 Downloading backup..."
scp habib29far@ssh.pythonanywhere.com:~/data_backup.json ./data_backup_$(date +%Y%m%d_%H%M%S).json

echo "✅ Backup complete! File saved locally."
