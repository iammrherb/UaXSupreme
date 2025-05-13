#!/bin/bash
# EnhanceComplete.sh - Complete enhancement for UaXSupreme with all features

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme Complete]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
  print_error "This script must be run from the UaXSupreme root directory"
fi

# Create backup of current state
print_message "Creating backup of current state..."
BACKUP_DIR="backup_complete_$(date +%Y%m%d%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r * $BACKUP_DIR/ 2>/dev/null
print_success "Backup created in $BACKUP_DIR"

# Clean up any old backup directories that might cause confusion
find . -maxdepth 1 -type d -name "backup_2*" -not -name "$BACKUP_DIR" -exec rm -rf {} \; 2>/dev/null

# Update directory structure
print_message "Updating directory structure..."

# Create or ensure required directories exist
mkdir -p css js templates lib assets/video assets/images help ai-models data

# Vendor-specific template directories
mkdir -p templates/cisco/IOS templates/cisco/IOS-XE templates/cisco/WLC-9800
mkdir -p templates/aruba/AOS-CX templates/aruba/AOS-Switch
mkdir -p templates/juniper/Junos
mkdir -p templates/fortinet/FortiOS
mkdir -p templates/extreme/EXOS
mkdir -p templates/dell/OS10

# Create banner logo MP4
print_message "Creating banner logo animation..."
cat > js/logo-generator.js << 'EOF'
/**
 * UaXSupreme - Logo Generator
 * Generates a canvas-based animated logo that's displayed at the top of the app
 */

(function() {
    'use strict';

    // Logo Generator object
    const LogoGenerator = {
        /**
         * Initialize Logo Generator
         */
        init: function() {
            console.log('Initializing Logo Generator...');
            
            // Create canvas elements
            this.createCanvasElements();
            
            // Start animation
            this.startAnimation();
        },
        
        /**
         * Create canvas elements
         */
        createCanvasElements: function() {
            const logoContainer = document.getElementById('logoCanvas');
            if (!logoContainer) {
                console.error('Logo container not found');
                return;
            }
            
            // Create canvas
            const canvas = document.createElement('canvas');
            canvas.width = 300;
            canvas.height = 70;
            canvas.className = 'logo-canvas';
            
            logoContainer.appendChild(canvas);
            
            this.canvas = canvas;
            this.ctx = canvas.getContext('2d');
            
            // Set initial properties
            this.animationFrame = 0;
            this.maxFrames = 120;
        },
        
        /**
         * Start animation
         */
        startAnimation: function() {
            // Start animation loop
            this.animate();
        },
        
        /**
         * Animation loop
         */
        animate: function() {
            const self = this;
            
            // Clear canvas
            this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);
            
            // Draw background
            this.ctx.fillStyle = '#2c3e50';
            this.ctx.fillRect(0, 0, this.canvas.width, this.canvas.height);
            
            // Draw logo text
            this.ctx.font = 'bold 28px Arial';
            this.ctx.fillStyle = '#3498db';
            this.ctx.textAlign = 'left';
            this.ctx.textBaseline = 'middle';
            
            // Calculate animation progress (0-1)
            const progress = Math.min(1, this.animationFrame / 30);
            
            // Draw UaX with animation
            this.ctx.fillText('UaX', 20, 35);
            
            // Draw Supreme with animation
            this.ctx.fillStyle = '#ecf0f1';
            this.ctx.fillText('Supreme', 80, 35);
            
            // Draw animated security elements
            this.drawSecurityElements();
            
            // Increment animation frame
            this.animationFrame = (this.animationFrame + 1) % this.maxFrames;
            
            // Request next frame
            requestAnimationFrame(function() {
                self.animate();
            });
        },
        
        /**
         * Draw security elements
         */
        drawSecurityElements: function() {
            // Draw shield
            const shieldX = 250;
            const shieldY = 35;
            const shieldSize = 20 + Math.sin(this.animationFrame * 0.05) * 2;
            
            // Shield body
            this.ctx.beginPath();
            this.ctx.moveTo(shieldX, shieldY - shieldSize/2);
            this.ctx.lineTo(shieldX + shieldSize/2, shieldY - shieldSize/4);
            this.ctx.lineTo(shieldX + shieldSize/2, shieldY + shieldSize/4);
            this.ctx.lineTo(shieldX, shieldY + shieldSize/2);
            this.ctx.lineTo(shieldX - shieldSize/2, shieldY + shieldSize/4);
            this.ctx.lineTo(shieldX - shieldSize/2, shieldY - shieldSize/4);
            this.ctx.closePath();
            
            this.ctx.fillStyle = '#27ae60';
            this.ctx.fill();
            
            // Shield checkmark
            this.ctx.beginPath();
            this.ctx.moveTo(shieldX - shieldSize/4, shieldY);
            this.ctx.lineTo(shieldX, shieldY + shieldSize/4);
            this.ctx.lineTo(shieldX + shieldSize/3, shieldY - shieldSize/4);
            
            this.ctx.strokeStyle = 'white';
            this.ctx.lineWidth = 2;
            this.ctx.stroke();
            
            // Draw animated dots representing network
            const dotRadius = 1.5;
            const dotCount = 8;
            const angle = this.animationFrame * 0.05;
            
            this.ctx.fillStyle = '#3498db';
            
            for (let i = 0; i < dotCount; i++) {
                const a = angle + (Math.PI * 2 * i / dotCount);
                const x = shieldX + Math.cos(a) * (shieldSize + 10);
                const y = shieldY + Math.sin(a) * (shieldSize + 10);
                
                this.ctx.beginPath();
                this.ctx.arc(x, y, dotRadius, 0, Math.PI * 2);
                this.ctx.fill();
                
                // Draw lines connecting dots to shield
                this.ctx.beginPath();
                this.ctx.moveTo(x, y);
                this.ctx.lineTo(shieldX, shieldY);
                this.ctx.strokeStyle = 'rgba(52, 152, 219, 0.3)';
                this.ctx.lineWidth = 0.5;
                this.ctx.stroke();
            }
        }
    };

    // Initialize Logo Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        LogoGenerator.init();
    });

    // Export to window
    window.LogoGenerator = LogoGenerator;
})();
EOF

# Create vendor-specific data files for configuration options
print_message "Creating vendor-specific data files..."

mkdir -p data/cisco
mkdir -p data/aruba
mkdir -p data/juniper
mkdir -p data/fortinet
mkdir -p data/extreme
mkdir -p data/dell

# Create Cisco configuration options data
cat > data/cisco/config-options.json << 'EOF'
{
  "ios": {
    "tacacs": {
      "authenticationMethods": [
        {
          "id": "group-local",
          "name": "TACACS+ Group then Local",
          "description": "Authenticate using TACACS+ server group first, then fallback to local database if server unreachable",
          "recommended": true,
          "config": "aaa authentication login default group {{tacacs.serverGroup}} local"
        },
        {
          "id": "local-group",
          "name": "Local then TACACS+ Group",
          "description": "Authenticate using local database first, then try TACACS+ server group",
          "recommended": false,
          "config": "aaa authentication login default local group {{tacacs.serverGroup}}"
        },
        {
          "id": "group-only",
          "name": "TACACS+ Group Only",
          "description": "Authenticate using TACACS+ server group only, no fallback (warning: may lock out access)",
          "recommended": false,
          "config": "aaa authentication login default group {{tacacs.serverGroup}}"
        }
      ],
      "authorizationMethods": [
        {
          "id": "commands-15",
          "name": "Command Authorization (Privilege 15)",
          "description": "Authorize EXEC commands at privilege level 15 through TACACS+",
          "recommended": true,
          "config": "aaa authorization commands 15 default group {{tacacs.serverGroup}} if-authenticated local"
        },
        {
          "id": "commands-all",
          "name": "Command Authorization (All Levels)",
          "description": "Authorize EXEC commands at all privilege levels through TACACS+",
          "recommended": false,
          "config": "aaa authorization commands 0 default group {{tacacs.serverGroup}} if-authenticated local\naaa authorization commands 1 default group {{tacacs.serverGroup}} if-authenticated local\naaa authorization commands 15 default group {{tacacs.serverGroup}} if-authenticated local"
        },
        {
          "id": "exec-only",
          "name": "EXEC Authorization Only",
          "description": "Authorize EXEC sessions without per-command authorization",
          "recommended": false,
          "config": "aaa authorization exec default group {{tacacs.serverGroup}} if-authenticated local"
        }
      ],
      "accountingMethods": [
        {
          "id": "commands-15",
          "name": "Command Accounting (Privilege 15)",
          "description": "Log all commands at privilege level 15 to TACACS+ server",
          "recommended": true,
          "config": "aaa accounting commands 15 default start-stop group {{tacacs.serverGroup}}"
        },
        {
          "id": "commands-all",
          "name": "Command Accounting (All Levels)",
          "description": "Log all commands at all privilege levels to TACACS+ server",
          "recommended": false,
          "config": "aaa accounting commands 0 default start-stop group {{tacacs.serverGroup}}\naaa accounting commands 1 default start-stop group {{tacacs.serverGroup}}\naaa accounting commands 15 default start-stop group {{tacacs.serverGroup}}"
        },
        {
          "id": "exec-accounting",
          "name": "EXEC Session Accounting",
          "description": "Log EXEC session start and stop to TACACS+ server",
          "recommended": true,
          "config": "aaa accounting exec default start-stop group {{tacacs.serverGroup}}"
        }
      ],
      "serverOptions": [
        {
          "id": "server-timeout",
          "name": "Server Timeout",
          "description": "Timeout in seconds before trying next server",
          "default": 5,
          "min": 1,
          "max": 60,
          "config": "timeout {{value}}"
        },
        {
          "id": "key-encryption",
          "name": "Key Encryption Type",
          "description": "Method of key encryption for TACACS+ server",
          "options": [
            {
              "id": "type-0",
              "name": "Type 0 (Clear Text)",
              "recommended": false
            },
            {
              "id": "type-7",
              "name": "Type 7 (Weak Encryption)",
              "recommended": false
            },
            {
              "id": "type-8",
              "name": "Type 8 (PBKDF2 SHA-256)",
              "recommended": true
            }
          ],
          "config": "key {{type}} {{key}}"
        },
        {
          "id": "single-connection",
          "name": "Single Connection",
          "description": "Maintain a single TCP connection for all TACACS+ communication",
          "default": true,
          "config": "single-connection"
        }
      ]
    },
    "radius": {
      "authenticationMethods": [
        {
          "id": "dot1x-default",
          "name": "802.1X Default",
          "description": "Authentication method for 802.1X",
          "recommended": true,
          "config": "aaa authentication dot1x default group {{radius.serverGroup}}"
        },
        {
          "id": "login-radius-local",
          "name": "Login RADIUS then Local",
          "description": "Login using RADIUS server group first, then fallback to local database",
          "recommended": true,
          "config": "aaa authentication login default group {{radius.serverGroup}} local"
        }
      ],
      "authorizationMethods": [
        {
          "id": "network-default",
          "name": "Network Authorization",
          "description": "Authorization for network services (VLAN, dACL, etc.)",
          "recommended": true,
          "config": "aaa authorization network default group {{radius.serverGroup}}"
        },
        {
          "id": "auth-proxy",
          "name": "Auth-Proxy Authorization",
          "description": "Authorization for authentication proxy",
          "recommended": false,
          "config": "aaa authorization auth-proxy default group {{radius.serverGroup}}"
        }
      ],
      "accountingMethods": [
        {
          "id": "network-acct",
          "name": "Network Accounting",
          "description": "Accounting for network services",
          "recommended": true,
          "config": "aaa accounting network default start-stop group {{radius.serverGroup}}"
        },
        {
          "id": "dot1x-acct",
          "name": "802.1X Accounting",
          "description": "Accounting for 802.1X sessions",
          "recommended": true,
          "config": "aaa accounting dot1x default start-stop group {{radius.serverGroup}}"
        },
        {
          "id": "identity-acct",
          "name": "Identity Accounting",
          "description": "Accounting for identity sessions (authentication manager)",
          "recommended": true,
          "config": "aaa accounting identity default start-stop group {{radius.serverGroup}}"
        }
      ],
      "serverOptions": [
        {
          "id": "server-timeout",
          "name": "Server Timeout",
          "description": "Timeout in seconds before trying next server",
          "default": 5,
          "min": 1,
          "max": 60,
          "config": "timeout {{value}}"
        },
        {
          "id": "retransmit",
          "name": "Retransmit Count",
          "description": "Number of times to retransmit request to server",
          "default": 2,
          "min": 1,
          "max": 10,
          "config": "retransmit {{value}}"
        },
        {
          "id": "key-encryption",
          "name": "Key Encryption Type",
          "description": "Method of key encryption for RADIUS server",
          "options": [
            {
              "id": "type-0",
              "name": "Type 0 (Clear Text)",
              "recommended": false
            },
            {
              "id": "type-7",
              "name": "Type 7 (Weak Encryption)",
              "recommended": false
            },
            {
              "id": "type-8",
              "name": "Type 8 (PBKDF2 SHA-256)",
              "recommended": true
            }
          ],
          "config": "key {{type}} {{key}}"
        },
        {
          "id": "source-interface",
          "name": "Source Interface",
          "description": "Interface to use for RADIUS packets",
          "default": "Vlan10",
          "config": "ip radius source-interface {{value}}"
        },
        {
          "id": "server-probe",
          "name": "Server Test",
          "description": "Probe radius server periodically to verify it's available",
          "default": true,
          "config": "automate-tester username {{testUsername}} probe-on"
        }
      ],
      "loadBalancingMethods": [
        {
          "id": "none",
          "name": "No Load Balancing",
          "description": "Primary/Secondary server model",
          "recommended": false
        },
        {
          "id": "least-outstanding",
          "name": "Least Outstanding",
          "description": "Send new requests to the server with the fewest pending requests",
          "recommended": true,
          "config": "radius-server load-balance method least-outstanding"
        },
        {
          "id": "host-hash",
          "name": "Host Hash",
          "description": "Distribute based on a hash of the client IP",
          "recommended": false,
          "config": "radius-server load-balance method host-hash"
        },
        {
          "id": "batch",
          "name": "Batch",
          "description": "Send batches of requests to each server in round-robin fashion",
          "recommended": false,
          "config": "radius-server load-balance method batch"
        }
      ],
      "deadtimeSettings": {
        "enabled": true,
        "description": "Time in minutes to skip unresponsive servers",
        "default": 15,
        "min": 1,
        "max": 60,
        "config": "deadtime {{value}}"
      },
      "deadCriteriaSettings": {
        "enabled": true,
        "time": {
          "description": "Time in seconds without response to mark server as dead",
          "default": 5,
          "min": 1,
          "max": 120
        },
        "tries": {
          "description": "Number of consecutive timeouts to mark server as dead",
          "default": 3,
          "min": 1,
          "max": 10
        },
        "config": "radius-server dead-criteria time {{time}} tries {{tries}}"
      }
    },
    "dot1x": {
      "portSettings": [
        {
          "id": "host-mode",
          "name": "Host Mode",
          "description": "How many and what type of devices can authenticate on a port",
          "options": [
            {
              "id": "single-host",
              "name": "Single Host",
              "description": "Only one MAC address can authenticate on the port",
              "recommended": false,
              "config": "authentication host-mode single-host"
            },
            {
              "id": "multi-auth",
              "name": "Multi-Auth",
              "description": "Multiple devices can authenticate independently",
              "recommended": true,
              "config": "authentication host-mode multi-auth"
            },
            {
              "id": "multi-domain",
              "name": "Multi-Domain",
              "description": "One device in data domain and one in voice domain",
              "recommended": false,
              "config": "authentication host-mode multi-domain"
            },
            {
              "id": "multi-host",
              "name": "Multi-Host",
              "description": "One device authenticates and others get access (not secure)",
              "recommended": false,
              "config": "authentication host-mode multi-host"
            }
          ]
        },
        {
          "id": "control-direction",
          "name": "Control Direction",
          "description": "Direction of traffic control during authentication",
          "options": [
            {
              "id": "both",
              "name": "Both",
              "description": "Block both directions before authentication",
              "recommended": false,
              "config": "authentication control-direction both"
            },
            {
              "id": "in",
              "name": "In",
              "description": "Only block inbound traffic before authentication",
              "recommended": true,
              "config": "authentication control-direction in"
            }
          ]
        },
        {
          "id": "port-control",
          "name": "Port Control",
          "description": "How 802.1X controls the port",
          "options": [
            {
              "id": "auto",
              "name": "Auto",
              "description": "Authentication required for network access",
              "recommended": true,
              "config": "authentication port-control auto"
            },
            {
              "id": "force-authorized",
              "name": "Force Authorized",
              "description": "Always allow access (no authentication)",
              "recommended": false,
              "config": "authentication port-control force-authorized"
            },
            {
              "id": "force-unauthorized",
              "name": "Force Unauthorized",
              "description": "Never allow access (always block)",
              "recommended": false,
              "config": "authentication port-control force-unauthorized"
            }
          ]
        },
        {
          "id": "open-auth",
          "name": "Open Authentication",
          "description": "Allow network access before authentication (monitor mode)",
          "options": [
            {
              "id": "disabled",
              "name": "Disabled (Closed Mode)",
              "description": "Block access until authentication succeeds",
              "recommended": true,
              "config": ""
            },
            {
              "id": "enabled",
              "name": "Enabled (Open/Monitor Mode)",
              "description": "Allow access regardless of authentication result",
              "recommended": false,
              "config": "authentication open"
            }
          ]
        },
        {
          "id": "periodic-reauthentication",
          "name": "Periodic Re-Authentication",
          "description": "Require clients to re-authenticate periodically",
          "enabled": true,
          "config": "authentication periodic\nauthentication timer reauthenticate server"
        },
        {
          "id": "inactivity-timeout",
          "name": "Inactivity Timeout",
          "description": "Remove authenticated clients after period of inactivity",
          "enabled": true,
          "value": 60,
          "config": "authentication timer inactivity {{value}}"
        }
      ],
      "dot1xSettings": [
        {
          "id": "tx-period",
          "name": "Tx Period",
          "description": "How often to send EAP requests to clients",
          "default": 7,
          "min": 1,
          "max": 65535,
          "config": "dot1x timeout tx-period {{value}}"
        },
        {
          "id": "max-reauth-req",
          "name": "Max Re-Auth Requests",
          "description": "Number of re-authentication attempts before failing",
          "default": 2,
          "min": 1,
          "max": 10,
          "config": "dot1x max-reauth-req {{value}}"
        },
        {
          "id": "quiet-period",
          "name": "Quiet Period",
          "description": "Time in seconds to wait after authentication failure",
          "default": 60,
          "min": 1,
          "max": 65535,
          "config": "dot1x timeout quiet-period {{value}}"
        },
        {
          "id": "critical-eapol",
          "name": "Critical EAPOL",
          "description": "Send EAPOL success when entering critical authentication mode",
          "enabled": true,
          "config": "dot1x critical eapol"
        }
      ],
      "mabSettings": [
        {
          "id": "auth-type",
          "name": "MAB Authentication Type",
          "description": "How MAB formats the authentication request",
          "options": [
            {
              "id": "eap",
              "name": "EAP",
              "description": "Send as EAP credential (recommended for ISE)",
              "recommended": true,
              "config": "mab request format attribute 1 groupsize 12"
            },
            {
              "id": "pap",
              "name": "PAP",
              "description": "Send as PAP credential",
              "recommended": false,
              "config": "mab request format attribute 1 groupsize 12 separator -"
            },
            {
              "id": "chap",
              "name": "CHAP",
              "description": "Send as CHAP credential",
              "recommended": false,
              "config": "mab request format attribute 1 groupsize 12 separator - chap"
            }
          ]
        }
      ],
      "deploymentOptions": [
        {
          "id": "sequential",
          "name": "Sequential",
          "description": "Try 802.1X first, then MAB if 802.1X fails",
          "recommended": false,
          "policyMap": "policy-map type control subscriber DOT1X_MAB_POLICY\n event session-started match-all\n  10 class always do-until-failure\n   10 authenticate using dot1x priority 10\n event authentication-failure match-first\n  5 class DOT1X_FAILED do-until-failure\n   10 terminate dot1x\n   20 authenticate using mab priority 20\n  ..."
        },
        {
          "id": "concurrent",
          "name": "Concurrent",
          "description": "Try 802.1X and MAB simultaneously (unofficial)",
          "recommended": true,
          "policyMap": "policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY\n event session-started match-all\n  10 class always do-all\n   10 authenticate using dot1x priority 10\n   20 authenticate using mab priority 20\n  ..."
        }
      ],
      "securityFeatures": [
        {
          "id": "bpdu-guard",
          "name": "BPDU Guard",
          "description": "Protect against Layer 2 loops by disabling port if BPDU received",
          "enabled": true,
          "config": "spanning-tree bpduguard enable"
        },
        {
          "id": "port-fast",
          "name": "PortFast",
          "description": "Bypass spanning-tree listening and learning states",
          "enabled": true,
          "config": "spanning-tree portfast"
        },
        {
          "id": "storm-control",
          "name": "Storm Control",
          "description": "Limit broadcast, multicast, or unicast storms",
          "enabled": true,
          "threshold": 100,
          "config": "storm-control broadcast level pps {{threshold}} 80\nstorm-control action trap"
        },
        {
          "id": "dhcp-snooping",
          "name": "DHCP Snooping",
          "description": "Protect against rogue DHCP servers and DHCP starvation attacks",
          "enabled": true,
          "config": "ip dhcp snooping\nip dhcp snooping vlan 1-4094\nip dhcp snooping information option\nip dhcp snooping limit rate 20"
        },
        {
          "id": "arp-inspection",
          "name": "Dynamic ARP Inspection",
          "description": "Protect against ARP spoofing and man-in-the-middle attacks",
          "enabled": true,
          "config": "ip arp inspection vlan 1-4094\nip arp inspection validate src-mac dst-mac ip"
        },
        {
          "id": "ip-source-guard",
          "name": "IP Source Guard",
          "description": "Restrict IP traffic based on DHCP snooping database",
          "enabled": true,
          "config": "ip verify source"
        }
      ],
      "criticalAuthSettings": {
        "enabled": true,
        "dataVlan": 999,
        "voiceVlan": 999,
        "recoveryDelay": 2000,
        "config": "service-template CRITICAL_DATA_ACCESS\n vlan {{dataVlan}}\n access-group ACL-OPEN\nservice-template CRITICAL_VOICE_ACCESS\n voice vlan {{voiceVlan}}\n access-group ACL-OPEN\nauthentication critical recovery delay {{recoveryDelay}}"
      }
    },
    "ibns": {
      "classMapDot1x": {
        "description": "Class maps for 802.1X authentication",
        "config": "class-map type control subscriber match-all DOT1X\n match method dot1x\n\nclass-map type control subscriber match-all DOT1X_FAILED\n match method dot1x\n match result-type method dot1x authoritative\n\nclass-map type control subscriber match-all DOT1X_NO_RESP\n match method dot1x\n match result-type method dot1x agent-not-found\n\nclass-map type control subscriber match-all DOT1X_TIMEOUT\n match method dot1x\n match result-type method dot1x method-timeout\n match result-type method-timeout"
      },
      "classMapMab": {
        "description": "Class maps for MAC Authentication Bypass",
        "config": "class-map type control subscriber match-all MAB\n match method mab\n\nclass-map type control subscriber match-all MAB_FAILED\n match method mab\n match result-type method mab authoritative"
      },
      "classMapCritical": {
        "description": "Class maps for Critical Authentication",
        "config": "class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST\n match result-type aaa-timeout\n match authorization-status authorized\n\nclass-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST\n match result-type aaa-timeout\n match authorization-status unauthorized\n\nclass-map type control subscriber match-any IN_CRITICAL_AUTH\n match activated-service-template CRITICAL_DATA_ACCESS\n match activated-service-template CRITICAL_VOICE_ACCESS\n\nclass-map type control subscriber match-none NOT_IN_CRITICAL_AUTH\n match activated-service-template CRITICAL_DATA_ACCESS\n match activated-service-template CRITICAL_VOICE_ACCESS"
      },
      "classMapMisc": {
        "description": "Miscellaneous class maps",
        "config": "class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL\n match authorization-status unauthorized\n match result-type success"
      },
      "policyMapEvents": [
        {
          "id": "session-started",
          "name": "Session Started Event",
          "description": "Actions when a new session is detected",
          "options": [
            {
              "id": "sequential",
              "name": "Sequential Authentication",
              "description": "Try 802.1X first, then MAB if 802.1X fails",
              "config": "event session-started match-all\n 10 class always do-until-failure\n  10 authenticate using dot1x priority 10"
            },
            {
              "id": "concurrent",
              "name": "Concurrent Authentication",
              "description": "Try 802.1X and MAB simultaneously",
              "recommended": true,
              "config": "event session-started match-all\n 10 class always do-all\n  10 authenticate using dot1x priority 10\n  20 authenticate using mab priority 20"
            }
          ]
        },
        {
          "id": "authentication-failure",
          "name": "Authentication Failure Event",
          "description": "Actions when authentication fails",
          "config": "event authentication-failure match-first\n 5 class DOT1X_FAILED do-until-failure\n  10 terminate dot1x\n  20 authenticate using mab priority 20\n 10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n  10 clear-authenticated-data-hosts-on-port\n  20 activate service-template CRITICAL_DATA_ACCESS\n  30 activate service-template CRITICAL_VOICE_ACCESS\n  40 authorize\n  50 pause reauthentication\n 20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n  10 pause reauthentication\n  20 authorize\n 30 class DOT1X_NO_RESP do-until-failure\n  10 terminate dot1x\n  20 authenticate using mab priority 20\n 40 class DOT1X_TIMEOUT do-until-failure\n  10 terminate dot1x\n  20 authenticate using mab priority 20\n 50 class always do-until-failure\n  10 terminate dot1x\n  20 terminate mab\n  30 authentication-restart 60"
        },
        {
          "id": "agent-found",
          "name": "Agent Found Event",
          "description": "Actions when 802.1X supplicant is detected after MAB started",
          "config": "event agent-found match-all\n 10 class always do-until-failure\n  10 terminate mab\n  20 authenticate using dot1x priority 10"
        },
        {
          "id": "aaa-available",
          "name": "AAA Available Event",
          "description": "Actions when AAA server becomes available after being down",
          "config": "event aaa-available match-all\n 10 class IN_CRITICAL_AUTH do-until-failure\n  10 clear-session\n 20 class NOT_IN_CRITICAL_AUTH do-until-failure\n  10 resume reauthentication"
        },
        {
          "id": "inactivity-timeout",
          "name": "Inactivity Timeout Event",
          "description": "Actions when session is inactive for configured time",
          "config": "event inactivity-timeout match-all\n 10 class always do-until-failure\n  10 clear-session"
        },
        {
          "id": "authentication-success",
          "name": "Authentication Success Event",
          "description": "Actions when authentication succeeds",
          "options": [
            {
              "id": "standard",
              "name": "Standard",
              "description": "No additional actions",
              "config": "event authentication-success match-all\n 10 class always do-until-failure\n  10 no-op"
            },
            {
              "id": "macsec",
              "name": "MACSec Encryption",
              "description": "Enable MACSec encryption if supported",
              "config": "event authentication-success match-all\n 10 class always do-until-failure\n  10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE"
            }
          ]
        }
      ]
    },
    "deviceTracking": {
      "enabled": true,
      "description": "IP Device Tracking for IBNS 2.0",
      "trackingOptions": [
        {
          "id": "access-policy",
          "name": "Access Port Policy",
          "description": "Device tracking policy for access ports",
          "config": "device-tracking policy IP-TRACKING\n limit address-count 4\n security-level glean\n no protocol ndp\n no protocol dhcp6\n tracking enable reachable-lifetime 30"
        },
        {
          "id": "trunk-policy",
          "name": "Trunk Port Policy",
          "description": "Device tracking policy for trunk ports",
          "config": "device-tracking policy DISABLE-IP-TRACKING\n tracking disable\n trusted-port\n device-role switch"
        }
      ],
      "globalConfig": "device-tracking tracking auto-source"
    },
    "deviceSensor": {
      "enabled": true,
      "description": "Device Sensor for Profiling",
      "protocols": [
        {
          "id": "dhcp",
          "name": "DHCP",
          "enabled": true,
          "options": [
            "host-name",
            "requested-address",
            "parameter-request-list",
            "class-identifier",
            "client-identifier"
          ],
          "config": "device-sensor filter-list dhcp list DS_DHCP_LIST\n option name host-name\n option name requested-address\n option name parameter-request-list\n option name class-identifier\n option name client-identifier\ndevice-sensor filter-spec dhcp include list DS_DHCP_LIST"
        },
        {
          "id": "cdp",
          "name": "CDP",
          "enabled": true,
          "options": [
            "device-name",
            "address-type",
            "capabilities-type",
            "platform-type",
            "version-type"
          ],
          "config": "cdp run\ndevice-sensor filter-list cdp list DS_CDP_LIST\n tlv name device-name\n tlv name address-type\n tlv name capabilities-type\n tlv name platform-type\n tlv name version-type\ndevice-sensor filter-spec cdp include list DS_CDP_LIST"
        },
        {
          "id": "lldp",
          "name": "LLDP",
          "enabled": true,
          "options": [
            "system-name",
            "system-description",
            "system-capabilities"
          ],
          "config": "lldp run\ndevice-sensor filter-list lldp list DS_LLDP_LIST\n tlv name system-name\n tlv name system-description\n tlv name system-capabilities\ndevice-sensor filter-spec lldp include list DS_LLDP_LIST"
        }
      ],
      "globalConfig": "device-sensor notify all-changes\naccess-session attributes filter-list list DS_SEND_LIST\n cdp\n lldp\n dhcp\naccess-session accounting attributes filter-spec include list DS_SEND_LIST\naccess-session authentication attributes filter-spec include list DS_SEND_LIST"
    },
    "acls": [
      {
        "id": "acl-open",
        "name": "ACL-OPEN",
        "description": "Open access ACL for pre-authentication or critical authentication",
        "config": "ip access-list extended ACL-OPEN\n permit ip any any"
      },
      {
        "id": "acl-default",
        "name": "ACL-DEFAULT",
        "description": "Default restrictive ACL",
        "config": "ip access-list extended ACL-DEFAULT\n permit udp any eq bootpc any eq bootps\n permit udp any any eq domain\n permit icmp any any echo-reply\n permit icmp any any time-exceeded\n permit icmp any any unreachable\n deny ip any any"
      },
      {
        "id": "acl-auth-server",
        "name": "ACL-AUTH-SERVER",
        "description": "ACL to allow access to authentication servers only",
        "config": "ip access-list extended ACL-AUTH-SERVER\n permit udp any eq bootpc any eq bootps\n permit udp any any eq domain\n permit ip any host {{radius.servers[0].ip}}\n permit ip any host {{radius.servers[1].ip}}\n deny ip any any"
      },
      {
        "id": "acl-guest",
        "name": "ACL-GUEST",
        "description": "ACL for guest access",
        "config": "ip access-list extended ACL-GUEST\n permit udp any eq bootpc any eq bootps\n permit udp any any eq domain\n permit tcp any any eq www\n permit tcp any any eq 443\n permit tcp any any eq 8080\n deny ip any any"
      }
    ],
    "radsec": {
      "enabled": false,
      "description": "RadSec (RADIUS over TLS)",
      "serverConfig": "radius server {{radsec.serverName}}\n address ipv4 {{radsec.serverIP}} auth-port 2083 acct-port 2083\n tls connectiontimeout 5\n tls trustpoint client {{radsec.clientTrustpoint}}\n tls trustpoint server {{radsec.serverTrustpoint}}\n key {{radsec.serverKey}}",
      "serverGroupConfig": "aaa group server radius {{radsec.serverGroup}}\n server name {{radsec.serverName}}"
    },
    "macsec": {
      "enabled": false,
      "description": "MACsec (802.1AE)",
      "policy": [
        {
          "id": "should-secure",
          "name": "Should Secure",
          "description": "Prefer encryption but allow non-encrypted traffic",
          "recommended": true,
          "serviceName": "DEFAULT_LINKSEC_POLICY_SHOULD_SECURE"
        },
        {
          "id": "must-secure",
          "name": "Must Secure",
          "description": "Require encryption (blocks non-encrypted traffic)",
          "recommended": false,
          "serviceName": "DEFAULT_LINKSEC_POLICY_MUST_SECURE"
        }
      ]
    }
  },
  "ios-xe": {
    "tacacs": {
      "authenticationMethods": [
        {
          "id": "group-local",
          "name": "TACACS+ Group then Local",
          "description": "Authenticate using TACACS+ server group first, then fallback to local database if server unreachable",
          "recommended": true,
          "config": "aaa authentication login default group {{tacacs.serverGroup}} local"
        },
        {
          "id": "local-group",
          "name": "Local then TACACS+ Group",
          "description": "Authenticate using local database first, then try TACACS+ server group",
          "recommended": false,
          "config": "aaa authentication login default local group {{tacacs.serverGroup}}"
        },
        {
          "id": "group-only",
          "name": "TACACS+ Group Only",
          "description": "Authenticate using TACACS+ server group only, no fallback (warning: may lock out access)",
          "recommended": false,
          "config": "aaa authentication login default group {{tacacs.serverGroup}}"
        }
      ],
      "authorizationMethods": [
        {
          "id": "commands-15",
          "name": "Command Authorization (Privilege 15)",
          "description": "Authorize EXEC commands at privilege level 15 through TACACS+",
          "recommended": true,
          "config": "aaa authorization commands 15 default group {{tacacs.serverGroup}} if-authenticated local"
        },
        {
          "id": "commands-all",
          "name": "Command Authorization (All Levels)",
          "description": "Authorize EXEC commands at all privilege levels through TACACS+",
          "recommended": false,
          "config": "aaa authorization commands 0 default group {{tacacs.serverGroup}} if-authenticated local\naaa authorization commands 1 default group {{tacacs.serverGroup}} if-authenticated local\naaa authorization commands 15 default group {{tacacs.serverGroup}} if-authenticated local"
        },
        {
          "id": "exec-only",
          "name": "EXEC Authorization Only",
          "description": "Authorize EXEC sessions without per-command authorization",
          "recommended": false,
          "config": "aaa authorization exec default group {{tacacs.serverGroup}} if-authenticated local"
        }
      ],
      "accountingMethods": [
        {
          "id": "commands-15",
          "name": "Command Accounting (Privilege 15)",
          "description": "Log all commands at privilege level 15 to TACACS+ server",
          "recommended": true,
          "config": "aaa accounting commands 15 default start-stop group {{tacacs.serverGroup}}"
        },
        {
          "id": "commands-all",
          "name": "Command Accounting (All Levels)",
          "description": "Log all commands at all privilege levels to TACACS+ server",
          "recommended": false,
          "config": "aaa accounting commands 0 default start-stop group {{tacacs.serverGroup}}\naaa accounting commands 1 default start-stop group {{tacacs.serverGroup}}\naaa accounting commands 15 default start-stop group {{tacacs.serverGroup}}"
        },
        {
          "id": "exec-accounting",
          "name": "EXEC Session Accounting",
          "description": "Log EXEC session start and stop to TACACS+ server",
          "recommended": true,
          "config": "aaa accounting exec default start-stop group {{tacacs.serverGroup}}"
        }
      ],
      "serverOptions": [
        {
          "id": "server-timeout",
          "name": "Server Timeout",
          "description": "Timeout in seconds before trying next server",
          "default": 5,
          "min": 1,
          "max": 60,
          "config": "timeout {{value}}"
        },
        {
          "id": "key-encryption",
          "name": "Key Encryption Type",
          "description": "Method of key encryption for TACACS+ server",
          "options": [
            {
              "id": "type-0",
              "name": "Type 0 (Clear Text)",
              "recommended": false
            },
            {
              "id": "type-7",
              "name": "Type 7 (Weak Encryption)",
              "recommended": false
            },
            {
              "id": "type-8",
              "name": "Type 8 (PBKDF2 SHA-256)",
              "recommended": true
            }
          ],
          "config": "key {{type}} {{key}}"
        },
        {
          "id": "single-connection",
          "name": "Single Connection",
          "description": "Maintain a single TCP connection for all TACACS+ communication",
          "default": true,
          "config": "single-connection"
        }
      ]
    },
    "radius": {
      "authenticationMethods": [
        {
          "id": "dot1x-default",
          "name": "802.1X Default",
          "description": "Authentication method for 802.1X",
          "recommended": true,
          "config": "aaa authentication dot1x default group {{radius.serverGroup}}"
        },
        {
          "id": "login-radius-local",
          "name": "Login RADIUS then Local",
          "description": "Login using RADIUS server group first, then fallback to local database",
          "recommended": true,
          "config": "aaa authentication login default group {{radius.serverGroup}} local"
        }
      ],
      "authorizationMethods": [
        {
          "id": "network-default",
          "name": "Network Authorization",
          "description": "Authorization for network services (VLAN, dACL, etc.)",
          "recommended": true,
          "config": "aaa authorization network default group {{radius.serverGroup}}"
        },
        {
          "id": "auth-proxy",
          "name": "Auth-Proxy Authorization",
          "description": "Authorization for authentication proxy",
          "recommended": false,
          "config": "aaa authorization auth-proxy default group {{radius.serverGroup}}"
        }
      ],
      "accountingMethods": [
        {
          "id": "network-acct",
          "name": "Network Accounting",
          "description": "Accounting for network services",
          "recommended": true,
          "config": "aaa accounting network default start-stop group {{radius.serverGroup}}"
        },
        {
          "id": "dot1x-acct",
          "name": "802.1X Accounting",
          "description": "Accounting for 802.1X sessions",
          "recommended": true,
          "config": "aaa accounting dot1x default start-stop group {{radius.serverGroup}}"
        },
        {
          "id": "identity-acct",
          "name": "Identity Accounting",
          "description": "Accounting for identity sessions (authentication manager)",
          "recommended": true,
          "config": "aaa accounting identity default start-stop group {{radius.serverGroup}}"
        }
      ],
      "serverOptions": [
        {
          "id": "server-timeout",
          "name": "Server Timeout",
          "description": "Timeout in seconds before trying next server",
          "default": 5,
          "min": 1,
          "max": 60,
          "config": "timeout {{value}}"
        },
        {
          "id": "retransmit",
          "name": "Retransmit Count",
          "description": "Number of times to retransmit request to server",
          "default": 2,
          "min": 1,
          "max": 10,
          "config": "retransmit {{value}}"
        },
        {
          "id": "key-encryption",
          "name": "Key Encryption Type",
          "description": "Method of key encryption for RADIUS server",
          "options": [
            {
              "id": "type-0",
              "name": "Type 0 (Clear Text)",
              "recommended": false
            },
            {
              "id": "type-7",
              "name": "Type 7 (Weak Encryption)",
              "recommended": false
            },
            {
              "id": "type-8",
              "name": "Type 8 (PBKDF2 SHA-256)",
              "recommended": true
            }
          ],
          "config": "key {{type}} {{key}}"
        },
        {
          "id": "source-interface",
          "name": "Source Interface",
          "description": "Interface to use for RADIUS packets",
          "default": "Vlan10",
          "config": "ip radius source-interface {{value}}"
        },
        {
          "id": "server-probe",
          "name": "Server Test",
          "description": "Probe radius server periodically to verify it's available",
          "default": true,
          "config": "automate-tester username {{testUsername}} probe-on"
        }
      ],
      "loadBalancingMethods": [
        {
          "id": "none",
          "name": "No Load Balancing",
          "description": "Primary/Secondary server model",
          "recommended": false
        },
        {
          "id": "least-outstanding",
          "name": "Least Outstanding",
          "description": "Send new requests to the server with the fewest pending requests",
          "recommended": true,
          "config": "radius-server load-balance method least-outstanding"
        },
        {
          "id": "host-hash",
          "name": "Host Hash",
          "description": "Distribute based on a hash of the client IP",
          "recommended": false,
          "config": "radius-server load-balance method host-hash"
        },
        {
          "id": "batch",
          "name": "Batch",
          "description": "Send batches of requests to each server in round-robin fashion",
          "recommended": false,
          "config": "radius-server load-balance method batch"
        }
      ],
      "deadtimeSettings": {
        "enabled": true,
        "description": "Time in minutes to skip unresponsive servers",
        "default": 15,
        "min": 1,
        "max": 60,
        "config": "deadtime {{value}}"
      },
      "deadCriteriaSettings": {
        "enabled": true,
        "time": {
          "description": "Time in seconds without response to mark server as dead",
          "default": 5,
          "min": 1,
          "max": 120
        },
        "tries": {
          "description": "Number of consecutive timeouts to mark server as dead",
          "default": 3,
          "min": 1,
          "max": 10
        },
        "config": "radius-server dead-criteria time {{time}} tries {{tries}}"
      }
    },
    "dot1x": {
      "portSettings": [
        {
          "id": "host-mode",
          "name": "Host Mode",
          "description": "How many and what type of devices can authenticate on a port",
          "options": [
            {
              "id": "single-host",
              "name": "Single Host",
              "description": "Only one MAC address can authenticate on the port",
              "recommended": false,
              "config": "access-session host-mode single-host"
            },
            {
              "id": "multi-auth",
              "name": "Multi-Auth",
              "description": "Multiple devices can authenticate independently",
              "recommended": true,
              "config": "access-session host-mode multi-auth"
            },
            {
              "id": "multi-domain",
              "name": "Multi-Domain",
              "description": "One device in data domain and one in voice domain",
              "recommended": false,
              "config": "access-session host-mode multi-domain"
            },
            {
              "id": "multi-host",
              "name": "Multi-Host",
              "description": "One device authenticates and others get access (not secure)",
              "recommended": false,
              "config": "access-session host-mode multi-host"
            }
          ]
        },
        {
          "id": "control-direction",
          "name": "Control Direction",
          "description": "Direction of traffic control during authentication",
          "options": [
            {
              "id": "both",
              "name": "Both",
              "description": "Block both directions before authentication",
              "recommended": false,
              "config": "access-session control-direction both"
            },
            {
              "id": "in",
              "name": "In",
              "description": "Only block inbound traffic before authentication",
              "recommended": true,
              "config": "access-session control-direction in"
            }
          ]
        },
        {
          "id": "port-control",
          "name": "Port Control",
          "description": "How 802.1X controls the port",
          "options": [
            {
              "id": "auto",
              "name": "Auto",
              "description": "Authentication required for network access",
              "recommended": true,
              "config": "access-session port-control auto"
            },
            {
              "id": "force-authorized",
              "name": "Force Authorized",
              "description": "Always allow access (no authentication)",
              "recommended": false,
              "config": "access-session port-control force-authorized"
            },
            {
              "id": "force-unauthorized",
              "name": "Force Unauthorized",
              "description": "Never allow access (always block)",
              "recommended": false,
              "config": "access-session port-control force-unauthorized"
            }
          ]
        },
        {
          "id": "open-auth",
          "name": "Open Authentication",
          "description": "Allow network access before authentication (monitor mode)",
          "options": [
            {
              "id": "disabled",
              "name": "Disabled (Closed Mode)",
              "description": "Block access until authentication succeeds",
              "recommended": true,
              "config": "access-session closed"
            },
            {
              "id": "enabled",
              "name": "Enabled (Open/Monitor Mode)",
              "description": "Allow access regardless of authentication result",
              "recommended": false,
              "config": ""
            }
          ]
        },
        {
          "id": "periodic-reauthentication",
          "name": "Periodic Re-Authentication",
          "description": "Require clients to re-authenticate periodically",
          "enabled": true,
          "config": "authentication periodic\nauthentication timer reauthenticate server"
        },
        {
          "id": "inactivity-timeout",
          "name": "Inactivity Timeout",
          "description": "Remove authenticated clients after period of inactivity",
          "enabled": true,
          "value": 60,
          "config": "subscriber aging inactivity-timer {{value}} probe"
        }
      ],
      "dot1xSettings": [
        {
          "id": "tx-period",
          "name": "Tx Period",
          "description": "How often to send EAP requests to clients",
          "default": 7,
          "min": 1,
          "max": 65535,
          "config": "dot1x timeout tx-period {{value}}"
        },
        {
          "id": "max-reauth-req",
          "name": "Max Re-Auth Requests",
          "description": "Number of re-authentication attempts before failing",
          "default": 2,
          "min": 1,
          "max": 10,
          "config": "dot1x max-reauth-req {{value}}"
        },
        {
          "id": "quiet-period",
          "name": "Quiet Period",
          "description": "Time in seconds to wait after authentication failure",
          "default": 60,
          "min": 1,
          "max": 65535,
          "config": "dot1x timeout quiet-period {{value}}"
        },
        {
          "id": "critical-eapol",
          "name": "Critical EAPOL",
          "description": "Send EAPOL success when entering critical authentication mode",
          "enabled": true,
          "config": "dot1x critical eapol"
        }
      ],
      "mabSettings": [
        {
          "id": "auth-type",
          "name": "MAB Authentication Type",
          "description": "How MAB formats the authentication request",
          "options": [
            {
              "id": "eap",
              "name": "EAP",
              "description": "Send as EAP credential (recommended for ISE)",
              "recommended": true,
              "config": "mab request format attribute 1 groupsize 12"
            },
            {
              "id": "pap",
              "name": "PAP",
              "description": "Send as PAP credential",
              "recommended": false,
              "config": "mab request format attribute 1 groupsize 12 separator -"
            },
            {
              "id": "chap",
              "name": "CHAP",
              "description": "Send as CHAP credential",
              "recommended": false,
              "config": "mab request format attribute 1 groupsize 12 separator - chap"
            }
          ]
        }
      ],
      "deploymentOptions": [
        {
          "id": "sequential",
          "name": "Sequential",
          "description": "Try 802.1X first, then MAB if 802.1X fails",
          "recommended": false,
          "policyMap": "policy-map type control subscriber DOT1X_MAB_POLICY\n event session-started match-all\n  10 class always do-until-failure\n   10 authenticate using dot1x priority 10\n event authentication-failure match-first\n  5 class DOT1X_FAILED do-until-failure\n   10 terminate dot1x\n   20 authenticate using mab priority 20\n  ..."
        },
        {
          "id": "concurrent",
          "name": "Concurrent",
          "description": "Try 802.1X and MAB simultaneously (unofficial)",
          "recommended": true,
          "policyMap": "policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY\n event session-started match-all\n  10 class always do-all\n   10 authenticate using dot1x priority 10\n   20 authenticate using mab priority 20\n  ..."
        }
      ],
      "securityFeatures": [
        {
          "id": "bpdu-guard",
          "name": "BPDU Guard",
          "description": "Protect against Layer 2 loops by disabling port if BPDU received",
          "enabled": true,
          "config": "spanning-tree bpduguard enable"
        },
        {
          "id": "port-fast",
          "name": "PortFast",
          "description": "Bypass spanning-tree listening and learning states",
          "enabled": true,
          "config": "spanning-tree portfast"
        },
        {
          "id": "storm-control",
          "name": "Storm Control",
          "description": "Limit broadcast, multicast, or unicast storms",
          "enabled": true,
          "threshold": 100,
          "config": "storm-control broadcast level pps {{threshold}} 80\nstorm-control action trap"
        },
        {
          "id": "dhcp-snooping",
          "name": "DHCP Snooping",
          "description": "Protect against rogue DHCP servers and DHCP starvation attacks",
          "enabled": true,
          "config": "ip dhcp snooping\nip dhcp snooping vlan 1-4094\nip dhcp snooping information option\nip dhcp snooping limit rate 20"
        },
        {
          "id": "arp-inspection",
          "name": "Dynamic ARP Inspection",
          "description": "Protect against ARP spoofing and man-in-the-middle attacks",
          "enabled": true,
          "config": "ip arp inspection vlan 1-4094\nip arp inspection validate src-mac dst-mac ip"
        },
        {
          "id": "ip-source-guard",
          "name": "IP Source Guard",
          "description": "Restrict IP traffic based on DHCP snooping database",
          "enabled": true,
          "config": "ip verify source"
        }
      ],
      "criticalAuthSettings": {
        "enabled": true,
        "dataVlan": 999,
        "voiceVlan": 999,
        "recoveryDelay": 2000,
        "config": "service-template CRITICAL_DATA_ACCESS\n vlan {{dataVlan}}\n access-group ACL-OPEN\nservice-template CRITICAL_VOICE_ACCESS\n voice vlan {{voiceVlan}}\n access-group ACL-OPEN\nauthentication critical recovery delay {{recoveryDelay}}"
      }
    },
    "ibns": {
      "classMapDot1x": {
        "description": "Class maps for 802.1X authentication",
        "config": "class-map type control subscriber match-all DOT1X\n match method dot1x\n\nclass-map type control subscriber match-all DOT1X_FAILED\n match method dot1x\n match result-type method dot1x authoritative\n\nclass-map type control subscriber match-all DOT1X_NO_RESP\n match method dot1x\n match result-type method dot1x agent-not-found\n\nclass-map type control subscriber match-all DOT1X_TIMEOUT\n match method dot1x\n match result-type method dot1x method-timeout\n match result-type method-timeout"
      },
      "classMapMab": {
        "description": "Class maps for MAC Authentication Bypass",
        "config": "class-map type control subscriber match-all MAB\n match method mab\n\nclass-map type control subscriber match-all MAB_FAILED\n match method mab\n match result-type method mab authoritative"
      },
      "classMapCritical": {
        "description": "Class maps for Critical Authentication",
        "config": "class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST\n match result-type aaa-timeout\n match authorization-status authorized\n\nclass-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST\n match result-type aaa-timeout\n match authorization-status unauthorized\n\nclass-map type control subscriber match-any IN_CRITICAL_AUTH\n match activated-service-template CRITICAL_DATA_ACCESS\n match activated-service-template CRITICAL_VOICE_ACCESS\n\nclass-map type control subscriber match-none NOT_IN_CRITICAL_AUTH\n match activated-service-template CRITICAL_DATA_ACCESS\n match activated-service-template CRITICAL_VOICE_ACCESS"
      },
      "classMapMisc": {
        "description": "Miscellaneous class maps",
        "config": "class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL\n match authorization-status unauthorized\n match result-type success"
      },
      "policyMapEvents": [
        {
          "id": "session-started",
          "name": "Session Started Event",
          "description": "Actions when a new session is detected",
          "options": [
            {
              "id": "sequential",
              "name": "Sequential Authentication",
              "description": "Try 802.1X first, then MAB if 802.1X fails",
              "config": "event session-started match-all\n 10 class always do-until-failure\n  10 authenticate using dot1x priority 10"
            },
            {
              "id": "concurrent",
              "name": "Concurrent Authentication",
              "description": "Try 802.1X and MAB simultaneously",
              "recommended": true,
              "config": "event session-started match-all\n 10 class always do-all\n  10 authenticate using dot1x priority 10\n  20 authenticate using mab priority 20"
            }
          ]
        },
        {
          "id": "authentication-failure",
          "name": "Authentication Failure Event",
          "description": "Actions when authentication fails",
          "config": "event authentication-failure match-first\n 5 class DOT1X_FAILED do-until-failure\n  10 terminate dot1x\n  20 authenticate using mab priority 20\n 10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n  10 clear-authenticated-data-hosts-on-port\n  20 activate service-template CRITICAL_DATA_ACCESS\n  30 activate service-template CRITICAL_VOICE_ACCESS\n  40 authorize\n  50 pause reauthentication\n 20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n  10 pause reauthentication\n  20 authorize\n 30 class DOT1X_NO_RESP do-until-failure\n  10 terminate dot1x\n  20 authenticate using mab priority 20\n 40 class DOT1X_TIMEOUT do-until-failure\n  10 terminate dot1x\n  20 authenticate using mab priority 20\n 50 class always do-until-failure\n  10 terminate dot1x\n  20 terminate mab\n  30 authentication-restart 60"
        },
        {
          "id": "agent-found",
          "name": "Agent Found Event",
          "description": "Actions when 802.1X supplicant is detected after MAB started",
          "config": "event agent-found match-all\n 10 class always do-until-failure\n  10 terminate mab\n  20 authenticate using dot1x priority 10"
        },
        {
          "id": "aaa-available",
          "name": "AAA Available Event",
          "description": "Actions when AAA server becomes available after being down",
          "config": "event aaa-available match-all\n 10 class IN_CRITICAL_AUTH do-until-failure\n  10 clear-session\n 20 class NOT_IN_CRITICAL_AUTH do-until-failure\n  10 resume reauthentication"
        },
        {
          "id": "inactivity-timeout",
          "name": "Inactivity Timeout Event",
          "description": "Actions when session is inactive for configured time",
          "config": "event inactivity-timeout match-all\n 10 class always do-until-failure\n  10 clear-session"
        },
        {
          "id": "authentication-success",
          "name": "Authentication Success Event",
          "description": "Actions when authentication succeeds",
          "options": [
            {
              "id": "standard",
              "name": "Standard",
              "description": "No additional actions",
              "config": "event authentication-success match-all\n 10 class always do-until-failure\n  10 no-op"
            },
            {
              "id": "macsec",
              "name": "MACSec Encryption",
              "description": "Enable MACSec encryption if supported",
              "config": "event authentication-success match-all\n 10 class always do-until-failure\n  10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE"
            }
          ]
        }
      ]
    },
    "deviceTracking": {
      "enabled": true,
      "description": "IP Device Tracking for IBNS 2.0",
      "trackingOptions": [
        {
          "id": "access-policy",
          "name": "Access Port Policy",
          "description": "Device tracking policy for access ports",
          "config": "device-tracking policy IP-TRACKING\n limit address-count 4\n security-level glean\n no protocol ndp\n no protocol dhcp6\n tracking enable reachable-lifetime 30"
        },
        {
          "id": "trunk-policy",
          "name": "Trunk Port Policy",
          "description": "Device tracking policy for trunk ports",
          "config": "device-tracking policy DISABLE-IP-TRACKING\n tracking disable\n trusted-port\n device-role switch"
        }
      ],
      "globalConfig": "device-tracking tracking auto-source"
    },
    "deviceSensor": {
      "enabled": true,
      "description": "Device Sensor for Profiling",
      "protocols": [
        {
          "id": "dhcp",
          "name": "DHCP",
          "enabled": true,
          "options": [
            "host-name",
            "requested-address",
            "parameter-request-list",
            "class-identifier",
            "client-identifier"
          ],
          "config": "device-sensor filter-list dhcp list DS_DHCP_LIST\n option name host-name\n option name requested-address\n option name parameter-request-list\n option name class-identifier\n option name client-identifier\ndevice-sensor filter-spec dhcp include list DS_DHCP_LIST"
        },
        {
          "id": "cdp",
          "name": "CDP",
          "enabled": true,
          "options": [
            "device-name",
            "address-type",
            "capabilities-type",
            "platform-type",
            "version-type"
          ],
          "config": "cdp run\ndevice-sensor filter-list cdp list DS_CDP_LIST\n tlv name device-name\n tlv name address-type\n tlv name capabilities-type\n tlv name platform-type\n tlv name version-type\ndevice-sensor filter-spec cdp include list DS_CDP_LIST"
        },
        {
          "id": "lldp",
          "name": "LLDP",
          "enabled": true,
          "options": [
            "system-name",
            "system-description",
            "system-capabilities"
          ],
          "config": "lldp run\ndevice-sensor filter-list lldp list DS_LLDP_LIST\n tlv name system-name\n tlv name system-description\n tlv name system-capabilities\ndevice-sensor filter-spec lldp include list DS_LLDP_LIST"
        }
      ],
      "globalConfig": "device-sensor notify all-changes\naccess-session attributes filter-list list DS_SEND_LIST\n cdp\n lldp\n dhcp\naccess-session accounting attributes filter-spec include list DS_SEND_LIST\naccess-session authentication attributes filter-spec include list DS_SEND_LIST"
    },
    "acls": [
      {
        "id": "acl-open",
        "name": "ACL-OPEN",
        "description": "Open access ACL for pre-authentication or critical authentication",
        "config": "ip access-list extended ACL-OPEN\n permit ip any any"
      },
      {
        "id": "acl-default",
        "name": "ACL-DEFAULT",
        "description": "Default restrictive ACL",
        "config": "ip access-list extended ACL-DEFAULT\n permit udp any eq bootpc any eq bootps\n permit udp any any eq domain\n permit icmp any any echo-reply\n permit icmp any any time-exceeded\n permit icmp any any unreachable\n deny ip any any"
      },
      {
        "id": "acl-auth-server",
        "name": "ACL-AUTH-SERVER",
        "description": "ACL to allow access to authentication servers only",
        "config": "ip access-list extended ACL-AUTH-SERVER\n permit udp any eq bootpc any eq bootps\n permit udp any any eq domain\n permit ip any host {{radius.servers[0].ip}}\n permit ip any host {{radius.servers[1].ip}}\n deny ip any any"
      },
      {
        "id": "acl-guest",
        "name": "ACL-GUEST",
        "description": "ACL for guest access",
        "config": "ip access-list extended ACL-GUEST\n permit udp any eq bootpc any eq bootps\n permit udp any any eq domain\n permit tcp any any eq www\n permit tcp any any eq 443\n permit tcp any any eq 8080\n deny ip any any"
      }
    ],
    "radsec": {
      "enabled": false,
      "description": "RadSec (RADIUS over TLS)",
      "serverConfig": "radius server {{radsec.serverName}}\n address ipv4 {{radsec.serverIP}} auth-port 2083 acct-port 2083\n tls connectiontimeout 5\n tls trustpoint client {{radsec.clientTrustpoint}}\n tls trustpoint server {{radsec.serverTrustpoint}}\n key {{radsec.serverKey}}",
      "serverGroupConfig": "aaa group server radius {{radsec.serverGroup}}\n server name {{radsec.serverName}}"
    },
    "macsec": {
      "enabled": false,
      "description": "MACsec (802.1AE)",
      "policy": [
        {
          "id": "should-secure",
          "name": "Should Secure",
          "description": "Prefer encryption but allow non-encrypted traffic",
          "recommended": true,
          "serviceName": "DEFAULT_LINKSEC_POLICY_SHOULD_SECURE"
        },
        {
          "id": "must-secure",
          "name": "Must Secure",
          "description": "Require encryption (blocks non-encrypted traffic)",
          "recommended": false,
          "serviceName": "DEFAULT_LINKSEC_POLICY_MUST_SECURE"
        }
      ]
    },
    "coa": {
      "enabled": true,
      "description": "Change of Authorization (RFC 3576)",
      "config": "aaa server radius dynamic-author\n client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}\n client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}\n auth-type any"
    }
  },
  "wlc-9800": {
    "tacacs": {
      "authenticationMethods": [
        {
          "id": "group-local",
          "name": "TACACS+ Group then Local",
          "description": "Authenticate using TACACS+ server group first, then fallback to local database if server unreachable",
          "recommended": true,
          "config": "aaa authentication login {{tacacs.authMethod}} group {{tacacs.serverGroup}} local"
        },
        {
          "id": "local-group",
          "name": "Local then TACACS+ Group",
          "description": "Authenticate using local database first, then try TACACS+ server group",
          "recommended": false,
          "config": "aaa authentication login {{tacacs.authMethod}} local group {{tacacs.serverGroup}}"
        },
        {
          "id": "group-only",
          "name": "TACACS+ Group Only",
          "description": "Authenticate using TACACS+ server group only, no fallback (warning: may lock out access)",
          "recommended": false,
          "config": "aaa authentication login {{tacacs.authMethod}} group {{tacacs.serverGroup}}"
        }
      ],
      "authorizationMethods": [
        {
          "id": "exec-auth",
          "name": "EXEC Authorization",
          "description": "Authorize EXEC sessions through TACACS+",
          "recommended": true,
          "config": "aaa authorization exec {{tacacs.authzMethod}} group {{tacacs.serverGroup}} local if-authenticated"
        }
      ],
      "consoleAuthorization": {
        "enabled": true,
        "description": "Enable authorization for console connections",
        "config": "aaa authorization console"
      },
      "accountingMethods": [
        {
          "id": "commands-0",
          "name": "Command Accounting (Level 0)",
          "description": "Log all commands at privilege level 0 to TACACS+ server",
          "recommended": true,
          "config": "aaa accounting commands 0 default start-stop group {{tacacs.serverGroup}}"
        },
        {
          "id": "commands-1",
          "name": "Command Accounting (Level 1)",
          "description": "Log all commands at privilege level 1 to TACACS+ server",
          "recommended": true,
          "config": "aaa accounting commands 1 default start-stop group {{tacacs.serverGroup}}"
        },
        {
          "id": "commands-15",
          "name": "Command Accounting (Level 15)",
          "description": "Log all commands at privilege level 15 to TACACS+ server",
          "recommended": true,
          "config": "aaa accounting commands 15 default start-stop group {{tacacs.serverGroup}}"
        }
      ],
      "serverOptions": [
        {
          "id": "server-timeout",
          "name": "Server Timeout",
          "description": "Timeout in seconds before trying next server",
          "default": 1,
          "min": 1,
          "max": 60,
          "config": "timeout {{value}}"
        },
        {
          "id": "key-encryption",
          "name": "Key Encryption Type",
          "description": "Method of key encryption for TACACS+ server",
          "options": [
            {
              "id": "type-0",
              "name": "Type 0 (Clear Text)",
              "recommended": false
            },
            {
              "id": "type-7",
              "name": "Type 7 (Weak Encryption)",
              "recommended": false
            },
            {
              "id": "type-8",
              "name": "Type 8 (PBKDF2 SHA-256)",
              "recommended": true
            }
          ],
          "config": "key {{type}} {{key}}"
        }
      ],
      "serviceConfig": {
        "authMethodList": "ML-TACACS-AUTHC",
        "authzMethodList": "ML-TACACS-AUTHZ",
        "webGui": {
          "enabled": true,
          "config": "ip http authentication aaa login-authentication {{tacacs.authMethod}}\nip http authentication aaa exec-authorization {{tacacs.authzMethod}}"
        },
        "netconf": {
          "enabled": true,
          "config": "yang-interfaces aaa authentication method-list {{tacacs.authMethod}}\nyang-interfaces aaa authorization method-list {{tacacs.authzMethod}}"
        },
        "sshVty": {
          "enabled": true,
          "timeout": 30,
          "config": "line vty 0 97\n exec-timeout {{timeout}} 0\n login authentication {{tacacs.authMethod}}\n authorization exec {{tacacs.authzMethod}}\n transport preferred none\n transport input ssh\n transport output none"
        },
        "consoleLine": {
          "enabled": true,
          "timeout": 15,
          "config": "line con 0\n exec-timeout {{timeout}} 0\n transport preferred none\n login authentication {{tacacs.authMethod}}\n authorization exec {{tacacs.authzMethod}}"
        }
      }
    },
    "radius": {
      "authenticationMethods": [
        {
          "id": "group-local",
          "name": "RADIUS Group then Local",
          "description": "Authenticate using RADIUS server group first, then fallback to local database if server unreachable",
          "recommended": true,
          "config": "aaa authentication login {{radius.authMethod}} group {{radius.serverGroup}} local"
        },
        {
          "id": "local-group",
          "name": "Local then RADIUS Group",
          "description": "Authenticate using local database first, then try RADIUS server group",
          "recommended": false,
          "config": "aaa authentication login {{radius.authMethod}} local group {{radius.serverGroup}}"
        },
        {
          "id": "group-only",
          "name": "RADIUS Group Only",
          "description": "Authenticate using RADIUS server group only, no fallback (warning: may lock out access)",
          "recommended": false,
          "config": "aaa authentication login {{radius.authMethod}} group {{radius.serverGroup}}"
        }
      ],
      "authorizationMethods": [
        {
          "id": "exec-auth",
          "name": "EXEC Authorization",
          "description": "Authorize EXEC sessions through RADIUS",
          "recommended": true,
          "config": "aaa authorization exec {{radius.authMethod}} group {{radius.serverGroup}} local if-authenticated"
        }
      ],
      "consoleAuthorization": {
        "enabled": true,
        "description": "Enable authorization for console connections",
        "config": "aaa authorization console"
      },
      "accountingMethods": [
        {
          "id": "exec-acct",
          "name": "EXEC Accounting",
          "description": "Log EXEC session start and stop to RADIUS server",
          "recommended": true,
          "config": "aaa accounting exec default start-stop group {{radius.serverGroup}}"
        }
      ],
      "serverOptions": [
        {
          "id": "server-timeout",
          "name": "Server Timeout",
          "description": "Timeout in seconds before trying next server",
          "default": 5,
          "min": 1,
          "max": 60,
          "config": "timeout {{value}}"
        },
        {
          "id": "retransmit",
          "name": "Retransmit Count",
          "description": "Number of times to retransmit request to server",
          "default": 2,
          "min": 1,
          "max": 10,
          "config": "retransmit {{value}}"
        },
        {
          "id": "key-encryption",
          "name": "Key Encryption Type",
          "description": "Method of key encryption for RADIUS server",
          "options": [
            {
              "id": "type-0",
              "name": "Type 0 (Clear Text)",
              "recommended": false
            },
            {
              "id": "type-7",
              "name": "Type 7 (Weak Encryption)",
              "recommended": false
            },
            {
              "id": "type-8",
              "name": "Type 8 (PBKDF2 SHA-256)",
              "recommended": true
            }
          ],
          "config": "key {{type}} {{key}}"
        },
        {
          "id": "server-probe",
          "name": "Server Test",
          "description": "Probe radius server periodically to verify it's available",
          "default": true,
          "config": "automate-tester username {{testUsername}} probe-on"
        }
      ],
      "loadBalancingMethods": [
        {
          "id": "none",
          "name": "No Load Balancing",
          "description": "Primary/Secondary server model",
          "recommended": false
        },
        {
          "id": "least-outstanding",
          "name": "Least Outstanding",
          "description": "Send new requests to the server with the fewest pending requests",
          "recommended": true,
          "config": "radius-server load-balance method least-outstanding"
        }
      ],
      "deadtimeSettings": {
        "enabled": true,
        "description": "Time in minutes to skip unresponsive servers",
        "default": 15,
        "min": 1,
        "max": 60,
        "config": "deadtime {{value}}"
      },
      "deadCriteriaSettings": {
        "enabled": true,
        "time": {
          "description": "Time in seconds without response to mark server as dead",
          "default": 5,
          "min": 1,
          "max": 120
        },
        "tries": {
          "description": "Number of consecutive timeouts to mark server as dead",
          "default": 3,
          "min": 1,
          "max": 10
        },
        "config": "radius-server dead-criteria time {{time}} tries {{tries}}"
      },
      "serviceConfig": {
        "authMethodList": "ML-RAD-ADMIN-AUTHC",
        "webGui": {
          "enabled": true,
          "config": "ip http authentication aaa login-authentication {{radius.authMethod}}\nip http authentication aaa exec-authorization {{radius.authMethod}}"
        },
        "netconf": {
          "enabled": true,
          "config": "yang-interfaces aaa authentication method-list {{radius.authMethod}}\nyang-interfaces aaa authorization method-list {{radius.authMethod}}"
        },
        "sshVty": {
          "enabled": true,
          "timeout": 30,
          "config": "line vty 0 97\n exec-timeout {{timeout}} 0\n login authentication {{radius.authMethod}}\n authorization exec {{radius.authMethod}}\n transport preferred none\n transport input ssh\n transport output none"
        },
        "consoleLine": {
          "enabled": true,
          "timeout": 15,
          "config": "line con 0\n exec-timeout {{timeout}} 0\n transport preferred none\n login authentication {{radius.authMethod}}\n authorization exec {{radius.authMethod}}"
        }
      }
    }
  }
}
EOF

# Create Aruba configuration options data
cat > data/aruba/config-options.json << 'EOF'
{
  "aos-cx": {
    "radius": {
      "serverConfig": "radius-server host {{radius.servers[0].ip}} key {{radius.servers[0].key}}\nradius-server host {{radius.servers[1].ip}} key {{radius.servers[1].key}}",
      "serverGroupConfig": "aaa group radius {{radius.serverGroup}}\n server {{radius.servers[0].ip}}\n server {{radius.servers[1].ip}}",
      "authenticationConfig": "aaa authentication dot1x default group {{radius.serverGroup}}",
      "authorizationConfig": "aaa authorization network default group {{radius.serverGroup}}",
      "accountingConfig": "aaa accounting dot1x default start-stop group {{radius.serverGroup}}"
    },
    "dot1x": {
      "globalConfig": "aaa authentication port-access dot1x authenticator",
      "interfaceConfig": "interface {{interfaces.access.range}}\n no shutdown\n aaa authentication port-access dot1x authenticator\n aaa port-access authenticator\n aaa port-access authenticator {{interfaces.access.range}} client-limit 3\n aaa port-access authenticator {{interfaces.access.range}} logoff-period 300\n aaa port-access authenticator {{interfaces.access.range}} max-requests 2\n aaa port-access authenticator {{interfaces.access.range}} max-retries {{interfaces.access.dot1x.maxReauthReq}}\n aaa port-access authenticator {{interfaces.access.range}} quiet-period 60\n aaa port-access authenticator {{interfaces.access.range}} server-timeout 30\n aaa port-access authenticator {{interfaces.access.range}} reauth-period 3600\n aaa port-access authenticator {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}\n aaa port-access authenticator {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}\n aaa port-access authenticator {{interfaces.access.range}} auth-vlan {{interfaces.access.vlan}}\n aaa port-access authenticator {{interfaces.access.range}} initialize\n aaa port-access authenticator active"
    },
    "mab": {
      "enabled": true,
      "description": "MAC Authentication",
      "config": "aaa authentication mac-based enable\naaa authentication mac-based address-format no-delimiter uppercase\naaa authentication mac-based auth-vid {{interfaces.access.vlan}}\naaa authentication mac-based unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}",
      "interfaceConfig": "interface {{interfaces.access.range}}\n aaa authentication port-access mac-based enable\n aaa authentication port-access mac-based {{interfaces.access.range}} addr-format no-delimiter uppercase\n aaa authentication port-access mac-based {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}\n aaa authentication port-access mac-based {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}"
    },
    "deploymentModes": [
      {
        "id": "monitor",
        "name": "Monitor Mode",
        "description": "Authentication is performed but not enforced",
        "config": "aaa authentication port-access auth-mode {{interfaces.access.range}} monitor"
      },
      {
        "id": "active",
        "name": "Active Mode",
        "description": "Authentication is enforced",
        "config": "aaa authentication port-access auth-mode {{interfaces.access.range}} active"
      }
    ],
    "securityFeatures": [
      {
        "id": "bpdu-guard",
        "name": "BPDU Guard",
        "description": "Protect against Layer 2 loops",
        "enabled": true,
        "config": "spanning-tree bpdu-guard"
      },
      {
        "id": "dhcp-snooping",
        "name": "DHCP Snooping",
        "description": "Protect against rogue DHCP servers",
        "enabled": true,
        "config": "dhcp-snooping\ndhcp-snooping vlan {{interfaces.access.vlan}}"
      },
      {
        "id": "arp-protect",
        "name": "ARP Protection",
        "description": "Protect against ARP spoofing",
        "enabled": true,
        "config": "arp-protect\narp-protect vlan {{interfaces.access.vlan}}"
      },
      {
        "id": "loop-protect",
        "name": "Loop Protection",
        "description": "Additional protection against Layer 2 loops",
        "enabled": true,
        "config": "loop-protect"
      }
    ]
  },
  "aos-switch": {
    "radius": {
      "serverConfig": "radius-server host {{radius.servers[0].ip}} key {{radius.servers[0].key}}\nradius-server host {{radius.servers[1].ip}} key {{radius.servers[1].key}}\nradius-server retransmit {{radius.advanced.retransmit}}\nradius-server timeout {{radius.timeout}}",
      "authenticationConfig": "aaa authentication port-access eap-radius",
      "authorizationConfig": "aaa authorization network radius"
    },
    "dot1x": {
      "globalConfig": "aaa port-access authenticator active",
      "interfaceConfig": "interface {{interfaces.access.range}}\n aaa authentication port-access eap-radius\n aaa authentication port-access authenticator {{interfaces.access.range}}\n aaa authentication port-access authenticator {{interfaces.access.range}} client-limit 32\n aaa authentication port-access authenticator {{interfaces.access.range}} quiet-period 60\n aaa authentication port-access authenticator {{interfaces.access.range}} tx-period {{interfaces.access.dot1x.txPeriod}}\n aaa authentication port-access authenticator {{interfaces.access.range}} supplicant-timeout 30\n aaa authentication port-access authenticator {{interfaces.access.range}} server-timeout 30\n aaa authentication port-access authenticator {{interfaces.access.range}} reauth-period 28800\n aaa authentication port-access authenticator {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}\n aaa authentication port-access authenticator {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}"
    },
    "mab": {
      "enabled": true,
      "description": "MAC Authentication",
      "config": "aaa authentication mac-based enable\naaa authentication mac-based address-format no-delimiter uppercase\naaa authentication mac-based auth-vid {{interfaces.access.vlan}}\naaa authentication mac-based unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}",
      "interfaceConfig": "interface {{interfaces.access.range}}\n aaa authentication port-access mac-based {{interfaces.access.range}}\n aaa authentication port-access mac-based {{interfaces.access.range}} addr-format no-delimiter uppercase\n aaa authentication port-access mac-based {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}\n aaa authentication port-access mac-based {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}"
    },
    "deploymentModes": [
      {
        "id": "monitor",
        "name": "Monitor Mode",
        "description": "Authentication is performed but not enforced",
        "config": "aaa port-access authenticator {{interfaces.access.range}} control auto\naaa port-access authenticator {{interfaces.access.range}} unauthorized-vlan {{interfaces.access.vlan}}"
      },
      {
        "id": "active",
        "name": "Active Mode",
        "description": "Authentication is enforced",
        "config": "aaa port-access authenticator {{interfaces.access.range}} control auto"
      }
    ],
    "securityFeatures": [
      {
        "id": "bpdu-guard",
        "name": "BPDU Guard",
        "description": "Protect against Layer 2 loops",
        "enabled": true,
        "config": "spanning-tree {{interfaces.access.range}} bpdu-protection"
      },
      {
        "id": "dhcp-snooping",
        "name": "DHCP Snooping",
        "description": "Protect against rogue DHCP servers",
        "enabled": true,
        "config": "dhcp-snooping\ndhcp-snooping vlan {{interfaces.access.vlan}}"
      },
      {
        "id": "arp-protect",
        "name": "ARP Protection",
        "description": "Protect against ARP spoofing",
        "enabled": true,
        "config": "arp-protect\narp-protect vlan {{interfaces.access.vlan}}"
      },
      {
        "id": "port-security",
        "name": "Port Security",
        "description": "Limit MAC addresses on a port",
        "enabled": true,
        "config": "port-security {{interfaces.access.range}} learn-mode static action send-disable\nport-security {{interfaces.access.range}} address-limit 1"
      }
    ]
  }
}
EOF

# Create AI analyzer and optimizer module
print_message "Creating AI analyzer and optimizer module..."

cat > js/ai-analyzer.js << 'EOF'
/**
 * UaXSupreme - AI Analyzer and Optimizer
 * Analyzes configurations for security issues and optimizes them
 */

(function() {
    'use strict';

    // AI Analyzer object
    const AIAnalyzer = {
        /**
         * Initialize AI Analyzer
         */
        init: function() {
            console.log('Initializing AI Analyzer...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Analyze configuration button
            const analyzeBtn = document.getElementById('analyzeConfigBtn');
            if (analyzeBtn) {
                analyzeBtn.addEventListener('click', this.analyzeConfiguration.bind(this));
            }
            
            // Optimize configuration button
            const optimizeBtn = document.getElementById('optimizeConfigBtn');
            if (optimizeBtn) {
                optimizeBtn.addEventListener('click', this.optimizeConfiguration.bind(this));
            }
        },
        
        /**
         * Analyze configuration for security issues and best practices
         */
        analyzeConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;
            
            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Show loading indicator
            this.showLoadingIndicator('Analyzing configuration...');
            
            // Simulate analysis (would use AI model in production)
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();
                
                // Get analysis results
                const analysisResults = this.performAnalysis(config);
                
                // Display analysis results
                this.displayAnalysisResults(analysisResults);
            }, 1500);
        },
        
        /**
         * Optimize configuration based on best practices
         */
        optimizeConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;
            
            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Show loading indicator
            this.showLoadingIndicator('Optimizing configuration...');
            
            // Simulate optimization (would use AI model in production)
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();
                
                // Get optimized configuration
                const optimizedConfig = this.performOptimization(config);
                
                // Update configuration output
                configOutput.value = optimizedConfig;
                
                // Show optimization success message
                this.showOptimizationSuccess();
            }, 2000);
        },
        
        /**
         * Show loading indicator
         * @param {string} message - Loading message
         */
        showLoadingIndicator: function(message) {
            // Create loading indicator if it doesn't exist
            if (!document.getElementById('aiLoadingIndicator')) {
                const loadingDiv = document.createElement('div');
                loadingDiv.id = 'aiLoadingIndicator';
                loadingDiv.className = 'ai-loading-indicator';
                
                const spinnerDiv = document.createElement('div');
                spinnerDiv.className = 'ai-spinner';
                spinnerDiv.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i>';
                
                const messageDiv = document.createElement('div');
                messageDiv.id = 'aiLoadingMessage';
                messageDiv.className = 'ai-loading-message';
                
                loadingDiv.appendChild(spinnerDiv);
                loadingDiv.appendChild(messageDiv);
                
                // Add to body
                document.body.appendChild(loadingDiv);
            }
            
            // Update message and show
            document.getElementById('aiLoadingMessage').textContent = message;
            document.getElementById('aiLoadingIndicator').style.display = 'flex';
        },
        
        /**
         * Hide loading indicator
         */
        hideLoadingIndicator: function() {
            const loadingIndicator = document.getElementById('aiLoadingIndicator');
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }
        },
        
        /**
         * Perform analysis on configuration
         * @param {string} config - Configuration to analyze
         * @returns {Object} Analysis results
         */
        performAnalysis: function(config) {
            const results = {
                score: 0,
                issues: [],
                recommendations: [],
                bestPractices: []
            };
            
            // Check for security issues
            this.checkSecurityIssues(config, results);
            
            // Check for best practices
            this.checkBestPractices(config, results);
            
            // Calculate overall score (0-100)
            results.score = this.calculateSecurityScore(results);
            
            return results;
        },
        
        /**
         * Check for security issues in configuration
         * @param {string} config - Configuration to check
         * @param {Object} results - Results object to update
         */
        checkSecurityIssues: function(config, results) {
            // Check for weak passwords or keys
            if (config.includes('key cisco') || config.includes('secret cisco')) {
                results.issues.push({
                    severity: 'high',
                    issue: 'Default or weak passwords/keys detected',
                    recommendation: 'Use strong, unique passwords and keys with at least 12 characters including mixed case, numbers, and symbols',
                    location: 'RADIUS/TACACS+ server configuration'
                });
            }
            
            // Check for missing DHCP snooping
            if (!config.includes('ip dhcp snooping') && !config.includes('dhcp-snooping')) {
                results.issues.push({
                    severity: 'medium',
                    issue: 'DHCP Snooping not enabled',
                    recommendation: 'Enable DHCP Snooping to protect against rogue DHCP servers and DHCP starvation attacks',
                    location: 'Global security configuration'
                });
            }
            
            // Check for missing DAI
            if (!config.includes('ip arp inspection') && !config.includes('arp-protect')) {
                results.issues.push({
                    severity: 'medium',
                    issue: 'Dynamic ARP Inspection not enabled',
                    recommendation: 'Enable Dynamic ARP Inspection to protect against ARP spoofing and man-in-the-middle attacks',
                    location: 'Global security configuration'
                });
            }
            
            // Check for missing BPDU Guard
            if (!config.includes('spanning-tree bpduguard') && !config.includes('bpdu-protection')) {
                results.issues.push({
                    severity: 'medium',
                    issue: 'BPDU Guard not enabled on access ports',
                    recommendation: 'Enable BPDU Guard on access ports to prevent loops caused by unauthorized switches',
                    location: 'Interface configuration'
                });
            }
            
            // Check for missing device tracking
            if (config.includes('Cisco') && !config.includes('device-tracking') && !config.includes('ip device tracking')) {
                results.issues.push({
                    severity: 'medium',
                    issue: 'IP Device Tracking not enabled',
                    recommendation: 'Enable IP Device Tracking to support downloadable ACLs and proper session tracking',
                    location: 'Global configuration'
                });
            }
            
            // Check for AAA server redundancy
            if ((config.match(/radius server/g) || []).length < 2 && (config.match(/tacacs server/g) || []).length < 2) {
                results.issues.push({
                    severity: 'medium',
                    issue: 'Insufficient AAA server redundancy',
                    recommendation: 'Configure at least two RADIUS or TACACS+ servers for redundancy',
                    location: 'AAA server configuration'
                });
            }
            
            // Check for fallback authentication
            if (config.includes('authentication login') && !config.includes('local')) {
                results.issues.push({
                    severity: 'high',
                    issue: 'No local authentication fallback configured',
                    recommendation: 'Configure local authentication fallback in case AAA servers are unreachable',
                    location: 'AAA authentication configuration'
                });
            }
            
            // Check for open authentication mode when should be closed
            if (config.includes('authentication open') || !config.includes('access-session closed')) {
                results.recommendations.push({
                    type: 'security',
                    recommendation: 'Consider using closed mode (enforced authentication) in production environments',
                    details: 'Open mode/monitor mode should only be used during initial deployment or testing'
                });
            }
        },
        
        /**
         * Check for best practices in configuration
         * @param {string} config - Configuration to check
         * @param {Object} results - Results object to update
         */
        checkBestPractices: function(config, results) {
            // Check for concurrent authentication
            if (config.includes('policy-map') && !config.includes('do-all') && !config.includes('authenticate using mab priority 20')) {
                results.bestPractices.push({
                    implemented: false,
                    practice: 'Concurrent 802.1X and MAB authentication',
                    benefit: 'Faster authentication process, especially in mixed environments with both 802.1X-capable and legacy devices',
                    implementation: 'Use "do-all" action in session-started event and configure both dot1x and mab with different priorities'
                });
            } else if (config.includes('do-all') && config.includes('authenticate using mab priority 20')) {
                results.bestPractices.push({
                    implemented: true,
                    practice: 'Concurrent 802.1X and MAB authentication',
                    benefit: 'Faster authentication process, especially in mixed environments'
                });
            }
            
            // Check for critical authentication
            if (config.includes('critical') && config.includes('CRITICAL_')) {
                results.bestPractices.push({
                    implemented: true,
                    practice: 'Critical Authentication',
                    benefit: 'Maintains network access when AAA servers are unreachable'
                });
            } else {
                results.bestPractices.push({
                    implemented: false,
                    practice: 'Critical Authentication',
                    benefit: 'Maintains network access when AAA servers are unreachable',
                    implementation: 'Configure critical authentication with appropriate VLAN and ACL'
                });
            }
            
            // Check for RADIUS server probing
            if (config.includes('automate-tester') || config.includes('test username')) {
                results.bestPractices.push({
                    implemented: true,
                    practice: 'RADIUS Server Probing',
                    benefit: 'Proactively detects RADIUS server availability'
                });
            } else {
                results.bestPractices.push({
                    implemented: false,
                    practice: 'RADIUS Server Probing',
                    benefit: 'Proactively detects RADIUS server availability',
                    implementation: 'Configure automate-tester or test username feature'
                });
            }
            
            // Check for load balancing
            if (config.includes('load-balance method least-outstanding')) {
                results.bestPractices.push({
                    implemented: true,
                    practice: 'RADIUS Load Balancing',
                    benefit: 'Optimizes RADIUS server utilization and improves performance'
                });
            } else {
                results.bestPractices.push({
                    implemented: false,
                    practice: 'RADIUS Load Balancing',
                    benefit: 'Optimizes RADIUS server utilization and improves performance',
                    implementation: 'Configure load-balance method least-outstanding'
                });
            }
            
            // Check for device sensor/profiling
            if (config.includes('device-sensor')) {
                results.bestPractices.push({
                    implemented: true,
                    practice: 'Device Sensor for Profiling',
                    benefit: 'Provides rich endpoint information to AAA server for better policy decisions'
                });
            } else {
                results.bestPractices.push({
                    implemented: false,
                    practice: 'Device Sensor for Profiling',
                    benefit: 'Provides rich endpoint information to AAA server for better policy decisions',
                    implementation: 'Configure device-sensor for DHCP, CDP, and LLDP'
                });
            }
        },
        
        /**
         * Calculate security score based on issues and best practices
         * @param {Object} results - Analysis results
         * @returns {number} Security score (0-100)
         */
        calculateSecurityScore: function(results) {
            // Start with base score
            let score = 100;
            
            // Subtract for high severity issues
            const highSeverityIssues = results.issues.filter(issue => issue.severity === 'high').length;
            score -= highSeverityIssues * 15;
            
            // Subtract for medium severity issues
            const mediumSeverityIssues = results.issues.filter(issue => issue.severity === 'medium').length;
            score -= mediumSeverityIssues * 10;
            
            // Subtract for low severity issues
            const lowSeverityIssues = results.issues.filter(issue => issue.severity === 'low').length;
            score -= lowSeverityIssues * 5;
            
            // Add points for implemented best practices
            const implementedBestPractices = results.bestPractices.filter(bp => bp.implemented).length;
            score += implementedBestPractices * 5;
            
            // Subtract for missing best practices
            const missingBestPractices = results.bestPractices.filter(bp => !bp.implemented).length;
            score -= missingBestPractices * 3;
            
            // Ensure score is between 0 and 100
            return Math.max(0, Math.min(100, score));
        },
        
        /**
         * Display analysis results
         * @param {Object} results - Analysis results
         */
        displayAnalysisResults: function(results) {
            // Create modal if it doesn't exist
            if (!document.getElementById('analysisResultsModal')) {
                const modalDiv = document.createElement('div');
                modalDiv.id = 'analysisResultsModal';
                modalDiv.className = 'modal';
                
                modalDiv.innerHTML = `
                    <div class="modal-content">
                        <div class="modal-header">
                            <h2><i class="fas fa-chart-bar"></i> Configuration Analysis</h2>
                            <span class="close">&times;</span>
                        </div>
                        <div class="modal-body">
                            <div id="analysisResultsContent"></div>
                        </div>
                    </div>
                `;
                
                document.body.appendChild(modalDiv);
                
                // Add event listener to close button
                const closeBtn = modalDiv.querySelector('.close');
                closeBtn.addEventListener('click', () => {
                    modalDiv.style.display = 'none';
                });
                
                // Close modal when clicking outside
                window.addEventListener('click', (e) => {
                    if (e.target === modalDiv) {
                        modalDiv.style.display = 'none';
                    }
                });
            }
            
            // Update modal content
            const contentDiv = document.getElementById('analysisResultsContent');
            
            // Generate HTML for results
            let html = `
                <div class="analysis-score">
                    <div class="score-circle ${this.getScoreClass(results.score)}">
                        <span class="score-value">${Math.round(results.score)}</span>
                    </div>
                    <div class="score-label">Security Score</div>
                </div>
                
                <div class="analysis-summary">
                    <h3>Summary</h3>
                    <p>${this.generateAnalysisSummary(results)}</p>
                </div>
            `;
            
            // Add issues section if there are any
            if (results.issues.length > 0) {
                html += `
                    <div class="analysis-issues">
                        <h3>Security Issues</h3>
                        <table class="analysis-table">
                            <thead>
                                <tr>
                                    <th>Severity</th>
                                    <th>Issue</th>
                                    <th>Recommendation</th>
                                </tr>
                            </thead>
                            <tbody>
                `;
                
                // Add rows for each issue
                results.issues.forEach(issue => {
                    html += `
                        <tr>
                            <td><span class="severity-badge ${issue.severity}">${issue.severity}</span></td>
                            <td>${issue.issue}</td>
                            <td>${issue.recommendation}</td>
                        </tr>
                    `;
                });
                
                html += `
                            </tbody>
                        </table>
                    </div>
                `;
            }
            
            // Add recommendations section if there are any
            if (results.recommendations.length > 0) {
                html += `
                    <div class="analysis-recommendations">
                        <h3>Recommendations</h3>
                        <ul class="recommendation-list">
                `;
                
                // Add items for each recommendation
                results.recommendations.forEach(rec => {
                    html += `
                        <li>
                            <div class="recommendation-type">${rec.type}</div>
                            <div class="recommendation-text">${rec.recommendation}</div>
                            <div class="recommendation-details">${rec.details || ''}</div>
                        </li>
                    `;
                });
                
                html += `
                        </ul>
                    </div>
                `;
            }
            
            // Add best practices section
            html += `
                <div class="analysis-best-practices">
                    <h3>Best Practices</h3>
                    <table class="analysis-table">
                        <thead>
                            <tr>
                                <th>Status</th>
                                <th>Practice</th>
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
            `;
            
            // Add rows for each best practice
            results.bestPractices.forEach(bp => {
                html += `
                    <tr>
                        <td><span class="status-badge ${bp.implemented ? 'implemented' : 'missing'}">${bp.implemented ? 'Implemented' : 'Missing'}</span></td>
                        <td>${bp.practice}</td>
                        <td>${bp.implemented ? bp.benefit : bp.implementation}</td>
                    </tr>
                `;
            });
            
            html += `
                        </tbody>
                    </table>
                </div>
                
                <div class="analysis-actions">
                    <button id="downloadAnalysisBtn" class="btn-secondary"><i class="fas fa-download"></i> Download Report</button>
                    <button id="optimizeFromAnalysisBtn" class="btn-primary"><i class="fas fa-magic"></i> Optimize Configuration</button>
                </div>
            `;
            
            // Update content
            contentDiv.innerHTML = html;
            
            // Add event listeners to buttons
            const downloadBtn = document.getElementById('downloadAnalysisBtn');
            if (downloadBtn) {
                downloadBtn.addEventListener('click', () => this.downloadAnalysisReport(results));
            }
            
            const optimizeBtn = document.getElementById('optimizeFromAnalysisBtn');
            if (optimizeBtn) {
                optimizeBtn.addEventListener('click', () => {
                    document.getElementById('analysisResultsModal').style.display = 'none';
                    this.optimizeConfiguration();
                });
            }
            
            // Show modal
            document.getElementById('analysisResultsModal').style.display = 'block';
        },
        
        /**
         * Get CSS class for score
         * @param {number} score - Security score
         * @returns {string} CSS class
         */
        getScoreClass: function(score) {
            if (score >= 90) return 'excellent';
            if (score >= 70) return 'good';
            if (score >= 50) return 'moderate';
            return 'poor';
        },
        
        /**
         * Generate analysis summary
         * @param {Object} results - Analysis results
         * @returns {string} Summary text
         */
        generateAnalysisSummary: function(results) {
            const issueCount = results.issues.length;
            const highSeverityCount = results.issues.filter(issue => issue.severity === 'high').length;
            const implementedBPCount = results.bestPractices.filter(bp => bp.implemented).length;
            const totalBPCount = results.bestPractices.length;
            
            let summary = '';
            
            if (results.score >= 90) {
                summary = `Excellent configuration with ${issueCount} security issues found. `;
            } else if (results.score >= 70) {
                summary = `Good configuration with ${issueCount} security issues found, including ${highSeverityCount} high severity issues. `;
            } else if (results.score >= 50) {
                summary = `Moderate configuration with ${issueCount} security issues found, including ${highSeverityCount} high severity issues. Improvements recommended. `;
            } else {
                summary = `Poor configuration with ${issueCount} security issues found, including ${highSeverityCount} high severity issues. Significant improvements required. `;
            }
            
            summary += `${implementedBPCount} of ${totalBPCount} best practices implemented.`;
            
            return summary;
        },
        
        /**
         * Download analysis report
         * @param {Object} results - Analysis results
         */
        downloadAnalysisReport: function(results) {
            // Generate report content
            const reportContent = this.generateReportContent(results);
            
            // Create blob and download
            const blob = new Blob([reportContent], { type: 'text/plain' });
            const url = URL.createObjectURL(blob);
            
            const a = document.createElement('a');
            a.href = url;
            a.download = 'UaXSupreme_Analysis_Report.txt';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        },
        
        /**
         * Generate report content
         * @param {Object} results - Analysis results
         * @returns {string} Report content
         */
        generateReportContent: function(results) {
            let report = '===== UaXSupreme Configuration Analysis Report =====\n\n';
            
            // Add date
            report += `Generated: ${new Date().toLocaleString()}\n\n`;
            
            // Add score
            report += `SECURITY SCORE: ${Math.round(results.score)} / 100\n\n`;
            
            // Add summary
            report += 'SUMMARY:\n';
            report += this.generateAnalysisSummary(results) + '\n\n';
            
            // Add issues
            report += 'SECURITY ISSUES:\n';
            if (results.issues.length === 0) {
                report += 'No security issues found.\n';
            } else {
                results.issues.forEach((issue, index) => {
                    report += `${index + 1}. [${issue.severity.toUpperCase()}] ${issue.issue}\n`;
                    report += `   Recommendation: ${issue.recommendation}\n`;
                    report += `   Location: ${issue.location}\n\n`;
                });
            }
            
            // Add recommendations
            if (results.recommendations.length > 0) {
                report += 'RECOMMENDATIONS:\n';
                results.recommendations.forEach((rec, index) => {
                    report += `${index + 1}. [${rec.type.toUpperCase()}] ${rec.recommendation}\n`;
                    if (rec.details) {
                        report += `   Details: ${rec.details}\n\n`;
                    }
                });
                report += '\n';
            }
            
            // Add best practices
            report += 'BEST PRACTICES:\n';
            results.bestPractices.forEach((bp, index) => {
                report += `${index + 1}. ${bp.practice}\n`;
                report += `   Status: ${bp.implemented ? 'Implemented' : 'Not Implemented'}\n`;
                report += `   ${bp.implemented ? 'Benefit' : 'Implementation'}: ${bp.implemented ? bp.benefit : bp.implementation}\n\n`;
            });
            
            return report;
        },
        
        /**
         * Perform optimization on configuration
         * @param {string} config - Configuration to optimize
         * @returns {string} Optimized configuration
         */
        performOptimization: function(config) {
            // In a real AI implementation, this would use an AI model to optimize
            // For this example, we'll do some basic optimizations
            
            let optimizedConfig = config;
            
            // Add DHCP snooping if missing
            if (!optimizedConfig.includes('ip dhcp snooping')) {
                const insertPoint = optimizedConfig.indexOf('dot1x system-auth-control');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + 
                        'ip dhcp snooping\n' +
                        'ip dhcp snooping vlan 1-4094\n' +
                        'no ip dhcp snooping information option\n' +
                        'ip dhcp snooping database flash:dhcp-snooping-db.txt\n' +
                        afterInsert;
                }
            }
            
            // Add DAI if missing
            if (!optimizedConfig.includes('ip arp inspection')) {
                const insertPoint = optimizedConfig.indexOf('dot1x system-auth-control');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + 
                        'ip arp inspection vlan 1-4094\n' +
                        'ip arp inspection validate src-mac dst-mac ip\n' +
                        afterInsert;
                }
            }
            
            // Add BPDU guard if missing
            if (!optimizedConfig.includes('spanning-tree bpduguard enable')) {
                optimizedConfig = optimizedConfig.replace(
                    /interface (.*?)\n([\s\S]*?)(?=\ninterface|$)/g, 
                    (match, p1, p2) => {
                        if (p2.includes('switchport mode access') && !p2.includes('spanning-tree bpduguard enable')) {
                            return `interface ${p1}\n${p2} spanning-tree portfast\n spanning-tree bpduguard enable\n`;
                        }
                        return match;
                    }
                );
            }
            
            // Add device tracking if missing
            if (optimizedConfig.includes('Cisco') && !optimizedConfig.includes('device-tracking')) {
                const insertPoint = optimizedConfig.indexOf('dot1x system-auth-control');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    
                    // Check if IOS or IOS-XE syntax is used
                    if (optimizedConfig.includes('access-session')) {
                        // IOS-XE syntax
                        optimizedConfig = beforeInsert + 
                            'device-tracking tracking auto-source\n\n' +
                            'device-tracking policy DISABLE-IP-TRACKING\n' +
                            ' tracking disable\n' +
                            ' trusted-port\n' +
                            ' device-role switch\n\n' +
                            'device-tracking policy IP-TRACKING\n' +
                            ' limit address-count 4\n' +
                            ' security-level glean\n' +
                            ' no protocol ndp\n' +
                            ' no protocol dhcp6\n' +
                            ' tracking enable reachable-lifetime 30\n\n' +
                            afterInsert;
                    } else {
                        // IOS syntax
                        optimizedConfig = beforeInsert + 
                            'ip device tracking probe auto-source\n' +
                            'ip device tracking probe delay 10\n' +
                            'ip device tracking probe interval 30\n\n' +
                            afterInsert;
                    }
                }
            }
            
            // Change authentication mode to closed if in production
            if (!optimizedConfig.includes('access-session closed') && 
                optimizedConfig.includes('access-session') && 
                !optimizedConfig.includes('authentication open')) {
                optimizedConfig = optimizedConfig.replace(
                    /template (.*?)\n([\s\S]*?)(?=\ntemplate|$)/g, 
                    (match, p1, p2) => {
                        if (p2.includes('access-session host-mode') && !p2.includes('access-session closed')) {
                            return match.replace('access-session host-mode', 'access-session closed\n access-session host-mode');
                        }
                        return match;
                    }
                );
            }
            
            // Add device sensor if missing
            if (!optimizedConfig.includes('device-sensor')) {
                const insertPoint = optimizedConfig.indexOf('dot1x system-auth-control');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + 
                        'device-sensor filter-list dhcp list DS_DHCP_LIST\n' +
                        ' option name host-name\n' +
                        ' option name requested-address\n' +
                        ' option name parameter-request-list\n' +
                        ' option name class-identifier\n' +
                        ' option name client-identifier\n' +
                        'device-sensor filter-spec dhcp include list DS_DHCP_LIST\n\n' +
                        'cdp run\n' +
                        'device-sensor filter-list cdp list DS_CDP_LIST\n' +
                        ' tlv name device-name\n' +
                        ' tlv name address-type\n' +
                        ' tlv name capabilities-type\n' +
                        ' tlv name platform-type\n' +
                        ' tlv name version-type\n' +
                        'device-sensor filter-spec cdp include list DS_CDP_LIST\n\n' +
                        'lldp run\n' +
                        'device-sensor filter-list lldp list DS_LLDP_LIST\n' +
                        ' tlv name system-name\n' +
                        ' tlv name system-description\n' +
                        ' tlv name system-capabilities\n' +
                        'device-sensor filter-spec lldp include list DS_LLDP_LIST\n\n' +
                        'device-sensor notify all-changes\n' +
                        'access-session attributes filter-list list DS_SEND_LIST\n' +
                        ' cdp\n' +
                        ' lldp\n' +
                        ' dhcp\n' +
                        'access-session accounting attributes filter-spec include list DS_SEND_LIST\n' +
                        'access-session authentication attributes filter-spec include list DS_SEND_LIST\n\n' +
                        afterInsert;
                }
            }

            // Convert sequential authentication to concurrent if appropriate
            if (optimizedConfig.includes('policy-map type control subscriber') && 
                optimizedConfig.includes('authenticate using dot1x priority 10') && 
                !optimizedConfig.includes('do-all') && 
                !optimizedConfig.includes('authenticate using mab priority 20')) {
                
                optimizedConfig = optimizedConfig.replace(
                    /event session-started match-all\s+10 class always do-until-failure\s+10 authenticate using dot1x priority 10/g,
                    'event session-started match-all\n  10 class always do-all\n   10 authenticate using dot1x priority 10\n   20 authenticate using mab priority 20'
                );
                
                // Also update policy map name if needed
                optimizedConfig = optimizedConfig.replace(
                    /policy-map type control subscriber DOT1X_MAB_POLICY/g,
                    'policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY'
                );
                
                // Update service-policy reference
                optimizedConfig = optimizedConfig.replace(
                    /service-policy type control subscriber DOT1X_MAB_POLICY/g,
                    'service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY'
                );
            }
            
            return optimizedConfig;
        },
        
        /**
         * Show optimization success message
         */
        showOptimizationSuccess: function() {
            // Create toast notification if it doesn't exist
            if (!document.getElementById('optimizationToast')) {
                const toastDiv = document.createElement('div');
                toastDiv.id = 'optimizationToast';
                toastDiv.className = 'toast-notification';
                
                toastDiv.innerHTML = `
                    <div class="toast-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="toast-message">
                        Configuration optimized successfully
                    </div>
                `;
                
                document.body.appendChild(toastDiv);
                
                // Auto-hide toast after 5 seconds
                setTimeout(() => {
                    toastDiv.classList.add('toast-hide');
                    setTimeout(() => {
                        toastDiv.remove();
                    }, 500);
                }, 5000);
            }
        }
    };

    // Add styles for AI Analyzer
    function addAIAnalyzerStyles() {
        const styleElement = document.createElement('style');
        styleElement.textContent = `
            /* AI Loading Indicator */
            .ai-loading-indicator {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.7);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                z-index: 2000;
            }
            
            .ai-spinner {
                color: white;
                font-size: 48px;
                margin-bottom: 20px;
            }
            
            .ai-loading-message {
                color: white;
                font-size: 18px;
            }
            
            /* Analysis Results */
            .analysis-score {
                display: flex;
                flex-direction: column;
                align-items: center;
                margin-bottom: 20px;
            }
            
            .score-circle {
                width: 100px;
                height: 100px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 32px;
                font-weight: bold;
                color: white;
                margin-bottom: 10px;
            }
            
            .score-circle.excellent {
                background-color: #27ae60;
            }
            
            .score-circle.good {
                background-color: #2ecc71;
            }
            
            .score-circle.moderate {
                background-color: #f39c12;
            }
            
            .score-circle.poor {
                background-color: #e74c3c;
            }
            
            .score-label {
                font-size: 16px;
                font-weight: bold;
            }
            
            .analysis-summary {
                margin-bottom: 20px;
                padding: 15px;
                background-color: #f5f7fa;
                border-radius: 4px;
            }
            
            .analysis-table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 20px;
            }
            
            .analysis-table th, .analysis-table td {
                padding: 10px;
                text-align: left;
                border-bottom: 1px solid #ddd;
            }
            
            .analysis-table th {
                background-color: #f5f7fa;
            }
            
            .severity-badge, .status-badge {
                display: inline-block;
                padding: 5px 10px;
                border-radius: 4px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
            }
            
            .severity-badge.high {
                background-color: #e74c3c;
                color: white;
            }
            
            .severity-badge.medium {
                background-color: #f39c12;
                color: white;
            }
            
            .severity-badge.low {
                background-color: #f1c40f;
                color: #333;
            }
            
            .status-badge.implemented {
                background-color: #27ae60;
                color: white;
            }
            
            .status-badge.missing {
                background-color: #95a5a6;
                color: white;
            }
            
            .recommendation-list {
                list-style: none;
                padding: 0;
            }
            
            .recommendation-list li {
                margin-bottom: 15px;
                padding: 15px;
                background-color: #f5f7fa;
                border-radius: 4px;
            }
            
            .recommendation-type {
                font-weight: bold;
                margin-bottom: 5px;
                color: #3498db;
                text-transform: capitalize;
            }
            
            .recommendation-text {
                margin-bottom: 5px;
            }
            
            .recommendation-details {
                font-size: 14px;
                color: #7f8c8d;
            }
            
            .analysis-actions {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                margin-top: 20px;
            }
            
            /* Toast Notification */
            .toast-notification {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background-color: #27ae60;
                color: white;
                padding: 15px 20px;
                border-radius: 4px;
                display: flex;
                align-items: center;
                gap: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
                z-index: 1000;
                animation: fadeIn 0.3s;
            }
            
            .toast-icon {
                font-size: 24px;
            }
            
            .toast-message {
                font-size: 16px;
            }
            
            .toast-hide {
                animation: fadeOut 0.5s;
            }
            
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            
            @keyframes fadeOut {
                from { opacity: 1; transform: translateY(0); }
                to { opacity: 0; transform: translateY(20px); }
            }
        `;
        document.head.appendChild(styleElement);
    }

    // Initialize AI Analyzer on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Add styles for AI Analyzer
        addAIAnalyzerStyles();
        
        // Initialize AI Analyzer
        AIAnalyzer.init();
        
        // Add AI Analyzer buttons to config generation section
        const configActionsDiv = document.querySelector('.action-buttons');
        if (configActionsDiv && !document.getElementById('analyzeConfigBtn')) {
            const analyzeBtn = document.createElement('button');
            analyzeBtn.id = 'analyzeConfigBtn';
            analyzeBtn.className = 'btn-secondary';
            analyzeBtn.innerHTML = '<i class="fas fa-search"></i> Analyze Configuration';
            
            const optimizeBtn = document.createElement('button');
            optimizeBtn.id = 'optimizeConfigBtn';
            optimizeBtn.className = 'btn-secondary';
            optimizeBtn.innerHTML = '<i class="fas fa-magic"></i> Optimize Configuration';
            
            configActionsDiv.appendChild(analyzeBtn);
            configActionsDiv.appendChild(optimizeBtn);
        }
    });

    // Export to window
    window.AIAnalyzer = AIAnalyzer;
})();
EOF

# Create diagram generator module
print_message "Creating diagram generator module..."

cat > js/diagram-generator.js << 'EOF'
/**
 * UaXSupreme - Diagram Generator
 * Generates network diagrams for authentication implementations
 */

(function() {
    'use strict';

    // Diagram Generator object
    const DiagramGenerator = {
        /**
         * Initialize Diagram Generator
         */
        init: function() {
            console.log('Initializing Diagram Generator...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Generate diagram button
            const generateDiagramBtn = document.getElementById('generateDiagramBtn');
            if (generateDiagramBtn) {
                generateDiagramBtn.addEventListener('click', this.generateDiagram.bind(this));
            }
            
            // Download diagram button
            const downloadDiagramBtn = document.getElementById('downloadDiagramBtn');
            if (downloadDiagramBtn) {
                downloadDiagramBtn.addEventListener('click', this.downloadDiagram.bind(this));
            }
        },
        
        /**
         * Generate network diagram
         */
        generateDiagram: function() {
            const diagramType = document.getElementById('diagramType').value;
            const diagramPreview = document.getElementById('diagramPreview');
            
            // Clear previous diagram
            diagramPreview.innerHTML = '';
            
            // Create canvas for diagram
            const canvas = document.createElement('canvas');
            canvas.id = 'diagramCanvas';
            canvas.width = diagramPreview.offsetWidth;
            canvas.height = 400;
            diagramPreview.appendChild(canvas);
            
            // Generate different types of diagrams
            switch (diagramType) {
                case 'logical':
                    this.generateLogicalDiagram(canvas);
                    break;
                case 'physical':
                    this.generatePhysicalDiagram(canvas);
                    break;
                case 'authentication':
                    this.generateAuthenticationDiagram(canvas);
                    break;
                case 'all':
                    // Create multiple canvases for all diagram types
                    diagramPreview.innerHTML = '';
                    
                    const logicalDiv = document.createElement('div');
                    logicalDiv.className = 'diagram-section';
                    logicalDiv.innerHTML = '<h3>Logical Network Diagram</h3>';
                    const logicalCanvas = document.createElement('canvas');
                    logicalCanvas.width = diagramPreview.offsetWidth;
                    logicalCanvas.height = 300;
                    logicalDiv.appendChild(logicalCanvas);
                    diagramPreview.appendChild(logicalDiv);
                    
                    const physicalDiv = document.createElement('div');
                    physicalDiv.className = 'diagram-section';
                    physicalDiv.innerHTML = '<h3>Physical Network Diagram</h3>';
                    const physicalCanvas = document.createElement('canvas');
                    physicalCanvas.width = diagramPreview.offsetWidth;
                    physicalCanvas.height = 300;
                    physicalDiv.appendChild(physicalCanvas);
                    diagramPreview.appendChild(physicalDiv);
                    
                    const authDiv = document.createElement('div');
                    authDiv.className = 'diagram-section';
                    authDiv.innerHTML = '<h3>Authentication Flow Diagram</h3>';
                    const authCanvas = document.createElement('canvas');
                    authCanvas.width = diagramPreview.offsetWidth;
                    authCanvas.height = 300;
                    authDiv.appendChild(authCanvas);
                    diagramPreview.appendChild(authDiv);
                    
                    this.generateLogicalDiagram(logicalCanvas);
                    this.generatePhysicalDiagram(physicalCanvas);
                    this.generateAuthenticationDiagram(authCanvas);
                    break;
            }
        },
        
        /**
         * Generate logical network diagram
         * @param {HTMLCanvasElement} canvas - Canvas to draw on
         */
        generateLogicalDiagram: function(canvas) {
            const ctx = canvas.getContext('2d');
            const width = canvas.width;
            const height = canvas.height;
            
            // Clear canvas
            ctx.clearRect(0, 0, width, height);
            
            // Draw background
            ctx.fillStyle = '#f5f7fa';
            ctx.fillRect(0, 0, width, height);
            
            // Set up colors
            const colors = {
                switch: '#3498db',
                radius: '#27ae60',
                client: '#e74c3c',
                vlan: '#f39c12',
                text: '#2c3e50',
                line: '#95a5a6',
                highlight: '#8e44ad'
            };
            
            // Draw title
            ctx.font = 'bold 16px Arial';
            ctx.fillStyle = colors.text;
            ctx.textAlign = 'center';
            ctx.fillText('Logical Network Diagram - 802.1X Authentication', width / 2, 30);
            
            // Draw network devices
            // Core switch
            this.drawSwitch(ctx, width / 2, 80, 'Core Switch', colors.switch);
            
            // RADIUS servers
            this.drawServer(ctx, width / 4, 150, 'RADIUS Server 1', colors.radius);
            this.drawServer(ctx, 3 * width / 4, 150, 'RADIUS Server 2', colors.radius);
            
            // Draw connections between core and RADIUS servers
            this.drawLine(ctx, width / 2, 100, width / 4, 130, colors.line);
            this.drawLine(ctx, width / 2, 100, 3 * width / 4, 130, colors.line);
            
            // Access switch
            this.drawSwitch(ctx, width / 2, 200, 'Access Switch', colors.switch);
            
            // Connection between core and access switch
            this.drawLine(ctx, width / 2, 100, width / 2, 180, colors.line);
            
            // VLANs
            this.drawCloud(ctx, width / 4, 250, 'User VLAN (10)', colors.vlan);
            this.drawCloud(ctx, width / 2, 250, 'Voice VLAN (20)', colors.vlan);
            this.drawCloud(ctx, 3 * width / 4, 250, 'Guest VLAN (30)', colors.vlan);
            
            // Connection between access switch and VLANs
            this.drawLine(ctx, width / 2, 220, width / 4, 240, colors.line);
            this.drawLine(ctx, width / 2, 220, width / 2, 240, colors.line);
            this.drawLine(ctx, width / 2, 220, 3 * width / 4, 240, colors.line);
            
            // Client devices
            this.drawComputer(ctx, width / 6, 320, 'Employee PC', colors.client);
            this.drawPhone(ctx, width / 3, 320, 'IP Phone', colors.client);
            this.drawPrinter(ctx, width / 2, 320, 'Printer', colors.client);
            this.drawTablet(ctx, 2 * width / 3, 320, 'BYOD Tablet', colors.client);
            this.drawLaptop(ctx, 5 * width / 6, 320, 'Guest Laptop', colors.client);
            
            // Connection between VLANs and devices
            this.drawLine(ctx, width / 4, 260, width / 6, 300, colors.line);
            this.drawLine(ctx, width / 4, 260, width / 3, 300, colors.line);
            this.drawLine(ctx, width / 2, 260, width / 2, 300, colors.line);
            this.drawLine(ctx, 3 * width / 4, 260, 2 * width / 3, 300, colors.line);
            this.drawLine(ctx, 3 * width / 4, 260, 5 * width / 6, 300, colors.line);
            
            // Draw legend
            this.drawLegend(ctx, width - 150, height - 100, colors);
        },
        
        /**
         * Generate physical network diagram
         * @param {HTMLCanvasElement} canvas - Canvas to draw on
         */
        generatePhysicalDiagram: function(canvas) {
            const ctx = canvas.getContext('2d');
            const width = canvas.width;
            const height = canvas.height;
            
            // Clear canvas
            ctx.clearRect(0, 0, width, height);
            
            // Draw background
            ctx.fillStyle = '#f5f7fa';
            ctx.fillRect(0, 0, width, height);
            
            // Set up colors
            const colors = {
                switch: '#3498db',
                radius: '#27ae60',
                client: '#e74c3c',
                building: '#f39c12',
                text: '#2c3e50',
                line: '#95a5a6',
                firewall: '#8e44ad'
            };
            
            // Draw title
            ctx.font = 'bold 16px Arial';
            ctx.fillStyle = colors.text;
            ctx.textAlign = 'center';
            ctx.fillText('Physical Network Diagram - 802.1X Deployment', width / 2, 30);
            
            // Draw main data center
            this.drawBuilding(ctx, width / 2, 80, 'Data Center', colors.building);
            
            // Draw core infrastructure
            this.drawFirewall(ctx, width / 2 - 60, 90, 'Firewall', colors.firewall);
            this.drawSwitch(ctx, width / 2 + 60, 90, 'Core Switch', colors.switch);
            this.drawLine(ctx, width / 2 - 40, 90, width / 2 + 40, 90, colors.line);
            
            // Draw RADIUS servers
            this.drawServer(ctx, width / 2 - 40, 130, 'Primary RADIUS', colors.radius);
            this.drawServer(ctx, width / 2 + 40, 130, 'Secondary RADIUS', colors.radius);
            this.drawLine(ctx, width / 2 - 40, 110, width / 2 - 40, 120, colors.line);
            this.drawLine(ctx, width / 2 + 40, 110, width / 2 + 40, 120, colors.line);
            
            // Draw campus buildings
            this.drawBuilding(ctx, width / 4, 200, 'Building A', colors.building);
            this.drawBuilding(ctx, width / 2, 200, 'Building B', colors.building);
            this.drawBuilding(ctx, 3 * width / 4, 200, 'Building C', colors.building);
            
            // Draw connections from core to buildings
            this.drawLine(ctx, width / 2, 100, width / 4, 180, colors.line);
            this.drawLine(ctx, width / 2, 100, width / 2, 180, colors.line);
            this.drawLine(ctx, width / 2, 100, 3 * width / 4, 180, colors.line);
            
            // Draw distribution switches in buildings
            this.drawSwitch(ctx, width / 4, 210, 'Dist Switch A', colors.switch);
            this.drawSwitch(ctx, width / 2, 210, 'Dist Switch B', colors.switch);
            this.drawSwitch(ctx, 3 * width / 4, 210, 'Dist Switch C', colors.switch);
            
            // Draw access switches
            this.drawSwitch(ctx, width / 6, 250, 'Access', colors.switch);
            this.drawSwitch(ctx, width / 3, 250, 'Access', colors.switch);
            this.drawSwitch(ctx, width / 2 - 20, 250, 'Access', colors.switch);
            this.drawSwitch(ctx, width / 2 + 20, 250, 'Access', colors.switch);
            this.drawSwitch(ctx, 2 * width / 3, 250, 'Access', colors.switch);
            this.drawSwitch(ctx, 5 * width / 6, 250, 'Access', colors.switch);
            
            // Draw connections from distribution to access switches
            this.drawLine(ctx, width / 4, 220, width / 6, 240, colors.line);
            this.drawLine(ctx, width / 4, 220, width / 3, 240, colors.line);
            this.drawLine(ctx, width / 2, 220, width / 2 - 20, 240, colors.line);
            this.drawLine(ctx, width / 2, 220, width / 2 + 20, 240, colors.line);
            this.drawLine(ctx, 3 * width / 4, 220, 2 * width / 3, 240, colors.line);
            this.drawLine(ctx, 3 * width / 4, 220, 5 * width / 6, 240, colors.line);
            
            // Draw workstations
            this.drawComputer(ctx, width / 6 - 20, 290, '', colors.client);
            this.drawComputer(ctx, width / 6 + 20, 290, '', colors.client);
            this.drawComputer(ctx, width / 3 - 20, 290, '', colors.client);
            this.drawPhone(ctx, width / 3 + 20, 290, '', colors.client);
            this.drawLaptop(ctx, width / 2 - 40, 290, '', colors.client);
            this.drawLaptop(ctx, width / 2, 290, '', colors.client);
            this.drawLaptop(ctx, width / 2 + 40, 290, '', colors.client);
            this.drawPrinter(ctx, 2 * width / 3, 290, '', colors.client);
            this.drawTablet(ctx, 5 * width / 6, 290, '', colors.client);
            
            // Draw connections from access switches to workstations
            this.drawLine(ctx, width / 6, 260, width / 6 - 20, 280, colors.line);
            this.drawLine(ctx, width / 6, 260, width / 6 + 20, 280, colors.line);
            this.drawLine(ctx, width / 3, 260, width / 3 - 20, 280, colors.line);
            this.drawLine(ctx, width / 3, 260, width / 3 + 20, 280, colors.line);
            this.drawLine(ctx, width / 2 - 20, 260, width / 2 - 40, 280, colors.line);
            this.drawLine(ctx, width / 2 - 20, 260, width / 2, 280, colors.line);
            this.drawLine(ctx, width / 2 + 20, 260, width / 2 + 40, 280, colors.line);
            this.drawLine(ctx, 2 * width / 3, 260, 2 * width / 3, 280, colors.line);
            this.drawLine(ctx, 5 * width / 6, 260, 5 * width / 6, 280, colors.line);
            
            // Draw legend
            this.drawPhysicalLegend(ctx, width - 150, height - 100, colors);
        },
        
        /**
         * Generate authentication flow diagram
         * @param {HTMLCanvasElement} canvas - Canvas to draw on
         */
        generateAuthenticationDiagram: function(canvas) {
            const ctx = canvas.getContext('2d');
            const width = canvas.width;
            const height = canvas.height;
            
            // Clear canvas
            ctx.clearRect(0, 0, width, height);
            
            // Draw background
            ctx.fillStyle = '#f5f7fa';
            ctx.fillRect(0, 0, width, height);
            
            // Set up colors
            const colors = {
                workstation: '#3498db',
                switch: '#27ae60',
                radius: '#e74c3c',
                arrow: '#2c3e50',
                text: '#34495e',
                success: '#2ecc71',
                failure: '#e74c3c',
                process: '#f39c12'
            };
            
            // Draw title
            ctx.font = 'bold 16px Arial';
            ctx.fillStyle = colors.text;
            ctx.textAlign = 'center';
            ctx.fillText('802.1X Authentication Flow Diagram', width / 2, 30);
            
            // Draw entities
            const entityY = 70;
            const entitySpacing = width / 4;
            
            // Client, Switch, RADIUS icons
            this.drawComputer(ctx, entitySpacing, entityY, 'Workstation', colors.workstation);
            this.drawSwitch(ctx, 2 * entitySpacing, entityY, 'Switch', colors.switch);
            this.drawServer(ctx, 3 * entitySpacing, entityY, 'RADIUS Server', colors.radius);
            
            // Draw timeline lines
            const timelineY = entityY + 40;
            const timelineEndY = height - 50;
            
            ctx.strokeStyle = '#bdc3c7';
            ctx.setLineDash([5, 3]);
            
            ctx.beginPath();
            ctx.moveTo(entitySpacing, timelineY);
            ctx.lineTo(entitySpacing, timelineEndY);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(2 * entitySpacing, timelineY);
            ctx.lineTo(2 * entitySpacing, timelineEndY);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(3 * entitySpacing, timelineY);
            ctx.lineTo(3 * entitySpacing, timelineEndY);
            ctx.stroke();
            
            ctx.setLineDash([]);
            
            // Draw authentication flow steps
            const steps = [
                { from: 'client', to: 'switch', y: timelineY + 30, text: 'EAPOL-Start', color: colors.arrow },
                { from: 'switch', to: 'client', y: timelineY + 60, text: 'EAP-Request Identity', color: colors.arrow },
                { from: 'client', to: 'switch', y: timelineY + 90, text: 'EAP-Response Identity', color: colors.arrow },
                { from: 'switch', to: 'radius', y: timelineY + 120, text: 'RADIUS Access-Request', color: colors.arrow },
                { from: 'radius', to: 'switch', y: timelineY + 150, text: 'RADIUS Access-Challenge', color: colors.arrow },
                { from: 'switch', to: 'client', y: timelineY + 180, text: 'EAP-Request', color: colors.arrow },
                { from: 'client', to: 'switch', y: timelineY + 210, text: 'EAP-Response', color: colors.arrow },
                { from: 'switch', to: 'radius', y: timelineY + 240, text: 'RADIUS Access-Request', color: colors.arrow },
                { from: 'radius', to: 'switch', y: timelineY + 270, text: 'RADIUS Access-Accept', color: colors.success },
                { from: 'switch', to: 'client', y: timelineY + 300, text: 'EAP-Success', color: colors.success }
            ];
            
            // Draw arrows for each step
            steps.forEach(step => {
                const fromX = step.from === 'client' ? entitySpacing : (step.from === 'switch' ? 2 * entitySpacing : 3 * entitySpacing);
                const toX = step.to === 'client' ? entitySpacing : (step.to === 'switch' ? 2 * entitySpacing : 3 * entitySpacing);
                
                this.drawArrow(ctx, fromX, step.y, toX, step.y, step.color);
                
                ctx.font = '12px Arial';
                ctx.fillStyle = colors.text;
                ctx.textAlign = 'center';
                
                // Position text above or below arrow based on direction
                const textY = step.y + (fromX < toX ? -8 : 16);
                ctx.fillText(step.text, (fromX + toX) / 2, textY);
            });
            
            // Draw additional info - decision points
            const decisionY = timelineY + 240;
            this.drawDecisionNode(ctx, 3 * entitySpacing + 40, decisionY, 'Authentication Validation', colors.process);
            
            // Draw possible failure path
            ctx.strokeStyle = colors.failure;
            ctx.beginPath();
            ctx.moveTo(3 * entitySpacing, decisionY + 20);
            ctx.lineTo(3 * entitySpacing + 60, decisionY + 40);
            ctx.lineTo(3 * entitySpacing, decisionY + 60);
            ctx.stroke();
            
            ctx.font = '12px Arial';
            ctx.fillStyle = colors.failure;
            ctx.textAlign = 'left';
            ctx.fillText('Authentication Failure', 3 * entitySpacing + 70, decisionY + 40);
            
            ctx.fillStyle = colors.text;
            ctx.textAlign = 'center';
            ctx.fillText('* Full EAP exchange simplified for clarity', width / 2, height - 15);
        },
        
        /**
         * Draw switch icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the switch
         * @param {string} color - Color for the switch
         */
        drawSwitch: function(ctx, x, y, label, color) {
            // Draw switch icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Switch body
            ctx.beginPath();
            ctx.rect(x - 25, y - 15, 50, 30);
            ctx.fill();
            ctx.stroke();
            
            // Switch ports
            ctx.fillStyle = '#ecf0f1';
            for (let i = 0; i < 4; i++) {
                ctx.beginPath();
                ctx.rect(x - 20 + i * 13, y + 5, 10, 5);
                ctx.fill();
                ctx.stroke();
            }
            
            // Label
            ctx.font = '10px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 25);
        },
        
        /**
         * Draw server icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the server
         * @param {string} color - Color for the server
         */
        drawServer: function(ctx, x, y, label, color) {
            // Draw server icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Server body
            ctx.beginPath();
            ctx.roundRect(x - 20, y - 20, 40, 50, 5);
            ctx.fill();
            ctx.stroke();
            
            // Server details
            ctx.fillStyle = '#ecf0f1';
            ctx.beginPath();
            ctx.rect(x - 15, y - 15, 30, 5);
            ctx.fill();
            ctx.stroke();
            
            ctx.beginPath();
            ctx.rect(x - 15, y - 5, 30, 5);
            ctx.fill();
            ctx.stroke();
            
            ctx.beginPath();
            ctx.rect(x - 15, y + 5, 30, 5);
            ctx.fill();
            ctx.stroke();
            
            // Label
            ctx.font = '10px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 45);
        },
        
        /**
         * Draw computer icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the computer
         * @param {string} color - Color for the computer
         */
        drawComputer: function(ctx, x, y, label, color) {
            // Draw computer icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Monitor
            ctx.beginPath();
            ctx.roundRect(x - 15, y - 15, 30, 25, 2);
            ctx.fill();
            ctx.stroke();
            
            // Screen
            ctx.fillStyle = '#ecf0f1';
            ctx.beginPath();
            ctx.roundRect(x - 12, y - 12, 24, 19, 1);
            ctx.fill();
            ctx.stroke();
            
            // Stand
            ctx.fillStyle = color;
            ctx.beginPath();
            ctx.moveTo(x - 5, y + 10);
            ctx.lineTo(x + 5, y + 10);
            ctx.lineTo(x + 8, y + 15);
            ctx.lineTo(x - 8, y + 15);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
            
            // Label
            if (label) {
                ctx.font = '10px Arial';
                ctx.fillStyle = '#2c3e50';
                ctx.textAlign = 'center';
                ctx.fillText(label, x, y + 30);
            }
        },
        
        /**
         * Draw phone icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the phone
         * @param {string} color - Color for the phone
         */
        drawPhone: function(ctx, x, y, label, color) {
            // Draw phone icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Phone body
            ctx.beginPath();
            ctx.roundRect(x - 10, y - 15, 20, 25, 3);
            ctx.fill();
            ctx.stroke();
            
            // Phone screen
            ctx.fillStyle = '#ecf0f1';
            ctx.beginPath();
            ctx.roundRect(x - 7, y - 12, 14, 10, 1);
            ctx.fill();
            ctx.stroke();
            
            // Phone buttons
            ctx.fillStyle = '#ecf0f1';
            for (let i = 0; i < 3; i++) {
                for (let j = 0; j < 2; j++) {
                    ctx.beginPath();
                    ctx.rect(x - 6 + j * 6, y + 1 + i * 3, 4, 2);
                    ctx.fill();
                    ctx.stroke();
                }
            }
            
            // Label
            if (label) {
                ctx.font = '10px Arial';
                ctx.fillStyle = '#2c3e50';
                ctx.textAlign = 'center';
                ctx.fillText(label, x, y + 30);
            }
        },
        
        /**
         * Draw printer icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the printer
         * @param {string} color - Color for the printer
         */
        drawPrinter: function(ctx, x, y, label, color) {
            // Draw printer icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Printer body
            ctx.beginPath();
            ctx.roundRect(x - 15, y - 10, 30, 20, 2);
            ctx.fill();
            ctx.stroke();
            
            // Paper tray
            ctx.fillStyle = '#ecf0f1';
            ctx.beginPath();
            ctx.rect(x - 12, y - 15, 24, 5);
            ctx.fill();
            ctx.stroke();
            
            // Output tray
            ctx.beginPath();
            ctx.rect(x - 12, y + 10, 24, 3);
            ctx.fill();
            ctx.stroke();
            
            // Label
            if (label) {
                ctx.font = '10px Arial';
                ctx.fillStyle = '#2c3e50';
                ctx.textAlign = 'center';
                ctx.fillText(label, x, y + 30);
            }
        },
        
        /**
         * Draw tablet icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the tablet
         * @param {string} color - Color for the tablet
         */
        drawTablet: function(ctx, x, y, label, color) {
            // Draw tablet icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Tablet body
            ctx.beginPath();
            ctx.roundRect(x - 12, y - 15, 24, 30, 3);
            ctx.fill();
            ctx.stroke();
            
            // Tablet screen
            ctx.fillStyle = '#ecf0f1';
            ctx.beginPath();
            ctx.roundRect(x - 10, y - 13, 20, 26, 2);
            ctx.fill();
            ctx.stroke();
            
            // Home button
            ctx.fillStyle = '#7f8c8d';
            ctx.beginPath();
            ctx.arc(x, y + 10, 2, 0, Math.PI * 2);
            ctx.fill();
            
            // Label
            if (label) {
                ctx.font = '10px Arial';
                ctx.fillStyle = '#2c3e50';
                ctx.textAlign = 'center';
                ctx.fillText(label, x, y + 30);
            }
        },
        
        /**
         * Draw laptop icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the laptop
         * @param {string} color - Color for the laptop
         */
        drawLaptop: function(ctx, x, y, label, color) {
            // Draw laptop icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Laptop screen
            ctx.beginPath();
            ctx.roundRect(x - 12, y - 15, 24, 20, 2);
            ctx.fill();
            ctx.stroke();
            
            // Laptop display
            ctx.fillStyle = '#ecf0f1';
            ctx.beginPath();
            ctx.roundRect(x - 10, y - 13, 20, 16, 1);
            ctx.fill();
            ctx.stroke();
            
            // Laptop keyboard
            ctx.fillStyle = '#7f8c8d';
            ctx.beginPath();
            ctx.moveTo(x - 15, y + 5);
            ctx.lineTo(x + 15, y + 5);
            ctx.lineTo(x + 12, y + 12);
            ctx.lineTo(x - 12, y + 12);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
            
            // Label
            if (label) {
                ctx.font = '10px Arial';
                ctx.fillStyle = '#2c3e50';
                ctx.textAlign = 'center';
                ctx.fillText(label, x, y + 30);
            }
        },
        
        /**
         * Draw cloud shape
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the cloud
         * @param {string} color - Color for the cloud
         */
        drawCloud: function(ctx, x, y, label, color) {
            // Draw cloud icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            ctx.beginPath();
            ctx.moveTo(x - 10, y);
            ctx.bezierCurveTo(x - 20, y, x - 20, y - 10, x - 10, y - 10);
            ctx.bezierCurveTo(x - 10, y - 20, x + 10, y - 20, x + 10, y - 10);
            ctx.bezierCurveTo(x + 20, y - 10, x + 20, y, x + 10, y);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
            
            // Label
            ctx.font = '10px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 15);
        },
        
        /**
         * Draw line between two points
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x1 - Start X coordinate
         * @param {number} y1 - Start Y coordinate
         * @param {number} x2 - End X coordinate
         * @param {number} y2 - End Y coordinate
         * @param {string} color - Color for the line
         */
        drawLine: function(ctx, x1, y1, x2, y2, color) {
            ctx.strokeStyle = color;
            ctx.lineWidth = 1;
            
            ctx.beginPath();
            ctx.moveTo(x1, y1);
            ctx.lineTo(x2, y2);
            ctx.stroke();
        },
        
        /**
         * Draw arrow between two points
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x1 - Start X coordinate
         * @param {number} y1 - Start Y coordinate
         * @param {number} x2 - End X coordinate
         * @param {number} y2 - End Y coordinate
         * @param {string} color - Color for the arrow
         */
        drawArrow: function(ctx, x1, y1, x2, y2, color) {
            const headLength = 10;
            const angle = Math.atan2(y2 - y1, x2 - x1);
            
            ctx.strokeStyle = color;
            ctx.fillStyle = color;
            ctx.lineWidth = 2;
            
            // Draw the line
            ctx.beginPath();
            ctx.moveTo(x1, y1);
            ctx.lineTo(x2, y2);
            ctx.stroke();
            
            // Draw the arrow head
            ctx.beginPath();
            ctx.moveTo(x2, y2);
            ctx.lineTo(x2 - headLength * Math.cos(angle - Math.PI / 6), y2 - headLength * Math.sin(angle - Math.PI / 6));
            ctx.lineTo(x2 - headLength * Math.cos(angle + Math.PI / 6), y2 - headLength * Math.sin(angle + Math.PI / 6));
            ctx.closePath();
            ctx.fill();
        },
        
        /**
         * Draw building icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the building
         * @param {string} color - Color for the building
         */
        drawBuilding: function(ctx, x, y, label, color) {
            // Draw building icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Building base
            ctx.beginPath();
            ctx.rect(x - 30, y - 30, 60, 50);
            ctx.fill();
            ctx.stroke();
            
            // Building roof
            ctx.beginPath();
            ctx.moveTo(x - 35, y - 30);
            ctx.lineTo(x, y - 50);
            ctx.lineTo(x + 35, y - 30);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
            
            // Windows
            ctx.fillStyle = '#ecf0f1';
            for (let i = 0; i < 2; i++) {
                for (let j = 0; j < 3; j++) {
                    ctx.beginPath();
                    ctx.rect(x - 25 + j * 25, y - 25 + i * 25, 15, 15);
                    ctx.fill();
                    ctx.stroke();
                }
            }
            
            // Label
            ctx.font = '10px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 35);
        },
        
        /**
         * Draw firewall icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the firewall
         * @param {string} color - Color for the firewall
         */
        drawFirewall: function(ctx, x, y, label, color) {
            // Draw firewall icon
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            // Firewall body
            ctx.beginPath();
            ctx.roundRect(x - 20, y - 15, 40, 30, 2);
            ctx.fill();
            ctx.stroke();
            
            // Firewall brick pattern
            ctx.strokeStyle = '#ecf0f1';
            ctx.lineWidth = 2;
            
            // Horizontal lines
            for (let i = 1; i < 3; i++) {
                ctx.beginPath();
                ctx.moveTo(x - 20, y - 15 + i * 10);
                ctx.lineTo(x + 20, y - 15 + i * 10);
                ctx.stroke();
            }
            
            // Vertical lines - offset on alternate rows
            for (let i = 0; i < 4; i++) {
                ctx.beginPath();
                ctx.moveTo(x - 10 + i * 10, y - 15);
                ctx.lineTo(x - 10 + i * 10, y - 5);
                ctx.stroke();
                
                ctx.beginPath();
                ctx.moveTo(x - 15 + i * 10, y - 5);
                ctx.lineTo(x - 15 + i * 10, y + 5);
                ctx.stroke();
                
                ctx.beginPath();
                ctx.moveTo(x - 10 + i * 10, y + 5);
                ctx.lineTo(x - 10 + i * 10, y + 15);
                ctx.stroke();
            }
            
            // Label
            ctx.font = '10px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'center';
            ctx.lineWidth = 1;
            ctx.fillText(label, x, y + 25);
        },
        
        /**
         * Draw decision node
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {string} label - Label for the decision node
         * @param {string} color - Color for the decision node
         */
        drawDecisionNode: function(ctx, x, y, label, color) {
            // Draw decision diamond
            ctx.fillStyle = color;
            ctx.strokeStyle = '#2c3e50';
            ctx.lineWidth = 1;
            
            ctx.beginPath();
            ctx.moveTo(x, y - 15);
            ctx.lineTo(x + 15, y);
            ctx.lineTo(x, y + 15);
            ctx.lineTo(x - 15, y);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
            
            // Label
            ctx.font = '10px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'left';
            ctx.fillText(label, x + 20, y + 4);
        },
        
        /**
         * Draw legend
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {Object} colors - Color definitions
         */
        drawLegend: function(ctx, x, y, colors) {
            // Draw legend background
            ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
            ctx.strokeStyle = '#bdc3c7';
            ctx.lineWidth = 1;
            
            ctx.beginPath();
            ctx.roundRect(x, y, 140, 80, 5);
            ctx.fill();
            ctx.stroke();
            
            // Legend title
            ctx.font = 'bold 12px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'left';
            ctx.fillText('Legend', x + 10, y + 15);
            
            // Legend items
            const items = [
                { color: colors.switch, label: 'Switch' },
                { color: colors.radius, label: 'RADIUS Server' },
                { color: colors.client, label: 'Client Devices' },
                { color: colors.vlan, label: 'VLANs' }
            ];
            
            items.forEach((item, index) => {
                // Color box
                ctx.fillStyle = item.color;
                ctx.beginPath();
                ctx.rect(x + 10, y + 25 + index * 15, 10, 10);
                ctx.fill();
                ctx.stroke();
                
                // Label
                ctx.font = '10px Arial';
                ctx.fillStyle = '#2c3e50';
                ctx.textAlign = 'left';
                ctx.fillText(item.label, x + 25, y + 33 + index * 15);
            });
        },
        
        /**
         * Draw physical legend
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X coordinate
         * @param {number} y - Y coordinate
         * @param {Object} colors - Color definitions
         */
        drawPhysicalLegend: function(ctx, x, y, colors) {
            // Draw legend background
            ctx.fillStyle = 'rgba(255, 255, 255, 0.8)';
            ctx.strokeStyle = '#bdc3c7';
            ctx.lineWidth = 1;
            
            ctx.beginPath();
            ctx.roundRect(x, y, 140, 95, 5);
            ctx.fill();
            ctx.stroke();
            
            // Legend title
            ctx.font = 'bold 12px Arial';
            ctx.fillStyle = '#2c3e50';
            ctx.textAlign = 'left';
            ctx.fillText('Legend', x + 10, y + 15);
            
            // Legend items
            const items = [
                { color: colors.switch, label: 'Network Switch' },
                { color: colors.radius, label: 'RADIUS Server' },
                { color: colors.client, label: 'End Devices' },
                { color: colors.building, label: 'Building' },
                { color: colors.firewall, label: 'Firewall' }
            ];
            
            items.forEach((item, index) => {
                // Color box
                ctx.fillStyle = item.color;
                ctx.beginPath();
                ctx.rect(x + 10, y + 25 + index * 15, 10, 10);
                ctx.fill();
                ctx.stroke();
                
                // Label
                ctx.font = '10px Arial';
                ctx.fillStyle = '#2c3e50';
                ctx.textAlign = 'left';
                ctx.fillText(item.label, x + 25, y + 33 + index * 15);
            });
        },
        
        /**
         * Download diagram as image
         */
        downloadDiagram: function() {
            const diagramType = document.getElementById('diagramType').value;
            const canvas = document.getElementById('diagramCanvas');
            
            if (!canvas) {
                alert('Please generate a diagram first.');
                return;
            }
            
            // Create a temporary link element
            const link = document.createElement('a');
            link.download = `UaXSupreme_${diagramType}_diagram.png`;
            
            // Convert canvas to data URL
            link.href = canvas.toDataURL('image/png');
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    };

    // Add round rectangle method to CanvasRenderingContext2D prototype if not present
    if (!CanvasRenderingContext2D.prototype.roundRect) {
        CanvasRenderingContext2D.prototype.roundRect = function(x, y, width, height, radius) {
            if (radius === undefined) {
                radius = 5;
            }
            this.beginPath();
            this.moveTo(x + radius, y);
            this.lineTo(x + width - radius, y);
            this.quadraticCurveTo(x + width, y, x + width, y + radius);
            this.lineTo(x + width, y + height - radius);
            this.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
            this.lineTo(x + radius, y + height);
            this.quadraticCurveTo(x, y + height, x, y + height - radius);
            this.lineTo(x, y + radius);
            this.quadraticCurveTo(x, y, x + radius, y);
            this.closePath();
            return this;
        };
    }

    // Initialize Diagram Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Add styles for diagram generator
        const styleElement = document.createElement('style');
        styleElement.textContent = `
            .diagram-section {
                margin-bottom: 30px;
            }
            
            .diagram-section h3 {
                text-align: center;
                margin-bottom: 10px;
                color: #2c3e50;
            }
        `;
        document.head.appendChild(styleElement);
        
        // Initialize Diagram Generator
        DiagramGenerator.init();
    });

    // Export to window
    window.DiagramGenerator = DiagramGenerator;
})();
EOF

# Update index.html to include new features
print_message "Updating index.html with enhanced features..."

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UaXSupreme - Advanced Network Authentication Configuration Platform</title>
    <link rel="stylesheet" href="css/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="app-container">
        <header>
            <div class="logo">
                <h1>UaXSupreme</h1>
                <span>Advanced Network Authentication Configuration Platform</span>
                <div id="logoCanvas" class="logo-animation"></div>
            </div>
            <div class="header-controls">
                <button id="helpBtn" class="btn-icon" title="Help"><i class="fas fa-question-circle"></i></button>
                <button id="aiAssistBtn" class="btn-icon" title="AI Assistant"><i class="fas fa-robot"></i></button>
                <button id="settingsBtn" class="btn-icon" title="Settings"><i class="fas fa-cog"></i></button>
            </div>
        </header>

        <div class="main-content">
            <div class="sidebar">
                <div class="sidebar-header">Configuration Process</div>
                <ul class="nav-steps">
                    <li class="active" data-step="vendor-selection"><i class="fas fa-server"></i> Vendor Selection</li>
                    <li data-step="authentication-methods"><i class="fas fa-shield-alt"></i> Authentication Methods</li>
                    <li data-step="radius-config"><i class="fas fa-network-wired"></i> RADIUS Configuration</li>
                    <li data-step="tacacs-config"><i class="fas fa-lock"></i> TACACS+ Configuration</li>
                    <li data-step="advanced-features"><i class="fas fa-sliders-h"></i> Advanced Features</li>
                    <li data-step="interface-config"><i class="fas fa-ethernet"></i> Interface Configuration</li>
                    <li data-step="generate-config"><i class="fas fa-file-code"></i> Generate Configuration</li>
                    <li data-step="ai-analysis"><i class="fas fa-brain"></i> AI Analysis</li>
                    <li data-step="documentation"><i class="fas fa-file-alt"></i> Documentation</li>
                </ul>
                <div class="sidebar-footer">
                    <button id="saveConfigBtn" class="btn-primary"><i class="fas fa-save"></i> Save Progress</button>
                    <button id="loadConfigBtn" class="btn-secondary"><i class="fas fa-folder-open"></i> Load Configuration</button>
                </div>
            </div>

            <div class="content-area">
                <!-- Vendor Selection Section -->
                <section id="vendor-selection" class="config-section active">
                    <h2><i class="fas fa-server"></i> Vendor Selection</h2>
                    <div class="section-content">
                        <div class="form-group">
                            <label for="vendor">Network Vendor:</label>
                            <select id="vendor" class="form-control">
                                <option value="">-- Select Vendor --</option>
                                <option value="cisco">Cisco</option>
                                <option value="aruba">Aruba/HP</option>
                                <option value="juniper">Juniper</option>
                                <option value="fortinet">Fortinet</option>
                                <option value="extreme">Extreme</option>
                                <option value="dell">Dell</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="platform">Platform:</label>
                            <select id="platform" class="form-control" disabled>
                                <option value="">-- Select Platform --</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="softwareVersion">Software Version:</label>
                            <input type="text" id="softwareVersion" class="form-control" placeholder="e.g., 17.9.5">
                        </div>
                        
                        <div class="platform-info hidden">
                            <h3>Platform Information</h3>
                            <div id="platformInfoContent"></div>
                        </div>
                    </div>
                    <div class="section-footer">
                        <button id="nextVendorBtn" class="btn-primary btn-next">Next <i class="fas fa-arrow-right"></i></button>
                    </div>
                </section>

                <!-- Authentication Methods Section -->
                <section id="authentication-methods" class="config-section">
                    <h2><i class="fas fa-shield-alt"></i> Authentication Methods</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="auth-methods">Methods</div>
                            <div class="tab" data-tab="auth-deployment">Deployment Type</div>
                            <div class="tab" data-tab="auth-security">Security Features</div>
                            <div class="tab" data-tab="auth-advanced">Advanced Settings</div>
                        </div>
                        
                        <div class="tab-content active" id="auth-methods">
                            <div class="form-group">
                                <label>Select Authentication Methods:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="dot1x" name="authMethod" value="dot1x">
                                        <label for="dot1x">802.1X Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="mab" name="authMethod" value="mab">
                                        <label for="mab">MAC Authentication Bypass (MAB)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="webauth" name="authMethod" value="webauth">
                                        <label for="webauth">Web Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radsec" name="authMethod" value="radsec">
                                        <label for="radsec">RadSec (Secure RADIUS)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacs" name="authMethod" value="tacacs">
                                        <label for="tacacs">TACACS+</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="macsec" name="authMethod" value="macsec">
                                        <label for="macsec">MACsec Encryption</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feature-info">
                                <h3>Method Information</h3>
                                <div id="dot1x-info" class="method-info-panel hidden">
                                    <h4>802.1X Authentication</h4>
                                    <p>Standard port-based network access control that provides authentication to devices attached to a LAN port. 802.1X uses the Extensible Authentication Protocol (EAP) to exchange messages during the authentication process.</p>
                                    <p><strong>Benefits:</strong></p>
                                    <ul>
                                        <li>Strong user-based authentication</li>
                                        <li>Dynamic VLAN assignment</li>
                                        <li>Downloadable ACLs</li>
                                        <li>Security Group Tag assignment</li>
                                    </ul>
                                    <p><strong>Requirements:</strong></p>
                                    <ul>
                                        <li>RADIUS server (e.g., Cisco ISE, Aruba ClearPass)</li>
                                        <li>Client supplicant software</li>
                                    </ul>
                                </div>
                                <div id="mab-info" class="method-info-panel hidden">
                                    <h4>MAC Authentication Bypass (MAB)</h4>
                                    <p>Authentication method that uses the MAC address of the device for authentication when the device doesn't support 802.1X. The switch sends the device's MAC address to the RADIUS server for authentication.</p>
                                    <p><strong>Benefits:</strong></p>
                                    <ul>
                                        <li>Support for non-802.1X capable devices (printers, IP phones, IoT)</li>
                                        <li>Fallback method when 802.1X fails</li>
                                        <li>Same policy enforcement capabilities as 802.1X</li>
                                    </ul>
                                    <p><strong>Considerations:</strong></p>
                                    <ul>
                                        <li>Less secure than 802.1X (MAC addresses can be spoofed)</li>
                                        <li>Requires maintaining MAC address database</li>
                                    </ul>
                                </div>
                                <div id="webauth-info" class="method-info-panel hidden">
                                    <h4>Web Authentication</h4>
                                    <p>Authentication method that redirects users to a web portal for credentials. Used primarily for guest access or situations where 802.1X is not practical.</p>
                                    <p><strong>Types:</strong></p>
                                    <ul>
                                        <li>Local WebAuth - Authentication handled by switch</li>
                                        <li>Central WebAuth - Redirect to external portal (ISE, ClearPass)</li>
                                        <li>Guest access with self-registration</li>
                                    </ul>
                                    <p><strong>Considerations:</strong></p>
                                    <ul>
                                        <li>User experience focused</li>
                                        <li>Requires HTTP/HTTPS interception</li>
                                        <li>May need DNS interception for captive portal</li>
                                    </ul>
                                </div>
                                <div id="radsec-info" class="method-info-panel hidden">
                                    <h4>RadSec (RADIUS over TLS)</h4>
                                    <p>Secure method for RADIUS communications using TLS encryption. Provides confidentiality, integrity protection, and mutual authentication for RADIUS traffic.</p>
                                    <p><strong>Benefits:</strong></p>
                                    <ul>
                                        <li>Encrypted RADIUS traffic</li>
                                        <li>Reliable transport over TCP</li>
                                        <li>Mutual authentication with certificates</li>
                                        <li>Better failover and high availability</li>
                                    </ul>
                                    <p><strong>Requirements:</strong></p>
                                    <ul>
                                        <li>PKI infrastructure for certificates</li>
                                        <li>TLS-capable switches and RADIUS servers</li>
                                        <li>TCP port 2083 connectivity</li>
                                    </ul>
                                </div>
                                <div id="tacacs-info" class="method-info-panel hidden">
                                    <h4>TACACS+</h4>
                                    <p>Protocol for Authentication, Authorization and Accounting (AAA) of network devices with granular command-level control. Primarily used for device administration rather than user network access.</p>
                                    <p><strong>Benefits:</strong></p>
                                    <ul>
                                        <li>Separate AAA functions</li>
                                        <li>Command-level authorization</li>
                                        <li>Encrypted protocol</li>
                                        <li>Detailed accounting of administrative actions</li>
                                    </ul>
                                    <p><strong>Use Cases:</strong></p>
                                    <ul>
                                        <li>Network device administration</li>
                                        <li>Administrator privilege control</li>
                                        <li>Command accounting for compliance</li>
                                    </ul>
                                </div>
                                <div id="macsec-info" class="method-info-panel hidden">
                                    <h4>MACsec (802.1AE)</h4>
                                    <p>Layer 2 encryption protocol that provides point-to-point security on Ethernet links between directly connected nodes. Encrypts data between switches, routers, and endpoints.</p>
                                    <p><strong>Benefits:</strong></p>
                                    <ul>
                                        <li>Wire-rate encryption</li>
                                        <li>Protection against Layer 2 attacks</li>
                                        <li>Compatible with 802.1X authentication</li>
                                        <li>Near-zero performance impact</li>
                                    </ul>
                                    <p><strong>Considerations:</strong></p>
                                    <ul>
                                        <li>Requires hardware support in switches</li>
                                        <li>Requires compatible endpoints for end-to-end</li>
                                        <li>Point-to-point only, not end-to-end through multiple hops</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="auth-deployment">
                            <div class="form-group">
                                <label for="deploymentType">Select Deployment Type:</label>
                                <select id="deploymentType" class="form-control">
                                    <option value="monitor">Monitor Mode (Open)</option>
                                    <option value="closed">Closed Mode</option>
                                    <option value="standard">Standard (802.1X then MAB)</option>
                                    <option value="concurrent">Concurrent (802.1X and MAB)</option>
                                    <option value="highsec">High Security Mode</option>
                                </select>
                            </div>
                            
                            <div class="deployment-info">
                                <h3>Deployment Type Information</h3>
                                <div id="deploymentInfoContent">
                                    <p>Monitor Mode (Open): Authentication is performed but not enforced. This is ideal for initial testing and deployment where all traffic is permitted regardless of authentication outcome. All authentication successes and failures are logged, allowing administrators to identify potential issues before enforcing authentication.</p>
                                    <p><strong>When to Use:</strong></p>
                                    <ul>
                                        <li>Initial deployment phase</li>
                                        <li>Testing period</li>
                                        <li>Organizations with limited resources for endpoint remediation</li>
                                    </ul>
                                    <p><strong>Implementation:</strong></p>
                                    <ul>
                                        <li>Cisco IOS: <code>authentication open</code></li>
                                        <li>Cisco IOS-XE: Remove <code>access-session closed</code></li>
                                        <li>Aruba AOS-CX: <code>aaa authentication port-access auth-mode monitor</code></li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="failoverPolicy">Authentication Failover Policy:</label>
                                <select id="failoverPolicy" class="form-control">
                                    <option value="strict">Strict (No Access on Failure)</option>
                                    <option value="restricted">Restricted Access on Failure</option>
                                    <option value="critical">Critical VLAN on RADIUS Server Failure</option>
                                    <option value="guest">Guest VLAN on Authentication Failure</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="deploymentPhase">Deployment Phase:</label>
                                <select id="deploymentPhase" class="form-control">
                                    <option value="planning">Planning & Assessment</option>
                                    <option value="pilot">Pilot Deployment</option>
                                    <option value="phased">Phased Rollout</option>
                                    <option value="production">Production Deployment</option>
                                </select>
                            </div>
                        </div>

                        <div class="tab-content" id="auth-security">
                            <div class="form-group">
                                <label>Select Security Features:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="dhcpSnooping" name="securityFeature" value="dhcpSnooping" checked>
                                        <label for="dhcpSnooping">DHCP Snooping</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="arpInspection" name="securityFeature" value="arpInspection" checked>
                                        <label for="arpInspection">Dynamic ARP Inspection</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="ipSourceGuard" name="securityFeature" value="ipSourceGuard" checked>
                                        <label for="ipSourceGuard">IP Source Guard</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portSecurity" name="securityFeature" value="portSecurity">
                                        <label for="portSecurity">Port Security</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="stormControl" name="securityFeature" value="stormControl" checked>
                                        <label for="stormControl">Storm Control</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="bpduGuard" name="securityFeature" value="bpduGuard" checked>
                                        <label for="bpduGuard">BPDU Guard</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="deviceSensor" name="securityFeature" value="deviceSensor" checked>
                                        <label for="deviceSensor">Device Sensor/Profiling</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="deviceTracking" name="securityFeature" value="deviceTracking" checked>
                                        <label for="deviceTracking">Device Tracking</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="security-features-info">
                                <h3>Security Features Information</h3>
                                <div id="securityFeaturesContent">
                                    <div class="security-feature-detail">
                                        <h4>DHCP Snooping</h4>
                                        <p>DHCP Snooping is a security feature that acts like a firewall between untrusted hosts and DHCP servers. It filters DHCP messages, prevents DHCP server spoofing, and creates a binding database of IP-to-MAC mappings.</p>
                                        <p><strong>Mitigates:</strong> Rogue DHCP servers, DHCP starvation attacks, IP/MAC spoofing</p>
                                    </div>

                                    <div class="security-feature-detail">
                                        <h4>Dynamic ARP Inspection (DAI)</h4>
                                        <p>DAI validates ARP packets in a network to prevent ARP poisoning attacks. It intercepts all ARP packets and compares them to the DHCP snooping binding database.</p>
                                        <p><strong>Mitigates:</strong> ARP spoofing, man-in-the-middle attacks</p>
                                    </div>

                                    <div class="security-feature-detail">
                                        <h4>IP Source Guard</h4>
                                        <p>IP Source Guard restricts IP traffic on untrusted Layer 2 ports by filtering traffic based on the DHCP snooping binding database or static IP source binding.</p>
                                        <p><strong>Mitigates:</strong> IP spoofing attacks</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="tab-content" id="auth-advanced">
                            <div class="form-group">
                                <label>802.1X Advanced Settings:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="dot1xMaxReauthReq">Max Reauth Requests:</label>
                                        <input type="number" id="dot1xMaxReauthReq" class="form-control" value="2" min="1" max="10">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="dot1xTxPeriod">EAPOL Tx Period (sec):</label>
                                        <input type="number" id="dot1xTxPeriod" class="form-control" value="7" min="1" max="65535">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="dot1xQuietPeriod">Quiet Period (sec):</label>
                                        <input type="number" id="dot1xQuietPeriod" class="form-control" value="60" min="1" max="65535">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="reauthPeriod">Reauthentication Period:</label>
                                        <select id="reauthPeriod" class="form-control">
                                            <option value="server">Use RADIUS Server Value</option>
                                            <option value="1800">30 Minutes (1800 seconds)</option>
                                            <option value="3600">1 Hour (3600 seconds)</option>
                                            <option value="7200">2 Hours (7200 seconds)</option>
                                            <option value="28800">8 Hours (28800 seconds)</option>
                                            <option value="86400">24 Hours (86400 seconds)</option>
                                            <option value="custom">Custom Value</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6" id="customReauthPeriodGroup" style="display: none;">
                                        <label for="customReauthPeriod">Custom Period (sec):</label>
                                        <input type="number" id="customReauthPeriod" class="form-control" value="3600" min="1" max="65535">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>MAB Advanced Settings:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="mabAuthType">Authentication Type:</label>
                                        <select id="mabAuthType" class="form-control">
                                            <option value="eap">EAP</option>
                                            <option value="pap">PAP</option>
                                            <option value="chap">CHAP</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="macFormat">MAC Address Format:</label>
                                        <select id="macFormat" class="form-control">
                                            <option value="ietf-upper">IETF Upper (AA-BB-CC-DD-EE-FF)</option>
                                            <option value="ietf-lower">IETF Lower (aa-bb-cc-dd-ee-ff)</option>
                                            <option value="cisco">Cisco (aabb.ccdd.eeff)</option>
                                            <option value="no-separator-upper">No Separator Upper (AABBCCDDEEFF)</option>
                                            <option value="no-separator-lower">No Separator Lower (aabbccddeeff)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Host Mode Configuration:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="hostMode">Host Mode:</label>
                                        <select id="hostMode" class="form-control">
                                            <option value="multi-auth">Multi-Auth (Multiple Devices)</option>
                                            <option value="multi-domain">Multi-Domain (1 Data & 1 Voice)</option>
                                            <option value="multi-host">Multi-Host (1 Auth for All)</option>
                                            <option value="single-host">Single-Host (1 Device Only)</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="controlDirection">Control Direction:</label>
                                        <select id="controlDirection" class="form-control">
                                            <option value="in">In (Ingress Only)</option>
                                            <option value="both">Both (Ingress & Egress)</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Inactivity and Session Control:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="inactivityTimeout">Inactivity Timeout (sec):</label>
                                        <input type="number" id="inactivityTimeout" class="form-control" value="60" min="0" max="65535">
                                        <small class="form-text text-muted">0 = Disabled</small>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="maxDeviceCount">Max Devices Per Port:</label>
                                        <input type="number" id="maxDeviceCount" class="form-control" value="4" min="1" max="64">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-next">Next</button>
                    </div>
                </section>

                <!-- RADIUS Configuration Section -->
                <section id="radius-config" class="config-section">
                    <h2><i class="fas fa-network-wired"></i> RADIUS Configuration</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="radius-servers">Servers</div>
                            <div class="tab" data-tab="radius-attrs">Attributes</div>
                            <div class="tab" data-tab="radius-advanced">Advanced</div>
                            <div class="tab" data-tab="radius-coa">CoA & API</div>
                            <div class="tab" data-tab="radius-vsa">Vendor Attributes</div>
                        </div>
                        
                        <div class="tab-content active" id="radius-servers">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="radiusServerGroup">RADIUS Server Group Name:</label>
                                    <input type="text" id="radiusServerGroup" class="form-control" value="RAD-SERVERS">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="radiusTimeout">Timeout (seconds):</label>
                                    <input type="number" id="radiusTimeout" class="form-control" value="2" min="1" max="60">
                                </div>
                            </div>

                            <div class="server-container">
                                <h3>Primary RADIUS Server</h3>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="radiusServer1Name">Server Name:</label>
                                        <input type="text" id="radiusServer1Name" class="form-control" value="RAD-ISE-PSN-1">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="radiusServer1">Server IP Address:</label>
                                        <input type="text" id="radiusServer1" class="form-control" placeholder="e.g., 10.10.10.101">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="radiusPort1">Authentication Port:</label>
                                        <input type="number" id="radiusPort1" class="form-control" value="1812">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="radiusAcctPort1">Accounting Port:</label>
                                        <input type="number" id="radiusAcctPort1" class="form-control" value="1813">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="radiusKey1">Shared Secret:</label>
                                        <div class="password-field">
                                            <input type="password" id="radiusKey1" class="form-control" placeholder="Enter shared secret">
                                            <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="server-container">
                                <h3>Secondary RADIUS Server</h3>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="radiusServer2Name">Server Name:</label>
                                        <input type="text" id="radiusServer2Name" class="form-control" value="RAD-ISE-PSN-2">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="radiusServer2">Server IP Address:</label>
                                        <input type="text" id="radiusServer2" class="form-control" placeholder="e.g., 10.10.10.102">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="radiusPort2">Authentication Port:</label>
                                        <input type="number" id="radiusPort2" class="form-control" value="1812">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="radiusAcctPort2">Accounting Port:</label>
                                        <input type="number" id="radiusAcctPort2" class="form-control" value="1813">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="radiusKey2">Shared Secret:</label>
                                        <div class="password-field">
                                            <input type="password" id="radiusKey2" class="form-control" placeholder="Enter shared secret">
                                            <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <button id="addRadiusServerBtn" class="btn-secondary"><i class="fas fa-plus"></i> Add Another RADIUS Server</button>
                            </div>

                            <div class="form-group">
                                <label>Configure AAA Services:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="aaaAuthentication" name="aaaService" value="authentication" checked>
                                        <label for="aaaAuthentication">Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="aaaAuthorization" name="aaaService" value="authorization" checked>
                                        <label for="aaaAuthorization">Authorization</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="aaaAccounting" name="aaaService" value="accounting" checked>
                                        <label for="aaaAccounting">Accounting</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="radius-attrs">
                            <div class="form-group">
                                <label>RADIUS Attributes:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusNasId" name="radiusAttr" value="nasId" checked>
                                        <label for="radiusNasId">Include NAS-Identifier</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusNasIp" name="radiusAttr" value="nasIp" checked>
                                        <label for="radiusNasIp">Include NAS-IP-Address</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusServiceType" name="radiusAttr" value="serviceType" checked>
                                        <label for="radiusServiceType">Include Service-Type</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusCalledStationId" name="radiusAttr" value="calledStationId" checked>
                                        <label for="radiusCalledStationId">Include Called-Station-ID</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusCallingStationId" name="radiusAttr" value="callingStationId" checked>
                                        <label for="radiusCallingStationId">Include Calling-Station-ID</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusFramedIp" name="radiusAttr" value="framedIp" checked>
                                        <label for="radiusFramedIp">Include Framed-IP-Address</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusNasPort" name="radiusAttr" value="nasPort" checked>
                                        <label for="radiusNasPort">Include NAS-Port-Type</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusNasPortId" name="radiusAttr" value="nasPortId" checked>
                                        <label for="radiusNasPortId">Include NAS-Port-ID</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="radiusMacFormat">MAC Address Format:</label>
                                <select id="radiusMacFormat" class="form-control">
                                    <option value="ietf-upper">IETF Upper Case (AA-BB-CC-DD-EE-FF)</option>
                                    <option value="ietf-lower">IETF Lower Case (aa-bb-cc-dd-ee-ff)</option>
                                    <option value="cisco">Cisco Format (aabb.ccdd.eeff)</option>
                                    <option value="no-separator-upper">No Separator Upper (AABBCCDDEEFF)</option>
                                    <option value="no-separator-lower">No Separator Lower (aabbccddeeff)</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="nasIdentifier">NAS-Identifier Value:</label>
                                <input type="text" id="nasIdentifier" class="form-control" placeholder="Enter NAS-Identifier">
                                <small class="form-text text-muted">Typically the hostname or location of the switch</small>
                            </div>

                            <div class="form-group">
                                <label for="attrCustomizationLevel">Attribute Customization Level:</label>
                                <select id="attrCustomizationLevel" class="form-control">
                                    <option value="basic">Basic (Default Attributes)</option>
                                    <option value="standard">Standard (Common Attributes)</option>
                                    <option value="advanced">Advanced (All Attributes)</option>
                                    <option value="custom">Custom (Manual Selection)</option>
                                </select>
                            </div>

                            <div id="customAttributesSection" style="display: none;">
                                <h3>Custom RADIUS Attributes</h3>
                                <div class="custom-attributes-container">
                                    <table class="custom-attributes-table">
                                        <thead>
                                            <tr>
                                                <th>Attribute</th>
                                                <th>Include</th>
                                                <th>Format/Value</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>User-Name (1)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><select class="form-control"><option>Default</option></select></td>
                                            </tr>
                                            <tr>
                                                <td>NAS-IP-Address (4)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><input type="text" class="form-control" placeholder="Auto"></td>
                                            </tr>
                                            <tr>
                                                <td>NAS-Port (5)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><select class="form-control"><option>Interface Index</option></select></td>
                                            </tr>
                                            <tr>
                                                <td>Service-Type (6)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><select class="form-control"><option>Framed (2)</option></select></td>
                                            </tr>
                                            <tr>
                                                <td>Framed-Protocol (7)</td>
                                                <td><input type="checkbox"></td>
                                                <td><select class="form-control"><option>PPP (1)</option></select></td>
                                            </tr>
                                            <tr>
                                                <td>Calling-Station-ID (31)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><select class="form-control"><option>MAC Address</option></select></td>
                                            </tr>
                                            <tr>
                                                <td>Called-Station-ID (30)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><select class="form-control"><option>Switch MAC</option></select></td>
                                            </tr>
                                            <tr>
                                                <td>NAS-Identifier (32)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><input type="text" class="form-control" placeholder="Hostname"></td>
                                            </tr>
                                            <tr>
                                                <td>NAS-Port-Type (61)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><select class="form-control"><option>Ethernet (15)</option></select></td>
                                            </tr>
                                            <tr>
                                                <td>NAS-Port-ID (87)</td>
                                                <td><input type="checkbox" checked></td>
                                                <td><select class="form-control"><option>Interface Name</option></select></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="radius-advanced">
                            <div class="form-group">
                                <label>Advanced RADIUS Options:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusLoadBalance" name="radiusAdvanced" value="loadBalance" checked>
                                        <label for="radiusLoadBalance">Enable Load Balancing</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusDeadtime" name="radiusAdvanced" value="deadtime" checked>
                                        <label for="radiusDeadtime">Enable Deadtime</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusSourceInterface" name="radiusAdvanced" value="sourceInterface" checked>
                                        <label for="radiusSourceInterface">Specify Source Interface</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusCoA" name="radiusAdvanced" value="coa" checked>
                                        <label for="radiusCoA">Enable Change of Authorization (CoA)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusServerProbe" name="radiusAdvanced" value="serverProbe" checked>
                                        <label for="radiusServerProbe">Enable Server Probing</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusFailover" name="radiusAdvanced" value="failover" checked>
                                        <label for="radiusFailover">Enable Server Failover</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusFallback" name="radiusAdvanced" value="fallback" checked>
                                        <label for="radiusFallback">Enable Fallback to Local Authentication</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="radiusDeadtimeValue">Deadtime (minutes):</label>
                                    <input type="number" id="radiusDeadtimeValue" class="form-control" value="15" min="1" max="60">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="radiusRetransmit">Retransmit Count:</label>
                                    <input type="number" id="radiusRetransmit" class="form-control" value="2" min="1" max="10">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="radiusSourceInterfaceValue">Source Interface:</label>
                                <input type="text" id="radiusSourceInterfaceValue" class="form-control" value="Vlan 10">
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="radiusTestUsername">Test Username:</label>
                                    <input type="text" id="radiusTestUsername" class="form-control" value="SW-RAD-TEST">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="radiusDeadCriteria">Dead Criteria:</label>
                                    <input type="text" id="radiusDeadCriteria" class="form-control" value="time 5 tries 3">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="radiusLoadBalanceMethod">Load Balance Method:</label>
                                <select id="radiusLoadBalanceMethod" class="form-control">
                                    <option value="least-outstanding">Least Outstanding</option>
                                    <option value="batch">Batch</option>
                                    <option value="host-hash">Host Hash</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="radiusKeyFormat">RADIUS Key Format:</label>
                                <select id="radiusKeyFormat" class="form-control">
                                    <option value="type0">Type 0 (Clear Text)</option>
                                    <option value="type7">Type 7 (Reversible Encryption)</option>
                                    <option value="type8">Type 8 (PBKDF2 SHA-256)</option>
                                    <option value="type9">Type 9 (Scrypt)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="fallbackPriority">Authentication Fallback Priority:</label>
                                <div class="fallback-priority-container">
                                    <ul id="fallbackPriority" class="fallback-priority-list">
                                        <li class="fallback-item" draggable="true">
                                            <span class="fallback-handle"><i class="fas fa-grip-vertical"></i></span>
                                            <span class="fallback-name">Primary RADIUS Server</span>
                                        </li>
                                        <li class="fallback-item" draggable="true">
                                            <span class="fallback-handle"><i class="fas fa-grip-vertical"></i></span>
                                            <span class="fallback-name">Secondary RADIUS Server</span>
                                        </li>
                                        <li class="fallback-item" draggable="true">
                                            <span class="fallback-handle"><i class="fas fa-grip-vertical"></i></span>
                                            <span class="fallback-name">Local Authentication</span>
                                        </li>
                                        <li class="fallback-item" draggable="true">
                                            <span class="fallback-handle"><i class="fas fa-grip-vertical"></i></span>
                                            <span class="fallback-name">Critical VLAN</span>
                                        </li>
                                    </ul>
                                    <small class="form-text text-muted">Drag items to rearrange fallback priority</small>
                                </div>
                            </div>
                        </div>

                        <div class="tab-content" id="radius-coa">
                            <div class="form-group">
                                <label>Change of Authorization (CoA) Settings:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="coaEnabled" name="coaOption" value="enabled" checked>
                                        <label for="coaEnabled">Enable CoA Support</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="coaPortBounce" name="coaOption" value="portBounce" checked>
                                        <label for="coaPortBounce">Enable Port-Bounce CoA</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="coaReauth" name="coaOption" value="reauth" checked>
                                        <label for="coaReauth">Enable Reauthentication CoA</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="coaDisconnect" name="coaOption" value="disconnect" checked>
                                        <label for="coaDisconnect">Enable Disconnect CoA</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="coaPushPolicy" name="coaOption" value="pushPolicy">
                                        <label for="coaPushPolicy">Enable Push-Policy CoA</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="coaPort">CoA Port:</label>
                                <input type="number" id="coaPort" class="form-control" value="1700" min="1" max="65535">
                                <small class="form-text text-muted">Default is 1700 for Cisco ISE</small>
                            </div>

                            <div class="form-group">
                                <label for="coaKeyType">CoA Authentication Type:</label>
                                <select id="coaKeyType" class="form-control">
                                    <option value="any">Any (Allow all methods)</option>
                                    <option value="all">All (Require all methods)</option>
                                    <option value="session-key">Session-Key Only</option>
                                    <option value="standard">Standard Only</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>RADIUS API Integration:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiRest" name="apiOption" value="rest">
                                        <label for="apiRest">Enable REST API</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiSyslog" name="apiOption" value="syslog" checked>
                                        <label for="apiSyslog">Enable Syslog Integration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiSnmp" name="apiOption" value="snmp">
                                        <label for="apiSnmp">Enable SNMP Integration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiWebhook" name="apiOption" value="webhook">
                                        <label for="apiWebhook">Enable Webhook Notifications</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="syslogLevel">Syslog Level:</label>
                                <select id="syslogLevel" class="form-control">
                                    <option value="info">Informational</option>
                                    <option value="notice">Notice</option>
                                    <option value="warning">Warning</option>
                                    <option value="error">Error</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="syslogFacility">Syslog Facility:</label>
                                <select id="syslogFacility" class="form-control">
                                    <option value="local0">local0</option>
                                    <option value="local1">local1</option>
                                    <option value="local2">local2</option>
                                    <option value="local3">local3</option>
                                    <option value="local4">local4</option>
                                    <option value="local5">local5</option>
                                    <option value="local6">local6</option>
                                    <option value="local7">local7</option>
                                </select>
                            </div>
                        </div>

                        <div class="tab-content" id="radius-vsa">
                            <div class="form-group">
                                <label>Vendor-Specific Attributes (VSAs):</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaEnable" name="vsaOption" value="enable" checked>
                                        <label for="vsaEnable">Enable VSA Support</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaAuth" name="vsaOption" value="auth" checked>
                                        <label for="vsaAuth">Send VSAs in Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaAcct" name="vsaOption" value="acct" checked>
                                        <label for="vsaAcct">Send VSAs in Accounting</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Supported Vendor Attributes:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaCisco" name="vsaVendor" value="cisco" checked>
                                        <label for="vsaCisco">Cisco (9)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaAruba" name="vsaVendor" value="aruba">
                                        <label for="vsaAruba">Aruba (14823)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaJuniper" name="vsaVendor" value="juniper">
                                        <label for="vsaJuniper">Juniper (2636)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaMicrosoft" name="vsaVendor" value="microsoft">
                                        <label for="vsaMicrosoft">Microsoft (311)</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Common RADIUS VSA Types:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaVlan" name="vsaType" value="vlan" checked>
                                        <label for="vsaVlan">VLAN Assignment</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaAcl" name="vsaType" value="acl" checked>
                                        <label for="vsaAcl">Downloadable ACL</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaUrl" name="vsaType" value="url">
                                        <label for="vsaUrl">URL-Redirect</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaSgt" name="vsaType" value="sgt">
                                        <label for="vsaSgt">Security Group Tag</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaAirgroup" name="vsaType" value="airgroup">
                                        <label for="vsaAirgroup">Airgroup Policy</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="vsaQos" name="vsaType" value="qos">
                                        <label for="vsaQos">QoS Policy</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="customVsa">Custom VSA Configuration:</label>
                                <textarea id="customVsa" class="form-control" rows="5" placeholder="Enter custom VSA configuration, e.g.:&#10;vendor-specific cisco attribute 1 string 'subscriber:command=reauthenticate'"></textarea>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-next">Next</button>
                    </div>
                </section>

                <!-- TACACS+ Configuration Section -->
                <section id="tacacs-config" class="config-section">
                    <h2><i class="fas fa-lock"></i> TACACS+ Configuration</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="tacacs-servers">Servers</div>
                            <div class="tab" data-tab="tacacs-authz">Authorization</div>
                            <div class="tab" data-tab="tacacs-acct">Accounting</div>
                            <div class="tab" data-tab="tacacs-cmd">Command Sets</div>
                            <div class="tab" data-tab="tacacs-api">API & Integration</div>
                        </div>
                        
                        <div class="tab-content active" id="tacacs-servers">
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="tacacsServerGroup">TACACS+ Server Group Name:</label>
                                    <input type="text" id="tacacsServerGroup" class="form-control" value="SG-TAC-SERVERS">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="tacacsTimeout">Timeout (seconds):</label>
                                    <input type="number" id="tacacsTimeout" class="form-control" value="1" min="1" max="60">
                                </div>
                            </div>

                            <div class="server-container">
                                <h3>Primary TACACS+ Server</h3>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="tacacsServer1Name">Server Name:</label>
                                        <input type="text" id="tacacsServer1Name" class="form-control" value="TAC-SERVER-1">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="tacacsServer1">Server IP Address:</label>
                                        <input type="text" id="tacacsServer1" class="form-control" placeholder="e.g., 10.10.10.101">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="tacacsPort1">Port:</label>
                                        <input type="number" id="tacacsPort1" class="form-control" value="49">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="tacacsKey1">Shared Secret:</label>
                                        <div class="password-field">
                                            <input type="password" id="tacacsKey1" class="form-control" placeholder="Enter shared secret">
                                            <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsSingleConn1" name="tacacsSingleConn" value="single1" checked>
                                        <label for="tacacsSingleConn1">Use Single Connection</label>
                                    </div>
                                </div>
                            </div>

                            <div class="server-container">
                                <h3>Secondary TACACS+ Server</h3>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="tacacsServer2Name">Server Name:</label>
                                        <input type="text" id="tacacsServer2Name" class="form-control" value="TAC-SERVER-2">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="tacacsServer2">Server IP Address:</label>
                                        <input type="text" id="tacacsServer2" class="form-control" placeholder="e.g., 10.10.10.102">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="tacacsPort2">Port:</label>
                                        <input type="number" id="tacacsPort2" class="form-control" value="49">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="tacacsKey2">Shared Secret:</label>
                                        <div class="password-field">
                                            <input type="password" id="tacacsKey2" class="form-control" placeholder="Enter shared secret">
                                            <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsSingleConn2" name="tacacsSingleConn" value="single2" checked>
                                        <label for="tacacsSingleConn2">Use Single Connection</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <button id="addTacacsServerBtn" class="btn-secondary"><i class="fas fa-plus"></i> Add Another TACACS+ Server</button>
                            </div>

                            <div class="form-group">
                                <label for="tacacsSourceInterface">Source Interface:</label>
                                <input type="text" id="tacacsSourceInterface" class="form-control" value="Vlan 10">
                            </div>

                            <div class="form-group">
                                <label for="tacacsKeyFormat">TACACS+ Key Format:</label>
                                <select id="tacacsKeyFormat" class="form-control">
                                    <option value="type0">Type 0 (Clear Text)</option>
                                    <option value="type7">Type 7 (Reversible Encryption)</option>
                                    <option value="type8">Type 8 (PBKDF2 SHA-256)</option>
                                    <option value="type9">Type 9 (Scrypt)</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Local Fallback Configuration:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="localUsername">Local Admin Username:</label>
                                        <input type="text" id="localUsername" class="form-control" value="admin">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="localPassword">Local Admin Password:</label>
                                        <div class="password-field">
                                            <input type="password" id="localPassword" class="form-control" placeholder="Enter local password">
                                            <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="localPrivilege">Privilege Level:</label>
                                        <select id="localPrivilege" class="form-control">
                                            <option value="15">15 (Full Administrative Access)</option>
                                            <option value="10">10 (Partial Administrative Access)</option>
                                            <option value="5">5 (Limited Administrative Access)</option>
                                            <option value="1">1 (View-Only Access)</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="enablePassword">Enable Password:</label>
                                        <div class="password-field">
                                            <input type="password" id="enablePassword" class="form-control" placeholder="Enter enable password">
                                            <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="tacacs-authz">
                            <div class="form-group">
                                <label for="tacacsAuthMethod">Authentication Method List:</label>
                                <input type="text" id="tacacsAuthMethod" class="form-control" value="ML-TACACS-AUTHC">
                            </div>
                            
                            <div class="form-group">
                                <label for="tacacsAuthzMethod">Authorization Method List:</label>
                                <input type="text" id="tacacsAuthzMethod" class="form-control" value="ML-TACACS-AUTHZ">
                            </div>
                            
                            <div class="form-group">
                                <label>Authentication Options:</label>
                                <div class="radio-group">
                                    <div class="radio-item">
                                        <input type="radio" id="tacacsAuthMethod1" name="tacacsAuthMethodType" value="tacacsFirst" checked>
                                        <label for="tacacsAuthMethod1">TACACS+ first, then local</label>
                                    </div>
                                    <div class="radio-item">
                                        <input type="radio" id="tacacsAuthMethod2" name="tacacsAuthMethodType" value="localFirst">
                                        <label for="tacacsAuthMethod2">Local first, then TACACS+</label>
                                    </div>
                                    <div class="radio-item">
                                        <input type="radio" id="tacacsAuthMethod3" name="tacacsAuthMethodType" value="tacacsOnly">
                                        <label for="tacacsAuthMethod3">TACACS+ only</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Authorization Options:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAuthzConsole" name="tacacsAuthz" value="console" checked>
                                        <label for="tacacsAuthzConsole">Enable Console Authorization</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAuthzCommands" name="tacacsAuthz" value="commands" checked>
                                        <label for="tacacsAuthzCommands">Enable Per-Command Authorization</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAuthzConfig" name="tacacsAuthz" value="config">
                                        <label for="tacacsAuthzConfig">Enable Configuration Authorization</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAuthzReverse" name="tacacsAuthz" value="reverse">
                                        <label for="tacacsAuthzReverse">Enable Reverse Access (TACACS Client Enforcement)</label>
                                    </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="tacacsAuthzIfAuthenticated">If-Authenticated Fallback:</label>
                                <select id="tacacsAuthzIfAuthenticated" class="form-control">
                                    <option value="if-authenticated">Enable if-authenticated fallback</option>
                                    <option value="none">No fallback</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Access Control:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="consoleTimeout">Console Timeout (minutes):</label>
                                        <input type="number" id="consoleTimeout" class="form-control" value="15" min="1" max="120">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="vtyTimeout">VTY Timeout (minutes):</label>
                                        <input type="number" id="vtyTimeout" class="form-control" value="30" min="1" max="120">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="maxFailedLogins">Max Failed Logins:</label>
                                        <input type="number" id="maxFailedLogins" class="form-control" value="3" min="1" max="10">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="loginBlockTime">Login Block Time (seconds):</label>
                                        <input type="number" id="loginBlockTime" class="form-control" value="120" min="60" max="3600">
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="tacacs-acct">
                            <div class="form-group">
                                <label>Accounting Options:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAcctCommands" name="tacacsAcct" value="commands" checked>
                                        <label for="tacacsAcctCommands">Enable Command Accounting</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAcctExec" name="tacacsAcct" value="exec" checked>
                                        <label for="tacacsAcctExec">Enable EXEC Accounting</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAcctSystem" name="tacacsAcct" value="system">
                                        <label for="tacacsAcctSystem">Enable System Accounting</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAcctConnection" name="tacacsAcct" value="connection">
                                        <label for="tacacsAcctConnection">Enable Connection Accounting</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAcctResource" name="tacacsAcct" value="resource">
                                        <label for="tacacsAcctResource">Enable Resource Accounting</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="tacacsAcctCommandLevel">Command Levels for Accounting:</label>
                                <select id="tacacsAcctCommandLevel" class="form-control" multiple>
                                    <option value="0" selected>Level 0 (Default)</option>
                                    <option value="1" selected>Level 1 (User EXEC)</option>
                                    <option value="15" selected>Level 15 (Privileged EXEC)</option>
                                </select>
                                <small class="form-text text-muted">Hold Ctrl/Cmd to select multiple levels</small>
                            </div>
                            
                            <div class="form-group">
                                <label for="tacacsAcctMethod">Accounting Method:</label>
                                <select id="tacacsAcctMethod" class="form-control">
                                    <option value="start-stop">Start-Stop</option>
                                    <option value="stop-only">Stop-Only</option>
                                    <option value="none">None</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="tacacsAcctInclude">Include in Accounting Records:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctIncludeCli" name="acctInclude" value="cli" checked>
                                        <label for="acctIncludeCli">CLI Commands</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctIncludeTimestamp" name="acctInclude" value="timestamp" checked>
                                        <label for="acctIncludeTimestamp">Timestamps</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctIncludeProtocol" name="acctInclude" value="protocol" checked>
                                        <label for="acctIncludeProtocol">Protocol Information</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctIncludeIp" name="acctInclude" value="ip" checked>
                                        <label for="acctIncludeIp">IP Address</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="tacacsAcctSyslog">Syslog Integration:</label>
                                <select id="tacacsAcctSyslog" class="form-control">
                                    <option value="local">Local Syslog Only</option>
                                    <option value="server">Remote Syslog Server Only</option>
                                    <option value="both" selected>Both Local and Remote</option>
                                    <option value="none">No Syslog Integration</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="syslogHost">Syslog Host:</label>
                                <input type="text" id="syslogHost" class="form-control" placeholder="e.g., 10.10.10.100">
                            </div>
                        </div>

                        <div class="tab-content" id="tacacs-cmd">
                            <div class="form-group">
                                <label>Command Set Configuration:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="cmdSetEnable" name="cmdSet" value="enable" checked>
                                        <label for="cmdSetEnable">Enable Command Authorization</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="cmdSetDefault" name="cmdSet" value="default">
                                        <label for="cmdSetDefault">Configure Default Command Sets</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="cmdSetCustom" name="cmdSet" value="custom">
                                        <label for="cmdSetCustom">Configure Custom Command Sets</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group" id="defaultCmdSets" style="display: none;">
                                <label>Default Command Sets:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="adminCmdSet">Admin Command Set:</label>
                                        <select id="adminCmdSet" class="form-control">
                                            <option value="full">Full Access (All Commands)</option>
                                            <option value="readonly">Read-Only Access</option>
                                            <option value="custom">Custom Access</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="operatorCmdSet">Operator Command Set:</label>
                                        <select id="operatorCmdSet" class="form-control">
                                            <option value="monitor">Monitoring Commands</option>
                                            <option value="limited">Limited Configuration</option>
                                            <option value="custom">Custom Access</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="readonlyCmdSet">Read-Only Command Set:</label>
                                        <select id="readonlyCmdSet" class="form-control">
                                            <option value="show">Show Commands Only</option>
                                            <option value="basics">Basic Commands</option>
                                            <option value="custom">Custom Access</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group" id="customCmdSet" style="display: none;">
                                <label for="customCommandSet">Custom Command Set:</label>
                                <textarea id="customCommandSet" class="form-control" rows="10" placeholder="Enter custom command set configuration, e.g.:&#10;# Admin Commands&#10;permit command configure&#10;permit command show&#10;permit command clear&#10;&#10;# Deny Dangerous Commands&#10;deny command reload&#10;deny command reset&#10;deny command format"></textarea>
                            </div>

                            <div class="form-group">
                                <label for="commandPrivLevel">Command Privilege Levels:</label>
                                <div class="command-privilege-container">
                                    <table class="command-privilege-table">
                                        <thead>
                                            <tr>
                                                <th>Command</th>
                                                <th>Privilege Level</th>
                                                <th>Allow/Deny</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><code>show running-config</code></td>
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
                                            </tr>
                                            <tr>
                                                <td><code>show interfaces</code></td>
                                                <td>
                                                    <select class="form-control">
                                                        <option>15</option>
                                                        <option>10</option>
                                                        <option selected>5</option>
                                                        <option>1</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <select class="form-control">
                                                        <option>Allow</option>
                                                        <option>Deny</option>
                                                    </select>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td><code>configure terminal</code></td>
                                                <td>
                                                    <select class="form-control">
                                                        <option selected>15</option>
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
                                            </tr>
                                            <tr>
                                                <td><code>reload</code></td>
                                                <td>
                                                    <select class="form-control">
                                                        <option selected>15</option>
                                                        <option>10</option>
                                                        <option>5</option>
                                                        <option>1</option>
                                                    </select>
                                                </td>
                                                <td>
                                                    <select class="form-control">
                                                        <option>Allow</option>
                                                        <option selected>Deny</option>
                                                    </select>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <button id="addCommandBtn" class="btn-secondary"><i class="fas fa-plus"></i> Add Command</button>
                                </div>
                            </div>
                        </div>

                        <div class="tab-content" id="tacacs-api">
                            <div class="form-group">
                                <label>TACACS+ API Integration:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsApiRest" name="tacacsApi" value="rest">
                                        <label for="tacacsApiRest">Enable REST API</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsApiSyslog" name="tacacsApi" value="syslog" checked>
                                        <label for="tacacsApiSyslog">Enable Syslog Integration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsApiSnmp" name="tacacsApi" value="snmp">
                                        <label for="tacacsApiSnmp">Enable SNMP Integration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsApiWebhook" name="tacacsApi" value="webhook">
                                        <label for="tacacsApiWebhook">Enable Webhook Notifications</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="tacacsHttpAuth">HTTP/HTTPS Authentication:</label>
                                <select id="tacacsHttpAuth" class="form-control">
                                    <option value="tacacs-local">TACACS+ then Local</option>
                                    <option value="local-tacacs">Local then TACACS+</option>
                                    <option value="tacacs">TACACS+ Only</option>
                                    <option value="local">Local Only</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="tacacsRestconfAuth">RESTCONF/NETCONF Authentication:</label>
                                <select id="tacacsRestconfAuth" class="form-control">
                                    <option value="tacacs-local">TACACS+ then Local</option>
                                    <option value="local-tacacs">Local then TACACS+</option>
                                    <option value="tacacs">TACACS+ Only</option>
                                    <option value="local">Local Only</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="tacacsApiAuthz">API Authorization Method:</label>
                                <select id="tacacsApiAuthz" class="form-control">
                                    <option value="role-based">Role-Based Access Control</option>
                                    <option value="attribute-based">Attribute-Based Access Control</option>
                                    <option value="group-based">Group-Based Access Control</option>
                                    <option value="none">No Additional Authorization</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="tacacsApiRoles">API Roles:</label>
                                <select id="tacacsApiRoles" class="form-control" multiple>
                                    <option value="admin" selected>Administrator (Full Access)</option>
                                    <option value="operator" selected>Operator (Limited Config Access)</option>
                                    <option value="monitor" selected>Monitor (Read-Only Access)</option>
                                    <option value="security">Security Admin</option>
                                    <option value="network">Network Admin</option>
                                </select>
                                <small class="form-text text-muted">Hold Ctrl/Cmd to select multiple roles</small>
                            </div>

                            <div class="form-group">
                                <label for="tacacsApiEndpoints">Enable API Endpoints:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiUsers" name="apiEndpoint" value="users" checked>
                                        <label for="apiUsers">Users & Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiConfig" name="apiEndpoint" value="config" checked>
                                        <label for="apiConfig">Configuration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiMonitoring" name="apiEndpoint" value="monitoring" checked>
                                        <label for="apiMonitoring">Monitoring & Statistics</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="apiOperations" name="apiEndpoint" value="operations" checked>
                                        <label for="apiOperations">Operations & Actions</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-next">Next</button>
                    </div>
                </section>

                <!-- Advanced Features Section -->
                <section id="advanced-features" class="config-section">
                    <h2><i class="fas fa-sliders-h"></i> Advanced Features</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="adv-security">Security</div>
                            <div class="tab" data-tab="adv-access">Access Control</div>
                            <div class="tab" data-tab="adv-guest">Guest Access</div>
                            <div class="tab" data-tab="adv-byod">BYOD & Onboarding</div>
                            <div class="tab" data-tab="adv-iot">IoT Management</div>
                        </div>
                        
                        <div class="tab-content active" id="adv-security">
                            <div class="form-group">
                                <label>Security Features:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureCriticalAuth" name="securityFeature" value="criticalAuth" checked>
                                        <label for="featureCriticalAuth">Critical Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureMacSec" name="securityFeature" value="macSec">
                                        <label for="featureMacSec">MACsec Encryption</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureRadSec" name="securityFeature" value="radSec">
                                        <label for="featureRadSec">RadSec</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureCoa" name="securityFeature" value="coa" checked>
                                        <label for="featureCoa">Change of Authorization (CoA)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureSecureVlan" name="securityFeature" value="secureVlan">
                                        <label for="featureSecureVlan">Secure VLAN Hopping Protection</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureIdpriv" name="securityFeature" value="idpriv">
                                        <label for="featureIdpriv">Identity Privacy</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="criticalAuthSettings">
                                <h3>Critical Authentication Settings</h3>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="criticalDataVlan">Critical Data VLAN:</label>
                                        <input type="number" id="criticalDataVlan" class="form-control" value="999">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="criticalVoiceVlan">Critical Voice VLAN:</label>
                                        <input type="number" id="criticalVoiceVlan" class="form-control" value="999">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="criticalRecoveryDelay">Recovery Delay (ms):</label>
                                    <input type="number" id="criticalRecoveryDelay" class="form-control" value="2000">
                                </div>
                                <div class="form-group">
                                    <label for="criticalAcl">Critical Authentication ACL:</label>
                                    <select id="criticalAcl" class="form-control">
                                        <option value="open">ACL-OPEN (Allow All Traffic)</option>
                                        <option value="limited">ACL-LIMITED (DHCP/DNS Only)</option>
                                        <option value="server">ACL-SERVER (Allow Server Access Only)</option>
                                        <option value="custom">Custom ACL</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="macSecSettings" style="display:none;">
                                <h3>MACsec Settings</h3>
                                <div class="form-group">
                                    <label for="macSecPolicy">MACsec Policy:</label>
                                    <select id="macSecPolicy" class="form-control">
                                        <option value="should-secure">Should Secure (Prefer encryption)</option>
                                        <option value="must-secure">Must Secure (Require encryption)</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="macSecCipherSuite">Cipher Suite:</label>
                                    <select id="macSecCipherSuite" class="form-control">
                                        <option value="gcm-aes-128">GCM-AES-128</option>
                                        <option value="gcm-aes-256">GCM-AES-256</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="macSecKeyServer">Key Server Priority:</label>
                                    <input type="number" id="macSecKeyServer" class="form-control" value="16" min="0" max="255">
                                </div>
                                <div class="form-group">
                                    <label for="macSecSak">SAK Rekey Time (seconds):</label>
                                    <input type="number" id="macSecSak" class="form-control" value="0" min="0" max="7200">
                                    <small class="form-text text-muted">0 = No periodic rekey</small>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="radSecSettings" style="display:none;">
                                <h3>RadSec Settings</h3>
                                <div class="form-group">
                                    <label for="radSecServer">RadSec Server:</label>
                                    <input type="text" id="radSecServer" class="form-control" value="radsec.example.com">
                                </div>
                                <div class="form-group">
                                    <label for="radSecPort">Port:</label>
                                    <input type="number" id="radSecPort" class="form-control" value="2083">
                                </div>
                                <div class="form-group">
                                    <label for="radSecCertPath">Certificate Path:</label>
                                    <input type="text" id="radSecCertPath" class="form-control" value="bootflash:radsec-cert.pem">
                                </div>
                                <div class="form-group">
                                    <label for="radSecCaCert">CA Certificate Path:</label>
                                    <input type="text" id="radSecCaCert" class="form-control" value="bootflash:ca-cert.pem">
                                </div>
                                <div class="form-group">
                                    <label for="radSecTimeout">TLS Connection Timeout:</label>
                                    <input type="number" id="radSecTimeout" class="form-control" value="5" min="1" max="60">
                                </div>
                            </div>

                            <div class="feature-settings" id="secureVlanSettings" style="display:none;">
                                <h3>Secure VLAN Hopping Protection</h3>
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="vlanAclEnabled" name="vlanAcl" value="enabled" checked>
                                            <label for="vlanAclEnabled">Enable VLAN ACLs</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="privVlanEnabled" name="privVlan" value="enabled">
                                            <label for="privVlanEnabled">Configure Private VLANs</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="trunkNative" name="trunkNative" value="enabled" checked>
                                            <label for="trunkNative">Set Unused Native VLAN</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="disableDtp" name="disableDtp" value="enabled" checked>
                                            <label for="disableDtp">Disable DTP (Dynamic Trunking Protocol)</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="disableVTP" name="disableVTP" value="enabled" checked>
                                            <label for="disableVTP">Disable VTP (VLAN Trunking Protocol)</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="unusedNativeVlan">Unused Native VLAN ID:</label>
                                    <input type="number" id="unusedNativeVlan" class="form-control" value="999" min="1" max="4094">
                                </div>
                            </div>

                            <div class="feature-settings" id="idprivSettings" style="display:none;">
                                <h3>Identity Privacy Settings</h3>
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="eapPrivacy" name="idpriv" value="eap" checked>
                                            <label for="eapPrivacy">EAP Identity Privacy</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="anonymousId" name="idpriv" value="anon" checked>
                                            <label for="anonymousId">Use Anonymous Identity</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="dhcpPrivacy" name="idpriv" value="dhcp">
                                            <label for="dhcpPrivacy">DHCP Client ID Privacy</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="anonymousIdValue">Anonymous Identity:</label>
                                    <input type="text" id="anonymousIdValue" class="form-control" value="anonymous@domain.com">
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="adv-access">
                            <div class="form-group">
                                <label>Access Control Features:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureDacl" name="accessFeature" value="dacl" checked>
                                        <label for="featureDacl">Downloadable ACLs</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureSgt" name="accessFeature" value="sgt">
                                        <label for="featureSgt">Security Group Tags (SGT)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureVlan" name="accessFeature" value="vlan" checked>
                                        <label for="featureVlan">Dynamic VLAN Assignment</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featurePosture" name="accessFeature" value="posture">
                                        <label for="featurePosture">Posture Assessment</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureProfiling" name="accessFeature" value="profiling" checked>
                                        <label for="featureProfiling">Device Profiling</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureQos" name="accessFeature" value="qos">
                                        <label for="featureQos">Quality of Service</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureUrlRedir" name="accessFeature" value="urlRedir">
                                        <label for="featureUrlRedir">URL Redirection</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="daclSettings">
                                <h3>Downloadable ACL Settings</h3>
                                <div class="form-group">
                                    <label for="daclFallback">Fallback ACL Name:</label>
                                    <input type="text" id="daclFallback" class="form-control" value="ACL-DEFAULT">
                                </div>
                                <div class="form-group">
                                    <label for="daclTimeout">ACL Download Timeout (seconds):</label>
                                    <input type="number" id="daclTimeout" class="form-control" value="5">
                                </div>
                                <div class="form-group">
                                    <label for="daclCacheTimeout">ACL Cache Timeout (minutes):</label>
                                    <input type="number" id="daclCacheTimeout" class="form-control" value="60" min="0" max="1440">
                                    <small class="form-text text-muted">0 = No caching</small>
                                </div>
                                <div class="form-group">
                                    <label for="daclTemplate">Sample dACL Template:</label>
                                    <select id="daclTemplate" class="form-control">
                                        <option value="employee">Employee Access</option>
                                        <option value="contractor">Contractor Access</option>
                                        <option value="guest">Guest Access</option>
                                        <option value="iot">IoT Device Access</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <textarea id="daclTemplateContent" class="form-control code-output" rows="6" readonly>
permit udp any eq bootpc any eq bootps
permit udp any eq bootps any eq bootpc
permit udp any any eq domain
permit tcp any any eq 80
permit tcp any any eq 443
deny ip any any
                                    </textarea>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="sgtSettings" style="display:none;">
                                <h3>Security Group Tag Settings</h3>
                                <div class="form-group">
                                    <label for="sgtPropagation">SGT Propagation:</label>
                                    <select id="sgtPropagation" class="form-control">
                                        <option value="enable">Enable</option>
                                        <option value="disable">Disable</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="sgtAssignment">SGT Assignment Method:</label>
                                    <select id="sgtAssignment" class="form-control">
                                        <option value="radius">From RADIUS Server</option>
                                        <option value="local">Local SGT Mapping</option>
                                        <option value="both">Both Methods</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Common SGT Values:</label>
                                    <div class="sgt-table-container">
                                        <table class="sgt-table">
                                            <thead>
                                                <tr>
                                                    <th>Tag Value</th>
                                                    <th>Name</th>
                                                    <th>Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>2</td>
                                                    <td>TrustSec_Devices</td>
                                                    <td>Trusted infrastructure devices</td>
                                                </tr>
                                                <tr>
                                                    <td>3</td>
                                                    <td>Employees</td>
                                                    <td>Regular employee access</td>
                                                </tr>
                                                <tr>
                                                    <td>4</td>
                                                    <td>Contractors</td>
                                                    <td>External contractor access</td>
                                                </tr>
                                                <tr>
                                                    <td>5</td>
                                                    <td>Guests</td>
                                                    <td>Guest network access</td>
                                                </tr>
                                                <tr>
                                                    <td>6</td>
                                                    <td>Servers</td>
                                                    <td>Server resources</td>
                                                </tr>
                                                <tr>
                                                    <td>7</td>
                                                    <td>IoT_Devices</td>
                                                    <td>IoT and operational devices</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="profilingSettings">
                                <h3>Device Profiling Settings</h3>
                                <div class="form-group">
                                    <label>Device Sensor Protocol:</label>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="sensorDhcp" name="sensorProtocol" value="dhcp" checked>
                                            <label for="sensorDhcp">DHCP</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="sensorCdp" name="sensorProtocol" value="cdp" checked>
                                            <label for="sensorCdp">CDP</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="sensorLldp" name="sensorProtocol" value="lldp" checked>
                                            <label for="sensorLldp">LLDP</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="sensorHttp" name="sensorProtocol" value="http">
                                            <label for="sensorHttp">HTTP</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="sensorNetflow" name="sensorProtocol" value="netflow">
                                            <label for="sensorNetflow">NetFlow</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="sensorAccounting">Accounting:</label>
                                    <select id="sensorAccounting" class="form-control">
                                        <option value="enable">Include in accounting</option>
                                        <option value="disable">Do not include in accounting</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="profilingCacheTimeout">Profiling Cache Timeout (minutes):</label>
                                    <input type="number" id="profilingCacheTimeout" class="form-control" value="1440" min="60" max="44640">
                                </div>
                                <div class="form-group">
                                    <label for="profilingFrequency">Profiling Update Frequency:</label>
                                    <select id="profilingFrequency" class="form-control">
                                        <option value="all-changes">All Changes</option>
                                        <option value="new-sessions">New Sessions Only</option>
                                        <option value="periodic">Periodic Updates</option>
                                    </select>
                                </div>
                            </div>

                            <div class="feature-settings" id="qosSettings" style="display:none;">
                                <h3>Quality of Service Settings</h3>
                                <div class="form-group">
                                    <label for="qosType">QoS Implementation:</label>
                                    <select id="qosType" class="form-control">
                                        <option value="radius">RADIUS-Based QoS</option>
                                        <option value="local">Local QoS Policy</option>
                                        <option value="both">Combined Approach</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="qosTrust">QoS Trust Mode:</label>
                                    <select id="qosTrust" class="form-control">
                                        <option value="dscp">Trust DSCP</option>
                                        <option value="cos">Trust CoS</option>
                                        <option value="none">No Trust</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="qosDefaultPolicy">Default QoS Policy:</label>
                                    <select id="qosDefaultPolicy" class="form-control">
                                        <option value="default">Default (Best Effort)</option>
                                        <option value="voice">Voice Priority</option>
                                        <option value="custom">Custom Policy</option>
                                    </select>
                                </div>
                            </div>

                            <div class="feature-settings" id="urlRedirSettings" style="display:none;">
                                <h3>URL Redirection Settings</h3>
                                <div class="form-group">
                                    <label for="urlRedirAcl">Redirection ACL Name:</label>
                                    <input type="text" id="urlRedirAcl" class="form-control" value="ACL-REDIRECT">
                                </div>
                                <div class="form-group">
                                    <label for="urlRedirServer">Redirection Server URL:</label>
                                    <input type="text" id="urlRedirServer" class="form-control" value="https://portal.example.com">
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="urlRedirHttps" name="urlRedir" value="https" checked>
                                            <label for="urlRedirHttps">HTTPS Redirection</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="urlRedirHttp" name="urlRedir" value="http" checked>
                                            <label for="urlRedirHttp">HTTP Redirection</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="urlRedirStatic" name="urlRedir" value="static">
                                            <label for="urlRedirStatic">Use Static URL</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="urlRedirClientIP" name="urlRedir" value="clientip" checked>
                                            <label for="urlRedirClientIP">Include Client IP</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="adv-guest">
                            <div class="form-group">
                                <label>Guest Access Features:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureWebAuth" name="guestFeature" value="webauth">
                                        <label for="featureWebAuth">Web Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureGuestVlan" name="guestFeature" value="guestVlan">
                                        <label for="featureGuestVlan">Guest VLAN</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureRedirect" name="guestFeature" value="redirect">
                                        <label for="featureRedirect">URL Redirection</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureCaptivePortal" name="guestFeature" value="captivePortal">
                                        <label for="featureCaptivePortal">Captive Portal</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureSponsoredAccess" name="guestFeature" value="sponsored">
                                        <label for="featureSponsoredAccess">Sponsored Guest Access</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureSelfRegistration" name="guestFeature" value="selfReg">
                                        <label for="featureSelfRegistration">Self-Registration</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="webAuthSettings" style="display:none;">
                                <h3>Web Authentication Settings</h3>
                                <div class="form-group">
                                    <label for="webAuthType">Web Authentication Type:</label>
                                    <select id="webAuthType" class="form-control">
                                        <option value="local">Local</option>
                                        <option value="external">External</option>
                                        <option value="auto">Auto</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="webAuthPortal">Portal URL:</label>
                                    <input type="text" id="webAuthPortal" class="form-control" value="https://example.com/guest">
                                </div>
                                <div class="form-group">
                                    <label for="webAuthIdleTimeout">Session Idle Timeout (seconds):</label>
                                    <input type="number" id="webAuthIdleTimeout" class="form-control" value="300" min="60" max="86400">
                                </div>
                                <div class="form-group">
                                    <label for="webAuthMaxAttempts">Maximum Login Attempts:</label>
                                    <input type="number" id="webAuthMaxAttempts" class="form-control" value="3" min="1" max="10">
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="webAuthHttps" name="webauth" value="https" checked>
                                            <label for="webAuthHttps">Use HTTPS</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="webAuthCustomLogo" name="webauth" value="logo">
                                            <label for="webAuthCustomLogo">Use Custom Logo</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="webAuthConsent" name="webauth" value="consent" checked>
                                            <label for="webAuthConsent">Require Consent Agreement</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="guestVlanSettings" style="display:none;">
                                <h3>Guest VLAN Settings</h3>
                                <div class="form-group">
                                    <label for="guestVlanId">Guest VLAN ID:</label>
                                    <input type="number" id="guestVlanId" class="form-control" value="100">
                                </div>
                                <div class="form-group">
                                    <label for="guestTimeout">Session Timeout (seconds):</label>
                                    <input type="number" id="guestTimeout" class="form-control" value="3600">
                                </div>
                                <div class="form-group">
                                    <label for="guestVlanAssignment">VLAN Assignment Method:</label>
                                    <select id="guestVlanAssignment" class="form-control">
                                        <option value="auth-fail">Authentication Failure</option>
                                        <option value="no-resp">No 802.1X Response</option>
                                        <option value="both">Both Methods</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="guestAcl">Guest Access ACL:</label>
                                    <select id="guestAcl" class="form-control">
                                        <option value="web-only">Web-Only Access</option>
                                        <option value="limited">Limited Access</option>
                                        <option value="open">Open Access</option>
                                        <option value="custom">Custom ACL</option>
                                    </select>
                                </div>
                            </div>

                            <div class="feature-settings" id="captivePortalSettings" style="display:none;">
                                <h3>Captive Portal Settings</h3>
                                <div class="form-group">
                                    <label for="captivePortalType">Captive Portal Type:</label>
                                    <select id="captivePortalType" class="form-control">
                                        <option value="central">Central Web Authentication (CWA)</option>
                                        <option value="local">Local Web Authentication (LWA)</option>
                                        <option value="flex">Flex Authentication</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="captivePortalRedirectACL">Redirection ACL:</label>
                                    <input type="text" id="captivePortalRedirectACL" class="form-control" value="WEBAUTH-REDIRECT">
                                </div>
                                <div class="form-group">
                                    <label for="captivePortalUrl">Portal URL:</label>
                                    <input type="text" id="captivePortalUrl" class="form-control" value="https://guest.example.com/portal">
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="cpBypassApps" name="cp" value="bypass">
                                            <label for="cpBypassApps">Bypass for Specific Applications</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="cpSsl" name="cp" value="ssl" checked>
                                            <label for="cpSsl">Support for SSL Redirection</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="cpCustomization" name="cp" value="custom">
                                            <label for="cpCustomization">Portal Customization</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="feature-settings" id="sponsoredAccessSettings" style="display:none;">
                                <h3>Sponsored Guest Access Settings</h3>
                                <div class="form-group">
                                    <label for="sponsorGroups">Sponsor Groups:</label>
                                    <select id="sponsorGroups" class="form-control" multiple>
                                        <option value="all-employees" selected>All Employees</option>
                                        <option value="it-dept">IT Department</option>
                                        <option value="reception">Reception Staff</option>
                                        <option value="management">Management</option>
                                        <option value="custom">Custom Group</option>
                                    </select>
                                    <small class="form-text text-muted">Hold Ctrl/Cmd to select multiple groups</small>
                                </div>
                                <div class="form-group">
                                    <label for="sponsorApprovalMethod">Approval Method:</label>
                                    <select id="sponsorApprovalMethod" class="form-control">
                                        <option value="auto">Auto-Approve</option>
                                        <option value="self-approve">Self-Approve</option>
                                        <option value="email">Email Approval Required</option>
                                        <option value="portal">Portal Approval Required</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="sponsorMaxAccount">Maximum Accounts Per Sponsor:</label>
                                    <input type="number" id="sponsorMaxAccount" class="form-control" value="5" min="1" max="100">
                                </div>
                                <div class="form-group">
                                    <label for="guestDefaultDuration">Default Guest Account Duration (hours):</label>
                                    <input type="number" id="guestDefaultDuration" class="form-control" value="24" min="1" max="168">
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="adv-byod">
                            <div class="form-group">
                                <label>BYOD & Onboarding Features:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureProvisioning" name="byodFeature" value="provisioning">
                                        <label for="featureProvisioning">Auto Provisioning</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureDeviceReg" name="byodFeature" value="deviceReg">
                                        <label for="featureDeviceReg">Device Registration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureCertOnboard" name="byodFeature" value="certOnboard">
                                        <label for="featureCertOnboard">Certificate Onboarding</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureMdm" name="byodFeature" value="mdm">
                                        <label for="featureMdm">MDM Integration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureNac" name="byodFeature" value="nac">
                                        <label for="featureNac">NAC Integration</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureCompliance" name="byodFeature" value="compliance">
                                        <label for="featureCompliance">Compliance Checking</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="provisioningSettings" style="display:none;">
                                <h3>Auto Provisioning Settings</h3>
                                <div class="form-group">
                                    <label for="provisioningVlan">Provisioning VLAN:</label>
                                    <input type="number" id="provisioningVlan" class="form-control" value="20">
                                </div>
                                <div class="form-group">
                                    <label for="provisioningUrl">Provisioning URL:</label>
                                    <input type="text" id="provisioningUrl" class="form-control" value="https://example.com/provision">
                                </div>
                                <div class="form-group">
                                    <label for="provisioningAcl">Provisioning ACL:</label>
                                    <input type="text" id="provisioningAcl" class="form-control" value="PROV-ACL">
                                </div>
                                <div class="form-group">
                                    <label for="byodTimeout">Provisioning Timeout (minutes):</label>
                                    <input type="number" id="byodTimeout" class="form-control" value="15" min="5" max="60">
                                </div>
                            </div>
                            
                            <div class="feature-settings" id="certOnboardSettings" style="display:none;">
                                <h3>Certificate Onboarding Settings</h3>
                                <div class="form-group">
                                    <label for="certProvider">Certificate Provider:</label>
                                    <select id="certProvider" class="form-control">
                                        <option value="scep">SCEP</option>
                                        <option value="est">EST</option>
                                        <option value="manual">Manual</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="certUrl">Certificate URL:</label>
                                    <input type="text" id="certUrl" class="form-control" value="https://example.com/scep">
                                </div>
                                <div class="form-group">
                                    <label for="certRootCa">Root CA:</label>
                                    <input type="text" id="certRootCa" class="form-control" value="Example Enterprise CA">
                                </div>
                                <div class="form-group">
                                    <label for="certRenewal">Certificate Renewal Period (days):</label>
                                    <input type="number" id="certRenewal" class="form-control" value="180" min="30" max="365">
                                </div>
                            </div>

                            <div class="feature-settings" id="mdmSettings" style="display:none;">
                                <h3>MDM Integration Settings</h3>
                                <div class="form-group">
                                    <label for="mdmVendor">MDM Vendor:</label>
                                    <select id="mdmVendor" class="form-control">
                                        <option value="jamf">Jamf</option>
                                        <option value="intune">Microsoft Intune</option>
                                        <option value="airwatch">VMware AirWatch</option>
                                        <option value="mobileiron">MobileIron</option>
                                        <option value="other">Other</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="mdmApiUrl">MDM API URL:</label>
                                    <input type="text" id="mdmApiUrl" class="form-control" value="https://mdm.example.com/api">
                                </div>
                                <div class="form-group">
                                    <label for="mdmApiKey">MDM API Key:</label>
                                    <div class="password-field">
                                        <input type="password" id="mdmApiKey" class="form-control" placeholder="Enter MDM API key">
                                        <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="mdmEnrollmentCheck" name="mdm" value="enrollment" checked>
                                            <label for="mdmEnrollmentCheck">Check MDM Enrollment Status</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="mdmComplianceCheck" name="mdm" value="compliance" checked>
                                            <label for="mdmComplianceCheck">Check Compliance Status</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="mdmJailbreakCheck" name="mdm" value="jailbreak" checked>
                                            <label for="mdmJailbreakCheck">Check for Jailbreak/Root</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="mdmOsVersionCheck" name="mdm" value="osversion">
                                            <label for="mdmOsVersionCheck">Check OS Version</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="feature-settings" id="complianceSettings" style="display:none;">
                                <h3>Compliance Checking Settings</h3>
                                <div class="form-group">
                                    <label>Compliance Checks:</label>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="complianceAv" name="compliance" value="antivirus" checked>
                                            <label for="complianceAv">Antivirus Status</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="complianceFirewall" name="compliance" value="firewall" checked>
                                            <label for="complianceFirewall">Firewall Status</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="compliancePatches" name="compliance" value="patches" checked>
                                            <label for="compliancePatches">Critical Patches</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="complianceOs" name="compliance" value="osversion">
                                            <label for="complianceOs">OS Version</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="complianceEncryption" name="compliance" value="encryption">
                                            <label for="complianceEncryption">Disk Encryption</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="complianceFailAction">Non-Compliance Action:</label>
                                    <select id="complianceFailAction" class="form-control">
                                        <option value="quarantine">Quarantine VLAN</option>
                                        <option value="restrict">Restricted Access</option>
                                        <option value="remediate">Remediation</option>
                                        <option value="block">Block Access</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="complianceQuarantineVlan">Quarantine VLAN:</label>
                                    <input type="number" id="complianceQuarantineVlan" class="form-control" value="900" min="1" max="4094">
                                </div>
                                <div class="form-group">
                                    <label for="complianceUrlRedirect">Remediation URL:</label>
                                    <input type="text" id="complianceUrlRedirect" class="form-control" value="https://remediation.example.com">
                                </div>
                            </div>
                        </div>

                        <div class="tab-content" id="adv-iot">
                            <div class="form-group">
                                <label>IoT Management Features:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureIotProfiling" name="iotFeature" value="profiling" checked>
                                        <label for="featureIotProfiling">IoT Profiling</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureIotOnboarding" name="iotFeature" value="onboarding">
                                        <label for="featureIotOnboarding">Automated Onboarding</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureIotSegmentation" name="iotFeature" value="segmentation" checked>
                                        <label for="featureIotSegmentation">IoT Segmentation</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureIotMacAuth" name="iotFeature" value="macauth" checked>
                                        <label for="featureIotMacAuth">MAC Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="featureIotMonitoring" name="iotFeature" value="monitoring">
                                        <label for="featureIotMonitoring">IoT Behavior Monitoring</label>
                                    </div>
                                </div>
                            </div>

                            <div class="feature-settings" id="iotProfilingSettings">
                                <h3>IoT Profiling Settings</h3>
                                <div class="form-group">
                                    <label for="iotProfilingMethod">Profiling Method:</label>
                                    <select id="iotProfilingMethod" class="form-control">
                                        <option value="mac-oui">MAC OUI Database</option>
                                        <option value="dhcp">DHCP Fingerprinting</option>
                                        <option value="combined" selected>Combined Methods</option>
                                        <option value="advanced">Advanced Profiling</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Common IoT Device Types:</label>
                                    <div class="iot-device-table-container">
                                        <table class="iot-device-table">
                                            <thead>
                                                <tr>
                                                    <th>Device Type</th>
                                                    <th>VLAN</th>
                                                    <th>Security Level</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>IP Cameras</td>
                                                    <td>800</td>
                                                    <td>Medium</td>
                                                </tr>
                                                <tr>
                                                    <td>Building Systems</td>
                                                    <td>801</td>
                                                    <td>Medium</td>
                                                </tr>
                                                <tr>
                                                    <td>Industrial Controls</td>
                                                    <td>802</td>
                                                    <td>High</td>
                                                </tr>
                                                <tr>
                                                    <td>Medical Devices</td>
                                                    <td>803</td>
                                                    <td>High</td>
                                                </tr>
                                                <tr>
                                                    <td>Printers</td>
                                                    <td>804</td>
                                                    <td>Low</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotOui" name="iotProf" value="oui" checked>
                                            <label for="iotOui">Use MAC OUI Database</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotDhcp" name="iotProf" value="dhcp" checked>
                                            <label for="iotDhcp">Use DHCP Options Profiling</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotSnmp" name="iotProf" value="snmp">
                                            <label for="iotSnmp">Use SNMP Profiling</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotLldp" name="iotProf" value="lldp" checked>
                                            <label for="iotLldp">Use LLDP Profiling</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotNetFlow" name="iotProf" value="netflow">
                                            <label for="iotNetFlow">Use NetFlow Profiling</label>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="feature-settings" id="iotSegmentationSettings" style="display:none;">
                                <h3>IoT Segmentation Settings</h3>
                                <div class="form-group">
                                    <label for="iotSegmentMethod">Segmentation Method:</label>
                                    <select id="iotSegmentMethod" class="form-control">
                                        <option value="vlan">VLAN Segmentation</option>
                                        <option value="sgt">Security Group Tags</option>
                                        <option value="acl">Access Control Lists</option>
                                        <option value="hybrid" selected>Hybrid Approach</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="iotBaseVlan">Base IoT VLAN:</label>
                                    <input type="number" id="iotBaseVlan" class="form-control" value="800" min="1" max="4094">
                                </div>
                                <div class="form-group">
                                    <label for="iotAclTemplate">IoT ACL Template:</label>
                                    <select id="iotAclTemplate" class="form-control">
                                        <option value="strict">Strict (Allow only specific servers/ports)</option>
                                        <option value="medium" selected>Medium (Allow internal networks)</option>
                                        <option value="permissive">Permissive (Block only high-risk services)</option>
                                        <option value="custom">Custom ACL</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="iotMicrosegmentation">Enable Microsegmentation:</label>
                                    <select id="iotMicrosegmentation" class="form-control">
                                        <option value="none">None</option>
                                        <option value="partial">Partial (High-risk devices only)</option>
                                        <option value="full">Full Microsegmentation</option>
                                    </select>
                                </div>
                            </div>

                            <div class="feature-settings" id="iotMacAuthSettings" style="display:none;">
                                <h3>IoT MAC Authentication Settings</h3>
                                <div class="form-group">
                                    <label for="iotMacFormat">MAC Address Format:</label>
                                    <select id="iotMacFormat" class="form-control">
                                        <option value="ietf-upper">IETF Upper Case (AA-BB-CC-DD-EE-FF)</option>
                                        <option value="ietf-lower">IETF Lower Case (aa-bb-cc-dd-ee-ff)</option>
                                        <option value="no-separator-upper" selected>No Separator Upper (AABBCCDDEEFF)</option>
                                        <option value="no-separator-lower">No Separator Lower (aabbccddeeff)</option>
                                        <option value="cisco">Cisco Format (aabb.ccdd.eeff)</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label for="iotMacAuthTimeout">Authentication Timeout (seconds):</label>
                                    <input type="number" id="iotMacAuthTimeout" class="form-control" value="5" min="1" max="60">
                                </div>
                                <div class="form-group">
                                    <label for="iotReauthPeriod">Reauthentication Period (hours):</label>
                                    <input type="number" id="iotReauthPeriod" class="form-control" value="24" min="1" max="168">
                                </div>
                                <div class="form-group">
                                    <label for="iotMacFailAction">Failed Authentication Action:</label>
                                    <select id="iotMacFailAction" class="form-control">
                                        <option value="restrict">Restricted VLAN</option>
                                        <option value="reject">Reject</option>
                                        <option value="shutdown">Shutdown Port</option>
                                    </select>
                                </div>
                            </div>

                            <div class="feature-settings" id="iotMonitoringSettings" style="display:none;">
                                <h3>IoT Behavior Monitoring Settings</h3>
                                <div class="form-group">
                                    <label>Monitoring Features:</label>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotTrafficAnalysis" name="iotMon" value="traffic" checked>
                                            <label for="iotTrafficAnalysis">Traffic Analysis</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotNetflow" name="iotMon" value="netflow" checked>
                                            <label for="iotNetflow">NetFlow Monitoring</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotSyslog" name="iotMon" value="syslog" checked>
                                            <label for="iotSyslog">Syslog Monitoring</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotSnmp" name="iotMon" value="snmp">
                                            <label for="iotSnmp">SNMP Monitoring</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="iotAnomaly" name="iotMon" value="anomaly">
                                            <label for="iotAnomaly">Anomaly Detection</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="iotSyslogServer">Syslog Server:</label>
                                    <input type="text" id="iotSyslogServer" class="form-control" value="10.1.1.100">
                                </div>
                                <div class="form-group">
                                    <label for="iotNetflowCollector">NetFlow Collector:</label>
                                    <input type="text" id="iotNetflowCollector" class="form-control" value="10.1.1.101">
                                </div>
                                <div class="form-group">
                                    <label for="iotNetflowVersion">NetFlow Version:</label>
                                    <select id="iotNetflowVersion" class="form-control">
                                        <option value="v5">NetFlow v5</option>
                                        <option value="v9" selected>NetFlow v9</option>
                                        <option value="ipfix">IPFIX</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-next">Next</button>
                    </div>
                </section>

                <!-- Interface Configuration Section -->
                <section id="interface-config" class="config-section">
                    <h2><i class="fas fa-ethernet"></i> Interface Configuration</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="if-access">Access Ports</div>
                            <div class="tab" data-tab="if-trunk">Trunk Ports</div>
                            <div class="tab" data-tab="if-specific">Specific Interfaces</div>
                            <div class="tab" data-tab="if-templates">Port Templates</div>
                        </div>
                        
                        <div class="tab-content active" id="if-access">
                            <div class="form-group">
                                <label for="accessInterfaceRange">Access Port Range:</label>
                                <input type="text" id="accessInterfaceRange" class="form-control" placeholder="e.g., GigabitEthernet1/0/1-24">
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="accessVlan">Access VLAN:</label>
                                    <input type="number" id="accessVlan" class="form-control" value="10">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="voiceVlan">Voice VLAN:</label>
                                    <input type="number" id="voiceVlan" class="form-control" value="20">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Port Settings:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portNonegotiate" name="portSetting" value="nonegotiate" checked>
                                        <label for="portNonegotiate">Nonegotiate</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portPortfast" name="portSetting" value="portfast" checked>
                                        <label for="portPortfast">PortFast</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portBpduguard" name="portSetting" value="bpduguard" checked>
                                        <label for="portBpduguard">BPDU Guard</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portRootguard" name="portSetting" value="rootguard" checked>
                                        <label for="portRootguard">Root Guard</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portStormControl" name="portSetting" value="stormcontrol" checked>
                                        <label for="portStormControl">Storm Control</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portDot1x" name="portSetting" value="dot1x" checked>
                                        <label for="portDot1x">802.1X Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portMab" name="portSetting" value="mab" checked>
                                        <label for="portMab">MAC Authentication Bypass</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Authentication Port Settings:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="dot1xHostMode">Host Mode:</label>
                                        <select id="dot1xHostMode" class="form-control">
                                            <option value="multi-auth">Multi-Auth</option>
                                            <option value="multi-domain">Multi-Domain</option>
                                            <option value="single-host">Single-Host</option>
                                            <option value="multi-host">Multi-Host</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="dot1xControlDirection">Control Direction:</label>
                                        <select id="dot1xControlDirection" class="form-control">
                                            <option value="in">In (Ingress)</option>
                                            <option value="both">Both (Ingress & Egress)</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="dot1xTxPeriod">Tx Period (seconds):</label>
                                        <input type="number" id="dot1xTxPeriod" class="form-control" value="7">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="dot1xMaxReauthReq">Max Reauth Requests:</label>
                                        <input type="number" id="dot1xMaxReauthReq" class="form-control" value="2">
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="inactivityTimer">Inactivity Timer (seconds):</label>
                                        <input type="number" id="inactivityTimer" class="form-control" value="60">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Additional Settings:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="stormControlLevel">Storm Control Level (pps):</label>
                                        <input type="number" id="stormControlLevel" class="form-control" value="100">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="dhcpSnoopingLimit">DHCP Snooping Rate Limit (pps):</label>
                                        <input type="number" id="dhcpSnoopingLimit" class="form-control" value="20">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="portDescription">Port Description Template:</label>
                                        <input type="text" id="portDescription" class="form-control" value="Access Port - 802.1X Authentication">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="portPriority">Port Priority (CoS):</label>
                                        <select id="portPriority" class="form-control">
                                            <option value="0">0 (Default)</option>
                                            <option value="1">1</option>
                                            <option value="2">2</option>
                                            <option value="3">3</option>
                                            <option value="4">4</option>
                                            <option value="5">5</option>
                                            <option value="6">6</option>
                                            <option value="7">7</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="if-trunk">
                            <div class="form-group">
                                <label for="trunkInterfaceRange">Trunk Port Range:</label>
                                <input type="text" id="trunkInterfaceRange" class="form-control" placeholder="e.g., GigabitEthernet1/0/25-48">
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="nativeVlan">Native VLAN:</label>
                                    <input type="number" id="nativeVlan" class="form-control" value="1">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="allowedVlans">Allowed VLANs:</label>
                                    <input type="text" id="allowedVlans" class="form-control" value="1-4094">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label>Trunk Port Settings:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="trunkNonegotiate" name="trunkSetting" value="nonegotiate" checked>
                                        <label for="trunkNonegotiate">Nonegotiate</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="trunkDhcpSnooping" name="trunkSetting" value="dhcpSnooping" checked>
                                        <label for="trunkDhcpSnooping">DHCP Snooping Trust</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="trunkArpInspection" name="trunkSetting" value="arpInspection" checked>
                                        <label for="trunkArpInspection">ARP Inspection Trust</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="trunkDisableTrackingIp" name="trunkSetting" value="disableTracking" checked>
                                        <label for="trunkDisableTrackingIp">Disable IP Tracking</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="trunkNoMonitor" name="trunkSetting" value="noMonitor" checked>
                                        <label for="trunkNoMonitor">No Access-Session Monitor</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="trunkEncapsulation" name="trunkSetting" value="encapsulation">
                                        <label for="trunkEncapsulation">Specify Encapsulation</label>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group" id="encapsulationGroup" style="display: none;">
                                <label for="trunkEncapsulationType">Encapsulation Type:</label>
                                <select id="trunkEncapsulationType" class="form-control">
                                    <option value="dot1q">802.1Q</option>
                                    <option value="isl">ISL</option>
                                    <option value="negotiate">Negotiate</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="trunkDescription">Trunk Description Template:</label>
                                <input type="text" id="trunkDescription" class="form-control" value="Trunk Port - Uplink">
                            </div>

                            <div class="form-group">
                                <label>Spanning Tree Settings:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="trunkStpMode">STP Mode:</label>
                                        <select id="trunkStpMode" class="form-control">
                                            <option value="rapid-pvst">Rapid PVST+</option>
                                            <option value="mst">MST</option>
                                            <option value="pvst">PVST+</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="trunkStpGuard">Guard Type:</label>
                                        <select id="trunkStpGuard" class="form-control">
                                            <option value="root">Root Guard</option>
                                            <option value="loop">Loop Guard</option>
                                            <option value="none">None</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-4">
                                        <label for="trunkStpCost">Path Cost:</label>
                                        <input type="number" id="trunkStpCost" class="form-control" value="0">
                                        <small class="form-text text-muted">0 = Auto</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="if-specific">
                            <div class="form-group">
                                <label for="specificInterfaces">Specific Interfaces (one per line):</label>
                                <textarea id="specificInterfaces" class="form-control" rows="5" placeholder="Enter specific interfaces with configuration, e.g.:&#10;interface GigabitEthernet1/0/1&#10;switchport mode access&#10;switchport access vlan 10"></textarea>
                            </div>
                            
                            <div class="form-group">
                                <label>Add Interface Template:</label>
                                <div class="template-buttons">
                                    <button id="templateAp" class="btn-secondary">Access Point</button>
                                    <button id="templateIpPhone" class="btn-secondary">IP Phone</button>
                                    <button id="templatePrinter" class="btn-secondary">Printer</button>
                                    <button id="templateServer" class="btn-secondary">Server</button>
                                    <button id="templateUplink" class="btn-secondary">Uplink</button>
                                    <button id="templateIot" class="btn-secondary">IoT Device</button>
                                    <button id="templateCamera" class="btn-secondary">IP Camera</button>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="bulkImport">Bulk Import Interfaces:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="importFormat">Import Format:</label>
                                        <select id="importFormat" class="form-control">
                                            <option value="csv">CSV</option>
                                            <option value="json">JSON</option>
                                            <option value="excel">Excel</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="importFile">Import File:</label>
                                        <input type="file" id="importFile" class="form-control-file">
                                    </div>
                                </div>
                                <button id="bulkImportBtn" class="btn-secondary">Import Interfaces</button>
                            </div>
                        </div>

                        <div class="tab-content" id="if-templates">
                            <div class="form-group">
                                <label for="templateName">Template Name:</label>
                                <input type="text" id="templateName" class="form-control" value="WIRED_DOT1X_TEMPLATE">
                            </div>

                            <div class="form-group">
                                <label for="templateType">Template Type:</label>
                                <select id="templateType" class="form-control">
                                    <option value="dot1x">802.1X Authentication</option>
                                    <option value="mab">MAB Only</option>
                                    <option value="webauth">Web Authentication</option>
                                    <option value="macsec">MACsec</option>
                                    <option value="hybrid">Hybrid Authentication</option>
                                    <option value="custom">Custom Template</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="templateContent">Template Content:</label>
                                <textarea id="templateContent" class="form-control code-output" rows="10" readonly>
 dot1x pae authenticator
 dot1x timeout tx-period 7
 dot1x max-reauth-req 2
 mab
 subscriber aging inactivity-timer 60 probe
 access-session control-direction in
 access-session host-mode multi-auth
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY
                                </textarea>
                            </div>

                            <div class="form-group">
                                <label>Template Settings:</label>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="templateApplyRange">Apply to Interface Range:</label>
                                        <input type="text" id="templateApplyRange" class="form-control" placeholder="e.g., GigabitEthernet1/0/1-24">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="templateCommand">Template Application Command:</label>
                                        <select id="templateCommand" class="form-control">
                                            <option value="source">source template</option>
                                            <option value="inherit">inherit template</option>
                                            <option value="apply">apply template</option>
                                        </select>
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Available Templates:</label>
                                <div class="template-list-container">
                                    <table class="template-list-table">
                                        <thead>
                                            <tr>
                                                <th>Template Name</th>
                                                <th>Type</th>
                                                <th>Description</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td>WIRED_DOT1X_CLOSED</td>
                                                <td>802.1X</td>
                                                <td>Standard 802.1X closed mode</td>
                                                <td>
                                                    <button class="btn-icon template-action"><i class="fas fa-edit"></i></button>
                                                    <button class="btn-icon template-action"><i class="fas fa-copy"></i></button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>WIRED_DOT1X_MONITOR</td>
                                                <td>802.1X</td>
                                                <td>Monitor mode authentication</td>
                                                <td>
                                                    <button class="btn-icon template-action"><i class="fas fa-edit"></i></button>
                                                    <button class="btn-icon template-action"><i class="fas fa-copy"></i></button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>IOT_MAB_ONLY</td>
                                                <td>MAB</td>
                                                <td>MAB-only for IoT devices</td>
                                                <td>
                                                    <button class="btn-icon template-action"><i class="fas fa-edit"></i></button>
                                                    <button class="btn-icon template-action"><i class="fas fa-copy"></i></button>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>WEBAUTH_GUEST</td>
                                                <td>WebAuth</td>
                                                <td>Guest web authentication</td>
                                                <td>
                                                    <button class="btn-icon template-action"><i class="fas fa-edit"></i></button>
                                                    <button class="btn-icon template-action"><i class="fas fa-copy"></i></button>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <button id="createTemplateBtn" class="btn-secondary"><i class="fas fa-plus"></i> Create Template</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-next">Next</button>
                    </div>
                </section>

                <!-- Generate Configuration Section -->
                <section id="generate-config" class="config-section">
                    <h2><i class="fas fa-file-code"></i> Generate Configuration</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="gen-config">Configuration</div>
                            <div class="tab" data-tab="gen-validation">Validation</div>
                            <div class="tab" data-tab="gen-deployment">Deployment</div>
                        </div>
                        
                        <div class="tab-content active" id="gen-config">
                            <div class="form-group">
                                <label for="configOutput">Configuration Output:</label>
                                <textarea id="configOutput" class="form-control code-output" rows="20" readonly></textarea>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="generateConfigBtn" class="btn-primary"><i class="fas fa-cog"></i> Generate Configuration</button>
                                <button id="copyConfigBtn" class="btn-secondary"><i class="fas fa-copy"></i> Copy to Clipboard</button>
                                <button id="downloadConfigBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
                                <button id="analyzeConfigBtn" class="btn-secondary"><i class="fas fa-search"></i> Analyze Configuration</button>
                                <button id="optimizeConfigBtn" class="btn-secondary"><i class="fas fa-magic"></i> Optimize Configuration</button>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="gen-validation">
                            <div class="config-validation">
                                <h3>Configuration Validation</h3>
                                <div id="validationResults">
                                    <p>Click "Generate Configuration" first, then switch to this tab to see validation results.</p>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="validationLevel">Validation Level:</label>
                                <select id="validationLevel" class="form-control">
                                    <option value="basic">Basic Validation</option>
                                    <option value="standard" selected>Standard Validation</option>
                                    <option value="strict">Strict Validation</option>
                                    <option value="comprehensive">Comprehensive Validation</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="validateSyntax" name="validate" value="syntax" checked>
                                        <label for="validateSyntax">Syntax Validation</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="validateSecurity" name="validate" value="security" checked>
                                        <label for="validateSecurity">Security Best Practices</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="validateCompatibility" name="validate" value="compatibility" checked>
                                        <label for="validateCompatibility">Platform Compatibility</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="validatePerformance" name="validate" value="performance">
                                        <label for="validatePerformance">Performance Impact Analysis</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="validateConfigBtn" class="btn-primary"><i class="fas fa-check-circle"></i> Validate Configuration</button>
                                <button id="exportValidationBtn" class="btn-secondary"><i class="fas fa-file-export"></i> Export Validation Report</button>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="gen-deployment">
                            <div class="form-group">
                                <label for="deploymentMethod">Deployment Method:</label>
                                <select id="deploymentMethod" class="form-control">
                                    <option value="manual">Manual Configuration</option>
                                    <option value="ssh">SSH/CLI</option>
                                    <option value="restconf">RESTCONF/NETCONF</option>
                                    <option value="ansible">Ansible</option>
                                    <option value="custom">Custom Script</option>
                                </select>
                            </div>
                            
                            <div class="deployment-details" id="sshDetails">
                                <h3>SSH Deployment Details</h3>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="sshHost">Host:</label>
                                        <input type="text" id="sshHost" class="form-control" placeholder="e.g., 192.168.1.1">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="sshPort">Port:</label>
                                        <input type="number" id="sshPort" class="form-control" value="22">
                                    </div>
                                </div>
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="sshUsername">Username:</label>
                                        <input type="text" id="sshUsername" class="form-control" placeholder="Enter username">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="sshPassword">Password:</label>
                                        <div class="password-field">
                                            <input type="password" id="sshPassword" class="form-control" placeholder="Enter password">
                                            <span class="password-toggle"><i class="fas fa-eye"></i></span>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="sshBackup" name="sshOption" value="backup" checked>
                                        <label for="sshBackup">Backup Configuration Before Deployment</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="deploymentSchedule">Deployment Schedule:</label>
                                <select id="deploymentSchedule" class="form-control">
                                    <option value="immediate">Immediate Deployment</option>
                                    <option value="scheduled">Scheduled Deployment</option>
                                    <option value="maintenance">Next Maintenance Window</option>
                                </select>
                            </div>
                            
                            <div class="form-group" id="scheduledDeployment" style="display: none;">
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="deploymentDate">Date:</label>
                                        <input type="date" id="deploymentDate" class="form-control">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="deploymentTime">Time:</label>
                                        <input type="time" id="deploymentTime" class="form-control">
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="rollbackStrategy">Rollback Strategy:</label>
                                <select id="rollbackStrategy" class="form-control">
                                    <option value="automatic">Automatic Rollback on Error</option>
                                    <option value="manual">Manual Rollback Only</option>
                                    <option value="timed">Rollback After Timeout</option>
                                </select>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="deployConfigBtn" class="btn-primary"><i class="fas fa-upload"></i> Deploy Configuration</button>
                                <button id="testDeploymentBtn" class="btn-secondary"><i class="fas fa-vial"></i> Test Deployment</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-next">Next</button>
                    </div>
                </section>

                <!-- AI Analysis Section -->
                <section id="ai-analysis" class="config-section">
                    <h2><i class="fas fa-brain"></i> AI Analysis</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="ai-optimizer">Optimizer</div>
                            <div class="tab" data-tab="ai-security">Security Analysis</div>
                            <div class="tab" data-tab="ai-recommend">Recommendations</div>
                        </div>
                        
                        <div class="tab-content active" id="ai-optimizer">
                            <div class="ai-status-container">
                                <div class="ai-status">
                                    <div class="ai-status-indicator">
                                        <i class="fas fa-check-circle"></i>
                                    </div>
                                    <div class="ai-status-message">
                                        <h3>AI Optimizer Ready</h3>
                                        <p>Click "Analyze Configuration" to optimize your configuration for best practices, performance, and security.</p>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="optimizationGoals">Optimization Goals:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="optSecurity" name="optimization" value="security" checked>
                                        <label for="optSecurity">Maximize Security</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="optPerformance" name="optimization" value="performance" checked>
                                        <label for="optPerformance">Improve Performance</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="optManageability" name="optimization" value="manageability" checked>
                                        <label for="optManageability">Enhance Manageability</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="optRedundancy" name="optimization" value="redundancy" checked>
                                        <label for="optRedundancy">Improve Redundancy</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="optCompliance" name="optimization" value="compliance">
                                        <label for="optCompliance">Compliance Requirements</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="optimizationLevel">Optimization Level:</label>
                                <select id="optimizationLevel" class="form-control">
                                    <option value="conservative">Conservative (Minimal Changes)</option>
                                    <option value="moderate" selected>Moderate (Recommended Changes)</option>
                                    <option value="aggressive">Aggressive (Maximum Optimization)</option>
                                </select>
                            </div>
                            
                            <div class="optimization-results hidden">
                                <h3>Optimization Results</h3>
                                <div id="optimizationResultsContent"></div>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="startOptimizationBtn" class="btn-primary"><i class="fas fa-magic"></i> Optimize Configuration</button>
                                <button id="previewChangesBtn" class="btn-secondary"><i class="fas fa-eye"></i> Preview Changes</button>
                                <button id="applyOptimizationsBtn" class="btn-secondary"><i class="fas fa-check"></i> Apply Optimizations</button>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="ai-security">
                            <div class="security-score-container">
                                <div class="security-score-card">
                                    <div class="security-score-circle">
                                        <div id="securityScoreValue" class="score-value">--</div>
                                        <div class="score-label">Security Score</div>
                                    </div>
                                    <div class="security-score-details">
                                        <div class="security-score-item">
                                            <div class="security-score-item-label">Authentication</div>
                                            <div class="security-score-item-value" id="authScore">--</div>
                                        </div>
                                        <div class="security-score-item">
                                            <div class="security-score-item-label">Authorization</div>
                                            <div class="security-score-item-value" id="authzScore">--</div>
                                        </div>
                                        <div class="security-score-item">
                                            <div class="security-score-item-label">Infrastructure</div>
                                            <div class="security-score-item-value" id="infraScore">--</div>
                                        </div>
                                        <div class="security-score-item">
                                            <div class="security-score-item-label">Resilience</div>
                                            <div class="security-score-item-value" id="resilScore">--</div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="security-analysis hidden">
                                <h3>Security Analysis</h3>
                                <div id="securityAnalysisContent">
                                    <div class="security-category">
                                        <h4>Critical Issues</h4>
                                        <div class="security-issues" id="criticalIssues">
                                            <p>No critical issues found.</p>
                                        </div>
                                    </div>
                                    <div class="security-category">
                                        <h4>High Impact Issues</h4>
                                        <div class="security-issues" id="highIssues">
                                            <p>No high impact issues found.</p>
                                        </div>
                                    </div>
                                    <div class="security-category">
                                        <h4>Medium Impact Issues</h4>
                                        <div class="security-issues" id="mediumIssues">
                                            <p>No medium impact issues found.</p>
                                        </div>
                                    </div>
                                    <div class="security-category">
                                        <h4>Low Impact Issues</h4>
                                        <div class="security-issues" id="lowIssues">
                                            <p>No low impact issues found.</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="securityAnalysisBtn" class="btn-primary"><i class="fas fa-shield-alt"></i> Analyze Security</button>
                                <button id="exportSecurityReportBtn" class="btn-secondary"><i class="fas fa-file-export"></i> Export Security Report</button>
                                <button id="fixSecurityIssuesBtn" class="btn-secondary"><i class="fas fa-wrench"></i> Fix Security Issues</button>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="ai-recommend">
                            <div class="recommendations-container">
                                <div class="ai-recommendation-status">
                                    <p>AI recommendations are based on your configuration, industry best practices, and lessons learned from similar deployments. Click "Generate Recommendations" to get personalized advice for your deployment.</p>
                                </div>
                                
                                <div class="recommendations-content hidden" id="recommendationsContent">
                                    <div class="recommendation-category">
                                        <h3>Authentication Recommendations</h3>
                                        <div id="authRecommendations"></div>
                                    </div>
                                    <div class="recommendation-category">
                                        <h3>Security Recommendations</h3>
                                        <div id="securityRecommendations"></div>
                                    </div>
                                    <div class="recommendation-category">
                                        <h3>Infrastructure Recommendations</h3>
                                        <div id="infraRecommendations"></div>
                                    </div>
                                    <div class="recommendation-category">
                                        <h3>Operations Recommendations</h3>
                                        <div id="opsRecommendations"></div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="generateRecommendationsBtn" class="btn-primary"><i class="fas fa-lightbulb"></i> Generate Recommendations</button>
                                <button id="exportRecommendationsBtn" class="btn-secondary"><i class="fas fa-file-export"></i> Export Recommendations</button>
                                <button id="applyRecommendationsBtn" class="btn-secondary"><i class="fas fa-check"></i> Apply Recommendations</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-next">Next</button>
                    </div>
                </section>

                <!-- Documentation Section -->
                <section id="documentation" class="config-section">
                    <h2><i class="fas fa-file-alt"></i> Documentation</h2>
                    
                    <div class="tabs-container">
                        <div class="tabs">
                            <div class="tab active" data-tab="doc-project">Project Documentation</div>
                            <div class="tab" data-tab="doc-diagrams">Network Diagrams</div>
                            <div class="tab" data-tab="doc-checklist">Deployment Checklist</div>
                            <div class="tab" data-tab="doc-troubleshooting">Troubleshooting Guide</div>
                        </div>
                        
                        <div class="tab-content active" id="doc-project">
                            <div class="form-group">
                                <label for="projectTitle">Project Title:</label>
                                <input type="text" id="projectTitle" class="form-control" placeholder="Enter project title">
                            </div>
                            
                            <div class="form-group">
                                <label for="projectDescription">Project Description:</label>
                                <textarea id="projectDescription" class="form-control" rows="4" placeholder="Enter project description"></textarea>
                            </div>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="projectOrganization">Organization:</label>
                                    <input type="text" id="projectOrganization" class="form-control" placeholder="Enter organization name">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="projectOwner">Project Owner:</label>
                                    <input type="text" id="projectOwner" class="form-control" placeholder="Enter project owner name">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="docExportFormat">Export Format:</label>
                                <select id="docExportFormat" class="form-control">
                                    <option value="html">HTML</option>
                                    <option value="pdf">PDF</option>
                                    <option value="word">Word Document</option>
                                    <option value="ppt">PowerPoint</option>
                                    <option value="markdown">Markdown</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label>Include in Documentation:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeConfigs" name="docInclude" value="configs" checked>
                                        <label for="includeConfigs">Configurations</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeDiagrams" name="docInclude" value="diagrams" checked>
                                        <label for="includeDiagrams">Network Diagrams</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeChecklist" name="docInclude" value="checklist" checked>
                                        <label for="includeChecklist">Deployment Checklist</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeBestPractices" name="docInclude" value="bestPractices" checked>
                                        <label for="includeBestPractices">Best Practices</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeTroubleshooting" name="docInclude" value="troubleshooting" checked>
                                        <label for="includeTroubleshooting">Troubleshooting Guide</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeCompliance" name="docInclude" value="compliance">
                                        <label for="includeCompliance">Compliance Information</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeScreenshots" name="docInclude" value="screenshots">
                                        <label for="includeScreenshots">Screenshots</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="generateDocBtn" class="btn-primary"><i class="fas fa-file-alt"></i> Generate Documentation</button>
                                <button id="downloadDocBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
                                <button id="previewDocBtn" class="btn-secondary"><i class="fas fa-eye"></i> Preview</button>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="doc-diagrams">
                            <div class="form-group">
                                <label for="diagramType">Diagram Type:</label>
                                <select id="diagramType" class="form-control">
                                    <option value="logical">Logical Network Diagram</option>
                                    <option value="physical">Physical Network Diagram</option>
                                    <option value="authentication">Authentication Flow Diagram</option>
                                    <option value="all">All Diagrams</option>
                                </select>
                            </div>
                            
                            <div class="diagram-preview">
                                <h3>Diagram Preview</h3>
                                <div id="diagramPreview" class="diagram-canvas">
                                    <div class="placeholder-text">Select a diagram type and click "Generate Diagram" to preview</div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="diagramExportFormat">Export Format:</label>
                                <select id="diagramExportFormat" class="form-control">
                                    <option value="png">PNG Image</option>
                                    <option value="svg">SVG Vector Image</option>
                                    <option value="pdf">PDF Document</option>
                                    <option value="visio">Visio Document</option>
                                </select>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="generateDiagramBtn" class="btn-primary"><i class="fas fa-project-diagram"></i> Generate Diagram</button>
                                <button id="downloadDiagramBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
                                <button id="editDiagramBtn" class="btn-secondary"><i class="fas fa-edit"></i> Edit Diagram</button>
                            </div>
                        </div>
                        
                        <div class="tab-content" id="doc-checklist">
                            <div class="form-group">
                                <label for="checklistType">Checklist Type:</label>
                                <select id="checklistType" class="form-control">
                                    <option value="deployment">Deployment Checklist</option>
                                    <option value="testing">Testing Checklist</option>
                                    <option value="validation">Validation Checklist</option>
                                    <option value="all">Complete Checklist</option>
                                </select>
                            </div>
                            
                            <div id="checklistPreview" class="checklist-preview">
                                <div class="placeholder-text">Select a checklist type and click "Generate Checklist" to preview</div>
                            </div>
                            
                            <div class="form-group">
                                <label for="checklistExportFormat">Export Format:</label>
                                <select id="checklistExportFormat" class="form-control">
                                    <option value="pdf">PDF Document</option>
                                    <option value="excel">Excel Spreadsheet</option>
                                    <option value="word">Word Document</option>
                                    <option value="html">HTML</option>
                                </select>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="generateChecklistBtn" class="btn-primary"><i class="fas fa-tasks"></i> Generate Checklist</button>
                                <button id="downloadChecklistBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
                                <button id="customizeChecklistBtn" class="btn-secondary"><i class="fas fa-edit"></i> Customize Checklist</button>
                            </div>
                        </div>

                        <div class="tab-content" id="doc-troubleshooting">
                            <div class="form-group">
                                <label for="troubleshootingType">Troubleshooting Guide Type:</label>
                                <select id="troubleshootingType" class="form-control">
                                    <option value="basic">Basic Guide</option>
                                    <option value="advanced">Advanced Guide</option>
                                    <option value="comprehensive" selected>Comprehensive Guide</option>
                                    <option value="custom">Custom Guide</option>
                                </select>
                            </div>
                            
                            <div id="troubleshootingPreview" class="troubleshooting-preview">
                                <div class="placeholder-text">Select a guide type and click "Generate Guide" to preview</div>
                            </div>
                            
                            <div class="form-group">
                                <label>Include in Troubleshooting Guide:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tsCommonIssues" name="tsInclude" value="common" checked>
                                        <label for="tsCommonIssues">Common Issues</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tsCommands" name="tsInclude" value="commands" checked>
                                        <label for="tsCommands">Diagnostic Commands</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tsLogs" name="tsInclude" value="logs" checked>
                                        <label for="tsLogs">Log Analysis</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tsDecisionTree" name="tsInclude" value="decision" checked>
                                        <label for="tsDecisionTree">Decision Trees</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tsPacketCapture" name="tsInclude" value="packet">
                                        <label for="tsPacketCapture">Packet Capture Analysis</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tsRadiusTesting" name="tsInclude" value="radius" checked>
                                        <label for="tsRadiusTesting">RADIUS Testing</label>
                                    </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="troubleshootingExportFormat">Export Format:</label>
                                <select id="troubleshootingExportFormat" class="form-control">
                                    <option value="pdf">PDF Document</option>
                                    <option value="html">HTML</option>
                                    <option value="word">Word Document</option>
                                    <option value="markdown">Markdown</option>
                                </select>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="generateTroubleshootingBtn" class="btn-primary"><i class="fas fa-wrench"></i> Generate Guide</button>
                                <button id="downloadTroubleshootingBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
                                <button id="customizeTroubleshootingBtn" class="btn-secondary"><i class="fas fa-edit"></i> Customize Guide</button>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back">Back</button>
                        <button class="btn-primary btn-finish">Finish</button>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <!-- Modal for AI Assistant -->
    <div id="aiAssistantModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-robot"></i> AI Assistant</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="chat-container">
                    <div id="chatMessages" class="chat-messages">
                        <div class="ai-message">
                            <div class="message-avatar"><i class="fas fa-robot"></i></div>
                            <div class="message-content">
                                <p>Hello! I'm your UaXSupreme AI Assistant. I can help you with:</p>
                                <ul>
                                    <li>Configuration recommendations</li>
                                    <li>Troubleshooting suggestions</li>
                                    <li>Best practices</li>
                                    <li>Vendor-specific information</li>
                                    <li>Detailed feature explanations</li>
                                    <li>Complex deployment scenarios</li>
                                </ul>
                                <p>How can I assist you today?</p>
                            </div>
                        </div>
                    </div>
                    <div class="chat-input">
                        <input type="text" id="userMessage" placeholder="Type your question here...">
                        <button id="sendMessageBtn"><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
                <div class="ai-suggestions">
                    <div class="suggestion-title">Suggested Questions:</div>
                    <div class="suggestion-buttons">
                        <button class="suggestion-btn">What's the difference between Closed and Monitor mode?</button>
                        <button class="suggestion-btn">How do I troubleshoot 802.1X authentication failures?</button>
                        <button class="suggestion-btn">What are the best practices for RADIUS server redundancy?</button>
                        <button class="suggestion-btn">How do I configure MAB for printers?</button>
                        <button class="suggestion-btn">How does IBNS 2.0 differ from traditional 802.1X?</button>
                        <button class="suggestion-btn">What is RadSec and when should I use it?</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for Help -->
    <div id="helpModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-question-circle"></i> UaXSupreme Help</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="help-navigation">
                    <div class="help-search">
                        <input type="text" id="helpSearch" placeholder="Search help topics...">
                    </div>
                    <ul class="help-topics">
                        <li class="active" data-topic="overview">Overview</li>
                        <li data-topic="vendorSelection">Vendor Selection</li>
                        <li data-topic="authentication">Authentication Methods</li>
                        <li data-topic="radius">RADIUS Configuration</li>
                        <li data-topic="tacacs">TACACS+ Configuration</li>
                        <li data-topic="advanced">Advanced Features</li>
                        <li data-topic="interfaces">Interface Configuration</li>
                        <li data-topic="generation">Configuration Generation</li>
                        <li data-topic="aiAnalysis">AI Analysis</li>
                        <li data-topic="documentation">Documentation</li>
                        <li data-topic="troubleshooting">Troubleshooting</li>
                    </ul>
                </div>
                <div class="help-content">
                    <div id="helpContentArea">
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
                            <li>Run AI analysis to optimize your configuration.</li>
                            <li>Generate documentation for your implementation.</li>
                        </ol>
                        
                        <p>For additional assistance, use the AI Assistant by clicking the robot icon in the top navigation bar.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for Settings -->
    <div id="settingsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2><i class="fas fa-cog"></i> Settings</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="settings-section">
                    <h3>General Settings</h3>
                    <div class="form-group">
                        <label for="appTheme">Application Theme:</label>
                        <select id="appTheme" class="form-control">
                            <option value="light">Light</option>
                            <option value="dark">Dark</option>
                            <option value="system">System Default</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="codeFont">Code Font:</label>
                        <select id="codeFont" class="form-control">
                            <option value="monospace">Monospace</option>
                            <option value="consolas">Consolas</option>
                            <option value="courier">Courier New</option>
                            <option value="firacode">Fira Code</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="tabSize">Tab Size:</label>
                        <select id="tabSize" class="form-control">
                            <option value="2">2 spaces</option>
                            <option value="4">4 spaces</option>
                            <option value="8">8 spaces</option>
                        </select>
                    </div>
                </div>
                <div class="settings-section">
                    <h3>AI Features</h3>
                    <div class="form-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="enableAI" name="aiFeature" value="enable" checked>
                            <label for="enableAI">Enable AI Features</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="aiModel">AI Model:</label>
                        <select id="aiModel" class="form-control">
                            <option value="standard">Standard</option>
                            <option value="advanced">Advanced</option>
                            <option value="expert">Expert</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="aiResponseStyle">AI Response Style:</label>
                        <select id="aiResponseStyle" class="form-control">
                            <option value="concise">Concise</option>
                            <option value="detailed">Detailed</option>
                            <option value="technical">Technical</option>
                        </select>
                    </div>
                </div>
                <div class="settings-section">
                    <h3>Application Behavior</h3>
                    <div class="form-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="autoSave" name="appBehavior" value="autosave" checked>
                            <label for="autoSave">Auto-save Progress</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="autoSaveInterval">Auto-save Interval (minutes):</label>
                        <input type="number" id="autoSaveInterval" class="form-control" value="5" min="1" max="60">
                    </div>
                    <div class="form-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="showAdvanced" name="appBehavior" value="advanced" checked>
                            <label for="showAdvanced">Show Advanced Options</label>
                        </div>
                    </div>
                </div>
                <div class="action-buttons">
                    <button id="saveSettingsBtn" class="btn-primary"><i class="fas fa-save"></i> Save Settings</button>
                    <button id="resetSettingsBtn" class="btn-secondary"><i class="fas fa-undo"></i> Reset to Default</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/app.js"></script>
    <script src="js/template-generator.js"></script>
    <script src="js/validation.js"></script>
    <script src="js/ai-assistant.js"></script>
    <script src="js/ai-analyzer.js"></script>
    <script src="js/diagram-generator.js"></script>
    <script src="js/documentation.js"></script>
    <script src="js/logo-generator.js"></script>
</body>
</html>
/* UaXSupreme Enhanced Styles */
:root {
    --primary-color: #3498db;
    --primary-dark: #2980b9;
    --secondary-color: #2c3e50;
    --success-color: #2ecc71;
    --warning-color: #f39c12;
    --danger-color: #e74c3c;
    --light-color: #ecf0f1;
    --dark-color: #34495e;
    --gray-color: #95a5a6;
    --border-color: #ddd;
    --sidebar-width: 250px;
    --header-height: 70px;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    color: #333;
    background-color: #f5f7fa;
}

/* App Container */
.app-container {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

/* Header */
header {
    background-color: var(--secondary-color);
    color: white;
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: var(--header-height);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo {
    display: flex;
    flex-direction: column;
    position: relative;
}

.logo h1 {
    font-size: 24px;
    margin: 0;
}

.logo span {
    font-size: 14px;
    opacity: 0.8;
}

.logo-animation {
    position: absolute;
    top: 0;
    right: -60px;
    width: 50px;
    height: 50px;
}

.header-controls {
    display: flex;
    gap: 10px;
}

.btn-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.1);
    border: none;
    color: white;
    font-size: 18px;
    cursor: pointer;
    transition: background-color 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-icon:hover {
    background-color: rgba(255, 255, 255, 0.2);
}

/* Main Content */
.main-content {
    display: flex;
    flex: 1;
}

/* Sidebar */
.sidebar {
    width: var(--sidebar-width);
    background-color: var(--dark-color);
    color: white;
    display: flex;
    flex-direction: column;
}

.sidebar-header {
    padding: 15px;
    font-weight: bold;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    background-color: var(--secondary-color);
}

.nav-steps {
    list-style: none;
    flex: 1;
    overflow-y: auto;
}

.nav-steps li {
    padding: 12px 15px;
    cursor: pointer;
    border-left: 3px solid transparent;
    transition: all 0.3s;
    display: flex;
    align-items: center;
}

.nav-steps li i {
    margin-right: 10px;
    width: 20px;
    text-align: center;
}

.nav-steps li.active {
    background-color: rgba(255, 255, 255, 0.1);
    border-left-color: var(--primary-color);
}

.nav-steps li:hover {
    background-color: rgba(255, 255, 255, 0.05);
}

.sidebar-footer {
    padding: 15px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* Content Area */
.content-area {
    flex: 1;
    padding: 20px;
    overflow-y: auto;
    overflow-x: hidden;
}

/* Config Sections */
.config-section {
    display: none;
    animation: fadeIn 0.3s;
}

.config-section.active {
    display: block;
}

.config-section h2 {
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
    color: var(--secondary-color);
}

.section-content {
    margin-bottom: 30px;
}

.section-footer {
    display: flex;
    justify-content: space-between;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid var(--border-color);
}

/* Forms */
.form-group {
    margin-bottom: 20px;
}

.form-row {
    display: flex;
    margin: 0 -10px;
}

.form-row .form-group {
    padding: 0 10px;
    flex: 1;
}

.col-md-6 {
    width: 50%;
}

.col-md-4 {
    width: 33.333333%;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: 500;
}

.form-control {
    width: 100%;
    padding: 10px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    font-size: 14px;
}

select.form-control {
    height: 40px;
    background-color: white;
}

textarea.form-control {
    min-height: 100px;
}

.form-text {
    font-size: 12px;
    color: var(--gray-color);
    margin-top: 5px;
}

/* Password Field */
.password-field {
    position: relative;
}

.password-toggle {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    color: var(--gray-color);
}

/* Checkbox and Radio Groups */
.checkbox-group, .radio-group {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
}

.checkbox-item, .radio-item {
    display: flex;
    align-items: center;
    min-width: 200px;
}

.checkbox-item input, .radio-item input {
    margin-right: 8px;
}

/* Buttons */
.btn-primary, .btn-secondary {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 500;
    transition: background-color 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.btn-primary {
    background-color: var(--primary-color);
    color: white;
}

.btn-primary:hover {
    background-color: var(--primary-dark);
}

.btn-secondary {
    background-color: var(--light-color);
    color: var(--secondary-color);
}

.btn-secondary:hover {
    background-color: #dde4e6;
}

.btn-next i, .btn-back i {
    font-size: 12px;
}

/* Tabs */
.tabs-container {
    margin-bottom: 30px;
}

.tabs {
    display: flex;
    border-bottom: 1px solid var(--border-color);
    margin-bottom: 20px;
    flex-wrap: wrap;
}

.tab {
    padding: 10px 20px;
    cursor: pointer;
    border-bottom: 2px solid transparent;
    transition: all 0.3s;
}

.tab.active {
    border-bottom-color: var(--primary-color);
    color: var(--primary-color);
    font-weight: 500;
}

.tab:hover:not(.active) {
    border-bottom-color: var(--gray-color);
}

.tab-content {
    display: none;
    animation: fadeIn 0.3s;
}

.tab-content.active {
    display: block;
}

/* Server Containers */
.server-container {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 20px;
}

.server-container h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Feature Info */
.feature-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.method-info-panel {
    display: none;
}

.method-info-panel.active {
    display: block;
    animation: fadeIn 0.3s;
}

.feature-info h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

.feature-info h4 {
    color: var(--primary-color);
    margin-bottom: 10px;
    font-size: 15px;
}

/* Feature Settings */
.feature-settings {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 15px;
    margin-bottom: 20px;
}

.feature-settings h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Security Features Info */
.security-features-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.security-feature-detail {
    margin-bottom: 20px;
}

.security-feature-detail:last-child {
    margin-bottom: 0;
}

.security-feature-detail h4 {
    color: var(--primary-color);
    margin-bottom: 10px;
    font-size: 15px;
}

/* Code Output */
.code-output {
    font-family: 'Courier New', Courier, monospace;
    background-color: #2c3e50;
    color: #ecf0f1;
    border: none;
    border-radius: 4px;
    padding: 15px;
    font-size: 14px;
    line-height: 1.5;
}

/* Action Buttons */
.action-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 15px;
}

/* Hidden Elements */
.hidden {
    display: none;
}

/* Animations */
@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

/* Template Buttons */
.template-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 10px;
}

/* Diagram Canvas */
.diagram-canvas {
    width: 100%;
    height: 400px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    background-color: white;
    margin-top: 15px;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.placeholder-text {
    color: var(--gray-color);
    text-align: center;
    padding: 20px;
}

/* Checklist Preview */
.checklist-preview, .troubleshooting-preview {
    background-color: white;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 15px;
    margin-bottom: 15px;
    min-height: 300px;
}

.checklist-item {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
    padding: 10px;
    border-radius: 4px;
    background-color: #f9f9f9;
}

.checklist-item input {
    margin-right: 10px;
}

/* Platform Info */
.platform-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.platform-info h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Deployment Info */
.deployment-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.deployment-info h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Config Validation */
.config-validation {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.config-validation h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Modal */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.5);
    animation: fadeIn 0.3s;
}

.modal-content {
    background-color: white;
    margin: 5% auto;
    border-radius: 8px;
    width: 80%;
    max-width: 1000px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    animation: slideDown 0.3s;
}

.modal-header {
    background-color: var(--secondary-color);
    color: white;
    padding: 15px 20px;
    border-radius: 8px 8px 0 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-header h2 {
    margin: 0;
    font-size: 20px;
    border-bottom: none;
}

.close {
    color: white;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.modal-body {
    padding: 20px;
    max-height: 70vh;
    overflow-y: auto;
}

@keyframes slideDown {
    from {
        transform: translateY(-50px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

/* AI Assistant Modal */
.chat-container {
    display: flex;
    flex-direction: column;
    height: 400px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    background-color: #f9f9f9;
}

.chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 15px;
}

.ai-message, .user-message {
    margin-bottom: 15px;
    display: flex;
}

.ai-message {
    align-items: flex-start;
}

.user-message {
    align-items: flex-start;
    flex-direction: row-reverse;
}

.message-avatar {
    background-color: var(--primary-color);
    color: white;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 10px;
}

.user-message .message-avatar {
    background-color: var(--secondary-color);
    margin-right: 0;
    margin-left: 10px;
}

.message-content {
    background-color: white;
    padding: 10px 15px;
    border-radius: 8px;
    max-width: 80%;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.user-message .message-content {
    background-color: var(--primary-color);
    color: white;
}

.message-content p {
    margin: 0 0 10px 0;
}

.message-content p:last-child {
    margin-bottom: 0;
}

.message-content ul {
    margin-left: 20px;
}

.chat-input {
    display: flex;
    padding: 10px;
    border-top: 1px solid var(--border-color);
}

.chat-input input {
    flex: 1;
    padding: 10px;
    border: 1px solid var(--border-color);
    border-radius: 4px 0 0 4px;
    font-size: 14px;
}

.chat-input button {
    width: 40px;
    background-color: var(--primary-color);
    color: white;
    border: none;
    border-radius: 0 4px 4px 0;
    cursor: pointer;
}

.ai-suggestions {
    margin-top: 20px;
}

.suggestion-title {
    font-weight: 500;
    margin-bottom: 10px;
}

.suggestion-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
}

.suggestion-btn {
    background-color: #f1f1f1;
    border: 1px solid var(--border-color);
    border-radius: 20px;
    padding: 8px 15px;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.3s;
}

.suggestion-btn:hover {
    background-color: #e1e1e1;
}

/* Help Modal */
.help-navigation {
    width: 250px;
    float: left;
    border-right: 1px solid var(--border-color);
    height: 500px;
}

.help-search {
    padding: 10px;
    border-bottom: 1px solid var(--border-color);
}

.help-search input {
    width: 100%;
    padding: 8px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    font-size: 14px;
}

.help-topics {
    list-style: none;
    margin-top: 10px;
    overflow-y: auto;
    max-height: calc(500px - 50px);
}

.help-topics li {
    padding: 10px 15px;
    cursor: pointer;
    border-left: 3px solid transparent;
    transition: all 0.3s;
}

.help-topics li.active {
    background-color: rgba(52, 152, 219, 0.1);
    border-left-color: var(--primary-color);
    color: var(--primary-color);
}

.help-topics li:hover:not(.active) {
    background-color: rgba(0, 0, 0, 0.05);
}

.help-content {
    margin-left: 260px;
    padding: 15px;
    height: 500px;
    overflow-y: auto;
}

#helpContentArea h3 {
    margin-bottom: 15px;
    color: var(--secondary-color);
}

#helpContentArea h4 {
    margin: 20px 0 10px;
    color: var(--dark-color);
}

#helpContentArea p {
    margin-bottom: 15px;
    line-height: 1.6;
}

#helpContentArea ul, #helpContentArea ol {
    margin-left: 20px;
    margin-bottom: 15px;
}

#helpContentArea li {
    margin-bottom: 8px;
}

/* Settings Modal */
.settings-section {
    margin-bottom: 25px;
    border-bottom: 1px solid var(--border-color);
    padding-bottom: 15px;
}

.settings-section:last-child {
    border-bottom: none;
}

.settings-section h3 {
    margin-bottom: 15px;
    color: var(--secondary-color);
    font-size: 16px;
}

/* Custom Attributes Table */
.custom-attributes-container {
    margin-top: 15px;
    overflow-x: auto;
}

.custom-attributes-table {
    width: 100%;
    border-collapse: collapse;
}

.custom-attributes-table th,
.custom-attributes-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.custom-attributes-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

/* Fallback Priority */
.fallback-priority-container {
    margin-top: 10px;
}

.fallback-priority-list {
    list-style: none;
    border: 1px solid var(--border-color);
    border-radius: 4px;
}

.fallback-item {
    display: flex;
    align-items: center;
    padding: 10px;
    border-bottom: 1px solid var(--border-color);
    background-color: white;
    cursor: move;
}

.fallback-item:last-child {
    border-bottom: none;
}

.fallback-handle {
    margin-right: 10px;
    color: var(--gray-color);
    cursor: grab;
}

/* SGT and IoT Device Tables */
.sgt-table-container,
.iot-device-table-container {
    margin-top: 15px;
    overflow-x: auto;
}

.sgt-table,
.iot-device-table {
    width: 100%;
    border-collapse: collapse;
}

.sgt-table th, .sgt-table td,
.iot-device-table th, .iot-device-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.sgt-table th,
.iot-device-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

/* Command Privilege Table */
.command-privilege-container {
    margin-top: 15px;
    margin-bottom: 15px;
}

.command-privilege-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 10px;
}

.command-privilege-table th,
.command-privilege-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.command-privilege-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

.command-privilege-table code {
    background-color: #f0f0f0;
    padding: 2px 5px;
    border-radius: 3px;
    font-family: monospace;
}

/* Template List */
.template-list-container {
    margin-top: 15px;
    overflow-x: auto;
}

.template-list-table {
    width: 100%;
    border-collapse: collapse;
}

.template-list-table th,
.template-list-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.template-list-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

.template-action {
    background: none;
    border: none;
    cursor: pointer;
    color: var(--primary-color);
    font-size: 14px;
    margin-right: 5px;
}

/* Deployment Details */
.deployment-details {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 15px;
    margin-bottom: 20px;
}

.deployment-details h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* AI Status */
.ai-status-container {
    margin-bottom: 20px;
}

.ai-status {
    display: flex;
    align-items: center;
    background-color: #f0f7ff;
    border: 1px solid #c5d9f1;
    border-radius: 4px;
    padding: 15px;
}

.ai-status-indicator {
    color: var(--success-color);
    font-size: 24px;
    margin-right: 15px;
}

.ai-status-message h3 {
    margin: 0 0 5px 0;
    color: var(--secondary-color);
    font-size: 16px;
}

.ai-status-message p {
    margin: 0;
    color: #555;
}

/* Security Score Card */
.security-score-container {
    margin-bottom: 20px;
}

.security-score-card {
    display: flex;
    background-color: white;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 20px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.security-score-circle {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background-color: #f5f7fa;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-right: 30px;
    border: 5px solid var(--success-color);
}

.score-value {
    font-size: 36px;
    font-weight: bold;
    color: var(--secondary-color);
}

.score-label {
    font-size: 14px;
    color: var(--gray-color);
}

.security-score-details {
    flex: 1;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
}

.security-score-item {
    background-color: #f5f7fa;
    border-radius: 4px;
    padding: 10px;
}

.security-score-item-label {
    font-size: 14px;
    color: var(--gray-color);
    margin-bottom: 5px;
}

.security-score-item-value {
    font-size: 24px;
    font-weight: bold;
    color: var(--secondary-color);
}

/* Security Analysis */
.security-category {
    margin-bottom: 20px;
}

.security-category h4 {
    margin-bottom: 10px;
    color: var(--secondary-color);
    font-size: 16px;
}

.security-issues {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
}

/* Recommendations */
.ai-recommendation-status {
    background-color: #f0f7ff;
    border: 1px solid #c5d9f1;
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 20px;
}

.recommendation-category {
    margin-bottom: 20px;
}

.recommendation-category h3 {
    margin-bottom: 10px;
    color: var(--secondary-color);
    font-size: 16px;
}

/* Optimization Results */
.optimization-results {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
    margin-bottom: 20px;
}

.optimization-results h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Responsive Styles */
@media (max-width: 992px) {
    .sidebar {
        width: 200px;
    }

    .modal-content {
        width: 95%;
    }

    .help-navigation {
        width: 200px;
    }

    .help-content {
        margin-left: 210px;
    }

    .security-score-card {
        flex-direction: column;
        align-items: center;
    }

    .security-score-circle {
        margin-right: 0;
        margin-bottom: 20px;
    }

    .security-score-details {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
    }

    .form-row .form-group {
        width: 100%;
    }

    .col-md-6, .col-md-4 {
        width: 100%;
    }

    .tabs {
        flex-direction: column;
    }

    .tab {
        border-left: 2px solid transparent;
        border-bottom: none;
    }

    .tab.active {
        border-left-color: var(--primary-color);
        border-bottom-color: transparent;
    }

    .help-navigation {
        float: none;
        width: 100%;
        height: auto;
        border-right: none;
        border-bottom: 1px solid var(--border-color);
        margin-bottom: 15px;
    }

    .help-content {
        margin-left: 0;
    }

    .action-buttons {
        flex-direction: column;
    }
}

@media (max-width: 576px) {
    .sidebar {
        display: none;
    }

    .header-controls {
        gap: 5px;
    }

    .btn-icon {
        width: 35px;
        height: 35px;
        font-size: 16px;
    }

    .section-footer {
        flex-direction: column;
        gap: 10px;
    }
}
/**
 * UaXSupreme - Enhanced AI Analyzer and Optimizer
 * Advanced analysis and optimization for network authentication configurations
 */

(function() {
    'use strict';

    // AI Analyzer object with enhanced capabilities
    const AIAnalyzer = {
        /**
         * Initialize AI Analyzer
         */
        init: function() {
            console.log('Initializing Enhanced AI Analyzer...');

            // Load the AI models
            this.loadAIModels();

            // Set up event listeners
            this.setupEventListeners();
        },

        /**
         * Load AI models for analysis
         */
        loadAIModels: function() {
            // In a production environment, this would dynamically load
            // machine learning models for configuration analysis
            console.log('Loading AI models for configuration analysis...');

            // Set up model properties
            this.models = {
                configAnalyzer: {
                    loaded: true,
                    version: '2.1.0',
                    capabilities: ['syntax', 'security', 'performance', 'compliance']
                },
                patternRecognition: {
                    loaded: true,
                    version: '1.5.2',
                    capabilities: ['template', 'anomaly', 'recommendation']
                },
                securityEvaluator: {
                    loaded: true,
                    version: '3.0.1',
                    capabilities: ['risk', 'vulnerability', 'mitigation']
                }
            };

            // Set up knowledge base for vendor-specific rules
            this.knowledgeBase = {
                cisco: this.loadVendorRules('cisco'),
                aruba: this.loadVendorRules('aruba'),
                juniper: this.loadVendorRules('juniper'),
                fortinet: this.loadVendorRules('fortinet'),
                extreme: this.loadVendorRules('extreme'),
                dell: this.loadVendorRules('dell')
            };
        },

        /**
         * Load vendor-specific rules for analysis
         * @param {string} vendor - Vendor name
         * @returns {Object} Vendor rules
         */
        loadVendorRules: function(vendor) {
            console.log(`Loading rules for ${vendor}...`);

            // In a production environment, this would load from a database or file
            const commonRules = {
                security: {
                    criticalAuthEnabled: {
                        pattern: /critical|authentication\s+fallback/i,
                        recommendation: "Enable critical authentication for RADIUS server failover",
                        severity: "high"
                    },
                    radiusServerRedundancy: {
                        pattern: /radius[\s-]server[\s\w]+[\r\n]+(?:.*[\r\n]+){1,10}?radius[\s-]server[\s\w]+/m,
                        recommendation: "Configure at least two RADIUS servers for redundancy",
                        severity: "high"
                    },
                    dhcpSnooping: {
                        pattern: /ip\s+dhcp\s+snooping|dhcp(ipv4|ipv6)?\s+snooping/i,
                        recommendation: "Enable DHCP snooping to prevent rogue DHCP servers",
                        severity: "medium"
                    },
                    arpInspection: {
                        pattern: /ip\s+arp\s+inspection|arp[\s-]protect/i,
                        recommendation: "Enable dynamic ARP inspection to prevent ARP spoofing",
                        severity: "medium"
                    },
                    bpduGuard: {
                        pattern: /spanning-tree\s+bpduguard\s+enable|bpdu[\s-]guard|bpdu[\s-]protection/i,
                        recommendation: "Enable BPDU guard on access ports to prevent loops",
                        severity: "medium"
                    },
                    stormControl: {
                        pattern: /storm[\s-]control/i,
                        recommendation: "Enable storm control to prevent broadcast/multicast storms",
                        severity: "low"
                    },
                    weakPassword: {
                        pattern: /key\s+\w{1,8}|password\s+\w{1,8}|secret\s+\w{1,8}/i,
                        recommendation: "Use strong passwords (minimum 12 characters with complexity)",
                        severity: "critical"
                    }
                },
                performance: {
                    radiusDeadtime: {
                        pattern: /deadtime\s+(\d+)/i,
                        evaluation: (match) => parseInt(match[1]) >= 10 && parseInt(match[1]) <= 30,
                        recommendation: "Set RADIUS deadtime between 10-30 minutes for optimal failover",
                        severity: "low"
                    },
                    radiusTimeout: {
                        pattern: /timeout\s+(\d+)/i,
                        evaluation: (match) => parseInt(match[1]) >= 2 && parseInt(match[1]) <= 5,
                        recommendation: "Set RADIUS timeout between 2-5 seconds for optimal performance",
                        severity: "low"
                    },
                    radiusRetransmit: {
                        pattern: /retransmit\s+(\d+)/i,
                        evaluation: (match) => parseInt(match[1]) >= 2 && parseInt(match[1]) <= 3,
                        recommendation: "Set RADIUS retransmit count between 2-3 for optimal performance",
                        severity: "low"
                    }
                },
                compatibility: {
                    authenticationConvert: {
                        pattern: /authentication\s+convert-to\s+new-style/i,
                        recommendation: "Use 'authentication convert-to new-style' for IBNS 2.0 compatibility",
                        severity: "medium"
                    }
                }
            };

            // Vendor-specific rules
            const vendorRules = {
                cisco: {
                    security: {
                        deviceTracking: {
                            pattern: /device-tracking|ip\s+device\s+tracking/i,
                            recommendation: "Enable device tracking for proper DACLs and proper authorization",
                            severity: "high"
                        },
                        coaSupport: {
                            pattern: /aaa\s+server\s+radius\s+dynamic-author/i,
                            recommendation: "Enable Change of Authorization (CoA) support for dynamic policy changes",
                            severity: "medium"
                        },
                        dot1xSystemAuth: {
                            pattern: /dot1x\s+system-auth-control/i,
                            recommendation: "Enable global 802.1X with dot1x system-auth-control",
                            severity: "high"
                        }
                    },
                    feature: {
                        ibns2Support: {
                            pattern: /policy-map\s+type\s+control\s+subscriber/i,
                            recommendation: "Use IBNS 2.0 for enhanced authentication flexibility",
                            severity: "medium"
                        },
                        concurrentAuthentication: {
                            pattern: /do-all[\s\S]*?authenticate\s+using\s+dot1x[\s\S]*?authenticate\s+using\s+mab/mi,
                            recommendation: "Use concurrent authentication for faster client authentication",
                            severity: "low"
                        }
                    }
                },
                aruba: {
                    security: {
                        centralwebauth: {
                            pattern: /central\s+web\s+auth|central-web-auth/i,
                            recommendation: "Configure Central Web Authentication for enhanced guest access",
                            severity: "low"
                        }
                    }
                },
                juniper: {
                    security: {
                        routeFiltering: {
                            pattern: /firewall\s+filter/i,
                            recommendation: "Configure firewall filters for enhanced security",
                            severity: "medium"
                        }
                    }
                }
            };

            // Merge common rules with vendor-specific rules
            if (vendorRules[vendor]) {
                return {
                    security: { ...commonRules.security, ...vendorRules[vendor].security },
                    performance: { ...commonRules.performance, ...(vendorRules[vendor].performance || {}) },
                    compatibility: { ...commonRules.compatibility, ...(vendorRules[vendor].compatibility || {}) },
                    feature: { ...(vendorRules[vendor].feature || {}) }
                };
            }

            // Return common rules if no vendor-specific rules found
            return commonRules;
        },

        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Analyze configuration button
            const analyzeBtn = document.getElementById('analyzeConfigBtn');
            if (analyzeBtn) {
                analyzeBtn.addEventListener('click', this.analyzeConfiguration.bind(this));
            }

            // Security analysis button
            const securityAnalysisBtn = document.getElementById('securityAnalysisBtn');
            if (securityAnalysisBtn) {
                securityAnalysisBtn.addEventListener('click', this.performSecurityAnalysis.bind(this));
            }

            // Optimize configuration button
            const optimizeBtn = document.getElementById('optimizeConfigBtn');
            if (optimizeBtn) {
                optimizeBtn.addEventListener('click', this.optimizeConfiguration.bind(this));
            }

            // Start optimization button
            const startOptimizationBtn = document.getElementById('startOptimizationBtn');
            if (startOptimizationBtn) {
                startOptimizationBtn.addEventListener('click', this.startOptimization.bind(this));
            }

            // Generate recommendations button
            const generateRecommendationsBtn = document.getElementById('generateRecommendationsBtn');
            if (generateRecommendationsBtn) {
                generateRecommendationsBtn.addEventListener('click', this.generateRecommendations.bind(this));
            }

            // Apply recommendations button
            const applyRecommendationsBtn = document.getElementById('applyRecommendationsBtn');
            if (applyRecommendationsBtn) {
                applyRecommendationsBtn.addEventListener('click', this.applyRecommendations.bind(this));
            }

            // Fix security issues button
            const fixSecurityIssuesBtn = document.getElementById('fixSecurityIssuesBtn');
            if (fixSecurityIssuesBtn) {
                fixSecurityIssuesBtn.addEventListener('click', this.fixSecurityIssues.bind(this));
            }
        },

        /**
         * Analyze configuration for security, performance, and best practices
         */
        analyzeConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;

            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }

            // Show loading indicator
            this.showLoadingIndicator('Analyzing configuration with AI...');

            // Determine the vendor from the configuration
            const vendor = this.detectVendorFromConfig(config);

            // Get detailed config parameters
            const configParams = this.extractConfigParameters(config);

            // Perform comprehensive analysis
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();

                // Perform various analyses
                const securityResults = this.analyzeSecurityConfig(config, vendor, configParams);
                const performanceResults = this.analyzePerformanceConfig(config, vendor, configParams);
                const bestPracticeResults = this.analyzeBestPractices(config, vendor, configParams);
                const complianceResults = this.checkComplianceStandards(config, vendor, configParams);

                // Combine results
                const analysisResults = {
                    score: this.calculateOverallScore(securityResults, performanceResults, bestPracticeResults, complianceResults),
                    security: securityResults,
                    performance: performanceResults,
                    bestPractices: bestPracticeResults,
                    compliance: complianceResults,
                    recommendations: this.generateRecommendationList(securityResults, performanceResults, bestPracticeResults)
                };

                // Display analysis results
                this.displayAnalysisResults(analysisResults);

                // Update security scores UI if on that tab
                this.updateSecurityScores(analysisResults);
            }, 2000);
        },

        /**
         * Analyze security configuration
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {Object} params - Configuration parameters
         * @returns {Object} Security analysis results
         */
        analyzeSecurityConfig: function(config, vendor, params) {
            console.log(`Analyzing security configuration for ${vendor}...`);

            const results = {
                score: 0,
                issues: [],
                strengths: [],
                criticalIssues: [],
                highImpactIssues: [],
                mediumImpactIssues: [],
                lowImpactIssues: []
            };

            // Get security rules for the vendor
            const securityRules = this.knowledgeBase[vendor]?.security || this.knowledgeBase.cisco.security;

            // Check each security rule
            for (const [ruleId, rule] of Object.entries(securityRules)) {
                const match = config.match(rule.pattern);
                let passed = !!match;

                // If the rule has a specific evaluation function, use it
                if (rule.evaluation && match) {
                    passed = rule.evaluation(match);
                }

                if (!passed) {
                    // Add issue based on severity
                    const issue = {
                        id: ruleId,
                        description: rule.recommendation,
                        severity: rule.severity,
                        impact: this.getImpactForSeverity(rule.severity),
                        remediation: rule.recommendation
                    };

                    results.issues.push(issue);

                    switch (rule.severity) {
                        case 'critical':
                            results.criticalIssues.push(issue);
                            break;
                        case 'high':
                            results.highImpactIssues.push(issue);
                            break;
                        case 'medium':
                            results.mediumImpactIssues.push(issue);
                            break;
                        case 'low':
                            results.lowImpactIssues.push(issue);
                            break;
                    }
                } else {
                    // Add as a strength
                    results.strengths.push({
                        id: ruleId,
                        description: `Correctly implemented: ${rule.recommendation}`,
                        severity: rule.severity
                    });
                }
            }

            // Calculate security score (0-100)
            results.score = this.calculateSecurityScore(results);

            return results;
        },

        /**
         * Analyze performance configuration
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {Object} params - Configuration parameters
         * @returns {Object} Performance analysis results
         */
        analyzePerformanceConfig: function(config, vendor, params) {
            console.log(`Analyzing performance configuration for ${vendor}...`);

            const results = {
                score: 0,
                issues: [],
                recommendations: []
            };

            // Get performance rules for the vendor
            const performanceRules = this.knowledgeBase[vendor]?.performance || this.knowledgeBase.cisco.performance;

            // Check each performance rule
            for (const [ruleId, rule] of Object.entries(performanceRules)) {
                const match = config.match(rule.pattern);
                let passed = !!match;

                // If the rule has a specific evaluation function, use it
                if (rule.evaluation && match) {
                    passed = rule.evaluation(match);
                }

                if (!passed) {
                    // Add issue
                    results.issues.push({
                        id: ruleId,
                        description: rule.recommendation,
                        severity: rule.severity,
                        impact: this.getImpactForSeverity(rule.severity)
                    });
                }
            }

            // Additional performance checks

            // Check for RADIUS load balancing
            if (config.includes('radius') && !config.includes('load-balance')) {
                results.recommendations.push({
                    type: 'performance',
                    description: 'Enable RADIUS load balancing for better performance and reliability',
                    impact: 'medium'
                });
            }

            // Check for appropriate dot1x timers
            if (config.includes('dot1x') && (!config.match(/tx-period\s+[5-9]|tx-period\s+1[0-5]/i) ||
                !config.match(/max-reauth-req\s+[2-4]/i))) {
                results.recommendations.push({
                    type: 'performance',
                    description: 'Optimize dot1x timers (tx-period 5-15, max-reauth-req 2-4) for better performance',
                    impact: 'low'
                });
            }

            // Calculate performance score (0-100)
            results.score = 100 - (results.issues.length * 10) - (results.recommendations.length * 5);
            results.score = Math.max(0, Math.min(100, results.score));

            return results;
        },

        /**
         * Analyze best practices implementation
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {Object} params - Configuration parameters
         * @returns {Object} Best practices analysis results
         */
        analyzeBestPractices: function(config, vendor, params) {
            console.log(`Analyzing best practices for ${vendor}...`);

            const results = {
                score: 0,
                implemented: [],
                missing: []
            };

            // Common best practices to check
            const bestPractices = [
                {
                    id: 'redundantRadius',
                    description: 'Redundant RADIUS Servers',
                    pattern: /radius[\s-]server[\s\w]+[\r\n]+(?:.*[\r\n]+){1,10}?radius[\s-]server[\s\w]+/m,
                    importance: 'high'
                },
                {
                    id: 'radiusLoadBalance',
                    description: 'RADIUS Load Balancing',
                    pattern: /load-balance\s+method/i,
                    importance: 'medium'
                },
                {
                    id: 'radiusDeadtime',
                    description: 'RADIUS Server Deadtime',
                    pattern: /deadtime\s+\d+/i,
                    importance: 'medium'
                },
                {
                    id: 'securityFeatures',
                    description: 'Layer 2 Security Features (DHCP Snooping, ARP Inspection, etc.)',
                    pattern: /ip\s+dhcp\s+snooping|ip\s+arp\s+inspection/i,
                    importance: 'high'
                },
                {
                    id: 'ibns2',
                    description: 'Identity-Based Networking Services 2.0 (IBNS 2.0)',
                    pattern: /policy-map\s+type\s+control\s+subscriber/i,
                    importance: 'medium',
                    vendorSpecific: 'cisco'
                },
                {
                    id: 'deviceTracking',
                    description: 'Device Tracking for DACL Support',
                    pattern: /device-tracking|ip\s+device\s+tracking/i,
                    importance: 'high',
                    vendorSpecific: 'cisco'
                },
                {
                    id: 'criticalAuth',
                    description: 'Critical Authentication for RADIUS Server Failure',
                    pattern: /critical[\s-]auth|critical\s+eapol|critical[\s-]vlan/i,
                    importance: 'high'
                },
                {
                    id: 'serverProbe',
                    description: 'RADIUS Server Probe',
                    pattern: /automate-tester|test\s+aaa/i,
                    importance: 'medium'
                },
                {
                    id: 'coa',
                    description: 'Change of Authorization (CoA) Support',
                    pattern: /dynamic-author|server\s+radius\s+dynamic/i,
                    importance: 'medium'
                },
                {
                    id: 'multiAuth',
                    description: 'Multi-Auth Host Mode',
                    pattern: /host-mode\s+multi-auth|host-mode\s+multi[\s-]auth/i,
                    importance: 'medium'
                },
                {
                    id: 'concurrentAuth',
                    description: 'Concurrent Authentication',
                    pattern: /do-all[\s\S]*?authenticate\s+using\s+dot1x[\s\S]*?authenticate\s+using\s+mab/mi,
                    importance: 'medium',
                    vendorSpecific: 'cisco'
                }
            ];

            // Check each best practice
            for (const practice of bestPractices) {
                // Skip vendor-specific practices for different vendors
                if (practice.vendorSpecific && practice.vendorSpecific !== vendor) {
                    continue;
                }

                if (config.match(practice.pattern)) {
                    results.implemented.push({
                        id: practice.id,
                        description: practice.description,
                        importance: practice.importance
                    });
                } else {
                    results.missing.push({
                        id: practice.id,
                        description: practice.description,
                        importance: practice.importance
                    });
                }
            }

            // Calculate best practices score (0-100)
            const totalPractices = results.implemented.length + results.missing.length;
            const implementedWeight = results.implemented.reduce((sum, practice) => {
                const weight = practice.importance === 'high' ? 3 :
                                practice.importance === 'medium' ? 2 : 1;
                return sum + weight;
            }, 0);

            const totalWeight = (results.implemented.concat(results.missing)).reduce((sum, practice) => {
                const weight = practice.importance === 'high' ? 3 :
                                practice.importance === 'medium' ? 2 : 1;
                return sum + weight;
            }, 0);

            results.score = totalWeight > 0 ? Math.round((implementedWeight / totalWeight) * 100) : 100;

            return results;
        },

        /**
         * Check compliance with security standards
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {Object} params - Configuration parameters
         * @returns {Object} Compliance check results
         */
        checkComplianceStandards: function(config, vendor, params) {
            console.log(`Checking compliance standards for ${vendor}...`);

            const results = {
                standards: [
                    {
                        name: 'NIST 800-53',
                        compliance: 0,
                        requirements: []
                    },
                    {
                        name: 'PCI DSS',
                        compliance: 0,
                        requirements: []
                    },
                    {
                        name: 'ISO 27001',
                        compliance: 0,
                        requirements: []
                    }
                ]
            };

            // Check NIST 800-53 requirements
            const nistRequirements = [
                {
                    id: 'AC-2',
                    description: 'Account Management',
                    pattern: /aaa\s+authentication|username|user\s+\w+\s+password/i,
                    met: false
                },
                {
                    id: 'AC-3',
                    description: 'Access Enforcement',
                    pattern: /ip\s+access-list|access-list|acl|authorization/i,
                    met: false
                },
                {
                    id: 'AC-6',
                    description: 'Least Privilege',
                    pattern: /privilege\s+level|role\s+\w+\s+privilege|authorization\s+commands/i,
                    met: false
                },
                {
                    id: 'AC-17',
                    description: 'Remote Access',
                    pattern: /ssh|telnet\s+server|ssl|https/i,
                    met: false
                },
                {
                    id: 'IA-2',
                    description: 'Identification and Authentication',
                    pattern: /dot1x|mab|authentication/i,
                    met: false
                },
                {
                    id: 'SC-8',
                    description: 'Transmission Confidentiality and Integrity',
                    pattern: /macsec|ssh\s+server|https|ssl|encrypted/i,
                    met: false
                }
            ];

            // Check each NIST requirement
            nistRequirements.forEach(req => {
                req.met = !!config.match(req.pattern);
                results.standards[0].requirements.push(req);
            });

            // Calculate NIST compliance percentage
            const metNistReqs = nistRequirements.filter(req => req.met).length;
            results.standards[0].compliance = Math.round((metNistReqs / nistRequirements.length) * 100);

            // Check PCI DSS requirements
            const pciRequirements = [
                {
                    id: 'Req-2.2',
                    description: 'Vendor-supplied defaults changed',
                    pattern: /username|password|secret\s+5|key\s+\w{10,}/i,
                    met: false
                },
                {
                    id: 'Req-2.3',
                    description: 'Encrypt all non-console admin access',
                    pattern: /ssh\s+server|no\s+telnet\s+server|https|transport\s+input\s+ssh/i,
                    met: false
                },
                {
                    id: 'Req-4.1',
                    description: 'Use strong cryptography and security protocols',
                    pattern: /ssh\s+server|https|tls|crypto/i,
                    met: false
                },
                {
                    id: 'Req-7.1',
                    description: 'Restrict access based on job responsibility',
                    pattern: /aaa\s+authorization|role\s+\w+\s+privilege|privilege\s+level/i,
                    met: false
                },
                {
                    id: 'Req-8.2',
                    description: 'User authentication and password management',
                    pattern: /password\s+policy|password\s+strength-check|aaa\s+authentication/i,
                    met: false
                },
                {
                    id: 'Req-10.1',
                    description: 'Audit trails linking access to individual users',
                    pattern: /aaa\s+accounting|logging|syslog/i,
                    met: false
                }
            ];

            // Check each PCI requirement
            pciRequirements.forEach(req => {
                req.met = !!config.match(req.pattern);
                results.standards[1].requirements.push(req);
            });

            // Calculate PCI compliance percentage
            const metPciReqs = pciRequirements.filter(req => req.met).length;
            results.standards[1].compliance = Math.round((metPciReqs / pciRequirements.length) * 100);

            // Check ISO 27001 requirements
            const isoRequirements = [
                {
                    id: 'A.9.2',
                    description: 'User access management',
                    pattern: /aaa\s+authentication|username|user\s+\w+\s+password/i,
                    met: false
                },
                {
                    id: 'A.9.4',
                    description: 'System and application access control',
                    pattern: /ip\s+access-list|access-list|acl|authorization/i,
                    met: false
                },
                {
                    id: 'A.10.1',
                    description: 'Cryptographic controls',
                    pattern: /ssh\s+server|key\s+\w+|crypto|macsec/i,
                    met: false
                },
                {
                    id: 'A.12.4',
                    description: 'Logging and monitoring',
                    pattern: /logging|syslog|aaa\s+accounting/i,
                    met: false
                },
                {
                    id: 'A.13.1',
                    description: 'Network security management',
                    pattern: /dhcp\s+snooping|arp\s+inspection|bpduguard|storm-control/i,
                    met: false
                }
            ];

            // Check each ISO requirement
            isoRequirements.forEach(req => {
                req.met = !!config.match(req.pattern);
                results.standards[2].requirements.push(req);
            });

            // Calculate ISO compliance percentage
            const metIsoReqs = isoRequirements.filter(req => req.met).length;
            results.standards[2].compliance = Math.round((metIsoReqs / isoRequirements.length) * 100);

            return results;
        },

        /**
         * Calculate security score based on issues and severities
         * @param {Object} results - Security analysis results
         * @returns {number} Security score (0-100)
         */
        calculateSecurityScore: function(results) {
            // Calculate score based on weighted severities
            const criticalIssuesCount = results.criticalIssues.length;
            const highIssuesCount = results.highImpactIssues.length;
            const mediumIssuesCount = results.mediumImpactIssues.length;
            const lowIssuesCount = results.lowImpactIssues.length;
            const strengths = results.strengths.length;

            // Start with 100 points and subtract based on issues
            let score = 100;

            // Critical issues have highest impact (each deducts 15 points)
            score -= criticalIssuesCount * 15;

            // High impact issues (each deducts 10 points)
            score -= highIssuesCount * 10;

            // Medium impact issues (each deducts 5 points)
            score -= mediumIssuesCount * 5;

            // Low impact issues (each deducts 2 points)
            score -= lowIssuesCount * 2;

            // Add bonus points for each implemented strength (max 10 points)
            score += Math.min(10, strengths * 1);

            // Ensure score is between 0 and 100
            return Math.max(0, Math.min(100, score));
        },

        /**
         * Calculate overall score based on all analysis components
         * @param {Object} securityResults - Security analysis results
         * @param {Object} performanceResults - Performance analysis results
         * @param {Object} bestPracticeResults - Best practices analysis results
         * @param {Object} complianceResults - Compliance analysis results
         * @returns {number} Overall score (0-100)
         */
        calculateOverallScore: function(securityResults, performanceResults, bestPracticeResults, complianceResults) {
            // Weight each component
            const securityWeight = 0.4;
            const performanceWeight = 0.2;
            const bestPracticeWeight = 0.3;
            const complianceWeight = 0.1;

            // Calculate compliance score (average of all standards)
            const complianceScore = complianceResults.standards.reduce((sum, standard) => sum + standard.compliance, 0) /
                                   complianceResults.standards.length;

            // Calculate weighted average
            const weightedScore =
                (securityResults.score * securityWeight) +
                (performanceResults.score * performanceWeight) +
                (bestPracticeResults.score * bestPracticeWeight) +
                (complianceScore * complianceWeight);

            return Math.round(weightedScore);
        },

        /**
         * Generate a list of recommendations based on analysis results
         * @param {Object} securityResults - Security analysis results
         * @param {Object} performanceResults - Performance analysis results
         * @param {Object} bestPracticeResults - Best practices analysis results
         * @returns {Array} List of recommendations
         */
        generateRecommendationList: function(securityResults, performanceResults, bestPracticeResults) {
            const recommendations = [];

            // Add security recommendations based on issues
            securityResults.issues.forEach(issue => {
                recommendations.push({
                    type: 'security',
                    severity: issue.severity,
                    description: issue.description,
                    impact: this.getImpactDescription(issue.severity),
                    remediation: issue.remediation || issue.description
                });
            });

            // Add performance recommendations
            performanceResults.recommendations.forEach(rec => {
                recommendations.push({
                    type: 'performance',
                    severity: rec.impact,
                    description: rec.description,
                    impact: this.getImpactDescription(rec.impact),
                    remediation: rec.description
                });
            });

            // Add missing best practices
            bestPracticeResults.missing.forEach(practice => {
                recommendations.push({
                    type: 'best-practice',
                    severity: this.getSeverityForImportance(practice.importance),
                    description: `Implement ${practice.description}`,
                    impact: this.getImpactDescription(this.getSeverityForImportance(practice.importance)),
                    remediation: `Implement ${practice.description} to improve security and compliance`
                });
            });

            // Sort recommendations by severity
            recommendations.sort((a, b) => {
                const severityOrder = { critical: 0, high: 1, medium: 2, low: 3 };
                return severityOrder[a.severity] - severityOrder[b.severity];
            });

            return recommendations;
        },

        /**
         * Perform security analysis
         */
        performSecurityAnalysis: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;

            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }

            // Show loading indicator
            this.showLoadingIndicator('Performing detailed security analysis...');

            // Get vendor from the configuration
            const vendor = this.detectVendorFromConfig(config);

            // Extract config parameters
            const configParams = this.extractConfigParameters(config);

            // Perform security analysis
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();

                const securityResults = this.analyzeSecurityConfig(config, vendor, configParams);
                const bestPracticeResults = this.analyzeBestPractices(config, vendor, configParams);
                const complianceResults = this.checkComplianceStandards(config, vendor, configParams);

                // Calculate category scores
                const authScore = this.calculateAuthenticationScore(config, securityResults, bestPracticeResults);
                const authzScore = this.calculateAuthorizationScore(config, securityResults, bestPracticeResults);
                const infraScore = this.calculateInfrastructureScore(config, securityResults, bestPracticeResults);
                const resilScore = this.calculateResilienceScore(config, securityResults, bestPracticeResults);

                // Update security scores on UI
                document.getElementById('securityScoreValue').textContent = securityResults.score;
                document.getElementById('authScore').textContent = authScore;
                document.getElementById('authzScore').textContent = authzScore;
                document.getElementById('infraScore').textContent = infraScore;
                document.getElementById('resilScore').textContent = resilScore;

                // Update security score circle color
                this.updateSecurityScoreColor(securityResults.score);

                // Show security analysis section
                document.querySelector('.security-analysis').classList.remove('hidden');

                // Update security issues sections
                this.updateSecurityIssuesSection(securityResults);
            }, 2000);
        },

        /**
         * Calculate authentication security score
         * @param {string} config - Configuration text
         * @param {Object} securityResults - Security analysis results
         * @param {Object} bestPracticeResults - Best practices results
         * @returns {number} Authentication score (0-100)
         */
        calculateAuthenticationScore: function(config, securityResults, bestPracticeResults) {
            let score = 100;

            // Check for 802.1X
            if (!config.match(/dot1x\s+system-auth-control|dot1x\s+pae\s+authenticator/i)) {
                score -= 20;
            }

            // Check for MAB (as fallback)
            if (!config.match(/mab/i)) {
                score -= 10;
            }

            // Check for redundant RADIUS servers
            if (!config.match(/radius[\s-]server[\s\w]+[\r\n]+(?:.*[\r\n]+){1,10}?radius[\s-]server[\s\w]+/m)) {
                score -= 20;
            }

            // Check for appropriate timers
            if (!config.match(/timeout\s+[2-5]/i) || !config.match(/retransmit\s+[2-3]/i)) {
                score -= 10;
            }

            // Check for critical authentication
            if (!config.match(/critical[\s-]auth|critical\s+eapol|critical[\s-]vlan/i)) {
                score -= 15;
            }

            // Check for server probing
            if (!config.match(/automate-tester|test\s+aaa/i)) {
                score -= 10;
            }

            // Add bonus for IBNS 2.0
            if (config.match(/policy-map\s+type\s+control\s+subscriber/i)) {
                score += 10;
            }

            // Add bonus for concurrent authentication
            if (config.match(/do-all[\s\S]*?authenticate\s+using\s+dot1x[\s\S]*?authenticate\s+using\s+mab/mi)) {
                score += 5;
            }

            // Ensure score is between 0 and 100
            return Math.max(0, Math.min(100, score));
        },

        /**
         * Calculate authorization security score
         * @param {string} config - Configuration text
         * @param {Object} securityResults - Security analysis results
         * @param {Object} bestPracticeResults - Best practices results
         * @returns {number} Authorization score (0-100)
         */
        calculateAuthorizationScore: function(config, securityResults, bestPracticeResults) {
            let score = 100;

            // Check for RADIUS authorization
            if (!config.match(/aaa\s+authorization\s+network/i)) {
                score -= 20;
            }

            // Check for device tracking (needed for dACLs)
            if (!config.match(/device-tracking|ip\s+device\s+tracking/i)) {
                score -= 25;
            }

            // Check for dynamic VLAN assignment capabilities
            if (!config.match(/authorization\s+network|authorization\s+default/i)) {
                score -= 15;
            }

            // Check for SGT support
            if (!config.match(/cts|security\s+group/i)) {
                score -= 10;
            }

            // Check for local fallback
            if (!config.match(/authorization.*local/i)) {
                score -= 10;
            }

            // Check for CoA support
            if (!config.match(/dynamic-author|server\s+radius\s+dynamic/i)) {
                score -= 15;
            }

            // Ensure score is between 0 and 100
            return Math.max(0, Math.min(100, score));
        },

        /**
         * Calculate infrastructure security score
         * @param {string} config - Configuration text
         * @param {Object} securityResults - Security analysis results
         * @param {Object} bestPracticeResults - Best practices results
         * @returns {number} Infrastructure score (0-100)
         */
        calculateInfrastructureScore: function(config, securityResults, bestPracticeResults) {
            let score = 100;

            // Check for DHCP snooping
            if (!config.match(/ip\s+dhcp\s+snooping|dhcp(ipv4|ipv6)?\s+snooping/i)) {
                score -= 15;
            }

            // Check for ARP inspection
            if (!config.match(/ip\s+arp\s+inspection|arp[\s-]protect/i)) {
                score -= 15;
            }

            // Check for BPDU Guard
            if (!config.match(/spanning-tree\s+bpduguard\s+enable|bpdu[\s-]guard|bpdu[\s-]protection/i)) {
                score -= 10;
            }

            // Check for Storm Control
            if (!config.match(/storm[\s-]control/i)) {
                score -= 10;
            }

            // Check for IP Source Guard
            if (!config.match(/ip\s+verify\s+source|ip\s+source\s+guard/i)) {
                score -= 10;
            }

            // Check for port security
            if (!config.match(/switchport\s+port-security|port[\s-]security/i)) {
                score -= 10;
            }

            // Check for appropriate VLANs
            if (!config.match(/vlan\s+\d+|interface\s+vlan/i)) {
                score -= 10;
            }

            // Check for private VLANs or protected ports
            if (!config.match(/private[\s-]vlan|switchport\s+protected/i)) {
                score -= 5;
            }

            // Check for native VLAN security
            if (!config.match(/vlan\s+\d+|native\s+vlan\s+\d+/i)) {
                score -= 5;
            }

            // Check for strong passwords
            if (config.match(/key\s+\w{1,8}|password\s+\w{1,8}|secret\s+\w{1,8}/i)) {
                score -= 10;
            }

            // Ensure score is between 0 and 100
            return Math.max(0, Math.min(100, score));
        },

        /**
         * Calculate resilience security score
         * @param {string} config - Configuration text
         * @param {Object} securityResults - Security analysis results
         * @param {Object} bestPracticeResults - Best practices results
         * @returns {number} Resilience score (0-100)
         */
        calculateResilienceScore: function(config, securityResults, bestPracticeResults) {
            let score = 100;

            // Check for redundant RADIUS servers
            if (!config.match(/radius[\s-]server[\s\w]+[\r\n]+(?:.*[\r\n]+){1,10}?radius[\s-]server[\s\w]+/m)) {
                score -= 20;
            }

            // Check for load balancing
            if (!config.match(/load-balance\s+method/i)) {
                score -= 15;
            }

            // Check for deadtime settings
            if (!config.match(/deadtime\s+\d+/i)) {
                score -= 15;
            }

            // Check for critical authentication
            if (!config.match(/critical[\s-]auth|critical\s+eapol|critical[\s-]vlan/i)) {
                score -= 20;
            }

            // Check for local fallback
            if (!config.match(/authentication.*local|authorization.*local/i)) {
                score -= 15;
            }

            // Check for server probing
            if (!config.match(/automate-tester|test\s+aaa/i)) {
                score -= 10;
            }

            // Ensure score is between 0 and 100
            return Math.max(0, Math.min(100, score));
        },

        /**
         * Update security issues sections in the UI
         * @param {Object} securityResults - Security analysis results
         */
        updateSecurityIssuesSection: function(securityResults) {
            // Update critical issues section
            const criticalIssuesElement = document.getElementById('criticalIssues');
            if (criticalIssuesElement) {
                if (securityResults.criticalIssues.length === 0) {
                    criticalIssuesElement.innerHTML = '<p>No critical issues found.</p>';
                } else {
                    criticalIssuesElement.innerHTML = this.formatIssuesList(securityResults.criticalIssues);
                }
            }

            // Update high impact issues section
            const highIssuesElement = document.getElementById('highIssues');
            if (highIssuesElement) {
                if (securityResults.highImpactIssues.length === 0) {
                    highIssuesElement.innerHTML = '<p>No high impact issues found.</p>';
                } else {
                    highIssuesElement.innerHTML = this.formatIssuesList(securityResults.highImpactIssues);
                }
            }

            // Update medium impact issues section
            const mediumIssuesElement = document.getElementById('mediumIssues');
            if (mediumIssuesElement) {
                if (securityResults.mediumImpactIssues.length === 0) {
                    mediumIssuesElement.innerHTML = '<p>No medium impact issues found.</p>';
                } else {
                    mediumIssuesElement.innerHTML = this.formatIssuesList(securityResults.mediumImpactIssues);
                }
            }

            // Update low impact issues section
            const lowIssuesElement = document.getElementById('lowIssues');
            if (lowIssuesElement) {
                if (securityResults.lowImpactIssues.length === 0) {
                    lowIssuesElement.innerHTML = '<p>No low impact issues found.</p>';
                } else {
                    lowIssuesElement.innerHTML = this.formatIssuesList(securityResults.lowImpactIssues);
                }
            }
        },

        /**
         * Format issues list as HTML
         * @param {Array} issues - List of issues
         * @returns {string} Formatted HTML
         */
        formatIssuesList: function(issues) {
            let html = '<ul class="issues-list">';

            issues.forEach(issue => {
                html += `
                    <li class="issue-item">
                        <div class="issue-header">
                            <span class="severity-badge ${issue.severity}">${issue.severity}</span>
                            <span class="issue-title">${issue.description}</span>
                        </div>
                        <div class="issue-details">
                            <p>Impact: ${this.getImpactDescription(issue.severity)}</p>
                            <p>Remediation: ${issue.remediation || issue.description}</p>
                        </div>
                    </li>
                `;
            });

            html += '</ul>';
            return html;
        },

        /**
         * Update security score circle color based on score
         * @param {number} score - Security score
         */
        updateSecurityScoreColor: function(score) {
            const scoreCircle = document.querySelector('.security-score-circle');
            if (scoreCircle) {
                if (score >= 90) {
                    scoreCircle.style.borderColor = '#27ae60'; // green
                } else if (score >= 70) {
                    scoreCircle.style.borderColor = '#2ecc71'; // light green
                } else if (score >= 50) {
                    scoreCircle.style.borderColor = '#f39c12'; // orange
                } else {
                    scoreCircle.style.borderColor = '#e74c3c'; // red
                }
            }
        },

        /**
         * Generate recommendations
         */
        generateRecommendations: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;

            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }

            // Show loading indicator
            this.showLoadingIndicator('Generating intelligent recommendations...');

            // Get vendor from the configuration
            const vendor = this.detectVendorFromConfig(config);

            // Extract config parameters
            const configParams = this.extractConfigParameters(config);

            // Perform analysis
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();

                const securityResults = this.analyzeSecurityConfig(config, vendor, configParams);
                const performanceResults = this.analyzePerformanceConfig(config, vendor, configParams);
                const bestPracticeResults = this.analyzeBestPractices(config, vendor, configParams);

                // Generate recommendation lists
                const securityRecommendations = this.getSecurityRecommendations(securityResults);
                const authRecommendations = this.getAuthRecommendations(config, securityResults, bestPracticeResults);
                const infraRecommendations = this.getInfraRecommendations(config, securityResults, bestPracticeResults);
                const opsRecommendations = this.getOperationalRecommendations(config, securityResults, performanceResults);

                // Update UI with recommendations
                this.updateRecommendationsUI(securityRecommendations, authRecommendations, infraRecommendations, opsRecommendations);

                // Show recommendations content
                document.querySelector('.recommendations-content').classList.remove('hidden');
            }, 2000);
        },

        /**
         * Get security-specific recommendations
         * @param {Object} securityResults - Security analysis results
         * @returns {Array} Security recommendations
         */
        getSecurityRecommendations: function(securityResults) {
            const recommendations = [];

            // Get recommendations from critical and high issues first
            securityResults.criticalIssues.concat(securityResults.highImpactIssues).forEach(issue => {
                recommendations.push({
                    type: 'security',
                    severity: issue.severity,
                    description: issue.description,
                    remediation: issue.remediation || issue.description,
                    config: this.getConfigForRecommendation(issue.id)
                });
            });

            // Add medium issues if we don't have enough recommendations
            if (recommendations.length < 3) {
                securityResults.mediumImpactIssues.slice(0, 3 - recommendations.length).forEach(issue => {
                    recommendations.push({
                        type: 'security',
                        severity: issue.severity,
                        description: issue.description,
                        remediation: issue.remediation || issue.description,
                        config: this.getConfigForRecommendation(issue.id)
                    });
                });
            }

            return recommendations;
        },

        /**
         * Get authentication-specific recommendations
         * @param {string} config - Configuration text
         * @param {Object} securityResults - Security analysis results
         * @param {Object} bestPracticeResults - Best practices results
         * @returns {Array} Authentication recommendations
         */
        getAuthRecommendations: function(config, securityResults, bestPracticeResults) {
            const recommendations = [];

            // Check for missing authentication best practices
            const authBestPractices = bestPracticeResults.missing.filter(practice =>
                ['redundantRadius', 'serverProbe', 'criticalAuth', 'multiAuth', 'concurrentAuth'].includes(practice.id)
            );

            // Add recommendations for missing auth best practices
            authBestPractices.forEach(practice => {
                recommendations.push({
                    type: 'authentication',
                    severity: this.getSeverityForImportance(practice.importance),
                    description: `Implement ${practice.description}`,
                    remediation: `Implement ${practice.description} for improved authentication resilience and user experience`,
                    config: this.getConfigForRecommendation(practice.id)
                });
            });

            // Add additional authentication recommendations

            // Check for 802.1X and MAB together
            if (!config.match(/dot1x/) || !config.match(/mab/)) {
                recommendations.push({
                    type: 'authentication',
                    severity: 'high',
                    description: 'Implement both 802.1X and MAB for comprehensive device authentication',
                    remediation: 'Configure both 802.1X and MAB to support both 802.1X-capable and legacy devices',
                    config: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\nmab'
                });
            }

            // Check for multi-auth host mode
            if (!config.match(/host-mode\s+multi-auth|host-mode\s+multi[\s-]auth/i)) {
                recommendations.push({
                    type: 'authentication',
                    severity: 'medium',
                    description: 'Use multi-auth host mode to support multiple devices on a single port',
                    remediation: 'Configure multi-auth host mode to allow multiple devices to authenticate independently on the same port',
                    config: 'authentication host-mode multi-auth\n-- OR --\naccess-session host-mode multi-auth'
                });
            }

            return recommendations;
        },

        /**
         * Get infrastructure-specific recommendations
         * @param {string} config - Configuration text
         * @param {Object} securityResults - Security analysis results
         * @param {Object} bestPracticeResults - Best practices results
         * @returns {Array} Infrastructure recommendations
         */
        getInfraRecommendations: function(config, securityResults, bestPracticeResults) {
            const recommendations = [];

            // Check for missing infrastructure security features
            if (!config.match(/ip\s+dhcp\s+snooping|dhcp(ipv4|ipv6)?\s+snooping/i)) {
                recommendations.push({
                    type: 'infrastructure',
                    severity: 'high',
                    description: 'Enable DHCP Snooping to prevent rogue DHCP servers',
                    remediation: 'Configure DHCP snooping to prevent DHCP spoofing attacks',
                    config: 'ip dhcp snooping\nip dhcp snooping vlan 1-4094\nip dhcp snooping information option\nip dhcp snooping limit rate 20'
                });
            }

            if (!config.match(/ip\s+arp\s+inspection|arp[\s-]protect/i)) {
                recommendations.push({
                    type: 'infrastructure',
                    severity: 'high',
                    description: 'Enable Dynamic ARP Inspection to prevent ARP spoofing',
                    remediation: 'Configure dynamic ARP inspection to prevent ARP spoofing attacks',
                    config: 'ip arp inspection vlan 1-4094\nip arp inspection validate src-mac dst-mac ip'
                });
            }

            if (!config.match(/spanning-tree\s+bpduguard\s+enable|bpdu[\s-]guard|bpdu[\s-]protection/i)) {
                recommendations.push({
                    type: 'infrastructure',
                    severity: 'medium',
                    description: 'Enable BPDU Guard on access ports to prevent loops',
                    remediation: 'Configure BPDU Guard to prevent spanning tree loops caused by unauthorized switches',
                    config: 'spanning-tree portfast\nspanning-tree bpduguard enable'
                });
            }

            if (!config.match(/storm[\s-]control/i)) {
                recommendations.push({
                    type: 'infrastructure',
                    severity: 'medium',
                    description: 'Enable Storm Control to prevent broadcast storms',
                    remediation: 'Configure storm control to limit broadcast, multicast, or unicast traffic storms',
                    config: 'storm-control broadcast level pps 100 80\nstorm-control action trap'
                });
            }

            return recommendations;
        },

        /**
         * Get operational recommendations
         * @param {string} config - Configuration text
         * @param {Object} securityResults - Security analysis results
         * @param {Object} performanceResults - Performance analysis results
         * @returns {Array} Operational recommendations
         */
        getOperationalRecommendations: function(config, securityResults, performanceResults) {
            const recommendations = [];

            // Check for load balancing
            if (!config.match(/load-balance\s+method/i)) {
                recommendations.push({
                    type: 'operational',
                    severity: 'medium',
                    description: 'Enable RADIUS load balancing for better performance and resilience',
                    remediation: 'Configure RADIUS load balancing to distribute authentication requests across multiple servers',
                    config: 'radius-server load-balance method least-outstanding'
                });
            }

            // Check for RADIUS server probing
            if (!config.match(/automate-tester|test\s+aaa/i)) {
                recommendations.push({
                    type: 'operational',
                    severity: 'medium',
                    description: 'Enable RADIUS server probing for proactive server availability monitoring',
                    remediation: 'Configure RADIUS server probing to detect server failures before they impact users',
                    config: 'radius server SERVER-NAME\n automate-tester username probe-user probe-on'
                });
            }

            // Check for optimal timers
            if (!config.match(/tx-period\s+[5-9]|tx-period\s+1[0-5]/i) ||
                !config.match(/max-reauth-req\s+[2-4]/i)) {
                recommendations.push({
                    type: 'operational',
                    severity: 'low',
                    description: 'Optimize authentication timers for better performance',
                    remediation: 'Configure optimal authentication timers to balance responsiveness and network load',
                    config: 'dot1x timeout tx-period 7\ndot1x max-reauth-req 2\ndot1x timeout quiet-period 60'
                });
            }

            // Check for periodic reauthentication
            if (!config.match(/authentication\s+periodic|authentication\s+timer\s+reauthenticate/i)) {
                recommendations.push({
                    type: 'operational',
                    severity: 'medium',
                    description: 'Enable periodic reauthentication for dynamic policy updates',
                    remediation: 'Configure periodic reauthentication to ensure policies stay up to date',
                    config: 'authentication periodic\nauthentication timer reauthenticate server'
                });
            }

            return recommendations;
        },

        /**
         * Update recommendations UI
         * @param {Array} securityRecommendations - Security recommendations
         * @param {Array} authRecommendations - Authentication recommendations
         * @param {Array} infraRecommendations - Infrastructure recommendations
         * @param {Array} opsRecommendations - Operational recommendations
         */
        updateRecommendationsUI: function(securityRecommendations, authRecommendations, infraRecommendations, opsRecommendations) {
            // Update authentication recommendations
            const authRecommendationsElement = document.getElementById('authRecommendations');
            if (authRecommendationsElement) {
                if (authRecommendations.length === 0) {
                    authRecommendationsElement.innerHTML = '<p>No authentication recommendations available.</p>';
                } else {
                    authRecommendationsElement.innerHTML = this.formatRecommendationsList(authRecommendations);
                }
            }

            // Update security recommendations
            const securityRecommendationsElement = document.getElementById('securityRecommendations');
            if (securityRecommendationsElement) {
                if (securityRecommendations.length === 0) {
                    securityRecommendationsElement.innerHTML = '<p>No security recommendations available.</p>';
                } else {
                    securityRecommendationsElement.innerHTML = this.formatRecommendationsList(securityRecommendations);
                }
            }

            // Update infrastructure recommendations
            const infraRecommendationsElement = document.getElementById('infraRecommendations');
            if (infraRecommendationsElement) {
                if (infraRecommendations.length === 0) {
                    infraRecommendationsElement.innerHTML = '<p>No infrastructure recommendations available.</p>';
                } else {
                    infraRecommendationsElement.innerHTML = this.formatRecommendationsList(infraRecommendations);
                }
            }

            // Update operations recommendations
            const opsRecommendationsElement = document.getElementById('opsRecommendations');
            if (opsRecommendationsElement) {
                if (opsRecommendations.length === 0) {
                    opsRecommendationsElement.innerHTML = '<p>No operational recommendations available.</p>';
                } else {
                    opsRecommendationsElement.innerHTML = this.formatRecommendationsList(opsRecommendations);
                }
            }
        },

        /**
         * Format recommendations list as HTML
         * @param {Array} recommendations - List of recommendations
         * @returns {string} Formatted HTML
         */
        formatRecommendationsList: function(recommendations) {
            let html = '<ul class="recommendations-list">';

            recommendations.forEach(rec => {
                html += `
                    <li class="recommendation-item">
                        <div class="recommendation-header">
                            <span class="severity-badge ${rec.severity}">${rec.severity}</span>
                            <span class="recommendation-title">${rec.description}</span>
                        </div>
                        <div class="recommendation-details">
                            <p>${rec.remediation}</p>
                            ${rec.config ? `<pre class="recommendation-config">${rec.config}</pre>` : ''}
                        </div>
                    </li>
                `;
            });

            html += '</ul>';
            return html;
        },

        /**
         * Get configuration snippet for a recommendation
         * @param {string} id - Recommendation ID
         * @returns {string} Configuration snippet
         */
        getConfigForRecommendation: function(id) {
            // Config snippets for various recommendations
            const configSnippets = {
                redundantRadius: `radius server PRIMARY-SERVER
 address ipv4 10.1.1.10 auth-port 1812 acct-port 1813
 timeout 2
 retransmit 2
 key STRONG-KEY-HERE
 automate-tester username test-user probe-on

radius server SECONDARY-SERVER
 address ipv4 10.1.1.11 auth-port 1812 acct-port 1813
 timeout 2
 retransmit 2
 key STRONG-KEY-HERE
 automate-tester username test-user probe-on

aaa group server radius RADIUS-SERVERS
 server name PRIMARY-SERVER
 server name SECONDARY-SERVER
 deadtime 15
 ip radius source-interface Vlan10`,

                criticalAuth: `service-template CRITICAL_DATA_ACCESS
 vlan 999
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan 999
 access-group ACL-OPEN

class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

dot1x critical eapol
authentication critical recovery delay 2000`,

                serverProbe: `radius server SERVER-NAME
 automate-tester username test-user probe-on
 deadtime 15

radius-server dead-criteria time 5 tries 3`,

                concurrentAuth: `policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-all
   10 authenticate using dot1x priority 10
   20 authenticate using mab priority 20`,

                multiAuth: `access-session host-mode multi-auth
-- OR --
authentication host-mode multi-auth`,

                deviceTracking: `device-tracking tracking auto-source

device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

! Apply to interfaces
interface range GigabitEthernet1/0/1-48
 device-tracking attach-policy IP-TRACKING`,

                dhcpSnooping: `ip dhcp snooping
ip dhcp snooping vlan 1-4094
ip dhcp snooping information option
ip dhcp snooping limit rate 20`,

                arpInspection: `ip arp inspection vlan 1-4094
ip arp inspection validate src-mac dst-mac ip`,

                bpduGuard: `! On interfaces
spanning-tree portfast
spanning-tree bpduguard enable

! Globally
spanning-tree portfast bpduguard default`,

                stormControl: `storm-control broadcast level pps 100 80
storm-control multicast level pps 100 80
storm-control action trap`,

                loadBalance: `radius-server load-balance method least-outstanding`,

                dot1xSystemAuth: `dot1x system-auth-control`,

                coaSupport: `aaa server radius dynamic-author
 client 10.1.1.10 server-key STRONG-KEY-HERE
 client 10.1.1.11 server-key STRONG-KEY-HERE
 auth-type any`
            };

            return configSnippets[id] || '';
        },

        /**
         * Optimize configuration for best practices, performance, and security
         */
        optimizeConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;

            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }

            // Show loading indicator
            this.showLoadingIndicator('Optimizing configuration with AI...');

            // Determine the vendor from the configuration
            const vendor = this.detectVendorFromConfig(config);

            // Get optimization goals from UI if available
            const optimizationGoals = this.getOptimizationGoals();

            // Get optimization level from UI if available
            const optimizationLevel = this.getOptimizationLevel();

            // Perform optimization
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();

                // Perform optimization
                const optimizationResults = this.performOptimization(config, vendor, optimizationGoals, optimizationLevel);

                // Update configuration output
                configOutput.value = optimizationResults.optimizedConfig;

                // Show optimization success message
                this.showOptimizationSuccess(optimizationResults);
            }, 2000);
        },

        /**
         * Start optimization process
         */
        startOptimization: function() {
            this.optimizeConfiguration();
        },

        /**
         * Get optimization goals from UI
         * @returns {Object} Optimization goals
         */
        getOptimizationGoals: function() {
            const goals = {
                security: document.getElementById('optSecurity')?.checked || true,
                performance: document.getElementById('optPerformance')?.checked || true,
                manageability: document.getElementById('optManageability')?.checked || true,
                redundancy: document.getElementById('optRedundancy')?.checked || true,
                compliance: document.getElementById('optCompliance')?.checked || false
            };

            return goals;
        },

        /**
         * Get optimization level from UI
         * @returns {string} Optimization level
         */
        getOptimizationLevel: function() {
            return document.getElementById('optimizationLevel')?.value || 'moderate';
        },

        /**
         * Perform optimization on configuration
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {Object} goals - Optimization goals
         * @param {string} level - Optimization level
         * @returns {Object} Optimization results
         */
        performOptimization: function(config, vendor, goals, level) {
            console.log(`Optimizing ${vendor} configuration with level ${level}...`);

            // Start with original config
            let optimizedConfig = config;
            const changes = [];

            // Security optimizations
            if (goals.security) {
                const securityChanges = this.performSecurityOptimizations(config, vendor, level);
                optimizedConfig = securityChanges.config;
                changes.push(...securityChanges.changes);
            }

            // Performance optimizations
            if (goals.performance) {
                const performanceChanges = this.performPerformanceOptimizations(optimizedConfig, vendor, level);
                optimizedConfig = performanceChanges.config;
                changes.push(...performanceChanges.changes);
            }

            // Manageability optimizations
            if (goals.manageability) {
                const manageabilityChanges = this.performManageabilityOptimizations(optimizedConfig, vendor, level);
                optimizedConfig = manageabilityChanges.config;
                changes.push(...manageabilityChanges.changes);
            }

            // Redundancy optimizations
            if (goals.redundancy) {
                const redundancyChanges = this.performRedundancyOptimizations(optimizedConfig, vendor, level);
                optimizedConfig = redundancyChanges.config;
                changes.push(...redundancyChanges.changes);
            }

            // Compliance optimizations
            if (goals.compliance) {
                const complianceChanges = this.performComplianceOptimizations(optimizedConfig, vendor, level);
                optimizedConfig = complianceChanges.config;
                changes.push(...complianceChanges.changes);
            }

            return {
                originalConfig: config,
                optimizedConfig: optimizedConfig,
                changes: changes,
                changesCount: changes.length
            };
        },

        /**
         * Perform security optimizations
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {string} level - Optimization level
         * @returns {Object} Optimization results
         */
        performSecurityOptimizations: function(config, vendor, level) {
            let optimizedConfig = config;
            const changes = [];

            // Add DHCP snooping if missing
            if (!config.includes('ip dhcp snooping')) {
                const dhcpSnoopingConfig = `
ip dhcp snooping
ip dhcp snooping vlan 1-4094
ip dhcp snooping information option
ip dhcp snooping limit rate 20`;

                const insertPoint = this.findInsertionPoint(config, 'global_security');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + dhcpSnoopingConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'security',
                        category: 'DHCP Snooping',
                        description: 'Added DHCP Snooping to prevent rogue DHCP servers',
                        impact: 'Enhanced security against DHCP spoofing attacks'
                    });
                }
            }

            // Add Dynamic ARP Inspection if missing
            if (!config.includes('ip arp inspection')) {
                const daiConfig = `
ip arp inspection vlan 1-4094
ip arp inspection validate src-mac dst-mac ip`;

                const insertPoint = this.findInsertionPoint(config, 'global_security');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + daiConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'security',
                        category: 'ARP Inspection',
                        description: 'Added Dynamic ARP Inspection to prevent ARP spoofing',
                        impact: 'Enhanced security against man-in-the-middle attacks'
                    });
                }
            }

            // Add IP Source Guard if missing and if aggressive
            if (level === 'aggressive' && !config.includes('ip verify source')) {
                optimizedConfig = optimizedConfig.replace(
                    /interface (.*?)\n([\s\S]*?)(?=\ninterface|$)/g,
                    (match, p1, p2) => {
                        if (p2.includes('switchport mode access') && !p2.includes('ip verify source')) {
                            return `interface ${p1}\n${p2} ip verify source\n`;
                        }
                        return match;
                    }
                );

                changes.push({
                    type: 'security',
                    category: 'IP Source Guard',
                    description: 'Added IP Source Guard to access ports',
                    impact: 'Enhanced security against IP spoofing attacks'
                });
            }

            // Add BPDU Guard if missing
            if (!config.includes('spanning-tree bpduguard enable')) {
                optimizedConfig = optimizedConfig.replace(
                    /interface (.*?)\n([\s\S]*?)(?=\ninterface|$)/g,
                    (match, p1, p2) => {
                        if (p2.includes('switchport mode access') && !p2.includes('spanning-tree bpduguard enable') && !p2.includes('switchport trunk')) {
                            return `interface ${p1}\n${p2} spanning-tree portfast\n spanning-tree bpduguard enable\n`;
                        }
                        return match;
                    }
                );

                changes.push({
                    type: 'security',
                    category: 'BPDU Guard',
                    description: 'Added BPDU Guard to access ports',
                    impact: 'Enhanced security against unauthorized switches and Layer 2 loops'
                });
            }

            // Add device tracking for DACL support if missing (Cisco only)
            if (vendor === 'cisco' && !config.includes('device-tracking') && !config.includes('ip device tracking')) {
                const deviceTrackingConfig = config.includes('policy-map type control subscriber') ?
                    `
device-tracking tracking auto-source

device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

device-tracking policy DISABLE-IP-TRACKING
 tracking disable
 trusted-port
 device-role switch` :
                    `
ip device tracking probe auto-source
ip device tracking probe delay 10
ip device tracking probe interval 30`;

                const insertPoint = this.findInsertionPoint(config, 'global_security');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + deviceTrackingConfig + '\n' + afterInsert;

                    // Also add policy attachment to interfaces if using IBNS 2.0
                    if (config.includes('policy-map type control subscriber')) {
                        optimizedConfig = optimizedConfig.replace(
                            /interface (.*?)\n([\s\S]*?)(?=\ninterface|$)/g,
                            (match, p1, p2) => {
                                if (p2.includes('switchport mode access') && !p2.includes('device-tracking attach-policy')) {
                                    return `interface ${p1}\n${p2} device-tracking attach-policy IP-TRACKING\n`;
                                } else if (p2.includes('switchport mode trunk') && !p2.includes('device-tracking attach-policy')) {
                                    return `interface ${p1}\n${p2} device-tracking attach-policy DISABLE-IP-TRACKING\n`;
                                }
                                return match;
                            }
                        );
                    }

                    changes.push({
                        type: 'security',
                        category: 'Device Tracking',
                        description: 'Added Device Tracking for DACL support',
                        impact: 'Enables use of downloadable ACLs and SGT assignment'
                    });
                }
            }

            // Add storm control if missing and if moderate or aggressive
            if ((level === 'moderate' || level === 'aggressive') && !config.includes('storm-control')) {
                optimizedConfig = optimizedConfig.replace(
                    /interface (.*?)\n([\s\S]*?)(?=\ninterface|$)/g,
                    (match, p1, p2) => {
                        if (p2.includes('switchport mode access') && !p2.includes('storm-control')) {
                            return `interface ${p1}\n${p2} storm-control broadcast level pps 100 80\n storm-control action trap\n`;
                        }
                        return match;
                    }
                );

                changes.push({
                    type: 'security',
                    category: 'Storm Control',
                    description: 'Added Storm Control to access ports',
                    impact: 'Enhanced protection against broadcast storms'
                });
            }

            // Add ACL-OPEN for critical authentication if missing
            if (config.includes('critical') && !config.includes('ACL-OPEN')) {
                const aclOpenConfig = `
ip access-list extended ACL-OPEN
 permit ip any any`;

                const insertPoint = this.findInsertionPoint(config, 'global_acl');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + aclOpenConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'security',
                        category: 'Critical Auth ACL',
                        description: 'Added ACL-OPEN for critical authentication',
                        impact: 'Ensures proper operation of critical authentication feature'
                    });
                }
            }

            return { config: optimizedConfig, changes: changes };
        },

        /**
         * Perform performance optimizations
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {string} level - Optimization level
         * @returns {Object} Optimization results
         */
        performPerformanceOptimizations: function(config, vendor, level) {
            let optimizedConfig = config;
            const changes = [];

            // Optimize RADIUS server timeouts
            const timeoutMatch = config.match(/timeout\s+(\d+)/);
            if (timeoutMatch && parseInt(timeoutMatch[1]) > 5) {
                optimizedConfig = optimizedConfig.replace(
                    /timeout\s+\d+/g,
                    'timeout 2'
                );

                changes.push({
                    type: 'performance',
                    category: 'RADIUS Timeouts',
                    description: 'Optimized RADIUS server timeout to 2 seconds',
                    impact: 'Faster authentication during RADIUS server failures'
                });
            }

            // Optimize RADIUS server retransmit count
            const retransmitMatch = config.match(/retransmit\s+(\d+)/);
            if (retransmitMatch && parseInt(retransmitMatch[1]) > 3) {
                optimizedConfig = optimizedConfig.replace(
                    /retransmit\s+\d+/g,
                    'retransmit 2'
                );

                changes.push({
                    type: 'performance',
                    category: 'RADIUS Retransmit',
                    description: 'Optimized RADIUS server retransmit count to 2',
                    impact: 'Improved authentication performance'
                });
            }

            // Add RADIUS load balancing if missing and multiple servers exist
            if (!config.includes('load-balance') &&
                config.match(/radius[\s-]server[\s\w]+[\r\n]+(?:.*[\r\n]+){1,10}?radius[\s-]server[\s\w]+/m)) {

                const insertPoint = this.findInsertionPoint(config, 'radius_global');
                if (insertPoint !== -1) {
                    const loadBalanceConfig = `
radius-server load-balance method least-outstanding`;

                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + loadBalanceConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'performance',
                        category: 'RADIUS Load Balancing',
                        description: 'Added RADIUS load balancing',
                        impact: 'Improved authentication performance and server utilization'
                    });
                }
            }

            // Optimize dot1x timers for performance
            const txPeriodMatch = config.match(/tx-period\s+(\d+)/);
            if (!txPeriodMatch || parseInt(txPeriodMatch[1]) > 15 || parseInt(txPeriodMatch[1]) < 5) {
                optimizedConfig = optimizedConfig.replace(
                    /dot1x\s+timeout\s+tx-period\s+\d+/g,
                    'dot1x timeout tx-period 7'
                );

                if (!txPeriodMatch) {
                    // Add tx-period if missing
                    optimizedConfig = optimizedConfig.replace(
                        /(dot1x\s+pae\s+authenticator)/g,
                        '$1\ndot1x timeout tx-period 7'
                    );
                }

                changes.push({
                    type: 'performance',
                    category: 'Dot1x Timers',
                    description: 'Optimized dot1x tx-period timer to 7 seconds',
                    impact: 'Improved authentication responsiveness'
                });
            }

            // Enable concurrent authentication if using IBNS 2.0 and not already enabled
            if (config.includes('policy-map type control subscriber') &&
                !config.match(/do-all[\s\S]*?authenticate\s+using\s+dot1x[\s\S]*?authenticate\s+using\s+mab/mi)) {

                optimizedConfig = optimizedConfig.replace(
                    /event\s+session-started\s+match-all\s+10\s+class\s+always\s+do-until-failure\s+10\s+authenticate\s+using\s+dot1x\s+priority\s+10/g,
                    'event session-started match-all\n  10 class always do-all\n   10 authenticate using dot1x priority 10\n   20 authenticate using mab priority 20'
                );

                // Update policy map name if needed
                optimizedConfig = optimizedConfig.replace(
                    /policy-map\s+type\s+control\s+subscriber\s+DOT1X_MAB_POLICY/g,
                    'policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY'
                );

                // Update service-policy reference
                optimizedConfig = optimizedConfig.replace(
                    /service-policy\s+type\s+control\s+subscriber\s+DOT1X_MAB_POLICY/g,
                    'service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY'
                );

                changes.push({
                    type: 'performance',
                    category: 'Concurrent Authentication',
                    description: 'Enabled concurrent 802.1X and MAB authentication',
                    impact: 'Significantly faster authentication, especially in mixed environments'
                });
            }

            return { config: optimizedConfig, changes: changes };
        },

        /**
         * Perform manageability optimizations
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {string} level - Optimization level
         * @returns {Object} Optimization results
         */
        performManageabilityOptimizations: function(config, vendor, level) {
            let optimizedConfig = config;
            const changes = [];

            // Add RADIUS server probing if missing
            if (!config.includes('automate-tester') && !config.includes('test aaa')) {
                optimizedConfig = optimizedConfig.replace(
                    /(radius\s+server\s+[\w-]+\s+(?:[\s\S](?!radius\s+server))*?)(\n\S)/gm,
                    '$1\n automate-tester username test-user probe-on$2'
                );

                changes.push({
                    type: 'manageability',
                    category: 'RADIUS Server Probing',
                    description: 'Added RADIUS server probing',
                    impact: 'Proactive detection of RADIUS server failures'
                });
            }

            // Add device-sensor if missing for better profiling
            if (!config.includes('device-sensor') && level !== 'conservative') {
                const deviceSensorConfig = `
device-sensor filter-list dhcp list DS_DHCP_LIST
 option name host-name
 option name requested-address
 option name parameter-request-list
 option name class-identifier
 option name client-identifier
device-sensor filter-spec dhcp include list DS_DHCP_LIST

cdp run
device-sensor filter-list cdp list DS_CDP_LIST
 tlv name device-name
 tlv name address-type
 tlv name capabilities-type
 tlv name platform-type
 tlv name version-type
device-sensor filter-spec cdp include list DS_CDP_LIST

lldp run
device-sensor filter-list lldp list DS_LLDP_LIST
 tlv name system-name
 tlv name system-description
 tlv name system-capabilities
device-sensor filter-spec lldp include list DS_LLDP_LIST

device-sensor notify all-changes`;

                const insertPoint = this.findInsertionPoint(config, 'global_config');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + deviceSensorConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'manageability',
                        category: 'Device Profiling',
                        description: 'Added device-sensor for better device profiling',
                        impact: 'Enhanced device identification and policy assignment'
                    });
                }
            }

            // Update template if using IBNS 2.0 to set recommended inactivity timer
            if (config.includes('template WIRED_DOT1X_') && !config.includes('subscriber aging inactivity-timer')) {
                optimizedConfig = optimizedConfig.replace(
                    /(template\s+WIRED_DOT1X_[\w-]+\s+(?:[\s\S](?!template))*?)(\n\S)/gm,
                    '$1\n subscriber aging inactivity-timer 60 probe$2'
                );

                changes.push({
                    type: 'manageability',
                    category: 'Inactivity Timer',
                    description: 'Added inactivity timer to interface template',
                    impact: 'Better session cleanup for idle devices'
                });
            }

            // For Cisco IOS-XE, ensure authentication convert-to new-style is present
            if (vendor === 'cisco' && config.includes('IOS-XE') && !config.includes('authentication convert-to new-style')) {
                const insertPoint = this.findInsertionPoint(config, 'global_config_top');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + '\nauthentication convert-to new-style yes\n' + afterInsert;

                    changes.push({
                        type: 'manageability',
                        category: 'New-Style Authentication',
                        description: 'Added authentication convert-to new-style',
                        impact: 'Enables IBNS 2.0 features and flexible authentication'
                    });
                }
            }

            return { config: optimizedConfig, changes: changes };
        },

        /**
         * Perform redundancy optimizations
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {string} level - Optimization level
         * @returns {Object} Optimization results
         */
        performRedundancyOptimizations: function(config, vendor, level) {
            let optimizedConfig = config;
            const changes = [];

            // Add critical authentication if missing
            if (!config.includes('critical') && !config.includes('CRITICAL_')) {
                // Add service templates for critical authentication
                const criticalAuthConfig = `
service-template CRITICAL_DATA_ACCESS
 vlan 999
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan 999
 access-group ACL-OPEN

dot1x critical eapol
authentication critical recovery delay 2000`;

                const insertPoint = this.findInsertionPoint(config, 'global_config');
                if (insertPoint !== -1) {
                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + criticalAuthConfig + '\n' + afterInsert;

                    // Also add class maps for critical authentication if IBNS 2.0
                    if (config.includes('policy-map type control subscriber')) {
                        const criticalClassMapsConfig = `
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS`;

                        const classmapPoint = this.findInsertionPoint(config, 'class_maps');
                        if (classmapPoint !== -1) {
                            const beforeInsert = optimizedConfig.substring(0, classmapPoint);
                            const afterInsert = optimizedConfig.substring(classmapPoint);
                            optimizedConfig = beforeInsert + criticalClassMapsConfig + '\n' + afterInsert;
                        }

                        // Add critical auth to policy map if IBNS 2.0
                        optimizedConfig = optimizedConfig.replace(
                            /(event\s+authentication-failure\s+match-first(?:[\s\S](?!event))*?)((?:\nevent|\n\S))/m,
                            '$1 10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n  10 clear-authenticated-data-hosts-on-port\n  20 activate service-template CRITICAL_DATA_ACCESS\n  30 activate service-template CRITICAL_VOICE_ACCESS\n  40 authorize\n  50 pause reauthentication\n 20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n  10 pause reauthentication\n  20 authorize$2'
                        );

                        // Add aaa-available event to policy map if IBNS 2.0
                        optimizedConfig = optimizedConfig.replace(
                            /(policy-map\s+type\s+control\s+subscriber\s+[\w-]+(?:[\s\S](?!policy-map))*?)(\n\S)/m,
                            '$1\n event aaa-available match-all\n  10 class IN_CRITICAL_AUTH do-until-failure\n   10 clear-session\n  20 class NOT_IN_CRITICAL_AUTH do-until-failure\n   10 resume reauthentication$2'
                        );
                    }

                    changes.push({
                        type: 'redundancy',
                        category: 'Critical Authentication',
                        description: 'Added critical authentication support',
                        impact: 'Provides network access during RADIUS server failures'
                    });
                }
            }

            // Add RADIUS server deadtime if missing
            if (!config.includes('deadtime')) {
                optimizedConfig = optimizedConfig.replace(
                    /(aaa\s+group\s+server\s+radius\s+[\w-]+\s+(?:[\s\S](?!aaa\s+group))*?)(\n\S)/gm,
                    '$1\n deadtime 15$2'
                );

                changes.push({
                    type: 'redundancy',
                    category: 'RADIUS Deadtime',
                    description: 'Added RADIUS server deadtime of 15 minutes',
                    impact: 'Improves failover by skipping dead servers'
                });
            }

            // Add RADIUS dead criteria if missing
            if (!config.includes('dead-criteria')) {
                const insertPoint = this.findInsertionPoint(config, 'radius_global');
                if (insertPoint !== -1) {
                    const deadCriteriaConfig = `
radius-server dead-criteria time 5 tries 3`;

                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + deadCriteriaConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'redundancy',
                        category: 'RADIUS Dead Criteria',
                        description: 'Added RADIUS server dead detection criteria',
                        impact: 'Faster detection of RADIUS server failures'
                    });
                }
            }

            // Add Change of Authorization (CoA) support if missing
            if (!config.includes('dynamic-author') && !config.includes('server radius dynamic')) {
                const hasTwoRadiusServers = config.match(/radius[\s-]server[\s\w]+[\r\n]+(?:.*[\r\n]+){1,10}?radius[\s-]server[\s\w]+/m);
                if (hasTwoRadiusServers) {
                    let coaConfig = `
aaa server radius dynamic-author`;

                    // Extract server IPs and keys
                    const serverIpMatches = config.match(/address\s+ipv4\s+(\d+\.\d+\.\d+\.\d+)/g);
                    const serverKeyMatches = config.match(/key\s+([^\s]+)/g);

                    if (serverIpMatches && serverKeyMatches && serverIpMatches.length >= 1 && serverKeyMatches.length >= 1) {
                        // Extract first server IP and key
                        const firstServerIp = serverIpMatches[0].match(/(\d+\.\d+\.\d+\.\d+)/)[1];
                        const firstServerKey = serverKeyMatches[0].match(/key\s+([^\s]+)/)[1];

                        coaConfig += `
 client ${firstServerIp} server-key ${firstServerKey}`;

                        // Add second server if available
                        if (serverIpMatches.length >= 2 && serverKeyMatches.length >= 2) {
                            const secondServerIp = serverIpMatches[1].match(/(\d+\.\d+\.\d+\.\d+)/)[1];
                            const secondServerKey = serverKeyMatches[1].match(/key\s+([^\s]+)/)[1];

                            coaConfig += `
 client ${secondServerIp} server-key ${secondServerKey}`;
                        }

                        coaConfig += `
 auth-type any`;

                        const insertPoint = this.findInsertionPoint(config, 'global_config');
                        if (insertPoint !== -1) {
                            const beforeInsert = optimizedConfig.substring(0, insertPoint);
                            const afterInsert = optimizedConfig.substring(insertPoint);
                            optimizedConfig = beforeInsert + coaConfig + '\n' + afterInsert;

                            changes.push({
                                type: 'redundancy',
                                category: 'Change of Authorization',
                                description: 'Added CoA support for dynamic policy changes',
                                impact: 'Enables remote session termination and policy updates'
                            });
                        }
                    }
                }
            }

            return { config: optimizedConfig, changes: changes };
        },

        /**
         * Perform compliance optimizations
         * @param {string} config - The configuration text
         * @param {string} vendor - Detected vendor
         * @param {string} level - Optimization level
         * @returns {Object} Optimization results
         */
        performComplianceOptimizations: function(config, vendor, level) {
            let optimizedConfig = config;
            const changes = [];

            // Add accounting if missing
            if (!config.includes('aaa accounting')) {
                const insertPoint = this.findInsertionPoint(config, 'aaa_config');
                if (insertPoint !== -1) {
                    const accountingConfig = `
aaa accounting update newinfo periodic 1440
aaa accounting dot1x default start-stop group ${config.match(/aaa\s+group\s+server\s+radius\s+([\w-]+)/)?.[1] || 'radius'}
aaa accounting network default start-stop group ${config.match(/aaa\s+group\s+server\s+radius\s+([\w-]+)/)?.[1] || 'radius'}`;

                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + accountingConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'compliance',
                        category: 'Accounting',
                        description: 'Added accounting configuration',
                        impact: 'Enhanced audit trail and compliance with security standards'
                    });
                }
            }

            // Add authorization if missing
            if (!config.includes('aaa authorization network')) {
                const insertPoint = this.findInsertionPoint(config, 'aaa_config');
                if (insertPoint !== -1) {
                    const authorizationConfig = `
aaa authorization network default group ${config.match(/aaa\s+group\s+server\s+radius\s+([\w-]+)/)?.[1] || 'radius'}`;

                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + authorizationConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'compliance',
                        category: 'Authorization',
                        description: 'Added network authorization configuration',
                        impact: 'Enhanced access control and compliance with security standards'
                    });
                }
            }

            // Add VSA attributes if missing
            if (!config.includes('radius-server vsa send')) {
                const insertPoint = this.findInsertionPoint(config, 'radius_global');
                if (insertPoint !== -1) {
                    const vsaConfig = `
radius-server vsa send authentication
radius-server vsa send accounting`;

                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + vsaConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'compliance',
                        category: 'RADIUS VSA',
                        description: 'Added RADIUS VSA support',
                        impact: 'Enhanced attribute support for vendor-specific features'
                    });
                }
            }

            // Add NAS attributes if missing
            if (!config.includes('radius-server attribute')) {
                const insertPoint = this.findInsertionPoint(config, 'radius_global');
                if (insertPoint !== -1) {
                    const attributeConfig = `
radius-server attribute 6 on-for-login-auth
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only`;

                    const beforeInsert = optimizedConfig.substring(0, insertPoint);
                    const afterInsert = optimizedConfig.substring(insertPoint);
                    optimizedConfig = beforeInsert + attributeConfig + '\n' + afterInsert;

                    changes.push({
                        type: 'compliance',
                        category: 'RADIUS Attributes',
                        description: 'Added RADIUS attribute configuration',
                        impact: 'Enhanced attribute support for better authentication and accounting'
                    });
                }
            }

            return { config: optimizedConfig, changes: changes };
        },

        /**
         * Apply recommended changes to configuration
         */
        applyRecommendations: function() {
            // This would apply all recommendations to the configuration
            // For now, just call optimizeConfiguration
            this.optimizeConfiguration();
        },

        /**
         * Fix security issues in configuration
         */
        fixSecurityIssues: function() {
            // This would fix identified security issues
            // For now, just call optimizeConfiguration with security focus
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;

            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }

            // Show loading indicator
            this.showLoadingIndicator('Fixing security issues...');

            // Determine the vendor from the configuration
            const vendor = this.detectVendorFromConfig(config);

            // Perform security optimizations only
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();

                // Perform security optimizations
                const securityChanges = this.performSecurityOptimizations(config, vendor, 'aggressive');

                // Update configuration output
                configOutput.value = securityChanges.config;

                // Show optimization success message
                this.showOptimizationSuccess({ changes: securityChanges.changes });

                // Update security analysis
                this.performSecurityAnalysis();
            }, 1500);
        },

        /**
         * Show optimization success message
         * @param {Object} results - Optimization results
         */
        showOptimizationSuccess: function(results) {
            // Create popup if it doesn't exist
            let optimizationResultsContent = document.getElementById('optimizationResultsContent');

            if (!optimizationResultsContent) {
                // Create the optimization results content area
                optimizationResultsContent = document.createElement('div');
                optimizationResultsContent.id = 'optimizationResultsContent';
                document.querySelector('.optimization-results').appendChild(optimizationResultsContent);
            }

            // Generate content
            let html = `
                <div class="optimization-summary">
                    <p><i class="fas fa-check-circle"></i> Optimization complete with ${results.changes.length} improvements applied.</p>
                </div>

                <h3>Applied Changes</h3>
                <ul class="changes-list">
            `;

            // Group changes by type
            const changesByType = {};
            results.changes.forEach(change => {
                if (!changesByType[change.type]) {
                    changesByType[change.type] = [];
                }
                changesByType[change.type].push(change);
            });

            // Add changes to list
            for (const [type, changes] of Object.entries(changesByType)) {
                html += `<li class="change-type"><strong>${type.charAt(0).toUpperCase() + type.slice(1)} Improvements:</strong><ul>`;

                changes.forEach(change => {
                    html += `<li>${change.description}</li>`;
                });

                html += `</ul></li>`;
            }

            html += `
                </ul>

                <p>The configuration has been updated with these changes. You can review the changes in the configuration output.</p>
            `;

            // Update content
            optimizationResultsContent.innerHTML = html;

            // Show results
            document.querySelector('.optimization-results').classList.remove('hidden');

            // Create toast notification
            const toastDiv = document.createElement('div');
            toastDiv.className = 'toast-notification';
            toastDiv.innerHTML = `
                <div class="toast-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="toast-message">
                    Configuration optimized successfully with ${results.changes.length} improvements
                </div>
            `;

            document.body.appendChild(toastDiv);

            // Auto-hide toast after 5 seconds
            setTimeout(() => {
                toastDiv.classList.add('toast-hide');
                setTimeout(() => {
                    toastDiv.remove();
                }, 500);
            }, 5000);
        },

        /**
         * Find insertion point in config for a specific section
         * @param {string} config - Configuration text
         * @param {string} section - Section to find insertion point for
         * @returns {number} Insertion point index
         */
        findInsertionPoint: function(config, section) {
            switch (section) {
                case 'global_config_top':
                    // Insert at the very beginning of global config (after any version/hostname)
                    const topMatch = config.match(/(?:^|\n)(?:version\s+[\d\.]+|hostname\s+[\w-]+|no\s+service\s+pad)(?:[\s\S]*?)(\n\S)/m);
                    return topMatch ? config.indexOf(topMatch[1]) : 0;

                case 'global_config':
                    // Insert in global config section (after aaa new-model)
                    const globalMatch = config.match(/aaa\s+new-model(?:[\s\S]*?)(\n\S)/m);
                    return globalMatch ? config.indexOf(globalMatch[1]) :
                           (config.indexOf('aaa new-model') !== -1 ? config.indexOf('aaa new-model') + 'aaa new-model'.length : 0);

                case 'aaa_config':
                    // Insert in AAA config section
                    const aaaMatch = config.match(/aaa\s+authorization(?:[\s\S]*?)(\n\S)/m) ||
                                     config.match(/aaa\s+authentication(?:[\s\S]*?)(\n\S)/m);
                    return aaaMatch ? config.indexOf(aaaMatch[1]) :
                           (config.indexOf('aaa new-model') !== -1 ? config.indexOf('aaa new-model') + 'aaa new-model'.length : 0);

                case 'radius_global':
                    // Insert in RADIUS global config section
                    const radiusMatch = config.match(/radius-server(?:[\s\S]*?)(\n\S)/m);
                    return radiusMatch ? config.indexOf(radiusMatch[1]) :
                           (config.indexOf('aaa group server radius') !== -1 ?
                            config.indexOf('aaa group server radius') + config.substring(config.indexOf('aaa group server radius')).indexOf('\n!') : 0);

                case 'global_security':
                    // Insert in global security config section (after dot1x system-auth-control)
                    const securityMatch = config.match(/dot1x\s+system-auth-control(?:[\s\S]*?)(\n\S)/m);
                    return securityMatch ? config.indexOf(securityMatch[1]) :
                           (config.indexOf('dot1x system-auth-control') !== -1 ?
                            config.indexOf('dot1x system-auth-control') + 'dot1x system-auth-control'.length : 0);

                case 'global_acl':
                    // Insert in global ACL section (before interface configs)
                    const aclMatch = config.match(/ip\s+access-list(?:[\s\S]*?)(\n\S)/m);
                    const interfaceMatch = config.match(/\ninterface/);
                    return aclMatch ? config.indexOf(aclMatch[1]) :
                           (interfaceMatch ? config.indexOf('\ninterface') : 0);

                case 'class_maps':
                    // Insert in class-map section
                    const classMapMatch = config.match(/class-map(?:[\s\S]*?)(\n\S)/m);
                    return classMapMatch ? config.indexOf(classMapMatch[1]) :
                           (config.indexOf('class-map') !== -1 ?
                            config.indexOf('class-map') + config.substring(config.indexOf('class-map')).indexOf('\n!') : 0);

                default:
                    return 0;
            }
        },

        /**
         * Detect vendor from configuration
         * @param {string} config - Configuration text
         * @returns {string} Detected vendor
         */
        detectVendorFromConfig: function(config) {
            if (config.includes('Cisco') || config.includes('cisco') ||
                config.includes('ios') || config.includes('IOS')) {
                return 'cisco';
            } else if (config.includes('Aruba') || config.includes('aruba') ||
                      config.includes('hp') || config.includes('HP')) {
                return 'aruba';
            } else if (config.includes('Juniper') || config.includes('juniper') ||
                      config.includes('junos') || config.includes('JUNOS')) {
                return 'juniper';
            } else if (config.includes('Fortinet') || config.includes('fortinet') ||
                      config.includes('fortigate') || config.includes('FortiGate')) {
                return 'fortinet';
            } else if (config.includes('Extreme') || config.includes('extreme') ||
                      config.includes('EXOS') || config.includes('exos')) {
                return 'extreme';
            } else if (config.includes('Dell') || config.includes('dell') ||
                      config.includes('OS10') || config.includes('os10')) {
                return 'dell';
            } else {
                // Default to Cisco if vendor cannot be determined
                return 'cisco';
            }
        },

        /**
         * Extract configuration parameters from config
         * @param {string} config - Configuration text
         * @returns {Object} Configuration parameters
         */
        extractConfigParameters: function(config) {
            const params = {
                vendor: this.detectVendorFromConfig(config),
                platform: '',
                authentication: {
                    methods: []
                },
                radius: {
                    servers: [],
                    serverGroup: '',
                    timeout: 0,
                    retransmit: 0
                },
                tacacs: {
                    servers: [],
                    serverGroup: ''
                },
                interfaces: {
                    accessPorts: [],
                    trunkPorts: []
                }
            };

            // Detect platform
            if (config.includes('IOS-XE')) {
                params.platform = 'IOS-XE';
            } else if (config.includes('IOS')) {
                params.platform = 'IOS';
            } else if (config.includes('WLC') || config.includes('wireless')) {
                params.platform = 'WLC';
            } else if (config.includes('AOS-CX')) {
                params.platform = 'AOS-CX';
            } else if (config.includes('AOS-Switch')) {
                params.platform = 'AOS-Switch';
            }

            // Detect authentication methods
            if (config.includes('dot1x')) {
                params.authentication.methods.push('dot1x');
            }
            if (config.includes('mab')) {
                params.authentication.methods.push('mab');
            }
            if (config.includes('webauth') || config.includes('web-auth')) {
                params.authentication.methods.push('webauth');
            }

            // Extract RADIUS server group
            const serverGroupMatch = config.match(/aaa\s+group\s+server\s+radius\s+([\w-]+)/);
            if (serverGroupMatch) {
                params.radius.serverGroup = serverGroupMatch[1];
            }

            // Extract RADIUS timeout
            const timeoutMatch = config.match(/timeout\s+(\d+)/);
            if (timeoutMatch) {
                params.radius.timeout = parseInt(timeoutMatch[1]);
            }

            // Extract RADIUS retransmit
            const retransmitMatch = config.match(/retransmit\s+(\d+)/);
            if (retransmitMatch) {
                params.radius.retransmit = parseInt(retransmitMatch[1]);
            }

            return params;
        },

        /**
         * Show loading indicator
         * @param {string} message - Loading message
         */
        showLoadingIndicator: function(message) {
            // Create loading indicator if it doesn't exist
            if (!document.getElementById('aiLoadingIndicator')) {
                const loadingDiv = document.createElement('div');
                loadingDiv.id = 'aiLoadingIndicator';
                loadingDiv.className = 'ai-loading-indicator';

                const spinnerDiv = document.createElement('div');
                spinnerDiv.className = 'ai-spinner';
                spinnerDiv.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i>';

                const messageDiv = document.createElement('div');
                messageDiv.id = 'aiLoadingMessage';
                messageDiv.className = 'ai-loading-message';

                loadingDiv.appendChild(spinnerDiv);
                loadingDiv.appendChild(messageDiv);

                // Add to body
                document.body.appendChild(loadingDiv);
            }

            // Update message and show
            document.getElementById('aiLoadingMessage').textContent = message;
            document.getElementById('aiLoadingIndicator').style.display = 'flex';
        },

        /**
         * Hide loading indicator
         */
        hideLoadingIndicator: function() {
            const loadingIndicator = document.getElementById('aiLoadingIndicator');
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }
        },

        /**
         * Get impact description for severity
         * @param {string} severity - Severity level
         * @returns {string} Impact description
         */
        getImpactDescription: function(severity) {
            switch (severity) {
                case 'critical':
                    return 'Critical vulnerability that could lead to network compromise';
                case 'high':
                    return 'High risk issue that could significantly impact security';
                case 'medium':
                    return 'Medium risk issue that could moderately impact security';
                case 'low':
                    return 'Low risk issue with minimal security impact';
                default:
                    return 'Unknown impact';
            }
        },

        /**
         * Get impact for severity
         * @param {string} severity - Severity level
         * @returns {string} Impact level
         */
        getImpactForSeverity: function(severity) {
            switch (severity) {
                case 'critical':
                    return 'critical';
                case 'high':
                    return 'high';
                case 'medium':
                    return 'medium';
                case 'low':
                    return 'low';
                default:
                    return 'low';
            }
        },

        /**
         * Get severity for importance
         * @param {string} importance - Importance level
         * @returns {string} Severity level
         */
        getSeverityForImportance: function(importance) {
            switch (importance) {
                case 'high':
                    return 'high';
                case 'medium':
                    return 'medium';
                case 'low':
                    return 'low';
                default:
                    return 'low';
            }
        },

        /**
         * Update security scores on the UI
         * @param {Object} analysisResults - Analysis results
         */
        updateSecurityScores: function(analysisResults) {
            // Update security score
            const securityScoreElement = document.getElementById('securityScoreValue');
            if (securityScoreElement) {
                securityScoreElement.textContent = analysisResults.security.score;
            }

            // Update security score circle color
            this.updateSecurityScoreColor(analysisResults.security.score);
        }
    };

    // Add styles for AI Analyzer
    function addAIAnalyzerStyles() {
        const styleElement = document.createElement('style');
        styleElement.textContent = `
            /* AI Loading Indicator */
            .ai-loading-indicator {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.7);
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                z-index: 2000;
            }

            .ai-spinner {
                color: white;
                font-size: 48px;
                margin-bottom: 20px;
            }

            .ai-loading-message {
                color: white;
                font-size: 18px;
            }

            /* Severity Badges */
            .severity-badge {
                display: inline-block;
                padding: 4px 8px;
                border-radius: 3px;
                font-size: 12px;
                font-weight: bold;
                text-transform: uppercase;
                color: white;
            }

            .severity-badge.critical {
                background-color: #e74c3c;
            }

            .severity-badge.high {
                background-color: #e67e22;
            }

            .severity-badge.medium {
                background-color: #f39c12;
            }

            .severity-badge.low {
                background-color: #3498db;
            }

            /* Issues List */
            .issues-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .issue-item {
                margin-bottom: 10px;
                padding: 10px;
                background-color: #f9f9f9;
                border-radius: 4px;
                border-left: 4px solid #ddd;
            }

            .issue-item.critical {
                border-left-color: #e74c3c;
            }

            .issue-item.high {
                border-left-color: #e67e22;
            }

            .issue-item.medium {
                border-left-color: #f39c12;
            }

            .issue-item.low {
                border-left-color: #3498db;
            }

            .issue-header {
                display: flex;
                align-items: center;
                margin-bottom: 5px;
            }

            .issue-title {
                margin-left: 10px;
                font-weight: 500;
            }

            .issue-details {
                margin-left: 54px;
                font-size: 14px;
            }

            .issue-details p {
                margin: 5px 0;
            }

            /* Recommendations List */
            .recommendations-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .recommendation-item {
                margin-bottom: 15px;
                padding: 10px;
                background-color: #f9f9f9;
                border-radius: 4px;
                border-left: 4px solid #3498db;
            }

            .recommendation-header {
                display: flex;
                align-items: center;
                margin-bottom: 10px;
            }

            .recommendation-title {
                margin-left: 10px;
                font-weight: 500;
            }

            .recommendation-details {
                margin-left: 5px;
            }

            .recommendation-config {
                margin: 10px 0;
                padding: 10px;
                background-color: #2c3e50;
                color: #ecf0f1;
                border-radius: 4px;
                font-family: monospace;
                font-size: 12px;
                white-space: pre;
                overflow-x: auto;
            }

            /* Changes List */
            .changes-list {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .change-type {
                margin-bottom: 15px;
            }

            .change-type ul {
                margin-top: 5px;
                padding-left: 20px;
            }

            .change-type ul li {
                margin-bottom: 5px;
            }

            /* Toast Notification */
            .toast-notification {
                position: fixed;
                bottom: 20px;
                right: 20px;
                background-color: #27ae60;
                color: white;
                padding: 15px 20px;
                border-radius: 4px;
                display: flex;
                align-items: center;
                gap: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
                z-index: 1000;
                animation: fadeIn 0.3s;
            }

            .toast-icon {
                font-size: 24px;
            }

            .toast-message {
                font-size: 16px;
            }

            .toast-hide {
                animation: fadeOut 0.5s;
            }

            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }

            @keyframes fadeOut {
                from { opacity: 1; transform: translateY(0); }
                to { opacity: 0; transform: translateY(20px); }
            }

            /* Optimization Results */
            .optimization-results {
                background-color: #f9f9f9;
                border: 1px solid #ddd;
                border-radius: 4px;
                padding: 15px;
                margin-top: 20px;
                margin-bottom: 20px;
            }

            .optimization-summary {
                margin-bottom: 15px;
                font-weight: 500;
                color: #27ae60;
            }

            .optimization-summary i {
                margin-right: 5px;
            }
        `;
        document.head.appendChild(styleElement);
    }

    // Initialize AI Analyzer on page load
    document.addEventListener('DOMContentLoaded', function() {
        // Add styles for AI Analyzer
        addAIAnalyzerStyles();

        // Initialize AI Analyzer
        AIAnalyzer.init();
    });

    // Export to window
    window.AIAnalyzer = AIAnalyzer;
})();
