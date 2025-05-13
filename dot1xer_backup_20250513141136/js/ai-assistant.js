/**
 * UaXSupreme - AI Assistant
 * Provides AI-powered assistance for network configuration
 */

(function() {
    'use strict';

    // AI Assistant object
    const AIAssistant = {
        /**
         * Initialize AI Assistant
         */
        init: function() {
            console.log('Initializing AI Assistant...');
            
            // Set up event listeners
            this.setupEventListeners();
            
            // Load AI model capabilities
            this.capabilities = {
                dot1x: true,
                mab: true,
                webauth: true,
                radsec: true,
                tacacs: true,
                macsec: true,
                deviceTracking: true,
                dACL: true,
                sgacl: true,
                avc: true,
                cisco: true,
                aruba: true,
                juniper: true,
                fortinet: true,
                extreme: true,
                dell: true
            };
            
            // Load knowledge base
            this.loadKnowledgeBase();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // AI Assistant button
            const aiAssistBtn = document.getElementById('aiAssistBtn');
            if (aiAssistBtn) {
                aiAssistBtn.addEventListener('click', this.showAssistant.bind(this));
            }
            
            // Close button for AI Assistant modal
            const closeAIModal = document.querySelector('#aiAssistantModal .close');
            if (closeAIModal) {
                closeAIModal.addEventListener('click', this.hideAssistant.bind(this));
            }
            
            // Send message button
            const sendMessageBtn = document.getElementById('sendMessageBtn');
            if (sendMessageBtn) {
                sendMessageBtn.addEventListener('click', this.sendMessage.bind(this));
            }
            
            // Send message on Enter key
            const userMessage = document.getElementById('userMessage');
            if (userMessage) {
                userMessage.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') {
                        AIAssistant.sendMessage();
                    }
                });
            }
            
            // Suggested question buttons
            const suggestionBtns = document.querySelectorAll('.suggestion-btn');
            suggestionBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const message = this.textContent;
                    document.getElementById('userMessage').value = message;
                    AIAssistant.sendMessage();
                });
            });
        },
        
        /**
         * Load knowledge base for AI Assistant
         */
        loadKnowledgeBase: function() {
            // In a real implementation, this would load from a database or API
            // For now, we'll use a simple object
            this.knowledgeBase = {
                'dot1x': {
                    description: '802.1X is an IEEE standard for port-based Network Access Control (PNAC). It provides an authentication mechanism to devices wishing to connect to a LAN or WLAN.',
                    components: [
                        'Supplicant - The client device requesting access',
                        'Authenticator - The network device (switch, access point)',
                        'Authentication Server - RADIUS server (e.g., Cisco ISE, Aruba ClearPass)'
                    ],
                    benefits: [
                        'Strong security with user-based authentication',
                        'Dynamic policy assignment (VLAN, ACL, QoS)',
                        'Integration with identity stores (AD, LDAP)',
                        'Support for certificate-based authentication'
                    ],
                    configuration: {
                        cisco: 'dot1x system-auth-control\n\ninterface GigabitEthernet1/0/1\n switchport mode access\n dot1x pae authenticator\n authentication port-control auto',
                        aruba: 'aaa authentication port-access eap-radius\naaa port-access authenticator 1/1\naaa port-access authenticator active'
                    }
                },
                'mab': {
                    description: 'MAC Authentication Bypass (MAB) allows devices that do not support 802.1X to be authenticated based on their MAC address.',
                    use_cases: [
                        'Printers, IP phones, and IoT devices',
                        'Legacy devices without 802.1X supplicant',
                        'Fallback mechanism when 802.1X fails'
                    ],
                    benefits: [
                        'Support for non-802.1X capable devices',
                        'Simplified deployment for specific device types',
                        'Can be used as fallback for 802.1X'
                    ],
                    configuration: {
                        cisco: 'interface GigabitEthernet1/0/1\n switchport mode access\n mab\n authentication port-control auto',
                        aruba: 'aaa authentication port-access mac-auth\naaa port-access mac-auth 1/1\naaa port-access mac-auth active'
                    }
                },
                'closed vs monitor': {
                    description: 'Closed mode enforces authentication, while Monitor mode allows traffic regardless of authentication outcome.',
                    comparison: [
                        {
                            name: 'Closed Mode',
                            description: 'Authentication is enforced and only authorized traffic is allowed.',
                            use_case: 'Production environments where security is critical.',
                            cisco_config: 'access-session closed\nauthentication port-control auto',
                            aruba_config: 'aaa authentication port-access auth-mode 1x'
                        },
                        {
                            name: 'Monitor Mode',
                            description: 'Authentication occurs but all traffic is allowed regardless of result.',
                            use_case: 'Testing and initial deployment phases.',
                            cisco_config: 'authentication open\nauthentication port-control auto',
                            aruba_config: 'aaa authentication port-access auth-mode monitor'
                        }
                    ],
                    recommendation: 'Start with Monitor Mode during deployment to identify and fix issues, then transition to Closed Mode for production.'
                },
                'troubleshooting 802.1x': {
                    description: 'Common steps for troubleshooting 802.1X authentication issues.',
                    steps: [
                        {
                            name: 'Verify Configuration',
                            commands: [
                                'show authentication sessions interface <interface>',
                                'show dot1x all',
                                'show dot1x interface <interface> details'
                            ]
                        },
                        {
                            name: 'Check RADIUS Connectivity',
                            commands: [
                                'test aaa group radius <username> <password> new-code',
                                'show radius statistics',
                                'debug radius authentication'
                            ]
                        },
                        {
                            name: 'Monitor Authentication Process',
                            commands: [
                                'debug dot1x all',
                                'debug authentication all',
                                'debug radius authentication'
                            ]
                        },
                        {
                            name: 'Check Client Status',
                            actions: [
                                'Verify supplicant configuration on client',
                                'Check client logs',
                                'Ensure proper credentials are being used'
                            ]
                        },
                        {
                            name: 'Verify Policy Application',
                            commands: [
                                'show access-session interface <interface> details',
                                'show authentication sessions interface <interface> details',
                                'show ip access-list'
                            ]
                        }
                    ],
                    common_issues: [
                        'RADIUS server unreachable',
                        'Certificate validation issues',
                        'Incompatible EAP methods',
                        'Missing or incorrect AAA configuration',
                        'Incorrect VLAN assignment',
                        'Authorization policy misconfiguration'
                    ]
                },
                'radius redundancy': {
                    description: 'Best practices for RADIUS server redundancy and high availability.',
                    best_practices: [
                        'Configure at least two RADIUS servers',
                        'Implement RADIUS server load balancing',
                        'Configure appropriate timeouts and deadtime',
                        'Use RADIUS server testing probes',
                        'Configure critical authentication for RADIUS server failure',
                        'Implement local authentication fallback',
                        'Monitor RADIUS server health'
                    ],
                    configuration: {
                        cisco_ios_xe: 'radius server RAD-SERVER-1\n address ipv4 10.1.1.1 auth-port 1812 acct-port 1813\n key <key>\n automate-tester username probe-user probe-on\n\nradius server RAD-SERVER-2\n address ipv4 10.1.1.2 auth-port 1812 acct-port 1813\n key <key>\n automate-tester username probe-user probe-on\n\naaa group server radius RAD-SERVERS\n server name RAD-SERVER-1\n server name RAD-SERVER-2\n deadtime 15\n load-balance method least-outstanding\n\naaa authentication dot1x default group RAD-SERVERS local\naaa authorization network default group RAD-SERVERS local\n\nradius-server dead-criteria time 5 tries 3\n\ndot1x critical eapol\nauthentication critical recovery delay 2000',
                        cisco_ios: 'radius-server host 10.1.1.1 auth-port 1812 acct-port 1813 key <key>\nradius-server host 10.1.1.2 auth-port 1812 acct-port 1813 key <key>\nradius-server deadtime 15\naaa group server radius RAD-SERVERS\n server 10.1.1.1 auth-port 1812 acct-port 1813\n server 10.1.1.2 auth-port 1812 acct-port 1813\naaa authentication dot1x default group RAD-SERVERS local\naaa authorization network default group RAD-SERVERS local\ndot1x critical eapol'
                    }
                },
                'mab for printers': {
                    description: 'Configuration for MAC Authentication Bypass (MAB) for printers and non-802.1X capable devices.',
                    configuration_steps: [
                        {
                            step: 'Enable AAA',
                            cisco_config: 'aaa new-model\naaa authentication dot1x default group radius\naaa authorization network default group radius'
                        },
                        {
                            step: 'Configure RADIUS',
                            cisco_config: 'radius server RADIUS-SERVER\n address ipv4 10.1.1.1 auth-port 1812 acct-port 1813\n key <key>'
                        },
                        {
                            step: 'Configure Authentication Global Settings',
                            cisco_config: 'dot1x system-auth-control\nip device tracking'
                        },
                        {
                            step: 'Configure Interface for MAB',
                            cisco_config: 'interface GigabitEthernet1/0/10\n description Printer\n switchport access vlan 20\n switchport mode access\n mab\n authentication port-control auto\n authentication order mab\n authentication priority mab\n spanning-tree portfast'
                        },
                        {
                            step: 'Configure RADIUS Server',
                            notes: [
                                'Add printer MAC addresses to RADIUS server',
                                'Configure authorization policy to assign appropriate VLAN and permissions',
                                'Set authentication method to MAC address'
                            ]
                        }
                    ],
                    best_practices: [
                        'Use dedicated VLAN for printers',
                        'Implement IP source guard for additional security',
                        'Consider using ACLs to restrict printer communications',
                        'Regularly audit authorized MAC addresses',
                        'Monitor for suspicious activity from printer VLAN'
                    ]
                },
                'ibns vs legacy': {
                    description: 'Identity-Based Networking Services (IBNS) 2.0 is Cisco\'s framework for identity and access control using new authentication commands.',
                    comparison: [
                        {
                            name: 'Legacy 802.1X',
                            commands: [
                                'dot1x pae authenticator',
                                'dot1x port-control auto',
                                'authentication host-mode multi-auth',
                                'authentication order dot1x mab',
                                'authentication priority dot1x mab'
                            ],
                            limitations: [
                                'Limited flexibility',
                                'Restricted policy application',
                                'Sequential authentication only',
                                'Limited failure handling'
                            ]
                        },
                        {
                            name: 'IBNS 2.0',
                            commands: [
                                'dot1x pae authenticator',
                                'access-session port-control auto',
                                'access-session host-mode multi-auth',
                                'service-policy type control subscriber POLICY_NAME'
                            ],
                            advantages: [
                                'Flexible policy definition',
                                'Event-driven policy control',
                                'Concurrent authentication',
                                'Fine-grained failure handling',
                                'Improved critical authentication',
                                'Service templates for policy application'
                            ]
                        }
                    ],
                    migration: [
                        'Use "authentication convert-to new-style" command',
                        'Create policy-maps for different authentication scenarios',
                        'Define service templates for policy application',
                        'Update interface configurations to use new commands'
                    ]
                },
                'radsec': {
                    description: 'RADIUS over TLS (RadSec) provides secure RADIUS communications using TLS encryption.',
                    benefits: [
                        'Encrypted RADIUS traffic',
                        'Mutual authentication using certificates',
                        'TCP transport for better reliability',
                        'Better high availability support',
                        'Protection of RADIUS credentials and attributes'
                    ],
                    requirements: [
                        'TLS-capable network devices',
                        'PKI infrastructure',
                        'TCP port 2083 connectivity',
                        'RADIUS servers with RadSec support'
                    ],
                    configuration: {
                        cisco: 'crypto pki trustpoint RADSEC-CLIENT\n enrollment self\n revocation-check none\n rsakeypair RADSEC-KEY 2048\n\ncrypto pki trustpoint RADSEC-SERVER\n enrollment terminal\n revocation-check none\n\nradius server RADSEC-SERVER\n address ipv4 10.1.1.1 auth-port 2083 acct-port 2083\n tls connectiontimeout 5\n tls trustpoint client RADSEC-CLIENT\n tls trustpoint server RADSEC-SERVER\n key <key>\n\naaa group server radius RADSEC-GROUP\n server name RADSEC-SERVER\n\naaa authentication dot1x default group RADSEC-GROUP\naaa authorization network default group RADSEC-GROUP'
                    },
                    when_to_use: 'RadSec should be used when RADIUS traffic traverses untrusted networks, when security compliance requires encryption of authentication traffic, or in environments with high security requirements.'
                }
            };
        },
        
        /**
         * Show AI Assistant modal
         */
        showAssistant: function() {
            const modal = document.getElementById('aiAssistantModal');
            if (modal) {
                modal.style.display = 'block';
                
                // Focus on message input
                setTimeout(() => {
                    const userMessage = document.getElementById('userMessage');
                    if (userMessage) {
                        userMessage.focus();
                    }
                }, 300);
            }
        },
        
        /**
         * Hide AI Assistant modal
         */
        hideAssistant: function() {
            const modal = document.getElementById('aiAssistantModal');
            if (modal) {
                modal.style.display = 'none';
            }
        },
        
        /**
         * Send message to AI Assistant
         */
        sendMessage: function() {
            const userMessage = document.getElementById('userMessage');
            const chatMessages = document.getElementById('chatMessages');
            
            if (!userMessage || !chatMessages) return;
            
            // Get user message
            const message = userMessage.value.trim();
            if (!message) return;
            
            // Clear input
            userMessage.value = '';
            
            // Add user message to chat
            chatMessages.innerHTML += `
                <div class="user-message">
                    <div class="message-content">
                        <p>${this.escapeHTML(message)}</p>
                    </div>
                    <div class="message-avatar"><i class="fas fa-user"></i></div>
                </div>
            `;
            
            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Generate AI response
            this.generateResponse(message);
        },
        
        /**
         * Generate AI response to user message
         * @param {string} message - User message
         */
        generateResponse: function(message) {
            // Simulate typing indicator
            const chatMessages = document.getElementById('chatMessages');
            
            const typingIndicator = document.createElement('div');
            typingIndicator.className = 'ai-message typing-indicator';
            typingIndicator.innerHTML = `
                <div class="message-avatar"><i class="fas fa-robot"></i></div>
                <div class="message-content">
                    <p>Thinking<span class="typing-dots">...</span></p>
                </div>
            `;
            
            chatMessages.appendChild(typingIndicator);
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Animate typing dots
            let dots = 0;
            const dotsInterval = setInterval(() => {
                const dotsElement = typingIndicator.querySelector('.typing-dots');
                dots = (dots + 1) % 4;
                dotsElement.textContent = '.'.repeat(dots);
            }, 500);
            
            // Process the message and generate a response
            setTimeout(() => {
                // Clear typing indicator
                clearInterval(dotsInterval);
                chatMessages.removeChild(typingIndicator);
                
                // Get response based on message
                const response = this.getResponseForMessage(message);
                
                // Add AI response to chat
                chatMessages.innerHTML += `
                    <div class="ai-message">
                        <div class="message-avatar"><i class="fas fa-robot"></i></div>
                        <div class="message-content">
                            ${response}
                        </div>
                    </div>
                `;
                
                // Scroll to bottom
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }, 1000 + Math.random() * 1000); // Random delay between 1-2 seconds
        },
        
        /**
         * Get response for user message
         * @param {string} message - User message
         * @returns {string} AI response
         */
        getResponseForMessage: function(message) {
            // Convert message to lowercase for easier matching
            const lowerMessage = message.toLowerCase();
            
            // Check for specific topics
            if (lowerMessage.includes('closed') && lowerMessage.includes('monitor') && 
                (lowerMessage.includes('mode') || lowerMessage.includes('difference'))) {
                return this.generateKnowledgeResponse('closed vs monitor');
            }
            
            if ((lowerMessage.includes('trouble') || lowerMessage.includes('debug')) && 
                lowerMessage.includes('802.1x')) {
                return this.generateKnowledgeResponse('troubleshooting 802.1x');
            }
            
            if (lowerMessage.includes('radius') && 
                (lowerMessage.includes('redundancy') || lowerMessage.includes('redundant') || 
                 lowerMessage.includes('ha') || lowerMessage.includes('high availability'))) {
                return this.generateKnowledgeResponse('radius redundancy');
            }
            
            if (lowerMessage.includes('mab') && 
                (lowerMessage.includes('printer') || lowerMessage.includes('printers'))) {
                return this.generateKnowledgeResponse('mab for printers');
            }
            
            if ((lowerMessage.includes('ibns') || lowerMessage.includes('new-style')) && 
                (lowerMessage.includes('legacy') || lowerMessage.includes('traditional') || 
                 lowerMessage.includes('old') || lowerMessage.includes('differ'))) {
                return this.generateKnowledgeResponse('ibns vs legacy');
            }
            
            if (lowerMessage.includes('radsec') || 
                (lowerMessage.includes('radius') && lowerMessage.includes('tls'))) {
                return this.generateKnowledgeResponse('radsec');
            }
            
            // Check for general authentication terms
            if (lowerMessage.includes('802.1x') || 
                lowerMessage.includes('dot1x') || 
                (lowerMessage.includes('ieee') && lowerMessage.includes('802.1x'))) {
                return this.generateKnowledgeResponse('dot1x');
            }
            
            if (lowerMessage.includes('mab') || 
                lowerMessage.includes('mac authentication bypass') || 
                (lowerMessage.includes('mac') && lowerMessage.includes('authentication'))) {
                return this.generateKnowledgeResponse('mab');
            }
            
            // Generic responses for other questions
            if (lowerMessage.includes('hello') || lowerMessage.includes('hi ')) {
                return '<p>Hello! How can I help you with your authentication configuration today?</p>';
            }
            
            if (lowerMessage.includes('thank')) {
                return '<p>You\'re welcome! If you need any more help, just ask.</p>';
            }
            
            // Default response for unrecognized questions
            return `
                <p>I don't have a specific answer for that question. Here are some topics I can help with:</p>
                <ul>
                    <li>802.1X authentication configuration</li>
                    <li>MAC Authentication Bypass (MAB) setup</li>
                    <li>Closed vs. Monitor mode differences</li>
                    <li>Troubleshooting 802.1X authentication</li>
                    <li>RADIUS server redundancy</li>
                    <li>MAB configuration for printers</li>
                    <li>IBNS 2.0 vs traditional 802.1X</li>
                    <li>RadSec implementation</li>
                </ul>
                <p>Please ask about one of these topics or rephrase your question.</p>
            `;
        },
        
        /**
         * Generate knowledge-based response
         * @param {string} topic - Knowledge base topic
         * @returns {string} Formatted response
         */
        generateKnowledgeResponse: function(topic) {
            const knowledge = this.knowledgeBase[topic];
            if (!knowledge) {
                return `<p>I don't have specific information about ${topic}. Please try asking about another topic.</p>`;
            }
            
            let response = '';
            
            // Add description
            if (knowledge.description) {
                response += `<p>${knowledge.description}</p>`;
            }
            
            // Add components if available
            if (knowledge.components) {
                response += '<p><strong>Components:</strong></p><ul>';
                knowledge.components.forEach(component => {
                    response += `<li>${component}</li>`;
                });
                response += '</ul>';
            }
            
            // Add benefits if available
            if (knowledge.benefits) {
                response += '<p><strong>Benefits:</strong></p><ul>';
                knowledge.benefits.forEach(benefit => {
                    response += `<li>${benefit}</li>`;
                });
                response += '</ul>';
            }
            
            // Add use cases if available
            if (knowledge.use_cases) {
                response += '<p><strong>Use Cases:</strong></p><ul>';
                knowledge.use_cases.forEach(use_case => {
                    response += `<li>${use_case}</li>`;
                });
                response += '</ul>';
            }
            
            // Add comparison if available
            if (knowledge.comparison) {
                knowledge.comparison.forEach(item => {
                    response += `<p><strong>${item.name}:</strong> ${item.description || ''}</p>`;
                    
                    if (item.commands) {
                        response += '<p>Configuration:</p><pre>';
                        item.commands.forEach(cmd => {
                            response += `${cmd}\n`;
                        });
                        response += '</pre>';
                    }
                    
                    if (item.advantages) {
                        response += '<p>Advantages:</p><ul>';
                        item.advantages.forEach(adv => {
                            response += `<li>${adv}</li>`;
                        });
                        response += '</ul>';
                    }
                    
                    if (item.limitations) {
                        response += '<p>Limitations:</p><ul>';
                        item.limitations.forEach(lim => {
                            response += `<li>${lim}</li>`;
                        });
                        response += '</ul>';
                    }
                    
                    if (item.use_case) {
                        response += `<p>Use Case: ${item.use_case}</p>`;
                    }
                });
            }
            
            // Add migration steps if available
            if (knowledge.migration) {
                response += '<p><strong>Migration Steps:</strong></p><ul>';
                knowledge.migration.forEach(step => {
                    response += `<li>${step}</li>`;
                });
                response += '</ul>';
            }
            
            // Add steps if available
            if (knowledge.steps) {
                response += '<p><strong>Troubleshooting Steps:</strong></p>';
                knowledge.steps.forEach(step => {
                    response += `<p><strong>${step.name}</strong></p>`;
                    
                    if (step.commands) {
                        response += '<p>Commands to use:</p><pre>';
                        step.commands.forEach(cmd => {
                            response += `${cmd}\n`;
                        });
                        response += '</pre>';
                    }
                    
                    if (step.actions) {
                        response += '<ul>';
                        step.actions.forEach(action => {
                            response += `<li>${action}</li>`;
                        });
                        response += '</ul>';
                    }
                });
            }
            
            // Add best practices if available
            if (knowledge.best_practices) {
                response += '<p><strong>Best Practices:</strong></p><ul>';
                knowledge.best_practices.forEach(practice => {
                    response += `<li>${practice}</li>`;
                });
                response += '</ul>';
            }
            
            // Add common issues if available
            if (knowledge.common_issues) {
                response += '<p><strong>Common Issues:</strong></p><ul>';
                knowledge.common_issues.forEach(issue => {
                    response += `<li>${issue}</li>`;
                });
                response += '</ul>';
            }
            
            // Add configuration steps if available
            if (knowledge.configuration_steps) {
                response += '<p><strong>Configuration Steps:</strong></p>';
                knowledge.configuration_steps.forEach((step, index) => {
                    response += `<p>${index + 1}. <strong>${step.step}</strong></p>`;
                    
                    if (step.cisco_config) {
                        response += '<pre>' + step.cisco_config + '</pre>';
                    }
                    
                    if (step.notes) {
                        response += '<ul>';
                        step.notes.forEach(note => {
                            response += `<li>${note}</li>`;
                        });
                        response += '</ul>';
                    }
                });
            }
            
            // Add configuration examples if available
            if (knowledge.configuration) {
                response += '<p><strong>Configuration Examples:</strong></p>';
                
                if (typeof knowledge.configuration === 'object') {
                    // Multiple configuration examples
                    for (const [platform, config] of Object.entries(knowledge.configuration)) {
                        response += `<p><strong>${platform.replace(/_/g, ' ')}:</strong></p><pre>${config}</pre>`;
                    }
                } else {
                    // Single configuration example
                    response += `<pre>${knowledge.configuration}</pre>`;
                }
            }
            
            // Add recommendation if available
            if (knowledge.recommendation) {
                response += `<p><strong>Recommendation:</strong> ${knowledge.recommendation}</p>`;
            }
            
            // Add when to use if available
            if (knowledge.when_to_use) {
                response += `<p><strong>When to Use:</strong> ${knowledge.when_to_use}</p>`;
            }
            
            // Add requirements if available
            if (knowledge.requirements) {
                response += '<p><strong>Requirements:</strong></p><ul>';
                knowledge.requirements.forEach(req => {
                    response += `<li>${req}</li>`;
                });
                response += '</ul>';
            }
            
            return response;
        },
        
        /**
         * Escape HTML special characters
         * @param {string} html - String to escape
         * @returns {string} Escaped string
         */
        escapeHTML: function(html) {
            const div = document.createElement('div');
            div.textContent = html;
            return div.innerHTML;
        }
    };

    // Initialize AI Assistant on page load
    document.addEventListener('DOMContentLoaded', function() {
        AIAssistant.init();
    });

    // Export to window
    window.AIAssistant = AIAssistant;
})();
