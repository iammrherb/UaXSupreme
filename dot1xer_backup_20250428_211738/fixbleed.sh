#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme Fix]${NC} $1"
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

# Create backup of index.html
print_message "Creating backup of index.html..."
BACKUP_FILE="index.html.bak.$(date +"%Y%m%d%H%M%S")"
cp index.html "$BACKUP_FILE"
print_success "Backup created: $BACKUP_FILE"

# Fix the index.html file
print_message "Fixing index.html file..."

# Step 1: Extract everything up to the closing HTML tag
if grep -q "</html>" index.html; then
  print_message "Found closing HTML tag. Extracting clean HTML..."
  sed -n '1,/<\/html>/p' index.html > index.html.clean
else
  print_warning "No closing HTML tag found. Using alternative cleaning method..."
  # Copy the original file as a starting point
  cp index.html index.html.clean
  
  # Look for shell script patterns and remove them
  print_message "Removing shell script patterns..."
  grep -v "#!/bin/bash" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_message" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_success" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_warning" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_error" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "function " index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "echo -e" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "if \[" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "for " index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "while " index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "cat >" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "EOF" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  
  # Make sure body and html tags are closed properly
  if ! grep -q "</body>" index.html.clean; then
    print_message "Adding missing </body> tag..."
    echo "</body>" >> index.html.clean
  fi
  
  if ! grep -q "</html>" index.html.clean; then
    print_message "Adding missing </html> tag..."
    echo "</html>" >> index.html.clean
  fi
fi

# Step 2: Ensure DOCTYPE declaration
if ! grep -q "<!DOCTYPE html>" index.html.clean; then
  print_message "Adding DOCTYPE declaration..."
  sed -i '1i<!DOCTYPE html>' index.html.clean
fi

# Step 3: Fix any broken script tags
print_message "Fixing script tags..."
sed -i 's/<script[^>]*>\([^<]*\)<script/<script>\1/g' index.html.clean

# Step 4: Replace the original with the cleaned version
mv index.html.clean index.html
print_success "index.html fixed successfully"

print_message "You should now refresh your browser to see the changes"
print_message "If you still see issues, try using one of the provided HTML tools:"
print_message "  - detect-script-bleed.html: For diagnosing script bleed issues"
print_message "  - fix-script-bleed.html: For manually cleaning the HTML file"
print_message "  - hide-script-blocks.html: For hiding problematic script blocks"
print_message "  - final-fix-bookmarklet.html: For a quick in-browser fix"
