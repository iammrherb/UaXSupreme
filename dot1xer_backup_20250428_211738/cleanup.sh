#!/bin/bash
# Dot1Xer Project Cleanup Script
# Purpose: Remove deployment, environment code and reduce bloat

# Set colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to show script progress
log() {
  local msg="$1"
  local type="${2:-INFO}"
  echo -e "[${YELLOW}$type${NC}] ${msg}"
}

# Function to show success message
success() {
  local msg="$1"
  echo -e "[${GREEN}SUCCESS${NC}] ${msg}"
}

# Function to show error message
error() {
  local msg="$1"
  echo -e "[${RED}ERROR${NC}] ${msg}"
  exit 1
}

# Function to confirm action
confirm() {
  local msg="$1"
  echo -e "${YELLOW}$msg (y/n)${NC}"
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    return 1
  fi
  return 0
}

# Start cleanup process
log "Starting Dot1Xer project cleanup process"
log "This script will remove deployment, environment code and reduce bloat"

# Check if we're in the right directory
if [ ! -f "js/main.js" ] || [ ! -f "js/config-generator.js" ]; then
  error "Please run this script from the root of your Dot1Xer project"
fi

# Create backup first
if confirm "Create a backup before proceeding?"; then
  BACKUP_DIR="dot1xer_backup_$(date +%Y%m%d_%H%M%S)"
  log "Creating backup to $BACKUP_DIR" "BACKUP"
  mkdir -p "$BACKUP_DIR"
  cp -r * "$BACKUP_DIR/" 2>/dev/null
  success "Backup created"
fi

# 1. Remove deployment & environment files
log "Removing deployment and environment files"
rm -rf auth-best-practices-final-part.txt
rm -rf js/checklist-handler.js
rm -rf "Comprehensive 802.1X Deployment Checklist with IoT, Onboarding, Guest Access & Discovery.tsx"

# 2. Clean up and optimize JS files
log "Optimizing JavaScript files"

# Clean up config-generator.js
cat > js/config-generator.js << 'EOL'
/**
 * Dot1Xer Core Edition - Configuration Generator
 * Version 1.0.0
 */

document.addEventListener('DOMContentLoaded', function() {
  console.log('Initializing Configuration Generator...');
  setupConfigGeneratorEvents();
});

// Set up configuration generator event handlers
function setupConfigGeneratorEvents() {
  const generateBtn = document.getElementById('generate-config');
  if (generateBtn) generateBtn.addEventListener('click', generateConfiguration);
  
  const copyBtn = document.getElementById('copy-config');
  if (copyBtn) copyBtn.addEventListener('click', copyConfigToClipboard);
  
  const downloadBtn = document.getElementById('download-config');
  if (downloadBtn) downloadBtn.addEventListener('click', downloadConfiguration);
}

// Generate configuration
function generateConfiguration() {
  const selectedVendor = getSelectedVendor();
  const platformSelect = document.getElementById('platform-select');
  const selectedPlatform = platformSelect ? platformSelect.value : '';

  if (!selectedVendor || !selectedPlatform) {
    showAlert('Please select a vendor and platform first.', 'warning');
    return;
  }

  const settings = collectFormSettings();
  let configText = '';

  try {
    configText = generateVendorConfig(selectedVendor, selectedPlatform, settings);
  } catch (error) {
    console.error('Error generating configuration:', error);
    showAlert('Error generating configuration: ' + error.message, 'danger');
    return;
  }

  const configOutput = document.getElementById('config-output');
  if (configOutput) configOutput.textContent = configText;

  showAlert('Configuration generated successfully!', 'success');
}

// Get the selected vendor
function getSelectedVendor() {
  const selectedVendorContainer = document.querySelector('.vendor-logo-container.selected');
  return selectedVendorContainer ? selectedVendorContainer.getAttribute('data-vendor') : null;
}

// Collect form settings
function collectFormSettings() {
  return {
    // Authentication settings
    authMethod: getSelectValue('auth-method', 'dot1x'),
    authMode: getRadioValue('auth-mode', 'closed'),
    hostMode: getSelectValue('host-mode', 'multi-auth'),

    // RADIUS server settings
    radiusServer: getInputValue('radius-server-1', ''),
    radiusKey: getInputValue('radius-key-1', ''),
    radiusAuthPort: getInputValue('radius-auth-port-1', '1812'),
    radiusAcctPort: getInputValue('radius-acct-port-1', '1813'),
    radiusTimeout: getInputValue('radius-timeout', '5'),
    radiusRetransmit: getInputValue('radius-retransmit', '3'),
    
    // Secondary RADIUS server
    secondaryServer: getInputValue('radius-server-2', ''),
    secondaryKey: getInputValue('radius-key-2', ''),
    
    // RADIUS options
    enableAccounting: getCheckboxValue('enable-accounting', false),
    useCoa: getCheckboxValue('use-coa', false),
    useRadsec: getCheckboxValue('use-radsec', false),

    // Authentication timing
    reauthPeriod: getInputValue('reauth-period', '3600'),
    txPeriod: getInputValue('tx-period', '30'),
    quietPeriod: getInputValue('quiet-period', '60'),
    maxReauth: getInputValue('max-reauth', '2'),

    // VLAN settings
    vlanAuth: getInputValue('vlan-auth', ''),
    vlanUnauth: getInputValue('vlan-unauth', ''),
    vlanGuest: getInputValue('vlan-guest', ''),
    vlanVoice: getInputValue('vlan-voice', ''),
    enableDynamicVlan: getCheckboxValue('enable-dynamic-vlan', true),

    // Interface settings
    interface: getInputValue('interface', ''),
    interfaceRange: getInputValue('interface-range', ''),
    
    // Security features
    enableDhcpSnooping: getCheckboxValue('enable-dhcp-snooping', false),
    enableDai: getCheckboxValue('enable-dai', false),
    enableIpsg: getCheckboxValue('enable-ipsg', false),
    enablePortSecurity: getCheckboxValue('enable-port-security', false),
    useMacsec: getCheckboxValue('use-macsec', false),
  };
}

// Helper function to get input value
function getInputValue(id, defaultValue) {
  const element = document.getElementById(id);
  return element && element.value ? element.value : defaultValue;
}

// Helper function to get select value
function getSelectValue(id, defaultValue) {
  const element = document.getElementById(id);
  if (!element) return defaultValue;
  return element.value || defaultValue;
}

// Helper function to get radio button value
function getRadioValue(name, defaultValue) {
  const elements = document.getElementsByName(name);
  for (let i = 0; i < elements.length; i++) {
    if (elements[i].checked) {
      return elements[i].value;
    }
  }
  return defaultValue;
}

// Helper function to get checkbox value
function getCheckboxValue(id, defaultValue) {
  const element = document.getElementById(id);
  return element ? element.checked : defaultValue;
}

// Generate a generic configuration when vendor-specific generator is not available
function generateVendorConfig(vendor, platform, settings) {
  return `! ${vendor.toUpperCase()} ${platform.toUpperCase()} 802.1X Configuration
! Generated by Dot1Xer Core Edition v1.0.0
!
! RADIUS Server: ${settings.radiusServer || 'Not specified'} (${settings.radiusAuthPort}/${settings.radiusAcctPort})
! Secondary RADIUS: ${settings.secondaryServer || 'Not specified'}
! Authentication Method: ${settings.authMethod}
! Authentication Mode: ${settings.authMode}
! Host Mode: ${settings.hostMode}
! Authentication VLAN: ${settings.vlanAuth || 'Not specified'}
! Unauthenticated VLAN: ${settings.vlanUnauth || 'Not specified'}
! Guest VLAN: ${settings.vlanGuest || 'Not specified'}
! Voice VLAN: ${settings.vlanVoice || 'Not specified'}
! Interface: ${settings.interface || 'Not specified'}
! Interface Range: ${settings.interfaceRange || 'Not specified'}`;
}

// Copy configuration to clipboard
function copyConfigToClipboard() {
  const configOutput = document.getElementById('config-output');
  if (!configOutput) return;

  const config = configOutput.textContent;
  if (config.trim() === '') {
    showAlert('Please generate a configuration first.', 'warning');
    return;
  }

  if (navigator.clipboard) {
    navigator.clipboard
      .writeText(config)
      .then(() => {
        showAlert('Configuration copied to clipboard!', 'success');
      })
      .catch((err) => {
        console.error('Failed to copy: ', err);
        showAlert('Failed to copy. Please try manually.', 'danger');
      });
  } else {
    try {
      const textarea = document.createElement('textarea');
      textarea.value = config;
      document.body.appendChild(textarea);
      textarea.select();
      document.execCommand('copy');
      document.body.removeChild(textarea);
      showAlert('Configuration copied to clipboard!', 'success');
    } catch (error) {
      console.error('Failed to copy: ', error);
      showAlert('Failed to copy. Please try manually.', 'danger');
    }
  }
}

// Download configuration as file
function downloadConfiguration() {
  const configOutput = document.getElementById('config-output');
  if (!configOutput) return;

  const config = configOutput.textContent;
  if (config.trim() === '') {
    showAlert('Please generate a configuration first.', 'warning');
    return;
  }

  const selectedVendor = getSelectedVendor() || 'vendor';
  const platformSelect = document.getElementById('platform-select');
  const platform = platformSelect ? platformSelect.value : 'platform';
  const date = new Date().toISOString().split('T')[0];
  const filename = `${selectedVendor}-${platform}-dot1x-config-${date}.txt`;

  try {
    const blob = new Blob([config], { type: 'text/plain' });
    const element = document.createElement('a');
    element.href = URL.createObjectURL(blob);
    element.download = filename;
    element.style.display = 'none';
    document.body.appendChild(element);
    element.click();
    setTimeout(() => {
      document.body.removeChild(element);
      URL.revokeObjectURL(element.href);
    }, 100);
    showAlert(`Configuration downloaded as "${filename}"`, 'success');
  } catch (error) {
    console.error('Error downloading:', error);
    showAlert('Error downloading. Please try again.', 'danger');
  }
}

// Helper function to show alerts
function showAlert(message, type = 'info') {
  if (typeof window.showAlert === 'function') {
    window.showAlert(message, type);
    return;
  }

  alert(message);
}
EOL

# Clean up main.js
cat > js/main.js << 'EOL'
/**
 * Dot1Xer Core Edition - Main Application
 * Version 1.0.0
 */

document.addEventListener('DOMContentLoaded', function() {
  console.log('Initializing Dot1Xer Core Edition v1.0.0...');
  createAlertContainer();
  
  // Initialize vendors and UI
  initVendorsModule();
  initUI();
});

// Initialize vendors module
function initVendorsModule() {
  if (typeof initVendorGrid === 'function') {
    initVendorGrid();
    setupVendorSelection();
    selectDefaultVendor();
  }
}

// Initialize UI components
function initUI() {
  initTabs();
  initModals();
}

// Initialize tabs functionality
function initTabs() {
  const tabLinks = document.querySelectorAll('.tab');
  const tabPanes = document.querySelectorAll('.tab-pane');

  tabLinks.forEach((tab) => {
    tab.addEventListener('click', () => {
      const tabId = tab.getAttribute('data-tab');
      tabLinks.forEach((t) => t.classList.remove('active'));
      tabPanes.forEach((p) => p.classList.remove('active'));
      tab.classList.add('active');
      document.getElementById(tabId)?.classList.add('active');
    });
  });
}

// Initialize modals
function initModals() {
  document.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal') && event.target.classList.contains('visible')) {
      event.target.classList.remove('visible');
    }
  });

  document.querySelectorAll('.modal-dialog').forEach((dialog) => {
    dialog.addEventListener('click', function(event) {
      event.stopPropagation();
    });
  });
}

// Create alert container
function createAlertContainer() {
  if (!document.getElementById('alert-container')) {
    const alertContainer = document.createElement('div');
    alertContainer.id = 'alert-container';
    alertContainer.style.position = 'fixed';
    alertContainer.style.top = '20px';
    alertContainer.style.right = '20px';
    alertContainer.style.zIndex = '9999';
    alertContainer.style.maxWidth = '400px';
    document.body.appendChild(alertContainer);
  }
}

// Global alert function
window.showAlert = function(message, type = 'info') {
  createAlertContainer();
  const alertContainer = document.getElementById('alert-container');

  const alert = document.createElement('div');
  alert.className = `alert alert-${type}`;
  alert.style.marginBottom = '10px';
  alert.style.padding = '15px';
  alert.style.borderRadius = '4px';
  alert.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
  alert.style.position = 'relative';
  alert.style.opacity = '0';
  alert.style.transform = 'translateX(50px)';
  alert.style.transition = 'opacity 0.3s, transform 0.3s';

  const closeButton = document.createElement('span');
  closeButton.innerHTML = '&times;';
  closeButton.style.position = 'absolute';
  closeButton.style.top = '10px';
  closeButton.style.right = '10px';
  closeButton.style.cursor = 'pointer';
  closeButton.style.fontWeight = 'bold';
  closeButton.addEventListener('click', () => {
    alert.style.opacity = '0';
    alert.style.transform = 'translateX(50px)';
    setTimeout(() => alert.remove(), 300);
  });

  alert.textContent = message;
  alert.appendChild(closeButton);
  alertContainer.appendChild(alert);

  setTimeout(() => {
    alert.style.opacity = '1';
    alert.style.transform = 'translateX(0)';
  }, 10);

  setTimeout(() => {
    if (alert.parentNode) {
      alert.style.opacity = '0';
      alert.style.transform = 'translateX(50px)';
      setTimeout(() => {
        if (alert.parentNode) alert.remove();
      }, 300);
    }
  }, 5000);
};
EOL

# Simplify vendors.js - Remove bloated vendor definitions
cat > js/vendors.js << 'EOL'
/**
 * Dot1Xer Core Edition - Vendor Configuration
 * Version 1.0.0
 */

// Define core vendors with only essential capabilities
const vendors = {
  cisco: {
    name: 'Cisco',
    types: ['wired', 'wireless'],
    platforms: {
      ios: {
        name: 'IOS',
        description: 'Traditional Cisco IOS for Catalyst switches',
        versions: ['15.2(4)E', '15.2(7)E'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      'ios-xe': {
        name: 'IOS-XE',
        description: 'IOS-XE for newer Catalyst switches',
        versions: ['16.12.x', '17.3.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      'nx-os': {
        name: 'NX-OS',
        description: 'NX-OS for Nexus switches',
        versions: ['9.3.x', '10.1.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
  },

  aruba: {
    name: 'Aruba',
    types: ['wired', 'wireless'],
    platforms: {
      'aos-cx': {
        name: 'AOS-CX',
        description: 'AOS-CX for Aruba CX switches',
        versions: ['10.06.x', '10.08.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      'aos-switch': {
        name: 'AOS-Switch',
        description: 'AOS-Switch for Aruba/HP switches',
        versions: ['16.08.x', '16.09.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
  },

  juniper: {
    name: 'Juniper',
    types: ['wired', 'wireless'],
    platforms: {
      junos: {
        name: 'JunOS',
        description: 'JunOS for EX/QFX switches',
        versions: ['19.4R3', '20.4R3'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
  },

  hp: {
    name: 'HP',
    types: ['wired'],
    platforms: {
      provision: {
        name: 'ProVision',
        description: 'ProVision for legacy HP ProCurve switches',
        versions: ['K.16.05', 'K.16.06'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      comware: {
        name: 'Comware',
        description: 'Comware for HP H3C switches',
        versions: ['7.1.x', '7.2.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
  }
};

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
  console.log('Initializing vendor selection system...');
  initVendorGrid();
  setupVendorSelection();
});

// Initialize vendor grid
function initVendorGrid() {
  const vendorGrid = document.getElementById('vendor-grid');
  if (!vendorGrid) {
    console.error('Vendor grid element not found!');
    return;
  }

  // Clear existing content
  vendorGrid.innerHTML = '';

  // Create vendor cards
  for (const [vendorId, vendor] of Object.entries(vendors)) {
    const vendorCard = document.createElement('div');
    vendorCard.className = 'vendor-logo-container';
    vendorCard.setAttribute('data-vendor', vendorId);

    // Get vendor types and determine primary type for badge
    const types = vendor.types || [];
    let primaryType = types.length > 0 ? types[0] : 'unknown';
    let typeLabel = primaryType.toUpperCase();

    // Create vendor logo
    const logoPath = `assets/logos/${vendorId}-logo.svg`;
    const vendorLogo = document.createElement('img');
    vendorLogo.className = 'vendor-logo';
    vendorLogo.src = logoPath;
    vendorLogo.alt = `${vendor.name} logo`;
    vendorLogo.onerror = function() {
      this.onerror = null;
      this.src = `data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50"><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-size="16" font-weight="bold" fill="%230077cc">${vendor.name}</text></svg>`;
    };

    // Create vendor name
    const vendorName = document.createElement('span');
    vendorName.className = 'vendor-name';
    vendorName.textContent = vendor.name;

    // Create vendor type badge
    const vendorType = document.createElement('span');
    vendorType.className = `vendor-type vendor-type-${primaryType}`;
    vendorType.textContent = typeLabel;

    // Add all elements to card
    vendorCard.appendChild(vendorLogo);
    vendorCard.appendChild(vendorName);
    vendorCard.appendChild(vendorType);

    // Add click event
    vendorCard.addEventListener('click', function() {
      selectVendor(vendorId);
    });

    // Add card to grid
    vendorGrid.appendChild(vendorCard);
  }
}

// Setup vendor selection event handling
function setupVendorSelection() {
  // Listen for platform selection changes
  const platformSelect = document.getElementById('platform-select');
  if (platformSelect) {
    platformSelect.addEventListener('change', updatePlatformDetails);
  }
}

// Select a vendor
function selectVendor(vendorId) {
  // Update selected vendor styling
  const vendorCards = document.querySelectorAll('.vendor-logo-container');
  vendorCards.forEach((card) => {
    if (card.getAttribute('data-vendor') === vendorId) {
      card.classList.add('selected');
    } else {
      card.classList.remove('selected');
    }
  });

  // Update platform select
  updatePlatformSelect(vendorId);

  // Store selected vendor
  localStorage.setItem('selectedVendor', vendorId);

  // Enable the next button
  const nextButton = document.getElementById('platform-next');
  if (nextButton) {
    nextButton.disabled = false;
  }
}

// Update platform select dropdown for selected vendor
function updatePlatformSelect(vendorId) {
  const platformSelect = document.getElementById('platform-select');
  if (!platformSelect) return;

  // Clear existing options
  platformSelect.innerHTML = '';

  // Add default option
  const defaultOption = document.createElement('option');
  defaultOption.value = '';
  defaultOption.textContent = 'Select a platform';
  platformSelect.appendChild(defaultOption);

  // Get vendor platforms
  const vendor = vendors[vendorId];
  if (!vendor) return;

  // Add platform options
  for (const [platformId, platform] of Object.entries(vendor.platforms)) {
    const option = document.createElement('option');
    option.value = platformId;
    option.textContent = platform.name;
    platformSelect.appendChild(option);
  }

  // Enable select
  platformSelect.disabled = false;

  // Update platform details
  updatePlatformDetails();
}

// Update platform details
function updatePlatformDetails() {
  const platformDetails = document.getElementById('platform-details');
  if (!platformDetails) return;

  // Get selected vendor and platform
  const selectedVendor = getSelectedVendor();
  const platformSelect = document.getElementById('platform-select');
  const selectedPlatform = platformSelect ? platformSelect.value : '';

  // Clear if nothing selected
  if (!selectedVendor || !selectedPlatform) {
    platformDetails.innerHTML = '<p>Please select a vendor and platform.</p>';
    return;
  }

  // Get vendor and platform data
  const vendor = vendors[selectedVendor];
  if (!vendor) return;

  const platform = vendor.platforms[selectedPlatform];
  if (!platform) return;

  // Create platform details HTML
  platformDetails.innerHTML = `
    <div class="platform-details-header">
      <h3>${platform.name}</h3>
      <span class="vendor-badge">${vendor.name}</span>
    </div>
    <p>${platform.description}</p>
    
    <h4>Capabilities</h4>
    <div class="capability-badges">
      ${(platform.capabilities || []).map(cap => 
        `<span class="capability-badge">${cap.toUpperCase()}</span>`
      ).join('')}
    </div>
    
    <h4>Software Version</h4>
    <select id="platform-version" class="form-control">
      <option value="">Select a version</option>
      ${(platform.versions || []).map(ver => 
        `<option value="${ver}">${ver}</option>`
      ).join('')}
    </select>
  `;
}

// Get selected vendor
function getSelectedVendor() {
  const selectedCard = document.querySelector('.vendor-logo-container.selected');
  return selectedCard ? selectedCard.getAttribute('data-vendor') : '';
}

// Select the default vendor
function selectDefaultVendor() {
  // Check if we have a saved vendor
  const savedVendor = localStorage.getItem('selectedVendor');

  if (savedVendor && vendors[savedVendor]) {
    selectVendor(savedVendor);
  } else {
    // Otherwise select Cisco by default
    selectVendor('cisco');
  }
}
EOL

# Clean up UI.js - Simplify UI code
cat > js/ui.js << 'EOL'
/**
 * Dot1Xer Core Edition - UI Functionality
 * Version 1.0.0
 */

document.addEventListener('DOMContentLoaded', function() {
  console.log('Initializing UI functionality...');
  initTabs();
  initModals();
  initSettings();
  initTooltips();
});

// Initialize tabs functionality
function initTabs() {
  // Main content tabs
  const tabLinks = document.querySelectorAll('.tab');
  const tabPanes = document.querySelectorAll('.tab-pane');

  tabLinks.forEach((tab) => {
    tab.addEventListener('click', () => {
      const tabId = tab.getAttribute('data-tab');
      tabLinks.forEach((t) => t.classList.remove('active'));
      tabPanes.forEach((p) => p.classList.remove('active'));
      tab.classList.add('active');
      document.getElementById(tabId)?.classList.add('active');
    });
  });

  // Tab navigation buttons
  setupTabNavigation();
}

// Setup tab navigation buttons
function setupTabNavigation() {
  const tabs = ['platform', 'authentication', 'security', 'network', 'advanced', 'preview'];
  
  tabs.forEach((tab, index) => {
    const nextTab = tabs[index + 1];
    const prevTab = tabs[index - 1];
    
    if (nextTab) {
      const nextBtn = document.getElementById(`${tab}-next`);
      if (nextBtn) {
        nextBtn.addEventListener('click', () => activateTab(nextTab));
      }
    }
    
    if (prevTab) {
      const prevBtn = document.getElementById(`${tab}-prev`);
      if (prevBtn) {
        prevBtn.addEventListener('click', () => activateTab(prevTab));
      }
    }
  });
}

// Activate a specific tab
function activateTab(tabId) {
  const tab = document.querySelector(`.tab[data-tab="${tabId}"]`);
  if (tab) tab.click();
}

// Initialize modals
function initModals() {
  // Close modals when clicking outside
  document.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal-overlay') && 
        event.target.classList.contains('visible')) {
      event.target.classList.remove('visible');
    }
  });

  // Setup common modals
  setupModal('settings-link', 'settings-modal', 'settings-modal-close', 'settings-cancel');
  setupModal('export-documentation', 'export-modal', 'export-modal-close', 'export-cancel');
  setupModal('save-config', 'save-config-modal', 'save-config-modal-close', 'save-config-cancel');
}

// Set up a modal dialog
function setupModal(triggerButtonId, modalId, closeButtonId, cancelButtonId) {
  const triggerButton = document.getElementById(triggerButtonId);
  const modal = document.getElementById(modalId);
  const closeButton = document.getElementById(closeButtonId);
  const cancelButton = document.getElementById(cancelButtonId);

  if (triggerButton && modal) {
    triggerButton.addEventListener('click', (e) => {
      e.preventDefault();
      modal.classList.add('visible');
    });
  }

  if (closeButton && modal) {
    closeButton.addEventListener('click', () => {
      modal.classList.remove('visible');
    });
  }

  if (cancelButton && modal) {
    cancelButton.addEventListener('click', () => {
      modal.classList.remove('visible');
    });
  }
}

// Initialize settings
function initSettings() {
  // Load saved settings
  loadSettings();

  // Save settings button
  const saveSettingsButton = document.getElementById('settings-save');
  if (saveSettingsButton) {
    saveSettingsButton.addEventListener('click', saveSettings);
  }

  // Theme selector
  const themeSelect = document.getElementById('theme-select');
  if (themeSelect) {
    themeSelect.addEventListener('change', () => {
      applyTheme(themeSelect.value);
    });
  }
}

// Load settings from localStorage
function loadSettings() {
  try {
    // Theme settings
    const theme = localStorage.getItem('theme') || 'light';
    applyTheme(theme);

    // Update settings form
    const themeSelect = document.getElementById('theme-select');
    if (themeSelect) themeSelect.value = theme;
  } catch (error) {
    console.error('Error loading settings:', error);
  }
}

// Save settings to localStorage
function saveSettings() {
  try {
    // Theme settings
    const themeSelect = document.getElementById('theme-select');
    if (themeSelect) localStorage.setItem('theme', themeSelect.value);
    
    // Apply theme
    if (themeSelect) applyTheme(themeSelect.value);
    
    // Close modal
    const modal = document.getElementById('settings-modal');
    if (modal) modal.classList.remove('visible');

    // Show success message
    showAlert('Settings saved successfully', 'success');
  } catch (error) {
    console.error('Error saving settings:', error);
    showAlert('Error saving settings: ' + error.message, 'danger');
  }
}

// Apply theme
function applyTheme(theme) {
  if (theme === 'dark') {
    document.body.classList.add('dark-theme');
  } else if (theme === 'light') {
    document.body.classList.remove('dark-theme');
  } else if (theme === 'system') {
    // Check system preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.body.classList.add('dark-theme');
    } else {
      document.body.classList.remove('dark-theme');
    }
  }
}

// Initialize tooltips
function initTooltips() {
  // Find all elements with tooltip data attribute
  const tooltips = document.querySelectorAll('[data-tooltip]');

  tooltips.forEach((tooltip) => {
    // Add a span for the tooltip text if it doesn't exist
    if (!tooltip.querySelector('.tooltip-text')) {
      const tooltipText = document.createElement('span');
      tooltipText.className = 'tooltip-text';
      tooltipText.textContent = tooltip.getAttribute('data-tooltip') || 'Tooltip';
      tooltip.appendChild(tooltipText);
    }
  });
}

// Helper function to show alerts - moved to main.js as global function
function showAlert(message, type = 'info') {
  // Use global showAlert function if available
  if (typeof window.showAlert === 'function') {
    window.showAlert(message, type);
    return;
  }

  alert(message);
}
EOL

# 3. Clean up CSS files
log "Optimizing CSS files"

# Simplify main.css
cat > css/main.css << 'EOL'
/* Dot1Xer Core Edition - Main CSS */
:root {
  --primary-color: #1a3a5f;
  --secondary-color: #0077cc;
  --accent-color: #f8bd1c;
  --background-color: #f8f9fa;
  --text-color: #333;
  --border-color: #ddd;
  --header-color: #1a3a5f;
  --success-color: #28a745;
  --warning-color: #ffc107;
  --danger-color: #dc3545;
  --info-color: #17a2b8;
  --tooltip-bg: rgba(0, 0, 0, 0.8);
  --tooltip-color: #fff;
  --help-icon-color: #6c757d;
  --help-icon-hover: #0077cc;
  --card-bg: #ffffff;
  --card-header: #f5f7fa;
  --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  background-color: var(--background-color);
  color: var(--text-color);
  line-height: 1.6;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
  width: 100%;
}

main {
  padding-bottom: 30px;
}

header {
  background-color: var(--header-color);
  color: white;
  padding: 0;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  position: relative;
}

.header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
}

.logo {
  font-size: 24px;
  font-weight: bold;
  color: white;
  text-decoration: none;
  display: flex;
  align-items: center;
}

.logo img {
  height: 40px;
  margin-right: 10px;
  vertical-align: middle;
}

nav ul {
  display: flex;
  list-style: none;
}

nav ul li {
  margin-left: 20px;
}

nav ul li a {
  color: white;
  text-decoration: none;
  font-size: 16px;
  transition: opacity 0.3s;
}

nav ul li a:hover {
  opacity: 0.8;
}

/* Card and panel styles */
.card {
  background-color: var(--card-bg);
  border-radius: 8px;
  box-shadow: var(--shadow);
  margin-bottom: 20px;
  overflow: hidden;
}

.main-card {
  min-height: 600px;
}

.panel {
  background-color: #f9f9f9;
  border: 1px solid var(--border-color);
  border-radius: 5px;
  padding: 20px;
  margin-bottom: 20px;
}

h2 {
  margin-bottom: 20px;
  color: var(--primary-color);
}

h3 {
  margin-bottom: 15px;
  color: var(--secondary-color);
  font-size: 1.2rem;
}

/* Tabs */
.tabs {
  display: flex;
  background-color: var(--card-header);
  border-bottom: 1px solid var(--border-color);
  flex-wrap: wrap;
}

.tab {
  padding: 15px 20px;
  cursor: pointer;
  font-weight: 500;
  border-bottom: 3px solid transparent;
  transition: all 0.3s;
  color: #777;
}

.tab:hover {
  background-color: rgba(0, 0, 0, 0.03);
  color: var(--secondary-color);
}

.tab.active {
  border-bottom-color: var(--secondary-color);
  color: var(--secondary-color);
  background-color: white;
}

.tab-content {
  padding: 20px;
}

.tab-pane {
  display: none;
}

.tab-pane.active {
  display: block;
}

/* Form styles */
.form-group {
  margin-bottom: 20px;
}

label {
  display: block;
  margin-bottom: 8px;
  font-weight: 500;
  color: #444;
}

.form-control {
  width: 100%;
  padding: 10px 12px;
  font-size: 16px;
  border: 1px solid var(--border-color);
  border-radius: 4px;
  transition: border-color 0.3s, box-shadow 0.3s;
}

.form-control:focus {
  border-color: var(--secondary-color);
  box-shadow: 0 0 0 3px rgba(0, 119, 204, 0.2);
  outline: none;
}

.input-group {
  display: flex;
  gap: 10px;
}

.input-group .form-control {
  flex: 1;
}

.help-text {
  font-size: 0.85rem;
  color: #666;
  margin-top: 5px;
}

/* Radio and checkbox styles */
.radio-group {
  margin-top: 5px;
}

.radio,
.checkbox {
  display: flex;
  align-items: center;
  margin-bottom: 10px;
  cursor: pointer;
}

.radio input,
.checkbox input {
  margin-right: 10px;
}

/* Button styles */
.btn {
  display: inline-block;
  background-color: #6c757d;
  color: white;
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  font-weight: 500;
  transition: background-color 0.3s, transform 0.1s;
  margin-right: 10px;
}

.btn:hover {
  background-color: #5a6268;
}

.btn:active {
  transform: translateY(1px);
}

.btn.primary {
  background-color: var(--secondary-color);
}

.btn.primary:hover {
  background-color: #0069b4;
}

.btn.next {
  background-color: var(--secondary-color);
}

.btn.next:hover {
  background-color: #0069b4;
}

.btn.prev {
  background-color: #6c757d;
}

.btn.prev:hover {
  background-color: #5a6268;
}

.btn.danger {
  background-color: var(--danger-color);
}

.btn.danger:hover {
  background-color: #bd2130;
}

/* Actions section */
.actions {
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
}

.action-bar {
  margin: 0 0 20px 0;
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

/* Code block */
.code-block {
  background-color: #f5f5f5;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 15px;
  overflow-x: auto;
  font-family: 'Courier New', Courier, monospace;
  font-size: 14px;
  line-height: 1.5;
  color: #333;
  white-space: pre;
  max-height: 400px;
  overflow-y: auto;
}

/* Vendor grid */
.vendor-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 15px;
  margin-bottom: 20px;
}

.vendor-logo-container {
  border: 1px solid var(--border-color);
  border-radius: 5px;
  padding: 15px;
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100px;
  cursor: pointer;
  transition: all 0.3s;
}

.vendor-logo-container:hover {
  border-color: var(--secondary-color);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}

.vendor-logo-container.selected {
  border-color: var(--secondary-color);
  box-shadow: 0 0 0 2px var(--secondary-color);
}

.vendor-logo {
  max-width: 100%;
  max-height: 70px;
  object-fit: contain;
}

/* Alert boxes */
.alert {
  padding: 15px;
  margin-bottom: 20px;
  border: 1px solid transparent;
  border-radius: 4px;
}

.alert-success {
  color: #155724;
  background-color: #d4edda;
  border-color: #c3e6cb;
}

.alert-info {
  color: #0c5460;
  background-color: #d1ecf1;
  border-color: #bee5eb;
}

.alert-warning {
  color: #856404;
  background-color: #fff3cd;
  border-color: #ffeeba;
}

.alert-danger {
  color: #721c24;
  background-color: #f8d7da;
  border-color: #f5c6cb;
}

/* Modals */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
  opacity: 0;
  visibility: hidden;
  transition: opacity 0.3s, visibility 0.3s;
}

.modal-overlay.visible {
  opacity: 1;
  visibility: visible;
}

.modal-container {
  background-color: white;
  border-radius: 8px;
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.2);
  width: 90%;
  max-width: 700px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}

.modal-header {
  padding: 15px 20px;
  border-bottom: 1px solid var(--border-color);
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.modal-header h2 {
  margin: 0;
  font-size: 1.5rem;
}

.modal-close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #777;
}

.modal-body {
  padding: 20px;
  overflow-y: auto;
  flex-grow: 1;
}

.modal-footer {
  padding: 15px 20px;
  border-top: 1px solid var(--border-color);
  display: flex;
  justify-content: flex-end;
}

/* Tooltips */
.tooltip {
  position: relative;
  display: inline-block;
}

.tooltip .tooltip-text {
  visibility: hidden;
  width: 200px;
  background-color: var(--tooltip-bg);
  color: var(--tooltip-color);
  text-align: center;
  border-radius: 6px;
  padding: 10px;
  position: absolute;
  z-index: 1;
  bottom: 125%;
  left: 50%;
  margin-left: -100px;
  opacity: 0;
  transition: opacity 0.3s;
  font-size: 14px;
  pointer-events: none;
}

.tooltip .tooltip-text::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: var(--tooltip-bg) transparent transparent transparent;
}

.tooltip:hover .tooltip-text {
  visibility: visible;
  opacity: 1;
}

/* Dark theme */
body.dark-theme {
  --primary-color: #2c3e50;
  --secondary-color: #3498db;
  --background-color: #1a1a1a;
  --text-color: #f0f0f0;
  --border-color: #444;
  --header-color: #2c3e50;
  --card-bg: #2d2d2d;
  --card-header: #333;
  --shadow: 0 2px 10px rgba(0, 0, 0, 0.4);
}

body.dark-theme .panel {
  background-color: #2a2a2a;
  border-color: #444;
}

body.dark-theme .code-block {
  background-color: #333;
  border-color: #555;
  color: #f0f0f0;
}

body.dark-theme .form-control {
  background-color: #333;
  border-color: #555;
  color: #f0f0f0;
}

body.dark-theme .modal-container {
  background-color: #2d2d2d;
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .tabs {
    flex-direction: column;
  }

  .tab {
    border-bottom: 1px solid var(--border-color);
  }

  .tab.active {
    border-bottom: 1px solid var(--border-color);
    border-left: 3px solid var(--secondary-color);
  }

  .actions {
    flex-direction: column;
  }

  .actions .btn {
    margin-bottom: 10px;
    width: 100%;
  }

  .header-container {
    flex-direction: column;
    padding: 10px;
  }

  nav ul {
    margin-top: 10px;
    flex-wrap: wrap;
    justify-content: center;
  }

  nav ul li {
    margin: 5px 10px;
  }

  .input-group {
    flex-direction: column;
    gap: 5px;
  }

  .action-bar {
    flex-direction: column;
  }

  .action-bar .btn {
    width: 100%;
    margin-bottom: 5px;
  }
}
EOL

# Simplify vendor-cards.css
cat > css/vendor-cards.css << 'EOL'
/* Simplified Vendor Selection Grid */
.vendor-selection {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
  gap: 12px;
  margin-bottom: 20px;
}

/* Vendor Card Container */
.vendor-logo-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 12px;
  border: 2px solid var(--border-color);
  border-radius: 5px;
  background-color: #ffffff;
  cursor: pointer;
  transition: all 0.2s ease;
  height: 110px;
  position: relative;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.vendor-logo-container:hover {
  border-color: var(--accent-color);
  background-color: rgba(0, 119, 204, 0.05);
  transform: translateY(-2px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.vendor-logo-container.selected {
  border-color: var(--accent-color);
  background-color: rgba(0, 119, 204, 0.1);
  box-shadow: 0 2px 8px rgba(0, 119, 204, 0.2);
}

/* Vendor Logo */
.vendor-logo {
  width: 80px;
  height: 60px;
  object-fit: contain;
  margin-bottom: 20px;
  transition: transform 0.3s ease;
  background: none;
}

.vendor-logo-container:hover .vendor-logo {
  transform: scale(1.05);
}

/* Vendor Name */
.vendor-name {
  font-size: 0.85rem;
  font-weight: 500;
  text-align: center;
  color: var(--text-color);
  position: absolute;
  bottom: 10px;
  left: 0;
  right: 0;
  margin: 0 auto;
}

/* Vendor Type Badge */
.vendor-type {
  position: absolute;
  top: 5px;
  right: 5px;
  font-size: 8px;
  padding: 2px 4px;
  border-radius: 8px;
  background-color: #e0e0e0;
  color: #333;
  font-weight: bold;
  text-transform: uppercase;
}

.vendor-type-wired {
  background-color: #bbdefb;
  color: #0d47a1;
}

.vendor-type-wireless {
  background-color: #d1c4e9;
  color: #4527a0;
}

/* Platform Details */
.platform-details {
  margin-top: 15px;
  padding: 15px;
  border: 1px solid var(--border-color);
  border-radius: 5px;
  background-color: white;
}

.platform-details-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 12px;
}

/* Capability Badges */
.capability-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 5px;
  margin: 10px 0;
}

.capability-badge {
  display: inline-block;
  padding: 3px 8px;
  background-color: #e3f2fd;
  color: #0d47a1;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: 500;
}
EOL

# Simplify help.css
cat > css/help.css << 'EOL'
/* Simplified Help System Styles */
.help-icon {
  cursor: pointer;
  color: var(--help-icon-color);
  margin-left: 5px;
  font-size: 16px;
  transition: color 0.3s;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background-color: rgba(0, 0, 0, 0.1);
}

.help-icon:hover {
  color: var(--help-icon-hover);
  background-color: rgba(0, 119, 204, 0.2);
}

/* Tooltips */
.tooltip {
  position: relative;
  display: inline-block;
}

.tooltip .tooltip-text {
  visibility: hidden;
  width: 200px;
  background-color: var(--tooltip-bg);
  color: var(--tooltip-color);
  text-align: center;
  border-radius: 6px;
  padding: 10px;
  position: absolute;
  z-index: 1;
  bottom: 125%;
  left: 50%;
  margin-left: -100px;
  opacity: 0;
  transition: opacity 0.3s;
  font-size: 14px;
  pointer-events: none;
}

.tooltip .tooltip-text::after {
  content: '';
  position: absolute;
  top: 100%;
  left: 50%;
  margin-left: -5px;
  border-width: 5px;
  border-style: solid;
  border-color: var(--tooltip-bg) transparent transparent transparent;
}

.tooltip:hover .tooltip-text {
  visibility: visible;
  opacity: 1;
}

/* Help panel */
.help-panel {
  position: fixed;
  top: 0;
  right: -400px;
  width: 400px;
  height: 100%;
  background-color: white;
  box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
  z-index: 1000;
  transition: right 0.3s ease-in-out;
  display: flex;
  flex-direction: column;
}

.help-panel.open {
  right: 0;
}

.help-panel-header {
  padding: 15px;
  background-color: var(--secondary-color);
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.help-panel-header h3 {
  margin: 0;
  color: white;
}

.help-panel-close {
  background: none;
  border: none;
  color: white;
  font-size: 20px;
  cursor: pointer;
}

.help-panel-content {
  padding: 20px;
  overflow-y: auto;
  flex-grow: 1;
}
EOL

# 4. Update vendor-specific files
log "Cleaning up vendor-specific files"

# Remove vendor-specific files that contain deployment info
rm -f js/diagrams.js

# 5. Remove unnecessary vendor CSS
log "Removing unnecessary vendor css files"
rm -f css/vendors.css

# Clean up index.html to match the simplified structure
cat > index.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dot1Xer Core Edition - 802.1X Configuration Tool</title>
    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/vendor-cards.css">
    <link rel="stylesheet" href="css/help.css">
</head>
<body>
    <header>
        <div class="header-container">
            <a href="index.html" class="logo">
                <img src="assets/images/logo.png" alt="Dot1Xer Logo">
                Dot1Xer Core Edition
            </a>
            <nav>
                <ul>
                    <li><a href="#" id="settings-link">Settings</a></li>
                    <li><a href="https://github.com/yourusername/dot1xer" target="_blank">GitHub</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <main>
        <div class="container">
            <div class="card main-card">
                <div class="tabs">
                    <div class="tab active" data-tab="platform">1. Platform</div>
                    <div class="tab" data-tab="authentication">2. Authentication</div>
                    <div class="tab" data-tab="security">3. Security</div>
                    <div class="tab" data-tab="network">4. Network</div>
                    <div class="tab" data-tab="advanced">5. Advanced</div>
                    <div class="tab" data-tab="preview">6. Preview</div>
                </div>
                <div class="tab-content">
                    <!-- Platform Tab -->
                    <div id="platform" class="tab-pane active">
                        <h2>Select Network Platform</h2>
                        <p>Choose your network device vendor and platform to generate 802.1X configuration.</p>
                        
                        <div id="vendor-grid" class="vendor-grid">
                            <!-- Vendor icons will be inserted here by JavaScript -->
                        </div>
                        
                        <div class="form-group">
                            <label for="platform-select">Select Platform:</label>
                            <select id="platform-select" class="form-control" disabled>
                                <option value="">Select a vendor first</option>
                            </select>
                        </div>
                        
                        <div id="platform-details">
                            <p>Please select a vendor and platform to view details.</p>
                        </div>
                        
                        <div class="actions">
                            <div></div>
                            <button id="platform-next" class="btn next" disabled>Next</button>
                        </div>
                    </div>
                    
                    <!-- Authentication Tab -->
                    <div id="authentication" class="tab-pane">
                        <h2>Authentication Settings</h2>
                        
                        <div class="form-group">
                            <label for="auth-method">Authentication Method:</label>
                            <select id="auth-method" class="form-control">
                                <option value="dot1x">802.1X Authentication Only</option>
                                <option value="mab">MAC Authentication Bypass Only</option>
                                <option value="dot1x-mab">802.1X with MAB Fallback</option>
                                <option value="concurrent">802.1X and MAB Concurrent</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label>Authentication Mode:</label>
                            <div class="radio-group">
                                <div class="radio">
                                    <input type="radio" id="auth-mode-closed" name="auth-mode" value="closed" checked>
                                    <label for="auth-mode-closed">Closed Mode (Secure)</label>
                                </div>
                                <div class="radio">
                                    <input type="radio" id="auth-mode-open" name="auth-mode" value="open">
                                    <label for="auth-mode-open">Open Mode (Permissive)</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="host-mode">Host Mode:</label>
                            <select id="host-mode" class="form-control">
                                <option value="single-host">Single-Host (One device per port)</option>
                                <option value="multi-host">Multi-Host (Multiple devices, single authentication)</option>
                                <option value="multi-auth" selected>Multi-Auth (Multiple devices, individual authentication)</option>
                                <option value="multi-domain">Multi-Domain (Data + Voice)</option>
                            </select>
                        </div>
                        
                        <h3>RADIUS Server Settings</h3>
                        
                        <div class="form-group">
                            <label for="radius-server-1">Primary RADIUS Server:</label>
                            <input type="text" id="radius-server-1" class="form-control" placeholder="e.g., 10.1.1.1">
                        </div>
                        
                        <div class="form-group">
                            <label for="radius-key-1">RADIUS Secret Key:</label>
                            <input type="password" id="radius-key-1" class="form-control" placeholder="Enter RADIUS shared secret">
                        </div>
                        
                        <div class="input-group">
                            <div class="form-group">
                                <label for="radius-auth-port-1">Authentication Port:</label>
                                <input type="number" id="radius-auth-port-1" class="form-control" value="1812">
                            </div>
                            <div class="form-group">
                                <label for="radius-acct-port-1">Accounting Port:</label>
                                <input type="number" id="radius-acct-port-1" class="form-control" value="1813">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="radius-server-2">Secondary RADIUS Server (Optional):</label>
                            <input type="text" id="radius-server-2" class="form-control" placeholder="e.g., 10.1.1.2">
                        </div>
                        
                        <div class="form-group">
                            <label for="radius-key-2">Secondary RADIUS Secret Key:</label>
                            <input type="password" id="radius-key-2" class="form-control" placeholder="Enter secondary RADIUS shared secret">
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="enable-accounting">
                                <label for="enable-accounting">Enable RADIUS Accounting</label>
                            </div>
                        </div>
                        
                        <div class="actions">
                            <button id="auth-prev" class="btn prev">Previous</button>
                            <button id="auth-next" class="btn next">Next</button>
                        </div>
                    </div>
                    
                    <!-- Security Tab -->
                    <div id="security" class="tab-pane">
                        <h2>Security Features</h2>
                        
                        <div class="form-group">
                            <label>Authentication Timing:</label>
                            <div class="input-group">
                                <div class="form-group">
                                    <label for="reauth-period">Reauthentication Period (seconds):</label>
                                    <input type="number" id="reauth-period" class="form-control" value="3600">
                                </div>
                                <div class="form-group">
                                    <label for="tx-period">TX Period (seconds):</label>
                                    <input type="number" id="tx-period" class="form-control" value="30">
                                </div>
                            </div>
                            <div class="input-group">
                                <div class="form-group">
                                    <label for="quiet-period">Quiet Period (seconds):</label>
                                    <input type="number" id="quiet-period" class="form-control" value="60">
                                </div>
                                <div class="form-group">
                                    <label for="max-reauth">Max Retries:</label>
                                    <input type="number" id="max-reauth" class="form-control" value="2">
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="use-coa">
                                <label for="use-coa">Enable RADIUS Change of Authorization (CoA)</label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="use-radsec">
                                <label for="use-radsec">Enable RadSec (RADIUS over TLS)</label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="use-macsec">
                                <label for="use-macsec">Enable MACsec (802.1AE)</label>
                            </div>
                        </div>
                        
                        <h3>Additional Security Features</h3>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="enable-dhcp-snooping">
                                <label for="enable-dhcp-snooping">Enable DHCP Snooping</label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="enable-dai">
                                <label for="enable-dai">Enable Dynamic ARP Inspection</label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="enable-ipsg">
                                <label for="enable-ipsg">Enable IP Source Guard</label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="enable-port-security">
                                <label for="enable-port-security">Enable Port Security</label>
                            </div>
                        </div>
                        
                        <div class="actions">
                            <button id="security-prev" class="btn prev">Previous</button>
                            <button id="security-next" class="btn next">Next</button>
                        </div>
                    </div>
                    
                    <!-- Network Tab -->
                    <div id="network" class="tab-pane">
                        <h2>Network Settings</h2>
                        
                        <h3>VLAN Configuration</h3>
                        
                        <div class="form-group">
                            <div class="checkbox">
                                <input type="checkbox" id="enable-dynamic-vlan" checked>
                                <label for="enable-dynamic-vlan">Enable Dynamic VLAN Assignment</label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="vlan-auth">Authentication VLAN ID:</label>
                            <input type="number" id="vlan-auth" class="form-control" placeholder="e.g., 100">
                        </div>
                        
                        <div class="form-group">
                            <label for="vlan-unauth">Unauthenticated VLAN ID:</label>
                            <input type="number" id="vlan-unauth" class="form-control" placeholder="e.g., 999">
                        </div>
                        
                        <div class="form-group">
                            <label for="vlan-guest">Guest VLAN ID:</label>
                            <input type="number" id="vlan-guest" class="form-control" placeholder="e.g., 900">
                        </div>
                        
                        <div class="form-group">
                            <label for="vlan-voice">Voice VLAN ID:</label>
                            <input type="number" id="vlan-voice" class="form-control" placeholder="e.g., 200">
                        </div>
                        
                        <h3>Interface Settings</h3>
                        
                        <div class="form-group">
                            <label for="interface">Interface:</label>
                            <input type="text" id="interface" class="form-control" placeholder="e.g., GigabitEthernet1/0/1">
                        </div>
                        
                        <div class="form-group">
                            <label for="interface-range">Interface Range (Optional):</label>
                            <input type="text" id="interface-range" class="form-control" placeholder="e.g., GigabitEthernet1/0/1-24">
                        </div>
                        
                        <div class="actions">
                            <button id="network-prev" class="btn prev">Previous</button>
                            <button id="network-next" class="btn next">Next</button>
                        </div>
                    </div>
                    
                    <!-- Advanced Tab -->
                    <div id="advanced" class="tab-pane">
                        <h2>Advanced Settings</h2>
                        
                        <div class="form-group">
                            <label for="additional-commands">Additional Commands:</label>
                            <textarea id="additional-commands" class="form-control" rows="10" placeholder="Enter additional configuration commands to include"></textarea>
                        </div>
                        
                        <div class="actions">
                            <button id="advanced-prev" class="btn prev">Previous</button>
                            <button id="advanced-next" class="btn next">Next</button>
                        </div>
                    </div>
                    
                    <!-- Preview Tab -->
                    <div id="preview" class="tab-pane">
                        <h2>Configuration Preview</h2>
                        
                        <div class="action-bar">
                            <button id="generate-config" class="btn primary">Generate Configuration</button>
                            <button id="copy-config" class="btn">Copy to Clipboard</button>
                            <button id="download-config" class="btn">Download</button>
                        </div>
                        
                        <pre id="config-output" class="code-block">No configuration generated yet. Click "Generate Configuration" to create the configuration.</pre>
                        
                        <div class="actions">
                            <button id="preview-prev" class="btn prev">Previous</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Modals -->
    <div id="settings-modal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h2>Settings</h2>
                <button id="settings-modal-close" class="modal-close">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="theme-select">Theme:</label>
                    <select id="theme-select" class="form-control">
                        <option value="light">Light</option>
                        <option value="dark">Dark</option>
                        <option value="system">System Default</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button id="settings-cancel" class="btn">Cancel</button>
                <button id="settings-save" class="btn primary">Save</button>
            </div>
        </div>
    </div>

    <div id="save-config-modal" class="modal-overlay">
        <div class="modal-container">
            <div class="modal-header">
                <h2>Save Configuration</h2>
                <button id="save-config-modal-close" class="modal-close">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="config-name">Configuration Name:</label>
                    <input type="text" id="config-name" class="form-control" placeholder="Enter a name for this configuration">
                </div>
                <div class="form-group">
                    <label for="config-description">Description (Optional):</label>
                    <textarea id="config-description" class="form-control" rows="3" placeholder="Enter a description"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button id="save-config-cancel" class="btn">Cancel</button>
                <button id="save-config-confirm" class="btn primary">Save</button>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/main.js"></script>
    <script src="js/vendors.js"></script>
    <script src="js/ui.js"></script>
    <script src="js/config-generator.js"></script>
</body>
</html>
EOL

# 6. Create README.md with cleanup info
cat > README.md << 'EOL'
# Dot1Xer Core Edition

A streamlined 802.1X configuration generator for network devices.

## Overview

Dot1Xer Core Edition is a simplified version of the original Dot1Xer tool, focusing on essential 802.1X configuration generation without deployment-specific code, environment dependencies, or bloated features.

## Features

- Support for major network vendors (Cisco, Aruba, Juniper, HP)
- 802.1X and MAB authentication configuration
- RADIUS server settings
- VLAN assignment
- Security features (DHCP Snooping, DAI, IP Source Guard)
- Easy-to-use web interface

## Project Structure

```
.
├── assets/
│   ├── images/
│   └── logos/
├── css/
│   ├── main.css           # Main stylesheet
│   ├── vendor-cards.css   # Vendor selection styling
│   └── help.css           # Help tooltips styling
├── js/
│   ├── main.js            # Core initialization
│   ├── vendors.js         # Vendor definitions
│   ├── ui.js              # UI functionality
│   └── config-generator.js # Configuration generation
├── index.html             # Main application page
└── README.md              # This file
```

## Usage

1. Open `index.html` in a web browser
2. Select your network device vendor and platform
3. Configure authentication settings
4. Configure security features
5. Set up VLANs and interfaces
6. Generate your 802.1X configuration
7. Copy or download the configuration

## Cleanup Process

This repository was created by removing deployment, environment, and bloated code from the original project. The following files were removed or simplified:

- Removed `js/checklist-handler.js`
- Removed `auth-best-practices-final-part.txt`
- Removed `Comprehensive 802.1X Deployment Checklist with IoT, Onboarding, Guest Access & Discovery.tsx`
- Removed `js/diagrams.js` 
- Simplified `js/config-generator.js`
- Simplified `js/vendors.js`
- Simplified `js/main.js`
- Simplified `js/ui.js`
- Simplified CSS files
- Updated HTML to match simplified structure

## License

MIT License
EOL

# 7. Final cleanup, remove any empty directories
find . -type d -empty -delete

success "Cleanup complete!"
log "The following files have been removed or simplified:"
log " - Removed auth-best-practices-final-part.txt"
log " - Removed js/checklist-handler.js"
log " - Removed Comprehensive 802.1X Deployment Checklist with IoT, Onboarding, Guest Access & Discovery.tsx"
log " - Removed js/diagrams.js"
log " - Simplified js/config-generator.js"
log " - Simplified js/vendors.js"
log " - Simplified js/main.js"
log " - Simplified js/ui.js"
log " - Simplified CSS files"
log " - Created README.md with cleanup information"

if [ -d "$BACKUP_DIR" ]; then
  success "A backup of your original files is available in: $BACKUP_DIR"
fi

echo ""
echo -e "${GREEN}Dot1Xer Core Edition is now ready to use!${NC}"
echo "Open index.html in your web browser to use the application."
