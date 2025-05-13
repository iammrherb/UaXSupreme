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

# Create backup
print_message "Creating backup of index.html..."
BACKUP_FILE="index.html.bak.$(date +"%Y%m%d%H%M%S")"
cp index.html "$BACKUP_FILE"
print_success "Backup created: $BACKUP_FILE"

# Clean the index.html file
print_message "Cleaning index.html file..."

# Extract HTML content up to the closing </html> tag
sed -n '1,/<\/html>/p' index.html > index.html.clean

# Check if we found the closing HTML tag
if grep -q "</html>" index.html.clean; then
  print_success "Found closing HTML tag"
else
  print_warning "No closing HTML tag found, will attempt to clean known script patterns"
  
  # If no </html> tag, try to remove script content
  grep -v "#!/bin/bash" index.html > index.html.clean
  grep -v "print_message" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_success" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_warning" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_error" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "function" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "echo -e" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  
  # Add closing tags if missing
  echo "</body>" >> index.html.clean
  echo "</html>" >> index.html.clean
fi

# Replace the original with the cleaned version
mv index.html.clean index.html
print_success "index.html cleaned successfully"

print_message "You should now refresh your browser to see the changes"
