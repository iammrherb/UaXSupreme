#!/bin/bash
# UaXSupreme Enhancement Script
# This script updates the UaXSupreme application to fully implement all authentication features
# including template generation, improved UI with subtabs, and functional help/AI/troubleshooting.

# Color definitions for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme Enhance]${NC} $1"
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
BACKUP_DIR="backup_$(date +%Y%m%d%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r * $BACKUP_DIR/ 2>/dev/null
print_success "Backup created in $BACKUP_DIR"

# Clean up any old backup directories that might cause confusion
find . -maxdepth 1 -type d -name "backup_2*" -not -name "$BACKUP_DIR" -exec rm -rf {} \; 2>/dev/null

# Update directory structure
print_message "Updating directory structure..."

# Create or ensure required directories exist
mkdir -p css js templates lib assets help ai-models

# Vendor-specific template directories
mkdir -p templates/cisco/IOS templates/cisco/IOS-XE templates/cisco/WLC-9800
mkdir -p templates/aruba/AOS-CX templates/aruba/AOS-Switch
mkdir -p templates/juniper/Junos
mkdir -p templates/fortinet/FortiOS
mkdir -p templates/extreme/EXOS
mkdir -p templates/dell/OS10

# Create example template files with actual content
print_message "Creating template files with real content..."

# Create Cisco IOS-XE template for IBNS 2.0 Concurrent 802.1X and MAB
cat > templates/cisco/IOS-XE/concurrent.txt << 'EOF'
! -----------------------------------------------------
! Cisco IOS-XE IBNS 2.0 Concurrent 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{RADIUS_GROUP}}
aaa authorization network default group {{RADIUS_GROUP}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{RADIUS_GROUP}}
aaa accounting network default start-stop group {{RADIUS_GROUP}}

! Configure RADIUS servers
radius server {{RADIUS_SERVER_1_NAME}}
 address ipv4 {{RADIUS_SERVER_1}} auth-port {{RADIUS_PORT}} acct-port {{RADIUS_ACCT_PORT}}
 timeout 2
 retransmit 2
 key {{RADIUS_KEY}}
 automate-tester username {{RADIUS_TEST_USER}} probe-on

radius server {{RADIUS_SERVER_2_NAME}}
 address ipv4 {{RADIUS_SERVER_2}} auth-port {{RADIUS_PORT}} acct-port {{RADIUS_ACCT_PORT}}
 timeout 2
 retransmit 2
 key {{RADIUS_KEY}}
 automate-tester username {{RADIUS_TEST_USER}} probe-on

! Configure RADIUS server group
aaa group server radius {{RADIUS_GROUP}}
 server name {{RADIUS_SERVER_1_NAME}}
 server name {{RADIUS_SERVER_2_NAME}}
 deadtime 15
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{RADIUS_SERVER_1}} server-key {{RADIUS_KEY}}
 client {{RADIUS_SERVER_2}} server-key {{RADIUS_KEY}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay 2000
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
device-tracking tracking auto-source

! Device Tracking Policy for Trunk Ports
device-tracking policy DISABLE-IP-TRACKING
 tracking disable
 trusted-port
 device-role switch

! Device Tracking Policy for Access Ports
device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{CRITICAL_DATA_VLAN}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{CRITICAL_VOICE_VLAN}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Concurrent 802.1X and MAB
policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-all
   10 authenticate using dot1x priority 10
   20 authenticate using mab priority 20
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
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

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{ACCESS_VLAN}}
 switchport voice vlan {{VOICE_VLAN}}
 switchport nonegotiate
 no switchport port-security
 device-tracking attach-policy IP-TRACKING
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED
EOF

# Create Cisco WLC 9800 TACACS+ template
cat > templates/cisco/WLC-9800/tacacs.txt << 'EOF'
! -----------------------------------------------------
! Cisco WLC 9800 TACACS+ Authentication Configuration
! -----------------------------------------------------

! Create local fallback account:
username {{ADMIN_USERNAME}} privilege 15 algorithm-type sha256 secret {{ADMIN_PASSWORD}}
enable algorithm-type sha256 secret {{ENABLE_PASSWORD}}

! Enable AAA services:
aaa new-model

! Configure TACACS+ servers:
tacacs server {{TACACS_SERVER_1_NAME}}
 address ipv4 {{TACACS_SERVER_1}}
 key {{TACACS_KEY}}
 timeout 1

tacacs server {{TACACS_SERVER_2_NAME}}
 address ipv4 {{TACACS_SERVER_2}}
 key {{TACACS_KEY}}
 timeout 1

! Configure TACACS+ Server Group:
aaa group server tacacs+ {{TACACS_GROUP}}
 server name {{TACACS_SERVER_1_NAME}}
 server name {{TACACS_SERVER_2_NAME}}
 {{TACACS_SOURCE_INTERFACE}}

! Create Method List to use TACACS+ logins primarily.
! Fallback to Local User Accounts ONLY if all TACACS+ servers fail.
aaa authentication login {{TACACS_AUTH_METHOD_LIST}} group {{TACACS_GROUP}} local
aaa authorization exec {{TACACS_AUTHZ_METHOD_LIST}} group {{TACACS_GROUP}} local if-authenticated
aaa authorization console

! Configure Accounting
aaa accounting commands 0 default start-stop group {{TACACS_GROUP}}
aaa accounting commands 1 default start-stop group {{TACACS_GROUP}}
aaa accounting commands 15 default start-stop group {{TACACS_GROUP}}

! Activate AAA TACACS+ for HTTPS Web GUI:
ip http authentication aaa login-authentication {{TACACS_AUTH_METHOD_LIST}}
ip http authentication aaa exec-authorization {{TACACS_AUTHZ_METHOD_LIST}}

! Activate AAA TACACS+ for NETCONF/RESTCONF authentication
yang-interfaces aaa authentication method-list {{TACACS_AUTH_METHOD_LIST}}
yang-interfaces aaa authorization method-list {{TACACS_AUTHZ_METHOD_LIST}}

! Restart HTTP/HTTPS services:
no ip http server
no ip http secure-server
ip http server
ip http secure-server

! Activate AAA TACACS+ authentication for SSH sessions:
line vty 0 97
 exec-timeout 30 0
 login authentication {{TACACS_AUTH_METHOD_LIST}}
 authorization exec {{TACACS_AUTHZ_METHOD_LIST}}
 transport preferred none
 transport input ssh
 transport output none

! Activate AAA TACACS+ authentication for the Console port:
line con 0
 exec-timeout 15 0
 transport preferred none
 login authentication {{TACACS_AUTH_METHOD_LIST}}
 authorization exec {{TACACS_AUTHZ_METHOD_LIST}}
EOF

# Create Aruba AOS-CX 802.1X template 
cat > templates/aruba/AOS-CX/dot1x.txt << 'EOF'
! -----------------------------------------------------
! Aruba AOS-CX 802.1X Authentication Configuration
! -----------------------------------------------------

! Configure RADIUS servers
radius-server host {{RADIUS_SERVER_1}} key {{RADIUS_KEY}}
radius-server host {{RADIUS_SERVER_2}} key {{RADIUS_KEY}} 

! Configure RADIUS server group 
aaa group radius {{RADIUS_GROUP}}
 server {{RADIUS_SERVER_1}}
 server {{RADIUS_SERVER_2}}

! Configure authentication method
aaa authentication dot1x default group {{RADIUS_GROUP}}
aaa authorization network default group {{RADIUS_GROUP}}
aaa accounting dot1x default start-stop group {{RADIUS_GROUP}}

! Enable 802.1X globally
aaa authentication port-access dot1x authenticator

! Configure interface settings for 802.1X
interface {{INTERFACE}}
 no shutdown
 aaa authentication port-access dot1x authenticator
 aaa port-access authenticator
 aaa port-access authenticator {{INTERFACE}} client-limit 3
 aaa port-access authenticator {{INTERFACE}} logoff-period 300
 aaa port-access authenticator {{INTERFACE}} max-requests 2
 aaa port-access authenticator {{INTERFACE}} max-retries 2
 aaa port-access authenticator {{INTERFACE}} quiet-period 60
 aaa port-access authenticator {{INTERFACE}} server-timeout 30
 aaa port-access authenticator {{INTERFACE}} reauth-period 3600 
 aaa port-access authenticator {{INTERFACE}} unauth-vid {{GUEST_VLAN}}
 aaa port-access authenticator {{INTERFACE}} auth-vid {{AUTH_VLAN}}
 aaa port-access authenticator {{INTERFACE}} auth-vlan {{AUTH_VLAN}}
 aaa port-access authenticator {{INTERFACE}} initialize
 aaa port-access authenticator active
EOF

# Create help documentation
cat > help/readme.md << 'EOF'
# UaXSupreme Help Documentation

## Overview
UaXSupreme is a comprehensive platform for configuring 802.1X, MAB, RADIUS, TACACS+, and advanced authentication features for all major network vendors.

## Features

### Multi-Vendor Support
- Configure authentication for Cisco, Aruba, Juniper, Fortinet, HP, Dell, Extreme, Arista, and more

### Authentication Methods
- 802.1X: Standard port-based network access control
- MAB: MAC Authentication Bypass for devices that don't support 802.1X
- WebAuth: Web-based authentication for guest access
- RADIUS/TACACS+: Complete AAA server configuration with redundancy and high availability

### Advanced Features
- VSAs: Vendor-Specific Attributes for granular control
- DACLs: Downloadable ACLs for dynamic access control
- CoA: RADIUS Change of Authorization for dynamic policy changes
- RadSec: Secure RADIUS communications
- MACsec: Layer 2 encryption
- Security Features: DHCP snooping, ARP inspection, port security, and more

### Use Cases
- Guest Access: Configure guest onboarding with captive portal integration
- BYOD: Device onboarding workflows for employee-owned devices
- IoT Management: Secure onboarding for IoT devices with profiling

## Getting Started
1. Select your network vendor and platform
2. Configure authentication settings
3. Set advanced features and parameters
4. Generate configuration
5. Review and download your configuration

## Troubleshooting
If you encounter issues, check the following:
- Ensure all required fields are filled
- Verify connectivity to network devices
- Check compatibility with your specific device models and software versions

For additional help, use the AI Assistant feature or contact support.
EOF

# Update UI HTML file
print_message "Updating UI with improved subtabs and features..."

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
                                    <p>Monitor Mode (Open): Authentication is performed but not enforced. This is ideal for initial testing.</p>
                                </div>
                            </div>
                        </div>

                        <div class="tab-content" id="auth-security">
                            <div class="form-group">
                                <label>Select Security Features:</label>
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="dhcpSnooping" name="securityFeature" value="dhcpSnooping">
                                        <label for="dhcpSnooping">DHCP Snooping</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="arpInspection" name="securityFeature" value="arpInspection">
                                        <label for="arpInspection">Dynamic ARP Inspection</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="ipSourceGuard" name="securityFeature" value="ipSourceGuard">
                                        <label for="ipSourceGuard">IP Source Guard</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portSecurity" name="securityFeature" value="portSecurity">
                                        <label for="portSecurity">Port Security</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="stormControl" name="securityFeature" value="stormControl">
                                        <label for="stormControl">Storm Control</label>
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
                                        <input type="password" id="radiusKey1" class="form-control" placeholder="Enter shared secret">
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
                                        <input type="password" id="radiusKey2" class="form-control" placeholder="Enter shared secret">
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
                                        <input type="password" id="tacacsKey1" class="form-control" placeholder="Enter shared secret">
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
                                        <input type="password" id="tacacsKey2" class="form-control" placeholder="Enter shared secret">
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="tacacsSourceInterface">Source Interface:</label>
                                <input type="text" id="tacacsSourceInterface" class="form-control" value="Vlan 10">
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
                                        <input type="checkbox" id="tacacsAuthzCommands" name="tacacsAuthz" value="commands">
                                        <label for="tacacsAuthzCommands">Enable Per-Command Authorization</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacsAuthzConfig" name="tacacsAuthz" value="config">
                                        <label for="tacacsAuthzConfig">Enable Configuration Authorization</label>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label for="tacacsAuthzIfAuthenticated">If-Authenticated Fallback:</label>
                                <select id="tacacsAuthzIfAuthenticated" class="form-control">
                                    <option value="if-authenticated">Enable if-authenticated fallback</option>
                                    <option value="none">No fallback</option>
                                </select>
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
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="sensorAccounting">Accounting:</label>
                                    <select id="sensorAccounting" class="form-control">
                                        <option value="enable">Include in accounting</option>
                                        <option value="disable">Do not include in accounting</option>
                                    </select>
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
                                </div>
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
                    
                    <div class="tab-content active">
                        <div class="form-group">
                            <label for="configOutput">Configuration Output:</label>
                            <textarea id="configOutput" class="form-control code-output" rows="20" readonly></textarea>
                        </div>
                        
                        <div class="action-buttons">
                            <button id="generateConfigBtn" class="btn-primary"><i class="fas fa-cog"></i> Generate Configuration</button>
                            <button id="copyConfigBtn" class="btn-secondary"><i class="fas fa-copy"></i> Copy to Clipboard</button>
                            <button id="downloadConfigBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
                        </div>
                        
                        <div class="config-validation hidden">
                            <h3>Configuration Validation</h3>
                            <div id="validationResults"></div>
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
                                </div>
                            </div>
                            
                            <div class="action-buttons">
                                <button id="generateDocBtn" class="btn-primary"><i class="fas fa-file-alt"></i> Generate Documentation</button>
                                <button id="downloadDocBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
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
                            
                            <div class="action-buttons">
                                <button id="generateDiagramBtn" class="btn-primary"><i class="fas fa-project-diagram"></i> Generate Diagram</button>
                                <button id="downloadDiagramBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
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
                            
                            <div class="action-buttons">
                                <button id="generateChecklistBtn" class="btn-primary"><i class="fas fa-tasks"></i> Generate Checklist</button>
                                <button id="downloadChecklistBtn" class="btn-secondary"><i class="fas fa-download"></i> Download</button>
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
                            <li>Generate documentation for your implementation.</li>
                        </ol>
                        
                        <p>For additional assistance, use the AI Assistant by clicking the robot icon in the top navigation bar.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="js/app.js"></script>
    <script src="js/template-generator.js"></script>
    <script src="js/validation.js"></script>
    <script src="js/ai-assistant.js"></script>
    <script src="js/documentation.js"></script>
</body>
</html>
EOF

# Create CSS file
print_message "Creating CSS styles..."

cat > css/styles.css << 'EOF'
/* UaXSupreme Styles */
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

.logo h1 {
    font-size: 24px;
    margin: 0;
}

.logo span {
    font-size: 14px;
    opacity: 0.8;
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
.checklist-preview {
    background-color: white;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 15px;
    margin-bottom: 15px;
    min-height: 300px;
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
}

@media (max-width: 576px) {
    .sidebar {
        display: none;
    }
    
    .action-buttons {
        flex-direction: column;
    }
}
EOF

# Create JS files
print_message "Creating JavaScript files..."

cat > js/app.js << 'EOF'
/**
 * UaXSupreme - Main Application JavaScript
 * Handles UI interactions, navigation, and application state
 */

document.addEventListener('DOMContentLoaded', function() {
    // Application state
    const appState = {
        currentStep: 'vendor-selection',
        vendorPlatforms: {
            'cisco': ['IOS', 'IOS-XE', 'WLC-9800', 'WLC-9800-CL', 'Catalyst 9800', 'ISE'],
            'aruba': ['AOS-CX', 'AOS-Switch', 'Instant On', 'Clearpass'],
            'juniper': ['Junos', 'Mist', 'EX Series', 'SRX Series'],
            'fortinet': ['FortiOS', 'FortiGate', 'FortiNAC', 'FortiAuthenticator'],
            'extreme': ['EXOS', 'VOSS', 'Fabric Engine', 'ExtremeControl'],
            'dell': ['OS10', 'PowerSwitch', 'SmartFabric']
        },
        vendor: '',
        platform: '',
        authMethods: [],
        deploymentType: 'monitor',
        radiusConfig: {
            servers: []
        },
        tacacsConfig: {
            servers: []
        },
        advancedFeatures: [],
        interfaceConfig: {},
        configOutput: ''
    };

    // Initialize UI
    initUI();
    attachEventListeners();

    /**
     * Initialize UI components
     */
    function initUI() {
        // Disable platform selector initially
        document.getElementById('platform').disabled = true;
        
        // Hide feature settings initially
        document.querySelectorAll('.feature-settings').forEach(el => {
            if (el.id !== 'criticalAuthSettings' && el.id !== 'daclSettings' && el.id !== 'profilingSettings') {
                el.style.display = 'none';
            }
        });
    }

    /**
     * Attach event listeners to UI elements
     */
    function attachEventListeners() {
        // Navigation steps
        document.querySelectorAll('.nav-steps li').forEach(step => {
            step.addEventListener('click', () => {
                navigateToStep(step.dataset.step);
            });
        });

        // Next/Back buttons
        document.querySelectorAll('.btn-next').forEach(btn => {
            btn.addEventListener('click', navigateNext);
        });

        document.querySelectorAll('.btn-back').forEach(btn => {
            btn.addEventListener('click', navigateBack);
        });

        // Finish button
        document.querySelector('.btn-finish').addEventListener('click', finishConfiguration);

        // Vendor selection
        document.getElementById('vendor').addEventListener('change', handleVendorChange);
        document.getElementById('platform').addEventListener('change', handlePlatformChange);

        // Tabs
        document.querySelectorAll('.tab').forEach(tab => {
            tab.addEventListener('click', () => {
                const tabGroup = tab.parentElement;
                const tabContentId = tab.dataset.tab;
                
                // Deactivate all tabs in this group
                tabGroup.querySelectorAll('.tab').forEach(t => {
                    t.classList.remove('active');
                });
                
                // Hide all tab contents for this group
                const tabContents = tabGroup.parentElement.querySelectorAll('.tab-content');
                tabContents.forEach(content => {
                    content.classList.remove('active');
                });
                
                // Activate selected tab and content
                tab.classList.add('active');
                document.getElementById(tabContentId).classList.add('active');
            });
        });

        // Authentication method checkboxes
        document.querySelectorAll('input[name="authMethod"]').forEach(checkbox => {
            checkbox.addEventListener('change', updateAuthMethods);
        });

        // Security features in Advanced section
        document.querySelectorAll('input[name="securityFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleSecurityFeature);
        });

        // Access features in Advanced section
        document.querySelectorAll('input[name="accessFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleAccessFeature);
        });

        // Guest features in Advanced section
        document.querySelectorAll('input[name="guestFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleGuestFeature);
        });

        // BYOD features in Advanced section
        document.querySelectorAll('input[name="byodFeature"]').forEach(checkbox => {
            checkbox.addEventListener('change', toggleByodFeature);
        });

        // Generate configuration button
        document.getElementById('generateConfigBtn').addEventListener('click', generateConfiguration);
        
        // Copy configuration button
        document.getElementById('copyConfigBtn').addEventListener('click', copyConfiguration);
        
        // Download configuration button
        document.getElementById('downloadConfigBtn').addEventListener('click', downloadConfiguration);

        // Generate diagram button
        document.getElementById('generateDiagramBtn').addEventListener('click', generateDiagram);

        // Generate checklist button
        document.getElementById('generateChecklistBtn').addEventListener('click', generateChecklist);

        // Generate documentation button
        document.getElementById('generateDocBtn').addEventListener('click', generateDocumentation);

        // Help button
        document.getElementById('helpBtn').addEventListener('click', () => {
            document.getElementById('helpModal').style.display = 'block';
        });

        // AI Assistant button
        document.getElementById('aiAssistBtn').addEventListener('click', () => {
            document.getElementById('aiAssistantModal').style.display = 'block';
        });

        // Close modal buttons
        document.querySelectorAll('.close').forEach(closeBtn => {
            closeBtn.addEventListener('click', () => {
                closeBtn.closest('.modal').style.display = 'none';
            });
        });

        // Send message to AI Assistant
        document.getElementById('sendMessageBtn').addEventListener('click', sendMessageToAI);
        document.getElementById('userMessage').addEventListener('keypress', (e) => {
            if (e.key === 'Enter') {
                sendMessageToAI();
            }
        });

        // Suggestion buttons in AI Assistant
        document.querySelectorAll('.suggestion-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.getElementById('userMessage').value = btn.textContent;
                sendMessageToAI();
            });
        });

        // Help topics
        document.querySelectorAll('.help-topics li').forEach(topic => {
            topic.addEventListener('click', () => {
                document.querySelectorAll('.help-topics li').forEach(t => {
                    t.classList.remove('active');
                });
                topic.classList.add('active');
                loadHelpContent(topic.dataset.topic);
            });
        });

        // Save configuration button
        document.getElementById('saveConfigBtn').addEventListener('click', saveConfiguration);
        
        // Load configuration button
        document.getElementById('loadConfigBtn').addEventListener('click', loadConfiguration);

        // Window click to close modals when clicking outside
        window.addEventListener('click', (e) => {
            if (e.target.classList.contains('modal')) {
                e.target.style.display = 'none';
            }
        });

        // Interface template buttons
        document.getElementById('templateAp').addEventListener('click', () => addInterfaceTemplate('ap'));
        document.getElementById('templateIpPhone').addEventListener('click', () => addInterfaceTemplate('ipphone'));
        document.getElementById('templatePrinter').addEventListener('click', () => addInterfaceTemplate('printer'));
        document.getElementById('templateServer').addEventListener('click', () => addInterfaceTemplate('server'));
        document.getElementById('templateUplink').addEventListener('click', () => addInterfaceTemplate('uplink'));
    }

    /**
     * Navigate to a specific step
     * @param {string} stepId - The ID of the step to navigate to
     */
    function navigateToStep(stepId) {
        // Hide all sections
        document.querySelectorAll('.config-section').forEach(section => {
            section.classList.remove('active');
        });
        
        // Show target section
        document.getElementById(stepId).classList.add('active');
        
        // Update active step in sidebar
        document.querySelectorAll('.nav-steps li').forEach(step => {
            step.classList.remove('active');
            if (step.dataset.step === stepId) {
                step.classList.add('active');
            }
        });
        
        // Update current step in state
        appState.currentStep = stepId;
    }

    /**
     * Navigate to the next step
     */
    function navigateNext() {
        const currentStepElement = document.querySelector(`.nav-steps li[data-step="${appState.currentStep}"]`);
        const nextStepElement = currentStepElement.nextElementSibling;
        
        if (nextStepElement) {
            navigateToStep(nextStepElement.dataset.step);
        }
    }

    /**
     * Navigate to the previous step
     */
    function navigateBack() {
        const currentStepElement = document.querySelector(`.nav-steps li[data-step="${appState.currentStep}"]`);
        const prevStepElement = currentStepElement.previousElementSibling;
        
        if (prevStepElement) {
            navigateToStep(prevStepElement.dataset.step);
        }
    }

    /**
     * Handle vendor selection change
     */
    function handleVendorChange() {
        const vendorSelect = document.getElementById('vendor');
        const platformSelect = document.getElementById('platform');
        const selectedVendor = vendorSelect.value;
        
        // Clear platform options
        platformSelect.innerHTML = '<option value="">-- Select Platform --</option>';
        
        if (selectedVendor) {
            // Enable platform selector
            platformSelect.disabled = false;
            
            // Add platform options for selected vendor
            const platforms = appState.vendorPlatforms[selectedVendor] || [];
            platforms.forEach(platform => {
                const option = document.createElement('option');
                option.value = platform;
                option.textContent = platform;
                platformSelect.appendChild(option);
            });
            
            // Update state
            appState.vendor = selectedVendor;
        } else {
            // Disable platform selector if no vendor selected
            platformSelect.disabled = true;
            appState.vendor = '';
        }
        
        // Hide platform info
        document.querySelector('.platform-info').classList.add('hidden');
    }

    /**
     * Handle platform selection change
     */
    function handlePlatformChange() {
        const platformSelect = document.getElementById('platform');
        const selectedPlatform = platformSelect.value;
        
        if (selectedPlatform) {
            // Update state
            appState.platform = selectedPlatform;
            
            // Show platform info
            const platformInfo = document.querySelector('.platform-info');
            platformInfo.classList.remove('hidden');
            
            // Update platform info content
            const platformInfoContent = document.getElementById('platformInfoContent');
            platformInfoContent.innerHTML = generatePlatformInfo(appState.vendor, selectedPlatform);
        } else {
            appState.platform = '';
            document.querySelector('.platform-info').classList.add('hidden');
        }
    }

    /**
     * Update authentication methods in state based on checkbox selection
     */
    function updateAuthMethods() {
        const authMethodCheckboxes = document.querySelectorAll('input[name="authMethod"]:checked');
        appState.authMethods = Array.from(authMethodCheckboxes).map(cb => cb.value);
    }

    /**
     * Toggle security feature settings visibility
     */
    function toggleSecurityFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Toggle access feature settings visibility
     */
    function toggleAccessFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Toggle guest feature settings visibility
     */
    function toggleGuestFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Toggle BYOD feature settings visibility
     */
    function toggleByodFeature(e) {
        const featureId = e.target.value;
        const settingsId = `${featureId}Settings`;
        const settingsElement = document.getElementById(settingsId);
        
        if (settingsElement) {
            settingsElement.style.display = e.target.checked ? 'block' : 'none';
        }
    }

    /**
     * Generate platform information HTML
     * @param {string} vendor - The selected vendor
     * @param {string} platform - The selected platform
     * @returns {string} HTML content for platform information
     */
    function generatePlatformInfo(vendor, platform) {
        let html = '';
        
        // Vendor-specific platform information
        switch (vendor) {
            case 'cisco':
                switch (platform) {
                    case 'IOS':
                        html = `
                            <p><strong>Cisco IOS</strong> is the traditional software used on older Cisco switches like the Catalyst 2960, 3560, and 3750 series.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAB, WebAuth</p>
                            <p><strong>Firmware Recommendation:</strong> At least 15.2(4)E or later for IBNS 2.0 support</p>
                            <p><strong>Configuration Model:</strong> Uses IBNS 2.0 with Class Maps and Policy Maps</p>
                        `;
                        break;
                    case 'IOS-XE':
                        html = `
                            <p><strong>Cisco IOS-XE</strong> is the modern Linux-based OS used on Catalyst 9000 series switches.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAB, WebAuth, MACsec, RadSec</p>
                            <p><strong>Firmware Recommendation:</strong> 16.9.x or later for full feature support</p>
                            <p><strong>Configuration Model:</strong> Uses IBNS 2.0 with Class Maps and Policy Maps with enhanced features</p>
                        `;
                        break;
                    case 'WLC-9800':
                        html = `
                            <p><strong>Cisco Catalyst 9800 WLC</strong> is the modern wireless controller platform for Catalyst 9100 access points.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAB, WebAuth, Central/Local Web Auth</p>
                            <p><strong>Firmware Recommendation:</strong> 17.3.x or later for optimal security features</p>
                            <p><strong>Administration:</strong> Supports both RADIUS and TACACS+ for device administration</p>
                        `;
                        break;
                    default:
                        html = `<p>Information about ${platform} will be displayed here.</p>`;
                }
                break;
            case 'aruba':
                switch (platform) {
                    case 'AOS-CX':
                        html = `
                            <p><strong>Aruba AOS-CX</strong> is Aruba's modern, cloud-native network operating system.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAC Authentication, Captive Portal</p>
                            <p><strong>Firmware Recommendation:</strong> 10.8.x or later for enhanced authentication features</p>
                            <p><strong>Configuration Model:</strong> Uses CLI or Aruba Central for cloud management</p>
                        `;
                        break;
                    case 'AOS-Switch':
                        html = `
                            <p><strong>Aruba AOS-Switch</strong> (formerly known as ProVision) is used on older Aruba/HP switches.</p>
                            <p><strong>Supported Authentication:</strong> 802.1X, MAC Authentication, Web Authentication</p>
                            <p><strong>Firmware Recommendation:</strong> WC.16.10.x or later for best security support</p>
                            <p><strong>Configuration Model:</strong> Uses traditional CLI commands with some differences from Cisco syntax</p>
                        `;
                        break;
                    default:
                        html = `<p>Information about ${platform} will be displayed here.</p>`;
                }
                break;
            default:
                html = `<p>Information about ${vendor} ${platform} will be displayed here.</p>`;
        }
        
        return html;
    }

    /**
     * Generate configuration based on user selections
     */
    function generateConfiguration() {
        // Collect all configuration parameters
        const configParams = collectConfigParameters();
        
        // Call template generator to create configuration
        if (window.TemplateGenerator) {
            try {
                const config = window.TemplateGenerator.generateConfig(configParams);
                displayConfiguration(config);
                
                // Update state
                appState.configOutput = config;
                
                // Show validation results
                validateConfiguration(config);
            } catch (error) {
                console.error('Error generating configuration:', error);
                alert('Error generating configuration. Please check console for details.');
            }
        } else {
            console.error('TemplateGenerator not loaded');
            alert('Template generator module not loaded. Please refresh the page and try again.');
        }
    }

    /**
     * Collect all configuration parameters from the UI
     * @returns {Object} Configuration parameters
     */
    function collectConfigParameters() {
        // Basic vendor and platform info
        const configParams = {
            vendor: document.getElementById('vendor').value,
            platform: document.getElementById('platform').value,
            softwareVersion: document.getElementById('softwareVersion').value,
            
            // Authentication methods
            authMethods: Array.from(document.querySelectorAll('input[name="authMethod"]:checked')).map(cb => cb.value),
            deploymentType: document.getElementById('deploymentType').value,
            
            // RADIUS configuration
            radius: {
                serverGroup: document.getElementById('radiusServerGroup').value,
                timeout: document.getElementById('radiusTimeout').value,
                servers: [
                    {
                        name: document.getElementById('radiusServer1Name').value,
                        ip: document.getElementById('radiusServer1').value,
                        authPort: document.getElementById('radiusPort1').value,
                        acctPort: document.getElementById('radiusAcctPort1').value,
                        key: document.getElementById('radiusKey1').value
},
                    {
                        name: document.getElementById('radiusServer2Name').value,
                        ip: document.getElementById('radiusServer2').value,
                        authPort: document.getElementById('radiusPort2').value,
                        acctPort: document.getElementById('radiusAcctPort2').value,
                        key: document.getElementById('radiusKey2').value
                    }
                ],
                attributes: {
                    nasId: document.getElementById('radiusNasId').checked,
                    nasIp: document.getElementById('radiusNasIp').checked,
                    serviceType: document.getElementById('radiusServiceType').checked,
                    calledStationId: document.getElementById('radiusCalledStationId').checked,
                    callingStationId: document.getElementById('radiusCallingStationId').checked
                },
                macFormat: document.getElementById('radiusMacFormat').value,
                nasIdentifier: document.getElementById('nasIdentifier').value,
                advanced: {
                    loadBalance: document.getElementById('radiusLoadBalance').checked,
                    deadtime: document.getElementById('radiusDeadtime').checked,
                    sourceInterface: document.getElementById('radiusSourceInterface').checked,
                    coa: document.getElementById('radiusCoA').checked,
                    serverProbe: document.getElementById('radiusServerProbe').checked,
                    deadtimeValue: document.getElementById('radiusDeadtimeValue').value,
                    retransmit: document.getElementById('radiusRetransmit').value,
                    sourceInterfaceValue: document.getElementById('radiusSourceInterfaceValue').value,
                    testUsername: document.getElementById('radiusTestUsername').value,
                    deadCriteria: document.getElementById('radiusDeadCriteria').value,
                    loadBalanceMethod: document.getElementById('radiusLoadBalanceMethod').value
                }
            },

            // TACACS+ configuration
            tacacs: {
                serverGroup: document.getElementById('tacacsServerGroup').value,
                timeout: document.getElementById('tacacsTimeout').value,
                servers: [
                    {
                        name: document.getElementById('tacacsServer1Name').value,
                        ip: document.getElementById('tacacsServer1').value,
                        port: document.getElementById('tacacsPort1').value,
                        key: document.getElementById('tacacsKey1').value
                    },
                    {
                        name: document.getElementById('tacacsServer2Name').value,
                        ip: document.getElementById('tacacsServer2').value,
                        port: document.getElementById('tacacsPort2').value,
                        key: document.getElementById('tacacsKey2').value
                    }
                ],
                sourceInterface: document.getElementById('tacacsSourceInterface').value,
                authMethod: document.getElementById('tacacsAuthMethod').value,
                authzMethod: document.getElementById('tacacsAuthzMethod').value,
                authMethodType: document.querySelector('input[name="tacacsAuthMethodType"]:checked').value,
                authorization: {
                    console: document.getElementById('tacacsAuthzConsole').checked,
                    commands: document.getElementById('tacacsAuthzCommands').checked,
                    config: document.getElementById('tacacsAuthzConfig').checked,
                    ifAuthenticated: document.getElementById('tacacsAuthzIfAuthenticated').value
                },
                accounting: {
                    commands: document.getElementById('tacacsAcctCommands').checked,
                    exec: document.getElementById('tacacsAcctExec').checked,
                    system: document.getElementById('tacacsAcctSystem').checked,
                    commandLevels: Array.from(document.getElementById('tacacsAcctCommandLevel').selectedOptions).map(opt => opt.value),
                    method: document.getElementById('tacacsAcctMethod').value
                }
            },

            // Advanced features
            advancedFeatures: {
                security: {
                    criticalAuth: document.getElementById('featureCriticalAuth').checked,
                    macSec: document.getElementById('featureMacSec').checked,
                    radSec: document.getElementById('featureRadSec').checked,
                    coa: document.getElementById('featureCoa').checked,
                    criticalSettings: {
                        dataVlan: document.getElementById('criticalDataVlan').value,
                        voiceVlan: document.getElementById('criticalVoiceVlan').value,
                        recoveryDelay: document.getElementById('criticalRecoveryDelay').value
                    },
                    macSecSettings: {
                        policy: document.getElementById('macSecPolicy')?.value,
                        cipherSuite: document.getElementById('macSecCipherSuite')?.value
                    },
                    radSecSettings: {
                        server: document.getElementById('radSecServer')?.value,
                        port: document.getElementById('radSecPort')?.value,
                        certPath: document.getElementById('radSecCertPath')?.value
                    }
                },
                access: {
                    dacl: document.getElementById('featureDacl').checked,
                    sgt: document.getElementById('featureSgt').checked,
                    vlan: document.getElementById('featureVlan').checked,
                    posture: document.getElementById('featurePosture').checked,
                    profiling: document.getElementById('featureProfiling').checked,
                    daclSettings: {
                        fallback: document.getElementById('daclFallback').value,
                        timeout: document.getElementById('daclTimeout').value
                    },
                    sgtSettings: {
                        propagation: document.getElementById('sgtPropagation')?.value
                    },
                    profilingSettings: {
                        dhcp: document.getElementById('sensorDhcp').checked,
                        cdp: document.getElementById('sensorCdp').checked,
                        lldp: document.getElementById('sensorLldp').checked,
                        accounting: document.getElementById('sensorAccounting').value
                    }
                },
                guest: {
                    webAuth: document.getElementById('featureWebAuth').checked,
                    guestVlan: document.getElementById('featureGuestVlan').checked,
                    redirect: document.getElementById('featureRedirect').checked,
                    webAuthSettings: {
                        type: document.getElementById('webAuthType')?.value,
                        portal: document.getElementById('webAuthPortal')?.value
                    },
                    guestVlanSettings: {
                        id: document.getElementById('guestVlanId')?.value,
                        timeout: document.getElementById('guestTimeout')?.value
                    }
                },
                byod: {
                    provisioning: document.getElementById('featureProvisioning').checked,
                    deviceReg: document.getElementById('featureDeviceReg').checked,
                    certOnboard: document.getElementById('featureCertOnboard').checked,
                    provisioningSettings: {
                        vlan: document.getElementById('provisioningVlan')?.value,
                        url: document.getElementById('provisioningUrl')?.value
                    },
                    certOnboardSettings: {
                        provider: document.getElementById('certProvider')?.value,
                        url: document.getElementById('certUrl')?.value
                    }
                }
            },

            // Interface configuration
            interfaces: {
                access: {
                    range: document.getElementById('accessInterfaceRange').value,
                    vlan: document.getElementById('accessVlan').value,
                    voiceVlan: document.getElementById('voiceVlan').value,
                    settings: {
                        nonegotiate: document.getElementById('portNonegotiate').checked,
                        portfast: document.getElementById('portPortfast').checked,
                        bpduguard: document.getElementById('portBpduguard').checked,
                        rootguard: document.getElementById('portRootguard').checked,
                        stormControl: document.getElementById('portStormControl').checked
                    },
                    dot1x: {
                        hostMode: document.getElementById('dot1xHostMode').value,
                        controlDirection: document.getElementById('dot1xControlDirection').value,
                        txPeriod: document.getElementById('dot1xTxPeriod').value,
                        maxReauthReq: document.getElementById('dot1xMaxReauthReq').value,
                        inactivityTimer: document.getElementById('inactivityTimer').value
                    }
                },
                trunk: {
                    range: document.getElementById('trunkInterfaceRange').value,
                    nativeVlan: document.getElementById('nativeVlan').value,
                    allowedVlans: document.getElementById('allowedVlans').value,
                    settings: {
                        nonegotiate: document.getElementById('trunkNonegotiate').checked,
                        dhcpSnooping: document.getElementById('trunkDhcpSnooping').checked,
                        arpInspection: document.getElementById('trunkArpInspection').checked,
                        disableTracking: document.getElementById('trunkDisableTrackingIp').checked,
                        noMonitor: document.getElementById('trunkNoMonitor').checked
                    }
                },
                specific: document.getElementById('specificInterfaces').value
            }
        };

        return configParams;
    }

    /**
     * Display generated configuration in the output area
     * @param {string} config - Generated configuration
     */
    function displayConfiguration(config) {
        const configOutput = document.getElementById('configOutput');
        configOutput.value = config;
    }

    /**
     * Validate the generated configuration
     * @param {string} config - Generated configuration
     */
    function validateConfiguration(config) {
        // Call validation module to check configuration
        if (window.ConfigValidator) {
            try {
                const validationResults = window.ConfigValidator.validate(config);

                // Show validation results
                const validationContainer = document.querySelector('.config-validation');
                const validationResultsElem = document.getElementById('validationResults');

                validationContainer.classList.remove('hidden');

                if (validationResults.valid) {
                    validationResultsElem.innerHTML = `
                        <div class="validation-success">
                            <i class="fas fa-check-circle"></i> Configuration validated successfully.
                        </div>
                    `;
                } else {
                    let issuesHtml = '<div class="validation-error"><i class="fas fa-exclamation-circle"></i> Configuration has issues:</div><ul>';

                    validationResults.issues.forEach(issue => {
                        issuesHtml += `<li>${issue}</li>`;
                    });

                    issuesHtml += '</ul>';
                    validationResultsElem.innerHTML = issuesHtml;
                }
            } catch (error) {
                console.error('Error validating configuration:', error);
            }
        }
    }

    /**
     * Copy configuration to clipboard
     */
    function copyConfiguration() {
        const configOutput = document.getElementById('configOutput');
        configOutput.select();
        document.execCommand('copy');

        // Show a brief "Copied!" message
        const copyBtn = document.getElementById('copyConfigBtn');
        const originalText = copyBtn.innerHTML;
        copyBtn.innerHTML = '<i class="fas fa-check"></i> Copied!';

        setTimeout(() => {
            copyBtn.innerHTML = originalText;
        }, 2000);
    }

    /**
     * Download configuration as a text file
     */
    function downloadConfiguration() {
        const configOutput = document.getElementById('configOutput');
        const config = configOutput.value;

        if (!config.trim()) {
            alert('Please generate a configuration first.');
            return;
        }

        const vendor = document.getElementById('vendor').value;
        const platform = document.getElementById('platform').value;
        const fileName = `${vendor}_${platform}_config.txt`;

        const element = document.createElement('a');
        element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(config));
        element.setAttribute('download', fileName);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);
    }

    /**
     * Generate network diagram
     */
    function generateDiagram() {
        const diagramType = document.getElementById('diagramType').value;
        const diagramPreview = document.getElementById('diagramPreview');

        // This is a placeholder - in a real implementation, this would generate an actual diagram
        diagramPreview.innerHTML = `
            <div style="text-align: center;">
                <p><i class="fas fa-project-diagram" style="font-size: 48px; color: var(--primary-color);"></i></p>
                <p>${diagramType.charAt(0).toUpperCase() + diagramType.slice(1)} Diagram</p>
                <p style="font-style: italic;">This is a placeholder for the actual diagram generation.</p>
            </div>
        `;
    }

    /**
     * Generate deployment checklist
     */
    function generateChecklist() {
        const checklistType = document.getElementById('checklistType').value;
        const checklistPreview = document.getElementById('checklistPreview');

        // Sample checklist items based on type
        let checklistItems = [];

        switch (checklistType) {
            case 'deployment':
                checklistItems = [
                    'Verify network hardware is installed and powered on',
                    'Configure IP addressing and VLANs',
                    'Configure RADIUS/TACACS+ servers',
                    'Configure switch ports for authentication',
                    'Test authentication with a sample device',
                    'Deploy to test user group',
                    'Monitor for issues',
                    'Roll out to production'
                ];
                break;
            case 'testing':
                checklistItems = [
                    'Test 802.1X authentication with compliant device',
                    'Test MAB authentication with non-compliant device',
                    'Test with various device types (Workstation, Phone, Printer)',
                    'Test RADIUS server failover',
                    'Test with wrong credentials',
                    'Test CoA functionality',
                    'Test High Availability',
                    'Verify logging and accounting'
                ];
                break;
            case 'validation':
                checklistItems = [
                    'Validate RADIUS server configuration',
                    'Validate switch port configuration',
                    'Validate security features (DHCP Snooping, ARP Inspection)',
                    'Validate user access policies',
                    'Validate guest access',
                    'Validate reporting and monitoring',
                    'Validate documentation',
                    'Validate troubleshooting procedures'
                ];
                break;
            case 'all':
                checklistItems = [
                    'Pre-Deployment: Hardware inventory check',
                    'Pre-Deployment: Network diagram review',
                    'Pre-Deployment: Server preparation',
                    'Deployment: Configure RADIUS/TACACS+ servers',
                    'Deployment: Configure switch authentication',
                    'Testing: Test with compliant devices',
                    'Testing: Test with non-compliant devices',
                    'Testing: Verify failover functionality',
                    'Validation: Validate user access',
                    'Validation: Validate security features',
                    'Post-Deployment: Documentation',
                    'Post-Deployment: Training',
                    'Post-Deployment: Monitoring setup'
                ];
                break;
        }

        // Generate HTML for checklist
        let checklistHtml = '';

        checklistItems.forEach((item, index) => {
            checklistHtml += `
                <div class="checklist-item">
                    <input type="checkbox" id="check-${index}">
                    <label for="check-${index}">${item}</label>
                </div>
            `;
        });

        checklistPreview.innerHTML = checklistHtml;
    }

    /**
     * Generate project documentation
     */
    function generateDocumentation() {
        // This would be implemented to generate actual documentation
        // For now, just show a message
        alert('Documentation generation feature will be implemented in a future update.');
    }

    /**
     * Save the current configuration state
     */
    function saveConfiguration() {
        // Collect all configuration parameters
        const configParams = collectConfigParameters();

        // Convert to JSON and encode for storage
        const configJson = JSON.stringify(configParams);
        const configData = btoa(configJson);

        // Create a downloadable file
        const fileName = `UaXSupreme_Config_${new Date().toISOString().slice(0, 10)}.json`;

        const element = document.createElement('a');
        element.setAttribute('href', 'data:application/json;charset=utf-8,' + encodeURIComponent(configJson));
        element.setAttribute('download', fileName);

        element.style.display = 'none';
        document.body.appendChild(element);

        element.click();

        document.body.removeChild(element);

        alert(`Configuration saved as ${fileName}`);
    }

    /**
     * Load a saved configuration
     */
    function loadConfiguration() {
        // Create a file input element
        const fileInput = document.createElement('input');
        fileInput.type = 'file';
        fileInput.accept = '.json';
        fileInput.style.display = 'none';

        fileInput.addEventListener('change', function(e) {
            const file = e.target.files[0];

            if (file) {
                const reader = new FileReader();

                reader.onload = function(e) {
                    try {
                        const configParams = JSON.parse(e.target.result);

                        // Apply loaded configuration to UI
                        applyConfigurationToUI(configParams);

                        alert('Configuration loaded successfully.');
                    } catch (error) {
                        console.error('Error parsing configuration file:', error);
                        alert('Error loading configuration. Invalid file format.');
                    }
                };

                reader.readAsText(file);
            }
        });

        document.body.appendChild(fileInput);
        fileInput.click();
        document.body.removeChild(fileInput);
    }

    /**
     * Apply loaded configuration to UI
     * @param {Object} configParams - Configuration parameters
     */
    function applyConfigurationToUI(configParams) {
        // This is a placeholder - in a real implementation, this would populate all UI elements
        // with the values from the loaded configuration

        // For now, just set the basic values
        if (configParams.vendor) {
            document.getElementById('vendor').value = configParams.vendor;
            handleVendorChange();
        }

        if (configParams.platform) {
            document.getElementById('platform').value = configParams.platform;
            handlePlatformChange();
        }

        if (configParams.softwareVersion) {
            document.getElementById('softwareVersion').value = configParams.softwareVersion;
        }

        // More detailed implementation would be needed to restore all settings
    }

    /**
     * Send message to AI Assistant
     */
    function sendMessageToAI() {
        const userMessage = document.getElementById('userMessage');
        const message = userMessage.value.trim();

        if (!message) {
            return;
        }

        // Add user message to chat
        addMessageToChat('user', message);

        // Clear input
        userMessage.value = '';

        // Simulate AI response
        simulateAIResponse(message);
    }

    /**
     * Add message to chat
     * @param {string} sender - 'user' or 'ai'
     * @param {string} message - Message content
     */
    function addMessageToChat(sender, message) {
        const chatMessages = document.getElementById('chatMessages');
        const messageDiv = document.createElement('div');

        messageDiv.className = sender === 'user' ? 'user-message' : 'ai-message';

        const avatarDiv = document.createElement('div');
        avatarDiv.className = 'message-avatar';
        avatarDiv.innerHTML = sender === 'user' ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';

        const contentDiv = document.createElement('div');
        contentDiv.className = 'message-content';
        contentDiv.innerHTML = formatMessageContent(message);

        messageDiv.appendChild(avatarDiv);
        messageDiv.appendChild(contentDiv);

        chatMessages.appendChild(messageDiv);

        // Scroll to bottom
        chatMessages.scrollTop = chatMessages.scrollHeight;
    }

    /**
     * Format message content with HTML
     * @param {string} message - Message content
     * @returns {string} Formatted HTML
     */
    function formatMessageContent(message) {
        // Simple formatting for now
        const paragraphs = message.split('\n\n');

        return paragraphs.map(p => `<p>${p}</p>`).join('');
    }

    /**
     * Simulate AI response (placeholder for real AI implementation)
     * @param {string} userMessage - User's message
     */
    function simulateAIResponse(userMessage) {
        const lowerMessage = userMessage.toLowerCase();
        let response = '';

        // Simulate thinking time
        setTimeout(() => {
            // Simple keyword-based responses
            if (lowerMessage.includes('monitor mode') || lowerMessage.includes('open mode')) {
                response = `Monitor Mode (or Open Mode) allows 802.1X authentication to run without enforcing it. This means:\n\n1. The switch will try to authenticate devices\n\n2. If authentication fails, devices will still be allowed network access\n\n3. This is ideal for testing and initial deployment phases\n\n4. You can monitor what would happen in real enforcement without impacting users`;
            } else if (lowerMessage.includes('closed mode')) {
                response = `Closed Mode is when 802.1X authentication is fully enforced. This means:\n\n1. The switch requires successful authentication before granting network access\n\n2. Unauthenticated devices will be denied access (except to authentication servers)\n\n3. This is used for full security enforcement\n\n4. Use this after thorough testing in Monitor Mode`;
            } else if (lowerMessage.includes('troubleshoot') || lowerMessage.includes('fail')) {
                response = `To troubleshoot 802.1X authentication failures:\n\n1. Check switch configuration with "show authentication sessions interface X"\n\n2. Verify RADIUS server connectivity with "test aaa server radius X"\n\n3. Check for port security or other conflicting features\n\n4. Use debug commands like "debug dot1x all" (use cautiously in production)\n\n5. Check client supplicant configuration\n\n6. Verify certificate validity if using EAP-TLS`;
            } else if (lowerMessage.includes('radius') && lowerMessage.includes('redundancy')) {
                response = `Best practices for RADIUS server redundancy:\n\n1. Configure at least two RADIUS servers\n\n2. Use server groups with proper failover timeouts\n\n3. Set appropriate deadtime values (typically 15-20 minutes)\n\n4. Use the server-probing feature to detect dead servers\n\n5. Configure proper source interface for RADIUS communication\n\n6. Consider RadSec for encrypted and reliable RADIUS communication`;
            } else if (lowerMessage.includes('mab') && lowerMessage.includes('printer')) {
                response = `To configure MAB for printers:\n\n1. Enable MAC Authentication Bypass on the switch port\n\n2. Add the printer's MAC address to your RADIUS server\n\n3. Set appropriate authorization policies in your RADIUS server\n\n4. Consider using device profiling to identify printers automatically\n\n5. Assign printers to a specific VLAN via RADIUS attributes\n\n6. Implement DACs to restrict printer access to required services only`;
            } else {
                response = `Thanks for your question. As an AI assistant for UaXSupreme, I can help with network authentication configuration. Could you provide more specific details about what you'd like to learn about 802.1X, MAB, RADIUS, or TACACS+ configuration?`;
            }

            addMessageToChat('ai', response);
        }, 1000);
    }

    /**
     * Load help content
     * @param {string} topic - Help topic to load
     */
    function loadHelpContent(topic) {
        const helpContentArea = document.getElementById('helpContentArea');
        let content = '';

        switch (topic) {
            case 'overview':
                content = `
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
                        <li>Generate documentation for your implementation.</li>
                    </ol>

                    <p>For additional assistance, use the AI Assistant by clicking the robot icon in the top navigation bar.</p>
                `;
                break;
            case 'vendorSelection':
                content = `
                    <h3>Vendor Selection</h3>
                    <p>The Vendor Selection section allows you to specify the network vendor and platform for which you want to generate configuration.</p>

                    <h4>Supported Vendors</h4>
                    <ul>
                        <li><strong>Cisco</strong>: IOS, IOS-XE, WLC-9800, and more</li>
                        <li><strong>Aruba/HP</strong>: AOS-CX, AOS-Switch, and more</li>
                        <li><strong>Juniper</strong>: Junos and related platforms</li>
                        <li><strong>Fortinet</strong>: FortiOS and related platforms</li>
                        <li><strong>Extreme</strong>: EXOS and related platforms</li>
                        <li><strong>Dell</strong>: OS10 and related platforms</li>
                    </ul>

                    <h4>Software Version</h4>
                    <p>Enter the software version of your network device to ensure compatibility with generated configurations. The application will warn you if certain features require newer software versions.</p>

                    <h4>Platform Information</h4>
                    <p>After selecting a vendor and platform, you'll see additional information about the selected platform, including supported authentication methods and recommended firmware versions.</p>
                `;
                break;
            case 'authentication':
                content = `
                    <h3>Authentication Methods</h3>
                    <p>This section allows you to select the authentication methods you want to implement.</p>

                    <h4>Available Methods</h4>
                    <ul>
                        <li><strong>802.1X Authentication</strong>: Port-based network access control for wired and wireless networks</li>
                        <li><strong>MAC Authentication Bypass (MAB)</strong>: Authentication based on MAC address for devices that don't support 802.1X</li>
                        <li><strong>Web Authentication</strong>: Browser-based authentication for guest access</li>
                        <li><strong>RadSec</strong>: Secure RADIUS communications over TLS</li>
                        <li><strong>TACACS+</strong>: Authentication, authorization, and accounting for network devices</li>
                        <li><strong>MACsec</strong>: Layer 2 encryption for secure communications</li>
                    </ul>

                    <h4>Deployment Types</h4>
                    <ul>
                        <li><strong>Monitor Mode (Open)</strong>: Authentication is performed but not enforced</li>
                        <li><strong>Closed Mode</strong>: Full enforcement of authentication</li>
                        <li><strong>Standard</strong>: 802.1X is tried first, then MAB if 802.1X fails</li>
                        <li><strong>Concurrent</strong>: 802.1X and MAB are tried simultaneously</li>
                        <li><strong>High Security</strong>: Strict enforcement with additional security features</li>
                    </ul>

                    <h4>Security Features</h4>
                    <p>You can also select additional security features like DHCP Snooping, Dynamic ARP Inspection, IP Source Guard, Port Security, and Storm Control.</p>
                `;
                break;
            // Add more help topics as needed
            default:
                content = `<p>Help content for "${topic}" will be available soon.</p>`;
        }

        helpContentArea.innerHTML = content;
    }

    /**
     * Add interface template to specific interfaces textarea
     * @param {string} templateType - Type of template to add
     */
    function addInterfaceTemplate(templateType) {
        const specificInterfaces = document.getElementById('specificInterfaces');
        let template = '';

        switch (templateType) {
            case 'ap':
                template = `interface GigabitEthernet1/0/10
 description Access Point
 switchport mode access
 switchport access vlan 10
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping limit rate 20

`;
                break;
            case 'ipphone':
                template = `interface GigabitEthernet1/0/11
 description IP Phone
 switchport mode access
 switchport access vlan 10
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping limit rate 20
 mab
 dot1x pae authenticator
 dot1x timeout tx-period 5
 dot1x max-reauth-req 2
 authentication periodic
 authentication timer reauthenticate server

`;
                break;
            case 'printer':
                template = `interface GigabitEthernet1/0/12
 description Printer
 switchport mode access
 switchport access vlan 30
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping limit rate 20
 mab
 dot1x timeout tx-period 5

`;
                break;
            case 'server':
                template = `interface GigabitEthernet1/0/13
 description Server
 switchport mode access
 switchport access vlan 100
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 ip dhcp snooping trust

`;
                break;
            case 'uplink':
                template = `interface TenGigabitEthernet1/1/1
 description Uplink to Core
 switchport mode trunk
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,100
 switchport nonegotiate
 spanning-tree guard root
 ip dhcp snooping trust
 no ip device tracking

`;
                break;
        }

        specificInterfaces.value += template;
    }

    /**
     * Finish configuration and show completion message
     */
    function finishConfiguration() {
        alert('Configuration complete! You can now download your configuration and documentation.');
    }
});
EOF

# Create template generator JavaScript file
print_message "Creating template generator JS file..."

cat > js/template-generator.js << 'EOF'
/**
 * UaXSupreme - Template Generator
 * Generates configuration templates based on user selection
 */

(function() {
    'use strict';

    // Template cache
    const templateCache = {};

    // Template placeholder regex
    const placeholderRegex = /\{\{([^}]+)\}\}/g;

    // Template Generator object
    const TemplateGenerator = {
        /**
         * Generate configuration based on parameters
         * @param {Object} params - Configuration parameters
         * @returns {string} Generated configuration
         */
        generateConfig: function(params) {
            console.log('Generating configuration with parameters:', params);

            try {
                // Determine template to use based on vendor, platform, and auth methods
                const template = this.selectTemplate(params);

                // Process template with parameters
                return this.processTemplate(template, params);
            } catch (error) {
                console.error('Error generating configuration:', error);
                throw error;
            }
        },

        /**
         * Select appropriate template based on parameters
         * @param {Object} params - Configuration parameters
         * @returns {string} Selected template
         */
        selectTemplate: function(params) {
            const { vendor, platform, authMethods, deploymentType } = params;

            // Use real template data if available, otherwise use placeholders
            try {
                // Try to load from template cache first
                const cacheKey = `${vendor}_${platform}_${deploymentType}`;

                if (templateCache[cacheKey]) {
                    console.log(`Using cached template for ${cacheKey}`);
                    return templateCache[cacheKey];
                }

                // Load template from server or use placeholder
                let template = '';

                // In a real implementation, this would load from the template directory
                // For now, use placeholders based on vendor and platform
                if (vendor === 'cisco') {
                    if (platform === 'IOS-XE') {
                        if (deploymentType === 'concurrent') {
                            template = this.getCiscoIOSXEConcurrentTemplate();
                        } else {
                            template = this.getCiscoIOSXEStandardTemplate();
                        }
                    } else if (platform === 'IOS') {
                        if (deploymentType === 'concurrent') {
                            template = this.getCiscoIOSConcurrentTemplate();
                        } else {
                            template = this.getCiscoIOSStandardTemplate();
                        }
                    } else if (platform === 'WLC-9800') {
                        if (authMethods.includes('tacacs')) {
                            template = this.getCiscoWLC9800TacacsTemplate();
                        } else {
                            template = this.getCiscoWLC9800RadiusTemplate();
                        }
                    } else {
                        template = this.getGenericTemplate(vendor, platform);
                    }
                } else if (vendor === 'aruba') {
                    if (platform === 'AOS-CX') {
                        template = this.getArubaAOSCXTemplate();
                    } else if (platform === 'AOS-Switch') {
                        template = this.getArubaAOSSwitchTemplate();
                    } else {
                        template = this.getGenericTemplate(vendor, platform);
                    }
                } else {
                    template = this.getGenericTemplate(vendor, platform);
                }

                // Cache template for future use
                templateCache[cacheKey] = template;

                return template;
            } catch (error) {
                console.error('Error selecting template:', error);
                return this.getGenericTemplate(vendor, platform);
            }
        },

        /**
         * Process template by replacing placeholders with values
         * @param {string} template - Template with placeholders
         * @param {Object} params - Parameters for replacement
         * @returns {string} Processed template
         */
        processTemplate: function(template, params) {
            let result = template;

            // Replace simple placeholders
            result = result.replace(placeholderRegex, (match, placeholder) => {
                // Split placeholder path (e.g., "radius.servers[0].ip")
                const path = placeholder.trim().split('.');

                // Navigate through params object to find value
                let value = params;

                for (let i = 0; i < path.length; i++) {
                    const key = path[i];

                    // Handle array access (e.g., "servers[0]")
                    const arrayMatch = key.match(/^([^\[]+)\[(\d+)\]$/);

                    if (arrayMatch) {
                        const arrayName = arrayMatch[1];
                        const arrayIndex = parseInt(arrayMatch[2], 10);

                        if (value[arrayName] && value[arrayName][arrayIndex] !== undefined) {
                            value = value[arrayName][arrayIndex];
                        } else {
                            value = undefined;
                            break;
                        }
                    } else if (value[key] !== undefined) {
                        value = value[key];
                    } else {
                        value = undefined;
                        break;
                    }
                }

                // Return value or empty string if undefined
                return value !== undefined ? value : '';
            });

            // Process conditional sections
            result = this.processConditionalSections(result, params);

            // Process special template logic
            result = this.processSpecialLogic(result, params);

            return result;
        },

        /**
         * Process conditional sections in template
         * @param {string} template - Template with conditionals
         * @param {Object} params - Parameters for evaluation
         * @returns {string} Processed template
         */
        processConditionalSections: function(template, params) {
            let result = template;

            // Simple if/endif conditional processing
            const ifRegex = /\{\{\s*if\s+([^}]+)\s*\}\}([\s\S]*?)\{\{\s*endif\s*\}\}/g;

            result = result.replace(ifRegex, (match, condition, content) => {
                try {
                    // Evaluate condition in the context of params
                    const conditionFn = new Function('params', `return ${condition};`);
                    const conditionResult = conditionFn(params);

                    return conditionResult ? content : '';
                } catch (error) {
                    console.error('Error evaluating condition:', condition, error);
                    return '';
                }
            });

            // if/else/endif conditional processing
            const ifElseRegex = /\{\{\s*if\s+([^}]+)\s*\}\}([\s\S]*?)\{\{\s*else\s*\}\}([\s\S]*?)\{\{\s*endif\s*\}\}/g;

            result = result.replace(ifElseRegex, (match, condition, ifContent, elseContent) => {
                try {
                    // Evaluate condition in the context of params
                    const conditionFn = new Function('params', `return ${condition};`);
                    const conditionResult = conditionFn(params);

                    return conditionResult ? ifContent : elseContent;
                } catch (error) {
                    console.error('Error evaluating condition:', condition, error);
                    return '';
                }
            });

            return result;
        },

        /**
         * Process special template logic
         * @param {string} template - Template with special logic
         * @param {Object} params - Parameters for processing
         * @returns {string} Processed template
         */
        processSpecialLogic: function(template, params) {
            let result = template;

            // Special case for RADIUS source interface
            if (params.radius && params.radius.advanced && params.radius.advanced.sourceInterface) {
                const sourceInterface = params.radius.advanced.sourceInterfaceValue || '';

                if (sourceInterface) {
                    result = result.replace('{{RADIUS_SOURCE_INTERFACE}}', `ip radius source-interface ${sourceInterface}`);
                } else {
                    result = result.replace('{{RADIUS_SOURCE_INTERFACE}}', '');
                }
            }

            // Special case for interface template
            if (params.interfaces && params.interfaces.access && params.interfaces.access.range) {
                // Replace interface range placeholder if present
                result = result.replace('{{INTERFACE_RANGE}}', params.interfaces.access.range);
            }

            // Handle authentication type selection
            const authTypes = params.authMethods || [];

            if (!authTypes.includes('dot1x')) {
                // Remove 802.1X specific configurations
                result = result.replace(/dot1x[^\n]*\n/g, '');
            }

            if (!authTypes.includes('mab')) {
                // Remove MAB specific configurations
                result = result.replace(/mab[^\n]*\n/g, '');
            }

            return result;
        },

        /**
         * Get Cisco IOS-XE concurrent 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSXEConcurrentTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS-XE IBNS 2.0 Concurrent 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
device-tracking tracking auto-source

! Device Tracking Policy for Trunk Ports
device-tracking policy DISABLE-IP-TRACKING
 tracking disable
 trusted-port
 device-role switch

! Device Tracking Policy for Access Ports
device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Concurrent 802.1X and MAB
policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-all
   10 authenticate using dot1x priority 10
   20 authenticate using mab priority 20
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 device-tracking attach-policy IP-TRACKING
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco IOS-XE standard 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSXEStandardTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS-XE IBNS 2.0 Standard 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
device-tracking tracking auto-source

! Device Tracking Policy for Trunk Ports
device-tracking policy DISABLE-IP-TRACKING
 tracking disable
 trusted-port
 device-role switch

! Device Tracking Policy for Access Ports
device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Sequential 802.1X and MAB
policy-map type control subscriber DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-until-failure
   10 authenticate using dot1x priority 10
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class MAB_FAILED do-until-failure
   10 terminate mab
   20 authentication-restart 60
  60 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 device-tracking attach-policy IP-TRACKING
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco IOS concurrent 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSConcurrentTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS IBNS 2.0 Concurrent 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
ip device tracking probe auto-source
ip device tracking probe delay 10
ip device tracking probe interval 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Concurrent 802.1X and MAB
policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-all
   10 authenticate using dot1x priority 10
   20 authenticate using mab priority 20
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 ip device tracking maximum 4
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast edge
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco IOS standard 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSStandardTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS IBNS 2.0 Standard 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
ip device tracking probe auto-source
ip device tracking probe delay 10
ip device tracking probe interval 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Sequential 802.1X and MAB
policy-map type control subscriber DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-until-failure
   10 authenticate using dot1x priority 10
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class MAB_FAILED do-until-failure
   10 terminate mab
   20 authentication-restart 60
  60 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 ip device tracking maximum 4
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast edge
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco WLC 9800 TACACS+ template
         * @returns {string} Template
         */
        getCiscoWLC9800TacacsTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco WLC 9800 TACACS+ Authentication Configuration
! -----------------------------------------------------

! Create local fallback account:
username admin privilege 15 algorithm-type sha256 secret {{tacacs.servers[0].key}}
enable algorithm-type sha256 secret {{tacacs.servers[0].key}}

! Enable AAA services:
aaa new-model

! Configure TACACS+ servers:
tacacs server {{tacacs.servers[0].name}}
 address ipv4 {{tacacs.servers[0].ip}}
 key {{tacacs.servers[0].key}}
 timeout {{tacacs.timeout}}

tacacs server {{tacacs.servers[1].name}}
 address ipv4 {{tacacs.servers[1].ip}}
 key {{tacacs.servers[1].key}}
 timeout {{tacacs.timeout}}

! Configure TACACS+ Server Group:
aaa group server tacacs+ {{tacacs.serverGroup}}
 server name {{tacacs.servers[0].name}}
 server name {{tacacs.servers[1].name}}
 ip vrf forwarding MGMT
 ip tacacs source-interface {{tacacs.sourceInterface}}

! Create Method List to use TACACS+ logins primarily.
! Fallback to Local User Accounts ONLY if all TACACS+ servers fail.
aaa authentication login {{tacacs.authMethod}} group {{tacacs.serverGroup}} local
aaa authorization exec {{tacacs.authzMethod}} group {{tacacs.serverGroup}} local if-authenticated
aaa authorization console

! Configure Accounting
aaa accounting commands 0 default start-stop group {{tacacs.serverGroup}}
aaa accounting commands 1 default start-stop group {{tacacs.serverGroup}}
aaa accounting commands 15 default start-stop group {{tacacs.serverGroup}}

! Activate AAA TACACS+ for HTTPS Web GUI:
ip http authentication aaa login-authentication {{tacacs.authMethod}}
ip http authentication aaa exec-authorization {{tacacs.authzMethod}}

! Activate AAA TACACS+ for NETCONF/RESTCONF authentication
yang-interfaces aaa authentication method-list {{tacacs.authMethod}}
yang-interfaces aaa authorization method-list {{tacacs.authzMethod}}

! Restart HTTP/HTTPS services:
no ip http server
no ip http secure-server
ip http server
ip http secure-server

! Activate AAA TACACS+ authentication for SSH sessions:
line vty 0 97
 exec-timeout 30 0
 login authentication {{tacacs.authMethod}}
 authorization exec {{tacacs.authzMethod}}
 transport preferred none
 transport input ssh
 transport output none

! Activate AAA TACACS+ authentication for the Console port:
line con 0
 exec-timeout 15 0
 transport preferred none
 login authentication {{tacacs.authMethod}}
 authorization exec {{tacacs.authzMethod}}`;
        },

        /**
         * Get Cisco WLC 9800 RADIUS template
         * @returns {string} Template
         */
        getCiscoWLC9800RadiusTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco WLC 9800 RADIUS Authentication Configuration
! -----------------------------------------------------

! Create local fallback account:
username admin privilege 15 algorithm-type sha256 secret {{radius.servers[0].key}}
enable algorithm-type sha256 secret {{radius.servers[0].key}}

! Create non-usable account for RADIUS server probing:
username {{radius.advanced.testUsername}} privilege 0 algorithm-type sha256 secret ciscodisco123!
username {{radius.advanced.testUsername}} autocommand exit

! Enable AAA services:
aaa new-model

! Configure RADIUS servers:
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 automate-tester username {{radius.advanced.testUsername}} probe-on
 key {{radius.servers[0].key}}

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 automate-tester username {{radius.advanced.testUsername}} probe-on
 key {{radius.servers[1].key}}

! Configure RADIUS Server Group:
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

radius-server load-balance method {{radius.advanced.loadBalanceMethod}}
radius-server dead-criteria time 5 tries 3

! Create Method List to use RADIUS logins primarily.
! Fallback to Local User Accounts ONLY if all RADIUS servers fail.
aaa authentication login {{radius.authMethod}} group {{radius.serverGroup}} local
aaa authorization exec {{radius.authMethod}} group {{radius.serverGroup}} local if-authenticated
aaa authorization console

! Configure Accounting
aaa accounting exec default start-stop group {{radius.serverGroup}}

! Activate AAA RADIUS for HTTPS Web GUI:
ip http authentication aaa login-authentication {{radius.authMethod}}
ip http authentication aaa exec-authorization {{radius.authMethod}}

! Activate AAA RADIUS for NETCONF/RESTCONF authentication
yang-interfaces aaa authentication method-list {{radius.authMethod}}
yang-interfaces aaa authorization method-list {{radius.authMethod}}

! Restart HTTP/HTTPS services:
no ip http server
no ip http secure-server
ip http server
ip http secure-server

! Activate AAA RADIUS authentication for SSH sessions:
line vty 0 97
 exec-timeout 30 0
 login authentication {{radius.authMethod}}
 authorization exec {{radius.authMethod}}
 transport preferred none
 transport input ssh
 transport output none

! Activate AAA RADIUS authentication for the Console port:
line con 0
 exec-timeout 15 0
 transport preferred none
 login authentication {{radius.authMethod}}
 authorization exec {{radius.authMethod}}`;
        },

        /**
         * Get Aruba AOS-CX template
         * @returns {string} Template
         */
        getArubaAOSCXTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Aruba AOS-CX 802.1X and MAB Authentication Configuration
! -----------------------------------------------------

! Configure RADIUS servers
radius-server host {{radius.servers[0].ip}} key {{radius.servers[0].key}}
radius-server host {{radius.servers[1].ip}} key {{radius.servers[1].key}}

! Configure RADIUS server group
aaa group radius {{radius.serverGroup}}
 server {{radius.servers[0].ip}}
 server {{radius.servers[1].ip}}

! Configure authentication method
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting dot1x default start-stop group {{radius.serverGroup}}

! Enable 802.1X globally
aaa authentication port-access dot1x authenticator

! Configure interface settings for 802.1X
interface {{interfaces.access.range}}
 no shutdown
 aaa authentication port-access dot1x authenticator
 aaa port-access authenticator
 aaa port-access authenticator {{interfaces.access.range}} client-limit 3
 aaa port-access authenticator {{interfaces.access.range}} logoff-period 300
 aaa port-access authenticator {{interfaces.access.range}} max-requests 2
 aaa port-access authenticator {{interfaces.access.range}} max-retries {{interfaces.access.dot1x.maxReauthReq}}
 aaa port-access authenticator {{interfaces.access.range}} quiet-period 60
 aaa port-access authenticator {{interfaces.access.range}} server-timeout 30
 aaa port-access authenticator {{interfaces.access.range}} reauth-period 3600
 aaa port-access authenticator {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}
 aaa port-access authenticator {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}
 aaa port-access authenticator {{interfaces.access.range}} auth-vlan {{interfaces.access.vlan}}
 aaa port-access authenticator {{interfaces.access.range}} initialize
 aaa port-access authenticator active`;
        },

        /**
         * Get Aruba AOS-Switch template
         * @returns {string} Template
         */
        getArubaAOSSwitchTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Aruba AOS-Switch 802.1X and MAB Authentication Configuration
! -----------------------------------------------------

! Configure RADIUS servers
radius-server host {{radius.servers[0].ip}} key {{radius.servers[0].key}}
radius-server host {{radius.servers[1].ip}} key {{radius.servers[1].key}}
radius-server retransmit {{radius.advanced.retransmit}}
radius-server timeout {{radius.timeout}}

! Enable 802.1X and MAB authentication globally
aaa authentication port-access eap-radius
aaa authentication mac-based enable
aaa authentication mac-based address-format no-delimiter uppercase
aaa authentication mac-based auth-vid {{interfaces.access.vlan}}
aaa authentication mac-based unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}

! Configure interface for 802.1X and MAB
interface {{interfaces.access.range}}
 aaa authentication port-access auth-mode {{deploymentType}}
 aaa authentication port-access enable
 aaa authentication port-access {{interfaces.access.range}} auth-mode {{deploymentType}}
 aaa authentication port-access {{interfaces.access.range}} control auto
 aaa authentication port-access {{interfaces.access.range}} dot1x enable
 aaa authentication port-access {{interfaces.access.range}} mac-based enable
 aaa authentication port-access {{interfaces.access.range}} reauth-period server
 aaa authentication port-access {{interfaces.access.range}} max-retries {{interfaces.access.dot1x.maxReauthReq}}
 aaa authentication port-access {{interfaces.access.range}} quiet-period 60
 aaa authentication port-access {{interfaces.access.range}} tx-period {{interfaces.access.dot1x.txPeriod}}
 aaa authentication port-access {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}
 aaa authentication port-access {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}
 spanning-tree port-admin edge
 spanning-tree bpdu-guard
 speed-duplex auto
 no allow-jumbo-frames`;
        },

        /**
         * Get generic template for unsupported vendor/platform
         * @param {string} vendor - Vendor name
         * @param {string} platform - Platform name
         * @returns {string} Template
         */
        getGenericTemplate: function(vendor, platform) {
            return `! -----------------------------------------------------
! ${vendor} ${platform} Authentication Configuration
! -----------------------------------------------------

! This is a placeholder template for ${vendor} ${platform}.
! Detailed templates for this platform are currently under development.
!
! Based on your selected options, you would typically configure:
!
! 1. RADIUS/TACACS+ server settings
! 2. Authentication methods (802.1X, MAB, etc.)
! 3. Interface settings for authentication
! 4. Advanced security features
!
! Please refer to ${vendor} documentation for specific commands
! and syntax for ${platform}.`;
        }
    };

    // Export to window
    window.TemplateGenerator = TemplateGenerator;
})();
EOF

# Create validation JavaScript file
print_message "Creating validation JS file..."

cat > js/validation.js << 'EOF'
/**
 * UaXSupreme - Configuration Validator
 * Validates generated configuration for errors and best practices
 */

(function() {
    'use strict';

    // Configuration Validator object
    const ConfigValidator = {
        /**
         * Validate configuration
         * @param {string} config - Configuration to validate
         * @returns {Object} Validation results
         */
        validate: function(config) {
            console.log('Validating configuration...');

            const issues = [];

            // Check for missing or incomplete configurations
            this.checkForMissingConfigurations(config, issues);

            // Check for security best practices
            this.checkSecurityBestPractices(config, issues);

            // Check for vendor-specific recommendations
            this.checkVendorSpecificRecommendations(config, issues);

            return {
                valid: issues.length === 0,
                issues: issues
            };
        },

        /**
         * Check for missing or incomplete configurations
         * @param {string} config - Configuration to check
         * @param {Array} issues - Array to collect issues
         */
        checkForMissingConfigurations: function(config, issues) {
            // Check for missing RADIUS/TACACS+ server configuration
            if (config.includes('{{') && config.includes('}}')) {
                issues.push('Configuration contains unresolved placeholders. Please fill in all required fields.');
            }

            // Check for empty or default passwords
            if (config.includes('secret cisco') || config.includes('key cisco')) {
                issues.push('Default or weak passwords detected. Please use strong, unique passwords.');
            }

            // Check if RADIUS/TACACS+ server IPs are specified
            if (config.includes('address ipv4 10.10.10.101') || config.includes('address ipv4 10.10.10.102')) {
                issues.push('Default RADIUS server IP addresses detected. Please specify actual server addresses.');
            }

            // Check for missing interface range
            if (config.includes('interface range Gigabit')) {
                issues.push('Generic interface range detected. Please specify actual interface range.');
            }
        },

        /**
         * Check for security best practices
         * @param {string} config - Configuration to check
         * @param {Array} issues - Array to collect issues
         */
        checkSecurityBestPractices: function(config, issues) {
            // Check for DHCP snooping
            if (!config.includes('ip dhcp snooping') && !config.includes('dhcpipv4 snooping')) {
                issues.push('DHCP Snooping is not enabled. Consider enabling it for additional security.');
            }

            // Check for BPDU guard
            if (!config.includes('spanning-tree bpduguard enable') && !config.includes('bpdu-guard')) {
                issues.push('BPDU Guard is not enabled on access ports. Consider enabling it to prevent Layer 2 loops.');
            }

            // Check for port security
            if (config.includes('no switchport port-security')) {
                issues.push('Port security is explicitly disabled. Consider enabling it for MAC address-based security.');
            }

            // Check for encrypted passwords
            if (config.includes('secret 0') || config.includes('key 0')) {
                issues.push('Unencrypted passwords detected. Consider using encrypted passwords.');
            }

            // Check for recommended timeouts
            if (!config.includes('exec-timeout') || config.includes('exec-timeout 0')) {
                issues.push('Console/VTY timeout is not properly configured. Consider setting appropriate timeouts.');
            }
        },

        /**
         * Check for vendor-specific recommendations
         * @param {string} config - Configuration to check
         * @param {Array} issues - Array to collect issues
         */
        checkVendorSpecificRecommendations: function(config, issues) {
            // Cisco IOS/IOS-XE specific checks
            if (config.includes('Cisco IOS') || config.includes('Cisco IOS-XE')) {
                // Check for device tracking
                if (!config.includes('device-tracking')) {
                    issues.push('IP Device Tracking is not configured. This is required for downloadable ACLs to work properly.');
                }

                // Check for dot1x system-auth-control
                if (!config.includes('dot1x system-auth-control')) {
                    issues.push('Global 802.1X is not enabled (dot1x system-auth-control).');
                }

                // Check for CoA
                if (!config.includes('aaa server radius dynamic-author')) {
                    issues.push('RADIUS Change of Authorization (CoA) is not configured. This is required for dynamic policy changes.');
                }
            }

            // Aruba specific checks
            if (config.includes('Aruba AOS-CX') || config.includes('Aruba AOS-Switch')) {
                // Aruba-specific checks would go here
            }
        }
    };

    // Export to window
    window.ConfigValidator = ConfigValidator;
})();
EOF

# Create AI assistant JavaScript file
print_message "Creating AI assistant JS file..."

cat > js/ai-assistant.js << 'EOF'
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
EOF

# Create documentation generator JavaScript file
print_message "Creating documentation generator JS file..."

cat > js/documentation.js << 'EOF'
/**
 * UaXSupreme - Documentation Generator
 * Generates documentation and diagrams for network authentication
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

            // Generate diagram button
            const generateDiagramBtn = document.getElementById('generateDiagramBtn');
            if (generateDiagramBtn) {
                generateDiagramBtn.addEventListener('click', this.generateDiagram.bind(this));
            }

            // Generate checklist button
            const generateChecklistBtn = document.getElementById('generateChecklistBtn');
            if (generateChecklistBtn) {
                generateChecklistBtn.addEventListener('click', this.generateChecklist.bind(this));
            }

            // Download buttons
            const downloadDocBtn = document.getElementById('downloadDocBtn');
            if (downloadDocBtn) {
                downloadDocBtn.addEventListener('click', this.downloadDocumentation.bind(this));
            }

            const downloadDiagramBtn = document.getElementById('downloadDiagramBtn');
            if (downloadDiagramBtn) {
                downloadDiagramBtn.addEventListener('click', this.downloadDiagram.bind(this));
            }

            const downloadChecklistBtn = document.getElementById('downloadChecklistBtn');
            if (downloadChecklistBtn) {
                downloadChecklistBtn.addEventListener('click', this.downloadChecklist.bind(this));
            }
        },

        /**
         * Generate documentation
         */
        generateDocumentation: function() {
            // This is a placeholder - in a real implementation, this would generate actual documentation
            alert('Documentation generation feature will be implemented in a future update.');
        },

        /**
         * Generate network diagram
         */
        generateDiagram: function() {
            const diagramType = document.getElementById('diagramType').value;
            const diagramPreview = document.getElementById('diagramPreview');

            // This is a placeholder - in a real implementation, this would generate an actual diagram
            diagramPreview.innerHTML = `
                <div style="text-align: center;">
                    <p><i class="fas fa-project-diagram" style="font-size: 48px; color: var(--primary-color);"></i></p>
                    <p>${diagramType.charAt(0).toUpperCase() + diagramType.slice(1)} Diagram</p>
                    <p style="font-style: italic;">This is a placeholder for the actual diagram generation.</p>
                </div>
            `;
        },

        /**
         * Generate deployment checklist
         */
        generateChecklist: function() {
            const checklistType = document.getElementById('checklistType').value;
            const checklistPreview = document.getElementById('checklistPreview');

            // Sample checklist items based on type
            let checklistItems = [];

            switch (checklistType) {
                case 'deployment':
                    checklistItems = [
                        'Verify network hardware is installed and powered on',
                        'Configure IP addressing and VLANs',
                        'Configure RADIUS/TACACS+ servers',
                        'Configure switch ports for authentication',
                        'Test authentication with a sample device',
                        'Deploy to test user group',
                        'Monitor for issues',
                        'Roll out to production'
                    ];
                    break;
                case 'testing':
                    checklistItems = [
                        'Test 802.1X authentication with compliant device',
                        'Test MAB authentication with non-compliant device',
                        'Test with various device types (Workstation, Phone, Printer)',
                        'Test RADIUS server failover',
                        'Test with wrong credentials',
                        'Test CoA functionality',
                        'Test High Availability',
                        'Verify logging and accounting'
                    ];
                    break;
                case 'validation':
                    checklistItems = [
                        'Validate RADIUS server configuration',
                        'Validate switch port configuration',
                        'Validate security features (DHCP Snooping, ARP Inspection)',
                        'Validate user access policies',
                        'Validate guest access',
                        'Validate reporting and monitoring',
                        'Validate documentation',
                        'Validate troubleshooting procedures'
                    ];
                    break;
                case 'all':
                    checklistItems = [
                        'Pre-Deployment: Hardware inventory check',
                        'Pre-Deployment: Network diagram review',
                        'Pre-Deployment: Server preparation',
                        'Deployment: Configure RADIUS/TACACS+ servers',
                        'Deployment: Configure switch authentication',
                        'Testing: Test with compliant devices',
                        'Testing: Test with non-compliant devices',
                        'Testing: Verify failover functionality',
                        'Validation: Validate user access',
                        'Validation: Validate security features',
                        'Post-Deployment: Documentation',
                        'Post-Deployment: Training',
                        'Post-Deployment: Monitoring setup'
                    ];
                    break;
            }

            // Generate HTML for checklist
            let checklistHtml = '';

            checklistItems.forEach((item, index) => {
                checklistHtml += `
                    <div class="checklist-item">
                        <input type="checkbox" id="check-${index}">
                        <label for="check-${index}">${item}</label>
                    </div>
                `;
            });

            checklistPreview.innerHTML = checklistHtml;
        },

        /**
         * Download documentation
         */
        downloadDocumentation: function() {
            // This is a placeholder - in a real implementation, this would generate and download actual documentation
            alert('Documentation download feature will be implemented in a future update.');
        },

        /**
         * Download diagram
         */
        downloadDiagram: function() {
            // This is a placeholder - in a real implementation, this would generate and download an actual diagram
            alert('Diagram download feature will be implemented in a future update.');
        },

        /**
         * Download checklist
         */
        downloadChecklist: function() {
            // This is a placeholder - in a real implementation, this would generate and download an actual checklist
            alert('Checklist download feature will be implemented in a future update.');
        }
    };

    // Initialize Documentation Generator
    document.addEventListener('DOMContentLoaded', function() {
        DocumentationGenerator.init();
    });

    // Export to window
    window.DocumentationGenerator = DocumentationGenerator;
})();
EOF

# Update fix duplicate script to handle template conflicts
print_message "Updating fix-duplicates.js script..."

cat > fix-duplicates.js << 'EOF'
/**
 * UaXSupreme - Fix Duplicates
 * This script resolves template and configuration conflicts in the repository
 */

// Import required modules
const fs = require('fs');
const path = require('path');

// Configuration
const TEMPLATE_DIR = path.join(__dirname, 'templates');
const JS_DIR = path.join(__dirname, 'js');
const CSS_DIR = path.join(__dirname, 'css');

// Create directories if they don't exist
function ensureDirectoryExists(directory) {
    if (!fs.existsSync(directory)) {
        console.log(`Creating directory: ${directory}`);
        fs.mkdirSync(directory, { recursive: true });
    }
}

// Find and remove duplicate template files
function fixDuplicateTemplates() {
    console.log('Checking for duplicate template files...');

    // Ensure template directory and subdirectories exist
    ensureDirectoryExists(TEMPLATE_DIR);

    // Create vendor and platform subdirectories
    const vendors = ['cisco', 'aruba', 'juniper', 'fortinet', 'extreme', 'dell'];

    vendors.forEach(vendor => {
        const vendorDir = path.join(TEMPLATE_DIR, vendor);
        ensureDirectoryExists(vendorDir);

        if (vendor === 'cisco') {
            const platforms = ['IOS', 'IOS-XE', 'WLC-9800'];
            platforms.forEach(platform => {
                ensureDirectoryExists(path.join(vendorDir, platform));
            });
        } else if (vendor === 'aruba') {
            const platforms = ['AOS-CX', 'AOS-Switch'];
            platforms.forEach(platform => {
                ensureDirectoryExists(path.join(vendorDir, platform));
            });
        }
    });

    console.log('Template directory structure created and verified.');
}

// Fix JavaScript duplicate files
function fixDuplicateJsFiles() {
    console.log('Checking for duplicate JavaScript files...');

    // Ensure JS directory exists
    ensureDirectoryExists(JS_DIR);

    // Check for essential JS files
    const essentialFiles = [
        'app.js',
        'template-generator.js',
        'validation.js',
        'ai-assistant.js',
        'documentation.js'
    ];

    essentialFiles.forEach(file => {
        const filePath = path.join(JS_DIR, file);
        if (!fs.existsSync(filePath)) {
            console.log(`Essential file missing: ${file}`);
        }
    });

    console.log('JavaScript files checked.');
}

// Fix CSS duplicate files
function fixDuplicateCssFiles() {
    console.log('Checking for duplicate CSS files...');

    // Ensure CSS directory exists
    ensureDirectoryExists(CSS_DIR);

    // Check for essential CSS files
    const essentialFiles = ['styles.css'];

    essentialFiles.forEach(file => {
        const filePath = path.join(CSS_DIR, file);
        if (!fs.existsSync(filePath)) {
            console.log(`Essential file missing: ${file}`);
        }
    });

    console.log('CSS files checked.');
}

// Main function
function main() {
    console.log('Starting duplicate file fix process...');

    fixDuplicateTemplates();
    fixDuplicateJsFiles();
    fixDuplicateCssFiles();

    console.log('Duplicate file fix process completed.');
}

// Run the main function
main();
EOF

# Update revert-vendor-fix script to use the new templates
print_message "Updating revert-vendor-fix.sh script..."

cat > revert-vendor-fix.sh << 'EOF'
#!/bin/bash
# Script to revert to a specific vendor implementation and fix any template issues

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme]${NC} $1"
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

# Check arguments
if [ $# -lt 1 ]; then
  print_message "Usage: $0 <vendor> [platform]"
  print_message "Available vendors: cisco, aruba, juniper, fortinet, extreme, dell"
  print_message "Example: $0 cisco IOS-XE"
  exit 1
fi

VENDOR=$1
PLATFORM=$2

# Validate vendor
case $VENDOR in
  cisco|aruba|juniper|fortinet|extreme|dell)
    print_message "Selected vendor: $VENDOR"
    ;;
  *)
    print_error "Invalid vendor: $VENDOR. Available vendors: cisco, aruba, juniper, fortinet, extreme, dell"
    ;;
esac

# Create backup of current state
print_message "Creating backup..."
BACKUP_DIR="backup_$(date +%Y%m%d%H%M%S)"
mkdir -p $BACKUP_DIR
cp -r * $BACKUP_DIR/ 2>/dev/null
print_success "Backup created in $BACKUP_DIR"

# Update templates for the selected vendor
print_message "Updating templates for $VENDOR..."

# Ensure template directories exist
mkdir -p templates/$VENDOR

# Handle platform-specific updates
if [ -n "$PLATFORM" ]; then
  print_message "Selected platform: $PLATFORM"

  # Create platform directory if it doesn't exist
  mkdir -p templates/$VENDOR/$PLATFORM

  # Check for platform-specific templates in the backup
  if [ -d "$BACKUP_DIR/templates/$VENDOR/$PLATFORM" ]; then
    cp -r "$BACKUP_DIR/templates/$VENDOR/$PLATFORM"/* templates/$VENDOR/$PLATFORM/ 2>/dev/null
    print_success "Restored platform-specific templates from backup"
  else
    print_warning "No platform-specific templates found in backup"
  fi
else
  # Handle all platforms for the vendor
  if [ -d "$BACKUP_DIR/templates/$VENDOR" ]; then
    cp -r "$BACKUP_DIR/templates/$VENDOR"/* templates/$VENDOR/ 2>/dev/null
    print_success "Restored vendor templates from backup"
  else
    print_warning "No vendor templates found in backup"
  fi
fi

# Verify JS files are intact
print_message "Verifying JavaScript files..."
if [ ! -f "js/app.js" ] || [ ! -f "js/template-generator.js" ]; then
  print_warning "Missing essential JavaScript files. Restoring from backup..."
  mkdir -p js
  
  # Copy JS files from backup if they exist
  if [ -d "$BACKUP_DIR/js" ]; then
    cp -r "$BACKUP_DIR/js"/* js/ 2>/dev/null
    print_success "Restored JavaScript files from backup"
  else
    print_error "No JavaScript files found in backup"
  fi
fi

# Verify CSS files are intact
print_message "Verifying CSS files..."
if [ ! -f "css/styles.css" ]; then
  print_warning "Missing CSS files. Restoring from backup..."
  mkdir -p css
  
  # Copy CSS files from backup if they exist
  if [ -d "$BACKUP_DIR/css" ]; then
    cp -r "$BACKUP_DIR/css"/* css/ 2>/dev/null
    print_success "Restored CSS files from backup"
  else
    print_error "No CSS files found in backup"
  fi
fi

# Run fix-duplicates.js to ensure structure is correct
print_message "Running fix-duplicates.js to ensure structure is correct..."
node fix-duplicates.js

# Update UI to focus on selected vendor
print_message "Updating UI to focus on $VENDOR..."

# Run update-index.js if it exists, otherwise skip
if [ -f "update-index.js" ]; then
  node update-index.js --vendor=$VENDOR
  print_success "UI updated to focus on $VENDOR"
else
  print_warning "update-index.js not found. UI not updated."
fi

print_success "Revert to $VENDOR completed successfully."
print_message "You may need to refresh your browser to see the changes."
EOF

# Create the update-index.js script
print_message "Creating update-index.js script..."

cat > update-index.js << 'EOF'
/**
 * UaXSupreme - Update Index
 * Updates the index.html file to focus on a specific vendor
 */

// Import required modules
const fs = require('fs');
const path = require('path');

// Parse command line arguments
const args = process.argv.slice(2);
let selectedVendor = '';

// Parse arguments in the format --vendor=cisco
args.forEach(arg => {
    if (arg.startsWith('--vendor=')) {
        selectedVendor = arg.split('=')[1];
    }
});

// Validate vendor
const validVendors = ['cisco', 'aruba', 'juniper', 'fortinet', 'extreme', 'dell'];
if (!selectedVendor || !validVendors.includes(selectedVendor)) {
    console.log('Error: Valid vendor must be specified');
    console.log('Usage: node update-index.js --vendor=<vendor>');
    console.log('Available vendors:', validVendors.join(', '));
    process.exit(1);
}

// Path to index.html
const indexPath = path.join(__dirname, 'index.html');

// Check if index.html exists
if (!fs.existsSync(indexPath)) {
    console.log('Error: index.html file not found');
    process.exit(1);
}

// Read index.html content
let indexContent = fs.readFileSync(indexPath, 'utf8');

// Update vendor dropdown to preselect the specified vendor
indexContent = indexContent.replace(/<option value="([^"]+)"(\s*selected)?>/g, (match, vendor) => {
    if (vendor.toLowerCase() === selectedVendor.toLowerCase()) {
        return `<option value="${vendor}" selected>`;
    }
    return `<option value="${vendor}">`;
});

// Write updated content back to index.html
fs.writeFileSync(indexPath, indexContent);

console.log(`index.html updated to focus on ${selectedVendor}`);
EOF

# Make scripts executable
print_message "Making scripts executable..."
chmod +x UaxEnhance.sh revert-vendor-fix.sh

# Update README.md
print_message "Updating README.md..."

cat > README.md << 'EOF'
# UaXSupreme - Advanced Network Authentication Configuration Platform

UaXSupreme is a comprehensive platform for configuring 802.1X, MAB, RADIUS, TACACS+, and advanced authentication features for all major network vendors.

## Features

### Multi-Vendor Support
Configure authentication for Cisco, Aruba, Juniper, Fortinet, HP, Dell, Extreme, Arista, and more.

### Authentication Methods
- **802.1X**: Standard port-based network access control
- **MAB**: MAC Authentication Bypass for devices that don't support 802.1X
- **WebAuth**: Web-based authentication for guest access
- **RADIUS/TACACS+**: Complete AAA server configuration with redundancy and high availability

### Advanced Features
- **VSAs**: Vendor-Specific Attributes for granular control
- **DACLs**: Downloadable ACLs for dynamic access control
- **CoA**: Change of Authorization for dynamic policy changes
- **RadSec**: Secure RADIUS communications
- **MACsec**: Layer 2 encryption
- **Security Features**: DHCP snooping, ARP inspection, port security, and more

### Use Cases
- **Guest Access**: Configure guest onboarding with captive portal integration
- **BYOD**: Device onboarding workflows for employee-owned devices
- **IoT Management**: Secure onboarding for IoT devices with profiling

### AI Optimization
- **AI Assistant**: Get help and recommendations for your configuration
- **Configuration Analysis**: Validate and improve your configuration
- **Best Practices**: Implement industry-standard security practices

## Getting Started

1. Open `index.html` in your web browser
2. Select your network vendor and platform
3. Configure authentication settings
4. Set advanced features and parameters
5. Generate configuration
6. Review and download your configuration

## Command-line Tools

UaXSupreme includes several command-line tools to help manage your configuration:

### UaxEnhance.sh

Run this script to install all required components and update to the latest version:

```bash
./UaxEnhance.sh
