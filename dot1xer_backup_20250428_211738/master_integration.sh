#!/bin/bash

# Portnox Cloud NAC Diagramming Master Integration Script
# Version: 1.0
# Date: April 25, 2025

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}===========================================================${NC}"
echo -e "${BLUE}  Portnox Cloud NAC Diagramming - Master Integration Script ${NC}"
echo -e "${BLUE}===========================================================${NC}"

# Check if we're in the right directory
if [ ! -f "index.html" ] || [ ! -d "js" ]; then
    echo -e "${RED}Error: This script must be run from the UaXSupreme root directory.${NC}"
    echo -e "${YELLOW}Please navigate to the directory containing index.html and try again.${NC}"
    exit 1
fi

# Step 1: Run the comprehensive integration script
echo -e "\n${YELLOW}Step 1: Running main integration script...${NC}"
chmod +x integrate_drawio.sh
./integrate_drawio.sh

# Step 2: Download all icon stencils
echo -e "\n${YELLOW}Step 2: Downloading all icon stencils...${NC}"
chmod +x download_all_icons.sh
./download_all_icons.sh

# Step 3: Update index.html
echo -e "\n${YELLOW}Step 3: Updating index.html with new scripts and styles...${NC}"
echo -e "${BLUE}Backing up original index.html to index.html.bak${NC}"
cp index.html index.html.bak

# Extract the CSS link section and append our new CSS
sed -i '/<!-- Add after your existing CSS files -->/{
r index_update.html
d
}' index.html 2>/dev/null || sed -i '' '/<!-- Add after your existing CSS files -->/{
r index_update.html
d
}' index.html

# If the marker doesn't exist, append to head
if ! grep -q "css/diagrams/diagram-styles.css" index.html; then
    echo -e "${BLUE}Adding CSS links to head section${NC}"
    sed -i '/<\/head>/ i\
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">\
    <link href="css/diagrams/grapheditor.css" rel="stylesheet">' index.html 2>/dev/null || sed -i '' '/<\/head>/ i\
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">\
    <link href="css/diagrams/grapheditor.css" rel="stylesheet">' index.html
fi

# Extract the JS script section and append our new scripts
sed -i '/<!-- Add before closing <\/body> tag -->/{
r index_update.html
d
}' index.html 2>/dev/null || sed -i '' '/<!-- Add before closing <\/body> tag -->/{
r index_update.html
d
}' index.html

# If the marker doesn't exist, append before body close
if ! grep -q "js/diagrams/mxClient.js" index.html; then
    echo -e "${BLUE}Adding JavaScript links before body end${NC}"
    sed -i '/<\/body>/ i\
    <script src="js/diagrams/mxClient.js"></script>\
    <script src="js/diagrams/diagram-generator.js"></script>\
    <script src="js/diagrams/diagram-ui.js"></script>\
    <script>\
      document.addEventListener("DOMContentLoaded", function() {\
        if (typeof DiagramUI !== "undefined") {\
          DiagramUI.initialize();\
        }\
      });\
    </script>' index.html 2>/dev/null || sed -i '' '/<\/body>/ i\
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

# Step 4: Update main.js if it exists
if [ -f "js/main.js" ]; then
    echo -e "\n${YELLOW}Step 4: Updating main.js with diagram initialization...${NC}"
    echo -e "${BLUE}Backing up original main.js to main.js.bak${NC}"
    cp js/main.js js/main.js.bak
    
    # Check if DiagramUI initialization already exists
    if ! grep -q "DiagramUI.initialize" js/main.js; then
        # Look for document ready or window load event
        if grep -q "DOMContentLoaded" js/main.js; then
            # Add inside existing DOMContentLoaded
            sed -i '/DOMContentLoaded/,/});/ {
                /});/i\
  if (typeof DiagramUI !== "undefined") {\
    DiagramUI.initialize();\
  }
            }' js/main.js 2>/dev/null || sed -i '' '/DOMContentLoaded/,/});/ {
                /});/i\
  if (typeof DiagramUI !== "undefined") {\
    DiagramUI.initialize();\
  }
            }' js/main.js
        else
            # Add at the end of the file
            echo -e "\n// Initialize diagram UI when document is ready
document.addEventListener('DOMContentLoaded', function() {
  if (typeof DiagramUI !== 'undefined') {
    DiagramUI.initialize();
  }
});" >> js/main.js
        fi
    fi
else
    echo -e "\n${YELLOW}Step 4: No main.js found, skipping update.${NC}"
fi

# Step 5: Add documentation
echo -e "\n${YELLOW}Step 5: Adding Portnox deployment documentation...${NC}"
mkdir -p docs
cp portnox_deployment_checklist.md docs/
cp portnox_best_practices.md docs/

# Step 6: Verify installation
echo -e "\n${YELLOW}Step 6: Verifying installation...${NC}"

# Check for required files
files_ok=true
for file in js/diagrams/mxClient.js js/diagrams/diagram-generator.js js/diagrams/diagram-ui.js css/diagrams/diagram-styles.css; do
    if [ ! -f "$file" ]; then
        echo -e "${RED}Missing file: $file${NC}"
        files_ok=false
    fi
done

if $files_ok; then
    echo -e "${GREEN}All required files are present.${NC}"
else
    echo -e "${RED}Some required files are missing. Installation may be incomplete.${NC}"
fi

# Create simple test HTML file to verify diagrams work
cat > test_diagram.html << 'TESTHTML'
<!DOCTYPE html>
<html>
<head>
    <title>Portnox Diagram Test</title>
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">
    <link href="css/diagrams/grapheditor.css" rel="stylesheet">
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        #diagram-container { width: 100%; height: 600px; border: 1px solid #ddd; }
    </style>
</head>
<body>
    <h1>Portnox Diagram Test</h1>
    <p>This page tests if the diagram integration is working correctly.</p>
    
    <div id="diagram-container"></div>
    <div style="margin-top: 10px;">
        <button id="test-btn">Generate Test Diagram</button>
    </div>
    
    <script src="js/diagrams/mxClient.js"></script>
    <script src="js/diagrams/diagram-generator.js"></script>
    <script>
        document.getElementById('test-btn').addEventListener('click', function() {
            if (typeof DiagramGenerator !== 'undefined') {
                if (DiagramGenerator.initialize('diagram-container')) {
                    DiagramGenerator.generateDiagram({}, 'basic_deployment');
                    alert('Diagram generation successful!');
                } else {
                    alert('Failed to initialize diagram generator.');
                }
            } else {
                alert('DiagramGenerator not found. Integration may be incomplete.');
            }
        });
    </script>
</body>
</html>
TESTHTML

echo -e "${GREEN}Created test_diagram.html to verify functionality.${NC}"

# Final message
echo -e "\n${GREEN}===========================================================${NC}"
echo -e "${GREEN}  Portnox Cloud NAC Diagramming Integration Complete!      ${NC}"
echo -e "${GREEN}===========================================================${NC}"
echo -e "\n${BLUE}The following components have been added:${NC}"
echo -e "- Comprehensive diagram generator for Portnox Cloud NAC"
echo -e "- Support for multiple network vendors and device types"
echo -e "- Authentication flow visualizations"
echo -e "- BYOD and IoT device onboarding workflows"
echo -e "- Dynamic VLAN assignment diagrams"
echo -e "- Multi-cloud deployment scenarios"
echo -e "- Deployment checklists and best practices guides"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo -e "1. Open your UaXSupreme application in a browser"
echo -e "2. Navigate to the Documentation tab to access diagrams"
echo -e "3. If needed, open test_diagram.html to verify the installation"
echo -e "4. Customize the stencils and templates for your specific needs"

echo -e "\n${BLUE}For troubleshooting, check the browser console for any errors.${NC}"
echo -e "${BLUE}Documentation has been added to the docs/ directory.${NC}"
