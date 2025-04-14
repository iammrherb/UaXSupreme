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
  
  # Special case for EAP component since we have a file for it
  if [ "$component" == "eap" ] && [ -f "eap-component.txt" ]; then
    echo -e "${YELLOW}Creating BaseEapComponent from existing file...${RESET}"
    cp eap-component.txt "$BASE_DIR/advanced/$component/Base${component_name}Component.js"
    echo -e "${GREEN}Created BaseEapComponent from existing file${RESET}"
  else
    # Create base component
    if [ ! -f "$BASE_DIR/advanced/$component/Base${component_name}Component.js" ]; then
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
    else
      echo -e "${YELLOW}Base ${component_name} component already exists, skipping...${RESET}"
    fi
  fi
  
  # Create index file
  if [ ! -f "$BASE_DIR/advanced/$component/index.js" ]; then
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
  else
    echo -e "${YELLOW}Index file for ${component_name} already exists, skipping...${RESET}"
  fi
done

# Copy vendor-specific advanced components if they exist
# Specifically for CiscoEapComponent
if [ -f "cisco-eap-component.js" ]; then
  mkdir -p "$BASE_DIR/advanced/eap/vendor/cisco"
  cp cisco-eap-component.js "$BASE_DIR/advanced/eap/vendor/cisco/CiscoEapComponent.js"
  echo -e "${GREEN}Copied CiscoEapComponent to advanced/eap/vendor/cisco/${RESET}"
fi

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