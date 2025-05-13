#!/bin/bash

# Portnox Cloud NAC Diagrams Integration Script
# This script updates index.html and tests the integration

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}====================================================${NC}"
echo -e "${BLUE}  Portnox NAC Diagram Integration - Final Setup     ${NC}"
echo -e "${BLUE}====================================================${NC}"

# Update index.html if it exists
if [ -f "index.html" ]; then
    echo -e "${YELLOW}Updating index.html with diagram resources...${NC}"
    echo -e "${BLUE}Backing up original index.html to index.html.bak${NC}"
    cp index.html "index.html.bak.$(date +%Y%m%d%H%M%S)"
    
    # Inject CSS links
    if ! grep -q "css/diagrams/diagram-styles.css" index.html; then
        echo -e "${BLUE}Adding diagram CSS links to head section${NC}"
        sed -i -e '/<\/head>/ i\
    <!-- Portnox Diagram Styles -->\
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">' index.html
    fi
    
    # Inject JS scripts
    if ! grep -q "js/diagrams/mxClient.js" index.html; then
        echo -e "${BLUE}Adding diagram JS scripts before body end${NC}"
        sed -i -e '/<\/body>/ i\
    <!-- Portnox NAC Diagram Libraries -->\
    <script src="js/diagrams/mxClient.js"></script>\
    <script src="js/diagrams/diagram-generator.js"></script>\
    <script src="js/diagrams/diagram-ui.js"></script>\
    <script>\
      document.addEventListener("DOMContentLoaded", function() {\
        if (typeof PortnoxDiagramUI !== "undefined") {\
          PortnoxDiagramUI.initialize();\
        }\
      });\
    </script>' index.html
    fi
    
    echo -e "${GREEN}Successfully updated index.html${NC}"
else
    echo -e "${YELLOW}index.html not found. Skipping update.${NC}"
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

# Create a test page
if [ ! -f "test_portnox_diagrams.html" ]; then
    echo -e "${YELLOW}Creating a test page for Portnox diagrams...${NC}"
    
    cat > test_portnox_diagrams.html << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head>
    <title>Portnox Cloud NAC Diagrams</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="css/diagrams/diagram-styles.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            color: #333;
            background-color: #f8f9fa;
        }
        h1, h2 {
            color: #0078D4;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .btn {
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
        }
        .btn-primary {
            background-color: #0078D4;
            color: white;
            border: none;
        }
        .card {
            background-color: white;
            border-radius: 4px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .card-header {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .card-body {
            padding: 20px;
        }
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: -10px;
        }
        .col-md-6, .col-md-4, .col-md-3 {
            padding: 10px;
            box-sizing: border-box;
        }
        .col-md-6 {
            width: 50%;
        }
        .col-md-4 {
            width: 33.333333%;
        }
        .col-md-3 {
            width: 25%;
        }
        @media (max-width: 768px) {
            .col-md-6, .col-md-4, .col-md-3 {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Portnox Cloud NAC Diagrams</h1>
        <p>Interactive network diagrams for Portnox Cloud NAC deployment scenarios.</p>
        
        <div class="card">
            <div class="card-header">
                <h2 style="margin: 0;">Network Diagrams</h2>
                <button type="button" class="btn btn-primary" id="toggle-options">
                    <i class="fas fa-cog"></i> Options
                </button>
            </div>
            <div class="card-body">
                <div id="diagram-options">
                    <div class="row">
                        <div class="col-md-6">
                            <h3>Diagram Type</h3>
                            <div class="form-group">
                                <select class="form-control" id="diagram-type">
                                    <optgroup label="Deployment Scenarios">
                                        <option value="basic_cloud_deployment">Basic Cloud Deployment</option>
                                        <option value="enterprise_deployment">Enterprise Deployment</option>
                                        <option value="multi_vendor_deployment">Multi-Vendor Deployment</option>
                                        <option value="high_security_deployment">High Security Deployment</option>
                                        <option value="cloud_integration">Cloud Service Integration</option>
                                        <option value="multi_site_deployment">Multi-Site Deployment</option>
                                    </optgroup>
                                    <optgroup label="Industry Specific">
                                        <option value="healthcare_deployment">Healthcare Deployment</option>
                                        <option value="education_deployment">Education Deployment</option>
                                        <option value="retail_deployment">Retail Deployment</option>
                                        <option value="manufacturing_deployment">Manufacturing Deployment</option>
                                        <option value="government_deployment">Government Deployment</option>
                                        <option value="financial_deployment">Financial Services Deployment</option>
                                    </optgroup>
                                    <optgroup label="Authentication & Workflows">
                                        <option value="eap_tls_authentication">EAP-TLS Authentication Flow</option>
                                        <option value="byod_onboarding">BYOD Onboarding Flow</option>
                                        <option value="guest_access">Guest Access Portal</option>
                                        <option value="dynamic_vlan_assignment">Dynamic VLAN Assignment</option>
                                        <option value="iot_segmentation">IoT Segmentation</option>
                                    </optgroup>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="vendor-select">Network Equipment Vendor</label>
                                <select class="form-control" id="vendor-select">
                                    <option value="cisco">Cisco</option>
                                    <option value="aruba">Aruba</option>
                                    <option value="juniper">Juniper</option>
                                    <option value="extreme">Extreme</option>
                                    <option value="fortinet">Fortinet</option>
                                    <option value="paloalto">Palo Alto</option>
                                    <option value="hp">HP Enterprise</option>
                                    <option value="dell">Dell</option>
                                    <option value="arista">Arista</option>
                                </select>
                            </div>
                            <button id="generate-diagram-btn" class="btn btn-primary">
                                <i class="fas fa-project-diagram"></i> Generate Diagram
                            </button>
                        </div>
                        <div class="col-md-6">
                            <h3>Diagram Components</h3>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-radius" checked>
                                <label for="show-radius">Show RADIUS Server</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-auth" checked>
                                <label for="show-auth">Show Authentication Methods</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-clients" checked>
                                <label for="show-clients">Show Client Devices</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-cloud" checked>
                                <label for="show-cloud">Show Cloud Services</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-legends" checked>
                                <label for="show-legends">Show Legends & Notes</label>
                            </div>
                            <div style="margin-bottom: 10px;">
                                <input type="checkbox" id="show-detailed" checked>
                                <label for="show-detailed">Show Detailed Components</label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="diagram-status" class="alert" style="display: none; padding: 10px; margin: 15px 0; border-radius: 4px;"></div>
                
                <div id="diagram-container" class="diagram-container" style="display: none;">
                    <div class="diagram-toolbar">
                        <button id="zoom-in-btn" title="Zoom In">
                            <i class="fas fa-search-plus"></i>
                        </button>
                        <button id="zoom-out-btn" title="Zoom Out">
                            <i class="fas fa-search-minus"></i>
                        </button>
                        <button id="zoom-reset-btn" title="Reset Zoom">
                            <i class="fas fa-compress"></i>
                        </button>
                        <span class="toolbar-separator"></span>
                        <button id="export-png-btn" title="Export as PNG">
                            <i class="fas fa-file-image"></i> PNG
                        </button>
                        <button id="export-svg-btn" title="Export as SVG">
                            <i class="fas fa-file-code"></i> SVG
                        </button>
                    </div>
                    <div id="diagram-canvas" class="diagram-canvas"></div>
                </div>
                
                <h3 style="margin-top: 20px;">Recommended Diagrams</h3>
                <div class="row">
                    <div class="col-md-4">
                        <div class="template-card" data-template="basic_cloud_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-network-wired"></i>
                            </div>
                            <div class="template-title">Basic Cloud Deployment</div>
                            <div class="template-description">Standard Portnox Cloud NAC deployment</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="template-card" data-template="eap_tls_authentication">
                            <div class="template-thumbnail">
                                <i class="fas fa-key"></i>
                            </div>
                            <div class="template-title">EAP-TLS Authentication</div>
                            <div class="template-description">Certificate-based authentication flow</div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="template-card" data-template="dynamic_vlan_assignment">
                            <div class="template-thumbnail">
                                <i class="fas fa-project-diagram"></i>
                            </div>
                            <div class="template-title">Dynamic VLAN Assignment</div>
                            <div class="template-description">Role and device-based segmentation</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Load diagram libraries -->
    <script src="js/diagrams/mxClient.js"></script>
    <script src="js/diagrams/diagram-generator.js"></script>
    <script src="js/diagrams/diagram-ui.js"></script>
    <script>
        // Initialize diagram UI
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize UI
            if (typeof PortnoxDiagramUI !== 'undefined') {
                PortnoxDiagramUI.initialize();
            }
            
            // Toggle options panel
            const toggleBtn = document.getElementById('toggle-options');
            const optionsPanel = document.getElementById('diagram-options');
            
            if (toggleBtn && optionsPanel) {
                toggleBtn.addEventListener('click', function() {
                    if (optionsPanel.style.display === 'none') {
                        optionsPanel.style.display = 'block';
                        toggleBtn.innerHTML = '<i class="fas fa-times"></i> Hide Options';
                    } else {
                        optionsPanel.style.display = 'none';
                        toggleBtn.innerHTML = '<i class="fas fa-cog"></i> Options';
                    }
                });
            }
        });
    </script>
</body>
</html>
HTMLEOF

    echo -e "${GREEN}Test page created: test_portnox_diagrams.html${NC}"
fi

echo -e "${GREEN}Integration complete! To test the diagrams, open:${NC}"
echo -e "${BLUE}test_portnox_diagrams.html${NC}"

echo -e "\n${YELLOW}What to do next:${NC}"
echo -e "1. Open the test page to verify diagram functionality"
echo -e "2. Check that all icons and stencils are working properly"
echo -e "3. Try generating and exporting diagrams for different scenarios"
echo -e "4. Review industry-specific deployments for your environment"

echo -e "\n${GREEN}For any issues, check the browser console for error messages${NC}"
