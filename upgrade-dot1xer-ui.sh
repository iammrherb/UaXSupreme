#!/bin/bash

# Dot1Xer Supreme Enterprise Edition UI Upgrade Script
# This script runs the integration process to apply the UI enhancements

# Set colors for terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print banner
echo -e "${BLUE}"
echo "==================================================================="
echo "        Dot1Xer Supreme Enterprise Edition UI Upgrade"
echo "==================================================================="
echo -e "${NC}"

# Check if running from project root directory
if [ ! -d "css" ] || [ ! -d "templates" ]; then
    echo -e "${RED}Error: Script must be run from the project root directory${NC}"
    echo "Please cd into your project root directory and try again."
    exit 1
fi

# Check if node is available
if ! command -v node &> /dev/null; then
    echo -e "${RED}Error: Node.js is required for integration but not found${NC}"
    echo "Please install Node.js and try again."
    exit 1
fi

# Run the main setup script first
echo -e "${YELLOW}Setting up the UI enhancement files...${NC}"
bash setup-dot1xer-ui.sh

# Run the integration script
echo -e "${YELLOW}Running integration script...${NC}"
node integrate-ui.js

# Check if integration was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Integration script completed successfully.${NC}"
    
    # Ask user if they want to apply the changes
    echo -e "${YELLOW}Do you want to apply the UI changes now? (y/n)${NC}"
    read -r apply_changes
    
    if [[ $apply_changes =~ ^[Yy]$ ]]; then
        mv index.html.new index.html
        echo -e "${GREEN}UI changes have been applied to index.html${NC}"
        echo -e "${YELLOW}You can now open index.html in your browser to see the new UI.${NC}"
    else
        echo -e "${YELLOW}Changes not applied. You can manually replace index.html with index.html.new when ready.${NC}"
    fi
else
    echo -e "${RED}Integration failed. Please check the errors above.${NC}"
    exit 1
fi

echo -e "${BLUE}"
echo "==================================================================="
echo "        UI Upgrade Completed"
echo "==================================================================="
echo -e "${NC}"

echo -e "To customize the UI further, you can edit the following files:"
echo -e "- css/dot1xer-ui.css: Main UI styles"
echo -e "- js/dot1xer-ui.js: Main UI functionality"
echo -e "- js/modules/vendor-data.js: Vendor information and capabilities"
echo -e "- js/modules/mobile-nav.js: Mobile navigation functionality"
