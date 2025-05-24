// Comprehensive Vendor Configuration Wizard

class VendorWizard {
  constructor() {
    this.currentStep = 0;
    this.formData = {};
    this.vendorData = {};
    this.platformData = {};
    this.templates = {};
  }

  // Initialize the wizard
  async init() {
    // Load vendor data
    await this.loadVendorData();
    
    // Set up event listeners
    this.setupEventListeners();
    
    // Initialize vendor selection grid
    this.initVendorGrid();
    
    // Setup form toggles and validations
    this.setupFormControls();
    
    // Initialize configuration preview
    this.initConfigPreview();
    
    console.log('Vendor Wizard initialized successfully');
  }

  // Load vendor data from server
  async loadVendorData() {
    try {
      const response = await fetch('data/vendors.json');
      if (!response.ok) {
        throw new Error('Failed to load vendor data');
      }
      this.vendorData = await response.json();
      console.log('Vendor data loaded:', Object.keys(this.vendorData).length, 'vendors');
    } catch (error) {
      console.error('Error loading vendor data:', error);
      // Fallback to hardcoded data
      this.vendorData = {
        cisco: {
          name: "Cisco",
          platforms: ["ios", "ios-xe", "nx-os", "wlc-9800"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: true,
            coa: true,
            wireless: true
          }
        },
        juniper: {
          name: "Juniper",
          platforms: ["junos", "mist"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: true,
            coa: true,
            wireless: true
          }
        },
        aruba: {
          name: "Aruba",
          platforms: ["aos-cx", "aos-switch"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: false,
            coa: true,
            wireless: true
          }
        },
        fortinet: {
          name: "Fortinet",
          platforms: ["fortiswitch", "fortigate"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: false,
            coa: false,
            wireless: true
          }
        }
      };
    }
  }

  // Set up event listeners
  setupEventListeners() {
    // Next/Previous step buttons
    document.querySelectorAll('.wizard-navigation .btn-next').forEach(btn => {
      btn.addEventListener('click', () => this.nextStep());
    });
    
    document.querySelectorAll('.wizard-navigation .btn-prev').forEach(btn => {
      btn.addEventListener('click', () => this.prevStep());
    });
    
    // Generate config button
    const generateBtn = document.getElementById('generate-config-btn');
    if (generateBtn) {
      generateBtn.addEventListener('click', () => this.generateConfiguration());
    }
    
    // Copy to clipboard button
    const copyBtn = document.getElementById('copy-config-btn');
    if (copyBtn) {
      copyBtn.addEventListener('click', () => this.copyToClipboard());
    }
    
    // Download button
    const downloadBtn = document.getElementById('download-config-btn');
    if (downloadBtn) {
      downloadBtn.addEventListener('click', () => this.downloadConfiguration());
    }
  }

  // Initialize vendor selection grid
  initVendorGrid() {
    const vendorGrid = document.getElementById('vendor-grid');
    if (!vendorGrid) return;
    
    // Clear existing content
    vendorGrid.innerHTML = '';
    
    // Create vendor cards
    Object.keys(this.vendorData).forEach(vendorKey => {
      const vendor = this.vendorData[vendorKey];
      
      const card = document.createElement('div');
      card.className = 'vendor-card';
      card.dataset.vendor = vendorKey;
      
      // Add types badge
      const typeText = vendor.types.includes('wired') && vendor.types.includes('wireless') 
        ? 'Wired & Wireless' 
        : vendor.types.includes('wired') 
          ? 'Wired' 
          : 'Wireless';
          
      const typeBadge = document.createElement('span');
      typeBadge.className = `vendor-type ${vendor.types.join('-')}`;
      typeBadge.textContent = typeText;
      
      // Add vendor logo and name
      const logo = document.createElement('img');
      logo.src = `assets/images/vendors/${vendorKey}.png`;
      logo.alt = vendor.name;
      logo.className = 'vendor-logo';
      
      const name = document.createElement('div');
      name.className = 'vendor-name';
      name.textContent = vendor.name;
      
      // Add elements to card
      card.appendChild(typeBadge);
      card.appendChild(logo);
      card.appendChild(name);
      
      // Add click handler
      card.addEventListener('click', () => this.selectVendor(vendorKey));
      
      // Add card to grid
      vendorGrid.appendChild(card);
    });
  }

  // Handle vendor selection
  selectVendor(vendorKey) {
    // Update UI
    document.querySelectorAll('.vendor-card').forEach(card => {
      card.classList.remove('selected');
    });
    
    const selectedCard = document.querySelector(`.vendor-card[data-vendor="${vendorKey}"]`);
    if (selectedCard) {
      selectedCard.classList.add('selected');
    }
    
    // Store selected vendor
    this.formData.vendor = vendorKey;
    
    // Update platform dropdown
    this.updatePlatformDropdown(vendorKey);
    
    // Update vendor information
    this.updateVendorInfo(vendorKey);
    
    // Enable next button
    const nextBtn = document.querySelector('#vendor-step .btn-next');
    if (nextBtn) {
      nextBtn.disabled = false;
    }
  }

  // Update platform dropdown based on selected vendor
  updatePlatformDropdown(vendorKey) {
    const platformSelect = document.getElementById('platform-select');
    if (!platformSelect) return;
    
    // Clear existing options
    platformSelect.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = 'Select a platform';
    platformSelect.appendChild(defaultOption);
    
    // Add platform options
    const vendor = this.vendorData[vendorKey];
    if (vendor && vendor.platforms) {
      vendor.platforms.forEach(platform => {
        const option = document.createElement('option');
        option.value = platform;
        option.textContent = this.formatPlatformName(platform);
        platformSelect.appendChild(option);
      });
    }
    
    // Enable the dropdown
    platformSelect.disabled = false;
    
    // Replace any existing change handler to avoid duplicate events
    platformSelect.onchange = () => {
      this.formData.platform = platformSelect.value;
      this.updatePlatformInfo(platformSelect.value);
    };
  }

  // Format platform name for display
  formatPlatformName(platform) {
    return platform
      .split('-')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  }

  // Update vendor information display
  updateVendorInfo(vendorKey) {
    const vendorInfoSection = document.getElementById('vendor-info');
    if (!vendorInfoSection) return;
    
    const vendor = this.vendorData[vendorKey];
    if (!vendor) return;
    
    // Create capabilities list
    const capabilities = [];
    if (vendor.capabilities.dot1x) capabilities.push('802.1X');
    if (vendor.capabilities.mab) capabilities.push('MAC Authentication Bypass');
    if (vendor.capabilities.tacacs) capabilities.push('TACACS+');
    if (vendor.capabilities.radsec) capabilities.push('RADIUS over TLS (RadSec)');
    if (vendor.capabilities.coa) capabilities.push('Change of Authorization (CoA)');
    if (vendor.capabilities.wireless) capabilities.push('Wireless Authentication');
    
    // Update info display
    vendorInfoSection.innerHTML = `
      <h4>${vendor.name} Authentication Capabilities</h4>
      <div class="capability-badges">
        ${capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
      </div>
    `;
  }

  // Update platform information display
  updatePlatformInfo(platform) {
    // This would show platform-specific capabilities and information
    const platformInfoSection = document.getElementById('platform-info');
    if (!platformInfoSection) return;
    
    if (!platform) {
      platformInfoSection.innerHTML = '<p>Please select a platform to see details.</p>';
      return;
    }
    
    // Here you would typically load platform-specific details
    platformInfoSection.innerHTML = `
      <h4>${this.formatPlatformName(platform)} Configuration</h4>
      <p>This template provides comprehensive authentication configuration for ${this.formatPlatformName(platform)} including 802.1X, MAB, RADIUS, and more.</p>
    `;
    
    // Enable next button
    const nextBtn = document.querySelector('#vendor-step .btn-next');
    if (nextBtn) {
      nextBtn.disabled = false;
    }
  }

  // Setup form controls
  setupFormControls() {
    // Toggle RADIUS server 2 fields
    const radiusServer2Container = document.getElementById('radius-server-2-container');
    const addRadiusServerBtn = document.getElementById('add-radius-server');
    
    if (radiusServer2Container && addRadiusServerBtn) {
      addRadiusServerBtn.addEventListener('click', () => {
        radiusServer2Container.style.display = 'block';
        addRadiusServerBtn.style.display = 'none';
      });
    }
    
    // Toggle TACACS+ fields
    const useTacacsCheckbox = document.getElementById('use-tacacs');
    const tacacsSettings = document.getElementById('tacacs-settings');
    
    if (useTacacsCheckbox && tacacsSettings) {
      useTacacsCheckbox.addEventListener('change', () => {
        tacacsSettings.style.display = useTacacsCheckbox.checked ? 'block' : 'none';
      });
    }
    
    // Toggle CoA fields
    const useCoaCheckbox = document.getElementById('use-coa');
    const coaSettings = document.getElementById('coa-settings');
    
    if (useCoaCheckbox && coaSettings) {
      useCoaCheckbox.addEventListener('change', () => {
        coaSettings.style.display = useCoaCheckbox.checked ? 'block' : 'none';
      });
    }
    
    // Toggle RadSec fields
    const useRadsecCheckbox = document.getElementById('use-radsec');
    const radsecSettings = document.getElementById('radsec-settings');
    
    if (useRadsecCheckbox && radsecSettings) {
      useRadsecCheckbox.addEventListener('change', () => {
        radsecSettings.style.display = useRadsecCheckbox.checked ? 'block' : 'none';
      });
    }
    
    // Toggle security feature sections
    const securityFeatures = [
      { checkbox: 'enable-dhcp-snooping', settings: 'dhcp-snooping-settings' },
      { checkbox: 'enable-dai', settings: 'dai-settings' },
      { checkbox: 'enable-ipsg', settings: 'ipsg-settings' },
      { checkbox: 'enable-storm-control', settings: 'storm-control-settings' },
      { checkbox: 'enable-port-security', settings: 'port-security-settings' }
    ];
    
    securityFeatures.forEach(feature => {
      const checkbox = document.getElementById(feature.checkbox);
      const settings = document.getElementById(feature.settings);
      
      if (checkbox && settings) {
        checkbox.addEventListener('change', () => {
          settings.style.display = checkbox.checked ? 'block' : 'none';
        });
      }
    });
  }

  // Initialize configuration preview
  initConfigPreview() {
    // This will be populated when generating the configuration
    const configPreview = document.getElementById('config-preview');
    if (configPreview) {
      configPreview.textContent = 'Configuration will be generated when you complete the wizard.';
    }
  }

  // Navigate to next step
  nextStep() {
    // Validate current step
    if (!this.validateStep(this.currentStep)) {
      return;
    }
    
    // Hide current step
    document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.remove('active');
    
    // Increment step counter
    this.currentStep++;
    
    // Show next step
    document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.add('active');
    
    // Update progress bar
    this.updateProgress();
    
    // If final step, generate preview
    if (this.currentStep === 3) {
      this.updateConfigSummary();
    }
  }

  // Navigate to previous step
  prevStep() {
    if (this.currentStep > 0) {
      // Hide current step
      document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.remove('active');
      
      // Decrement step counter
      this.currentStep--;
      
      // Show previous step
      document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.add('active');
      
      // Update progress bar
      this.updateProgress();
    }
  }

  // Update progress bar
  updateProgress() {
    const progressFill = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    if (progressFill && progressText) {
      const totalSteps = document.querySelectorAll('.wizard-step').length;
      const percentage = Math.round(((this.currentStep + 1) / totalSteps) * 100);
      
      progressFill.style.width = `${percentage}%`;
      progressText.textContent = `${percentage}% complete`;
    }
  }

  // Validate current step
  validateStep(step) {
    // Collect form data from current step
    this.collectFormData(step);
    
    // Validation logic for each step
    switch (step) {
      case 0: // Vendor selection
        if (!this.formData.vendor || !this.formData.platform) {
          alert('Please select a vendor and platform to continue.');
          return false;
        }
        break;
        
      case 1: // Authentication settings
        if (!this.formData.authMethod) {
          alert('Please select an authentication method.');
          return false;
        }
        
        if (!this.formData.radiusServer1 || !this.formData.radiusKey1) {
          alert('Please enter RADIUS server information.');
          return false;
        }
        break;
        
      case 2: // Security features
        // No required fields
        break;
    }
    
    return true;
  }

  // Collect form data from step
  collectFormData(step) {
    switch (step) {
      case 0: // Vendor selection
        // Already collected in selectVendor()
        break;
        
      case 1: // Authentication settings
        this.formData.authMethod = document.getElementById('auth-method')?.value;
        this.formData.authMode = document.querySelector('input[name="auth-mode"]:checked')?.value;
        this.formData.hostMode = document.getElementById('host-mode')?.value;
        
        this.formData.radiusServer1 = document.getElementById('radius-server-1')?.value;
        this.formData.radiusKey1 = document.getElementById('radius-key-1')?.value;
        this.formData.radiusAuthPort1 = document.getElementById('radius-auth-port-1')?.value || '1812';
        this.formData.radiusAcctPort1 = document.getElementById('radius-acct-port-1')?.value || '1813';
        
        this.formData.radiusServer2 = document.getElementById('radius-server-2')?.value;
        this.formData.radiusKey2 = document.getElementById('radius-key-2')?.value;
        
        this.formData.enableAccounting = document.getElementById('enable-accounting')?.checked;
        
        this.formData.useTacacs = document.getElementById('use-tacacs')?.checked;
        if (this.formData.useTacacs) {
          this.formData.tacacsServer1 = document.getElementById('tacacs-server-1')?.value;
          this.formData.tacacsKey1 = document.getElementById('tacacs-key-1')?.value;
          this.formData.tacacsServer2 = document.getElementById('tacacs-server-2')?.value;
          this.formData.tacacsKey2 = document.getElementById('tacacs-key-2')?.value;
        }
        break;
        
      case 2: // Security features
        this.formData.reauthPeriod = document.getElementById('reauth-period')?.value || '3600';
        this.formData.txPeriod = document.getElementById('tx-period')?.value || '30';
        this.formData.quietPeriod = document.getElementById('quiet-period')?.value || '60';
        this.formData.maxReauth = document.getElementById('max-reauth')?.value || '2';
        
        this.formData.useCoa = document.getElementById('use-coa')?.checked;
        if (this.formData.useCoa) {
          this.formData.coaPort = document.getElementById('coa-port')?.value || '3799';
        }
        
        this.formData.useRadsec = document.getElementById('use-radsec')?.checked;
        if (this.formData.useRadsec) {
          this.formData.radsecPort = document.getElementById('radsec-port')?.value || '2083';
        }
        
        this.formData.enableDhcpSnooping = document.getElementById('enable-dhcp-snooping')?.checked;
        if (this.formData.enableDhcpSnooping) {
          this.formData.dhcpSnoopingVlans = document.getElementById('dhcp-snooping-vlans')?.value || '1-4094';
          this.formData.dhcpSnoopingOption82 = document.getElementById('dhcp-snooping-option82')?.checked;
        }
        
        this.formData.enableDai = document.getElementById('enable-dai')?.checked;
        if (this.formData.enableDai) {
          this.formData.daiVlans = document.getElementById('dai-vlans')?.value || '1-4094';
        }
        
        this.formData.enableIpsg = document.getElementById('enable-ipsg')?.checked;
        
        this.formData.enableStormControl = document.getElementById('enable-storm-control')?.checked;
        if (this.formData.enableStormControl) {
          this.formData.stormControlBroadcast = document.getElementById('storm-control-broadcast')?.value || '80.00';
          this.formData.stormControlMulticast = document.getElementById('storm-control-multicast')?.value || '80.00';
          this.formData.stormControlUnicast = document.getElementById('storm-control-unicast')?.value || '80.00';
          this.formData.stormControlAction = document.getElementById('storm-control-action')?.value || 'trap';
        }
        
        this.formData.enablePortSecurity = document.getElementById('enable-port-security')?.checked;
        if (this.formData.enablePortSecurity) {
          this.formData.portSecurityMaxMac = document.getElementById('port-security-max-mac')?.value || '5';
          this.formData.portSecurityViolation = document.getElementById('port-security-violation')?.value || 'protect';
        }
        break;
        
      case 3: // Network settings
        this.formData.vlanAuth = document.getElementById('vlan-auth')?.value || '10';
        this.formData.vlanUnauth = document.getElementById('vlan-unauth')?.value || '999';
        this.formData.vlanGuest = document.getElementById('vlan-guest')?.value || '900';
        this.formData.vlanVoice = document.getElementById('vlan-voice')?.value || '100';
        
        this.formData.interface = document.getElementById('interface')?.value;
        this.formData.interfaceRange = document.getElementById('interface-range')?.value;
        
        this.formData.additionalCommands = document.getElementById('additional-commands')?.value;
        break;
    }
  }

  // Update configuration summary
  updateConfigSummary() {
    const summaryElement = document.getElementById('config-summary');
    if (!summaryElement) return;
    
    // Collect all form data
    for (let i = 0; i <= 3; i++) {
      this.collectFormData(i);
    }
    
    // Create summary HTML
    let summaryHtml = '<div class="config-summary-grid">';
    
    // Vendor & Platform
    summaryHtml += `
      <div class="summary-section">
        <h5>Vendor & Platform</h5>
        <ul>
          <li><strong>Vendor:</strong> ${this.vendorData[this.formData.vendor]?.name || this.formData.vendor}</li>
          <li><strong>Platform:</strong> ${this.formatPlatformName(this.formData.platform)}</li>
        </ul>
      </div>
    `;
    
    // Authentication Settings
    summaryHtml += `
      <div class="summary-section">
        <h5>Authentication</h5>
        <ul>
          <li><strong>Method:</strong> ${this.formatAuthMethod(this.formData.authMethod)}</li>
          <li><strong>Mode:</strong> ${this.formData.authMode === 'closed' ? 'Closed (Secure)' : 'Open (Monitor)'}</li>
          <li><strong>Host Mode:</strong> ${this.formatHostMode(this.formData.hostMode)}</li>
        </ul>
      </div>
    `;
    
    // RADIUS Server
    summaryHtml += `
      <div class="summary-section">
        <h5>RADIUS Server</h5>
        <ul>
          <li><strong>Primary:</strong> ${this.formData.radiusServer1}</li>
          ${this.formData.radiusServer2 ? `<li><strong>Secondary:</strong> ${this.formData.radiusServer2}</li>` : ''}
          <li><strong>Accounting:</strong> ${this.formData.enableAccounting ? 'Enabled' : 'Disabled'}</li>
        </ul>
      </div>
    `;
    
    // Security Features
    summaryHtml += `
      <div class="summary-section">
        <h5>Security Features</h5>
        <ul>
          <li><strong>CoA:</strong> ${this.formData.useCoa ? 'Enabled' : 'Disabled'}</li>
          <li><strong>RadSec:</strong> ${this.formData.useRadsec ? 'Enabled' : 'Disabled'}</li>
          <li><strong>DHCP Snooping:</strong> ${this.formData.enableDhcpSnooping ? 'Enabled' : 'Disabled'}</li>
          <li><strong>Dynamic ARP Inspection:</strong> ${this.formData.enableDai ? 'Enabled' : 'Disabled'}</li>
          <li><strong>IP Source Guard:</strong> ${this.formData.enableIpsg ? 'Enabled' : 'Disabled'}</li>
        </ul>
      </div>
    `;
    
    // Network Settings
    summaryHtml += `
      <div class="summary-section">
        <h5>Network Settings</h5>
        <ul>
          <li><strong>Auth VLAN:</strong> ${this.formData.vlanAuth}</li>
          <li><strong>Unauth VLAN:</strong> ${this.formData.vlanUnauth}</li>
          <li><strong>Guest VLAN:</strong> ${this.formData.vlanGuest}</li>
          ${this.formData.vlanVoice ? `<li><strong>Voice VLAN:</strong> ${this.formData.vlanVoice}</li>` : ''}
        </ul>
      </div>
    `;
    
    // TACACS+ Settings (if enabled)
    if (this.formData.useTacacs) {
      summaryHtml += `
        <div class="summary-section">
          <h5>TACACS+ Settings</h5>
          <ul>
            <li><strong>Primary:</strong> ${this.formData.tacacsServer1}</li>
            ${this.formData.tacacsServer2 ? `<li><strong>Secondary:</strong> ${this.formData.tacacsServer2}</li>` : ''}
          </ul>
        </div>
      `;
    }
    
    summaryHtml += '</div>';
    
    // Update summary element
    summaryElement.innerHTML = summaryHtml;
  }

  // Format authentication method for display
  formatAuthMethod(method) {
    switch (method) {
      case 'dot1x':
        return '802.1X Only';
      case 'mab':
        return 'MAC Authentication Bypass Only';
      case 'dot1x-mab':
        return '802.1X with MAB Fallback';
      case 'concurrent':
        return 'Concurrent 802.1X and MAB';
      default:
        return method;
    }
  }

  // Format host mode for display
  formatHostMode(mode) {
    switch (mode) {
      case 'single-host':
        return 'Single-Host (One device per port)';
      case 'multi-host':
        return 'Multi-Host (Multiple devices, single authentication)';
      case 'multi-auth':
        return 'Multi-Auth (Multiple devices, individual authentication)';
      case 'multi-domain':
        return 'Multi-Domain (Data + Voice)';
      default:
        return mode;
    }
  }

  // Generate configuration
  async generateConfiguration() {
    const configOutput = document.getElementById('config-preview');
    if (!configOutput) return;
    
    // Collect all form data
    for (let i = 0; i <= 3; i++) {
      this.collectFormData(i);
    }
    
    // Show loading message
    configOutput.textContent = 'Generating configuration...';
    
    try {
      // Load template if not already loaded
      if (!this.templates[`${this.formData.vendor}/${this.formData.platform}`]) {
        await this.loadTemplate(this.formData.vendor, this.formData.platform);
      }
      
      // Get template
      let template = this.templates[`${this.formData.vendor}/${this.formData.platform}`];
      
      // Process template with form data
      const config = this.processTemplate(template);
      
      // Display configuration
      configOutput.textContent = config;
      
    } catch (error) {
      console.error('Error generating configuration:', error);
      configOutput.textContent = `Error generating configuration: ${error.message}`;
    }
  }

  // Load template from server
  async loadTemplate(vendor, platform) {
    try {
      const templateUrl = `templates/vendors/${vendor}/${platform}.txt`;
      
      const response = await fetch(templateUrl);
      if (!response.ok) {
        // Try fallback to basic template
        const fallbackResponse = await fetch(`templates/vendors/${vendor}/basic.txt`);
        if (!fallbackResponse.ok) {
          throw new Error(`Could not load template for ${vendor}/${platform}`);
        }
        
        const template = await fallbackResponse.text();
        this.templates[`${vendor}/${platform}`] = template;
        return template;
      }
      
      const template = await response.text();
      this.templates[`${vendor}/${platform}`] = template;
      return template;
      
    } catch (error) {
      console.error('Error loading template:', error);
      throw error;
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
    const configOutput = document.getElementById('config-preview');
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
    const configOutput = document.getElementById('config-preview');
    if (!configOutput || !configOutput.textContent) {
      alert('No configuration to download. Please generate a configuration first.');
      return;
    }
    
    // Create filename based on vendor and platform
    let filename = 'config.txt';
    if (this.formData.vendor && this.formData.platform) {
      filename = `${this.formData.vendor}-${this.formData.platform}-config.txt`;
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

// Initialize the wizard when the document is ready
document.addEventListener('DOMContentLoaded', () => {
  const wizard = new VendorWizard();
  wizard.init();
});
