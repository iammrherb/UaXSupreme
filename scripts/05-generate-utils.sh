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
if [ ! -f "$BASE_DIR/utils/factory/ComponentFactory.js" ]; then
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
else
  echo -e "${YELLOW}ComponentFactory.js already exists, skipping...${RESET}"
fi

# Create configuration converter service
if [ ! -f "$BASE_DIR/utils/converters/ConfigConverter.js" ]; then
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
else
  echo -e "${YELLOW}ConfigConverter.js already exists, skipping...${RESET}"
fi

# Create configuration template service
if [ ! -f "$BASE_DIR/utils/templates/TemplateService.js" ]; then
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
else
  echo -e "${YELLOW}TemplateService.js already exists, skipping...${RESET}"
fi

# Check if ValidationService.js exists, and if not, copy from validation-service.js if available
if [ ! -f "$BASE_DIR/utils/validation/ValidationService.js" ] && [ -f "validation-service.js" ]; then
  cp validation-service.js "$BASE_DIR/utils/validation/ValidationService.js"
  echo -e "${GREEN}Copied ValidationService from validation-service.js${RESET}"
fi

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