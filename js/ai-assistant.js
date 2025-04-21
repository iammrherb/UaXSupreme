/**
 * UaXSupreme - AI Assistant
 * Provides AI-powered assistance for configurations
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
        },

        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Listen for send message button
            const sendButton = document.getElementById('sendMessageBtn');
            if (sendButton) {
                sendButton.addEventListener('click', this.handleSendMessage.bind(this));
            }

            // Listen for enter key in message input
            const messageInput = document.getElementById('userMessage');
            if (messageInput) {
                messageInput.addEventListener('keypress', (e) => {
                    if (e.key === 'Enter') {
                        this.handleSendMessage();
                    }
                });
            }

            // Listen for suggestion button clicks
            const suggestionButtons = document.querySelectorAll('.suggestion-btn');
            suggestionButtons.forEach(button => {
                button.addEventListener('click', () => {
                    if (messageInput) {
                        messageInput.value = button.textContent;
                        this.handleSendMessage();
                    }
                });
            });
        },

        /**
         * Handle send message event
         */
        handleSendMessage: function() {
            const messageInput = document.getElementById('userMessage');
            const message = messageInput.value.trim();

            if (!message) {
                return;
            }

            // Add user message to chat
            this.addMessageToChat('user', message);

            // Clear input
            messageInput.value = '';

            // Process message and generate response
            this.processUserMessage(message);
        },

        /**
         * Add message to chat
         * @param {string} sender - 'user' or 'ai'
         * @param {string} message - Message content
         */
        addMessageToChat: function(sender, message) {
            const chatMessages = document.getElementById('chatMessages');
            if (!chatMessages) {
                return;
            }

            const messageDiv = document.createElement('div');
            messageDiv.className = sender === 'user' ? 'user-message' : 'ai-message';

            const avatarDiv = document.createElement('div');
            avatarDiv.className = 'message-avatar';
            avatarDiv.innerHTML = sender === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';

            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';

            // Format message content
            contentDiv.innerHTML = this.formatMessageContent(message);

            messageDiv.appendChild(avatarDiv);
            messageDiv.appendChild(contentDiv);

            chatMessages.appendChild(messageDiv);

            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
        },

        /**
         * Format message content with HTML
         * @param {string} message - Message content
         * @returns {string} Formatted HTML
         */
        formatMessageContent: function(message) {
            // Replace newlines with paragraphs
            const paragraphs = message.split('\n\n');
            let formattedContent = '';

            paragraphs.forEach(paragraph => {
                // Replace single newlines with <br>
                const lines = paragraph.split('\n');
                const processedParagraph = lines.join('<br>');

                formattedContent += `<p>${processedParagraph}</p>`;
            });

            return formattedContent;
        },

        /**
         * Process user message and generate response
         * @param {string} message - User's message
         */
        processUserMessage: function(message) {
            // Add typing indicator
            this.showTypingIndicator();

            // In a real implementation, this would call an API or use local AI model
            // For this example, use simple keyword-based responses
            setTimeout(() => {
                this.hideTypingIndicator();

                const response = this.generateResponse(message);
                this.addMessageToChat('ai', response);
            }, 1000);
        },

        /**
         * Show typing indicator
         */
        showTypingIndicator: function() {
            const chatMessages = document.getElementById('chatMessages');
            if (!chatMessages) {
                return;
            }

            const typingDiv = document.createElement('div');
            typingDiv.className = 'ai-message typing-indicator';
            typingDiv.id = 'typingIndicator';

            const avatarDiv = document.createElement('div');
            avatarDiv.className = 'message-avatar';
            avatarDiv.innerHTML = '<i class="fas fa-robot"></i>';

            const contentDiv = document.createElement('div');
            contentDiv.className = 'message-content';
            contentDiv.innerHTML = '<p><i class="fas fa-circle-notch fa-spin"></i> AI Assistant is typing...</p>';

            typingDiv.appendChild(avatarDiv);
            typingDiv.appendChild(contentDiv);

            chatMessages.appendChild(typingDiv);

            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
        },

        /**
         * Hide typing indicator
         */
        hideTypingIndicator: function() {
            const typingIndicator = document.getElementById('typingIndicator');
            if (typingIndicator) {
                typingIndicator.remove();
            }
        },

        /**
         * Generate response based on user message
         * @param {string} message - User's message
         * @returns {string} Generated response
         */
        generateResponse: function(message) {
            const lowerMessage = message.toLowerCase();

            // Simple keyword-based responses
            if (lowerMessage.includes('monitor mode') || lowerMessage.includes('open mode')) {
                return `Monitor Mode (or Open Mode) allows 802.1X authentication to run without enforcing it. This means:

1. The switch will try to authenticate devices
2. If authentication fails, devices will still be allowed network access
3. This is ideal for testing and initial deployment phases
4. You can monitor what would happen in real enforcement without impacting users

To configure Monitor Mode, make sure your switch port configuration does not include:
\`access-session closed\` (on IOS-XE)
\`authentication open\` (on IOS)`;
            }
            else if (lowerMessage.includes('closed mode')) {
                return `Closed Mode is when 802.1X authentication is fully enforced. This means:

1. The switch requires successful authentication before granting network access
2. Unauthenticated devices will be denied access (except to authentication servers)
3. This is used for full security enforcement
4. Use this after thorough testing in Monitor Mode

To configure Closed Mode, include:
\`access-session closed\` (on IOS-XE)
\`authentication port-control auto\` without \`authentication open\` (on IOS)`;
            }
            else if (lowerMessage.includes('concurrent')) {
                return `Concurrent 802.1X and MAB allows both authentication methods to run simultaneously, rather than sequentially. This means:

1. The switch initiates both 802.1X and MAB authentication at the same time
2. Whichever method succeeds first will authenticate the device
3. This is faster than sequential authentication
4. Particularly useful for mixed environments with both 802.1X-capable and legacy devices

In IBNS 2.0, this is configured in the policy-map with:
\`\`\`
event session-started match-all
 10 class always do-all
  10 authenticate using dot1x priority 10
  20 authenticate using mab priority 20
\`\`\`

Note that while this is a major feature of IBNS 2.0, Cisco does not officially support this configuration.`;
            }
            else if (lowerMessage.includes('ibns 2.0')) {
                return `IBNS 2.0 (Identity-Based Networking Services 2.0) is Cisco's framework for configuring authentication on network devices. Key features include:

1. Flexible policy language using class-maps and policy-maps
2. Event-driven policy application
3. Support for concurrent authentication methods
4. Improved high availability and critical authentication
5. Better service template support

IBNS 2.0 uses a policy language similar to QoS, with class-maps to match conditions and policy-maps to define actions. The policy is event-driven, responding to events like "session-started" or "authentication-failure".

To implement IBNS 2.0, you need:
- IOS 15.2(2)E or later, or IOS-XE 3.6.0E or later
- The 'authentication convert-to new-style' command to convert legacy configurations`;
            }
            else if (lowerMessage.includes('troubleshoot') || lowerMessage.includes('fail')) {
                return `To troubleshoot 802.1X authentication failures:

1. Check switch configuration with "show authentication sessions interface X" or "show access-session interface X detail"

2. Verify RADIUS server connectivity with "test aaa server radius X"

3. Check RADIUS server logs for authentication attempts

4. For detailed debugging, use:
   - "debug dot1x all" (use cautiously in production)
   - "debug radius"
   - "debug aaa authentication"
   - "debug aaa authorization"

5. Check for policy-map issues with:
   - "show policy-map type control subscriber DOT1X_MAB_POLICY detail"
   - "show class-map type control subscriber all"

6. Check client supplicant configuration and logs

7. Verify certificate validity if using EAP-TLS

Remember to clear debug logging when finished troubleshooting.`;
            }
            else if (lowerMessage.includes('radius') && lowerMessage.includes('redundancy')) {
                return `Best practices for RADIUS server redundancy:

1. Configure at least two RADIUS servers:
\`\`\`
radius server RAD-ISE-PSN-1
 address ipv4 10.10.10.101 auth-port 1812 acct-port 1813
 automate-tester username SW-RAD-TEST probe-on
 key SecretKey123
 timeout 2
 retransmit 2

radius server RAD-ISE-PSN-2
 address ipv4 10.10.10.102 auth-port 1812 acct-port 1813
 automate-tester username SW-RAD-TEST probe-on
 key SecretKey123
 timeout 2
 retransmit 2
\`\`\`

2. Use server groups with deadtime:
\`\`\`
aaa group server radius RAD-SERVERS
 server name RAD-ISE-PSN-1
 server name RAD-ISE-PSN-2
 deadtime 15
\`\`\`

3. Set appropriate timeouts and retransmit values (usually 2-3 seconds timeout, 2 retransmits)

4. Use server probing to detect dead servers

5. Configure load balancing:
\`\`\`
radius-server load-balance method least-outstanding
\`\`\`

6. Consider RadSec for encrypted and reliable RADIUS communication`;
            }
            else if (lowerMessage.includes('mab') && lowerMessage.includes('printer')) {
                return `To configure MAB for printers:

1. Enable MAC Authentication Bypass on the switch port:
\`\`\`
interface GigabitEthernet1/0/10
 description Printer
 switchport access vlan 20
 switchport mode access
 mab
 access-session port-control auto
 service-policy type control subscriber DOT1X_MAB_POLICY
\`\`\`

2. Add the printer's MAC address to your RADIUS server (e.g., ISE):
   - Create an endpoint in ISE with the printer's MAC address
   - Assign it to an appropriate endpoint group

3. Set authorization policies in your RADIUS server:
   - Create policy to match printer MAC addresses or endpoint group
   - Assign appropriate permissions (VLAN, dACL, etc.)

4. Consider using device profiling to identify printers automatically:
\`\`\`
device-classifier
device-sensor filter-list dhcp list DHCP_LIST
 option name host-name
 option name class-identifier
device-sensor filter-spec dhcp include list DHCP_LIST
\`\`\`

5. For non-802.1X capable devices like printers, consider setting up a dedicated printer VLAN`;
            }
            else if (lowerMessage.includes('critical auth') || lowerMessage.includes('critical authentication')) {
                return `Critical Authentication allows devices to maintain or gain network access when RADIUS servers are unreachable. Configuration includes:

1. Service templates for critical authorization:
\`\`\`
service-template CRITICAL_DATA_ACCESS
 vlan 999
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan 999
 access-group ACL-OPEN
\`\`\`

2. Class maps to detect AAA server down condition:
\`\`\`
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized
\`\`\`

3. Policy map actions for AAA server down:
\`\`\`
event authentication-failure match-first
 10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
  10 clear-authenticated-data-hosts-on-port
  20 activate service-template CRITICAL_DATA_ACCESS
  30 activate service-template CRITICAL_VOICE_ACCESS
  40 authorize
  50 pause reauthentication
 20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
  10 pause reauthentication
  20 authorize
\`\`\`

4. Global critical settings:
\`\`\`
dot1x critical eapol
authentication critical recovery delay 2000
\`\`\`

These configurations ensure that:
- Already authenticated devices stay authenticated if RADIUS becomes unreachable
- New devices can gain limited access if RADIUS is unreachable
- Authentication resumes when RADIUS servers become available again`;
            }
            else if (lowerMessage.includes('class map') || lowerMessage.includes('policy map')) {
                return `IBNS 2.0 uses class maps and policy maps to control authentication behavior:

Class Maps match specific conditions:
\`\`\`
class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found
\`\`\`

Policy Maps define actions based on events and class matches:
\`\`\`
policy-map type control subscriber DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-until-failure
   10 authenticate using dot1x priority 10
 event authentication-failure match-first
  10 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
\`\`\`

To troubleshoot class maps and policy maps:
- View policy map counters: \`show policy-map type control subscriber DOT1X_MAB_POLICY detail\`
- View class map definitions: \`show class-map type control subscriber all\`
- Clear counters: \`clear policy-map control subscriber name DOT1X_MAB_POLICY\`

The policy map processing is event-driven and follows priority order. The first matching class in each event will be processed based on the match-all, match-first, or match-any setting.`;
            }
            else if (lowerMessage.includes('radsec')) {
                return `RadSec (RADIUS over TLS) provides secure RADIUS communication by:

1. Encrypting RADIUS traffic using TLS
2. Providing reliable transport over TCP instead of UDP
3. Supporting certificates for mutual authentication
4. Enabling better redundancy and load balancing

To configure RadSec on Cisco IOS-XE (17.3+):
\`\`\`
! Generate or import certificates
crypto pki trustpoint MY-TRUSTPOINT
 enrollment terminal
 revocation-check none
 rsakeypair MY-TRUSTPOINT

! Configure RadSec server
radius server RADSEC-SERVER
 address ipv4 10.10.10.101 auth-port 2083 acct-port 2083
 tls connectiontimeout 5
 tls trustpoint client MY-TRUSTPOINT
 tls trustpoint server MY-TRUSTPOINT
 key RadSecKey123

! Configure server group
aaa group server radius RADSEC-GROUP
 server name RADSEC-SERVER
\`\`\`

RadSec typically uses TCP port 2083 and requires proper certificates for both the switch and RADIUS server. For full redundancy, configure multiple RadSec servers.`;
            }
            else if (lowerMessage.includes('dacl') || lowerMessage.includes('downloadable acl')) {
                return `Downloadable ACLs (dACLs) are access control lists pushed from RADIUS server to switches during authentication. Configuration requires:

1. On the switch:
\`\`\`
! Enable IP device tracking to associate IP addresses with authenticated sessions
device-tracking tracking auto-source

! Create device tracking policy for access ports
device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

! Apply to interfaces
interface range GigabitEthernet1/0/1-48
 device-tracking attach-policy IP-TRACKING
\`\`\`

2. On the RADIUS server (like ISE):
   - Create named dACLs on the RADIUS server
   - Associate dACLs with authorization profiles
   - Apply authorization profiles in authorization policies

3. Verify dACL application:
\`\`\`
show access-session interface GigabitEthernet1/0/10 details
\`\`\`

The output should show the dACL name and IP address associated with the session.

Common issues with dACLs:
- Missing IP device tracking configuration
- IP address not yet learned for the endpoint
- dACL too large for switch memory
- Syntax errors in dACL on RADIUS server`;
            }
            else {
                return `Thanks for your question. As an AI assistant for UaXSupreme, I can help with network authentication configuration.

I can assist with topics like:
- 802.1X and MAB configuration
- RADIUS and TACACS+ setup
- IBNS 2.0 configuration
- Vendor-specific implementations
- Troubleshooting authentication issues
- Best practices for secure deployment

Could you provide more specific details about what you'd like to learn about authentication configuration?`;
            }
        }
    };

    // Initialize AI Assistant
    document.addEventListener('DOMContentLoaded', function() {
        AIAssistant.init();
    });

    // Export to window
    window.AIAssistant = AIAssistant;
})();
