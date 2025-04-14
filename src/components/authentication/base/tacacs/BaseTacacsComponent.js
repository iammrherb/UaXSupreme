/**
 * BaseTacacsComponent.js
 * Base TACACS+ configuration component that serves as the foundation for vendor-specific extensions.
 */

import { EventEmitter } from '../../../core/events.js';
import { ValidationService } from '../../utils/validation/ValidationService.js';

export class BaseTacacsComponent extends EventEmitter {
  constructor(options = {}) {
    super();
    this.options = {
      enableValidation: true,
      ...options
    };
    
    // Initialize configuration with default values
    this.config = {
      // Primary TACACS+ server
      primaryServer: {
        address: '',
        port: 49,
        secret: '',
        enabled: true,
        singleConnection: false
      },
      
      // Secondary TACACS+ server (for redundancy)
      secondaryServer: {
        address: '',
        port: 49,
        secret: '',
        enabled: false,
        singleConnection: false
      },
      
      // Tertiary TACACS+ server (for additional redundancy)
      tertiaryServer: {
        address: '',
        port: 49,
        secret: '',
        enabled: false,
        singleConnection: false
      },
      
      // General TACACS+ settings
      general: {
        sourceInterface: '',
        sourceIpAddress: '',
        timeout: 5,
        retransmit: 3,
        directedRequest: false,
        keyEncryption: true,
        sharedSecret: ''
      },
      
      // Server groups
      serverGroups: [],
      
      // Authentication settings
      authentication: {
        enabled: true,
        method: 'default', // 'default', 'login', 'enable', 'arap', 'dot1x', 'ppp'
        fallback: 'local',  // 'local', 'none'
        login: true,
        enable: true,
        customAttributes: []
      },
      
      // Authorization settings
      authorization: {
        enabled: true,
        method: 'default',  // 'default', 'commands', 'config-commands', 'network', 'exec'
        commandLevel: 15,   // Command authorization level (0-15)
        failureAction: 'local', // 'local', 'none', 'reject'
        commandAttributes: [],
        customAttributes: []
      },
      
      // Accounting settings
      accounting: {
        enabled: true,
        method: 'default',  // 'default', 'commands', 'network', 'exec', 'system', 'connection'
        commandLevel: 15,   // Command logging level (0-15)
        recordType: 'start-stop', // 'start-stop', 'stop-only', 'none'
        customAttributes: []
      },
      
      // Advanced options
      advanced: {
        // Packet encryption settings
        encryption: {
          type: 'standard', // 'standard', 'strong', 'none'
          algorithm: 'md5',  // 'md5', 'sha1'
          minimalPacketSize: true
        },
        
        // Command authorization groups
        commandAuthorizationGroups: [],
        
        // User privilege mapping
        userPrivilegeMapping: [],
        
        // Custom attribute definitions
        customAttributeDefinitions: []
      }
    };
    
    // Initialize validation if enabled
    if (this.options.enableValidation) {
      this.validator = new ValidationService();
      this.registerValidations();
    }
  }
  
  /**
   * Register validations for TACACS+ configuration
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
    this.validator.register('*.port', {
      type: 'number',
      min: 1,
      max: 65535,
      message: 'TACACS+ port must be between 1 and 65535'
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
    
    // Authorization level validations
    this.validator.register('authorization.commandLevel', {
      type: 'number',
      min: 0,
      max: 15,
      message: 'Command authorization level must be between 0 and 15'
    });
    
    this.validator.register('accounting.commandLevel', {
      type: 'number',
      min: 0,
      max: 15,
      message: 'Command accounting level must be between 0 and 15'
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
   * Generate TACACS+ configuration (abstract method to be implemented by subclasses)
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
      primaryServer: {
        address: '',
        port: 49,
        secret: '',
        enabled: true,
        singleConnection: false
      },
      secondaryServer: {
        address: '',
        port: 49,
        secret: '',
        enabled: false,
        singleConnection: false
      },
      tertiaryServer: {
        address: '',
        port: 49,
        secret: '',
        enabled: false,
        singleConnection: false
      },
      general: {
        sourceInterface: '',
        sourceIpAddress: '',
        timeout: 5,
        retransmit: 3,
        directedRequest: false,
        keyEncryption: true,
        sharedSecret: ''
      },
      serverGroups: [],
      authentication: {
        enabled: true,
        method: 'default',
        fallback: 'local',
        login: true,
        enable: true,
        customAttributes: []
      },
      authorization: {
        enabled: true,
        method: 'default',
        commandLevel: 15,
        failureAction: 'local',
        commandAttributes: [],
        customAttributes: []
      },
      accounting: {
        enabled: true,
        method: 'default',
        commandLevel: 15,
        recordType: 'start-stop',
        customAttributes: []
      },
      advanced: {
        encryption: {
          type: 'standard',
          algorithm: 'md5',
          minimalPacketSize: true
        },
        commandAuthorizationGroups: [],
        userPrivilegeMapping: [],
        customAttributeDefinitions: []
      }
    };
    
    // Emit change event
    this.emit('configReset', this.config);
  }
  
  /**
   * Add a command authorization group
   * @param {String} groupName Name of the command group
   * @param {Array} commands List of commands in the group
   * @param {Number} level Authorization level (0-15)
   * @returns {Boolean} Success status
   */
  addCommandAuthorizationGroup(groupName, commands, level = 15) {
    if (!groupName || !Array.isArray(commands)) {
      return false;
    }
    
    const group = {
      name: groupName,
      level: Math.min(Math.max(0, level), 15), // Ensure level is between 0 and 15
      commands: commands.slice() // Clone array
    };
    
    // Check if group already exists
    const existingIndex = this.config.advanced.commandAuthorizationGroups.findIndex(g => g.name === groupName);
    if (existingIndex >= 0) {
      // Update existing group
      this.config.advanced.commandAuthorizationGroups[existingIndex] = group;
    } else {
      // Add new group
      this.config.advanced.commandAuthorizationGroups.push(group);
    }
    
    // Emit change event
    this.emit('commandGroupChanged', group);
    
    return true;
  }
  
  /**
   * Remove a command authorization group
   * @param {String} groupName Name of the command group to remove
   * @returns {Boolean} Success status
   */
  removeCommandAuthorizationGroup(groupName) {
    const initialLength = this.config.advanced.commandAuthorizationGroups.length;
    
    this.config.advanced.commandAuthorizationGroups = 
      this.config.advanced.commandAuthorizationGroups.filter(g => g.name !== groupName);
    
    const removed = initialLength > this.config.advanced.commandAuthorizationGroups.length;
    
    if (removed) {
      // Emit change event
      this.emit('commandGroupRemoved', { name: groupName });
    }
    
    return removed;
  }
  
  /**
   * Test TACACS+ server connection
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
      
      // In a real implementation, this would send a test request to the TACACS+ server
      setTimeout(() => {
        // Simulate successful test
        this.emit('connectionTested', { 
          server, 
          success: true,
          responseTime: 38, // ms
          message: `Successfully connected to ${serverConfig.address}`
        });
        
        resolve({
          success: true,
          server: serverConfig.address,
          responseTime: 38,
          message: `Successfully connected to ${serverConfig.address}`
        });
      }, 1000);
    });
  }
}

export default BaseTacacsComponent;
