/**
 * BaseRadiusComponent.js
 * Base RADIUS configuration component that serves as the foundation for vendor-specific extensions.
 */

import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseRadiusComponent extends EventEmitter {
  constructor(options = {}) {
    super();
    this.options = {
      enableValidation: true,
      ...options
    };
    
    // Initialize configuration with default values
    this.config = {
      // Primary RADIUS server
      primaryServer: {
        address: '',
        authPort: 1812,
        acctPort: 1813,
        secret: '',
        enabled: true
      },
      
      // Secondary RADIUS server (for redundancy)
      secondaryServer: {
        address: '',
        authPort: 1812,
        acctPort: 1813,
        secret: '',
        enabled: false
      },
      
      // Tertiary RADIUS server (for additional redundancy)
      tertiaryServer: {
        address: '',
        authPort: 1812,
        acctPort: 1813,
        secret: '',
        enabled: false
      },
      
      // General RADIUS settings
      general: {
        sourceInterface: '',
        sourceIpAddress: '',
        timeout: 5,
        retransmit: 3,
        deadtime: 15,
        nasId: '',
        nasIp: '',
        nasPortType: 'Ethernet',
        keyWrap: false,
        messageAuthenticator: true
      },
      
      // Server groups
      serverGroups: [],
      
      // Advanced options
      advanced: {
        // Dead server detection
        deadServerDetection: {
          enabled: false,
          deadTime: 30,
          detectCount: 3,
          detectTimeoutCount: 3
        },
        
        // Packet logging
        packetLogging: {
          enabled: false,
          logLevel: 'info', // 'debug', 'info', 'warning', 'error'
          logRequests: true,
          logResponses: true
        },
        
        // IPv6 support
        ipv6: {
          enabled: false,
          sourceAddress: ''
        },
        
        // Dynamic ports
        dynamicAuthPorts: {
          enabled: false,
          portRangeStart: 1812,
          portRangeEnd: 1813
        }
      },
      
      // Authentication options
      authentication: {
        enabled: true,
        methods: ['PAP', 'CHAP', 'MS-CHAPv2'],
        attributeFormat: 'standard', // 'standard', 'vendor-specific'
        customAttributes: []
      },
      
      // Accounting options
      accounting: {
        enabled: true,
        interim: true,
        interimInterval: 60, // seconds
        startStop: true,
        methods: ['start-stop', 'stop-only']
      }
    };
    
    // Initialize validation if enabled
    if (this.options.enableValidation) {
      this.validator = new ValidationService();
      this.registerValidations();
    }
  }
  
  /**
   * Register validations for RADIUS configuration
   * This can be extended by vendor-specific components
   */
  registerValidations() {
    // Primary server validations
    this.validator.register('primaryServer.address', {
      required: true,
      type: 'string',
      validator: (value) => {
        // Check for valid IP address or hostname
        return /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$|^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/.test(value);
      },
      message: 'Primary server address must be a valid IP address or hostname'
    });
    
    this.validator.register('primaryServer.secret', {
      required: true,
      type: 'string',
      minLength: 8,
      message: 'Primary server shared secret must be at least 8 characters'
    });
    
    // Port validations
    this.validator.register('*.authPort', {
      type: 'number',
      min: 1,
      max: 65535,
      message: 'Authentication port must be between 1 and 65535'
    });
    
    this.validator.register('*.acctPort', {
      type: 'number',
      min: 1,
      max: 65535,
      message: 'Accounting port must be between 1 and 65535'
    });
    
    // General settings validations
    this.validator.register('general.timeout', {
      type: 'number',
      min: 1,
      max: 60,
      message: 'Timeout must be between 1 and 60 seconds'
    });
    
    this.validator.register('general.retransmit', {
      type: 'number',
      min: 0,
      max: 20,
      message: 'Retransmit count must be between 0 and 20'
    });
    
    this.validator.register('general.deadtime', {
      type: 'number',
      min: 0,
      max: 1440,
      message: 'Deadtime must be between 0 and 1440 minutes'
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
   * Generate RADIUS configuration (abstract method to be implemented by subclasses)
   * @returns {String} Configuration string
   */
  generateConfig() {
    throw new Error('generateConfig method must be implemented by vendor-specific subclasses');
  }
  
  /**
   * Reset configuration to defaults
   */
  resetConfig() {
    // Reset to initial default values - create a new instance of the default configuration
    this.config = {
      primaryServer: {
        address: '',
        authPort: 1812,
        acctPort: 1813,
        secret: '',
        enabled: true
      },
      secondaryServer: {
        address: '',
        authPort: 1812,
        acctPort: 1813,
        secret: '',
        enabled: false
      },
      tertiaryServer: {
        address: '',
        authPort: 1812,
        acctPort: 1813,
        secret: '',
        enabled: false
      },
      general: {
        sourceInterface: '',
        sourceIpAddress: '',
        timeout: 5,
        retransmit: 3,
        deadtime: 15,
        nasId: '',
        nasIp: '',
        nasPortType: 'Ethernet',
        keyWrap: false,
        messageAuthenticator: true
      },
      serverGroups: [],
      advanced: {
        deadServerDetection: {
          enabled: false,
          deadTime: 30,
          detectCount: 3,
          detectTimeoutCount: 3
        },
        packetLogging: {
          enabled: false,
          logLevel: 'info',
          logRequests: true,
          logResponses: true
        },
        ipv6: {
          enabled: false,
          sourceAddress: ''
        },
        dynamicAuthPorts: {
          enabled: false,
          portRangeStart: 1812,
          portRangeEnd: 1813
        }
      },
      authentication: {
        enabled: true,
        methods: ['PAP', 'CHAP', 'MS-CHAPv2'],
        attributeFormat: 'standard',
        customAttributes: []
      },
      accounting: {
        enabled: true,
        interim: true,
        interimInterval: 60,
        startStop: true,
        methods: ['start-stop', 'stop-only']
      }
    };
    
    // Emit change event
    this.emit('configReset', this.config);
  }
  
  /**
   * Test RADIUS server connection
   * @param {String} server Server name ('primary', 'secondary', 'tertiary')
   * @returns {Promise} Promise that resolves with test result
   */
  testConnection(server = 'primary') {
    // This would typically integrate with a testing service
    return new Promise((resolve, reject) => {
      const serverConfig = this.config[`${server}Server`];
      
      if (!serverConfig || !serverConfig.address) {
        reject(new Error(`Invalid ${server} server configuration`));
        return;
      }
      
      // Emit testing event
      this.emit('connectionTesting', { server, config: serverConfig });
      
      // In a real implementation, this would send a test request to the RADIUS server
      setTimeout(() => {
        // Simulate successful test
        this.emit('connectionTested', { 
          server, 
          success: true,
          responseTime: 42, // ms
          message: `Successfully connected to ${serverConfig.address}`
        });
        
        resolve({
          success: true,
          server: serverConfig.address,
          responseTime: 42,
          message: `Successfully connected to ${serverConfig.address}`
        });
      }, 1000);
    });
  }
}

export default BaseRadiusComponent;
