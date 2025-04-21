#!/bin/bash
# UaxEnhance.sh - Script to enhance and update UaXSupreme

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme Enhance]${NC} $1"
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

# Create backup of current state
print_message "Creating backup of current state..."
BACKUP_DIR="backup_$(date +%Y%m%d%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r * $BACKUP_DIR/ 2>/dev/null
print_success "Backup created in $BACKUP_DIR"

# Clean up any old backup directories that might cause confusion
find . -maxdepth 1 -type d -name "backup_2*" -not -name "$BACKUP_DIR" -exec rm -rf {} \; 2>/dev/null

# Update directory structure
print_message "Updating directory structure..."

# Create or ensure required directories exist
mkdir -p css js templates lib assets help ai-models

# Vendor-specific template directories
mkdir -p templates/cisco/IOS templates/cisco/IOS-XE templates/cisco/WLC-9800
mkdir -p templates/aruba/AOS-CX templates/aruba/AOS-Switch
mkdir -p templates/juniper/Junos
mkdir -p templates/fortinet/FortiOS
mkdir -p templates/extreme/EXOS
mkdir -p templates/dell/OS10

# Run fix-duplicates.js to ensure structure is correct
print_message "Running fix-duplicates.js to ensure structure is correct..."
node fix-duplicates.js

# Create sample templates if they don't exist
print_message "Creating sample templates if they don't exist..."

# Check for Cisco IOS-XE Concurrent 802.1X and MAB template
if [ ! -f "templates/cisco/IOS-XE/concurrent.txt" ]; then
  print_message "Creating Cisco IOS-XE Concurrent 802.1X and MAB template..."
  mkdir -p templates/cisco/IOS-XE
  cp $BACKUP_DIR/templates/cisco/IOS-XE/concurrent.txt templates/cisco/IOS-XE/ 2>/dev/null
  
  if [ $? -ne 0 ]; then
    print_warning "Template not found in backup. Creating a new template."
    touch templates/cisco/IOS-XE/concurrent.txt
  fi
fi

# Ensure JavaScript files are present
print_message "Ensuring JavaScript files are present..."
for jsFile in app.js template-generator.js validation.js ai-assistant.js documentation.js; do
  if [ ! -f "js/$jsFile" ]; then
    print_warning "Missing JS file: $jsFile. Restoring from backup."
    cp $BACKUP_DIR/js/$jsFile js/ 2>/dev/null
    
    if [ $? -ne 0 ]; then
      print_warning "File not found in backup. Creating an empty file."
      touch js/$jsFile
    fi
  fi
done

# Ensure CSS files are present
print_message "Ensuring CSS files are present..."
if [ ! -f "css/styles.css" ]; then
  print_warning "Missing CSS file: styles.css. Restoring from backup."
  cp $BACKUP_DIR/css/styles.css css/ 2>/dev/null
  
  if [ $? -ne 0 ]; then
    print_warning "File not found in backup. Creating an empty file."
    touch css/styles.css
  fi
fi

# Verify help documentation
print_message "Verifying help documentation..."
if [ ! -f "help/readme.md" ]; then
  print_warning "Help documentation not found. Creating from backup or template."
  mkdir -p help
  cp $BACKUP_DIR/help/readme.md help/ 2>/dev/null
  
  if [ $? -ne 0 ]; then
    print_message "Creating help documentation template."
    echo "# UaXSupreme Help Documentation" > help/readme.md
    echo "" >> help/readme.md
    echo "Please see the main README.md file for general information." >> help/readme.md
  fi
fi

# Run update-index.js if it exists
if [ -f "update-index.js" ]; then
  print_message "Running update-index.js..."
  node update-index.js --vendor=cisco
fi

print_success "UaXSupreme enhancement complete."
print_message "You may need to refresh your browser to see the changes."
