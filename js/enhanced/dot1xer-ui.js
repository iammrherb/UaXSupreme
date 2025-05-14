// Enhanced Dot1Xer UI JavaScript

// Vendor data with comprehensive support information
const vendorData = {
  cisco: {
    name: "Cisco",
    platforms: ["IOS", "IOS-XE", "NX-OS", "WLC 9800"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "TACACS+", "RADIUS", "RadSec", "CoA", "Device Tracking", "Guest Access", "Dynamic ACLs", "MACsec"],
    description: "Comprehensive authentication templates for Cisco switches, routers, and wireless controllers."
  },
  aruba: {
    name: "Aruba",
    platforms: ["AOS-CX", "AOS-Switch", "Mobility Controller"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "TACACS+", "RADIUS", "ClearPass", "CoA", "Dynamic Role Assignment", "Guest Access"],
    description: "Authentication solutions for Aruba wired and wireless products."
  },
  juniper: {
    name: "Juniper",
    platforms: ["JunOS", "Mist"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "TACACS+", "RADIUS", "Guest Access", "Dynamic VLAN", "CoA", "Security Policies"],
    description: "Authentication configurations for Juniper Networks devices."
  },
  hp: {
    name: "HP",
    platforms: ["ProCurve", "Aruba Switch"],
    types: ["wired"],
    capabilities: ["802.1X", "MAB", "RADIUS", "CoA", "User Roles", "Device Profiling"],
    description: "Authentication templates for HP ProCurve and legacy Aruba switches."
  },
  fortinet: {
    name: "Fortinet",
    platforms: ["FortiSwitch", "FortiGate"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "RADIUS", "FortiAuthenticator", "User Identity", "Device Control"],
    description: "Authentication configurations for Fortinet security fabric."
  },
  extreme: {
    name: "Extreme",
    platforms: ["EXOS", "VOSS"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "RADIUS", "Policy-Based Routing", "Network Access Control"],
    description: "Authentication templates for Extreme Networks switches and wireless."
  },
  dell: {
    name: "Dell",
    platforms: ["PowerSwitch", "Force10"],
    types: ["wired"],
    capabilities: ["802.1X", "MAB", "RADIUS", "Guest VLAN", "Authentication VLAN"],
    description: "Authentication configurations for Dell enterprise switches."
  },
  arista: {
    name: "Arista",
    platforms: ["EOS"],
    types: ["wired"],
    capabilities: ["802.1X", "MAB", "RADIUS", "TACACS+", "CoA", "Fallback Authentication"],
    description: "Authentication templates for Arista data center switches."
  },
  ubiquiti: {
    name: "Ubiquiti",
    platforms: ["UniFi"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "RADIUS", "Guest Networks", "User Groups"],
    description: "Authentication configurations for Ubiquiti UniFi products."
  },
  paloalto: {
    name: "Palo Alto",
    platforms: ["PAN-OS"],
    types: ["wired"],
    capabilities: ["802.1X", "RADIUS", "TACACS+", "User-ID", "Security Policies"],
    description: "Authentication templates for Palo Alto security appliances."
  },
  checkpoint: {
    name: "Check Point",
    platforms: ["Gaia"],
    types: ["wired"],
    capabilities: ["RADIUS", "TACACS+", "Identity Awareness", "Security Policies"],
    description: "Authentication configurations for Check Point security appliances."
  },
  ruckus: {
    name: "Ruckus",
    platforms: ["SmartZone", "ICX"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "RADIUS", "Dynamic VLAN", "Guest Access"],
    description: "Authentication templates for Ruckus switches and wireless."
  },
  meraki: {
    name: "Meraki",
    platforms: ["Dashboard"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "RADIUS", "Group Policies", "Guest Access"],
    description: "Authentication configurations for Cisco Meraki cloud managed devices."
  },
  sonicwall: {
    name: "SonicWall",
    platforms: ["SonicOS"],
    types: ["wired"],
    capabilities: ["RADIUS", "TACACS+", "User Groups", "Security Policies"],
    description: "Authentication templates for SonicWall security appliances."
  },
  huawei: {
    name: "Huawei",
    platforms: ["VRP"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAC Authentication", "RADIUS", "Portal Authentication"],
    description: "Authentication configurations for Huawei enterprise products."
  }
};

// Initialize enhanced UI when document is ready
document.addEventListener('DOMContentLoaded', function() {
  // Initialize vendor grid with enhanced cards
  initVendorGrid();
  
  // Set up event listeners
  setupEventListeners();
  
  // Initialize platform selector
  initPlatformSelector();
  
  // Add dark mode support
  setupDarkMode();
});

// Initialize vendor grid with all available vendors
function initVendorGrid() {
  const vendorGrid = document.getElementById('vendor-grid');
  if (!vendorGrid) return;
  
  // Clear existing content
  vendorGrid.innerHTML = '';
  
  // Create vendor cards
  Object.keys(vendorData).forEach(vendorKey => {
    const vendor = vendorData[vendorKey];
    const card = createVendorCard(vendorKey, vendor);
    vendorGrid.appendChild(card);
  });
}

// Create a vendor card element
function createVendorCard(vendorKey, vendor) {
  const card = document.createElement('div');
  card.className = 'vendor-card';
  card.dataset.vendor = vendorKey;
  
  // Create vendor type badge
  const typeClass = getVendorTypeClass(vendor.types);
  const typeLabel = getVendorTypeLabel(vendor.types);
  
  // Create card content
  card.innerHTML = `
    <div class="vendor-type ${typeClass}">${typeLabel}</div>
    <img src="assets/images/vendors/${vendorKey}.png" alt="${vendor.name}" class="vendor-logo">
    <div class="vendor-name">${vendor.name}</div>
  `;
  
  // Add click event
  card.addEventListener('click', function() {
    selectVendor(vendorKey);
  });
  
  return card;
}

// Get CSS class for vendor type badge
function getVendorTypeClass(types) {
  if (types.includes('wired') && types.includes('wireless')) {
    return 'both';
  } else if (types.includes('wired')) {
    return 'wired';
  } else {
    return 'wireless';
  }
}

// Get label for vendor type badge
function getVendorTypeLabel(types) {
  if (types.includes('wired') && types.includes('wireless')) {
    return 'Wired & Wireless';
  } else if (types.includes('wired')) {
    return 'Wired';
  } else {
    return 'Wireless';
  }
}

// Handle vendor selection
function selectVendor(vendorKey) {
  // Update selected card styling
  document.querySelectorAll('.vendor-card').forEach(card => {
    card.classList.remove('selected');
  });
  
  const selectedCard = document.querySelector(`.vendor-card[data-vendor="${vendorKey}"]`);
  if (selectedCard) {
    selectedCard.classList.add('selected');
  }
  
  // Populate platform dropdown
  populatePlatformDropdown(vendorKey);
  
  // Update platform details
  updatePlatformDetails(vendorKey);
  
  // Enable next button
  const platformNext = document.getElementById('platform-next');
  if (platformNext) {
    platformNext.disabled = false;
  }
  
  // Save selection in localStorage
  localStorage.setItem('selectedVendor', vendorKey);
}

// Populate platform dropdown based on selected vendor
function populatePlatformDropdown(vendorKey) {
  const platformSelect = document.getElementById('platform-select');
  if (!platformSelect) return;
  
  // Clear existing options
  platformSelect.innerHTML = '';
  
  // Get platforms for selected vendor
  const vendor = vendorData[vendorKey];
  if (!vendor) return;
  
  // Create default option
  const defaultOption = document.createElement('option');
  defaultOption.value = '';
  defaultOption.textContent = 'Select a platform';
  platformSelect.appendChild(defaultOption);
  
  // Add platform options
  vendor.platforms.forEach(platform => {
    const option = document.createElement('option');
    option.value = platform.toLowerCase().replace(/\s+/g, '-');
    option.textContent = platform;
    platformSelect.appendChild(option);
  });
  
  // Enable the select
  platformSelect.disabled = false;
  
  // Add change event
  platformSelect.addEventListener('change', function() {
    updatePlatformDetails(vendorKey, this.value);
  });
}

// Update platform details section
function updatePlatformDetails(vendorKey, platformKey = null) {
  const platformDetails = document.getElementById('platform-details');
  if (!platformDetails) return;
  
  const vendor = vendorData[vendorKey];
  if (!vendor) return;
  
  // If no platform selected, show vendor overview
  if (!platformKey || platformKey === '') {
    platformDetails.innerHTML = `
      <div class="platform-box">
        <div class="platform-header">
          <div class="platform-info">
            <div class="platform-icon">
              <i class="fa fa-network-wired"></i>
            </div>
            <div>
              <h3 class="platform-title">${vendor.name}</h3>
              <span class="vendor-badge">${getVendorTypeLabel(vendor.types)}</span>
            </div>
          </div>
        </div>
        <p class="platform-description">${vendor.description}</p>
        <div class="capability-label">Supported Features</div>
        <div class="capability-badges">
          ${vendor.capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
        </div>
        <p>Select a platform from the dropdown above to see specific configuration options.</p>
      </div>
    `;
    return;
  }
  
  // Show platform-specific details
  const platformName = vendor.platforms.find(p => p.toLowerCase().replace(/\s+/g, '-') === platformKey);
  
  platformDetails.innerHTML = `
    <div class="platform-box">
      <div class="platform-header">
        <div class="platform-info">
          <div class="platform-icon">
            <i class="fa fa-server"></i>
          </div>
          <div>
            <h3 class="platform-title">${vendor.name} ${platformName}</h3>
            <span class="vendor-badge">${getVendorTypeLabel(vendor.types)}</span>
          </div>
        </div>
      </div>
      <p class="platform-description">
        Configure advanced authentication settings for ${vendor.name} ${platformName} devices including 802.1X, MAB, TACACS+, and more.
      </p>
      <div class="capability-label">Supported Features</div>
      <div class="capability-badges">
        ${vendor.capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
      </div>
      <div class="tabs">
        <div class="tab-nav">
          <div class="tab-item active" data-tab="overview">Overview</div>
          <div class="tab-item" data-tab="capabilities">Capabilities</div>
          <div class="tab-item" data-tab="requirements">Requirements</div>
        </div>
        <div class="tab-content">
          <p>This platform supports comprehensive authentication configuration including 802.1X, MAB, RADIUS, and more. Continue to the Authentication tab to configure these settings.</p>
        </div>
      </div>
    </div>
  `;
  
  // Set up tab navigation
  setupTabNavigation();
}

// Setup tab navigation in platform details
function setupTabNavigation() {
  const tabItems = document.querySelectorAll('.tab-item');
  
  tabItems.forEach(tab => {
    tab.addEventListener('click', function() {
      // Remove active class from all tabs
      tabItems.forEach(t => t.classList.remove('active'));
      
      // Add active class to clicked tab
      this.classList.add('active');
      
      // Update content (simplified for this example)
      const tabContent = document.querySelector('.tab-content');
      const tabName = this.dataset.tab;
      
      if (tabName === 'overview') {
        tabContent.innerHTML = '<p>This platform supports comprehensive authentication configuration including 802.1X, MAB, RADIUS, and more. Continue to the Authentication tab to configure these settings.</p>';
      } else if (tabName === 'capabilities') {
        tabContent.innerHTML = `
          <ul>
            <li><strong>802.1X Authentication:</strong> Support for standard-based port authentication</li>
            <li><strong>MAC Authentication Bypass (MAB):</strong> For legacy devices</li>
            <li><strong>Multi-Domain Authentication:</strong> Separate authentication for voice and data</li>
            <li><strong>Guest VLAN:</strong> For unauthenticated clients</li>
            <li><strong>RADIUS CoA:</strong> Dynamic policy changes post-authentication</li>
            <li><strong>TACACS+:</strong> For device administration</li>
          </ul>
        `;
      } else if (tabName === 'requirements') {
        tabContent.innerHTML = `
          <ul>
            <li><strong>RADIUS Server:</strong> Required for 802.1X and MAB authentication</li>
            <li><strong>Supplicant Software:</strong> Required on endpoints for 802.1X</li>
            <li><strong>VLAN Configuration:</strong> Separate VLANs for authenticated and guest access</li>
            <li><strong>Software Version:</strong> Latest recommended for full feature support</li>
          </ul>
        `;
      }
    });
  });
}

// Setup dark mode support
function setupDarkMode() {
  const storedTheme = localStorage.getItem('theme') || 'light';
  if (storedTheme === 'dark') {
    document.body.classList.add('dark-theme');
  }
  
  // Check for theme toggle button
  const themeToggle = document.getElementById('theme-toggle');
  if (themeToggle) {
    themeToggle.addEventListener('click', function() {
      document.body.classList.toggle('dark-theme');
      const isDark = document.body.classList.contains('dark-theme');
      localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });
  }
}

// Setup event listeners
function setupEventListeners() {
  // Platform next button
  const platformNext = document.getElementById('platform-next');
  if (platformNext) {
    platformNext.addEventListener('click', function() {
      // Navigate to authentication tab
      const authTab = document.querySelector('.tab[data-tab="authentication"]');
      if (authTab) {
        document.querySelectorAll('.tab').forEach(tab => {
          tab.classList.remove('active');
        });
        authTab.classList.add('active');
        
        document.querySelectorAll('.tab-pane').forEach(pane => {
          pane.classList.remove('active');
        });
        document.getElementById('authentication').classList.add('active');
      }
    });
  }
  
  // Authentication tab controls
  const authPrev = document.getElementById('auth-prev');
  if (authPrev) {
    authPrev.addEventListener('click', function() {
      navigateTab('platform');
    });
  }
  
  const authNext = document.getElementById('auth-next');
  if (authNext) {
    authNext.addEventListener('click', function() {
      navigateTab('security');
    });
  }
  
  // Security tab controls
  const securityPrev = document.getElementById('security-prev');
  if (securityPrev) {
    securityPrev.addEventListener('click', function() {
      navigateTab('authentication');
    });
  }
  
  const securityNext = document.getElementById('security-next');
  if (securityNext) {
    securityNext.addEventListener('click', function() {
      navigateTab('network');
    });
  }
  
  // Network tab controls
  const networkPrev = document.getElementById('network-prev');
  if (networkPrev) {
    networkPrev.addEventListener('click', function() {
      navigateTab('security');
    });
  }
  
  const networkNext = document.getElementById('network-next');
  if (networkNext) {
    networkNext.addEventListener('click', function() {
      navigateTab('advanced');
    });
  }
  
  // Advanced tab controls
  const advancedPrev = document.getElementById('advanced-prev');
  if (advancedPrev) {
    advancedPrev.addEventListener('click', function() {
      navigateTab('network');
    });
  }
  
  const advancedNext = document.getElementById('advanced-next');
  if (advancedNext) {
    advancedNext.addEventListener('click', function() {
      navigateTab('preview');
    });
  }
  
  // Preview tab controls
  const previewPrev = document.getElementById('preview-prev');
  if (previewPrev) {
    previewPrev.addEventListener('click', function() {
      navigateTab('advanced');
    });
  }
  
  // Generate configuration button
  const generateConfig = document.getElementById('generate-config');
  if (generateConfig) {
    generateConfig.addEventListener('click', function() {
      generateConfiguration();
    });
  }
  
  // Copy configuration button
  const copyConfig = document.getElementById('copy-config');
  if (copyConfig) {
    copyConfig.addEventListener('click', function() {
      copyToClipboard();
    });
  }
  
  // Download configuration button
  const downloadConfig = document.getElementById('download-config');
  if (downloadConfig) {
    downloadConfig.addEventListener('click', function() {
      downloadConfiguration();
    });
  }
}

// Initialize platform selector
function initPlatformSelector() {
  // Try to restore previous selection
  const savedVendor = localStorage.getItem('selectedVendor');
  if (savedVendor && vendorData[savedVendor]) {
    selectVendor(savedVendor);
  }
}

// Navigate to a specific tab
function navigateTab(tabId) {
  // Activate tab
  document.querySelectorAll('.tab').forEach(tab => {
    tab.classList.remove('active');
  });
  document.querySelector(`.tab[data-tab="${tabId}"]`).classList.add('active');
  
  // Show tab content
  document.querySelectorAll('.tab-pane').forEach(pane => {
    pane.classList.remove('active');
  });
  document.getElementById(tabId).classList.add('active');
}

// Generate configuration based on user inputs
function generateConfiguration() {
  // Get selected vendor and platform
  const vendorKey = localStorage.getItem('selectedVendor');
  const platformSelect = document.getElementById('platform-select');
  const platformKey = platformSelect ? platformSelect.value : null;
  
  if (!vendorKey || !platformKey) {
    alert('Please select a vendor and platform first.');
    return;
  }
  
  // Gather form data
  const formData = gatherFormData();
  
  // Generate configuration template
  const config = generateTemplate(vendorKey, platformKey, formData);
  
  // Display in output area
  const configOutput = document.getElementById('config-output');
  if (configOutput) {
    configOutput.textContent = config;
  }
}

// Gather form data from all tabs
function gatherFormData() {
  return {
    // Authentication tab
    authMethod: document.getElementById('auth-method').value,
    authMode: document.querySelector('input[name="auth-mode"]:checked').value,
    hostMode: document.getElementById('host-mode').value,
    radiusServer1: document.getElementById('radius-server-1').value,
    radiusKey1: document.getElementById('radius-key-1').value,
    radiusAuthPort1: document.getElementById('radius-auth-port-1').value,
    radiusAcctPort1: document.getElementById('radius-acct-port-1').value,
    radiusServer2: document.getElementById('radius-server-2').value,
    radiusKey2: document.getElementById('radius-key-2').value,
    enableAccounting: document.getElementById('enable-accounting').checked,
    
    // Security tab
    reauthPeriod: document.getElementById('reauth-period').value,
    txPeriod: document.getElementById('tx-period').value,
    quietPeriod: document.getElementById('quiet-period').value,
    maxReauth: document.getElementById('max-reauth').value,
    useCoa: document.getElementById('use-coa').checked,
    useRadsec: document.getElementById('use-radsec').checked,
    useMacsec: document.getElementById('use-macsec').checked,
    enableDhcpSnooping: document.getElementById('enable-dhcp-snooping').checked,
    enableDai: document.getElementById('enable-dai').checked,
    enableIpsg: document.getElementById('enable-ipsg').checked,
    enablePortSecurity: document.getElementById('enable-port-security').checked,
    
    // Network tab
    enableDynamicVlan: document.getElementById('enable-dynamic-vlan').checked,
    vlanAuth: document.getElementById('vlan-auth').value,
    vlanUnauth: document.getElementById('vlan-unauth').value,
    vlanGuest: document.getElementById('vlan-guest').value,
    vlanVoice: document.getElementById('vlan-voice').value,
    interface: document.getElementById('interface').value,
    interfaceRange: document.getElementById('interface-range').value,
    
    // Advanced tab
    additionalCommands: document.getElementById('additional-commands').value
  };
}

// Generate configuration template based on vendor, platform and form data
function generateTemplate(vendorKey, platformKey, formData) {
  // Placeholder for actual template generation logic
  let config = `! ${vendorData[vendorKey].name} ${platformKey.replace(/-/g, ' ').toUpperCase()} Configuration\n`;
  config += `! Generated by Dot1Xer Enhanced Edition\n`;
  config += `! Date: ${new Date().toISOString().split('T')[0]}\n\n`;
  
  // Add authentication configuration
  config += `! Authentication Configuration\n`;
  config += `! Method: ${formData.authMethod}\n`;
  config += `! Mode: ${formData.authMode}\n`;
  config += `! Host Mode: ${formData.hostMode}\n\n`;
  
  // Add RADIUS server configuration
  config += `! RADIUS Server Configuration\n`;
  config += `radius-server host ${formData.radiusServer1} key ${formData.radiusKey1}\n`;
  if (formData.radiusServer2) {
    config += `radius-server host ${formData.radiusServer2} key ${formData.radiusKey2}\n`;
  }
  
  // Add 802.1X configuration
  config += `\n! 802.1X Configuration\n`;
  config += `dot1x system-auth-control\n`;
  
  // Add interface configuration
  config += `\n! Interface Configuration\n`;
  config += `interface ${formData.interface}\n`;
  config += `  switchport mode access\n`;
  config += `  switchport access vlan ${formData.vlanAuth}\n`;
  if (formData.vlanVoice) {
    config += `  switchport voice vlan ${formData.vlanVoice}\n`;
  }
  config += `  dot1x port-control ${formData.authMode === 'closed' ? 'auto' : 'force-authorized'}\n`;
  config += `  dot1x host-mode ${formData.hostMode}\n`;
  
  // Add additional commands if provided
  if (formData.additionalCommands) {
    config += `\n! Additional Commands\n${formData.additionalCommands}\n`;
  }
  
  return config;
}

// Copy configuration to clipboard
function copyToClipboard() {
  const configOutput = document.getElementById('config-output');
  if (!configOutput || !configOutput.textContent.trim()) {
    alert('Please generate a configuration first.');
    return;
  }
  
  // Create temporary textarea
  const textarea = document.createElement('textarea');
  textarea.value = configOutput.textContent;
  document.body.appendChild(textarea);
  
  // Select and copy
  textarea.select();
  document.execCommand('copy');
  
  // Clean up
  document.body.removeChild(textarea);
  
  // Show feedback
  alert('Configuration copied to clipboard!');
}

// Download configuration as a text file
function downloadConfiguration() {
  const configOutput = document.getElementById('config-output');
  if (!configOutput || !configOutput.textContent.trim()) {
    alert('Please generate a configuration first.');
    return;
  }
  
  // Get vendor and platform info
  const vendorKey = localStorage.getItem('selectedVendor');
  const platformSelect = document.getElementById('platform-select');
  const platformKey = platformSelect ? platformSelect.value : 'config';
  
  // Create filename
  const filename = `${vendorKey}-${platformKey}-config.txt`;
  
  // Create download link
  const element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(configOutput.textContent));
  element.setAttribute('download', filename);
  
  // Simulate click and clean up
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
}
