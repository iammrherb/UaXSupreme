#!/bin/bash

# Master script to finalize Portnox diagram integration
# This script will update index.html and test the integration

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}  Portnox Diagram Integration - Final Configuration ${NC}"
echo -e "${BLUE}====================================================${NC}"

# Update index.html if it exists
if [ -f "index.html" ]; then
    echo -e "${YELLOW}Updating index.html with diagram resources...${NC}"
    echo -e "${BLUE}Backing up original index.html to index.html.bak${NC}"
    cp index.html index.html.bak
    
    # Inject CSS links
    if ! grep -q "css/diagrams/diagram-styles.css" index.html; then
        echo -e "${BLUE}Adding diagram CSS links to head section${NC}"
        sed -i -e '/<\/head>/ i\
    <!-- Portnox Diagram Styles -->\
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">\
    <link href="css/diagrams/grapheditor.css" rel="stylesheet">' index.html
    fi
    
    # Inject JS scripts
    if ! grep -q "js/diagrams/mxClient.js" index.html; then
        echo -e "${BLUE}Adding diagram JS scripts before body end${NC}"
        sed -i -e '/<\/body>/ i\
    <!-- Portnox Diagram Libraries -->\
    <script src="js/diagrams/mxClient.js"></script>\
    <script src="js/diagrams/diagram-generator.js"></script>\
    <script src="js/diagrams/diagram-ui.js"></script>\
    <script>\
      document.addEventListener("DOMContentLoaded", function() {\
        if (typeof DiagramUI !== "undefined") {\
          DiagramUI.initialize();\
        }\
      });\
    </script>' index.html
    fi
    
    echo -e "${GREEN}Successfully updated index.html${NC}"
else
    echo -e "${YELLOW}index.html not found. Skipping update.${NC}"
fi

# Update main.js if it exists
if [ -f "js/main.js" ]; then
    echo -e "${YELLOW}Updating main.js with diagram initialization...${NC}"
    echo -e "${BLUE}Backing up original main.js to js/main.js.bak${NC}"
    cp js/main.js js/main.js.bak
    
    # Check if DiagramUI initialization already exists
    if ! grep -q "DiagramUI.initialize" js/main.js; then
        # Look for document ready or window load event
        if grep -q "DOMContentLoaded" js/main.js; then
            # Add inside existing DOMContentLoaded
            sed -i '/DOMContentLoaded/,/});/ {
                /});/i\
  // Initialize Portnox diagram UI\
  if (typeof DiagramUI !== "undefined") {\
    DiagramUI.initialize();\
  }
            }' js/main.js
        else
            # Add at the end of the file
            echo -e "\n// Initialize Portnox diagram UI when document is ready
document.addEventListener('DOMContentLoaded', function() {
  if (typeof DiagramUI !== 'undefined') {
    DiagramUI.initialize();
  }
});" >> js/main.js
        fi
        
        echo -e "${GREEN}Successfully updated main.js${NC}"
    else
        echo -e "${YELLOW}DiagramUI.initialize already found in main.js. No changes needed.${NC}"
    fi
else
    echo -e "${YELLOW}js/main.js not found. Skipping update.${NC}"
fi

# Test if the key files exist
echo -e "${YELLOW}Verifying installation...${NC}"

FILES_OK=true
for file in js/diagrams/mxClient.js js/diagrams/diagram-generator.js js/diagrams/diagram-ui.js css/diagrams/diagram-styles.css; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Missing file: $file${NC}"
        FILES_OK=false
    fi
done

if [ "$FILES_OK" = true ]; then
    echo -e "${GREEN}All required files are present.${NC}"
else
    echo -e "${RED}Some required files are missing. Installation may be incomplete.${NC}"
fi

# Verify stencil directories
echo -e "${YELLOW}Checking stencil directories...${NC}"
STENCIL_DIRS_OK=true

for dir in images/stencils/vendors images/stencils/portnox images/stencils/devices images/stencils/authentication; do
    if [ ! -d "$dir" ]; then
        echo -e "${RED}Missing directory: $dir${NC}"
        STENCIL_DIRS_OK=false
    else
        # Check if directory has any files
        if [ -z "$(ls -A $dir 2>/dev/null)" ]; then
            echo -e "${YELLOW}Warning: Directory $dir is empty${NC}"
        fi
    fi
done

if [ "$STENCIL_DIRS_OK" = true ]; then
    echo -e "${GREEN}All stencil directories are present.${NC}"
else
    echo -e "${RED}Some stencil directories are missing. Installation may be incomplete.${NC}"
fi

echo -e "${GREEN}Integration complete! To test the diagrams, open:${NC}"
echo -e "${BLUE}test_portnox_diagrams.html${NC}"

echo -e "\n${YELLOW}What to do next:${NC}"
echo -e "1. Open the test page to verify diagram functionality"
echo -e "2. Add more custom stencils to images/stencils directories as needed"
echo -e "3. Create additional diagram templates in js/diagrams/templates"
echo -e "4. Customize the diagram generator for your specific needs"

echo -e "\n${GREEN}For any issues, check the browser console for error messages${NC}"
