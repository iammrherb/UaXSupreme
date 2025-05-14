// Configuration Generator for Dot1Xer
class ConfigGenerator {
  constructor() {
    this.templates = {};
    this.loadedTemplates = 0;
    this.totalTemplates = 0;
    this.vendor = null;
    this.platform = null;
    this.formData = {};
  }

  // Initialize the generator
  init() {
    console.log("Initializing Configuration Generator...");
    this.setupEventListeners();
  }

  // Set up event listeners
  setupEventListeners() {
    const generateBtn = document.getElementById('generate-config');
    if (generateBtn) {
      generateBtn.addEventListener('click', () => this.generateConfiguration());
    }

    const copyBtn = document.getElementById('copy-config');
    if (copyBtn) {
      copyBtn.addEventListener('click', () => this.copyToClipboard());
    }

    const downloadBtn = document.getElementById('download-config');
    if (downloadBtn) {
      downloadBtn.addEventListener('click', () => this.downloadConfiguration());
    }
  }

  // Load template for vendor/platform
  loadTemplate(vendor, platform) {
    return new Promise((resolve, reject) => {
      const templateUrl = `templates/vendors/${vendor}/${platform}.txt`;
      
      fetch(templateUrl)
        .then(response => {
          if (!response.ok) {
            // Try fallback to basic template
            return fetch(`templates/vendors/${vendor}/basic.txt`);
          }
          return response;
        })
        .then(response => {
          if (!response.ok) {
            throw new Error(`Could not load template for ${vendor}/${platform}`);
          }
          return response.text();
        })
        .then(template => {
          this.templates[`${vendor}/${platform}`] = template;
          resolve(template);
        })
        .catch(error => {
          console.error("Error loading template:", error);
          reject(error);
        });
    });
  }

  // Gather form data
  gatherFormData() {
    this.formData = {
      // Authentication Settings
      authMethod: document.getElementById('auth-method')?.value,
      authMode: document.querySelector('input[name="auth-mode"]:checked')?.value,
      hostMode: document.getElementById('host-mode')?.value,
      
      // RADIUS Server Settings
      radiusServer1: document.getElementById('radius-server-1')?.value,
      radiusKey1: document.getElementById('radius-key-1')?.value,
      radiusAuthPort1: document.getElementById('radius-auth-port-1')?.value || "1812",
      radiusAcctPort1: document.getElementById('radius-acct-port-1')?.value || "1813",
      radiusServer2: document.getElementById('radius-server-2')?.value,
      radiusKey2: document.getElementById('radius-key-2')?.value,
      radiusTimeout: document.getElementById('radius-timeout')?.value || "5",
      radiusRetransmit: document.getElementById('radius-retransmit')?.value || "3",
      radiusDeadtime: document.getElementById('radius-deadtime')?.value || "15",
      enableAccounting: document.getElementById('enable-accounting')?.checked,
      accountingInterval: document.getElementById('accounting-interval')?.value || "1440",
      
      // Security Settings
      reauthPeriod: document.getElementById('reauth-period')?.value || "3600",
      txPeriod: document.getElementById('tx-period')?.value || "30",
      quietPeriod: document.getElementById('quiet-period')?.value || "60",
      maxReauth: document.getElementById('max-reauth')?.value || "2",
      useCoa: document.getElementById('use-coa')?.checked,
      coaPort: document.getElementById('coa-port')?.value || "3799",
      useRadsec: document.getElementById('use-radsec')?.checked,
      radsecPort: document.getElementById('radsec-port')?.value || "2083",
      useMacsec: document.getElementById('use-macsec')?.checked,
      
      // Network Settings
      enableDynamicVlan: document.getElementById('enable-dynamic-vlan')?.checked,
      vlanAuth: document.getElementById('vlan-auth')?.value,
      vlanUnauth: document.getElementById('vlan-unauth')?.value,
      vlanGuest: document.getElementById('vlan-guest')?.value,
      vlanVoice: document.getElementById('vlan-voice')?.value,
      vlanCritical: document.getElementById('vlan-critical')?.value,
      interface: document.getElementById('interface')?.value,
      interfaceRange: document.getElementById('interface-range')?.value,
      
      // DHCP and ARP Settings
      enableDhcpSnooping: document.getElementById('enable-dhcp-snooping')?.checked,
      dhcpSnoopingVlans: document.getElementById('dhcp-snooping-vlans')?.value || "1-4094",
      dhcpSnoopingOption82: document.getElementById('dhcp-snooping-option82')?.checked,
      enableDai: document.getElementById('enable-dai')?.checked,
      daiVlans: document.getElementById('dai-vlans')?.value || "1-4094",
      daiValidateSrc: document.getElementById('dai-validate-src')?.checked,
      daiValidateDst: document.getElementById('dai-validate-dst')?.checked,
      daiValidateIp: document.getElementById('dai-validate-ip')?.checked,
      enableIpsg: document.getElementById('enable-ipsg')?.checked,
      
      // Storm Control
      enableStormControl: document.getElementById('enable-storm-control')?.checked,
      stormControlAction: document.getElementById('storm-control-action')?.value || "trap",
      stormControlBroadcast: document.getElementById('storm-control-broadcast')?.value || "80.00",
      stormControlMulticast: document.getElementById('storm-control-multicast')?.value || "80.00",
      stormControlUnicast: document.getElementById('storm-control-unicast')?.value || "80.00",
      
      // Port Security
      enablePortSecurity: document.getElementById('enable-port-security')?.checked,
      portSecurityMaxMac: document.getElementById('port-security-max-mac')?.value || "5",
      portSecurityViolation: document.getElementById('port-security-violation')?.value || "protect",
      
      // TACACS Settings
      useTacacs: document.getElementById('use-tacacs')?.checked,
      tacacsServer1: document.getElementById('tacacs-server-1')?.value,
      tacacsKey1: document.getElementById('tacacs-key-1')?.value,
      tacacsServer2: document.getElementById('tacacs-server-2')?.value,
      tacacsKey2: document.getElementById('tacacs-key-2')?.value,
      tacacsTimeout: document.getElementById('tacacs-timeout')?.value || "5",
      tacacsSourceInterface: document.getElementById('tacacs-source-interface')?.value,
      
      // Additional Commands
      additionalCommands: document.getElementById('additional-commands')?.value
    };
    
    return this.formData;
  }

  // Generate configuration
  async generateConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput) return;
    
    // Show loading message
    configOutput.textContent = "Generating configuration...";
    
    try {
      // Get vendor and platform
      this.vendor = localStorage.getItem('selectedVendor');
      this.platform = document.getElementById('platform-select')?.value;
      
      if (!this.vendor || !this.platform) {
        configOutput.textContent = "Error: Please select a vendor and platform.";
        return;
      }
      
      // Gather form data
      this.gatherFormData();
      
      // Load template if not already loaded
      if (!this.templates[`${this.vendor}/${this.platform}`]) {
        await this.loadTemplate(this.vendor, this.platform);
      }
      
      // Get template
      let template = this.templates[`${this.vendor}/${this.platform}`];
      
      // Process template with form data
      const config = this.processTemplate(template);
      
      // Display configuration
      configOutput.textContent = config;
      
    } catch (error) {
      console.error("Error generating configuration:", error);
      configOutput.textContent = `Error generating configuration: ${error.message}`;
    }
  }

  // Process template with form data
  processTemplate(template) {
    // Replace variables in template with form data
    let config = template;
    
    // Replace basic field variables
    Object.keys(this.formData).forEach(key => {
      const value = this.formData[key];
      if (value !== undefined && value !== null) {
        // Handle boolean values
        if (typeof value === 'boolean') {
          // Skip section if boolean is false
          const regex = new RegExp(`{{#${key}}}([\\s\\S]*?){{/${key}}}`, 'g');
          if (value) {
            // Keep content but remove the conditional tags
            config = config.replace(regex, '$1');
          } else {
            // Remove content and tags
            config = config.replace(regex, '');
          }
        } else {
          // Replace variable with value
          const regex = new RegExp(`{{${key}}}`, 'g');
          config = config.replace(regex, value);
        }
      }
    });
    
    // Handle conditional blocks that haven't been processed
    config = this.processConditionalBlocks(config);
    
    // Clean up any remaining template variables
    config = this.cleanupTemplate(config);
    
    return config;
  }

  // Process conditional blocks in template
  processConditionalBlocks(template) {
    let config = template;
    
    // Handle equality conditional blocks {{#key eq "value"}}...{{/key}}
    const eqRegex = /{{#(\w+) eq "([^"]+)"}}/g;
    let match;
    
    while ((match = eqRegex.exec(template)) !== null) {
      const [fullMatch, key, value] = match;
      const endTag = `{{/${key}}}`;
      
      // Find the end of this conditional block
      const startIndex = match.index;
      const endIndex = template.indexOf(endTag, startIndex) + endTag.length;
      
      if (endIndex > startIndex) {
        const blockContent = template.substring(startIndex + fullMatch.length, endIndex - endTag.length);
        
        // Check if condition is met
        if (this.formData[key] === value) {
          // Replace the entire block with just the content
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, blockContent);
        } else {
          // Remove the entire block
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, '');
        }
      }
    }
    
    // Handle negation conditional blocks {{^key}}...{{/key}}
    const negRegex = /{{^(\w+)}}/g;
    
    while ((match = negRegex.exec(template)) !== null) {
      const [fullMatch, key] = match;
      const endTag = `{{/${key}}}`;
      
      // Find the end of this conditional block
      const startIndex = match.index;
      const endIndex = template.indexOf(endTag, startIndex) + endTag.length;
      
      if (endIndex > startIndex) {
        const blockContent = template.substring(startIndex + fullMatch.length, endIndex - endTag.length);
        
        // Check if condition is met (value is falsy)
        if (!this.formData[key]) {
          // Replace the entire block with just the content
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, blockContent);
        } else {
          // Remove the entire block
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, '');
        }
      }
    }
    
    return config;
  }

  // Clean up any remaining template variables and conditionals
  cleanupTemplate(template) {
    let config = template;
    
    // Remove any remaining simple variables
    config = config.replace(/{{[^{}]+}}/g, '');
    
    // Remove any remaining conditional blocks
    config = config.replace(/{{#[^{}]+}}[\s\S]*?{{\/[^{}]+}}/g, '');
    config = config.replace(/{{^[^{}]+}}[\s\S]*?{{\/[^{}]+}}/g, '');
    
    // Clean up empty lines (more than 2 consecutive)
    config = config.replace(/\n{3,}/g, '\n\n');
    
    return config;
  }

  // Copy configuration to clipboard
  copyToClipboard() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput || !configOutput.textContent) {
      alert('No configuration to copy. Please generate a configuration first.');
      return;
    }
    
    // Create a temporary textarea element
    const textarea = document.createElement('textarea');
    textarea.value = configOutput.textContent;
    textarea.style.position = 'fixed';
    textarea.style.opacity = 0;
    document.body.appendChild(textarea);
    
    // Select and copy text
    textarea.select();
    document.execCommand('copy');
    
    // Clean up
    document.body.removeChild(textarea);
    
    // Show success message
    alert('Configuration copied to clipboard!');
  }

  // Download configuration as a file
  downloadConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput || !configOutput.textContent) {
      alert('No configuration to download. Please generate a configuration first.');
      return;
    }
    
    // Create filename based on vendor and platform
    let filename = 'config.txt';
    if (this.vendor && this.platform) {
      filename = `${this.vendor}-${this.platform}-config.txt`;
    }
    
    // Create a blob and download link
    const blob = new Blob([configOutput.textContent], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.style.display = 'none';
    
    // Trigger download
    document.body.appendChild(a);
    a.click();
    
    // Clean up
    setTimeout(() => {
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }, 100);
  }
}

// Initialize the generator when the document is ready
document.addEventListener('DOMContentLoaded', () => {
  const generator = new ConfigGenerator();
  generator.init();
});
