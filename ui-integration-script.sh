#!/bin/bash
# UI Integration Script for Best Practices Module

# Set color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Print banner
echo -e "${GREEN}"
echo "============================================================"
echo "    Best Practices UI Integration Script                    "
echo "============================================================"
echo -e "${NC}"

# Define base directory (default to current directory)
BASE_DIR="."
if [ ! -z "$1" ]; then
    BASE_DIR="$1"
fi

# Function to complete the Best Practices Integration
complete_integration() {
    echo -e "\n${YELLOW}Completing the Best Practices UI integration...${NC}"
    
    # 1. Add script imports to index.html
    echo -e "\n${YELLOW}Adding script imports to index.html...${NC}"
    if [ -f "$BASE_DIR/index.html" ]; then
        # Check if scripts are already added
        if grep -q "bestPracticesIntegration.js" "$BASE_DIR/index.html"; then
            echo -e "${GREEN}Best Practices scripts already imported in index.html${NC}"
        else
            # Add scripts before closing body tag
            sed -i 's|</body>|    <!-- Best Practices Integration -->\n    <script src="js/bestPracticesIntegration.js"></script>\n</body>|' "$BASE_DIR/index.html"
            echo -e "${GREEN}✓ Added Best Practices scripts to index.html${NC}"
        fi
    else
        echo -e "${RED}Error: index.html not found in $BASE_DIR${NC}"
    fi
    
    # 2. Add the AI Review Modal to index.html
    echo -e "\n${YELLOW}Adding AI Review Modal to index.html...${NC}"
    if [ -f "$BASE_DIR/index.html" ]; then
        # Check if modal is already added
        if grep -q "ai-review-modal" "$BASE_DIR/index.html"; then
            echo -e "${GREEN}AI Review Modal already added to index.html${NC}"
        else
            # Add modal before closing body tag
            sed -i 's|</body>|    <!-- AI Review Modal -->\n    <div id="ai-review-modal" class="modal-overlay">\n        <div class="modal-container ai-assistant-review-modal">\n            <div class="modal-header">\n                <h2>AI Assistant Configuration Review</h2>\n                <button id="ai-review-modal-close" class="modal-close">&times;</button>\n            </div>\n            <div class="modal-body">\n                <!-- Content will be added dynamically -->\n                <p>Analyzing configuration with AI assistant...</p>\n                <div class="loader"></div>\n            </div>\n            <div class="modal-footer">\n                <button id="ai-review-close" class="btn">Close</button>\n            </div>\n        </div>\n    </div>\n</body>|' "$BASE_DIR/index.html"
            echo -e "${GREEN}✓ Added AI Review Modal to index.html${NC}"
        fi
    else
        echo -e "${RED}Error: index.html not found in $BASE_DIR${NC}"
    fi
    
    # 3. Update config-generator.js to integrate with Best Practices
    echo -e "\n${YELLOW}Updating config-generator.js...${NC}"
    if [ -f "$BASE_DIR/js/config-generator.js" ]; then
        # Create backup
        cp "$BASE_DIR/js/config-generator.js" "$BASE_DIR/js/config-generator.js.bak"
        echo -e "${GREEN}✓ Created backup of config-generator.js${NC}"
        
        # Update the file
        if grep -q "exportEnhancedConfiguration" "$BASE_DIR/js/config-generator.js"; then
            echo -e "${GREEN}Best Practices integration already added to config-generator.js${NC}"
        else
            # Add import at the top if it's using module syntax
            if grep -q "import " "$BASE_DIR/js/config-generator.js"; then
                sed -i '1i\
// Import Best Practices Integration\n\
import { generateRecommendations, applyRecommendations, exportEnhancedConfiguration } from "./bestPracticesIntegration.js";\n' "$BASE_DIR/js/config-generator.js"
            fi
            
            # Modify the setupConfigGeneratorEvents function
            sed -i '/setupConfigGeneratorEvents/,/}/s/const exportDocBtn = document.getElementById(.*)export-documentation(.*);\s*if (exportDocBtn) {\s*exportDocBtn.addEventListener(.*)click(.*)function(.*){\s*/const exportDocBtn = document.getElementById("export-documentation");\n    if (exportDocBtn) {\n        exportDocBtn.addEventListener("click", function(e) {\n            // First enhance the configuration with best practices\n            let enhancedConfig;\n            try {\n                enhancedConfig = exportEnhancedConfiguration();\n                window.enhancedConfig = enhancedConfig;\n            } catch (error) {\n                console.error("Error enhancing configuration:", error);\n            }\n            /' "$BASE_DIR/js/config-generator.js"
            
            echo -e "${GREEN}✓ Updated config-generator.js to integrate with Best Practices${NC}"
        fi
    else
        echo -e "${RED}Error: config-generator.js not found in $BASE_DIR/js${NC}"
    fi
    
    # 4. Update document-generator.js to include best practices in exports
    echo -e "\n${YELLOW}Updating document-generator.js...${NC}"
    if [ -f "$BASE_DIR/js/document-generator.js" ]; then
        # Create backup
        cp "$BASE_DIR/js/document-generator.js" "$BASE_DIR/js/document-generator.js.bak"
        echo -e "${GREEN}✓ Created backup of document-generator.js${NC}"
        
        # Update the file
        if grep -q "Best Practices Applied" "$BASE_DIR/js/document-generator.js"; then
            echo -e "${GREEN}Best Practices section already added to document-generator.js${NC}"
        else
            # Find the export function and add best practices section
            sed -i '/function exportDocumentation/,/}/s/const configOutput = document.getElementById(.*)config-output(.*);\s*const config = configOutput \? configOutput.textContent : (.*);\s*/    // Check if we have an enhanced configuration\n    let configText = "";\n    if (window.enhancedConfig) {\n        configText = window.enhancedConfig;\n        window.enhancedConfig = null; // Clear it after use\n    } else {\n        // Get the normal configuration\n        const configOutput = document.getElementById("config-output");\n        configText = configOutput ? configOutput.textContent : "";\n    }\n\n/' "$BASE_DIR/js/document-generator.js"
            
            # Find where to add the best practices section
            sed -i '/documentContent += (.*)Configuration(.*);\s*documentContent += config;/a\
    // Add a best practices section to the document\n    documentContent += "\\n\\n## Best Practices Applied\\n\\n";\n    \n    // Get security score if available\n    const scoreElement = document.getElementById("security-score-value");\n    const securityScore = scoreElement ? scoreElement.textContent : "N/A";\n    \n    documentContent += `Security Score: ${securityScore}/100\\n\\n`;\n    \n    // Add applied recommendations\n    documentContent += "### Applied Recommendations\\n\\n";\n    \n    const appliedItems = document.querySelectorAll(".expandable-item.applied");\n    if (appliedItems.length > 0) {\n        appliedItems.forEach(item => {\n            const header = item.querySelector(".expandable-item-header h4");\n            const priority = item.querySelector(".priority-badge");\n            \n            documentContent += `- ${header.textContent} (Priority: ${priority.textContent})\\n`;\n        });\n    } else {\n        documentContent += "No specific recommendations were applied.\\n";\n    }' "$BASE_DIR/js/document-generator.js"
            
            echo -e "${GREEN}✓ Updated document-generator.js to include Best Practices in exports${NC}"
        fi
    else
        echo -e "${RED}Error: document-generator.js not found in $BASE_DIR/js${NC}"
    fi
    
    # 5. Replace the preview tab with the updated version that includes the best practices subtab
    echo -e "\n${YELLOW}Updating the preview tab in index.html...${NC}"
    if [ -f "$BASE_DIR/index.html" ]; then
        # Check if the best practices subtab is already added
        if grep -q "best-practices-tab" "$BASE_DIR/index.html"; then
            echo -e "${GREEN}Best Practices subtab already added to index.html${NC}"
        else
            # This is more complex and might require manual editing
            echo -e "${YELLOW}Note: The preview tab update is complex and may require manual editing.${NC}"
            echo -e "${YELLOW}Please refer to the template at $BASE_DIR/preview-tab-update.html${NC}"
            
            # Create a script to attempt the update
            cat > "$BASE_DIR/update-preview-tab.sh" << 'EOSCRIPT'
#!/bin/bash
# This script attempts to update the preview tab in index.html

# Define base directory
BASE_DIR="."
if [ ! -z "$1" ]; then
    BASE_DIR="$1"
fi

# Create a temporary file
TEMP_FILE=$(mktemp)

# Extract the preview tab from preview-tab-update.html
cat "$BASE_DIR/preview-tab-update.html" > "$TEMP_FILE"

# Try to replace the preview tab in index.html
sed -i '/<div class="tab-pane" id="preview">/,/<\/div><!--.*preview.*-->/c\
'"$(cat $TEMP_FILE)" "$BASE_DIR/index.html"

# Clean up
rm "$TEMP_FILE"

echo "Preview tab update attempted. Please check index.html to verify the changes."
EOSCRIPT
            
            chmod +x "$BASE_DIR/update-preview-tab.sh"
            echo -e "${YELLOW}Created update-preview-tab.sh script to attempt preview tab update${NC}"
            echo -e "${YELLOW}Run: ./update-preview-tab.sh to try automating this step, but manual verification is recommended${NC}"
        fi
    else
        echo -e "${RED}Error: index.html not found in $BASE_DIR${NC}"
    fi
    
    echo -e "\n${GREEN}UI Integration steps completed.${NC}"
    echo -e "${YELLOW}Note: Some steps may require manual verification or editing.${NC}"
    echo -e "${YELLOW}Please check the updated files to ensure proper integration.${NC}"
}

# Execute the integration function
complete_integration

echo -e "\n${GREEN}================================================${NC}"
echo -e "${GREEN}Best Practices UI Integration Complete!${NC}"
echo -e "${GREEN}================================================${NC}"
echo -e "\nThe following files have been modified:"
echo -e " - index.html: Added script imports and AI Review Modal"
echo -e " - config-generator.js: Integrated with Best Practices"
echo -e " - document-generator.js: Added Best Practices section to exports"
echo -e "\n${YELLOW}IMPORTANT:${NC} Please verify the changes and complete any manual steps as needed."
echo -e "Refer to INSTALLATION.md for additional guidance.\n"
