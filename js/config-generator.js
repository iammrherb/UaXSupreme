/**
 * Dot1Xer Supreme Enterprise Edition - Configuration Generator
 * Version 4.1.0
 * 
 * This module handles the generation of network device configurations
 * for 802.1X deployment across multiple vendor platforms.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Configuration Generator...');
    
    // Set up event handlers
    setupConfigGeneratorEvents();
    
    // Set up conditional display for advanced settings sections
    setupConditionalDisplay();
});

// Initialize event handlers for configuration generation
function setupConfigGeneratorEvents() {
    const generateButton = document.getElementById('generate-config');
    const copyButton = document.getElementById('copy-config');
    const downloadButton = document.getElementById('download-config');
    const analyzeButton = document.getElementById('analyze-config');
    const optimizeButton = document.getElementById('optimize-config');
    const saveButton = document.getElementById('save-config');
    
    if (generateButton) {
        generateButton.addEventListener('click', generateConfiguration);
    }
    
    if (copyButton) {
        copyButton.addEventListener('click', copyConfigToClipboard);
    }
    
    if (downloadButton) {
        downloadButton.addEventListener('click', downloadConfiguration);
    }
    
    if (analyzeButton) {
        analyzeButton.addEventListener('click', analyzeConfiguration);
    }
    
    if (optimizeButton) {
        optimizeButton.addEventListener('click', optimizeConfiguration);
    }
    
    if (saveButton) {
        saveButton.addEventListener('click', showSaveConfigModal);
    }
    
    // Save Config Modal Handlers
    const saveConfigConfirm = document.getElementById('save-config-confirm');
    const saveConfigCancel = document.getElementById('save-config-cancel');
    const saveConfigModalClose = document.getElementById('save-config-modal-close');
    
    if (saveConfigConfirm) {
        saveConfigConfirm.addEventListener('click', saveConfiguration);
    }
    
    if (saveConfigCancel) {
        saveConfigCancel.addEventListener('click', () => {
            const modal = document.getElementById('save-config-modal');
            if (modal) modal.classList.remove('visible');
        });
    }
    
    if (saveConfigModalClose) {
        saveConfigModalClose.addEventListener('click', () => {
            const modal = document.getElementById('save-config-modal');
            if (modal) modal.classList.remove('visible');
        });
    }
}

// Setup conditional display for advanced settings sections
function setupConditionalDisplay() {
    // Enable/disable nested settings based on checkbox state
    setupCheckboxToggle('use-coa', 'coa-settings');
    setupCheckboxToggle('enable-accounting', 'accounting-settings');
    setupCheckboxToggle('use-radsec', 'radsec-settings');
    setupCheckboxToggle('use-macsec', 'macsec-settings');
    setupCheckboxToggle('enable-dhcp-snooping', 'dhcp-snooping-settings');
    setupCheckboxToggle('enable-dai', 'dai-settings');
    setupCheckboxToggle('enable-storm-control', 'storm-control-settings');
    setupCheckboxToggle('enable-port-security', 'port-security-settings');
    setupCheckboxToggle('enable-device-tracking', 'device-tracking-settings');
    setupCheckboxToggle('enable-acl', 'acl-settings');
    setupCheckboxToggle('use-tacacs', 'tacacs-settings');
    setupCheckboxToggle('apply-industry-templates', 'industry-settings');
    
    // Setup expandable sections
    const expandableHeaders = document.querySelectorAll('.expandable-header');
    expandableHeaders.forEach(header => {
        header.addEventListener('click', () => {
            header.classList.toggle('expanded');
            const content = header.nextElementSibling;
            if (content && content.classList.contains('expandable-content')) {
                content.classList.toggle('expanded');
            }
        });
    });
}

// Setup checkbox toggle for nested settings
function setupCheckboxToggle(checkboxId, targetId) {
    const checkbox = document.getElementById(checkboxId);
    const target = document.getElementById(targetId);
    
    if (checkbox && target) {
        // Set initial state
        target.style.display = checkbox.checked ? 'block' : 'none';
        
        // Add change listener
        checkbox.addEventListener('change', () => {
            target.style.display = checkbox.checked ? 'block' : 'none';
        });
    }
}

// Generate configuration based on user input
function generateConfiguration() {
    console.log('Generating configuration...');
    
    // Get selected vendor and platform
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    let selectedVendor = null;
    
    vendorContainers.forEach(container => {
        if (container.classList.contains('selected')) {
            selectedVendor = container.getAttribute('data-vendor');
        }
    });
    
    const platformSelect = document.getElementById('platform-select');
    const platform = platformSelect ? platformSelect.value : '';
    
    if (!selectedVendor || !platform) {
        showAlert('Please select a vendor and platform first.', 'warning');
        return;
    }
    
    // Gather form settings
    const settings = collectFormSettings();
    
    // Generate configuration
    let configOutput = '';
    
    if (window.generateVendorConfig && typeof window.generateVendorConfig === 'function') {
        // Use the vendor-specific generator from vendors.js
        configOutput = window.generateVendorConfig(selectedVendor, platform, settings);
    } else {
        // Fallback to a simple configuration template
        configOutput = generateFallbackConfig(selectedVendor, platform, settings);
    }
    
    // Display configuration
    const configOutputElement = document.getElementById('config-output');
    if (configOutputElement) {
        configOutputElement.textContent = configOutput;
    }
    
    // Auto analyze configuration
    analyzeConfiguration();
    
    showAlert('Configuration generated successfully!', 'success');
}

// Collect form settings from all tabs
function collectFormSettings() {
    const settings = {
        // Platform settings
        softwareVersion: getInputValue('software-version', ''),
        
        // Authentication settings
        authMethod: getSelectValue('auth-method', 'dot1x'),
        authMode: getRadioValue('auth-mode', 'closed'),
        hostMode: getSelectValue('host-mode', 'multi-auth'),
        radiusServer: getInputValue('radius-server-1', ''),
        radiusAuthPort: getInputValue('radius-auth-port-1', '1812'),
        radiusAcctPort: getInputValue('radius-acct-port-1', '1813'),
        radiusKey: getInputValue('radius-secret-1', ''),
        secondaryServer: getInputValue('radius-server-2', ''),
        secondaryAuthPort: getInputValue('radius-auth-port-2', '1812'),
        secondaryAcctPort: getInputValue('radius-acct-port-2', '1813'),
        secondaryKey: getInputValue('radius-secret-2', ''),
        tertiaryServer: getInputValue('radius-server-3', ''),
        tertiaryAuthPort: getInputValue('radius-auth-port-3', '1812'),
        tertiaryAcctPort: getInputValue('radius-acct-port-3', '1813'),
        tertiaryKey: getInputValue('radius-secret-3', ''),
        radiusTimeout: getInputValue('radius-timeout', '5'),
        radiusRetransmit: getInputValue('radius-retransmit', '3'),
        radiusDeadtime: getInputValue('radius-deadtime', '15'),
        radiusAttributeFormat: getSelectValue('radius-attribute-format', 'standard'),
        radiusNasId: getInputValue('radius-nas-id', ''),
        radiusNasIp: getInputValue('radius-nas-ip', ''),
        
        // TACACS+ settings
        useTacacs: getCheckboxValue('use-tacacs', false),
        tacacsServer: getInputValue('tacacs-server-1', ''),
        tacacsPort: getInputValue('tacacs-port-1', '49'),
        tacacsKey: getInputValue('tacacs-secret-1', ''),
        tacacsSecondaryServer: getInputValue('tacacs-server-2', ''),
        tacacsSecondaryKey: getInputValue('tacacs-secret-2', ''),
        
        // Authentication timers
        reauthPeriod: getInputValue('reauth-period', '3600'),
        txPeriod: getInputValue('tx-period', '30'),
        quietPeriod: getInputValue('quiet-period', '60'),
        maxReauth: getInputValue('max-reauth', '2'),
        
        // Security settings - RADIUS
        useCoa: getCheckboxValue('use-coa', true),
        coaPort: getInputValue('coa-port', '1700'),
        coaBouncePort: getCheckboxValue('coa-bounce-port', true),
        coaReauth: getCheckboxValue('coa-reauth', true),
        enableAccounting: getCheckboxValue('enable-accounting', true),
        accountingUpdate: getInputValue('accounting-update', '30'),
        accountingInterim: getCheckboxValue('accounting-interim', true),
        useRadsec: getCheckboxValue('use-radsec', false),
        radsecPort: getInputValue('radsec-port', '2083'),
        radsecCert: getInputValue('radsec-cert', ''),
        radsecCa: getInputValue('radsec-ca', ''),
        
        // Security settings - Data protection
        useMacsec: getCheckboxValue('use-macsec', false),
        macsecPolicy: getSelectValue('macsec-policy', 'should-secure'),
        macsecCipher: getSelectValue('macsec-cipher', 'gcm-aes-256'),
        macsecIncludeSci: getCheckboxValue('macsec-include-sci', true),
        macsecReplayProtection: getCheckboxValue('macsec-replay-protection', true),
        macsecReplayWindow: getInputValue('macsec-replay-window', '0'),
        
        // Security settings - Additional protections
        enableDhcpSnooping: getCheckboxValue('enable-dhcp-snooping', true),
        dhcpRateLimit: getInputValue('dhcp-rate-limit', '20'),
        dhcpOption82: getCheckboxValue('dhcp-option82', true),
        enableDai: getCheckboxValue('enable-dai', false),
        daiValidateSrcMac: getCheckboxValue('dai-validate-src-mac', true),
        daiValidateDstMac: getCheckboxValue('dai-validate-dst-mac', true),
        daiValidateIp: getCheckboxValue('dai-validate-ip', true),
        enableIpsg: getCheckboxValue('enable-ipsg', false),
        enableStormControl: getCheckboxValue('enable-storm-control', false),
        stormControlBroadcast: getInputValue('storm-control-broadcast', '20'),
        stormControlMulticast: getInputValue('storm-control-multicast', '30'),
        stormControlUnicast: getInputValue('storm-control-unicast', '50'),
        enablePortSecurity: getCheckboxValue('enable-port-security', false),
        portSecurityMaxMac: getInputValue('port-security-max-mac', '1'),
        portSecurityViolation: getSelectValue('port-security-violation', 'shutdown'),
        
        // Network settings - VLANs
        vlanAuth: getInputValue('vlan-auth', ''),
        vlanAuthName: getInputValue('vlan-auth-name', ''),
        vlanUnauth: getInputValue('vlan-unauth', ''),
        vlanUnauthName: getInputValue('vlan-unauth-name', ''),
        vlanGuest: getInputValue('vlan-guest', ''),
        vlanGuestName: getInputValue('vlan-guest-name', ''),
        vlanVoice: getInputValue('vlan-voice', ''),
        vlanVoiceName: getInputValue('vlan-voice-name', ''),
        vlanCritical: getInputValue('vlan-critical', ''),
        vlanCriticalName: getInputValue('vlan-critical-name', ''),
        enableDynamicVlan: getCheckboxValue('enable-dynamic-vlan', true),
        enableVlanOverride: getCheckboxValue('enable-vlan-override', false),
        enableVoiceVlanDetection: getCheckboxValue('enable-voice-vlan-detection', true),
        
        // Network settings - Interfaces
        interface: getInputValue('interface', 'GigabitEthernet1/0/1'),
        interfaceRange: getInputValue('interface-range', ''),
        mgmtInterface: getInputValue('mgmt-interface', ''),
        interfacePortfast: getCheckboxValue('interface-portfast', true),
        interfaceBpduGuard: getCheckboxValue('interface-bpdu-guard', true),
        interfaceAdminShutdown: getCheckboxValue('interface-admin-shutdown', false),
        interfaceMtu: getInputValue('interface-mtu', '1500'),
        
        // Network settings - Device tracking & ACLs
        enableDeviceTracking: getCheckboxValue('enable-device-tracking', true),
        deviceTrackingInterval: getInputValue('device-tracking-interval', '30'),
        deviceTrackingIpv6: getCheckboxValue('device-tracking-ipv6', false),
        enableAcl: getCheckboxValue('enable-acl', false),
        aclNameAuth: getInputValue('acl-name-auth', ''),
        aclNameUnauth: getInputValue('acl-name-unauth', ''),
        enableDynamicAcl: getCheckboxValue('enable-dynamic-acl', true),
        enableRedirectAcl: getCheckboxValue('enable-redirect-acl', false),
        
        // Advanced settings - Deployment
        deployStrategy: getRadioValue('deploy-strategy', 'monitor'),
        phase1Duration: getInputValue('phase1-duration', '30'),
        phase2Duration: getInputValue('phase2-duration', '15'),
        phase3Date: getInputValue('phase3-date', ''),
        
        // Advanced settings - Industry
        industryType: getSelectValue('industry-type', 'enterprise'),
        applyIndustryTemplates: getCheckboxValue('apply-industry-templates', false),
        complianceMode: getCheckboxValue('compliance-mode', true),
        complianceFramework: getSelectValue('compliance-framework', 'none'),
        
        // Advanced settings - Additional
        additionalCommands: getInputValue('additional-commands', ''),
        includeComments: getCheckboxValue('include-comments', true),
        backupConfig: getCheckboxValue('backup-config', false),
        enableAaaLogging: getCheckboxValue('enable-aaa-logging', true)
    };
    
    return settings;
}

// Show save configuration modal
function showSaveConfigModal() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput || configOutput.textContent.trim() === '' || configOutput.textContent.includes('No configuration generated yet.')) {
        showAlert('Please generate a configuration first.', 'warning');
        return;
    }
    
    // Get vendor and platform for default name
    let selectedVendor = '';
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    vendorContainers.forEach(container => {
        if (container.classList.contains('selected')) {
            selectedVendor = container.getAttribute('data-vendor');
        }
    });
    
    const platformSelect = document.getElementById('platform-select');
    const platform = platformSelect ? platformSelect.value : '';
    
    // Set default name
    const configNameInput = document.getElementById('saved-config-name');
    const date = new Date().toISOString().split('T')[0];
    if (configNameInput) {
        configNameInput.value = `${selectedVendor.toUpperCase()} ${platform.toUpperCase()} 802.1X Config - ${date}`;
    }
    
    // Show modal
    const modal = document.getElementById('save-config-modal');
    if (modal) {
        modal.classList.add('visible');
    }
}

// Save configuration
function saveConfiguration() {
    const configName = document.getElementById('saved-config-name').value;
    const configDesc = document.getElementById('saved-config-desc').value;
    const configTags = document.getElementById('saved-config-tags').value;
    
    if (!configName) {
        showAlert('Please enter a name for this configuration.', 'warning');
        return;
    }
    
    // Get current configuration text
    const configOutput = document.getElementById('config-output').textContent;
    
    // Get selected vendor and platform
    let selectedVendor = '';
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    vendorContainers.forEach(container => {
        if (container.classList.contains('selected')) {
            selectedVendor = container.getAttribute('data-vendor');
        }
    });
    
    const platformSelect = document.getElementById('platform-select');
    const platform = platformSelect ? platformSelect.value : '';
    
    // Create configuration object
    const configObject = {
        id: Date.now().toString(),
        name: configName,
        description: configDesc,
        tags: configTags.split(',').map(tag => tag.trim()).filter(tag => tag),
        vendor: selectedVendor,
        platform: platform,
        createdAt: new Date().toISOString(),
        settings: collectFormSettings(),
        configuration: configOutput
    };
    
    // Save to local storage
    let savedConfigs = [];
    try {
        const savedConfigsStr = localStorage.getItem('dot1xer_saved_configs');
        if (savedConfigsStr) {
            savedConfigs = JSON.parse(savedConfigsStr);
        }
        
        savedConfigs.push(configObject);
        localStorage.setItem('dot1xer_saved_configs', JSON.stringify(savedConfigs));
        
        // Hide modal
        const modal = document.getElementById('save-config-modal');
        if (modal) {
            modal.classList.remove('visible');
        }
        
        showAlert('Configuration saved successfully!', 'success');
    } catch (error) {
        console.error('Error saving configuration:', error);
        showAlert('Failed to save configuration.', 'danger');
    }
}

// Helper function to get input value
function getInputValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

// Helper function to get select value
function getSelectValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

// Helper function to get radio value
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

// Generate a fallback configuration when vendor-specific generator is not available
function generateFallbackConfig(vendor, platform, settings) {
    return `! ${vendor.toUpperCase()} ${platform.toUpperCase()} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
!
! Configuration Parameters:
! - RADIUS Server: ${settings.radiusServer || 'Not specified'} (${settings.radiusAuthPort}/${settings.radiusAcctPort})
! - Secondary RADIUS: ${settings.secondaryServer || 'Not specified'} (${settings.secondaryAuthPort}/${settings.secondaryAcctPort})
! - Tertiary RADIUS: ${settings.tertiaryServer || 'Not specified'} (${settings.tertiaryAuthPort}/${settings.tertiaryAcctPort})
! - Authentication Method: ${settings.authMethod}
! - Authentication Mode: ${settings.authMode}
! - Host Mode: ${settings.hostMode}
! - Authentication VLAN: ${settings.vlanAuth || 'Not specified'} ${settings.vlanAuthName ? `(${settings.vlanAuthName})` : ''}
! - Unauthenticated VLAN: ${settings.vlanUnauth || 'Not specified'} ${settings.vlanUnauthName ? `(${settings.vlanUnauthName})` : ''}
! - Guest VLAN: ${settings.vlanGuest || 'Not specified'} ${settings.vlanGuestName ? `(${settings.vlanGuestName})` : ''}
! - Voice VLAN: ${settings.vlanVoice || 'Not specified'} ${settings.vlanVoiceName ? `(${settings.vlanVoiceName})` : ''}
! - Critical VLAN: ${settings.vlanCritical || 'Not specified'} ${settings.vlanCriticalName ? `(${settings.vlanCriticalName})` : ''}
! - Interface: ${settings.interface || 'Not specified'}
! - Interface Range: ${settings.interfaceRange || 'Not specified'}
! - Management Interface: ${settings.mgmtInterface || 'Not specified'}
! - Reauthentication Period: ${settings.reauthPeriod} seconds
! - Transmit Period: ${settings.txPeriod} seconds
! - Quiet Period: ${settings.quietPeriod} seconds
! - Max Retries: ${settings.maxReauth}
! 
! RADIUS Security Features:
! - RADIUS CoA: ${settings.useCoa ? 'Enabled' : 'Disabled'} ${settings.useCoa ? `(Port: ${settings.coaPort})` : ''}
! - RADIUS Accounting: ${settings.enableAccounting ? 'Enabled' : 'Disabled'} ${settings.enableAccounting ? `(Update: ${settings.accountingUpdate} min)` : ''}
! - RadSec: ${settings.useRadsec ? 'Enabled' : 'Disabled'} ${settings.useRadsec ? `(Port: ${settings.radsecPort})` : ''}
! - MACsec: ${settings.useMacsec ? 'Enabled' : 'Disabled'} ${settings.useMacsec ? `(Cipher: ${settings.macsecCipher})` : ''}
! 
! Additional Protections:
! - DHCP Snooping: ${settings.enableDhcpSnooping ? 'Enabled' : 'Disabled'}
! - Dynamic ARP Inspection: ${settings.enableDai ? 'Enabled' : 'Disabled'}
! - IP Source Guard: ${settings.enableIpsg ? 'Enabled' : 'Disabled'}
! - Storm Control: ${settings.enableStormControl ? 'Enabled' : 'Disabled'}
! - Port Security: ${settings.enablePortSecurity ? 'Enabled' : 'Disabled'}
! 
! Advanced Settings:
! - Deployment Strategy: ${settings.deployStrategy}
! - Industry Type: ${settings.industryType}
! - Compliance Framework: ${settings.applyIndustryTemplates ? settings.complianceFramework : 'None'}
!
! Additional Commands:
${settings.additionalCommands ? settings.additionalCommands.split('\n').map(line => '! ' + line).join('\n') : '! None specified'}`;
}

// Copy configuration to clipboard
function copyConfigToClipboard() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput) return;
    
    const config = configOutput.textContent;
    if (config.trim() === '' || config.includes('No configuration generated yet.')) {
        showAlert('Please generate a configuration first.', 'warning');
        return;
    }
    
    if (navigator.clipboard) {
        navigator.clipboard.writeText(config)
            .then(() => {
                showAlert('Configuration copied to clipboard!', 'success');
            })
            .catch(err => {
                console.error('Failed to copy configuration: ', err);
                showAlert('Failed to copy configuration. Please try selecting and copying manually.', 'danger');
            });
    } else {
        // Fallback for browsers without clipboard API
        try {
            const textarea = document.createElement('textarea');
            textarea.value = config;
            document.body.appendChild(textarea);
            textarea.select();
            document.execCommand('copy');
            document.body.removeChild(textarea);
            showAlert('Configuration copied to clipboard!', 'success');
        } catch (error) {
            console.error('Failed to copy configuration: ', error);
            showAlert('Failed to copy configuration. Please try selecting and copying manually.', 'danger');
        }
    }
}

// Download configuration as file
function downloadConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput) return;
    
    const config = configOutput.textContent;
    if (config.trim() === '' || config.includes('No configuration generated yet.')) {
        showAlert('Please generate a configuration first.', 'warning');
        return;
    }
    
    // Get selected vendor and platform
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    let selectedVendor = 'unknown';
    
    vendorContainers.forEach(container => {
        if (container.classList.contains('selected')) {
            selectedVendor = container.getAttribute('data-vendor');
        }
    });
    
    const platformSelect = document.getElementById('platform-select');
    const platform = platformSelect ? platformSelect.value : 'unknown';
    
    // Create filename
    const date = new Date().toISOString().split('T')[0];
    const filename = `${selectedVendor}-${platform}-dot1x-config-${date}.txt`;
    
    // Create download link
    try {
        const blob = new Blob([config], { type: 'text/plain' });
        if (window.saveAs) {
            // Use FileSaver.js if available
            saveAs(blob, filename);
        } else {
            // Fallback to manual download
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
        }
        showAlert(`Configuration downloaded as "${filename}"`, 'success');
    } catch (error) {
        console.error('Error downloading configuration:', error);
        showAlert('Error downloading configuration. Please try again.', 'danger');
    }
}

// Analyze the generated configuration
function analyzeConfiguration() {
    const configOutput = document.getElementById('config-output');
    const configAnalysis = document.getElementById('config-analysis');
    
    if (!configOutput || !configAnalysis) return;
    
    const config = configOutput.textContent;
    if (config.trim() === '' || config.includes('No configuration generated yet.')) {
        configAnalysis.innerHTML = '<p>No analysis available yet. Please generate a configuration first.</p>';
        return;
    }
    
    // Comprehensive analysis
    const analysis = [];
    const settings = collectFormSettings();
    
    // Security analysis
    const securityIssues = [];
    const securityWarnings = [];
    const securityRecommendations = [];
    
    // Check for RADIUS server configuration
    if (!settings.radiusServer) {
        securityIssues.push('No primary RADIUS server configured.');
    }
    
    // Check for RADIUS redundancy
    if (!settings.secondaryServer) {
        securityWarnings.push('No secondary RADIUS server configured for redundancy.');
    }
    
    // Check for reasonable timers
    if (parseInt(settings.reauthPeriod) < 300) {
        securityWarnings.push(`Reauthentication period (${settings.reauthPeriod}s) is less than 300 seconds. This may cause excessive authentication traffic.`);
    } else if (parseInt(settings.reauthPeriod) > 86400) {
        securityWarnings.push(`Reauthentication period (${settings.reauthPeriod}s) is greater than 24 hours. Consider reducing for better security.`);
    }
    
    if (parseInt(settings.txPeriod) < 10) {
        securityWarnings.push(`TX period (${settings.txPeriod}s) is less than 10 seconds. This may cause excessive EAP traffic.`);
    }
    
    // Check for multi-host mode (least secure)
    if (settings.hostMode === 'multi-host') {
        securityWarnings.push('Multi-host mode is configured. This is the least secure host mode as it allows any device on the port once one device is authenticated.');
    }
    
    // Check authentication methods
    if (settings.authMethod === 'mab') {
        securityWarnings.push('MAC Authentication Bypass (MAB) is the only authentication method. This is less secure than 802.1X.');
    }
    
    if (settings.authMode === 'open') {
        securityWarnings.push('Open authentication mode allows traffic before authentication, reducing security effectiveness.');
    }
    
    // Check for security features
    if (!settings.enableDhcpSnooping) {
        securityRecommendations.push('DHCP Snooping is disabled. Consider enabling it to prevent DHCP spoofing attacks.');
    }
    
    if (!settings.enableDai) {
        securityRecommendations.push('Dynamic ARP Inspection is disabled. Consider enabling it to prevent ARP poisoning attacks.');
    }
    
    if (!settings.enableIpsg) {
        securityRecommendations.push('IP Source Guard is disabled. Consider enabling it to prevent IP spoofing attacks.');
    }
    
    // Check for accounting
    if (!settings.enableAccounting) {
        securityRecommendations.push('RADIUS accounting is disabled. Consider enabling it for auditing and troubleshooting.');
    }
    
    // Check for MACsec
    if (!settings.useMacsec) {
        securityRecommendations.push('MACsec is disabled. Consider enabling it for layer 2 encryption if your hardware supports it.');
    }
    
    // Check for RadSec
    if (!settings.useRadsec) {
        securityRecommendations.push('RadSec is disabled. Consider enabling it to encrypt RADIUS traffic if your infrastructure supports it.');
    }
    
    // Create security analysis HTML
    let securityAnalysisHtml = '';
    
    if (securityIssues.length > 0) {
        securityAnalysisHtml += `<div class="alert alert-danger"><strong>Critical Issues:</strong><ul><li>${securityIssues.join('</li><li>')}</li></ul></div>`;
    }
    
    if (securityWarnings.length > 0) {
        securityAnalysisHtml += `<div class="alert alert-warning"><strong>Security Warnings:</strong><ul><li>${securityWarnings.join('</li><li>')}</li></ul></div>`;
    }
    
    if (securityRecommendations.length > 0) {
        securityAnalysisHtml += `<div class="alert alert-info"><strong>Recommendations:</strong><ul><li>${securityRecommendations.join('</li><li>')}</li></ul></div>`;
    }
    
    // If no issues found
    if (securityIssues.length === 0 && securityWarnings.length === 0 && securityRecommendations.length === 0) {
        securityAnalysisHtml += '<div class="alert alert-success"><strong>Security Analysis:</strong> No security issues detected.</div>';
    }
    
    // Compatibility analysis
    let compatibilityHtml = '';
    const compatibilityIssues = [];
    
    // VLAN configuration checks
    if (settings.vlanGuest && !settings.vlanUnauth) {
        compatibilityIssues.push('Guest VLAN is configured, but Unauthenticated VLAN is not. Some platforms may require both for proper operation.');
    }
    
    // Voice VLAN with multi-domain
    if (settings.vlanVoice && settings.hostMode !== 'multi-domain') {
        compatibilityIssues.push('Voice VLAN is configured, but host mode is not set to Multi-Domain. Voice devices may not authenticate properly.');
    }
    
    // Add compatibility section if issues exist
    if (compatibilityIssues.length > 0) {
        compatibilityHtml = `<div class="alert alert-warning"><strong>Compatibility Issues:</strong><ul><li>${compatibilityIssues.join('</li><li>')}</li></ul></div>`;
    }
    
    // Deploy strategy specific recommendations
    let deployRecommendations = '';
    if (settings.deployStrategy === 'monitor') {
        deployRecommendations = `
            <div class="alert alert-info">
                <strong>Monitor Mode Deployment Notes:</strong>
                <p>Your configuration is set for "Monitor Mode" deployment. This is ideal for the initial deployment phase.</p>
                <ul>
                    <li>Authentication will be performed but not enforced</li>
                    <li>Monitor authentication successes and failures</li>
                    <li>Recommended duration: ${settings.phase1Duration} days</li>
                    <li>Next step: Move to Low-Impact mode after resolving authentication issues</li>
                </ul>
            </div>
        `;
    } else if (settings.deployStrategy === 'low-impact') {
        deployRecommendations = `
            <div class="alert alert-info">
                <strong>Low-Impact Mode Deployment Notes:</strong>
                <p>Your configuration is set for "Low-Impact" deployment. This is suitable for the second phase of deployment.</p>
                <ul>
                    <li>Authentication will be enforced but with fallback mechanisms</li>
                    <li>Unauthenticated devices will be placed in ${settings.vlanUnauth ? `VLAN ${settings.vlanUnauth}` : 'the unauthenticated VLAN'}</li>
                    <li>Guest devices will be placed in ${settings.vlanGuest ? `VLAN ${settings.vlanGuest}` : 'the guest VLAN'}</li>
                    <li>Recommended duration: ${settings.phase2Duration} days</li>
                    <li>Next step: Move to Closed mode after addressing any remaining issues</li>
                </ul>
            </div>
        `;
    } else if (settings.deployStrategy === 'closed') {
        deployRecommendations = `
            <div class="alert alert-info">
                <strong>Closed Mode Deployment Notes:</strong>
                <p>Your configuration is set for full "Closed Mode" enforcement. This provides maximum security.</p>
                <ul>
                    <li>Full 802.1X enforcement is in effect</li>
                    <li>Unauthenticated devices will not have network access</li>
                    <li>Ensure all legitimate devices can authenticate before deploying</li>
                    <li>Have a rollback plan ready in case of unexpected issues</li>
                </ul>
            </div>
        `;
    }
    
    // Combine all analysis sections
    const fullAnalysis = securityAnalysisHtml + compatibilityHtml + deployRecommendations;
    configAnalysis.innerHTML = fullAnalysis;
}

// Optimize configuration with AI
async function optimizeConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput) return;
    
    const config = configOutput.textContent;
    if (config.trim() === '' || config.includes('No configuration generated yet.')) {
        showAlert('Please generate a configuration first.', 'warning');
        return;
    }
    
    // Check if AI integration is available
    if (!window.AIIntegration) {
        showAlert('AI integration is not available. Using local optimization instead.', 'info');
        // Perform basic optimization without AI
        const optimizedConfig = optimizeConfigurationLocally(config);
        configOutput.textContent = optimizedConfig;
        return;
    }
    
    // Show loading indicator
    showAlert('Optimizing configuration with AI...', 'info');
    const settings = collectFormSettings();
    
    try {
        const result = await window.AIIntegration.optimizeConfiguration(config, settings);
        
        if (result.success) {
            configOutput.textContent = result.optimizedConfig;
            showAlert(`Configuration optimized successfully using ${result.provider} ${result.model}!`, 'success');
            
            // Re-analyze the optimized configuration
            analyzeConfiguration();
        } else {
            showAlert(`Failed to optimize configuration: ${result.error}. Using local optimization instead.`, 'warning');
            // Fallback to local optimization
            const optimizedConfig = optimizeConfigurationLocally(config);
            configOutput.textContent = optimizedConfig;
        }
    } catch (error) {
        console.error('Error during AI optimization:', error);
        showAlert('Error during AI optimization. Using local optimization instead.', 'warning');
        // Fallback to local optimization
        const optimizedConfig = optimizeConfigurationLocally(config);
        configOutput.textContent = optimizedConfig;
    }
}

// Optimize configuration locally (without AI)
function optimizeConfigurationLocally(config) {
    const settings = collectFormSettings();
    const lines = config.split('\n');
    const optimizedLines = [];
    
    // Add optimization header
    optimizedLines.push('! Configuration optimized by Dot1Xer Supreme Enterprise Edition v4.1.0');
    optimizedLines.push('! Local optimization applied - for advanced optimization, configure AI integration');
    optimizedLines.push('!');
    
    // Process each line and apply optimizations
    for (let i = 0; i < lines.length; i++) {
        const line = lines[i];
        
        // Skip empty lines and comments at the beginning
        if (optimizedLines.length < 5 && (line.trim() === '' || line.trim().startsWith('!'))) {
            continue;
        }
        
        // Apply optimizations based on settings
        
        // Optimize RADIUS server settings if timeout and retransmit are default values
        if (line.includes('timeout 5') && settings.radiusTimeout !== '5') {
            optimizedLines.push(line.replace('timeout 5', `timeout ${settings.radiusTimeout}`));
            continue;
        }
        
        if (line.includes('retransmit 3') && settings.radiusRetransmit !== '3') {
            optimizedLines.push(line.replace('retransmit 3', `retransmit ${settings.radiusRetransmit}`));
            continue;
        }
        
        // Optimize reauthentication period for better performance
        if (line.includes('reauth-period') && !line.includes(`reauth-period ${settings.reauthPeriod}`)) {
            // If current reauth period is too small or too large, optimize it
            const currentValue = parseInt(line.match(/reauth-period\s+(\d+)/)?.[1] || '0');
            const optimizedValue = currentValue < 300 ? 3600 : (currentValue > 86400 ? 86400 : currentValue);
            optimizedLines.push(line.replace(/reauth-period\s+\d+/, `reauth-period ${optimizedValue}`));
            continue;
        }
        
        // Add recommended security features if missing
        if (line.includes('dot1x pae authenticator') && !config.includes('ip verify source')) {
            optimizedLines.push(line);
            // Recommend IP Source Guard if DHCP Snooping is enabled
            if (settings.enableDhcpSnooping && !settings.enableIpsg) {
                optimizedLines.push(' ! Recommended: ip verify source');
            }
            continue;
        }
        
        // Add default line with optional comment for optimization
        optimizedLines.push(line);
    }
    
    // Add optimization recommendations at the end
    optimizedLines.push('');
    optimizedLines.push('! ===== Optimization Recommendations =====');
    
    if (!settings.secondaryServer) {
        optimizedLines.push('! Add a secondary RADIUS server for redundancy');
    }
    
    if (!settings.enableDhcpSnooping) {
        optimizedLines.push('! Enable DHCP Snooping for enhanced security');
    }
    
    if (!settings.enableDai && settings.enableDhcpSnooping) {
        optimizedLines.push('! Enable Dynamic ARP Inspection when DHCP Snooping is enabled');
    }
    
    if (!settings.enableIpsg && settings.enableDhcpSnooping) {
        optimizedLines.push('! Enable IP Source Guard when DHCP Snooping is enabled');
    }
    
    if (settings.hostMode === 'multi-host') {
        optimizedLines.push('! Consider using multi-auth or multi-domain instead of multi-host for better security');
    }
    
    if (!settings.enableAaaLogging) {
        optimizedLines.push('! Enable AAA logging for better troubleshooting and auditing');
    }
    
    return optimizedLines.join('\n');
}

// Helper function to display alerts
function showAlert(message, type = 'info') {
    // Create alert container if it doesn't exist
    let alertContainer = document.getElementById('alert-container');
    if (!alertContainer) {
        alertContainer = document.createElement('div');
        alertContainer.id = 'alert-container';
        alertContainer.style.position = 'fixed';
        alertContainer.style.top = '20px';
        alertContainer.style.right = '20px';
        alertContainer.style.zIndex = '9999';
        alertContainer.style.maxWidth = '400px';
        document.body.appendChild(alertContainer);
    }
    
    // Create alert element
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
    
    // Close button
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
    
    // Show the alert with animation
    setTimeout(() => {
        alert.style.opacity = '1';
        alert.style.transform = 'translateX(0)';
    }, 10);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alert.parentNode) {
            alert.style.opacity = '0';
            alert.style.transform = 'translateX(50px)';
            setTimeout(() => {
                if (alert.parentNode) {
                    alert.remove();
                }
            }, 300);
        }
    }, 5000);
}
/**
 * Dot1Xer Supreme Enterprise Edition - AI Assistant
 * Version 4.1.0
 * 
 * This module handles the AI assistant chat functionality
 * for helping users with 802.1X configuration questions.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing AI Assistant...');
    initAIAssistant();
});

// Chat history storage
const chatHistory = [];

// Initialize AI Assistant
function initAIAssistant() {
    // Set up event handlers
    const aiAssistantButton = document.getElementById('ai-assistant-button');
    const aiAssistantPanel = document.getElementById('ai-assistant-panel');
    const aiAssistantClose = document.getElementById('ai-assistant-close');
    const aiAssistantInput = document.getElementById('ai-assistant-input');
    const aiAssistantSend = document.getElementById('ai-assistant-send');
    
    // Toggle AI panel visibility
    if (aiAssistantButton) {
        aiAssistantButton.addEventListener('click', () => {
            if (aiAssistantPanel) {
                aiAssistantPanel.classList.toggle('visible');
                
                // Focus input field when panel opens
                if (aiAssistantPanel.classList.contains('visible') && aiAssistantInput) {
                    setTimeout(() => aiAssistantInput.focus(), 300);
                }
            }
        });
    }
    
    // Close AI panel
    if (aiAssistantClose) {
        aiAssistantClose.addEventListener('click', () => {
            if (aiAssistantPanel) {
                aiAssistantPanel.classList.remove('visible');
            }
        });
    }
    
    // Send message when clicking the send button
    if (aiAssistantSend) {
        aiAssistantSend.addEventListener('click', sendAIMessage);
    }
    
    // Send message when pressing Enter in the input field
    if (aiAssistantInput) {
        aiAssistantInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                e.preventDefault();
                sendAIMessage();
            }
        });
    }
    
    // Initialize AIIntegration if available
    if (window.AIIntegration && typeof window.AIIntegration.init === 'function') {
        // Load API keys from localStorage
        const storedKeys = {};
        try {
            const openaiKey = localStorage.getItem('openai_api_key');
            const anthropicKey = localStorage.getItem('anthropic_api_key');
            const geminiKey = localStorage.getItem('gemini_api_key');
            
            if (openaiKey) storedKeys.openai = openaiKey;
            if (anthropicKey) storedKeys.anthropic = anthropicKey;
            if (geminiKey) storedKeys.gemini = geminiKey;
        } catch (e) {
            console.error('Error loading AI API keys:', e);
        }
        
        // Initialize AIIntegration with stored keys
        window.AIIntegration.init({
            provider: localStorage.getItem('ai_provider') || 'openai',
            apiKeys: storedKeys
        });
    }
}

// Send message to AI Assistant
async function sendAIMessage() {
    const aiAssistantInput = document.getElementById('ai-assistant-input');
    const aiAssistantBody = document.getElementById('ai-assistant-body');
    
    if (!aiAssistantInput || !aiAssistantBody) return;
    
    const message = aiAssistantInput.value.trim();
    if (!message) return;
    
    // Clear input field
    aiAssistantInput.value = '';
    
    // Add user message to chat
    addChatMessage('user', message);
    
    // Add user message to history
    chatHistory.push({ role: 'user', content: message });
    
    // Generate AI response
    try {
        // Add typing indicator
        const typingIndicator = addTypingIndicator();
        
        let response;
        
        // Use AIIntegration if available
        if (window.AIIntegration && typeof window.AIIntegration.chatWithAssistant === 'function') {
            const result = await window.AIIntegration.chatWithAssistant(message, chatHistory);
            
            if (result.success) {
                response = result.response;
            } else {
                response = `I'm having trouble connecting to the AI service (${result.error}). Here's some general information about 802.1X:\n\n802.1X is a standard for port-based Network Access Control (PNAC) that provides authentication for devices connecting to a network. It involves three parties: the supplicant (client device), the authenticator (switch or access point), and the authentication server (RADIUS).`;
            }
        } else {
            // Fallback to local response if AIIntegration not available
            response = getLocalAIResponse(message);
        }
        
        // Remove typing indicator
        if (typingIndicator) {
            typingIndicator.remove();
        }
        
        // Add AI response to chat
        addChatMessage('assistant', response);
        
        // Add AI response to history
        chatHistory.push({ role: 'assistant', content: response });
        
        // Scroll to bottom
        aiAssistantBody.scrollTop = aiAssistantBody.scrollHeight;
    } catch (error) {
        console.error('Error generating AI response:', error);
        
        // Remove typing indicator
        const typingIndicator = document.querySelector('.typing-indicator');
        if (typingIndicator) {
            typingIndicator.remove();
        }
        
        // Add error message
        addChatMessage('assistant', 'Sorry, I encountered an error. Please try again.');
    }
}

// Add message to chat
function addChatMessage(role, content) {
    const aiAssistantBody = document.getElementById('ai-assistant-body');
    if (!aiAssistantBody) return;
    
    const messageElement = document.createElement('div');
    messageElement.className = `ai-message ${role}`;
    
    // Format content with markdown-like syntax
    const formattedContent = formatMessageContent(content);
    messageElement.innerHTML = formattedContent;
    
    aiAssistantBody.appendChild(messageElement);
    
    // Scroll to bottom
    aiAssistantBody.scrollTop = aiAssistantBody.scrollHeight;
    
    return messageElement;
}

// Format message content with markdown-like syntax
function formatMessageContent(content) {
    if (!content) return '';
    
    // Convert line breaks
    let formatted = content.replace(/\n/g, '<br>');
    
    // Format bold text: **text** -> <strong>text</strong>
    formatted = formatted.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
    
    // Format italic text: *text* -> <em>text</em>
    formatted = formatted.replace(/\*(.*?)\*/g, '<em>$1</em>');
    
    // Format code blocks: ```code``` -> <pre><code>code</code></pre>
    formatted = formatted.replace(/```([\s\S]*?)```/g, '<pre><code>$1</code></pre>');
    
    // Format inline code: `code` -> <code>code</code>
    formatted = formatted.replace(/`([^`]+)`/g, '<code>$1</code>');
    
    // Format lists: - item -> <li>item</li>
    const listItems = formatted.match(/- (.*?)(?=<br>|$)/g);
    if (listItems) {
        formatted = formatted.replace(/- (.*?)(?=<br>|$)/g, '<li>$1</li>');
        // Wrap list items in <ul> tags
        formatted = formatted.replace(/<li>.*?<\/li>(?:<br>)?<li>/g, '<ul><li>');
        formatted = formatted.replace(/<\/li>(?:<br>)?(?!<li>)/g, '</li></ul>');
    }
    
    return formatted;
}

// Add typing indicator
function addTypingIndicator() {
    const aiAssistantBody = document.getElementById('ai-assistant-body');
    if (!aiAssistantBody) return null;
    
    const typingIndicator = document.createElement('div');
    typingIndicator.className = 'ai-message assistant typing-indicator';
    typingIndicator.innerHTML = 'Thinking<span class="dot">.</span><span class="dot">.</span><span class="dot">.</span>';
    
    aiAssistantBody.appendChild(typingIndicator);
    
    // Scroll to bottom
    aiAssistantBody.scrollTop = aiAssistantBody.scrollHeight;
    
    return typingIndicator;
}

// Get local AI response without using external API
function getLocalAIResponse(message) {
    message = message.toLowerCase();
    
    // Common 802.1X related questions and answers
    if (message.includes('what is 802.1x') || message.includes('explain 802.1x')) {
        return `IEEE 802.1X is a standard for port-based Network Access Control (PNAC) that provides an authentication mechanism for devices connecting to a LAN or WLAN.

Key components include:
- **Supplicant**: The client device requesting access
- **Authenticator**: The network device (switch or access point)
- **Authentication Server**: Usually a RADIUS server that validates credentials

The standard allows network administrators to enforce authentication before granting access to network resources, significantly enhancing security.`;
    }
    
    if (message.includes('mab') || message.includes('mac authentication bypass')) {
        return `MAC Authentication Bypass (MAB) is an authentication method used when a device doesn't support 802.1X authentication.

With MAB:
- The switch attempts 802.1X authentication first
- If no response, the switch captures the device's MAC address
- The MAC address is sent to the RADIUS server as both username and password
- The RADIUS server authenticates based on the MAC address

MAB is commonly used for printers, IP phones, and other devices that can't run a supplicant. It's less secure than 802.1X because MAC addresses can be spoofed, but provides better security than no authentication.`;
    }
    
    if (message.includes('eap') || message.includes('extensible authentication protocol')) {
        return `Extensible Authentication Protocol (EAP) is an authentication framework used in 802.1X. It supports multiple authentication methods.

Common EAP methods include:
- **EAP-TLS**: Uses certificates for mutual authentication (strongest)
- **PEAP**: Protected EAP, creates a TLS tunnel for other authentication methods
- **EAP-TTLS**: Tunneled TLS, allows legacy authentication protocols
- **EAP-FAST**: Flexible Authentication via Secure Tunneling
- **EAP-MD5**: Simple method using MD5 hashing (least secure)

The chosen EAP method significantly impacts your 802.1X deployment's security.`;
    }
    
    if (message.includes('host mode') || message.includes('multi-auth') || message.includes('multi-host')) {
        return `Host modes determine how many devices can authenticate on a single port:

- **Single-Host**: Only one device allowed; any other device causes a security violation
- **Multi-Host**: One device authenticates, then all devices allowed (least secure)
- **Multi-Domain**: Allows one voice device and one data device (e.g., IP phone + computer)
- **Multi-Auth**: Multiple devices can authenticate independently (most flexible)

For most modern deployments, multi-auth is recommended unless you have specific security requirements.`;
    }
    
    if (message.includes('macsec') || message.includes('802.1ae')) {
        return `MACsec (IEEE 802.1AE) is a Layer 2 security technology that provides point-to-point encryption on Ethernet links.

Key features:
- **Data confidentiality**: Encrypts data in transit between devices
- **Data integrity**: Ensures data hasn't been modified
- **Replay protection**: Prevents replay attacks

MACsec works with 802.1X authentication and provides protection against various attacks including man-in-the-middle, eavesdropping, and data modification.

To use MACsec, both the client and switch must support it, and you need to configure 802.1X with EAP-TLS or similar methods that can generate encryption keys.`;
    }
    
    if (message.includes('deploy') || message.includes('implement') || message.includes('roll out')) {
        return `Best practices for deploying 802.1X include a phased approach:

1. **Planning Phase**
   - Inventory network devices
   - Check for 802.1X support
   - Design authentication infrastructure
   - Deploy RADIUS servers

2. **Monitor Mode** (2-4 weeks)
   - Enable 802.1X but don't enforce
   - Monitor authentication attempts
   - Identify problematic devices

3. **Low Impact Mode** (2-3 weeks)
   - Use guest VLAN for unauthenticated devices
   - Address exceptions with MAB
   - Test voice VLAN if applicable

4. **Closed Mode**
   - Full enforcement
   - Unauthenticated devices have no access
   - Ongoing monitoring and maintenance

This phased approach minimizes disruption and helps identify issues before they affect users.`;
    }
    
    if (message.includes('radius') || message.includes('authentication server')) {
        return `RADIUS (Remote Authentication Dial-In User Service) servers handle authentication, authorization, and accounting in 802.1X deployments.

Best practices for RADIUS configuration:
- **Redundancy**: Deploy at least two servers
- **Timeout & Retries**: Set appropriate values (typically 3-5 seconds timeout, 2-3 retries)
- **Shared Secret**: Use strong, unique keys for each network device
- **Attribute-Value Pairs**: Configure proper VLAN assignment attributes
- **Accounting**: Enable for troubleshooting and auditing
- **CoA (Change of Authorization)**: Enable for dynamic policy changes

Popular RADIUS servers include:
- Cisco ISE
- Aruba ClearPass
- FreeRADIUS
- Microsoft NPS
- Juniper SBR`;
    }
    
    if (message.includes('guest vlan') || message.includes('unauthorized') || message.includes('unauthenticated')) {
        return `VLANs play a critical role in 802.1X deployments:

- **Authentication VLAN**: For successfully authenticated devices
- **Guest VLAN**: For devices that don't attempt authentication
- **Auth-Fail VLAN**: For devices that fail authentication
- **Critical VLAN**: Used when RADIUS servers are unreachable
- **Voice VLAN**: For voice devices (often used with multi-domain)

These VLANs provide flexibility in handling different authentication scenarios. The guest VLAN is particularly useful during deployment as it provides network access to devices that don't support 802.1X.`;
    }
    
    if (message.includes('dynamic vlan') || message.includes('vlan assignment')) {
        return `Dynamic VLAN assignment allows the RADIUS server to specify which VLAN a client should be placed in after successful authentication.

Implementation:
1. The RADIUS server sends VLAN attributes in the Access-Accept message
2. The switch places the client in the specified VLAN

Common RADIUS attributes used:
- **Tunnel-Type (64)** = VLAN (13)
- **Tunnel-Medium-Type (65)** = 802 (6)
- **Tunnel-Private-Group-ID (81)** = VLAN ID

This allows for centralized policy management and user-specific network access based on identity, group membership, or other attributes.`;
    }
    
    // Default response for unrecognized questions
    return `I'm here to help with your 802.1X deployment questions. Could you provide more details about what you're trying to accomplish? 

I can help with:
- Authentication methods (802.1X, MAB, EAP types)
- RADIUS server configuration
- Switch configuration
- Deployment strategies
- Troubleshooting
- Security recommendations`;
}
/**
 * Dot1Xer Supreme Enterprise Edition - Document Generator
 * Version 4.1.0
 * 
 * This module handles the generation of documentation for 802.1X deployments.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Document Generator...');
    
    // Set up event handlers
    setupDocumentGeneratorEvents();
});

// Initialize event handlers for document generation
function setupDocumentGeneratorEvents() {
    const exportConfirmBtn = document.getElementById('export-confirm');
    const exportCancelBtn = document.getElementById('export-cancel');
    
    if (exportConfirmBtn) {
        exportConfirmBtn.addEventListener('click', generateDocument);
    }
    
    if (exportCancelBtn) {
        exportCancelBtn.addEventListener('click', () => {
            const modal = document.getElementById('export-modal');
            if (modal) modal.classList.remove('visible');
        });
    }
}

// Generate document based on user selection
async function generateDocument() {
    const exportFormat = document.getElementById('export-format').value;
    const documentTitle = document.getElementById('document-title').value || '802.1X Configuration Document';
    
    // Get export options
    const includeConfig = document.getElementById('export-configuration').checked;
    const includeDiagram = document.getElementById('export-diagram').checked;
    const includeChecklist = document.getElementById('export-checklist').checked;
    const includeTimeline = document.getElementById('export-timeline').checked;
    const includeBestPractices = document.getElementById('export-best-practices').checked;
    const includeTroubleshooting = document.getElementById('export-troubleshooting').checked;
    
    // Get configuration and settings
    const configOutput = document.getElementById('config-output').textContent;
    const settings = collectFormSettings();
    
    // Get selected vendor and platform
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    let selectedVendor = 'unknown';
    
    vendorContainers.forEach(container => {
        if (container.classList.contains('selected')) {
            selectedVendor = container.getAttribute('data-vendor');
        }
    });
    
    const platformSelect = document.getElementById('platform-select');
    const platform = platformSelect ? platformSelect.value : 'unknown';
    
    // Show loading message
    showAlert('Generating document...', 'info');
    
    // Generate different document types based on format
    try {
        switch (exportFormat) {
            case 'pdf':
                await generatePdfDocument(documentTitle, configOutput, settings, selectedVendor, platform, {
                    includeConfig,
                    includeDiagram,
                    includeChecklist,
                    includeTimeline,
                    includeBestPractices,
                    includeTroubleshooting
                });
                break;
            case 'word':
                generateWordDocument(documentTitle, configOutput, settings, selectedVendor, platform, {
                    includeConfig,
                    includeDiagram,
                    includeChecklist,
                    includeTimeline,
                    includeBestPractices,
                    includeTroubleshooting
                });
                break;
            case 'powerpoint':
                generatePowerPointDocument(documentTitle, configOutput, settings, selectedVendor, platform, {
                    includeConfig,
                    includeDiagram,
                    includeChecklist,
                    includeTimeline,
                    includeBestPractices,
                    includeTroubleshooting
                });
                break;
            case 'html':
                generateHtmlDocument(documentTitle, configOutput, settings, selectedVendor, platform, {
                    includeConfig,
                    includeDiagram,
                    includeChecklist,
                    includeTimeline,
                    includeBestPractices,
                    includeTroubleshooting
                });
                break;
            case 'text':
                generateTextDocument(documentTitle, configOutput, settings, selectedVendor, platform, {
                    includeConfig,
                    includeDiagram,
                    includeChecklist,
                    includeTimeline,
                    includeBestPractices,
                    includeTroubleshooting
                });
                break;
            default:
                throw new Error('Unsupported document format');
        }
        
        // Hide export modal
        const modal = document.getElementById('export-modal');
        if (modal) modal.classList.remove('visible');
        
        showAlert(`${exportFormat.toUpperCase()} document generated successfully!`, 'success');
    } catch (error) {
        console.error('Error generating document:', error);
        showAlert(`Error generating document: ${error.message}`, 'danger');
    }
}

// Generate PDF document
async function generatePdfDocument(title, config, settings, vendor, platform, options) {
    // Check if jsPDF is available
    if (typeof jspdf === 'undefined' || typeof jspdf.jsPDF === 'undefined') {
        throw new Error('jsPDF library is not available. Please check your connection and try again.');
    }
    
    try {
        // Create new jsPDF instance
        const { jsPDF } = jspdf;
        const doc = new jsPDF();
        
        // Set document properties
        doc.setProperties({
            title: title,
            subject: `802.1X Configuration for ${vendor.toUpperCase()} ${platform.toUpperCase()}`,
            author: 'Dot1Xer Supreme Enterprise Edition',
            keywords: '802.1X, Configuration, Network Security',
            creator: 'Dot1Xer Supreme Enterprise Edition v4.1.0'
        });
        
        // Add title
        doc.setFontSize(24);
        doc.text(title, 105, 20, { align: 'center' });
        
        // Add date
        doc.setFontSize(12);
        doc.text(`Generated: ${new Date().toLocaleDateString()}`, 105, 30, { align: 'center' });
        
        // Add vendor and platform info
        doc.text(`Vendor: ${vendor.toUpperCase()}`, 105, 40, { align: 'center' });
        doc.text(`Platform: ${platform.toUpperCase()}`, 105, 50, { align: 'center' });
        
        // Add line
        doc.setLineWidth(0.5);
        doc.line(20, 55, 190, 55);
        
        let yPosition = 65;
        
        // Add table of contents
        doc.setFontSize(16);
        doc.text('Table of Contents', 20, yPosition);
        yPosition += 10;
        
        doc.setFontSize(12);
        let tocItems = [];
        
        if (options.includeConfig) tocItems.push('1. Configuration');
        if (options.includeChecklist) tocItems.push('2. Deployment Checklist');
        if (options.includeTimeline) tocItems.push('3. Deployment Timeline');
        if (options.includeBestPractices) tocItems.push('4. Best Practices');
        if (options.includeTroubleshooting) tocItems.push('5. Troubleshooting Guide');
        
        // Add TOC items
        tocItems.forEach((item, index) => {
            doc.text(item, 25, yPosition + (index * 8));
        });
        
        yPosition += (tocItems.length * 8) + 10;
        
        // Add configuration if selected
        if (options.includeConfig) {
            // Add page break if needed
            if (yPosition > 250) {
                doc.addPage();
                yPosition = 20;
            }
            
            doc.setFontSize(16);
            doc.text('1. Configuration', 20, yPosition);
            yPosition += 10;
            
            // Format configuration (split into lines)
            const configLines = config.split('\n');
            
            doc.setFontSize(10);
            doc.setFont('courier');
            
            configLines.forEach(line => {
                // Check if we need a new page
                if (yPosition > 280) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                // Truncate long lines
                const truncatedLine = line.length > 90 ? line.substring(0, 87) + '...' : line;
                doc.text(truncatedLine, 20, yPosition);
                yPosition += 5;
            });
            
            doc.setFont('helvetica');
            yPosition += 10;
        }
        
        // Add deployment checklist if selected
        if (options.includeChecklist) {
            // Add page break
            doc.addPage();
            yPosition = 20;
            
            doc.setFontSize(16);
            doc.text('2. Deployment Checklist', 20, yPosition);
            yPosition += 10;
            
            // Add checklist items
            doc.setFontSize(12);
            
            const checklistItems = getDeploymentChecklistItems(vendor, platform);
            
            checklistItems.forEach((item, index) => {
                // Check if we need a new page
                if (yPosition > 280) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                doc.text(`? ${item}`, 25, yPosition);
                yPosition += 8;
            });
            
            yPosition += 10;
        }
        
        // Add deployment timeline if selected
        if (options.includeTimeline) {
            // Add page break
            doc.addPage();
            yPosition = 20;
            
            doc.setFontSize(16);
            doc.text('3. Deployment Timeline', 20, yPosition);
            yPosition += 10;
            
            // Add timeline
            doc.setFontSize(12);
            
            const timelineItems = [
                { phase: 'Planning Phase', duration: '2-4 weeks', tasks: ['Network assessment', 'Device inventory', 'RADIUS server setup', 'Policy definition'] },
                { phase: 'Monitor Mode', duration: `${settings.phase1Duration || 30} days`, tasks: ['Enable 802.1X in monitor mode', 'Collect authentication data', 'Identify problematic devices', 'Resolve client issues'] },
                { phase: 'Low Impact Mode', duration: `${settings.phase2Duration || 15} days`, tasks: ['Enable authentication with guest VLAN', 'Configure MAB for non-802.1X devices', 'User communication', 'Help desk training'] },
                { phase: 'Full Enforcement', duration: 'Ongoing', tasks: ['Deploy closed mode', 'Regular monitoring', 'Periodic review', 'Ongoing maintenance'] }
            ];
            
            timelineItems.forEach((item, index) => {
                // Check if we need a new page
                if (yPosition > 260) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                doc.setFontSize(14);
                doc.text(`Phase ${index + 1}: ${item.phase}`, 25, yPosition);
                yPosition += 8;
                
                doc.setFontSize(12);
                doc.text(`Duration: ${item.duration}`, 30, yPosition);
                yPosition += 8;
                
                doc.text('Tasks:', 30, yPosition);
                yPosition += 6;
                
                item.tasks.forEach(task => {
                    doc.text(`• ${task}`, 35, yPosition);
                    yPosition += 6;
                });
                
                yPosition += 10;
            });
        }
        
        // Add best practices if selected
        if (options.includeBestPractices) {
            // Add page break
            doc.addPage();
            yPosition = 20;
            
            doc.setFontSize(16);
            doc.text('4. Best Practices', 20, yPosition);
            yPosition += 10;
            
            // Add best practices
            doc.setFontSize(12);
            
            const bestPractices = getBestPractices(vendor, platform);
            
            bestPractices.forEach((practice, index) => {
                // Check if we need a new page
                if (yPosition > 270) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                doc.setFontSize(13);
                doc.text(`${index + 1}. ${practice.title}`, 25, yPosition);
                yPosition += 7;
                
                doc.setFontSize(11);
                
                // Split description into multiple lines if needed
                const descLines = doc.splitTextToSize(practice.description, 160);
                descLines.forEach(line => {
                    doc.text(line, 30, yPosition);
                    yPosition += 6;
                });
                
                yPosition += 5;
            });
        }
        
        // Add troubleshooting guide if selected
        if (options.includeTroubleshooting) {
            // Add page break
            doc.addPage();
            yPosition = 20;
            
            doc.setFontSize(16);
            doc.text('5. Troubleshooting Guide', 20, yPosition);
            yPosition += 10;
            
            // Add troubleshooting items
            doc.setFontSize(12);
            
            const troubleshootingItems = getTroubleshootingGuide(vendor, platform);
            
            troubleshootingItems.forEach((item, index) => {
                // Check if we need a new page
                if (yPosition > 250) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                doc.setFontSize(13);
                doc.text(`${index + 1}. Problem: ${item.problem}`, 25, yPosition);
                yPosition += 7;
                
                doc.setFontSize(11);
                doc.text('Possible Causes:', 30, yPosition);
                yPosition += 6;
                
                item.causes.forEach(cause => {
                    const causeLines = doc.splitTextToSize(`• ${cause}`, 155);
                    causeLines.forEach(line => {
                        doc.text(line, 35, yPosition);
                        yPosition += 5;
                    });
                });
                
                yPosition += 3;
                doc.text('Solution:', 30, yPosition);
                yPosition += 6;
                
                const solutionLines = doc.splitTextToSize(item.solution, 155);
                solutionLines.forEach(line => {
                    doc.text(line, 35, yPosition);
                    yPosition += 5;
                });
                
                yPosition += 10;
            });
        }
        
        // Add footer to all pages
        const pageCount = doc.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(10);
            doc.text(`Dot1Xer Supreme Enterprise Edition v4.1.0 - Page ${i} of ${pageCount}`, 105, 290, { align: 'center' });
        }
        
        // Save the PDF
        const filename = `${title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}-${vendor}-${platform}.pdf`;
        doc.save(filename);
        
    } catch (error) {
        console.error('Error generating PDF:', error);
        throw new Error(`PDF generation failed: ${error.message}`);
    }
}

// Generate Word document (simulated as HTML download)
function generateWordDocument(title, config, settings, vendor, platform, options) {
    try {
        // Create HTML content that could be pasted into Word
        let htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>${title}</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 40px; }
                h1 { color: #1a3a5f; }
                h2 { color: #0077cc; margin-top: 30px; }
                h3 { margin-top: 20px; }
                .config { font-family: Consolas, Monaco, monospace; background-color: #f5f5f5; padding: 15px; white-space: pre-wrap; }
                .checklist-item { margin: 10px 0; }
                .timeline-phase { margin: 20px 0; }
                .best-practice { margin: 20px 0; }
                .troubleshooting-item { margin: 20px 0; }
                .footer { margin-top: 50px; text-align: center; font-size: 0.8em; color: #666; }
            </style>
        </head>
        <body>
            <h1>${title}</h1>
            <p>Generated: ${new Date().toLocaleDateString()}</p>
            <p>Vendor: ${vendor.toUpperCase()}</p>
            <p>Platform: ${platform.toUpperCase()}</p>
            
            <h2>Table of Contents</h2>
            <ol>
                ${options.includeConfig ? '<li><a href="#configuration">Configuration</a></li>' : ''}
                ${options.includeChecklist ? '<li><a href="#checklist">Deployment Checklist</a></li>' : ''}
                ${options.includeTimeline ? '<li><a href="#timeline">Deployment Timeline</a></li>' : ''}
                ${options.includeBestPractices ? '<li><a href="#best-practices">Best Practices</a></li>' : ''}
                ${options.includeTroubleshooting ? '<li><a href="#troubleshooting">Troubleshooting Guide</a></li>' : ''}
            </ol>
        `;
        
        // Add configuration if selected
        if (options.includeConfig) {
            htmlContent += `
                <h2 id="configuration">1. Configuration</h2>
                <div class="config">${config.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\n/g, '<br>')}</div>
            `;
        }
        
        // Add deployment checklist if selected
        if (options.includeChecklist) {
            htmlContent += `
                <h2 id="checklist">2. Deployment Checklist</h2>
            `;
            
            const checklistItems = getDeploymentChecklistItems(vendor, platform);
            
            checklistItems.forEach(item => {
                htmlContent += `
                    <div class="checklist-item">
                        <input type="checkbox"> ${item}
                    </div>
                `;
            });
        }
        
        // Add deployment timeline if selected
        if (options.includeTimeline) {
            htmlContent += `
                <h2 id="timeline">3. Deployment Timeline</h2>
            `;
            
            const timelineItems = [
                { phase: 'Planning Phase', duration: '2-4 weeks', tasks: ['Network assessment', 'Device inventory', 'RADIUS server setup', 'Policy definition'] },
                { phase: 'Monitor Mode', duration: `${settings.phase1Duration || 30} days`, tasks: ['Enable 802.1X in monitor mode', 'Collect authentication data', 'Identify problematic devices', 'Resolve client issues'] },
                { phase: 'Low Impact Mode', duration: `${settings.phase2Duration || 15} days`, tasks: ['Enable authentication with guest VLAN', 'Configure MAB for non-802.1X devices', 'User communication', 'Help desk training'] },
                { phase: 'Full Enforcement', duration: 'Ongoing', tasks: ['Deploy closed mode', 'Regular monitoring', 'Periodic review', 'Ongoing maintenance'] }
            ];
            
            timelineItems.forEach((item, index) => {
                htmlContent += `
                    <div class="timeline-phase">
                        <h3>Phase ${index + 1}: ${item.phase}</h3>
                        <p><strong>Duration:</strong> ${item.duration}</p>
                        <p><strong>Tasks:</strong></p>
                        <ul>
                            ${item.tasks.map(task => `<li>${task}</li>`).join('')}
                        </ul>
                    </div>
                `;
            });
        }
        
        // Add best practices if selected
        if (options.includeBestPractices) {
            htmlContent += `
                <h2 id="best-practices">4. Best Practices</h2>
            `;
            
            const bestPractices = getBestPractices(vendor, platform);
            
            bestPractices.forEach((practice, index) => {
                htmlContent += `
                    <div class="best-practice">
                        <h3>${index + 1}. ${practice.title}</h3>
                        <p>${practice.description}</p>
                    </div>
                `;
            });
        }
        
        // Add troubleshooting guide if selected
        if (options.includeTroubleshooting) {
            htmlContent += `
                <h2 id="troubleshooting">5. Troubleshooting Guide</h2>
            `;
            
            const troubleshootingItems = getTroubleshootingGuide(vendor, platform);
            
            troubleshootingItems.forEach((item, index) => {
                htmlContent += `
                    <div class="troubleshooting-item">
                        <h3>${index + 1}. Problem: ${item.problem}</h3>
                        <p><strong>Possible Causes:</strong></p>
                        <ul>
                            ${item.causes.map(cause => `<li>${cause}</li>`).join('')}
                        </ul>
                        <p><strong>Solution:</strong></p>
                        <p>${item.solution}</p>
                    </div>
                `;
            });
        }
        
        // Add footer
        htmlContent += `
            <div class="footer">
                <p>Generated by Dot1Xer Supreme Enterprise Edition v4.1.0</p>
            </div>
        </body>
        </html>
        `;
        
        // Download HTML file that can be opened in Word
        const blob = new Blob([htmlContent], { type: 'text/html' });
        const filename = `${title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}-${vendor}-${platform}.html`;
        
        if (window.saveAs) {
            // Use FileSaver.js if available
            saveAs(blob, filename);
        } else {
            // Fallback to manual download
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
        }
    } catch (error) {
        console.error('Error generating Word document:', error);
        throw new Error(`Word document generation failed: ${error.message}`);
    }
}

// Generate PowerPoint document (simulated as HTML download)
function generatePowerPointDocument(title, config, settings, vendor, platform, options) {
    try {
        // Create HTML content that simulates PowerPoint slides
        let htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <title>${title} - Presentation</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 0; padding: 0; background-color: #f0f0f0; }
                .slide { width: 800px; height: 600px; background-color: white; margin: 20px auto; padding: 50px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); page-break-after: always; }
                .title { color: #1a3a5f; font-size: 36px; margin-bottom: 20px; }
                .subtitle { color: #0077cc; font-size: 24px; margin-bottom: 40px; }
                .content { font-size: 20px; line-height: 1.5; }
                .footer { position: absolute; bottom: 20px; right: 20px; font-size: 14px; color: #666; }
                .code { font-family: Consolas, Monaco, monospace; font-size: 14px; background-color: #f5f5f5; padding: 15px; overflow: auto; max-height: 400px; }
                ul, ol { font-size: 20px; margin-left: 30px; }
                li { margin-bottom: 15px; }
                .slide-number { position: absolute; bottom: 20px; left: 20px; font-size: 14px; color: #666; }
            </style>
        </head>
        <body>
            <!-- Title Slide -->
            <div class="slide">
                <div class="title" style="font-size: 48px; margin-top: 200px; text-align: center;">${title}</div>
                <div class="subtitle" style="text-align: center;">802.1X Deployment for ${vendor.toUpperCase()} ${platform.toUpperCase()}</div>
                <div style="text-align: center; margin-top: 100px;">Generated: ${new Date().toLocaleDateString()}</div>
                <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                <div class="slide-number">1</div>
            </div>
            
            <!-- Overview Slide -->
            <div class="slide">
                <div class="title">Overview</div>
                <div class="content">
                    <ul>
                        ${options.includeConfig ? '<li>802.1X Configuration</li>' : ''}
                        ${options.includeChecklist ? '<li>Deployment Checklist</li>' : ''}
                        ${options.includeTimeline ? '<li>Deployment Timeline</li>' : ''}
                        ${options.includeBestPractices ? '<li>Best Practices</li>' : ''}
                        ${options.includeTroubleshooting ? '<li>Troubleshooting Tips</li>' : ''}
                    </ul>
                </div>
                <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                <div class="slide-number">2</div>
            </div>
        `;
        
        let slideNumber = 3;
        
        // Add configuration slides if selected
        if (options.includeConfig) {
            htmlContent += `
                <div class="slide">
                    <div class="title">802.1X Configuration</div>
                    <div class="content">
                        <p>Key Configuration Parameters:</p>
                        <ul>
                            <li>Vendor: ${vendor.toUpperCase()}</li>
                            <li>Platform: ${platform.toUpperCase()}</li>
                            <li>Authentication Method: ${settings.authMethod}</li>
                            <li>Host Mode: ${settings.hostMode}</li>
                            <li>VLAN Assignment: ${settings.vlanAuth ? `VLAN ${settings.vlanAuth}` : 'Not specified'}</li>
                        </ul>
                    </div>
                    <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                    <div class="slide-number">${slideNumber++}</div>
                </div>
                
                <div class="slide">
                    <div class="title">Configuration Preview</div>
                    <div class="code" style="font-size: 12px; max-height: 400px; overflow: auto;">${config.replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/\n/g, '<br>')}</div>
                    <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                    <div class="slide-number">${slideNumber++}</div>
                </div>
            `;
        }
        
        // Add deployment checklist if selected
        if (options.includeChecklist) {
            const checklistItems = getDeploymentChecklistItems(vendor, platform);
            
            // Split checklist items into multiple slides if needed
            const itemsPerSlide = 6;
            const checklistSlides = Math.ceil(checklistItems.length / itemsPerSlide);
            
            for (let i = 0; i < checklistSlides; i++) {
                const startIndex = i * itemsPerSlide;
                const endIndex = Math.min(startIndex + itemsPerSlide, checklistItems.length);
                const slideItems = checklistItems.slice(startIndex, endIndex);
                
                htmlContent += `
                    <div class="slide">
                        <div class="title">Deployment Checklist ${checklistSlides > 1 ? `(${i + 1}/${checklistSlides})` : ''}</div>
                        <div class="content">
                            <ul style="list-style-type: square;">
                                ${slideItems.map(item => `<li>${item}</li>`).join('')}
                            </ul>
                        </div>
                        <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                        <div class="slide-number">${slideNumber++}</div>
                    </div>
                `;
            }
        }
        
        // Add deployment timeline if selected
        if (options.includeTimeline) {
            const timelineItems = [
                { phase: 'Planning Phase', duration: '2-4 weeks', tasks: ['Network assessment', 'Device inventory', 'RADIUS server setup', 'Policy definition'] },
                { phase: 'Monitor Mode', duration: `${settings.phase1Duration || 30} days`, tasks: ['Enable 802.1X in monitor mode', 'Collect authentication data', 'Identify problematic devices', 'Resolve client issues'] },
                { phase: 'Low Impact Mode', duration: `${settings.phase2Duration || 15} days`, tasks: ['Enable authentication with guest VLAN', 'Configure MAB for non-802.1X devices', 'User communication', 'Help desk training'] },
                { phase: 'Full Enforcement', duration: 'Ongoing', tasks: ['Deploy closed mode', 'Regular monitoring', 'Periodic review', 'Ongoing maintenance'] }
            ];
            
            htmlContent += `
                <div class="slide">
                    <div class="title">Deployment Timeline</div>
                    <div class="content">
                        <p>A phased approach to 802.1X deployment:</p>
                    </div>
                    <div style="display: flex; flex-direction: row; justify-content: space-between; margin-top: 30px;">
                        ${timelineItems.map((item, index) => `
                            <div style="width: 23%; background-color: ${index === 0 ? '#d1e7ff' : index === 1 ? '#d1ffe7' : index === 2 ? '#fff8d1' : '#ffd1d1'}; padding: 15px; border-radius: 5px;">
                                <h3 style="margin-top: 0; font-size: 18px;">Phase ${index + 1}: ${item.phase}</h3>
                                <p style="font-size: 16px;">${item.duration}</p>
                            </div>
                        `).join('')}
                    </div>
                    <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                    <div class="slide-number">${slideNumber++}</div>
                </div>
            `;
            
            // Add individual phase slides
            timelineItems.forEach((item, index) => {
                htmlContent += `
                    <div class="slide">
                        <div class="title">Phase ${index + 1}: ${item.phase}</div>
                        <div class="content">
                            <p><strong>Duration:</strong> ${item.duration}</p>
                            <p><strong>Key Tasks:</strong></p>
                            <ul>
                                ${item.tasks.map(task => `<li>${task}</li>`).join('')}
                            </ul>
                        </div>
                        <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                        <div class="slide-number">${slideNumber++}</div>
                    </div>
                `;
            });
        }
        
        // Add best practices if selected
        if (options.includeBestPractices) {
            const bestPractices = getBestPractices(vendor, platform);
            
            // Take only first 6 best practices for presentation
            const presentationPractices = bestPractices.slice(0, 6);
            
            htmlContent += `
                <div class="slide">
                    <div class="title">Best Practices</div>
                    <div class="content">
                        <ul>
                            ${presentationPractices.map(practice => `<li>${practice.title}</li>`).join('')}
                        </ul>
                    </div>
                    <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                    <div class="slide-number">${slideNumber++}</div>
                </div>
            `;
            
            // Add individual best practice slides
            presentationPractices.forEach((practice, index) => {
                htmlContent += `
                    <div class="slide">
                        <div class="title">Best Practice: ${practice.title}</div>
                        <div class="content">
                            <p>${practice.description}</p>
                        </div>
                        <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                        <div class="slide-number">${slideNumber++}</div>
                    </div>
                `;
            });
        }
        
        // Add troubleshooting guide if selected
        if (options.includeTroubleshooting) {
            const troubleshootingItems = getTroubleshootingGuide(vendor, platform);
            
            // Take only first 5 troubleshooting items for presentation
            const presentationItems = troubleshootingItems.slice(0, 5);
            
            htmlContent += `
                <div class="slide">
                    <div class="title">Troubleshooting Guide</div>
                    <div class="content">
                        <p>Common issues and solutions:</p>
                        <ul>
                            ${presentationItems.map(item => `<li>${item.problem}</li>`).join('')}
                        </ul>
                    </div>
                    <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                    <div class="slide-number">${slideNumber++}</div>
                </div>
            `;
            
            // Add first few troubleshooting items as individual slides
            presentationItems.slice(0, 3).forEach((item, index) => {
                htmlContent += `
                    <div class="slide">
                        <div class="title">Troubleshooting: ${item.problem}</div>
                        <div class="content">
                            <p><strong>Possible Causes:</strong></p>
                            <ul>
                                ${item.causes.map(cause => `<li style="margin-bottom: 10px;">${cause}</li>`).join('')}
                            </ul>
                            <p><strong>Solution:</strong></p>
                            <p>${item.solution}</p>
                        </div>
                        <div class="footer">Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                        <div class="slide-number">${slideNumber++}</div>
                    </div>
                `;
            });
        }
        
        // Add final slide
        htmlContent += `
            <div class="slide">
                <div class="title" style="text-align: center; margin-top: 200px;">Thank You</div>
                <div class="subtitle" style="text-align: center;">802.1X Deployment</div>
                <div style="text-align: center; margin-top: 50px;">Generated by Dot1Xer Supreme Enterprise Edition v4.1.0</div>
                <div class="slide-number">${slideNumber++}</div>
            </div>
        </body>
        </html>
        `;
        
        // Download HTML file that can be viewed as a presentation
        const blob = new Blob([htmlContent], { type: 'text/html' });
        const filename = `${title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}-${vendor}-${platform}-presentation.html`;
        
        if (window.saveAs) {
            // Use FileSaver.js if available
            saveAs(blob, filename);
        } else {
            // Fallback to manual download
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
        }
    } catch (error) {
        console.error('Error generating PowerPoint document:', error);
        throw new Error(`PowerPoint document generation failed: ${error.message}`);
    }
}

// Generate HTML document
function generateHtmlDocument(title, config, settings, vendor, platform, options) {
    try {
        // Create HTML content with modern styling
        let htmlContent = `
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${title}</title>
            <style>
                :root {
                    --primary-color: #1a3a5f;
                    --secondary-color: #0077cc;
                    --accent-color: #f8bd1c;
                    --background-color: #f8f9fa;
                    --text-color: #333;
                    --border-color: #ddd;
                    --card-bg: #ffffff;
                    --shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                }
                
                body {
                    font-family: 'Segoe UI', Arial, sans-serif;
                    line-height: 1.6;
                    color: var(--text-color);
                    background-color: var(--background-color);
                    margin: 0;
                    padding: 0;
                }
                
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 20px;
                }
                
                header {
                    background-color: var(--primary-color);
                    color: white;
                    padding: 40px 20px;
                    text-align: center;
                }
                
                h1 {
                    margin: 0;
                    font-size: 2.5rem;
                }
                
                h2 {
                    color: var(--secondary-color);
                    border-bottom: 2px solid var(--secondary-color);
                    padding-bottom: 10px;
                    margin-top: 40px;
                }
                
                h3 {
                    color: var(--primary-color);
                    margin-top: 25px;
                }
                
                .meta-info {
                    background-color: var(--card-bg);
                    border-radius: 5px;
                    box-shadow: var(--shadow);
                    padding: 20px;
                    margin: 20px 0;
                }
                
                .meta-info p {
                    margin: 10px 0;
                }
                
                .config {
                    font-family: Consolas, Monaco, monospace;
                    background-color: #272822;
                    color: #f8f8f2;
                    padding: 20px;
                    border-radius: 5px;
                    overflow-x: auto;
                    white-space: pre;
                    box-shadow: var(--shadow);
                }
                
                .section {
                    background-color: var(--card-bg);
                    border-radius: 5px;
                    box-shadow: var(--shadow);
                    padding: 20px;
                    margin: 20px 0;
                }
                
                .checklist-item {
                    margin: 15px 0;
                    padding-left: 30px;
                    position: relative;
                }
                
                .checklist-item:before {
                    content: "?";
                    position: absolute;
                    left: 0;
                    color: var(--secondary-color);
                }
                
                .timeline {
                    position: relative;
                    margin: 40px 0;
                }
                
                .timeline:before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 20px;
                    height: 100%;
                    width: 4px;
                    background: var(--secondary-color);
                }
                
                .timeline-item {
                    position: relative;
                    margin-left: 50px;
                    padding: 20px;
                    background: white;
                    border-radius: 5px;
                    box-shadow: var(--shadow);
                    margin-bottom: 30px;
                }
                
                .timeline-item:before {
                    content: '';
                    position: absolute;
                    left: -30px;
                    top: 20px;
                    width: 20px;
                    height: 20px;
                    border-radius: 50%;
                    background: var(--secondary-color);
                    border: 4px solid white;
                }
                
                .best-practice {
                    background-color: #f0f7ff;
                    border-left: 4px solid var(--secondary-color);
                    padding: 15px;
                    margin: 20px 0;
                    border-radius: 0 5px 5px 0;
                }
                
                .troubleshooting-item {
                    background-color: #fff7f0;
                    border-radius: 5px;
                    padding: 20px;
                    margin: 20px 0;
                    box-shadow: var(--shadow);
                }
                
                .troubleshooting-item h3 {
                    color: #e67e22;
                    margin-top: 0;
                }
                
                .footer {
                    text-align: center;
                    margin-top: 50px;
                    padding: 20px;
                    color: #666;
                    border-top: 1px solid var(--border-color);
                }
                
                .toc {
                    background-color: var(--card-bg);
                    border-radius: 5px;
                    box-shadow: var(--shadow);
                    padding: 20px;
                    margin: 20px 0;
                }
                
                .toc-item {
                    margin: 8px 0;
                }
                
                .toc-item a {
                    color: var(--secondary-color);
                    text-decoration: none;
                }
                
                .toc-item a:hover {
                    text-decoration: underline;
                }
                
                @media print {
                    body {
                        background: white;
                    }
                    .container {
                        max-width: 100%;
                    }
                    .section, .meta-info, .config, .timeline-item, .best-practice, .troubleshooting-item {
                        box-shadow: none;
                        border: 1px solid #ddd;
                    }
                    .timeline:before {
                        display: none;
                    }
                    .timeline-item:before {
                        display: none;
                    }
                }
            </style>
        </head>
        <body>
            <header>
                <div class="container">
                    <h1>${title}</h1>
                    <p>802.1X Deployment Documentation</p>
                </div>
            </header>
            
            <div class="container">
                <div class="meta-info">
                    <p><strong>Generated:</strong> ${new Date().toLocaleDateString()}</p>
                    <p><strong>Vendor:</strong> ${vendor.toUpperCase()}</p>
                    <p><strong>Platform:</strong> ${platform.toUpperCase()}</p>
                    <p><strong>Authentication Method:</strong> ${settings.authMethod}</p>
                    <p><strong>Host Mode:</strong> ${settings.hostMode}</p>
                </div>
                
                <div class="toc">
                    <h2 id="toc">Table of Contents</h2>
                    <div class="toc-item"><a href="#overview">1. Overview</a></div>
                    ${options.includeConfig ? '<div class="toc-item"><a href="#configuration">2. Configuration</a></div>' : ''}
                    ${options.includeChecklist ? `<div class="toc-item"><a href="#checklist">${options.includeConfig ? '3' : '2'}. Deployment Checklist</a></div>` : ''}
                    ${options.includeTimeline ? `<div class="toc-item"><a href="#timeline">${options.includeConfig && options.includeChecklist ? '4' : options.includeConfig || options.includeChecklist ? '3' : '2'}. Deployment Timeline</a></div>` : ''}
                    ${options.includeBestPractices ? `<div class="toc-item"><a href="#best-practices">${(options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + 2}. Best Practices</a></div>` : ''}
                    ${options.includeTroubleshooting ? `<div class="toc-item"><a href="#troubleshooting">${(options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + (options.includeBestPractices ? 1 : 0) + 2}. Troubleshooting Guide</a></div>` : ''}
                </div>
                
                <div class="section">
                    <h2 id="overview">1. Overview</h2>
                    <p>This document provides comprehensive information for deploying 802.1X authentication on ${vendor.toUpperCase()} ${platform.toUpperCase()} network devices. It includes configuration commands, deployment guidance, and best practices for a successful implementation.</p>
                    
                    <h3>Key Components</h3>
                    <ul>
                        <li><strong>Authentication Method:</strong> ${settings.authMethod === 'dot1x' ? '802.1X Only' : 
                            settings.authMethod === 'mab' ? 'MAC Authentication Bypass Only' : 
                            settings.authMethod === 'dot1x-mab' ? '802.1X with MAB Fallback' : 
                            settings.authMethod === 'concurrent' ? '802.1X and MAB Concurrent' : 
                            '802.1X + MAB + WebAuth'}</li>
                        <li><strong>Authentication Mode:</strong> ${settings.authMode === 'open' ? 'Open (Monitor Mode)' : 'Closed (Enforced Mode)'}</li>
                        <li><strong>Host Mode:</strong> ${settings.hostMode === 'multi-auth' ? 'Multi-Auth (Multiple Devices)' : 
                            settings.hostMode === 'multi-domain' ? 'Multi-Domain (1 Data + 1 Voice)' : 
                            settings.hostMode === 'single-host' ? 'Single-Host (1 Device Total)' : 
                            'Multi-Host (1 Auth, Multiple Devices)'}</li>
                        <li><strong>RADIUS Server:</strong> ${settings.radiusServer || 'Not specified'}</li>
                        <li><strong>Auth VLAN:</strong> ${settings.vlanAuth || 'Not specified'}</li>
                    </ul>
                </div>
        `;
        
        // Add configuration if selected
        if (options.includeConfig) {
            htmlContent += `
                <div class="section">
                    <h2 id="configuration">2. Configuration</h2>
                    <p>The following configuration commands should be applied to your ${vendor.toUpperCase()} ${platform.toUpperCase()} network device.</p>
                    <div class="config">${config.replace(/</g, '&lt;').replace(/>/g, '&gt;')}</div>
                </div>
            `;
        }
        
        // Add deployment checklist if selected
        if (options.includeChecklist) {
            const checklistItems = getDeploymentChecklistItems(vendor, platform);
            let checklistNumber = options.includeConfig ? 3 : 2;
            
            htmlContent += `
                <div class="section">
                    <h2 id="checklist">${checklistNumber}. Deployment Checklist</h2>
                    <p>Follow this checklist to ensure a successful 802.1X deployment:</p>
                    
                    <div class="checklist">
            `;
            
            checklistItems.forEach(item => {
                htmlContent += `<div class="checklist-item">${item}</div>`;
            });
            
            htmlContent += `
                    </div>
                </div>
            `;
        }
        
        // Add deployment timeline if selected
        if (options.includeTimeline) {
            const timelineItems = [
                { phase: 'Planning Phase', duration: '2-4 weeks', tasks: ['Network assessment', 'Device inventory', 'RADIUS server setup', 'Policy definition'] },
                { phase: 'Monitor Mode', duration: `${settings.phase1Duration || 30} days`, tasks: ['Enable 802.1X in monitor mode', 'Collect authentication data', 'Identify problematic devices', 'Resolve client issues'] },
                { phase: 'Low Impact Mode', duration: `${settings.phase2Duration || 15} days`, tasks: ['Enable authentication with guest VLAN', 'Configure MAB for non-802.1X devices', 'User communication', 'Help desk training'] },
                { phase: 'Full Enforcement', duration: 'Ongoing', tasks: ['Deploy closed mode', 'Regular monitoring', 'Periodic review', 'Ongoing maintenance'] }
            ];
            
            let timelineNumber = (options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + 2;
            
            htmlContent += `
                <div class="section">
                    <h2 id="timeline">${timelineNumber}. Deployment Timeline</h2>
                    <p>A phased approach is recommended for 802.1X deployment to minimize disruption and ensure success:</p>
                    
                    <div class="timeline">
            `;
            
            timelineItems.forEach((item, index) => {
                htmlContent += `
                    <div class="timeline-item">
                        <h3>Phase ${index + 1}: ${item.phase}</h3>
                        <p><strong>Duration:</strong> ${item.duration}</p>
                        <p><strong>Key Tasks:</strong></p>
                        <ul>
                            ${item.tasks.map(task => `<li>${task}</li>`).join('')}
                        </ul>
                    </div>
                `;
            });
            
            htmlContent += `
                    </div>
                </div>
            `;
        }
        
        // Add best practices if selected
        if (options.includeBestPractices) {
            const bestPractices = getBestPractices(vendor, platform);
            let bpNumber = (options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + 2;
            
            htmlContent += `
                <div class="section">
                    <h2 id="best-practices">${bpNumber}. Best Practices</h2>
                    <p>Follow these best practices for a secure and robust 802.1X deployment:</p>
            `;
            
            bestPractices.forEach((practice, index) => {
                htmlContent += `
                    <div class="best-practice">
                        <h3>${index + 1}. ${practice.title}</h3>
                        <p>${practice.description}</p>
                    </div>
                `;
            });
            
            htmlContent += `
                </div>
            `;
        }
        
        // Add troubleshooting guide if selected
        if (options.includeTroubleshooting) {
            const troubleshootingItems = getTroubleshootingGuide(vendor, platform);
            let tsNumber = (options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + (options.includeBestPractices ? 1 : 0) + 2;
            
            htmlContent += `
                <div class="section">
                    <h2 id="troubleshooting">${tsNumber}. Troubleshooting Guide</h2>
                    <p>Use this guide to troubleshoot common issues during 802.1X deployment:</p>
            `;
            
            troubleshootingItems.forEach((item, index) => {
                htmlContent += `
                    <div class="troubleshooting-item">
                        <h3>${index + 1}. Problem: ${item.problem}</h3>
                        <p><strong>Possible Causes:</strong></p>
                        <ul>
                            ${item.causes.map(cause => `<li>${cause}</li>`).join('')}
                        </ul>
                        <p><strong>Solution:</strong></p>
                        <p>${item.solution}</p>
                    </div>
                `;
            });
            
            htmlContent += `
                </div>
            `;
        }
        
        // Add footer
        htmlContent += `
                <div class="footer">
                    <p>Generated by Dot1Xer Supreme Enterprise Edition v4.1.0</p>
                    <p>${new Date().toLocaleDateString()}</p>
                </div>
            </div>
        </body>
        </html>
        `;
        
        // Download HTML file
        const blob = new Blob([htmlContent], { type: 'text/html' });
        const filename = `${title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}-${vendor}-${platform}.html`;
        
        if (window.saveAs) {
            // Use FileSaver.js if available
            saveAs(blob, filename);
        } else {
            // Fallback to manual download
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
        }
    } catch (error) {
        console.error('Error generating HTML document:', error);
        throw new Error(`HTML document generation failed: ${error.message}`);
    }
}

// Generate text document
function generateTextDocument(title, config, settings, vendor, platform, options) {
    try {
        // Create text content
        let textContent = `
${title.toUpperCase()}
${'='.repeat(title.length)}

802.1X Configuration for ${vendor.toUpperCase()} ${platform.toUpperCase()}
Generated: ${new Date().toLocaleDateString()}
Dot1Xer Supreme Enterprise Edition v4.1.0

TABLE OF CONTENTS
----------------
1. Overview
${options.includeConfig ? '2. Configuration\n' : ''}${options.includeChecklist ? `${options.includeConfig ? '3' : '2'}. Deployment Checklist\n` : ''}${options.includeTimeline ? `${(options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + 2}. Deployment Timeline\n` : ''}${options.includeBestPractices ? `${(options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + 2}. Best Practices\n` : ''}${options.includeTroubleshooting ? `${(options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + (options.includeBestPractices ? 1 : 0) + 2}. Troubleshooting Guide\n` : ''}

1. OVERVIEW
-----------
This document provides comprehensive information for deploying 802.1X authentication 
on ${vendor.toUpperCase()} ${platform.toUpperCase()} network devices.

KEY COMPONENTS:
- Authentication Method: ${settings.authMethod === 'dot1x' ? '802.1X Only' : 
    settings.authMethod === 'mab' ? 'MAC Authentication Bypass Only' : 
    settings.authMethod === 'dot1x-mab' ? '802.1X with MAB Fallback' : 
    settings.authMethod === 'concurrent' ? '802.1X and MAB Concurrent' : 
    '802.1X + MAB + WebAuth'}
- Authentication Mode: ${settings.authMode === 'open' ? 'Open (Monitor Mode)' : 'Closed (Enforced Mode)'}
- Host Mode: ${settings.hostMode === 'multi-auth' ? 'Multi-Auth (Multiple Devices)' : 
    settings.hostMode === 'multi-domain' ? 'Multi-Domain (1 Data + 1 Voice)' : 
    settings.hostMode === 'single-host' ? 'Single-Host (1 Device Total)' : 
    'Multi-Host (1 Auth, Multiple Devices)'}
- RADIUS Server: ${settings.radiusServer || 'Not specified'}
- Auth VLAN: ${settings.vlanAuth || 'Not specified'}
`;
        
        // Add configuration if selected
        if (options.includeConfig) {
            textContent += `

2. CONFIGURATION
---------------
The following configuration commands should be applied to your ${vendor.toUpperCase()} ${platform.toUpperCase()} network device.

${config}
`;
        }
        
        // Add deployment checklist if selected
        if (options.includeChecklist) {
            const checklistItems = getDeploymentChecklistItems(vendor, platform);
            let checklistNumber = options.includeConfig ? 3 : 2;
            
            textContent += `

${checklistNumber}. DEPLOYMENT CHECKLIST
${'-'.repeat(String(checklistNumber).length + 21)}
Follow this checklist to ensure a successful 802.1X deployment:

`;
            
            checklistItems.forEach((item, index) => {
                textContent += `[ ] ${index + 1}. ${item}\n`;
            });
        }
        
        // Add deployment timeline if selected
        if (options.includeTimeline) {
            const timelineItems = [
                { phase: 'Planning Phase', duration: '2-4 weeks', tasks: ['Network assessment', 'Device inventory', 'RADIUS server setup', 'Policy definition'] },
                { phase: 'Monitor Mode', duration: `${settings.phase1Duration || 30} days`, tasks: ['Enable 802.1X in monitor mode', 'Collect authentication data', 'Identify problematic devices', 'Resolve client issues'] },
                { phase: 'Low Impact Mode', duration: `${settings.phase2Duration || 15} days`, tasks: ['Enable authentication with guest VLAN', 'Configure MAB for non-802.1X devices', 'User communication', 'Help desk training'] },
                { phase: 'Full Enforcement', duration: 'Ongoing', tasks: ['Deploy closed mode', 'Regular monitoring', 'Periodic review', 'Ongoing maintenance'] }
            ];
            
            let timelineNumber = (options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + 2;
            
            textContent += `

${timelineNumber}. DEPLOYMENT TIMELINE
${'-'.repeat(String(timelineNumber).length + 21)}
A phased approach is recommended for 802.1X deployment to minimize disruption and ensure success:

`;
            
            timelineItems.forEach((item, index) => {
                textContent += `PHASE ${index + 1}: ${item.phase.toUpperCase()}
Duration: ${item.duration}
Key Tasks:
${item.tasks.map(task => `  * ${task}`).join('\n')}

`;
            });
        }
        
        // Add best practices if selected
        if (options.includeBestPractices) {
            const bestPractices = getBestPractices(vendor, platform);
            let bpNumber = (options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + 2;
            
            textContent += `

${bpNumber}. BEST PRACTICES
${'-'.repeat(String(bpNumber).length + 16)}
Follow these best practices for a secure and robust 802.1X deployment:

`;
            
            bestPractices.forEach((practice, index) => {
                textContent += `${index + 1}. ${practice.title.toUpperCase()}
   ${practice.description}

`;
            });
        }
        
        // Add troubleshooting guide if selected
        if (options.includeTroubleshooting) {
            const troubleshootingItems = getTroubleshootingGuide(vendor, platform);
            let tsNumber = (options.includeConfig ? 1 : 0) + (options.includeChecklist ? 1 : 0) + (options.includeTimeline ? 1 : 0) + (options.includeBestPractices ? 1 : 0) + 2;
            
            textContent += `

${tsNumber}. TROUBLESHOOTING GUIDE
${'-'.repeat(String(tsNumber).length + 22)}
Use this guide to troubleshoot common issues during 802.1X deployment:

`;
            
            troubleshootingItems.forEach((item, index) => {
                textContent += `PROBLEM ${index + 1}: ${item.problem}

Possible Causes:
${item.causes.map(cause => `  * ${cause}`).join('\n')}

Solution:
  ${item.solution.replace(/\n/g, '\n  ')}

`;
            });
        }
        
        // Add footer
        textContent += `
--------------------------------------------------------------------------------
Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
${new Date().toLocaleDateString()}
`;
        
        // Download text file
        const blob = new Blob([textContent], { type: 'text/plain' });
        const filename = `${title.replace(/[^a-z0-9]/gi, '_').toLowerCase()}-${vendor}-${platform}.txt`;
        
        if (window.saveAs) {
            // Use FileSaver.js if available
            saveAs(blob, filename);
        } else {
            // Fallback to manual download
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
        }
    } catch (error) {
        console.error('Error generating text document:', error);
        throw new Error(`Text document generation failed: ${error.message}`);
    }
}

// Get deployment checklist items based on vendor
function getDeploymentChecklistItems(vendor, platform) {
    // Common checklist items for all vendors
    const commonItems = [
        'Inventory all network devices and verify 802.1X support',
        'Document existing VLAN assignments and network topology',
        'Deploy and configure RADIUS server(s)',
        'Create and test authentication policies on RADIUS server',
        'Identify devices that cannot support 802.1X and plan for MAB',
        'Configure test switch with 802.1X in monitor mode',
        'Test authentication with sample devices',
        'Prepare user communication plan',
        'Train help desk staff on common 802.1X issues',
        'Create rollback procedure in case of critical issues',
        'Deploy 802.1X in monitor mode across network',
        'Analyze authentication logs and address failures',
        'Configure guest and auth-fail VLANs',
        'Transition to low-impact mode with fallback options',
        'Implement full enforcement on a phased schedule',
        'Document final configuration and deployment results'
    ];
    
    // Vendor-specific checklist items
    const vendorItems = {
        cisco: [
            'Verify IOS/IOS-XE/NX-OS version supports required 802.1X features',
            'Configure AAA new-model on all devices',
            'Test Change of Authorization (CoA) if using ISE',
            'Configure voice VLAN if using IP phones',
            'Test multi-domain authentication for IP phone deployments'
        ],
        aruba: [
            'Verify AOS-CX/AOS-Switch version supports required 802.1X features',
            'Configure ClearPass policy manager if applicable',
            'Test Downloadable User Roles if using ClearPass',
            'Configure device profiling for automated MAB'
        ],
        juniper: [
            'Verify JunOS version supports required 802.1X features',
            'Configure RADIUS server in authentication-order',
            'Test fallback authentication methods',
            'Configure firewall filters if needed'
        ],
        hp: [
            'Verify ProCurve/Comware software supports required features',
            'Configure user roles for different authorization levels',
            'Test LLDP for IP phone detection if applicable'
        ]
    };
    
    // Get vendor-specific items or empty array if vendor not found
    const specificItems = vendorItems[vendor] || [];
    
    // Combine and return all items
    return [...commonItems, ...specificItems];
}

// Get best practices based on vendor
function getBestPractices(vendor, platform) {
    // Common best practices for all vendors
    const commonPractices = [
        {
            title: 'Use a phased deployment approach',
            description: 'Start with monitor mode, then low-impact mode with guest VLAN, and finally full enforcement. This minimizes disruption and helps identify issues early.'
        },
        {
            title: 'Implement RADIUS server redundancy',
            description: 'Configure at least two RADIUS servers for high availability. Set appropriate timeout and retry values to ensure smooth failover.'
        },
        {
            title: 'Use strong RADIUS shared secrets',
            description: 'Implement unique, complex shared secrets for each network device. Avoid using the same shared secret across all devices.'
        },
        {
            title: 'Enable RADIUS accounting',
            description: 'RADIUS accounting provides valuable information for troubleshooting and auditing. Configure accounting to track session starts, stops, and interim updates.'
        },
        {
            title: 'Configure appropriate VLANs',
            description: 'Create separate VLANs for authenticated, unauthenticated, and guest users. This provides proper network segmentation and security.'
        },
        {
            title: 'Implement MAC Authentication Bypass (MAB)',
            description: 'Use MAB for devices that cannot support 802.1X. Maintain a secure database of authorized MAC addresses and regularly audit it.'
        },
        {
            title: 'Enable additional security features',
            description: 'Configure DHCP snooping, Dynamic ARP Inspection, and IP Source Guard alongside 802.1X for comprehensive security.'
        },
        {
            title: 'Document exceptions and special cases',
            description: 'Maintain documentation of all devices exempted from 802.1X or using special configurations like MAB. Regularly review and update this list.'
        }
    ];
    
    // Vendor-specific best practices
    const vendorPractices = {
        cisco: [
            {
                title: 'Use Multi-Domain Authentication for IP phones',
                description: 'When deploying IP phones with computers connected through them, configure multi-domain authentication mode to authorize both devices independently.'
            },
            {
                title: 'Configure Change of Authorization (CoA)',
                description: 'Enable RADIUS CoA to allow dynamic policy changes from the RADIUS server, especially when using Cisco ISE or similar NAC solutions.'
            },
            {
                title: 'Enable MACsec where supported',
                description: 'On hardware that supports it, enable MACsec (802.1AE) to provide Layer 2 encryption between the client and the switch.'
            }
        ],
        aruba: [
            {
                title: 'Use ClearPass for advanced policy management',
                description: 'Leverage Aruba ClearPass features like device profiling, OnGuard, and OnConnect for enhanced authentication and authorization.'
            },
            {
                title: 'Configure Downloadable User Roles',
                description: 'Use RADIUS-assigned user roles to dynamically apply the appropriate permissions to authenticated clients.'
            }
        ],
        juniper: [
            {
                title: 'Configure server-reject VLAN',
                description: 'Use the server-reject-vlan configuration to handle devices that fail authentication rather than completely blocking access.'
            },
            {
                title: 'Implement firewall filters with 802.1X',
                description: 'Use firewall filters in conjunction with 802.1X to provide additional access controls based on authenticated identity.'
            }
        ],
        hp: [
            {
                title: 'Use user roles for authorization',
                description: 'Configure user roles for different types of users and devices to apply appropriate access policies based on RADIUS attributes.'
            },
            {
                title: 'Enable LLDP for voice VLAN detection',
                description: 'Configure LLDP to help identify IP phones and automatically assign them to the voice VLAN.'
            }
        ]
    };
    
    // Get vendor-specific practices or empty array if vendor not found
    const specificPractices = vendorPractices[vendor] || [];
    
    // Combine and return all practices
    return [...commonPractices, ...specificPractices];
}

// Get troubleshooting guide based on vendor
function getTroubleshootingGuide(vendor, platform) {
    // Common troubleshooting items for all vendors
    const commonItems = [
        {
            problem: 'Client fails to authenticate',
            causes: [
                'Supplicant not configured correctly',
                'RADIUS server unreachable',
                'Incorrect shared secret',
                'EAP method mismatch',
                'User credentials invalid'
            ],
            solution: 'Check RADIUS server logs for specific error messages. Verify network connectivity between the switch and RADIUS server. Ensure the shared secret matches on both the switch and RADIUS server. Confirm the client supplicant is configured with the correct EAP method.'
        },
        {
            problem: 'Authentication succeeds but client gets incorrect VLAN',
            causes: [
                'RADIUS attribute format incorrect',
                'VLAN doesn\'t exist on the switch',
                'RADIUS server sending incorrect attributes',
                'Dynamic VLAN assignment not configured properly'
            ],
            solution: 'Verify the RADIUS server is sending the correct VLAN attributes (Tunnel-Type=13, Tunnel-Medium-Type=6, Tunnel-Private-Group-ID=VLAN ID). Ensure the VLAN exists on the switch. Check RADIUS server logs and switch logs for attribute details.'
        },
        {
            problem: 'Intermittent authentication failures',
            causes: [
                'RADIUS server overloaded',
                'Network congestion or latency',
                'Timer values too aggressive',
                'Supplicant timeouts'
            ],
            solution: 'Increase RADIUS server timeout and retry values. Check network latency between the switch and RADIUS server. Adjust the quiet-period and tx-period timers to appropriate values. Consider adding additional RADIUS servers to distribute load.'
        },
        {
            problem: 'Voice VLAN not working with 802.1X',
            causes: [
                'Host mode not set correctly',
                'Voice VLAN not configured',
                'CDP/LLDP not enabled',
                'IP phone not supporting 802.1X'
            ],
            solution: 'Configure multi-domain or multi-auth host mode. Ensure voice VLAN is properly configured. Enable CDP/LLDP for voice VLAN detection. For IP phones without 802.1X support, configure MAB or authentication exemption.'
        },
        {
            problem: 'MAC Authentication Bypass not working',
            causes: [
                'MAC address format mismatch',
                'MAB not enabled on the interface',
                'RADIUS server not configured for MAB',
                'MAC address not in the database'
            ],
            solution: 'Verify the MAC address format sent to the RADIUS server (hyphenated, colon-separated, period-separated, or no delimiter). Ensure MAB is enabled on the interface. Check that the RADIUS server is configured to accept MAC addresses as credentials.'
        },
        {
            problem: 'Clients cannot connect after authentication server failure',
            causes: [
                'Critical VLAN not configured',
                'Secondary RADIUS server not configured',
                'High server deadtime',
                'Server failure detection too slow'
            ],
            solution: 'Configure a critical VLAN to handle authentication server failures. Implement RADIUS server redundancy with appropriate failover settings. Adjust server deadtime to an appropriate value. Test failover scenarios during maintenance windows.'
        },
        {
            problem: 'Guest VLAN not working',
            causes: [
                'Guest VLAN not configured correctly',
                'Auth-fail VLAN confusion',
                'Timeout values incorrect',
                'Client sending EAPOL packets'
            ],
            solution: 'Ensure the guest VLAN is correctly configured and exists on the switch. Note that guest VLAN is for clients that don\'t attempt authentication, while auth-fail VLAN is for failed authentications. Verify the client is not sending any EAPOL packets that would prevent guest VLAN assignment.'
        }
    ];
    
    // Vendor-specific troubleshooting items
    const vendorItems = {
        cisco: [
            {
                problem: 'Authentication fails with "EAP-TLS requires a server certificate"',
                causes: [
                    'Missing or invalid server certificate',
                    'Certificate chain issue',
                    'Mismatched certificate CN/SAN',
                    'Client not trusting the CA'
                ],
                solution: 'Verify the RADIUS server has a valid certificate. Ensure the certificate\'s Common Name (CN) or Subject Alternative Name (SAN) matches the server\'s FQDN. Check that the client trusts the Certificate Authority (CA) that issued the server certificate.'
            },
            {
                problem: 'ISE shows "Endpoint not found" or "Unknown NAD"',
                causes: [
                    'Switch not defined in ISE',
                    'Incorrect IP address',
                    'NAD profile mismatch',
                    'Incorrect shared secret'
                ],
                solution: 'Add the switch to ISE as a Network Access Device (NAD). Verify the switch\'s IP address matches what\'s configured in ISE. Check the shared secret is identical on both the switch and ISE. Ensure the correct device profile is selected in ISE.'
            }
        ],
        aruba: [
            {
                problem: 'ClearPass shows "Authentication failed - RADIUS server rejected request"',
                causes: [
                    'Service rule not matching',
                    'Enforcement policy issue',
                    'Authentication source unavailable',
                    'Role derivation failure'
                ],
                solution: 'Check ClearPass service rules to ensure they match the incoming request. Verify the authentication sources are available and responding. Review enforcement policies and role mappings. Check the ClearPass Access Tracker for detailed failure information.'
            },
            {
                problem: 'Downloadable User Roles not applying correctly',
                causes: [
                    'RADIUS VSAs not configured properly',
                    'User role not defined on the switch',
                    'Attribute format mismatch',
                    'Permission issues'
                ],
                solution: 'Ensure the user role is defined on the switch. Verify ClearPass is sending the correct Vendor-Specific Attributes (VSAs) for role assignment. Check the RADIUS packet capture to see the exact attributes being sent.'
            }
        ],
        juniper: [
            {
                problem: 'Authentication succeeds but traffic is blocked',
                causes: [
                    'Firewall filter blocking traffic',
                    'Incorrect forwarding class assignment',
                    'VLAN interface not up',
                    'Routing issue after authentication'
                ],
                solution: 'Check firewall filters applied to the interface or VLAN. Verify the VLAN interface is up and has the correct IP configuration. Review any QoS configurations that might be affecting traffic. Use "show firewall" commands to verify filter statistics.'
            },
            {
                problem: 'Server-reject-vlan not working',
                causes: [
                    'VLAN not defined on the switch',
                    'Incorrect configuration syntax',
                    'Not supported in current JunOS version',
                    'Conflicting configuration'
                ],
                solution: 'Verify the VLAN exists on the switch. Check JunOS version supports server-reject-vlan. Ensure the configuration syntax is correct for your JunOS version. Use "show dot1x interface detail" to verify the current authentication state.'
            }
        ],
        hp: [
            {
                problem: 'User role not applied after authentication',
                causes: [
                    'Role not defined on the switch',
                    'RADIUS attributes incorrect',
                    'Role derivation rule issue',
                    'Software version limitation'
                ],
                solution: 'Ensure the user role is properly defined on the switch. Verify the RADIUS server is sending the correct attributes for role assignment. Check role derivation rules if configured. Some roles or features might require specific software versions.'
            },
            {
                problem: 'LLDP/CDP not detecting voice devices properly',
                causes: [
                    'LLDP/CDP disabled',
                    'Voice VLAN not configured',
                    'IP phone firmware issue',
                    'Incorrect OUI configuration'
                ],
                solution: 'Enable LLDP and/or CDP on the interfaces. Configure voice VLAN on the switch. Verify the IP phone\'s firmware supports LLDP/CDP for voice VLAN discovery. Check if OUI-based detection is configured correctly if using that method.'
            }
        ]
    };
    
    // Get vendor-specific items or empty array if vendor not found
    const specificItems = vendorItems[vendor] || [];
    
    // Combine and return all items
    return [...commonItems, ...specificItems];
}

// Helper function to collect form settings (simplified version)
function collectFormSettings() {
    // This is a simplified version just for document generation
    // The full version is in config-generator.js
    return {
        authMethod: getSelectValue('auth-method', 'dot1x'),
        authMode: getRadioValue('auth-mode', 'closed'),
        hostMode: getSelectValue('host-mode', 'multi-auth'),
        radiusServer: getInputValue('radius-server-1', ''),
        vlanAuth: getInputValue('vlan-auth', ''),
        vlanUnauth: getInputValue('vlan-unauth', ''),
        vlanGuest: getInputValue('vlan-guest', ''),
        vlanVoice: getInputValue('vlan-voice', ''),
        interface: getInputValue('interface', 'GigabitEthernet1/0/1'),
        deployStrategy: getRadioValue('deploy-strategy', 'monitor'),
        phase1Duration: getInputValue('phase1-duration', '30'),
        phase2Duration: getInputValue('phase2-duration', '15')
    };
}

// Helper functions to get form values (simplified versions)
function getInputValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

function getSelectValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

function getRadioValue(name, defaultValue) {
    const elements = document.getElementsByName(name);
    for (let i = 0; i < elements.length; i++) {
        if (elements[i].checked) {
            return elements[i].value;
        }
    }
    return defaultValue;
}

// Helper function to show alerts (simplified version)
function showAlert(message, type = 'info') {
    console.log(`[${type.toUpperCase()}] ${message}`);
    
    // If there's a global alert function from config-generator.js, use it
    if (typeof window.showAlert === 'function') {
        window.showAlert(message, type);
        return;
    }
    
    // Simple alert fallback
    alert(message);
}
/**
 * Dot1Xer Supreme Enterprise Edition - Diagram Generator
 * Version 4.1.0
 * 
 * This module handles the generation of network diagrams for 802.1X deployments.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Diagram Generator...');
    
    // Set up event handlers
    const generateDiagramButton = document.getElementById('generate-diagram');
    if (generateDiagramButton) {
        generateDiagramButton.addEventListener('click', generateDiagram);
    }
});

// Generate diagram based on selected type
function generateDiagram() {
    const diagramType = document.getElementById('diagram-type').value;
    const diagramDisplay = document.getElementById('diagram-display');
    
    if (!diagramDisplay) return;
    
    // Show loading indicator
    diagramDisplay.innerHTML = '<p>Generating diagram...</p>';
    
    // Get settings for diagram
    const settings = collectDiagramSettings();
    
    // Generate different diagram types
    switch (diagramType) {
        case 'network-topology':
            generateNetworkTopologyDiagram(diagramDisplay, settings);
            break;
        case 'authentication-flow':
            generateAuthenticationFlowDiagram(diagramDisplay, settings);
            break;
        case 'deployment-architecture':
            generateDeploymentArchitectureDiagram(diagramDisplay, settings);
            break;
        case 'radius-communication':
            generateRadiusCommunicationDiagram(diagramDisplay, settings);
            break;
        default:
            diagramDisplay.innerHTML = '<p>Unknown diagram type selected.</p>';
    }
}

// Collect settings for diagram generation
function collectDiagramSettings() {
    // Get vendor and platform
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    let selectedVendor = 'unknown';
    
    vendorContainers.forEach(container => {
        if (container.classList.contains('selected')) {
            selectedVendor = container.getAttribute('data-vendor');
        }
    });
    
    const platformSelect = document.getElementById('platform-select');
    const platform = platformSelect ? platformSelect.value : 'unknown';
    
    // Get relevant settings from form
    return {
        vendor: selectedVendor,
        platform: platform,
        authMethod: getSelectValue('auth-method', 'dot1x'),
        authMode: getRadioValue('auth-mode', 'closed'),
        hostMode: getSelectValue('host-mode', 'multi-auth'),
        radiusServer: getInputValue('radius-server-1', '10.1.1.1'),
        secondaryServer: getInputValue('radius-server-2', ''),
        vlanAuth: getInputValue('vlan-auth', '100'),
        vlanUnauth: getInputValue('vlan-unauth', '999'),
        vlanGuest: getInputValue('vlan-guest', '900'),
        vlanVoice: getInputValue('vlan-voice', '200'),
        interface: getInputValue('interface', 'GigabitEthernet1/0/1'),
        useMab: ['mab', 'dot1x-mab', 'concurrent', 'dot1x-mab-webauth'].includes(getSelectValue('auth-method', 'dot1x')),
        useRadSec: getCheckboxValue('use-radsec', false),
        useCoa: getCheckboxValue('use-coa', true)
    };
}

// Generate Network Topology Diagram
function generateNetworkTopologyDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "500");
    svg.setAttribute("viewBox", "0 0 800 500");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "802.1X Network Topology";
    svg.appendChild(title);
    
    // Add subtitle with vendor information
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = `${settings.vendor.toUpperCase()} ${settings.platform.toUpperCase()} Deployment`;
    svg.appendChild(subtitle);
    
    // Draw network elements
    
    // RADIUS Server(s)
    drawRadiusServer(svg, 650, 200, settings.radiusServer, "Primary RADIUS");
    if (settings.secondaryServer) {
        drawRadiusServer(svg, 650, 300, settings.secondaryServer, "Secondary RADIUS");
    // Network switch
    drawNetworkSwitch(svg, 400, 250, settings);
    
    // Client devices
    if (settings.hostMode === 'single-host') {
        // Single client
        drawClientDevice(svg, 150, 250, "Client Device", "standard");
        drawConnection(svg, 150, 250, 400, 250, "#0077cc", "802.1X");
    } else if (settings.hostMode === 'multi-host') {
        // Multiple clients through one authentication
        drawClientDevice(svg, 150, 200, "Authenticated Client", "standard");
        drawClientDevice(svg, 150, 250, "Piggyback Client", "light");
        drawClientDevice(svg, 150, 300, "Piggyback Client", "light");
        drawConnection(svg, 150, 200, 400, 250, "#0077cc", "802.1X");
        drawConnection(svg, 150, 250, 400, 250, "#999", "Non-auth traffic");
        drawConnection(svg, 150, 300, 400, 250, "#999", "Non-auth traffic");
    } else if (settings.hostMode === 'multi-domain') {
        // Data + voice device
        drawClientDevice(svg, 150, 200, "Data Device", "standard");
        drawClientDevice(svg, 150, 300, "Voice Device", "phone");
        drawConnection(svg, 150, 200, 400, 250, "#0077cc", "802.1X (Data)");
        drawConnection(svg, 150, 300, 400, 250, "#28a745", "802.1X (Voice)");
    } else {
        // Multi-auth (multiple devices)
        drawClientDevice(svg, 100, 150, "Client 1", "standard");
        drawClientDevice(svg, 150, 200, "Client 2", "standard");
        drawClientDevice(svg, 150, 300, "Client 3", "phone");
        drawConnection(svg, 100, 150, 400, 250, "#0077cc", "802.1X");
        drawConnection(svg, 150, 200, 400, 250, "#0077cc", "802.1X");
        drawConnection(svg, 150, 300, 400, 250, "#28a745", "802.1X (Voice)");
    }
    
    // RADIUS connections
    drawConnection(svg, 400, 250, 650, 200, "#dc3545", settings.useRadSec ? "RadSec (TLS)" : "RADIUS");
    if (settings.secondaryServer) {
        drawConnection(svg, 400, 250, 650, 300, "#dc3545", "Failover RADIUS");
    }
    
    // Draw legend
    drawLegend(svg, 50, 400);
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "network-topology");
}

// Generate Authentication Flow Diagram
function generateAuthenticationFlowDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "600");
    svg.setAttribute("viewBox", "0 0 800 600");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "802.1X Authentication Flow";
    svg.appendChild(title);
    
    // Add subtitle with method information
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = getAuthMethodName(settings.authMethod);
    svg.appendChild(subtitle);
    
    // Draw column headers
    const columns = ["Supplicant", "Authenticator", "Authentication Server"];
    const columnX = [150, 400, 650];
    
    columns.forEach((text, index) => {
        const header = document.createElementNS("http://www.w3.org/2000/svg", "text");
        header.setAttribute("x", columnX[index]);
        header.setAttribute("y", "90");
        header.setAttribute("text-anchor", "middle");
        header.setAttribute("font-family", "Arial, sans-serif");
        header.setAttribute("font-size", "16");
        header.setAttribute("font-weight", "bold");
        header.setAttribute("fill", "#333");
        header.textContent = text;
        svg.appendChild(header);
        
        // Draw column vertical lines
        const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", columnX[index]);
        line.setAttribute("y1", "100");
        line.setAttribute("x2", columnX[index]);
        line.setAttribute("y2", "550");
        line.setAttribute("stroke", "#ccc");
        line.setAttribute("stroke-width", "2");
        line.setAttribute("stroke-dasharray", "5,5");
        svg.appendChild(line);
        
        // Draw icons for each column
        if (index === 0) {
            // Supplicant icon
            drawIcon(svg, columnX[index], 130, "laptop");
        } else if (index === 1) {
            // Authenticator icon
            drawIcon(svg, columnX[index], 130, "switch");
        } else {
            // Authentication Server icon
            drawIcon(svg, columnX[index], 130, "server");
        }
    });
    
    // Draw authentication flow arrows and labels
    let startY = 180;
    const stepHeight = 50;
    
    // Standard 802.1X flow
    if (settings.authMethod === 'dot1x' || settings.authMethod === 'dot1x-mab' || 
        settings.authMethod === 'concurrent' || settings.authMethod === 'dot1x-mab-webauth') {
        
        // Link initialization
        drawArrow(svg, columnX[0], startY, columnX[1], startY, "#0077cc");
        drawFlowLabel(svg, "EAPOL-Start", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        // Identity request
        drawArrow(svg, columnX[1], startY, columnX[0], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Request/Identity", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        // Identity response
        drawArrow(svg, columnX[0], startY, columnX[1], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Response/Identity", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        // RADIUS Access-Request
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#dc3545");
        drawFlowLabel(svg, "RADIUS Access-Request", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // EAP challenge (multiple rounds)
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#dc3545");
        drawFlowLabel(svg, "Access-Challenge", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[1], startY, columnX[0], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Request (Challenge)", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[0], startY, columnX[1], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Response", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#dc3545");
        drawFlowLabel(svg, "RADIUS Access-Request", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // Success scenario
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#28a745");
        drawFlowLabel(svg, "Access-Accept + VLAN, ACL, etc.", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[1], startY, columnX[0], startY, "#28a745");
        drawFlowLabel(svg, "EAP-Success", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
    }
    
    // Add MAB flow if applicable
    if (settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || 
        settings.authMethod === 'dot1x-mab-webauth') {
        
        if (settings.authMethod !== 'mab') {
            // Add fallback text
            const fallbackText = document.createElementNS("http://www.w3.org/2000/svg", "text");
            fallbackText.setAttribute("x", "400");
            fallbackText.setAttribute("y", startY + 10);
            fallbackText.setAttribute("text-anchor", "middle");
            fallbackText.setAttribute("font-family", "Arial, sans-serif");
            fallbackText.setAttribute("font-size", "14");
            fallbackText.setAttribute("font-style", "italic");
            fallbackText.setAttribute("fill", "#666");
            fallbackText.textContent = "If 802.1X fails or times out, MAB occurs:";
            svg.appendChild(fallbackText);
            startY += 30;
        }
        
        // MAC address capture
        drawArrow(svg, columnX[1], startY, columnX[1] - 50, startY, "#f8bd1c");
        drawArrow(svg, columnX[1] - 50, startY, columnX[1], startY + 10, "#f8bd1c");
        drawFlowLabel(svg, "Capture MAC Address", columnX[1] - 80, startY - 10);
        startY += stepHeight;
        
        // RADIUS MAB request
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#f8bd1c");
        drawFlowLabel(svg, "RADIUS Access-Request (MAC as username/password)", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // MAB success
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#28a745");
        drawFlowLabel(svg, "Access-Accept + VLAN, ACL, etc.", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
    }
    
    // Add CoA if enabled
    if (settings.useCoa) {
        // Add CoA information
        const coaText = document.createElementNS("http://www.w3.org/2000/svg", "text");
        coaText.setAttribute("x", "400");
        coaText.setAttribute("y", startY + 10);
        coaText.setAttribute("text-anchor", "middle");
        coaText.setAttribute("font-family", "Arial, sans-serif");
        coaText.setAttribute("font-size", "14");
        coaText.setAttribute("font-style", "italic");
        coaText.setAttribute("fill", "#666");
        coaText.textContent = "Later, if policies change:";
        svg.appendChild(coaText);
        startY += 30;
        
        // CoA Request
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#e83e8c");
        drawFlowLabel(svg, "RADIUS CoA-Request", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // CoA ACK
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#e83e8c");
        drawFlowLabel(svg, "RADIUS CoA-ACK", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
    }
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "authentication-flow");
}

// Generate Deployment Architecture Diagram
function generateDeploymentArchitectureDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "600");
    svg.setAttribute("viewBox", "0 0 800 600");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "802.1X Deployment Architecture";
    svg.appendChild(title);
    
    // Add subtitle
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = `${settings.vendor.toUpperCase()} ${settings.platform.toUpperCase()} with ${getAuthMethodName(settings.authMethod)}`;
    svg.appendChild(subtitle);
    
    // Draw network components
    
    // Core Network (cloud)
    drawCloud(svg, 400, 120, 200, 80, "Core Network");
    
    // Distribution switches
    drawNetworkSwitch(svg, 250, 220, { label: "Distribution Switch" });
    drawNetworkSwitch(svg, 550, 220, { label: "Distribution Switch" });
    
    // Connect core to distribution
    drawConnection(svg, 250, 220, 400, 120, "#333", "Trunk");
    drawConnection(svg, 550, 220, 400, 120, "#333", "Trunk");
    
    // Access switches (multiple)
    drawNetworkSwitch(svg, 150, 320, { label: "Access Switch", small: true });
    drawNetworkSwitch(svg, 350, 320, { label: "Access Switch", small: true });
    drawNetworkSwitch(svg, 450, 320, { label: "Access Switch", small: true });
    drawNetworkSwitch(svg, 650, 320, { label: "Access Switch", small: true });
    
    // Connect distribution to access
    drawConnection(svg, 150, 320, 250, 220, "#333", "Trunk");
    drawConnection(svg, 350, 320, 250, 220, "#333", "Trunk");
    drawConnection(svg, 450, 320, 550, 220, "#333", "Trunk");
    drawConnection(svg, 650, 320, 550, 220, "#333", "Trunk");
    
    // RADIUS Servers
    drawRadiusServer(svg, 300, 120, settings.radiusServer, "Primary RADIUS");
    if (settings.secondaryServer) {
        drawRadiusServer(svg, 500, 120, settings.secondaryServer, "Secondary RADIUS");
    }
    
    // Connect switches to RADIUS
    drawConnection(svg, 250, 220, 300, 120, "#dc3545", settings.useRadSec ? "RadSec" : "RADIUS");
    drawConnection(svg, 550, 220, 300, 120, "#dc3545", settings.useRadSec ? "RadSec" : "RADIUS");
    if (settings.secondaryServer) {
        drawConnection(svg, 250, 220, 500, 120, "#dc3545", "Failover", true);
        drawConnection(svg, 550, 220, 500, 120, "#dc3545", "Failover", true);
    }
    
    // End devices (multiple clients)
    // Row 1
    drawClientDevice(svg, 100, 420, "PC", "standard");
    drawClientDevice(svg, 150, 420, "Laptop", "laptop");
    drawClientDevice(svg, 200, 420, "Phone", "phone");
    // Row 2
    drawClientDevice(svg, 300, 420, "PC", "standard");
    drawClientDevice(svg, 350, 420, "Printer", "printer");
    drawClientDevice(svg, 400, 420, "Phone", "phone");
    // Row 3
    drawClientDevice(svg, 400, 420, "PC", "standard");
    drawClientDevice(svg, 450, 420, "Laptop", "laptop");
    drawClientDevice(svg, 500, 420, "Phone", "phone");
    // Row 4
    drawClientDevice(svg, 600, 420, "PC", "standard");
    drawClientDevice(svg, 650, 420, "IoT Device", "iot");
    drawClientDevice(svg, 700, 420, "Phone", "phone");
    
    // Connect clients to access switches
    drawConnection(svg, 100, 420, 150, 320, "#0077cc", "802.1X");
    drawConnection(svg, 150, 420, 150, 320, "#0077cc", "802.1X");
    drawConnection(svg, 200, 420, 150, 320, "#28a745", "802.1X (Voice)");
    
    drawConnection(svg, 300, 420, 350, 320, "#0077cc", "802.1X");
    drawConnection(svg, 350, 420, 350, 320, "#f8bd1c", "MAB");
    drawConnection(svg, 400, 420, 350, 320, "#28a745", "802.1X (Voice)");
    
    drawConnection(svg, 400, 420, 450, 320, "#0077cc", "802.1X");
    drawConnection(svg, 450, 420, 450, 320, "#0077cc", "802.1X");
    drawConnection(svg, 500, 420, 450, 320, "#28a745", "802.1X (Voice)");
    
    drawConnection(svg, 600, 420, 650, 320, "#0077cc", "802.1X");
    drawConnection(svg, 650, 420, 650, 320, "#f8bd1c", "MAB");
    drawConnection(svg, 700, 420, 650, 320, "#28a745", "802.1X (Voice)");
    
    // Add VLANs information
    const vlansInfo = document.createElementNS("http://www.w3.org/2000/svg", "text");
    vlansInfo.setAttribute("x", "400");
    vlansInfo.setAttribute("y", "520");
    vlansInfo.setAttribute("text-anchor", "middle");
    vlansInfo.setAttribute("font-family", "Arial, sans-serif");
    vlansInfo.setAttribute("font-size", "14");
    vlansInfo.setAttribute("fill", "#333");
    vlansInfo.textContent = `VLANs: Auth=${settings.vlanAuth || 'N/A'}, Unauth=${settings.vlanUnauth || 'N/A'}, Guest=${settings.vlanGuest || 'N/A'}, Voice=${settings.vlanVoice || 'N/A'}`;
    svg.appendChild(vlansInfo);
    
    // Draw legend
    drawLegend(svg, 50, 550);
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "deployment-architecture");
}

// Generate RADIUS Communication Diagram
function generateRadiusCommunicationDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "600");
    svg.setAttribute("viewBox", "0 0 800 600");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "RADIUS Communication";
    svg.appendChild(title);
    
    // Add subtitle
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = settings.useRadSec ? "Using RadSec (RADIUS over TLS)" : "Standard RADIUS Protocol";
    svg.appendChild(subtitle);
    
    // Draw network components
    
    // Switch
    drawNetworkSwitch(svg, 200, 250, settings);
    
    // RADIUS Server
    drawRadiusServer(svg, 600, 250, settings.radiusServer, "RADIUS Server");
    
    // Draw protocol details
    
    // Authentication
    drawArrow(svg, 200, 200, 600, 200, "#dc3545");
    drawPacketLabel(svg, "Access-Request", 400, 180, "#dc3545");
    drawPacketDetails(svg, "Username, Password, NAS-IP, Called-Station-ID", 400, 195);
    
    drawArrow(svg, 600, 230, 200, 230, "#28a745");
    drawPacketLabel(svg, "Access-Accept", 400, 210, "#28a745");
    drawPacketDetails(svg, "Tunnel-Type=VLAN, Tunnel-Medium-Type=802, Tunnel-Private-Group-ID=" + (settings.vlanAuth || "100"), 400, 225);
    
    // Accounting (if enabled)
    if (settings.enableAccounting) {
        drawArrow(svg, 200, 280, 600, 280, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Request (Start)", 400, 260, "#17a2b8");
        drawPacketDetails(svg, "Acct-Status-Type=Start, User-Name, Framed-IP-Address", 400, 275);
        
        drawArrow(svg, 600, 310, 200, 310, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Response", 400, 290, "#17a2b8");
        
        drawArrow(svg, 200, 350, 600, 350, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Request (Interim)", 400, 330, "#17a2b8");
        drawPacketDetails(svg, "Acct-Status-Type=Interim, Acct-Input-Octets, Acct-Output-Octets", 400, 345);
        
        drawArrow(svg, 600, 380, 200, 380, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Response", 400, 360, "#17a2b8");
        
        drawArrow(svg, 200, 420, 600, 420, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Request (Stop)", 400, 400, "#17a2b8");
        drawPacketDetails(svg, "Acct-Status-Type=Stop, Acct-Input-Octets, Acct-Output-Octets", 400, 415);
        
        drawArrow(svg, 600, 450, 200, 450, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Response", 400, 430, "#17a2b8");
    }
    
    // CoA (if enabled)
    if (settings.useCoa) {
        drawArrow(svg, 600, 500, 200, 500, "#e83e8c");
        drawPacketLabel(svg, "CoA-Request", 400, 480, "#e83e8c");
        drawPacketDetails(svg, "User-Name, Class, Filter-Id", 400, 495);
        
        drawArrow(svg, 200, 530, 600, 530, "#e83e8c");
        drawPacketLabel(svg, "CoA-ACK", 400, 510, "#e83e8c");
    }
    
    // Add protocol information
    const protocolInfo = document.createElementNS("http://www.w3.org/2000/svg", "text");
    protocolInfo.setAttribute("x", "400");
    protocolInfo.setAttribute("y", "560");
    protocolInfo.setAttribute("text-anchor", "middle");
    protocolInfo.setAttribute("font-family", "Arial, sans-serif");
    protocolInfo.setAttribute("font-size", "12");
    protocolInfo.setAttribute("fill", "#666");
    
    if (settings.useRadSec) {
        protocolInfo.textContent = `RadSec: Port ${settings.radsecPort || 2083}, TLS-encrypted RADIUS traffic`;
    } else {
        protocolInfo.textContent = `RADIUS: Auth Port ${settings.radiusAuthPort || 1812}, Acct Port ${settings.radiusAcctPort || 1813}, Shared Secret Authentication`;
    }
    
    svg.appendChild(protocolInfo);
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "radius-communication");
}

// Drawing helper functions

// Draw RADIUS server
function drawRadiusServer(svg, x, y, label, title) {
    // Server box
    const server = document.createElementNS("http://www.w3.org/2000/svg", "rect");
    server.setAttribute("x", x - 50);
    server.setAttribute("y", y - 40);
    server.setAttribute("width", 100);
    server.setAttribute("height", 80);
    server.setAttribute("rx", 5);
    server.setAttribute("ry", 5);
    server.setAttribute("fill", "#f8f9fa");
    server.setAttribute("stroke", "#dc3545");
    server.setAttribute("stroke-width", 2);
    svg.appendChild(server);
    
    // Server details
    const serverLines = document.createElementNS("http://www.w3.org/2000/svg", "g");
    for (let i = 0; i < 4; i++) {
        const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", x - 40);
        line.setAttribute("y1", y - 25 + (i * 15));
        line.setAttribute("x2", x + 40);
        line.setAttribute("y2", y - 25 + (i * 15));
        line.setAttribute("stroke", "#dc3545");
        line.setAttribute("stroke-width", 1);
        line.setAttribute("stroke-opacity", "0.5");
        serverLines.appendChild(line);
    }
    svg.appendChild(serverLines);
    
    // Server IP text
    const serverIP = document.createElementNS("http://www.w3.org/2000/svg", "text");
    serverIP.setAttribute("x", x);
    serverIP.setAttribute("y", y + 20);
    serverIP.setAttribute("text-anchor", "middle");
    serverIP.setAttribute("font-family", "Arial, sans-serif");
    serverIP.setAttribute("font-size", "12");
    serverIP.setAttribute("fill", "#333");
    serverIP.textContent = label || "RADIUS Server";
    svg.appendChild(serverIP);
    
    // Server title
    const serverTitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    serverTitle.setAttribute("x", x);
    serverTitle.setAttribute("y", y - 50);
    serverTitle.setAttribute("text-anchor", "middle");
    serverTitle.setAttribute("font-family", "Arial, sans-serif");
    serverTitle.setAttribute("font-size", "12");
    serverTitle.setAttribute("fill", "#333");
    serverTitle.textContent = title || "RADIUS Server";
    svg.appendChild(serverTitle);
}

// Draw network switch
function drawNetworkSwitch(svg, x, y, settings) {
    // Default size
    const width = settings.small ? 80 : 100;
    const height = settings.small ? 40 : 50;
    
    // Switch box
    const switchBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
    switchBox.setAttribute("x", x - width/2);
    switchBox.setAttribute("y", y - height/2);
    switchBox.setAttribute("width", width);
    switchBox.setAttribute("height", height);
    switchBox.setAttribute("rx", 3);
    switchBox.setAttribute("ry", 3);
    switchBox.setAttribute("fill", "#f8f9fa");
    switchBox.setAttribute("stroke", "#0077cc");
    switchBox.setAttribute("stroke-width", 2);
    svg.appendChild(switchBox);
    
    // Switch ports
    const portsGroup = document.createElementNS("http://www.w3.org/2000/svg", "g");
    const portCount = settings.small ? 6 : 8;
    const portWidth = (width - 20) / portCount;
    
    for (let i = 0; i < portCount; i++) {
        const port = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        port.setAttribute("x", (x - width/2 + 10) + (i * portWidth));
        port.setAttribute("y", y - height/2 + 10);
        port.setAttribute("width", portWidth - 2);
        port.setAttribute("height", 10);
        port.setAttribute("fill", "#333");
        port.setAttribute("rx", 1);
        port.setAttribute("ry", 1);
        portsGroup.appendChild(port);
    }
    svg.appendChild(portsGroup);
    
    // Switch label
    const switchLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
    switchLabel.setAttribute("x", x);
    switchLabel.setAttribute("y", y + 5);
    switchLabel.setAttribute("text-anchor", "middle");
    switchLabel.setAttribute("font-family", "Arial, sans-serif");
    switchLabel.setAttribute("font-size", settings.small ? "10" : "12");
    switchLabel.setAttribute("fill", "#333");
    switchLabel.textContent = settings.label || settings.vendor || "Network Switch";
    svg.appendChild(switchLabel);
}

// Draw client device
function drawClientDevice(svg, x, y, label, type) {
    let deviceShape;
    
    switch (type) {
        case "laptop":
            // Laptop shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "path");
            deviceShape.setAttribute("d", `M${x-20},${y-10} L${x+20},${y-10} L${x+25},${y+10} L${x-25},${y+10} Z`);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#333");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Screen
            const laptopScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            laptopScreen.setAttribute("x", x - 15);
            laptopScreen.setAttribute("y", y - 8);
            laptopScreen.setAttribute("width", 30);
            laptopScreen.setAttribute("height", 15);
            laptopScreen.setAttribute("fill", "#0077cc");
            laptopScreen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(laptopScreen);
            break;
            
        case "phone":
            // Phone shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 8);
            deviceShape.setAttribute("y", y - 15);
            deviceShape.setAttribute("width", 16);
            deviceShape.setAttribute("height", 30);
            deviceShape.setAttribute("rx", 3);
            deviceShape.setAttribute("ry", 3);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#28a745");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Screen
            const phoneScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            phoneScreen.setAttribute("x", x - 5);
            phoneScreen.setAttribute("y", y - 12);
            phoneScreen.setAttribute("width", 10);
            phoneScreen.setAttribute("height", 20);
            phoneScreen.setAttribute("fill", "#28a745");
            phoneScreen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(phoneScreen);
            
            // Home button
            const homeButton = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            homeButton.setAttribute("cx", x);
            homeButton.setAttribute("cy", y + 10);
            homeButton.setAttribute("r", 2);
            homeButton.setAttribute("fill", "#333");
            svg.appendChild(homeButton);
            break;
            
        case "printer":
            // Printer shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 15);
            deviceShape.setAttribute("y", y - 10);
            deviceShape.setAttribute("width", 30);
            deviceShape.setAttribute("height", 20);
            deviceShape.setAttribute("rx", 2);
            deviceShape.setAttribute("ry", 2);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#f8bd1c");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Paper tray
            const paperTray = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            paperTray.setAttribute("x", x - 10);
            paperTray.setAttribute("y", y - 15);
            paperTray.setAttribute("width", 20);
            paperTray.setAttribute("height", 5);
            paperTray.setAttribute("fill", "#f8f9fa");
            paperTray.setAttribute("stroke", "#f8bd1c");
            paperTray.setAttribute("stroke-width", 1.5);
            svg.appendChild(paperTray);
            
            // Control panel
            const controlPanel = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            controlPanel.setAttribute("x", x - 5);
            controlPanel.setAttribute("y", y - 5);
            controlPanel.setAttribute("width", 10);
            controlPanel.setAttribute("height", 5);
            controlPanel.setAttribute("fill", "#f8bd1c");
            controlPanel.setAttribute("fill-opacity", "0.2");
            svg.appendChild(controlPanel);
            break;
            
        case "iot":
            // IoT device (circular)
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            deviceShape.setAttribute("cx", x);
            deviceShape.setAttribute("cy", y);
            deviceShape.setAttribute("r", 15);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#e83e8c");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // IoT indicators
            for (let i = 0; i < 3; i++) {
                const indicator = document.createElementNS("http://www.w3.org/2000/svg", "circle");
                indicator.setAttribute("cx", x + (i * 5) - 5);
                indicator.setAttribute("cy", y - 5);
                indicator.setAttribute("r", 2);
                indicator.setAttribute("fill", "#e83e8c");
                svg.appendChild(indicator);
            }
            break;
            
        case "light":
            // Light client (transparent)
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 15);
            deviceShape.setAttribute("y", y - 15);
            deviceShape.setAttribute("width", 30);
            deviceShape.setAttribute("height", 30);
            deviceShape.setAttribute("rx", 3);
            deviceShape.setAttribute("ry", 3);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#999");
            deviceShape.setAttribute("stroke-width", 1);
            deviceShape.setAttribute("stroke-dasharray", "3,3");
            svg.appendChild(deviceShape);
            
            // Screen
            const lightScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            lightScreen.setAttribute("x", x - 10);
            lightScreen.setAttribute("y", y - 8);
            lightScreen.setAttribute("width", 20);
            lightScreen.setAttribute("height", 16);
            lightScreen.setAttribute("fill", "#999");
            lightScreen.setAttribute("fill-opacity", "0.1");
            svg.appendChild(lightScreen);
            break;
            
        case "standard":
        default:
            // Default PC shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 15);
            deviceShape.setAttribute("y", y - 15);
            deviceShape.setAttribute("width", 30);
            deviceShape.setAttribute("height", 30);
            deviceShape.setAttribute("rx", 3);
            deviceShape.setAttribute("ry", 3);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#0077cc");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Screen
            const screen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            screen.setAttribute("x", x - 10);
            screen.setAttribute("y", y - 10);
            screen.setAttribute("width", 20);
            screen.setAttribute("height", 16);
            screen.setAttribute("fill", "#0077cc");
            screen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(screen);
            
            // Base
            const base = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            base.setAttribute("x", x - 5);
            base.setAttribute("y", y + 6);
            base.setAttribute("width", 10);
            base.setAttribute("height", 4);
            base.setAttribute("fill", "#0077cc");
            base.setAttribute("fill-opacity", "0.3");
            svg.appendChild(base);
    }
    
    // Device label
    const deviceLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
    deviceLabel.setAttribute("x", x);
    deviceLabel.setAttribute("y", y + 30);
    deviceLabel.setAttribute("text-anchor", "middle");
    deviceLabel.setAttribute("font-family", "Arial, sans-serif");
    deviceLabel.setAttribute("font-size", "10");
    deviceLabel.setAttribute("fill", "#333");
    deviceLabel.textContent = label || "Client";
    svg.appendChild(deviceLabel);
}

// Draw connection between components
function drawConnection(svg, x1, y1, x2, y2, color, label, dashed = false) {
    // Connection line
    const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
    line.setAttribute("x1", x1);
    line.setAttribute("y1", y1);
    line.setAttribute("x2", x2);
    line.setAttribute("y2", y2);
    line.setAttribute("stroke", color || "#333");
    line.setAttribute("stroke-width", 2);
    if (dashed) {
        line.setAttribute("stroke-dasharray", "5,5");
    }
    svg.appendChild(line);
    
    // Connection label if provided
    if (label) {
        const text = document.createElementNS("http://www.w3.org/2000/svg", "text");
        const midX = (x1 + x2) / 2;
        const midY = (y1 + y2) / 2;
        
        // Calculate angle for text rotation
        const angle = Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
        
        text.setAttribute("x", midX);
        text.setAttribute("y", midY);
        text.setAttribute("dy", "-5");
        text.setAttribute("text-anchor", "middle");
        text.setAttribute("font-family", "Arial, sans-serif");
        text.setAttribute("font-size", "10");
        text.setAttribute("fill", color || "#333");
        
        // Adjust text rotation for readability
        let adjustedAngle = angle;
        if (angle > 90 || angle < -90) {
            adjustedAngle = angle + 180;
        }
        
        // Only rotate if the line isn't mostly horizontal
        if (Math.abs(angle) > 15 && Math.abs(angle) < 165) {
            text.setAttribute("transform", `rotate(${adjustedAngle}, ${midX}, ${midY})`);
        }
        
        text.textContent = label;
        svg.appendChild(text);
    }
}

// Draw arrow for flow diagrams
function drawArrow(svg, x1, y1, x2, y2, color) {
    // Main line
    const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
    line.setAttribute("x1", x1);
    line.setAttribute("y1", y1);
    line.setAttribute("x2", x2);
    line.setAttribute("y2", y2);
    line.setAttribute("stroke", color || "#333");
    line.setAttribute("stroke-width", 2);
    svg.appendChild(line);
    
    // Arrow head
    const arrowSize = 6;
    const dx = x2 - x1;
    const dy = y2 - y1;
    const angle = Math.atan2(dy, dx);
    
    const arrowHead = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
    const x3 = x2 - arrowSize * Math.cos(angle - Math.PI / 6);
    const y3 = y2 - arrowSize * Math.sin(angle - Math.PI / 6);
    const x4 = x2 - arrowSize * Math.cos(angle + Math.PI / 6);
    const y4 = y2 - arrowSize * Math.sin(angle + Math.PI / 6);
    
    arrowHead.setAttribute("points", `${x2},${y2} ${x3},${y3} ${x4},${y4}`);
    arrowHead.setAttribute("fill", color || "#333");
    svg.appendChild(arrowHead);
}

// Draw cloud shape
function drawCloud(svg, x, y, width, height, label) {
    // Cloud path
    const cloudPath = document.createElementNS("http://www.w3.org/2000/svg", "path");
    const halfWidth = width / 2;
    const halfHeight = height / 2;
    
    const path = `
        M${x - halfWidth * 0.8},${y}
        C${x - halfWidth * 0.8},${y - halfHeight * 0.6}
        ${x - halfWidth * 0.4},${y - halfHeight}
        ${x},${y - halfHeight * 0.7}
        C${x + halfWidth * 0.4},${y - halfHeight}
        ${x + halfWidth * 0.8},${y - halfHeight * 0.8}
        ${x + halfWidth * 0.8},${y}
        C${x + halfWidth * 0.8},${y + halfHeight * 0.6}
        ${x + halfWidth * 0.4},${y + halfHeight}
        ${x},${y + halfHeight * 0.7}
        C${x - halfWidth * 0.4},${y + halfHeight}
        ${x - halfWidth * 0.8},${y + halfHeight * 0.6}
        ${x - halfWidth * 0.8},${y}
        Z
    `;
    
    cloudPath.setAttribute("d", path);
    cloudPath.setAttribute("fill", "#f8f9fa");
    cloudPath.setAttribute("stroke", "#333");
    cloudPath.setAttribute("stroke-width", 2);
    svg.appendChild(cloudPath);
    
    // Cloud label
    const cloudLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
    cloudLabel.setAttribute("x", x);
    cloudLabel.setAttribute("y", y + 5);
    cloudLabel.setAttribute("text-anchor", "middle");
    cloudLabel.setAttribute("font-family", "Arial, sans-serif");
    cloudLabel.setAttribute("font-size", "14");
    cloudLabel.setAttribute("fill", "#333");
    cloudLabel.textContent = label || "Cloud";
    svg.appendChild(cloudLabel);
}

// Draw icon in the flow diagram
function drawIcon(svg, x, y, type) {
    switch (type) {
        case "laptop":
            // Laptop icon
            const laptop = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            laptop.setAttribute("x", x - 15);
            laptop.setAttribute("y", y - 10);
            laptop.setAttribute("width", 30);
            laptop.setAttribute("height", 20);
            laptop.setAttribute("rx", 2);
            laptop.setAttribute("fill", "#f8f9fa");
            laptop.setAttribute("stroke", "#0077cc");
            laptop.setAttribute("stroke-width", 1.5);
            svg.appendChild(laptop);
            
            // Screen
            const laptopScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            laptopScreen.setAttribute("x", x - 12);
            laptopScreen.setAttribute("y", y - 8);
            laptopScreen.setAttribute("width", 24);
            laptopScreen.setAttribute("height", 16);
            laptopScreen.setAttribute("fill", "#0077cc");
            laptopScreen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(laptopScreen);
            break;
            
        case "switch":
            // Switch icon
            const switchBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            switchBox.setAttribute("x", x - 20);
            switchBox.setAttribute("y", y - 10);
            switchBox.setAttribute("width", 40);
            switchBox.setAttribute("height", 20);
            switchBox.setAttribute("rx", 2);
            switchBox.setAttribute("fill", "#f8f9fa");
            switchBox.setAttribute("stroke", "#0077cc");
            switchBox.setAttribute("stroke-width", 1.5);
            svg.appendChild(switchBox);
            
            // Ports
            for (let i = 0; i < 5; i++) {
                const port = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                port.setAttribute("x", x - 15 + (i * 7));
                port.setAttribute("y", y - 5);
                port.setAttribute("width", 5);
                port.setAttribute("height", 3);
                port.setAttribute("fill", "#0077cc");
                svg.appendChild(port);
                
                const port2 = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                port2.setAttribute("x", x - 15 + (i * 7));
                port2.setAttribute("y", y + 2);
                port2.setAttribute("width", 5);
                port2.setAttribute("height", 3);
                port2.setAttribute("fill", "#0077cc");
                svg.appendChild(port2);
            }
            break;
            
        case "server":
            // Server icon
            const server = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            server.setAttribute("x", x - 20);
            server.setAttribute("y", y - 15);
            server.setAttribute("width", 40);
            server.setAttribute("height", 30);
            server.setAttribute("rx", 2);
            server.setAttribute("fill", "#f8f9fa");
            server.setAttribute("stroke", "#dc3545");
            server.setAttribute("stroke-width", 1.5);
            svg.appendChild(server);
            
            // Server details
            for (let i = 0; i < 3; i++) {
                const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
                line.setAttribute("x1", x - 15);
                line.setAttribute("y1", y - 10 + (i * 10));
                line.setAttribute("x2", x + 15);
                line.setAttribute("y2", y - 10 + (i * 10));
                line.setAttribute("stroke", "#dc3545");
                line.setAttribute("stroke-width", 1);
                svg.appendChild(line);
            }
            break;
    }
}

// Draw flow label (protocol or message type)
function drawFlowLabel(svg, text, x, y) {
    const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
    label.setAttribute("x", x);
    label.setAttribute("y", y);
    label.setAttribute("text-anchor", "middle");
    label.setAttribute("font-family", "Arial, sans-serif");
    label.setAttribute("font-size", "12");
    label.setAttribute("font-weight", "bold");
    label.setAttribute("fill", "#333");
    label.textContent = text;
    svg.appendChild(label);
}

// Draw packet details (attributes)
function drawPacketDetails(svg, text, x, y) {
    const details = document.createElementNS("http://www.w3.org/2000/svg", "text");
    details.setAttribute("x", x);
    details.setAttribute("y", y);
    details.setAttribute("text-anchor", "middle");
    details.setAttribute("font-family", "Arial, sans-serif");
    details.setAttribute("font-size", "10");
    details.setAttribute("font-style", "italic");
    details.setAttribute("fill", "#666");
    details.textContent = text;
    svg.appendChild(details);
}

// Draw packet label (protocol message type)
function drawPacketLabel(svg, text, x, y, color) {
    const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
    label.setAttribute("x", x);
    label.setAttribute("y", y);
    label.setAttribute("text-anchor", "middle");
    label.setAttribute("font-family", "Arial, sans-serif");
    label.setAttribute("font-size", "12");
    label.setAttribute("font-weight", "bold");
    label.setAttribute("fill", color || "#333");
    label.textContent = text;
    svg.appendChild(label);
}

// Draw legend
function drawLegend(svg, x, y) {
    // Legend box
    const legendBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
    legendBox.setAttribute("x", x);
    legendBox.setAttribute("y", y);
    legendBox.setAttribute("width", 300);
    legendBox.setAttribute("height", 80);
    legendBox.setAttribute("rx", 5);
    legendBox.setAttribute("fill", "white");
    legendBox.setAttribute("fill-opacity", "0.9");
    legendBox.setAttribute("stroke", "#ddd");
    legendBox.setAttribute("stroke-width", 1);
    svg.appendChild(legendBox);
    
    // Legend title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", x + 10);
    title.setAttribute("y", y + 20);
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "12");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#333");
    title.textContent = "Legend";
    svg.appendChild(title);
    
    // Legend items
    const items = [
        { color: "#0077cc", label: "802.1X Authentication" },
        { color: "#f8bd1c", label: "MAC Authentication Bypass" },
        { color: "#dc3545", label: "RADIUS Communication" },
        { color: "#28a745", label: "Voice VLAN" }
    ];
    
    items.forEach((item, index) => {
        // Item color box
        const colorBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        colorBox.setAttribute("x", x + 10 + (index % 2) * 150);
        colorBox.setAttribute("y", y + 30 + Math.floor(index / 2) * 20);
        colorBox.setAttribute("width", 12);
        colorBox.setAttribute("height", 12);
        colorBox.setAttribute("fill", item.color);
        svg.appendChild(colorBox);
        
        // Item label
        const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
        label.setAttribute("x", x + 30 + (index % 2) * 150);
        label.setAttribute("y", y + 40 + Math.floor(index / 2) * 20);
        label.setAttribute("font-family", "Arial, sans-serif");
        label.setAttribute("font-size", "10");
        label.setAttribute("fill", "#333");
        label.textContent = item.label;
        svg.appendChild(label);
    });
}

// Add download button for the diagram
function addDownloadButton(container, svg, filename) {
    // Create download button
    const downloadButton = document.createElement('button');
    downloadButton.className = 'btn';
    downloadButton.innerHTML = 'Download Diagram';
    downloadButton.style.marginTop = '10px';
    
    // Add click handler
    downloadButton.addEventListener('click', () => {
        // Convert SVG to a data URL
        const svgData = new XMLSerializer().serializeToString(svg);
        const svgBlob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' });
        const url = URL.createObjectURL(svgBlob);
        
        // Create download link
        const link = document.createElement('a');
        link.href = url;
        link.download = `${filename}-diagram.svg`;
        link.click();
        
        // Clean up
        URL.revokeObjectURL(url);
    });
    
    // Add button to container
    container.appendChild(downloadButton);
}

// Helper function for checkbox values
function getCheckboxValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.checked : defaultValue;
}

// Helper function for input values
function getInputValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

// Helper function for select values
function getSelectValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

// Helper function for radio values
function getRadioValue(name, defaultValue) {
    const elements = document.getElementsByName(name);
    for (let i = 0; i < elements.length; i++) {
        if (elements[i].checked) {
            return elements[i].value;
        }
    }
    return defaultValue;
}

// Helper function to get authentication method name
function getAuthMethodName(method) {
    switch (method) {
        case 'dot1x':
            return '802.1X Authentication Only';
        case 'mab':
            return 'MAC Authentication Bypass Only';
        case 'dot1x-mab':
            return '802.1X with MAB Fallback';
        case 'concurrent':
            return '802.1X and MAB Concurrent';
        case 'dot1x-mab-webauth':
            return '802.1X + MAB + WebAuth';
        default:
            return '802.1X Authentication';
    }
}

/**
 * Dot1Xer Supreme Enterprise Edition - Project Questionnaire
 * Version 4.1.0
 * 
 * This module handles the project questionnaire for gathering 802.1X 
 * deployment requirements and pre-populating configuration settings.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Project Questionnaire...');
    
    // Set up event handlers
    setupQuestionnaireEvents();
});

// Global variables
let currentQuestionIndex = 0;
const answers = {};
const questionnaireQuestions = [
    // Section 1: Project Information
    {
        title: "Project Information",
        questions: [
            {
                id: "project-name",
                text: "What is the name of your 802.1X deployment project?",
                type: "text",
                required: true,
                placeholder: "e.g., Corporate Network Security Enhancement"
            },
            {
                id: "organization-name",
                text: "What is your organization name?",
                type: "text",
                required: true,
                placeholder: "e.g., Acme Corporation"
            },
            {
                id: "project-deadline",
                text: "What is your target completion date for this project?",
                type: "date",
                required: false
            }
        ]
    },
    
    // Section 2: Network Information
    {
        title: "Network Information",
        questions: [
            {
                id: "network-size",
                text: "What is the approximate size of your network?",
                type: "radio",
                required: true,
                options: [
                    { value: "small", label: "Small (< 100 devices)" },
                    { value: "medium", label: "Medium (100-500 devices)" },
                    { value: "large", label: "Large (501-2000 devices)" },
                    { value: "enterprise", label: "Enterprise (> 2000 devices)" }
                ]
            },
            {
                id: "primary-vendor",
                text: "What is your primary network equipment vendor?",
                type: "select",
                required: true,
                options: [
                    { value: "", label: "-- Select Vendor --" },
                    { value: "cisco", label: "Cisco" },
                    { value: "aruba", label: "Aruba" },
                    { value: "juniper", label: "Juniper" },
                    { value: "hp", label: "HP" },
                    { value: "extreme", label: "Extreme" },
                    { value: "fortinet", label: "Fortinet" },
                    { value: "dell", label: "Dell" },
                    { value: "huawei", label: "Huawei" },
                    { value: "ruckus", label: "Ruckus" },
                    { value: "mixed", label: "Mixed Vendor Environment" }
                ]
            },
            {
                id: "mixed-vendors",
                text: "Which vendors are present in your environment?",
                type: "checkbox",
                required: false,
                condition: { id: "primary-vendor", value: "mixed" },
                options: [
                    { value: "cisco", label: "Cisco" },
                    { value: "aruba", label: "Aruba" },
                    { value: "juniper", label: "Juniper" },
                    { value: "hp", label: "HP" },
                    { value: "extreme", label: "Extreme" },
                    { value: "fortinet", label: "Fortinet" },
                    { value: "dell", label: "Dell" },
                    { value: "huawei", label: "Huawei" },
                    { value: "ruckus", label: "Ruckus" },
                    { value: "other", label: "Other" }
                ]
            },
            {
                id: "vlan-structure",
                text: "Do you have an existing VLAN structure in place?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" },
                    { value: "partial", label: "Partially" }
                ]
            }
        ]
    },
    
    // Section 3: Authentication Requirements
    {
        title: "Authentication Requirements",
        questions: [
            {
                id: "auth-server",
                text: "Which RADIUS server will you be using?",
                type: "select",
                required: true,
                options: [
                    { value: "", label: "-- Select RADIUS Server --" },
                    { value: "cisco-ise", label: "Cisco ISE" },
                    { value: "aruba-clearpass", label: "Aruba ClearPass" },
                    { value: "microsoft-nps", label: "Microsoft NPS" },
                    { value: "freeradius", label: "FreeRADIUS" },
                    { value: "packetfence", label: "PacketFence" },
                    { value: "other", label: "Other" }
                ]
            },
            {
                id: "auth-server-other",
                text: "Please specify your RADIUS server:",
                type: "text",
                required: false,
                condition: { id: "auth-server", value: "other" },
                placeholder: "e.g., Radiator, XSupplicant, etc."
            },
            {
                id: "auth-types",
                text: "Which authentication methods do you plan to implement?",
                type: "checkbox",
                required: true,
                options: [
                    { value: "dot1x", label: "802.1X" },
                    { value: "mab", label: "MAC Authentication Bypass (MAB)" },
                    { value: "webauth", label: "Web Authentication" }
                ]
            },
            {
                id: "eap-methods",
                text: "Which EAP methods do you plan to use?",
                type: "checkbox",
                required: false,
                condition: { id: "auth-types", value: "dot1x" },
                options: [
                    { value: "peap", label: "PEAP" },
                    { value: "eap-tls", label: "EAP-TLS" },
                    { value: "eap-ttls", label: "EAP-TTLS" },
                    { value: "eap-fast", label: "EAP-FAST" },
                    { value: "eap-md5", label: "EAP-MD5" }
                ]
            },
            {
                id: "identity-source",
                text: "What is your primary identity source?",
                type: "select",
                required: true,
                options: [
                    { value: "", label: "-- Select Identity Source --" },
                    { value: "active-directory", label: "Active Directory" },
                    { value: "ldap", label: "LDAP" },
                    { value: "local-db", label: "Local Database" },
                    { value: "certificates", label: "Certificate Authority" },
                    { value: "other", label: "Other" }
                ]
            }
        ]
    },
    
    // Section 4: Device Types
    {
        title: "Device Types",
        questions: [
            {
                id: "device-types",
                text: "What types of devices will connect to your network?",
                type: "checkbox",
                required: true,
                options: [
                    { value: "workstations", label: "Workstations/Laptops" },
                    { value: "phones", label: "IP Phones" },
                    { value: "printers", label: "Printers/Scanners" },
                    { value: "cameras", label: "IP Cameras" },
                    { value: "iot", label: "IoT Devices" },
                    { value: "byod", label: "BYOD Devices" },
                    { value: "guests", label: "Guest Devices" }
                ]
            },
            {
                id: "legacy-devices",
                text: "Do you have devices that cannot support 802.1X authentication?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" },
                    { value: "unknown", label: "Unknown" }
                ]
            },
            {
                id: "legacy-handling",
                text: "How would you like to handle devices that cannot support 802.1X?",
                type: "radio",
                required: false,
                condition: { id: "legacy-devices", value: "yes" },
                options: [
                    { value: "mab", label: "MAC Authentication Bypass (MAB)" },
                    { value: "dedicated-ports", label: "Dedicated Non-802.1X Ports" },
                    { value: "vlans", label: "Separate VLANs" },
                    { value: "not-decided", label: "Not Decided Yet" }
                ]
            },
            {
                id: "ip-phones",
                text: "Do you use IP phones in your environment?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" }
                ]
            },
            {
                id: "phone-vendor",
                text: "What is your IP phone vendor?",
                type: "select",
                required: false,
                condition: { id: "ip-phones", value: "yes" },
                options: [
                    { value: "", label: "-- Select Phone Vendor --" },
                    { value: "cisco", label: "Cisco" },
                    { value: "avaya", label: "Avaya" },
                    { value: "polycom", label: "Polycom" },
                    { value: "mitel", label: "Mitel" },
                    { value: "other", label: "Other" }
                ]
            }
        ]
    },
    
    // Section 5: Security Requirements
    {
        title: "Security Requirements",
        questions: [
            {
                id: "security-level",
                text: "What level of security are you aiming to achieve?",
                type: "radio",
                required: true,
                options: [
                    { value: "basic", label: "Basic (Authentication only)" },
                    { value: "medium", label: "Medium (Authentication with VLAN assignment)" },
                    { value: "high", label: "High (Authentication, VLAN assignment, and ACLs)" },
                    { value: "highest", label: "Highest (All above plus encryption)" }
                ]
            },
            {
                id: "use-macsec",
                text: "Do you plan to implement MACsec (802.1AE) encryption?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" },
                    { value: "future", label: "In a future phase" }
                ]
            },
            {
                id: "compliance-reqs",
                text: "Are there specific compliance requirements?",
                type: "checkbox",
                required: false,
                options: [
                    { value: "pci", label: "PCI DSS" },
                    { value: "hipaa", label: "HIPAA" },
                    { value: "fisma", label: "FISMA" },
                    { value: "gdpr", label: "GDPR" },
                    { value: "iso27001", label: "ISO 27001" },
                    { value: "other", label: "Other" },
                    { value: "none", label: "None" }
                ]
            },
            {
                id: "additional-security",
                text: "Which additional security features do you want to implement?",
                type: "checkbox",
                required: false,
                options: [
                    { value: "dhcp-snooping", label: "DHCP Snooping" },
                    { value: "dai", label: "Dynamic ARP Inspection" },
                    { value: "ipsg", label: "IP Source Guard" },
                    { value: "port-security", label: "Port Security" },
                    { value: "storm-control", label: "Storm Control" },
                    { value: "radius-coa", label: "RADIUS Change of Authorization (CoA)" }
                ]
            }
        ]
    },
    
    // Section 6: Deployment Strategy
    {
        title: "Deployment Strategy",
        questions: [
            {
                id: "deployment-approach",
                text: "What deployment approach do you prefer?",
                type: "radio",
                required: true,
                options: [
                    { value: "phased", label: "Phased (Monitor ? Low Impact ? Closed)" },
                    { value: "pilot", label: "Pilot Group First, Then Full Deployment" },
                    { value: "department", label: "Department by Department" },
                    { value: "location", label: "Location by Location" },
                    { value: "cutover", label: "Single Cutover (Not Recommended)" }
                ]
            },
            {
                id: "monitor-mode-duration",
                text: "How long do you plan to run in monitor mode?",
                type: "select",
                required: false,
                condition: { id: "deployment-approach", value: "phased" },
                options: [
                    { value: "1-week", label: "1 Week" },
                    { value: "2-weeks", label: "2 Weeks" },
                    { value: "1-month", label: "1 Month" },
                    { value: "2-months", label: "2 Months" },
                    { value: "custom", label: "Custom Duration" }
                ]
            },
            {
                id: "guest-access",
                text: "Do you need to provide network access for guests?",
                type: "radio",
                required: true,
                options: [
                    { value: "yes", label: "Yes" },
                    { value: "no", label: "No" }
                ]
            },
            {
                id: "guest-method",
                text: "How would you like to handle guest access?",
                type: "radio",
                required: false,
                condition: { id: "guest-access", value: "yes" },
                options: [
                    { value: "guest-vlan", label: "Guest VLAN for unauthenticated users" },
                    { value: "sponsor", label: "Sponsored guest accounts" },
                    { value: "self-reg", label: "Self-registration portal" },
                    { value: "separate", label: "Separate guest network" }
                ]
            }
        ]
    },
    
    // Section 7: Additional Information
    {
        title: "Additional Information",
        questions: [
            {
                id: "special-requirements",
                text: "Are there any special requirements or considerations for your deployment?",
                type: "textarea",
                required: false,
                placeholder: "Please describe any specific requirements or concerns..."
            },
            {
                id: "vlan-details",
                text: "Please provide details about your VLANs (Authentication, Guest, Voice, etc.)",
                type: "textarea",
                required: false,
                placeholder: "e.g., Auth VLAN 100, Guest VLAN 900, Voice VLAN 200..."
            },
            {
                id: "contact-person",
                text: "Who is the primary contact person for this project?",
                type: "text",
                required: false,
                placeholder: "Name, Email, Phone"
            }
        ]
    }
];

// Set up questionnaire event handlers
function setupQuestionnaireEvents() {
    // Questionnaire link click
    const questionnaireLink = document.getElementById('questionnaire-link');
    if (questionnaireLink) {
        questionnaireLink.addEventListener('click', function(e) {
            e.preventDefault();
            showQuestionnaire();
        });
    }
    
    // Modal close button
    const modalClose = document.getElementById('questionnaire-modal-close');
    if (modalClose) {
        modalClose.addEventListener('click', function() {
            hideQuestionnaire();
        });
    }
    
    // Next button
    const nextButton = document.getElementById('questionnaire-next');
    if (nextButton) {
        nextButton.addEventListener('click', function() {
            goToNextQuestion();
        });
    }
    
    // Previous button
    const prevButton = document.getElementById('questionnaire-previous');
    if (prevButton) {
        prevButton.addEventListener('click', function() {
            goToPreviousQuestion();
        });
    }
    
    // Finish button
    const finishButton = document.getElementById('questionnaire-finish');
    if (finishButton) {
        finishButton.addEventListener('click', function() {
            completeQuestionnaire();
        });
    }
}

// Show questionnaire modal
function showQuestionnaire() {
    const modal = document.getElementById('questionnaire-modal');
    if (modal) {
        // Reset questionnaire state
        currentQuestionIndex = 0;
        
        // Show first section
        showCurrentSection();
        
        // Show modal
        modal.classList.add('visible');
    }
}

// Hide questionnaire modal
function hideQuestionnaire() {
    const modal = document.getElementById('questionnaire-modal');
    if (modal) {
        modal.classList.remove('visible');
    }
}

// Show current question section
function showCurrentSection() {
    const container = document.getElementById('questionnaire-container');
    if (!container) return;
    
    const currentSection = questionnaireQuestions[currentQuestionIndex];
    if (!currentSection) return;
    
    // Create section content
    let content = `
        <div class="questionnaire-section">
            <h2>${currentSection.title}</h2>
            <p class="section-info">Section ${currentQuestionIndex + 1} of ${questionnaireQuestions.length}</p>
            <form id="questionnaire-form">
    `;
    
    // Add each question
    currentSection.questions.forEach((question) => {
        // Check if question should be shown based on conditions
        let showQuestion = true;
        if (question.condition) {
            const conditionValue = answers[question.condition.id];
            
            if (Array.isArray(conditionValue)) {
                // For checkbox conditions (arrays)
                showQuestion = conditionValue && conditionValue.includes(question.condition.value);
            } else {
                // For radio/select conditions (single values)
                showQuestion = conditionValue === question.condition.value;
            }
        }
        
        if (!showQuestion) return;
        
        content += `
            <div class="form-group">
                <label for="${question.id}">${question.text}${question.required ? ' <span class="required">*</span>' : ''}</label>
        `;
        
        // Handle different question types
        switch (question.type) {
            case 'text':
                content += `
                    <input type="text" id="${question.id}" name="${question.id}" class="form-control" 
                    ${question.placeholder ? `placeholder="${question.placeholder}"` : ''} 
                    ${question.required ? 'required' : ''} 
                    ${answers[question.id] ? `value="${answers[question.id]}"` : ''}>
                `;
                break;
                
            case 'textarea':
                content += `
                    <textarea id="${question.id}" name="${question.id}" class="form-control" 
                    ${question.placeholder ? `placeholder="${question.placeholder}"` : ''} 
                    ${question.required ? 'required' : ''}>${answers[question.id] || ''}</textarea>
                `;
                break;
                
            case 'date':
                content += `
                    <input type="date" id="${question.id}" name="${question.id}" class="form-control" 
                    ${question.required ? 'required' : ''} 
                    ${answers[question.id] ? `value="${answers[question.id]}"` : ''}>
                `;
                break;
                
            case 'select':
                content += `<select id="${question.id}" name="${question.id}" class="form-control" ${question.required ? 'required' : ''}>`;
                
                question.options.forEach(option => {
                    const selected = answers[question.id] === option.value ? 'selected' : '';
                    content += `<option value="${option.value}" ${selected}>${option.label}</option>`;
                });
                
                content += `</select>`;
                break;
                
            case 'radio':
                content += `<div class="radio-group">`;
                
                question.options.forEach(option => {
                    const checked = answers[question.id] === option.value ? 'checked' : '';
                    content += `
                        <div class="radio">
                            <input type="radio" id="${question.id}-${option.value}" name="${question.id}" 
                            value="${option.value}" ${checked} ${question.required ? 'required' : ''}>
                            <label for="${question.id}-${option.value}">${option.label}</label>
                        </div>
                    `;
                });
                
                content += `</div>`;
                break;
                
            case 'checkbox':
                content += `<div class="checkbox-group">`;
                
                question.options.forEach(option => {
                    const checked = answers[question.id] && Array.isArray(answers[question.id]) && 
                                   answers[question.id].includes(option.value) ? 'checked' : '';
                    
                    content += `
                        <div class="checkbox">
                            <input type="checkbox" id="${question.id}-${option.value}" name="${question.id}" 
                            value="${option.value}" ${checked}>
                            <label for="${question.id}-${option.value}">${option.label}</label>
                        </div>
                    `;
                });
                
                content += `</div>`;
                break;
        }
        
        content += `</div>`;
    });
    
    content += `</form></div>`;
    
    // Update container
    container.innerHTML = content;
    
    // Update button states
    updateNavigationButtons();
    
    // Add event listeners for condition-based questions
    addConditionalQuestionListeners();
}

// Add listeners for questions that have conditions
function addConditionalQuestionListeners() {
    const currentSection = questionnaireQuestions[currentQuestionIndex];
    if (!currentSection) return;
    
    currentSection.questions.forEach(question => {
        // Find questions that have conditions
        const dependentQuestions = currentSection.questions.filter(q => 
            q.condition && q.condition.id === question.id
        );
        
        if (dependentQuestions.length === 0) return;
        
        // Add appropriate event listeners based on question type
        switch (question.type) {
            case 'radio':
                const radioInputs = document.querySelectorAll(`input[name="${question.id}"]`);
                radioInputs.forEach(input => {
                    input.addEventListener('change', () => {
                        // Save the answer
                        saveCurrentAnswers();
                        // Re-render the section to show/hide dependent questions
                        showCurrentSection();
                    });
                });
                break;
                
            case 'select':
                const selectInput = document.getElementById(question.id);
                if (selectInput) {
                    selectInput.addEventListener('change', () => {
                        // Save the answer
                        saveCurrentAnswers();
                        // Re-render the section to show/hide dependent questions
                        showCurrentSection();
                    });
                }
                break;
                
            case 'checkbox':
                const checkboxInputs = document.querySelectorAll(`input[name="${question.id}"]`);
                checkboxInputs.forEach(input => {
                    input.addEventListener('change', () => {
                        // Save the answer
                        saveCurrentAnswers();
                        // Re-render the section to show/hide dependent questions
                        showCurrentSection();
                    });
                });
                break;
        }
    });
}

// Update navigation buttons
function updateNavigationButtons() {
    const prevButton = document.getElementById('questionnaire-previous');
    const nextButton = document.getElementById('questionnaire-next');
    const finishButton = document.getElementById('questionnaire-finish');
    
    if (prevButton) {
        prevButton.style.display = currentQuestionIndex > 0 ? 'block' : 'none';
    }
    
    if (nextButton && finishButton) {
        if (currentQuestionIndex < questionnaireQuestions.length - 1) {
            nextButton.style.display = 'block';
            finishButton.style.display = 'none';
        } else {
            nextButton.style.display = 'none';
            finishButton.style.display = 'block';
        }
    }
}

// Go to the next question
function goToNextQuestion() {
    // Save current answers
    if (!saveCurrentAnswers()) {
        // Don't proceed if validation fails
        return;
    }
    
    // Move to next section
    if (currentQuestionIndex < questionnaireQuestions.length - 1) {
        currentQuestionIndex++;
        showCurrentSection();
    }
}

// Go to the previous question
function goToPreviousQuestion() {
    // Save current answers (but don't validate)
    saveCurrentAnswers(false);
    
    // Move to previous section
    if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        showCurrentSection();
    }
}

// Save current answers
function saveCurrentAnswers(validate = true) {
    const form = document.getElementById('questionnaire-form');
    if (!form) return true;
    
    // Check form validity if validation is enabled
    if (validate && !form.checkValidity()) {
        // Show validation messages
        form.reportValidity();
        return false;
    }
    
    // Get all form elements
    const elements = form.elements;
    const currentSection = questionnaireQuestions[currentQuestionIndex];
    
    if (!currentSection) return true;
    
    // Process each question in the current section
    currentSection.questions.forEach(question => {
        switch (question.type) {
            case 'text':
            case 'textarea':
            case 'date':
            case 'select':
                const element = document.getElementById(question.id);
                if (element) {
                    answers[question.id] = element.value;
                }
                break;
                
            case 'radio':
                const selectedRadio = document.querySelector(`input[name="${question.id}"]:checked`);
                if (selectedRadio) {
                    answers[question.id] = selectedRadio.value;
                }
                break;
                
            case 'checkbox':
                const checkedBoxes = document.querySelectorAll(`input[name="${question.id}"]:checked`);
                if (checkedBoxes.length > 0) {
                    answers[question.id] = Array.from(checkedBoxes).map(cb => cb.value);
                } else {
                    answers[question.id] = [];
                }
                break;
        }
    });
    
    return true;
}

// Complete the questionnaire
function completeQuestionnaire() {
    // Save final answers
    if (!saveCurrentAnswers()) {
        return;
    }
    
    // Process answers to pre-populate configuration
    applyAnswersToConfiguration();
    
    // Hide questionnaire
    hideQuestionnaire();
    
    // Show confirmation message
    showAlert('Questionnaire completed successfully. Settings have been applied.', 'success');
}

// Apply questionnaire answers to configuration settings
function applyAnswersToConfiguration() {
    // Map answers to configuration fields
    
    // 1. Vendor & Platform
    if (answers['primary-vendor'] && answers['primary-vendor'] !== 'mixed') {
        selectVendor(answers['primary-vendor']);
    }
    
    // 2. Authentication settings
    if (answers['auth-types']) {
        // Set authentication method based on selected types
        const authTypes = answers['auth-types'];
        let authMethod = 'dot1x'; // Default
        
        if (authTypes.includes('dot1x') && authTypes.includes('mab') && authTypes.includes('webauth')) {
            authMethod = 'dot1x-mab-webauth';
        } else if (authTypes.includes('dot1x') && authTypes.includes('mab')) {
            authMethod = 'dot1x-mab';
        } else if (authTypes.includes('mab') && !authTypes.includes('dot1x')) {
            authMethod = 'mab';
        }
        
        setSelectValue('auth-method', authMethod);
    }
    
    // Set auth mode based on deployment approach
    if (answers['deployment-approach'] === 'phased') {
        setRadioValue('auth-mode', 'open'); // Start with monitor mode
    } else {
        setRadioValue('auth-mode', 'closed');
    }
    
    // 3. Host mode based on device types
    if (answers['device-types'] && answers['ip-phones']) {
        if (answers['device-types'].includes('phones') && answers['ip-phones'] === 'yes') {
            setSelectValue('host-mode', 'multi-domain');
        } else if (answers['device-types'].length > 2) {
            // Multiple device types suggest multi-auth
            setSelectValue('host-mode', 'multi-auth');
        }
    }
    
    // 4. RADIUS server settings
    if (answers['auth-server']) {
        // We don't have the actual IP, but we can set a placeholder
        setInputValue('radius-server-1', '10.0.0.1');
        
        // Set secondary server placeholder if high security is selected
        if (answers['security-level'] === 'high' || answers['security-level'] === 'highest') {
            setInputValue('radius-server-2', '10.0.0.2');
        }
    }
    
    // 5. VLAN settings from textarea
    if (answers['vlan-details']) {
        // Try to extract VLAN information from the provided text
        extractAndSetVlans(answers['vlan-details']);
    }
    
    // 6. Security features
    if (answers['security-level'] === 'highest' || (answers['use-macsec'] && answers['use-macsec'] === 'yes')) {
        setCheckboxValue('use-macsec', true);
    }
    
    if (answers['additional-security']) {
        if (answers['additional-security'].includes('dhcp-snooping')) {
            setCheckboxValue('enable-dhcp-snooping', true);
        }
        
        if (answers['additional-security'].includes('dai')) {
            setCheckboxValue('enable-dai', true);
        }
        
        if (answers['additional-security'].includes('ipsg')) {
            setCheckboxValue('enable-ipsg', true);
        }
        
        if (answers['additional-security'].includes('radius-coa')) {
            setCheckboxValue('use-coa', true);
        } else {
            setCheckboxValue('use-coa', false);
        }
    }
    
    // 7. Deployment strategy
    if (answers['deployment-approach']) {
        let strategy = 'monitor';
        
        if (answers['deployment-approach'] === 'phased') {
            strategy = 'monitor';
        } else if (answers['deployment-approach'] === 'pilot' || answers['deployment-approach'] === 'department') {
            strategy = 'low-impact';
        } else if (answers['deployment-approach'] === 'cutover') {
            strategy = 'closed';
        }
        
        setRadioValue('deploy-strategy', strategy);
    }
    
    // 8. Industry type
    if (answers['compliance-reqs']) {
        if (answers['compliance-reqs'].includes('hipaa')) {
            setSelectValue('industry-type', 'healthcare');
        } else if (answers['compliance-reqs'].includes('pci')) {
            setSelectValue('industry-type', 'retail');
        } else if (answers['compliance-reqs'].includes('fisma')) {
            setSelectValue('industry-type', 'government');
        } else if (answers['compliance-reqs'].includes('gdpr') || answers['compliance-reqs'].includes('iso27001')) {
            setSelectValue('industry-type', 'enterprise');
        }
    }
}

// Select a vendor in the UI
function selectVendor(vendorId) {
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    vendorContainers.forEach(container => {
        if (container.getAttribute('data-vendor') === vendorId) {
            // Remove selected class from all vendors
            vendorContainers.forEach(v => v.classList.remove('selected'));
            
            // Add selected class to clicked vendor
            container.classList.add('selected');
            
            // Trigger change event
            const event = new CustomEvent('vendorChange', { detail: { vendor: vendorId } });
            document.dispatchEvent(event);
        }
    });
}

// Set value for a select element
function setSelectValue(id, value) {
    const element = document.getElementById(id);
    if (element && element.tagName === 'SELECT') {
        element.value = value;
        
        // Trigger change event
        const event = new Event('change');
        element.dispatchEvent(event);
    }
}

// Set value for an input element
function setInputValue(id, value) {
    const element = document.getElementById(id);
    if (element && (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA')) {
        element.value = value;
    }
}

// Set value for a radio button
function setRadioValue(name, value) {
    const radio = document.querySelector(`input[name="${name}"][value="${value}"]`);
    if (radio) {
        radio.checked = true;
        
        // Trigger change event
        const event = new Event('change');
        radio.dispatchEvent(event);
    }
}

// Set value for a checkbox
function setCheckboxValue(id, checked) {
    const checkbox = document.getElementById(id);
    if (checkbox && checkbox.type === 'checkbox') {
        checkbox.checked = checked;
        
        // Trigger change event
        const event = new Event('change');
        checkbox.dispatchEvent(event);
    }
}

// Extract and set VLAN information from text
function extractAndSetVlans(text) {
    // Common VLAN naming patterns
    const patterns = {
        auth: /auth(entication)?[\s-]*vlan[\s:]*(\d+)/i,
        unauth: /unauth(enticated|orized)?[\s-]*vlan[\s:]*(\d+)/i,
        guest: /guest[\s-]*vlan[\s:]*(\d+)/i,
        voice: /voice[\s-]*vlan[\s:]*(\d+)/i,
        critical: /critical[\s-]*vlan[\s:]*(\d+)/i
    };
    
    // Try to match and set each VLAN
    for (const [type, pattern] of Object.entries(patterns)) {
        const match = text.match(pattern);
        if (match && match[2]) {
            setInputValue(`vlan-${type}`, match[2]);
        }
    }
}

// Helper function to show alerts
function showAlert(message, type = 'info') {
    // If the global alert function is available, use it
    if (typeof window.showAlert === 'function') {
        window.showAlert(message, type);
        return;
    }
    
    // Simple alert fallback
    alert(message);
}

# Create UI.js file
echo "DEBUG: About to call create_ui_js" && type create_ui_js && echo "Function exists, trying to call it..." && create_ui_js || echo "FAILED: create_ui_js function does not exist or has errors"() {
    log_info "Creating UI.js..."
    
    cat > "$JS_DIR/ui.js" << 'EOF'
/**
 * Dot1Xer Supreme Enterprise Edition - UI Functionality
 * Version 4.1.0
 * 
 * This module handles user interface functionality, including tab switching,
 * form interactions, modal displays, and other UI-related features.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing UI functionality...');
    
    // Initialize tabs
    initTabs();
    
    // Initialize expandable sections
    initExpandableSections();
    
    // Initialize modals
    initModals();
    
    // Initialize settings
    initSettings();
    
    // Initialize video banner
    initVideoBanner();
    
    // Initialize tooltips
    initTooltips();
});

// Initialize tabs functionality
function initTabs() {
    // Main content tabs
    const tabLinks = document.querySelectorAll('.tab');
    const tabPanes = document.querySelectorAll('.tab-pane');
    
    tabLinks.forEach(tab => {
        tab.addEventListener('click', () => {
            const tabId = tab.getAttribute('data-tab');
            
            // Remove active class from all tabs and panes
            tabLinks.forEach(t => t.classList.remove('active'));
            tabPanes.forEach(p => p.classList.remove('active'));
            
            // Add active class to selected tab and pane
            tab.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        });
    });
    
    // Tab navigation buttons
    setupTabNavigation();
    
    // Settings tabs
    const settingsTabs = document.querySelectorAll('.settings-tabs .tab');
    const settingsPanes = document.querySelectorAll('#settings-modal .tab-pane');
    
    settingsTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const tabId = tab.getAttribute('data-tab');
            
            // Remove active class from all tabs and panes
            settingsTabs.forEach(t => t.classList.remove('active'));
            settingsPanes.forEach(p => p.classList.remove('active'));
            
            // Add active class to selected tab and pane
            tab.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        });
    });
}

// Setup tab navigation buttons
function setupTabNavigation() {
    // Platform tab navigation
    const platformNext = document.getElementById('platform-next');
    if (platformNext) {
        platformNext.addEventListener('click', () => {
            activateTab('authentication');
        });
    }
    
    // Authentication tab navigation
    const authPrev = document.getElementById('auth-prev');
    const authNext = document.getElementById('auth-next');
    
    if (authPrev) {
        authPrev.addEventListener('click', () => {
            activateTab('platform');
        });
    }
    
    if (authNext) {
        authNext.addEventListener('click', () => {
            activateTab('security');
        });
    }
    
    // Security tab navigation
    const securityPrev = document.getElementById('security-prev');
    const securityNext = document.getElementById('security-next');
    
    if (securityPrev) {
        securityPrev.addEventListener('click', () => {
            activateTab('authentication');
        });
    }
    
    if (securityNext) {
        securityNext.addEventListener('click', () => {
            activateTab('network');
        });
    }
    
    // Network tab navigation
    const networkPrev = document.getElementById('network-prev');
    const networkNext = document.getElementById('network-next');
    
    if (networkPrev) {
        networkPrev.addEventListener('click', () => {
            activateTab('security');
        });
    }
    
    if (networkNext) {
        networkNext.addEventListener('click', () => {
            activateTab('advanced');
        });
    }
    
    // Advanced tab navigation
    const advancedPrev = document.getElementById('advanced-prev');
    const advancedNext = document.getElementById('advanced-next');
    
    if (advancedPrev) {
        advancedPrev.addEventListener('click', () => {
            activateTab('network');
        });
    }
    
    if (advancedNext) {
        advancedNext.addEventListener('click', () => {
            activateTab('preview');
        });
    }
    
    // Preview tab navigation
    const previewPrev = document.getElementById('preview-prev');
    
    if (previewPrev) {
        previewPrev.addEventListener('click', () => {
            activateTab('advanced');
        });
    }
}

// Activate a specific tab
function activateTab(tabId) {
    const tab = document.querySelector(`.tab[data-tab="${tabId}"]`);
    if (tab) {
        tab.click();
    }
}

// Initialize expandable sections
function initExpandableSections() {
    const expandableHeaders = document.querySelectorAll('.expandable-header');
    
    expandableHeaders.forEach(header => {
        header.addEventListener('click', () => {
            header.classList.toggle('expanded');
            const content = header.nextElementSibling;
            if (content && content.classList.contains('expandable-content')) {
                content.classList.toggle('expanded');
            }
        });
    });
}

// Initialize modal dialogs
function initModals() {
    // Settings modal
    setupModal('settings-link', 'settings-modal', 'settings-modal-close', 'settings-cancel');
    
    // Export documentation modal
    setupModal('export-documentation', 'export-modal', 'export-modal-close', 'export-cancel');
    
    // Save config modal
    setupModal('save-config', 'save-config-modal', 'save-config-modal-close', 'save-config-cancel');
    
    // Checklist modal
    setupModal('checklist-link', 'checklist-modal', 'checklist-modal-close', 'checklist-close');
    setupModal('checklist-tool', 'checklist-modal', 'checklist-modal-close', 'checklist-close');
    
    // AI Assistant
    const aiButton = document.getElementById('ai-assistant-button');
    const aiPanel = document.getElementById('ai-assistant-panel');
    const aiClose = document.getElementById('ai-assistant-close');
    
    if (aiButton && aiPanel && aiClose) {
        aiButton.addEventListener('click', () => {
            aiPanel.classList.add('visible');
        });
        
        aiClose.addEventListener('click', () => {
            aiPanel.classList.remove('visible');
        });
    }
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
    
    // Close modal when clicking outside
    if (modal) {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('visible');
            }
        });
    }
}

// Initialize settings functionality
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
    
    // Font size selector
    const fontSizeSelect = document.getElementById('font-size');
    if (fontSizeSelect) {
        fontSizeSelect.addEventListener('change', () => {
            applyFontSize(fontSizeSelect.value);
        });
    }
    
    // AI provider selector
    const aiProviderSelect = document.getElementById('ai-provider');
    if (aiProviderSelect) {
        aiProviderSelect.addEventListener('change', updateAIModelOptions);
    }
    
    // Backup and restore
    const backupButton = document.getElementById('backup-all-settings');
    if (backupButton) {
        backupButton.addEventListener('click', backupAllSettings);
    }
    
    const restoreButton = document.getElementById('restore-settings');
    if (restoreButton) {
        restoreButton.addEventListener('click', restoreSettingsFromFile);
    }
    
    const clearButton = document.getElementById('clear-all-settings');
    if (clearButton) {
        clearButton.addEventListener('click', confirmAndClearAllSettings);
    }
}

// Load settings from localStorage
function loadSettings() {
    try {
        // Theme settings
        const theme = localStorage.getItem('theme') || 'light';
        const fontSize = localStorage.getItem('fontSize') || 'medium';
        
        // Apply visual settings
        applyTheme(theme);
        applyFontSize(fontSize);
        
        // Update settings form
        const themeSelect = document.getElementById('theme-select');
        const fontSizeSelect = document.getElementById('font-size');
        
        if (themeSelect) themeSelect.value = theme;
        if (fontSizeSelect) fontSizeSelect.value = fontSize;
        
        // Load AI settings
        const aiProvider = localStorage.getItem('ai_provider') || 'openai';
        const openaiKey = localStorage.getItem('openai_api_key') || '';
        const anthropicKey = localStorage.getItem('anthropic_api_key') || '';
        const geminiKey = localStorage.getItem('gemini_api_key') || '';
        
        // Update AI settings form
        const aiProviderSelect = document.getElementById('ai-provider');
        const openaiKeyInput = document.getElementById('openai-api-key');
        const anthropicKeyInput = document.getElementById('anthropic-api-key');
        const geminiKeyInput = document.getElementById('gemini-api-key');
        
        if (aiProviderSelect) aiProviderSelect.value = aiProvider;
        if (openaiKeyInput) openaiKeyInput.value = openaiKey;
        if (anthropicKeyInput) anthropicKeyInput.value = anthropicKey;
        if (geminiKeyInput) geminiKeyInput.value = geminiKey;
        
        // Update AI model options
        updateAIModelOptions();
        
        // General settings
        const defaultVendor = localStorage.getItem('default_vendor') || '';
        const autoSaveInterval = localStorage.getItem('auto_save_interval') || '5';
        const rememberSettings = localStorage.getItem('remember_settings') !== 'false';
        const showAdvanced = localStorage.getItem('show_advanced_options') === 'true';
        
        // Update general settings form
        const defaultVendorSelect = document.getElementById('default-vendor');
        const autoSaveInput = document.getElementById('auto-save-interval');
        const rememberSettingsCheckbox = document.getElementById('remember-settings');
        const showAdvancedCheckbox = document.getElementById('show-advanced-options');
        
        if (defaultVendorSelect) defaultVendorSelect.value = defaultVendor;
        if (autoSaveInput) autoSaveInput.value = autoSaveInterval;
        if (rememberSettingsCheckbox) rememberSettingsCheckbox.checked = rememberSettings;
        if (showAdvancedCheckbox) showAdvancedCheckbox.checked = showAdvanced;
        
        console.log('Settings loaded successfully');
    } catch (error) {
        console.error('Error loading settings:', error);
    }
}

// Save settings to localStorage
function saveSettings() {
    try {
        // Theme settings
        const themeSelect = document.getElementById('theme-select');
        const fontSizeSelect = document.getElementById('font-size');
        
        if (themeSelect) localStorage.setItem('theme', themeSelect.value);
        if (fontSizeSelect) localStorage.setItem('fontSize', fontSizeSelect.value);
        
        // Apply visual settings
        if (themeSelect) applyTheme(themeSelect.value);
        if (fontSizeSelect) applyFontSize(fontSizeSelect.value);
        
        // AI settings
        const aiProviderSelect = document.getElementById('ai-provider');
        const openaiKeyInput = document.getElementById('openai-api-key');
        const anthropicKeyInput = document.getElementById('anthropic-api-key');
        const geminiKeyInput = document.getElementById('gemini-api-key');
        
        if (aiProviderSelect) localStorage.setItem('ai_provider', aiProviderSelect.value);
        if (openaiKeyInput) localStorage.setItem('openai_api_key', openaiKeyInput.value);
        if (anthropicKeyInput) localStorage.setItem('anthropic_api_key', anthropicKeyInput.value);
        if (geminiKeyInput) localStorage.setItem('gemini_api_key', geminiKeyInput.value);
        
        // General settings
        const defaultVendorSelect = document.getElementById('default-vendor');
        const autoSaveInput = document.getElementById('auto-save-interval');
        const rememberSettingsCheckbox = document.getElementById('remember-settings');
        const showAdvancedCheckbox = document.getElementById('show-advanced-options');
        
        if (defaultVendorSelect) localStorage.setItem('default_vendor', defaultVendorSelect.value);
        if (autoSaveInput) localStorage.setItem('auto_save_interval', autoSaveInput.value);
        if (rememberSettingsCheckbox) localStorage.setItem('remember_settings', rememberSettingsCheckbox.checked.toString());
        if (showAdvancedCheckbox) localStorage.setItem('show_advanced_options', showAdvancedCheckbox.checked.toString());
        
        // Initialize AI with updated settings
        if (window.AIIntegration && typeof window.AIIntegration.init === 'function') {
            window.AIIntegration.init({
                provider: aiProviderSelect ? aiProviderSelect.value : 'openai',
                apiKeys: {
                    openai: openaiKeyInput ? openaiKeyInput.value : '',
                    anthropic: anthropicKeyInput ? anthropicKeyInput.value : '',
                    gemini: geminiKeyInput ? geminiKeyInput.value : ''
                }
            });
        }
        
        // Close modal
        const modal = document.getElementById('settings-modal');
        if (modal) modal.classList.remove('visible');
        
        // Show success message
        showAlert('Settings saved successfully', 'success');
        
        console.log('Settings saved successfully');
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

// Apply font size
function applyFontSize(size) {
    document.body.classList.remove('font-small', 'font-medium', 'font-large');
    document.body.classList.add(`font-${size}`);
}

// Update AI model options based on selected provider
function updateAIModelOptions() {
    const aiProviderSelect = document.getElementById('ai-provider');
    const aiModelSelect = document.getElementById('ai-model');
    
    if (!aiProviderSelect || !aiModelSelect) return;
    
    // Clear existing options
    aiModelSelect.innerHTML = '';
    
    // Get selected provider
    const provider = aiProviderSelect.value;
    
    // Define models for each provider
    const models = {
        openai: [
            { value: 'gpt-3.5-turbo', label: 'GPT-3.5 Turbo' },
            { value: 'gpt-4-turbo', label: 'GPT-4 Turbo' },
            { value: 'gpt-4o', label: 'GPT-4o' }
        ],
        anthropic: [
            { value: 'claude-3-haiku', label: 'Claude 3 Haiku' },
            { value: 'claude-3-sonnet', label: 'Claude 3 Sonnet' },
            { value: 'claude-3-opus', label: 'Claude 3 Opus' }
        ],
        gemini: [
            { value: 'gemini-pro', label: 'Gemini Pro' },
            { value: 'gemini-ultra', label: 'Gemini Ultra' }
        ]
    };
    
    // Add options for selected provider
    const providerModels = models[provider] || [];
    providerModels.forEach(model => {
        const option = document.createElement('option');
        option.value = model.value;
        option.textContent = model.label;
        aiModelSelect.appendChild(option);
    });
    
    // Select first model by default
    if (providerModels.length > 0) {
        aiModelSelect.value = providerModels[0].value;
    }
}

// Backup all settings
function backupAllSettings() {
    try {
        // Collect all settings from localStorage
        const settings = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith('dot1xer_') || 
                key === 'theme' || 
                key === 'fontSize' || 
                key === 'ai_provider' || 
                key === 'default_vendor' || 
                key === 'auto_save_interval' || 
                key === 'remember_settings' || 
                key === 'show_advanced_options') {
                settings[key] = localStorage.getItem(key);
            }
        }
        
        // Convert to JSON
        const settingsJson = JSON.stringify(settings, null, 2);
        
        // Create download
        const blob = new Blob([settingsJson], { type: 'application/json' });
        const filename = `dot1xer-settings-backup-${new Date().toISOString().split('T')[0]}.json`;
        
        if (window.saveAs) {
            // Use FileSaver.js if available
            saveAs(blob, filename);
        } else {
            // Fallback to manual download
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
        }
        
        showAlert('Settings backup created successfully', 'success');
    } catch (error) {
        console.error('Error backing up settings:', error);
        showAlert('Error backing up settings: ' + error.message, 'danger');
    }
}

// Restore settings from file
function restoreSettingsFromFile() {
    const fileInput = document.getElementById('restore-file');
    if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
        showAlert('Please select a backup file to restore', 'warning');
        return;
    }
    
    const file = fileInput.files[0];
    const reader = new FileReader();
    
    reader.onload = function(e) {
        try {
            const settings = JSON.parse(e.target.result);
            
            // Restore settings to localStorage
            Object.keys(settings).forEach(key => {
                localStorage.setItem(key, settings[key]);
            });
            
            // Reload settings
            loadSettings();
            
            showAlert('Settings restored successfully. Reloading page...', 'success');
            
            // Reload page after a short delay
            setTimeout(() => {
                window.location.reload();
            }, 2000);
        } catch (error) {
            console.error('Error restoring settings:', error);
            showAlert('Error restoring settings: ' + error.message, 'danger');
        }
    };
    
    reader.onerror = function() {
        showAlert('Error reading backup file', 'danger');
    };
    
    reader.readAsText(file);
}

// Confirm and clear all settings
function confirmAndClearAllSettings() {
    const confirmed = confirm('This will reset all settings to default values. This action cannot be undone. Are you sure you want to continue?');
    
    if (confirmed) {
        clearAllSettings();
    }
}

// Clear all settings
function clearAllSettings() {
    try {
        // Remove all Dot1Xer-related items from localStorage
        const keysToRemove = [];
        
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith('dot1xer_') || 
                key === 'theme' || 
                key === 'fontSize' || 
                key === 'ai_provider' || 
                key === 'openai_api_key' || 
                key === 'anthropic_api_key' || 
                key === 'gemini_api_key' || 
                key === 'default_vendor' || 
                key === 'auto_save_interval' || 
                key === 'remember_settings' || 
                key === 'show_advanced_options') {
                keysToRemove.push(key);
            }
        }
        
        keysToRemove.forEach(key => {
            localStorage.removeItem(key);
        });
        
        showAlert('All settings have been reset. Reloading page...', 'success');
        
        // Reload page after a short delay
        setTimeout(() => {
            window.location.reload();
        }, 2000);
    } catch (error) {
        console.error('Error clearing settings:', error);
        showAlert('Error clearing settings: ' + error.message, 'danger');
    }
}

// Initialize video banner
function initVideoBanner() {
    const videoBanner = document.getElementById('video-banner');
    if (!videoBanner) return;
    
    // Try to load video
    try {
        const video = document.createElement('video');
        video.autoplay = true;
        video.loop = true;
        video.muted = true;
        video.playsInline = true;
        video.style.width = '100%';
        video.style.height = '100%';
        video.style.objectFit = 'cover';
        
        // Add source
        const source = document.createElement('source');
        source.src = 'assets/videos/banner-video.mp4';
        source.type = 'video/mp4';
        
        // Error handling - fallback to image
        video.onerror = function() {
            loadFallbackImage(videoBanner);
        };
        
        source.onerror = function() {
            loadFallbackImage(videoBanner);
        };
        
        video.appendChild(source);
        
        // Insert before overlay
        const overlay = videoBanner.querySelector('.video-overlay');
        if (overlay) {
            videoBanner.insertBefore(video, overlay);
        } else {
            videoBanner.appendChild(video);
        }
        
        // Start playing
        video.play().catch(err => {
            console.warn('Auto-play prevented:', err);
            // Fallback to image
            loadFallbackImage(videoBanner);
        });
    } catch (error) {
        console.error('Error loading video:', error);
        loadFallbackImage(videoBanner);
    }
}

// Load fallback image for video banner
function loadFallbackImage(container) {
    // Remove any existing video
    const existingVideo = container.querySelector('video');
    if (existingVideo) {
        container.removeChild(existingVideo);
    }
    
    // Use a gradient background as fallback
    container.style.background = 'linear-gradient(45deg, #1a3a5f, #0077cc)';
}

// Initialize tooltips
function initTooltips() {
    // Find all elements with tooltip-text class
    const tooltips = document.querySelectorAll('.tooltip');
    
    tooltips.forEach(tooltip => {
        // Add a span for the tooltip text if it doesn't exist
        if (!tooltip.querySelector('.tooltip-text')) {
            const tooltipText = document.createElement('span');
            tooltipText.className = 'tooltip-text';
            tooltipText.textContent = tooltip.getAttribute('data-tooltip') || 'Tooltip';
            tooltip.appendChild(tooltipText);
        }
    });
}

// Helper function to show alerts
function showAlert(message, type = 'info') {
    // Create alert container if it doesn't exist
    let alertContainer = document.getElementById('alert-container');
    if (!alertContainer) {
        alertContainer = document.createElement('div');
        alertContainer.id = 'alert-container';
        alertContainer.style.position = 'fixed';
        alertContainer.style.top = '20px';
        alertContainer.style.right = '20px';
        alertContainer.style.zIndex = '9999';
        alertContainer.style.maxWidth = '400px';
        document.body.appendChild(alertContainer);
    }
    
    // Create alert element
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
    
    // Close button
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
    
    // Show the alert with animation
    setTimeout(() => {
        alert.style.opacity = '1';
        alert.style.transform = 'translateX(0)';
    }, 10);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alert.parentNode) {
            alert.style.opacity = '0';
            alert.style.transform = 'translateX(50px)';
            setTimeout(() => {
                if (alert.parentNode) {
                    alert.remove();
                }
            }, 300);
        }
    }, 5000);
}

// Export showAlert function globally
window.showAlert = showAlert;
