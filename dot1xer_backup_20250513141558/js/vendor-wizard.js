/**
 * Vendor-Specific 802.1X Configuration Wizard
 * Provides dynamic, vendor-specific configuration options
 */

class VendorConfigWizard {
    constructor() {
        this.currentVendor = null;
        this.currentPlatform = null;
        this.currentStep = 0;
        this.configuration = {};
        this.wizardSteps = [];
        this.vendorCapabilities = this.loadVendorCapabilities();
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.injectWizardHTML();
    }
    
    loadVendorCapabilities() {
        return {
            cisco: {
                'ios': {
                    authentication: ['dot1x', 'mab', 'webauth'],
                    authorization: ['vlan', 'acl', 'sgacl', 'downloadable-acl'],
                    security: ['port-security', 'dhcp-snooping', 'dai', 'ipsg', 'device-tracking'],
                    radius: ['coa', 'dead-server-detection', 'server-groups', 'vsa'],
                    advanced: ['macsec', 'critical-auth', 'monitor-mode', 'low-impact'],
                    hostModes: ['single-host', 'multi-host', 'multi-domain', 'multi-auth'],
                    eapMethods: ['peap', 'eap-tls', 'eap-fast', 'eap-md5'],
                    features: {
                        supportsRadSec: false,
                        supportsTacacs: true,
                        supportsIBNS2: true,
                        maxRadiusServers: 16,
                        supportsCriticalAuth: true
                    }
                },
                'ios-xe': {
                    authentication: ['dot1x', 'mab', 'webauth'],
                    authorization: ['vlan', 'acl', 'sgacl', 'downloadable-acl', 'url-redirect'],
                    security: ['port-security', 'dhcp-snooping', 'dai', 'ipsg', 'device-tracking-v2'],
                    radius: ['coa', 'dtls', 'radsec', 'dead-server-detection', 'server-groups', 'vsa', 'load-balance'],
                    advanced: ['macsec', 'critical-auth', 'monitor-mode', 'low-impact', 'closed-mode'],
                    hostModes: ['single-host', 'multi-host', 'multi-domain', 'multi-auth'],
                    eapMethods: ['peap', 'eap-tls', 'eap-fast', 'eap-md5', 'eap-teap'],
                    features: {
                        supportsRadSec: true,
                        supportsTacacs: true,
                        supportsIBNS2: true,
                        maxRadiusServers: 64,
                        supportsCriticalAuth: true,
                        supportsDTLS: true
                    }
                },
                'nx-os': {
                    authentication: ['dot1x', 'mab'],
                    authorization: ['vlan', 'acl', 'sgacl'],
                    security: ['port-security', 'dhcp-snooping', 'dai', 'ipsg'],
                    radius: ['coa', 'dead-server-detection', 'server-groups', 'vsa'],
                    advanced: ['critical-auth'],
                    hostModes: ['single-host', 'multi-host', 'multi-auth'],
                    eapMethods: ['peap', 'eap-tls', 'eap-fast'],
                    features: {
                        supportsRadSec: false,
                        supportsTacacs: true,
                        supportsIBNS2: false,
                        maxRadiusServers: 16,
                        supportsCriticalAuth: true
                    }
                },
                'wlc-9800': {
                    authentication: ['dot1x', 'webauth', 'psk'],
                    authorization: ['vlan', 'acl', 'qos', 'url-redirect'],
                    security: ['wpa2', 'wpa3', 'pmf', 'ft'],
                    radius: ['coa', 'accounting', 'server-groups', 'vsa', 'radsec'],
                    advanced: ['flexconnect', 'local-auth', 'identity-psk'],
                    hostModes: ['single-ssid', 'multi-ssid'],
                    eapMethods: ['peap', 'eap-tls', 'eap-fast', 'eap-teap'],
                    features: {
                        supportsRadSec: true,
                        supportsTacacs: true,
                        supportsIBNS2: false,
                        maxRadiusServers: 32,
                        supportsCriticalAuth: true,
                        supportsFlexConnect: true
                    }
                }
            },
            aruba: {
                'aos-cx': {
                    authentication: ['dot1x', 'mab', 'webauth'],
                    authorization: ['vlan', 'acl', 'user-role', 'downloadable-acl'],
                    security: ['port-security', 'dhcp-snooping', 'arp-protect', 'ipsg'],
                    radius: ['coa', 'server-tracking', 'server-groups', 'vsa'],
                    advanced: ['device-fingerprinting', 'critical-auth', 'cached-reauth'],
                    hostModes: ['single-auth', 'multi-auth', 'multi-domain'],
                    eapMethods: ['peap', 'eap-tls', 'eap-ttls'],
                    features: {
                        supportsRadSec: false,
                        supportsTacacs: true,
                        supportsUserRoles: true,
                        maxRadiusServers: 8,
                        supportsCriticalAuth: true
                    }
                },
                'arubaos': {
                    authentication: ['dot1x', 'webauth', 'psk', 'mac-auth'],
                    authorization: ['vlan', 'acl', 'user-role', 'bandwidth'],
                    security: ['wpa2', 'wpa3', 'pmf', 'ft', 'arp-protect'],
                    radius: ['coa', 'accounting', 'server-groups', 'vsa', 'cppm-integration'],
                    advanced: ['airgroup', 'arm', 'ids/ips', 'rf-protect'],
                    hostModes: ['per-user', 'per-device'],
                    eapMethods: ['peap', 'eap-tls', 'eap-ttls', 'eap-fast'],
                    features: {
                        supportsRadSec: false,
                        supportsTacacs: true,
                        supportsUserRoles: true,
                        maxRadiusServers: 16,
                        supportsClearPass: true,
                        supportsARM: true
                    }
                }
            },
            juniper: {
                'junos': {
                    authentication: ['dot1x', 'mab'],
                    authorization: ['vlan', 'filter', 'user-profile'],
                    security: ['dhcp-snooping', 'dai', 'ip-source-guard', 'storm-control'],
                    radius: ['coa', 'accounting', 'server-failover', 'vsa'],
                    advanced: ['mac-limit', 'guest-vlan', 'server-reject-vlan'],
                    hostModes: ['single', 'single-secure', 'multiple', 'multiple-supplicants'],
                    eapMethods: ['peap', 'eap-tls', 'eap-ttls', 'eap-md5'],
                    features: {
                        supportsRadSec: false,
                        supportsTacacs: true,
                        supportsUserProfiles: true,
                        maxRadiusServers: 8,
                        supportsCaptivePortal: true
                    }
                }
            }
        };
    }
    
    setupEventListeners() {
        // Listen for vendor selection
        document.addEventListener('vendorSelected', (e) => {
            this.handleVendorChange(e.detail);
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
        
        // Step 1: Basic 802.1X Settings
        steps.push({
            id: 'basic-settings',
            title: 'Basic 802.1X Settings',
            render: () => this.renderBasicSettings(capabilities)
        });
        
        // Step 2: RADIUS Configuration
        steps.push({
            id: 'radius-config',
            title: 'RADIUS Configuration',
            render: () => this.renderRadiusConfig(capabilities)
        });
        
        // Step 3: Authentication Methods
        steps.push({
            id: 'auth-methods',
            title: 'Authentication Methods',
            render: () => this.renderAuthMethods(capabilities)
        });
        
        // Step 4: Authorization & VLANs
        steps.push({
            id: 'authorization',
            title: 'Authorization & VLANs',
            render: () => this.renderAuthorization(capabilities)
        });
        
        // Step 5: Security Features
        steps.push({
            id: 'security',
            title: 'Security Features',
            render: () => this.renderSecurity(capabilities)
        });
        
        // Step 6: Advanced Options
        steps.push({
            id: 'advanced',
            title: 'Advanced Options',
            render: () => this.renderAdvanced(capabilities)
        });
        
        // Step 7: TACACS+ (if supported)
        if (capabilities.features.supportsTacacs) {
            steps.push({
                id: 'tacacs',
                title: 'TACACS+ Configuration',
                render: () => this.renderTacacs(capabilities)
            });
        }
        
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
                    <small class="help-text">Enter interface or range (e.g., ${this.getInterfaceExample()})</small>
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
                        <label class="radio">
                            <input type="radio" name="auth-mode" value="closed" checked>
                            Closed Mode (Recommended)
                        </label>
                        <label class="radio">
                            <input type="radio" name="auth-mode" value="open">
                            Open Mode
                        </label>
                        ${capabilities.advanced.includes('monitor-mode') ? `
                        <label class="radio">
                            <input type="radio" name="auth-mode" value="monitor">
                            Monitor Mode (Deployment Phase)
                        </label>
                        ` : ''}
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Control Direction</label>
                    <select id="control-direction" class="form-control">
                        <option value="both">Both (Default)</option>
                        <option value="in">Inbound Only</option>
                    </select>
                </div>
            </div>
        `;
    }
    
    renderRadiusConfig(capabilities) {
        const maxServers = capabilities.features.maxRadiusServers;
        const supportsRadSec = capabilities.features.supportsRadSec;
        const supportsGroups = capabilities.radius.includes('server-groups');
        const supportsLoadBalance = capabilities.radius.includes('load-balance');
        
        return `
            <div class="wizard-step-content">
                <h3>RADIUS Server Configuration</h3>
                
                ${supportsGroups ? `
                <div class="form-group">
                    <label>RADIUS Server Group Name</label>
                    <input type="text" id="radius-group-name" class="form-control" 
                           value="ISE-GROUP" />
                </div>
                ` : ''}
                
                <div class="radius-servers">
                    <h4>Primary RADIUS Server</h4>
                    <div class="form-group">
                        <label>Server IP/Hostname</label>
                        <input type="text" id="radius-primary-ip" class="form-control" required />
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-6">
                            <label>Auth Port</label>
                            <input type="number" id="radius-primary-auth-port" 
                                   class="form-control" value="1812" />
                        </div>
                        <div class="form-group col-6">
                            <label>Acct Port</label>
                            <input type="number" id="radius-primary-acct-port" 
                                   class="form-control" value="1813" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Shared Secret</label>
                        <input type="password" id="radius-primary-secret" class="form-control" required />
                    </div>
                    
                    <h4>Secondary RADIUS Server (Optional)</h4>
                    <div class="form-group">
                        <label>Server IP/Hostname</label>
                        <input type="text" id="radius-secondary-ip" class="form-control" />
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group col-6">
                            <label>Auth Port</label>
                            <input type="number" id="radius-secondary-auth-port" 
                                   class="form-control" value="1812" />
                        </div>
                        <div class="form-group col-6">
                            <label>Acct Port</label>
                            <input type="number" id="radius-secondary-acct-port" 
                                   class="form-control" value="1813" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Shared Secret</label>
                        <input type="password" id="radius-secondary-secret" class="form-control" />
                    </div>
                </div>
                
                <div class="radius-options">
                    <h4>RADIUS Options</h4>
                    
                    <div class="form-row">
                        <div class="form-group col-4">
                            <label>Timeout (seconds)</label>
                            <input type="number" id="radius-timeout" class="form-control" value="5" />
                        </div>
                        <div class="form-group col-4">
                            <label>Retries</label>
                            <input type="number" id="radius-retries" class="form-control" value="3" />
                        </div>
                        <div class="form-group col-4">
                            <label>Dead Time (seconds)</label>
                            <input type="number" id="radius-deadtime" class="form-control" value="15" />
                        </div>
                    </div>
                    
                    ${supportsLoadBalance ? `
                    <div class="form-group">
                        <label>Load Balancing Method</label>
                        <select id="radius-load-balance" class="form-control">
                            <option value="">Disabled</option>
                            <option value="round-robin">Round Robin</option>
                            <option value="least-outstanding">Least Outstanding</option>
                        </select>
                    </div>
                    ` : ''}
                    
                    ${supportsRadSec ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-radsec">
                            Enable RadSec (RADIUS over TLS)
                        </label>
                    </div>
                    
                    <div id="radsec-options" style="display: none;">
                        <div class="form-group">
                            <label>RadSec Port</label>
                            <input type="number" id="radsec-port" class="form-control" value="2083" />
                        </div>
                        <div class="form-group">
                            <label>Trust Point Name</label>
                            <input type="text" id="radsec-trustpoint" class="form-control" 
                                   value="RADSEC-TP" />
                        </div>
                    </div>
                    ` : ''}
                    
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-coa" checked>
                            Enable Change of Authorization (CoA)
                        </label>
                    </div>
                    
                    <div id="coa-options">
                        <div class="form-group">
                            <label>CoA Port</label>
                            <input type="number" id="coa-port" class="form-control" value="1700" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-accounting" checked>
                            Enable RADIUS Accounting
                        </label>
                    </div>
                    
                    <div id="accounting-options">
                        <div class="form-group">
                            <label>Accounting Update Interval (minutes)</label>
                            <input type="number" id="accounting-interval" class="form-control" value="60" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-dead-server-detection" checked>
                            Enable Dead Server Detection
                        </label>
                    </div>
                    
                    ${this.renderVendorSpecificRadiusOptions(capabilities)}
                </div>
            </div>
        `;
    }
    
    renderAuthMethods(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Authentication Methods</h3>
                
                <div class="form-group">
                    <label>Authentication Order</label>
                    <select id="auth-order" class="form-control" multiple>
                        ${capabilities.authentication.map(method => `
                            <option value="${method}" selected>${this.formatAuthMethod(method)}</option>
                        `).join('')}
                    </select>
                    <small class="help-text">Order matters - drag to reorder</small>
                </div>
                
                <div class="form-group">
                    <label>Authentication Priority</label>
                    <select id="auth-priority" class="form-control" multiple>
                        ${capabilities.authentication.map(method => `
                            <option value="${method}" selected>${this.formatAuthMethod(method)}</option>
                        `).join('')}
                    </select>
                </div>
                
                <div class="auth-method-settings">
                    <h4>802.1X Settings</h4>
                    <div class="form-row">
                        <div class="form-group col-4">
                            <label>Reauth Period (seconds)</label>
                            <input type="number" id="dot1x-reauth-period" class="form-control" value="3600" />
                        </div>
                        <div class="form-group col-4">
                            <label>TX Period (seconds)</label>
                            <input type="number" id="dot1x-tx-period" class="form-control" value="30" />
                        </div>
                        <div class="form-group col-4">
                            <label>Quiet Period (seconds)</label>
                            <input type="number" id="dot1x-quiet-period" class="form-control" value="60" />
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>EAP Methods</label>
                        <select id="eap-methods" class="form-control" multiple>
                            ${capabilities.eapMethods.map(method => `
                                <option value="${method}">${method.toUpperCase()}</option>
                            `).join('')}
                        </select>
                    </div>
                    
                    ${capabilities.authentication.includes('mab') ? `
                    <h4>MAC Authentication Bypass (MAB)</h4>
                    <div class="form-group">
                        <label>MAC Address Format</label>
                        <select id="mab-format" class="form-control">
                            <option value="cisco">Cisco (1111.2222.3333)</option>
                            <option value="ietf-upper">IETF Upper (11-22-33-44-55-66)</option>
                            <option value="ietf-lower">IETF Lower (11-22-33-44-55-66)</option>
                            <option value="no-delimiter">No Delimiter (112233445566)</option>
                        </select>
                    </div>
                    ` : ''}
                    
                    ${capabilities.authentication.includes('webauth') ? `
                    <h4>Web Authentication</h4>
                    <div class="form-group">
                        <label>Redirect URL</label>
                        <input type="url" id="webauth-redirect-url" class="form-control" 
                               placeholder="https://ise.company.com/portal/" />
                    </div>
                    <div class="form-group">
                        <label>Session Timeout (seconds)</label>
                        <input type="number" id="webauth-session-timeout" class="form-control" value="1800" />
                    </div>
                    ` : ''}
                </div>
            </div>
        `;
    }
    
    renderAuthorization(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Authorization & VLAN Configuration</h3>
                
                <div class="vlan-config">
                    <h4>VLAN Assignments</h4>
                    <div class="form-group">
                        <label>Authenticated VLAN</label>
                        <input type="number" id="vlan-auth" class="form-control" placeholder="100" />
                    </div>
                    
                    <div class="form-group">
                        <label>Guest VLAN</label>
                        <input type="number" id="vlan-guest" class="form-control" placeholder="900" />
                    </div>
                    
                    <div class="form-group">
                        <label>Restricted/Auth-Fail VLAN</label>
                        <input type="number" id="vlan-restricted" class="form-control" placeholder="999" />
                    </div>
                    
                    ${capabilities.hostModes.includes('multi-domain') ? `
                    <div class="form-group">
                        <label>Voice VLAN</label>
                        <input type="number" id="vlan-voice" class="form-control" placeholder="200" />
                    </div>
                    ` : ''}
                    
                    ${capabilities.advanced.includes('critical-auth') ? `
                    <div class="form-group">
                        <label>Critical VLAN</label>
                        <input type="number" id="vlan-critical" class="form-control" placeholder="111" />
                    </div>
                    ` : ''}
                </div>
                
                ${capabilities.authorization.includes('acl') ? `
                <div class="acl-config">
                    <h4>Access Control Lists</h4>
                    <div class="form-group">
                        <label>Pre-Auth ACL Name</label>
                        <input type="text" id="acl-preauth" class="form-control" placeholder="PREAUTH-ACL" />
                    </div>
                    
                    ${capabilities.authorization.includes('downloadable-acl') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-dacl" checked>
                            Enable Downloadable ACLs (dACLs)
                        </label>
                    </div>
                    ` : ''}
                </div>
                ` : ''}
                
                ${capabilities.authorization.includes('user-role') ? `
                <div class="user-role-config">
                    <h4>User Roles</h4>
                    <div class="form-group">
                        <label>Default User Role</label>
                        <input type="text" id="default-user-role" class="form-control" 
                               placeholder="authenticated-user" />
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.authorization.includes('sgacl') ? `
                <div class="sgacl-config">
                    <h4>Security Group ACLs (TrustSec)</h4>
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-sgacl">
                            Enable SGACLs
                        </label>
                    </div>
                </div>
                ` : ''}
                
                <div class="form-group">
                    <h4>RADIUS Attributes</h4>
                    <label class="checkbox">
                        <input type="checkbox" id="enable-vsa" checked>
                        Enable Vendor Specific Attributes (VSA)
                    </label>
                </div>
                
                ${this.renderVendorSpecificAuthOptions(capabilities)}
            </div>
        `;
    }
    
    renderSecurity(capabilities) {
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
                        <input type="text" id="dhcp-snooping-vlans" class="form-control" 
                               placeholder="VLAN list (e.g., 1-100,200)" />
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.security.includes('dai') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-dai">
                        Enable Dynamic ARP Inspection (DAI)
                    </label>
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
                        <div class="form-group">
                            <label>Maximum MAC Addresses</label>
                            <input type="number" id="port-security-max-mac" class="form-control" value="1" />
                        </div>
                        <div class="form-group">
                            <label>Violation Action</label>
                            <select id="port-security-violation" class="form-control">
                                <option value="shutdown">Shutdown</option>
                                <option value="restrict">Restrict</option>
                                <option value="protect">Protect</option>
                            </select>
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
                </div>
                ` : ''}
                
                ${capabilities.security.includes('storm-control') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-storm-control">
                        Enable Storm Control
                    </label>
                    <div id="storm-control-options" style="display: none;">
                        <div class="form-group">
                            <label>Broadcast Level (%)</label>
                            <input type="number" id="storm-broadcast-level" class="form-control" value="20" />
                        </div>
                        <div class="form-group">
                            <label>Multicast Level (%)</label>
                            <input type="number" id="storm-multicast-level" class="form-control" value="30" />
                        </div>
                    </div>
                </div>
                ` : ''}
                
                ${capabilities.advanced.includes('macsec') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-macsec">
                        Enable MACsec (802.1AE)
                    </label>
                    <div id="macsec-options" style="display: none;">
                        <div class="form-group">
                            <label>MACsec Cipher Suite</label>
                            <select id="macsec-cipher" class="form-control">
                                <option value="gcm-aes-128">GCM-AES-128</option>
                                <option value="gcm-aes-256">GCM-AES-256</option>
                            </select>
                        </div>
                    </div>
                </div>
                ` : ''}
            </div>
        `;
    }
    
    renderAdvanced(capabilities) {
        return `
            <div class="wizard-step-content">
                <h3>Advanced Options</h3>
                
                ${capabilities.advanced.includes('critical-auth') ? `
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-critical-auth">
                        Enable Critical Authentication (RADIUS Server Dead)
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
                
                ${capabilities.advanced.includes('low-impact') ? `
                <div class="form-group">
                    <label>Deployment Mode</label>
                    <select id="deployment-mode" class="form-control">
                        <option value="closed">Closed Mode (Production)</option>
                        <option value="low-impact">Low Impact Mode</option>
                        <option value="monitor">Monitor Mode</option>
                    </select>
                </div>
                ` : ''}
                
                <div class="form-group">
                    <label>Re-authentication</label>
                    <div class="form-row">
                        <div class="col-6">
                            <label class="checkbox">
                                <input type="checkbox" id="enable-reauth" checked>
                                Enable Periodic Re-authentication
                            </label>
                        </div>
                        <div class="col-6">
                            <input type="number" id="reauth-period" class="form-control" 
                                   placeholder="3600" value="3600" />
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Server Failure Action</label>
                    <select id="server-fail-action" class="form-control">
                        <option value="unauthorized">Unauthorized</option>
                        <option value="authorize-vlan">Authorize VLAN</option>
                        <option value="authorize-voice">Authorize Voice</option>
                        <option value="next-method">Next Method</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>No Response Action</label>
                    <select id="no-response-action" class="form-control">
                        <option value="unauthorized">Unauthorized</option>
                        <option value="authorize-vlan">Authorize VLAN</option>
                        <option value="next-method">Next Method</option>
                    </select>
                </div>
                
                ${this.renderVendorSpecificAdvancedOptions(capabilities)}
            </div>
        `;
    }
    
    renderTacacs(capabilities) {
        if (!capabilities.features.supportsTacacs) return '';
        
        return `
            <div class="wizard-step-content">
                <h3>TACACS+ Configuration</h3>
                
                <div class="form-group">
                    <label class="checkbox">
                        <input type="checkbox" id="enable-tacacs">
                        Enable TACACS+ for Device Administration
                    </label>
                </div>
                
                <div id="tacacs-options" style="display: none;">
                    <div class="form-group">
                        <label>TACACS+ Server IP</label>
                        <input type="text" id="tacacs-server-ip" class="form-control" />
                    </div>
                    
                    <div class="form-group">
                        <label>TACACS+ Server Key</label>
                        <input type="password" id="tacacs-server-key" class="form-control" />
                    </div>
                    
                    <div class="form-group">
                        <label>TACACS+ Port</label>
                        <input type="number" id="tacacs-port" class="form-control" value="49" />
                    </div>
                    
                    <div class="form-group">
                        <label>TACACS+ Timeout</label>
                        <input type="number" id="tacacs-timeout" class="form-control" value="5" />
                    </div>
                    
                    <div class="form-group">
                        <label>Authorization Level</label>
                        <select id="tacacs-auth-level" class="form-control">
                            <option value="exec">Exec Mode</option>
                            <option value="commands">Command Authorization</option>
                            <option value="both">Both</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="tacacs-accounting">
                            Enable TACACS+ Accounting
                        </label>
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
                    <h4>Selected Configuration Summary</h4>
                    <div id="config-summary">
                        <!-- Dynamic summary will be populated here -->
                    </div>
                </div>
                
                <div class="form-group">
                    <label>Configuration Name</label>
                    <input type="text" id="config-name" class="form-control" 
                           placeholder="My 802.1X Configuration" />
                </div>
                
                <div class="form-group">
                    <label>Description</label>
                    <textarea id="config-description" class="form-control" rows="3"
                              placeholder="Enter a description for this configuration"></textarea>
                </div>
                
                <div class="generation-options">
                    <h4>Generation Options</h4>
                    
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="include-comments" checked>
                            Include Comments in Configuration
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="include-best-practices" checked>
                            Apply Best Practices
                        </label>
                    </div>
                    
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="optimize-config" checked>
                            Optimize Configuration
                        </label>
                    </div>
                    
                    <div class="form-group">
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
    
    // Vendor-specific options rendering methods
    renderVendorSpecificRadiusOptions(capabilities) {
        switch (this.currentVendor) {
            case 'cisco':
                return `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="radius-automate-tester">
                            Enable Automated RADIUS Testing
                        </label>
                    </div>
                    ${capabilities.radius.includes('dtls') ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="enable-dtls">
                            Enable DTLS for RADIUS
                        </label>
                    </div>
                    ` : ''}
                `;
            case 'aruba':
                return `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="radius-server-tracking">
                            Enable Server Tracking
                        </label>
                    </div>
                `;
            default:
                return '';
        }
    }
    
    renderVendorSpecificAuthOptions(capabilities) {
        switch (this.currentVendor) {
            case 'cisco':
                return `
                    <div class="form-group">
                        <label>RADIUS Attribute 31 Format</label>
                        <select id="attr-31-format" class="form-control">
                            <option value="ietf">IETF</option>
                            <option value="cisco">Cisco</option>
                        </select>
                    </div>
                `;
            case 'aruba':
                return capabilities.features.supportsUserRoles ? `
                    <div class="form-group">
                        <label>User Role Mapping</label>
                        <select id="user-role-mapping" class="form-control">
                            <option value="vsa">Vendor Specific Attribute</option>
                            <option value="filter-id">Filter-ID</option>
                        </select>
                    </div>
                ` : '';
            default:
                return '';
        }
    }
    
    renderVendorSpecificAdvancedOptions(capabilities) {
        switch (this.currentVendor) {
            case 'cisco':
                return capabilities.features.supportsIBNS2 ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="use-ibns2">
                            Use IBNS 2.0 Configuration Model
                        </label>
                    </div>
                ` : '';
            case 'aruba':
                return capabilities.features.supportsClearPass ? `
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="clearpass-integration">
                            Enable ClearPass Integration
                        </label>
                    </div>
                ` : '';
            default:
                return '';
        }
    }
    
    // Utility methods
    getInterfacePlaceholder() {
        switch (this.currentVendor) {
            case 'cisco':
                return 'GigabitEthernet1/0/1';
            case 'aruba':
                return '1/1/1';
            case 'juniper':
                return 'ge-0/0/1';
            default:
                return 'interface';
        }
    }
    
    getInterfaceExample() {
        switch (this.currentVendor) {
            case 'cisco':
                return 'Gi1/0/1-24, Te1/1/1';
            case 'aruba':
                return '1/1/1-24, 2/1/1';
            case 'juniper':
                return 'ge-0/0/1-24';
            default:
                return 'interface range';
        }
    }
    
    formatHostMode(mode) {
        const modeMap = {
            'single-host': 'Single Host',
            'multi-host': 'Multi Host',
            'multi-domain': 'Multi Domain',
            'multi-auth': 'Multi Auth',
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
            'mac-auth': 'MAC Authentication'
        };
        return methodMap[method] || method;
    }
    
    getHostModeHelp() {
        switch (this.currentVendor) {
            case 'cisco':
                return 'Multi-Auth recommended for most deployments';
            case 'aruba':
                return 'Multi-Auth provides per-device authentication';
            case 'juniper':
                return 'Multiple mode supports multiple devices per port';
            default:
                return 'Select appropriate host mode for your deployment';
        }
    }
    
    collectConfiguration() {
        // Collect all configuration values
        const config = {
            // Basic settings
            interface: document.getElementById('interface-range')?.value,
            hostMode: document.getElementById('host-mode')?.value,
            authMode: document.querySelector('input[name="auth-mode"]:checked')?.value,
            controlDirection: document.getElementById('control-direction')?.value,
            
            // RADIUS settings
            radiusGroupName: document.getElementById('radius-group-name')?.value,
            primaryRadiusServer: document.getElementById('radius-primary-ip')?.value,
            primaryRadiusAuthPort: document.getElementById('radius-primary-auth-port')?.value,
            primaryRadiusAcctPort: document.getElementById('radius-primary-acct-port')?.value,
            primaryRadiusSecret: document.getElementById('radius-primary-secret')?.value,
            secondaryRadiusServer: document.getElementById('radius-secondary-ip')?.value,
            secondaryRadiusAuthPort: document.getElementById('radius-secondary-auth-port')?.value,
            secondaryRadiusAcctPort: document.getElementById('radius-secondary-acct-port')?.value,
            secondaryRadiusSecret: document.getElementById('radius-secondary-secret')?.value,
            radiusTimeout: document.getElementById('radius-timeout')?.value,
            radiusRetries: document.getElementById('radius-retries')?.value,
            radiusDeadtime: document.getElementById('radius-deadtime')?.value,
            radiusLoadBalance: document.getElementById('radius-load-balance')?.value,
            enableRadSec: document.getElementById('enable-radsec')?.checked,
            radSecPort: document.getElementById('radsec-port')?.value,
            radSecTrustPoint: document.getElementById('radsec-trustpoint')?.value,
            enableCoA: document.getElementById('enable-coa')?.checked,
            coaPort: document.getElementById('coa-port')?.value,
            enableAccounting: document.getElementById('enable-accounting')?.checked,
            accountingInterval: document.getElementById('accounting-interval')?.value,
            enableDeadServerDetection: document.getElementById('enable-dead-server-detection')?.checked,
            
            // Authentication methods
            authOrder: Array.from(document.getElementById('auth-order')?.selectedOptions || []).map(opt => opt.value),
            authPriority: Array.from(document.getElementById('auth-priority')?.selectedOptions || []).map(opt => opt.value),
            reauthPeriod: document.getElementById('dot1x-reauth-period')?.value,
            txPeriod: document.getElementById('dot1x-tx-period')?.value,
            quietPeriod: document.getElementById('dot1x-quiet-period')?.value,
            eapMethods: Array.from(document.getElementById('eap-methods')?.selectedOptions || []).map(opt => opt.value),
            mabFormat: document.getElementById('mab-format')?.value,
            webauthRedirectUrl: document.getElementById('webauth-redirect-url')?.value,
            webauthSessionTimeout: document.getElementById('webauth-session-timeout')?.value,
            
            // Authorization
            vlanAuth: document.getElementById('vlan-auth')?.value,
            vlanGuest: document.getElementById('vlan-guest')?.value,
            vlanRestricted: document.getElementById('vlan-restricted')?.value,
            vlanVoice: document.getElementById('vlan-voice')?.value,
            vlanCritical: document.getElementById('vlan-critical')?.value,
            aclPreauth: document.getElementById('acl-preauth')?.value,
            enableDacl: document.getElementById('enable-dacl')?.checked,
            defaultUserRole: document.getElementById('default-user-role')?.value,
            enableSgacl: document.getElementById('enable-sgacl')?.checked,
            enableVsa: document.getElementById('enable-vsa')?.checked,
            
            // Security features
            enableDhcpSnooping: document.getElementById('enable-dhcp-snooping')?.checked,
            dhcpSnoopingVlans: document.getElementById('dhcp-snooping-vlans')?.value,
            enableDai: document.getElementById('enable-dai')?.checked,
            enableIpsg: document.getElementById('enable-ipsg')?.checked,
            enablePortSecurity: document.getElementById('enable-port-security')?.checked,
            portSecurityMaxMac: document.getElementById('port-security-max-mac')?.value,
            portSecurityViolation: document.getElementById('port-security-violation')?.value,
            enableDeviceTracking: document.getElementById('enable-device-tracking')?.checked,
            enableStormControl: document.getElementById('enable-storm-control')?.checked,
            stormBroadcastLevel: document.getElementById('storm-broadcast-level')?.value,
            stormMulticastLevel: document.getElementById('storm-multicast-level')?.value,
            enableMacsec: document.getElementById('enable-macsec')?.checked,
            macsecCipher: document.getElementById('macsec-cipher')?.value,
            
            // Advanced options
            enableCriticalAuth: document.getElementById('enable-critical-auth')?.checked,
            criticalVlan: document.getElementById('critical-vlan')?.value,
            criticalRecovery: document.getElementById('critical-recovery')?.value,
            deploymentMode: document.getElementById('deployment-mode')?.value,
            enableReauth: document.getElementById('enable-reauth')?.checked,
            serverFailAction: document.getElementById('server-fail-action')?.value,
            noResponseAction: document.getElementById('no-response-action')?.value,
            
            // TACACS+ settings
            enableTacacs: document.getElementById('enable-tacacs')?.checked,
            tacacsServerIp: document.getElementById('tacacs-server-ip')?.value,
            tacacsServerKey: document.getElementById('tacacs-server-key')?.value,
            tacacsPort: document.getElementById('tacacs-port')?.value,
            tacacsTimeout: document.getElementById('tacacs-timeout')?.value,
            tacacsAuthLevel: document.getElementById('tacacs-auth-level')?.value,
            tacacsAccounting: document.getElementById('tacacs-accounting')?.checked,
            
            // Generation options
            configName: document.getElementById('config-name')?.value,
            configDescription: document.getElementById('config-description')?.value,
            includeComments: document.getElementById('include-comments')?.checked,
            includeBestPractices: document.getElementById('include-best-practices')?.checked,
            optimizeConfig: document.getElementById('optimize-config')?.checked,
            includeTroubleshooting: document.getElementById('include-troubleshooting')?.checked,
            
            // Vendor-specific options
            vendor: this.currentVendor,
            platform: this.currentPlatform,
            useIBNS2: document.getElementById('use-ibns2')?.checked,
            clearpassIntegration: document.getElementById('clearpass-integration')?.checked,
            radiusAutomateTester: document.getElementById('radius-automate-tester')?.checked,
            enableDTLS: document.getElementById('enable-dtls')?.checked,
            radiusServerTracking: document.getElementById('radius-server-tracking')?.checked,
            attr31Format: document.getElementById('attr-31-format')?.value,
            userRoleMapping: document.getElementById('user-role-mapping')?.value
        };
        
        return config;
    }
    
    generateConfiguration() {
        const config = this.collectConfiguration();
        
        // Call the existing config generator with our collected settings
        if (window.generateConfigurationFromWizard) {
            window.generateConfigurationFromWizard(config);
        }
        
        // Show success message
        showAlert('Configuration generated successfully!', 'success');
        
        // Switch to preview tab
        const previewTab = document.querySelector('.tab[data-tab="preview"]');
        if (previewTab) {
            previewTab.click();
        }
    }
    
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
                    <h2>802.1X Configuration Wizard - ${this.currentVendor} ${this.currentPlatform}</h2>
                    <div class="wizard-progress">
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${((this.currentStep + 1) / this.wizardSteps.length) * 100}%"></div>
                        </div>
                        <div class="progress-text">Step ${this.currentStep + 1} of ${this.wizardSteps.length}</div>
                    </div>
                </div>
                
                <div class="wizard-body">
                    ${currentStep.render()}
                </div>
                
                <div class="wizard-footer">
                    <div class="wizard-navigation">
                        ${this.currentStep > 0 ? '<button type="button" class="btn wizard-prev">Previous</button>' : ''}
                        ${this.currentStep < this.wizardSteps.length - 1 ? 
                            '<button type="button" class="btn primary wizard-next">Next</button>' :
                            '<button type="button" class="btn primary wizard-generate">Generate Configuration</button>'}
                    </div>
                </div>
            </div>
        `;
        
        wizardContainer.innerHTML = html;
        
        // Set up dynamic field interactions
        this.setupFieldInteractions();
    }
    
    setupFieldInteractions() {
        // RadSec toggle
        const radsecCheckbox = document.getElementById('enable-radsec');
        if (radsecCheckbox) {
            radsecCheckbox.addEventListener('change', (e) => {
                document.getElementById('radsec-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // CoA toggle
        const coaCheckbox = document.getElementById('enable-coa');
        if (coaCheckbox) {
            coaCheckbox.addEventListener('change', (e) => {
                document.getElementById('coa-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // Accounting toggle
        const accountingCheckbox = document.getElementById('enable-accounting');
        if (accountingCheckbox) {
            accountingCheckbox.addEventListener('change', (e) => {
                document.getElementById('accounting-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // DHCP snooping toggle
        const dhcpSnoopingCheckbox = document.getElementById('enable-dhcp-snooping');
        if (dhcpSnoopingCheckbox) {
            dhcpSnoopingCheckbox.addEventListener('change', (e) => {
                document.getElementById('dhcp-snooping-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // Port security toggle
        const portSecurityCheckbox = document.getElementById('enable-port-security');
        if (portSecurityCheckbox) {
            portSecurityCheckbox.addEventListener('change', (e) => {
                document.getElementById('port-security-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // Storm control toggle
        const stormControlCheckbox = document.getElementById('enable-storm-control');
        if (stormControlCheckbox) {
            stormControlCheckbox.addEventListener('change', (e) => {
                document.getElementById('storm-control-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // MACsec toggle
        const macsecCheckbox = document.getElementById('enable-macsec');
        if (macsecCheckbox) {
            macsecCheckbox.addEventListener('change', (e) => {
                document.getElementById('macsec-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // Critical auth toggle
        const criticalAuthCheckbox = document.getElementById('enable-critical-auth');
        if (criticalAuthCheckbox) {
            criticalAuthCheckbox.addEventListener('change', (e) => {
                document.getElementById('critical-auth-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // TACACS+ toggle
        const tacacsCheckbox = document.getElementById('enable-tacacs');
        if (tacacsCheckbox) {
            tacacsCheckbox.addEventListener('change', (e) => {
                document.getElementById('tacacs-options').style.display = e.target.checked ? 'block' : 'none';
            });
        }
        
        // Update summary on review page
        if (this.currentStep === this.wizardSteps.length - 1) {
            this.updateConfigSummary();
        }
    }
    
    updateConfigSummary() {
        const summaryContainer = document.getElementById('config-summary');
        if (!summaryContainer) return;
        
        const config = this.collectConfiguration();
        
        let summary = '<ul>';
        
        // Basic settings
        summary += `<li><strong>Interface:</strong> ${config.interface || 'Not specified'}</li>`;
        summary += `<li><strong>Host Mode:</strong> ${this.formatHostMode(config.hostMode)}</li>`;
        summary += `<li><strong>Authentication Mode:</strong> ${config.authMode}</li>`;
        
        // RADIUS settings
        summary += `<li><strong>Primary RADIUS:</strong> ${config.primaryRadiusServer || 'Not specified'}</li>`;
        if (config.secondaryRadiusServer) {
            summary += `<li><strong>Secondary RADIUS:</strong> ${config.secondaryRadiusServer}</li>`;
        }
        
        // Features
        const features = [];
        if (config.enableRadSec) features.push('RadSec');
        if (config.enableCoA) features.push('CoA');
        if (config.enableAccounting) features.push('Accounting');
        if (config.enableMacsec) features.push('MACsec');
        if (config.enableCriticalAuth) features.push('Critical Auth');
        if (config.enableTacacs) features.push('TACACS+');
        
        if (features.length > 0) {
            summary += `<li><strong>Enabled Features:</strong> ${features.join(', ')}</li>`;
        }
        
        // Security features
        const security = [];
        if (config.enableDhcpSnooping) security.push('DHCP Snooping');
        if (config.enableDai) security.push('DAI');
        if (config.enableIpsg) security.push('IP Source Guard');
        if (config.enablePortSecurity) security.push('Port Security');
        if (config.enableDeviceTracking) security.push('Device Tracking');
        
        if (security.length > 0) {
            summary += `<li><strong>Security Features:</strong> ${security.join(', ')}</li>`;
        }
        
        summary += '</ul>';
        
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
        toggleButton.textContent = 'Enable Configuration Wizard';
        toggleButton.addEventListener('click', () => {
            const isVisible = wizardContainer.style.display !== 'none';
            wizardContainer.style.display = isVisible ? 'none' : 'block';
            toggleButton.textContent = isVisible ? 'Enable Configuration Wizard' : 'Disable Configuration Wizard';
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

// Global function to generate configuration from wizard data
window.generateConfigurationFromWizard = function(config) {
    // Call the existing config generator with mapped parameters
    const settings = {
        vendor: config.vendor,
        platform: config.platform,
        
        // Map authentication settings
        authMethod: config.authOrder[0] || 'dot1x',
        authMode: config.authMode || 'closed',
        hostMode: config.hostMode || 'multi-auth',
        
        // Map RADIUS settings
        radiusServer: config.primaryRadiusServer,
        radiusKey: config.primaryRadiusSecret,
        radiusAuthPort: config.primaryRadiusAuthPort || '1812',
        radiusAcctPort: config.primaryRadiusAcctPort || '1813',
        radiusTimeout: config.radiusTimeout || '5',
        radiusRetransmit: config.radiusRetries || '3',
        radiusDeadtime: config.radiusDeadtime || '15',
        
        // Secondary RADIUS
        secondaryServer: config.secondaryRadiusServer,
        secondaryKey: config.secondaryRadiusSecret,
        secondaryAuthPort: config.secondaryRadiusAuthPort || '1812',
        secondaryAcctPort: config.secondaryRadiusAcctPort || '1813',
        
        // Features
        enableAccounting: config.enableAccounting,
        accountingUpdate: config.accountingInterval || '60',
        useCoa: config.enableCoA,
        coaPort: config.coaPort || '1700',
        useRadsec: config.enableRadSec,
        radsecPort: config.radSecPort || '2083',
        
        // VLANs
        vlanAuth: config.vlanAuth,
        vlanUnauth: config.vlanRestricted,
        vlanGuest: config.vlanGuest,
        vlanVoice: config.vlanVoice,
        vlanCritical: config.vlanCritical,
        
        // Interface
        interface: config.interface,
        
        // Security features
        enableDhcpSnooping: config.enableDhcpSnooping,
        enableDai: config.enableDai,
        enableIpsg: config.enableIpsg,
        enablePortSecurity: config.enablePortSecurity,
        portSecurityMaxMac: config.portSecurityMaxMac,
        portSecurityViolation: config.portSecurityViolation,
        enableDeviceTracking: config.enableDeviceTracking,
        useMacsec: config.enableMacsec,
        
        // Additional timing
        reauthPeriod: config.reauthPeriod || '3600',
        txPeriod: config.txPeriod || '30',
        quietPeriod: config.quietPeriod || '60'
    };
    
    // Generate configuration using existing generator
    if (window.generateVendorConfig) {
        const configText = window.generateVendorConfig(config.vendor, config.platform, settings);
        
        // Display in output
        const configOutput = document.getElementById('config-output');
        if (configOutput) {
            configOutput.textContent = configText;
        }
        
        return configText;
    }
};
