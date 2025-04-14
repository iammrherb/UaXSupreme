#!/bin/bash

# Main Index Generator Script
# This script generates the main index file for authentication components

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"

echo -e "${BLUE}Generating Main Index File...${RESET}"

# Create master index file for all authentication components
cat > "$BASE_DIR/index.js" << EOF
/**
 * Authentication Components
 * Main entry point for all authentication components
 */

// Import base components
import BaseRadiusComponent from './base/radius/BaseRadiusComponent.js';
import BaseTacacsComponent from './base/tacacs/BaseTacacsComponent.js';
import BaseCoaComponent from './base/coa/BaseCoaComponent.js';
import BaseRadsecComponent from './base/radsec/BaseRadsecComponent.js';

// Import vendor components
import vendorComponents from './vendor/index.js';

// Import advanced components
import advancedComponents from './advanced/index.js';

// Import utilities
import utilities from './utils/index.js';

// Export base components
export {
  BaseRadiusComponent,
  BaseTacacsComponent,
  BaseCoaComponent,
  BaseRadsecComponent
};

// Export vendor components
export const vendors = vendorComponents;

// Export advanced components
export const advanced = advancedComponents;

// Export utilities
export const utils = utilities;

// Export everything in a structured format
export default {
  base: {
    radius: BaseRadiusComponent,
    tacacs: BaseTacacsComponent,
    coa: BaseCoaComponent,
    radsec: BaseRadsecComponent
  },
  vendors: vendorComponents,
  advanced: advancedComponents,
  utils: utilities,
  
  // Factory function to get appropriate component for a vendor
  getComponent(type, vendor) {
    if (!type) {
      throw new Error('Component type is required');
    }
    
    if (vendor && vendorComponents[vendor] && vendorComponents[vendor][type]) {
      return vendorComponents[vendor][type];
    }
    
    // Fall back to base component if vendor-specific one doesn't exist
    switch (type) {
      case 'radius':
        return BaseRadiusComponent;
      case 'tacacs':
        return BaseTacacsComponent;
      case 'coa':
        return BaseCoaComponent;
      case 'radsec':
        return BaseRadsecComponent;
      default:
        if (advancedComponents[type]) {
          return advancedComponents[type];
        }
        throw new Error(\`Unknown component type: \${type}\`);
    }
  }
};
EOF

echo -e "${GREEN}Created main index file for authentication components${RESET}"