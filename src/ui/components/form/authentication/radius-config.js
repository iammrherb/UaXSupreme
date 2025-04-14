// src/ui/components/form/authentication/radius-config.js

import { eventBus } from '../../../../core/events.js';
import { stateManager } from '../../../../core/state.js';

export class RadiusConfig {
  constructor() {
    this.fields = {
      primary: {
        server: 'radius-server-1',
        authPort: 'radius-auth-port-1',
        acctPort: 'radius-acct-port-1',
        secret: 'radius-secret-1'
      },
      secondary: {
        server: 'radius-server-2',
        authPort: 'radius-auth-port-2',
        acctPort: 'radius-acct-port-2',
        secret: 'radius-secret-2'
      },
      tertiary: {
        server: 'radius-server-3',
        authPort: 'radius-auth-port-3',
        acctPort: 'radius-acct-port-3',
        secret: 'radius-secret-3'
      },
      advanced: {
        timeout: 'radius-timeout',
        retransmit: 'radius-retransmit',
        deadtime: 'radius-deadtime',
        nasId: 'radius-nas-id',
        nasIp: 'radius-nas-ip',
        attributeFormat: 'radius-attribute-format'
      }
    };
    
    this.elements = {};
    
    // Bind methods
    this.handleChange = this.handleChange.bind(this);
    
    // Subscribe to relevant events
    eventBus.on('form:reset', this.reset.bind(this));
  }
  
  /**
   * Initialize the component
   * @returns {RadiusConfig} This instance for chaining
   */
  initialize() {
    // Get all field elements
    for (const section in this.fields) {
      for (const field in this.fields[section]) {
        const elementId = this.fields[section][field];
        const element = document.getElementById(elementId);
        
        if (element) {
          // Store element reference
          if (!this.elements[section]) {
            this.elements[section] = {};
          }
          this.elements[section][field] = element;
          
          // Add change handler
          element.addEventListener('change', this.handleChange);
        }
      }
    }
    
    // Initial update
    this.handleChange();
    
    return this;
  }
  
  /**
   * Handle input change
   * @param {Event} event - Change event
   */
  handleChange(event) {
    // Collect all values
    const radiusConfig = {};
    
    // Primary server
    if (this.elements.primary) {
      radiusConfig.primaryServer = this.elements.primary.server?.value || '';
      radiusConfig.primaryAuthPort = this.elements.primary.authPort?.value || '1812';
      radiusConfig.primaryAcctPort = this.elements.primary.acctPort?.value || '1813';
      radiusConfig.primarySecret = this.elements.primary.secret?.value || '';
    }
    
    // Secondary server
    if (this.elements.secondary) {
      radiusConfig.secondaryServer = this.elements.secondary.server?.value || '';
      radiusConfig.secondaryAuthPort = this.elements.secondary.authPort?.value || '1812';
      radiusConfig.secondaryAcctPort = this.elements.secondary.acctPort?.value || '1813';
      radiusConfig.secondarySecret = this.elements.secondary.secret?.value || '';
    }
    
    // Tertiary server
    if (this.elements.tertiary) {
      radiusConfig.tertiaryServer = this.elements.tertiary.server?.value || '';
      radiusConfig.tertiaryAuthPort = this.elements.tertiary.authPort?.value || '1812';
      radiusConfig.tertiaryAcctPort = this.elements.tertiary.acctPort?.value || '1813';
      radiusConfig.tertiarySecret = this.elements.tertiary.secret?.value || '';
    }
    
    // Advanced settings
    if (this.elements.advanced) {
      radiusConfig.timeout = this.elements.advanced.timeout?.value || '5';
      radiusConfig.retransmit = this.elements.advanced.retransmit?.value || '3';
      radiusConfig.deadtime = this.elements.advanced.deadtime?.value || '15';
      radiusConfig.nasId = this.elements.advanced.nasId?.value || '';
      radiusConfig.nasIp = this.elements.advanced.nasIp?.value || '';
      radiusConfig.attributeFormat = this.elements.advanced.attributeFormat?.value || 'standard';
    }
    
    // Update state
    stateManager.setFormData({
      radius: radiusConfig
    });
    
    // Emit event
    eventBus.emit('auth:radius-config-changed', radiusConfig);
  }
  
  /**
   * Set form values
   * @param {Object} config - Configuration values
   */
  setValues(config) {
    if (!config) return;
    
    // Set primary server values
    if (this.elements.primary) {
      if (config.primaryServer) this.elements.primary.server.value = config.primaryServer;
      if (config.primaryAuthPort) this.elements.primary.authPort.value = config.primaryAuthPort;
      if (config.primaryAcctPort) this.elements.primary.acctPort.value = config.primaryAcctPort;
      if (config.primarySecret) this.elements.primary.secret.value = config.primarySecret;
    }
    
    // Set secondary server values
    if (this.elements.secondary) {
      if (config.secondaryServer) this.elements.secondary.server.value = config.secondaryServer;
      if (config.secondaryAuthPort) this.elements.secondary.authPort.value = config.secondaryAuthPort;
      if (config.secondaryAcctPort) this.elements.secondary.acctPort.value = config.secondaryAcctPort;
      if (config.secondarySecret) this.elements.secondary.secret.value = config.secondarySecret;
    }
    
    // Set tertiary server values
    if (this.elements.tertiary) {
      if (config.tertiaryServer) this.elements.tertiary.server.value = config.tertiaryServer;
      if (config.tertiaryAuthPort) this.elements.tertiary.authPort.value = config.tertiaryAuthPort;
      if (config.tertiaryAcctPort) this.elements.tertiary.acctPort.value = config.tertiaryAcctPort;
      if (config.tertiarySecret) this.elements.tertiary.secret.value = config.tertiarySecret;
    }
    
    // Set advanced values
    if (this.elements.advanced) {
      if (config.timeout) this.elements.advanced.timeout.value = config.timeout;
      if (config.retransmit) this.elements.advanced.retransmit.value = config.retransmit;
      if (config.deadtime) this.elements.advanced.deadtime.value = config.deadtime;
      if (config.nasId) this.elements.advanced.nasId.value = config.nasId;
      if (config.nasIp) this.elements.advanced.nasIp.value = config.nasIp;
      if (config.attributeFormat) this.elements.advanced.attributeFormat.value = config.attributeFormat;
    }
    
    // Trigger change event
    this.handleChange();
  }
  
  /**
   * Reset to default values
   */
  reset() {
    // Primary server
    if (this.elements.primary) {
      this.elements.primary.server.value = '';
      this.elements.primary.authPort.value = '1812';
      this.elements.primary.acctPort.value = '1813';
      this.elements.primary.secret.value = '';
    }
    
    // Secondary server
    if (this.elements.secondary) {
      this.elements.secondary.server.value = '';
      this.elements.secondary.authPort.value = '1812';
      this.elements.secondary.acctPort.value = '1813';
      this.elements.secondary.secret.value = '';
    }
    
    // Tertiary server
    if (this.elements.tertiary) {
      this.elements.tertiary.server.value = '';
      this.elements.tertiary.authPort.value = '1812';
      this.elements.tertiary.acctPort.value = '1813';
      this.elements.tertiary.secret.value = '';
    }
    
    // Advanced settings
    if (this.elements.advanced) {
      this.elements.advanced.timeout.value = '5';
      this.elements.advanced.retransmit.value = '3';
      this.elements.advanced.deadtime.value = '15';
      this.elements.advanced.nasId.value = '';
      this.elements.advanced.nasIp.value = '';
      this.elements.advanced.attributeFormat.value = 'standard';
    }
    
    // Trigger change event
    this.handleChange();
  }
}

// Export singleton instance
export const radiusConfig = new RadiusConfig();