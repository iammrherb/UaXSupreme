#!/bin/bash

# Vendor Components Generator Script
# This script generates vendor-specific components for authentication services

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"
SCRIPTS_DIR="./scripts"

echo -e "${BLUE}Generating Vendor-Specific Components...${RESET}"

# Create component directory if it doesn't exist
mkdir -p "$BASE_DIR/vendor"

# Define vendor information with specific capabilities and settings
declare -A VENDOR_INFO
VENDOR_INFO=(
  [cisco]="Cisco Systems|iOS,iOS-XE,NX-OS,ISE|dot1x,mab,radsec,macsec,tacacs"
  [aruba]="HPE Aruba|AOS-CX,AOS-Switch,Instant AP,ClearPass|dot1x,mab,radius,tacacs,cppm"
  [juniper]="Juniper Networks|JunOS,EX Series,SRX Series|dot1x,mab,radius,tacacs"
  [hp]="Hewlett Packard Enterprise|ProVision,Comware|dot1x,mab,radius,tacacs"
  [extreme]="Extreme Networks|EXOS,VOSS,Wing|dot1x,mab,radius,tacacs"
  [fortinet]="Fortinet|FortiOS,FortiSwitch,FortiWLC|dot1x,mab,radius,tacacs,802.1x"
  [dell]="Dell Technologies|OS10,OS9,OS6|dot1x,mab,radius,tacacs"
  [huawei]="Huawei|VRP,S-Series,USG|dot1x,mab,radius,tacacs"
  [ruckus]="CommScope Ruckus|FastIron,SmartZone,ICX|dot1x,mab,radius"
  [paloalto]="Palo Alto Networks|PAN-OS,Panorama|vpn,radius,tacacs,certauth"
  [checkpoint]="Check Point Software|Gaia,MDS|vpn,radius,tacacs,identity"
  [f5]="F5 Networks|BIG-IP,TMOS|vpn,radius,tacacs,policyauth"
)

# Array of vendor names
VENDORS=("cisco" "aruba" "juniper" "hp" "extreme" "fortinet" "dell" "huawei" "ruckus" "paloalto" "checkpoint" "f5")

# For each vendor, generate component files
for vendor in "${VENDORS[@]}"; do
  # Parse vendor info
  IFS='|' read -r VENDOR_DISPLAY VENDOR_PLATFORMS VENDOR_CAPABILITIES <<< "${VENDOR_INFO[$vendor]}"
  
  # Create vendor directory if it doesn't exist
  mkdir -p "$BASE_DIR/vendor/$vendor"
  
  # Create README.md with vendor info
  cat > "$BASE_DIR/vendor/$vendor/README.md" << EOF
# ${VENDOR_DISPLAY} Authentication Components

This directory contains authentication components specific to ${VENDOR_DISPLAY} networking equipment.

## Supported Platforms

$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed 's/^/- /')

## Capabilities

$(echo $VENDOR_CAPABILITIES | tr ',' '\n' | sed 's/^/- /')

## Implementation Notes

The ${VENDOR_DISPLAY} components extend the base authentication components with vendor-specific 
functionality and configuration syntax.
EOF
  
  # Create subdirectories
  mkdir -p "$BASE_DIR/vendor/$vendor/radius"
  mkdir -p "$BASE_DIR/vendor/$vendor/tacacs"
  mkdir -p "$BASE_DIR/vendor/$vendor/coa"
  mkdir -p "$BASE_DIR/vendor/$vendor/radsec"
  mkdir -p "$BASE_DIR/vendor/$vendor/utils"
  
  # Create index.js file for the vendor
  cat > "$BASE_DIR/vendor/$vendor/index.js" << EOF
/**
 * ${VENDOR_DISPLAY} Authentication Components
 * This file exports all ${vendor^}-specific authentication components
 * 
 * Supported platforms:
 * - $(echo $VENDOR_PLATFORMS | sed 's/,/\n * - /g')
 * 
 * Capabilities:
 * - $(echo $VENDOR_CAPABILITIES | sed 's/,/\n * - /g')
 */

import ${vendor^}RadiusComponent from './radius/${vendor^}RadiusComponent.js';
import ${vendor^}TacacsComponent from './tacacs/${vendor^}TacacsComponent.js';
import ${vendor^}CoaComponent from './coa/${vendor^}CoaComponent.js';
import ${vendor^}RadsecComponent from './radsec/${vendor^}RadsecComponent.js';

export {
  ${vendor^}RadiusComponent,
  ${vendor^}TacacsComponent,
  ${vendor^}CoaComponent,
  ${vendor^}RadsecComponent
};

export default {
  radius: ${vendor^}RadiusComponent,
  tacacs: ${vendor^}TacacsComponent,
  coa: ${vendor^}CoaComponent,
  radsec: ${vendor^}RadsecComponent
};
EOF
  
  echo -e "${GREEN}Created index.js for ${vendor}${RESET}"
  
  # Create placeholder files for components that don't exist yet
  # Each vendor directory should have RADIUS, TACACS+, CoA, and RADSEC components
  
  # RADIUS Component
  if [ ! -f "$BASE_DIR/vendor/$vendor/radius/${vendor^}RadiusComponent.js" ]; then
    # Check if we have a specific template for this vendor
    if [ "$vendor" = "cisco" ] && [ -f "$SCRIPTS_DIR/cisco-radius-component.js" ]; then
      cp "$SCRIPTS_DIR/cisco-radius-component.js" "$BASE_DIR/vendor/$vendor/radius/${vendor^}RadiusComponent.js"
    elif [ "$vendor" = "aruba" ] && [ -f "$SCRIPTS_DIR/aruba-radius-component.js" ]; then
      cp "$SCRIPTS_DIR/aruba-radius-component.js" "$BASE_DIR/vendor/$vendor/radius/${vendor^}RadiusComponent.js"
    else
      # Create a default vendor component with custom capabilities based on vendor info
      cat > "$BASE_DIR/vendor/$vendor/radius/${vendor^}RadiusComponent.js" << EOF
/**
 * ${vendor^}RadiusComponent.js
 * ${VENDOR_DISPLAY}-specific implementation of RADIUS configuration
 * 
 * Supported platforms:
 * - $(echo $VENDOR_PLATFORMS | sed 's/,/\n * - /g')
 * 
 * Capabilities:
 * - $(echo $VENDOR_CAPABILITIES | sed 's/,/\n * - /g')
 */

import { BaseRadiusComponent } from '../../../base/radius/BaseRadiusComponent.js';

export class ${vendor^}RadiusComponent extends BaseRadiusComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // Platform support
      platforms: {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/        /g" | sed "s/\(.*\)/\1: {/g" | sed "s/$/ enabled: true },/g")
      },
      
      // ${vendor^}-specific settings
      settings: {
        // Authentication settings
        authentication: {
          // Add vendor-specific authentication settings
        },
        
        // Authorization settings
        authorization: {
          // Add vendor-specific authorization settings
        },
        
        // Accounting settings
        accounting: {
          // Add vendor-specific accounting settings
        }
      },
      
      // Advanced features
      features: {
$(echo $VENDOR_CAPABILITIES | tr ',' '\n' | sed "s/^/        /g" | sed "s/\(.*\)/\1: true,/g")
      }
    };
    
    // Extend the validator with ${vendor^}-specific validations
    if (this.validator) {
      this.register${vendor^}Validations();
    }
  }
  
  /**
   * Register ${vendor^}-specific validations
   */
  register${vendor^}Validations() {
    // Add ${vendor^}-specific validations for RADIUS configuration
    // Example validation for platform selection
    this.validator.register('${vendor}Specific.platforms', {
      type: 'object',
      required: true,
      message: '${VENDOR_DISPLAY} platform configuration is required'
    });
    
    // Add more validations as needed
  }
  
  /**
   * Generate ${vendor^} RADIUS configuration based on platform
   * @param {String} platform Platform name (optional)
   * @returns {String} Configuration commands as a string
   */
  generateConfig(platform = '') {
    let config = '';
    
    // Header with vendor information
    config += '! ${VENDOR_DISPLAY} RADIUS Configuration\n';
    config += '! Generated by Authentication Components Library\n!\n';
    
    // Platform-specific configuration
    const platforms = Object.keys(this.config.${vendor}Specific.platforms)
      .filter(p => this.config.${vendor}Specific.platforms[p].enabled);
    
    // Use specified platform or first enabled platform
    const targetPlatform = platform || (platforms.length > 0 ? platforms[0] : '');
    
    if (targetPlatform) {
      config += \`! Platform: \${targetPlatform}\n!\n\`;
      
      // Add platform-specific RADIUS configuration
      switch(targetPlatform.toLowerCase()) {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/        case '/g" | sed "s/$/':/g")
          // Platform-specific configuration generation
          config += this.generate${vendor^}PlatformConfig(targetPlatform, this.config);
          break;
        default:
          config += '! Unknown platform, using generic configuration\n';
          config += this.generateGenericConfig();
      }
    } else {
      // Generic configuration if no platform specified
      config += '! No specific platform selected\n!\n';
      config += this.generateGenericConfig();
    }
    
    return config;
  }
  
  /**
   * Generate generic ${vendor^} RADIUS configuration
   * @returns {String} Generic configuration
   */
  generateGenericConfig() {
    let config = '';
    
    // Add basic RADIUS server configuration
    if (this.config.primaryServer.address) {
      config += \`radius-server host \${this.config.primaryServer.address}\n\`;
      config += \`radius-server key \${this.config.primaryServer.secret}\n\`;
    }
    
    // Add basic settings
    config += \`radius-server timeout \${this.config.general.timeout}\n\`;
    config += \`radius-server retransmit \${this.config.general.retransmit}\n\`;
    
    return config;
  }
  
  /**
   * Generate ${vendor^} platform-specific configuration
   * @param {String} platform Platform name
   * @param {Object} config Configuration object
   * @returns {String} Platform-specific configuration
   */
  generate${vendor^}PlatformConfig(platform, config) {
    // Implement platform-specific configuration generation
    return \`! TODO: Implement \${platform}-specific configuration\n\`;
  }
}

export default ${vendor^}RadiusComponent;
EOF
    fi
    
    echo -e "${GREEN}Created RADIUS component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}RADIUS component already exists for ${vendor}${RESET}"
  fi
  
  # TACACS+ Component with similar enhancements
  if [ ! -f "$BASE_DIR/vendor/$vendor/tacacs/${vendor^}TacacsComponent.js" ]; then
    cat > "$BASE_DIR/vendor/$vendor/tacacs/${vendor^}TacacsComponent.js" << EOF
/**
 * ${vendor^}TacacsComponent.js
 * ${VENDOR_DISPLAY}-specific implementation of TACACS+ configuration
 * 
 * Supported platforms:
 * - $(echo $VENDOR_PLATFORMS | sed 's/,/\n * - /g')
 */

import { BaseTacacsComponent } from '../../../base/tacacs/BaseTacacsComponent.js';

export class ${vendor^}TacacsComponent extends BaseTacacsComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // Platform support
      platforms: {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/        /g" | sed "s/\(.*\)/\1: {/g" | sed "s/$/ enabled: true },/g")
      },
      
      // ${vendor^}-specific TACACS+ settings
      settings: {
        // Authentication settings
        authentication: {
          // Add vendor-specific authentication settings
        },
        
        // Authorization settings
        authorization: {
          // Add vendor-specific authorization settings
        },
        
        // Accounting settings
        accounting: {
          // Add vendor-specific accounting settings
        }
      }
    };
    
    // Extend the validator with ${vendor^}-specific validations
    if (this.validator) {
      this.register${vendor^}Validations();
    }
  }
  
  /**
   * Register ${vendor^}-specific validations
   */
  register${vendor^}Validations() {
    // TODO: Add ${vendor^}-specific validations for TACACS+
  }
  
  /**
   * Generate ${vendor^} TACACS+ configuration based on platform
   * @param {String} platform Platform name (optional)
   * @returns {String} Configuration commands as a string
   */
  generateConfig(platform = '') {
    let config = '';
    
    // Header with vendor information
    config += '! ${VENDOR_DISPLAY} TACACS+ Configuration\n';
    config += '! Generated by Authentication Components Library\n!\n';
    
    // Platform-specific configuration
    const platforms = Object.keys(this.config.${vendor}Specific.platforms)
      .filter(p => this.config.${vendor}Specific.platforms[p].enabled);
    
    // Use specified platform or first enabled platform
    const targetPlatform = platform || (platforms.length > 0 ? platforms[0] : '');
    
    if (targetPlatform) {
      config += \`! Platform: \${targetPlatform}\n!\n\`;
      
      // Add platform-specific TACACS+ configuration
      // TODO: Implement platform-specific configuration
    } else {
      // Generic configuration if no platform specified
      config += '! No specific platform selected\n!\n';
      
      // Add basic TACACS+ server configuration
      if (this.config.primaryServer.address) {
        config += \`tacacs-server host \${this.config.primaryServer.address}\n\`;
        config += \`tacacs-server key \${this.config.primaryServer.secret}\n\`;
      }
    }
    
    return config;
  }
}

export default ${vendor^}TacacsComponent;
EOF
    
    echo -e "${GREEN}Created TACACS+ component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}TACACS+ component already exists for ${vendor}${RESET}"
  fi
  
  # CoA Component with similar enhancements
  if [ ! -f "$BASE_DIR/vendor/$vendor/coa/${vendor^}CoaComponent.js" ]; then
    cat > "$BASE_DIR/vendor/$vendor/coa/${vendor^}CoaComponent.js" << EOF
/**
 * ${vendor^}CoaComponent.js
 * ${VENDOR_DISPLAY}-specific implementation of Change of Authorization (CoA)
 * 
 * Supported platforms:
 * - $(echo $VENDOR_PLATFORMS | sed 's/,/\n * - /g')
 */

import { BaseCoaComponent } from '../../../base/coa/BaseCoaComponent.js';

export class ${vendor^}CoaComponent extends BaseCoaComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // Platform support
      platforms: {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/        /g" | sed "s/\(.*\)/\1: {/g" | sed "s/$/ enabled: true },/g")
      },
      
      // ${vendor^}-specific CoA settings
      settings: {
        // Add vendor-specific CoA settings
      }
    };
    
    // Extend the validator with ${vendor^}-specific validations
    if (this.validator) {
      this.register${vendor^}Validations();
    }
  }
  
  /**
   * Register ${vendor^}-specific validations
   */
  register${vendor^}Validations() {
    // TODO: Add ${vendor^}-specific validations for CoA
  }
  
  /**
   * Generate ${vendor^} CoA configuration
   * @param {String} platform Platform name (optional)
   * @returns {String} Configuration commands as a string
   */
  generateConfig(platform = '') {
    let config = '';
    
    // Header with vendor information
    config += '! ${VENDOR_DISPLAY} CoA Configuration\n';
    config += '! Generated by Authentication Components Library\n!\n';
    
    // Platform-specific configuration or generic configuration
    // TODO: Implement platform-specific configuration
    
    return config;
  }
}

export default ${vendor^}CoaComponent;
EOF
    
    echo -e "${GREEN}Created CoA component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}CoA component already exists for ${vendor}${RESET}"
  fi
  
  # RADSEC Component with similar enhancements
  if [ ! -f "$BASE_DIR/vendor/$vendor/radsec/${vendor^}RadsecComponent.js" ]; then
    cat > "$BASE_DIR/vendor/$vendor/radsec/${vendor^}RadsecComponent.js" << EOF
/**
 * ${vendor^}RadsecComponent.js
 * ${VENDOR_DISPLAY}-specific implementation of RADSEC configuration
 * 
 * Supported platforms:
 * - $(echo $VENDOR_PLATFORMS | sed 's/,/\n * - /g')
 */

import { BaseRadsecComponent } from '../../../base/radsec/BaseRadsecComponent.js';

export class ${vendor^}RadsecComponent extends BaseRadsecComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // Platform support
      platforms: {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/        /g" | sed "s/\(.*\)/\1: {/g" | sed "s/$/ enabled: true },/g")
      },
      
      // ${vendor^}-specific RADSEC settings
      settings: {
        // Add vendor-specific RADSEC settings
      }
    };
    
    // Extend the validator with ${vendor^}-specific validations
    if (this.validator) {
      this.register${vendor^}Validations();
    }
  }
  
  /**
   * Register ${vendor^}-specific validations
   */
  register${vendor^}Validations() {
    // TODO: Add ${vendor^}-specific validations for RADSEC
  }
  
  /**
   * Generate ${vendor^} RADSEC configuration
   * @param {String} platform Platform name (optional)
   * @returns {String} Configuration commands as a string
   */
  generateConfig(platform = '') {
    let config = '';
    
    // Header with vendor information
    config += '! ${VENDOR_DISPLAY} RADSEC Configuration\n';
    config += '! Generated by Authentication Components Library\n!\n';
    
    // Platform-specific configuration or generic configuration
    // TODO: Implement platform-specific configuration
    
    return config;
  }
}

export default ${vendor^}RadsecComponent;
EOF
    
    echo -e "${GREEN}Created RADSEC component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}RADSEC component already exists for ${vendor}${RESET}"
  fi
  
  # Create a utils directory with vendor-specific helper functions
  mkdir -p "$BASE_DIR/vendor/$vendor/utils"
  
  if [ ! -f "$BASE_DIR/vendor/$vendor/utils/helpers.js" ]; then
    cat > "$BASE_DIR/vendor/$vendor/utils/helpers.js" << EOF
/**
 * ${VENDOR_DISPLAY} Helper Utilities
 * This file contains helper functions specific to ${VENDOR_DISPLAY} devices
 */

/**
 * Format command output for ${VENDOR_DISPLAY} devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/    case '/g" | sed "s/$/':/g")
      // Add platform-specific formatting
      return command;
    default:
      return command;
  }
}

/**
 * Check if a feature is supported on this platform
 * @param {String} feature Feature to check
 * @param {String} platform Platform name
 * @returns {Boolean} True if feature is supported
 */
export function isFeatureSupported(feature, platform) {
  // Define platform-feature support matrix
  const featureMatrix = {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/    /g" | sed "s/\(.*\)/\1: {/g")
$(echo $VENDOR_CAPABILITIES | tr ',' '\n' | sed "s/^/      /g" | sed "s/\(.*\)/\1: true,/g")
    },
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/    /g" | sed "s/$/ },/g")
  };
  
  return featureMatrix[platform] && featureMatrix[platform][feature] === true;
}

/**
 * Get platform-specific command syntax
 * @param {String} commandType Type of command
 * @param {String} platform Platform name
 * @returns {String} Command syntax template
 */
export function getCommandSyntax(commandType, platform) {
  // Define command syntax for different platforms
  const syntaxMatrix = {
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/    /g" | sed "s/\(.*\)/\1: {/g")
      'radius-server': '${vendor}-radius-server {address} key {secret}',
      'tacacs-server': '${vendor}-tacacs-server {address} key {secret}',
      'aaa': '${vendor}-aaa {method} {type}'
    },
$(echo $VENDOR_PLATFORMS | tr ',' '\n' | sed "s/^/    /g" | sed "s/$/ },/g")
  };
  
  if (syntaxMatrix[platform] && syntaxMatrix[platform][commandType]) {
    return syntaxMatrix[platform][commandType];
  }
  
  // Default syntax
  return '{command} {params}';
}

export default {
  formatCommand,
  isFeatureSupported,
  getCommandSyntax
};
EOF
    
    echo -e "${GREEN}Created helper utilities for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}Helper utilities already exist for ${vendor}${RESET}"
  fi
  
done

# Create an index file that exports all vendor components
cat > "$BASE_DIR/vendor/index.js" << EOF
/**
 * Vendor-Specific Authentication Components
 * This file exports all vendor-specific authentication components
 */

// Import all vendor modules
import ciscoComponents from './cisco/index.js';
import arubaComponents from './aruba/index.js';
import juniperComponents from './juniper/index.js';
import hpComponents from './hp/index.js';
import extremeComponents from './extreme/index.js';
import fortinetComponents from './fortinet/index.js';
import dellComponents from './dell/index.js';
import huaweiComponents from './huawei/index.js';
import ruckusComponents from './ruckus/index.js';
import paloaltoComponents from './paloalto/index.js';
import checkpointComponents from './checkpoint/index.js';
import f5Components from './f5/index.js';

// Export as named exports
export {
  ciscoComponents,
  arubaComponents,
  juniperComponents,
  hpComponents,
  extremeComponents,
  fortinetComponents,
  dellComponents,
  huaweiComponents,
  ruckusComponents,
  paloaltoComponents,
  checkpointComponents,
  f5Components
};

// Export by vendor name for dynamic access
export default {
  cisco: ciscoComponents,
  aruba: arubaComponents,
  juniper: juniperComponents,
  hp: hpComponents,
  extreme: extremeComponents,
  fortinet: fortinetComponents,
  dell: dellComponents,
  huawei: huaweiComponents,
  ruckus: ruckusComponents,
  paloalto: paloaltoComponents,
  checkpoint: checkpointComponents,
  f5: f5Components
};

/**
 * Get component by vendor and type
 * @param {String} vendor Vendor name
 * @param {String} type Component type (radius, tacacs, coa, radsec)
 * @returns {Object} Vendor-specific component
 */
export function getVendorComponent(vendor, type) {
  if (!vendor || !type) {
    throw new Error('Vendor and type are required');
  }
  
  const vendorMap = {
    'cisco': ciscoComponents,
    'aruba': arubaComponents,
    'juniper': juniperComponents,
    'hp': hpComponents,
    'extreme': extremeComponents,
    'fortinet': fortinetComponents,
    'dell': dellComponents,
    'huawei': huaweiComponents,
    'ruckus': ruckusComponents,
    'paloalto': paloaltoComponents,
    'checkpoint': checkpointComponents,
    'f5': f5Components
  };
  
  // Get vendor components
  const vendorComponents = vendorMap[vendor.toLowerCase()];
  if (!vendorComponents) {
    throw new Error(\`Vendor "\${vendor}" not found\`);
  }
  
  // Get specific component type
  const component = vendorComponents[type.toLowerCase()];
  if (!component) {
    throw new Error(\`Component type "\${type}" not found for vendor "\${vendor}"\`);
  }
  
  return component;
}
EOF

echo -e "${GREEN}Created vendor index file${RESET}"

# Create a README for the vendor directory
cat > "$BASE_DIR/vendor/README.md" << EOF
# Vendor-Specific Authentication Components

This directory contains vendor-specific implementations of authentication components.

## Supported Vendors

$(for vendor in "${VENDORS[@]}"; do
  IFS='|' read -r VENDOR_DISPLAY VENDOR_PLATFORMS VENDOR_CAPABILITIES <<< "${VENDOR_INFO[$vendor]}"
  echo "### $VENDOR_DISPLAY"
  echo ""
  echo "**Platforms:** $(echo $VENDOR_PLATFORMS | sed 's/,/, /g')"
  echo ""
  echo "**Capabilities:** $(echo $VENDOR_CAPABILITIES | sed 's/,/, /g')"
  echo ""
done)

## Usage

Import vendor-specific components directly:

\`\`\`javascript
import { CiscoRadiusComponent } from './vendor/cisco/radius/CiscoRadiusComponent.js';

// Create an instance
const ciscoRadius = new CiscoRadiusComponent();
\`\`\`

Or use the factory method:

\`\`\`javascript
import { getVendorComponent } from './vendor/index.js';

// Get vendor component by name and type
const juniperTacacs = getVendorComponent('juniper', 'tacacs');
\`\`\`
EOF

echo -e "${GREEN}Created vendor directory README${RESET}"