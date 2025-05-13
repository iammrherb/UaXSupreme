/**
 * UaXSupreme - Documentation Generator
 * Generates deployment documentation for authentication implementations
 */

(function() {
    'use strict';

    // Documentation Generator object
    const DocumentationGenerator = {
        /**
         * Initialize Documentation Generator
         */
        init: function() {
            console.log('Initializing Documentation Generator...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Generate documentation button
            const generateDocBtn = document.getElementById('generateDocBtn');
            if (generateDocBtn) {
                generateDocBtn.addEventListener('click', this.generateDocumentation.bind(this));
            }
            
            // Download documentation button
            const downloadDocBtn = document.getElementById('downloadDocBtn');
            if (downloadDocBtn) {
                downloadDocBtn.addEventListener('click', this.downloadDocumentation.bind(this));
            }
            
            // Generate checklist button
            const generateChecklistBtn = document.getElementById('generateChecklistBtn');
            if (generateChecklistBtn) {
                generateChecklistBtn.addEventListener('click', this.generateChecklist.bind(this));
            }
            
            // Download checklist button
            const downloadChecklistBtn = document.getElementById('downloadChecklistBtn');
            if (downloadChecklistBtn) {
                downloadChecklistBtn.addEventListener('click', this.downloadChecklist.bind(this));
            }
            
            // Generate troubleshooting guide button
            const generateTroubleshootingBtn = document.getElementById('generateTroubleshootingBtn');
            if (generateTroubleshootingBtn) {
                generateTroubleshootingBtn.addEventListener('click', this.generateTroubleshootingGuide.bind(this));
            }
            
            // Download troubleshooting guide button
            const downloadTroubleshootingBtn = document.getElementById('downloadTroubleshootingBtn');
            if (downloadTroubleshootingBtn) {
                downloadTroubleshootingBtn.addEventListener('click', this.downloadTroubleshootingGuide.bind(this));
            }
        },
        
        /**
         * Generate documentation
         */
        generateDocumentation: function() {
            const configOutput = document.getElementById('configOutput');
            const documentationPreview = document.getElementById('documentationPreview');
            
            if (!configOutput || !configOutput.value.trim() || !documentationPreview) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get the configuration
            const config = configOutput.value;
            
            // Get documentation options
            const docFormat = document.getElementById('docFormat').value;
            const includeConfig = document.getElementById('includeConfig').checked;
            const includeDeployment = document.getElementById('includeDeployment').checked;
            const includeVerification = document.getElementById('includeVerification').checked;
            
            // Parse configuration parameters
            const params = this.parseConfigParameters(config);
            
            // Generate documentation HTML
            let docHTML = `
                <div class="doc-header">
                    <h1>Network Authentication Implementation Documentation</h1>
                    <p class="doc-meta">Generated on: ${new Date().toLocaleDateString()}</p>
                </div>
                
                <div class="doc-section">
                    <h2>1. Overview</h2>
                    <p>This document provides details for the implementation of network authentication using ${params.authMethods.join(', ')} on ${params.vendor} ${params.platform} platform.</p>
                    
                    <h3>1.1 Authentication Methods</h3>
                    <ul>
            `;
            
            // Add authentication methods details
            params.authMethods.forEach(method => {
                docHTML += `<li><strong>${this.getFullMethodName(method)}</strong>: ${this.getMethodDescription(method)}</li>`;
            });
            
            docHTML += `
                    </ul>
                    
                    <h3>1.2 Implementation Summary</h3>
                    <table class="doc-table">
                        <tr>
                            <th>Item</th>
                            <th>Value</th>
                        </tr>
                        <tr>
                            <td>Network Vendor</td>
                            <td>${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)}</td>
                        </tr>
                        <tr>
                            <td>Platform</td>
                            <td>${params.platform}</td>
                        </tr>
                        <tr>
                            <td>Authentication Methods</td>
                            <td>${params.authMethods.map(m => this.getFullMethodName(m)).join(', ')}</td>
                        </tr>
                        <tr>
                            <td>RADIUS Servers</td>
                            <td>${params.radiusServers.length > 0 ? params.radiusServers.join('<br>') : 'None'}</td>
                        </tr>
                        <tr>
                            <td>Host Mode</td>
                            <td>${params.hostMode || 'Not specified'}</td>
                        </tr>
                        <tr>
                            <td>Deployment Type</td>
                            <td>${params.deploymentType || 'Standard'}</td>
                        </tr>
                    </table>
                </div>
            `;
            
            // Add architecture section
            docHTML += this.generateArchitectureSection(params);
            
            // Add configuration section if requested
            if (includeConfig) {
                docHTML += this.generateConfigurationSection(config, params);
            }
            
            // Add deployment section if requested
            if (includeDeployment) {
                docHTML += this.generateDeploymentSection(params);
            }
            
            // Add verification section if requested
            if (includeVerification) {
                docHTML += this.generateVerificationSection(params);
            }
            
            // Add troubleshooting section
            docHTML += this.generateTroubleshootingSection(params);
            
            // Add appendices
            docHTML += `
                <div class="doc-section">
                    <h2>Appendix A: Reference Documents</h2>
                    <ul>
                        <li><a href="#">${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)} ${params.platform.toUpperCase()} Configuration Guide</a></li>
                        <li><a href="#">IEEE 802.1X Standard</a></li>
                        <li><a href="#">RADIUS Protocol (RFC 2865)</a></li>
                    </ul>
                </div>
            `;
            
            // Apply document format
            if (docFormat === 'formal') {
                documentationPreview.className = 'documentation-preview formal';
            } else if (docFormat === 'technical') {
                documentationPreview.className = 'documentation-preview technical';
            } else {
                documentationPreview.className = 'documentation-preview standard';
            }
            
            // Apply document style
            this.applyDocumentStyle(docFormat);
            
            // Set the documentation HTML
            documentationPreview.innerHTML = docHTML;
        },
        
        /**
         * Generate architecture section
         * @param {Object} params - Configuration parameters
         * @returns {string} Architecture section HTML
         */
        generateArchitectureSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>2. Architecture</h2>
                    
                    <h3>2.1 Logical Architecture</h3>
                    <p>The authentication architecture consists of the following components:</p>
                    <ul>
                        <li><strong>Supplicants</strong>: End-user devices that authenticate to the network</li>
                        <li><strong>Authenticators</strong>: ${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)} ${params.platform} switches that enforce authentication</li>
                        <li><strong>Authentication Servers</strong>: RADIUS servers that validate credentials and return policy attributes</li>
                    </ul>
                    
                    <div class="doc-image-placeholder">
                        [Logical Architecture Diagram]
                    </div>
                    
                    <h3>2.2 Authentication Flow</h3>
                    <p>The authentication process follows these steps:</p>
                    <ol>
                        <li>Client connects to the network port</li>
                        <li>Switch initiates authentication (${params.authMethods.includes('dot1x') ? 'sends EAPOL-Start' : 'checks MAC address'})</li>
                        <li>Client responds with credentials</li>
                        <li>Switch forwards authentication request to RADIUS server</li>
                        <li>RADIUS server validates credentials and returns attributes (VLAN, ACLs, etc.)</li>
                        <li>Switch applies policies and permits access</li>
                    </ol>
                    
                    <div class="doc-image-placeholder">
                        [Authentication Flow Diagram]
                    </div>
                    
                    <h3>2.3 Security Policies</h3>
                    <p>The implementation includes the following security policies:</p>
                    <ul>
                        ${params.authMethods.includes('dot1x') ? '<li>802.1X port-based authentication</li>' : ''}
                        ${params.authMethods.includes('mab') ? '<li>MAC Authentication Bypass for non-802.1X devices</li>' : ''}
                        ${params.authMethods.includes('webauth') ? '<li>Web Authentication for guest access</li>' : ''}
                        ${params.securityFeatures.includes('dhcpSnooping') ? '<li>DHCP Snooping for DHCP security</li>' : ''}
                        ${params.securityFeatures.includes('arpInspection') ? '<li>Dynamic ARP Inspection for ARP spoofing prevention</li>' : ''}
                        ${params.securityFeatures.includes('ipSourceGuard') ? '<li>IP Source Guard for IP spoofing prevention</li>' : ''}
                        <li>VLAN assignment based on authentication results</li>
                        <li>Access control lists for traffic filtering</li>
                    </ul>
                </div>
            `;
        },
        
        /**
         * Generate configuration section
         * @param {string} config - Complete configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Configuration section HTML
         */
        generateConfigurationSection: function(config, params) {
            return `
                <div class="doc-section">
                    <h2>3. Configuration Details</h2>
                    
                    <h3>3.1 Global Authentication Configuration</h3>
                    <p>The following global configuration is applied:</p>
                    <pre class="doc-code">${this.extractGlobalAuthConfig(config)}</pre>
                    
                    <h3>3.2 RADIUS Server Configuration</h3>
                    <p>The following RADIUS servers are configured:</p>
                    <pre class="doc-code">${this.extractRadiusConfig(config)}</pre>
                    
                    ${params.authMethods.includes('dot1x') ? `
                    <h3>3.3 802.1X Configuration</h3>
                    <p>The following 802.1X configuration is applied:</p>
                    <pre class="doc-code">${this.extract801xConfig(config)}</pre>
                    ` : ''}
                    
                    ${params.authMethods.includes('mab') ? `
                    <h3>3.4 MAC Authentication Bypass Configuration</h3>
                    <p>The following MAB configuration is applied:</p>
                    <pre class="doc-code">${this.extractMabConfig(config)}</pre>
                    ` : ''}
                    
                    <h3>3.5 Interface Configuration</h3>
                    <p>The following interface configuration is applied to authentication ports:</p>
                    <pre class="doc-code">${this.extractInterfaceConfig(config)}</pre>
                </div>
            `;
        },
        
        /**
         * Generate deployment section
         * @param {Object} params - Configuration parameters
         * @returns {string} Deployment section HTML
         */
        generateDeploymentSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>4. Deployment Guidelines</h2>
                    
                    <h3>4.1 Pre-Deployment Checklist</h3>
                    <ul>
                        <li>Ensure RADIUS servers are accessible from network devices</li>
                        <li>Verify RADIUS shared secrets match between servers and network devices</li>
                        <li>Confirm network time is synchronized (NTP)</li>
                        <li>Backup existing configuration</li>
                        <li>Schedule maintenance window for implementation</li>
                        <li>Prepare rollback plan</li>
                    </ul>
                    
                    <h3>4.2 Deployment Phases</h3>
                    
                    <h4>Phase 1: Setup and Testing</h4>
                    <ol>
                        <li>Configure RADIUS servers and test authentication</li>
                        <li>Configure global authentication settings on network devices</li>
                        <li>Deploy configuration on test ports</li>
                        <li>Verify authentication works as expected</li>
                    </ol>
                    
                    <h4>Phase 2: Monitor Mode Deployment</h4>
                    <ol>
                        <li>Deploy configuration in monitor mode to production ports</li>
                        <li>Monitor authentication attempts and results</li>
                        <li>Identify and remediate issues</li>
                        <li>Communicate with end users about upcoming enforcement</li>
                    </ol>
                    
                    <h4>Phase 3: Enforcement Mode Deployment</h4>
                    <ol>
                        <li>Convert ports from monitor mode to closed mode</li>
                        <li>Implement in groups (e.g., by department or floor)</li>
                        <li>Monitor help desk tickets and address issues promptly</li>
                        <li>Complete deployment across all network ports</li>
                    </ol>
                    
                    <h3>4.3 Rollback Procedure</h3>
                    <p>If critical issues occur during deployment, follow these steps to roll back:</p>
                    <ol>
                        <li>Identify affected ports or devices</li>
                        <li>Disable authentication on affected ports:
                            <pre class="doc-code">interface range &lt;affected-ports&gt;
no authentication port-control auto
spanning-tree portfast
no shutdown</pre>
                        </li>
                        <li>If global rollback is needed, disable 802.1X globally:
                            <pre class="doc-code">no dot1x system-auth-control</pre>
                        </li>
                        <li>Restore previous configuration if necessary</li>
                    </ol>
                </div>
            `;
        },
        
        /**
         * Generate verification section
         * @param {Object} params - Configuration parameters
         * @returns {string} Verification section HTML
         */
        generateVerificationSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>5. Verification Procedures</h2>
                    
                    <h3>5.1 Authentication Status Verification</h3>
                    <p>Use the following commands to verify authentication status:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Command</th>
                            <th>Purpose</th>
                        </tr>
                        ${params.vendor === 'cisco' ? `
                        <tr>
                            <td><code>show authentication sessions</code></td>
                            <td>Displays all authenticated sessions</td>
                        </tr>
                        <tr>
                            <td><code>show authentication sessions interface &lt;interface&gt;</code></td>
                            <td>Displays authentication details for a specific interface</td>
                        </tr>
                        <tr>
                            <td><code>show dot1x all</code></td>
                            <td>Displays 802.1X status for all interfaces</td>
                        </tr>
                        <tr>
                            <td><code>show dot1x interface &lt;interface&gt; details</code></td>
                            <td>Displays detailed 802.1X information for a specific interface</td>
                        </tr>
                        <tr>
                            <td><code>show mab all</code></td>
                            <td>Displays MAB status for all interfaces</td>
                        </tr>
                        ` : params.vendor === 'aruba' ? `
                        <tr>
                            <td><code>show port-access authenticator</code></td>
                            <td>Displays authentication status for all ports</td>
                        </tr>
                        <tr>
                            <td><code>show port-access authenticator &lt;interface&gt;</code></td>
                            <td>Displays authentication details for a specific interface</td>
                        </tr>
                        <tr>
                            <td><code>show port-access mac-auth</code></td>
                            <td>Displays MAC authentication status</td>
                        </tr>
                        ` : `
                        <tr>
                            <td><code>show authentication status</code></td>
                            <td>Displays authentication status for all ports</td>
                        </tr>
                        <tr>
                            <td><code>show authentication interface &lt;interface&gt;</code></td>
                            <td>Displays authentication details for a specific interface</td>
                        </tr>
                        `}
                    </table>
                    
                    <h3>5.2 RADIUS Server Verification</h3>
                    <p>Use the following commands to verify RADIUS server status:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Command</th>
                            <th>Purpose</th>
                        </tr>
                        ${params.vendor === 'cisco' ? `
                        <tr>
                            <td><code>show radius statistics</code></td>
                            <td>Displays RADIUS server statistics</td>
                        </tr>
                        <tr>
                            <td><code>test aaa group radius &lt;username&gt; &lt;password&gt; new-code</code></td>
                            <td>Tests RADIUS authentication</td>
                        </tr>
                        ` : `
                        <tr>
                            <td><code>show radius statistics</code></td>
                            <td>Displays RADIUS server statistics</td>
                        </tr>
                        <tr>
                            <td><code>test radius authentication</code></td>
                            <td>Tests RADIUS authentication</td>
                        </tr>
                        `}
                    </table>
                    
                    <h3>5.3 Validation Tests</h3>
                    <p>Perform the following tests to validate the implementation:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Test</th>
                            <th>Procedure</th>
                            <th>Expected Result</th>
                        </tr>
                        <tr>
                            <td>802.1X Authentication</td>
                            <td>Connect 802.1X-capable device to port</td>
                            <td>Device authenticates and receives correct VLAN and policy</td>
                        </tr>
                        <tr>
                            <td>MAB Authentication</td>
                            <td>Connect non-802.1X device with authorized MAC to port</td>
                            <td>Device authenticates via MAB and receives correct VLAN and policy</td>
                        </tr>
                        <tr>
                            <td>Authentication Failure</td>
                            <td>Connect device with invalid credentials or unauthorized MAC</td>
                            <td>Device fails authentication and is denied access or placed in restricted VLAN</td>
                        </tr>
                        <tr>
                            <td>RADIUS Server Failure</td>
                            <td>Disable primary RADIUS server</td>
                            <td>Authentication continues using secondary server</td>
                        </tr>
                        <tr>
                            <td>All RADIUS Servers Failure</td>
                            <td>Disable all RADIUS servers</td>
                            <td>${params.criticalAuth ? 'Critical authentication activates and permits restricted access' : 'Authentication fails and devices denied access'}</td>
                        </tr>
                    </table>
                </div>
            `;
        },
        
        /**
         * Generate troubleshooting section
         * @param {Object} params - Configuration parameters
         * @returns {string} Troubleshooting section HTML
         */
        generateTroubleshootingSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>6. Troubleshooting</h2>
                    
                    <h3>6.1 Common Issues and Resolutions</h3>
                    <table class="doc-table">
                        <tr>
                            <th>Issue</th>
                            <th>Possible Causes</th>
                            <th>Resolution</th>
                        </tr>
                        <tr>
                            <td>Authentication Failures</td>
                            <td>
                                <ul>
                                    <li>Incorrect credentials</li>
                                    <li>Expired account</li>
                                    <li>Misconfigured supplicant</li>
                                    <li>RADIUS server issues</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Verify credentials</li>
                                    <li>Check account status</li>
                                    <li>Verify supplicant configuration</li>
                                    <li>Check RADIUS server connectivity</li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>RADIUS Connectivity Issues</td>
                            <td>
                                <ul>
                                    <li>Network connectivity</li>
                                    <li>Firewall blocking</li>
                                    <li>Incorrect shared secret</li>
                                    <li>Server down</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Check network connectivity</li>
                                    <li>Verify firewall rules</li>
                                    <li>Confirm shared secret matches</li>
                                    <li>Check server status</li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>VLAN Assignment Issues</td>
                            <td>
                                <ul>
                                    <li>Missing VLAN on switch</li>
                                    <li>Incorrect RADIUS attributes</li>
                                    <li>Trunk port configuration</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Verify VLAN exists on switch</li>
                                    <li>Check RADIUS attribute format</li>
                                    <li>Ensure VLANs are allowed on trunk</li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>Intermittent Authentication</td>
                            <td>
                                <ul>
                                    <li>Supplicant timeout issues</li>
                                    <li>Network instability</li>
                                    <li>Server overload</li>
                                    <li>EAP method incompatibility</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Adjust timers</li>
                                    <li>Check for network issues</li>
                                    <li>Verify server capacity</li>
                                    <li>Test different EAP methods</li>
                                </ul>
                            </td>
                        </tr>
                    </table>
                    
                    <h3>6.2 Diagnostic Commands</h3>
                    <p>Use the following commands for troubleshooting:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Command</th>
                            <th>Purpose</th>
                        </tr>
                        ${params.vendor === 'cisco' ? `
                        <tr>
                            <td><code>debug dot1x all</code></td>
                            <td>Debug 802.1X authentication process</td>
                        </tr>
                        <tr>
                            <td><code>debug authentication all</code></td>
                            <td>Debug authentication manager</td>
                        </tr>
                        <tr>
                            <td><code>debug radius authentication</code></td>
                            <td>Debug RADIUS authentication</td>
                        </tr>
                        <tr>
                            <td><code>debug aaa authentication</code></td>
                            <td>Debug AAA authentication</td>
                        </tr>
                        ` : params.vendor === 'aruba' ? `
                        <tr>
                            <td><code>debug port-access authenticator</code></td>
                            <td>Debug port authentication process</td>
                        </tr>
                        <tr>
                            <td><code>debug radius</code></td>
                            <td>Debug RADIUS communication</td>
                        </tr>
                        <tr>
                            <td><code>debug security port-access</code></td>
                            <td>Debug port security</td>
                        </tr>
                        ` : `
                        <tr>
                            <td><code>debug authentication</code></td>
                            <td>Debug authentication process</td>
                        </tr>
                        <tr>
                            <td><code>debug radius</code></td>
                            <td>Debug RADIUS communication</td>
                        </tr>
                        `}
                    </table>
                    
                    <h3>6.3 Logs and Error Messages</h3>
                    <p>Monitor the following logs for authentication issues:</p>
                    <ul>
                        <li>Switch authentication logs</li>
                        <li>RADIUS server logs</li>
                        <li>Client supplicant logs</li>
                        <li>System logs for port status changes</li>
                    </ul>
                    
                    <p>Common error messages and their meanings:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Error Message</th>
                            <th>Meaning</th>
                        </tr>
                        <tr>
                            <td>RADIUS-3-NOSERVERS</td>
                            <td>No RADIUS servers responding</td>
                        </tr>
                        <tr>
                            <td>DOT1X-5-FAIL</td>
                            <td>Authentication failed</td>
                        </tr>
                        <tr>
                            <td>MAB-5-FAIL</td>
                            <td>MAC authentication failed</td>
                        </tr>
                        <tr>
                            <td>DOT1X-5-SUCCESS</td>
                            <td>Authentication succeeded</td>
                        </tr>
                    </table>
                </div>
            `;
        },
        
        /**
         * Extract global authentication configuration
         * @param {string} config - Complete configuration
         * @returns {string} Global authentication configuration
         */
        extractGlobalAuthConfig: function(config) {
            // Extract AAA and authentication global configuration
            const globalConfig = [];
            
            // Match AAA configuration
            const aaaMatch = config.match(/aaa new-model[\s\S]*?(?=\n\S|$)/m);
            if (aaaMatch) {
                globalConfig.push(aaaMatch[0]);
            }
            
            // Match dot1x global configuration
            const dot1xMatch = config.match(/dot1x system-auth-control[\s\S]*?(?=\n\S|$)/m);
            if (dot1xMatch) {
                globalConfig.push(dot1xMatch[0]);
            }
            
            // Match critical auth configuration
            const criticalMatch = config.match(/(?:dot1x critical|authentication critical)[\s\S]*?(?=\n\S|$)/m);
            if (criticalMatch) {
                globalConfig.push(criticalMatch[0]);
            }
            
            return globalConfig.join('\n\n') || 'No global authentication configuration found.';
        },
        
        /**
         * Extract RADIUS server configuration
         * @param {string} config - Complete configuration
         * @returns {string} RADIUS server configuration
         */
        extractRadiusConfig: function(config) {
            // Extract RADIUS server configuration
            let radiusConfig = '';
            
            // Match RADIUS server definitions - IOS-XE style
            const radServerMatch = config.match(/radius server[\s\S]*?(?=\n\S|$)/gm);
            if (radServerMatch) {
                radiusConfig += radServerMatch.join('\n\n');
            }
            
            // Match RADIUS server definitions - IOS style
            const radOldMatch = config.match(/radius-server host.*(?:\n\s+.*)*(?=\n\S|$)/gm);
            if (radOldMatch) {
                radiusConfig += (radiusConfig ? '\n\n' : '') + radOldMatch.join('\n');
            }
            
            // Match AAA server group configuration
            const aaaGroupMatch = config.match(/aaa group server radius[\s\S]*?(?=\n\S|$)/m);
            if (aaaGroupMatch) {
                radiusConfig += (radiusConfig ? '\n\n' : '') + aaaGroupMatch[0];
            }
            
            return radiusConfig || 'No RADIUS configuration found.';
        },
        
        /**
         * Extract 802.1X configuration
         * @param {string} config - Complete configuration
         * @returns {string} 802.1X configuration
         */
        extract801xConfig: function(config) {
            // Extract 802.1X specific configuration
            const dot1xConfig = [];
            
            // Match dot1x global config
            const dot1xGlobalMatch = config.match(/dot1x system-auth-control[\s\S]*?(?=\n\S|$)/m);
            if (dot1xGlobalMatch) {
                dot1xConfig.push(dot1xGlobalMatch[0]);
            }
            
            // Match IBNS 2.0 policy maps if available
            const policyMapMatch = config.match(/policy-map type control subscriber[\s\S]*?(?=\n\S|$)/gm);
            if (policyMapMatch) {
                dot1xConfig.push(policyMapMatch.join('\n\n'));
            }
            
            // Match class maps if available
            const classMapMatch = config.match(/class-map type control subscriber[\s\S]*?(?=\n\S|$)/gm);
            if (classMapMatch) {
                dot1xConfig.push(classMapMatch.join('\n\n'));
            }
            
            // Match dot1x configuration on a sample interface
            const interfaceMatch = config.match(/interface[\s\S]*?dot1x[\s\S]*?(?=\n\S|$)/m);
            if (interfaceMatch) {
                dot1xConfig.push('# Sample Interface Configuration:\n' + interfaceMatch[0]);
            }
            
            return dot1xConfig.join('\n\n') || 'No 802.1X specific configuration found.';
        },
        
        /**
         * Extract MAB configuration
         * @param {string} config - Complete configuration
         * @returns {string} MAB configuration
         */
        extractMabConfig: function(config) {
            // Extract MAB specific configuration
            const mabConfig = [];
            
            // Match MAB configuration on a sample interface
            const interfaceMatch = config.match(/interface[\s\S]*?mab[\s\S]*?(?=\n\S|$)/m);
            if (interfaceMatch) {
                mabConfig.push('# Sample Interface Configuration:\n' + interfaceMatch[0]);
            }
            
            // Match MAB policy maps if available
            const mabPolicyMatch = config.match(/policy-map[\s\S]*?mab[\s\S]*?(?=\n\S|$)/gm);
            if (mabPolicyMatch) {
                mabConfig.push(mabPolicyMatch.join('\n\n'));
            }
            
            return mabConfig.join('\n\n') || 'No MAB specific configuration found.';
        },
        
        /**
         * Extract interface configuration
         * @param {string} config - Complete configuration
         * @returns {string} Interface configuration
         */
        extractInterfaceConfig: function(config) {
            // Extract interface configuration with authentication
            const interfaceMatch = config.match(/interface[\s\S]*?(?:authentication|dot1x|mab)[\s\S]*?(?=\n\S|$)/m);
            
            if (interfaceMatch) {
                return interfaceMatch[0];
            }
            
            return 'No interface configuration with authentication found.';
        },
        
        /**
         * Apply document style
         * @param {string} format - Document format
         */
        applyDocumentStyle: function(format) {
            // Remove previous style if it exists
            const oldStyle = document.getElementById('docStyle');
            if (oldStyle) {
                oldStyle.remove();
            }
            
            // Create new style element
            const style = document.createElement('style');
            style.id = 'docStyle';
            
            // Set style based on format
            if (format === 'formal') {
                style.textContent = `
                    .documentation-preview {
                        font-family: 'Times New Roman', Times, serif;
                        line-height: 1.6;
                        color: #000000;
                    }
                    
                    .doc-header h1 {
                        font-size: 20px;
                        text-align: center;
                        margin-bottom: 10px;
                    }
                    
                    .doc-meta {
                        text-align: center;
                        font-style: italic;
                        margin-bottom: 30px;
                    }
                    
                    .doc-section {
                        margin-bottom: 30px;
                    }
                    
                    .doc-section h2 {
                        font-size: 16px;
                        border-bottom: 1px solid #000000;
                        padding-bottom: 5px;
                        margin-bottom: 15px;
                    }
                    
                    .doc-section h3 {
                        font-size: 14px;
                        margin-top: 20px;
                        margin-bottom: 10px;
                    }
                    
                    .doc-section h4 {
                        font-size: 12px;
                        margin-top: 15px;
                        margin-bottom: 5px;
                    }
                    
                    .doc-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }
                    
                    .doc-table th, .doc-table td {
                        border: 1px solid #000000;
                        padding: 8px;
                        text-align: left;
                    }
                    
                    .doc-table th {
                        background-color: #f0f0f0;
                    }
                    
                    .doc-code {
                        font-family: Courier, monospace;
                        background-color: #f5f5f5;
                        padding: 10px;
                        margin: 10px 0;
                        border: 1px solid #ddd;
                        white-space: pre-wrap;
                    }
                    
                    .doc-image-placeholder {
                        border: 1px dashed #999;
                        padding: 30px;
                        text-align: center;
                        margin: 20px 0;
                        background-color: #f9f9f9;
                    }
                `;
            } else if (format === 'technical') {
                style.textContent = `
                    .documentation-preview {
                        font-family: Arial, Helvetica, sans-serif;
                        line-height: 1.5;
                        color: #333333;
                    }
                    
                    .doc-header h1 {
                        font-size: 22px;
                        color: #0056b3;
                        margin-bottom: 10px;
                    }
                    
                    .doc-meta {
                        color: #666;
                        margin-bottom: 30px;
                    }
                    
                    .doc-section {
                        margin-bottom: 30px;
                    }
                    
                    .doc-section h2 {
                        font-size: 18px;
                        color: #0056b3;
                        border-bottom: 2px solid #0056b3;
                        padding-bottom: 5px;
                        margin-bottom: 15px;
                    }
                    
                    .doc-section h3 {
                        font-size: 16px;
                        color: #0077cc;
                        margin-top: 20px;
                        margin-bottom: 10px;
                    }
                    
                    .doc-section h4 {
                        font-size: 14px;
                        color: #0077cc;
                        margin-top: 15px;
                        margin-bottom: 5px;
                    }
                    
                    .doc-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }
                    
                    .doc-table th, .doc-table td {
                        border: 1px solid #ddd;
                        padding: 8px;
                        text-align: left;
                    }
                    
                    .doc-table th {
                        background-color: #f0f0f0;
                    }
                    
                    .doc-code {
                        font-family: 'Courier New', Courier, monospace;
                        background-color: #f8f8f8;
                        padding: 10px;
                        margin: 10px 0;
                        border: 1px solid #ddd;
                        border-left: 3px solid #0056b3;
                        white-space: pre-wrap;
                    }
                    
                    .doc-image-placeholder {
                        border: 1px dashed #999;
                        padding: 30px;
                        text-align: center;
                        margin: 20px 0;
                        background-color: #f9f9f9;
                    }
                `;
            } else {
                style.textContent = `
                    .documentation-preview {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        line-height: 1.6;
                        color: #333333;
                    }
                    
                    .doc-header h1 {
                        font-size: 24px;
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }
                    
                    .doc-meta {
                        color: #7f8c8d;
                        margin-bottom: 30px;
                    }
                    
                    .doc-section {
                        margin-bottom: 30px;
                    }
                    
                    .doc-section h2 {
                        font-size: 20px;
                        color: #2c3e50;
                        border-bottom: 1px solid #ecf0f1;
                        padding-bottom: 5px;
                        margin-bottom: 15px;
                    }
                    
                    .doc-section h3 {
                        font-size: 18px;
                        color: #3498db;
                        margin-top: 20px;
                        margin-bottom: 10px;
                    }
                    
                    .doc-section h4 {
                        font-size: 16px;
                        color: #2980b9;
                        margin-top: 15px;
                        margin-bottom: 5px;
                    }
                    
                    .doc-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }
                    
                    .doc-table th, .doc-table td {
                        border: 1px solid #ecf0f1;
                        padding: 8px;
                        text-align: left;
                    }
                    
                    .doc-table th {
                        background-color: #f9f9f9;
                    }
                    
                    .doc-code {
                        font-family: Consolas, Monaco, 'Andale Mono', monospace;
                        background-color: #f8f9fa;
                        padding: 10px;
                        margin: 10px 0;
                        border: 1px solid #ecf0f1;
                        border-radius: 4px;
                        white-space: pre-wrap;
                    }
                    
                    .doc-image-placeholder {
                        border: 1px dashed #bdc3c7;
                        padding: 30px;
                        text-align: center;
                        margin: 20px 0;
                        background-color: #f9f9f9;
                        border-radius: 4px;
                    }
                `;
            }
            
            // Add style to document
            document.head.appendChild(style);
        },
        
        /**
         * Get full method name
         * @param {string} method - Method short name
         * @returns {string} Full method name
         */
        getFullMethodName: function(method) {
            switch (method) {
                case 'dot1x':
                    return 'IEEE 802.1X';
                case 'mab':
                    return 'MAC Authentication Bypass (MAB)';
                case 'webauth':
                    return 'Web Authentication';
                case 'macsec':
                    return 'MACsec (802.1AE)';
                case 'radsec':
                    return 'RADIUS over TLS (RadSec)';
                case 'tacacs':
                    return 'TACACS+';
                default:
                    return method;
            }
        },
        
        /**
         * Get method description
         * @param {string} method - Method short name
         * @returns {string} Method description
         */
        getMethodDescription: function(method) {
            switch (method) {
                case 'dot1x':
                    return 'Port-based Network Access Control for authenticating and authorizing devices before they can access the network';
                case 'mab':
                    return 'Allows non-802.1X capable devices to authenticate based on their MAC address';
                case 'webauth':
                    return 'Web-based authentication typically used for guest access';
                case 'macsec':
                    return 'IEEE 802.1AE standard for MAC Security providing point-to-point encryption on wired networks';
                case 'radsec':
                    return 'RADIUS over TLS providing secure transportation of RADIUS messages';
                case 'tacacs':
                    return 'Authentication protocol providing centralized authentication for administrative access';
                default:
                    return 'Authentication method';
            }
        },
        
        /**
         * Parse configuration parameters from configuration
         * @param {string} config - Configuration text
         * @returns {Object} Configuration parameters
         */
        parseConfigParameters: function(config) {
            const params = {
                vendor: 'unknown',
                platform: 'unknown',
                authMethods: [],
                radiusServers: [],
                hostMode: '',
                deploymentType: '',
                securityFeatures: [],
                criticalAuth: false
            };
            
            // Detect vendor and platform
            if (config.includes('aaa new-model') || config.includes('interface GigabitEthernet')) {
                params.vendor = 'cisco';
                
                if (config.includes('IBNS') || config.includes('POLICY') || 
                    config.includes('service-policy type control subscriber') ||
                    config.includes('access-session')) {
                    params.platform = 'ios-xe';
                } else {
                    params.platform = 'ios';
                }
            } else if (config.includes('aaa authentication port-access') || 
                        config.includes('aaa port-access authenticator')) {
                params.vendor = 'aruba';
                
                if (config.includes('aaa port-access authenticator active')) {
                    params.platform = 'arubaos-switch';
                } else {
                    params.platform = 'arubaos-cx';
                }
            } else if (config.includes('system {') || config.includes('protocols {')) {
                params.vendor = 'juniper';
                params.platform = 'junos';
            }
            
            // Detect authentication methods
            if (config.includes('dot1x')) {
                params.authMethods.push('dot1x');
            }
            
            if (config.includes('mab')) {
                params.authMethods.push('mab');
            }
            
            if (config.includes('webauth') || config.includes('web-auth') || 
                config.includes('web authentication')) {
                params.authMethods.push('webauth');
            }
            
            if (config.includes('macsec')) {
                params.authMethods.push('macsec');
            }
            
            if (config.includes('tacacs')) {
                params.authMethods.push('tacacs');
            }
            
            // Extract RADIUS servers
            const radiusMatches = config.match(/(?:radius server|radius-server host|address ipv4)\s+(\d+\.\d+\.\d+\.\d+)/g);
            if (radiusMatches) {
                radiusMatches.forEach(match => {
                    const ipMatch = match.match(/(\d+\.\d+\.\d+\.\d+)/);
                    if (ipMatch && !params.radiusServers.includes(ipMatch[1])) {
                        params.radiusServers.push(ipMatch[1]);
                    }
                });
            }
            
            // Detect host mode
            const hostModeMatch = config.match(/host-mode\s+(\S+)/);
            if (hostModeMatch) {
                params.hostMode = hostModeMatch[1];
            }
            
            // Detect deployment type
            if (config.includes('authentication open') || config.includes('auth-mode monitor')) {
                params.deploymentType = 'monitor';
            } else if (config.includes('do-all') && config.includes('authenticate using dot1x') && 
                        config.includes('authenticate using mab')) {
                params.deploymentType = 'concurrent';
            } else {
                params.deploymentType = 'closed';
            }
            
            // Detect security features
            if (config.includes('ip dhcp snooping') || config.includes('dhcp-snooping')) {
                params.securityFeatures.push('dhcpSnooping');
            }
            
            if (config.includes('ip arp inspection') || config.includes('arp-protect')) {
                params.securityFeatures.push('arpInspection');
            }
            
            if (config.includes('ip verify source')) {
                params.securityFeatures.push('ipSourceGuard');
            }
            
            // Detect critical authentication
            if (config.includes('critical') || config.includes('CRITICAL_')) {
                params.criticalAuth = true;
            }
            
            return params;
        },
        
        /**
         * Download documentation as a file
         */
        downloadDocumentation: function() {
            const documentationPreview = document.getElementById('documentationPreview');
            
            if (!documentationPreview || !documentationPreview.innerHTML) {
                alert('Please generate documentation first.');
                return;
            }
            
            // Get document format
            const format = document.getElementById('docFormat').value || 'standard';
            
            // Create document content
            const docContent = `<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Network Authentication Documentation</title>
    <style>
        ${document.getElementById('docStyle').textContent}
    </style>
</head>
<body>
    <div class="documentation-preview ${format}">
        ${documentationPreview.innerHTML}
    </div>
</body>
</html>`;
            
            // Create download link
            const link = document.createElement('a');
            link.href = 'data:text/html;charset=utf-8,' + encodeURIComponent(docContent);
            link.download = 'network-authentication-documentation.html';
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        },
        
        /**
         * Generate deployment checklist
         */
        generateChecklist: function() {
            const configOutput = document.getElementById('configOutput');
            const checklistPreview = document.getElementById('checklistPreview');
            
            if (!configOutput || !configOutput.value.trim() || !checklistPreview) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get the configuration
            const config = configOutput.value;
            
            // Parse configuration parameters
            const params = this.parseConfigParameters(config);
            
            // Generate checklist HTML
            let checklistHTML = `
                <div class="checklist-header">
                    <h2>Network Authentication Deployment Checklist</h2>
                    <p class="checklist-meta">Generated on: ${new Date().toLocaleDateString()}</p>
                </div>
                
                <div class="checklist-section">
                    <h3>1. Pre-Deployment Tasks</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-1">
                        <label for="pre-1">Backup current network device configurations</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-2">
                        <label for="pre-2">Verify RADIUS server connectivity from network devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-3">
                        <label for="pre-3">Test RADIUS authentication with sample credentials</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-4">
                        <label for="pre-4">Verify NTP configuration and time synchronization</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-5">
                        <label for="pre-5">Document current network state (VLANs, port assignments, etc.)</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-6">
                        <label for="pre-6">Create user/device database in RADIUS server</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-7">
                        <label for="pre-7">Define authorization policies in RADIUS server</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-8">
                        <label for="pre-8">Prepare client supplicant configuration templates</label>
                    </div>
                </div>
                
                <div class="checklist-section">
                    <h3>2. Network Device Configuration</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-1">
                        <label for="net-1">Configure global AAA settings</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-2">
                        <label for="net-2">Configure RADIUS server settings</label>
                    </div>
                    
                    ${params.authMethods.includes('dot1x') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-3">
                        <label for="net-3">Configure global 802.1X settings</label>
                    </div>
                    ` : ''}
                    
                    ${params.securityFeatures.includes('dhcpSnooping') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-4">
                        <label for="net-4">Configure DHCP snooping</label>
                    </div>
                    ` : ''}
                    
                    ${params.securityFeatures.includes('arpInspection') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-5">
                        <label for="net-5">Configure Dynamic ARP Inspection</label>
                    </div>
                    ` : ''}
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-6">
                        <label for="net-6">Configure authentication ${params.deploymentType === 'monitor' ? 'in monitor mode' : 'in closed mode'}</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-7">
                        <label for="net-7">Configure authentication policies and templates</label>
                    </div>
                    
                    ${params.criticalAuth ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-8">
                        <label for="net-8">Configure critical authentication for RADIUS failure handling</label>
                    </div>
                    ` : ''}
                </div>
                
                <div class="checklist-section">
                    <h3>3. Interface Configuration</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-1">
                        <label for="int-1">Configure authentication on test ports</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-2">
                        <label for="int-2">Verify authentication works on test ports</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-3">
                        <label for="int-3">Create interface templates for different port types</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-4">
                        <label for="int-4">Roll out configuration to first batch of production ports</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-5">
                        <label for="int-5">Verify authentication and policy application</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-6">
                        <label for="int-6">Document any issues and resolutions</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-7">
                        <label for="int-7">Complete rollout to all remaining ports</label>
                    </div>
                </div>
                
                <div class="checklist-section">
                    <h3>4. Client Configuration</h3>
                    
                    ${params.authMethods.includes('dot1x') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-1">
                        <label for="cli-1">Configure supplicants on Windows devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-2">
                        <label for="cli-2">Configure supplicants on macOS devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-3">
                        <label for="cli-3">Configure supplicants on Linux devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-4">
                        <label for="cli-4">Configure supplicants on mobile devices</label>
                    </div>
                    ` : ''}
                    
                    ${params.authMethods.includes('mab') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-5">
                        <label for="cli-5">Add MAC addresses of non-802.1X devices to RADIUS server</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-6">
                        <label for="cli-6">Verify MAB authentication for printers</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-7">
                        <label for="cli-7">Verify MAB authentication for IoT devices</label>
                    </div>
                    ` : ''}
                </div>
                
                <div class="checklist-section">
                    <h3>5. Verification and Testing</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-1">
                        <label for="ver-1">Test successful 802.1X authentication</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-2">
                        <label for="ver-2">Test failed authentication handling</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-3">
                        <label for="ver-3">Test RADIUS server failover</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-4">
                        <label for="ver-4">Verify VLAN assignment</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-5">
                        <label for="ver-5">Verify policy (ACL) application</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-6">
                        <label for="ver-6">Verify authentication accounting logs</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-7">
                        <label for="ver-7">Conduct load testing if applicable</label>
                    </div>
                </div>
                
                <div class="checklist-section">
                    <h3>6. Post-Deployment Tasks</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-1">
                        <label for="post-1">Document final configuration</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-2">
                        <label for="post-2">Create monitoring dashboards</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-3">
                        <label for="post-3">Set up alerts for authentication failures</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-4">
                        <label for="post-4">Create user documentation</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-5">
                        <label for="post-5">Train help desk staff on troubleshooting</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-6">
                        <label for="post-6">Conduct post-implementation review</label>
                    </div>
                </div>
            `;
            
            // Set the checklist HTML
            checklistPreview.innerHTML = checklistHTML;
        },
        
        /**
         * Download checklist as a file
         */
        downloadChecklist: function() {
            const checklistPreview = document.getElementById('checklistPreview');
            
            if (!checklistPreview || !checklistPreview.innerHTML) {
                alert('Please generate a checklist first.');
                return;
            }
            
            // Create checklist content
            const checklistContent = `<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Network Authentication Deployment Checklist</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .checklist-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .checklist-header h2 {
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .checklist-meta {
            color: #7f8c8d;
        }
        
        .checklist-section {
            margin-bottom: 30px;
        }
        
        .checklist-section h3 {
            color: #3498db;
            border-bottom: 1px solid #ecf0f1;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }
        
        .checklist-item {
            display: flex;
            align-items: baseline;
            margin-bottom: 10px;
            padding: 8px;
            border-radius: 4px;
            background-color: #f8f9fa;
        }
        
        .checklist-item input[type="checkbox"] {
            margin-right: 10px;
            width: 16px;
            height: 16px;
        }
        
        .checklist-item label {
            flex: 1;
        }
        
        .checklist-item:hover {
            background-color: #e9ecef;
        }
        
        @media print {
            .checklist-item {
                break-inside: avoid;
                background-color: #fff;
                border: 1px solid #ddd;
            }
            
            .checklist-section {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
    ${checklistPreview.innerHTML}
</body>
</html>`;
            
            // Create download link
            const link = document.createElement('a');
            link.href = 'data:text/html;charset=utf-8,' + encodeURIComponent(checklistContent);
            link.download = 'network-authentication-checklist.html';
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        },
        
        /**
         * Generate troubleshooting guide
         */
        generateTroubleshootingGuide: function() {
            const configOutput = document.getElementById('configOutput');
            const troubleshootingPreview = document.getElementById('troubleshootingPreview');
            
            if (!configOutput || !configOutput.value.trim() || !troubleshootingPreview) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get the configuration
            const config = configOutput.value;
            
            // Parse configuration parameters
            const params = this.parseConfigParameters(config);
            
            // Generate troubleshooting guide HTML
            let guideHTML = `
                <div class="guide-header">
                    <h2>Network Authentication Troubleshooting Guide</h2>
                    <p class="guide-meta">Generated on: ${new Date().toLocaleDateString()}</p>
                </div>
                
                <div class="guide-section">
                    <h3>1. Common Authentication Issues</h3>
                    
                    <div class="guide-problem">
                        <h4>Problem: Authentication Failures</h4>
                        <div class="guide-symptoms">
                            <h5>Symptoms:</h5>
                            <ul>
                                <li>Client cannot access network resources</li>
                                <li>Port shows "unauthorized" status</li>
                                <li>Authentication failure messages in logs</li>
                            </ul>
                        </div>
                        
                        <div class="guide-steps">
                            <h5>Troubleshooting Steps:</h5>
                            <ol>
                                <li>
                                    <strong>Verify port status:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.vendor === 'cisco' && params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') : 'show port-access authenticator'}</pre>
                                </li>
                                <li>
                                    <strong>Check authentication method:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.vendor === 'cisco' && params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + ' details' : 'show port-access authenticator ' + (params.vendor === 'aruba' ? '1/1' : '')}</pre>
                                </li>
                                <li>
                                    <strong>Verify RADIUS server connectivity:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'test aaa group radius username password new-code' : 'test radius auth server-group radius username password'}</pre>
                                </li>
                                <li>
                                    <strong>Check RADIUS server statistics:</strong>
                                    <pre class="guide-command">show radius statistics</pre>
                                </li>
                                <li>
                                    <strong>Verify client configuration:</strong>
                                    <ul>
                                        <li>Check 802.1X supplicant settings on client</li>
                                        <li>Verify user credentials</li>
                                        <li>Check EAP method configuration</li>
                                    </ul>
                                </li>
                                <li>
                                    <strong>Debug authentication process:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'debug authentication all\ndebug dot1x all\ndebug radius authentication' : 'debug port-access authenticator\ndebug radius'}</pre>
                                </li>
                            </ol>
                        </div>
                        
                        <div class="guide-resolution">
                            <h5>Common Resolutions:</h5>
                            <ul>
                                <li>Correct user credentials</li>
                                <li>Update supplicant configuration</li>
                                <li>Ensure RADIUS server is reachable</li>
                                <li>Verify correct shared secret configured</li>
                                <li>Check EAP method compatibility</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="guide-problem">
                        <h4>Problem: RADIUS Server Connectivity Issues</h4>
                        <div class="guide-symptoms">
                            <h5>Symptoms:</h5>
                            <ul>
                                <li>Authentication timeouts</li>
                                <li>RADIUS server unreachable messages</li>
                                <li>Fallback to secondary server or critical authentication</li>
                            </ul>
                        </div>
                        
                        <div class="guide-steps">
                            <h5>Troubleshooting Steps:</h5>
                            <ol>
                                <li>
                                    <strong>Check RADIUS server status:</strong>
                                    <pre class="guide-command">show radius statistics</pre>
                                </li>
                                <li>
                                    <strong>Verify network connectivity:</strong>
                                    <pre class="guide-command">ping ${params.radiusServers.length > 0 ? params.radiusServers[0] : '10.1.1.100'}</pre>
                                </li>
                                <li>
                                    <strong>Check RADIUS configuration:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'show run | section radius server' : 'show run | include radius-server') : 'show radius'}</pre>
                                </li>
                                <li>
                                    <strong>Verify port connectivity:</strong>
                                    <pre class="guide-command">telnet ${params.radiusServers.length > 0 ? params.radiusServers[0] : '10.1.1.100'} 1812</pre>
                                </li>
                                <li>
                                    <strong>Check firewall rules:</strong>
                                    <ul>
                                        <li>Ensure RADIUS ports (1812/1813) are allowed</li>
                                        <li>Check for any ACLs blocking RADIUS traffic</li>
                                    </ul>
                                </li>
                                <li>
                                    <strong>Debug RADIUS communication:</strong>
                                    <pre class="guide-command">debug radius authentication</pre>
                                </li>
                            </ol>
                        </div>
                        
                        <div class="guide-resolution">
                            <h5>Common Resolutions:</h5>
                            <ul>
                                <li>Restore network connectivity to RADIUS server</li>
                                <li>Correct RADIUS server IP address configuration</li>
                                <li>Update shared secret to match RADIUS server</li>
                                <li>Adjust firewall rules to allow RADIUS traffic</li>
                                <li>Check RADIUS server logs for errors</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="guide-problem">
                        <h4>Problem: VLAN Assignment Issues</h4>
                        <div class="guide-symptoms">
                            <h5>Symptoms:</h5>
                            <ul>
                                <li>Authentication succeeds but client assigned to wrong VLAN</li>
                                <li>Client not receiving IP address</li>
                                <li>VLAN assignment errors in logs</li>
                            </ul>
                        </div>
                        
                        <div class="guide-steps">
                            <h5>Troubleshooting Steps:</h5>
                            <ol>
                                <li>
                                    <strong>Check current VLAN assignment:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + ' details' : 'show port-access authenticator ' + (params.vendor === 'aruba' ? '1/1' : '')}</pre>
                                </li>
                                <li>
                                    <strong>Verify VLAN exists on switch:</strong>
                                    <pre class="guide-command">show vlan</pre>
                                </li>
                                <li>
                                    <strong>Check RADIUS attributes:</strong>
                                    <ul>
                                        <li>Tunnel-Type = VLAN (13)</li>
                                        <li>Tunnel-Medium-Type = 802 (6)</li>
                                        <li>Tunnel-Private-Group-ID = [VLAN ID]</li>
                                    </ul>
                                </li>
                                <li>
                                    <strong>Verify trunk configuration (if applicable):</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show interfaces trunk' : 'show interfaces trunk'}</pre>
                                </li>
                                <li>
                                    <strong>Debug RADIUS attributes:</strong>
                                    <pre class="guide-command">debug radius attributes</pre>
                                </li>
                            </ol>
                        </div>
                        
                        <div class="guide-resolution">
                            <h5>Common Resolutions:</h5>
                            <ul>
                                <li>Create missing VLAN on switch</li>
                                <li>Correct RADIUS attribute format</li>
                                <li>Add VLAN to allowed list on trunk ports</li>
                                <li>Check DHCP configuration for the VLAN</li>
                                <li>Verify IP helper addresses configured</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>2. ${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)} ${params.platform.toUpperCase()} Specific Commands</h3>
                    
                    <div class="guide-commands">
                        <h4>Status and Verification Commands</h4>
                        <table class="guide-table">
                            <tr>
                                <th>Purpose</th>
                                <th>Command</th>
                            </tr>
                            ${params.vendor === 'cisco' ? `
                            <tr>
                                <td>View authentication sessions</td>
                                <td><code>show authentication sessions</code></td>
                            </tr>
                            <tr>
                                <td>View interface authentication</td>
                                <td><code>show authentication sessions interface ${params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1'}</code></td>
                            </tr>
                            <tr>
                                <td>View 802.1X status</td>
                                <td><code>show dot1x all</code></td>
                            </tr>
                            <tr>
                                <td>View detailed 802.1X status</td>
                                <td><code>show dot1x interface ${params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1'} details</code></td>
                            </tr>
                            <tr>
                                <td>View MAB status</td>
                                <td><code>show mab all</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS statistics</td>
                                <td><code>show radius statistics</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS configuration</td>
                                <td><code>${params.platform === 'ios-xe' ? 'show run | section radius server' : 'show run | include radius-server'}</code></td>
                            </tr>
                            <tr>
                                <td>Test RADIUS authentication</td>
                                <td><code>test aaa group radius username password new-code</code></td>
                            </tr>
                            ` : params.vendor === 'aruba' ? `
                            <tr>
                                <td>View authentication status</td>
                                <td><code>show port-access authenticator</code></td>
                            </tr>
                            <tr>
                                <td>View interface authentication</td>
                                <td><code>show port-access authenticator 1/1</code></td>
                            </tr>
                            <tr>
                                <td>View MAC authentication</td>
                                <td><code>show port-access mac-auth</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS statistics</td>
                                <td><code>show radius authentication</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS configuration</td>
                                <td><code>show radius</code></td>
                            </tr>
                            <tr>
                                <td>Test RADIUS authentication</td>
                                <td><code>test radius authentication</code></td>
                            </tr>
                            ` : `
                            <tr>
                                <td>View authentication status</td>
                                <td><code>show authentication status</code></td>
                            </tr>
                            <tr>
                                <td>View interface authentication</td>
                                <td><code>show authentication interface ge-0/0/1</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS statistics</td>
                                <td><code>show radius statistics</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS configuration</td>
                                <td><code>show configuration system radius-server</code></td>
                            </tr>
                            `}
                        </table>
                    </div>
                    
                    <div class="guide-commands">
                        <h4>Debug Commands</h4>
                        <table class="guide-table">
                            <tr>
                                <th>Purpose</th>
                                <th>Command</th>
                                <th>Notes</th>
                            </tr>
                            ${params.vendor === 'cisco' ? `
                            <tr>
                                <td>Debug 802.1X authentication</td>
                                <td><code>debug dot1x all</code></td>
                                <td>Shows detailed 802.1X packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug authentication manager</td>
                                <td><code>debug authentication all</code></td>
                                <td>Shows authentication state machine</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS communication</td>
                                <td><code>debug radius authentication</code></td>
                                <td>Shows RADIUS packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS attributes</td>
                                <td><code>debug radius attributes</code></td>
                                <td>Shows detailed RADIUS attributes</td>
                            </tr>
                            <tr>
                                <td>Debug AAA authentication</td>
                                <td><code>debug aaa authentication</code></td>
                                <td>Shows AAA process for authentication</td>
                            </tr>
                            <tr>
                                <td>Debug AAA authorization</td>
                                <td><code>debug aaa authorization</code></td>
                                <td>Shows AAA process for authorization</td>
                            </tr>
                            ` : params.vendor === 'aruba' ? `
                            <tr>
                                <td>Debug port authentication</td>
                                <td><code>debug port-access authenticator</code></td>
                                <td>Shows detailed authentication process</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS communication</td>
                                <td><code>debug radius</code></td>
                                <td>Shows RADIUS packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug port security</td>
                                <td><code>debug security port-access</code></td>
                                <td>Shows port security state changes</td>
                            </tr>
                            <tr>
                                <td>Debug all authentication</td>
                                <td><code>debug all</code></td>
                                <td>Shows all debugging (use carefully)</td>
                            </tr>
                            ` : `
                            <tr>
                                <td>Debug 802.1X authentication</td>
                                <td><code>debug dot1x</code></td>
                                <td>Shows detailed 802.1X packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS communication</td>
                                <td><code>debug radius</code></td>
                                <td>Shows RADIUS packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug authentication process</td>
                                <td><code>debug authentication</code></td>
                                <td>Shows authentication state machine</td>
                            </tr>
                            `}
                        </table>
                        
                        <div class="guide-warning">
                            <p><strong>Warning:</strong> Debug commands can generate a large amount of output and impact device performance. Use them in a controlled environment and disable debugging when finished.</p>
                            <p><code>${params.vendor === 'cisco' ? 'undebug all' : 'no debug all'}</code></p>
                        </div>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>3. Error Message Reference</h3>
                    
                    <div class="guide-errors">
                        <table class="guide-table">
                            <tr>
                                <th>Error Message</th>
                                <th>Description</th>
                                <th>Resolution</th>
                            </tr>
                            <tr>
                                <td>%DOT1X-5-FAIL</td>
                                <td>802.1X authentication failed</td>
                                <td>Verify user credentials, check EAP method, check RADIUS server</td>
                            </tr>
                            <tr>
                                <td>%MAB-5-FAIL</td>
                                <td>MAC authentication failed</td>
                                <td>Verify MAC address in RADIUS database, check format (hyphen, colon, etc.)</td>
                            </tr>
                            <tr>
                                <td>%RADIUS-4-RADIUS_DEAD</td>
                                <td>RADIUS server not responding</td>
                                <td>Check network connectivity, server status, shared secret</td>
                            </tr>
                            <tr>
                                <td>%RADIUS-4-RADIUS_ALIVE</td>
                                <td>RADIUS server returned to service</td>
                                <td>Informational only, no action required</td>
                            </tr>
                            <tr>
                                <td>%DOT1X-5-ERR_VLAN_NOT_FOUND</td>
                                <td>VLAN from RADIUS not found on switch</td>
                                <td>Create VLAN on switch or correct RADIUS attribute</td>
                            </tr>
                            <tr>
                                <td>%DOT1X-5-ERR_INVALID_AAA_ATTR</td>
                                <td>Invalid AAA attribute received</td>
                                <td>Check RADIUS attribute format</td>
                            </tr>
                            <tr>
                                <td>%AUTHMGR-7-RESULT</td>
                                <td>Authentication result</td>
                                <td>Informational, shows authentication outcome</td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>4. Advanced Troubleshooting Scenarios</h3>
                    
                    <div class="guide-scenario">
                        <h4>Scenario: Intermittent Authentication Failures</h4>
                        <p><strong>Description:</strong> Clients authenticate successfully sometimes but fail at other times.</p>
                        
                        <h5>Possible Causes:</h5>
                        <ul>
                            <li>RADIUS server overload or performance issues</li>
                            <li>Network connectivity problems</li>
                            <li>Timer misconfigurations</li>
                            <li>Client supplicant issues</li>
                        </ul>
                        
                        <h5>Troubleshooting Approach:</h5>
                        <ol>
                            <li>Check RADIUS server performance metrics</li>
                            <li>Examine network for intermittent connectivity issues:
                                <pre class="guide-command">ping ${params.radiusServers.length > 0 ? params.radiusServers[0] : '10.1.1.100'} repeat 100</pre>
                            </li>
                            <li>Adjust timeouts and retransmits:
                                <pre class="guide-command">${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'radius server SERVER1\n timeout 5\n retransmit 3' : 'radius-server timeout 5\nradius-server retransmit 3') : 'radius-server timeout 5\nradius-server retransmit 3'}</pre>
                            </li>
                            <li>Enable RADIUS server load balancing (if multiple servers available):
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'aaa group server radius RAD_SERVERS\n load-balance method least-outstanding' : 'radius-server host 10.1.1.1 loadbalance\nradius-server host 10.1.1.2 loadbalance'}</pre>
                            </li>
                            <li>Check for client-specific issues by testing with different devices</li>
                        </ol>
                    </div>
                    
                    <div class="guide-scenario">
                        <h4>Scenario: Authentication Succeeds but Access is Limited</h4>
                        <p><strong>Description:</strong> Clients authenticate successfully but cannot access network resources.</p>
                        
                        <h5>Possible Causes:</h5>
                        <ul>
                            <li>DACL or VLAN ACL issues</li>
                            <li>Incorrect VLAN assignment</li>
                            <li>Routing issues</li>
                            <li>DHCP problems</li>
                        </ul>
                        
                        <h5>Troubleshooting Approach:</h5>
                        <ol>
                            <li>Check assigned VLAN and IP address:
                                <pre class="guide-command">show authentication sessions interface ${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') : 'ge-0/0/1'} details</pre>
                            </li>
                            <li>Verify applied ACLs:
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show ip access-lists' : 'show access-lists'}</pre>
                            </li>
                            <li>Check DHCP snooping (if enabled):
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show ip dhcp snooping binding' : 'show dhcp snooping binding'}</pre>
                            </li>
                            <li>Verify routing between VLANs:
                                <pre class="guide-command">show ip route</pre>
                            </li>
                            <li>Test connectivity from the device:
                                <pre class="guide-command">ping default-gateway-ip</pre>
                            </li>
                        </ol>
                    </div>
                    
                    <div class="guide-scenario">
                        <h4>Scenario: All RADIUS Servers Unavailable</h4>
                        <p><strong>Description:</strong> All RADIUS servers are unreachable, causing authentication issues.</p>
                        
                        <h5>Expected Behavior:</h5>
                        <p>${params.criticalAuth ? 'Critical authentication should activate and permit restricted access based on configured policies.' : 'Authentication will fail unless local fallback is configured.'}</p>
                        
                        <h5>Troubleshooting Approach:</h5>
                        <ol>
                            <li>Verify RADIUS server status:
                                <pre class="guide-command">show radius statistics</pre>
                            </li>
                            <li>Check critical authentication status:
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + ' details' : 'show port-access authenticator'}</pre>
                            </li>
                            <li>Verify critical authentication configuration:
                                <pre class="guide-command">${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'show run | section critical' : 'show run | include critical') : 'show port-access critical-vlan'}</pre>
                            </li>
                            <li>Check local fallback authentication:
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show run | include local' : 'show authentication'}</pre>
                            </li>
                            <li>Restore connectivity to RADIUS servers</li>
                        </ol>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>5. Configuration Snippets for Quick Fixes</h3>
                    
                    <div class="guide-snippets">
                        <div class="guide-snippet">
                            <h4>Enable Monitor Mode for Testing</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + '\n authentication open\n authentication port-control auto' : params.vendor === 'aruba' ? 'aaa port-access authenticator 1/1\n auth-mode monitor' : 'set protocols dot1x interface ge-0/0/1 authentication open'}</pre>
                        </div>
                        
                        <div class="guide-snippet">
                            <h4>Disable Authentication on a Port</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + '\n no authentication port-control auto\n no dot1x pae authenticator\n no mab\n spanning-tree portfast' : params.vendor === 'aruba' ? 'no aaa port-access authenticator 1/1' : 'delete protocols dot1x interface ge-0/0/1'}</pre>
                        </div>
                        
                        <div class="guide-snippet">
                            <h4>Reset Interface</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + '\n shutdown\n no shutdown' : params.vendor === 'aruba' ? 'interface 1/1 disable\ninterface 1/1 enable' : 'set interface ge-0/0/1 disable\nset interface ge-0/0/1 enable'}</pre>
                        </div>
                        
                        <div class="guide-snippet">
                            <h4>Clear Authentication Sessions</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'clear authentication sessions interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') : params.vendor === 'aruba' ? 'aaa port-access authenticator 1/1 clear' : 'clear dot1x interface ge-0/0/1'}</pre>
                        </div>
                    </div>
                </div>
            `;
            
            // Apply guide style
            this.applyGuideStyle();
            
            // Set the troubleshooting HTML
            troubleshootingPreview.innerHTML = guideHTML;
        },
        
        /**
         * Apply guide style
         */
        applyGuideStyle: function() {
            // Remove previous style if it exists
            const oldStyle = document.getElementById('guideStyle');
            if (oldStyle) {
                oldStyle.remove();
            }
            
            // Create new style element
            const style = document.createElement('style');
            style.id = 'guideStyle';
            
            // Set style
            style.textContent = `
                .troubleshooting-preview {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    line-height: 1.6;
                    color: #333;
                }
                
                .guide-header {
                    margin-bottom: 30px;
                }
                
                .guide-header h2 {
                    color: #2c3e50;
                    font-size: 24px;
                    margin-bottom: 10px;
                }
                
                .guide-meta {
                    color: #7f8c8d;
                }
                
                .guide-section {
                    margin-bottom: 30px;
                }
                
                .guide-section h3 {
                    color: #2c3e50;
                    font-size: 20px;
                    border-bottom: 1px solid #ecf0f1;
                    padding-bottom: 5px;
                    margin-bottom: 15px;
                }
                
                .guide-problem {
                    background-color: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 4px;
                    padding: 15px;
                    margin-bottom: 20px;
                }
                
                .guide-problem h4 {
                    color: #e74c3c;
                    font-size: 18px;
                    margin-bottom: 10px;
                }
                
                .guide-symptoms {
                    margin-bottom: 15px;
                }
                
                .guide-symptoms h5, .guide-steps h5, .guide-resolution h5 {
                    color: #2c3e50;
                    font-size: 16px;
                    margin-bottom: 10px;
                }
                
                .guide-command {
                    background-color: #2c3e50;
                    color: #ecf0f1;
                    padding: 8px;
                    border-radius: 4px;
                    font-family: monospace;
                    margin: 10px 0;
                    overflow-x: auto;
                    white-space: nowrap;
                }
                
                .guide-code {
                    background-color: #2c3e50;
                    color: #ecf0f1;
                    padding: 12px;
                    border-radius: 4px;
                    font-family: monospace;
                    margin: 10px 0;
                    white-space: pre;
                    overflow-x: auto;
                }
                
                .guide-resolution {
                    background-color: #e1f5fe;
                    border-left: 4px solid #03a9f4;
                    padding: 10px 15px;
                    margin-top: 15px;
                }
                
                .guide-commands {
                    margin-bottom: 20px;
                }
                
                .guide-commands h4 {
                    color: #3498db;
                    font-size: 18px;
                    margin-bottom: 10px;
                }
                
                .guide-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 20px;
                }
                
                .guide-table th, .guide-table td {
                    border: 1px solid #e9ecef;
                    padding: 8px;
                    text-align: left;
                }
                
                .guide-table th {
                    background-color: #f8f9fa;
                    font-weight: 600;
                }
                
                .guide-table code {
                    background-color: #f8f9fa;
                    padding: 2px 5px;
                    border-radius: 4px;
                    font-family: monospace;
                }
                
                .guide-warning {
                    background-color: #fff3cd;
                    border-left: 4px solid #ffc107;
                    padding: 15px;
                    margin-top: 15px;
                    margin-bottom: 15px;
                }
                
                .guide-warning code {
                    background-color: #2c3e50;
                    color: #ecf0f1;
                    padding: 2px 5px;
                    border-radius: 4px;
                    font-family: monospace;
                }
                
                .guide-scenario {
                    margin-bottom: 20px;
                    padding: 15px;
                    background-color: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 4px;
                }
                
                .guide-scenario h4 {
                    color: #3498db;
                    font-size: 18px;
                    margin-bottom: 10px;
                }
                
                .guide-scenario h5 {
                    color: #2c3e50;
                    font-size: 16px;
                    margin-top: 15px;
                    margin-bottom: 10px;
                }
                
                .guide-snippets {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 20px;
                }
                
                .guide-snippet {
                    background-color: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 4px;
                    padding: 15px;
                }
                
                .guide-snippet h4 {
                    color: #2c3e50;
                    font-size: 16px;
                    margin-bottom: 10px;
                }
                
                @media print {
                    .guide-command, .guide-code {
                        background-color: #f8f9fa !important;
                        color: #333 !important;
                        border: 1px solid #ddd;
                    }
                    
                    .guide-problem, .guide-scenario, .guide-snippet {
                        break-inside: avoid;
                    }
                    
                    .guide-section {
                        page-break-after: always;
                    }
                    
                    .guide-section:last-child {
                        page-break-after: auto;
                    }
                }
            `;
            
            // Add style to document
            document.head.appendChild(style);
        },
        
        /**
         * Download troubleshooting guide as a file
         */
        downloadTroubleshootingGuide: function() {
            const troubleshootingPreview = document.getElementById('troubleshootingPreview');
            
            if (!troubleshootingPreview || !troubleshootingPreview.innerHTML) {
                alert('Please generate a troubleshooting guide first.');
                return;
            }
            
            // Create guide content
            const guideContent = `<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Network Authentication Troubleshooting Guide</title>
    <style>
        ${document.getElementById('guideStyle').textContent}
    </style>
</head>
<body>
    <div class="troubleshooting-preview">
        ${troubleshootingPreview.innerHTML}
    </div>
</body>
</html>`;
            
            // Create download link
            const link = document.createElement('a');
            link.href = 'data:text/html;charset=utf-8,' + encodeURIComponent(guideContent);
            link.download = 'network-authentication-troubleshooting-guide.html';
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    };

    // Initialize Documentation Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        DocumentationGenerator.init();
    });

    // Export to window
    window.DocumentationGenerator = DocumentationGenerator;
})();
