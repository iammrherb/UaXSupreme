/**
 * BaseCoaComponent.js
 * Base Change of Authorization (CoA) component that serves as the foundation
 * for vendor-specific extensions.
 */

import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseCoaComponent extends EventEmitter {
  constructor(options = {}) {
    super();
    this.options = {
      enableValidation: true,
      ...options
    };
    
    // Initialize configuration with default values
    this.config = {
      // Basic CoA configuration
      enabled: false,
      port: 1700, // Standard CoA port
      
      // Client settings
      client: {
        timeout: 5, // seconds
        retransmit: 3,
        maxRetries: 3,
        deadtime: 0
      },
      
      // Supported methods
      methods: {
        bouncePort: true,
        reauthentication: true,
        disconnect: true,
        disablePort: false,
        updateACL: false
      },
      
      // Security settings
      security: {
        useTimestamp: true,
        keyWrap: false,
        keyWrapFormat: 'rfc3579', // 'rfc3579', 'rfc5176'
        messageAuthenticator: true,
        requireMessageAuthenticator: false,
        hashAlgorithm: 'md5' // 'md5', 'sha1', 'sha256'
      },
      
      // Advanced settings
      advanced: {
        proxyState: false,
        identityHandling: 'standard', // 'standard', 'cisco-av-pair', 'custom'
        authorizationFormat: {
          type: 'standard', // 'standard', 'vendor-specific', 'custom'
          attributes: [] // Additional attributes to include
        },
        clientFiltering: {
          enabled: false,
          allowedIPs: []
        },
        messageIntegrityCheck: {
          enabled: true,
          algorithm: 'hmac-md5', // 'hmac-md5', 'hmac-sha1', 'hmac-sha256'
          includeAttributeTypes: true
        },
        packetFormat: {
          version: 'rfc5176', // 'rfc3576', 'rfc5176'
          vendorExtensions: false
        },
        errorHandling: {
          retryOnTimeout: true,
          retryOnReject: false,
          fallbackToStatic: true,
          logErrors: true
        }
      },
      
      // Vendor-specific capabilities
      vendorCapabilities: {
        supportsBouncePort: true,
        supportsReauth: true,
        supportsDisconnect: true,
        supportsACLChange: false,
        supportsPolicyChange: false,
        supportsVLANChange: false,
        supportsCustomAttributes: false
      }
    };
    
    // Initialize validation if enabled
    if (this.options.enableValidation) {
      this.validator = new ValidationService();
      this.registerValidations();
    }
  }
  
  /**
   * Register validations for CoA configuration
   * This can be extended by vendor-specific components
   */
  registerValidations() {
    // Basic validations
    this.validator.register('port', {
      type: 'number',
      min: 1,
      max: 65535,
      message: 'CoA port must be between 1 and 65535'
    });
    
    // Client settings validations
    this.validator.register('client.timeout', {
      type: 'number',
      min: 1,
      max: 60,
      message: 'Client timeout must be between 1 and 60 seconds'
    });
    
    this.validator.register('client.retransmit', {
      type: 'number',
      min: 0,
      max: 20,
      message: 'Client retransmit count must be between 0 and 20'
    });
    
    this.validator.register('client.maxRetries', {
      type: 'number',
      min: 1,
      max: 10,
      message: 'Maximum retries must be between 1 and 10'
    });
    
    // IP address validation for client filtering
    this.validator.register('advanced.clientFiltering.allowedIPs.*', {
      type: 'string',
      validator: (value) => {
        // Check for valid IP address
        return /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$|^(?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}$/.test(value);
      },
      message: 'IP address must be in valid format (e.g., 192.168.1.1 or 192.168.1.0/24)'
    });
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
   * Generate CoA configuration (abstract method to be implemented by subclasses)
   * @returns {String} Configuration string
   */
  generateConfig() {
    throw new Error('generateConfig method must be implemented by vendor-specific subclasses');
  }
  
  /**
   * Reset configuration to defaults
   */
  resetConfig() {
    // Reset to initial default values
    this.config = {
      enabled: false,
      port: 1700,
      client: {
        timeout: 5,
        retransmit: 3,
        maxRetries: 3,
        deadtime: 0
      },
      methods: {
        bouncePort: true,
        reauthentication: true,
        disconnect: true,
        disablePort: false,
        updateACL: false
      },
      security: {
        useTimestamp: true,
        keyWrap: false,
        keyWrapFormat: 'rfc3579',
        messageAuthenticator: true,
        requireMessageAuthenticator: false,
        hashAlgorithm: 'md5'
      },
      advanced: {
        proxyState: false,
        identityHandling: 'standard',
        authorizationFormat: {
          type: 'standard',
          attributes: []
        },
        clientFiltering: {
          enabled: false,
          allowedIPs: []
        },
        messageIntegrityCheck: {
          enabled: true,
          algorithm: 'hmac-md5',
          includeAttributeTypes: true
        },
        packetFormat: {
          version: 'rfc5176',
          vendorExtensions: false
        },
        errorHandling: {
          retryOnTimeout: true,
          retryOnReject: false,
          fallbackToStatic: true,
          logErrors: true
        }
      },
      vendorCapabilities: {
        supportsBouncePort: true,
        supportsReauth: true,
        supportsDisconnect: true,
        supportsACLChange: false,
        supportsPolicyChange: false,
        supportsVLANChange: false,
        supportsCustomAttributes: false
      }
    };
    
    // Emit change event
    this.emit('configReset', this.config);
  }
  
  /**
   * Add an allowed client IP address
   * @param {String} ipAddress IP address to allow
   * @returns {Boolean} Success status
   */
  addAllowedClient(ipAddress) {
    // Validate IP address format
    const ipRegex = /^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$|^(?:[0-9]{1,3}\.){3}[0-9]{1,3}\/[0-9]{1,2}$/;
    if (!ipRegex.test(ipAddress)) {
      return false;
    }
    
    // Enable client filtering if not already enabled
    this.config.advanced.clientFiltering.enabled = true;
    
    // Add IP if not already in list
    if (!this.config.advanced.clientFiltering.allowedIPs.includes(ipAddress)) {
      this.config.advanced.clientFiltering.allowedIPs.push(ipAddress);
      
      // Emit change event
      this.emit('clientAdded', { ipAddress });
    }
    
    return true;
  }
  
  /**
   * Remove an allowed client IP address
   * @param {String} ipAddress IP address to remove
   * @returns {Boolean} Success status
   */
  removeAllowedClient(ipAddress) {
    const initialLength = this.config.advanced.clientFiltering.allowedIPs.length;
    
    this.config.advanced.clientFiltering.allowedIPs = 
      this.config.advanced.clientFiltering.allowedIPs.filter(ip => ip !== ipAddress);
    
    const removed = initialLength > this.config.advanced.clientFiltering.allowedIPs.length;
    
    if (removed) {
      // Emit change event
      this.emit('clientRemoved', { ipAddress });
    }
    
    return removed;
  }
  
  /**
   * Add a custom attribute to the authorization format
   * @param {Object} attribute Attribute object {name, value, type}
   * @returns {Boolean} Success status
   */
  addCustomAttribute(attribute) {
    if (!attribute || !attribute.name || attribute.value === undefined) {
      return false;
    }
    
    const newAttribute = {
      name: attribute.name,
      value: attribute.value,
      type: attribute.type || 'string' // string, integer, ipaddr, etc.
    };
    
    // Check if attribute already exists
    const existingIndex = this.config.advanced.authorizationFormat.attributes.findIndex(a => a.name === attribute.name);
    if (existingIndex >= 0) {
      // Update existing attribute
      this.config.advanced.authorizationFormat.attributes[existingIndex] = newAttribute;
    } else {
      // Add new attribute
      this.config.advanced.authorizationFormat.attributes.push(newAttribute);
    }
    
    // Emit change event
    this.emit('attributeChanged', newAttribute);
    
    return true;
  }
  
  /**
   * Test CoA functionality using the current configuration
   * @param {String} method CoA method to test ('bouncePort', 'reauthentication', 'disconnect')
   * @param {Object} testParams Test parameters (e.g., {username: 'test', sessionId: '123'})
   * @returns {Promise} Promise that resolves with test result
   */
  testCoA(method, testParams = {}) {
    // This would typically integrate with a testing service
    return new Promise((resolve, reject) => {
      if (!this.config.enabled) {
        reject(new Error('CoA is not enabled'));
        return;
      }
      
      if (!this.config.methods[method]) {
        reject(new Error(`CoA method '${method}' is not enabled`));
        return;
      }
      
      // Emit testing event
      this.emit('coaTesting', { method, params: testParams });
      
      // In a real implementation, this would send a test CoA request
      setTimeout(() => {
        // Simulate successful test
        this.emit('coaTested', { 
          method, 
          success: true,
          responseTime: 45, // ms
          message: `Successfully sent ${method} CoA request`
        });
        
        resolve({
          success: true,
          method,
          responseTime: 45,
          message: `Successfully sent ${method} CoA request`
        });
      }, 1000);
    });
  }
}

export default BaseCoaComponent;
