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
