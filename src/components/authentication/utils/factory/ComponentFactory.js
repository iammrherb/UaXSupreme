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
    const key = vendor ? `${vendor}:${type}` : type;
    
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
    const key = vendor ? `${vendor}:${type}` : type;
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
