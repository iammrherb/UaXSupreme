/**
 * Dot1Xer Supreme Enterprise Edition - Help System
<<<<<<< HEAD
 * Version 4.0.0
 * 
 * This file handles the help system functionality including context-sensitive help,
 * documentation display, and searchable help topics.
 */

// Help System object
const HelpSystem = {
    // Currently displayed help topic
    currentTopic: '',
    
    // Search query
    searchQuery: '',
    
    // Help topics
    topics: {
        '802.1x-overview': {
            title: '802.1X Overview',
            content: `
                <h1>802.1X Overview</h1>
                <p>IEEE 802.1X is a standard for port-based Network Access Control (PNAC) that provides an authentication mechanism for devices connecting to a wired or wireless LAN.</p>
                
                <h2>Key Components</h2>
                <ul>
                    <li><strong>Supplicant</strong>: The client device requesting access to the network</li>
                    <li><strong>Authenticator</strong>: The network device (switch, access point) that facilitates the authentication process</li>
                    <li><strong>Authentication Server</strong>: Usually a RADIUS server that validates credentials</li>
                </ul>
                
                <h2>Authentication Process</h2>
                <ol>
                    <li>The supplicant sends an EAPOL-Start message to the authenticator</li>
                    <li>The authenticator responds with an EAP-Request/Identity packet</li>
                    <li>The supplicant provides identity information</li>
                    <li>The authenticator forwards this to the authentication server</li>
                    <li>The authentication server validates credentials and informs the authenticator</li>
                    <li>The authenticator grants or denies access to the network</li>
                </ol>
                
                <h2>Benefits</h2>
                <ul>
                    <li>Enhanced security through port-based access control</li>
                    <li>Centralized authentication management</li>
                    <li>Dynamic VLAN assignment based on user identity</li>
                    <li>Integration with existing identity stores (AD, LDAP)</li>
                    <li>Auditing and accounting capabilities</li>
                </ul>
            `
        },
        'authentication-methods': {
            title: 'Authentication Methods',
            content: `
                <h1>802.1X Authentication Methods</h1>
                
                <h2>Standard 802.1X</h2>
                <p>Traditional 802.1X authentication requires a supplicant on the client device. This is the most secure option but requires client support.</p>
                
                <h2>MAC Authentication Bypass (MAB)</h2>
                <p>MAB allows devices without 802.1X capability to authenticate based on their MAC address. The switch forwards the client's MAC address to the authentication server for validation.</p>
                <p>Useful for: Printers, IP phones, legacy devices without 802.1X support</p>
                
                <h2>Web Authentication (WebAuth)</h2>
                <p>Web Authentication uses a captive portal to authenticate users through a web browser. When users attempt to access the network, they are redirected to a login page.</p>
                <p>Useful for: Guest access, BYOD environments</p>
                
                <h2>Flexible Authentication</h2>
                <p>Combinations of the above methods in sequence or simultaneously:</p>
                <ul>
                    <li><strong>802.1X with MAB Fallback</strong>: Attempts 802.1X first, then falls back to MAB if 802.1X fails</li>
                    <li><strong>802.1X and MAB Concurrent</strong>: Attempts both authentication methods simultaneously</li>
                    <li><strong>Multi-step (802.1X + MAB + WebAuth)</strong>: Tries methods in sequence with various fallback options</li>
                </ul>
                
                <h2>EAP Methods</h2>
                <p>Several EAP methods can be used with 802.1X:</p>
                <ul>
                    <li><strong>EAP-TLS</strong>: Certificate-based mutual authentication (strongest security)</li>
                    <li><strong>PEAP</strong>: Protected EAP, typically with MSCHAPv2 for password authentication</li>
                    <li><strong>EAP-TTLS</strong>: Tunneled TLS, supports legacy authentication protocols</li>
                    <li><strong>EAP-FAST</strong>: Flexible Authentication via Secure Tunneling</li>
                </ul>
            `
        },
        'radius-config': {
            title: 'RADIUS Configuration',
            content: `
                <h1>RADIUS Configuration</h1>
                
                <p>RADIUS (Remote Authentication Dial-In User Service) is the primary authentication protocol used with 802.1X deployments.</p>
                
                <h2>Key RADIUS Components</h2>
                <ul>
                    <li><strong>RADIUS Server</strong>: Authenticates users and provides authorization attributes</li>
                    <li><strong>RADIUS Client</strong>: The network device (switch/WAP) that forwards authentication requests</li>
                    <li><strong>Shared Secret</strong>: A password shared between the RADIUS server and client for secure communication</li>
                </ul>
                
                <h2>RADIUS Server Configuration</h2>
                <p>When configuring RADIUS servers, consider:</p>
                <ul>
                    <li><strong>Primary and Secondary Servers</strong>: Always configure at least two servers for redundancy</li>
                    <li><strong>Authentication Ports</strong>: Typically UDP 1812 for authentication, 1813 for accounting</li>
                    <li><strong>Shared Secret</strong>: Use a strong, unique shared secret for each network device</li>
                    <li><strong>Server Timeout</strong>: The time to wait for a response from the server (typically 5-10 seconds)</li>
                    <li><strong>Retransmit Count</strong>: How many times to retry before failing over to another server</li>
                </ul>
                
                <h2>RADIUS Attributes</h2>
                <p>Common RADIUS attributes used in 802.1X:</p>
                <ul>
                    <li><strong>Tunnel-Type</strong> (64): Set to VLAN (13) for VLAN assignment</li>
                    <li><strong>Tunnel-Medium-Type</strong> (65): Set to 802 (6) for VLAN assignment</li>
                    <li><strong>Tunnel-Private-Group-ID</strong> (81): The VLAN ID to assign</li>
                    <li><strong>Filter-ID</strong>: For ACL assignment on some platforms</li>
                </ul>
                
                <h2>RADIUS Security</h2>
                <ul>
                    <li><strong>RadSec</strong>: RADIUS over TLS for enhanced security</li>
                    <li><strong>CoA (Change of Authorization)</strong>: Allows RADIUS server to dynamically change authorization</li>
                    <li><strong>Accounting</strong>: Provides session tracking and auditing capabilities</li>
                </ul>
            `
        },
        'host-modes': {
            title: 'Host Modes',
            content: `
                <h1>802.1X Host Modes</h1>
                
                <p>Host modes determine how many devices can authenticate on a single port and how they are handled.</p>
                
                <h2>Single-Host Mode</h2>
                <p>Only one device can authenticate on the port. If a second device is detected, it may trigger a security violation depending on the configuration.</p>
                <p><strong>Best for</strong>: High-security environments where only one device per port is expected</p>
                <p><strong>Limitations</strong>: Not suitable for environments with IP phones or hubs/unmanaged switches</p>
                
                <h2>Multi-Host Mode</h2>
                <p>One device authenticates, and then all other devices on the port gain access. The first successful authentication opens the port for all traffic.</p>
                <p><strong>Best for</strong>: Environments where unmanaged switches or hubs are connected to the port</p>
                <p><strong>Limitations</strong>: Reduced security as one authenticated device grants access to all devices on the port</p>
                
                <h2>Multi-Domain Authentication Mode</h2>
                <p>Allows one voice device and one data device to authenticate independently. Commonly used for IP phone deployments where a computer connects through the phone.</p>
                <p><strong>Best for</strong>: IP phone + computer configurations</p>
                <p><strong>Limitations</strong>: Limited to only two devices (one voice, one data)</p>
                
                <h2>Multi-Authentication Mode</h2>
                <p>Multiple devices can authenticate independently on the same port. Each device is assigned to the appropriate VLAN based on its authentication result.</p>
                <p><strong>Best for</strong>: Modern environments with multiple devices per port</p>
                <p><strong>Limitations</strong>: May require more RADIUS resources; not supported on all platforms</p>
                
                <h2>Choosing the Right Host Mode</h2>
                <ul>
                    <li>Use <strong>Single-Host</strong> when maximum security is required and only one device will connect</li>
                    <li>Use <strong>Multi-Domain</strong> for IP phone deployments</li>
                    <li>Use <strong>Multi-Auth</strong> for general-purpose access where multiple devices may connect</li>
                    <li>Use <strong>Multi-Host</strong> only when unmanaged switches/hubs must be supported and security requirements are lower</li>
                </ul>
            `
        },
        'deployment-strategies': {
            title: 'Deployment Strategies',
            content: `
                <h1>802.1X Deployment Strategies</h1>
                
                <p>Successful 802.1X deployments require careful planning and a phased approach to minimize disruption.</p>
                
                <h2>Monitor Mode</h2>
                <p>Initially deploy 802.1X in monitor mode (also called "open mode" or "passive mode") where authentication is performed but not enforced. This allows you to identify potential issues before enforcement.</p>
                <p><strong>Implementation</strong>: Enable authentication with "authentication open" or equivalent command</p>
                <p><strong>Duration</strong>: Typically 2-4 weeks to gather data on authentication successes and failures</p>
                
                <h2>Low-Impact Mode</h2>
                <p>Begin enforcement with a fallback mechanism such as a guest VLAN for unauthenticated devices. This provides a safety net for devices that cannot authenticate.</p>
                <p><strong>Implementation</strong>: Configure guest VLAN and authentication failure VLAN</p>
                <p><strong>Duration</strong>: 2-4 weeks as you resolve issues with failing devices</p>
                
                <h2>Closed Mode</h2>
                <p>Full enforcement where unauthenticated devices have no network access except to authentication servers.</p>
                <p><strong>Implementation</strong>: Enable full port security with "authentication port-control auto"</p>
                
                <h2>Phased Deployment Approach</h2>
                <ol>
                    <li><strong>Planning and Design</strong>: Document network topology, device inventory, and authentication requirements</li>
                    <li><strong>Pilot Deployment</strong>: Test in a controlled environment with representative devices</li>
                    <li><strong>Monitor Mode Rollout</strong>: Deploy to production in monitor mode</li>
                    <li><strong>Low-Impact Enforcement</strong>: Begin enforcement with fallback options</li>
                    <li><strong>Full Enforcement</strong>: Move to closed mode once all issues are resolved</li>
                    <li><strong>Ongoing Management</strong>: Monitor, audit, and refine policies</li>
                </ol>
                
                <h2>Deployment Considerations</h2>
                <ul>
                    <li><strong>Special Device Handling</strong>: Identify devices that cannot support 802.1X and implement alternatives (MAB, exemption)</li>
                    <li><strong>User Communication</strong>: Inform users about the changes and provide instructions for supplicant configuration</li>
                    <li><strong>Help Desk Preparation</strong>: Train support staff on common issues and troubleshooting</li>
                    <li><strong>Rollback Plan</strong>: Have a procedure to quickly disable 802.1X if critical issues arise</li>
                </ul>
            `
        }
    },
    
    // Initialize help system
    init: function() {
        console.log('Initializing Help System...');
        
        // Add context help to form elements
        this.addContextHelp();
        
        // Set up help panel
        this.setupHelpPanel();
        
        // Add event handlers
        this.setupEventHandlers();
        
        console.log('Help System initialized');
    },
    
    // Add context-sensitive help to form elements
    addContextHelp: function() {
        // Help content for different elements
        const helpContent = {
            'auth-method': 'Choose the primary authentication method. 802.1X requires a client supplicant while MAB uses the device\'s MAC address for authentication.',
            'auth-mode': 'Open mode allows traffic before authentication (monitor mode), while Closed mode requires successful authentication before allowing traffic.',
            'host-mode': 'Controls how many devices can authenticate on a single port. Multi-Auth allows multiple devices, Multi-Domain allows one data device and one voice device.',
            'radius-server-1': 'IP address or hostname of your primary RADIUS server.',
            'radius-secret-1': 'Shared secret key used to secure communication with the RADIUS server.',
            'radius-server-2': 'Optional secondary RADIUS server for redundancy.',
            'reauth-period': 'Time in seconds before requiring reauthentication. Common values: 1 hour (3600s) to 24 hours (86400s).',
            'tx-period': 'Time in seconds between EAP retransmissions. Typically 30 seconds.',
            'quiet-period': 'Time in seconds to wait after failed authentication before trying again. Typically 60 seconds.',
            'max-reauth': 'Maximum number of times to retry authentication before failing.',
            'use-coa': 'Change of Authorization (CoA) allows the RADIUS server to dynamically change authorization attributes after authentication.',
            'enable-accounting': 'Enables RADIUS accounting for session tracking and auditing.',
            'use-macsec': 'MACsec (802.1AE) provides Layer 2 encryption for enhanced security.',
            'use-radsec': 'RadSec encrypts RADIUS traffic using TLS for enhanced security.',
            'vlan-auth': 'VLAN ID assigned to successfully authenticated devices.',
            'vlan-unauth': 'VLAN ID assigned to devices that fail authentication.',
            'vlan-guest': 'VLAN ID assigned to guest devices or devices waiting for authentication.',
            'vlan-voice': 'VLAN ID assigned to voice devices like IP phones.'
        };
        
        // Add help icons to elements
        for (const [elementId, content] of Object.entries(helpContent)) {
            const element = document.getElementById(elementId);
            if (!element) continue;
            
            // Find the label for this element
            const label = document.querySelector(`label[for="${elementId}"]`);
            if (!label) continue;
            
            // Create help icon
            const helpIcon = document.createElement('span');
            helpIcon.className = 'help-icon';
            helpIcon.innerHTML = '?';
            helpIcon.setAttribute('title', content);
            helpIcon.setAttribute('data-help', content);
            
            // Add tooltip functionality
            helpIcon.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                this.showContextHelp(elementId, content);
            });
            
            // Add help icon to label
            label.appendChild(helpIcon);
        }
    },
    
    // Set up the help panel
    setupHelpPanel: function() {
        // Check if help panel already exists
        if (document.getElementById('help-panel')) return;
        
        // Create help panel
        const helpPanel = document.createElement('div');
        helpPanel.id = 'help-panel';
        helpPanel.className = 'help-panel';
        
        // Create panel header
        const header = document.createElement('div');
        header.className = 'help-panel-header';
        
        const title = document.createElement('h3');
        title.textContent = 'Help Center';
        
        const closeButton = document.createElement('button');
        closeButton.className = 'help-panel-close';
        closeButton.innerHTML = '&times;';
        closeButton.addEventListener('click', this.hideHelpPanel.bind(this));
        
        header.appendChild(title);
        header.appendChild(closeButton);
        
        // Create search field
        const search = document.createElement('div');
        search.className = 'help-search';
        
        const searchInput = document.createElement('input');
        searchInput.type = 'text';
        searchInput.id = 'help-search-input';
        searchInput.placeholder = 'Search help topics...';
        searchInput.addEventListener('input', this.searchHelp.bind(this));
        
        search.appendChild(searchInput);
        
        // Create content area
        const content = document.createElement('div');
        content.className = 'help-panel-content';
        content.id = 'help-panel-content';
        
        // Add components to panel
        helpPanel.appendChild(header);
        helpPanel.appendChild(search);
        helpPanel.appendChild(content);
        
        // Add to document
        document.body.appendChild(helpPanel);
    },
    
    // Set up event handlers
    setupEventHandlers: function() {
        // Global handler for tooltip clicks
        document.addEventListener('click', (e) => {
            // Hide tooltips when clicking outside
            if (!e.target.closest('.tooltip')) {
                const tooltips = document.querySelectorAll('.tooltip-text');
                tooltips.forEach(tooltip => {
                    tooltip.style.visibility = 'hidden';
                    tooltip.style.opacity = '0';
                });
            }
        });
        
        // ESC key handler to close help panel
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.hideHelpPanel();
            }
        });
    },
    
    // Show context-specific help
    showContextHelp: function(elementId, content) {
        // Find element
        const element = document.getElementById(elementId);
        if (!element) return;
        
        // Create tooltip if not exists
        let tooltip = element.parentNode.querySelector('.tooltip');
        if (!tooltip) {
            tooltip = document.createElement('div');
            tooltip.className = 'tooltip';
            
            const tooltipText = document.createElement('span');
            tooltipText.className = 'tooltip-text';
            tooltipText.textContent = content;
            
            tooltip.appendChild(tooltipText);
            element.parentNode.appendChild(tooltip);
        }
        
        // Show tooltip
        const tooltipText = tooltip.querySelector('.tooltip-text');
        if (tooltipText) {
            tooltipText.style.visibility = 'visible';
            tooltipText.style.opacity = '1';
        }
    },
    
    // Show the help panel
    showHelpPanel: function() {
        const panel = document.getElementById('help-panel');
        if (panel) {
            panel.classList.add('open');
            
            // Show default help topics if no topic is selected
            if (!this.currentTopic) {
                this.showHelpTopics();
            }
=======
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
>>>>>>> 0b11660 (Updated UaXSupreme with improved functionality and fixed issues)
        }
    },
    
    // Hide the help panel
    hideHelpPanel: function() {
<<<<<<< HEAD
        const panel = document.getElementById('help-panel');
        if (panel) {
            panel.classList.remove('open');
        }
    },
    
    // Show available help topics
    showHelpTopics: function() {
        const content = document.getElementById('help-panel-content');
        if (!content) return;
        
        content.innerHTML = '';
        
        // Create topics header
        const header = document.createElement('h2');
        header.textContent = 'Help Topics';
        content.appendChild(header);
        
        // Create topics list
        const topicsList = document.createElement('div');
        topicsList.className = 'help-topics';
        
        // Add each topic
        for (const [id, topic] of Object.entries(this.topics)) {
            const topicItem = document.createElement('div');
            topicItem.className = 'help-topic';
            
            const topicTitle = document.createElement('h4');
            topicTitle.textContent = topic.title;
            
            const topicLink = document.createElement('a');
            topicLink.className = 'help-topic-link';
            topicLink.textContent = 'Read more';
            topicLink.href = '#';
            topicLink.setAttribute('data-topic', id);
            topicLink.addEventListener('click', (e) => {
                e.preventDefault();
                this.showTopic(id);
            });
            
            topicItem.appendChild(topicTitle);
            topicItem.appendChild(topicLink);
            topicsList.appendChild(topicItem);
        }
        
        content.appendChild(topicsList);
    },
    
    // Show a specific help topic
    showTopic: function(topicId) {
        const content = document.getElementById('help-panel-content');
        if (!content) return;
        
        // Get topic
        const topic = this.topics[topicId];
        if (!topic) return;
        
        // Set current topic
        this.currentTopic = topicId;
        
        // Display topic content
        content.innerHTML = '';
        
        // Add back button
        const backButton = document.createElement('button');
        backButton.className = 'btn';
        backButton.textContent = 'Back to Topics';
        backButton.addEventListener('click', () => {
            this.currentTopic = '';
            this.showHelpTopics();
        });
        
        // Add topic content
        const topicContent = document.createElement('div');
        topicContent.className = 'help-content';
        topicContent.innerHTML = topic.content;
        
        content.appendChild(backButton);
        content.appendChild(topicContent);
    },
    
    // Search help topics
    searchHelp: function(event) {
        const searchInput = event.target;
        const query = searchInput.value.toLowerCase();
        
        // Set search query
        this.searchQuery = query;
        
        // If search is empty, show all topics
        if (!query) {
            this.showHelpTopics();
            return;
        }
        
        // Search topics
        const results = [];
        
        for (const [id, topic] of Object.entries(this.topics)) {
            // Check title
            if (topic.title.toLowerCase().includes(query)) {
                results.push({
                    id,
                    title: topic.title,
                    relevance: 10
                });
                continue;
            }
            
            // Check content
            if (topic.content.toLowerCase().includes(query)) {
                results.push({
                    id,
                    title: topic.title,
                    relevance: 5
                });
            }
        }
        
        // Sort by relevance
        results.sort((a, b) => b.relevance - a.relevance);
        
        // Display results
        const content = document.getElementById('help-panel-content');
        if (!content) return;
        
        content.innerHTML = '';
        
        // Create results header
        const header = document.createElement('h2');
        header.textContent = `Search Results for "${query}"`;
        content.appendChild(header);
        
        // Create results list
        const resultsList = document.createElement('div');
        resultsList.className = 'help-topics';
        
        if (results.length === 0) {
            const noResults = document.createElement('p');
            noResults.textContent = 'No results found. Try a different search term.';
            resultsList.appendChild(noResults);
        } else {
            // Add each result
            results.forEach(result => {
                const resultItem = document.createElement('div');
                resultItem.className = 'help-topic';
                
                const resultTitle = document.createElement('h4');
                resultTitle.textContent = result.title;
                
                const resultLink = document.createElement('a');
                resultLink.className = 'help-topic-link';
                resultLink.textContent = 'Read more';
                resultLink.href = '#';
                resultLink.setAttribute('data-topic', result.id);
                resultLink.addEventListener('click', (e) => {
                    e.preventDefault();
                    this.showTopic(result.id);
                });
                
                resultItem.appendChild(resultTitle);
                resultItem.appendChild(resultLink);
                resultsList.appendChild(resultItem);
            });
        }
        
        content.appendChild(resultsList);
    }
};

// Make showHelpPanel accessible globally
window.HelpSystem = HelpSystem;

// Initialize the help system when the DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    HelpSystem.init();
});
=======
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
>>>>>>> 0b11660 (Updated UaXSupreme with improved functionality and fixed issues)
