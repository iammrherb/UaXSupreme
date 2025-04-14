/**
 * CiscoEapComponent.js
 * Cisco-specific implementation of EAP configuration
 */

import { BaseEapComponent } from '../../../advanced/eap/BaseEapComponent.js';

export class CiscoEapComponent extends BaseEapComponent {
  constructor(options = {}) {
    // Initialize with base options
    super(options);
    
    // Add Cisco-specific configuration options
    this.config.ciscoSpecific = {
      // Cisco EAP configuration specific fields
      iseProfile: {
        enabled: false,
        profileName: '',
        eapChaining: false
      },
      
      // PEAP specific options
      peap: {
        validateAuthorizationIdentity: false,
        useLogonCredentials: false
      },
      
      // EAP-FAST specific options
      eapFast: {
        authorityId: '', // Authority Identity (A-ID)
        pacTtl: 86400, // seconds (24 hours)
        pacPasswordProtection: false,
        allowAnonymousProvisioning: false,
        localPacGeneration: false
      },
      
      // EAP-TLS specific options
      eapTls: {
        useSmartCard: false,
        crlAutoDownload: true,
        certificateSelection: 'auto', // 'auto', 'manual', 'prompt'
        allowExpiredCrl: false,
        allowSimultaneousTls: true
      },
      
      // Cisco Client Provisioning options
      provisioning: {
        enabled: false,
        provisioningUrl: '',
        autoProvision: false,
        allowManualDownload: true,
        promptForCredentials: true
      },
      
      // ISE posture assessment
      posture: {
        enabled: false,
        strictMode: false,
        remediationTimeoutAction: 'continue', // 'continue', 'terminate'
        remediationTimeout: 900, // seconds (15 minutes)
        checkInterval: 3600, // seconds (1 hour)
        fullCheckInterval: 24  // hours
      },
      
      // Cisco EAP protocol extensions
      extensions: {
        mka: false, // MACsec Key Agreement
        suiteB: false, // NSA Suite B cryptography
        suppressIdentityPrivacy: false,
        fastLaneSupport: false
      }
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
    // Validate ISE profile configuration
    this.validator.register('ciscoSpecific.iseProfile.profileName', {
      required: function(config) { 
        return config.ciscoSpecific && 
               config.ciscoSpecific.iseProfile && 
               config.ciscoSpecific.iseProfile.enabled; 
      },
      type: 'string',
      message: 'ISE profile name is required when ISE profile is enabled'
    });
    
    // Validate EAP-FAST Authority ID
    this.validator.register('ciscoSpecific.eapFast.authorityId', {
      required: function(config) { 
        return config.methods && 
               config.methods['eap-fast'] && 
               config.methods['eap-fast'].enabled; 
      },
      type: 'string',
      message: 'Authority ID (A-ID) is required when EAP-FAST is enabled'
    });
    
    // Validate provisioning URL
    this.validator.register('ciscoSpecific.provisioning.provisioningUrl', {
      required: function(config) { 
        return config.ciscoSpecific && 
               config.ciscoSpecific.provisioning && 
               config.ciscoSpecific.provisioning.enabled; 
      },
      type: 'string',
      message: 'Provisioning URL is required when client provisioning is enabled'
    });
  }
  
  /**
   * Enable Cisco ISE profile
   * @param {String} profileName ISE profile name
   * @param {Boolean} eapChaining Enable EAP chaining
   * @returns {Boolean} Success status
   */
  enableIseProfile(profileName, eapChaining = false) {
    if (!profileName) {
      return false;
    }
    
    this.config.ciscoSpecific.iseProfile.enabled = true;
    this.config.ciscoSpecific.iseProfile.profileName = profileName;
    this.config.ciscoSpecific.iseProfile.eapChaining = !!eapChaining;
    
    // Emit change event
    this.emit('iseProfileChanged', this.config.ciscoSpecific.iseProfile);
    
    return true;
  }
  
  /**
   * Enable Cisco posture assessment
   * @param {Object} options Posture options
   * @returns {Boolean} Success status
   */
  enablePostureAssessment(options = {}) {
    this.config.ciscoSpecific.posture.enabled = true;
    
    // Update posture options
    if (options.strictMode !== undefined) {
      this.config.ciscoSpecific.posture.strictMode = !!options.strictMode;
    }
    
    if (options.remediationTimeoutAction) {
      this.config.ciscoSpecific.posture.remediationTimeoutAction = options.remediationTimeoutAction;
    }
    
    if (options.remediationTimeout) {
      this.config.ciscoSpecific.posture.remediationTimeout = options.remediationTimeout;
    }
    
    if (options.checkInterval) {
      this.config.ciscoSpecific.posture.checkInterval = options.checkInterval;
    }
    
    if (options.fullCheckInterval) {
      this.config.ciscoSpecific.posture.fullCheckInterval = options.fullCheckInterval;
    }
    
    // Emit change event
    this.emit('postureChanged', this.config.ciscoSpecific.posture);
    
    return true;
  }
  
  /**
   * Generate Cisco IOS EAP configuration
   * @param {String} platform Platform type ('ios', 'ios-xe', 'ios-xr', 'nx-os')
   * @returns {String} Configuration commands as a string
   */
  generateConfig(platform = 'ios-xe') {
    // Different platforms have slightly different syntax
    switch (platform) {
      case 'ios':
      case 'ios-xe':
        return this.generateIosConfig();
      case 'ios-xr':
        return this.generateIosXrConfig();
      case 'nx-os':
        return this.generateNxOsConfig();
      default:
        return this.generateIosConfig(); // Default to IOS/IOS-XE
    }
  }
  
  /**
   * Generate Cisco IOS/IOS-XE EAP configuration
   * @returns {String} Configuration commands as a string
   */
  generateIosConfig() {
    let config = '';
    
    // Start with headers and general AAA configuration
    config += '! Cisco IOS/IOS-XE EAP Configuration\n';
    config += '!\n';
    config += 'aaa new-model\n';
    
    // Add EAP settings
    if (this.config.enabled) {
      config += '!\n';
      config += '! EAP Authentication\n';
      
      // Configure dot1x system-auth-control
      config += 'dot1x system-auth-control\n';
      
      // Configure authentication methods
      const enabledMethods = this.getEnabledMethods();
      
      if (enabledMethods.length > 0) {
        config += `aaa authentication dot1x default group radius\n`;
        
        // Configure EAP allowed methods
        config += 'dot1x method allowed ';
        config += enabledMethods
          .map(method => method.replace('eap-', ''))
          .join(' ');
        config += '\n';
        
        // Configure EAP profiles
        for (const method of enabledMethods) {
          config += this.generateEapProfileConfig(method);
        }
      }
      
      // Configure RADIUS servers
      if (this.config.server.primaryDomain) {
        const serverName = this.config.server.primaryDomain.replace(/\./g, '-');
        config += `!\n`;
        config += `radius server ${serverName}\n`;
        config += ` address ipv4 ${this.config.server.primaryDomain} auth-port 1812 acct-port 1813\n`;
        config += ` timeout ${this.config.server.requestTimeout}\n`;
        config += ` retransmit ${this.config.server.maxAuthRetries}\n`;
        
        // If using EAP-TLS, configure certificate settings
        if (this.config.methods['eap-tls'].enabled) {
          config += ` authenticate using-trustpoint ${this.config.ciscoSpecific.eapTls.trustpoint || 'DOT1X-TRUSTPOINT'}\n`;
        }
        
        config += `!\n`;
      }
      
      // Add secondary server if configured
      if (this.config.server.secondaryDomain) {
        const serverName = this.config.server.secondaryDomain.replace(/\./g, '-');
        config += `radius server ${serverName}\n`;
        config += ` address ipv4 ${this.config.server.secondaryDomain} auth-port 1812 acct-port 1813\n`;
        config += ` timeout ${this.config.server.requestTimeout}\n`;
        config += ` retransmit ${this.config.server.maxAuthRetries}\n`;
        config += `!\n`;
      }
      
      // Configure advanced EAP settings
      if (this.config.advanced.fragmentation.enabled) {
        config += `dot1x max-req-fragment ${this.config.advanced.fragmentation.maxFragmentSize}\n`;
      }
      
      if (this.config.advanced.sessionResumption.enabled) {
        config += `dot1x session-timeout ${this.config.advanced.sessionResumption.lifetime}\n`;
      }
      
      // Configure ISE integration if enabled
      if (this.config.ciscoSpecific.iseProfile.enabled) {
        config += `!\n`;
        config += `! ISE Integration\n`;
        config += `aaa server radius dynamic-author\n`;
        config += ` client ${this.config.server.primaryDomain} server-key <shared-secret>\n`;
        
        if (this.config.ciscoSpecific.iseProfile.eapChaining) {
          config += `dot1x profile ${this.config.ciscoSpecific.iseProfile.profileName}\n`;
          config += ` eap-chaining allow\n`;
        }
        
        if (this.config.ciscoSpecific.posture.enabled) {
          config += ` posture-assessment enable\n`;
          config += ` posture-assessment remediation-timeout ${this.config.ciscoSpecific.posture.remediationTimeout}\n`;
          config += ` posture-assessment remediation-action ${this.config.ciscoSpecific.posture.remediationTimeoutAction}\n`;
        }
        
        config += `!\n`;
      }
    }
    
    return config;
  }
  
  /**
   * Generate EAP profile configuration for a specific method
   * @param {String} method EAP method
   * @returns {String} Configuration commands for the EAP profile
   */
  generateEapProfileConfig(method) {
    let config = '';
    
    switch (method) {
      case 'peap':
        config += '!\n';
        config += `eap profile PEAP\n`;
        config += ` method peap\n`;
        
        if (this.config.methods.peap.validateServerCertificate) {
          config += ` server-cert validate\n`;
        } else {
          config += ` no server-cert validate\n`;
        }
        
        config += ` peap inner-method ${this.config.methods.peap.innerMethod}\n`;
        
        if (this.config.methods.peap.version !== 0) {
          config += ` peap version ${this.config.methods.peap.version}\n`;
        }
        
        if (this.config.ciscoSpecific.peap.validateAuthorizationIdentity) {
          config += ` peap validate-authorization-identity\n`;
        }
        
        if (this.config.methods.peap.options.fastReconnect) {
          config += ` peap fast-reconnect\n`;
        } else {
          config += ` no peap fast-reconnect\n`;
        }
        
        config += '!\n';
        break;
        
      case 'eap-tls':
        config += '!\n';
        config += `eap profile EAP-TLS\n`;
        config += ` method tls\n`;
        
        if (this.config.methods['eap-tls'].validateServerCertificate) {
          config += ` server-cert validate\n`;
        } else {
          config += ` no server-cert validate\n`;
        }
        
        if (this.config.ciscoSpecific.eapTls.crlAutoDownload) {
          config += ` tls crl-auto-download\n`;
        }
        
        // Configure TLS version
        const tlsVersion = this.config.methods['eap-tls'].options.tlsVersion;
        if (tlsVersion === 'tls1.3') {
          config += ` tls min-version 1.3\n`;
        } else if (tlsVersion === 'tls1.2') {
          config += ` tls min-version 1.2\n`;
        }
        
        // Configure session resumption
        if (this.config.methods['eap-tls'].options.sessionResumption) {
          config += ` tls session-resumption\n`;
        } else {
          config += ` no tls session-resumption\n`;
        }
        
        config += '!\n';
        break;
        
      case 'eap-fast':
        config += '!\n';
        config += `eap profile EAP-FAST\n`;
        config += ` method fast\n`;
        
        if (this.config.methods['eap-fast'].validateServerCertificate) {
          config += ` server-cert validate\n`;
        } else {
          config += ` no server-cert validate\n`;
        }
        
        config += ` fast inner-method ${this.config.methods['eap-fast'].innerMethod}\n`;
        
        if (this.config.methods['eap-fast'].provisionPac) {
          config += ` fast pac-provisioning ${this.config.methods['eap-fast'].inBandProvisioning ? 'auto' : 'manual'}\n`;
          config += ` fast pac-ttl ${this.config.ciscoSpecific.eapFast.pacTtl}\n`;
          
          if (this.config.ciscoSpecific.eapFast.authorityId) {
            config += ` fast authority-id ${this.config.ciscoSpecific.eapFast.authorityId}\n`;
          }
          
          if (this.config.ciscoSpecific.eapFast.allowAnonymousProvisioning) {
            config += ` fast allow-anonymous-provisioning\n`;
          }
        } else {
          config += ` no fast pac-provisioning\n`;
        }
        
        if (this.config.methods['eap-fast'].options.fastReconnect) {
          config += ` fast fast-reconnect\n`;
        } else {
          config += ` no fast fast-reconnect\n`;
        }
        
        config += '!\n';
        break;
        
      case 'eap-ttls':
        config += '!\n';
        config += `eap profile EAP-TTLS\n`;
        config += ` method ttls\n`;
        
        if (this.config.methods['eap-ttls'].validateServerCertificate) {
          config += ` server-cert validate\n`;
        } else {
          config += ` no server-cert validate\n`;
        }
        
        config += ` ttls inner-method ${this.config.methods['eap-ttls'].innerMethod}\n`;
        
        if (this.config.methods['eap-ttls'].options.fastReconnect) {
          config += ` ttls fast-reconnect\n`;
        } else {
          config += ` no ttls fast-reconnect\n`;
        }
        
        // Configure session resumption
        if (this.config.methods['eap-ttls'].options.sessionResumption) {
          config += ` ttls session-resumption\n`;
        } else {
          config += ` no ttls session-resumption\n`;
        }
        
        config += '!\n';
        break;
        
      case 'eap-md5':
        config += '!\n';
        config += `eap profile EAP-MD5\n`;
        config += ` method md5\n`;
        config += '!\n';
        break;
      
      // Other methods would be implemented similarly
    }
    
    return config;
  }
  
  /**
   * Generate Cisco IOS-XR EAP configuration
   * @returns {String} Configuration commands as a string
   */
  generateIosXrConfig() {
    // Implementation would be similar to IOS but with IOS-XR syntax
    let config = '';
    config += '! Cisco IOS-XR EAP Configuration\n';
    config += '! (IOS-XR specific implementation)\n';
    
    // This would be implemented with IOS-XR specific syntax
    return config;
  }
  
  /**
   * Generate Cisco NX-OS EAP configuration
   * @returns {String} Configuration commands as a string
   */
  generateNxOsConfig() {
    // Implementation would be similar to IOS but with NX-OS syntax
    let config = '';
    config += '! Cisco NX-OS EAP Configuration\n';
    config += '! (NX-OS specific implementation)\n';
    
    // This would be implemented with NX-OS specific syntax
    return config;
  }
}

export default CiscoEapComponent;