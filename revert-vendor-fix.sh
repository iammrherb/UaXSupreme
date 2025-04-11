#!/bin/bash
# Revert the vendor selection fixes

TARGET_FILE="/home/iamrad/Projects/github/UaXSupreme/index.html"
BACKUP_FILE="/home/iamrad/Projects/github/UaXSupreme/index.html.bak"
CSS_FILE="/home/iamrad/Projects/github/UaXSupreme/css/vendor-fix.css"
JS_FILE="/home/iamrad/Projects/github/UaXSupreme/js/vendor-fix.js"

if [ -f "$BACKUP_FILE" ]; then
    echo "Restoring from backup..."
    cp "$BACKUP_FILE" "$TARGET_FILE"
    echo "Original file restored."
else
    echo "Error: Backup file not found at $BACKUP_FILE"
    exit 1
fi

if [ -f "$CSS_FILE" ]; then
    echo "Removing CSS override file..."
    rm "$CSS_FILE"
    echo "CSS file removed."
fi

if [ -f "$JS_FILE" ]; then
    echo "Removing JS fix file..."
    rm "$JS_FILE"
    echo "JS file removed."
fi

echo "Vendor selection fix has been reverted."
