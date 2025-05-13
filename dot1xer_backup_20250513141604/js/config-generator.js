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
