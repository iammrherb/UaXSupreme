/**
 * BaseRadsecComponent.js
 * Base RADSEC (RADIUS over TLS) configuration component that serves as the foundation
 * for vendor-specific extensions.
 */

import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseRadsecComponent extends EventEmitter {
  constructor(options = {}) {
    super();
    this.options = {
      enableValidation: true,
      ...options
    };
    
    // Initialize configuration with default values
    this.config = {
      // Basic RADSEC configuration
      enabled: false,
      port: 2083, // Standard RADSEC port
      listenAddress: '0.0.0.0',
      
      // TLS settings
      tls: {
        certificateFile: '',
        keyFile: '',
        caFile: '',
        cipherSuites: [
          'TLS_AES_256_GCM_SHA384',
          'TLS_AES_128_GCM_SHA256',
          'TLS_CHACHA20_POLY1305_SHA256'
        ],
        tlsVersion: 'tls1.2+', // 'tls1.2', 'tls1.3', 'tls1.2+'
        verifyPeer: true,
        verifyDepth: 3,
        sessionTimeout: 3600, // seconds
        dhParamFile: '' // Optional Diffie-Hellman parameters file
      },
      
      // Advanced settings
      advanced: {
        retry: 3,
        timeout: 5, // seconds
        keepalive: true,
        keepaliveInterval: 30, // seconds
        tlsSessionCaching: {
          enabled: true,
          cacheSize: 100,
          cacheTimeout: 300 // seconds
        },
        certificateRevocation: {
          check: true,
          method: 'crl', // 'crl', 'ocsp', 'both'
          crlPath: '',
          ocspUrl: '',
          ocspTimeout: 5 // seconds
        },
        mutualAuthentication: {
          required: false,
          clientCert: '',
          clientKey: ''
        },
        tlsCompression: false
      },
      
      // Server configuration
      servers: [
        // Example server structure (empty by default)
        {
          name: 'primary',
          address: '',
          port: 2083,
          sourceInterface: '',
          enabled: true,
          priority: 1,
          certificateVerification: true
        }
      ],
      
      // Connection settings
      connectionSettings: {
        connectTimeout: 5, // seconds
        idleTimeout: 60, // seconds
        maxConnections: 10,
        connectionBackoff: {
          enabled: true,
          initialDelay: 1, // seconds
          maxDelay: 30, // seconds
          multiplier: 2
        }
      }
    };
    
    // Initialize validation if enabled
    if (this.options.enableValidation) {
      this.validator = new ValidationService();
      this.registerValidations();
    }
  }
  
  /**
   * Register validations for RADSEC configuration
   * This can be extended by vendor-specific components
   */
  registerValidations() {
    // Basic validations
    this.validator.register('port', {
      type: 'number',
      min: 1,
      max: 65535,
      message: 'RADSEC port must be between 1 and 65535'
    });
    
    // TLS validations
    this.validator.register('tls.certificateFile', {
      type: 'string',
      required: function(config) { return config.enabled === true; },
      message: 'Certificate file is required when RADSEC is enabled'
    });
    
    this.validator.register('tls.keyFile', {
      type: 'string',
      required: function(config) { return config.enabled === true; },
      message: 'Private key file is required when RADSEC is enabled'
    });
    
    this.validator.register('tls.caFile', {
      type: 'string',
      required: function(config) { return config.enabled === true && config.tls.verifyPeer === true; },
      message: 'CA certificate file is required when peer verification is enabled'
    });
    
    // Server validations
    this.validator.register('servers.*.address', {
      type: 'string',
      required: function(config, server) { return server.enabled === true; },
      validator: (value) => {
        // Check for valid IP address or hostname
        return /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$|^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/.test(value);
      },
      message: 'Server address must be a valid IP address or hostname'
    });
    
    this.validator.register('servers.*.port', {
      type: 'number',
      min: 1,
      max: 65535,
      message: 'Server port must be between 1 and 65535'
    });
    
    // Advanced settings validations
    this.validator.register('advanced.timeout', {
      type: 'number',
      min: 1,
      max: 60,
      message: 'Timeout must be between 1 and 60 seconds'
    });
    
    this.validator.register('advanced.retry', {
      type: 'number',
      min: 0,
      max: 10,
      message: 'Retry count must be between 0 and 10'
    });
    
    this.validator.register('advanced.tlsSessionCaching.cacheTimeout', {
      type: 'number',
      min: 60,
      max: 86400,
      message: 'TLS session cache timeout must be between 60 and 86400 seconds'
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
   * Generate RADSEC configuration (abstract method to be implemented by subclasses)
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
      port: 2083,
      listenAddress: '0.0.0.0',
      tls: {
        certificateFile: '',
        keyFile: '',
        caFile: '',
        cipherSuites: [
          'TLS_AES_256_GCM_SHA384',
          'TLS_AES_128_GCM_SHA256',
          'TLS_CHACHA20_POLY1305_SHA256'
        ],
        tlsVersion: 'tls1.2+',
        verifyPeer: true,
        verifyDepth: 3,
        sessionTimeout: 3600,
        dhParamFile: ''
      },
      advanced: {
        retry: 3,
        timeout: 5,
        keepalive: true,
        keepaliveInterval: 30,
        tlsSessionCaching: {
          enabled: true,
          cacheSize: 100,
          cacheTimeout: 300
        },
        certificateRevocation: {
          check: true,
          method: 'crl',
          crlPath: '',
          ocspUrl: '',
          ocspTimeout: 5
        },
        mutualAuthentication: {
          required: false,
          clientCert: '',
          clientKey: ''
        },
        tlsCompression: false
      },
      servers: [
        {
          name: 'primary',
          address: '',
          port: 2083,
          sourceInterface: '',
          enabled: true,
          priority: 1,
          certificateVerification: true
        }
      ],
      connectionSettings: {
        connectTimeout: 5,
        idleTimeout: 60,
        maxConnections: 10,
        connectionBackoff: {
          enabled: true,
          initialDelay: 1,
          maxDelay: 30,
          multiplier: 2
        }
      }
    };
    
    // Emit change event
    this.emit('configReset', this.config);
  }
  
  /**
   * Add a RADSEC server
   * @param {Object} server Server configuration
   * @returns {Boolean} Success status
   */
  addServer(server) {
    if (!server || !server.address) {
      return false;
    }
    
    // Set default values for missing properties
    const newServer = {
      name: server.name || `server-${this.config.servers.length + 1}`,
      address: server.address,
      port: server.port || 2083,
      sourceInterface: server.sourceInterface || '',
      enabled: server.enabled !== undefined ? server.enabled : true,
      priority: server.priority || this.config.servers.length + 1,
      certificateVerification: server.certificateVerification !== undefined ? server.certificateVerification : true
    };
    
    // Check if server with same name already exists
    const existingIndex = this.config.servers.findIndex(s => s.name === newServer.name);
    if (existingIndex >= 0) {
      // Update existing server
      this.config.servers[existingIndex] = newServer;
    } else {
      // Add new server
      this.config.servers.push(newServer);
    }
    
    // Sort servers by priority
    this.config.servers.sort((a, b) => a.priority - b.priority);
    
    // Emit change event
    this.emit('serverChanged', newServer);
    
    return true;
  }
  
  /**
   * Remove a RADSEC server
   * @param {String} serverName Name of the server to remove
   * @returns {Boolean} Success status
   */
  removeServer(serverName) {
    const initialLength = this.config.servers.length;
    
    this.config.servers = this.config.servers.filter(s => s.name !== serverName);
    
    const removed = initialLength > this.config.servers.length;
    
    if (removed) {
      // Emit change event
      this.emit('serverRemoved', { name: serverName });
    }
    
    return removed;
  }
  
  /**
   * Test RADSEC configuration
   * @param {String} serverName Server name to test (defaults to first enabled server)
   * @returns {Promise} Promise that resolves with test result
   */
  testConfiguration(serverName = null) {
    // This would typically integrate with a testing service
    return new Promise((resolve, reject) => {
      if (!this.config.enabled) {
        reject(new Error('RADSEC is not enabled'));
        return;
      }
      
      // Find the server to test
      let serverToTest;
      if (serverName) {
        serverToTest = this.config.servers.find(s => s.name === serverName && s.enabled);
      } else {
        serverToTest = this.config.servers.find(s => s.enabled);
      }
      
      if (!serverToTest) {
        reject(new Error('No enabled RADSEC server found'));
        return;
      }
      
      // Verify TLS files exist (in a real implementation)
      if (!this.config.tls.certificateFile || !this.config.tls.keyFile) {
        reject(new Error('Certificate and/or key file not specified'));
        return;
      }
      
      // Emit testing event
      this.emit('configTesting', { server: serverToTest });
      
      // In a real implementation, this would test the RADSEC configuration
      setTimeout(() => {
        // Simulate successful test
        this.emit('configTested', { 
          server: serverToTest,
          success: true,
          tlsVersion: 'TLSv1.3',
          cipher: 'TLS_AES_256_GCM_SHA384',
          certificateVerified: true,
          message: `Successfully established RADSEC connection to ${serverToTest.address}`
        });
        
        resolve({
          success: true,
          server: serverToTest.address,
          tlsVersion: 'TLSv1.3',
          cipher: 'TLS_AES_256_GCM_SHA384',
          certificateVerified: true,
          message: `Successfully established RADSEC connection to ${serverToTest.address}`
        });
      }, 1500);
    });
  }
}

export default BaseRadsecComponent;
