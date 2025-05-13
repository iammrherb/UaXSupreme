#!/bin/bash
# UaXSupreme Enhancement Script
# Version: 2.0.1
# Description: Comprehensive enhancement for UaXSupreme including draw.io integration,
# vendor-specific optimizations, AI integration, and improved user experience

# Set color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script configuration
BASE_DIR="$(pwd)"
BACKUP_DIR="${BASE_DIR}/backups/$(date +%Y%m%d%H%M%S)"
LOG_FILE="${BASE_DIR}/uaxenhance_$(date +%Y%m%d%H%M%S).log"
TEMP_DIR="${BASE_DIR}/.temp"
AI_CONFIG_FILE="${BASE_DIR}/config/ai_integration.json"

# Initialize log file
mkdir -p "$(dirname "$LOG_FILE")"
echo "UaXSupreme Enhancement Log - $(date)" > "$LOG_FILE"

# Function for logging
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    echo "${timestamp} [${level}] ${message}" >> "$LOG_FILE"
    
    case "$level" in
        "INFO")
            echo -e "${BLUE}[INFO] ${message}${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS] ${message}${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING] ${message}${NC}"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR] ${message}${NC}"
            ;;
        "STEP")
            echo -e "${CYAN}${BOLD}[STEP] ${message}${NC}"
            ;;
    esac
}

# Function to create backup
create_backup() {
    log "STEP" "Creating backup of current installation..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Backup main files
    cp -r index.html css js lib templates "$BACKUP_DIR/" 2>/dev/null
    
    # Backup configuration files
    if [ -d "config" ]; then
        cp -r config "$BACKUP_DIR/" 2>/dev/null
    fi
    
    # Backup custom stencils
    if [ -d "images/stencils" ]; then
        mkdir -p "$BACKUP_DIR/images"
        cp -r images/stencils "$BACKUP_DIR/images/" 2>/dev/null
    fi
    
    log "SUCCESS" "Backup created at $BACKUP_DIR"
}

# Function to check dependencies
check_dependencies() {
    log "STEP" "Checking dependencies..."
    
    local missing_deps=0
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        log "WARNING" "curl is not installed. Required for downloading components."
        missing_deps=$((missing_deps + 1))
    fi
    
    # Check for node/npm
    if ! command -v node &> /dev/null; then
        log "WARNING" "Node.js is not installed. Required for JavaScript processing."
        missing_deps=$((missing_deps + 1))
    fi
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        log "WARNING" "jq is not installed. Required for JSON processing."
        missing_deps=$((missing_deps + 1))
    fi
    
    if [ $missing_deps -gt 0 ]; then
        log "ERROR" "$missing_deps dependencies are missing. Please install them before continuing."
        echo -e "${YELLOW}You can install dependencies on Ubuntu/Debian with:${NC}"
        echo "  sudo apt update && sudo apt install -y curl nodejs npm jq"
        echo -e "${YELLOW}You can install dependencies on CentOS/RHEL with:${NC}"
        echo "  sudo yum install -y curl nodejs npm jq"
        echo -e "${YELLOW}You can install dependencies on macOS with:${NC}"
        echo "  brew install curl node jq"
        return 1
    fi
    
    log "SUCCESS" "All dependencies are installed"
    return 0
}

# Function to enhance draw.io diagram integration
enhance_diagram_integration() {
    log "STEP" "Enhancing draw.io diagram integration..."
    
    # Create diagrams directory if it doesn't exist
    mkdir -p "${BASE_DIR}/diagrams/templates"
    mkdir -p "${BASE_DIR}/diagrams/custom"
    mkdir -p "${BASE_DIR}/diagrams/vendor"
    
    # Create vendor-specific diagram directories
    local vendors=("cisco" "aruba" "juniper" "fortinet" "extreme" "paloalto" "hp" "dell")
    for vendor in "${vendors[@]}"; do
        mkdir -p "${BASE_DIR}/diagrams/vendor/${vendor}"
        
        # Create authentication topology templates for each vendor
        cat > "${BASE_DIR}/diagrams/vendor/${vendor}/auth_topology.xml" << EOF
<mxfile host="app.diagrams.net" modified="$(date +%Y%m%d%H%M%S)" agent="UaXSupreme" version="15.3.5">
  <diagram id="authentication_topology_${vendor}" name="${vendor^} Authentication Topology">
    <mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1169" pageHeight="827" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- This is a template for ${vendor^} authentication topology -->
        <!-- Add custom elements in the UaXSupreme interface -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
EOF
    done
    
    # Create authentication flow diagram template
    cat > "${BASE_DIR}/diagrams/templates/authentication_flow.xml" << 'EOF'
<mxfile host="app.diagrams.net" modified="20250424000000" agent="UaXSupreme" version="15.3.5">
  <diagram id="authentication_flow" name="802.1X Authentication Flow">
    <mxGraphModel dx="1422" dy="762" grid="1" gridSize="10" guides="1" tooltips="1" connect="1" arrows="1" fold="1" page="1" pageScale="1" pageWidth="1169" pageHeight="827" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <!-- Supplicant -->
        <mxCell id="supplicant" value="Supplicant&#xa;(Client Device)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#dae8fc;strokeColor=#6c8ebf;" vertex="1" parent="1">
          <mxGeometry x="120" y="200" width="120" height="60" as="geometry" />
        </mxCell>
        <!-- Authenticator -->
        <mxCell id="authenticator" value="Authenticator&#xa;(Network Device)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#d5e8d4;strokeColor=#82b366;" vertex="1" parent="1">
          <mxGeometry x="440" y="200" width="120" height="60" as="geometry" />
        </mxCell>
        <!-- Authentication Server -->
        <mxCell id="auth_server" value="Authentication Server&#xa;(RADIUS)" style="rounded=1;whiteSpace=wrap;html=1;fillColor=#ffe6cc;strokeColor=#d79b00;" vertex="1" parent="1">
          <mxGeometry x="760" y="200" width="120" height="60" as="geometry" />
        </mxCell>
        <!-- EAPoL Start -->
        <mxCell id="eapol_start" value="" style="endArrow=classic;html=1;exitX=1;exitY=0.25;exitDx=0;exitDy=0;entryX=0;entryY=0.25;entryDx=0;entryDy=0;" edge="1" parent="1" source="supplicant" target="authenticator">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="390" y="430" as="sourcePoint" />
            <mxPoint x="440" y="380" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="eapol_start_label" value="1. EAPoL Start" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" vertex="1" connectable="0" parent="eapol_start">
          <mxGeometry x="-0.1556" y="-1" relative="1" as="geometry">
            <mxPoint as="offset" />
          </mxGeometry>
        </mxCell>
        <!-- EAP Request Identity -->
        <mxCell id="eap_req_id" value="" style="endArrow=classic;html=1;exitX=0;exitY=0.4;exitDx=0;exitDy=0;entryX=1;entryY=0.4;entryDx=0;entryDy=0;" edge="1" parent="1" source="authenticator" target="supplicant">
          <mxGeometry width="50" height="50" relative="1" as="geometry">
            <mxPoint x="390" y="430" as="sourcePoint" />
            <mxPoint x="440" y="380" as="targetPoint" />
          </mxGeometry>
        </mxCell>
        <mxCell id="eap_req_id_label" value="2. EAP Request Identity" style="edgeLabel;html=1;align=center;verticalAlign=middle;resizable=0;points=[];" vertex="1" connectable="0" parent="eap_req_id">
          <mxGeometry x="0.1111" y="1" relative="1" as="geometry">
            <mxPoint as="offset" />
          </mxGeometry>
        </mxCell>
        <!-- More flow elements will be added dynamically -->
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>
EOF

    # Create HTML integration file for diagrams
    cat > "${BASE_DIR}/diagrams/diagram_integration.js" << 'EOF'
/**
 * UaXSupreme Diagram Integration
 * Provides draw.io integration for network authentication diagrams
 */

class UaxDiagramGenerator {
    constructor() {
        this.diagrams = {};
        this.currentVendor = '';
        this.currentDiagram = null;
        this.loadedTemplates = {};
    }

    /**
     * Initialize the diagram generator
     */
    async init() {
        try {
            // Load the draw.io iframe API
            await this.loadDrawioApi();
            
            // Initialize diagrams
            this.initializeDiagramLibrary();
            
            console.log("UaxDiagramGenerator initialized successfully");
            return true;
        } catch (error) {
            console.error("Failed to initialize diagram generator:", error);
            return false;
        }
    }

    /**
     * Load the draw.io iframe API
     */
    loadDrawioApi() {
        return new Promise((resolve, reject) => {
            const script = document.createElement('script');
            script.src = 'https://embed.diagrams.net/js/viewer.min.js';
            script.onload = () => resolve();
            script.onerror = () => reject(new Error('Failed to load draw.io API'));
            document.head.appendChild(script);
        });
    }

    /**
     * Initialize diagram library
     */
    async initializeDiagramLibrary() {
        // Load template diagrams
        try {
            const templates = [
                'authentication_flow',
                'radius_server_deployment',
                'tacacs_server_deployment',
                'byod_flow',
                'guest_access_flow',
                'network_segmentation'
            ];
            
            for (const template of templates) {
                await this.loadDiagramTemplate(template);
            }
        } catch (error) {
            console.error("Error initializing diagram library:", error);
        }
    }

    /**
     * Load a diagram template
     */
    async loadDiagramTemplate(templateName) {
        try {
            const response = await fetch(`diagrams/templates/${templateName}.xml`);
            if (response.ok) {
                const xmlContent = await response.text();
                this.loadedTemplates[templateName] = xmlContent;
            } else {
                console.warn(`Template ${templateName} not found, using default`);
                // Create a basic template as fallback
                this.loadedTemplates[templateName] = this.createBasicTemplate(templateName);
            }
        } catch (error) {
            console.error(`Error loading template ${templateName}:`, error);
            this.loadedTemplates[templateName] = this.createBasicTemplate(templateName);
        }
    }

    /**
     * Create a basic template as fallback
     */
    createBasicTemplate(templateName) {
        const title = templateName.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
        
        return `<mxfile host="app.diagrams.net" modified="${Date.now()}" agent="UaXSupreme">
  <diagram id="${templateName}" name="${title}">
    <mxGraphModel dx="1422" dy="762" grid="1" guides="1" tooltips="1" connect="1" arrows="1" fold="1">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="title" value="${title}" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=24;fontStyle=1" vertex="1" parent="1">
          <mxGeometry x="350" y="20" width="400" height="40" as="geometry" />
        </mxCell>
        <mxCell id="note" value="This is a placeholder diagram. Add elements in the editor." style="shape=note;strokeWidth=2;fontSize=14;size=20;whiteSpace=wrap;html=1;fillColor=#fff2cc;strokeColor=#d6b656;fontColor=#666600;align=center;" vertex="1" parent="1">
          <mxGeometry x="350" y="100" width="400" height="100" as="geometry" />
        </mxCell>
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>`;
    }

    /**
     * Generate an authentication flow diagram for a specific vendor
     */
    generateAuthFlowDiagram(vendor, container, config) {
        this.currentVendor = vendor.toLowerCase();
        
        if (!container) {
            console.error("No container specified for diagram");
            return false;
        }
        
        // Clear the container
        container.innerHTML = '';
        
        // Create the iframe for the diagram
        const iframe = document.createElement('iframe');
        iframe.style.width = '100%';
        iframe.style.height = '600px';
        iframe.style.border = '1px solid #ccc';
        container.appendChild(iframe);
        
        // Get the diagram template
        let diagramXml = this.loadedTemplates['authentication_flow'] || this.createBasicTemplate('authentication_flow');
        
        // Customize the diagram based on vendor and config
        diagramXml = this.customizeDiagramForVendor(diagramXml, vendor, config);
        
        // Initialize the diagram editor
        const editor = new GraphEditor(iframe);
        editor.openDiagram(diagramXml, 'authentication_flow');
        
        this.currentDiagram = editor;
        return editor;
    }

    /**
     * Customize diagram for specific vendor
     */
    customizeDiagramForVendor(diagramXml, vendor, config) {
        // This would contain vendor-specific customizations
        // For now we'll just add a vendor label to the diagram
        
        const parser = new DOMParser();
        const xmlDoc = parser.parseFromString(diagramXml, "text/xml");
        
        // Find the root cell
        const root = xmlDoc.querySelector('root');
        
        if (root) {
            // Add vendor title
            const titleCell = `
                <mxCell id="vendor_title" value="${vendor.toUpperCase()} Authentication" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=20;fontStyle=1" vertex="1" parent="1">
                    <mxGeometry x="350" y="20" width="400" height="40" as="geometry" />
                </mxCell>
            `;
            
            root.innerHTML += titleCell;
            
            // Add configuration details based on passed config
            if (config) {
                let configDetails = '';
                for (const [key, value] of Object.entries(config)) {
                    if (typeof value !== 'object') {
                        configDetails += `${key}: ${value}\\n`;
                    }
                }
                
                if (configDetails) {
                    const configCell = `
                        <mxCell id="config_details" value="Configuration:\\n${configDetails}" style="shape=note;strokeWidth=2;fontSize=12;size=20;whiteSpace=wrap;html=1;fillColor=#f5f5f5;strokeColor=#666666;fontColor=#333333;align=left;" vertex="1" parent="1">
                            <mxGeometry x="760" y="300" width="200" height="150" as="geometry" />
                        </mxCell>
                    `;
                    
                    root.innerHTML += configCell;
                }
            }
        }
        
        // Convert back to string
        const serializer = new XMLSerializer();
        return serializer.serializeToString(xmlDoc);
    }

    /**
     * Generate a RADIUS server deployment diagram
     */
    generateRadiusDeploymentDiagram(container, config) {
        // Similar to the auth flow diagram but with RADIUS-specific template
        // Implementation would be similar to generateAuthFlowDiagram
    }

    /**
     * Export the current diagram to PNG
     */
    exportDiagramToPng() {
        if (this.currentDiagram) {
            this.currentDiagram.exportImage('png');
        } else {
            console.error("No active diagram to export");
        }
    }

    /**
     * Export the current diagram to XML
     */
    exportDiagramToXml() {
        if (this.currentDiagram) {
            return this.currentDiagram.getXml();
        } else {
            console.error("No active diagram to export");
            return null;
        }
    }
}

// Initialize the diagram generator when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.uaxDiagramGenerator = new UaxDiagramGenerator();
    window.uaxDiagramGenerator.init();
});
EOF

    # Make sure the JavaScript is included in index.html
    if ! grep -q "diagram_integration.js" "${BASE_DIR}/index.html"; then
        # Add the script inclusion before the closing body tag
        sed -i.bak "/<\/body>/i <script src=\"diagrams\/diagram_integration.js\"></script>" "${BASE_DIR}/index.html"
    fi
    
    # Copy enhanced diagram generation script
    cat > "${BASE_DIR}/enhanced-diagram.sh" << 'EOF'
#!/bin/bash
# Enhanced diagram generation script for UaXSupreme
# Handles generation of all authentication-related diagrams

# Set color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
BASE_DIR="$(pwd)"
DIAGRAM_DIR="${BASE_DIR}/diagrams"
OUTPUT_DIR="${BASE_DIR}/output/diagrams"
CONFIG_FILE="${BASE_DIR}/config/diagram_config.json"

# Make sure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Check if config file exists, create if not
if [ ! -f "$CONFIG_FILE" ]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo '{
    "vendors": ["cisco", "aruba", "juniper", "fortinet", "extreme", "paloalto", "hp", "dell"],
    "diagramTypes": ["authentication_flow", "radius_deployment", "tacacs_deployment", "byod_flow", "guest_flow"],
    "outputFormat": "png",
    "includeLegend": true,
    "includeTimestamp": true
}' > "$CONFIG_FILE"
fi

# Function to generate a diagram
generate_diagram() {
    local vendor="$1"
    local diagram_type="$2"
    local output_format="${3:-png}"
    
    echo -e "${BLUE}Generating ${diagram_type} diagram for ${vendor^}...${NC}"
    
    # Check if template exists
    local template_file="${DIAGRAM_DIR}/vendor/${vendor}/${diagram_type}.xml"
    local default_template="${DIAGRAM_DIR}/templates/${diagram_type}.xml"
    local target_file="${OUTPUT_DIR}/${vendor}_${diagram_type}.${output_format}"
    
    if [ -f "$template_file" ]; then
        echo -e "${GREEN}Using vendor-specific template${NC}"
        # Here we would actually convert the XML to PNG/SVG using draw.io CLI
        # For this script, we'll just copy the XML as this is a demonstration
        cp "$template_file" "${target_file%.${output_format}}.xml"
    elif [ -f "$default_template" ]; then
        echo -e "${YELLOW}Using default template${NC}"
        cp "$default_template" "${target_file%.${output_format}}.xml"
    else
        echo -e "${RED}No template found for ${diagram_type}${NC}"
        return 1
    fi
    
    echo -e "${GREEN}Diagram generated at ${target_file%.${output_format}}.xml${NC}"
    echo "To convert to ${output_format}, use the UaXSupreme web interface"
    
    return 0
}

# Main execution
echo -e "${BLUE}UaXSupreme Diagram Generator${NC}"
echo "=========================="

# Load configuration
if [ -f "$CONFIG_FILE" ]; then
    vendors=$(jq -r '.vendors | join(" ")' "$CONFIG_FILE")
    diagram_types=$(jq -r '.diagramTypes | join(" ")' "$CONFIG_FILE")
    output_format=$(jq -r '.outputFormat' "$CONFIG_FILE")
else
    # Default values if config doesn't exist
    vendors="cisco aruba juniper"
    diagram_types="authentication_flow radius_deployment"
    output_format="png"
fi

# Check command line arguments
if [ "$1" = "--all" ]; then
    # Generate all diagrams for all vendors
    for vendor in $vendors; do
        for diagram_type in $diagram_types; do
            generate_diagram "$vendor" "$diagram_type" "$output_format"
        done
    done
elif [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    echo "Usage:"
    echo "  $0 --all                      Generate all diagrams for all vendors"
    echo "  $0 --vendor VENDOR            Generate all diagrams for specific vendor"
    echo "  $0 --type TYPE                Generate specific diagram for all vendors"
    echo "  $0 --vendor VENDOR --type TYPE Generate specific diagram for specific vendor"
    echo "  $0 --help                     Show this help message"
    exit 0
elif [ "$1" = "--vendor" ]; then
    if [ -z "$2" ]; then
        echo -e "${RED}Error: No vendor specified${NC}"
        exit 1
    fi
    
    if [ "$3" = "--type" ]; then
        if [ -z "$4" ]; then
            echo -e "${RED}Error: No diagram type specified${NC}"
            exit 1
        fi
        # Generate specific diagram for specific vendor
        generate_diagram "$2" "$4" "$output_format"
    else
        # Generate all diagrams for specific vendor
        for diagram_type in $diagram_types; do
            generate_diagram "$2" "$diagram_type" "$output_format"
        done
    fi
elif [ "$1" = "--type" ]; then
    if [ -z "$2" ]; then
        echo -e "${RED}Error: No diagram type specified${NC}"
        exit 1
    fi
    
    # Generate specific diagram for all vendors
    for vendor in $vendors; do
        generate_diagram "$vendor" "$2" "$output_format"
    done
else
    echo -e "${YELLOW}No options specified. Use --help for usage information.${NC}"
    exit 1
fi

echo -e "${GREEN}Diagram generation complete!${NC}"
exit 0
EOF

    # Make the script executable
    chmod +x "${BASE_DIR}/enhanced-diagram.sh"
    
    log "SUCCESS" "Diagram integration enhanced successfully"
}

# Function to implement vendor-specific templates and configurations
implement_vendor_templates() {
    log "STEP" "Implementing vendor-specific templates and configurations..."
    
    # Create templates directory if it doesn't exist
    mkdir -p "${BASE_DIR}/templates/vendor"
    
    # Define vendors
    local vendors=("cisco" "aruba" "juniper" "fortinet" "extreme" "paloalto" "hp" "dell")
    
    # Create vendor-specific directories
    for vendor in "${vendors[@]}"; do
        mkdir -p "${BASE_DIR}/templates/vendor/${vendor}"
    done
    
    # Create vendor selection UI enhancements
    create_vendor_selection_ui
    
    log "SUCCESS" "Vendor-specific templates implemented successfully"
}

# Function to create vendor selection UI
create_vendor_selection_ui() {
    # Create a JavaScript file for enhanced vendor selection UI
    mkdir -p "${BASE_DIR}/js"
    
    cat > "${BASE_DIR}/js/vendor-selection.js" << 'EOF'
/**
 * UaXSupreme Vendor Selection UI
 * Enhanced vendor selection with platform-specific options
 */
 
document.addEventListener('DOMContentLoaded', function() {
    initializeVendorSelection();
});

// Global variables
let currentVendor = '';
let currentPlatform = '';
let vendorData = {};

/**
 * Initialize the vendor selection UI
 */
function initializeVendorSelection() {
    // Load vendor data
    fetch('templates/vendor_data.json')
        .then(response => response.json())
        .then(data => {
            vendorData = data;
            populateVendorSelector();
            setupEventListeners();
        })
        .catch(error => {
            console.error('Error loading vendor data:', error);
            // Create fallback vendor data
            vendorData = createFallbackVendorData();
            populateVendorSelector();
            setupEventListeners();
        });
}

/**
 * Create fallback vendor data if the JSON file can't be loaded
 */
function createFallbackVendorData() {
    return {
        "vendors": [
            {
                "id": "cisco",
                "name": "Cisco",
                "logo": "images/stencils/cisco/cisco_logo.png",
                "platforms": [
                    { "id": "ios", "name": "IOS" },
                    { "id": "ios-xe", "name": "IOS XE" },
                    { "id": "ios-xr", "name": "IOS XR" },
                    { "id": "nx-os", "name": "NX-OS" },
                    { "id": "catalyst", "name": "Catalyst" }
                ]
            },
            {
                "id": "aruba",
                "name": "Aruba",
                "logo": "images/stencils/aruba/aruba_logo.png",
                "platforms": [
                    { "id": "aos-cx", "name": "AOS-CX" },
                    { "id": "aos-switch", "name": "AOS-Switch" },
                    { "id": "mobility-controller", "name": "Mobility Controller" }
                ]
            },
            {
                "id": "juniper",
                "name": "Juniper",
                "logo": "images/stencils/juniper/juniper_logo.png",
                "platforms": [
                    { "id": "junos", "name": "Junos" },
                    { "id": "srx", "name": "SRX" },
                    { "id": "ex", "name": "EX Series" },
                    { "id": "mx", "name": "MX Series" },
                    { "id": "qfx", "name": "QFX Series" }
                ]
            },
            {
                "id": "fortinet",
                "name": "Fortinet",
                "logo": "images/stencils/fortinet/fortinet_logo.png",
                "platforms": [
                    { "id": "fortigate", "name": "FortiGate" },
                    { "id": "fortiswitch", "name": "FortiSwitch" },
                    { "id": "fortiauthenticator", "name": "FortiAuthenticator" }
                ]
            },
            {
                "id": "paloalto",
                "name": "Palo Alto",
                "logo": "images/stencils/paloalto/paloalto_logo.png",
                "platforms": [
                    { "id": "panos", "name": "PAN-OS" },
                    { "id": "panorama", "name": "Panorama" }
                ]
            },
            {
                "id": "extreme",
                "name": "Extreme",
                "logo": "images/stencils/extreme/extreme_logo.png",
                "platforms": [
                    { "id": "exos", "name": "EXOS" },
                    { "id": "voss", "name": "VOSS" }
                ]
            }
        ]
    };
}

/**
 * Populate the vendor selector dropdown
 */
function populateVendorSelector() {
    const vendorSelector = document.getElementById('vendor-selector');
    
    if (!vendorSelector) {
        // Create the vendor selector if it doesn't exist
        createVendorUI();
        return;
    }
    
    // Clear existing options
    vendorSelector.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.text = 'Select Vendor';
    vendorSelector.appendChild(defaultOption);
    
    // Add vendor options
    vendorData.vendors.forEach(vendor => {
        const option = document.createElement('option');
        option.value = vendor.id;
        option.text = vendor.name;
        vendorSelector.appendChild(option);
    });
}

/**
 * Create the vendor selection UI if it doesn't exist
 */
function createVendorUI() {
    // Find the container element
    const container = document.querySelector('.main-container') || document.body;
    
    // Create vendor selection UI
    const vendorUI = document.createElement('div');
    vendorUI.className = 'vendor-selection-container';
    vendorUI.innerHTML = `
        <div class="vendor-selection-header">
            <h2>Select Network Vendor</h2>
            <p>Choose your network equipment vendor to configure authentication</p>
        </div>
        
        <div class="vendor-selection-form">
            <div class="form-group">
                <label for="vendor-selector">Vendor:</label>
                <select id="vendor-selector" class="form-control">
                    <option value="">Select Vendor</option>
                </select>
            </div>
            
            <div class="form-group" id="platform-selector-container" style="display: none;">
                <label for="platform-selector">Platform:</label>
                <select id="platform-selector" class="form-control">
                    <option value="">Select Platform</option>
                </select>
            </div>
        </div>
        
        <div class="vendor-cards-container" id="vendor-cards">
            <!-- Vendor cards will be populated here -->
        </div>
        
        <div class="vendor-details-container" id="vendor-details" style="display: none;">
            <!-- Vendor details will be shown here -->
        </div>
    `;
    
    // Add to the page before the first child of the container
    container.insertBefore(vendorUI, container.firstChild);
    
    // Add CSS
    const style = document.createElement('style');
    style.textContent = `
        .vendor-selection-container {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .vendor-selection-header {
            margin-bottom: 20px;
        }
        
        .vendor-selection-form {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .form-group {
            flex: 1;
            min-width: 200px;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            font-size: 16px;
        }
        
        .vendor-cards-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            margin-top: 20px;
        }
        
        .vendor-card {
            flex: 0 0 calc(33.333% - 20px);
            min-width: 200px;
            padding: 15px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            cursor: pointer;
            transition: transform 0.2s, box-shadow 0.2s;
            text-align: center;
        }
        
        .vendor-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .vendor-card.selected {
            border: 2px solid #007bff;
            transform: translateY(-5px);
        }
        
        .vendor-logo {
            height: 60px;
            margin-bottom: 10px;
            object-fit: contain;
        }
        
        .vendor-name {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 5px;
        }
        
        .vendor-details-container {
            margin-top: 30px;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .platform-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 15px;
        }
        
        .platform-button {
            padding: 10px 15px;
            background-color: #e9ecef;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .platform-button:hover {
            background-color: #dee2e6;
        }
        
        .platform-button.selected {
            background-color: #007bff;
            color: white;
        }
        
        .continue-button {
            display: block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        
        .continue-button:hover {
            background-color: #218838;
        }
        
        .feature-list {
            margin-top: 20px;
        }
        
        .feature-item {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
        }
        
        .feature-icon {
            margin-right: 10px;
            color: #28a745;
        }
        
        @media (max-width: 768px) {
            .vendor-card {
                flex: 0 0 calc(50% - 20px);
            }
        }
        
        @media (max-width: 576px) {
            .vendor-card {
                flex: 0 0 100%;
            }
        }
    `;
    document.head.appendChild(style);
    
    // Now populate the vendor selector
    populateVendorSelector();
    
    // Populate vendor cards
    populateVendorCards();
    
    // Setup event listeners
    setupEventListeners();
}

/**
 * Populate vendor cards for visual selection
 */
function populateVendorCards() {
    const vendorCardsContainer = document.getElementById('vendor-cards');
    
    if (!vendorCardsContainer) return;
    
    // Clear existing cards
    vendorCardsContainer.innerHTML = '';
    
    // Add vendor cards
    vendorData.vendors.forEach(vendor => {
        const card = document.createElement('div');
        card.className = 'vendor-card';
        card.dataset.vendor = vendor.id;
        
        // Check if logo file exists
        const logo = vendor.logo || `images/stencils/${vendor.id}/${vendor.id}_logo.png`;
        
        card.innerHTML = `
            <img src="${logo}" alt="${vendor.name}" class="vendor-logo" onerror="this.src='images/vendor_placeholder.png'">
            <div class="vendor-name">${vendor.name}</div>
        `;
        
        card.addEventListener('click', () => {
            // Remove selected class from all cards
            document.querySelectorAll('.vendor-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selected class to this card
            card.classList.add('selected');
            
            // Update vendor selector
            const vendorSelector = document.getElementById('vendor-selector');
            if (vendorSelector) {
                vendorSelector.value = vendor.id;
                // Trigger change event
                vendorSelector.dispatchEvent(new Event('change'));
            }
        });
        
        vendorCardsContainer.appendChild(card);
    });
}

/**
 * Setup event listeners for vendor and platform selection
 */
function setupEventListeners() {
    const vendorSelector = document.getElementById('vendor-selector');
    const platformSelector = document.getElementById('platform-selector');
    const platformContainer = document.getElementById('platform-selector-container');
    const vendorDetails = document.getElementById('vendor-details');
    
    if (!vendorSelector || !platformSelector || !platformContainer || !vendorDetails) return;
    
    // Vendor selection change
    vendorSelector.addEventListener('change', function() {
        const selectedVendor = this.value;
        currentVendor = selectedVendor;
        
        // Update visual card selection
        document.querySelectorAll('.vendor-card').forEach(card => {
            if (card.dataset.vendor === selectedVendor) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
        });
        
        if (selectedVendor) {
            // Find vendor data
            const vendor = vendorData.vendors.find(v => v.id === selectedVendor);
            
            if (vendor && vendor.platforms && vendor.platforms.length > 0) {
                // Populate platform selector
                populatePlatformSelector(vendor.platforms);
                
                // Show platform selector
                platformContainer.style.display = 'block';
                
                // Show vendor details
                showVendorDetails(vendor);
            } else {
                platformContainer.style.display = 'none';
                vendorDetails.style.display = 'none';
            }
        } else {
            platformContainer.style.display = 'none';
            vendorDetails.style.display = 'none';
        }
    });
    
    // Platform selection change
    platformSelector.addEventListener('change', function() {
        const selectedPlatform = this.value;
        currentPlatform = selectedPlatform;
        
        if (selectedPlatform && currentVendor) {
            // Find vendor and platform data
            const vendor = vendorData.vendors.find(v => v.id === currentVendor);
            const platform = vendor?.platforms.find(p => p.id === selectedPlatform);
            
            if (vendor && platform) {
                // Update vendor details with platform specifics
                updateVendorDetailsWithPlatform(vendor, platform);
            }
        }
    });
}

/**
 * Populate the platform selector based on selected vendor
 */
function populatePlatformSelector(platforms) {
    const platformSelector = document.getElementById('platform-selector');
    
    if (!platformSelector) return;
    
    // Clear existing options
    platformSelector.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.text = 'Select Platform';
    platformSelector.appendChild(defaultOption);
    
    // Add platform options
    platforms.forEach(platform => {
        const option = document.createElement('option');
        option.value = platform.id;
        option.text = platform.name;
        platformSelector.appendChild(option);
    });
}

/**
 * Show vendor details section
 */
function showVendorDetails(vendor) {
    const vendorDetails = document.getElementById('vendor-details');
    
    if (!vendorDetails) return;
    
    // Display vendor details
    vendorDetails.style.display = 'block';
    
    // Populate vendor details
    vendorDetails.innerHTML = `
        <h3>${vendor.name} Authentication Features</h3>
        <p>Configure authentication for ${vendor.name} devices:</p>
        
        <div class="feature-list">
            <div class="feature-item">
                <span class="feature-icon">✓</span>
                <span>802.1X Authentication</span>
            </div>
            <div class="feature-item">
                <span class="feature-icon">✓</span>
                <span>MAC Authentication Bypass (MAB)</span>
            </div>
            <div class="feature-item">
                <span class="feature-icon">✓</span>
                <span>RADIUS/TACACS+ Configuration</span>
            </div>
            <div class="feature-item">
                <span class="feature-icon">✓</span>
                <span>Guest Access</span>
            </div>
        </div>
        
        <h4>Available Platforms:</h4>
        <div class="platform-buttons">
            ${vendor.platforms.map(platform => 
                `<button class="platform-button" data-platform="${platform.id}">${platform.name}</button>`
            ).join('')}
        </div>
        
        <button class="continue-button">Continue with Configuration</button>
    `;
    
    // Setup platform button event listeners
    vendorDetails.querySelectorAll('.platform-button').forEach(button => {
        button.addEventListener('click', function() {
            // Remove selected class from all platform buttons
            vendorDetails.querySelectorAll('.platform-button').forEach(btn => {
                btn.classList.remove('selected');
            });
            
            // Add selected class to this button
            this.classList.add('selected');
            
            // Update platform selector
            const platformSelector = document.getElementById('platform-selector');
            if (platformSelector) {
                platformSelector.value = this.dataset.platform;
                // Trigger change event
                platformSelector.dispatchEvent(new Event('change'));
            }
        });
    });
    
    // Setup continue button event listener
    vendorDetails.querySelector('.continue-button').addEventListener('click', function() {
        if (currentVendor && currentPlatform) {
            // Start configuration process
            startConfigurationProcess(currentVendor, currentPlatform);
        } else if (currentVendor) {
            // Prompt for platform selection
            alert('Please select a platform to continue');
        } else {
            // This shouldn't happen, but just in case
            alert('Please select a vendor and platform to continue');
        }
    });
}

/**
 * Update vendor details with platform-specific information
 */
function updateVendorDetailsWithPlatform(vendor, platform) {
    const vendorDetails = document.getElementById('vendor-details');
    
    if (!vendorDetails) return;
    
    // Update platform buttons selection
    vendorDetails.querySelectorAll('.platform-button').forEach(button => {
        if (button.dataset.platform === platform.id) {
            button.classList.add('selected');
        } else {
            button.classList.remove('selected');
        }
    });
    
    // Update any platform-specific content
    // This would typically be populated from additional platform data
}

/**
 * Start the configuration process for the selected vendor and platform
 */
function startConfigurationProcess(vendor, platform) {
    console.log(`Starting configuration process for ${vendor} ${platform}`);
    
    // Trigger an event that the main application can listen for
    const event = new CustomEvent('uaxStartConfiguration', {
        detail: {
            vendor: vendor,
            platform: platform
        }
    });
    document.dispatchEvent(event);
    
    // Alternatively, redirect to the configuration page
    // window.location.href = `configure.html?vendor=${vendor}&platform=${platform}`;
}
EOF

    # Create vendor data JSON file
    mkdir -p "${BASE_DIR}/templates"
    
    cat > "${BASE_DIR}/templates/vendor_data.json" << 'EOF'
{
    "vendors": [
        {
            "id": "cisco",
            "name": "Cisco",
            "logo": "images/stencils/cisco/cisco_logo.png",
            "platforms": [
                { "id": "ios", "name": "IOS", "supports": ["dot1x", "mab", "radius", "tacacs", "guest"] },
                { "id": "ios-xe", "name": "IOS XE", "supports": ["dot1x", "mab", "radius", "tacacs", "radsec", "coa", "byod", "guest", "iot"] },
                { "id": "ios-xr", "name": "IOS XR", "supports": ["radius", "tacacs"] },
                { "id": "nx-os", "name": "NX-OS", "supports": ["dot1x", "mab", "radius", "tacacs"] },
                { "id": "catalyst", "name": "Catalyst", "supports": ["dot1x", "mab", "radius", "tacacs", "coa", "guest"] }
            ],
            "features": {
                "dot1x": {
                    "supported": true,
                    "modes": ["single-host", "multi-host", "multi-auth", "multi-domain"],
                    "options": ["guest-vlan", "auth-fail-vlan", "critical-vlan", "voice-vlan"]
                },
                "mab": {
                    "supported": true,
                    "formats": ["xxxx.xxxx.xxxx", "xx-xx-xx-xx-xx-xx", "xxxxxxxxxxxx"]
                },
                "radius": {
                    "supported": true,
                    "attributes": ["standard", "cisco-av-pair", "cisco-nas-port"],
                    "accounting": true
                },
                "tacacs": {
                    "supported": true,
                    "features": ["authentication", "authorization", "accounting"]
                },
                "radsec": {
                    "supported": true,
                    "platforms": ["ios-xe"]
                },
                "coa": {
                    "supported": true,
                    "platforms": ["ios-xe", "catalyst"]
                },
                "byod": {
                    "supported": true,
                    "platforms": ["ios-xe"],
                    "requires": ["ISE"]
                },
                "guest": {
                    "supported": true,
                    "methods": ["web-auth", "central-web-auth"]
                }
            }
        },
        {
            "id": "aruba",
            "name": "Aruba",
            "logo": "images/stencils/aruba/aruba_logo.png",
            "platforms": [
                { "id": "aos-cx", "name": "AOS-CX", "supports": ["dot1x", "mab", "radius", "tacacs", "radsec", "coa", "byod", "guest"] },
                { "id": "aos-switch", "name": "AOS-Switch", "supports": ["dot1x", "mab", "radius", "tacacs", "guest"] },
                { "id": "mobility-controller", "name": "Mobility Controller", "supports": ["dot1x", "radius", "tacacs", "byod", "guest"] }
            ],
            "features": {
                "dot1x": {
                    "supported": true,
                    "modes": ["port-based", "user-based"],
                    "options": ["unauthorized-vlan", "auth-fail-vlan", "server-dead-vlan"]
                },
                "mab": {
                    "supported": true,
                    "platforms": ["aos-cx", "aos-switch"]
                },
                "radius": {
                    "supported": true,
                    "attributes": ["standard", "aruba-av-pair"],
                    "accounting": true
                },
                "tacacs": {
                    "supported": true,
                    "features": ["authentication", "authorization", "accounting"]
                },
                "radsec": {
                    "supported": true,
                    "platforms": ["aos-cx"]
                },
                "byod": {
                    "supported": true,
                    "requires": ["ClearPass"]
                }
            }
        },
        {
            "id": "juniper",
            "name": "Juniper",
            "logo": "images/stencils/juniper/juniper_logo.png",
            "platforms": [
                { "id": "junos", "name": "Junos", "supports": ["dot1x", "mab", "radius", "tacacs", "radsec"] },
                { "id": "ex", "name": "EX Series", "supports": ["dot1x", "mab", "radius", "tacacs"] },
                { "id": "qfx", "name": "QFX Series", "supports": ["dot1x", "radius", "tacacs"] }
            ],
            "features": {
                "dot1x": {
                    "supported": true,
                    "modes": ["single", "multiple", "single-secure"],
                    "options": ["guest-vlan", "server-reject-vlan", "server-fail"]
                },
                "mab": {
                    "supported": true,
                    "command": "mac-radius"
                },
                "radius": {
                    "supported": true,
                    "attributes": ["standard", "juniper-vsa"],
                    "accounting": true
                }
            }
        },
        {
            "id": "fortinet",
            "name": "Fortinet",
            "logo": "images/stencils/fortinet/fortinet_logo.png",
            "platforms": [
                { "id": "fortiswitch", "name": "FortiSwitch", "supports": ["dot1x", "mab", "radius", "tacacs"] },
                { "id": "fortigate", "name": "FortiGate", "supports": ["radius", "tacacs", "guest"] },
                { "id": "fortiauthenticator", "name": "FortiAuthenticator", "supports": ["radius", "tacacs", "byod", "guest"] }
            ]
        },
        {
            "id": "paloalto",
            "name": "Palo Alto",
            "logo": "images/stencils/paloalto/paloalto_logo.png",
            "platforms": [
                { "id": "panos", "name": "PAN-OS", "supports": ["radius", "tacacs", "guest"] }
            ]
        },
        {
            "id": "extreme",
            "name": "Extreme",
            "logo": "images/stencils/extreme/extreme_logo.png",
            "platforms": [
                { "id": "exos", "name": "EXOS", "supports": ["dot1x", "mab", "radius", "tacacs"] },
                { "id": "voss", "name": "VOSS", "supports": ["dot1x", "radius", "tacacs"] }
            ]
        }
    ]
}
EOF

    # Make sure the JavaScript is included in index.html
    if ! grep -q "vendor-selection.js" "${BASE_DIR}/index.html"; then
        # Add the script inclusion before the closing body tag
        sed -i.bak "/<\/body>/i <script src=\"js\/vendor-selection.js\"></script>" "${BASE_DIR}/index.html"
    fi
    
    log "SUCCESS" "Vendor selection UI created successfully"
}

# Function to implement AI integration
implement_ai_integration() {
    log "STEP" "Implementing AI integration..."
    
    # Create AI integration directory
    mkdir -p "${BASE_DIR}/js/ai"
    
    # Create AI configuration file
    mkdir -p "${BASE_DIR}/config"
    
    cat > "${BASE_DIR}/config/ai_integration.json" << 'EOF'
{
    "ai_services": {
        "openai": {
            "enabled": true,
            "endpoint": "https://api.openai.com/v1/chat/completions",
            "model": "gpt-4",
            "temperature": 0.7,
            "max_tokens": 2000
        },
        "anthropic": {
            "enabled": true,
            "endpoint": "https://api.anthropic.com/v1/messages",
            "model": "claude-3-opus-20240229",
            "temperature": 0.7,
            "max_tokens": 2000
        },
        "gemini": {
            "enabled": true,
            "endpoint": "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent",
            "model": "gemini-pro",
            "temperature": 0.7,
            "max_tokens": 2000
        }
    },
    "ai_features": {
        "config_optimization": {
            "enabled": true,
            "description": "Optimize configuration based on best practices",
            "prompt_template": "Please optimize this {vendor} {platform} configuration for 802.1X authentication best practices and security. Provide specific recommendations and improvements:\n\n{configuration}"
        },
        "config_validation": {
            "enabled": true,
            "description": "Validate configuration for errors and security issues",
            "prompt_template": "Please review this {vendor} {platform} authentication configuration for potential errors, security issues, or missing best practices:\n\n{configuration}"
        },
        "troubleshooting": {
            "enabled": true,
            "description": "Provide troubleshooting steps for authentication issues",
            "prompt_template": "I'm having an issue with 802.1X authentication on a {vendor} {platform} device. The error is: '{error}'. Please provide troubleshooting steps and potential solutions."
        },
        "best_practices": {
            "enabled": true,
            "description": "Generate best practices for authentication deployment",
            "prompt_template": "Please provide a comprehensive list of best practices for implementing 802.1X authentication with {vendor} {platform} devices in an enterprise environment."
        },
        "compliance_checks": {
            "enabled": true,
            "description": "Check configuration for compliance with standards",
            "prompt_template": "Please analyze this {vendor} {platform} authentication configuration for compliance with {compliance_standard} requirements:\n\n{configuration}"
        }
    }
}
EOF

    # Create AI integration JavaScript module
    cat > "${BASE_DIR}/js/ai/ai-integration.js" << 'EOF'
/**
 * UaXSupreme AI Integration Module
 * Provides AI-powered features for authentication configuration
 */

class UaxAiIntegration {
    constructor() {
        this.config = null;
        this.currentVendor = '';
        this.currentPlatform = '';
    }
    
    /**
     * Initialize the AI integration module
     */
    async init() {
        try {
            // Load AI configuration
            this.config = await this.loadAiConfig();
            
            // Initialize AI services
            this.initializeAiServices();
            
            console.log("UaxAiIntegration initialized successfully");
            return true;
        } catch (error) {
            console.error("Failed to initialize AI integration:", error);
            return false;
        }
    }
    
    /**
     * Load AI configuration
     */
    async loadAiConfig() {
        try {
            const response = await fetch('config/ai_integration.json');
            
            if (response.ok) {
                return await response.json();
            } else {
                throw new Error(`Failed to load AI configuration: ${response.status} ${response.statusText}`);
            }
        } catch (error) {
            console.error("Error loading AI configuration:", error);
            
            // Return default configuration
            return {
                "ai_services": {
                    "openai": {
                        "enabled": true,
                        "endpoint": "https://api.openai.com/v1/chat/completions",
                        "model": "gpt-4",
                        "temperature": 0.7,
                        "max_tokens": 2000
                    }
                },
                "ai_features": {
                    "config_optimization": {
                        "enabled": true,
                        "description": "Optimize configuration based on best practices",
                        "prompt_template": "Please optimize this {vendor} {platform} configuration for 802.1X authentication best practices and security. Provide specific recommendations and improvements:\n\n{configuration}"
                    },
                    "troubleshooting": {
                        "enabled": true,
                        "description": "Provide troubleshooting steps for authentication issues",
                        "prompt_template": "I'm having an issue with 802.1X authentication on a {vendor} {platform} device. The error is: '{error}'. Please provide troubleshooting steps and potential solutions."
                    }
                }
            };
        }
    }
    
    /**
     * Initialize AI services
     */
    initializeAiServices() {
        // Add AI service buttons to UI
        this.addAiServiceButtons();
        
        // Add event listeners for AI features
        this.setupAiFeatureListeners();
    }
    
    /**
     * Set the current vendor and platform
     */
    setVendorPlatform(vendor, platform) {
        this.currentVendor = vendor;
        this.currentPlatform = platform;
    }
    
    /**
     * Add AI service buttons to UI
     */
    addAiServiceButtons() {
        // Find or create the AI tools container
        let aiToolsContainer = document.getElementById('ai-tools-container');
        
        if (!aiToolsContainer) {
            // Create container
            aiToolsContainer = document.createElement('div');
            aiToolsContainer.id = 'ai-tools-container';
            aiToolsContainer.className = 'ai-tools-container';
            
            // Add to page in appropriate location
            const mainContainer = document.querySelector('.main-container') || document.body;
            
            // Try to insert after header or at the beginning
            const header = document.querySelector('header') || document.querySelector('.header');
            if (header) {
                header.parentNode.insertBefore(aiToolsContainer, header.nextSibling);
            } else {
                mainContainer.insertBefore(aiToolsContainer, mainContainer.firstChild);
            }
            
            // Add CSS
            const style = document.createElement('style');
            style.textContent = `
                .ai-tools-container {
                    margin: 20px 0;
                    padding: 15px;
                    background-color: #f0f8ff;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                
                .ai-tools-header {
                    display: flex;
                    align-items: center;
                    margin-bottom: 15px;
                }
                
                .ai-tools-title {
                    flex: 1;
                    font-size: 18px;
                    font-weight: bold;
                    margin: 0;
                }
                
                .ai-toggle-button {
                    background-color: #4CAF50;
                    color: white;
                    border: none;
                    padding: 5px 10px;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 14px;
                }
                
                .ai-tools-content {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 10px;
                }
                
                .ai-feature-button {
                    padding: 10px 15px;
                    background-color: #007bff;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    transition: background-color 0.2s;
                    font-size: 14px;
                    display: flex;
                    align-items: center;
                }
                
                .ai-feature-button:hover {
                    background-color: #0056b3;
                }
                
                .ai-feature-icon {
                    margin-right: 5px;
                    font-size: 16px;
                }
                
                .ai-service-pills {
                    display: flex;
                    gap: 10px;
                    margin-top: 10px;
                }
                
                .ai-service-pill {
                    background-color: #e9ecef;
                    padding: 5px 10px;
                    border-radius: 15px;
                    font-size: 12px;
                    display: flex;
                    align-items: center;
                }
                
                .ai-service-pill.active {
                    background-color: #28a745;
                    color: white;
                }
                
                .ai-dialog {
                    position: fixed;
                    top: 50%;
                    left: 50%;
                    transform: translate(-50%, -50%);
                    background-color: white;
                    padding: 20px;
                    border-radius: 8px;
                    box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                    z-index: 1000;
                    width: 80%;
                    max-width: 800px;
                    max-height: 80vh;
                    overflow-y: auto;
                }
                
                .ai-dialog-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                    margin-bottom: 15px;
                    padding-bottom: 10px;
                    border-bottom: 1px solid #e9ecef;
                }
                
                .ai-dialog-title {
                    font-size: 18px;
                    font-weight: bold;
                    margin: 0;
                }
                
                .ai-dialog-close {
                    background: none;
                    border: none;
                    font-size: 18px;
                    cursor: pointer;
                }
                
                .ai-dialog-content {
                    margin-bottom: 15px;
                }
                
                .ai-dialog-input {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ced4da;
                    border-radius: 4px;
                    margin-bottom: 15px;
                    font-family: monospace;
                    min-height: 100px;
                }
                
                .ai-dialog-output {
                    width: 100%;
                    padding: 10px;
                    border: 1px solid #ced4da;
                    border-radius: 4px;
                    background-color: #f8f9fa;
                    min-height: 150px;
                    max-height: 300px;
                    overflow-y: auto;
                    white-space: pre-wrap;
                    font-family: monospace;
                }
                
                .ai-dialog-buttons {
                    display: flex;
                    justify-content: flex-end;
                    gap: 10px;
                }
                
                .ai-dialog-button {
                    padding: 8px 15px;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                    font-size: 14px;
                }
                
                .ai-dialog-button.primary {
                    background-color: #007bff;
                    color: white;
                }
                
                .ai-dialog-button.secondary {
                    background-color: #6c757d;
                    color: white;
                }
                
                .ai-dialog-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background-color: rgba(0,0,0,0.5);
                    z-index: 999;
                }
                
                .ai-thinking {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin: 20px 0;
                }
                
                .ai-thinking-dots {
                    display: flex;
                    gap: 5px;
                }
                
                .ai-thinking-dot {
                    width: 10px;
                    height: 10px;
                    background-color: #007bff;
                    border-radius: 50%;
                    animation: pulse 1.5s infinite ease-in-out;
                }
                
                .ai-thinking-dot:nth-child(2) {
                    animation-delay: 0.2s;
                }
                
                .ai-thinking-dot:nth-child(3) {
                    animation-delay: 0.4s;
                }
                
                @keyframes pulse {
                    0%, 100% {
                        opacity: 0.2;
                        transform: scale(0.8);
                    }
                    50% {
                        opacity: 1;
                        transform: scale(1.2);
                    }
                }
            `;
            document.head.appendChild(style);
        }
        
        // Populate container with AI tools
        aiToolsContainer.innerHTML = `
            <div class="ai-tools-header">
                <h3 class="ai-tools-title">AI Assistant & Tools</h3>
                <button id="ai-toggle-button" class="ai-toggle-button">Enable AI</button>
            </div>
            <div id="ai-tools-content" class="ai-tools-content" style="display: none;">
                <!-- AI feature buttons will be populated here -->
            </div>
            <div id="ai-service-pills" class="ai-service-pills" style="display: none;">
                <!-- AI service pills will be populated here -->
            </div>
        `;
        
        // Add toggle button functionality
        const toggleButton = document.getElementById('ai-toggle-button');
        const toolsContent = document.getElementById('ai-tools-content');
        const servicePills = document.getElementById('ai-service-pills');
        
        if (toggleButton && toolsContent && servicePills) {
            toggleButton.addEventListener('click', () => {
                if (toolsContent.style.display === 'none') {
                    toolsContent.style.display = 'flex';
                    servicePills.style.display = 'flex';
                    toggleButton.textContent = 'Disable AI';
                    toggleButton.style.backgroundColor = '#dc3545';
                } else {
                    toolsContent.style.display = 'none';
                    servicePills.style.display = 'none';
                    toggleButton.textContent = 'Enable AI';
                    toggleButton.style.backgroundColor = '#4CAF50';
                }
            });
        }
        
        // Add AI feature buttons
        this.populateAiFeatureButtons();
        
        // Add AI service pills
        this.populateAiServicePills();
    }
    
    /**
     * Populate AI feature buttons
     */
    populateAiFeatureButtons() {
        const toolsContent = document.getElementById('ai-tools-content');
        
        if (!toolsContent || !this.config || !this.config.ai_features) return;
        
        // Clear existing buttons
        toolsContent.innerHTML = '';
        
        // Add feature buttons
        Object.entries(this.config.ai_features).forEach(([featureId, feature]) => {
            if (feature.enabled) {
                const button = document.createElement('button');
                button.className = 'ai-feature-button';
                button.dataset.feature = featureId;
                
                // Add icon based on feature type
                let icon = '🤖';
                if (featureId === 'config_optimization') icon = '⚙️';
                if (featureId === 'config_validation') icon = '✓';
                if (featureId === 'troubleshooting') icon = '🔍';
                if (featureId === 'best_practices') icon = '📚';
                if (featureId === 'compliance_checks') icon = '📋';
                
                button.innerHTML = `
                    <span class="ai-feature-icon">${icon}</span>
                    ${feature.description}
                `;
                
                toolsContent.appendChild(button);
            }
        });
    }
    
    /**
     * Populate AI service pills
     */
    populateAiServicePills() {
        const servicePills = document.getElementById('ai-service-pills');
        
        if (!servicePills || !this.config || !this.config.ai_services) return;
        
        // Clear existing pills
        servicePills.innerHTML = '';
        
        // Add service pills
        Object.entries(this.config.ai_services).forEach(([serviceId, service]) => {
            const pill = document.createElement('div');
            pill.className = `ai-service-pill ${service.enabled ? 'active' : ''}`;
            pill.dataset.service = serviceId;
            
            // Add service icon
            let icon = '🤖';
            if (serviceId === 'openai') icon = '🟢';
            if (serviceId === 'anthropic') icon = '🟣';
            if (serviceId === 'gemini') icon = '🔵';
            
            pill.innerHTML = `${icon} ${serviceId.charAt(0).toUpperCase() + serviceId.slice(1)}`;
            
            pill.addEventListener('click', () => {
                // Toggle service enabled state
                service.enabled = !service.enabled;
                
                // Update pill appearance
                if (service.enabled) {
                    pill.classList.add('active');
                } else {
                    pill.classList.remove('active');
                }
            });
            
            servicePills.appendChild(pill);
        });
    }
    
    /**
     * Setup AI feature event listeners
     */
    setupAiFeatureListeners() {
        // Add click event listeners to feature buttons
        document.addEventListener('click', event => {
            const button = event.target.closest('.ai-feature-button');
            
            if (button) {
                const featureId = button.dataset.feature;
                this.handleFeatureClick(featureId);
            }
        });
    }
    
    /**
     * Handle AI feature button click
     */
    handleFeatureClick(featureId) {
        if (!this.config || !this.config.ai_features) return;
        
        const feature = this.config.ai_features[featureId];
        
        if (!feature) return;
        
        switch (featureId) {
            case 'config_optimization':
                this.showConfigOptimizationDialog();
                break;
            case 'config_validation':
                this.showConfigValidationDialog();
                break;
            case 'troubleshooting':
                this.showTroubleshootingDialog();
                break;
            case 'best_practices':
                this.showBestPracticesDialog();
                break;
            case 'compliance_checks':
                this.showComplianceChecksDialog();
                break;
            default:
                console.warn(`Unknown AI feature: ${featureId}`);
        }
    }
    
    /**
     * Show config optimization dialog
     */
    showConfigOptimizationDialog() {
        const dialogContent = `
            <div class="ai-dialog-header">
                <h3 class="ai-dialog-title">AI Configuration Optimization</h3>
                <button class="ai-dialog-close">&times;</button>
            </div>
            <div class="ai-dialog-content">
                <p>Paste your current configuration below to receive AI-optimized suggestions:</p>
                <textarea class="ai-dialog-input" placeholder="Paste your configuration here..."></textarea>
                <div class="ai-thinking" style="display: none;">
                    <div class="ai-thinking-dots">
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                    </div>
                    <span style="margin-left: 10px;">AI is analyzing your configuration...</span>
                </div>
                <div class="ai-dialog-output-container" style="display: none;">
                    <h4>Optimized Configuration:</h4>
                    <div class="ai-dialog-output"></div>
                </div>
            </div>
            <div class="ai-dialog-buttons">
                <button class="ai-dialog-button secondary ai-cancel-button">Cancel</button>
                <button class="ai-dialog-button primary ai-optimize-button">Optimize Configuration</button>
                <button class="ai-dialog-button primary ai-apply-button" style="display: none;">Apply Optimization</button>
            </div>
        `;
        
        this.showAiDialog(dialogContent, async (dialog) => {
            const input = dialog.querySelector('.ai-dialog-input');
            const output = dialog.querySelector('.ai-dialog-output');
            const outputContainer = dialog.querySelector('.ai-dialog-output-container');
            const optimizeButton = dialog.querySelector('.ai-optimize-button');
            const applyButton = dialog.querySelector('.ai-apply-button');
            const thinking = dialog.querySelector('.ai-thinking');
            
            optimizeButton.addEventListener('click', async () => {
                const configuration = input.value.trim();
                
                if (!configuration) {
                    alert('Please paste a configuration to optimize.');
                    return;
                }
                
                // Show thinking indicator
                thinking.style.display = 'flex';
                optimizeButton.disabled = true;
                
                try {
                    // Call AI service for optimization
                    const optimizedConfig = await this.callAiService('config_optimization', {
                        configuration: configuration,
                        vendor: this.currentVendor || 'cisco',
                        platform: this.currentPlatform || 'ios'
                    });
                    
                    // Hide thinking indicator
                    thinking.style.display = 'none';
                    
                    // Show output
                    output.textContent = optimizedConfig;
                    outputContainer.style.display = 'block';
                    
                    // Show apply button
                    applyButton.style.display = 'inline-block';
                    optimizeButton.disabled = false;
                } catch (error) {
                    console.error('Error optimizing configuration:', error);
                    thinking.style.display = 'none';
                    optimizeButton.disabled = false;
                    alert(`Error: ${error.message}`);
                }
            });
            
            applyButton.addEventListener('click', () => {
                // Apply the optimized configuration to the main editor
                const optimizedConfig = output.textContent;
                
                // Trigger an event that the main application can listen for
                const event = new CustomEvent('uaxApplyOptimizedConfig', {
                    detail: {
                        config: optimizedConfig
                    }
                });
                document.dispatchEvent(event);
                
                // Close the dialog
                this.closeAiDialog();
            });
        });
    }
    
    /**
     * Show config validation dialog
     */
    showConfigValidationDialog() {
        const dialogContent = `
            <div class="ai-dialog-header">
                <h3 class="ai-dialog-title">AI Configuration Validation</h3>
                <button class="ai-dialog-close">&times;</button>
            </div>
            <div class="ai-dialog-content">
                <p>Paste your configuration below to validate for errors and security issues:</p>
                <textarea class="ai-dialog-input" placeholder="Paste your configuration here..."></textarea>
                <div class="ai-thinking" style="display: none;">
                    <div class="ai-thinking-dots">
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                    </div>
                    <span style="margin-left: 10px;">AI is validating your configuration...</span>
                </div>
                <div class="ai-dialog-output-container" style="display: none;">
                    <h4>Validation Results:</h4>
                    <div class="ai-dialog-output"></div>
                </div>
            </div>
            <div class="ai-dialog-buttons">
                <button class="ai-dialog-button secondary ai-cancel-button">Cancel</button>
                <button class="ai-dialog-button primary ai-validate-button">Validate Configuration</button>
            </div>
        `;
        
        this.showAiDialog(dialogContent, async (dialog) => {
            const input = dialog.querySelector('.ai-dialog-input');
            const output = dialog.querySelector('.ai-dialog-output');
            const outputContainer = dialog.querySelector('.ai-dialog-output-container');
            const validateButton = dialog.querySelector('.ai-validate-button');
            const thinking = dialog.querySelector('.ai-thinking');
            
            validateButton.addEventListener('click', async () => {
                const configuration = input.value.trim();
                
                if (!configuration) {
                    alert('Please paste a configuration to validate.');
                    return;
                }
                
                // Show thinking indicator
                thinking.style.display = 'flex';
                validateButton.disabled = true;
                
                try {
                    // Call AI service for validation
                    const validationResults = await this.callAiService('config_validation', {
                        configuration: configuration,
                        vendor: this.currentVendor || 'cisco',
                        platform: this.currentPlatform || 'ios'
                    });
                    
                    // Hide thinking indicator
                    thinking.style.display = 'none';
                    
                    // Show output
                    output.textContent = validationResults;
                    outputContainer.style.display = 'block';
                    validateButton.disabled = false;
                } catch (error) {
                    console.error('Error validating configuration:', error);
                    thinking.style.display = 'none';
                    validateButton.disabled = false;
                    alert(`Error: ${error.message}`);
                }
            });
        });
    }
    
    /**
     * Show troubleshooting dialog
     */
    showTroubleshootingDialog() {
        const dialogContent = `
            <div class="ai-dialog-header">
                <h3 class="ai-dialog-title">AI Troubleshooting Assistant</h3>
                <button class="ai-dialog-close">&times;</button>
            </div>
            <div class="ai-dialog-content">
                <p>Describe the authentication issue you're experiencing:</p>
                <textarea class="ai-dialog-input" placeholder="Example: 'Users are getting authentication failed messages when connecting to the network...'"></textarea>
                <div class="ai-thinking" style="display: none;">
                    <div class="ai-thinking-dots">
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                    </div>
                    <span style="margin-left: 10px;">AI is analyzing your issue...</span>
                </div>
                <div class="ai-dialog-output-container" style="display: none;">
                    <h4>Troubleshooting Steps:</h4>
                    <div class="ai-dialog-output"></div>
                </div>
            </div>
            <div class="ai-dialog-buttons">
                <button class="ai-dialog-button secondary ai-cancel-button">Cancel</button>
                <button class="ai-dialog-button primary ai-troubleshoot-button">Get Help</button>
            </div>
        `;
        
        this.showAiDialog(dialogContent, async (dialog) => {
            const input = dialog.querySelector('.ai-dialog-input');
            const output = dialog.querySelector('.ai-dialog-output');
            const outputContainer = dialog.querySelector('.ai-dialog-output-container');
            const troubleshootButton = dialog.querySelector('.ai-troubleshoot-button');
            const thinking = dialog.querySelector('.ai-thinking');
            
            troubleshootButton.addEventListener('click', async () => {
                const issue = input.value.trim();
                
                if (!issue) {
                    alert('Please describe the issue you are experiencing.');
                    return;
                }
                
                // Show thinking indicator
                thinking.style.display = 'flex';
                troubleshootButton.disabled = true;
                
                try {
                    // Call AI service for troubleshooting
                    const troubleshootingSteps = await this.callAiService('troubleshooting', {
                        error: issue,
                        vendor: this.currentVendor || 'cisco',
                        platform: this.currentPlatform || 'ios'
                    });
                    
                    // Hide thinking indicator
                    thinking.style.display = 'none';
                    
                    // Show output
                    output.textContent = troubleshootingSteps;
                    outputContainer.style.display = 'block';
                    troubleshootButton.disabled = false;
                } catch (error) {
                    console.error('Error getting troubleshooting steps:', error);
                    thinking.style.display = 'none';
                    troubleshootButton.disabled = false;
                    alert(`Error: ${error.message}`);
                }
            });
        });
    }
    
    /**
     * Show best practices dialog
     */
    showBestPracticesDialog() {
        const dialogContent = `
            <div class="ai-dialog-header">
                <h3 class="ai-dialog-title">AI Best Practices</h3>
                <button class="ai-dialog-close">&times;</button>
            </div>
            <div class="ai-dialog-content">
                <p>Get best practices for 802.1X authentication implementation:</p>
                <div class="ai-thinking" style="display: none;">
                    <div class="ai-thinking-dots">
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                    </div>
                    <span style="margin-left: 10px;">AI is generating best practices...</span>
                </div>
                <div class="ai-dialog-output-container">
                    <h4>Best Practices:</h4>
                    <div class="ai-dialog-output"></div>
                </div>
            </div>
            <div class="ai-dialog-buttons">
                <button class="ai-dialog-button secondary ai-cancel-button">Close</button>
                <button class="ai-dialog-button primary ai-practices-button">Generate Best Practices</button>
            </div>
        `;
        
        this.showAiDialog(dialogContent, async (dialog) => {
            const output = dialog.querySelector('.ai-dialog-output');
            const practicesButton = dialog.querySelector('.ai-practices-button');
            const thinking = dialog.querySelector('.ai-thinking');
            
            practicesButton.addEventListener('click', async () => {
                // Show thinking indicator
                thinking.style.display = 'flex';
                practicesButton.disabled = true;
                
                try {
                    // Call AI service for best practices
                    const bestPractices = await this.callAiService('best_practices', {
                        vendor: this.currentVendor || 'cisco',
                        platform: this.currentPlatform || 'ios'
                    });
                    
                    // Hide thinking indicator
                    thinking.style.display = 'none';
                    
                    // Show output
                    output.textContent = bestPractices;
                    practicesButton.disabled = false;
                } catch (error) {
                    console.error('Error generating best practices:', error);
                    thinking.style.display = 'none';
                    practicesButton.disabled = false;
                    alert(`Error: ${error.message}`);
                }
            });
            
            // Generate best practices automatically when dialog opens
            practicesButton.click();
        });
    }
    
    /**
     * Show compliance checks dialog
     */
    showComplianceChecksDialog() {
        const dialogContent = `
            <div class="ai-dialog-header">
                <h3 class="ai-dialog-title">AI Compliance Checks</h3>
                <button class="ai-dialog-close">&times;</button>
            </div>
            <div class="ai-dialog-content">
                <p>Validate your configuration against compliance standards:</p>
                <div class="form-group">
                    <label for="compliance-standard">Compliance Standard:</label>
                    <select id="compliance-standard" class="form-control">
                        <option value="ISO 27001">ISO 27001</option>
                        <option value="NIST 800-53">NIST 800-53</option>
                        <option value="PCI DSS">PCI DSS</option>
                        <option value="HIPAA">HIPAA</option>
                        <option value="SOC2">SOC2</option>
                    </select>
                </div>
                <textarea class="ai-dialog-input" placeholder="Paste your configuration here..."></textarea>
                <div class="ai-thinking" style="display: none;">
                    <div class="ai-thinking-dots">
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                        <div class="ai-thinking-dot"></div>
                    </div>
                    <span style="margin-left: 10px;">AI is checking compliance...</span>
                </div>
                <div class="ai-dialog-output-container" style="display: none;">
                    <h4>Compliance Check Results:</h4>
                    <div class="ai-dialog-output"></div>
                </div>
            </div>
            <div class="ai-dialog-buttons">
                <button class="ai-dialog-button secondary ai-cancel-button">Cancel</button>
                <button class="ai-dialog-button primary ai-compliance-button">Check Compliance</button>
            </div>
        `;
        
        this.showAiDialog(dialogContent, async (dialog) => {
            const input = dialog.querySelector('.ai-dialog-input');
            const output = dialog.querySelector('.ai-dialog-output');
            const outputContainer = dialog.querySelector('.ai-dialog-output-container');
            const standardSelector = dialog.querySelector('#compliance-standard');
            const complianceButton = dialog.querySelector('.ai-compliance-button');
            const thinking = dialog.querySelector('.ai-thinking');
            
            complianceButton.addEventListener('click', async () => {
                const configuration = input.value.trim();
                const complianceStandard = standardSelector.value;
                
                if (!configuration) {
                    alert('Please paste a configuration to check for compliance.');
                    return;
                }
                
                // Show thinking indicator
                thinking.style.display = 'flex';
                complianceButton.disabled = true;
                
                try {
                    // Call AI service for compliance checks
                    const complianceResults = await this.callAiService('compliance_checks', {
                        configuration: configuration,
                        compliance_standard: complianceStandard,
                        vendor: this.currentVendor || 'cisco',
                        platform: this.currentPlatform || 'ios'
                    });
                    
                    // Hide thinking indicator
                    thinking.style.display = 'none';
                    
                    // Show output
                    output.textContent = complianceResults;
                    outputContainer.style.display = 'block';
                    complianceButton.disabled = false;
                } catch (error) {
                    console.error('Error checking compliance:', error);
                    thinking.style.display = 'none';
                    complianceButton.disabled = false;
                    alert(`Error: ${error.message}`);
                }
            });
        });
    }
    
    /**
     * Show AI dialog
     */
    showAiDialog(content, setupCallback) {
        // Create overlay
        const overlay = document.createElement('div');
        overlay.className = 'ai-dialog-overlay';
        document.body.appendChild(overlay);
        
        // Create dialog
        const dialog = document.createElement('div');
        dialog.className = 'ai-dialog';
        dialog.innerHTML = content;
        document.body.appendChild(dialog);
        
        // Set up close button
        const closeButton = dialog.querySelector('.ai-dialog-close');
        if (closeButton) {
            closeButton.addEventListener('click', () => {
                this.closeAiDialog();
            });
        }
        
        // Set up cancel button
        const cancelButton = dialog.querySelector('.ai-cancel-button');
        if (cancelButton) {
            cancelButton.addEventListener('click', () => {
                this.closeAiDialog();
            });
        }
        
        // Allow clicking overlay to close
        overlay.addEventListener('click', () => {
            this.closeAiDialog();
        });
        
        // Call setup callback with dialog element
        if (setupCallback) {
            setupCallback(dialog);
        }
    }
    
    /**
     * Close AI dialog
     */
    closeAiDialog() {
        // Remove overlay and dialog
        const overlay = document.querySelector('.ai-dialog-overlay');
        const dialog = document.querySelector('.ai-dialog');
        
        if (overlay) {
            overlay.remove();
        }
        
        if (dialog) {
            dialog.remove();
        }
    }
    
    /**
     * Call AI service with prompt
     */
    async callAiService(featureId, variables) {
        if (!this.config || !this.config.ai_features || !this.config.ai_services) {
            throw new Error('AI configuration not loaded');
        }
        
        // Find the feature
        const feature = this.config.ai_features[featureId];
        if (!feature || !feature.enabled) {
            throw new Error(`Feature ${featureId} not enabled or not found`);
        }
        
        // Get enabled AI services
        const enabledServices = Object.entries(this.config.ai_services)
            .filter(([, service]) => service.enabled)
            .map(([id]) => id);
        
        if (enabledServices.length === 0) {
            throw new Error('No AI services enabled');
        }
        
        // Select a service to use
        const serviceId = enabledServices[Math.floor(Math.random() * enabledServices.length)];
        const service = this.config.ai_services[serviceId];
        
        // Replace variables in prompt template
        let prompt = feature.prompt_template;
        for (const [key, value] of Object.entries(variables)) {
            prompt = prompt.replace(new RegExp(`{${key}}`, 'g'), value);
        }
        
        // In a real implementation, we would call the actual API here
        // For this simulation, we'll just return a mock response based on the service and feature
        return this.mockAiResponse(serviceId, featureId, prompt, variables);
    }
    
    /**
     * Mock AI response for simulation
     */
    mockAiResponse(serviceId, featureId, prompt, variables) {
        // This is a simulation - in a real implementation we would call the actual API
        return new Promise((resolve) => {
            // Simulate API call delay
            setTimeout(() => {
                let response = '';
                
                switch (featureId) {
                    case 'config_optimization':
                        response = this.getMockOptimizationResponse(variables.vendor, variables.platform);
                        break;
                    case 'config_validation':
                        response = this.getMockValidationResponse(variables.vendor, variables.platform);
                        break;
                    case 'troubleshooting':
                        response = this.getMockTroubleshootingResponse(variables.vendor, variables.platform, variables.error);
                        break;
                    case 'best_practices':
                        response = this.getMockBestPracticesResponse(variables.vendor, variables.platform);
                        break;
                    case 'compliance_checks':
                        response = this.getMockComplianceResponse(variables.vendor, variables.platform, variables.compliance_standard);
                        break;
                    default:
                        response = 'No mock response available for this feature.';
                }
                
                resolve(response);
            }, 1500); // Simulate processing time
        });
    }
    
    /**
     * Get mock optimization response
     */
    getMockOptimizationResponse(vendor, platform) {
        if (vendor === 'cisco' && (platform === 'ios' || platform === 'ios-xe')) {
            return `! Optimized configuration for Cisco ${platform.toUpperCase()}
! Recommended changes:

! 1. Enhanced RADIUS configuration with key-wrap
radius-server key-wrap enable

! 2. Improved server monitoring with automated tester
radius server RADIUS-PRIMARY
 automate-tester username probe-user idle-time 60 probe-on

! 3. Added RADIUS attribute configuration for better profiling
radius-server attribute 6 on-for-login-auth
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only

! 4. Improved dead detection and failover
radius-server dead-criteria time 15 tries 3
radius-server deadtime 15

! 5. Added source interface for consistent communication
ip radius source-interface Loopback0

! 6. Enhanced accounting for better tracking
aaa accounting update newinfo periodic 30

! The rest of your configuration remains valid.`;
        } else if (vendor === 'aruba') {
            return `! Optimized configuration for Aruba ${platform}
! Recommended changes:

! 1. Enhanced RADIUS tracking for better server monitoring
radius-server tracking user-name tracking-user
radius-server tracking interval 10

! 2. Improved attributes for device profiling
radius-server attribute 31 format ietf upper-case
radius-server attribute 31 send mac-only

! 3. Added support for VSAs
radius-server vsa send authentication

! 4. Added periodic accounting updates
aaa accounting update periodic 30

! 5. Enhanced client limits for better scaling
aaa authentication port-access ge-0/0/1 client-limit 32

! The rest of your configuration remains valid.`;
        } else {
            return `! Optimized configuration for ${vendor} ${platform}
! Generic optimization suggestions:

! 1. Add redundant RADIUS servers for high availability
! 2. Configure appropriate deadtime and timeout values
! 3. Use secure authentication methods
! 4. Implement guest VLAN for non-802.1X devices
! 5. Configure critical VLAN for server failure scenarios
! 6. Implement appropriate security features

! Please refer to ${vendor} documentation for specific syntax.`;
        }
    }
    
    /**
     * Get mock validation response
     */
    getMockValidationResponse(vendor, platform) {
        return `## Configuration Validation Results

### Security Issues:
1. ⚠️ RADIUS shared secret appears to be weak or default
   - Recommended: Use a strong, unique shared secret of at least 16 characters

2. ⚠️ No backup RADIUS server configured
   - Recommended: Configure at least two RADIUS servers for redundancy

3. ⚠️ Missing source interface for RADIUS communication
   - Recommended: Configure a specific source interface for consistent communication

### Best Practice Gaps:
1. ℹ️ No RADIUS server dead detection configured
   - Recommended: Add dead-criteria and deadtime configuration

2. ℹ️ No accounting configuration found
   - Recommended: Enable accounting for better tracking and troubleshooting

3. ℹ️ No guest VLAN configured
   - Recommended: Configure guest VLAN for non-802.1X capable devices

### Configuration Errors:
1. ❌ Line 15: Invalid syntax in authentication command
   - Fix: Check the authentication command syntax

2. ❌ Missing AAA configuration
   - Fix: Add necessary AAA configuration before 802.1X settings

### Overall Assessment:
The configuration needs improvement in security, redundancy, and compliance with best practices. Please address the issues above to enhance your authentication security posture.`;
    }
    
    /**
     * Get mock troubleshooting response
     */
    getMockTroubleshootingResponse(vendor, platform, error) {
        return `## 802.1X Authentication Troubleshooting

### Issue Analysis
Based on your description: "${error}"

### Troubleshooting Steps

1. **Verify RADIUS Server Communication**
   - Check connectivity to RADIUS server:
     \`\`\`
     ping ${vendor === 'cisco' ? '10.1.1.100' : 'radius-server'}
     \`\`\`
   - Verify RADIUS server status:
     \`\`\`
     ${vendor === 'cisco' ? 'show radius server-group all' : 'show radius statistics'}
     \`\`\`

2. **Check Authentication Status**
   - Review authentication sessions:
     \`\`\`
     ${vendor === 'cisco' ? 'show authentication sessions' : 'show port-access authenticator'}
     \`\`\`
   - Check for specific failures:
     \`\`\`
     ${vendor === 'cisco' ? 'show authentication sessions interface GigabitEthernet1/0/1 details' : 'show port-access authenticator interface details'}
     \`\`\`

3. **Verify Configuration**
   - Check RADIUS configuration:
     \`\`\`
     ${vendor === 'cisco' ? 'show running-config | include radius' : 'show running-config | include radius-server'}
     \`\`\`
   - Verify 802.1X configuration:
     \`\`\`
     ${vendor === 'cisco' ? 'show running-config interface GigabitEthernet1/0/1' : 'show running-config interface ge-0/0/1'}
     \`\`\`

4. **Enable Debugging**
   - Enable authentication debugging:
     \`\`\`
     ${vendor === 'cisco' ? 'debug dot1x all' : 'debug authentication'}
     \`\`\`
   - Enable RADIUS debugging:
     \`\`\`
     ${vendor === 'cisco' ? 'debug radius authentication' : 'debug radius'}
     \`\`\`

5. **Check Client Side**
   - Verify client supplicant configuration
   - Ensure client is using correct credentials
   - Check client system logs for authentication errors

6. **Check RADIUS Server Logs**
   - Review authentication logs on RADIUS server
   - Verify client attributes are being processed correctly
   - Check for policy mismatches or authorization failures

### Potential Solutions

1. **If RADIUS server connectivity issue:**
   - Verify network path to RADIUS server
   - Check firewall rules and ensure ports 1812/1813 are open
   - Verify shared secret matches between switch and server

2. **If configuration issue:**
   - Update RADIUS shared secret
   - Configure backup RADIUS server
   - Adjust authentication timers (timeout, retransmit)

3. **If client issue:**
   - Reconfigure client supplicant
   - Update client certificates if using EAP-TLS
   - Try alternate authentication method (e.g., PEAP instead of EAP-TLS)

4. **If policy issue:**
   - Verify RADIUS server policy configuration
   - Check user/device attributes and group membership
   - Update authorization policies

### Additional Information
For persistent issues, consider opening a TAC case with ${vendor.charAt(0).toUpperCase() + vendor.slice(1)} and provide debug outputs and RADIUS server logs.`;
    }
    
    /**
     * Get mock best practices response
     */
    getMockBestPracticesResponse(vendor, platform) {
        return `# 802.1X Authentication Best Practices for ${vendor.charAt(0).toUpperCase() + vendor.slice(1)} ${platform.toUpperCase()}

## RADIUS Configuration

1. **Server Redundancy**
   - Configure at least two RADIUS servers for high availability
   - Use different physical or virtual servers in different locations when possible
   - Configure appropriate deadtime (10-15 minutes) to skip unresponsive servers

2. **Secure Communication**
   - Use strong, unique shared secrets (16+ characters) for each RADIUS client
   - Configure a specific source interface for consistent communication
   - Consider RadSec (RADIUS over TLS) for enhanced security when supported

3. **Server Monitoring**
   - Configure automated server testing with test probes
   - Implement proper dead detection criteria (3 failed attempts, 15 second timeout)
   - Configure accounting properly to track authentication sessions

## 802.1X Configuration

1. **Phased Deployment**
   - Start with monitor mode to identify potential issues
   - Use low-impact security mode during initial deployment
   - Move to closed mode in phases, starting with less critical areas

2. **Host Modes**
   - Use multi-auth mode for environments with multiple devices per port
   - Use multi-domain for IP phone environments
   - Configure appropriate client limit based on environment needs

3. **Fallback Mechanisms**
   - Configure guest VLAN for non-802.1X capable devices
   - Implement auth-fail VLAN for failed authentication attempts
   - Configure critical VLAN for RADIUS server failure

4. **Timers and Retries**
   - Configure reasonable timeouts to avoid authentication delays
   - Set appropriate reauthentication period (1-24 hours)
   - Configure proper quiet period to prevent authentication storms

## MAC Authentication Bypass (MAB)

1. **Security Considerations**
   - Use MAB only for devices that cannot perform 802.1X
   - Implement comprehensive MAC address management
   - Consider MAC address expiration policies for temporary devices

2. **Configuration Best Practices**
   - Configure MAC format to match your RADIUS server expectations
   - Use 802.1X as the primary authentication method with MAB as fallback
   - Implement device profiling to identify device types

## Advanced Security Features

1. **Dynamic Access Control**
   - Implement Change of Authorization (CoA) for dynamic policy changes
   - Configure downloadable ACLs for granular access control
   - Use VLAN assignment based on user/device identity

2. **Additional Security Layers**
   - Enable DHCP snooping on user VLANs
   - Configure Dynamic ARP Inspection
   - Implement IP Source Guard on access ports
   - Configure storm control and port security

## Monitoring and Troubleshooting

1. **Logging and Reporting**
   - Configure appropriate logging levels
   - Implement authentication session monitoring
   - Set up regular reporting on authentication status

2. **Troubleshooting Tools**
   - Understand debug commands for authentication issues
   - Know how to check RADIUS server status and statistics
   - Develop troubleshooting procedures for common issues

## Vendor-Specific Recommendations

1. **${vendor.charAt(0).toUpperCase() + vendor.slice(1)}-Specific Features**
   - Leverage vendor-specific attributes for enhanced functionality
   - Implement vendor-specific security features
   - Follow ${vendor.charAt(0).toUpperCase() + vendor.slice(1)} recommended configuration templates

2. **Integration with Security Ecosystem**
   - Integrate with ${vendor === 'cisco' ? 'ISE' : vendor === 'aruba' ? 'ClearPass' : 'NAC solution'} for advanced features
   - Leverage posture assessment when available
   - Implement guest access and BYOD workflows

Following these best practices will help ensure a secure, reliable, and manageable 802.1X deployment on your ${vendor.charAt(0).toUpperCase() + vendor.slice(1)} ${platform.toUpperCase()} infrastructure.`;
    }
    
    /**
     * Get mock compliance response
     */
    getMockComplianceResponse(vendor, platform, standard) {
        return `# ${standard} Compliance Assessment

## Configuration Analysis Summary

- **Device**: ${vendor.charAt(0).toUpperCase() + vendor.slice(1)} ${platform.toUpperCase()}
- **Compliance Standard**: ${standard}
- **Analysis Date**: ${new Date().toISOString().split('T')[0]}

## Compliance Status

| Requirement | Status | Notes |
|-------------|--------|-------|
| Authentication Methods | ✅ Compliant | 802.1X implementation meets standards |
| Encryption | ⚠️ Partial | Missing MACsec configuration |
| Logging | ❌ Non-compliant | Insufficient logging configuration |
| Access Control | ✅ Compliant | Appropriate VLAN segmentation implemented |
| Server Security | ⚠️ Partial | RADIUS server communication needs improvement |
| Password Policy | ❌ Non-compliant | Weak shared secrets detected |
| High Availability | ✅ Compliant | Redundant RADIUS servers configured |

## Specific Findings

### Authentication Methods (✅ Compliant)
- 802.1X implementation meets ${standard} requirements
- Appropriate EAP methods supported
- Fallback mechanisms properly configured

### Encryption (⚠️ Partial)
- Missing MACsec configuration required by ${standard} section 8.2.3
- Recommendation: Implement MACsec for Layer 2 encryption

### Logging (❌ Non-compliant)
- Insufficient logging for authentication events
- Missing accounting configuration
- Recommendation: Configure detailed accounting with interim updates

### Server Security (⚠️ Partial)
- RADIUS server communication not sufficiently secured
- Recommendation: Implement RadSec (RADIUS over TLS) when supported

### Password Policy (❌ Non-compliant)
- Weak shared secrets detected in RADIUS configuration
- ${standard} requires minimum 16-character complex shared secrets
- Recommendation: Update all shared secrets to meet complexity requirements

## Remediation Steps

1. **Update RADIUS shared secrets**
   \`\`\`
   ${vendor === 'cisco' ? 'radius server RADIUS-PRIMARY\n key 0 ComplexSharedSecret123!@#$%' : 'radius-server host 10.1.1.100 key "ComplexSharedSecret123!@#$%"'}
   \`\`\`

2. **Enhance logging configuration**
   \`\`\`
   ${vendor === 'cisco' ? 'aaa accounting dot1x default start-stop group radius\naaa accounting update newinfo periodic 30' : 'accounting-order radius\naccounting accounting-stop-on-failure'}
   \`\`\`

3. **Implement MACsec where supported**
   \`\`\`
   ${vendor === 'cisco' ? 'interface GigabitEthernet1/0/1\n macsec\n mka policy POLICY-1' : '# Refer to vendor documentation for MACsec configuration'}
   \`\`\`

4. **Secure RADIUS communication**
   \`\`\`
   ${vendor === 'cisco' && platform === 'ios-xe' ? 'radius server RADSEC\n address ipv4 10.1.1.100 auth-port 2083 acct-port 2083\n key 0 radsec\n tls connectiontimeout 5\n tls version 1.2' : '# Refer to vendor documentation for securing RADIUS communication'}
   \`\`\`

## Conclusion

The current configuration does not fully comply with ${standard} requirements. Implement the remediation steps above to achieve full compliance. After implementing changes, perform another compliance assessment to verify compliance status.`;
    }
}

// Initialize the AI integration when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.uaxAiIntegration = new UaxAiIntegration();
    window.uaxAiIntegration.init();
    
    // Listen for vendor selection events
    document.addEventListener('uaxStartConfiguration', (event) => {
        if (window.uaxAiIntegration && event.detail) {
            window.uaxAiIntegration.setVendorPlatform(
                event.detail.vendor,
                event.detail.platform
            );
        }
    });
});
EOF

    # Create AI service modules
    mkdir -p "${BASE_DIR}/js/ai/services"
    
    # OpenAI service module
    cat > "${BASE_DIR}/js/ai/services/openai-service.js" << 'EOF'
/**
 * UaXSupreme OpenAI Service
 * Handles interactions with OpenAI API
 */

class OpenAiService {
    constructor(config) {
        this.config = config || {
            endpoint: 'https://api.openai.com/v1/chat/completions',
            model: 'gpt-4',
            temperature: 0.7,
            max_tokens: 2000
        };
        this.apiKey = ''; // Should be set by the user
    }
    
    /**
     * Set API key
     */
    setApiKey(apiKey) {
        this.apiKey = apiKey;
    }
    
    /**
     * Call OpenAI API
     */
    async callApi(prompt, options = {}) {
        if (!this.apiKey) {
            throw new Error('OpenAI API key not set. Please set API key first.');
        }
        
        try {
            const response = await fetch(this.config.endpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${this.apiKey}`
                },
                body: JSON.stringify({
                    model: options.model || this.config.model,
                    messages: [
                        {
                            role: 'system',
                            content: options.systemPrompt || 'You are an AI assistant specializing in network authentication configuration. Provide detailed, accurate answers based on best practices.'
                        },
                        {
                            role: 'user',
                            content: prompt
                        }
                    ],
                    temperature: options.temperature || this.config.temperature,
                    max_tokens: options.max_tokens || this.config.max_tokens
                })
            });
            
            if (!response.ok) {
                const error = await response.json();
                throw new Error(`OpenAI API error: ${error.error?.message || response.statusText}`);
            }
            
            const data = await response.json();
            return data.choices[0].message.content;
        } catch (error) {
            console.error('Error calling OpenAI API:', error);
            throw error;
        }
    }
}

// Export the service
window.OpenAiService = OpenAiService;
EOF

    # Anthropic service module
    cat > "${BASE_DIR}/js/ai/services/anthropic-service.js" << 'EOF'
/**
 * UaXSupreme Anthropic Service
 * Handles interactions with Anthropic API
 */

class AnthropicService {
    constructor(config) {
        this.config = config || {
            endpoint: 'https://api.anthropic.com/v1/messages',
            model: 'claude-3-opus-20240229',
            temperature: 0.7,
            max_tokens: 2000
        };
        this.apiKey = ''; // Should be set by the user
    }
    
    /**
     * Set API key
     */
    setApiKey(apiKey) {
        this.apiKey = apiKey;
    }
    
    /**
     * Call Anthropic API
     */
    async callApi(prompt, options = {}) {
        if (!this.apiKey) {
            throw new Error('Anthropic API key not set. Please set API key first.');
        }
        
        try {
            const response = await fetch(this.config.endpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'x-api-key': this.apiKey,
                    'anthropic-version': '2023-06-01'
                },
                body: JSON.stringify({
                    model: options.model || this.config.model,
                    messages: [
                        {
                            role: 'user',
                            content: prompt
                        }
                    ],
                    system: options.systemPrompt || 'You are an AI assistant specializing in network authentication configuration. Provide detailed, accurate answers based on best practices.',
                    temperature: options.temperature || this.config.temperature,
                    max_tokens: options.max_tokens || this.config.max_tokens
                })
            });
            
            if (!response.ok) {
                const error = await response.json();
                throw new Error(`Anthropic API error: ${error.error?.message || response.statusText}`);
            }
            
            const data = await response.json();
            return data.content[0].text;
        } catch (error) {
            console.error('Error calling Anthropic API:', error);
            throw error;
        }
    }
}

// Export the service
window.AnthropicService = AnthropicService;
EOF

    # Gemini service module
    cat > "${BASE_DIR}/js/ai/services/gemini-service.js" << 'EOF'
/**
 * UaXSupreme Gemini Service
 * Handles interactions with Google Gemini API
 */

class GeminiService {
    constructor(config) {
        this.config = config || {
            endpoint: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent',
            model: 'gemini-pro',
            temperature: 0.7,
            max_tokens: 2000
        };
        this.apiKey = ''; // Should be set by the user
    }
    
    /**
     * Set API key
     */
    setApiKey(apiKey) {
        this.apiKey = apiKey;
    }
    
    /**
     * Call Gemini API
     */
    async callApi(prompt, options = {}) {
        if (!this.apiKey) {
            throw new Error('Gemini API key not set. Please set API key first.');
        }
        
        try {
            const endpoint = `${this.config.endpoint}?key=${this.apiKey}`;
            
            const response = await fetch(endpoint, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    contents: [
                        {
                            parts: [
                                {
                                    text: options.systemPrompt ? 
                                        `${options.systemPrompt}\n\n${prompt}` : 
                                        prompt
                                }
                            ]
                        }
                    ],
                    generationConfig: {
                        temperature: options.temperature || this.config.temperature,
                        maxOutputTokens: options.max_tokens || this.config.max_tokens
                    }
                })
            });
            
            if (!response.ok) {
                const error = await response.json();
                throw new Error(`Gemini API error: ${error.error?.message || response.statusText}`);
            }
            
            const data = await response.json();
            return data.candidates[0].content.parts[0].text;
        } catch (error) {
            console.error('Error calling Gemini API:', error);
            throw error;
        }
    }
}

// Export the service
window.GeminiService = GeminiService;
EOF

    # Make sure AI scripts are included in index.html
    if ! grep -q "ai-integration.js" "${BASE_DIR}/index.html"; then
        # Add the script inclusions before the closing body tag
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/services\/openai-service.js\"></script>" "${BASE_DIR}/index.html"
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/services\/anthropic-service.js\"></script>" "${BASE_DIR}/index.html"
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/services\/gemini-service.js\"></script>" "${BASE_DIR}/index.html"
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/ai-integration.js\"></script>" "${BASE_DIR}/index.html"
    fi
    
    log "SUCCESS" "AI integration implemented successfully"
}

# Function to enhance UaXSupreme main script
enhance_main_script() {
    log "STEP" "Enhancing UaXSupreme main script..."
    
    # Create base enhancer script
    cat > "${BASE_DIR}/UaxEnhance.sh" << 'EOF'
#!/bin/bash
# UaXSupreme Enhancement Script
# Version: 2.0.1
# Description: Complete enhancement for UaXSupreme authentication platform

# Set color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script configuration
BASE_DIR="$(pwd)"
BACKUP_DIR="${BASE_DIR}/backups/$(date +%Y%m%d%H%M%S)"
LOG_FILE="${BASE_DIR}/uaxenhance_$(date +%Y%m%d%H%M%S).log"
TEMP_DIR="${BASE_DIR}/.temp"

# Print banner
print_banner() {
    clear
    echo -e "${BLUE}${BOLD}"
    echo "═════════════════════════════════════════════════════════════════"
    echo "            UaXSupreme Enhancement Script v2.0.1                 "
    echo "═════════════════════════════════════════════════════════════════"
    echo -e "${NC}"
    echo -e "   ${CYAN}Date:${NC} $(date "+%Y-%m-%d")    ${CYAN}Mode:${NC} $([ "$DEBUG" == "true" ] && echo "Debug" || echo "Standard")"
    echo
}

# Function for logging
log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    
    # Create log directory if it doesn't exist
    mkdir -p "$(dirname "$LOG_FILE")"
    
    # Write to log file
    echo "${timestamp} [${level}] ${message}" >> "$LOG_FILE"
    
    # Print to console based on level with enhanced formatting
    case "$level" in
        "INFO")
            echo -e "${BLUE}○ [INFO] ${message}${NC}"
            ;;
        "SUCCESS")
            echo -e "${GREEN}✓ [SUCCESS] ${message}${NC}"
            ;;
        "WARNING")
            echo -e "${YELLOW}⚠ [WARNING] ${message}${NC}"
            ;;
        "ERROR")
            echo -e "${RED}✗ [ERROR] ${message}${NC}"
            ;;
        "DEBUG")
            if [ "$DEBUG" == "true" ]; then
                echo -e "${CYAN}➤ [DEBUG] ${message}${NC}"
            fi
            ;;
        "STEP")
            echo -e "${MAGENTA}${BOLD}► ${message}${NC}"
            ;;
    esac
}

# Function to check dependencies
check_dependencies() {
    log "STEP" "Checking dependencies..."
    
    local missing_deps=0
    
    # Check for curl
    if ! command -v curl &> /dev/null; then
        log "WARNING" "curl is not installed. Required for downloading components."
        missing_deps=$((missing_deps + 1))
    fi
    
    # Check for node/npm
    if ! command -v node &> /dev/null; then
        log "WARNING" "Node.js is not installed. Required for JavaScript processing."
        missing_deps=$((missing_deps + 1))
    fi
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        log "WARNING" "jq is not installed. Required for JSON processing."
        missing_deps=$((missing_deps + 1))
    fi
    
    if [ $missing_deps -gt 0 ]; then
        log "ERROR" "$missing_deps dependencies are missing. Please install them before continuing."
        echo -e "${YELLOW}You can install dependencies on Ubuntu/Debian with:${NC}"
        echo "  sudo apt update && sudo apt install -y curl nodejs npm jq"
        echo -e "${YELLOW}You can install dependencies on CentOS/RHEL with:${NC}"
        echo "  sudo yum install -y curl nodejs npm jq"
        echo -e "${YELLOW}You can install dependencies on macOS with:${NC}"
        echo "  brew install curl node jq"
        return 1
    fi
    
    log "SUCCESS" "All dependencies are installed"
    return 0
}

# Function to create backup
create_backup() {
    log "STEP" "Creating backup of current installation..."
    
    mkdir -p "$BACKUP_DIR"
    
    # Backup all important files
    log "INFO" "Backing up configuration files..."
    rsync -a --exclude="backups" --exclude=".git" --exclude="node_modules" --exclude=".temp" "$BASE_DIR/" "$BACKUP_DIR/" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        log "SUCCESS" "Backup created at $BACKUP_DIR"
    else
        log "ERROR" "Failed to create backup"
        exit 1
    fi
}

# Function to run enhancer scripts
run_enhancers() {
    log "STEP" "Running enhancer scripts..."
    
    # Create directory structure
    log "INFO" "Creating directory structure..."
    mkdir -p "${BASE_DIR}/diagrams"
    mkdir -p "${BASE_DIR}/config"
    mkdir -p "${BASE_DIR}/templates/vendor"
    mkdir -p "${BASE_DIR}/js/ai/services"
    
    # Run specific enhancer scripts
    log "INFO" "Enhancing diagram integration..."
    bash "${BASE_DIR}/enhanced-diagram.sh" --all
    
    # Run vendor template implementation
    log "INFO" "Implementing vendor templates..."
    bash "${BASE_DIR}/implement-vendor-templates.sh"
    
    log "SUCCESS" "Enhancer scripts completed successfully"
}

# Function to enhance index.html
enhance_index_html() {
    log "STEP" "Enhancing index.html..."
    
    # Backup original index.html
    cp "${BASE_DIR}/index.html" "${BASE_DIR}/index.html.bak.$(date +%Y%m%d%H%M%S)"
    
    # Update index.html with new features
    log "INFO" "Adding enhanced UI components..."
    
    # Check if index.html exists
    if [ ! -f "${BASE_DIR}/index.html" ]; then
        log "ERROR" "index.html not found"
        return 1
    fi
    
    # Add CSS for enhanced UI
    if ! grep -q "uax-enhanced-styles" "${BASE_DIR}/index.html"; then
        log "INFO" "Adding enhanced styles..."
        
        # Create CSS file
        mkdir -p "${BASE_DIR}/css"
        cat > "${BASE_DIR}/css/uax-enhanced-styles.css" << 'EOF'
/* UaXSupreme Enhanced Styles */
:root {
    --primary-color: #007bff;
    --secondary-color: #6c757d;
    --success-color: #28a745;
    --warning-color: #ffc107;
    --danger-color: #dc3545;
    --light-color: #f8f9fa;
    --dark-color: #343a40;
    --white-color: #ffffff;
    --border-color: #dee2e6;
    --shadow-color: rgba(0, 0, 0, 0.1);
}

body {
    font-family: Arial, Helvetica, sans-serif;
    line-height: 1.6;
    color: #333;
    background-color: #f4f6f9;
    margin: 0;
    padding: 0;
}
EOF
        
        # Add stylesheet link
        sed -i.bak "/<\/head>/i <link rel=\"stylesheet\" href=\"css\/uax-enhanced-styles.css\">" "${BASE_DIR}/index.html"
    fi
    
    # Add script includes if not already present
    if ! grep -q "vendor-selection.js" "${BASE_DIR}/index.html"; then
        log "INFO" "Adding vendor selection script..."
        sed -i.bak "/<\/body>/i <script src=\"js\/vendor-selection.js\"></script>" "${BASE_DIR}/index.html"
    fi
    
    if ! grep -q "diagram_integration.js" "${BASE_DIR}/index.html"; then
        log "INFO" "Adding diagram integration script..."
        sed -i.bak "/<\/body>/i <script src=\"diagrams\/diagram_integration.js\"></script>" "${BASE_DIR}/index.html"
    fi
    
    if ! grep -q "ai-integration.js" "${BASE_DIR}/index.html"; then
        log "INFO" "Adding AI integration scripts..."
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/services\/openai-service.js\"></script>" "${BASE_DIR}/index.html"
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/services\/anthropic-service.js\"></script>" "${BASE_DIR}/index.html"
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/services\/gemini-service.js\"></script>" "${BASE_DIR}/index.html"
        sed -i.bak "/<\/body>/i <script src=\"js\/ai\/ai-integration.js\"></script>" "${BASE_DIR}/index.html"
    fi
    
    log "SUCCESS" "index.html enhanced successfully"
    return 0
}

# Function to download vendor icons
download_vendor_icons() {
    log "STEP" "Downloading vendor icons..."
    
    mkdir -p "${BASE_DIR}/images/stencils"
    
    # Execute all vendor icon download scripts in sequence
    for script in ${BASE_DIR}/download_*_icons.sh; do
        if [ -f "$script" ]; then
            log "INFO" "Running $(basename "$script")..."
            chmod +x "$script"
            bash "$script"
        fi
    done
    
    log "SUCCESS" "Vendor icons downloaded successfully"
}

# Function to create tooltips file
create_tooltips_file() {
    log "STEP" "Creating tooltips and help content..."
    
    mkdir -p "${BASE_DIR}/help"
    
    # Create tooltips JSON file
    cat > "${BASE_DIR}/help/tooltips.json" << 'EOF'
{
    "authentication": {
        "802.1X": "IEEE 802.1X is a standard for port-based network access control that provides an authentication mechanism to devices wishing to attach to a network.",
        "MAB": "MAC Authentication Bypass allows devices that don't support 802.1X to be authenticated based on their MAC address.",
        "RADIUS": "Remote Authentication Dial-In User Service is a network protocol that provides centralized Authentication, Authorization, and Accounting management.",
        "TACACS+": "Terminal Access Controller Access-Control System Plus is a protocol providing detailed AAA for network devices with centralized authentication."
    }
}
EOF

    log "SUCCESS" "Tooltips and help content created successfully"
}

# Main function
main() {
    print_banner
    
    # Parse command line arguments
    DEBUG="false"
    SKIP_BACKUP="false"
    SKIP_DEPENDENCIES="false"
    
    for arg in "$@"; do
        case $arg in
            --debug)
                DEBUG="true"
                ;;
            --skip-backup)
                SKIP_BACKUP="true"
                ;;
            --skip-dependencies)
                SKIP_DEPENDENCIES="true"
                ;;
        esac
    done
    
    log "INFO" "Starting UaXSupreme enhancement process..."
    
    # Check dependencies unless skipped
    if [ "$SKIP_DEPENDENCIES" != "true" ]; then
        check_dependencies || exit 1
    fi
    
    # Create backup unless skipped
    if [ "$SKIP_BACKUP" != "true" ]; then
        create_backup
    else
        log "WARNING" "Skipping backup as requested"
    fi
    
    # Run enhancement steps
    mkdir -p "${BASE_DIR}/diagrams"
    mkdir -p "${BASE_DIR}/config"
    mkdir -p "${BASE_DIR}/templates/vendor"
    
    # Run specific enhancement steps
    enhance_diagram_integration
    implement_vendor_templates
    implement_ai_integration
    enhance_index_html
    download_vendor_icons
    create_tooltips_file
    
    # Create wrapper scripts for vendor implementations
    cat > "${BASE_DIR}/implement-vendor-templates.sh" << 'EOF'
#!/bin/bash
# Script to implement vendor-specific templates for UaXSupreme

# Set base directory to current directory
BASE_DIR="$(pwd)"
TEMPLATES_DIR="${BASE_DIR}/templates/vendor"

# Run implementation
mkdir -p "$TEMPLATES_DIR"
bash "${BASE_DIR}/enhanced-diagram.sh" --all

echo "Vendor templates implementation complete!"
EOF
    chmod +x "${BASE_DIR}/implement-vendor-templates.sh"
    
    log "SUCCESS" "UaXSupreme enhancement completed successfully!"
    log "INFO" "You can now open index.html in your browser to use the enhanced UaXSupreme platform."
}

# Run the main function
main "$@"
EOF

    # Make the script executable
    chmod +x "${BASE_DIR}/UaxEnhance.sh"
    
    log "SUCCESS" "UaXSupreme main script enhanced successfully"
}

# Main function
main() {
    log "STEP" "Running UaXSupreme Enhancement Tool"
    
    # Check dependencies
    check_dependencies || exit 1
    
    # Create backup
    create_backup
    
    # Enhanced diagram integration
    enhance_diagram_integration
    
    # Implement vendor-specific templates
    implement_vendor_templates
    
    # Implement AI integration
    implement_ai_integration
    
    # Enhance main script
    enhance_main_script
    
    log "SUCCESS" "UaXSupreme enhancement completed successfully!"
    log "INFO" "Run ./UaxEnhance.sh to complete the installation"
}

# Run the main function
main
