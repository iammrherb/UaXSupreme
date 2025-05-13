/**
 * Dot1Xer Supreme Enterprise Edition - Configuration Generator
 * Version 4.1.0
 * 
 * This module handles the generation of 802.1X configuration.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Configuration Generator...');
    
    // Set up event handlers
    setupConfigGeneratorEvents();
});

// Set up configuration generator event handlers
function setupConfigGeneratorEvents() {
    // Generate configuration button
    const generateBtn = document.getElementById('generate-config');
    if (generateBtn) {
        generateBtn.addEventListener('click', generateConfiguration);
    }
    
    // Copy configuration button
    const copyBtn = document.getElementById('copy-config');
    if (copyBtn) {
        copyBtn.addEventListener('click', copyConfigToClipboard);
    }
    
    // Download configuration button
    const downloadBtn = document.getElementById('download-config');
    if (downloadBtn) {
        downloadBtn.addEventListener('click', downloadConfiguration);
    }
    
    // Analyze configuration button
    const analyzeBtn = document.getElementById('analyze-config');
    if (analyzeBtn) {
        analyzeBtn.addEventListener('click', analyzeConfiguration);
    }
    
    // Optimize configuration button
    const optimizeBtn = document.getElementById('optimize-config');
    if (optimizeBtn) {
        optimizeBtn.addEventListener('click', optimizeConfiguration);
    }
    
    // Save configuration button
    const saveBtn = document.getElementById('save-config');
    if (saveBtn) {
        saveBtn.addEventListener('click', () => {
            const modal = document.getElementById('save-config-modal');
            if (modal) {
                modal.classList.add('visible');
            }
        });
    }
    
    // Save config confirmation button
    const saveConfirmBtn = document.getElementById('save-config-confirm');
    if (saveConfirmBtn) {
        saveConfirmBtn.addEventListener('click', saveConfiguration);
    }
}

// Generate configuration
function generateConfiguration() {
    // Get the selected vendor and platform
    const selectedVendor = getSelectedVendor();
    const platformSelect = document.getElementById('platform-select');
    const selectedPlatform = platformSelect ? platformSelect.value : '';
    
    // Validate vendor and platform selection
    if (!selectedVendor || !selectedPlatform) {
        showAlert('Please select a vendor and platform first.', 'warning');
        return;
    }
    
    // Collect form settings
    const settings = collectFormSettings();
    
    // Generate configuration
    let configText = '';
    
    try {
        // Use vendor-specific generator if available
        if (typeof generateVendorConfig === 'function') {
            configText = generateVendorConfig(selectedVendor, selectedPlatform, settings);
        } else {
            // Fallback to generic configuration
            configText = generateFallbackConfig(selectedVendor, selectedPlatform, settings);
        }
    } catch (error) {
        console.error('Error generating configuration:', error);
        showAlert('Error generating configuration: ' + error.message, 'danger');
        return;
    }
    
    // Display the generated configuration
    const configOutput = document.getElementById('config-output');
    if (configOutput) {
        configOutput.textContent = configText;
    }
    
    // Show the preview tab
    const previewTab = document.querySelector('.tab[data-tab="preview"]');
    if (previewTab) {
        previewTab.click();
    }
    
    // Analyze the generated configuration
    analyzeConfiguration();
    
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
        radiusDeadtime: getInputValue('radius-deadtime', '15'),
        radiusNasId: getInputValue('radius-nas-id', ''),
        
        // Secondary RADIUS server
        secondaryServer: getInputValue('radius-server-2', ''),
        secondaryKey: getInputValue('radius-key-2', ''),
        secondaryAuthPort: getInputValue('radius-auth-port-2', '1812'),
        secondaryAcctPort: getInputValue('radius-acct-port-2', '1813'),
        
        // Tertiary RADIUS server
        tertiaryServer: getInputValue('radius-server-3', ''),
        tertiaryKey: getInputValue('radius-key-3', ''),
        tertiaryAuthPort: getInputValue('radius-auth-port-3', '1812'),
        tertiaryAcctPort: getInputValue('radius-acct-port-3', '1813'),
        
        // RADIUS options
        enableAccounting: getCheckboxValue('enable-accounting', false),
        accountingUpdate: getInputValue('accounting-update', '60'),
        useCoa: getCheckboxValue('use-coa', false),
        coaPort: getInputValue('coa-port', '1700'),
        useRadsec: getCheckboxValue('use-radsec', false),
        radsecPort: getInputValue('radsec-port', '2083'),
        
        // Authentication timing
        reauthPeriod: getInputValue('reauth-period', '3600'),
        txPeriod: getInputValue('tx-period', '30'),
        quietPeriod: getInputValue('quiet-period', '60'),
        maxReauth: getInputValue('max-reauth', '2'),
        
        // VLAN settings
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
        
        // Interface settings
        interface: getInputValue('interface', ''),
        interfaceRange: getInputValue('interface-range', ''),
        interfaceAdminShutdown: getCheckboxValue('interface-admin-shutdown', false),
        interfaceMtu: getInputValue('interface-mtu', ''),
        interfacePortfast: getCheckboxValue('interface-portfast', true),
        interfaceBpduGuard: getCheckboxValue('interface-bpduguard', true),
        mgmtInterface: getInputValue('mgmt-interface', ''),
        
        // Security features
        enableDhcpSnooping: getCheckboxValue('enable-dhcp-snooping', false),
        dhcpOption82: getCheckboxValue('dhcp-option82', false),
        dhcpRateLimit: getInputValue('dhcp-rate-limit', '20'),
        
        enableDai: getCheckboxValue('enable-dai', false),
        daiValidateSrcMac: getCheckboxValue('dai-validate-src-mac', true),
        daiValidateDstMac: getCheckboxValue('dai-validate-dst-mac', false),
        daiValidateIp: getCheckboxValue('dai-validate-ip', true),
        
        enableIpsg: getCheckboxValue('enable-ipsg', false),
        
        enablePortSecurity: getCheckboxValue('enable-port-security', false),
        portSecurityMaxMac: getInputValue('port-security-max-mac', '1'),
        portSecurityViolation: getSelectValue('port-security-violation', 'shutdown'),
        
        enableStormControl: getCheckboxValue('enable-storm-control', false),
        stormControlBroadcast: getInputValue('storm-control-broadcast', '20'),
        stormControlMulticast: getInputValue('storm-control-multicast', '30'),
        stormControlUnicast: getInputValue('storm-control-unicast', '50'),
        
        enableDeviceTracking: getCheckboxValue('enable-device-tracking', false),
        deviceTrackingIpv6: getCheckboxValue('device-tracking-ipv6', false),
        deviceTrackingInterval: getInputValue('device-tracking-interval', '30'),
        
        // MACsec settings
        useMacsec: getCheckboxValue('use-macsec', false),
        macsecPolicy: getSelectValue('macsec-policy', 'should-secure'),
        macsecCipher: getSelectValue('macsec-cipher', 'gcm-aes-256'),
        macsecIncludeSci: getCheckboxValue('macsec-include-sci', true),
        macsecReplayProtection: getCheckboxValue('macsec-replay-protection', true),
        macsecReplayWindow: getInputValue('macsec-replay-window', '0'),
        
        // ACL settings
        enableAcl: getCheckboxValue('enable-acl', false),
        aclNameAuth: getInputValue('acl-name-auth', ''),
        aclNameUnauth: getInputValue('acl-name-unauth', ''),
        
        // Logging settings
        enableAaaLogging: getCheckboxValue('enable-aaa-logging', false),
        
        // Deployment settings
        deployStrategy: getRadioValue('deploy-strategy', 'monitor'),
        phase1Duration: getInputValue('phase1-duration', '30'),
        phase2Duration: getInputValue('phase2-duration', '15'),
        
        // Industry settings
        industryType: getSelectValue('industry-type', 'enterprise'),
        applyIndustryTemplates: getCheckboxValue('apply-industry-templates', false),
        complianceFramework: getSelectValue('compliance-framework', 'none'),
        
        // Additional commands
        additionalCommands: getTextareaValue('additional-commands', '')
    };
}

// Helper function to get input value
function getInputValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element && element.value ? element.value : defaultValue;
}

// Helper function to get textarea value
function getTextareaValue(id, defaultValue) {
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

// Save a configuration
function saveConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput) return;
    
    const config = configOutput.textContent;
    if (config.trim() === '' || config.includes('No configuration generated yet.')) {
        showAlert('Please generate a configuration first.', 'warning');
        return;
    }
    
    const configName = document.getElementById('config-name').value;
    if (!configName) {
        showAlert('Please provide a name for the configuration.', 'warning');
        return;
    }
    
    const configDescription = document.getElementById('config-description').value;
    
    // Save configuration to localStorage
    try {
        // Get existing saved configs
        const savedConfigs = JSON.parse(localStorage.getItem('dot1xer_saved_configs') || '[]');
        
        // Get vendor and platform info
        const selectedVendor = getSelectedVendor() || 'unknown';
        const platformSelect = document.getElementById('platform-select');
        const selectedPlatform = platformSelect ? platformSelect.value : 'unknown';
        
        // Create new config object
        const newConfig = {
            id: Date.now().toString(),
            name: configName,
            description: configDescription,
            vendor: selectedVendor,
            platform: selectedPlatform,
            config: config,
            timestamp: new Date().toISOString()
        };
        
        // Add to saved configs
        savedConfigs.push(newConfig);
        
        // Save back to localStorage
        localStorage.setItem('dot1xer_saved_configs', JSON.stringify(savedConfigs));
        
        // Close modal
        const modal = document.getElementById('save-config-modal');
        if (modal) {
            modal.classList.remove('visible');
        }
        
        // Show success message
        showAlert('Configuration saved successfully!', 'success');
        
        // Clear form
        document.getElementById('config-name').value = '';
        document.getElementById('config-description').value = '';
    } catch (error) {
        console.error('Error saving configuration:', error);
        showAlert('Error saving configuration: ' + error.message, 'danger');
    }
}

// Helper function to show alerts
    
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
