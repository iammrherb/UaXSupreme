/**
 * AuthenticationBestPractices.js
 * Comprehensive authentication best practices for network configurations
 */

class AuthenticationBestPractices {
  constructor() {
    this.practices = {
      general: this.initGeneralPractices(),
      radius: this.initRadiusPractices(),
      tacacs: this.initTacacsPractices(),
      radsec: this.initRadsecPractices(),
      coa: this.initCoAPractices(),
      ibns: this.initIbnsPractices(),
      wireless: this.initWirelessPractices(),
      guest: this.initGuestPractices(),
      byod: this.initByodPractices(),
      fallback: this.initFallbackPractices(),
      dacl: this.initDaclPractices(),
      onboarding: this.initOnboardingPractices()
    };
    
    this.vendorConfigurations = {
      cisco: this.initCiscoPractices(),
      aruba: this.initArubaPractices(),
      juniper: this.initJuniperPractices(),
      extreme: this.initExtremePractices(),
      fortinet: this.initFortinetPractices(),
      paloalto: this.initPaloAltoPractices()
    };
    
    this.complianceProfiles = {
      pci: this.initPciCompliance(),
      hipaa: this.initHipaaCompliance(),
      nist: this.initNistCompliance(),
      iso27001: this.initIso27001Compliance(),
      gdpr: this.initGdprCompliance(),
      fedramp: this.initFedRampCompliance()
    };
    
    this.industryProfiles = {
      healthcare: this.initHealthcareProfile(),
      finance: this.initFinanceProfile(),
      education: this.initEducationProfile(),
      government: this.initGovernmentProfile(),
      retail: this.initRetailProfile(),
      manufacturing: this.initManufacturingProfile(),
      energy: this.initEnergyProfile()
    };
  }
  
  // Initialize practice definitions
  initGeneralPractices() {
    return {
      strongAuthentication: {
        title: "Strong Authentication Methods",
        description: "Use strong authentication methods like EAP-TLS",
        recommendation: "Configure EAP-TLS with certificates for user authentication",
        priority: "high",
        impact: "Provides strongest authentication security",
        examples: [
          "identity-service default",
          "  bind certificate default",
          "  authentication-type certificate"
        ]
      },
      serverRedundancy: {
        title: "Server Redundancy",
        description: "Implement redundant authentication servers",
        recommendation: "Configure at least two authentication servers for redundancy",
        priority: "high",
        impact: "Ensures authentication availability"
      },
      serviceMonitoring: {
        title: "Authentication Service Monitoring",
        description: "Monitor authentication service health",
        recommendation: "Configure SNMP monitoring for authentication services",
        priority: "medium",
        impact: "Provides visibility into authentication system health"
      }
    };
  }
  
  initRadiusPractices() {
    return {
      keyWrap: {
        title: "RADIUS Key Wrap",
        description: "Enable RADIUS Key Wrap for secure key transport",
        recommendation: "Configure Key Wrap with AES key encryption and HMAC-SHA1 key message auth",
        priority: "high",
        impact: "Protects RADIUS shared secrets during transport"
      },
      messageAuthenticator: {
        title: "Message Authenticator",
        description: "Enable Message-Authenticator attribute",
        recommendation: "Configure all RADIUS messages to include Message-Authenticator attribute",
        priority: "high",
        impact: "Prevents RADIUS message tampering"
      },
      accounting: {
        title: "RADIUS Accounting",
        description: "Enable RADIUS accounting with interim updates",
        recommendation: "Configure accounting with interim update interval of 15-30 minutes",
        priority: "medium",
        impact: "Provides session tracking and audit trail"
      },
      deadTime: {
        title: "Server Dead Time",
        description: "Configure appropriate server dead time",
        recommendation: "Set dead time between 5-15 minutes to prevent excessive failover attempts",
        priority: "medium",
        impact: "Optimizes authentication during server outages"
      }
    };
  }
  
  initTacacsPractices() {
    return {
      encryptedPayload: {
        title: "Encrypted TACACS+ Payload",
        description: "Ensure TACACS+ payload encryption",
        recommendation: "Use unique, strong shared secrets for each TACACS+ server",
        priority: "high",
        impact: "Protects administrative credentials"
      },
      commandAuthorization: {
        title: "Command Authorization",
        description: "Enable per-command authorization",
        recommendation: "Configure TACACS+ with per-command authorization for administrative access",
        priority: "high",
        impact: "Provides granular access control for administrative commands"
      }
    };
  }
  
  initRadsecPractices() {
    return {
      tlsVersion: {
        title: "TLS Version",
        description: "Use secure TLS version for RadSec",
        recommendation: "Configure RadSec to use TLS 1.2 or higher",
        priority: "high",
        impact: "Ensures cryptographic security for RADIUS traffic"
      },
      certificateValidation: {
        title: "Certificate Validation",
        description: "Enable certificate validation for RadSec",
        recommendation: "Configure certificate validation with appropriate CA certificates",
        priority: "high",
        impact: "Prevents man-in-the-middle attacks"
      }
    };
  }
  
  initCoAPractices() {
    return {
      dynamicAuthorization: {
        title: "Dynamic Authorization",
        description: "Enable Change of Authorization (CoA)",
        recommendation: "Configure RADIUS CoA support for dynamic policy changes",
        priority: "high",
        impact: "Enables real-time policy updates without reauthentication"
      }
    };
  }
  
  initIbnsPractices() {
    return {
      ibns2: {
        title: "IBNS 2.0",
        description: "Use Identity-Based Networking Services 2.0",
        recommendation: "Configure IBNS 2.0 for simplified, consistent authentication",
        priority: "medium",
        impact: "Simplifies 802.1X deployment and management"
      }
    };
  }
  
  initWirelessPractices() {
    return {
      encryption: {
        title: "Strong Wireless Encryption",
        description: "Use strong wireless encryption",
        recommendation: "Configure WPA3-Enterprise for wireless networks",
        priority: "high",
        impact: "Provides strongest wireless encryption security"
      }
    };
  }
  
  initGuestPractices() {
    return {
      isolation: {
        title: "Guest Network Isolation",
        description: "Isolate guest networks from internal resources",
        recommendation: "Configure guest VLAN with ACLs to prevent access to internal resources",
        priority: "high",
        impact: "Prevents guest access to sensitive resources"
      }
    };
  }
  
  initByodPractices() {
    return {
      onboarding: {
        title: "Secure BYOD Onboarding",
        description: "Implement secure BYOD onboarding",
        recommendation: "Configure automated certificate provisioning for BYOD",
        priority: "high",
        impact: "Ensures secure BYOD authentication"
      }
    };
  }
  
  initFallbackPractices() {
    return {
      authentication: {
        title: "Authentication Fallback",
        description: "Configure authentication fallback mechanisms",
        recommendation: "Implement MAB fallback for devices that don't support 802.1X",
        priority: "medium",
        impact: "Ensures compatibility with non-802.1X devices"
      }
    };
  }
  
  initDaclPractices() {
    return {
      authorization: {
        title: "Downloadable ACLs",
        description: "Implement downloadable ACLs",
        recommendation: "Configure RADIUS to provide downloadable ACLs",
        priority: "high",
        impact: "Provides granular access control"
      }
    };
  }
  
  initOnboardingPractices() {
    return {
      automation: {
        title: "Automated Onboarding",
        description: "Implement automated device onboarding",
        recommendation: "Configure onboarding portal for automatic provisioning",
        priority: "medium",
        impact: "Simplifies device enrollment and configuration"
      }
    };
  }
  
  // Initialize vendor-specific practices
  initCiscoPractices() {
    return {
      radius: {
        ibns2: {
          title: "IBNS 2.0",
          description: "Use Identity-Based Networking Services 2.0",
          recommendation: "Configure IBNS 2.0 for simplified, consistent authentication",
          priority: "medium",
          impact: "Simplifies 802.1X deployment and management"
        },
        keyWrap: {
          title: "RADIUS Key Wrap",
          description: "Enable RADIUS Key Wrap for secure key transport",
          recommendation: "Configure Key Wrap with AES key encryption and HMAC-SHA1 key message auth",
          priority: "high",
          impact: "Protects RADIUS shared secrets during transport"
        }
      },
      security: {
        dhcpSnooping: {
          title: "DHCP Snooping",
          description: "Enable DHCP Snooping for protection against rogue DHCP servers",
          recommendation: "Configure DHCP snooping on all user VLANs",
          priority: "high",
          impact: "Prevents DHCP spoofing attacks"
        },
        ipSourceGuard: {
          title: "IP Source Guard",
          description: "Enable IP Source Guard for protection against IP spoofing",
          recommendation: "Configure IP Source Guard on all access ports",
          priority: "high",
          impact: "Prevents IP spoofing attacks"
        },
        dynamicArpInspection: {
          title: "Dynamic ARP Inspection",
          description: "Enable Dynamic ARP Inspection for protection against ARP poisoning",
          recommendation: "Configure Dynamic ARP Inspection on all user VLANs",
          priority: "high",
          impact: "Prevents ARP poisoning attacks"
        }
      }
    };
  }
  
  initArubaPractices() {
    return {
      radius: {
        centralizedAuth: {
          title: "Centralized Authentication",
          description: "Use centralized authentication with ClearPass",
          recommendation: "Configure ClearPass as central auth server with CoA support",
          priority: "high",
          impact: "Provides unified authentication and policy management"
        },
        userRoleMappings: {
          title: "User Role Mappings",
          description: "Implement user role mappings",
          recommendation: "Configure role-based access control with dynamic role assignment",
          priority: "high",
          impact: "Provides granular access control based on user roles"
        }
      }
    };
  }
  
  initJuniperPractices() {
    return {
      radius: {
        unifiedAccessControl: {
          title: "Unified Access Control",
          description: "Implement Unified Access Control (UAC)",
          recommendation: "Configure UAC for centralized authentication and access control",
          priority: "high",
          impact: "Provides comprehensive access control solution"
        }
      }
    };
  }
  
  initExtremePractices() {
    return {
      radius: {
        policyManager: {
          title: "Policy Manager",
          description: "Use Extreme Management Center Policy Manager",
          recommendation: "Configure Policy Manager for centralized policy management",
          priority: "high",
          impact: "Provides centralized authentication policy management"
        }
      }
    };
  }
  
  initFortinetPractices() {
    return {
      radius: {
        securityFabric: {
          title: "Security Fabric",
          description: "Integrate with Fortinet Security Fabric",
          recommendation: "Configure FortiAuthenticator to integrate with Security Fabric",
          priority: "high",
          impact: "Provides unified security management"
        }
      }
    };
  }
  
  initPaloAltoPractices() {
    return {
      radius: {
        userID: {
          title: "User-ID",
          description: "Implement User-ID for user-based policies",
          recommendation: "Configure User-ID agents for user identification",
          priority: "high",
          impact: "Enables user-based security policies"
        }
      }
    };
  }
  
  // Initialize compliance profiles
  initPciCompliance() {
    return {
      requirements: {
        req2: {
          title: "Strong Authentication (PCI 8.2)",
          description: "Implement strong authentication for all system components",
          recommendation: "Configure EAP-TLS with certificates for user authentication",
          priority: "high",
          impact: "Meets PCI DSS 8.2 requirement for strong authentication"
        },
        req4: {
          title: "Encrypted Transmission (PCI 4.1)",
          description: "Encrypt transmission of cardholder data across open networks",
          recommendation: "Configure RadSec or IPsec for encrypted RADIUS traffic",
          priority: "high",
          impact: "Meets PCI DSS 4.1 requirement for encrypted transmission"
        },
        req7: {
          title: "Access Control (PCI 7.1)",
          description: "Restrict access to system components",
          recommendation: "Configure role-based access control with appropriate VLANs and ACLs",
          priority: "high",
          impact: "Meets PCI DSS 7.1 requirement for access control"
        },
        req8: {
          title: "Multi-Factor Authentication (PCI 8.3)",
          description: "Implement multi-factor authentication for all remote access",
          recommendation: "Configure MFA for all remote access methods",
          priority: "high",
          impact: "Meets PCI DSS 8.3 requirement for MFA"
        },
        req10: {
          title: "Audit Trails (PCI 10.1)",
          description: "Track and monitor all access to network resources",
          recommendation: "Configure RADIUS accounting and logging",
          priority: "high",
          impact: "Meets PCI DSS 10.1 requirement for audit trails"
        }
      }
    };
  }
  
  initHipaaCompliance() {
    return {
      requirements: {
        accessControl: {
          title: "Access Control (HIPAA 164.312(a)(1))",
          description: "Implement technical policies and procedures for electronic access",
          recommendation: "Configure role-based access control with appropriate VLANs and ACLs",
          priority: "high",
          impact: "Meets HIPAA 164.312(a)(1) access control requirement"
        },
        auditControls: {
          title: "Audit Controls (HIPAA 164.312(b))",
          description: "Implement mechanisms to record and examine activity",
          recommendation: "Configure RADIUS accounting and logging",
          priority: "high",
          impact: "Meets HIPAA 164.312(b) audit controls requirement"
        }
      }
    };
  }
  
  initNistCompliance() {
    return {
      requirements: {
        ac2: {
          title: "Account Management (NIST AC-2)",
          description: "Manage system accounts",
          recommendation: "Configure accounting and session management",
          priority: "high",
          impact: "Meets NIST SP 800-53 AC-2 account management requirement"
        },
        ia2: {
          title: "Identification and Authentication (NIST IA-2)",
          description: "Uniquely identify and authenticate users",
          recommendation: "Configure strong authentication methods",
          priority: "high",
          impact: "Meets NIST SP 800-53 IA-2 identification requirement"
        }
      }
    };
  }
  
  initIso27001Compliance() {
    return {
      requirements: {
        a9: {
          title: "Access Control (ISO A.9)",
          description: "Implement access control for information systems",
          recommendation: "Configure 802.1X with role-based access control",
          priority: "high",
          impact: "Meets ISO 27001 A.9 access control requirement"
        }
      }
    };
  }
  
  initGdprCompliance() {
    return {
      requirements: {
        article32: {
          title: "Security of Processing (GDPR Article 32)",
          description: "Implement appropriate technical measures for security",
          recommendation: "Configure strong authentication and encryption",
          priority: "high",
          impact: "Helps meet GDPR Article 32 security requirements"
        }
      }
    };
  }
  
  initFedRampCompliance() {
    return {
      requirements: {
        moderate: {
          title: "FedRAMP Moderate Controls",
          description: "Implement controls for FedRAMP Moderate",
          recommendation: "Configure strong authentication, accounting, and monitoring",
          priority: "high",
          impact: "Helps meet FedRAMP Moderate control requirements"
        }
      }
    };
  }
  
  // Initialize industry profiles
  initHealthcareProfile() {
    return {
      clinical: {
        title: "Clinical Device Support",
        description: "Support for clinical devices with appropriate security",
        recommendation: "Configure MAB for medical devices with device profiling",
        priority: "high",
        impact: "Ensures clinical devices operate securely"
      },
      medical: {
        title: "Medical Device Provisioning",
        description: "Special provisions for medical devices",
        recommendation: "Configure device profiles for medical equipment",
        priority: "high",
        impact: "Supports medical devices without compromising security"
      }
    };
  }
  
  initFinanceProfile() {
    return {
      trading: {
        title: "Trading System Support",
        description: "Support for trading systems with low latency",
        recommendation: "Configure authentication caching and fast failover",
        priority: "high",
        impact: "Minimizes authentication latency for trading systems"
      }
    };
  }
  
  initEducationProfile() {
    return {
      classroom: {
        title: "Classroom Device Support",
        description: "Support for classroom devices",
        recommendation: "Configure shared device access and device profiling",
        priority: "medium",
        impact: "Supports classroom technology usage"
      },
      byod: {
        title: "BYOD Support",
        description: "Support for student and faculty devices",
        recommendation: "Configure onboarding portal for student and faculty devices",
        priority: "high",
        impact: "Securely supports student and faculty devices"
      }
    };
  }
  
  initGovernmentProfile() {
    return {
      classified: {
        title: "Classified Network Support",
        description: "Support for classified networks",
        recommendation: "Configure multi-factor authentication and encryption",
        priority: "high",
        impact: "Meets requirements for classified data protection"
      }
    };
  }
  
  initRetailProfile() {
    return {
      pos: {
        title: "Point-of-Sale Support",
        description: "Support for point-of-sale systems",
        recommendation: "Configure POS device profiles and network segmentation",
        priority: "high",
        impact: "Secures point-of-sale transactions"
      }
    };
  }
  
  initManufacturingProfile() {
    return {
      ot: {
        title: "Operational Technology Support",
        description: "Support for OT devices",
        recommendation: "Configure OT device profiles and network segmentation",
        priority: "high",
        impact: "Secures OT devices without disrupting production"
      }
    };
  }
  
  initEnergyProfile() {
    return {
      scada: {
        title: "SCADA System Support",
        description: "Support for SCADA systems",
        recommendation: "Configure SCADA device profiles and network segmentation",
        priority: "high",
        impact: "Secures SCADA systems without disrupting operations"
      }
    };
  }
  
  // Generate recommendations based on configuration
  generateRecommendations(config, options = {}) {
    const recommendations = [];
    const nonCompliantItems = [];
    
    // Apply general practices
    this.applyGeneralPractices(config, recommendations, nonCompliantItems);
    
    // Apply component-specific practices
    if (options.component) {
      this.applyComponentPractices(options.component, config, recommendations, nonCompliantItems);
    }
    
    // Apply vendor-specific practices
    if (options.vendor) {
      this.applyVendorPractices(options.vendor, options.component, config, recommendations, nonCompliantItems);
    }
    
    // Apply industry practices
    if (options.industry) {
      this.applyIndustryPractices(options.industry, config, recommendations, nonCompliantItems);
    }
    
    // Apply compliance standards
    if (options.complianceStandards && Array.isArray(options.complianceStandards)) {
      this.applyComplianceStandards(options.complianceStandards, config, recommendations, nonCompliantItems);
    }
    
    // Apply security level enhancements
    if (options.securityLevel) {
      this.applySecurityLevelEnhancements(options.securityLevel, config, recommendations);
    }
    
    // Apply device type optimizations
    if (options.deviceType) {
      this.applyDeviceTypeOptimizations(options.deviceType, config, recommendations);
    }
    
    // Calculate security score
    const securityScore = this.calculateSecurityScore(config, nonCompliantItems);
    
    return {
      recommendations,
      nonCompliantItems,
      securityScore,
      compliant: nonCompliantItems.length === 0
    };
  }
  
  // Apply general best practices
  applyGeneralPractices(config, recommendations, nonCompliantItems) {
    // Check each general practice for compliance
    for (const [key, practice] of Object.entries(this.practices.general)) {
      const isCompliant = this.checkPracticeCompliance(key, practice, config);
      
      if (!isCompliant) {
        recommendations.push({
          category: 'General',
          ...practice,
          currentState: 'Not implemented'
        });
        nonCompliantItems.push({
          category: 'General',
          item: practice.title,
          severity: practice.priority
        });
      }
    }
  }
  
  // Apply component-specific practices
  applyComponentPractices(component, config, recommendations, nonCompliantItems) {
    // Check if component practices exist
    if (!this.practices[component]) {
      return;
    }
    
    // Check each component practice for compliance
    for (const [key, practice] of Object.entries(this.practices[component])) {
      const isCompliant = this.checkPracticeCompliance(key, practice, config);
      
      if (!isCompliant) {
        recommendations.push({
          category: component.charAt(0).toUpperCase() + component.slice(1),
          ...practice,
          currentState: 'Not implemented'
        });
        nonCompliantItems.push({
          category: component.charAt(0).toUpperCase() + component.slice(1),
          item: practice.title,
          severity: practice.priority
        });
      }
    }
  }
  
  applyVendorPractices(vendor, component, config, recommendations, nonCompliantItems) {
    // Apply vendor-specific practices
    const vendorPractices = this.vendorConfigurations[vendor.toLowerCase()];
    
    if (!vendorPractices) {
      return;
    }
    
    // If component is specified, only apply practices for that component
    if (component && vendorPractices[component]) {
      for (const [key, practice] of Object.entries(vendorPractices[component])) {
        const isCompliant = this.checkVendorPracticeCompliance(key, practice, config, vendor);
        
        if (!isCompliant) {
          recommendations.push({
            category: `${vendor.charAt(0).toUpperCase() + vendor.slice(1)} ${component.charAt(0).toUpperCase() + component.slice(1)}`,
            ...practice,
            currentState: 'Not compliant'
          });
          nonCompliantItems.push({
            category: `${vendor.charAt(0).toUpperCase() + vendor.slice(1)} ${component.charAt(0).toUpperCase() + component.slice(1)}`,
            item: practice.title,
            severity: practice.priority
          });
        }
      }
    } else {
      // Apply all vendor practices
      for (const [sectionKey, sectionPractices] of Object.entries(vendorPractices)) {
        if (typeof sectionPractices === 'object') {
          for (const [key, practice] of Object.entries(sectionPractices)) {
            const isCompliant = this.checkVendorPracticeCompliance(key, practice, config, vendor);
            
            if (!isCompliant) {
              recommendations.push({
                category: `${vendor.charAt(0).toUpperCase() + vendor.slice(1)} ${sectionKey.charAt(0).toUpperCase() + sectionKey.slice(1)}`,
                ...practice,
                currentState: 'Not compliant'
              });
              nonCompliantItems.push({
                category: `${vendor.charAt(0).toUpperCase() + vendor.slice(1)} ${sectionKey.charAt(0).toUpperCase() + sectionKey.slice(1)}`,
                item: practice.title,
                severity: practice.priority
              });
            }
          }
        }
      }
    }
  }
  
  applyIndustryPractices(industry, config, recommendations, nonCompliantItems) {
    // Apply industry-specific practices
    const industryPractices = this.industryProfiles[industry.toLowerCase()];
    
    if (!industryPractices) {
      return;
    }
    
    // Loop through each practice in the industry profile
    for (const [sectionKey, sectionPractices] of Object.entries(industryPractices)) {
      if (typeof sectionPractices === 'object') {
        const isCompliant = this.checkIndustryPracticeCompliance(sectionKey, sectionPractices, config, industry);
        
        if (!isCompliant) {
          recommendations.push({
            category: `${industry.charAt(0).toUpperCase() + industry.slice(1)} Industry`,
            ...sectionPractices,
            currentState: 'Not compliant'
          });
          nonCompliantItems.push({
            category: `${industry.charAt(0).toUpperCase() + industry.slice(1)} Industry`,
            item: sectionPractices.title,
            severity: sectionPractices.priority
          });
        }
      }
    }
  }
  
  checkIndustryPracticeCompliance(key, practice, config, industry) {
    // Check compliance with industry-specific practices
    switch (industry.toLowerCase()) {
      case 'healthcare':
        return this.checkHealthcareCompliance(key, practice, config);
      case 'finance':
        return this.checkFinanceCompliance(key, practice, config);
      case 'education':
        return this.checkEducationCompliance(key, practice, config);
      case 'government':
        return this.checkGovernmentCompliance(key, practice, config);
      case 'retail':
        return this.checkRetailCompliance(key, practice, config);
      case 'manufacturing':
        return this.checkManufacturingCompliance(key, practice, config);
      case 'energy':
        return this.checkEnergyCompliance(key, practice, config);
      default:
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  applyComplianceStandards(standards, config, recommendations, nonCompliantItems) {
    // Apply compliance standards
    for (const standard of standards) {
      const complianceProfile = this.complianceProfiles[standard.toLowerCase()];
      
      if (!complianceProfile) {
        continue;
      }
      
      // Process requirements
      if (complianceProfile.requirements) {
        for (const [reqKey, requirement] of Object.entries(complianceProfile.requirements)) {
          const isCompliant = this.checkComplianceRequirement(reqKey, requirement, config, standard);
          
          if (!isCompliant) {
            recommendations.push({
              category: `${standard.toUpperCase()} Compliance`,
              ...requirement,
              currentState: 'Not compliant'
            });
            nonCompliantItems.push({
              category: `${standard.toUpperCase()} Compliance`,
              item: requirement.title,
              severity: requirement.priority
            });
          }
        }
      }
    }
  }
  
  checkComplianceRequirement(key, requirement, config, standard) {
    // Check compliance with specific standard requirements
    switch (standard.toLowerCase()) {
      case 'pci':
        return this.checkPciRequirement(key, requirement, config);
      case 'hipaa':
        return this.checkHipaaRequirement(key, requirement, config);
      case 'nist':
        return this.checkNistRequirement(key, requirement, config);
      case 'iso27001':
        return this.checkIso27001Requirement(key, requirement, config);
      case 'gdpr':
        return this.checkGdprRequirement(key, requirement, config);
      case 'fedramp':
        return this.checkFedRampRequirement(key, requirement, config);
      default:
        return this.checkGenericCompliance(key, requirement, config);
    }
  }
  
  // Compliance standard specific checks
  checkPciRequirement(key, requirement, config) {
    switch (key) {
      case 'req2':
        return config.radius && config.radius.authentication && 
               config.radius.authentication.methods && 
               config.radius.authentication.methods.includes('EAP-TLS');
      case 'req4':
        return (config.radsec && config.radsec.enabled) || 
               (config.ipsec && config.ipsec.enabled);
      case 'req7':
        return config.radius && config.radius.authorization && 
               config.radius.authorization.enabled;
      case 'req8':
        return config.mfa && config.mfa.enabled;
      case 'req10':
        return config.radius && config.radius.accounting && 
               config.radius.accounting.enabled && 
               config.logging && config.logging.enabled;
      default:
        return false;
    }
  }
  
  checkHipaaRequirement(key, requirement, config) {
    // HIPAA-specific checks
    return this.checkGenericCompliance(key, requirement, config);
  }
  
  checkNistRequirement(key, requirement, config) {
    // NIST-specific checks
    return this.checkGenericCompliance(key, requirement, config);
  }
  
  checkIso27001Requirement(key, requirement, config) {
    // ISO 27001-specific checks
    return this.checkGenericCompliance(key, requirement, config);
  }
  
  checkGdprRequirement(key, requirement, config) {
    // GDPR-specific checks
    return this.checkGenericCompliance(key, requirement, config);
  }
  
  checkFedRampRequirement(key, requirement, config) {
    // FedRAMP-specific checks
    return this.checkGenericCompliance(key, requirement, config);
  }
  
  applySecurityLevelEnhancements(securityLevel, config, recommendations) {
    // Apply security level-specific enhancements
    switch (securityLevel.toLowerCase()) {
      case 'highest':
        this.applyHighestSecurityLevel(config, recommendations);
        // Fall through to apply all lower levels too
      case 'high':
        this.applyHighSecurityLevel(config, recommendations);
        // Fall through
      case 'standard':
        this.applyStandardSecurityLevel(config, recommendations);
        // Fall through
      case 'baseline':
        this.applyBaselineSecurityLevel(config, recommendations);
        break;
      default:
        // Unknown security level, apply standard
        this.applyStandardSecurityLevel(config, recommendations);
    }
  }
  
  applyBaselineSecurityLevel(config, recommendations) {
    // Baseline security level recommendations
    if (!config.radius || !config.radius.authentication || !config.radius.authentication.enabled) {
      recommendations.push({
        category: 'Security Level - Baseline',
        title: "Basic Authentication",
        description: "Implement basic RADIUS authentication",
        recommendation: "Configure RADIUS server and enable authentication",
        priority: "high",
        impact: "Provides basic authentication security",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.dot1x || !config.dot1x.enabled) {
      recommendations.push({
        category: 'Security Level - Baseline',
        title: "802.1X Authentication",
        description: "Enable 802.1X authentication",
        recommendation: "Configure 802.1X authentication on network devices",
        priority: "high",
        impact: "Provides port-based access control",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.secondaryServer || !config.secondaryServer.enabled) {
      recommendations.push({
        category: 'Security Level - Baseline',
        title: "Authentication Redundancy",
        description: "Implement redundant authentication servers",
        recommendation: "Configure secondary RADIUS server",
        priority: "high",
        impact: "Ensures authentication availability",
        currentState: 'Not implemented'
      });
    }
  }
  
  applyStandardSecurityLevel(config, recommendations) {
    // Standard security level recommendations
    if (!config.radius || !config.radius.accounting || !config.radius.accounting.enabled) {
      recommendations.push({
        category: 'Security Level - Standard',
        title: "RADIUS Accounting",
        description: "Enable RADIUS accounting",
        recommendation: "Configure accounting for audit trails",
        priority: "medium",
        impact: "Provides authentication audit records",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.vlanAssignment || !config.vlanAssignment.dynamic) {
      recommendations.push({
        category: 'Security Level - Standard',
        title: "Dynamic VLAN Assignment",
        description: "Implement dynamic VLAN assignment",
        recommendation: "Configure RADIUS for dynamic VLAN assignment",
        priority: "medium",
        impact: "Enables dynamic network segmentation",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.authenticationFallback || !config.authenticationFallback.enabled) {
      recommendations.push({
        category: 'Security Level - Standard',
        title: "Authentication Fallback",
        description: "Configure authentication fallback mechanisms",
        recommendation: "Implement MAB fallback for devices that don't support 802.1X",
        priority: "medium",
        impact: "Ensures compatibility with non-802.1X devices",
        currentState: 'Not implemented'
      });
    }
  }
  
  applyHighSecurityLevel(config, recommendations) {
    // High security level recommendations
    if (!config.radsec || !config.radsec.enabled) {
      recommendations.push({
        category: 'Security Level - High',
        title: "Encrypted RADIUS",
        description: "Implement RADIUS encryption",
        recommendation: "Configure RadSec for encrypted RADIUS traffic",
        priority: "high",
        impact: "Protects authentication traffic from eavesdropping",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.radius || !config.radius.authorization || !config.radius.authorization.dacl) {
      recommendations.push({
        category: 'Security Level - High',
        title: "Downloadable ACLs",
        description: "Implement downloadable ACLs",
        recommendation: "Configure RADIUS to provide downloadable ACLs",
        priority: "high",
        impact: "Provides granular access control",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.coa || !config.coa.enabled) {
      recommendations.push({
        category: 'Security Level - High',
        title: "Dynamic Authorization",
        description: "Enable Change of Authorization (CoA)",
        recommendation: "Configure RADIUS CoA support",
        priority: "high",
        impact: "Enables dynamic policy changes",
        currentState: 'Not implemented'
      });
    }
  }
  
  applyHighestSecurityLevel(config, recommendations) {
    // Highest security level recommendations
    if (!config.macsec || !config.macsec.enabled) {
      recommendations.push({
        category: 'Security Level - Highest',
        title: "Layer 2 Encryption",
        description: "Implement MACsec encryption",
        recommendation: "Configure 802.1AE MACsec for layer 2 encryption",
        priority: "high",
        impact: "Provides wire-level encryption",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.certificate || !config.certificate.validation || !config.certificate.validation.ocsp) {
      recommendations.push({
        category: 'Security Level - Highest',
        title: "Certificate Validation",
        description: "Implement certificate validation",
        recommendation: "Configure OCSP for real-time certificate validation",
        priority: "high",
        impact: "Ensures only valid certificates are accepted",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.mfa || !config.mfa.enabled) {
      recommendations.push({
        category: 'Security Level - Highest',
        title: "Multi-Factor Authentication",
        description: "Implement multi-factor authentication",
        recommendation: "Configure MFA for administrative access",
        priority: "high",
        impact: "Provides strongest authentication security",
        currentState: 'Not implemented'
      });
    }
  }
  
  applyDeviceTypeOptimizations(deviceType, config, recommendations) {
    // Device type specific optimizations
    switch (deviceType.toLowerCase()) {
      case 'wired':
        this.applyWiredOptimizations(config, recommendations);
        break;
      case 'wireless':
        this.applyWirelessOptimizations(config, recommendations);
        break;
      case 'firewall':
        this.applyFirewallOptimizations(config, recommendations);
        break;
      case 'router':
        this.applyRouterOptimizations(config, recommendations);
        break;
      case 'switch':
        this.applySwitchOptimizations(config, recommendations);
        break;
      default:
        // Unknown device type, apply wired optimizations
        this.applyWiredOptimizations(config, recommendations);
    }
  }
  
  applyWiredOptimizations(config, recommendations) {
    // Wired device optimizations
    if (!config.portSecurity || !config.portSecurity.enabled) {
      recommendations.push({
        category: 'Device Optimization - Wired',
        title: "Port Security",
        description: "Enable port security features",
        recommendation: "Configure DHCP snooping, IP Source Guard, and Dynamic ARP Inspection",
        priority: "high",
        impact: "Provides comprehensive port security",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.stormControl || !config.stormControl.enabled) {
      recommendations.push({
        category: 'Device Optimization - Wired',
        title: "Storm Control",
        description: "Implement storm control protection",
        recommendation: "Configure storm control to limit broadcast, multicast, and unknown unicast traffic",
        priority: "medium",
        impact: "Prevents network disruption from traffic storms",
        currentState: 'Not implemented'
      });
    }
  }
  
  applyWirelessOptimizations(config, recommendations) {
    // Wireless device optimizations
    if (!config.wpa || !config.wpa.version !== '3-enterprise') {
      recommendations.push({
        category: 'Device Optimization - Wireless',
        title: "WPA3-Enterprise",
        description: "Implement WPA3-Enterprise",
        recommendation: "Configure WPA3-Enterprise with 802.1X",
        priority: "high",
        impact: "Provides strongest wireless security",
        currentState: 'Not implemented'
      });
    }
    
    if (!config.pmf || !config.pmf.enabled) {
      recommendations.push({
        category: 'Device Optimization - Wireless',
        title: "Protected Management Frames",
        description: "Enable Protected Management Frames (PMF)",
        recommendation: "Configure PMF to protect against deauthentication attacks",
        priority: "high",
        impact: "Prevents wireless management frame attacks",
        currentState: 'Not implemented'
      });
    }
  }
  
  applyFirewallOptimizations(config, recommendations) {
    // Firewall device optimizations
    if (!config.identityAwareness || !config.identityAwareness.enabled) {
      recommendations.push({
        category: 'Device Optimization - Firewall',
        title: "Identity-Aware Firewall",
        description: "Implement identity-aware firewall policies",
        recommendation: "Configure identity integration with RADIUS for user-based policies",
        priority: "high",
        impact: "Enables user-based security policies",
        currentState: 'Not implemented'
      });
    }
  }
  
  applyRouterOptimizations(config, recommendations) {
    // Router device optimizations
    if (!config.controlPlanePolicing || !config.controlPlanePolicing.enabled) {
      recommendations.push({
        category: 'Device Optimization - Router',
        title: "Control Plane Policing",
        description: "Implement control plane policing",
        recommendation: "Configure CoPP to protect the control plane",
        priority: "high",
        impact: "Prevents DoS attacks against control plane",
        currentState: 'Not implemented'
      });
    }
  }
  
  applySwitchOptimizations(config, recommendations) {
    // Switch device optimizations
    if (!config.spanningTree || !config.spanningTree.portFast || !config.spanningTree.bpduGuard) {
      recommendations.push({
        category: 'Device Optimization - Switch',
        title: "STP Protection",
        description: "Implement spanning tree protection",
        recommendation: "Configure PortFast and BPDU Guard on access ports",
        priority: "high",
        impact: "Prevents spanning tree attacks",
        currentState: 'Not implemented'
      });
    }
  }
  
  // Calculate security score based on compliance
  calculateSecurityScore(config, nonCompliantItems) {
    // Basic score calculation
    const maxScore = 100;
    const nonCompliantWeight = {
      'high': 10,
      'medium': 5,
      'low': 2
    };
    
    let totalDeduction = 0;
    
    // Deduct points for each non-compliant item based on priority
    nonCompliantItems.forEach(item => {
      totalDeduction += nonCompliantWeight[item.severity] || 5;
    });
    
    // Cap the deduction to maxScore
    totalDeduction = Math.min(totalDeduction, maxScore);
    
    // Calculate final score
    const score = maxScore - totalDeduction;
    
    return Math.max(0, score);
  }
  
  // Helper methods for checking practice compliance
  checkVendorPracticeCompliance(key, practice, config, vendor) {
    // This would contain vendor-specific logic to check if the config complies with the practice
    switch (vendor.toLowerCase()) {
      case 'cisco':
        return this.checkCiscoCompliance(key, practice, config);
      case 'aruba':
        return this.checkArubaCompliance(key, practice, config);
      case 'juniper':
        return this.checkJuniperCompliance(key, practice, config);
      case 'extreme':
        return this.checkExtremeCompliance(key, practice, config);
      case 'fortinet':
        return this.checkFortinetCompliance(key, practice, config);
      case 'paloalto':
        return this.checkPaloAltoCompliance(key, practice, config);
      default:
        // Default check for unknown vendors
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  checkCiscoCompliance(key, practice, config) {
    // Cisco-specific checks
    switch (key) {
      case 'ibns2':
        return config.ibns && config.ibns.version === '2.0';
      case 'keyWrap':
        return config.radius && config.radius.keyWrap && config.radius.keyWrap.enabled;
      case 'dhcpSnooping':
        return config.dhcpSnooping && config.dhcpSnooping.enabled;
      case 'ipSourceGuard':
        return config.ipSourceGuard && config.ipSourceGuard.enabled;
      case 'dynamicArpInspection':
        return config.dai && config.dai.enabled;
      case 'radsec':
        return config.radsec && config.radsec.enabled;
      default:
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  checkArubaCompliance(key, practice, config) {
    // Aruba-specific checks
    switch (key) {
      case 'centralizedAuth':
        return config.cppm && config.cppm.enabled;
      case 'userRoleMappings':
        return config.userRoles && config.userRoles.enabled;
      case 'cppmPolicies':
        return config.cppm && config.cppm.policies && config.cppm.policies.length > 0;
      case 'clearpassOnboarding':
        return config.cppm && config.cppm.onboarding && config.cppm.onboarding.enabled;
      default:
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  checkJuniperCompliance(key, practice, config) {
    // Juniper-specific checks
    switch (key) {
      case 'unifiedAccessControl':
        return config.uac && config.uac.enabled;
      case 'captivePortal':
        return config.captivePortal && config.captivePortal.enabled;
      case 'securityPolicies':
        return config.securityPolicies && config.securityPolicies.enabled;
      default:
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  checkExtremeCompliance(key, practice, config) {
    // Extreme-specific checks
    switch (key) {
      case 'policyManager':
        return config.policyManager && config.policyManager.enabled;
      case 'policyVlans':
        return config.policyVlans && config.policyVlans.enabled;
      default:
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  checkFortinetCompliance(key, practice, config) {
    // Fortinet-specific checks
    switch (key) {
      case 'securityFabric':
        return config.securityFabric && config.securityFabric.enabled;
      case 'fortinac':
        return config.fortinac && config.fortinac.enabled;
      default:
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  checkPaloAltoCompliance(key, practice, config) {
    // Palo Alto-specific checks
    switch (key) {
      case 'zerotouch':
        return config.zerotouch && config.zerotouch.enabled;
      case 'userID':
        return config.userId && config.userId.enabled;
      case 'globalProtect':
        return config.globalProtect && config.globalProtect.enabled;
      default:
        return this.checkGenericCompliance(key, practice, config);
    }
  }
  
  // Default compliance check for all vendors and components
  checkGenericCompliance(key, practice, config) {
    // Simple check if the feature exists in config
    return config[key] && config[key].enabled;
  }
  
  // Check practice compliance
  checkPracticeCompliance(key, practice, config) {
    // This would contain logic to check if the config complies with the practice
    switch (key) {
      case 'keyWrap':
        return config.keyWrap && config.keyWrap.enabled;
      case 'messageAuthenticator':
        return config.messageAuthenticator === true;
      case 'accounting':
        return config.enabled && config.interim === true;
      case 'deadTime':
        return config.deadtime >= 5 && config.deadtime <= 15;
      case 'dynamicAuthorization':
        return config.coa && config.coa.enabled;
      case 'encryption':
        return config.encryption && config.encryption.enabled;
      case 'commandAuthorization':
        return config.commandAuthorization && config.commandAuthorization.enabled;
      case 'tlsVersion':
        return config.tlsVersion && (config.tlsVersion === 'tls1.2' || config.tlsVersion === 'tls1.3');
      case 'certificateValidation':
        return config.certificateValidation && config.certificateValidation.enabled;
      default:
        // Default check for unknown practices
        return config[key] && config[key].enabled;
    }
  }
  
  // Methods for retrieving practices (useful for documentation)
  getGeneralPractices() {
    return this.practices.general;
  }
  
  getComponentPractices(component) {
    return this.practices[component] || {};
  }
  
  getVendorPractices(vendor, component) {
    const vendorPractices = this.vendorConfigurations[vendor.toLowerCase()];
    if (!vendorPractices) {
      return {};
    }
    
    if (component) {
      return vendorPractices[component] || {};
    }
    
    return vendorPractices;
  }
  
  getCompliancePractices(standard) {
    return this.complianceProfiles[standard.toLowerCase()] || {};
  }
  
  getIndustryPractices(industry) {
    return this.industryProfiles[industry.toLowerCase()] || {};
  }
  
  checkHealthcareCompliance(key, practice, config) {
    switch (key) {
      case 'clinical':
        return config.radius && config.radius.authentication && 
               config.radius.authentication.methods && 
               config.radius.authentication.methods.includes('EAP-TLS') &&
               config.deviceProfiling && config.deviceProfiling.medical;
      case 'medical':
        return config.mab && config.mab.enabled && 
               config.deviceProfiling && config.deviceProfiling.medical;
      case 'segmentation':
        return config.vlanAssignment && config.vlanAssignment.dynamic && 
               config.acls && config.acls.interVlan;
      default:
        return false;
    }
  }
  
  checkFinanceCompliance(key, practice, config) {
    switch (key) {
      case 'trading':
        return config.authentication && config.authentication.caching && 
               config.failover && config.failover.enabled && 
               config.failover.maxDelay < 500;
      case 'dmz':
        return config.radius && config.radius.authentication && 
               config.radius.authentication.methods && 
               config.radius.authentication.methods.includes('EAP-TLS') &&
               config.networkSegmentation && config.networkSegmentation.dmz;
      default:
        return false;
    }
  }
  
  checkEducationCompliance(key, practice, config) {
    switch (key) {
      case 'classroom':
        return config.authentication && config.authentication.concurrent && 
               config.deviceProfiling && config.deviceProfiling.enabled;
      case 'byod':
        return config.onboarding && config.onboarding.portal && 
               config.onboarding.policies && config.onboarding.policies.byod;
      default:
        return false;
    }
  }
  
  checkGovernmentCompliance(key, practice, config) {
    switch (key) {
      case 'classified':
        return config.authentication && config.authentication.mfa && 
               config.securityControls && 
               config.securityControls.level === 'high';
      case 'unclassified':
        return config.radius && config.radius.authentication && 
               config.radius.authentication.methods && 
               config.radius.authentication.methods.includes('EAP-TLS') &&
               config.securityControls && 
               config.securityControls.level === 'medium';
      default:
        return false;
    }
  }
  
  checkRetailCompliance(key, practice, config) {
    switch (key) {
      case 'pos':
        return (config.authentication && config.authentication.dot1x) || 
               (config.authentication && config.authentication.mab) &&
               config.networkSegmentation && config.networkSegmentation.pos;
      case 'backOffice':
        return config.authentication && config.authentication.dot1x && 
               config.securityControls && 
               config.securityControls.level === 'medium';
      default:
        return false;
    }
  }
  
  checkManufacturingCompliance(key, practice, config) {
    switch (key) {
      case 'ot':
        return config.mab && config.mab.enabled && 
               config.deviceProfiling && config.deviceProfiling.ot;
      case 'iotDevices':
        return ((config.authentication && config.authentication.dot1x && 
                config.authentication.methods && 
                config.authentication.methods.includes('EAP-TLS')) || 
               (config.mab && config.mab.enabled)) && 
               config.deviceProfiling && config.deviceProfiling.iot;
      default:
        return false;
    }
  }
  
  checkEnergyCompliance(key, practice, config) {
    switch (key) {
      case 'scada':
        return config.mab && config.mab.enabled && 
               config.deviceProfiling && config.deviceProfiling.scada;
      case 'smartGrid':
        return config.authentication && config.authentication.certificate && 
               config.authentication.fallback && 
               config.authentication.fallback.enabled;
      default:
        return false;
    }
  }
}

// Export the module
export default AuthenticationBestPractices;
