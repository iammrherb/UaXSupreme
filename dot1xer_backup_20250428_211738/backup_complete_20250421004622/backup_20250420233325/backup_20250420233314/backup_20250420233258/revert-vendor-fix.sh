#!/bin/bash
# Script to revert to a specific vendor implementation and fix any template issues

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
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

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
  print_error "This script must be run from the UaXSupreme root directory"
fi

# Check arguments
if [ $# -lt 1 ]; then
  print_message "Usage: $0 <vendor> [platform]"
  print_message "Available vendors: cisco, aruba, juniper, fortinet, extreme, dell"
  print_message "Example: $0 cisco IOS-XE"
  exit 1
fi

VENDOR=$1
PLATFORM=$2

# Validate vendor
case $VENDOR in
  cisco|aruba|juniper|fortinet|extreme|dell)
    print_message "Selected vendor: $VENDOR"
    ;;
  *)
    print_error "Invalid vendor: $VENDOR. Available vendors: cisco, aruba, juniper, fortinet, extreme, dell"
    ;;
esac

# Create backup of current state
print_message "Creating backup..."
BACKUP_DIR="backup_$(date +%Y%m%d%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r * $BACKUP_DIR/ 2>/dev/null
print_success "Backup created in $BACKUP_DIR"

# Update templates for the selected vendor
print_message "Updating templates for $VENDOR..."

# Ensure template directories exist
mkdir -p templates/$VENDOR

# Handle platform-specific updates
if [ -n "$PLATFORM" ]; then
  print_message "Selected platform: $PLATFORM"

  # Create platform directory if it doesn't exist
  mkdir -p templates/$VENDOR/$PLATFORM

  # Check for platform-specific templates in the backup
  if [ -d "$BACKUP_DIR/templates/$VENDOR/$PLATFORM" ]; then
    cp -r "$BACKUP_DIR/templates/$VENDOR/$PLATFORM"/* templates/$VENDOR/$PLATFORM/ 2>/dev/null
    print_success "Restored platform-specific templates from backup"
  else
    print_warning "No platform-specific templates found in backup"
  fi
else
  # Handle all platforms for the vendor
  if [ -d "$BACKUP_DIR/templates/$VENDOR" ]; then
    cp -r "$BACKUP_DIR/templates/$VENDOR"/* templates/$VENDOR/ 2>/dev/null
    print_success "Restored vendor templates from backup"
  else
    print_warning "No vendor templates found in backup"
  fi
fi

# Verify JS files are intact
print_message "Verifying JavaScript files..."
if [ ! -f "js/app.js" ] || [ ! -f "js/template-generator.js" ]; then
  print_warning "Missing essential JavaScript files. Restoring from backup..."
  mkdir -p js
  
  # Copy JS files from backup if they exist
  if [ -d "$BACKUP_DIR/js" ]; then
    cp -r "$BACKUP_DIR/js"/* js/ 2>/dev/null
    print_success "Restored JavaScript files from backup"
  else
    print_error "No JavaScript files found in backup"
  fi
fi

# Verify CSS files are intact
print_message "Verifying CSS files..."
if [ ! -f "css/styles.css" ]; then
  print_warning "Missing CSS files. Restoring from backup..."
  mkdir -p css
  
  # Copy CSS files from backup if they exist
  if [ -d "$BACKUP_DIR/css" ]; then
    cp -r "$BACKUP_DIR/css"/* css/ 2>/dev/null
    print_success "Restored CSS files from backup"
  else
    print_error "No CSS files found in backup"
  fi
fi

# Run fix-duplicates.js to ensure structure is correct
print_message "Running fix-duplicates.js to ensure structure is correct..."
node fix-duplicates.js

# Update UI to focus on selected vendor
print_message "Updating UI to focus on $VENDOR..."

# Run update-index.js if it exists, otherwise skip
if [ -f "update-index.js" ]; then
  node update-index.js --vendor=$VENDOR
  print_success "UI updated to focus on $VENDOR"
else
  print_warning "update-index.js not found. UI not updated."
fi

print_success "Revert to $VENDOR completed successfully."
print_message "You may need to refresh your browser to see the changes."
