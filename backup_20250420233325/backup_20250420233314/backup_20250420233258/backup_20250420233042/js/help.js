/**
 * Dot1Xer Supreme Enterprise Edition - Help System
 * Version 4.1.0
 * 
 * This module provides help functionality, documentation, and contextual assistance.
 */

// Initialize help system when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Help System...');
    initHelpSystem();
});

// Global reference to help system
const HelpSystem = {
    // Show the help panel
    showHelpPanel: function() {
        const helpPanel = document.getElementById('help-panel');
        if (helpPanel) {
            helpPanel.classList.add('open');
        } else {
            createHelpPanel();
        }
    },
    
    // Hide the help panel
    hideHelpPanel: function() {
        const helpPanel = document.getElementById('help-panel');
        if (helpPanel) {
            helpPanel.classList.remove('open');
        }
    },
    
    // Show context-specific help
    showContextHelp: function(context) {
        const helpPanel = document.getElementById('help-panel');
        if (!helpPanel) {
            createHelpPanel();
        }
        
        // Show panel
        document.getElementById('help-panel').classList.add('open');
        
        // Load context-specific content
        loadHelpContent(context);
    }
};

// Initialize the help system
function initHelpSystem() {
    // Create help panel if it doesn't exist
    if (!document.getElementById('help-panel')) {
        createHelpPanel();
    }
    
    // Set up help buttons and links
    setupHelpTriggers();
    
    // Make help system globally available
    window.HelpSystem = HelpSystem;
}

// Create the help panel
function createHelpPanel() {
    // Create help panel element
    const helpPanel = document.createElement('div');
    helpPanel.id = 'help-panel';
    helpPanel.className = 'help-panel';
    
    // Create panel content
    helpPanel.innerHTML = `
        <div class="help-panel-header">
            <h3>Help & Documentation</h3>
            <button id="help-panel-close" class="help-panel-close">&times;</button>
        </div>
        
        <div class="help-search">
            <input type="text" id="help-search-input" placeholder="Search help topics...">
        </div>
        
        <div class="help-panel-content" id="help-panel-content">
            <div class="help-content">
                <h1>802.1X Configuration Assistant</h1>
                <p>Welcome to the Dot1Xer Supreme Enterprise Edition help system. This tool helps you configure 802.1X authentication on various network devices.</p>
                
                <h2>Getting Started</h2>
                <p>To create a configuration:</p>
                <ol>
                    <li>Select a vendor and platform</li>
                    <li>Configure authentication settings</li>
                    <li>Set security options</li>
                    <li>Define network parameters</li>
                    <li>Set advanced options</li>
                    <li>Generate and review your configuration</li>
                </ol>
                
                <h2>Common Tasks</h2>
                <ul>
                    <li><a href="#" data-help-topic="vendor-selection">Selecting a Vendor</a></li>
                    <li><a href="#" data-help-topic="authentication-methods">Authentication Methods</a></li>
                    <li><a href="#" data-help-topic="radius-configuration">RADIUS Configuration</a></li>
                    <li><a href="#" data-help-topic="deployment-strategies">Deployment Strategies</a></li>
                    <li><a href="#" data-help-topic="troubleshooting">Troubleshooting</a></li>
                </ul>
                
                <h2>Need More Help?</h2>
                <p>Click on any section-specific help icon <span class="help-icon">?</span> or use the search bar above to find specific topics.</p>
            </div>
        </div>
    `;
    
    // Add to document
    document.body.appendChild(helpPanel);
    
    // Set up close button
    const closeButton = document.getElementById('help-panel-close');
    if (closeButton) {
        closeButton.addEventListener('click', function() {
            helpPanel.classList.remove('open');
        });
    }
    
    // Set up search functionality
    const searchInput = document.getElementById('help-search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            searchHelpTopics(this.value);
        });
    }
    
    // Set up help topic links
    setupHelpTopicLinks();
}

// Set up help triggers (buttons and links)
function setupHelpTriggers() {
    // Main help link
    const helpLink = document.getElementById('help-link');
    if (helpLink) {
        helpLink.addEventListener('click', function(e) {
            e.preventDefault();
            HelpSystem.showHelpPanel();
        });
    }
    
    // Footer help link
    const footerHelpLink = document.getElementById('help-footer');
    if (footerHelpLink) {
        footerHelpLink.addEventListener('click', function(e) {
            e.preventDefault();
            HelpSystem.showHelpPanel();
        });
    }
    
    // Add help icons to form labels
    addHelpIconsToLabels();
}

// Add help icons to form labels
function addHelpIconsToLabels() {
    // Select all form labels
    const labels = document.querySelectorAll('.form-group label');
    
    // Add help icon to each label
    labels.forEach(label => {
        // Get form field ID from label's "for" attribute
        const fieldId = label.getAttribute('for');
        if (!fieldId) return;
        
        // Check if there's help content available for this field
        const helpContent = getHelpContentForField(fieldId);
        if (!helpContent) return;
        
        // Don't add help icon if it already has one
        if (label.querySelector('.help-icon')) return;
        
        // Create help icon
        const helpIcon = document.createElement('span');
        helpIcon.className = 'help-icon';
        helpIcon.textContent = '?';
        helpIcon.setAttribute('data-help-field', fieldId);
        
        // Add tooltip
        const tooltip = document.createElement('span');
        tooltip.className = 'tooltip-text';
        tooltip.innerHTML = helpContent.short || 'Click for help';
        helpIcon.appendChild(tooltip);
        
        // Add click event
        helpIcon.addEventListener('click', function(e) {
            e.stopPropagation();
            showFieldHelp(fieldId);
        });
        
        // Append to label
        label.appendChild(helpIcon);
    });
}

// Show help for a specific field
function showFieldHelp(fieldId) {
    const helpContent = getHelpContentForField(fieldId);
    if (!helpContent) return;
    
    // Open help panel
    HelpSystem.showHelpPanel();
    
    // Set content
    const helpPanelContent = document.getElementById('help-panel-content');
    if (helpPanelContent) {
        helpPanelContent.innerHTML = `
            <div class="help-content">
                <h1>${helpContent.title}</h1>
                ${helpContent.content}
                <div class="context-help">
                    <h4>Related Topics</h4>
                    <ul>
                        ${helpContent.related.map(topic => `<li><a href="#" data-help-topic="${topic.id}">${topic.title}</a></li>`).join('')}
                    </ul>
                </div>
            </div>
        `;
        
        // Set up help topic links
        setupHelpTopicLinks();
    }
}

// Set up help topic links
function setupHelpTopicLinks() {
    const topicLinks = document.querySelectorAll('[data-help-topic]');
    
    topicLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const topicId = this.getAttribute('data-help-topic');
            loadHelpContent(topicId);
        });
    });
}

// Load help content for a specific topic
function loadHelpContent(topicId) {
    const helpContent = getHelpTopic(topicId);
    if (!helpContent) return;
    
    const helpPanelContent = document.getElementById('help-panel-content');
    if (helpPanelContent) {
        helpPanelContent.innerHTML = `
            <div class="help-content">
                <h1>${helpContent.title}</h1>
                ${helpContent.content}
                
                ${helpContent.related && helpContent.related.length > 0 ? `
                    <div class="context-help">
                        <h4>Related Topics</h4>
                        <ul>
                            ${helpContent.related.map(topic => `<li><a href="#" data-help-topic="${topic.id}">${topic.title}</a></li>`).join('')}
                        </ul>
                    </div>
                ` : ''}
            </div>
        `;
        
        // Set up help topic links
        setupHelpTopicLinks();
    }
}

// Search help topics
function searchHelpTopics(query) {
    if (!query || query.length < 2) {
        // Show default help content if search query is too short
        const helpPanelContent = document.getElementById('help-panel-content');
        if (helpPanelContent) {
            loadHelpContent('welcome');
        }
        return;
    }
    
    // Search through topics
    const results = [];
    for (const [topicId, topic] of Object.entries(helpTopics)) {
        const titleMatch = topic.title.toLowerCase().includes(query.toLowerCase());
        const contentMatch = topic.content.toLowerCase().includes(query.toLowerCase());
        
        if (titleMatch || contentMatch) {
            results.push({
                id: topicId,
                title: topic.title,
                snippet: getSearchSnippet(topic.content, query)
            });
        }
    }
    
    // Display results
    const helpPanelContent = document.getElementById('help-panel-content');
    if (helpPanelContent) {
        if (results.length > 0) {
            helpPanelContent.innerHTML = `
                <div class="help-content">
                    <h1>Search Results for "${query}"</h1>
                    <p>Found ${results.length} matching topics:</p>
                    
                    <div class="search-results">
                        ${results.map(result => `
                            <div class="search-result">
                                <h3><a href="#" data-help-topic="${result.id}">${result.title}</a></h3>
                                <p>${result.snippet}</p>
                            </div>
                        `).join('')}
                    </div>
                </div>
            `;
        } else {
            helpPanelContent.innerHTML = `
                <div class="help-content">
                    <h1>Search Results for "${query}"</h1>
                    <p>No matching topics found.</p>
                    
                    <h2>Suggested Topics</h2>
                    <ul>
                        <li><a href="#" data-help-topic="authentication-methods">Authentication Methods</a></li>
                        <li><a href="#" data-help-topic="radius-configuration">RADIUS Configuration</a></li>
                        <li><a href="#" data-help-topic="deployment-strategies">Deployment Strategies</a></li>
                    </ul>
                </div>
            `;
        }
        
        // Set up help topic links
        setupHelpTopicLinks();
    }
}

// Get a snippet of text containing the search query
function getSearchSnippet(content, query) {
    // Strip HTML tags
    const plainText = content.replace(/<[^>]*>/g, ' ');
    
    // Find the position of the query
    const position = plainText.toLowerCase().indexOf(query.toLowerCase());
    
    if (position === -1) {
        // If not found, return the first 150 characters
        return plainText.substring(0, 150) + '...';
    }
    
    // Show text around the match
    const start = Math.max(0, position - 75);
    const end = Math.min(plainText.length, position + query.length + 75);
    let snippet = plainText.substring(start, end);
    
    // Add ellipsis if needed
    if (start > 0) {
        snippet = '...' + snippet;
    }
    
    if (end < plainText.length) {
        snippet = snippet + '...';
    }
    
    // Highlight the query
    const highlightedSnippet = snippet.replace(new RegExp(query, 'gi'), match => `<strong>${match}</strong>`);
    
    return highlightedSnippet;
}

// Get help content for a specific field
function getHelpContentForField(fieldId) {
    // Map of field IDs to help topics
    const fieldHelpMap = {
        'auth-method': {
            title: 'Authentication Method',
            short: 'Choose how devices authenticate to your network',
            content: `
                <p>The authentication method determines how devices will gain access to your network.</p>
                
                <h2>Available Options</h2>
                <ul>
                    <li><strong>802.1X Only</strong>: Requires 802.1X supplicant software on all devices. Most secure option.</li>
                    <li><strong>MAC Authentication Bypass Only</strong>: Authenticates devices based on MAC address. Less secure but works for devices without 802.1X support.</li>
                    <li><strong>802.1X with MAB Fallback</strong>: Tries 802.1X first, falls back to MAB if 802.1X fails. Good balance for mixed environments.</li>
                    <li><strong>802.1X and MAB Concurrent</strong>: Tries both authentication methods simultaneously. Fastest authentication but more complex.</li>
                    <li><strong>802.1X + MAB + WebAuth</strong>: Adds web authentication as a final fallback. Most flexible but complex to configure.</li>
                </ul>
                
                <h2>Recommended Use</h2>
                <p>For most enterprise environments, "802.1X with MAB Fallback" provides the best balance of security and compatibility.</p>
            `,
            related: [
                { id: 'host-mode', title: 'Host Mode' },
                { id: 'authentication-flow', title: 'Authentication Flow' },
                { id: 'mab-configuration', title: 'MAC Authentication Bypass' }
            ]
        },
        'auth-mode': {
            title: 'Authentication Mode',
            short: 'Determine if authentication is enforced or monitored',
            content: `
                <p>The authentication mode determines whether 802.1X is enforced or just monitored.</p>
                
                <h2>Available Options</h2>
                <ul>
                    <li><strong>Open (Monitor Mode)</strong>: Authentication is attempted but not enforced. All traffic is allowed regardless of authentication status. Use this for initial deployments and testing.</li>
                    <li><strong>Closed (Enforced Mode)</strong>: Authentication is enforced. Only authenticated devices can access the network. This is the secure production setting.</li>
                </ul>
                
                <h2>Deployment Recommendation</h2>
                <p>Start with "Open" mode during your deployment phase to monitor authentication attempts without disrupting network access. Once most devices are authenticating successfully, switch to "Closed" mode.</p>
            `,
            related: [
                { id: 'deployment-strategies', title: 'Deployment Strategies' },
                { id: 'monitor-mode', title: 'Monitor Mode Deployment' },
                { id: 'phased-deployment', title: 'Phased Deployment' }
            ]
        },
        'host-mode': {
            title: 'Host Mode',
            short: 'Control how many devices can authenticate on a port',
            content: `
                <p>Host mode determines how many devices can authenticate on a single switch port.</p>
                
                <h2>Available Options</h2>
                <ul>
                    <li><strong>Multi-Auth (Multiple Devices)</strong>: Allows multiple devices to independently authenticate on the same port. Each device gets individual authentication.</li>
                    <li><strong>Multi-Domain (1 Data + 1 Voice)</strong>: Allows one data device and one voice device on the same port. Common for IP phone deployments with a computer connected through the phone.</li>
                    <li><strong>Single-Host (1 Device Total)</strong>: Allows only one device per port. Most restrictive and secure option.</li>
                    <li><strong>Multi-Host (1 Auth, Multiple Devices)</strong>: One device authenticates, then all devices are allowed. Least secure option but useful for hubs or unmanaged switches.</li>
                </ul>
                
                <h2>Recommended Use</h2>
                <p>For most modern environments, "Multi-Auth" provides the best flexibility. Use "Multi-Domain" if you have IP phones with computers connected through them.</p>
            `,
            related: [
                { id: 'auth-method', title: 'Authentication Method' },
                { id: 'voice-vlan', title: 'Voice VLAN Configuration' },
                { id: 'ip-phones', title: 'IP Phone Deployment' }
            ]
        },
        'radius-server-1': {
            title: 'Primary RADIUS Server',
            short: 'Specify your main RADIUS server IP address',
            content: `
                <p>The primary RADIUS server is the main authentication server that validates user and device credentials.</p>
                
                <h2>Configuration Details</h2>
                <ul>
                    <li>Enter the IP address of your RADIUS server (e.g., 10.1.1.100)</li>
                    <li>Ensure the switch has network connectivity to this server</li>
                    <li>The RADIUS server must be configured to accept authentication requests from the switch IP address</li>
                </ul>
                
                <h2>Common RADIUS Servers</h2>
                <ul>
                    <li>Cisco ISE</li>
                    <li>Aruba ClearPass</li>
                    <li>Microsoft NPS</li>
                    <li>FreeRADIUS</li>
                </ul>
                
                <p>For production environments, configuring at least one secondary RADIUS server is strongly recommended for redundancy.</p>
            `,
            related: [
                { id: 'radius-secret-1', title: 'RADIUS Shared Secret' },
                { id: 'radius-server-2', title: 'Secondary RADIUS Server' },
                { id: 'radius-configuration', title: 'RADIUS Configuration' }
            ]
        },
        'use-macsec': {
            title: 'MACsec (802.1AE)',
            short: 'Enable Layer 2 encryption between devices',
            content: `
                <p>MACsec (802.1AE) provides Layer 2 encryption for traffic between the client and the switch, protecting against eavesdropping and man-in-the-middle attacks on the physical network.</p>
                
                <h2>Key Benefits</h2>
                <ul>
                    <li>Provides line-rate encryption of all traffic on the link</li>
                    <li>Ensures data confidentiality, integrity, and authenticity</li>
                    <li>Protects against physical layer attacks like cable tapping</li>
                    <li>Works with 802.1X to create a secure authenticated and encrypted link</li>
                </ul>
                
                <h2>Requirements</h2>
                <ul>
                    <li>Both the switch and the client device must support MACsec</li>
                    <li>Typically requires hardware support in the network interface</li>
                    <li>Usually requires EAP-TLS or similar authentication that can generate encryption keys</li>
                </ul>
                
                <p>Note: MACsec is a premium security feature that may not be supported on all hardware.</p>
            `,
            related: [
                { id: 'security-features', title: 'Security Features' },
                { id: 'eap-tls', title: 'EAP-TLS Authentication' },
                { id: 'encryption', title: 'Network Encryption Options' }
            ]
        },
        'use-radsec': {
            title: 'RadSec (RADIUS over TLS)',
            short: 'Encrypt RADIUS traffic for enhanced security',
            content: `
                <p>RadSec encapsulates RADIUS traffic inside TLS tunnels, providing encryption for RADIUS communication between the switch and the authentication server.</p>
                
                <h2>Key Benefits</h2>
                <ul>
                    <li>Encrypts RADIUS traffic, protecting sensitive authentication data</li>
                    <li>Provides mutual authentication between RADIUS client and server</li>
                    <li>Improves reliability through TCP-based transport</li>
                    <li>Can traverse NAT and firewalls more effectively than UDP-based RADIUS</li>
                </ul>
                
                <h2>Requirements</h2>
                <ul>
                    <li>Both the switch and RADIUS server must support RadSec</li>
                    <li>Valid certificates for TLS authentication</li>
                    <li>Proper certificate verification and trust chain configuration</li>
                </ul>
                
                <p>Note: RadSec is a newer feature that may not be supported on all platforms.</p>
            `,
            related: [
                { id: 'radius-configuration', title: 'RADIUS Configuration' },
                { id: 'security-features', title: 'Security Features' },
                { id: 'certificates', title: 'Certificate Management' }
            ]
        },
        'enable-dhcp-snooping': {
            title: 'DHCP Snooping',
            short: 'Protect against rogue DHCP servers',
            content: `
                <p>DHCP Snooping is a security feature that validates DHCP messages and builds a binding database of legitimate IP-to-MAC mappings.</p>
                
                <h2>Key Benefits</h2>
                <ul>
                    <li>Prevents rogue DHCP servers from distributing incorrect IP addresses</li>
                    <li>Creates a binding database that can be used by other security features</li>
                    <li>Blocks DHCP responses from unauthorized ports</li>
                    <li>Provides foundation for IP Source Guard and Dynamic ARP Inspection</li>
                </ul>
                
                <h2>Configuration Considerations</h2>
                <ul>
                    <li>Must mark uplink ports and ports connected to legitimate DHCP servers as trusted</li>
                    <li>All access ports should be untrusted</li>
                    <li>Rate limiting should be applied to prevent DoS attacks</li>
                </ul>
                
                <p>DHCP Snooping is highly recommended alongside 802.1X for comprehensive security.</p>
            `,
            related: [
                { id: 'enable-dai', title: 'Dynamic ARP Inspection' },
                { id: 'enable-ipsg', title: 'IP Source Guard' },
                { id: 'security-features', title: 'Security Features' }
            ]
        },
    };
    
    return fieldHelpMap[fieldId];
}

// Get a specific help topic
function getHelpTopic(topicId) {
    return helpTopics[topicId] || helpTopics['welcome'];
}

// Help topics
const helpTopics = {
    'welcome': {
        title: '802.1X Configuration Assistant',
        content: `
            <p>Welcome to the Dot1Xer Supreme Enterprise Edition help system. This tool helps you configure 802.1X authentication on various network devices.</p>
            
            <h2>Getting Started</h2>
            <p>To create a configuration:</p>
            <ol>
                <li>Select a vendor and platform</li>
                <li>Configure authentication settings</li>
                <li>Set security options</li>
                <li>Define network parameters</li>
                <li>Set advanced options</li>
                <li>Generate and review your configuration</li>
            </ol>
            
            <h2>Common Tasks</h2>
            <ul>
                <li><a href="#" data-help-topic="vendor-selection">Selecting a Vendor</a></li>
                <li><a href="#" data-help-topic="authentication-methods">Authentication Methods</a></li>
                <li><a href="#" data-help-topic="radius-configuration">RADIUS Configuration</a></li>
                <li><a href="#" data-help-topic="deployment-strategies">Deployment Strategies</a></li>
                <li><a href="#" data-help-topic="troubleshooting">Troubleshooting</a></li>
            </ul>
            
            <h2>Need More Help?</h2>
            <p>Click on any section-specific help icon <span class="help-icon">?</span> or use the search bar above to find specific topics.</p>
        `,
        related: [
            { id: 'about', title: 'About This Tool' },
            { id: 'whats-new', title: 'What\'s New' },
            { id: '802.1x-overview', title: '802.1X Overview' }
        ]
    },
    'vendor-selection': {
        title: 'Selecting a Vendor',
        content: `
            <p>The first step in creating an 802.1X configuration is selecting the vendor and specific platform of your network device.</p>
            
            <h2>Supported Vendors</h2>
            <p>Dot1Xer Supreme Enterprise Edition supports the following vendors:</p>
            <ul>
                <li><strong>Cisco</strong>: IOS, IOS-XE, NX-OS, and ISE</li>
                <li><strong>Aruba</strong>: AOS-CX, AOS-Switch, ClearPass</li>
                <li><strong>Juniper</strong>: JunOS, EX Series, SRX Series</li>
                <li><strong>HP</strong>: ProCurve, Comware</li>
                <li><strong>Extreme</strong>: EXOS, VOSS</li>
                <li><strong>Fortinet</strong>: FortiSwitch, FortiGate, FortiNAC</li>
                <li><strong>Dell</strong>: OS10, OS9</li>
                <li><strong>Huawei</strong>: VRP, S-Series</li>
                <li><strong>Ruckus</strong>: ICX, FastIron, SmartZone</li>
                <li><strong>And more...</strong></li>
            </ul>
            
            <h2>Platform Selection</h2>
            <p>After selecting a vendor, choose the specific platform or operating system. Different platforms within the same vendor may have different command syntax or feature support.</p>
            
            <h2>Software Version</h2>
            <p>Some 802.1X features may require specific software versions. Enter your device's software version to ensure compatibility with generated configurations.</p>
        `,
        related: [
            { id: 'platform-compatibility', title: 'Platform Compatibility' },
            { id: 'feature-support', title: 'Feature Support Matrix' },
            { id: 'software-requirements', title: 'Software Requirements' }
        ]
    },
    'authentication-methods': {
        title: 'Authentication Methods',
        content: `
            <p>802.1X authentication can be configured in several ways, depending on your network requirements and device capabilities.</p>
            
            <h2>802.1X Only</h2>
            <p>The most secure option, requiring all devices to have 802.1X supplicant software. Devices without proper supplicants cannot access the network.</p>
            
            <h2>MAC Authentication Bypass (MAB)</h2>
            <p>Allows devices without 802.1X support to authenticate based on their MAC address. Less secure than 802.1X but necessary for devices like printers, IP phones, and IoT devices.</p>
            
            <h2>802.1X with MAB Fallback</h2>
            <p>Tries 802.1X authentication first, then falls back to MAB if 802.1X fails. This provides a good balance of security and compatibility for mixed environments.</p>
            
            <h2>Concurrent Authentication</h2>
            <p>Attempts both 802.1X and MAB simultaneously to reduce authentication time. More complex to configure but can improve user experience.</p>
            
            <h2>WebAuth Fallback</h2>
            <p>Adds web authentication as a final fallback method, redirecting users to a captive portal. Useful for guest access or BYOD scenarios.</p>
            
            <h2>Choosing the Right Method</h2>
            <p>Most enterprise environments should use "802.1X with MAB Fallback" for the best balance of security and compatibility. Use the following guidelines:</p>
            <ul>
                <li>If all devices support 802.1X: Use "802.1X Only"</li>
                <li>If you have mixed devices: Use "802.1X with MAB Fallback"</li>
                <li>If fast authentication is critical: Use "Concurrent Authentication"</li>
                <li>If you need guest access: Include "WebAuth Fallback"</li>
            </ul>
        `,
        related: [
            { id: 'mab-configuration', title: 'MAC Authentication Bypass' },
            { id: 'eap-methods', title: 'EAP Methods' },
            { id: 'webauth', title: 'Web Authentication' }
        ]
    },
    'radius-configuration': {
        title: 'RADIUS Configuration',
        content: `
            <p>RADIUS (Remote Authentication Dial-In User Service) is the authentication server that validates credentials during 802.1X authentication.</p>
            
            <h2>Primary and Secondary Servers</h2>
            <p>Always configure at least two RADIUS servers for redundancy. If the primary server becomes unreachable, the switch will fail over to the secondary server.</p>
            
            <h2>Shared Secret</h2>
            <p>The shared secret is a password used to authenticate and encrypt communication between the switch and RADIUS server. Use a strong, unique shared secret for each network device.</p>
            
            <h2>Ports</h2>
            <p>Standard RADIUS ports are 1812 for authentication and 1813 for accounting. Some legacy servers may use 1645 and 1646 instead.</p>
            
            <h2>RADIUS Server Config</h2>
            <p>Remember to configure your RADIUS server to:</p>
            <ul>
                <li>Accept authentication requests from your switch IP addresses</li>
                <li>Apply the same shared secret configured on the switch</li>
                <li>Define appropriate authorization policies for authenticated users</li>
                <li>Configure VLAN assignments and other attributes as needed</li>
            </ul>
            
            <h2>Advanced RADIUS Features</h2>
            <p>Consider these advanced features for enhanced security and functionality:</p>
            <ul>
                <li><strong>Change of Authorization (CoA)</strong>: Allows the RADIUS server to dynamically change session attributes</li>
                <li><strong>RADIUS Accounting</strong>: Tracks session information for billing or auditing</li>
                <li><strong>RadSec</strong>: Encrypts RADIUS traffic using TLS</li>
                <li><strong>Attribute Format</strong>: Ensure correct attribute format for your specific RADIUS server</li>
            </ul>
        `,
        related: [
            { id: 'radius-coa', title: 'RADIUS Change of Authorization' },
            { id: 'radius-accounting', title: 'RADIUS Accounting' },
            { id: 'radius-attributes', title: 'RADIUS Attributes' }
        ]
    },
    'deployment-strategies': {
        title: 'Deployment Strategies',
        content: `
            <p>802.1X should be deployed using a phased approach to minimize disruption and identify issues early.</p>
            
            <h2>Phased Deployment Approach</h2>
            <ol>
                <li><strong>Planning Phase</strong>: Inventory devices, identify authentication methods, prepare RADIUS infrastructure</li>
                <li><strong>Monitor Mode</strong>: Enable 802.1X but don't enforce it. Monitor authentication successes and failures.</li>
                <li><strong>Low Impact Mode</strong>: Enable enforcement with fallback mechanisms like guest VLAN</li>
                <li><strong>Full Enforcement</strong>: Move to closed mode with full security</li>
            </ol>
            
            <h2>Monitor Mode</h2>
            <p>Monitor mode (also called "open mode" on some platforms) allows all traffic regardless of authentication status. This lets you identify which devices are successfully authenticating without disrupting network access.</p>
            
            <p>Recommended duration: 2-4 weeks</p>
            
            <h2>Low Impact Mode</h2>
            <p>Low impact mode enforces authentication but provides fallback mechanisms:</p>
            <ul>
                <li>Guest VLAN for devices that don't attempt authentication</li>
                <li>Auth-fail VLAN for devices with failed authentication</li>
                <li>Critical VLAN for when RADIUS servers are unreachable</li>
            </ul>
            
            <p>Recommended duration: 2-3 weeks</p>
            
            <h2>Full Enforcement</h2>
            <p>In this final phase, move to full closed-mode enforcement. Unauthenticated devices will not have network access except through specifically configured fallback mechanisms.</p>
            
            <h2>Deployment Scope</h2>
            <p>Consider these approaches for large networks:</p>
            <ul>
                <li><strong>Pilot Group</strong>: Deploy to a small group of technical users first</li>
                <li><strong>Department by Department</strong>: Roll out to one department at a time</li>
                <li><strong>Location by Location</strong>: Deploy by physical location</li>
            </ul>
        `,
        related: [
            { id: 'monitor-mode', title: 'Monitor Mode Configuration' },
            { id: 'guest-vlan', title: 'Guest VLAN Configuration' },
            { id: 'rollback-plan', title: 'Rollback Planning' }
        ]
    },
    'troubleshooting': {
        title: 'Troubleshooting 802.1X',
        content: `
            <p>802.1X issues can occur at various points in the authentication process. Here's how to troubleshoot common problems.</p>
            
            <h2>Common Issues</h2>
            
            <h3>Authentication Failures</h3>
            <ul>
                <li><strong>RADIUS Server Unreachable</strong>: Check network connectivity and RADIUS server status</li>
                <li><strong>Incorrect Shared Secret</strong>: Verify the shared secret matches on both switch and server</li>
                <li><strong>EAP Method Mismatch</strong>: Ensure the client and server support the same EAP methods</li>
                <li><strong>Certificate Issues</strong>: Verify certificates are valid and trusted for EAP-TLS</li>
                <li><strong>User Credentials</strong>: Check that username and password are correct</li>
            </ul>
            
            <h3>VLAN Assignment Issues</h3>
            <ul>
                <li><strong>Incorrect RADIUS Attributes</strong>: Verify server is sending correct Tunnel-Type, Tunnel-Medium-Type, and Tunnel-Private-Group-ID</li>
                <li><strong>Missing VLAN</strong>: Ensure the VLAN exists on the switch</li>
                <li><strong>Attribute Format</strong>: Check if VLAN ID is sent as string or integer based on vendor requirements</li>
            </ul>
            
            <h3>Timeout Issues</h3>
            <ul>
                <li><strong>Excessive Authentication Delays</strong>: Adjust timers like tx-period and quiet-period</li>
                <li><strong>RADIUS Server Overload</strong>: Consider load balancing or additional servers</li>
                <li><strong>Network Latency</strong>: Check for network congestion between switch and RADIUS</li>
            </ul>
            
            <h2>Troubleshooting Commands</h2>
            <p>Use these vendor-specific commands to troubleshoot 802.1X issues:</p>
            
            <h3>Cisco</h3>
            <pre>show authentication sessions
show authentication sessions interface GigabitEthernet1/0/1 details
debug dot1x all
debug radius authentication</pre>
            
            <h3>Aruba</h3>
            <pre>show port-access authenticator
show port-access authenticator 1/1 detail
debug security port-access authenticator</pre>
            
            <h3>Juniper</h3>
            <pre>show dot1x interface
show dot1x interface detail
show dot1x authentication-failed-users</pre>
        `,
        related: [
            { id: 'radius-troubleshooting', title: 'RADIUS Troubleshooting' },
            { id: 'client-troubleshooting', title: 'Client Troubleshooting' },
            { id: 'logging', title: 'Logging and Debugging' }
        ]
    }
};
