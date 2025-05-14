/**
 * UaXSupreme - Template Generator
 * Generates configuration templates for network devices
 */

(function() {
    'use strict';

    // Template Generator object
    const TemplateGenerator = {
        /**
         * Initialize Template Generator
         */
        init: function() {
            console.log('Initializing Template Generator...');
            
            // Set up event listeners
            this.setupEventListeners();
            
            // Add templates to storage
            this.loadTemplates();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Generate configuration button
            const generateConfigBtn = document.getElementById('generateConfigBtn');
            if (generateConfigBtn) {
                generateConfigBtn.addEventListener('click', this.generateConfiguration.bind(this));
            }
            
            // Template type selector
            const templateType = document.getElementById('templateType');
            if (templateType) {
                templateType.addEventListener('change', this.updateTemplateContent.bind(this));
            }
            
            // Add interface templates
            const templateButtons = document.querySelectorAll('.template-buttons button');
            templateButtons.forEach(button => {
                button.addEventListener('click', this.addInterfaceTemplate.bind(this, button.id.replace('template', '').toLowerCase()));
            });
            
            // Create template button
            const createTemplateBtn = document.getElementById('createTemplateBtn');
            if (createTemplateBtn) {
                createTemplateBtn.addEventListener('click', this.createTemplate.bind(this));
            }
            
            // Reauthentication period
            const reauthPeriod = document.getElementById('reauthPeriod');
            if (reauthPeriod) {
                reauthPeriod.addEventListener('change', function() {
                    const customGroup = document.getElementById('customReauthPeriodGroup');
                    if (customGroup) {
                        customGroup.style.display = this.value === 'custom' ? 'block' : 'none';
                    }
                });
            }
            
            // Trunk encapsulation
            const trunkEncapsulation = document.getElementById('trunkEncapsulation');
            if (trunkEncapsulation) {
                trunkEncapsulation.addEventListener('change', function() {
                    const encapsulationGroup = document.getElementById('encapsulationGroup');
                    if (encapsulationGroup) {
                        encapsulationGroup.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }
            
            // Command sets
            const cmdSetCustom = document.getElementById('cmdSetCustom');
            if (cmdSetCustom) {
                cmdSetCustom.addEventListener('change', function() {
                    const customCmdSet = document.getElementById('customCmdSet');
                    if (customCmdSet) {
                        customCmdSet.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }
            
            // Default command sets
            const cmdSetDefault = document.getElementById('cmdSetDefault');
            if (cmdSetDefault) {
                cmdSetDefault.addEventListener('change', function() {
                    const defaultCmdSets = document.getElementById('defaultCmdSets');
                    if (defaultCmdSets) {
                        defaultCmdSets.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }
            
            // Command privilege add button
            const addCommandBtn = document.getElementById('addCommandBtn');
            if (addCommandBtn) {
                addCommandBtn.addEventListener('click', this.addCommandRow.bind(this));
            }
            
            // Copy configuration button
            const copyConfigBtn = document.getElementById('copyConfigBtn');
            if (copyConfigBtn) {
                copyConfigBtn.addEventListener('click', this.copyToClipboard.bind(this));
            }
            
            // Download configuration button
            const downloadConfigBtn = document.getElementById('downloadConfigBtn');
            if (downloadConfigBtn) {
                downloadConfigBtn.addEventListener('click', this.downloadConfiguration.bind(this));
            }
            
            // Attribute customization level
            const attrCustomizationLevel = document.getElementById('attrCustomizationLevel');
            if (attrCustomizationLevel) {
                attrCustomizationLevel.addEventListener('change', function() {
                    const customAttributesSection = document.getElementById('customAttributesSection');
                    if (customAttributesSection) {
                        customAttributesSection.style.display = this.value === 'custom' ? 'block' : 'none';
                    }
                });
            }
            
            // Feature checkboxes
            const featureCheckboxes = document.querySelectorAll('.checkbox-item input[type="checkbox"]');
            featureCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', this.handleFeatureToggle.bind(this));
            });
            
            // Validation level
            const validationLevel = document.getElementById('validationLevel');
            if (validationLevel) {
                validationLevel.addEventListener('change', this.updateValidationOptions.bind(this));
            }
            
            // Validate configuration button
            const validateConfigBtn = document.getElementById('validateConfigBtn');
            if (validateConfigBtn) {
                validateConfigBtn.addEventListener('click', this.validateConfiguration.bind(this));
            }
            
            // Deployment method
            const deploymentMethod = document.getElementById('deploymentMethod');
            if (deploymentMethod) {
                deploymentMethod.addEventListener('change', this.updateDeploymentOptions.bind(this));
            }
            
            // Deployment schedule
            const deploymentSchedule = document.getElementById('deploymentSchedule');
            if (deploymentSchedule) {
                deploymentSchedule.addEventListener('change', function() {
                    const scheduledDeployment = document.getElementById('scheduledDeployment');
                    if (scheduledDeployment) {
                        scheduledDeployment.style.display = this.value === 'scheduled' ? 'block' : 'none';
                    }
                });
            }
            
            // Authentication method checkboxes
            const authMethodCheckboxes = document.querySelectorAll('input[name="authMethod"]');
            authMethodCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', this.showMethodInfo.bind(this));
            });
            
            // Security feature checkboxes for macSec
            const macSecCheckbox = document.getElementById('macsec');
            if (macSecCheckbox) {
                macSecCheckbox.addEventListener('change', function() {
                    // Show MACsec settings in Advanced Features section when MACsec is checked
                    const macSecSettings = document.getElementById('macSecSettings');
                    if (macSecSettings) {
                        macSecSettings.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }

            // Monitor authentication method checkboxes
            const authMethodToggles = document.querySelectorAll('input[name="authMethod"]');
            if (authMethodToggles.length > 0) {
                authMethodToggles.forEach(toggle => {
                    toggle.addEventListener('change', function() {
                        // Update dependent sections based on enabled authentication methods
                        TemplateGenerator.updateDependentSections();
                    });
                });
            }
        },
        
        /**
         * Load templates into local storage
         */
        loadTemplates: function() {
            // Default templates
            const defaultTemplates = {
                dot1x: {
                    name: 'WIRED_DOT1X_CLOSED',
                    type: '802.1X',
                    description: 'Standard 802.1X closed mode authentication',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\nmab\nsubscriber aging inactivity-timer 60 probe\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session closed\naccess-session port-control auto\nauthentication periodic\nauthentication timer reauthenticate server\nservice-policy type control subscriber DOT1X_MAB_POLICY'
                },
                monitor: {
                    name: 'WIRED_DOT1X_MONITOR',
                    type: '802.1X',
                    description: 'Monitor mode authentication for testing',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\nmab\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session port-control auto\nauthentication open\nauthentication periodic\nauthentication timer reauthenticate server\nservice-policy type control subscriber DOT1X_MAB_POLICY'
                },
                mab: {
                    name: 'IOT_MAB_ONLY',
                    type: 'MAB',
                    description: 'MAB-only for IoT devices',
                    content: 'mab\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session port-control auto\nauthentication open\nservice-policy type control subscriber MAB_POLICY'
                },
                webauth: {
                    name: 'WEBAUTH_GUEST',
                    type: 'WebAuth',
                    description: 'Guest web authentication',
                    content: 'access-session control-direction in\naccess-session port-control auto\nauthentication open\nip access-group ACL-WEBAUTH-REDIRECT in\nip admission WEBAUTH\nservice-policy type control subscriber WEBAUTH_POLICY'
                },
                macsec: {
                    name: 'MACSEC_DOT1X',
                    type: 'MACsec',
                    description: '802.1X with MACsec encryption',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session closed\naccess-session port-control auto\nauthentication periodic\nauthentication timer reauthenticate server\nmacsec\nmacsec replay-protection window-size 0\nmls qos trust dscp\nservice-policy type control subscriber DOT1X_POLICY'
                },
                hybrid: {
                    name: 'HYBRID_AUTH',
                    type: 'Hybrid Authentication',
                    description: 'Hybrid authentication with 802.1X, MAB, and Web Authentication',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\nmab\naccess-session control-direction in\naccess-session host-mode multi-domain\naccess-session closed\naccess-session port-control auto\nauthentication periodic\nauthentication timer reauthenticate server\nip access-group ACL-WEBAUTH-REDIRECT in\nip admission WEBAUTH\nservice-policy type control subscriber HYBRID_POLICY'
                }
            };
            
            // Store templates in local storage
            if (!localStorage.getItem('uaxTemplates')) {
                localStorage.setItem('uaxTemplates', JSON.stringify(defaultTemplates));
            }
        },
        
        /**
         * Update dependent sections based on selected authentication methods
         */
        updateDependentSections: function() {
            // Check if RADIUS section should be shown based on selected auth methods
            const dot1xEnabled = document.getElementById('dot1x')?.checked || false;
            const mabEnabled = document.getElementById('mab')?.checked || false;
            const webauthEnabled = document.getElementById('webauth')?.checked || false;
            const radsecEnabled = document.getElementById('radsec')?.checked || false;
            const tacacsEnabled = document.getElementById('tacacs')?.checked || false;
            const macsecEnabled = document.getElementById('macsec')?.checked || false;
            
            // Determine which sections to show/hide
            const radiusNeeded = dot1xEnabled || mabEnabled || webauthEnabled || radsecEnabled;
            const tacacsNeeded = tacacsEnabled;
            
            // Get step elements
            const radiusStep = document.querySelector('.nav-steps li[data-step="radius-config"]');
            const tacacsStep = document.querySelector('.nav-steps li[data-step="tacacs-config"]');
            
            // Show/hide steps based on selections
            if (radiusStep) {
                radiusStep.style.display = radiusNeeded ? 'flex' : 'none';
            }
            
            if (tacacsStep) {
                tacacsStep.style.display = tacacsNeeded ? 'flex' : 'none';
            }
            
            // Show warning if no authentication method is selected
            const warningElement = document.querySelector('.authentication-warning');
            if (!warningElement && !radiusNeeded && !tacacsNeeded) {
                const warning = document.createElement('div');
                warning.className = 'authentication-warning';
                warning.style.backgroundColor = '#f8d7da';
                warning.style.color = '#721c24';
                warning.style.padding = '10px';
                warning.style.borderRadius = '4px';
                warning.style.marginTop = '10px';
                warning.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Warning: No authentication method selected. Please select at least one authentication method.';
                
                const tabContent = document.getElementById('auth-methods');
                if (tabContent) {
                    tabContent.appendChild(warning);
                }
            } else if (warningElement && (radiusNeeded || tacacsNeeded)) {
                warningElement.remove();
            }
        },
        
        /**
         * Show method info when checkbox is checked
         * @param {Event} event - Change event
         */
        showMethodInfo: function(event) {
            const checkbox = event.target;
            const methodId = checkbox.id;
            const infoPanel = document.getElementById(`${methodId}-info`);
            
            // Hide all info panels
            const allInfoPanels = document.querySelectorAll('.method-info-panel');
            allInfoPanels.forEach(panel => {
                panel.classList.add('hidden');
            });
            
            // Show selected info panel
            if (checkbox.checked && infoPanel) {
                infoPanel.classList.remove('hidden');
            }
        },
        
        /**
         * Handle feature toggle
         * @param {Event} event - Change event
         */
        handleFeatureToggle: function(event) {
            const checkbox = event.target;
            const featureId = checkbox.id;
            const settingsId = `${featureId}Settings`;
            const settingsPanel = document.getElementById(settingsId);
            
            // Show/hide settings panel if it exists
            if (settingsPanel) {
                settingsPanel.style.display = checkbox.checked ? 'block' : 'none';
            }
        },
        
        /**
         * Update validation options based on level
         */
        updateValidationOptions: function() {
            const level = document.getElementById('validationLevel').value;
            
            // Update validation checkboxes based on level
            const validateSyntax = document.getElementById('validateSyntax');
            const validateSecurity = document.getElementById('validateSecurity');
            const validateCompatibility = document.getElementById('validateCompatibility');
            const validatePerformance = document.getElementById('validatePerformance');
            
            if (validateSyntax) validateSyntax.checked = true; // Always checked
            
            if (validateSecurity) {
                validateSecurity.checked = level !== 'basic';
            }
            
            if (validateCompatibility) {
                validateCompatibility.checked = level !== 'basic';
            }
            
            if (validatePerformance) {
                validatePerformance.checked = level === 'strict' || level === 'comprehensive';
            }
        },
        
        /**
         * Update deployment options based on method
         */
        updateDeploymentOptions: function() {
            const method = document.getElementById('deploymentMethod').value;
            
            // Show/hide SSH details based on method
            const sshDetails = document.getElementById('sshDetails');
            if (sshDetails) {
                sshDetails.style.display = method === 'ssh' ? 'block' : 'none';
            }
        },
        
        /**
         * Add command row to command privilege table
         */
        addCommandRow: function() {
            const table = document.querySelector('.command-privilege-table tbody');
            if (!table) return;
            
            const newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td><input type="text" class="form-control" placeholder="Enter command"></td>
                <td>
                    <select class="form-control">
                        <option>15</option>
                        <option>10</option>
                        <option>5</option>
                        <option>1</option>
                    </select>
                </td>
                <td>
                    <select class="form-control">
                        <option>Allow</option>
                        <option>Deny</option>
                    </select>
                </td>
            `;
            
            table.appendChild(newRow);
        },
        
        /**
         * Update template content when template type changes
         */
        updateTemplateContent: function() {
            const templateType = document.getElementById('templateType').value;
            const templateContent = document.getElementById('templateContent');
            
            if (!templateContent) return;
            
            // Get templates from storage
            const templates = JSON.parse(localStorage.getItem('uaxTemplates') || '{}');
            
            // Set template content based on type
            if (templates[templateType]) {
                templateContent.value = templates[templateType].content;
            } else {
                templateContent.value = 'Select a template type to see content...';
            }
        },
        
        /**
         * Add interface template to specific interfaces
         * @param {string} type - Template type
         */
        addInterfaceTemplate: function(type) {
            const specificInterfaces = document.getElementById('specificInterfaces');
            if (!specificInterfaces) return;
            
            let template = '';
            
            // Define templates for different device types
            switch (type) {
                case 'ap':
                    template = `interface GigabitEthernet1/0/1
 description Access Point - 802.1X Authentication
 switchport access vlan 10
 switchport mode access
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 dot1x pae authenticator
 dot1x timeout tx-period 7
 dot1x max-reauth-req 2
 mab
 access-session host-mode multi-auth
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'ipphone':
                    template = `interface GigabitEthernet1/0/2
 description IP Phone - 802.1X + Voice
 switchport access vlan 10
 switchport mode access
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 dot1x pae authenticator
 dot1x timeout tx-period 7
 dot1x max-reauth-req 2
 mab
 access-session host-mode multi-domain
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'printer':
                    template = `interface GigabitEthernet1/0/3
 description Printer - MAB Authentication
 switchport access vlan 30
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 mab
 access-session host-mode single-host
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'server':
                    template = `interface GigabitEthernet1/0/4
 description Server - Static Assignment
 switchport access vlan 100
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 storm-control broadcast level pps 1k
 storm-control action trap
 no shutdown`;
                    break;
                case 'uplink':
                    template = `interface GigabitEthernet1/0/48
 description Uplink to Core Switch
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,100
 switchport mode trunk
 spanning-tree guard root
 storm-control broadcast level pps 5k
 storm-control action trap
 no shutdown`;
                    break;
                case 'iot':
                    template = `interface GigabitEthernet1/0/5
 description IoT Device - MAB Authentication
 switchport access vlan 40
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 mab
 access-session host-mode multi-auth
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'camera':
                    template = `interface GigabitEthernet1/0/6
 description IP Camera - MAB Authentication
 switchport access vlan 50
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 mab
 access-session host-mode single-host
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 500
 storm-control action trap
 no shutdown`;
                    break;
            }
            
            // Add template to textarea
            specificInterfaces.value += (specificInterfaces.value ? '\n\n' : '') + template;
        },
        
        /**
         * Create a new template
         */
        createTemplate: function() {
            const templateName = document.getElementById('templateName').value;
            const templateType = document.getElementById('templateType').value;
            const templateContent = document.getElementById('templateContent').value;
            
            if (!templateName || !templateContent) {
                alert('Please enter a template name and content.');
                return;
            }
            
            // Get templates from storage
            const templates = JSON.parse(localStorage.getItem('uaxTemplates') || '{}');
            
            // Add new template
            templates[templateName.toLowerCase()] = {
                name: templateName,
                type: templateType,
                description: `Custom ${templateType} template`,
                content: templateContent
            };
            
            // Save templates to storage
            localStorage.setItem('uaxTemplates', JSON.stringify(templates));
            
            alert(`Template "${templateName}" created successfully.`);
        },
        
        /**
         * Create configuration parameter object from form inputs
         * @returns {Object} Configuration parameters
         */
        getConfigParameters: function() {
            // Get vendor and platform
            const vendor = document.getElementById('vendor')?.value || '';
            const platform = document.getElementById('platform')?.value || '';
            
            // Get authentication methods
            const authMethods = Array.from(document.querySelectorAll('input[name="authMethod"]:checked')).map(el => el.value);
            
            // Get deployment and fallover settings
            const deploymentType = document.getElementById('deploymentType')?.value || 'standard';
            const failoverPolicy = document.getElementById('failoverPolicy')?.value || 'strict';
            
            // Get RADIUS server settings
            const radiusServer1 = document.getElementById('radiusServer1')?.value || '';
            const radiusServer2 = document.getElementById('radiusServer2')?.value || '';
            const radiusKey1 = document.getElementById('radiusKey1')?.value || '';
            const radiusKey2 = document.getElementById('radiusKey2')?.value || '';
            const radiusServerGroup = document.getElementById('radiusServerGroup')?.value || 'RAD-SERVERS';
            
            // Get general settings
            const hostMode = document.getElementById('hostMode')?.value || 'multi-auth';
            const controlDirection = document.getElementById('controlDirection')?.value || 'in';
            const dot1xTxPeriod = document.getElementById('dot1xTxPeriod')?.value || '7';
            const dot1xMaxReauthReq = document.getElementById('dot1xMaxReauthReq')?.value || '2';
            
            // Get security features
            const securityFeatures = Array.from(document.querySelectorAll('input[name="securityFeature"]:checked')).map(el => el.value);
            
            // Get interface settings
            const accessInterfaceRange = document.getElementById('accessInterfaceRange')?.value || '';
            const accessVlan = document.getElementById('accessVlan')?.value || '';
            const voiceVlan = document.getElementById('voiceVlan')?.value || '';
            
            // Return configuration parameters object
            return {
                vendor,
                platform,
                authMethods,
                deploymentType,
                failoverPolicy,
                radiusServer1,
                radiusServer2,
                radiusKey1,
                radiusKey2,
                radiusServerGroup,
                hostMode,
                controlDirection,
                dot1xTxPeriod,
                dot1xMaxReauthReq,
                securityFeatures,
                accessInterfaceRange,
                accessVlan,
                voiceVlan
            };
        },
        
        /**
         * Generate configuration based on form inputs
         */
        generateConfiguration: function() {
            // Get configuration parameters
            const params = this.getConfigParameters();
            
            // Get configuration output textarea
            const configOutput = document.getElementById('configOutput');
            if (!configOutput) return;
            
            // Clear previous configuration
            configOutput.value = '';
            
            // Generate configuration
            let config = this.generateBaseConfig(params);
            
            // Add TACACS configuration if selected
            if (params.authMethods.includes('tacacs')) {
                config += this.generateTacacsConfig(params);
            }
            
            // Add RADIUS configuration if needed
            if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab') || 
                params.authMethods.includes('webauth') || params.authMethods.includes('radsec')) {
                config += this.generateRadiusConfig(params);
            }
            
            // Add authentication configuration
            config += this.generateAuthenticationConfig(params);
            
            // Add security features
            config += this.generateSecurityConfig(params);
            
            // Add interface configuration
            config += this.generateInterfaceConfig(params);
            
            // Set configuration output
            configOutput.value = config;
            
            // Show success message
            this.showToast('Configuration generated successfully');
        },
        
        /**
         * Generate base configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Base configuration
         */
        generateBaseConfig: function(params) {
            // Create base configuration based on vendor
            let config = '';
            
            // Get current date for comments
            const date = new Date().toISOString().split('T')[0];
            
            // Add version and hostname
            config += `! UaXSupreme Generated Configuration\n`;
            config += `! Vendor: ${params.vendor}\n`;
            config += `! Platform: ${params.platform}\n`;
            config += `! Date: ${date}\n`;
            config += `!\n`;
            
            // Add base configuration based on vendor
            switch (params.vendor) {
                case 'cisco':
                    config += `hostname SWITCH-${Math.floor(1000 + Math.random() * 9000)}\n`;
                    config += `!\n`;
                    config += `! Base services\n`;
                    config += `no service pad\n`;
                    config += `service timestamps debug datetime msec localtime show-timezone\n`;
                    config += `service timestamps log datetime msec localtime show-timezone\n`;
                    config += `service password-encryption\n`;
                    config += `!\n`;
                    
                    // Add AAA base config
                    config += `! AAA Configuration\n`;
                    config += `aaa new-model\n`;
                    
                    // Add device tracking (required for 802.1X and dACLs)
                    if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab')) {
                        if (params.platform === 'ios-xe') {
                            config += `!\n`;
                            config += `! Device Tracking Configuration\n`;
                            config += `device-tracking tracking auto-source\n`;
                            config += `!\n`;
                            config += `device-tracking policy IP-TRACKING\n`;
                            config += ` limit address-count 4\n`;
                            config += ` security-level glean\n`;
                            config += ` no protocol ndp\n`;
                            config += ` no protocol dhcp6\n`;
                            config += ` tracking enable reachable-lifetime 30\n`;
                            config += `!\n`;
                            config += `device-tracking policy DISABLE-IP-TRACKING\n`;
                            config += ` tracking disable\n`;
                            config += ` trusted-port\n`;
                            config += ` device-role switch\n`;
                        } else {
                            config += `!\n`;
                            config += `! IP Device Tracking Configuration\n`;
                            config += `ip device tracking probe auto-source\n`;
                            config += `ip device tracking probe delay 30\n`;
                            config += `ip device tracking probe interval 30\n`;
                            config += `ip device tracking\n`;
                        }
                    }
                    break;
                    
                case 'aruba':
                    config += `hostname SWITCH-${Math.floor(1000 + Math.random() * 9000)}\n`;
                    config += `!\n`;
                    config += `time timezone pst -8\n`;
                    config += `time daylight-time-rule continental-us-and-canada\n`;
                    config += `!\n`;
                    config += `! AAA Configuration\n`;
                    config += `aaa authentication port-access eap-radius\n`;
                    break;
                    
                case 'juniper':
                    config = `# UaXSupreme Generated Configuration\n`;
                    config += `# Vendor: ${params.vendor}\n`;
                    config += `# Platform: ${params.platform}\n`;
                    config += `# Date: ${date}\n`;
                    config += `#\n`;
                    config += `system {\n`;
                    config += `    host-name SWITCH-${Math.floor(1000 + Math.random() * 9000)};\n`;
                    config += `    time-zone America/Los_Angeles;\n`;
                    config += `}\n`;
                    break;
                    
                default:
                    config += `hostname SWITCH-${Math.floor(1000 + Math.random() * 9000)}\n`;
                    config += `!\n`;
            }
            
            return config;
        },
        
        /**
         * Generate TACACS configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} TACACS configuration
         */
        generateTacacsConfig: function(params) {
            // Create TACACS configuration based on vendor
            let config = '\n';
            
            // Check if TACACS server information exists
            const tacacsServer1 = document.getElementById('tacacsServer1')?.value || '';
            const tacacsServer2 = document.getElementById('tacacsServer2')?.value || '';
            const tacacsKey1 = document.getElementById('tacacsKey1')?.value || '';
            const tacacsServerGroup = document.getElementById('tacacsServerGroup')?.value || 'SG-TAC-SERVERS';
            
            // Skip if no server is defined
            if (!tacacsServer1) {
                return '\n! TACACS+ Configuration (servers not defined)\n';
            }
            
            // Add TACACS configuration based on vendor
            switch (params.vendor) {
                case 'cisco':
                    config += `! TACACS+ Configuration\n`;
                    
                    // TACACS server definitions
                    if (params.platform === 'ios-xe') {
                        config += `tacacs server TAC-SERVER-1\n`;
                        config += ` address ipv4 ${tacacsServer1}\n`;
                        config += ` key ${tacacsKey1}\n`;
                        config += ` timeout 1\n`;
                        config += ` single-connection\n`;
                        
                        if (tacacsServer2) {
                            config += `!\n`;
                            config += `tacacs server TAC-SERVER-2\n`;
                            config += ` address ipv4 ${tacacsServer2}\n`;
                            config += ` key ${tacacsKey1}\n`;
                            config += ` timeout 1\n`;
                            config += ` single-connection\n`;
                        }
                    } else {
                        config += `tacacs-server host ${tacacsServer1} key ${tacacsKey1}\n`;
                        
                        if (tacacsServer2) {
                            config += `tacacs-server host ${tacacsServer2} key ${tacacsKey1}\n`;
                        }
                        
                        config += `tacacs-server timeout 1\n`;
                    }
                    
                    // TACACS server group
                    config += `!\n`;
                    config += `aaa group server tacacs+ ${tacacsServerGroup}\n`;
                    
                    if (params.platform === 'ios-xe') {
                        config += ` server name TAC-SERVER-1\n`;
                        
                        if (tacacsServer2) {
                            config += ` server name TAC-SERVER-2\n`;
                        }
                    } else {
                        config += ` server ${tacacsServer1}\n`;
                        
                        if (tacacsServer2) {
                            config += ` server ${tacacsServer2}\n`;
                        }
                    }
                    
                    config += ` ip tacacs source-interface Vlan10\n`;
                    
                    // TACACS configuration
                    config += `!\n`;
                    config += `aaa authentication login default group ${tacacsServerGroup} local\n`;
                    config += `aaa authentication enable default group ${tacacsServerGroup} enable\n`;
                    config += `aaa authorization exec default group ${tacacsServerGroup} local if-authenticated\n`;
                    config += `aaa authorization commands 15 default group ${tacacsServerGroup} local if-authenticated\n`;
                    config += `aaa accounting exec default start-stop group ${tacacsServerGroup}\n`;
                    config += `aaa accounting commands 15 default start-stop group ${tacacsServerGroup}\n`;
                    break;
                    
                case 'aruba':
                    config += `! TACACS+ Configuration\n`;
                    config += `tacacs-server host ${tacacsServer1} key ${tacacsKey1}\n`;
                    
                    if (tacacsServer2) {
                        config += `tacacs-server host ${tacacsServer2} key ${tacacsKey1}\n`;
                    }
                    
                    config += `tacacs-server timeout 1\n`;
                    config += `aaa authentication login default group tacacs local\n`;
                    config += `aaa authentication enable default group tacacs enable\n`;
                    config += `aaa authorization commands 15 default group tacacs local\n`;
                    config += `aaa accounting exec default start-stop group tacacs\n`;
                    config += `aaa accounting commands 15 default start-stop group tacacs\n`;
                    break;
                    
                case 'juniper':
                    config = `# TACACS+ Configuration\n`;
                    config += `system {\n`;
                    config += `    tacplus-server {\n`;
                    config += `        ${tacacsServer1} {\n`;
                    config += `            secret "${tacacsKey1}";\n`;
                    config += `            timeout 1;\n`;
                    config += `            single-connection;\n`;
                    config += `        }\n`;
                    
                    if (tacacsServer2) {
                        config += `        ${tacacsServer2} {\n`;
                        config += `            secret "${tacacsKey1}";\n`;
                        config += `            timeout 1;\n`;
                        config += `            single-connection;\n`;
                        config += `        }\n`;
                    }
                    
                    config += `    }\n`;
                    config += `    authentication-order [ tacplus password ];\n`;
                    config += `    accounting {\n`;
                    config += `        events [ login interactive-commands ];\n`;
                    config += `        destination {\n`;
                    config += `            tacplus;\n`;
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    break;
                    
                default:
                    config += `! TACACS+ Configuration\n`;
                    config += `tacacs-server host ${tacacsServer1} key ${tacacsKey1}\n`;
                    
                    if (tacacsServer2) {
                        config += `tacacs-server host ${tacacsServer2} key ${tacacsKey1}\n`;
                    }
                    
                    config += `tacacs-server timeout 1\n`;
                    config += `aaa authentication login default group tacacs local\n`;
                    config += `aaa authentication enable default group tacacs enable\n`;
                    config += `aaa authorization commands 15 default group tacacs local\n`;
                    config += `aaa accounting exec default start-stop group tacacs\n`;
                    config += `aaa accounting commands 15 default start-stop group tacacs\n`;
            }
            
            return config;
        },
        
        /**
         * Generate RADIUS configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} RADIUS configuration
         */
        generateRadiusConfig: function(params) {
            // Create RADIUS configuration based on vendor
            let config = '\n';
            
            // Skip if no RADIUS-based authentication methods are selected
            if (!params.authMethods.includes('dot1x') && !params.authMethods.includes('mab') && 
                !params.authMethods.includes('webauth') && !params.authMethods.includes('radsec')) {
                return '\n! RADIUS Configuration (not required)\n';
            }
            
            // Check if RADIUS server information exists
            if (!params.radiusServer1) {
                return '\n! RADIUS Configuration (servers not defined)\n';
            }
            
            // Define RADIUS configuration based on vendor
            switch (params.vendor) {
                case 'cisco':
                    config += `! RADIUS Configuration\n`;
                    
                    // RADIUS server definitions
                    if (params.platform === 'ios-xe') {
                        config += `radius server RAD-ISE-PSN-1\n`;
                        config += ` address ipv4 ${params.radiusServer1} auth-port 1812 acct-port 1813\n`;
                        config += ` key ${params.radiusKey1}\n`;
                        config += ` timeout 2\n`;
                        config += ` retransmit 2\n`;
                        config += ` automate-tester username test-user probe-on\n`;
                        
                        if (params.radiusServer2) {
                            config += `!\n`;
                            config += `radius server RAD-ISE-PSN-2\n`;
                            config += ` address ipv4 ${params.radiusServer2} auth-port 1812 acct-port 1813\n`;
                            config += ` key ${params.radiusKey2 || params.radiusKey1}\n`;
                            config += ` timeout 2\n`;
                            config += ` retransmit 2\n`;
                            config += ` automate-tester username test-user probe-on\n`;
                        }
                    } else {
                        config += `radius-server host ${params.radiusServer1} auth-port 1812 acct-port 1813 key ${params.radiusKey1}\n`;
                        
                        if (params.radiusServer2) {
                            config += `radius-server host ${params.radiusServer2} auth-port 1812 acct-port 1813 key ${params.radiusKey2 || params.radiusKey1}\n`;
                        }
                        
                        config += `radius-server timeout 2\n`;
                        config += `radius-server retransmit 2\n`;
                        config += `radius-server dead-criteria time 5 tries 3\n`;
                    }
                    
                    // RADIUS server group
                    config += `!\n`;
                    config += `aaa group server radius ${params.radiusServerGroup}\n`;
                    
                    if (params.platform === 'ios-xe') {
                        config += ` server name RAD-ISE-PSN-1\n`;
                        
                        if (params.radiusServer2) {
                            config += ` server name RAD-ISE-PSN-2\n`;
                        }
                    } else {
                        config += ` server ${params.radiusServer1} auth-port 1812 acct-port 1813\n`;
                        
                        if (params.radiusServer2) {
                            config += ` server ${params.radiusServer2} auth-port 1812 acct-port 1813\n`;
                        }
                    }
                    
                    config += ` deadtime 15\n`;
                    if (params.radiusServer2) {
                        config += ` load-balance method least-outstanding\n`;
                    }
                    config += ` ip radius source-interface Vlan10\n`;
                    
                    // RADIUS attributes
                    config += `!\n`;
                    config += `radius-server attribute 6 on-for-login-auth\n`;
                    config += `radius-server attribute 8 include-in-access-req\n`;
                    config += `radius-server attribute 25 access-request include\n`;
                    config += `radius-server attribute 31 mac format ietf upper-case\n`;
                    config += `radius-server attribute 31 send nas-port-detail mac-only\n`;
                    config += `radius-server vsa send authentication\n`;
                    config += `radius-server vsa send accounting\n`;
                    
                    // RADIUS dead criteria
                    config += `radius-server dead-criteria time 5 tries 3\n`;
                    
                    // Change of Authorization (CoA)
                    config += `!\n`;
                    config += `aaa server radius dynamic-author\n`;
                    config += ` client ${params.radiusServer1} server-key ${params.radiusKey1}\n`;
                    
                    if (params.radiusServer2) {
                        config += ` client ${params.radiusServer2} server-key ${params.radiusKey2 || params.radiusKey1}\n`;
                    }
                    
                    config += ` auth-type any\n`;
                    
                    // AAA authentication, authorization, and accounting
                    config += `!\n`;
                    config += `aaa authentication dot1x default group ${params.radiusServerGroup} local\n`;
                    config += `aaa authorization network default group ${params.radiusServerGroup} local\n`;
                    config += `aaa accounting dot1x default start-stop group ${params.radiusServerGroup}\n`;
                    config += `aaa accounting update newinfo periodic 1440\n`;
                    break;
                    
                case 'aruba':
                    config += `! RADIUS Configuration\n`;
                    config += `radius-server host ${params.radiusServer1} key ${params.radiusKey1}\n`;
                    
                    if (params.radiusServer2) {
                        config += `radius-server host ${params.radiusServer2} key ${params.radiusKey2 || params.radiusKey1}\n`;
                    }
                    
                    config += `radius-server timeout 2\n`;
                    config += `radius-server retransmit 2\n`;
                    config += `radius-server deadtime 15\n`;
                    config += `radius-server key ${params.radiusKey1}\n`;
                    config += `radius-server cppm server-group ${params.radiusServerGroup}\n`;
                    
                    if (params.radiusServer2) {
                        config += `radius-server cppm server-group ${params.radiusServerGroup} server ${params.radiusServer1}\n`;
                        config += `radius-server cppm server-group ${params.radiusServerGroup} server ${params.radiusServer2}\n`;
                    } else {
                        config += `radius-server cppm server-group ${params.radiusServerGroup} server ${params.radiusServer1}\n`;
                    }
                    
                    config += `aaa authentication port-access eap-radius server-group ${params.radiusServerGroup}\n`;
                    config += `aaa authentication mac-auth server-group ${params.radiusServerGroup}\n`;
                    break;
                    
                case 'juniper':
                    config = `# RADIUS Configuration\n`;
                    config += `system {\n`;
                    config += `    radius-server {\n`;
                    config += `        ${params.radiusServer1} {\n`;
                    config += `            secret "${params.radiusKey1}";\n`;
                    config += `            timeout 2;\n`;
                    config += `            retry 2;\n`;
                    config += `            source-address <vlan-10-ip>;\n`;
                    config += `        }\n`;
                    
                    if (params.radiusServer2) {
                        config += `        ${params.radiusServer2} {\n`;
                        config += `            secret "${params.radiusKey2 || params.radiusKey1}";\n`;
                        config += `            timeout 2;\n`;
                        config += `            retry 2;\n`;
                        config += `            source-address <vlan-10-ip>;\n`;
                        config += `        }\n`;
                    }
                    
                    config += `    }\n`;
                    config += `    authentication-order radius;\n`;
                    config += `    accounting {\n`;
                    config += `        events [ login interactive-commands ];\n`;
                    config += `        destination {\n`;
                    config += `            radius;\n`;
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    
                    config += `access {\n`;
                    config += `    radius-server {\n`;
                    config += `        ${params.radiusServer1} {\n`;
                    config += `            secret "${params.radiusKey1}";\n`;
                    config += `            timeout 2;\n`;
                    config += `            retry 2;\n`;
                    config += `            source-address <vlan-10-ip>;\n`;
                    config += `        }\n`;
                    
                    if (params.radiusServer2) {
                        config += `        ${params.radiusServer2} {\n`;
                        config += `            secret "${params.radiusKey2 || params.radiusKey1}";\n`;
                        config += `            timeout 2;\n`;
                        config += `            retry 2;\n`;
                        config += `            source-address <vlan-10-ip>;\n`;
                        config += `        }\n`;
                    }
                    
                    config += `    }\n`;
                    config += `    profile dot1x-profile {\n`;
                    config += `        authentication-protocol eap-peap;\n`;
                    config += `        radius-authentication-server {\n`;
                    config += `            ${params.radiusServer1};\n`;
                    
                    if (params.radiusServer2) {
                        config += `            ${params.radiusServer2};\n`;
                    }
                    
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    break;
                    
                default:
                    config += `! RADIUS Configuration\n`;
                    config += `radius-server host ${params.radiusServer1} key ${params.radiusKey1}\n`;
                    
                    if (params.radiusServer2) {
                        config += `radius-server host ${params.radiusServer2} key ${params.radiusKey2 || params.radiusKey1}\n`;
                    }
                    
                    config += `radius-server timeout 2\n`;
                    config += `radius-server retransmit 2\n`;
                    config += `radius-server deadtime 15\n`;
                    config += `aaa authentication dot1x default group radius local\n`;
                    config += `aaa authorization network default group radius local\n`;
                    config += `aaa accounting dot1x default start-stop group radius\n`;
            }
            
            return config;
        },
        
        /**
         * Generate authentication configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Authentication configuration
         */
        generateAuthenticationConfig: function(params) {
            // Create authentication configuration based on vendor and methods
            let config = '\n';
            
            // Check if any authentication method is selected
            if (!params.authMethods || params.authMethods.length === 0) {
                return '\n! Authentication Configuration (methods not selected)\n';
            }
            
            switch (params.vendor) {
                case 'cisco':
                    config += `! Authentication Configuration\n`;
                    
                    // Enable 802.1X system authentication control
                    if (params.authMethods.includes('dot1x')) {
                        config += `dot1x system-auth-control\n`;
                    }
                    
                    // Enable MACsec if selected
                    if (params.authMethods.includes('macsec')) {
                        config += `mka default-policy\n`;
                    }
                    
                    // IOS-XE with Identity-Based Networking Services (IBNS) 2.0
                    if (params.platform === 'ios-xe' && (params.authMethods.includes('dot1x') || params.authMethods.includes('mab'))) {
                        // Advanced authentication configuration with IBNS 2.0
                        config += `!\n`;
                        config += `! Convert to IBNS 2.0\n`;
                        config += `authentication convert-to new-style\n`;
                        
                        // ACL for critical authentication
                        config += `!\n`;
                        config += `ip access-list extended ACL-OPEN\n`;
                        config += ` permit ip any any\n`;
                        
                        // Critical authentication service template
                        config += `!\n`;
                        config += `service-template CRITICAL_DATA_ACCESS\n`;
                        config += ` vlan 999\n`;
                        config += ` access-group ACL-OPEN\n`;
                        
                        config += `!\n`;
                        config += `service-template CRITICAL_VOICE_ACCESS\n`;
                        config += ` voice vlan 999\n`;
                        config += ` access-group ACL-OPEN\n`;
                        
                        // Class maps for authentication
                        config += `!\n`;
                        config += `class-map type control subscriber match-all DOT1X\n`;
                        config += ` match method dot1x\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all MAB\n`;
                        config += ` match method mab\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all DOT1X_FAILED\n`;
                        config += ` match method dot1x\n`;
                        config += ` match result-type method dot1x authoritative\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all MAB_FAILED\n`;
                        config += ` match method mab\n`;
                        config += ` match result-type method mab authoritative\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST\n`;
                        config += ` match result-type aaa-timeout\n`;
                        config += ` match authorization-status authorized\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST\n`;
                        config += ` match result-type aaa-timeout\n`;
                        config += ` match authorization-status unauthorized\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all IN_CRITICAL_AUTH\n`;
                        config += ` match activated-service-template CRITICAL_DATA_ACCESS\n`;
                        config += ` match activated-service-template CRITICAL_VOICE_ACCESS\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH\n`;
                        config += ` match activated-service-template CRITICAL_DATA_ACCESS\n`;
                        config += ` match activated-service-template CRITICAL_VOICE_ACCESS\n`;
                        
                        // Policy map for 802.1X and MAB
                        if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                            // Policy map name based on deployment type
                            let policyMapName = 'DOT1X_MAB_POLICY';
                            if (params.deploymentType === 'concurrent') {
                                policyMapName = 'CONCURRENT_DOT1X_MAB_POLICY';
                            }
                            
                            config += `!\n`;
                            config += `policy-map type control subscriber ${policyMapName}\n`;
                            
                            // Session start event
                            config += ` event session-started match-all\n`;
                            
                            // Sequential vs Concurrent based on deployment type
                            if (params.deploymentType === 'concurrent') {
                                config += `  10 class always do-all\n`;
                                config += `   10 authenticate using dot1x priority 10\n`;
                                config += `   20 authenticate using mab priority 20\n`;
                            } else {
                                config += `  10 class always do-until-failure\n`;
                                config += `   10 authenticate using dot1x priority 10\n`;
                                config += `  20 class DOT1X_FAILED do-until-failure\n`;
                                config += `   10 authenticate using mab priority 20\n`;
                            }
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 activate service-template DEFAULT_LINKSEC_POLICY_MUST_SECURE\n`;
                            config += `   20 authorize\n`;
                            config += `   30 pause reauthentication\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n`;
                            config += `   10 clear-authenticated-data-hosts-on-port\n`;
                            config += `   20 activate service-template CRITICAL_DATA_ACCESS\n`;
                            config += `   30 activate service-template CRITICAL_VOICE_ACCESS\n`;
                            config += `   40 authorize\n`;
                            config += `   50 pause reauthentication\n`;
                            config += `  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n`;
                            config += `   10 pause reauthentication\n`;
                            config += `   20 authorize\n`;
                            config += `  30 class DOT1X_FAILED do-until-failure\n`;
                            config += `   10 authenticate using mab priority 20\n`;
                            config += `  40 class MAB_FAILED do-until-failure\n`;
                            
                            // Actions based on deployment type
                            if (params.deploymentType === 'monitor') {
                                config += `   10 authorize\n`;
                            } else if (params.failoverPolicy === 'guest' && params.authMethods.includes('webauth')) {
                                config += `   10 authenticate using webauth priority 30\n`;
                            } else if (params.failoverPolicy === 'restricted') {
                                config += `   10 activate service-template RESTRICTED_ACCESS\n`;
                                config += `   20 authorize\n`;
                                config += `   30 pause reauthentication\n`;
                            } else {
                                config += `   10 terminate dot1x\n`;
                                config += `   20 terminate mab\n`;
                                config += `   30 authentication-restart 60\n`;
                            }
                            
                            // AAA available event (for critical auth recovery)
                            config += ` event aaa-available match-all\n`;
                            config += `  10 class IN_CRITICAL_AUTH do-until-failure\n`;
                            config += `   10 clear-session\n`;
                            config += `  20 class NOT_IN_CRITICAL_AUTH do-until-failure\n`;
                            config += `   10 resume reauthentication\n`;
                            
                            // Authorization policy change event
                            config += ` event violation match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 restrict\n`;
                        }
                        // 802.1X only policy map
                        else if (params.authMethods.includes('dot1x')) {
                            config += `!\n`;
                            config += `policy-map type control subscriber DOT1X_POLICY\n`;
                            config += ` event session-started match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authenticate using dot1x priority 10\n`;
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authorize\n`;
                            config += `   20 pause reauthentication\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n`;
                            config += `   10 activate service-template CRITICAL_DATA_ACCESS\n`;
                            config += `   20 activate service-template CRITICAL_VOICE_ACCESS\n`;
                            config += `   30 authorize\n`;
                            config += `   40 pause reauthentication\n`;
                            config += `  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n`;
                            config += `   10 pause reauthentication\n`;
                            config += `   20 authorize\n`;
                            config += `  30 class always do-until-failure\n`;
                            
                            // Actions based on deployment type
                            if (params.deploymentType === 'monitor') {
                                config += `   10 authorize\n`;
                            } else if (params.failoverPolicy === 'restricted') {
                                config += `   10 activate service-template RESTRICTED_ACCESS\n`;
                                config += `   20 authorize\n`;
                                config += `   30 pause reauthentication\n`;
                            } else {
                                config += `   10 terminate dot1x\n`;
                                config += `   20 authentication-restart 60\n`;
                            }
                        }
                        // MAB only policy map
                        else if (params.authMethods.includes('mab')) {
                            config += `!\n`;
                            config += `policy-map type control subscriber MAB_POLICY\n`;
                            config += ` event session-started match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authenticate using mab priority 10\n`;
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authorize\n`;
                            config += `   20 pause reauthentication\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n`;
                            config += `   10 activate service-template CRITICAL_DATA_ACCESS\n`;
                            config += `   20 activate service-template CRITICAL_VOICE_ACCESS\n`;
                            config += `   30 authorize\n`;
                            config += `   40 pause reauthentication\n`;
                            config += `  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n`;
                            config += `   10 pause reauthentication\n`;
                            config += `   20 authorize\n`;
                            config += `  30 class always do-until-failure\n`;
                            
                            // Actions based on deployment type
                            if (params.deploymentType === 'monitor') {
                                config += `   10 authorize\n`;
                            } else if (params.failoverPolicy === 'restricted') {
                                config += `   10 activate service-template RESTRICTED_ACCESS\n`;
                                config += `   20 authorize\n`;
                                config += `   30 pause reauthentication\n`;
                            } else {
                                config += `   10 terminate mab\n`;
                                config += `   20 authentication-restart 60\n`;
                            }
                        }
                        
                        // Web Authentication policy map if needed
                        if (params.authMethods.includes('webauth')) {
                            config += `!\n`;
                            config += `ip access-list extended ACL-WEBAUTH-REDIRECT\n`;
                            config += ` permit tcp any any eq www\n`;
                            config += ` permit tcp any any eq 443\n`;
                            
                            config += `!\n`;
                            config += `ip admission name WEBAUTH proxy http\n`;
                            
                            config += `!\n`;
                            config += `policy-map type control subscriber WEBAUTH_POLICY\n`;
                            config += ` event session-started match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authenticate using webauth priority 10\n`;
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authorize\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 terminate webauth\n`;
                            config += `   20 authentication-restart 60\n`;
                        }
                        
                        // Critical authentication configuration
                        config += `!\n`;
                        config += `dot1x critical eapol\n`;
                        config += `authentication critical recovery delay 2000\n`;
                    }
                    // Standard IOS authentication configuration
                    else if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab')) {
                        // Basic authentication configuration without IBNS 2.0
                        config += `!\n`;
                        config += `dot1x pae authenticator\n`;
                        config += `dot1x timeout tx-period ${params.dot1xTxPeriod}\n`;
                        config += `dot1x max-reauth-req ${params.dot1xMaxReauthReq}\n`;
                        
                        if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                            config += `dot1x critical eapol\n`;
                            
                            // Critical VLAN configuration
                            if (params.failoverPolicy === 'critical') {
                                config += `dot1x critical vlan 999\n`;
                            }
                            
                            // Configure fallback policies
                            if (params.deploymentType === 'closed') {
                                config += `authentication fallback FAILOVER\n`;
                                config += `!\n`;
                                config += `fallback profile FAILOVER\n`;
                                
                                if (params.failoverPolicy === 'restricted') {
                                    config += ` ip access-group ACL-RESTRICTED in\n`;
                                } else if (params.failoverPolicy === 'guest') {
                                    config += ` ip access-group ACL-GUEST in\n`;
                                }
                            }
                            
                            // Enable authentication features
                            config += `authentication order dot1x mab\n`;
                            config += `authentication priority dot1x mab\n`;
                        } else if (params.authMethods.includes('dot1x')) {
                            config += `authentication order dot1x\n`;
                            config += `authentication priority dot1x\n`;
                        } else if (params.authMethods.includes('mab')) {
                            config += `authentication order mab\n`;
                            config += `authentication priority mab\n`;
                        }
                        
                        // Authentication modes and settings
                        config += `authentication port-control auto\n`;
                        
                        if (params.deploymentType === 'monitor') {
                            config += `authentication open\n`;
                        }
                        
                        config += `authentication host-mode ${params.hostMode}\n`;
                        config += `authentication control-direction ${params.controlDirection}\n`;
                        config += `authentication periodic\n`;
                        config += `authentication timer reauthenticate server\n`;
                    }
                    break;
                    
                case 'aruba':
                    config += `! Authentication Configuration\n`;
                    
                    // Configure authentication modes based on methods
                    if (params.authMethods.includes('dot1x')) {
                        config += `!\n`;
                        config += `! 802.1X Configuration\n`;
                        
                        if (params.deploymentType === 'monitor') {
                            config += `aaa authentication port-access auth-mode monitor\n`;
                        } else {
                            config += `aaa authentication port-access auth-mode 1x\n`;
                        }
                        
                        config += `aaa authentication port-access dot1x username-compare other\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} client-limit ${params.hostMode === 'multi-auth' ? '32' : '1'}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} tx-period ${params.dot1xTxPeriod}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} max-requests ${params.dot1xMaxReauthReq}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} reauth-period server\n`;
                    }
                    
                    if (params.authMethods.includes('mab')) {
                        config += `!\n`;
                        config += `! MAC Authentication Configuration\n`;
                        
                        if (params.deploymentType === 'monitor') {
                            config += `aaa authentication port-access auth-mode monitor\n`;
                        } else {
                            config += `aaa authentication port-access auth-mode mac\n`;
                        }
                        
                        config += `aaa port-access mac-auth ${params.accessInterfaceRange}\n`;
                        config += `aaa port-access mac-auth ${params.accessInterfaceRange} auth-mac-format no-delimiter uppercase\n`;
                    }
                    
                    // Configure combined authentication modes
                    if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                        if (params.deploymentType === 'concurrent') {
                            config += `aaa authentication port-access auth-mode dot1x-mac\n`;
                        } else {
                            config += `aaa authentication port-access auth-mode dot1x-then-mac\n`;
                        }
                    }
                    
                    break;
                    
                case 'juniper':
                    config = `# Authentication Configuration\n`;
                    
                    if (params.authMethods.includes('dot1x')) {
                        config += `protocols {\n`;
                        config += `    dot1x {\n`;
                        config += `        authenticator {\n`;
                        config += `            interface {\n`;
                        config += `                <interface-range> {\n`;
                        config += `                    supplicant multiple;\n`;
                        config += `                    transmit-period ${params.dot1xTxPeriod};\n`;
                        config += `                    maximum-requests ${params.dot1xMaxReauthReq};\n`;
                        config += `                    server-timeout 30;\n`;
                        config += `                    authentication-profile-name dot1x-profile;\n`;
                        config += `                }\n`;
                        config += `            }\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    
                    if (params.authMethods.includes('mab')) {
                        config += `ethernet-switching-options {\n`;
                        config += `    secure-access-port {\n`;
                        config += `        interface <interface-range> {\n`;
                        config += `            mac-limit 4 action drop;\n`;
                        config += `            allowed-mac <mac-1>;\n`;
                        config += `            allowed-mac <mac-2>;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    break;
                    
                default:
                    config += `! Authentication Configuration\n`;
                    
                    if (params.authMethods.includes('dot1x')) {
                        config += `dot1x system-auth-control\n`;
                    }
            }
            
            return config;
        },
        
        /**
         * Generate security configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Security configuration
         */
        generateSecurityConfig: function(params) {
            // Create security configuration based on vendor and features
            let config = '\n';
            
            // Check if any security features are selected
            if (!params.securityFeatures || params.securityFeatures.length === 0) {
                return '\n! Security Configuration (features not selected)\n';
            }
            
            switch (params.vendor) {
                case 'cisco':
                    config += `! Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `!\n`;
                        config += `! DHCP Snooping\n`;
                        config += `ip dhcp snooping vlan 1-4094\n`;
                        config += `ip dhcp snooping information option\n`;
                        config += `ip dhcp snooping\n`;
                    }
                    
                    // Dynamic ARP Inspection
                    if (params.securityFeatures.includes('arpInspection')) {
                        config += `!\n`;
                        config += `! Dynamic ARP Inspection\n`;
                        config += `ip arp inspection vlan 1-4094\n`;
                        config += `ip arp inspection validate src-mac dst-mac ip\n`;
                    }
                    
                    // IP Source Guard
                    if (params.securityFeatures.includes('ipSourceGuard')) {
                        config += `!\n`;
                        config += `! IP Source Guard\n`;
                        config += `! (Applied on individual interfaces)\n`;
                    }
                    
                    // Storm Control - set up in interface template
                    if (params.securityFeatures.includes('stormControl')) {
                        config += `!\n`;
                        config += `! Storm Control (Applied on individual interfaces)\n`;
                    }
                    
                    // BPDU Guard - set up in interface template
                    if (params.securityFeatures.includes('bpduGuard')) {
                        config += `!\n`;
                        config += `! BPDU Guard (Applied on individual interfaces)\n`;
                        config += `spanning-tree portfast bpduguard default\n`;
                    }
                    
                    // Device Sensor
                    if (params.securityFeatures.includes('deviceSensor')) {
                        config += `!\n`;
                        config += `! Device Sensor Configuration\n`;
                        config += `device-sensor filter-list dhcp list DS_DHCP_LIST\n`;
                        config += ` option name host-name\n`;
                        config += ` option name requested-address\n`;
                        config += ` option name parameter-request-list\n`;
                        config += ` option name class-identifier\n`;
                        config += ` option name client-identifier\n`;
                        config += `device-sensor filter-spec dhcp include list DS_DHCP_LIST\n`;
                        
                        config += `!\n`;
                        config += `cdp run\n`;
                        config += `device-sensor filter-list cdp list DS_CDP_LIST\n`;
                        config += ` tlv name device-name\n`;
                        config += ` tlv name address-type\n`;
                        config += ` tlv name capabilities-type\n`;
                        config += ` tlv name platform-type\n`;
                        config += ` tlv name version-type\n`;
                        config += `device-sensor filter-spec cdp include list DS_CDP_LIST\n`;
                        
                        config += `!\n`;
                        config += `lldp run\n`;
                        config += `device-sensor filter-list lldp list DS_LLDP_LIST\n`;
                        config += ` tlv name system-name\n`;
                        config += ` tlv name system-description\n`;
                        config += ` tlv name system-capabilities\n`;
                        config += `device-sensor filter-spec lldp include list DS_LLDP_LIST\n`;
                        
                        config += `!\n`;
                        config += `device-sensor notify all-changes\n`;
                        
                        // If using RADIUS accounting with device-sensor
                        config += `!\n`;
                        config += `access-session accounting attributes filter-spec include list DS_SEND_LIST\n`;
                        config += `access-session accounting attributes filter-list DS_SEND_LIST cdp device-name platform-type\n`;
                        config += `access-session accounting attributes filter-list DS_SEND_LIST lldp system-name system-description\n`;
                        config += `access-session accounting attributes filter-list DS_SEND_LIST dhcp host-name client-identifier\n`;
                        config += `access-session authentication attributes filter-spec include list DS_SEND_LIST\n`;
                    }
                    
                    // MACsec if enabled
                    if (params.authMethods.includes('macsec')) {
                        config += `!\n`;
                        config += `! MACsec Configuration\n`;
                        config += `service-template DEFAULT_LINKSEC_POLICY_MUST_SECURE\n`;
                        config += ` linksec policy must-secure\n`;
                    }
                    break;
                    
                case 'aruba':
                    config += `! Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `!\n`;
                        config += `! DHCP Snooping\n`;
                        config += `dhcp-snooping\n`;
                        config += `dhcp-snooping vlan 1-4094\n`;
                    }
                    
                    // ARP Protection
                    if (params.securityFeatures.includes('arpInspection')) {
                        config += `!\n`;
                        config += `! ARP Protection\n`;
                        config += `arp-protect\n`;
                        config += `arp-protect vlan 1-4094\n`;
                    }
                    
                    // BPDU Guard and other features are configured on interfaces
                    break;
                    
                case 'juniper':
                    config = `# Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `forwarding-options {\n`;
                        config += `    dhcp-security {\n`;
                        config += `        group all-vlans {\n`;
                        config += `            overrides no-option82;\n`;
                        config += `            interface <interface-range> {\n`;
                        config += `                static-ip 0.0.0.0/0 mac <mac-address>;\n`;
                        config += `            }\n`;
                        config += `        }\n`;
                        config += `        dhcp-snooping;\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    
                    // ARP Inspection
                    if (params.securityFeatures.includes('arpInspection')) {
                        config += `ethernet-switching-options {\n`;
                        config += `    secure-access-port {\n`;
                        config += `        vlan all {\n`;
                        config += `            arp-inspection;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    break;
                    
                default:
                    config += `! Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `ip dhcp snooping\n`;
                    }
            }
            
            return config;
        },
        
        /**
         * Generate interface configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Interface configuration
         */
        generateInterfaceConfig: function(params) {
            // Create interface configuration based on vendor and parameters
            let config = '\n';
            
            // Check if interface range is defined
            if (!params.accessInterfaceRange) {
                return '\n! Interface Configuration (interfaces not specified)\n';
            }
            
            switch (params.vendor) {
                case 'cisco':
                    config += `! Interface Configuration\n`;
                    
                    // Access port configuration
                    config += `!\n`;
                    config += `interface range ${params.accessInterfaceRange}\n`;
                    config += ` description 802.1X Authentication Port\n`;
                    config += ` switchport access vlan ${params.accessVlan}\n`;
                    
                    // Add voice VLAN if specified
                    if (params.voiceVlan) {
                        config += ` switchport voice vlan ${params.voiceVlan}\n`;
                    }
                    
                    config += ` switchport mode access\n`;
                    config += ` switchport nonegotiate\n`;
                    
                    // Add security features
                    if (params.securityFeatures.includes('bpduGuard')) {
                        config += ` spanning-tree portfast\n`;
                        config += ` spanning-tree bpduguard enable\n`;
                    }
                    
                    if (params.securityFeatures.includes('stormControl')) {
                        config += ` storm-control broadcast level pps 100\n`;
                        config += ` storm-control action trap\n`;
                    }
                    
                    if (params.securityFeatures.includes('ipSourceGuard')) {
                        config += ` ip verify source\n`;
                    }
                    
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += ` ip dhcp snooping limit rate 20\n`;
                    }
                    
                    // Add authentication features
                    if (params.authMethods.includes('dot1x')) {
                        config += ` dot1x pae authenticator\n`;
                        config += ` dot1x timeout tx-period ${params.dot1xTxPeriod}\n`;
                        config += ` dot1x max-reauth-req ${params.dot1xMaxReauthReq}\n`;
                    }
                    
                    if (params.authMethods.includes('mab')) {
                        config += ` mab\n`;
                    }
                    
                    // Device tracking for IBNS 2.0
                    if (params.platform === 'ios-xe' && params.securityFeatures.includes('deviceTracking')) {
                        config += ` device-tracking attach-policy IP-TRACKING\n`;
                    }
                    
                    // Authentication settings
                    if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab')) {
                        if (params.platform === 'ios-xe') {
                            config += ` access-session host-mode ${params.hostMode}\n`;
                            config += ` access-session control-direction ${params.controlDirection}\n`;
                            
                            if (params.deploymentType !== 'monitor') {
                                config += ` access-session closed\n`;
                            }
                            
                            config += ` access-session port-control auto\n`;
                            config += ` authentication periodic\n`;
                            config += ` authentication timer reauthenticate server\n`;
                            config += ` subscriber aging inactivity-timer 60 probe\n`;
                            
                            // Determine which policy to apply
                            let policyName = '';
                            if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                                policyName = params.deploymentType === 'concurrent' ? 'CONCURRENT_DOT1X_MAB_POLICY' : 'DOT1X_MAB_POLICY';
                            } else if (params.authMethods.includes('dot1x')) {
                                policyName = 'DOT1X_POLICY';
                            } else if (params.authMethods.includes('mab')) {
                                policyName = 'MAB_POLICY';
                            }
                            
                            if (policyName) {
                                config += ` service-policy type control subscriber ${policyName}\n`;
                            }
                        } else {
                            config += ` authentication port-control auto\n`;
                            
                            if (params.deploymentType === 'monitor') {
                                config += ` authentication open\n`;
                            }
                            
                            config += ` authentication host-mode ${params.hostMode}\n`;
                            config += ` authentication control-direction ${params.controlDirection}\n`;
                            config += ` authentication periodic\n`;
                            config += ` authentication timer reauthenticate server\n`;
                        }
                    }
                    
                    // MACsec if enabled
                    if (params.authMethods.includes('macsec')) {
                        config += ` macsec\n`;
                        config += ` macsec replay-protection window-size 0\n`;
                    }
                    
                    // Web Authentication if enabled
                    if (params.authMethods.includes('webauth')) {
                        config += ` ip access-group ACL-WEBAUTH-REDIRECT in\n`;
                        config += ` ip admission WEBAUTH\n`;
                    }
                    
                    // Enable port
                    config += ` no shutdown\n`;
                    break;
                    
                case 'aruba':
                    config += `! Interface Configuration\n`;
                    
                    // Aruba has a different approach, with most auth settings configured globally
                    // Additional port-specific settings:
                    const interfaces = params.accessInterfaceRange.split(',');
                    
                    for (const iface of interfaces) {
                        config += `!\n`;
                        config += `interface ${iface}\n`;
                        config += ` name "802.1X Authentication Port"\n`;
                        
                        if (params.securityFeatures.includes('bpduGuard')) {
                            config += ` spanning-tree bpdu-guard\n`;
                            config += ` spanning-tree port-type admin-edge\n`;
                        }
                        
                        if (params.securityFeatures.includes('stormControl')) {
                            config += ` broadcast-limit 1\n`;
                            config += ` multicast-limit 1\n`;
                        }
                        
                        config += ` no shutdown\n`;
                    }
                    
                    // VLAN configuration
                    config += `!\n`;
                    config += `vlan ${params.accessVlan}\n`;
                    config += ` name "User-VLAN"\n`;
                    
                    if (params.voiceVlan) {
                        config += `!\n`;
                        config += `vlan ${params.voiceVlan}\n`;
                        config += ` name "Voice-VLAN"\n`;
                    }
                    break;
                    
                case 'juniper':
                    config = `# Interface Configuration\n`;
                    
                    // Create interface configuration
                    config += `interfaces {\n`;
                    config += `    <interface-name> {\n`;
                    config += `        unit 0 {\n`;
                    config += `            family ethernet-switching {\n`;
                    config += `                port-mode access;\n`;
                    config += `                vlan {\n`;
                    config += `                    members ${params.accessVlan};\n`;
                    config += `                }\n`;
                    
                    if (params.voiceVlan) {
                        config += `                voip {\n`;
                        config += `                    vlan ${params.voiceVlan};\n`;
                        config += `                }\n`;
                    }
                    
                    config += `            }\n`;
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    
                    // Security features for interfaces
                    config += `protocols {\n`;
                    
                    if (params.securityFeatures.includes('bpduGuard')) {
                        config += `    rstp {\n`;
                        config += `        interface <interface-name> {\n`;
                        config += `            edge;\n`;
                        config += `            bpdu-block-on-edge;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                    }
                    
                    config += `}\n`;
                    
                    if (params.securityFeatures.includes('stormControl')) {
                        config += `forwarding-options {\n`;
                        config += `    storm-control-profiles default {\n`;
                        config += `        all {\n`;
                        config += `            bandwidth-percentage 80;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    break;
                    
                default:
                    config += `! Interface Configuration\n`;
                    config += `interface range ${params.accessInterfaceRange}\n`;
                    config += ` switchport access vlan ${params.accessVlan}\n`;
                    config += ` switchport mode access\n`;
            }
            
            return config;
        },
        
        /**
         * Copy configuration to clipboard
         */
        copyToClipboard: function() {
            const configOutput = document.getElementById('configOutput');
            if (!configOutput) return;
            
            // Copy configuration to clipboard
            configOutput.select();
            document.execCommand('copy');
            
            // Show success message
            this.showToast('Configuration copied to clipboard');
        },
        
        /**
         * Download configuration as a text file
         */
        downloadConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            if (!configOutput || !configOutput.value.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get vendor and platform
            const vendor = document.getElementById('vendor')?.value || 'network';
            const platform = document.getElementById('platform')?.value || 'device';
            
            // Create file name with date
            const date = new Date().toISOString().slice(0, 10);
            const fileName = `${vendor}_${platform}_config_${date}.txt`;
            
            // Create a blob and download link
            const blob = new Blob([configOutput.value], { type: 'text/plain' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = fileName;
            
            // Trigger download
            document.body.appendChild(a);
            a.click();
            
            // Clean up
            setTimeout(() => {
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
            }, 0);
            
            // Show success message
            this.showToast('Configuration downloaded successfully');
        },
        
        /**
         * Validate configuration
         */
        validateConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const validationResults = document.getElementById('validationResults');
            
            if (!configOutput || !configOutput.value.trim() || !validationResults) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get validation options
            const validateSyntax = document.getElementById('validateSyntax')?.checked || true;
            const validateSecurity = document.getElementById('validateSecurity')?.checked || false;
            const validateCompatibility = document.getElementById('validateCompatibility')?.checked || false;
            const validatePerformance = document.getElementById('validatePerformance')?.checked || false;
            
            // Simulate validation by checking common configuration elements
            const config = configOutput.value;
            const results = [];
            
            // Syntax validation
            if (validateSyntax) {
                // Check for missing 'aaa new-model'
                if (config.includes('aaa authentication') && !config.includes('aaa new-model')) {
                    results.push({
                        type: 'error',
                        message: 'AAA commands found but "aaa new-model" is missing.',
                        recommendation: 'Add "aaa new-model" before AAA commands.'
                    });
                }
                
                // Check for interface ranges without interfaces
                if (config.includes('interface range') && !/interface range\s+\w+/i.test(config)) {
                    results.push({
                        type: 'error',
                        message: 'Interface range command found without interface specifications.',
                        recommendation: 'Specify interfaces in the interface range command.'
                    });
                }
                
                // Check for missing VLAN in access port configuration
                if (config.includes('switchport mode access') && !config.includes('switchport access vlan')) {
                    results.push({
                        type: 'warning',
                        message: 'Access port configuration found without VLAN assignment.',
                        recommendation: 'Add "switchport access vlan <vlan-id>" to access ports.'
                    });
                }
                
                // Check for incomplete policy maps
                if (config.includes('policy-map') && !config.includes('class ')) {
                    results.push({
                        type: 'error',
                        message: 'Policy map found without class configuration.',
                        recommendation: 'Add class configuration to policy maps.'
                    });
                }
                
                // Check for proper command indentation
                if (/^\s+\S+/m.test(config) && !/^\s\s\S+/m.test(config)) {
                    results.push({
                        type: 'warning',
                        message: 'Inconsistent command indentation detected.',
                        recommendation: 'Use consistent indentation (2 spaces) for nested commands.'
                    });
                }
            }
            
            // Security validation
            if (validateSecurity) {
                // Check for 802.1X with dot1x system-auth-control
                if (config.includes('dot1x pae authenticator') && !config.includes('dot1x system-auth-control')) {
                    results.push({
                        type: 'error',
                        message: '802.1X interface configuration found but "dot1x system-auth-control" is missing.',
                        recommendation: 'Add "dot1x system-auth-control" to enable 802.1X globally.'
                    });
                }
                
                // Check for DHCP snooping without IP Source Guard
                if (config.includes('ip dhcp snooping') && !config.includes('ip verify source')) {
                    results.push({
                        type: 'warning',
                        message: 'DHCP snooping enabled but IP Source Guard is not configured on interfaces.',
                        recommendation: 'Consider adding "ip verify source" to protect against IP spoofing.'
                    });
                }
                
                // Check for unused native VLAN on trunks
                if (config.includes('switchport mode trunk') && !config.includes('switchport trunk native vlan')) {
                    results.push({
                        type: 'warning',
                        message: 'Trunk ports found without explicit native VLAN configuration.',
                        recommendation: 'Set unused native VLAN with "switchport trunk native vlan <vlan-id>".'
                    });
                }
                
                // Check for authentication open
                if (config.includes('authentication open') || config.includes('access-session closed') === false) {
                    results.push({
                        type: 'info',
                        message: 'Monitor mode (open authentication) is enabled.',
                        recommendation: 'This is suitable for initial deployment but should be changed to closed mode for production.'
                    });
                }
                
                // Check for critical authentication
                if ((config.includes('dot1x') || config.includes('mab')) && !config.includes('critical')) {
                    results.push({
                        type: 'warning',
                        message: 'Authentication enabled but critical authentication is not configured.',
                        recommendation: 'Add critical authentication for RADIUS server failure handling.'
                    });
                }
            }
            
            // Compatibility validation
            if (validateCompatibility) {
                // Check for new vs old style authentication commands
                if (config.includes('authentication port-control') && config.includes('access-session port-control')) {
                    results.push({
                        type: 'error',
                        message: 'Mixed old-style and new-style authentication commands detected.',
                        recommendation: 'Use consistently either old-style or new-style authentication commands.'
                    });
                }
                
                // Check for conflicting host modes
                if (config.includes('authentication host-mode multi-auth') && config.includes('dot1x host-mode')) {
                    results.push({
                        type: 'error',
                        message: 'Conflicting host mode commands detected.',
                        recommendation: 'Use either "authentication host-mode" or "dot1x host-mode" but not both.'
                    });
                }
                
                // Check for IOS vs IOS-XE commands
                if (config.includes('device-tracking attach-policy') && config.includes('ip device tracking')) {
                    results.push({
                        type: 'error',
                        message: 'Mixed IOS and IOS-XE device tracking commands detected.',
                        recommendation: 'Use consistently either IOS or IOS-XE device tracking commands.'
                    });
                }
            }
            
            // Performance validation
            if (validatePerformance) {
                // Check for excessive tx-period
                const txPeriodMatch = config.match(/tx-period\s+(\d+)/);
                if (txPeriodMatch && parseInt(txPeriodMatch[1]) > 10) {
                    results.push({
                        type: 'warning',
                        message: `TX period value (${txPeriodMatch[1]}) is high which can delay authentication.`,
                        recommendation: 'Set tx-period to a value between 5-10 seconds for better performance.'
                    });
                }
                
                // Check for sequential vs concurrent authentication
                if (config.includes('do-until-failure') && config.includes('authenticate using dot1x') && config.includes('authenticate using mab')) {
                    results.push({
                        type: 'info',
                        message: 'Sequential authentication detected (dot1x then mab).',
                        recommendation: 'Consider using concurrent authentication with "do-all" for faster authentication.'
                    });
                }
                
                // Check for RADIUS timeouts
                const timeoutMatch = config.match(/timeout\s+(\d+)/);
                if (timeoutMatch && parseInt(timeoutMatch[1]) > 5) {
                    results.push({
                        type: 'warning',
                        message: `RADIUS timeout value (${timeoutMatch[1]}) is high which can delay authentication.`,
                        recommendation: 'Set timeout to 3-5 seconds for better performance.'
                    });
                }
            }
            
            // Display validation results
            if (results.length === 0) {
                validationResults.innerHTML = `
                    <div class="validation-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Validation successful! No issues found.</span>
                    </div>
                `;
            } else {
                let html = `
                    <div class="validation-summary">
                        <span>Found ${results.length} issue${results.length > 1 ? 's' : ''}.</span>
                    </div>
                    <div class="validation-issues">
                `;
                
                // Sort results by type (error, warning, info)
                results.sort((a, b) => {
                    const typeOrder = { error: 0, warning: 1, info: 2 };
                    return typeOrder[a.type] - typeOrder[b.type];
                });
                
                // Add each issue
                for (const result of results) {
                    html += `
                        <div class="validation-issue ${result.type}">
                            <div class="issue-icon">
                                <i class="fas fa-${result.type === 'error' ? 'times' : (result.type === 'warning' ? 'exclamation' : 'info')}-circle"></i>
                            </div>
                            <div class="issue-content">
                                <div class="issue-message">${result.message}</div>
                                <div class="issue-recommendation">${result.recommendation}</div>
                            </div>
                        </div>
                    `;
                }
                
                html += `</div>`;
                validationResults.innerHTML = html;
                
                // Add validation styles if not already added
                this.addValidationStyles();
            }
        },
        
        /**
         * Add validation styles to document
         */
        addValidationStyles: function() {
            if (!document.getElementById('validationStyles')) {
                const style = document.createElement('style');
                style.id = 'validationStyles';
                style.innerHTML = `
                    .validation-success {
                        background-color: #d4edda;
                        color: #155724;
                        padding: 15px;
                        border-radius: 4px;
                        display: flex;
                        align-items: center;
                    }
                    
                    .validation-success i {
                        font-size: 20px;
                        margin-right: 10px;
                    }
                    
                    .validation-summary {
                        margin-bottom: 15px;
                        font-weight: 500;
                    }
                    
                    .validation-issues {
                        display: flex;
                        flex-direction: column;
                        gap: 10px;
                    }
                    
                    .validation-issue {
                        display: flex;
                        padding: 10px;
                        border-radius: 4px;
                    }
                    
                    .validation-issue.error {
                        background-color: #f8d7da;
                        color: #721c24;
                    }
                    
                    .validation-issue.warning {
                        background-color: #fff3cd;
                        color: #856404;
                    }
                    
                    .validation-issue.info {
                        background-color: #d1ecf1;
                        color: #0c5460;
                    }
                    
                    .issue-icon {
                        margin-right: 10px;
                        font-size: 18px;
                        display: flex;
                        align-items: center;
                    }
                    
                    .issue-content {
                        flex: 1;
                    }
                    
                    .issue-message {
                        font-weight: 500;
                        margin-bottom: 5px;
                    }
                    
                    .issue-recommendation {
                        font-size: 14px;
                    }
                `;
                document.head.appendChild(style);
            }
        },
        
        /**
         * Show toast message
         * @param {string} message - Message to display
         */
        showToast: function(message) {
            // Create toast element
            const toast = document.createElement('div');
            toast.className = 'toast-notification';
            toast.innerHTML = `
                <div class="toast-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="toast-message">
                    ${message}
                </div>
            `;
            
            // Add to body
            document.body.appendChild(toast);
            
            // Remove after 3 seconds
            setTimeout(() => {
                toast.classList.add('toast-hide');
                setTimeout(() => {
                    document.body.removeChild(toast);
                }, 500);
            }, 3000);
        }
    };

    // Initialize Template Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        TemplateGenerator.init();
    });

    // Export to window
    window.TemplateGenerator = TemplateGenerator;
})();
