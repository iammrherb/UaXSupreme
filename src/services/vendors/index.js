import { eventBus } from '../../core/events.js';

/**
 * BaseVendor - Base class for all vendor implementations
 */
export class BaseVendor {
  constructor(id, name) {
    this.id = id;
    this.name = name;
    this.types = [];
    this.platforms = {};
    this.templates = {};
  }
  
  // Standard methods all vendors should implement
  
  /**
   * Get all platform IDs for this vendor
   * @returns {Array} Array of platform IDs
   */
  getPlatforms() {
    return Object.keys(this.platforms);
  }
  
  /**
   * Get platform information
   * @param {string} platformId - Platform ID
   * @returns {Object|null} Platform information
   */
  getPlatformInfo(platformId) {
    return this.platforms[platformId] || null;
  }
  
  /**
   * Get software versions for a platform
   * @param {string} platformId - Platform ID
   * @returns {Array} Array of version strings
   */
  getVersions(platformId) {
    const platform = this.getPlatformInfo(platformId);
    return platform ? platform.versions : [];
  }
  
  /**
   * Get capabilities for a platform
   * @param {string} platformId - Platform ID
   * @returns {Array} Array of capability strings
   */
  getCapabilities(platformId) {
    const platform = this.getPlatformInfo(platformId);
    return platform ? platform.capabilities : [];
  }
  
  /**
   * Check if a platform supports a capability
   * @param {string} platformId - Platform ID
   * @param {string} capability - Capability to check
   * @returns {boolean} True if supported
   */
  supportsCapability(platformId, capability) {
    const platform = this.getPlatformInfo(platformId);
    if (!platform) return false;
    
    // Check in main capabilities list
    if (platform.capabilities && platform.capabilities.includes(capability)) {
      return true;
    }
    
    // Check in advanced capabilities
    if (platform.advanced && platform.advanced[`${capability}-support`]) {
      return true;
    }
    
    return false;
  }
  
  /**
   * Generate configuration - must be implemented by subclasses
   * @param {string} platformId - Platform ID
   * @param {Object} settings - Configuration settings
   * @returns {string} Generated configuration
   */
  generateConfig(platformId, settings) {
    throw new Error('generateConfig method must be implemented by each vendor');
  }
  
  /**
   * Analyze configuration - must be implemented by subclasses
   * @param {string} config - Configuration to analyze
   * @param {Object} settings - Configuration settings
   * @returns {Object} Analysis results
   */
  analyzeConfig(config, settings) {
    throw new Error('analyzeConfig method must be implemented by each vendor');
  }
}

/**
 * VendorService - Manages vendor implementations
 */
export class VendorService {
  constructor() {
    this.vendors = new Map();
    this.vendorMetadata = new Map();
    this.initialized = false;
  }
  
  /**
   * Initialize the vendor service
   * @returns {Promise} Promise that resolves when initialization is complete
   */
  async initialize() {
    console.log('Initializing Vendor Service...');
    
    if (this.initialized) {
      return;
    }
    
    // Load vendor implementations
    await this.loadVendors();
    
    this.initialized = true;
    console.log(`Vendor Service initialized with ${this.vendors.size} vendors`);
    eventBus.emit('vendors:initialized', { count: this.vendors.size });
    
    return this;
  }
  
  /**
   * Load vendor implementations
   * @returns {Promise} Promise that resolves when vendors are loaded
   */
  async loadVendors() {
    try {
      // For now, we'll provide stubs for common vendors
      // In a real implementation, this would dynamically import modules
      
      // Create a stub Cisco vendor
      const ciscoVendor = new BaseVendor('cisco', 'Cisco');
      ciscoVendor.types = ['wired', 'wireless', 'tacacs', 'vpn', 'uaac'];
      ciscoVendor.platforms = {
        'ios': {
          name: 'IOS',
          description: 'Traditional Cisco IOS for older Catalyst switches',
          versions: ['12.2(55)SE', '15.0(2)SE', '15.2(2)E', '15.2(4)E', '15.2(7)E'],
          capabilities: ['dot1x', 'mab', 'tacacs', 'radius']
        },
        'ios-xe': {
          name: 'IOS-XE',
          description: 'IOS-XE for newer Catalyst switches and ISR routers',
          versions: ['16.12.x', '17.3.x', '17.6.x', '17.9.x', '17.11.x'],
          capabilities: ['dot1x', 'mab', 'radsec', 'tacacs', 'radius']
        }
      };
      
      // Register the Cisco vendor
      this.registerVendor(ciscoVendor);
      
      // Create a stub Aruba vendor
      const arubaVendor = new BaseVendor('aruba', 'Aruba');
      arubaVendor.types = ['wired', 'wireless', 'tacacs', 'uaac'];
      arubaVendor.platforms = {
        'aos-cx': {
          name: 'AOS-CX',
          description: 'AOS-CX for Aruba CX switches',
          versions: ['10.04.x', '10.05.x', '10.06.x', '10.08.x', '10.09.x', '10.10.x'],
          capabilities: ['dot1x', 'mab', 'radius', 'tacacs']
        },
        'aos-switch': {
          name: 'AOS-Switch',
          description: 'AOS-Switch for Aruba/HP switches (former ProVision)',
          versions: ['16.08.x', '16.09.x', '16.10.x', '16.11.x'],
          capabilities: ['dot1x', 'mab', 'radius', 'tacacs']
        }
      };
      
      // Register the Aruba vendor
      this.registerVendor(arubaVendor);
      
      console.log(`Loaded ${this.vendors.size} vendor stubs`);
      
      // Once implemented, this would dynamically load vendor modules
      /*
      const vendorModules = await import.meta.glob('../../vendor-specific/*/index.js');
      for (const path in vendorModules) {
        const vendorModule = await vendorModules[path]();
        const vendorInstance = vendorModule.default;
        this.registerVendor(vendorInstance);
      }
      */
    } catch (error) {
      console.error('Error loading vendor implementations:', error);
      throw error;
    }
  }
  
  /**
   * Register a vendor implementation
   * @param {BaseVendor} vendorInstance - Vendor instance
   * @param {Object} metadata - Additional metadata
   * @returns {VendorService} This instance for chaining
   */
  registerVendor(vendorInstance, metadata = {}) {
    if (!(vendorInstance instanceof BaseVendor)) {
      throw new Error(`Vendor must be an instance of BaseVendor: ${vendorInstance.id}`);
    }
    
    this.vendors.set(vendorInstance.id, vendorInstance);
    this.vendorMetadata.set(vendorInstance.id, {
      id: vendorInstance.id,
      name: vendorInstance.name,
      types: vendorInstance.types,
      ...metadata
    });
    
    console.log(`Registered vendor: ${vendorInstance.id}`);
    eventBus.emit('vendor:registered', { 
      id: vendorInstance.id, 
      name: vendorInstance.name,
      metadata 
    });
    
    return this;
  }
  
  /**
   * Get all registered vendors
   * @returns {Array} Array of vendor metadata
   */
  getAllVendors() {
    return Array.from(this.vendorMetadata.values());
  }
  
  /**
   * Get a vendor by ID
   * @param {string} vendorId - Vendor ID
   * @returns {BaseVendor|null} Vendor instance or null
   */
  getVendor(vendorId) {
    return this.vendors.get(vendorId) || null;
  }
}

// Export singleton instance
export const vendorService = new VendorService();
