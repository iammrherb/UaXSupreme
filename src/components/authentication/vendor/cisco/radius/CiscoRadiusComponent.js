/**
 * CiscoRadiusComponent.js
 * Cisco-specific implementation of RADIUS configuration
 */

import { BaseRadiusComponent } from '../../../base/radius/BaseRadiusComponent.js';

export class CiscoRadiusComponent extends BaseRadiusComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add Cisco-specific configuration options
    this.config.ciscoSpecific = {
      // Key Wrap settings
      keyWrap: {
        enabled: false,
        keyEncryptionKey: '',
        messageMacAuthenticationCodeKey: '',
        keyWrapFormat: 'ascii', // 'ascii' or 'hex'
      },
      
      // AAA method configuration
      aaa: {
        newModel: true, // Use AAA new-model command
        methodList: 'default', // Method list name
        authorizationType: 'network', // 'network', 'exec', 'commands'
        accountingType: 'network', // 'network', 'exec', 'connection', 'system'
        accountingStopOnly: false,
      },
      
      // Named server groups
      namedGroups: [],
      
      // Auto-detect options
      autoDetect: {
        enabled: false,
        retryCount: 3,
        portRange: {
          start: 1645,
          end: 1646
        }
      },
      
      // Probing settings
      probing: {
        enabled: false,
        interval: 300, // seconds
        retries: 3,
        timeout: 5 // seconds
      },
      
      // RADIUS application IDs
      applicationId: 1, // 1 for standard, custom values for specific applications
      
      // ISE integration
      iseIntegration: {
        enabled: false,
        pxgrid: {
          enabled: false,
          nodeName: '',
          nodeSecret: '',
          servers: []
        },
        deviceSensor: {
          enabled: false,
          filterList: '',
          accountingAugment: true,
          protocols: {
            dhcp: true,
            cdp: true,
            lldp: true
          }
        }
      },
      
      // VSA format settings
      vsaFormat: {
        type: 'cisco', // 'cisco', 'ietf', 'custom'
        vendorId: 9, // Cisco IANA enterprise number
        delimiters: {
          attributeSeparator: ';',
          valueSeparator: '='
        }
      },
      
      // Advanced IOS features
      advancedIos: {
        multiDomain: {
          authenticationHost: true,
          authenticationOpen: false,
          authenticationClosed: false
        },
        dot1x: {
          systemAuthControl: true,
          credentialsCaching: true,
          supplicantTimeout: 30,
          serverTimeout: 30,
          maxStartRetries: 3,
          maxAuthRequests: 2
        }
      },
      
      // Dynamic authorization for IOS
      dynamicAuthorization: {
        enabled: false,
        clientIp: '',
        serverKey: '',
        port: 1700,
        authType: 'any' // 'any', 'all', 'session-key'
      },
      
      // Interface template mapping
      interfaceTemplates: []
    };
    
    // Extend the validator with Cisco-specific validations
    if (this.validator) {
      this.registerCiscoValidations();
    }
  }
  
  /**
   * Register Cisco-specific validations
   */
  registerCiscoValidations() {
    // Validate Key Wrap configuration
    this.validator.register('ciscoSpecific.keyWrap.keyEncryptionKey', {
      required: function(config) { return config.ciscoSpecific && config.ciscoSpecific.keyWrap && config.ciscoSpecific.keyWrap.enabled; },
      type: 'string',
      minLength: 16,
      maxLength: 32,
      message: 'Key Encryption Key must be 16-32 characters when Key Wrap is enabled'
    });
    
    this.validator.register('ciscoSpecific.keyWrap.messageMacAuthenticationCodeKey', {
      required: function(config) { return config.ciscoSpecific && config.ciscoSpecific.keyWrap && config.ciscoSpecific.keyWrap.enabled; },
      type: 'string',
      minLength: 16,
      maxLength: 32,
      message: 'Message MAC Authentication Code Key must be 16-32 characters when Key Wrap is enabled'
    });
    
    // Validate ISE PxGrid configuration
    this.validator.register('ciscoSpecific.iseIntegration.pxgrid.nodeName', {
      required: function(config) { 
        return config.ciscoSpecific && 
               config.ciscoSpecific.iseIntegration && 
               config.ciscoSpecific.iseIntegration.enabled && 
               config.ciscoSpecific.iseIntegration.pxgrid && 
               config.ciscoSpecific.iseIntegration.pxgrid.enabled; 
      },
      type: 'string',
      message: 'Node name is required when PxGrid is enabled'
    });
    
    this.validator.register('ciscoSpecific.iseIntegration.pxgrid.nodeSecret', {
      required: function(config) { 
        return config.ciscoSpecific && 
               config.ciscoSpecific.iseIntegration && 
               config.ciscoSpecific.iseIntegration.enabled && 
               config.ciscoSpecific.iseIntegration.pxgrid && 
               config.ciscoSpecific.iseIntegration.pxgrid.enabled; 
      },
      type: 'string',
      minLength: 8,
      message: 'Node secret must be at least 8 characters when PxGrid is enabled'
    });
  }
  
  /**
   * Add a named server group
   * @param {String} groupName Name of the server group
   * @param {Array} servers List of server names to include in the group
   * @param {Object} options Group options
   * @returns {Boolean} Success status
   */
  addNamedGroup(groupName, servers, options = {}) {
    if (!groupName || !Array.isArray(servers) || servers.length === 0) {
      return false;
    }
    
    const group = {
      name: groupName,
      servers: servers.slice(), // Clone array
      options: {
        deadtime: options.deadtime || 0,
        timeout: options.timeout || this.config.general.timeout,
        retransmit: options.retransmit || this.config.general.retransmit,
        sourceInterface: options.sourceInterface || '',
        ...options
      }
    };
    
    // Check if group already exists
    const existingIndex = this.config.ciscoSpecific.namedGroups.findIndex(g => g.name === groupName);
    if (existingIndex >= 0) {
      // Update existing group
      this.config.ciscoSpecific.namedGroups[existingIndex] = group;
    } else {
      // Add new group
      this.config.ciscoSpecific.namedGroups.push(group);
    }
    
    // Emit change event
    this.emit('namedGroupChanged', group);
    
    return true;
  }
  
  /**
   * Remove a named server group
   * @param {String} groupName Name of the group to remove
   * @returns {Boolean} Success status
   */
  removeNamedGroup(groupName) {
    const initialLength = this.config.ciscoSpecific.namedGroups.length;
    
    this.config.ciscoSpecific.namedGroups = 
      this.config.ciscoSpecific.namedGroups.filter(g => g.name !== groupName);
    
    const removed = initialLength > this.config.ciscoSpecific.namedGroups.length;
    
    if (removed) {
      // Emit change event
      this.emit('namedGroupRemoved', { name: groupName });
    }
    
    return removed;
  }
  
  /**
   * Add an interface template
   * @param {Object} template Interface template
   * @returns {Boolean} Success status
   */
  addInterfaceTemplate(template) {
    if (!template || !template.name || !template.commands) {
      return false;
    }
    
    const newTemplate = {
      name: template.name,
      description: template.description || '',
      commands: Array.isArray(template.commands) ? template.commands : [],
      interfaces: template.interfaces || []
    };
    
    // Check if template already exists
    const existingIndex = this.config.ciscoSpecific.interfaceTemplates.findIndex(t => t.name === template.name);
    if (existingIndex >= 0) {
      // Update existing template
      this.config.ciscoSpecific.interfaceTemplates[existingIndex] = newTemplate;
    } else {
      // Add new template
      this.config.ciscoSpecific.interfaceTemplates.push(newTemplate);
    }
    
    // Emit change event
    this.emit('interfaceTemplateChanged', newTemplate);
    
    return true;
  }
  
  /**
   * Generate Cisco IOS RADIUS configuration
   * @returns {String} Configuration commands as a string
   */
  generateConfig() {
    let config = '';
    
    // Add AAA new-model if enabled
    if (this.config.ciscoSpecific.aaa.newModel) {
      config += 'aaa new-model\n\n';
    }
    
    // Configure RADIUS servers
    if (this.config.primaryServer.address) {
      config += `radius server ${this.config.primaryServer.address.replace(/\./g, '-')}\n`;
      config += ` address ipv4 ${this.config.primaryServer.address} auth-port ${this.config.primaryServer.authPort} acct-port ${this.config.primaryServer.acctPort}\n`;
      
      if (this.config.primaryServer.secret) {
        config += ` key ${this.config.primaryServer.secret}\n`;
      }
      
      // Add timeout and retransmit settings
      config += ` timeout ${this.config.general.timeout}\n`;
      config += ` retransmit ${this.config.general.retransmit}\n`;
      
      // Add source interface if specified
      if (this.config.general.sourceInterface) {
        config += ` source-interface ${this.config.general.sourceInterface}\n`;
      }
      
      // Add Key Wrap settings if enabled
      if (this.config.ciscoSpecific.keyWrap.enabled) {
        config += ' key-wrap enable\n';
        
        if (this.config.ciscoSpecific.keyWrap.keyEncryptionKey) {
          config += ` key-wrap kek ${this.config.ciscoSpecific.keyWrap.keyEncryptionKey} ${this.config.ciscoSpecific.keyWrap.keyWrapFormat}\n`;
        }
        
        if (this.config.ciscoSpecific.keyWrap.messageMacAuthenticationCodeKey) {
          config += ` key-wrap mack ${this.config.ciscoSpecific.keyWrap.messageMacAuthenticationCodeKey} ${this.config.ciscoSpecific.keyWrap.keyWrapFormat}\n`;
        }
      }
      
      config += '!\n';
    }
    
    // Configure secondary server if enabled
    if (this.config.secondaryServer.enabled && this.config.secondaryServer.address) {
      config += `radius server ${this.config.secondaryServer.address.replace(/\./g, '-')}\n`;
      config += ` address ipv4 ${this.config.secondaryServer.address} auth-port ${this.config.secondaryServer.authPort} acct-port ${this.config.secondaryServer.acctPort}\n`;
      
      if (this.config.secondaryServer.secret) {
        config += ` key ${this.config.secondaryServer.secret}\n`;
      }
      
      // Add timeout and retransmit settings
      config += ` timeout ${this.config.general.timeout}\n`;
      config += ` retransmit ${this.config.general.retransmit}\n`;
      
      // Add source interface if specified
      if (this.config.general.sourceInterface) {
        config += ` source-interface ${this.config.general.sourceInterface}\n`;
      }
      
      config += '!\n';
    }
    
    // Configure tertiary server if enabled
    if (this.config.tertiaryServer.enabled && this.config.tertiaryServer.address) {
      config += `radius server ${this.config.tertiaryServer.address.replace(/\./g, '-')}\n`;
      config += ` address ipv4 ${this.config.tertiaryServer.address} auth-port ${this.config.tertiaryServer.authPort} acct-port ${this.config.tertiaryServer.acctPort}\n`;
      
      if (this.config.tertiaryServer.secret) {
        config += ` key ${this.config.tertiaryServer.secret}\n`;
      }
      
      // Add timeout and retransmit settings
      config += ` timeout ${this.config.general.timeout}\n`;
      config += ` retransmit ${this.config.general.retransmit}\n`;
      
      // Add source interface if specified
      if (this.config.general.sourceInterface) {
        config += ` source-interface ${this.config.general.sourceInterface}\n`;
      }
      
      config += '!\n';
    }
    
    // Configure named server groups
    for (const group of this.config.ciscoSpecific.namedGroups) {
      config += `aaa group server radius ${group.name}\n`;
      
      for (const server of group.servers) {
        config += ` server name ${server}\n`;
      }
      
      // Add group options
      if (group.options.sourceInterface) {
        config += ` ip radius source-interface ${group.options.sourceInterface}\n`;
      }
      
      if (group.options.deadtime > 0) {
        config += ` deadtime ${group.options.deadtime}\n`;
      }
      
      config += '!\n';
    }
    
    // Configure AAA authentication
    if (this.config.authentication.enabled) {
      config += `aaa authentication ${this.config.ciscoSpecific.aaa.authorizationType} ${this.config.ciscoSpecific.aaa.methodList} group radius local\n`;
    }
    
    // Configure AAA authorization
    if (this.config.ciscoSpecific.aaa.authorizationType) {
      config += `aaa authorization ${this.config.ciscoSpecific.aaa.authorizationType} ${this.config.ciscoSpecific.aaa.methodList} group radius local\n`;
    }
    
    // Configure AAA accounting
    if (this.config.accounting.enabled) {
      const recordType = this.config.ciscoSpecific.aaa.accountingStopOnly ? 'stop-only' : 'start-stop';
      config += `aaa accounting ${this.config.ciscoSpecific.aaa.accountingType} ${this.config.ciscoSpecific.aaa.methodList} ${recordType} group radius\n`;
    }
    
    // Configure radius-server settings (global settings)
    if (this.config.general.deadtime > 0) {
      config += `radius-server deadtime ${this.config.general.deadtime}\n`;
    }
    
    // Add NAS-ID if specified
    if (this.config.general.nasId) {
      config += `radius-server attribute 32 include-in-access-req format %h\n`;
    }
    
    // Configure dynamic authorization if enabled
    if (this.config.ciscoSpecific.dynamicAuthorization.enabled) {
      config += 'aaa server radius dynamic-author\n';
      
      if (this.config.ciscoSpecific.dynamicAuthorization.clientIp) {
        const serverKey = this.config.ciscoSpecific.dynamicAuthorization.serverKey || '';
        config += ` client ${this.config.ciscoSpecific.dynamicAuthorization.clientIp} server-key ${serverKey}\n`;
      }
      
      if (this.config.ciscoSpecific.dynamicAuthorization.port !== 1700) {
        config += ` port ${this.config.ciscoSpecific.dynamicAuthorization.port}\n`;
      }
      
      if (this.config.ciscoSpecific.dynamicAuthorization.authType !== 'any') {
        config += ` auth-type ${this.config.ciscoSpecific.dynamicAuthorization.authType}\n`;
      }
      
      config += '!\n';
    }
    
    // Configure ISE integration if enabled
    if (this.config.ciscoSpecific.iseIntegration.enabled) {
      // Configure device-sensor if enabled
      if (this.config.ciscoSpecific.iseIntegration.deviceSensor.enabled) {
        config += 'device-sensor filter-list cdp list cdp-list\n';
        config += 'device-sensor filter-list lldp list lldp-list\n';
        config += 'device-sensor filter-list dhcp list dhcp-list\n';
        
        if (this.config.ciscoSpecific.iseIntegration.deviceSensor.accountingAugment) {
          config += 'device-sensor accounting\n';
        }
        
        config += 'device-sensor notify all-changes\n';
      }
      
      // Configure PxGrid if enabled
      if (this.config.ciscoSpecific.iseIntegration.pxgrid.enabled) {
        config += `cts authorization list ${this.config.ciscoSpecific.aaa.methodList}\n`;
        config += `cts role-based enforcement\n`;
        
        if (this.config.ciscoSpecific.iseIntegration.pxgrid.servers.length > 0) {
          for (const server of this.config.ciscoSpecific.iseIntegration.pxgrid.servers) {
            config += `cts server ${server}\n`;
          }
        }
        
        config += '!\n';
      }
    }
    
    // Interface templates
    for (const template of this.config.ciscoSpecific.interfaceTemplates) {
      if (template.interfaces.length > 0) {
        const interfacesList = template.interfaces.join(',');
        config += `interface range ${interfacesList}\n`;
        
        for (const command of template.commands) {
          config += ` ${command}\n`;
        }
        
        config += '!\n';
      }
    }
    
    return config;
  }
}

export default CiscoRadiusComponent;