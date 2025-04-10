/**
 * Dot1Xer Supreme Enterprise Edition - Help System
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
        }
    },
    
    // Hide the help panel
    hideHelpPanel: function() {
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
