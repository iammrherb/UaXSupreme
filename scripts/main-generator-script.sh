#!/bin/bash

# Authentication Components Generator Master Script
# This script orchestrates the generation of all authentication components

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

echo -e "${BLUE}Starting Authentication Components Generation...${RESET}"

# Create scripts directory if it doesn't exist
SCRIPTS_DIR="./scripts"
mkdir -p "$SCRIPTS_DIR"

# Write the directory structure script
cat > "$SCRIPTS_DIR/01-create-structure.sh" << 'EOL'
#!/bin/bash

# Authentication Components Structure Setup Script
# This script sets up the directory structure for authentication components

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"

echo -e "${BLUE}Creating Authentication Components Directory Structure...${RESET}"

# Create base directories
mkdir -p "$BASE_DIR/base"
mkdir -p "$BASE_DIR/vendor"
mkdir -p "$BASE_DIR/advanced"
mkdir -p "$BASE_DIR/utils"

# Create base component directories
mkdir -p "$BASE_DIR/base/radius"
mkdir -p "$BASE_DIR/base/tacacs"
mkdir -p "$BASE_DIR/base/coa"
mkdir -p "$BASE_DIR/base/radsec"
mkdir -p "$BASE_DIR/base/common"

# Create vendor-specific directories for major vendors
VENDORS=("cisco" "aruba" "juniper" "hp" "extreme" "fortinet" "dell" "huawei" "ruckus" "paloalto" "checkpoint" "f5")

for vendor in "${VENDORS[@]}"; do
  mkdir -p "$BASE_DIR/vendor/$vendor/radius"
  mkdir -p "$BASE_DIR/vendor/$vendor/tacacs"
  mkdir -p "$BASE_DIR/vendor/$vendor/coa"
  mkdir -p "$BASE_DIR/vendor/$vendor/radsec"
  mkdir -p "$BASE_DIR/vendor/$vendor/utils"
  
  echo -e "${GREEN}Created directory structure for vendor: $vendor${RESET}"
done

# Create advanced authentication components directories
mkdir -p "$BASE_DIR/advanced/eap"
mkdir -p "$BASE_DIR/advanced/mab"
mkdir -p "$BASE_DIR/advanced/webauth"
mkdir -p "$BASE_DIR/advanced/macsec"
mkdir -p "$BASE_DIR/advanced/pki"
mkdir -p "$BASE_DIR/advanced/posture"
mkdir -p "$BASE_DIR/advanced/mfa"
mkdir -p "$BASE_DIR/advanced/byod"
mkdir -p "$BASE_DIR/advanced/guest"
mkdir -p "$BASE_DIR/advanced/profiling"
mkdir -p "$BASE_DIR/advanced/idp"

# Create utility directories
mkdir -p "$BASE_DIR/utils/validation"
mkdir -p "$BASE_DIR/utils/templates"
mkdir -p "$BASE_DIR/utils/generators"
mkdir -p "$BASE_DIR/utils/converters"
mkdir -p "$BASE_DIR/utils/factory"

echo -e "${GREEN}Directory structure created successfully.${RESET}"
EOL

# Write the base components generator script
cat > "$SCRIPTS_DIR/02-generate-base-components.sh" << 'EOL'
#!/bin/bash

# Base Components Generator Script
# This script generates the base authentication components

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"

echo -e "${BLUE}Generating Base Authentication Components...${RESET}"

# Create ValidationService
mkdir -p "$BASE_DIR/utils/validation"
echo -e "${YELLOW}Creating ValidationService...${RESET}"

# Check if ValidationService.js already exists to avoid overwriting
if [ -f "$BASE_DIR/utils/validation/ValidationService.js" ]; then
  echo -e "${YELLOW}ValidationService.js already exists, skipping...${RESET}"
else
  # Create ValidationService.js
  # (The actual content would be copied from the ValidationService implementation)
  echo "/**
 * ValidationService.js
 * A flexible validation service for authentication components.
 * 
 * NOTE: This is a placeholder. Replace with the actual implementation.
 */
 
export class ValidationService {
  constructor() {
    // Implementation goes here
  }
}

export default ValidationService;" > "$BASE_DIR/utils/validation/ValidationService.js"
  
  echo -e "${GREEN}Created ValidationService${RESET}"
fi

# Create base components
echo -e "${YELLOW}Creating BaseRadiusComponent...${RESET}"

# Check if BaseRadiusComponent.js already exists
if [ -f "$BASE_DIR/base/radius/BaseRadiusComponent.js" ]; then
  echo -e "${YELLOW}BaseRadiusComponent.js already exists, skipping...${RESET}"
else
  # Create BaseRadiusComponent.js
  # (The actual content would be copied from the BaseRadiusComponent implementation)
  echo "/**
 * BaseRadiusComponent.js
 * Base RADIUS configuration component that serves as the foundation for vendor-specific extensions.
 * 
 * NOTE: This is a placeholder. Replace with the actual implementation.
 */
 
import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseRadiusComponent extends EventEmitter {
  constructor(options = {}) {
    // Implementation goes here
  }
}

export default BaseRadiusComponent;" > "$BASE_DIR/base/radius/BaseRadiusComponent.js"
  
  echo -e "${GREEN}Created BaseRadiusComponent${RESET}"
fi

# Repeat for other base components: TACACS+, CoA, RADSEC
echo -e "${YELLOW}Creating BaseTacacsComponent...${RESET}"
if [ -f "$BASE_DIR/base/tacacs/BaseTacacsComponent.js" ]; then
  echo -e "${YELLOW}BaseTacacsComponent.js already exists, skipping...${RESET}"
else
  echo "/**
 * BaseTacacsComponent.js
 * Base TACACS+ configuration component that serves as the foundation for vendor-specific extensions.
 * 
 * NOTE: This is a placeholder. Replace with the actual implementation.
 */
 
import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseTacacsComponent extends EventEmitter {
  constructor(options = {}) {
    // Implementation goes here
  }
}

export default BaseTacacsComponent;" > "$BASE_DIR/base/tacacs/BaseTacacsComponent.js"
  
  echo -e "${GREEN}Created BaseTacacsComponent${RESET}"
fi

echo -e "${YELLOW}Creating BaseCoaComponent...${RESET}"
if [ -f "$BASE_DIR/base/coa/BaseCoaComponent.js" ]; then
  echo -e "${YELLOW}BaseCoaComponent.js already exists, skipping...${RESET}"
else
  echo "/**
 * BaseCoaComponent.js
 * Base Change of Authorization (CoA) component that serves as the foundation for vendor-specific extensions.
 * 
 * NOTE: This is a placeholder. Replace with the actual implementation.
 */
 
import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseCoaComponent extends EventEmitter {
  constructor(options = {}) {
    // Implementation goes here
  }
}

export default BaseCoaComponent;" > "$BASE_DIR/base/coa/BaseCoaComponent.js"
  
  echo -e "${GREEN}Created BaseCoaComponent${RESET}"
fi

echo -e "${YELLOW}Creating BaseRadsecComponent...${RESET}"
if [ -f "$BASE_DIR/base/radsec/BaseRadsecComponent.js" ]; then
  echo -e "${YELLOW}BaseRadsecComponent.js already exists, skipping...${RESET}"
else
  echo "/**
 * BaseRadsecComponent.js
 * Base RADSEC (RADIUS over TLS) component that serves as the foundation for vendor-specific extensions.
 * 
 * NOTE: This is a placeholder. Replace with the actual implementation.
 */
 
import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseRadsecComponent extends EventEmitter {
  constructor(options = {}) {
    // Implementation goes here
  }
}

export default BaseRadsecComponent;" > "$BASE_DIR/base/radsec/BaseRadsecComponent.js"
  
  echo -e "${GREEN}Created BaseRadsecComponent${RESET}"
fi

# Create base components index file
echo -e "${YELLOW}Creating base components index file...${RESET}"
cat > "$BASE_DIR/base/index.js" << EOF
/**
 * Base Authentication Components
 * This file exports all base authentication components
 */

import BaseRadiusComponent from './radius/BaseRadiusComponent.js';
import BaseTacacsComponent from './tacacs/BaseTacacsComponent.js';
import BaseCoaComponent from './coa/BaseCoaComponent.js';
import BaseRadsecComponent from './radsec/BaseRadsecComponent.js';

export {
  BaseRadiusComponent,
  BaseTacacsComponent,
  BaseCoaComponent,
  BaseRadsecComponent
};

export default {
  radius: BaseRadiusComponent,
  tacacs: BaseTacacsComponent,
  coa: BaseCoaComponent,
  radsec: BaseRadsecComponent
};
EOF

echo -e "${GREEN}Created base components index file${RESET}"

echo -e "${GREEN}Base components generation completed${RESET}"
EOL

# Write the vendor components generator script
cat > "$SCRIPTS_DIR/03-generate-vendor-components.sh" << 'EOL'
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

echo -e "${BLUE}Generating Vendor-Specific Components...${RESET}"

# Create component directory if it doesn't exist
mkdir -p "$BASE_DIR/vendor"

# Array of vendor names
VENDORS=("cisco" "aruba" "juniper" "hp" "extreme" "fortinet" "dell" "huawei" "ruckus" "paloalto" "checkpoint" "f5")

# For each vendor, generate component files
for vendor in "${VENDORS[@]}"; do
  # Create vendor directory if it doesn't exist
  mkdir -p "$BASE_DIR/vendor/$vendor"
  
  # Create subdirectories
  mkdir -p "$BASE_DIR/vendor/$vendor/radius"
  mkdir -p "$BASE_DIR/vendor/$vendor/tacacs"
  mkdir -p "$BASE_DIR/vendor/$vendor/coa"
  mkdir -p "$BASE_DIR/vendor/$vendor/radsec"
  
  # Create index.js file for the vendor
  cat > "$BASE_DIR/vendor/$vendor/index.js" << EOF
/**
 * ${vendor^} Authentication Components
 * This file exports all ${vendor^}-specific authentication components
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
    cat > "$BASE_DIR/vendor/$vendor/radius/${vendor^}RadiusComponent.js" << EOF
/**
 * ${vendor^}RadiusComponent.js
 * ${vendor^}-specific implementation of RADIUS configuration
 */

import { BaseRadiusComponent } from '../../../base/radius/BaseRadiusComponent.js';

export class ${vendor^}RadiusComponent extends BaseRadiusComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // TODO: Add ${vendor^}-specific configuration options
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
    // TODO: Add ${vendor^}-specific validations
  }
  
  /**
   * Generate ${vendor^} RADIUS configuration
   * @returns {String} Configuration commands as a string
   */
  generateConfig() {
    let config = '';
    
    // TODO: Implement ${vendor^}-specific configuration generation
    config += '! ${vendor^} RADIUS Configuration\n!\n';
    
    return config;
  }
}

export default ${vendor^}RadiusComponent;
EOF
    
    echo -e "${GREEN}Created RADIUS component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}RADIUS component already exists for ${vendor}${RESET}"
  fi
  
  # TACACS+ Component
  if [ ! -f "$BASE_DIR/vendor/$vendor/tacacs/${vendor^}TacacsComponent.js" ]; then
    cat > "$BASE_DIR/vendor/$vendor/tacacs/${vendor^}TacacsComponent.js" << EOF
/**
 * ${vendor^}TacacsComponent.js
 * ${vendor^}-specific implementation of TACACS+ configuration
 */

import { BaseTacacsComponent } from '../../../base/tacacs/BaseTacacsComponent.js';

export class ${vendor^}TacacsComponent extends BaseTacacsComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // TODO: Add ${vendor^}-specific configuration options
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
    // TODO: Add ${vendor^}-specific validations
  }
  
  /**
   * Generate ${vendor^} TACACS+ configuration
   * @returns {String} Configuration commands as a string
   */
  generateConfig() {
    let config = '';
    
    // TODO: Implement ${vendor^}-specific configuration generation
    config += '! ${vendor^} TACACS+ Configuration\n!\n';
    
    return config;
  }
}

export default ${vendor^}TacacsComponent;
EOF
    
    echo -e "${GREEN}Created TACACS+ component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}TACACS+ component already exists for ${vendor}${RESET}"
  fi
  
  # CoA Component
  if [ ! -f "$BASE_DIR/vendor/$vendor/coa/${vendor^}CoaComponent.js" ]; then
    cat > "$BASE_DIR/vendor/$vendor/coa/${vendor^}CoaComponent.js" << EOF
/**
 * ${vendor^}CoaComponent.js
 * ${vendor^}-specific implementation of Change of Authorization (CoA)
 */

import { BaseCoaComponent } from '../../../base/coa/BaseCoaComponent.js';

export class ${vendor^}CoaComponent extends BaseCoaComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // TODO: Add ${vendor^}-specific configuration options
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
    // TODO: Add ${vendor^}-specific validations
  }
  
  /**
   * Generate ${vendor^} CoA configuration
   * @returns {String} Configuration commands as a string
   */
  generateConfig() {
    let config = '';
    
    // TODO: Implement ${vendor^}-specific configuration generation
    config += '! ${vendor^} CoA Configuration\n!\n';
    
    return config;
  }
}

export default ${vendor^}CoaComponent;
EOF
    
    echo -e "${GREEN}Created CoA component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}CoA component already exists for ${vendor}${RESET}"
  fi
  
  # RADSEC Component
  if [ ! -f "$BASE_DIR/vendor/$vendor/radsec/${vendor^}RadsecComponent.js" ]; then
    cat > "$BASE_DIR/vendor/$vendor/radsec/${vendor^}RadsecComponent.js" << EOF
/**
 * ${vendor^}RadsecComponent.js
 * ${vendor^}-specific implementation of RADSEC configuration
 */

import { BaseRadsecComponent } from '../../../base/radsec/BaseRadsecComponent.js';

export class ${vendor^}RadsecComponent extends BaseRadsecComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add ${vendor^}-specific configuration options
    this.config.${vendor}Specific = {
      // TODO: Add ${vendor^}-specific configuration options
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
    // TODO: Add ${vendor^}-specific validations
  }
  
  /**
   * Generate ${vendor^} RADSEC configuration
   * @returns {String} Configuration commands as a string
   */
  generateConfig() {
    let config = '';
    
    // TODO: Implement ${vendor^}-specific configuration generation
    config += '! ${vendor^} RADSEC Configuration\n!\n';
    
    return config;
  }
}

export default ${vendor^}RadsecComponent;
EOF
    
    echo -e "${GREEN}Created RADSEC component for ${vendor}${RESET}"
  else
    echo -e "${YELLOW}RADSEC component already exists for ${vendor}${RESET}"
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
EOF

echo -e "${GREEN}Created vendor index file${RESET}"
EOL

# Write the advanced components generator script
cat > "$SCRIPTS_DIR/04-generate-advanced-components.sh" << 'EOL'
#!/bin/bash

# Advanced Components Generator Script
# This script generates advanced authentication components

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"

echo -e "${BLUE}Generating Advanced Authentication Components...${RESET}"

# Create advanced authentication components directory if it doesn't exist
mkdir -p "$BASE_DIR/advanced"

# Define advanced component types
ADVANCED_COMPONENTS=("eap" "mab" "webauth" "macsec" "pki" "posture" "mfa" "byod" "guest" "profiling" "idp")

# Create advanced component placeholder files
for component in "${ADVANCED_COMPONENTS[@]}"; do
  component_name=$(echo $component | sed -r 's/(^|-)([a-z])/\U\2/g')
  
  mkdir -p "$BASE_DIR/advanced/$component"
  
  # Create base component
  cat > "$BASE_DIR/advanced/$component/Base${component_name}Component.js" << EOF
/**
 * Base${component_name}Component.js
 * Base component for ${component_name} authentication
 */

import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class Base${component_name}Component extends EventEmitter {
  constructor(options = {}) {
    super();
    this.options = {
      enableValidation: true,
      ...options
    };
    
    // Initialize configuration with default values
    this.config = {
      // TODO: Add default configuration
      enabled: false
    };
    
    // Initialize validation if enabled
    if (this.options.enableValidation) {
      this.validator = new ValidationService();
      this.registerValidations();
    }
  }
  
  /**
   * Register validations for configuration
   */
  registerValidations() {
    // TODO: Add validations
  }
  
  /**
   * Validate the current configuration
   * @returns {Object} Validation result {valid, errors}
   */
  validate() {
    if (!this.validator) {
      return { valid: true, errors: [] };
    }
    
    return this.validator.validate(this.config);
  }
  
  /**
   * Set configuration values
   * @param {Object} config Configuration object to merge with current config
   * @param {Boolean} validate Whether to validate the new configuration
   * @returns {Object} Validation result if validate=true, otherwise null
   */
  setConfig(config, validate = true) {
    // Deep merge the configurations
    this.config = this.mergeDeep(this.config, config);
    
    // Emit change event
    this.emit('configChanged', this.config);
    
    // Validate if requested
    if (validate && this.validator) {
      const validationResult = this.validate();
      if (!validationResult.valid) {
        this.emit('validationFailed', validationResult.errors);
      }
      return validationResult;
    }
    
    return null;
  }
  
  /**
   * Get the current configuration
   * @returns {Object} Current configuration
   */
  getConfig() {
    return JSON.parse(JSON.stringify(this.config));
  }
  
  /**
   * Deep merge two objects
   * @param {Object} target Target object
   * @param {Object} source Source object
   * @returns {Object} Merged object
   */
  mergeDeep(target, source) {
    const output = Object.assign({}, target);
    
    if (this.isObject(target) && this.isObject(source)) {
      Object.keys(source).forEach(key => {
        if (this.isObject(source[key])) {
          if (!(key in target)) {
            Object.assign(output, { [key]: source[key] });
          } else {
            output[key] = this.mergeDeep(target[key], source[key]);
          }
        } else {
          Object.assign(output, { [key]: source[key] });
        }
      });
    }
    
    return output;
  }
  
  /**
   * Check if value is an object
   * @param {*} item Item to check
   * @returns {Boolean} True if object
   */
  isObject(item) {
    return (item && typeof item === 'object' && !Array.isArray(item));
  }
  
  /**
   * Generate configuration (abstract method to be implemented by subclasses)
   * @returns {String} Configuration string
   */
  generateConfig() {
    throw new Error('generateConfig method must be implemented by subclasses');
  }
  
  /**
   * Reset configuration to defaults
   */
  resetConfig() {
    // Reset to initial default values
    this.config = {
      enabled: false
    };
    
    // Emit change event
    this.emit('configReset', this.config);
  }
}

export default Base${component_name}Component;
EOF
  
  echo -e "${GREEN}Created base ${component_name} component${RESET}"
  
  # Create index file
  cat > "$BASE_DIR/advanced/$component/index.js" << EOF
/**
 * ${component_name} Authentication Components
 * This file exports all ${component_name}-related components
 */

import Base${component_name}Component from './Base${component_name}Component.js';

export {
  Base${component_name}Component
};

export default Base${component_name}Component;
EOF
  
  echo -e "${GREEN}Created index file for ${component_name}${RESET}"
done

# Create an index file for all advanced components
cat > "$BASE_DIR/advanced/index.js" << EOF
/**
 * Advanced Authentication Components
 * This file exports all advanced authentication components
 */

// Import all advanced component modules
import EapComponent from './eap/index.js';
import MabComponent from './mab/index.js';
import WebauthComponent from './webauth/index.js';
import MacsecComponent from './macsec/index.js';
import PkiComponent from './pki/index.js';
import PostureComponent from './posture/index.js';
import MfaComponent from './mfa/index.js';
import ByodComponent from './byod/index.js';
import GuestComponent from './guest/index.js';
import ProfilingComponent from './profiling/index.js';
import IdpComponent from './idp/index.js';

// Export as named exports
export {
  EapComponent,
  MabComponent,
  WebauthComponent,
  MacsecComponent,
  PkiComponent,
  PostureComponent,
  MfaComponent,
  ByodComponent,
  GuestComponent,
  ProfilingComponent,
  IdpComponent
};

// Export by component type for dynamic access
export default {
  eap: EapComponent,
  mab: MabComponent,
  webauth: WebauthComponent,
  macsec: MacsecComponent,
  pki: PkiComponent,
  posture: PostureComponent,
  mfa: MfaComponent,
  byod: ByodComponent,
  guest: GuestComponent,
  profiling: ProfilingComponent,
  idp: IdpComponent
};
EOF

echo -e "${GREEN}Created advanced components index file${RESET}"
EOL

# Write the utility components generator script
cat > "$SCRIPTS_DIR/05-generate-utils.sh" << 'EOL'
#!/bin/bash

# Utility Components Generator Script
# This script generates utility components and services

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"

echo -e "${BLUE}Generating Utility Components and Services...${RESET}"

# Create utility directory if it doesn't exist
mkdir -p "$BASE_DIR/utils/factory"
mkdir -p "$BASE_DIR/utils/templates"
mkdir -p "$BASE_DIR/utils/converters"
mkdir -p "$BASE_DIR/utils/validation"

# Create component factory service
cat > "$BASE_DIR/utils/factory/ComponentFactory.js" << EOF
/**
 * ComponentFactory.js
 * Factory service for creating authentication components
 */

import authComponents from '../../index.js';

export class ComponentFactory {
  constructor() {
    this.components = authComponents;
    this.instances = new Map();
  }
  
  /**
   * Get a component instance for the specified type and vendor
   * @param {String} type Component type ('radius', 'tacacs', 'coa', 'radsec', etc.)
   * @param {String} vendor Vendor name (optional)
   * @param {Object} options Component options
   * @returns {Object} Component instance
   */
  getComponent(type, vendor, options = {}) {
    const key = vendor ? \`\${vendor}:\${type}\` : type;
    
    // Return cached instance if available
    if (this.instances.has(key)) {
      return this.instances.get(key);
    }
    
    // Get component class
    const ComponentClass = this.components.getComponent(type, vendor);
    
    // Create instance
    const instance = new ComponentClass(options);
    
    // Cache instance
    this.instances.set(key, instance);
    
    return instance;
  }
  
  /**
   * Clear all cached component instances
   */
  clearCache() {
    this.instances.clear();
  }
  
  /**
   * Remove a specific component from the cache
   * @param {String} type Component type
   * @param {String} vendor Vendor name (optional)
   */
  removeFromCache(type, vendor) {
    const key = vendor ? \`\${vendor}:\${type}\` : type;
    this.instances.delete(key);
  }
  
  /**
   * Get all supported vendors
   * @returns {Array} Array of vendor names
   */
  getSupportedVendors() {
    return Object.keys(this.components.vendors);
  }
  
  /**
   * Get all component types for a vendor
   * @param {String} vendor Vendor name
   * @returns {Array} Array of component types
   */
  getVendorComponentTypes(vendor) {
    if (!this.components.vendors[vendor]) {
      return [];
    }
    
    return Object.keys(this.components.vendors[vendor]);
  }
  
  /**
   * Check if a vendor supports a component type
   * @param {String} vendor Vendor name
   * @param {String} type Component type
   * @returns {Boolean} True if supported
   */
  vendorSupportsComponent(vendor, type) {
    return this.components.vendors[vendor] && !!this.components.vendors[vendor][type];
  }
}

// Export a singleton instance
export default new ComponentFactory();
EOF

echo -e "${GREEN}Created ComponentFactory service${RESET}"

# Create configuration converter service
cat > "$BASE_DIR/utils/converters/ConfigConverter.js" << EOF
/**
 * ConfigConverter.js
 * Service for converting configurations between vendors
 */

import componentFactory from '../factory/ComponentFactory.js';

export class ConfigConverter {
  constructor() {
    this.factory = componentFactory;
  }
  
  /**
   * Convert a configuration from one vendor to another
   * @param {String} config Configuration to convert
   * @param {String} fromVendor Source vendor
   * @param {String} toVendor Target vendor
   * @param {String} type Component type ('radius', 'tacacs', 'coa', 'radsec')
   * @returns {Object} Conversion result {success, config, errors}
   */
  convert(config, fromVendor, toVendor, type) {
    if (!this.factory.vendorSupportsComponent(fromVendor, type) || 
        !this.factory.vendorSupportsComponent(toVendor, type)) {
      return {
        success: false,
        config: '',
        errors: ['One or both vendors do not support this component type']
      };
    }
    
    try {
      // Parse configuration from source vendor
      const sourceComponent = this.factory.getComponent(type, fromVendor);
      const parsedConfig = sourceComponent.parseConfig(config);
      
      if (!parsedConfig.success) {
        return {
          success: false,
          config: '',
          errors: ['Failed to parse source configuration', ...parsedConfig.errors]
        };
      }
      
      // Generate configuration for target vendor
      const targetComponent = this.factory.getComponent(type, toVendor);
      targetComponent.setConfig(parsedConfig.config);
      
      // Validate the configuration for the target vendor
      const validationResult = targetComponent.validate();
      if (!validationResult.valid) {
        return {
          success: false,
          config: '',
          errors: ['Configuration is not valid for target vendor', ...validationResult.errors]
        };
      }
      
      // Generate target vendor configuration
      const newConfig = targetComponent.generateConfig();
      
      return {
        success: true,
        config: newConfig,
        errors: []
      };
    } catch (error) {
      return {
        success: false,
        config: '',
        errors: ['Conversion error', error.message]
      };
    }
  }
}

// Export a singleton instance
export default new ConfigConverter();
EOF

echo -e "${GREEN}Created ConfigConverter service${RESET}"

# Create configuration template service
cat > "$BASE_DIR/utils/templates/TemplateService.js" << EOF
/**
 * TemplateService.js
 * Service for managing configuration templates
 */

export class TemplateService {
  constructor() {
    this.templates = {};
  }
  
  /**
   * Register a template
   * @param {String} name Template name
   * @param {Object} template Template object
   * @param {String} template.vendor Vendor
   * @param {String} template.type Component type
   * @param {Object} template.config Configuration
   * @param {String} template.description Description
   * @returns {Boolean} Success status
   */
  registerTemplate(name, template) {
    if (!name || !template || !template.vendor || !template.type || !template.config) {
      return false;
    }
    
    this.templates[name] = {
      ...template,
      timestamp: new Date().toISOString()
    };
    
    return true;
  }
  
  /**
   * Get a template by name
   * @param {String} name Template name
   * @returns {Object} Template object or null if not found
   */
  getTemplate(name) {
    return this.templates[name] || null;
  }
  
  /**
   * Get all templates
   * @returns {Object} Templates object
   */
  getAllTemplates() {
    return { ...this.templates };
  }
  
  /**
   * Get templates for a specific vendor and type
   * @param {String} vendor Vendor
   * @param {String} type Component type
   * @returns {Array} Array of template objects
   */
  getTemplatesForVendorAndType(vendor, type) {
    return Object.entries(this.templates)
      .filter(([_, template]) => template.vendor === vendor && template.type === type)
      .map(([name, template]) => ({ name, ...template }));
  }
  
  /**
   * Remove a template
   * @param {String} name Template name
   * @returns {Boolean} Success status
   */
  removeTemplate(name) {
    if (!this.templates[name]) {
      return false;
    }
    
    delete this.templates[name];
    return true;
  }
  
  /**
   * Save templates to localStorage
   * @returns {Boolean} Success status
   */
  saveTemplates() {
    try {
      localStorage.setItem('auth_templates', JSON.stringify(this.templates));
      return true;
    } catch (error) {
      console.error('Error saving templates:', error);
      return false;
    }
  }
  
  /**
   * Load templates from localStorage
   * @returns {Boolean} Success status
   */
  loadTemplates() {
    try {
      const templates = localStorage.getItem('auth_templates');
      if (templates) {
        this.templates = JSON.parse(templates);
      }
      return true;
    } catch (error) {
      console.error('Error loading templates:', error);
      return false;
    }
  }
}

// Export a singleton instance
export default new TemplateService();
EOF

echo -e "${GREEN}Created TemplateService${RESET}"

# Create utilities index file
cat > "$BASE_DIR/utils/index.js" << EOF
/**
 * Utility Services
 * This file exports all utility services for authentication components
 */

import ValidationService from './validation/ValidationService.js';
import componentFactory from './factory/ComponentFactory.js';
import configConverter from './converters/ConfigConverter.js';
import templateService from './templates/TemplateService.js';

export {
  ValidationService,
  componentFactory,
  configConverter,
  templateService
};

export default {
  validation: ValidationService,
  factory: componentFactory,
  converter: configConverter,
  templates: templateService
};
EOF

echo -e "${GREEN}Created utilities index file${RESET}"
EOL

# Write the main index generator script
cat > "$SCRIPTS_DIR/06-generate-main-index.sh" << 'EOL'
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
EOL

# Make all scripts executable
chmod +x "$SCRIPTS_DIR/"*.sh

# Create main run script
cat > ./generate-all.sh << 'EOL'
#!/bin/bash

# Master script to run all component generation scripts

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

SCRIPTS_DIR="./scripts"

echo -e "${BLUE}Starting Authentication Components Generation...${RESET}"

# Run each script in order
echo -e "${YELLOW}Step 1: Creating directory structure...${RESET}"
"$SCRIPTS_DIR/01-create-structure.sh"

echo -e "${YELLOW}Step 2: Generating base components...${RESET}"
"$SCRIPTS_DIR/02-generate-base-components.sh"

echo -e "${YELLOW}Step 3: Generating vendor-specific components...${RESET}"
"$SCRIPTS_DIR/03-generate-vendor-components.sh"

echo -e "${YELLOW}Step 4: Generating advanced components...${RESET}"
"$SCRIPTS_DIR/04-generate-advanced-components.sh"

echo -e "${YELLOW}Step 5: Generating utility services...${RESET}"
"$SCRIPTS_DIR/05-generate-utils.sh"

echo -e "${YELLOW}Step 6: Generating main index file...${RESET}"
"$SCRIPTS_DIR/06-generate-main-index.sh"

echo -e "${GREEN}Authentication Components Generation Completed!${RESET}"
echo -e "The components are available in ${BLUE}./src/components/authentication${RESET}"
EOL

# Make main script executable
chmod +x ./generate-all.sh

echo -e "${GREEN}All generator scripts created successfully.${RESET}"
echo -e "Run ${BLUE}./generate-all.sh${RESET} to generate all components."
