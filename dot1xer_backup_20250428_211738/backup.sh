#!/bin/bash

Backup script for UaXSupreme
Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

Function to display script messages
print_message() {
echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
echo -e "${RED}[ERROR]${NC} $1"
exit 1
}

Create backup directory if it doesn't exist
BACKUP_DIR="backups"
mkdir -p $BACKUP_DIR

Create timestamp for backup file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/uaxsupreme_backup_$TIMESTAMP.tar.gz"

print_message "Creating backup of UaXSupreme data..."

Create tar archive of important files and directories
tar -czf $BACKUP_FILE index.html css js data *.md *.sh

Check if backup was successful
if [ $? -eq 0 ]; then
print_success "Backup created successfully: $BACKUP_FILE"
echo "Backup size: $(du -h $BACKUP_FILE | cut -f1)"
else
print_error "Backup failed"
fi
