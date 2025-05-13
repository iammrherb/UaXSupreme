#!/bin/bash

Import script for UaXSupreme - import existing configuration for analysis
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

Check if a file was provided
if [ $# -ne 1 ]; then
print_error "Usage: $0 <config_file>"
fi

CONFIG_FILE=$1

Check if the file exists
if [ ! -f "$CONFIG_FILE" ]; then
print_error "File not found: $CONFIG_FILE"
fi

Create import directory if it doesn't exist
IMPORT_DIR="data/imports"
mkdir -p $IMPORT_DIR

Create timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

Copy the file to imports directory
cp "$CONFIG_FILE" "$IMPORT_DIR/config_$TIMESTAMP.txt"

print_success "Configuration imported: $CONFIG_FILE"
print_message "To analyze this configuration, open UaXSupreme and load the file from the Generate Configuration section."
print_message "File saved as: $IMPORT_DIR/config_$TIMESTAMP.txt"

Try to detect the device type
if grep -q "aaa new-model" "$CONFIG_FILE"; then
print_message "Detected: Cisco IOS/IOS-XE configuration"
elif grep -q "aaa authentication port-access" "$CONFIG_FILE"; then
print_message "Detected: Aruba/HP configuration"
elif grep -q "system {" "$CONFIG_FILE"; then
print_message "Detected: Juniper configuration"
else
print_warning "Could not automatically detect configuration type"
fi

print_message "Configuration ready for analysis in UaXSupreme!"
