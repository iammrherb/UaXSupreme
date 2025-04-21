/**
 * UaXSupreme - Main Application JavaScript
 * Handles UI interactions, navigation, and application state
 */

document.addEventListener('DOMContentLoaded', function() {
    // Application state
    const appState = {
        currentStep: 'vendor-selection',
        vendorPlatforms: {
            'cisco': ['IOS', 'IOS-XE', 'WLC-9800', 'WLC-9800-CL', 'Catalyst 9800', 'ISE'],
            'aruba': ['AOS-CX', 'AOS-Switch', 'Instant On', 'Clearpass'],
            'juniper': ['Junos', 'Mist', 'EX Series', 'SRX Series'],
            'fortinet': ['FortiOS', 'FortiGate', 'FortiNAC', 'FortiAuthenticator'],
            'extreme': ['EXOS', 'VOSS', 'Fabric Engine', 'ExtremeControl'],
            'dell': ['OS10', 'PowerSwitch', 'SmartFabric']
        },
        vendor: '',
        platform: '',
        authMethods: [],
        deploymentType: 'monitor',
        radiusConfig: {
            servers: []
        },
        tacacsConfig: {
            servers: []
        },
        advancedFeatures: [],
        interfaceConfig: {},
        configOutput: ''
    };

    // Initialize UI
    initUI();
    attachEventListeners();

    /**
     * Initialize UI components
     */
    function initUI() {
        // Disable platform selector initially
        document.getElementById('platform').disabled = true;
        
        // Hide feature settings initially
        document.querySelectorAll('.feature-settings').forEach(el => {
            if (el.id !== 'criticalAuthSettings' && el.id !== 'daclSettings' && el.id !== 'profilingSettings') {
                el.style.display = 'none';
            }
        });
    }

    /**
     * Attach event listeners to UI elements
     */
    function attachEventListeners() {
        // Navigation steps
        document.querySelectorAll('.nav-steps li').forEach(step => {
            step.addEventListener('click', () => {
                navigateToStep(step.dataset.step);
            });
        });

        // Next/Back buttons
        document.querySelectorAll('.btn-next').forEach(btn => {
            btn.addEventListener('click', navigateNext);
        });

        document.querySelectorAll('.btn-back').forEach(btn => {
            btn.addEventListener('click', navigateBack);
        });

        // Finish button
        document.querySelector('.btn-finish').addEventListener('click', finishConfiguration);

        // Vendor selection
        document.getElementById('vendor').addEventListener('change', handleVendorChange);
        document.getElementById('platform').addEventListener('change', handlePlatformChange);

        // Tabs
        document.querySelectorAll('.tab').forEach(tab => {
            tab.addEventListener('click', () => {
                const tabGroup = tab.parentElement;
                const tabContentId = tab.dataset.tab;
                
                // Deactivate all tabs in this group
                tabGroup.querySelectorAll('.tab').forEach(t => {
                    t.classList.remove('active');
                });
                
                // Hide all tab contents for this group
                const tabContents = tabGroup.parentElement.querySelectorAll('.tab-content');
                tabContents.forEach(content => {
                    content.classList.remove('active');
                });
                
                // Activate selected tab and content
                tab.classList.add('active');
                document.getElementById(tabContentId).classList.add('active');
            });
        });

        // Authentication method checkboxes
        document.querySelectorAll('input[name="authMethod"]').forEach(checkbox => {
            checkbox.addEventListener('change', updateAuthMethods);
        });

        // Security features in Advanced section
        document.querySelectorAll('input[name="securityFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleSecurityFeature);
        });

        // Access features in Advanced section
        document.querySelectorAll('input[name="accessFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleAccessFeature);
        });

        // Guest features in Advanced section
        document.querySelectorAll('input[name="guestFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleGuestFeature);
        });

        // BYOD features in Advanced section
        document.querySelectorAll('input[name="byodFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleByodFeature);
        });

        // Generate configuration button
        document.getElementById('generateConfigBtn').addEventListener('click', generateConfiguration);
        
        // Copy configuration button
        document.getElementById('copyConfigBtn').addEventListener('click', copyConfiguration);
        
        // Download configuration button
        document.getElementById('downloadConfigBtn').addEventListener('click', downloadConfiguration);

        // Generate diagram button
        document.getElementById('generateDiagramBtn').addEventListener('click', generateDiagram);

        // Generate checklist button
        document.getElementById('generateChecklistBtn').addEventListener('click', generateChecklist);

        // Generate documentation button
        document.getElementById('generateDocBtn').addEventListener('click', generateDocumentation);

        // Help button
        document.getElementById('helpBtn').addEventListener('click', () => {
            document.getElementById('helpModal').style.display = 'block';
        });

        // AI Assistant button
        document.getElementById('aiAssistBtn').addEventListener('click', () => {
            document.getElementById('aiAssistantModal').style.display = 'block';
        });

        // Close modal buttons
        document.querySelectorAll('.close').forEach(closeBtn => {
            closeBtn.addEventListener('click', () => {
                closeBtn.closest('.modal').style.display = 'none';
            });
        });

        // Send message to AI Assistant
        document.getElementById('sendMessageBtn').addEventListener('click', sendMessageToAI);
        document.getElementById('userMessage').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                sendMessageToAI();
            }
        });

        // Suggestion buttons in AI Assistant
        document.querySelectorAll('.suggestion-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.getElementById('userMessage').value = btn.textContent;
                sendMessageToAI();
            });
        });

        // Help topics
        document.querySelectorAll('.help-topics li').forEach(topic => {
            topic.addEventListener('click', () => {
                document.querySelectorAll('.help-topics li').forEach(t => {
                    t.classList.remove('active');
                });
                topic.classList.add('active');
                loadHelpContent(topic.dataset.topic);
            });
        });

        // Save configuration button
        document.getElementById('saveConfigBtn').addEventListener('click', saveConfiguration);
        
        // Load configuration button
        document.getElementById('loadConfigBtn').addEventListener('click', loadConfiguration);

        // Window click to close modals when clicking outside
        window.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal')) {
                e.target.style.display = 'none';
            }
        });

        // Interface template buttons
        document.getElementById('templateAp').addEventListener('click', () => addInterfaceTemplate('ap'));
        document.getElementById('templateIpPhone').addEventListener('click', () => addInterfaceTemplate('ipphone'));
        document.getElementById('templatePrinter').addEventListener('click', () => addInterfaceTemplate('printer'));
        document.getElementById('templateServer').addEventListener('click', () => addInterfaceTemplate('server'));
        document.getElementById('templateUplink').addEventListener('click', () => addInterfaceTemplate('uplink'));
    }

    /**
     * Navigate to a specific step
     * @param {string} stepId - The ID of the step to navigate to
     */
    function navigateToStep(stepId) {
        // Hide all sections
        document.querySelectorAll('.config-section').forEach(section => {
            section.classList.remove('active');
        });
        
        // Show target section
        document.getElementById(stepId).classList.add('active');
        
        // Update active step in sidebar
        document.querySelectorAll('.nav-steps li').forEach(step => {
            step.classList.remove('active');
            if (step.dataset.step === stepId) {
                step.classList.add('active');
            }
        });
        
        // Update current step in state
        appState.currentStep = stepId;
    }

    /**
     * Navigate to the next step
     */
    function navigateNext() {
        const currentStepElement = document.querySelector(`.nav-steps li[data-step="${appState.currentStep}"]`);
        const nextStepElement = currentStepElement.nextElementSibling;
        
        if (nextStepElement) {
            navigateToStep(nextStepElement.dataset.step);
        }
    }

    /**
     * Navigate to the previous step
     */
    function navigateBack() {
        const currentStepElement = document.querySelector(`.nav-steps li[data-step="${appState.currentStep}"]`);
        const prevStepElement = currentStepElement.previousElementSibling;
        
        if (prevStepElement) {
            navigateToStep(prevStepElement.dataset.step);
        }
    }

    /**
     * Handle vendor selection change
     */
    function handleVendorChange() {
        const vendorSelect = document.getElementById('vendor');
        const platformSelect = document.getElementById('platform');
        const selectedVendor = vendorSelect.value;
        
        // Clear platform options
        platformSelect.innerHTML = '<option value="">-- Select Platform --</option>';
        
        if (selectedVendor) {
            // Enable platform selector
            platformSelect.disabled = false;
            
            // Add platform options for selected vendor
            const platforms = appState.vendorPlatforms[selectedVendor] || [];
            platforms.forEach(platform => {
                const option = document.createElement('option');
                option.value = platform;
                option.textContent = platform;
                platformSelect.appendChild(option);
            });
            
            // Update state
            appState.vendor = selectedVendor;
        } else {
            // Disable platform selector if no vendor selected
            platformSelect.disabled = true;
            appState.vendor = '';
        }
        
        // Hide platform info
        document.querySelector('.platform-info').classList.add('hidden');
    }

    /**
     * Handle platform selection change
     */
    function handlePlatformChange() {
        const platformSelect = document.getElementById('platform');
        const selectedPlatform = platformSelect.value;
        
        if (selectedPlatform) {
            // Update state
            appState.platform = selectedPlatform;
            
            // Show platform info
            const platformInfo = document.querySelector('.platform-info');
            platformInfo.classList.remove('hidden');
            
            // Update platform info content
            const platformInfoContent = document.getElementById('platformInfoContent');
            platformInfoContent.innerHTML = generatePlatformInfo(appState.vendor, selectedPlatform);
        } else {
            appState.platform = '';
            document.querySelector('.platform-info').classList.add('hidden');
        }
    }

    /**
     * Update authentication methods in state based on checkbox selection
     */
    function updateAuthMethods() {
        const authMethodCheckboxes = document.querySelectorAll('input[name="authMethod"]:checked');
        appState.authMethods = Array.from(authMethodCheckboxes).map(cb => cb.value);
    }

    /**
     * Toggle security feature settings visibility
     */
    function toggleSecurityFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Toggle access feature settings visibility
     */
    function toggleAccessFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Toggle guest feature settings visibility
     */
    function toggleGuestFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Toggle BYOD feature settings visibility
     */
    function toggleByodFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Generate platform information HTML
     * @param {string} vendor - The selected vendor
     * @param {string} platform - The selected platform
     * @returns {string} HTML content for platform information
     */
    function generatePlatformInfo(vendor, platform) {
        let html = '';
        
        // Vendor-specific platform information
        switch (vendor) {
            case 'cisco':
                switch (platform) {
                    case 'IOS':
                        html = `
                            <p><strong>Cisco IOS</strong> is the traditional software used on older Cisco switches like the Catalyst 2960, 3560, and 3750 series.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAB, WebAuth</p>
                            <p><strong>Firmware Recommendation:</strong> At least 15.2(4)E or later for IBNS 2.0 support</p>
                            <p><strong>Configuration Model:</strong> Uses IBNS 2.0 with Class Maps and Policy Maps</p>
                        `;
                        break;
                    case 'IOS-XE':
                        html = `
                            <p><strong>Cisco IOS-XE</strong> is the modern Linux-based OS used on Catalyst 9000 series switches.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAB, WebAuth, MACsec, RadSec</p>
                            <p><strong>Firmware Recommendation:</strong> 16.9.x or later for full feature support</p>
                            <p><strong>Configuration Model:</strong> Uses IBNS 2.0 with Class Maps and Policy Maps with enhanced features</p>
                        `;
                        break;
                    case 'WLC-9800':
                        html = `
                            <p><strong>Cisco Catalyst 9800 WLC</strong> is the modern wireless controller platform for Catalyst 9100 access points.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAB, WebAuth, Central/Local Web Auth</p>
                            <p><strong>Firmware Recommendation:</strong> 17.3.x or later for optimal security features</p>
                            <p><strong>Administration:</strong> Supports both RADIUS and TACACS+ for device administration</p>
                        `;
                        break;
                    default:
                        html = `<p>Information about ${platform} will be displayed here.</p>`;
                }
                break;
            case 'aruba':
                switch (platform) {
                    case 'AOS-CX':
                        html = `
                            <p><strong>Aruba AOS-CX</strong> is Aruba's modern, cloud-native network operating system.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAC Authentication, Captive Portal</p>
                            <p><strong>Firmware Recommendation:</strong> 10.8.x or later for enhanced authentication features</p>
                            <p><strong>Configuration Model:</strong> Uses CLI or Aruba Central for cloud management</p>
                        `;
                        break;
                    case 'AOS-Switch':
                        html = `
                            <p><strong>Aruba AOS-Switch</strong> (formerly known as ProVision) is used on older Aruba/HP switches.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAC Authentication, Web Authentication</p>
                            <p><strong>Firmware Recommendation:</strong> WC.16.10.x or later for best security support</p>
                            <p><strong>Configuration Model:</strong> Uses traditional CLI commands with some differences from Cisco syntax</p>
                        `;
                        break;
                    default:
                        html = `<p>Information about ${platform} will be displayed here.</p>`;
                }
                break;
            default:
                html = `<p>Information about ${vendor} ${platform} will be displayed here.</p>`;
        }
        
        return html;
    }

    /**
     * Generate configuration based on user selections
     */
    function generateConfiguration() {
        // Collect all configuration parameters
        const configParams = collectConfigParameters();
        
        // Call template generator to create configuration
        if (window.TemplateGenerator) {
            try {
                const config = window.TemplateGenerator.generateConfig(configParams);
                displayConfiguration(config);
                
                // Update state
                appState.configOutput = config;
                
                // Show validation results
                validateConfiguration(config);
            } catch (error) {
                console.error('Error generating configuration:', error);
                alert('Error generating configuration. Please check console for details.');
            }
        } else {
            console.error('TemplateGenerator not loaded');
            alert('Template generator module not loaded. Please refresh the page and try again.');
        }
    }

    /**
     * Collect all configuration parameters from the UI
     * @returns {Object} Configuration parameters
     */
    function collectConfigParameters() {
        // Basic vendor and platform info
        const configParams = {
            vendor: document.getElementById('vendor').value,
            platform: document.getElementById('platform').value,
            softwareVersion: document.getElementById('softwareVersion').value,
            
            // Authentication methods
            authMethods: Array.from(document.querySelectorAll('input[name="authMethod"]:checked')).map(cb => cb.value),
            deploymentType: document.getElementById('deploymentType').value,
            
            // RADIUS configuration
            radius: {
                serverGroup: document.getElementById('radiusServerGroup').value,
                timeout: document.getElementById('radiusTimeout').value,
                servers: [
                    {
                        name: document.getElementById('radiusServer1Name').value,
                        ip: document.getElementById('radiusServer1').value,
                        authPort: document.getElementById('radiusPort1').value,
                        acctPort: document.getElementById('radiusAcctPort1').value,
                        key: document.getElementById('radiusKey1').value
},
                    {
                        name: document.getElementById('radiusServer2Name').value,
                        ip: document.getElementById('radiusServer2').value,
                        authPort: document.getElementById('radiusPort2').value,
                        acctPort: document.getElementById('radiusAcctPort2').value,
                        key: document.getElementById('radiusKey2').value
                    }
                ],
                attributes: {
                    nasId: document.getElementById('radiusNasId').checked,
                    nasIp: document.getElementById('radiusNasIp').checked,
                    serviceType: document.getElementById('radiusServiceType').checked,
                    calledStationId: document.getElementById('radiusCalledStationId').checked,
                    callingStationId: document.getElementById('radiusCallingStationId').checked
                },
                macFormat: document.getElementById('radiusMacFormat').value,
                nasIdentifier: document.getElementById('nasIdentifier').value,
                advanced: {
                    loadBalance: document.getElementById('radiusLoadBalance').checked,
                    deadtime: document.getElementById('radiusDeadtime').checked,
                    sourceInterface: document.getElementById('radiusSourceInterface').checked,
                    coa: document.getElementById('radiusCoA').checked,
                    serverProbe: document.getElementById('radiusServerProbe').checked,
                    deadtimeValue: document.getElementById('radiusDeadtimeValue').value,
                    retransmit: document.getElementById('radiusRetransmit').value,
                    sourceInterfaceValue: document.getElementById('radiusSourceInterfaceValue').value,
                    testUsername: document.getElementById('radiusTestUsername').value,
                    deadCriteria: document.getElementById('radiusDeadCriteria').value,
                    loadBalanceMethod: document.getElementById('radiusLoadBalanceMethod').value
                }
            },

            // TACACS+ configuration
            tacacs: {
                serverGroup: document.getElementById('tacacsServerGroup').value,
                timeout: document.getElementById('tacacsTimeout').value,
                servers: [
                    {
                        name: document.getElementById('tacacsServer1Name').value,
                        ip: document.getElementById('tacacsServer1').value,
                        port: document.getElementById('tacacsPort1').value,
                        key: document.getElementById('tacacsKey1').value
                    },
                    {
                        name: document.getElementById('tacacsServer2Name').value,
                        ip: document.getElementById('tacacsServer2').value,
                        port: document.getElementById('tacacsPort2').value,
                        key: document.getElementById('tacacsKey2').value
                    }
                ],
                sourceInterface: document.getElementById('tacacsSourceInterface').value,
                authMethod: document.getElementById('tacacsAuthMethod').value,
                authzMethod: document.getElementById('tacacsAuthzMethod').value,
                authMethodType: document.querySelector('input[name="tacacsAuthMethodType"]:checked').value,
                authorization: {
                    console: document.getElementById('tacacsAuthzConsole').checked,
                    commands: document.getElementById('tacacsAuthzCommands').checked,
                    config: document.getElementById('tacacsAuthzConfig').checked,
                    ifAuthenticated: document.getElementById('tacacsAuthzIfAuthenticated').value
                },
                accounting: {
                    commands: document.getElementById('tacacsAcctCommands').checked,
                    exec: document.getElementById('tacacsAcctExec').checked,
                    system: document.getElementById('tacacsAcctSystem').checked,
                    commandLevels: Array.from(document.getElementById('tacacsAcctCommandLevel').selectedOptions).map(opt => opt.value),
                    method: document.getElementById('tacacsAcctMethod').value
                }
            },

            // Advanced features
            advancedFeatures: {
                security: {
                    criticalAuth: document.getElementById('featureCriticalAuth').checked,
                    macSec: document.getElementById('featureMacSec').checked,
                    radSec: document.getElementById('featureRadSec').checked,
                    coa: document.getElementById('featureCoa').checked,
                    criticalSettings: {
                        dataVlan: document.getElementById('criticalDataVlan').value,
                        voiceVlan: document.getElementById('criticalVoiceVlan').value,
                        recoveryDelay: document.getElementById('criticalRecoveryDelay').value
                    },
                    macSecSettings: {
                        policy: document.getElementById('macSecPolicy')?.value,
                        cipherSuite: document.getElementById('macSecCipherSuite')?.value
                    },
                    radSecSettings: {
                        server: document.getElementById('radSecServer')?.value,
                        port: document.getElementById('radSecPort')?.value,
                        certPath: document.getElementById('radSecCertPath')?.value
                    }
                },
                access: {
                    dacl: document.getElementById('featureDacl').checked,
                    sgt: document.getElementById('featureSgt').checked,
                    vlan: document.getElementById('featureVlan').checked,
                    posture: document.getElementById('featurePosture').checked,
                    profiling: document.getElementById('featureProfiling').checked,
                    daclSettings: {
                        fallback: document.getElementById('daclFallback').value,
                        timeout: document.getElementById('daclTimeout').value
                    },
                    sgtSettings: {
                        propagation: document.getElementById('sgtPropagation')?.value
                    },
                    profilingSettings: {
                        dhcp: document.getElementById('sensorDhcp').checked,
                        cdp: document.getElementById('sensorCdp').checked,
                        lldp: document.getElementById('sensorLldp').checked,
                        accounting: document.getElementById('sensorAccounting').value
                    }
                },
                guest: {
                    webAuth: document.getElementById('featureWebAuth').checked,
                    guestVlan: document.getElementById('featureGuestVlan').checked,
                    redirect: document.getElementById('featureRedirect').checked,
                    webAuthSettings: {
                        type: document.getElementById('webAuthType')?.value,
                        portal: document.getElementById('webAuthPortal')?.value
                    },
                    guestVlanSettings: {
                        id: document.getElementById('guestVlanId')?.value,
                        timeout: document.getElementById('guestTimeout')?.value
                    }
                },
                byod: {
                    provisioning: document.getElementById('featureProvisioning').checked,
                    deviceReg: document.getElementById('featureDeviceReg').checked,
                    certOnboard: document.getElementById('featureCertOnboard').checked,
                    provisioningSettings: {
                        vlan: document.getElementById('provisioningVlan')?.value,
                        url: document.getElementById('provisioningUrl')?.value
                    },
                    certOnboardSettings: {
                        provider: document.getElementById('certProvider')?.value,
                        url: document.getElementById('certUrl')?.value
                    }
                }
            },

            // Interface configuration
            interfaces: {
                access: {
                    range: document.getElementById('accessInterfaceRange').value,
                    vlan: document.getElementById('accessVlan').value,
                    voiceVlan: document.getElementById('voiceVlan').value,
                    settings: {
                        nonegotiate: document.getElementById('portNonegotiate').checked,
                        portfast: document.getElementById('portPortfast').checked,
                        bpduguard: document.getElementById('portBpduguard').checked,
                        rootguard: document.getElementById('portRootguard').checked,
                        stormControl: document.getElementById('portStormControl').checked
                    },
                    dot1x: {
                        hostMode: document.getElementById('dot1xHostMode').value,
                        controlDirection: document.getElementById('dot1xControlDirection').value,
                        txPeriod: document.getElementById('dot1xTxPeriod').value,
                        maxReauthReq: document.getElementById('dot1xMaxReauthReq').value,
                        inactivityTimer: document.getElementById('inactivityTimer').value
                    }
                },
                trunk: {
                    range: document.getElementById('trunkInterfaceRange').value,
                    nativeVlan: document.getElementById('nativeVlan').value,
                    allowedVlans: document.getElementById('allowedVlans').value,
                    settings: {
                        nonegotiate: document.getElementById('trunkNonegotiate').checked,
                        dhcpSnooping: document.getElementById('trunkDhcpSnooping').checked,
                        arpInspection: document.getElementById('trunkArpInspection').checked,
                        disableTracking: document.getElementById('trunkDisableTrackingIp').checked,
                        noMonitor: document.getElementById('trunkNoMonitor').checked
                    }
                },
                specific: document.getElementById('specificInterfaces').value
            }
        };

        return configParams;
    }

    /**
     * Display generated configuration in the output area
     * @param {string} config - Generated configuration
     */
    function displayConfiguration(config) {
        const configOutput = document.getElementById('configOutput');
        configOutput.value = config;
    }

    /**
     * Validate the generated configuration
     * @param {string} config - Generated configuration
     */
    function validateConfiguration(config) {
        // Call validation module to check configuration
        if (window.ConfigValidator) {
            try {
                const validationResults = window.ConfigValidator.validate(config);

                // Show validation results
                const validationContainer = document.querySelector('.config-validation');
                const validationResultsElem = document.getElementById('validationResults');

                validationContainer.classList.remove('hidden');

                if (validationResults.valid) {
                    validationResultsElem.innerHTML = `
                        <div class="validation-success">
                            <i class="fas fa-check-circle"></i> Configuration validated successfully.
                        </div>
                    `;
                } else {
                    let issuesHtml = '<div class="validation-error"><i class="fas fa-exclamation-circle"></i> Configuration has issues:</div><ul>';

                    validationResults.issues.forEach(issue => {
                        issuesHtml += `<li>${issue}</li>`;
                    });

                    issuesHtml += '</ul>';
                    validationResultsElem.innerHTML = issuesHtml;
                }
            } catch (error) {
                console.error('Error validating configuration:', error);
            }
        }
    }

    /**
     * Copy configuration to clipboard
     */
    function copyConfiguration() {
        const configOutput = document.getElementById('configOutput');
        configOutput.select();
        document.execCommand('copy');

        // Show a brief "Copied!" message
        const copyBtn = document.getElementById('copyConfigBtn');
        const originalText = copyBtn.innerHTML;
        copyBtn.innerHTML = '<i class="fas fa-check"></i> Copied!';

        setTimeout(() => {
            copyBtn.innerHTML = originalText;
        }, 2000);
    }

    /**
     * Download configuration as a text file
     */
    function downloadConfiguration() {
        const configOutput = document.getElementById('configOutput');
        const config = configOutput.value;

        if (!config.trim()) {
            alert('Please generate a configuration first.');
            return;
        }

        const vendor = document.getElementById('vendor').value;
        const platform = document.getElementById('platform').value;
        const fileName = `${vendor}_${platform}_config.txt`;

        const element = document.createElement('a');
        element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(config));
        element.setAttribute('download', fileName);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);
    }

    /**
     * Generate network diagram
     */
    function generateDiagram() {
        const diagramType = document.getElementById('diagramType').value;
        const diagramPreview = document.getElementById('diagramPreview');

        // This is a placeholder - in a real implementation, this would generate an actual diagram
        diagramPreview.innerHTML = `
            <div style="text-align: center;">
                <p><i class="fas fa-project-diagram" style="font-size: 48px; color: var(--primary-color);"></i></p>
                <p>${diagramType.charAt(0).toUpperCase() + diagramType.slice(1)} Diagram</p>
                <p style="font-style: italic;">This is a placeholder for the actual diagram generation.</p>
            </div>
        `;
    }

    /**
     * Generate deployment checklist
     */
    function generateChecklist() {
        const checklistType = document.getElementById('checklistType').value;
        const checklistPreview = document.getElementById('checklistPreview');

        // Sample checklist items based on type
        let checklistItems = [];

        switch (checklistType) {
            case 'deployment':
                checklistItems = [
                    'Verify network hardware is installed and powered on',
                    'Configure IP addressing and VLANs',
                    'Configure RADIUS/TACACS+ servers',
                    'Configure switch ports for authentication',
                    'Test authentication with a sample device',
                    'Deploy to test user group',
                    'Monitor for issues',
                    'Roll out to production'
                ];
                break;
            case 'testing':
                checklistItems = [
                    'Test 802.1X authentication with compliant device',
                    'Test MAB authentication with non-compliant device',
                    'Test with various device types (Workstation, Phone, Printer)',
                    'Test RADIUS server failover',
                    'Test with wrong credentials',
                    'Test CoA functionality',
                    'Test High Availability',
                    'Verify logging and accounting'
                ];
                break;
            case 'validation':
                checklistItems = [
                    'Validate RADIUS server configuration',
                    'Validate switch port configuration',
                    'Validate security features (DHCP Snooping, ARP Inspection)',
                    'Validate user access policies',
                    'Validate guest access',
                    'Validate reporting and monitoring',
                    'Validate documentation',
                    'Validate troubleshooting procedures'
                ];
                break;
            case 'all':
                checklistItems = [
                    'Pre-Deployment: Hardware inventory check',
                    'Pre-Deployment: Network diagram review',
                    'Pre-Deployment: Server preparation',
                    'Deployment: Configure RADIUS/TACACS+ servers',
                    'Deployment: Configure switch authentication',
                    'Testing: Test with compliant devices',
                    'Testing: Test with non-compliant devices',
                    'Testing: Verify failover functionality',
                    'Validation: Validate user access',
                    'Validation: Validate security features',
                    'Post-Deployment: Documentation',
                    'Post-Deployment: Training',
                    'Post-Deployment: Monitoring setup'
                ];
                break;
        }

        // Generate HTML for checklist
        let checklistHtml = '';

        checklistItems.forEach((item, index) => {
            checklistHtml += `
                <div class="checklist-item">
                    <input type="checkbox" id="check-${index}">
                    <label for="check-${index}">${item}</label>
                </div>
            `;
        });

        checklistPreview.innerHTML = checklistHtml;
    }

    /**
     * Generate project documentation
     */
    function generateDocumentation() {
        // This would be implemented to generate actual documentation
        // For now, just show a message
        alert('Documentation generation feature will be implemented in a future update.');
    }

    /**
     * Save the current configuration state
     */
    function saveConfiguration() {
        // Collect all configuration parameters
        const configParams = collectConfigParameters();

        // Convert to JSON and encode for storage
        const configJson = JSON.stringify(configParams);
        const configData = btoa(configJson);

        // Create a downloadable file
        const fileName = `UaXSupreme_Config_${new Date().toISOString().slice(0, 10)}.json`;

        const element = document.createElement('a');
        element.setAttribute('href', 'data:application/json;charset=utf-8,' + encodeURIComponent(configJson));
        element.setAttribute('download', fileName);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);

        alert(`Configuration saved as ${fileName}`);
    }

    /**
     * Load a saved configuration
     */
    function loadConfiguration() {
        // Create a file input element
        const fileInput = document.createElement('input');
        fileInput.type = 'file';
        fileInput.accept = '.json';
        fileInput.style.display = 'none';

        fileInput.addEventListener('change', function(e) {
            const file = e.target.files[0];

            if (file) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    try {
                        const configParams = JSON.parse(e.target.result);

                        // Apply loaded configuration to UI
                        applyConfigurationToUI(configParams);

                        alert('Configuration loaded successfully.');
                    } catch (error) {
                        console.error('Error parsing configuration file:', error);
                        alert('Error loading configuration. Invalid file format.');
                    }
                };

                reader.readAsText(file);
            }
        });

        document.body.appendChild(fileInput);
        fileInput.click();
        document.body.removeChild(fileInput);
    }

    /**
     * Apply loaded configuration to UI
     * @param {Object} configParams - Configuration parameters
     */
    function applyConfigurationToUI(configParams) {
        // This is a placeholder - in a real implementation, this would populate all UI elements
        // with the values from the loaded configuration

        // For now, just set the basic values
        if (configParams.vendor) {
            document.getElementById('vendor').value = configParams.vendor;
            handleVendorChange();
        }

        if (configParams.platform) {
            document.getElementById('platform').value = configParams.platform;
            handlePlatformChange();
        }

        if (configParams.softwareVersion) {
            document.getElementById('softwareVersion').value = configParams.softwareVersion;
        }

        // More detailed implementation would be needed to restore all settings
    }

    /**
     * Send message to AI Assistant
     */
    function sendMessageToAI() {
        const userMessage = document.getElementById('userMessage');
        const message = userMessage.value.trim();

        if (!message) {
            return;
        }

        // Add user message to chat
        addMessageToChat('user', message);

        // Clear input
        userMessage.value = '';

        // Simulate AI response
        simulateAIResponse(message);
    }

    /**
     * Add message to chat
     * @param {string} sender - 'user' or 'ai'
     * @param {string} message - Message content
     */
    function addMessageToChat(sender, message) {
        const chatMessages = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');

        messageDiv.className = sender === 'user' ? 'user-message' : 'ai-message';

        const avatarDiv = document.createElement('div');
        avatarDiv.className = 'message-avatar';
        avatarDiv.innerHTML = sender === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';

        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        contentDiv.innerHTML = formatMessageContent(message);

        messageDiv.appendChild(avatarDiv);
        messageDiv.appendChild(contentDiv);

        chatMessages.appendChild(messageDiv);

        // Scroll to bottom
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    /**
     * Format message content with HTML
     * @param {string} message - Message content
     * @returns {string} Formatted HTML
     */
    function formatMessageContent(message) {
        // Simple formatting for now
        const paragraphs = message.split('\n\n');

        return paragraphs.map(p => `<p>${p}</p>`).join('');
    }

    /**
     * Simulate AI response (placeholder for real AI implementation)
     * @param {string} userMessage - User's message
     */
    function simulateAIResponse(userMessage) {
        const lowerMessage = userMessage.toLowerCase();
        let response = '';

        // Simulate thinking time
        setTimeout(() => {
            // Simple keyword-based responses
            if (lowerMessage.includes('monitor mode') || lowerMessage.includes('open mode')) {
                response = `Monitor Mode (or Open Mode) allows 802.1X authentication to run without enforcing it. This means:\n\n1. The switch will try to authenticate devices\n\n2. If authentication fails, devices will still be allowed network access\n\n3. This is ideal for testing and initial deployment phases\n\n4. You can monitor what would happen in real enforcement without impacting users`;
            } else if (lowerMessage.includes('closed mode')) {
                response = `Closed Mode is when 802.1X authentication is fully enforced. This means:\n\n1. The switch requires successful authentication before granting network access\n\n2. Unauthenticated devices will be denied access (except to authentication servers)\n\n3. This is used for full security enforcement\n\n4. Use this after thorough testing in Monitor Mode`;
            } else if (lowerMessage.includes('troubleshoot') || lowerMessage.includes('fail')) {
                response = `To troubleshoot 802.1X authentication failures:\n\n1. Check switch configuration with "show authentication sessions interface X"\n\n2. Verify RADIUS server connectivity with "test aaa server radius X"\n\n3. Check for port security or other conflicting features\n\n4. Use debug commands like "debug dot1x all" (use cautiously in production)\n\n5. Check client supplicant configuration\n\n6. Verify certificate validity if using EAP-TLS`;
            } else if (lowerMessage.includes('radius') && lowerMessage.includes('redundancy')) {
                response = `Best practices for RADIUS server redundancy:\n\n1. Configure at least two RADIUS servers\n\n2. Use server groups with proper failover timeouts\n\n3. Set appropriate deadtime values (typically 15-20 minutes)\n\n4. Use the server-probing feature to detect dead servers\n\n5. Configure proper source interface for RADIUS communication\n\n6. Consider RadSec for encrypted and reliable RADIUS communication`;
            } else if (lowerMessage.includes('mab') && lowerMessage.includes('printer')) {
                response = `To configure MAB for printers:\n\n1. Enable MAC Authentication Bypass on the switch port\n\n2. Add the printer's MAC address to your RADIUS server\n\n3. Set appropriate authorization policies in your RADIUS server\n\n4. Consider using device profiling to identify printers automatically\n\n5. Assign printers to a specific VLAN via RADIUS attributes\n\n6. Implement DACs to restrict printer access to required services only`;
            } else {
                response = `Thanks for your question. As an AI assistant for UaXSupreme, I can help with network authentication configuration. Could you provide more specific details about what you'd like to learn about 802.1X, MAB, RADIUS, or TACACS+ configuration?`;
            }

            addMessageToChat('ai', response);
        }, 1000);
    }

    /**
     * Load help content
     * @param {string} topic - Help topic to load
     */
    function loadHelpContent(topic) {
        const helpContentArea = document.getElementById('helpContentArea');
        let content = '';

        switch (topic) {
            case 'overview':
                content = `
                    <h3>UaXSupreme Help</h3>
                    <p>UaXSupreme is a comprehensive platform for configuring 802.1X, MAB, RADIUS, TACACS+, and advanced authentication features for all major network vendors.</p>
                    <p>Select a topic from the left navigation menu to view detailed help information.</p>

                    <h4>Getting Started</h4>
                    <ol>
                        <li>Begin by selecting your network vendor and platform in the Vendor Selection section.</li>
                        <li>Choose authentication methods that you want to implement.</li>
                        <li>Configure RADIUS and/or TACACS+ servers as needed.</li>
                        <li>Set up advanced features for your implementation.</li>
                        <li>Configure interfaces for authentication.</li>
                        <li>Generate and review the configuration.</li>
                        <li>Generate documentation for your implementation.</li>
                    </ol>

                    <p>For additional assistance, use the AI Assistant by clicking the robot icon in the top navigation bar.</p>
                `;
                break;
            case 'vendorSelection':
                content = `
                    <h3>Vendor Selection</h3>
                    <p>The Vendor Selection section allows you to specify the network vendor and platform for which you want to generate configuration.</p>

                    <h4>Supported Vendors</h4>
                    <ul>
                        <li><strong>Cisco</strong>: IOS, IOS-XE, WLC-9800, and more</li>
                        <li><strong>Aruba/HP</strong>: AOS-CX, AOS-Switch, and more</li>
                        <li><strong>Juniper</strong>: Junos and related platforms</li>
                        <li><strong>Fortinet</strong>: FortiOS and related platforms</li>
                        <li><strong>Extreme</strong>: EXOS and related platforms</li>
                        <li><strong>Dell</strong>: OS10 and related platforms</li>
                    </ul>

                    <h4>Software Version</h4>
                    <p>Enter the software version of your network device to ensure compatibility with generated configurations. The application will warn you if certain features require newer software versions.</p>

                    <h4>Platform Information</h4>
                    <p>After selecting a vendor and platform, you'll see additional information about the selected platform, including supported authentication methods and recommended firmware versions.</p>
                `;
                break;
            case 'authentication':
                content = `
                    <h3>Authentication Methods</h3>
                    <p>This section allows you to select the authentication methods you want to implement.</p>

                    <h4>Available Methods</h4>
                    <ul>
                        <li><strong>802.1X Authentication</strong>: Port-based network access control for wired and wireless networks</li>
                        <li><strong>MAC Authentication Bypass (MAB)</strong>: Authentication based on MAC address for devices that don't support 802.1X</li>
                        <li><strong>Web Authentication</strong>: Browser-based authentication for guest access</li>
                        <li><strong>RadSec</strong>: Secure RADIUS communications over TLS</li>
                        <li><strong>TACACS+</strong>: Authentication, authorization, and accounting for network devices</li>
                        <li><strong>MACsec</strong>: Layer 2 encryption for secure communications</li>
                    </ul>

                    <h4>Deployment Types</h4>
                    <ul>
                        <li><strong>Monitor Mode (Open)</strong>: Authentication is performed but not enforced</li>
                        <li><strong>Closed Mode</strong>: Full enforcement of authentication</li>
                        <li><strong>Standard</strong>: 802.1X is tried first, then MAB if 802.1X fails</li>
                        <li><strong>Concurrent</strong>: 802.1X and MAB are tried simultaneously</li>
                        <li><strong>High Security</strong>: Strict enforcement with additional security features</li>
                    </ul>

                    <h4>Security Features</h4>
                    <p>You can also select additional security features like DHCP Snooping, Dynamic ARP Inspection, IP Source Guard, Port Security, and Storm Control.</p>
                `;
                break;
            // Add more help topics as needed
            default:
                content = `<p>Help content for "${topic}" will be available soon.</p>`;
        }

        helpContentArea.innerHTML = content;
    }

    /**
     * Add interface template to specific interfaces textarea
     * @param {string} templateType - Type of template to add
     */
    function addInterfaceTemplate(templateType) {
        const specificInterfaces = document.getElementById('specificInterfaces');
        let template = '';

        switch (templateType) {
            case 'ap':
                template = `interface GigabitEthernet1/0/10
 description Access Point
 switchport mode access
 switchport access vlan 10
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping limit rate 20

`;
                break;
            case 'ipphone':
                template = `interface GigabitEthernet1/0/11
 description IP Phone
 switchport mode access
 switchport access vlan 10
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping limit rate 20
 mab
 dot1x pae authenticator
 dot1x timeout tx-period 5
 dot1x max-reauth-req 2
 authentication periodic
 authentication timer reauthenticate server

`;
                break;
            case 'printer':
                template = `interface GigabitEthernet1/0/12
 description Printer
 switchport mode access
 switchport access vlan 30
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping limit rate 20
 mab
 dot1x timeout tx-period 5

`;
                break;
            case 'server':
                template = `interface GigabitEthernet1/0/13
 description Server
 switchport mode access
 switchport access vlan 100
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping trust

`;
                break;
            case 'uplink':
                template = `interface TenGigabitEthernet1/1/1
 description Uplink to Core
 switchport mode trunk
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,100
 switchport nonegotiate
 spanning-tree guard root
 ip dhcp snooping trust
 no ip device tracking

`;
                break;
        }

        specificInterfaces.value += template;
    }

    /**
     * Finish configuration and show completion message
     */
    function finishConfiguration() {
        alert('Configuration complete! You can now download your configuration and documentation.');
    }
});
