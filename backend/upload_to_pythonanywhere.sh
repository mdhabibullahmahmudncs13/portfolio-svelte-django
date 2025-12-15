#!/bin/bash

# Upload Database to PythonAnywhere
# Run this script to push your local data to production

echo "📤 Uploading database to PythonAnywhere..."

# Export local data
cd /home/mhmhmud/Documents/GitHub/portfolio-svelte-django/backend
python3 manage.py dumpdata api --indent 2 --output data_export.json

if [ ! -s data_export.json ]; then
    echo "❌ Error: No data to export (database is empty)"
    exit 1
fi

echo "✓ Local data exported"

# Upload to PythonAnywhere
echo "📤 Uploading to server..."
scp data_export.json habib29far@ssh.pythonanywhere.com:~/portfolio-svelte-django/backend/

# Load data on PythonAnywhere
echo "🔄 Loading data on PythonAnywhere..."
ssh habib29far@ssh.pythonanywhere.com << 'ENDSSH'
cd ~/portfolio-svelte-django/backend
source ~/.virtualenvs/portfolio-env/bin/activate

# Backup existing data first
python manage.py dumpdata api --indent 2 --output ~/backup_before_import_$(date +%Y%m%d_%H%M%S).json

# Load new data
python manage.py loaddata data_export.json
echo "✓ Data loaded successfully"
ENDSSH

echo "✅ Upload complete! Your data is now on PythonAnywhere."
echo "🔄 Don't forget to reload your web app in the PythonAnywhere Web tab."
