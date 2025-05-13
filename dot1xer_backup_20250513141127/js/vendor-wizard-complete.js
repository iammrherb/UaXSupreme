/**
 * Vendor-Specific 802.1X Configuration Wizard - Complete Implementation
 * Includes all vendor-specific features, RADIUS groups, TACACS, and IBNS
 */

class VendorConfigWizard {
    constructor() {
        this.currentVendor = null;
        this.currentPlatform = null;
        this.currentStep = 0;
        this.configuration = {};
        this.wizardSteps = [];
        this.vendorCapabilities = this.loadCompleteVendorCapabilities();
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.injectWizardHTML();
    }
    
    loadCompleteVendorCapabilities() {
        return {
            cisco: {
                'ios': {
                    authentication: ['dot1x', 'mab', 'webauth'],
                    authorization: ['vlan', 'acl', 'sgacl', 'downloadable-acl'],
                    security: ['port-security', 'dhcp-snooping', 'dai', 'ipsg', 'device-tracking'],
                    radius: {
                        features: ['coa', 'dead-server-detection', 'server-groups', 'vsa', 'load-balance', 'server-probe'],
                        serverGroups: true,
                        maxServers: 16,
                        attributes: ['6', '8', '25', '31', '64', '65', '81'],
                        vsaSupport: true,
                        coaPort: 1700,
                        accountingModes: ['system', 'exec', 'network', 'connection', 'resource']
                    },
                    tacacs: {
                        supported: true,
                        serverGroups: true,
                        authorization: ['exec', 'commands', 'network', 'configuration'],
                        accounting: ['exec', 'commands', 'network', 'connection', 'system'],
                        maxServers: 16,
                        authMethods: ['ascii', 'pap', 'chap', 'mschap']
                    },
                    advanced: {
                        macsec: true,
                        criticalAuth: true,
                        monitorMode: true,
                        lowImpact: true,
                        ibns2: {
                            supported: true,
                            classMaps: true,
                            policyMaps: true,
                            serviceTemplates: true
                        }
                    },
                    hostModes: ['single-host', 'multi-host', 'multi-domain', 'multi-auth'],
                    eapMethods: ['peap', 'eap-tls', 'eap-fast', 'eap-md5'],
                    fallback: {
                        local: true,
                        critical: true,
                        vlan: true,
                        webAuth: true
                    }
                },
                'ios-xe': {
                    authentication: ['dot1x', 'mab', 'webauth'],
                    authorization: ['vlan', 'acl', 'sgacl', 'downloadable-acl', 'url-redirect', 'qos'],
                    security: ['port-security', 'dhcp-snooping', 'dai', 'ipsg', 'device-tracking-v2', 'sisf'],
                    radius: {
                        features: ['coa', 'dtls', 'radsec', 'dead-server-detection', 'server-groups', 'vsa', 'load-balance', 'server-probe', 'automate-tester'],
                        serverGroups: true,
                        maxServers: 64,
                        attributes: ['6', '8', '25', '31', '44', '64', '65', '81', '87', '88'],
                        vsaSupport: true,
                        coaPort: 1700,
                        accountingModes: ['system', 'exec', 'network', 'connection', 'resource', 'identity'],
                        radsec: {
                            supported: true,
                            port: 2083,
                            tls: true,
                            dtls: true
                        }
                    },
                    tacacs: {
                        supported: true,
                        serverGroups: true,
                        authorization: ['exec', 'commands', 'network', 'configuration', 'shell'],
                        accounting: ['exec', 'commands', 'network', 'connection', 'system'],
                        maxServers: 64,
                        authMethods: ['ascii', 'pap', 'chap', 'mschap', 'mschapv2']
                    },
                    advanced: {
                        macsec: true,
                        criticalAuth: true,
                        monitorMode: true,
                        lowImpact: true,
                        closedMode: true,
                        ibns2: {
                            supported: true,
                            classMaps: true,
                            policyMaps: true,
                            serviceTemplates: true,
                            subscriberAging: true,
                            concurrentAuth: true
                        }
                    },
                    hostModes: ['single-host', 'multi-host', 'multi-domain', 'multi-auth'],
                    eapMethods: ['peap', 'eap-tls', 'eap-fast', 'eap-md5', 'eap-teap'],
                    fallback: {
                        local: true,
                        critical: true,
                        vlan: true,
                        webAuth: true,
                        mab: true
                    }
                }
            },
            aruba: {
                'aos-cx': {
                    authentication: ['dot1x', 'mab', 'webauth', 'captive-portal'],
                    authorization: ['vlan', 'acl', 'user-role', 'downloadable-acl', 'qos'],
                    security: ['port-security', 'dhcp-snooping', 'arp-protect', 'ipsg', 'storm-control'],
                    radius: {
                        features: ['coa', 'server-tracking', 'server-groups', 'vsa', 'dead-time', 'load-balance'],
                        serverGroups: true,
                        maxServers: 8,
                        attributes: ['1', '2', '6', '8', '25', '31', '64', '65'],
                        vsaSupport: true,
                        coaPort: 3799,
                        accountingModes: ['network', 'exec', 'session']
                    },
                    tacacs: {
                        supported: true,
                        serverGroups: true,
                        authorization: ['exec', 'commands'],
                        accounting: ['exec', 'commands'],
                        maxServers: 8,
                        authMethods: ['ascii', 'pap']
                    },
                    advanced: {
                        deviceFingerprinting: true,
                        criticalAuth: true,
                        cachedReauth: true,
                        userRoles: {
                            supported: true,
                            downloadable: true,
                            local: true
                        },
                        clearpass: {
                            supported: true,
                            cppm: true,
                            onguard: true,
                            onboard: true
                        }
                    },
                    hostModes: ['single-auth', 'multi-auth', 'multi-domain'],
                    eapMethods: ['peap', 'eap-tls', 'eap-ttls'],
                    fallback: {
                        critical: true,
                        vlan: true,
                        role: true
                    }
                }
            }
        };
    }
    
    setupEventListeners() {
        // Listen for vendor selection in the existing system
        document.addEventListener('vendorChange', (e) => {
            this.handleVendorChange(e.detail.vendor);
        });
        
        // Platform selection
        document.getElementById('platform-select')?.addEventListener('change', (e) => {
            this.handlePlatformChange(e.target.value);
        });
        
        // Wizard navigation
        document.addEventListener('click', (e) => {
            if (e.target.matches('.wizard-next')) {
                this.nextStep();
            } else if (e.target.matches('.wizard-prev')) {
                this.previousStep();
            } else if (e.target.matches('.wizard-generate')) {
                this.generateConfiguration();
            }
        });
    }
    
    handleVendorChange(vendor) {
        this.currentVendor = vendor;
        this.rebuildWizard();
    }
    
    handlePlatformChange(platform) {
        this.currentPlatform = platform;
        this.rebuildWizard();
    }
    
    rebuildWizard() {
        if (!this.currentVendor || !this.currentPlatform) return;
        
        const capabilities = this.vendorCapabilities[this.currentVendor]?.[this.currentPlatform];
        if (!capabilities) return;
        
        this.wizardSteps = this.buildWizardSteps(capabilities);
        this.currentStep = 0;
        this.renderWizard();
    }
    
    buildWizardSteps(capabilities) {
        const steps = [];
        
        // Step 1: Basic Settings
        steps.push({
            id: 'basic',
            title: 'Basic 802.1X Settings',
            render: () => this.renderBasicSettings(capabilities)
        });
        
        // Step 2: RADIUS Configuration with Server Groups
        steps.push({
            id: 'radius',
            title: 'RADIUS Servers & Groups',
            render: () => this.renderRadiusConfiguration(capabilities)
        });
        
        // Step 3: TACACS+ Configuration (if supported)
        if (capabilities.tacacs?.supported) {
            steps.push({
                id: 'tacacs',
                title: 'TACACS+ Configuration',
                render: () => this.renderTacacsConfiguration(capabilities)
            });
        }
        
        // Step 4: Authentication & Authorization
        steps.push({
            id: 'auth',
            title: 'Authentication & Authorization',
            render: () => this.renderAuthConfiguration(capabilities)
        });
        
        // Step 5: Security Features
        steps.push({
            id: 'security',
            title: 'Security Features',
            render: () => this.renderSecurityFeatures(capabilities)
        });
        
        // Step 6: Advanced Features (including IBNS for Cisco)
        steps.push({
            id: 'advanced',
            title: 'Advanced Features',
            render: () => this.renderAdvancedFeatures(capabilities)
        });
        
        // Step 7: Fallback & Redundancy
        steps.push({
            id: 'fallback',
            title: 'Fallback & Redundancy',
            render: () => this.renderFallbackOptions(capabilities)
        });
        
        // Step 8: Review & Generate
        steps.push({
            id: 'review',
            title: 'Review & Generate',
            render: () => this.renderReview(capabilities)
        });
        
        return steps;
    }
    
    renderBasicSettings(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Basic 802.1X Settings</h3>
                
                <div class="form-group">
                    <label>Interface/Port Range</label>
                    <input type="text" id="interface-range" class="form-control" 
                           placeholder="${this.getInterfacePlaceholder()}" />
                    <small class="help-text">Example: ${this.getInterfaceExample()}</small>
                </div>
                
                <div class="form-group">
                    <label>Host Mode</label>
                    <select id="host-mode" class="form-control">
                        ${capabilities.hostModes.map(mode => `
                            <option value="${mode}">${this.formatHostMode(mode)}</option>
                        `).join('')}
                    </select>
                    <small class="help-text">${this.getHostModeHelp()}</small>
                </div>
                
                <div class="form-group">
                    <label>Authentication Mode</label>
                    <div class="radio-group">
                        ${capabilities.advanced.closedMode ? `
                        <label class="radio">
                            <input type="radio" name="auth-mode" value="closed" checked>
                            Closed Mode (802.1X Enforced)
                        </label>
                        ` : ''}
                        <label class="radio">
                            <input type="radio" name="auth-mode" value="open">
                            Open Mode (Authentication Optional)
                        </label>
                        ${capabilities.advanced.monitorMode ? `
                        <label class="radio">
                            <input type="radio" name="auth-mode" value="monitor">
                            Monitor Mode (Log Only)
                        </label>
                        ` : ''}
                        ${capabilities.advanced.lowImpact ? `
                        <label class="radio">
                            <input type="radio" name="auth-mode" value="low-impact">
                            Low Impact Mode
                        </label>
                        ` : ''}
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Control Direction</label>
                    <select id="control-direction" class="form-control">
                        <option value="both">Both Directions (Default)</option>
                        <option value="in">Inbound Only</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>Authentication Order</label>
                    <select id="auth-order" class="form-control" multiple>
                        ${capabilities.authentication.map(method => `
                            <option value="${method}" selected>${this.formatAuthMethod(method)}</option>
                        `).join('')}
                    </select>
                    <small class="help-text">Drag to reorder authentication methods</small>
                </div>
                
                <div class="form-group">
                    <label>Authentication Priority</label>
                    <select id="auth-priority" class="form-control" multiple>
                        ${capabilities.authentication.map(method => `
                            <option value="${method}" selected>${this.formatAuthMethod(method)}</option>
                        `).join('')}
                    </select>
                </div>
            </div>
        `;
    }
    
    renderRadiusConfiguration(capabilities) {
        const radiusCap = capabilities.radius;
        const supportsGroups = radiusCap.serverGroups;
        const supportsRadSec = radiusCap.radsec?.supported;
        
        return `
            <div class="wizard-step-content">
                <h3>RADIUS Server Configuration</h3>
                
                ${supportsGroups ? `
                <div class="form-group">
                    <label>RADIUS Server Group Name</label>
                    <input type="text" id="radius-group-name" class="form-control" 
                           value="${this.getDefaultGroupName()}" />
                    <small class="help-text">Name for the RADIUS server group</small>
                </div>
                ` : ''}
                
                <div class="radius-servers">
                    <h4>RADIUS Servers</h4>
                    <div id="radius-server-list">
                        ${this.renderRadiusServer(1, true)}
                    </div>
                    <button type="button" class="btn btn-secondary add-radius-server" 
                            data-max="${radiusCap.maxServers}">
                        Add RADIUS Server
                    </button>
                </div>
                
                <div class="radius-options">
                    <h4>RADIUS Options</h4>
                    
                    <div class="form-row">
                        <div class="form-group col-4">
                            <label>Timeout (seconds)</label>
                            <input type="number" id="radius-timeout" class="form-control" value="5" />
                        </div>
                        <div class="form-group col-4">
                            <label>Retransmit</label>
                            <input type="number" id="radius-retransmit" class="form-control" value="3" />
                        </div>
                        <div class="form-group col-4">
                            <label>Dead Time (minutes)</label>
                            <input type="number" id="radius-deadtime" class="form-control" value="15" />
                        </div>
                    </div>
                    
                    ${radiusCap.features.includes('load-balance') ? `
                    <div class="form-group">
                        <label>Load Balancing</label>
                        <select id="radius-load-balance" class="form-control">
                            <option value="">Disabled</option>
                            <option value="round-robin">Round Robin</option>
                            <option value="least-outstanding">Least Outstanding</option>
                            <option value="batch-size">Batch Size</option>
                        </select>
                    </div>
                    ` : ''}
                    
                    ${radiusCap.features.includes('dead-server-detection') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="radius-dead-detection" checked>
                            Enable Dead Server Detection
                        </label>
                    </div>
                    ` : ''}
                    
                    ${radiusCap.features.includes('server-probe') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="radius-server-probe">
                            Enable Automated Server Probing
                        </label>
                        <div id="server-probe-options" style="display: none;">
                            <input type="text" id="probe-username" class="form-control" 
                                   placeholder="Probe username" value="radius-test" />
                        </div>
                    </div>
                    ` : ''}
                    
                    <h4>RADIUS Attributes</h4>
                    <div class="checkbox-group">
                        ${radiusCap.attributes.map(attr => `
                            <label class="checkbox">
                                <input type="checkbox" name="radius-attr" value="${attr}" 
                                       ${this.isDefaultAttribute(attr) ? 'checked' : ''}>
                                Attribute ${attr} ${this.getAttributeDescription(attr)}
                            </label>
                        `).join('')}
                    </div>
                    
                    ${radiusCap.vsaSupport ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-vsa" checked>
                            Enable Vendor Specific Attributes (VSA)
                        </label>
                    </div>
                    ` : ''}
                    
                    ${radiusCap.features.includes('coa') ? `
                    <h4>Change of Authorization (CoA)</h4>
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-coa" checked>
                            Enable RADIUS CoA
                        </label>
                        <div id="coa-options">
                            <div class="form-group">
                                <label>CoA Port</label>
                                <input type="number" id="coa-port" class="form-control" 
                                       value="${radiusCap.coaPort || 1700}" />
                            </div>
                            <div class="form-group">
                                <label>CoA Type</label>
                                <select id="coa-type" class="form-control">
                                    <option value="any">Any</option>
                                    <option value="all">All</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    ` : ''}
                    
                    ${supportsRadSec ? `
                    <h4>RadSec Configuration</h4>
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-radsec">
                            Enable RadSec (RADIUS over TLS)
                        </label>
                        <div id="radsec-options" style="display: none;">
                            <div class="form-group">
                                <label>RadSec Port</label>
                                <input type="number" id="radsec-port" class="form-control" 
                                       value="${radiusCap.radsec.port}" />
                            </div>
                            <div class="form-group">
                                <label>TLS Version</label>
                                <select id="radsec-tls-version" class="form-control">
                                    <option value="1.2">TLS 1.2</option>
                                    <option value="1.3">TLS 1.3</option>
                                </select>
                            </div>
                            ${radiusCap.radsec.dtls ? `
                            <div class="form-group">
                                <label class="checkbox">
                                    <input type="checkbox" id="enable-dtls">
                                    Enable DTLS
                                </label>
                            </div>
                            ` : ''}
                        </div>
                    </div>
                    ` : ''}
                    
                    <h4>Accounting</h4>
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-accounting" checked>
                            Enable RADIUS Accounting
                        </label>
                        <div id="accounting-options">
                            <div class="form-group">
                                <label>Accounting Modes</label>
                                <select id="accounting-modes" class="form-control" multiple>
                                    ${radiusCap.accountingModes.map(mode => `
                                        <option value="${mode}" 
                                                ${mode === 'network' ? 'selected' : ''}>
                                            ${mode.charAt(0).toUpperCase() + mode.slice(1)}
                                        </option>
                                    `).join('')}
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Update Interval (minutes)</label>
                                <input type="number" id="accounting-interval" class="form-control" value="60" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }
    
    renderRadiusServer(index, isPrimary = false) {
        return `
            <div class="radius-server-config" data-server-index="${index}">
                <h5>${isPrimary ? 'Primary' : `Server ${index}`} RADIUS Server</h5>
                <div class="form-row">
                    <div class="form-group col-8">
                        <label>Server IP/Hostname</label>
                        <input type="text" id="radius-server-${index}" 
                               class="form-control" ${isPrimary ? 'required' : ''} />
                    </div>
                    <div class="form-group col-4">
                        <label>Server Name</label>
                        <input type="text" id="radius-name-${index}" 
                               class="form-control" value="RADIUS-${index}" />
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-4">
                        <label>Auth Port</label>
                        <input type="number" id="radius-auth-port-${index}" 
                               class="form-control" value="1812" />
                    </div>
                    <div class="form-group col-4">
                        <label>Acct Port</label>
                        <input type="number" id="radius-acct-port-${index}" 
                               class="form-control" value="1813" />
                    </div>
                    <div class="form-group col-4">
                        <label>Priority</label>
                        <input type="number" id="radius-priority-${index}" 
                               class="form-control" value="${index}" />
                    </div>
                </div>
                <div class="form-group">
                    <label>Shared Secret</label>
                    <input type="password" id="radius-secret-${index}" 
                           class="form-control" ${isPrimary ? 'required' : ''} />
                </div>
                ${!isPrimary ? `
                <button type="button" class="btn btn-danger btn-sm remove-radius-server" 
                        data-server-index="${index}">
                    Remove Server
                </button>
                ` : ''}
            </div>
        `;
    }
    
    renderTacacsConfiguration(capabilities) {
        const tacacsCap = capabilities.tacacs;
        
        return `
            <div class="wizard-step-content">
                <h3>TACACS+ Configuration</h3>
                
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-tacacs">
                        Enable TACACS+ for Device Administration
                    </label>
                </div>
                
                <div id="tacacs-config" style="display: none;">
                    ${tacacsCap.serverGroups ? `
                    <div class="form-group">
                        <label>TACACS+ Server Group Name</label>
                        <input type="text" id="tacacs-group-name" class="form-control" 
                               value="TACACS-GROUP" />
                    </div>
                    ` : ''}
                    
                    <div class="tacacs-servers">
                        <h4>TACACS+ Servers</h4>
                        <div id="tacacs-server-list">
                            ${this.renderTacacsServer(1, true)}
                        </div>
                        <button type="button" class="btn btn-secondary add-tacacs-server" 
                                data-max="${tacacsCap.maxServers}">
                            Add TACACS+ Server
                        </button>
                    </div>
                    
                    <h4>Authentication Settings</h4>
                    <div class="form-group">
                        <label>Authentication Method</label>
                        <select id="tacacs-auth-method" class="form-control">
                            ${tacacsCap.authMethods.map(method => `
                                <option value="${method}">${method.toUpperCase()}</option>
                            `).join('')}
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Fallback Authentication</label>
                        <select id="tacacs-fallback" class="form-control">
                            <option value="none">None</option>
                            <option value="local">Local</option>
                            <option value="radius">RADIUS</option>
                        </select>
                    </div>
                    
                    <h4>Authorization Settings</h4>
                    <div class="checkbox-group">
                        ${tacacsCap.authorization.map(auth => `
                            <label class="checkbox">
                                <input type="checkbox" name="tacacs-authz" value="${auth}" 
                                       ${auth === 'exec' ? 'checked' : ''}>
                                ${this.formatTacacsAuth(auth)}
                            </label>
                        `).join('')}
                    </div>
                    
                    <h4>Accounting Settings</h4>
                    <div class="checkbox-group">
                        ${tacacsCap.accounting.map(acct => `
                            <label class="checkbox">
                                <input type="checkbox" name="tacacs-acct" value="${acct}" 
                                       ${acct === 'commands' ? 'checked' : ''}>
                                ${this.formatTacacsAcct(acct)}
                            </label>
                        `).join('')}
                    </div>
                    
                    <div class="form-group">
                        <label>Command Accounting Levels</label>
                        <select id="tacacs-cmd-levels" class="form-control" multiple>
                            <option value="0" selected>Level 0 (User)</option>
                            <option value="1" selected>Level 1 (Privileged)</option>
                            <option value="15" selected>Level 15 (Admin)</option>
                        </select>
                    </div>
                </div>
            </div>
        `;
    }
    
    renderTacacsServer(index, isPrimary = false) {
        return `
            <div class="tacacs-server-config" data-server-index="${index}">
                <h5>${isPrimary ? 'Primary' : `Server ${index}`} TACACS+ Server</h5>
                <div class="form-row">
                    <div class="form-group col-8">
                        <label>Server IP/Hostname</label>
                        <input type="text" id="tacacs-server-${index}" 
                               class="form-control" ${isPrimary ? 'required' : ''} />
                    </div>
                    <div class="form-group col-4">
                        <label>Port</label>
                        <input type="number" id="tacacs-port-${index}" 
                               class="form-control" value="49" />
                    </div>
                </div>
                <div class="form-group">
                    <label>Shared Key</label>
                    <input type="password" id="tacacs-key-${index}" 
                           class="form-control" ${isPrimary ? 'required' : ''} />
                </div>
                <div class="form-row">
                    <div class="form-group col-6">
                        <label>Timeout (seconds)</label>
                        <input type="number" id="tacacs-timeout-${index}" 
                               class="form-control" value="5" />
                    </div>
                    <div class="form-group col-6">
                        <label>Priority</label>
                        <input type="number" id="tacacs-priority-${index}" 
                               class="form-control" value="${index}" />
                    </div>
                </div>
                ${!isPrimary ? `
                <button type="button" class="btn btn-danger btn-sm remove-tacacs-server" 
                        data-server-index="${index}">
                    Remove Server
                </button>
                ` : ''}
            </div>
        `;
    }
    
    renderAuthConfiguration(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Authentication & Authorization</h3>
                
                <h4>Authentication Methods</h4>
                <div class="auth-method-settings">
                    ${capabilities.authentication.includes('dot1x') ? `
                    <div class="method-config">
                        <h5>802.1X Settings</h5>
                        <div class="form-row">
                            <div class="form-group col-4">
                                <label>Reauth Period (seconds)</label>
                                <input type="number" id="dot1x-reauth-period" 
                                       class="form-control" value="3600" />
                            </div>
                            <div class="form-group col-4">
                                <label>TX Period (seconds)</label>
                                <input type="number" id="dot1x-tx-period" 
                                       class="form-control" value="30" />
                            </div>
                            <div class="form-group col-4">
                                <label>Quiet Period (seconds)</label>
                                <input type="number" id="dot1x-quiet-period" 
                                       class="form-control" value="60" />
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label>EAP Methods</label>
                            <select id="eap-methods" class="form-control" multiple>
                                ${capabilities.eapMethods.map(method => `
                                    <option value="${method}" 
                                            ${method === 'peap' ? 'selected' : ''}>
                                        ${method.toUpperCase()}
                                    </option>
                                `).join('')}
                            </select>
                        </div>
                    </div>
                    ` : ''}
                    
                    ${capabilities.authentication.includes('mab') ? `
                    <div class="method-config">
                        <h5>MAC Authentication Bypass (MAB)</h5>
                        <div class="form-group">
                            <label>MAC Address Format</label>
                            <select id="mab-format" class="form-control">
                                <option value="cisco">Cisco (1111.2222.3333)</option>
                                <option value="ietf-upper">IETF Upper (11-22-33-44-55-66)</option>
                                <option value="ietf-lower">IETF Lower (11-22-33-44-55-66)</option>
                                <option value="no-delimiter">No Delimiter (112233445566)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="checkbox">
                                <input type="checkbox" id="mab-eap-md5">
                                Use EAP-MD5 for MAB
                            </label>
                        </div>
                    </div>
                    ` : ''}
                    
                    ${capabilities.authentication.includes('webauth') ? `
                    <div class="method-config">
                        <h5>Web Authentication</h5>
                        <div class="form-group">
                            <label>Portal Type</label>
                            <select id="webauth-type" class="form-control">
                                <option value="central">Centralized Web Auth</option>
                                <option value="local">Local Web Auth</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Redirect URL</label>
                            <input type="url" id="webauth-redirect" class="form-control" 
                                   placeholder="https://ise.company.com/portal/" />
                        </div>
                    </div>
                    ` : ''}
                </div>
                
                <h4>Authorization Options</h4>
                <div class="authorization-config">
                    ${capabilities.authorization.includes('vlan') ? `
                    <div class="form-group">
                        <h5>VLAN Assignment</h5>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label>Authenticated VLAN</label>
                                <input type="number" id="vlan-auth" class="form-control" placeholder="100" />
                            </div>
                            <div class="form-group col-6">
                                <label>Guest VLAN</label>
                                <input type="number" id="vlan-guest" class="form-control" placeholder="900" />
                            </div>
                        </div>
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label>Restricted VLAN</label>
                                <input type="number" id="vlan-restricted" class="form-control" placeholder="999" />
                            </div>
                            ${capabilities.hostModes.includes('multi-domain') ? `
                            <div class="form-group col-6">
                                <label>Voice VLAN</label>
                                <input type="number" id="vlan-voice" class="form-control" placeholder="200" />
                            </div>
                            ` : ''}
                        </div>
                    </div>
                    ` : ''}
                    
                    ${capabilities.authorization.includes('downloadable-acl') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-dacl" checked>
                            Enable Downloadable ACLs (dACLs)
                        </label>
                    </div>
                    ` : ''}
                    
                    ${capabilities.authorization.includes('url-redirect') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-redirect">
                            Enable URL Redirect
                        </label>
                    </div>
                    ` : ''}
                    
                    ${capabilities.authorization.includes('sgacl') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-sgacl">
                            Enable Security Group ACLs (SGACLs)
                        </label>
                    </div>
                    ` : ''}
                    
                    ${capabilities.authorization.includes('qos') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-qos">
                            Enable QoS Policy
                        </label>
                    </div>
                    ` : ''}
                </div>
            </div>
        `;
    }
    
    renderSecurityFeatures(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Security Features</h3>
                
                ${capabilities.security.includes('dhcp-snooping') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-dhcp-snooping">
                        Enable DHCP Snooping
                    </label>
                    <div id="dhcp-snooping-options" style="display: none;">
                        <div class="form-group">
                            <label>DHCP Snooping VLANs</label>
                            <input type="text" id="dhcp-snooping-vlans" class="form-control" 
                                   placeholder="1-100,200" />
                        </div>
                        <div class="form-group">
                            <label class="checkbox">
                                <input type="checkbox" id="dhcp-option82">
                                Insert Option 82
                            </label>
                        </div>
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.security.includes('dai') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-dai">
                        Enable Dynamic ARP Inspection
                    </label>
                    <div id="dai-options" style="display: none;">
                        <div class="form-group">
                            <label>DAI VLANs</label>
                            <input type="text" id="dai-vlans" class="form-control" 
                                   placeholder="1-100,200" />
                        </div>
                        <div class="checkbox-group">
                            <label class="checkbox">
                                <input type="checkbox" id="dai-validate-src" checked>
                                Validate Source MAC
                            </label>
                            <label class="checkbox">
                                <input type="checkbox" id="dai-validate-dst">
                                Validate Destination MAC
                            </label>
                            <label class="checkbox">
                                <input type="checkbox" id="dai-validate-ip" checked>
                                Validate IP
                            </label>
                        </div>
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.security.includes('ipsg') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-ipsg">
                        Enable IP Source Guard
                    </label>
                </div>
                ` : ''}
                
                ${capabilities.security.includes('port-security') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-port-security">
                        Enable Port Security
                    </label>
                    <div id="port-security-options" style="display: none;">
                        <div class="form-row">
                            <div class="form-group col-6">
                                <label>Maximum MAC Addresses</label>
                                <input type="number" id="port-security-max" 
                                       class="form-control" value="1" />
                            </div>
                            <div class="form-group col-6">
                                <label>Violation Action</label>
                                <select id="port-security-violation" class="form-control">
                                    <option value="shutdown">Shutdown</option>
                                    <option value="restrict">Restrict</option>
                                    <option value="protect">Protect</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.security.includes('device-tracking') || capabilities.security.includes('device-tracking-v2') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-device-tracking" checked>
                        Enable Device Tracking ${capabilities.security.includes('device-tracking-v2') ? 'v2' : ''}
                    </label>
                    <div id="device-tracking-options">
                        <div class="form-group">
                            <label>Tracking Policy</label>
                            <input type="text" id="tracking-policy" class="form-control" 
                                   value="IPDT_POLICY" />
                        </div>
                        <div class="form-group">
                            <label class="checkbox">
                                <input type="checkbox" id="tracking-ipv6">
                                Track IPv6 Addresses
                            </label>
                        </div>
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.security.includes('storm-control') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-storm-control">
                        Enable Storm Control
                    </label>
                    <div id="storm-control-options" style="display: none;">
                        <div class="form-row">
                            <div class="form-group col-4">
                                <label>Broadcast Level (%)</label>
                                <input type="number" id="storm-broadcast" 
                                       class="form-control" value="10" />
                            </div>
                            <div class="form-group col-4">
                                <label>Multicast Level (%)</label>
                                <input type="number" id="storm-multicast" 
                                       class="form-control" value="10" />
                            </div>
                            <div class="form-group col-4">
                                <label>Unicast Level (%)</label>
                                <input type="number" id="storm-unicast" 
                                       class="form-control" value="70" />
                            </div>
                        </div>
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.advanced?.macsec ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-macsec">
                        Enable MACsec (802.1AE)
                    </label>
                    <div id="macsec-options" style="display: none;">
                        <div class="form-group">
                            <label>Cipher Suite</label>
                            <select id="macsec-cipher" class="form-control">
                                <option value="gcm-aes-128">GCM-AES-128</option>
                                <option value="gcm-aes-256">GCM-AES-256</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>MKA Policy</label>
                            <input type="text" id="mka-policy" class="form-control" 
                                   value="MKA-POLICY" />
                        </div>
                    </div>
                </div>
                ` : ''}
            </div>
        `;
    }
    
    renderAdvancedFeatures(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Advanced Features</h3>
                
                ${capabilities.advanced?.ibns2?.supported && this.currentVendor === 'cisco' ? `
                <div class="form-group">
                    <h4>IBNS 2.0 Configuration</h4>
                    <label class="checkbox">
                        <input type="checkbox" id="enable-ibns2" checked>
                        Use IBNS 2.0 Configuration Model
                    </label>
                    
                    <div id="ibns2-options">
                        <div class="form-group">
                            <label>Policy Map Name</label>
                            <input type="text" id="policy-map-name" class="form-control" 
                                   value="DOT1X_MAB_POLICY" />
                        </div>
                        
                        ${capabilities.advanced.ibns2.classMaps ? `
                        <div class="form-group">
                            <label>Class Maps</label>
                            <select id="class-maps" class="form-control" multiple>
                                <option value="dot1x" selected>DOT1X</option>
                                <option value="mab" selected>MAB</option>
                                <option value="dot1x-failed" selected>DOT1X_FAILED</option>
                                <option value="dot1x-no-resp" selected>DOT1X_NO_RESP</option>
                                <option value="mab-failed" selected>MAB_FAILED</option>
                                <option value="aaa-down" selected>AAA_SVR_DOWN</option>
                            </select>
                        </div>
                        ` : ''}
                        
                        ${capabilities.advanced.ibns2.serviceTemplates ? `
                        <div class="form-group">
                            <label>Service Templates</label>
                            <select id="service-templates" class="form-control" multiple>
                                <option value="default-access">DEFAULT_ACCESS</option>
                                <option value="critical-access" selected>CRITICAL_ACCESS</option>
                                <option value="restricted-access">RESTRICTED_ACCESS</option>
                                <option value="guest-access">GUEST_ACCESS</option>
                            </select>
                        </div>
                        ` : ''}
                        
                        ${capabilities.advanced.ibns2.concurrentAuth ? `
                        <div class="form-group">
                            <label class="checkbox">
                                <input type="checkbox" id="concurrent-auth">
                                Enable Concurrent Authentication (802.1X + MAB)
                            </label>
                        </div>
                        ` : ''}
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.advanced?.criticalAuth ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-critical-auth">
                        Enable Critical Authentication
                    </label>
                    <div id="critical-auth-options" style="display: none;">
                        <div class="form-group">
                            <label>Critical VLAN</label>
                            <input type="number" id="critical-vlan" class="form-control" />
                        </div>
                        <div class="form-group">
                            <label>Recovery Action</label>
                            <select id="critical-recovery" class="form-control">
                                <option value="reinitialize">Reinitialize</option>
                                <option value="maintain">Maintain</option>
                            </select>
                        </div>
                    </div>
                </div>
                ` : ''}
                
                <div class="form-group">
                    <h4>Timing Configuration</h4>
                    <div class="form-row">
                        <div class="form-group col-4">
                            <label>Reauth Period</label>
                            <select id="reauth-control" class="form-control">
                                <option value="periodic">Periodic</option>
                                <option value="server">Server-based</option>
                                <option value="disabled">Disabled</option>
                            </select>
                        </div>
                        <div class="form-group col-4">
                            <label>Reauth Interval (sec)</label>
                            <input type="number" id="reauth-period" class="form-control" value="3600" />
                        </div>
                        <div class="form-group col-4">
                            <label>Inactivity Timer</label>
                            <input type="number" id="inactivity-timer" class="form-control" value="0" />
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <h4>Session Management</h4>
                    <div class="form-row">
                        <div class="form-group col-6">
                            <label>Max Sessions</label>
                            <input type="number" id="max-sessions" class="form-control" value="256" />
                        </div>
                        <div class="form-group col-6">
                            <label>Session Timeout</label>
                            <input type="number" id="session-timeout" class="form-control" value="0" />
                        </div>
                    </div>
                </div>
                
                ${capabilities.advanced?.clearpass?.supported ? `
                <div class="form-group">
                    <h4>ClearPass Integration</h4>
                    <label class="checkbox">
                        <input type="checkbox" id="enable-clearpass">
                        Enable ClearPass Integration
                    </label>
                    <div id="clearpass-options" style="display: none;">
                        <div class="form-group">
                            <label>ClearPass Server</label>
                            <input type="text" id="clearpass-server" class="form-control" />
                        </div>
                        ${capabilities.advanced.clearpass.onguard ? `
                        <div class="form-group">
                            <label class="checkbox">
                                <input type="checkbox" id="enable-onguard">
                                Enable OnGuard Health Checks
                            </label>
                        </div>
                        ` : ''}
                    </div>
                </div>
                ` : ''}
            </div>
        `;
    }
    
    renderFallbackOptions(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Fallback & Redundancy Options</h3>
                
                <h4>Authentication Fallback</h4>
                <div class="fallback-config">
                    <div class="form-group">
                        <label>Server Dead Action</label>
                        <select id="server-dead-action" class="form-control">
                            <option value="authorize">Authorize</option>
                            <option value="reinitialize">Reinitialize</option>
                            <option value="authorize-vlan">Authorize VLAN</option>
                            <option value="authorize-voice">Authorize Voice</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>No Response Action</label>
                        <select id="no-response-action" class="form-control">
                            <option value="unauthorized">Unauthorized</option>
                            <option value="authorize">Authorize</option>
                            <option value="authorize-vlan">Authorize VLAN</option>
                        </select>
                    </div>
                    
                    ${capabilities.fallback?.critical ? `
                    <div class="form-group">
                        <label>Critical VLAN</label>
                        <input type="number" id="fallback-critical-vlan" class="form-control" />
                    </div>
                    ` : ''}
                    
                    ${capabilities.fallback?.webAuth ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="fallback-webauth">
                            Fallback to Web Authentication
                        </label>
                    </div>
                    ` : ''}
                    
                    ${capabilities.fallback?.local ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="fallback-local">
                            Enable Local Authentication Fallback
                        </label>
                        <div id="local-fallback-options" style="display: none;">
                            <div class="form-group">
                                <label>Local Username</label>
                                <input type="text" id="local-username" class="form-control" />
                            </div>
                            <div class="form-group">
                                <label>Local Password</label>
                                <input type="password" id="local-password" class="form-control" />
                            </div>
                        </div>
                    </div>
                    ` : ''}
                </div>
                
                <h4>Redundancy Configuration</h4>
                <div class="redundancy-config">
                    <div class="form-group">
                        <label>AAA Method Lists</label>
                        <select id="method-lists" class="form-control" multiple>
                            <option value="dot1x-primary" selected>Primary 802.1X</option>
                            <option value="dot1x-backup">Backup 802.1X</option>
                            <option value="mab-primary" selected>Primary MAB</option>
                            <option value="mab-backup">Backup MAB</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Server Selection</label>
                        <select id="server-selection" class="form-control">
                            <option value="round-robin">Round Robin</option>
                            <option value="prefer-primary">Prefer Primary</option>
                            <option value="least-outstanding">Least Outstanding</option>
                        </select>
                    </div>
                </div>
                
                <h4>High Availability</h4>
                <div class="ha-config">
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-ha">
                            Enable High Availability
                        </label>
                    </div>
                    
                    <div id="ha-options" style="display: none;">
                        <div class="form-group">
                            <label>HA Mode</label>
                            <select id="ha-mode" class="form-control">
                                <option value="active-standby">Active-Standby</option>
                                <option value="active-active">Active-Active</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label>Sync Interval (seconds)</label>
                            <input type="number" id="ha-sync-interval" class="form-control" value="30" />
                        </div>
                    </div>
                </div>
            </div>
        `;
    }
    
    renderReview(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Review Configuration</h3>
                
                <div class="review-section">
                    <h4>Configuration Summary</h4>
                    <div id="config-summary">
                        <!-- Summary will be populated dynamically -->
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Configuration Name</label>
                    <input type="text" id="config-name" class="form-control" 
                           placeholder="My 802.1X Configuration" />
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea id="config-description" class="form-control" rows="3"></textarea>
                </div>
                
                <div class="generation-options">
                    <h4>Generation Options</h4>
                    <div class="checkbox-group">
                        <label class="checkbox">
                            <input type="checkbox" id="include-comments" checked>
                            Include Comments
                        </label>
                        <label class="checkbox">
                            <input type="checkbox" id="optimize-config" checked>
                            Optimize Configuration
                        </label>
                        <label class="checkbox">
                            <input type="checkbox" id="validate-config" checked>
                            Validate Configuration
                        </label>
                        <label class="checkbox">
                            <input type="checkbox" id="include-troubleshooting">
                            Include Troubleshooting Commands
                        </label>
                    </div>
                </div>
                
                <div class="actions">
                    <button type="button" class="btn primary wizard-generate">
                        Generate Configuration
                    </button>
                </div>
            </div>
        `;
    }
    
    // Utility methods for vendor-specific details
    getDefaultGroupName() {
        switch (this.currentVendor) {
            case 'cisco':
                return 'ISE-GROUP';
            case 'aruba':
                return 'CLEARPASS-GROUP';
            default:
                return 'DOT1X-SERVERS';
        }
    }
    
    isDefaultAttribute(attr) {
        const defaultAttrs = ['6', '8', '25', '31'];
        return defaultAttrs.includes(attr);
    }
    
    getAttributeDescription(attr) {
        const descriptions = {
            '6': '(Service-Type)',
            '8': '(Framed-IP-Address)',
            '25': '(Class)',
            '31': '(Calling-Station-Id)',
            '44': '(Acct-Session-Id)',
            '64': '(Tunnel-Type)',
            '65': '(Tunnel-Medium-Type)',
            '81': '(Tunnel-Private-Group-ID)',
            '87': '(NAS-Port-Id)',
            '88': '(Framed-Pool)'
        };
        return descriptions[attr] || '';
    }
    
    formatHostMode(mode) {
        const modeMap = {
            'single-host': 'Single Host',
            'multi-host': 'Multi Host',
            'multi-domain': 'Multi Domain (Data + Voice)',
            'multi-auth': 'Multi Auth (Recommended)',
            'single-auth': 'Single Auth',
            'single': 'Single',
            'multiple': 'Multiple',
            'multi-supplicant': 'Multi Supplicant'
        };
        return modeMap[mode] || mode;
    }
    
    formatAuthMethod(method) {
        const methodMap = {
            'dot1x': '802.1X',
            'mab': 'MAC Authentication Bypass',
            'webauth': 'Web Authentication',
            'mac-auth': 'MAC Authentication',
            'captive-portal': 'Captive Portal'
        };
        return methodMap[method] || method;
    }
    
    formatTacacsAuth(auth) {
        const authMap = {
            'exec': 'EXEC Access',
            'commands': 'Command Authorization',
            'network': 'Network Access',
            'configuration': 'Configuration Mode',
            'shell': 'Shell Access'
        };
        return authMap[auth] || auth;
    }
    
    formatTacacsAcct(acct) {
        const acctMap = {
            'exec': 'EXEC Sessions',
            'commands': 'Command Accounting',
            'network': 'Network Sessions',
            'connection': 'Connection Events',
            'system': 'System Events'
        };
        return acctMap[acct] || acct;
    }
    
    collectConfiguration() {
        const config = {
            // Basic settings
            interface: document.getElementById('interface-range')?.value,
            hostMode: document.getElementById('host-mode')?.value,
            authMode: document.querySelector('input[name="auth-mode"]:checked')?.value,
            controlDirection: document.getElementById('control-direction')?.value,
            authOrder: Array.from(document.getElementById('auth-order')?.selectedOptions || []).map(opt => opt.value),
            authPriority: Array.from(document.getElementById('auth-priority')?.selectedOptions || []).map(opt => opt.value),
            
            // RADIUS configuration
            radiusGroupName: document.getElementById('radius-group-name')?.value,
            radiusServers: this.collectRadiusServers(),
            radiusTimeout: document.getElementById('radius-timeout')?.value,
            radiusRetransmit: document.getElementById('radius-retransmit')?.value,
            radiusDeadtime: document.getElementById('radius-deadtime')?.value,
            radiusLoadBalance: document.getElementById('radius-load-balance')?.value,
            radiusDeadDetection: document.getElementById('radius-dead-detection')?.checked,
            radiusServerProbe: document.getElementById('radius-server-probe')?.checked,
            probeUsername: document.getElementById('probe-username')?.value,
            radiusAttributes: Array.from(document.querySelectorAll('input[name="radius-attr"]:checked')).map(el => el.value),
            enableVsa: document.getElementById('enable-vsa')?.checked,
            
            // CoA settings
            enableCoa: document.getElementById('enable-coa')?.checked,
            coaPort: document.getElementById('coa-port')?.value,
            coaType: document.getElementById('coa-type')?.value,
            
            // RadSec settings
            enableRadsec: document.getElementById('enable-radsec')?.checked,
            radsecPort: document.getElementById('radsec-port')?.value,
            radsecTlsVersion: document.getElementById('radsec-tls-version')?.value,
            enableDtls: document.getElementById('enable-dtls')?.checked,
            
            // Accounting settings
            enableAccounting: document.getElementById('enable-accounting')?.checked,
            accountingModes: Array.from(document.getElementById('accounting-modes')?.selectedOptions || []).map(opt => opt.value),
            accountingInterval: document.getElementById('accounting-interval')?.value,
            
            // TACACS+ configuration
            enableTacacs: document.getElementById('enable-tacacs')?.checked,
            tacacsGroupName: document.getElementById('tacacs-group-name')?.value,
            tacacsServers: this.collectTacacsServers(),
            tacacsAuthMethod: document.getElementById('tacacs-auth-method')?.value,
            tacacsFallback: document.getElementById('tacacs-fallback')?.value,
            tacacsAuthz: Array.from(document.querySelectorAll('input[name="tacacs-authz"]:checked')).map(el => el.value),
            tacacsAcct: Array.from(document.querySelectorAll('input[name="tacacs-acct"]:checked')).map(el => el.value),
            tacacsCmdLevels: Array.from(document.getElementById('tacacs-cmd-levels')?.selectedOptions || []).map(opt => opt.value),
            
            // Authentication methods
            reauthPeriod: document.getElementById('dot1x-reauth-period')?.value,
            txPeriod: document.getElementById('dot1x-tx-period')?.value,
            quietPeriod: document.getElementById('dot1x-quiet-period')?.value,
            eapMethods: Array.from(document.getElementById('eap-methods')?.selectedOptions || []).map(opt => opt.value),
            mabFormat: document.getElementById('mab-format')?.value,
            mabEapMd5: document.getElementById('mab-eap-md5')?.checked,
            webauthType: document.getElementById('webauth-type')?.value,
            webauthRedirect: document.getElementById('webauth-redirect')?.value,
            
            // Authorization
            vlanAuth: document.getElementById('vlan-auth')?.value,
            vlanGuest: document.getElementById('vlan-guest')?.value,
            vlanRestricted: document.getElementById('vlan-restricted')?.value,
            vlanVoice: document.getElementById('vlan-voice')?.value,
            enableDacl: document.getElementById('enable-dacl')?.checked,
            enableRedirect: document.getElementById('enable-redirect')?.checked,
            enableSgacl: document.getElementById('enable-sgacl')?.checked,
            enableQos: document.getElementById('enable-qos')?.checked,
            
            // Security features
            enableDhcpSnooping: document.getElementById('enable-dhcp-snooping')?.checked,
            dhcpSnoopingVlans: document.getElementById('dhcp-snooping-vlans')?.value,
            dhcpOption82: document.getElementById('dhcp-option82')?.checked,
            enableDai: document.getElementById('enable-dai')?.checked,
            daiVlans: document.getElementById('dai-vlans')?.value,
            daiValidateSrc: document.getElementById('dai-validate-src')?.checked,
            daiValidateDst: document.getElementById('dai-validate-dst')?.checked,
            daiValidateIp: document.getElementById('dai-validate-ip')?.checked,
            enableIpsg: document.getElementById('enable-ipsg')?.checked,
            enablePortSecurity: document.getElementById('enable-port-security')?.checked,
            portSecurityMax: document.getElementById('port-security-max')?.value,
            portSecurityViolation: document.getElementById('port-security-violation')?.value,
            enableDeviceTracking: document.getElementById('enable-device-tracking')?.checked,
            trackingPolicy: document.getElementById('tracking-policy')?.value,
            trackingIpv6: document.getElementById('tracking-ipv6')?.checked,
            enableStormControl: document.getElementById('enable-storm-control')?.checked,
            stormBroadcast: document.getElementById('storm-broadcast')?.value,
            stormMulticast: document.getElementById('storm-multicast')?.value,
            stormUnicast: document.getElementById('storm-unicast')?.value,
            enableMacsec: document.getElementById('enable-macsec')?.checked,
            macsecCipher: document.getElementById('macsec-cipher')?.value,
            mkaPolicy: document.getElementById('mka-policy')?.value,
            
            // Advanced features
            enableIbns2: document.getElementById('enable-ibns2')?.checked,
            policyMapName: document.getElementById('policy-map-name')?.value,
            classMaps: Array.from(document.getElementById('class-maps')?.selectedOptions || []).map(opt => opt.value),
            serviceTemplates: Array.from(document.getElementById('service-templates')?.selectedOptions || []).map(opt => opt.value),
            concurrentAuth: document.getElementById('concurrent-auth')?.checked,
            enableCriticalAuth: document.getElementById('enable-critical-auth')?.checked,
            criticalVlan: document.getElementById('critical-vlan')?.value,
            criticalRecovery: document.getElementById('critical-recovery')?.value,
            reauthControl: document.getElementById('reauth-control')?.value,
            inactivityTimer: document.getElementById('inactivity-timer')?.value,
            maxSessions: document.getElementById('max-sessions')?.value,
            sessionTimeout: document.getElementById('session-timeout')?.value,
            enableClearpass: document.getElementById('enable-clearpass')?.checked,
            clearpassServer: document.getElementById('clearpass-server')?.value,
            enableOnguard: document.getElementById('enable-onguard')?.checked,
            
            // Fallback options
            serverDeadAction: document.getElementById('server-dead-action')?.value,
            noResponseAction: document.getElementById('no-response-action')?.value,
            fallbackCriticalVlan: document.getElementById('fallback-critical-vlan')?.value,
            fallbackWebauth: document.getElementById('fallback-webauth')?.checked,
            fallbackLocal: document.getElementById('fallback-local')?.checked,
            localUsername: document.getElementById('local-username')?.value,
            localPassword: document.getElementById('local-password')?.value,
            methodLists: Array.from(document.getElementById('method-lists')?.selectedOptions || []).map(opt => opt.value),
            serverSelection: document.getElementById('server-selection')?.value,
            enableHa: document.getElementById('enable-ha')?.checked,
            haMode: document.getElementById('ha-mode')?.value,
            haSyncInterval: document.getElementById('ha-sync-interval')?.value,
            
            // Generation options
            configName: document.getElementById('config-name')?.value,
            configDescription: document.getElementById('config-description')?.value,
            includeComments: document.getElementById('include-comments')?.checked,
            optimizeConfig: document.getElementById('optimize-config')?.checked,
            validateConfig: document.getElementById('validate-config')?.checked,
            includeTroubleshooting: document.getElementById('include-troubleshooting')?.checked,
            
            // Vendor and platform
            vendor: this.currentVendor,
            platform: this.currentPlatform
        };
        
        return config;
    }
    
    collectRadiusServers() {
        const servers = [];
        const serverElements = document.querySelectorAll('.radius-server-config');
        
        serverElements.forEach(element => {
            const index = element.dataset.serverIndex;
            const server = {
                ip: document.getElementById(`radius-server-${index}`)?.value,
                name: document.getElementById(`radius-name-${index}`)?.value,
                authPort: document.getElementById(`radius-auth-port-${index}`)?.value,
                acctPort: document.getElementById(`radius-acct-port-${index}`)?.value,
                priority: document.getElementById(`radius-priority-${index}`)?.value,
                secret: document.getElementById(`radius-secret-${index}`)?.value
            };
            
            if (server.ip && server.secret) {
                servers.push(server);
            }
        });
        
        return servers;
    }
    
    collectTacacsServers() {
        const servers = [];
        const serverElements = document.querySelectorAll('.tacacs-server-config');
        
        serverElements.forEach(element => {
            const index = element.dataset.serverIndex;
            const server = {
                ip: document.getElementById(`tacacs-server-${index}`)?.value,
                port: document.getElementById(`tacacs-port-${index}`)?.value,
                key: document.getElementById(`tacacs-key-${index}`)?.value,
                timeout: document.getElementById(`tacacs-timeout-${index}`)?.value,
                priority: document.getElementById(`tacacs-priority-${index}`)?.value
            };
            
            if (server.ip && server.key) {
                servers.push(server);
            }
        });
        
        return servers;
    }
    
    generateConfiguration() {
        const config = this.collectConfiguration();
        
        // Generate vendor-specific configuration
        const generator = new VendorConfigGenerator(config);
        const configText = generator.generate();
        
        // Display in output
        const configOutput = document.getElementById('config-output');
        if (configOutput) {
            configOutput.textContent = configText;
        }
        
        // Show success message
        if (window.showAlert) {
            window.showAlert('Configuration generated successfully!', 'success');
        }
        
        // Switch to preview tab
        const previewTab = document.querySelector('.tab[data-tab="preview"]');
        if (previewTab) {
            previewTab.click();
        }
    }
    
    // Wizard navigation methods
    nextStep() {
        if (this.currentStep < this.wizardSteps.length - 1) {
            this.currentStep++;
            this.renderWizard();
        }
    }
    
    previousStep() {
        if (this.currentStep > 0) {
            this.currentStep--;
            this.renderWizard();
        }
    }
    
    renderWizard() {
        const wizardContainer = document.getElementById('vendor-wizard-container');
        if (!wizardContainer) return;
        
        const currentStep = this.wizardSteps[this.currentStep];
        if (!currentStep) return;
        
        let html = `
            <div class="wizard-container">
                <div class="wizard-header">
                    <h2>802.1X Configuration Wizard - ${this.currentVendor?.toUpperCase()} ${this.currentPlatform?.toUpperCase()}</h2>
                    <div class="wizard-progress">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${((this.currentStep + 1) / this.wizardSteps.length) * 100}%"></div>
                        </div>
                        <div class="progress-text">Step ${this.currentStep + 1} of ${this.wizardSteps.length}: ${currentStep.title}</div>
                    </div>
                </div>
                
                <div class="wizard-body">
                    ${currentStep.render()}
                </div>
                
                <div class="wizard-footer">
                    <div class="wizard-navigation">
                        ${this.currentStep > 0 ? '<button type="button" class="btn wizard-prev">Previous</button>' : '<div></div>'}
                        ${this.currentStep < this.wizardSteps.length - 1 ? 
                            '<button type="button" class="btn primary wizard-next">Next</button>' :
                            '<button type="button" class="btn primary wizard-generate">Generate Configuration</button>'}
                    </div>
                </div>
            </div>
        `;
        
        wizardContainer.innerHTML = html;
        
        // Set up field interactions
        this.setupFieldInteractions();
        
        // Update summary if on review step
        if (this.currentStep === this.wizardSteps.length - 1) {
            this.updateConfigSummary();
        }
    }
    
    setupFieldInteractions() {
        // RADIUS server management
        const addRadiusBtn = document.querySelector('.add-radius-server');
        if (addRadiusBtn) {
            addRadiusBtn.addEventListener('click', () => {
                const serverList = document.getElementById('radius-server-list');
                const serverCount = serverList.children.length;
                const maxServers = parseInt(addRadiusBtn.dataset.max);
                
                if (serverCount < maxServers) {
                    const newServerHtml = this.renderRadiusServer(serverCount + 1, false);
                    serverList.insertAdjacentHTML('beforeend', newServerHtml);
                }
                
                if (serverCount + 1 >= maxServers) {
                    addRadiusBtn.disabled = true;
                }
            });
        }
        
        // TACACS server management
        const addTacacsBtn = document.querySelector('.add-tacacs-server');
        if (addTacacsBtn) {
            addTacacsBtn.addEventListener('click', () => {
                const serverList = document.getElementById('tacacs-server-list');
                const serverCount = serverList.children.length;
                const maxServers = parseInt(addTacacsBtn.dataset.max);
                
                if (serverCount < maxServers) {
                    const newServerHtml = this.renderTacacsServer(serverCount + 1, false);
                    serverList.insertAdjacentHTML('beforeend', newServerHtml);
                }
                
                if (serverCount + 1 >= maxServers) {
                    addTacacsBtn.disabled = true;
                }
            });
        }
        
        // Remove server buttons
        document.addEventListener('click', (e) => {
            if (e.target.matches('.remove-radius-server')) {
                e.target.closest('.radius-server-config').remove();
                document.querySelector('.add-radius-server').disabled = false;
            }
            
            if (e.target.matches('.remove-tacacs-server')) {
                e.target.closest('.tacacs-server-config').remove();
                document.querySelector('.add-tacacs-server').disabled = false;
            }
        });
        
        // Dynamic option toggles
        this.setupDynamicToggles();
    }
    
    setupDynamicToggles() {
        // Map of checkbox ID to options container ID
        const toggleMap = {
            'enable-tacacs': 'tacacs-config',
            'radius-server-probe': 'server-probe-options',
            'enable-coa': 'coa-options',
            'enable-radsec': 'radsec-options',
            'enable-accounting': 'accounting-options',
            'enable-dhcp-snooping': 'dhcp-snooping-options',
            'enable-dai': 'dai-options',
            'enable-port-security': 'port-security-options',
            'enable-storm-control': 'storm-control-options',
            'enable-macsec': 'macsec-options',
            'enable-ibns2': 'ibns2-options',
            'enable-critical-auth': 'critical-auth-options',
            'fallback-local': 'local-fallback-options',
            'enable-ha': 'ha-options',
            'enable-clearpass': 'clearpass-options'
        };
        
        // Set up toggles
        Object.entries(toggleMap).forEach(([checkboxId, containerId]) => {
            const checkbox = document.getElementById(checkboxId);
            const container = document.getElementById(containerId);
            
            if (checkbox && container) {
                checkbox.addEventListener('change', () => {
                    container.style.display = checkbox.checked ? 'block' : 'none';
                });
                
                // Initialize visibility based on checkbox state
                container.style.display = checkbox.checked ? 'block' : 'none';
            }
        });
    }
    
    updateConfigSummary() {
        const summaryContainer = document.getElementById('config-summary');
        if (!summaryContainer) return;
        
        const config = this.collectConfiguration();
        
        let summary = '<div class="config-summary-grid">';
        
        // Basic settings
        summary += `
            <div class="summary-section">
                <h5>Basic Settings</h5>
                <ul>
                    <li><strong>Interface:</strong> ${config.interface || 'Not specified'}</li>
                    <li><strong>Host Mode:</strong> ${this.formatHostMode(config.hostMode)}</li>
                    <li><strong>Auth Mode:</strong> ${config.authMode}</li>
                    <li><strong>Auth Order:</strong> ${config.authOrder.join(' → ')}</li>
                </ul>
            </div>
        `;
        
        // RADIUS configuration
        summary += `
            <div class="summary-section">
                <h5>RADIUS Configuration</h5>
                <ul>
                    <li><strong>Server Group:</strong> ${config.radiusGroupName}</li>
                    <li><strong>Servers:</strong> ${config.radiusServers.length} configured</li>
                    <li><strong>Load Balancing:</strong> ${config.radiusLoadBalance || 'Disabled'}</li>
                    <li><strong>RadSec:</strong> ${config.enableRadsec ? 'Enabled' : 'Disabled'}</li>
                    <li><strong>CoA:</strong> ${config.enableCoa ? `Enabled (Port ${config.coaPort})` : 'Disabled'}</li>
                </ul>
            </div>
        `;
        
        // TACACS+ if enabled
        if (config.enableTacacs) {
            summary += `
                <div class="summary-section">
                    <h5>TACACS+ Configuration</h5>
                    <ul>
                        <li><strong>Server Group:</strong> ${config.tacacsGroupName}</li>
                        <li><strong>Servers:</strong> ${config.tacacsServers.length} configured</li>
                        <li><strong>Auth Method:</strong> ${config.tacacsAuthMethod?.toUpperCase()}</li>
                        <li><strong>Authorization:</strong> ${config.tacacsAuthz.join(', ')}</li>
                        <li><strong>Accounting:</strong> ${config.tacacsAcct.join(', ')}</li>
                    </ul>
                </div>
            `;
        }
        
        // Security features
        const security = [];
        if (config.enableDhcpSnooping) security.push('DHCP Snooping');
        if (config.enableDai) security.push('DAI');
        if (config.enableIpsg) security.push('IP Source Guard');
        if (config.enablePortSecurity) security.push('Port Security');
        if (config.enableDeviceTracking) security.push('Device Tracking');
        if (config.enableStormControl) security.push('Storm Control');
        if (config.enableMacsec) security.push('MACsec');
        
        summary += `
            <div class="summary-section">
                <h5>Security Features</h5>
                <ul>
                    <li><strong>Enabled:</strong> ${security.join(', ') || 'None'}</li>
                </ul>
            </div>
        `;
        
        // Advanced features
        const advanced = [];
        if (config.enableIbns2) advanced.push('IBNS 2.0');
        if (config.enableCriticalAuth) advanced.push('Critical Auth');
        if (config.enableClearpass) advanced.push('ClearPass Integration');
        
        summary += `
            <div class="summary-section">
                <h5>Advanced Features</h5>
                <ul>
                    <li><strong>Enabled:</strong> ${advanced.join(', ') || 'None'}</li>
                </ul>
            </div>
        `;
        
        summary += '</div>';
        
        summaryContainer.innerHTML = summary;
    }
    
    injectWizardHTML() {
        // Find the authentication tab content
        const authTabContent = document.getElementById('authentication');
        if (!authTabContent) return;
        
        // Create wizard container
        const wizardContainer = document.createElement('div');
        wizardContainer.id = 'vendor-wizard-container';
        wizardContainer.className = 'vendor-wizard-container';
        
        // Insert at the beginning of the authentication tab
        authTabContent.insertBefore(wizardContainer, authTabContent.firstChild);
        
        // Add toggle button
        const toggleButton = document.createElement('button');
        toggleButton.className = 'btn wizard-toggle';
        toggleButton.textContent = 'Enable Advanced Configuration Wizard';
        toggleButton.addEventListener('click', () => {
            const isVisible = wizardContainer.style.display !== 'none';
            wizardContainer.style.display = isVisible ? 'none' : 'block';
            toggleButton.textContent = isVisible ? 'Enable Advanced Configuration Wizard' : 'Disable Advanced Configuration Wizard';
            
            if (!isVisible) {
                this.rebuildWizard();
            }
        });
        
        authTabContent.insertBefore(toggleButton, wizardContainer);
        
        // Initially hide the wizard
        wizardContainer.style.display = 'none';
    }
}

// Initialize the wizard
document.addEventListener('DOMContentLoaded', () => {
    window.vendorWizard = new VendorConfigWizard();
});
