/**
 * ArubaRadiusComponent.js
 * Aruba-specific implementation of RADIUS configuration
 */

import { BaseRadiusComponent } from '../../../base/radius/BaseRadiusComponent.js';

export class ArubaRadiusComponent extends BaseRadiusComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add Aruba-specific configuration options
    this.config.arubaSpecific = {
      // ClearPass integration
      clearpass: {
        enabled: false,
        apiServer: '',
        apiPort: 443,
        apiKey: '',
        apiClient: '',
        operatorProfile: 'Administrator',
        insightEnabled: false,
        guestEnabled: false,
        onConnectEnabled: false,
        onboardEnabled: false
      },
      
      // RFC 3576 support (now RFC 5176 for CoA)
      rfc3576: {
        enabled: false,
        port: 3799,
        clientIp: '',
        serverSecret: ''
      },
      
      // Enforcement profiles
      enforcementProfiles: [],
      
      // Controller settings
      controller: {
        mode: 'controller-based', // 'controller-based', 'controller-less'
        name: '',
        location: '',
        apdGroup: '',
        redundancyMode: 'active-standby', // 'active-standby', 'active-active'
        vrrpIp: ''
      },
      
      // ClearPass API integration
      cppmApi: {
        enabled: false,
        endpoint: '/api/v1',
        timeout: 30,
        authentication: {
          method: 'oauth2', // 'oauth2', 'token', 'basic'
          clientId: '',
          clientSecret: '',
          username: '',
          password: ''
        },
        services: {
          endpointContext: true,
          guestAccess: false,
          onboardProvisioning: false,
          userAuthentication: true
        }
      },
      
      // Dynamic authorization
      dynamicAuthorization: {
        enabled: false,
        attributeFormat: 'aruba', // 'aruba', 'standard'
        rejectIfNoSession: false,
        action: 'reauth', // 'reauth', 'terminate'
        destinationOption: 'vlan', // 'vlan', 'role', 'both'
        sendDisconnectForReauth: false
      },
      
      // User role mapping
      userRoleMapping: {
        enabled: false,
        defaultRole: 'authenticated',
        roles: [],
        useRadiusVsaForRole: true,
        defaultVlan: '',
        caseSensitive: false
      },
      
      // Advanced Aruba settings
      advanced: {
        // AOS-CX specific
        aosCx: {
          radiusServerDead: 'auth-fail', // 'auth-fail', 'ignore'
          noResponse: 'fail', // 'fail', 'ignore'
          aaa: {
            authorizationMethod: 'commands', // 'commands', 'config-commands', 'exec'
            authenticationMethod: 'login', // 'login', 'enable', 'dot1x'
            accountingMethod: 'network', // 'network', 'exec', 'system'
          }
        },
        
        // Aruba Instant specific
        instant: {
          cpSecurity: true,
          allowReauth: true,
          termCause: 'user-request', // 'user-request', 'lost-carrier', 'admin-reboot'
          vendorId: 14823, // Aruba vendor ID
          healthCheck: {
            enabled: false,
            interval: 30,
            timeout: 3,
            retries: 3
          }
        }
      }
    };
    
    // Extend the validator with Aruba-specific validations
    if (this.validator) {
      this.registerArubaValidations();
    }
  }
  
  /**
   * Register Aruba-specific validations
   */
  registerArubaValidations() {
    // Validate ClearPass configuration
    this.validator.register('arubaSpecific.clearpass.apiServer', {
      required: function(config) { return config.arubaSpecific && config.arubaSpecific.clearpass && config.arubaSpecific.clearpass.enabled; },
      type: 'string',
      validator: (value) => {
        // Check for valid IP address or hostname
        return /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$|^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$/.test(value);
      },
      message: 'ClearPass API server must be a valid IP address or hostname'
    });
    
    this.validator.register('arubaSpecific.clearpass.apiKey', {
      required: function(config) { return config.arubaSpecific && config.arubaSpecific.clearpass && config.arubaSpecific.clearpass.enabled; },
      type: 'string',
      minLength: 16,
      message: 'ClearPass API key must be at least 16 characters'
    });
    
    // Validate RFC 3576 configuration
    this.validator.register('arubaSpecific.rfc3576.port', {
      type: 'number',
      min: 1,
      max: 65535,
      message: 'RFC 3576 port must be between 1 and 65535'
    });
    
    // Validate controller configuration
    this.validator.register('arubaSpecific.controller.name', {
      required: function(config) { return config.arubaSpecific && config.arubaSpecific.controller && config.arubaSpecific.controller.mode === 'controller-based'; },
      type: 'string',
      message: 'Controller name is required when in controller-based mode'
    });
    
    // Validate CPPM API configuration
    this.validator.register('arubaSpecific.cppmApi.authentication.clientId', {
      required: function(config) { 
        return config.arubaSpecific && 
               config.arubaSpecific.cppmApi && 
               config.arubaSpecific.cppmApi.enabled && 
               config.arubaSpecific.cppmApi.authentication && 
               config.arubaSpecific.cppmApi.authentication.method === 'oauth2'; 
      },
      type: 'string',
      message: 'Client ID is required when using OAuth2 authentication'
    });
    
    this.validator.register('arubaSpecific.cppmApi.authentication.clientSecret', {
      required: function(config) { 
        return config.arubaSpecific && 
               config.arubaSpecific.cppmApi && 
               config.arubaSpecific.cppmApi.enabled && 
               config.arubaSpecific.cppmApi.authentication && 
               config.arubaSpecific.cppmApi.authentication.method === 'oauth2'; 
      },
      type: 'string',
      message: 'Client Secret is required when using OAuth2 authentication'
    });
  }
  
  /**
   * Add an enforcement profile
   * @param {Object} profile Enforcement profile object
   * @returns {Boolean} Success status
   */
  addEnforcementProfile(profile) {
    if (!profile || !profile.name) {
      return false;
    }
    
    const newProfile = {
      name: profile.name,
      description: profile.description || '',
      type: profile.type || 'role', // 'role', 'vlan', 'acl'
      value: profile.value || '',
      conditions: profile.conditions || [],
      priority: profile.priority || 1
    };
    
    // Check if profile already exists
    const existingIndex = this.config.arubaSpecific.enforcementProfiles.findIndex(p => p.name === profile.name);
    if (existingIndex >= 0) {
      // Update existing profile
      this.config.arubaSpecific.enforcementProfiles[existingIndex] = newProfile;
    } else {
      // Add new profile
      this.config.arubaSpecific.enforcementProfiles.push(newProfile);
    }
    
    // Sort profiles by priority
    this.config.arubaSpecific.enforcementProfiles.sort((a, b) => a.priority - b.priority);
    
    // Emit change event
    this.emit('enforcementProfileChanged', newProfile);
    
    return true;
  }
  
  /**
   * Remove an enforcement profile
   * @param {String} profileName Name of the profile to remove
   * @returns {Boolean} Success status
   */
  removeEnforcementProfile(profileName) {
    const initialLength = this.config.arubaSpecific.enforcementProfiles.length;
    
    this.config.arubaSpecific.enforcementProfiles = 
      this.config.arubaSpecific.enforcementProfiles.filter(p => p.name !== profileName);
    
    const removed = initialLength > this.config.arubaSpecific.enforcementProfiles.length;
    
    if (removed) {
      // Emit change event
      this.emit('enforcementProfileRemoved', { name: profileName });
    }
    
    return removed;
  }
  
  /**
   * Add a user role mapping
   * @param {Object} roleMapping Role mapping object
   * @returns {Boolean} Success status
   */
  addUserRoleMapping(roleMapping) {
    if (!roleMapping || !roleMapping.role) {
      return false;
    }
    
    // Enable role mapping if adding a mapping
    this.config.arubaSpecific.userRoleMapping.enabled = true;
    
    const newRoleMapping = {
      role: roleMapping.role,
      vlan: roleMapping.vlan || '',
      attributes: roleMapping.attributes || [],
      description: roleMapping.description || ''
    };
    
    // Check if mapping already exists
    const existingIndex = this.config.arubaSpecific.userRoleMapping.roles.findIndex(r => r.role === roleMapping.role);
    if (existingIndex >= 0) {
      // Update existing mapping
      this.config.arubaSpecific.userRoleMapping.roles[existingIndex] = newRoleMapping;
    } else {
      // Add new mapping
      this.config.arubaSpecific.userRoleMapping.roles.push(newRoleMapping);
    }
    
    // Emit change event
    this.emit('userRoleMappingChanged', newRoleMapping);
    
    return true;
  }
  
  /**
   * Generate Aruba RADIUS configuration
   * @param {String} platform Platform type ('aos-cx', 'aos-switch', 'instant')
   * @returns {String} Configuration commands as a string
   */
  generateConfig(platform = 'aos-cx') {
    let config = '';
    
    // Different platforms have different configuration syntax
    switch (platform) {
      case 'aos-cx':
        return this.generateAosCxConfig();
      case 'aos-switch':
        return this.generateAosSwitchConfig();
      case 'instant':
        return this.generateInstantConfig();
      default:
        return this.generateAosCxConfig(); // Default to AOS-CX
    }
  }
  
  /**
   * Generate Aruba AOS-CX configuration
   * @returns {String} Configuration commands as a string
   */
  generateAosCxConfig() {
    let config = '';
    
    // Global configuration section
    config += '! Aruba AOS-CX RADIUS Configuration\n!\n';
    
    // Configure radius servers
    if (this.config.primaryServer.address) {
      config += `radius-server host ${this.config.primaryServer.address} key ${this.config.primaryServer.secret}\n`;
      config += ` auth-port ${this.config.primaryServer.authPort}\n`;
      config += ` acct-port ${this.config.primaryServer.acctPort}\n`;
      config += ` timeout ${this.config.general.timeout}\n`;
      config += ` retransmit ${this.config.general.retransmit}\n`;
      
      if (this.config.general.sourceInterface) {
        config += ` source-interface ${this.config.general.sourceInterface}\n`;
      }
      
      config += '!\n';
    }
    
    // Configure secondary server if enabled
    if (this.config.secondaryServer.enabled && this.config.secondaryServer.address) {
      config += `radius-server host ${this.config.secondaryServer.address} key ${this.config.secondaryServer.secret}\n`;
      config += ` auth-port ${this.config.secondaryServer.authPort}\n`;
      config += ` acct-port ${this.config.secondaryServer.acctPort}\n`;
      config += ` timeout ${this.config.general.timeout}\n`;
      config += ` retransmit ${this.config.general.retransmit}\n`;
      
      if (this.config.general.sourceInterface) {
        config += ` source-interface ${this.config.general.sourceInterface}\n`;
      }
      
      config += '!\n';
    }
    
    // Configure radius server-group
    config += 'radius-server group radius\n';
    
    if (this.config.primaryServer.address) {
      config += ` server ${this.config.primaryServer.address}\n`;
    }
    
    if (this.config.secondaryServer.enabled && this.config.secondaryServer.address) {
      config += ` server ${this.config.secondaryServer.address}\n`;
    }
    
    if (this.config.tertiaryServer.enabled && this.config.tertiaryServer.address) {
      config += ` server ${this.config.tertiaryServer.address}\n`;
    }
    
    if (this.config.general.deadtime > 0) {
      config += ` deadtime ${this.config.general.deadtime}\n`;
    }
    
    config += '!\n';
    
    // Configure AAA authentication
    config += 'aaa authentication\n';
    
    if (this.config.authentication.enabled) {
      const authMethod = this.config.arubaSpecific.advanced.aosCx.aaa.authenticationMethod || 'login';
      config += ` ${authMethod} group radius local\n`;
    }
    
    config += '!\n';
    
    // Configure AAA authorization
    config += 'aaa authorization\n';
    
    if (this.config.arubaSpecific.advanced.aosCx.aaa.authorizationMethod) {
      config += ` ${this.config.arubaSpecific.advanced.aosCx.aaa.authorizationMethod} group radius local\n`;
    }
    
    config += '!\n';
    
    // Configure AAA accounting
    if (this.config.accounting.enabled) {
      config += 'aaa accounting\n';
      
      const acctMethod = this.config.arubaSpecific.advanced.aosCx.aaa.accountingMethod || 'network';
      const recordType = this.config.accounting.startStop ? 'start-stop' : 'stop-only';
      
      config += ` ${acctMethod} ${recordType} group radius\n`;
      
      config += '!\n';
    }
    
    // Configure RADIUS server-dead settings
    if (this.config.arubaSpecific.advanced.aosCx.radiusServerDead) {
      config += `radius-server dead-criteria ${this.config.arubaSpecific.advanced.aosCx.radiusServerDead}\n`;
    }
    
    if (this.config.arubaSpecific.advanced.aosCx.noResponse) {
      config += `radius-server no-response ${this.config.arubaSpecific.advanced.aosCx.noResponse}\n`;
    }
    
    // Configure RFC 3576 (CoA) support if enabled
    if (this.config.arubaSpecific.rfc3576.enabled) {
      config += `radius-server host ${this.config.arubaSpecific.rfc3576.clientIp} key ${this.config.arubaSpecific.rfc3576.serverSecret}\n`;
      config += ` coa-port ${this.config.arubaSpecific.rfc3576.port}\n`;
      config += '!\n';
    }
    
    // Configure user role mapping if enabled
    if (this.config.arubaSpecific.userRoleMapping.enabled) {
      config += 'aaa authorization user-role\n';
      
      if (this.config.arubaSpecific.userRoleMapping.defaultRole) {
        config += ` default-role ${this.config.arubaSpecific.userRoleMapping.defaultRole}\n`;
      }
      
      if (this.config.arubaSpecific.userRoleMapping.useRadiusVsaForRole) {
        config += ' use-radius-vsa-for-role\n';
      }
      
      if (this.config.arubaSpecific.userRoleMapping.defaultVlan) {
        config += ` default-vlan ${this.config.arubaSpecific.userRoleMapping.defaultVlan}\n`;
      }
      
      // Add role mappings
      for (const role of this.config.arubaSpecific.userRoleMapping.roles) {
        config += ` role ${role.role}\n`;
        
        if (role.vlan) {
          config += `  vlan ${role.vlan}\n`;
        }
        
        // Add attribute conditions
        for (const attr of role.attributes) {
          if (attr.type && attr.value) {
            config += `  attribute ${attr.type} value ${attr.value}\n`;
          }
        }
      }
      
      config += '!\n';
    }
    
    return config;
  }
  
  /**
   * Generate Aruba AOS-Switch configuration
   * @returns {String} Configuration commands as a string
   */
  generateAosSwitchConfig() {
    let config = '';
    
    // Global configuration section
    config += '; Aruba AOS-Switch RADIUS Configuration\n;\n';
    
    // Configure radius servers
    if (this.config.primaryServer.address) {
      config += `radius-server host ${this.config.primaryServer.address} key ${this.config.primaryServer.secret}\n`;
      config += `radius-server host ${this.config.primaryServer.address} auth-port ${this.config.primaryServer.authPort}\n`;
      config += `radius-server host ${this.config.primaryServer.address} acct-port ${this.config.primaryServer.acctPort}\n`;
      config += `radius-server host ${this.config.primaryServer.address} timeout ${this.config.general.timeout}\n`;
      config += `radius-server host ${this.config.primaryServer.address} retransmit ${this.config.general.retransmit}\n`;
    }
    
    // Configure secondary server if enabled
    if (this.config.secondaryServer.enabled && this.config.secondaryServer.address) {
      config += `radius-server host ${this.config.secondaryServer.address} key ${this.config.secondaryServer.secret}\n`;
      config += `radius-server host ${this.config.secondaryServer.address} auth-port ${this.config.secondaryServer.authPort}\n`;
      config += `radius-server host ${this.config.secondaryServer.address} acct-port ${this.config.secondaryServer.acctPort}\n`;
      config += `radius-server host ${this.config.secondaryServer.address} timeout ${this.config.general.timeout}\n`;
      config += `radius-server host ${this.config.secondaryServer.address} retransmit ${this.config.general.retransmit}\n`;
    }
    
    // Set RADIUS server dead-time
    if (this.config.general.deadtime > 0) {
      config += `radius-server dead-time ${this.config.general.deadtime}\n`;
    }
    
    // Configure authentication
    if (this.config.authentication.enabled) {
      config += 'aaa authentication port-access eap-radius\n';
      config += 'aaa authentication login privilege-mode\n';
    }
    
    // Configure accounting
    if (this.config.accounting.enabled) {
      const recordType = this.config.accounting.startStop ? 'start-stop' : 'stop-only';
      config += `aaa accounting network ${recordType} radius\n`;
    }
    
    // Configure RFC 3576 (CoA) support if enabled
    if (this.config.arubaSpecific.rfc3576.enabled) {
      config += `radius-server host ${this.config.arubaSpecific.rfc3576.clientIp} key ${this.config.arubaSpecific.rfc3576.serverSecret}\n`;
      config += `radius-server host ${this.config.arubaSpecific.rfc3576.clientIp} dyn-authorization\n`;
      
      if (this.config.arubaSpecific.rfc3576.port !== 3799) {
        config += `radius-server host ${this.config.arubaSpecific.rfc3576.clientIp} dyn-authorization ${this.config.arubaSpecific.rfc3576.port}\n`;
      }
    }
    
    return config;
  }
  
  /**
   * Generate Aruba Instant configuration
   * @returns {String} Configuration commands as a string
   */
  generateInstantConfig() {
    let config = '';
    
    // Aruba Instant uses a different configuration format (CLI or JSON)
    config += '# Aruba Instant RADIUS Configuration\n\n';
    
    // Configure RADIUS servers
    if (this.config.primaryServer.address) {
      config += `wlan auth-server ${this.config.primaryServer.address}\n`;
      config += `  ip ${this.config.primaryServer.address}\n`;
      config += `  port ${this.config.primaryServer.authPort}\n`;
      config += `  acctport ${this.config.primaryServer.acctPort}\n`;
      config += `  key ${this.config.primaryServer.secret}\n`;
      config += `  timeout ${this.config.general.timeout}\n`;
      config += `  retry-count ${this.config.general.retransmit}\n`;
      
      if (this.config.arubaSpecific.advanced.instant.cpSecurity) {
        config += `  cp-security\n`;
      }
      
      config += `  end\n`;
    }
    
    // Configure secondary server if enabled
    if (this.config.secondaryServer.enabled && this.config.secondaryServer.address) {
      config += `wlan auth-server ${this.config.secondaryServer.address}\n`;
      config += `  ip ${this.config.secondaryServer.address}\n`;
      config += `  port ${this.config.secondaryServer.authPort}\n`;
      config += `  acctport ${this.config.secondaryServer.acctPort}\n`;
      config += `  key ${this.config.secondaryServer.secret}\n`;
      config += `  timeout ${this.config.general.timeout}\n`;
      config += `  retry-count ${this.config.general.retransmit}\n`;
      
      if (this.config.arubaSpecific.advanced.instant.cpSecurity) {
        config += `  cp-security\n`;
      }
      
      config += `  end\n`;
    }
    
    // Configure server load balancing and failover
    if (this.config.primaryServer.address && this.config.secondaryServer.enabled && this.config.secondaryServer.address) {
      config += `wlan auth-server load-balance\n`;
    }
    
    // Configure RFC 3576 (CoA) support if enabled
    if (this.config.arubaSpecific.rfc3576.enabled) {
      config += `wlan auth-server rfc3576 server ${this.config.arubaSpecific.rfc3576.clientIp}\n`;
      config += `  key ${this.config.arubaSpecific.rfc3576.serverSecret}\n`;
      
      if (this.config.arubaSpecific.rfc3576.port !== 3799) {
        config += `  port ${this.config.arubaSpecific.rfc3576.port}\n`;
      }
      
      if (this.config.arubaSpecific.advanced.instant.allowReauth) {
        config += `  allow-reauth\n`;
      }
      
      config += `  end\n`;
    }
    
    // Configure server health check if enabled
    if (this.config.arubaSpecific.advanced.instant.healthCheck.enabled) {
      config += `wlan auth-server health-check\n`;
      config += `  interval ${this.config.arubaSpecific.advanced.instant.healthCheck.interval}\n`;
      config += `  timeout ${this.config.arubaSpecific.advanced.instant.healthCheck.timeout}\n`;
      config += `  retries ${this.config.arubaSpecific.advanced.instant.healthCheck.retries}\n`;
      config += `  end\n`;
    }
    
    // Configure user role mapping if enabled
    if (this.config.arubaSpecific.userRoleMapping.enabled) {
      config += `wlan ssid-profile default\n`;
      
      if (this.config.arubaSpecific.userRoleMapping.defaultRole) {
        config += `  set-role ${this.config.arubaSpecific.userRoleMapping.defaultRole}\n`;
      }
      
      if (this.config.arubaSpecific.userRoleMapping.useRadiusVsaForRole) {
        config += `  set-role-from-radius\n`;
      }
      
      config += `  end\n`;
      
      // Define roles
      for (const role of this.config.arubaSpecific.userRoleMapping.roles) {
        config += `wlan access-rule ${role.role}\n`;
        
        if (role.vlan) {
          config += `  vlan ${role.vlan}\n`;
        }
        
        config += `  end\n`;
      }
    }
    
    return config;
  }
}

export default ArubaRadiusComponent;