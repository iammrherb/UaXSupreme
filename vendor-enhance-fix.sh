#!/bin/bash

# =====================================================
# Dot1Xer Enhancement Script
# Version: 2.0.0
# Description: Enhances Dot1Xer with comprehensive vendor configurations
# and advanced authentication settings
# =====================================================

# Set script variables
APP_DIR="$(pwd)"
TEMPLATES_DIR="${APP_DIR}/templates"
VENDOR_DIR="${TEMPLATES_DIR}/vendors"
CSS_DIR="${APP_DIR}/css"
JS_DIR="${APP_DIR}/js"
BACKUP_DIR="${APP_DIR}/backup_$(date +%Y%m%d_%H%M%S)"

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# =====================================================
# Helper Functions
# =====================================================

# Display progress message
progress() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

# Display warning message
warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Display error message and exit
error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Check if directory exists
check_dir() {
  if [ ! -d "$1" ]; then
    error "Directory $1 not found. Please run this script from the Dot1Xer root directory."
  fi
}

# Create directory if it doesn't exist
create_dir() {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
    progress "Created directory: $1"
  fi
}

# Create backup of existing files
create_backup() {
  progress "Creating backup of existing configuration..."
  mkdir -p "$BACKUP_DIR"
  cp -r "$TEMPLATES_DIR" "$BACKUP_DIR/templates"
  cp -r "$CSS_DIR" "$BACKUP_DIR/css"
  cp -r "$JS_DIR" "$BACKUP_DIR/js"
  progress "Backup created in $BACKUP_DIR"
}

# =====================================================
# Configuration Setup Functions
# =====================================================

# Setup vendor directories
setup_vendor_dirs() {
  progress "Setting up vendor directories..."
  
  # List of all vendors to support
  vendors=(
    "cisco" "aruba" "juniper" "hp" "extreme" "dell" 
    "fortinet" "paloalto" "checkpoint" "sonicwall" 
    "watchguard" "arista" "brocade" "cambium" "ruckus"
    "ubiquiti" "meraki" "alcatel" "huawei" "arubaio"
    "avaya" "enterasys" "sophos" "netgear"
  )
  
  # Create directories for each vendor
  for vendor in "${vendors[@]}"; do
    create_dir "${VENDOR_DIR}/$vendor"
    
    # Create platform subdirectories for vendors with multiple platforms
    case $vendor in
      "cisco")
        create_dir "${VENDOR_DIR}/$vendor/ios"
        create_dir "${VENDOR_DIR}/$vendor/ios-xe"
        create_dir "${VENDOR_DIR}/$vendor/nx-os"
        create_dir "${VENDOR_DIR}/$vendor/wlc-9800"
        ;;
      "aruba")
        create_dir "${VENDOR_DIR}/$vendor/aos-cx"
        create_dir "${VENDOR_DIR}/$vendor/aos-switch"
        ;;
      "hp")
        create_dir "${VENDOR_DIR}/$vendor/procurve"
        create_dir "${VENDOR_DIR}/$vendor/aruba-switch"
        ;;
      "juniper")
        create_dir "${VENDOR_DIR}/$vendor/junos"
        create_dir "${VENDOR_DIR}/$vendor/mist"
        ;;
      "extreme")
        create_dir "${VENDOR_DIR}/$vendor/exos"
        create_dir "${VENDOR_DIR}/$vendor/voss"
        ;;
      "fortinet")
        create_dir "${VENDOR_DIR}/$vendor/fortiswitch"
        create_dir "${VENDOR_DIR}/$vendor/fortigate"
        ;;
    esac
  done
  
  progress "Vendor directory structure created successfully"
}

# Create comprehensive configuration templates
create_templates() {
  progress "Creating comprehensive configuration templates..."
  
  # Cisco IOS/IOS-XE Templates
  progress "Generating Cisco templates..."
  cat > "${VENDOR_DIR}/cisco/ios-xe/dot1x-mab-template.txt" << 'EOL'
! Cisco IOS-XE IBNS 2.0 802.1X and MAB Authentication Configuration
! Based on best practices from wiresandwi.fi and Cisco documentation
!
! Global AAA Configuration
authentication convert-to new-style yes

! Logging Configuration
logging discriminator NO-DOT1X facility drops AUTHMGR|MAB|DOT1X|EPM
logging buffered discriminator NO-DOT1X informational
logging host {{SYSLOG_SERVER}} discriminator NO-DOT1X

! Time Configuration
clock timezone {{TIMEZONE}} {{TIMEZONE_OFFSET}}
clock summer-time {{DAYLIGHT_TIMEZONE}} recurring {{DST_START}} {{DST_END}}
service timestamps debug datetime msec localtime show-timezone
service timestamps log datetime msec localtime show-timezone

! RADIUS Test User
username {{RADIUS_TEST_USER}} privilege 0 algorithm-type sha256 secret {{RADIUS_TEST_PASSWORD}}
username {{RADIUS_TEST_USER}} autocommand exit

! Domain Configuration
ip domain name {{DOMAIN_NAME}}

! AAA Configuration
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{RADIUS_GROUP}}
aaa authorization network default group {{RADIUS_GROUP}}
aaa authorization auth-proxy default group {{RADIUS_GROUP}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{RADIUS_GROUP}}
aaa accounting network default start-stop group {{RADIUS_GROUP}}

! RADIUS Server Configuration
radius server {{RADIUS_SERVER_1}}
 address ipv4 {{RADIUS_SERVER_1_IP}} auth-port 1812 acct-port 1813
 automate-tester username {{RADIUS_TEST_USER}} probe-on
 key {{RADIUS_SERVER_1_KEY}}
 timeout 2
 retransmit 2

radius server {{RADIUS_SERVER_2}}
 address ipv4 {{RADIUS_SERVER_2_IP}} auth-port 1812 acct-port 1813
 automate-tester username {{RADIUS_TEST_USER}} probe-on
 key {{RADIUS_SERVER_2_KEY}}
 timeout 2
 retransmit 2

! RADIUS Server Group
aaa group server radius {{RADIUS_GROUP}}
 server name {{RADIUS_SERVER_1}}
 server name {{RADIUS_SERVER_2}}
 deadtime 15

! RADIUS CoA Configuration
aaa server radius dynamic-author
 client {{RADIUS_SERVER_1_IP}} server-key {{RADIUS_SERVER_1_KEY}}
 client {{RADIUS_SERVER_2_IP}} server-key {{RADIUS_SERVER_2_KEY}}
 auth-type any

! RADIUS Attribute Configuration
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

! Source Interface Configuration
ip radius source-interface {{MANAGEMENT_INTERFACE}}
snmp-server trap-source {{MANAGEMENT_INTERFACE}}
snmp-server source-interface informs {{MANAGEMENT_INTERFACE}}
ntp source {{MANAGEMENT_INTERFACE}}
ntp server {{NTP_SERVER}}

! 802.1X System Authentication Control
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay 2000
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking and DHCP Snooping
ip dhcp snooping
no ip dhcp snooping information option
ip dhcp snooping vlan 1-4094
ip dhcp snooping database flash:dhcp-snooping-db.txt
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

! Device Classifier
device classifier

! Device Sensor Configuration
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

device-sensor notify all-changes
access-session attributes filter-list list DS_SEND_LIST
 cdp
 lldp
 dhcp
access-session accounting attributes filter-spec include list DS_SEND_LIST
access-session authentication attributes filter-spec include list DS_SEND_LIST

! Service Templates for Critical Authentication
service-template CRITICAL_DATA_ACCESS
 vlan {{CRITICAL_VLAN}}
 access-group ACL-OPEN
service-template CRITICAL_VOICE_ACCESS
 voice vlan {{VOICE_VLAN}}
 access-group ACL-OPEN

! Class Maps for Authentication
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

! ACL for Open Access
ip access-list extended ACL-OPEN
 permit ip any any

! Policy Map for Sequential 802.1X then MAB Authentication
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

! Port Templates
template WIRED_DOT1X_OPEN
 dot1x pae authenticator
 dot1x timeout tx-period {{TX_PERIOD}}
 dot1x max-reauth-req 2
 mab
 subscriber aging inactivity-timer 60 probe
 access-session control-direction in
 access-session host-mode {{HOST_MODE}}
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate {{REAUTH_PERIOD}}
 service-policy type control subscriber DOT1X_MAB_POLICY

template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{TX_PERIOD}}
 dot1x max-reauth-req 2
 mab
 subscriber aging inactivity-timer 60 probe
 access-session control-direction in
 access-session host-mode {{HOST_MODE}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate {{REAUTH_PERIOD}}
 service-policy type control subscriber DOT1X_MAB_POLICY

! Interface Configuration Examples
! Example Trunk Port
interface {{TRUNK_INTERFACE}}
 switchport mode trunk
 switchport nonegotiate
 ip dhcp snooping trust
 no access-session monitor
 device-tracking attach-policy DISABLE-IP-TRACKING

! Example Access Port
interface {{ACCESS_INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{DATA_VLAN}}
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
 ! Choose appropriate template based on authentication mode
 source template {{TEMPLATE_NAME}}
EOL

  cat > "${VENDOR_DIR}/cisco/ios/dot1x-mab-concurrent-template.txt" << 'EOL'
! Cisco IOS IBNS 2.0 Concurrent 802.1X and MAB Authentication Configuration
! Based on best practices from wiresandwi.fi
!
! NOTE: This template is focused on the policy-map for concurrent authentication.
! The rest of the global configuration is identical to the sequential template.
! Use this policy-map in conjunction with the standard global config.

! Policy Map for Concurrent 802.1X and MAB Authentication
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

! Port Templates for Concurrent Authentication
template WIRED_DOT1X_OPEN_CONCURRENT
 dot1x pae authenticator
 dot1x timeout tx-period {{TX_PERIOD}}
 dot1x max-reauth-req 2
 mab
 subscriber aging inactivity-timer 60 probe
 access-session control-direction in
 access-session host-mode {{HOST_MODE}}
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate {{REAUTH_PERIOD}}
 service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY

template WIRED_DOT1X_CLOSED_CONCURRENT
 dot1x pae authenticator
 dot1x timeout tx-period {{TX_PERIOD}}
 dot1x max-reauth-req 2
 mab
 subscriber aging inactivity-timer 60 probe
 access-session control-direction in
 access-session host-mode {{HOST_MODE}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate {{REAUTH_PERIOD}}
 service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY
EOL

  cat > "${VENDOR_DIR}/cisco/ios/radsec-template.txt" << 'EOL'
! Cisco IOS RadSec Configuration (RADIUS over DTLS)
! Based on best practices from wiresandwi.fi and Cisco documentation
!
! Prerequisites:
! 1. Certificate needs to be installed on the switch
! 2. RADIUS server needs to be configured for RadSec
!
! RadSec Server Configuration
radius server {{RADSEC_SERVER_NAME}}
 address ipv4 {{RADSEC_SERVER_IP}}
 automate-tester username {{RADIUS_TEST_USER}} probe-on
 key radius/dtls
 dtls connectiontimeout 10
 dtls idletimeout 75
 dtls retries 15
 dtls ip radius source-interface {{MANAGEMENT_INTERFACE}}
 dtls match-server-identity hostname {{RADSEC_SERVER_HOSTNAME}}
 dtls port 2083
 dtls trustpoint client {{DEVICE_CERT_TRUSTPOINT}}
 dtls trustpoint server {{SERVER_CERT_TRUSTPOINT}}

! RADIUS Server Group with RadSec
aaa group server radius {{RADSEC_GROUP}}
 server name {{RADSEC_SERVER_NAME}}
 deadtime 15

! Change of Authorization (CoA) for RadSec
aaa server radius dynamic-author
 client {{RADSEC_SERVER_IP}} dtls client-tp {{DEVICE_CERT_TRUSTPOINT}} server-tp {{SERVER_CERT_TRUSTPOINT}}
 dtls ip radius source-interface {{MANAGEMENT_INTERFACE}}
 dtls port 2083
 auth-type any
EOL

  cat > "${VENDOR_DIR}/cisco/ios/tacacs-admin-template.txt" << 'EOL'
! Cisco IOS TACACS+ Configuration for Device Administration
! Based on best practices for TACACS+ device administration
!
! Local fallback account (use complex passwords in production)
username {{ADMIN_USERNAME}} privilege 15 algorithm-type sha256 secret {{ADMIN_PASSWORD}}
enable algorithm-type sha256 secret {{ENABLE_PASSWORD}}

! AAA Configuration
aaa new-model
aaa session-id common

! TACACS+ Server Configuration
tacacs server {{TACACS_SERVER_1}}
 address ipv4 {{TACACS_SERVER_1_IP}}
 key {{TACACS_SERVER_1_KEY}}
 timeout 5
 single-connection

tacacs server {{TACACS_SERVER_2}}
 address ipv4 {{TACACS_SERVER_2_IP}}
 key {{TACACS_SERVER_2_KEY}}
 timeout 5
 single-connection

! TACACS+ Server Group
aaa group server tacacs+ {{TACACS_GROUP}}
 server name {{TACACS_SERVER_1}}
 server name {{TACACS_SERVER_2}}
 ip tacacs source-interface {{MANAGEMENT_INTERFACE}}

! Authentication Method Lists
aaa authentication login default group {{TACACS_GROUP}} local
aaa authentication enable default group {{TACACS_GROUP}} enable

! Authorization Method Lists
aaa authorization config-commands
aaa authorization commands 0 default group {{TACACS_GROUP}} local 
aaa authorization commands 1 default group {{TACACS_GROUP}} local
aaa authorization commands 15 default group {{TACACS_GROUP}} local
aaa authorization console

! Accounting Method Lists
aaa accounting commands 0 default start-stop group {{TACACS_GROUP}}
aaa accounting commands 1 default start-stop group {{TACACS_GROUP}}
aaa accounting commands 15 default start-stop group {{TACACS_GROUP}}
aaa accounting exec default start-stop group {{TACACS_GROUP}}

! Line Configuration
line con 0
 login authentication default
 authorization commands 15 default
 accounting commands 15 default

line vty 0 15
 login authentication default
 authorization commands 15 default
 accounting commands 15 default
 transport input ssh
EOL

  cat > "${VENDOR_DIR}/cisco/wlc-9800/radius-admin-template.txt" << 'EOL'
! Cisco WLC 9800 RADIUS Authentication Configuration
! Based on best practices from wiresandwi.fi and Cisco documentation
!
! Local fallback account
username {{ADMIN_USERNAME}} privilege 15 algorithm-type sha256 secret {{ADMIN_PASSWORD}}
enable algorithm-type sha256 secret {{ENABLE_PASSWORD}}

! Create non-usable account for RADIUS server probing
username {{RADIUS_TEST_USER}} privilege 0 algorithm-type sha256 secret {{RADIUS_TEST_PASSWORD}}
username {{RADIUS_TEST_USER}} autocommand exit

! Enable AAA services
aaa new-model

! Configure RADIUS servers
radius server {{RADIUS_SERVER_1}}
 address ipv4 {{RADIUS_SERVER_1_IP}} auth-port 1812 acct-port 1813
 timeout 2
 retransmit 2
 automate-tester username {{RADIUS_TEST_USER}} probe-on
 key {{RADIUS_SERVER_1_KEY}}

radius server {{RADIUS_SERVER_2}}
 address ipv4 {{RADIUS_SERVER_2_IP}} auth-port 1812 acct-port 1813
 timeout 2
 retransmit 2
 automate-tester username {{RADIUS_TEST_USER}} probe-on
 key {{RADIUS_SERVER_2_KEY}}

! Configure RADIUS Server Group
aaa group server radius {{RADIUS_ADMIN_GROUP}}
 server name {{RADIUS_SERVER_1}}
 server name {{RADIUS_SERVER_2}}
 deadtime 15

! Configure source interface if needed
! aaa group server radius {{RADIUS_ADMIN_GROUP}}
!  ip vrf forwarding {{VRF_NAME}}
!  ip radius source-interface {{SOURCE_INTERFACE}}
! radius-server load-balance method least-outstanding
! radius-server dead-criteria time 5 tries 3

! Create Method List for RADIUS authentication (RADIUS first, then local fallback)
aaa authentication login {{ADMIN_AUTH_METHOD}} group {{RADIUS_ADMIN_GROUP}} local
aaa authorization exec {{ADMIN_AUTHZ_METHOD}} group {{RADIUS_ADMIN_GROUP}} local if-authenticated
aaa authorization console

! Configure Accounting
aaa accounting exec default start-stop group {{RADIUS_ADMIN_GROUP}}

! Activate AAA RADIUS for HTTPS Web GUI
ip http authentication aaa login-authentication {{ADMIN_AUTH_METHOD}}
ip http authentication aaa exec-authorization {{ADMIN_AUTHZ_METHOD}}

! Activate AAA RADIUS for NETCONF/RESTCONF authentication
yang-interfaces aaa authentication method-list {{ADMIN_AUTH_METHOD}}
yang-interfaces aaa authorization method-list {{ADMIN_AUTHZ_METHOD}}

! Restart HTTP/HTTPS services
no ip http server
no ip http secure-server
ip http server
ip http secure-server

! Activate AAA RADIUS authentication for SSH sessions
line vty 0 97
 exec-timeout 30 0
 login authentication {{ADMIN_AUTH_METHOD}}
 authorization exec {{ADMIN_AUTHZ_METHOD}}
 transport preferred none
 transport input ssh
 transport output none

! Activate AAA RADIUS authentication for the Console port
line con 0
 exec-timeout 15 0
 transport preferred none
 login authentication {{ADMIN_AUTH_METHOD}}
 authorization exec {{ADMIN_AUTHZ_METHOD}}
EOL

  cat > "${VENDOR_DIR}/cisco/wlc-9800/tacacs-admin-template.txt" << 'EOL'
! Cisco WLC 9800 TACACS+ Authentication Configuration
! Based on best practices from wiresandwi.fi and Cisco documentation
!
! Local fallback account
username {{ADMIN_USERNAME}} privilege 15 algorithm-type sha256 secret {{ADMIN_PASSWORD}}
enable algorithm-type sha256 secret {{ENABLE_PASSWORD}}

! Enable AAA services
aaa new-model

! Configure TACACS+ servers
tacacs server {{TACACS_SERVER_1}}
 address ipv4 {{TACACS_SERVER_1_IP}}
 key {{TACACS_SERVER_1_KEY}}
 timeout 1

tacacs server {{TACACS_SERVER_2}}
 address ipv4 {{TACACS_SERVER_2_IP}}
 key {{TACACS_SERVER_2_KEY}}
 timeout 1

! Configure TACACS+ Server Group
aaa group server tacacs+ {{TACACS_ADMIN_GROUP}}
 server name {{TACACS_SERVER_1}}
 server name {{TACACS_SERVER_2}}

! Configure source interface if needed
! aaa group server tacacs+ {{TACACS_ADMIN_GROUP}}
!  ip vrf forwarding {{VRF_NAME}}
!  ip tacacs source-interface {{SOURCE_INTERFACE}}

! Create Method List to use TACACS+ logins primarily.
! Fallback to Local User Accounts ONLY if all TACACS+ servers fail.
aaa authentication login {{TACACS_AUTH_METHOD}} group {{TACACS_ADMIN_GROUP}} local
aaa authorization exec {{TACACS_AUTHZ_METHOD}} group {{TACACS_ADMIN_GROUP}} local if-authenticated
aaa authorization console

! Configure Command Accounting
aaa accounting commands 0 default start-stop group {{TACACS_ADMIN_GROUP}}
aaa accounting commands 1 default start-stop group {{TACACS_ADMIN_GROUP}}
aaa accounting commands 15 default start-stop group {{TACACS_ADMIN_GROUP}}

! Activate AAA TACACS+ for HTTPS Web GUI
ip http authentication aaa login-authentication {{TACACS_AUTH_METHOD}}
ip http authentication aaa exec-authorization {{TACACS_AUTHZ_METHOD}}

! Activate AAA TACACS+ for NETCONF/RESTCONF authentication
yang-interfaces aaa authentication method-list {{TACACS_AUTH_METHOD}}
yang-interfaces aaa authorization method-list {{TACACS_AUTHZ_METHOD}}

! Restart HTTP/HTTPS services
no ip http server
no ip http secure-server
ip http server
ip http secure-server

! Activate AAA TACACS+ authentication for SSH sessions
line vty 0 97
 exec-timeout 30 0
 login authentication {{TACACS_AUTH_METHOD}}
 authorization exec {{TACACS_AUTHZ_METHOD}}
 transport preferred none
 transport input ssh
 transport output none

! Activate AAA TACACS+ authentication for the Console port
line con 0
 exec-timeout 15 0
 transport preferred none
 login authentication {{TACACS_AUTH_METHOD}}
 authorization exec {{TACACS_AUTHZ_METHOD}}
EOL

  # Juniper Templates
  progress "Generating Juniper templates..."
  cat > "${VENDOR_DIR}/juniper/junos/dot1x-template.txt" << 'EOL'
# Juniper JunOS 802.1X Configuration Template
# Based on best practices for 802.1X deployments
#
# RADIUS Configuration
system {
    radius-server {
        {{RADIUS_SERVER_1_IP}} {
            secret "{{RADIUS_SERVER_1_KEY}}";
            timeout 5;
            retry 3;
            source-address {{MGMT_IP}};
            port 1812;
            accounting-port 1813;
        }
        {{RADIUS_SERVER_2_IP}} {
            secret "{{RADIUS_SERVER_2_KEY}}";
            timeout 5;
            retry 3;
            source-address {{MGMT_IP}};
            port 1812;
            accounting-port 1813;
        }
    }
}

# Authentication Configuration
access {
    radius-server {
        {{RADIUS_SERVER_1_IP}} {
            secret "{{RADIUS_SERVER_1_KEY}}";
            timeout 5;
            retry 3;
            source-address {{MGMT_IP}};
            port 1812;
            accounting-port 1813;
        }
        {{RADIUS_SERVER_2_IP}} {
            secret "{{RADIUS_SERVER_2_KEY}}";
            timeout 5;
            retry 3;
            source-address {{MGMT_IP}};
            port 1812;
            accounting-port 1813;
        }
    }
    profile dot1x-profile {
        authentication-order [dot1x mac-radius];
        radius {
            authentication-server [{{RADIUS_SERVER_1_IP}} {{RADIUS_SERVER_2_IP}}];
            accounting-server [{{RADIUS_SERVER_1_IP}} {{RADIUS_SERVER_2_IP}}];
        }
        accounting {
            order radius;
            accounting-stop-on-failure;
            accounting-stop-on-access-deny;
        }
    }
}

# 802.1X Protocol Configuration
protocols {
    dot1x {
        authenticator {
            authentication-profile-name dot1x-profile;
            interface {
                {{INTERFACE_NAME}} {
                    supplicant multiple;
                    retries 2;
                    quiet-period {{QUIET_PERIOD}};
                    max-requests 2;
                    transmit-period {{TX_PERIOD}};
                    mac-radius {
                        restrict;
                    }
                    server-timeout 30;
                    supplicant-timeout 30;
                    reauthentication {{REAUTH_PERIOD}};
                    guest-vlan {{GUEST_VLAN}};
                    server-fail vlan-name {{CRITICAL_VLAN}};
                    server-reject-vlan {{AUTH_FAIL_VLAN}};
                }
            }
        }
    }
}

# VLAN Configuration
vlans {
    auth-vlan {
        vlan-id {{AUTH_VLAN_ID}};
    }
    unauth-vlan {
        vlan-id {{UNAUTH_VLAN_ID}};
    }
    guest-vlan {
        vlan-id {{GUEST_VLAN_ID}};
    }
    critical-vlan {
        vlan-id {{CRITICAL_VLAN_ID}};
    }
    auth-fail-vlan {
        vlan-id {{AUTH_FAIL_VLAN_ID}};
    }
    voice-vlan {
        vlan-id {{VOICE_VLAN_ID}};
    }
}

# Interface Configuration (Access Ports)
interfaces {
    {{ACCESS_INTERFACE}} {
        unit 0 {
            family ethernet-switching {
                interface-mode access;
                vlan {
                    members unauth-vlan;
                }
                voip {
                    vlan voice-vlan;
                }
            }
        }
    }
}

# Interface Configuration (Trunk Ports)
interfaces {
    {{TRUNK_INTERFACE}} {
        unit 0 {
            family ethernet-switching {
                interface-mode trunk;
                vlan {
                    members [ {{ALLOWED_VLAN_LIST}} ];
                }
            }
        }
    }
}
EOL

  # Aruba Templates
  progress "Generating Aruba templates..."
  cat > "${VENDOR_DIR}/aruba/aos-cx/dot1x-template.txt" << 'EOL'
! Aruba AOS-CX 802.1X Configuration Template
! Based on best practices for 802.1X deployments
!
! RADIUS Authentication Configuration
radius-server host {{RADIUS_SERVER_1_IP}} key {{RADIUS_SERVER_1_KEY}}
radius-server host {{RADIUS_SERVER_2_IP}} key {{RADIUS_SERVER_2_KEY}}

radius-server host {{RADIUS_SERVER_1_IP}} auth-port 1812 acct-port 1813
radius-server host {{RADIUS_SERVER_2_IP}} auth-port 1812 acct-port 1813

radius-server retransmit 3
radius-server timeout 5

! AAA Configuration
aaa authentication port-access eap-radius
aaa authentication dot1x default radius local
aaa authentication mac-auth default radius local
aaa authorization network default radius
aaa accounting network start-stop radius

! 802.1X and MAC Authentication Timers
aaa port-access auth-failure-vlan {{AUTH_FAILURE_VLAN}}
aaa port-access critical-vlan {{CRITICAL_VLAN}}
aaa port-access guest-vlan {{GUEST_VLAN}}

aaa port-access authenticator active
aaa port-access authenticator reauth-period {{REAUTH_PERIOD}}
aaa port-access authenticator quiet-period {{QUIET_PERIOD}}
aaa port-access authenticator tx-period {{TX_PERIOD}}
aaa port-access authenticator max-requests {{MAX_REQUEST}}
aaa port-access authenticator max-retries {{MAX_RETRIES}}

! Define 802.1X Authentication Profiles
aaa port-access authentication {{DOT1X_PROFILE}}
 authenticator
 active
 control unauthorized
 interface-mode port-control-mode
 use-lldp
 allow-mbv
 multiauth
 reauthenticate
 reauth-period {{REAUTH_PERIOD}}
 auth-fail-vlan {{AUTH_FAILURE_VLAN}}
 critical-vlan {{CRITICAL_VLAN}}
 voice-vlan {{VOICE_VLAN}}

! Define MAC Authentication Profiles
aaa port-access mac-auth {{MAB_PROFILE}}
 addr-format no-delimiter uppercase
 auth-vid {{AUTH_VLAN}}
 unauth-vid {{UNAUTH_VLAN}}
 reauth-period {{REAUTH_PERIOD}}

! Interface Configuration (Access Ports)
interface {{ACCESS_INTERFACE_RANGE}}
 no routing
 vlan access {{UNAUTH_VLAN}}
 aaa port-access authentication {{DOT1X_PROFILE}}
 aaa port-access mac-auth {{MAB_PROFILE}}
 spanning-tree bpdu-protection
 spanning-tree port-type admin-edge
 voice-vlan {{VOICE_VLAN}}
 no shutdown

! Interface Configuration (Trunk Ports)
interface {{TRUNK_INTERFACE}}
 no routing
 vlan trunk native {{NATIVE_VLAN}}
 vlan trunk allowed {{ALLOWED_VLAN_LIST}}
 no aaa port-access
 no shutdown
EOL

  # Fortinet Templates
  progress "Generating Fortinet templates..."
  cat > "${VENDOR_DIR}/fortinet/fortiswitch/dot1x-template.txt" << 'EOL'
# FortiSwitch 802.1X Configuration Template
# Based on best practices for 802.1X deployments

config system global
    set hostname "{{HOSTNAME}}"
end

# RADIUS Server Configuration
config user radius
    edit "{{RADIUS_NAME}}"
        set server "{{RADIUS_SERVER_1_IP}}"
        set secret "{{RADIUS_SERVER_1_KEY}}"
        set auth-type auto
        set source-ip "{{MGMT_IP}}"
        set nas-ip "{{MGMT_IP}}"
    next
    edit "{{RADIUS_NAME_2}}"
        set server "{{RADIUS_SERVER_2_IP}}"
        set secret "{{RADIUS_SERVER_2_KEY}}"
        set auth-type auto
        set source-ip "{{MGMT_IP}}"
        set nas-ip "{{MGMT_IP}}"
    next
end

# RADIUS User Group
config user group
    edit "RADIUS_GROUP"
        set member "{{RADIUS_NAME}}" "{{RADIUS_NAME_2}}"
    next
end

# 802.1X Security Policy
config switch security-feature 802-1X
    set radius-timeout 5
    set reauth-period {{REAUTH_PERIOD}}
    set max-reauth-attempt 3
    set link-down-auth deauthenticate
end

# Configure VLANs
config system interface
    edit "auth-vlan"
        set vdom "root"
        set ip "{{AUTH_VLAN_IP}} {{AUTH_VLAN_NETMASK}}"
        set allowaccess ping
        set vlanid {{AUTH_VLAN_ID}}
        set interface "internal"
    next
    edit "unauth-vlan"
        set vdom "root"
        set ip "{{UNAUTH_VLAN_IP}} {{UNAUTH_VLAN_NETMASK}}"
        set allowaccess ping
        set vlanid {{UNAUTH_VLAN_ID}}
        set interface "internal"
    next
    edit "guest-vlan"
        set vdom "root"
        set ip "{{GUEST_VLAN_IP}} {{GUEST_VLAN_NETMASK}}"
        set allowaccess ping
        set vlanid {{GUEST_VLAN_ID}}
        set interface "internal"
    next
    edit "voice-vlan"
        set vdom "root"
        set ip "{{VOICE_VLAN_IP}} {{VOICE_VLAN_NETMASK}}"
        set allowaccess ping
        set vlanid {{VOICE_VLAN_ID}}
        set interface "internal"
    next
end

# Configure 802.1X on ports
config switch interface
    edit "{{ACCESS_INTERFACE}}"
        set native-vlan {{UNAUTH_VLAN_ID}}
        set allowed-vlans "{{AUTH_VLAN_ID}}" "{{UNAUTH_VLAN_ID}}" "{{GUEST_VLAN_ID}}" "{{VOICE_VLAN_ID}}"
        set security-groups "RADIUS_GROUP"
        set snmp-index 1
        config 802-1X
            set port-control auto
            set guest-vlan {{GUEST_VLAN_ID}}
            set auth-fail-vlan {{UNAUTH_VLAN_ID}}
            set open-auth enable
            set security-mode {{SECURITY_MODE}}
            set radius-timeout-overwrite enable
            set voice-vlan {{VOICE_VLAN_ID}}
        end
    next
    edit "{{TRUNK_INTERFACE}}"
        set native-vlan {{NATIVE_VLAN_ID}}
        set allowed-vlans "{{ALLOWED_VLAN_LIST}}"
        set snmp-index 2
    next
end
EOL

  # HP/Aruba ProCurve Templates
  progress "Generating HP templates..."
  cat > "${VENDOR_DIR}/hp/procurve/dot1x-template.txt" << 'EOL'
! HP ProCurve 802.1X Configuration Template
! Based on best practices for 802.1X deployments
!
! RADIUS Authentication Configuration
radius-server host {{RADIUS_SERVER_1_IP}} key {{RADIUS_SERVER_1_KEY}}
radius-server host {{RADIUS_SERVER_2_IP}} key {{RADIUS_SERVER_2_KEY}}

radius-server host {{RADIUS_SERVER_1_IP}} auth-port 1812 acct-port 1813
radius-server host {{RADIUS_SERVER_2_IP}} auth-port 1812 acct-port 1813

radius-server timeout 5
radius-server retransmit 3
radius-server dead-time 15

! AAA Configuration
aaa authentication port-access eap-radius
aaa authentication dot1x default radius local
aaa authentication mac-auth default radius local
aaa authorization network default radius
aaa accounting network start-stop radius

! 802.1X Global Configuration
aaa port-access authenticator active
aaa port-access authenticator reauth-period {{REAUTH_PERIOD}}
aaa port-access authenticator quiet-period {{QUIET_PERIOD}}
aaa port-access authenticator tx-period {{TX_PERIOD}}
aaa port-access authenticator max-requests {{MAX_REQUEST}}
aaa port-access authenticator max-retries {{MAX_RETRIES}}

! MAC Address Format for MAB
aaa port-access mac-auth addr-format no-delimiter
aaa port-access mac-auth addr-format uppercase

! User Role Configuration
aaa authorization user-role name "Authenticated"
 vlan-id {{AUTH_VLAN}}

aaa authorization user-role name "Unauthenticated"
 vlan-id {{UNAUTH_VLAN}}

aaa authorization user-role name "VoIP"
 vlan-id {{VOICE_VLAN}}

! Interface Configuration (Access Ports)
interface {{ACCESS_INTERFACE_RANGE}}
 no routing
 aaa port-access authenticator active
 aaa port-access authenticator reauth-period {{REAUTH_PERIOD}}
 aaa port-access authenticator quiet-period {{QUIET_PERIOD}}
 aaa port-access authenticator tx-period {{TX_PERIOD}}
 aaa port-access authenticator max-requests {{MAX_REQUEST}}
 aaa port-access authenticator max-retries {{MAX_RETRIES}}
 aaa port-access authenticator client-limit {{CLIENT_LIMIT}}
 aaa port-access authenticator unauth-vid {{UNAUTH_VLAN}}
 aaa port-access authenticator auth-vid {{AUTH_VLAN}}
 aaa port-access authenticator logoff-period {{LOGOFF_PERIOD}}
 aaa port-access mac-auth
 aaa port-access mac-auth port-role {{PORT_ROLE}}
 aaa port-access mac-auth unauth-vid {{UNAUTH_VLAN}}
 aaa port-access mac-auth auth-vid {{AUTH_VLAN}}
 aaa port-access mac-auth logoff-period {{LOGOFF_PERIOD}}
 spanning-tree bpdu-protection
 spanning-tree admin-edge-port
 voice-vlan {{VOICE_VLAN}}

! Interface Configuration (Trunk Ports)
interface {{TRUNK_INTERFACE}}
 no routing
 trunk
 tagged vlan {{TAGGED_VLAN_LIST}}
 untagged vlan {{NATIVE_VLAN}}
 no aaa port-access authenticator active
 no aaa port-access mac-auth
EOL

  # Extreme Networks Templates
  progress "Generating Extreme Networks templates..."
  cat > "${VENDOR_DIR}/extreme/exos/dot1x-template.txt" << 'EOL'
# Extreme EXOS 802.1X Configuration Template
# Based on best practices for 802.1X deployments

# RADIUS Server Configuration
configure radius netlogin primary server {{RADIUS_SERVER_1_IP}} client-ip {{CLIENT_IP}} vr VR-Mgmt
configure radius netlogin primary shared-secret {{RADIUS_SERVER_1_KEY}}

configure radius netlogin secondary server {{RADIUS_SERVER_2_IP}} client-ip {{CLIENT_IP}} vr VR-Mgmt
configure radius netlogin secondary shared-secret {{RADIUS_SERVER_2_KEY}}

# Configure RADIUS attributes
configure radius netlogin "Filter-Id" vlan-name
configure radius-accounting netlogin primary server {{RADIUS_SERVER_1_IP}} client-ip {{CLIENT_IP}} vr VR-Mgmt
configure radius-accounting netlogin primary shared-secret {{RADIUS_SERVER_1_KEY}}

# Configure Network Login
enable netlogin dot1x
enable netlogin mac
configure netlogin add mac-list "allowed-macs.txt"
configure netlogin mac timers reauth-period {{REAUTH_PERIOD}}
configure netlogin dot1x timers quiet-period {{QUIET_PERIOD}}
configure netlogin dot1x timers tx-period {{TX_PERIOD}}
configure netlogin dot1x timers auth-hold-period 60
configure netlogin dot1x timers handshake-timeout 60
configure netlogin dot1x timers supplicant-response 30
configure netlogin dot1x timers server-timeout 30
configure netlogin dot1x timers reauthentication {{REAUTH_PERIOD}}

# VLAN Configuration
create vlan "auth" tag {{AUTH_VLAN_ID}}
create vlan "unauth" tag {{UNAUTH_VLAN_ID}}
create vlan "guest" tag {{GUEST_VLAN_ID}}
create vlan "voice" tag {{VOICE_VLAN_ID}}

# Configure NetLogin VLANs
configure netlogin vlan unauth
configure netlogin authentication failure vlan unauth
configure netlogin authentication service-unavailable vlan unauth

# Authentication Order and Mode
configure netlogin authentication mode {{AUTH_MODE}}
configure netlogin authentication protocol-order dot1x mac
configure netlogin authentication dot1x protocol eap-md5
configure netlogin guest-vlan enable guest

# Port Configuration
# Access ports
configure port {{ACCESS_PORTS}} display-string "802.1X Ports"
enable netlogin dot1x port {{ACCESS_PORTS}}
enable netlogin mac port {{ACCESS_PORTS}}
enable netlogin port {{ACCESS_PORTS}}
configure netlogin port {{ACCESS_PORTS}} mode mac-dot1x
configure netlogin port {{ACCESS_PORTS}} authentication mode {{AUTH_MODE}}
configure port {{ACCESS_PORTS}} vlan unauth
configure port {{ACCESS_PORTS}} tag-dot1q-mode tag-all

# Trunk ports
configure port {{TRUNK_PORTS}} display-string "Trunk Port"
disable netlogin port {{TRUNK_PORTS}}
configure port {{TRUNK_PORTS}} vlan add {{TRUNK_VLANS}} tagged
configure port {{TRUNK_PORTS}} vlan add {{NATIVE_VLAN}} untagged
EOL

  progress "Creating additional vendor templates..."
  # Create more vendor templates here for Arista, Dell, etc.
  
  progress "Configuration templates created successfully"
}

# Update index.html with enhanced UI components
update_ui() {
  progress "Updating UI components..."
  
  # Create enhanced CSS for flawless UI experience
  cat > "${CSS_DIR}/enhanced/dot1xer-ui.css" << 'EOL'
:root {
  /* Primary colors */
  --primary-50: #eef2ff;
  --primary-100: #e0e7ff;
  --primary-200: #c7d2fe;
  --primary-300: #a5b4fc;
  --primary-400: #818cf8;
  --primary-500: #6366f1;
  --primary-600: #4f46e5;
  --primary-700: #4338ca;
  --primary-800: #3730a3;
  --primary-900: #312e81;
  --primary-950: #1e1b4b;
  
  /* Secondary colors */
  --secondary-50: #f0fdfa;
  --secondary-100: #ccfbf1;
  --secondary-200: #99f6e4;
  --secondary-300: #5eead4;
  --secondary-400: #2dd4bf;
  --secondary-500: #14b8a6;
  --secondary-600: #0d9488;
  --secondary-700: #0f766e;
  --secondary-800: #115e59;
  --secondary-900: #134e4a;
  --secondary-950: #042f2e;
  
  /* Light theme */
  --light-bg: #ffffff;
  --light-surface: #f8fafc;
  --light-surface-hover: #f1f5f9;
  --light-border: #e2e8f0;
  --light-text: #0f172a;
  --light-text-secondary: #475569;
  
  /* Dark theme */
  --dark-bg: #0f172a;
  --dark-surface: #1e293b;
  --dark-surface-hover: #334155;
  --dark-border: #334155;
  --dark-text: #f8fafc;
  --dark-text-secondary: #cbd5e1;
  
  /* Base styles */
  --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  --shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  --radius-sm: 0.25rem;
  --radius: 0.5rem;
  --radius-lg: 0.75rem;
  --radius-full: 9999px;
  --transition: all 0.2s ease;
}

/* Vendor Grid */
.vendor-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 1rem;
  margin-bottom: 20px;
}

.vendor-card {
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 1.25rem 0.75rem;
  background-color: var(--light-surface);
  border: 1px solid var(--light-border);
  border-radius: var(--radius);
  cursor: pointer;
  transition: var(--transition);
  height: 130px;
}

.dark-theme .vendor-card {
  background-color: var(--dark-surface);
  border-color: var(--dark-border);
}

.vendor-card:hover {
  transform: translateY(-2px);
  box-shadow: var(--shadow);
  border-color: var(--primary-300);
}

.dark-theme .vendor-card:hover {
  border-color: var(--primary-600);
}

.vendor-card.selected {
  background-color: var(--primary-50);
  border-color: var(--primary-400);
  box-shadow: 0 0 0 2px rgba(99, 102, 241, 0.2);
}

.dark-theme .vendor-card.selected {
  background-color: rgba(99, 102, 241, 0.15);
  border-color: var(--primary-500);
}

.vendor-logo {
  height: 40px;
  width: 100px;
  object-fit: contain;
  margin-bottom: 0.75rem;
}

.vendor-name {
  font-weight: 600;
  font-size: 0.875rem;
  text-align: center;
  color: var(--light-text);
}

.dark-theme .vendor-name {
  color: var(--dark-text);
}

.vendor-type {
  position: absolute;
  top: 0.5rem;
  right: 0.5rem;
  font-size: 0.625rem;
  font-weight: 500;
  padding: 0.125rem 0.375rem;
  border-radius: var(--radius-full);
}

.vendor-type.both {
  background-color: var(--primary-100);
  color: var(--primary-700);
}

.dark-theme .vendor-type.both {
  background-color: rgba(99, 102, 241, 0.3);
  color: var(--primary-300);
}

.vendor-type.wired {
  background-color: var(--secondary-100);
  color: var(--secondary-700);
}

.dark-theme .vendor-type.wired {
  background-color: rgba(20, 184, 166, 0.3);
  color: var(--secondary-300);
}

.vendor-type.wireless {
  background-color: #fef3c7;
  color: #92400e;
}

.dark-theme .vendor-type.wireless {
  background-color: rgba(217, 70, 239, 0.3);
  color: #fbbf24;
}

/* Platform Details */
.platform-box {
  background-color: var(--light-surface);
  border: 1px solid var(--light-border);
  border-radius: var(--radius);
  padding: 1.5rem;
  margin-top: 1.5rem;
}

.dark-theme .platform-box {
  background-color: var(--dark-surface);
  border-color: var(--dark-border);
}

.platform-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 1rem;
}

.platform-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.platform-icon {
  width: 2.5rem;
  height: 2.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: var(--primary-50);
  color: var(--primary-600);
  border-radius: var(--radius);
  font-size: 1.25rem;
}

.dark-theme .platform-icon {
  background-color: rgba(99, 102, 241, 0.15);
  color: var(--primary-400);
}

.platform-title {
  margin: 0;
  font-size: 1.125rem;
  font-weight: 600;
  color: var(--light-text);
}

.dark-theme .platform-title {
  color: var(--dark-text);
}

.vendor-badge {
  display: inline-block;
  padding: 0.25rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 500;
  border-radius: var(--radius-full);
  background-color: var(--primary-100);
  color: var(--primary-700);
}

.dark-theme .vendor-badge {
  background-color: rgba(99, 102, 241, 0.15);
  color: var(--primary-300);
}

.platform-description {
  font-size: 0.875rem;
  color: var(--light-text-secondary);
  margin-bottom: 1.25rem;
}

.dark-theme .platform-description {
  color: var(--dark-text-secondary);
}

.capability-label {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  color: var(--light-text-secondary);
  margin-bottom: 0.5rem;
}

.dark-theme .capability-label {
  color: var(--dark-text-secondary);
}

.capability-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin-bottom: 1.5rem;
}

.capability-badge {
  display: inline-block;
  padding: 0.25rem 0.625rem;
  font-size: 0.75rem;
  font-weight: 500;
  border-radius: var(--radius-full);
  background-color: var(--light-surface-hover);
  color: var(--light-text-secondary);
  border: 1px solid var(--light-border);
}

.dark-theme .capability-badge {
  background-color: var(--dark-surface-hover);
  color: var(--dark-text-secondary);
  border-color: var(--dark-border);
}

/* Form Controls */
.form-group {
  margin-bottom: 1.25rem;
}

.form-label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  font-size: 0.875rem;
  color: var(--light-text);
}

.dark-theme .form-label {
  color: var(--dark-text);
}

.form-control {
  width: 100%;
  padding: 0.625rem 0.75rem;
  font-size: 0.875rem;
  border: 1px solid var(--light-border);
  border-radius: var(--radius);
  background-color: var(--light-bg);
  color: var(--light-text);
  transition: var(--transition);
}

.dark-theme .form-control {
  background-color: var(--dark-bg);
  border-color: var(--dark-border);
  color: var(--dark-text);
}

.form-control:focus {
  outline: none;
  border-color: var(--primary-500);
  box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.15);
}

.form-row {
  display: flex;
  gap: 1rem;
}

.form-col {
  flex: 1;
}

/* Button Styles */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  font-weight: 500;
  font-size: 0.875rem;
  line-height: 1.5;
  border-radius: var(--radius);
  transition: var(--transition);
  cursor: pointer;
  border: none;
}

.btn-primary {
  background: linear-gradient(90deg, var(--primary-600) 0%, var(--primary-500) 100%);
  color: white;
}

.btn-primary:hover {
  background: linear-gradient(90deg, var(--primary-700) 0%, var(--primary-600) 100%);
  box-shadow: 0 4px 6px -1px rgba(99, 102, 241, 0.3);
}

.btn-secondary {
  background-color: var(--light-surface);
  color: var(--light-text);
  border: 1px solid var(--light-border);
}

.dark-theme .btn-secondary {
  background-color: var(--dark-surface);
  color: var(--dark-text);
  border-color: var(--dark-border);
}

.btn-secondary:hover {
  background-color: var(--light-surface-hover);
  border-color: var(--light-text-secondary);
}

.dark-theme .btn-secondary:hover {
  background-color: var(--dark-surface-hover);
  border-color: var(--dark-text-secondary);
}

/* Tabs */
.tabs {
  margin-top: 1.5rem;
}

.tab-nav {
  display: flex;
  border-bottom: 1px solid var(--light-border);
  margin-bottom: 1rem;
}

.dark-theme .tab-nav {
  border-color: var(--dark-border);
}

.tab-item {
  padding: 0.75rem 1.25rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--light-text-secondary);
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: var(--transition);
}

.dark-theme .tab-item {
  color: var(--dark-text-secondary);
}

.tab-item:hover {
  color: var(--primary-600);
}

.dark-theme .tab-item:hover {
  color: var(--primary-400);
}

.tab-item.active {
  color: var(--primary-600);
  border-bottom-color: var(--primary-600);
}

.dark-theme .tab-item.active {
  color: var(--primary-400);
  border-bottom-color: var(--primary-400);
}

/* Media Queries */
@media (max-width: 768px) {
  .vendor-grid {
    grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
  }
  
  .form-row {
    flex-direction: column;
    gap: 0.75rem;
  }
  
  .platform-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 0.75rem;
  }
}
EOL

  # Create JavaScript for the enhanced vendor browser
  cat > "${JS_DIR}/enhanced/dot1xer-ui.js" << 'EOL'
// Enhanced Dot1Xer UI JavaScript

// Vendor data with comprehensive support information
const vendorData = {
  cisco: {
    name: "Cisco",
    platforms: ["IOS", "IOS-XE", "NX-OS", "WLC 9800"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "TACACS+", "RADIUS", "RadSec", "CoA", "Device Tracking", "Guest Access", "Dynamic ACLs", "MACsec"],
    description: "Comprehensive authentication templates for Cisco switches, routers, and wireless controllers."
  },
  aruba: {
    name: "Aruba",
    platforms: ["AOS-CX", "AOS-Switch", "Mobility Controller"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "TACACS+", "RADIUS", "ClearPass", "CoA", "Dynamic Role Assignment", "Guest Access"],
    description: "Authentication solutions for Aruba wired and wireless products."
  },
  juniper: {
    name: "Juniper",
    platforms: ["JunOS", "Mist"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "TACACS+", "RADIUS", "Guest Access", "Dynamic VLAN", "CoA", "Security Policies"],
    description: "Authentication configurations for Juniper Networks devices."
  },
  hp: {
    name: "HP",
    platforms: ["ProCurve", "Aruba Switch"],
    types: ["wired"],
    capabilities: ["802.1X", "MAB", "RADIUS", "CoA", "User Roles", "Device Profiling"],
    description: "Authentication templates for HP ProCurve and legacy Aruba switches."
  },
  fortinet: {
    name: "Fortinet",
    platforms: ["FortiSwitch", "FortiGate"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "RADIUS", "FortiAuthenticator", "User Identity", "Device Control"],
    description: "Authentication configurations for Fortinet security fabric."
  },
  extreme: {
    name: "Extreme",
    platforms: ["EXOS", "VOSS"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAB", "RADIUS", "Policy-Based Routing", "Network Access Control"],
    description: "Authentication templates for Extreme Networks switches and wireless."
  },
  dell: {
    name: "Dell",
    platforms: ["PowerSwitch", "Force10"],
    types: ["wired"],
    capabilities: ["802.1X", "MAB", "RADIUS", "Guest VLAN", "Authentication VLAN"],
    description: "Authentication configurations for Dell enterprise switches."
  },
  arista: {
    name: "Arista",
    platforms: ["EOS"],
    types: ["wired"],
    capabilities: ["802.1X", "MAB", "RADIUS", "TACACS+", "CoA", "Fallback Authentication"],
    description: "Authentication templates for Arista data center switches."
  },
  ubiquiti: {
    name: "Ubiquiti",
    platforms: ["UniFi"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "RADIUS", "Guest Networks", "User Groups"],
    description: "Authentication configurations for Ubiquiti UniFi products."
  },
  paloalto: {
    name: "Palo Alto",
    platforms: ["PAN-OS"],
    types: ["wired"],
    capabilities: ["802.1X", "RADIUS", "TACACS+", "User-ID", "Security Policies"],
    description: "Authentication templates for Palo Alto security appliances."
  },
  checkpoint: {
    name: "Check Point",
    platforms: ["Gaia"],
    types: ["wired"],
    capabilities: ["RADIUS", "TACACS+", "Identity Awareness", "Security Policies"],
    description: "Authentication configurations for Check Point security appliances."
  },
  ruckus: {
    name: "Ruckus",
    platforms: ["SmartZone", "ICX"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "RADIUS", "Dynamic VLAN", "Guest Access"],
    description: "Authentication templates for Ruckus switches and wireless."
  },
  meraki: {
    name: "Meraki",
    platforms: ["Dashboard"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "RADIUS", "Group Policies", "Guest Access"],
    description: "Authentication configurations for Cisco Meraki cloud managed devices."
  },
  sonicwall: {
    name: "SonicWall",
    platforms: ["SonicOS"],
    types: ["wired"],
    capabilities: ["RADIUS", "TACACS+", "User Groups", "Security Policies"],
    description: "Authentication templates for SonicWall security appliances."
  },
  huawei: {
    name: "Huawei",
    platforms: ["VRP"],
    types: ["wired", "wireless"],
    capabilities: ["802.1X", "MAC Authentication", "RADIUS", "Portal Authentication"],
    description: "Authentication configurations for Huawei enterprise products."
  }
};

// Initialize enhanced UI when document is ready
document.addEventListener('DOMContentLoaded', function() {
  // Initialize vendor grid with enhanced cards
  initVendorGrid();
  
  // Set up event listeners
  setupEventListeners();
  
  // Initialize platform selector
  initPlatformSelector();
  
  // Add dark mode support
  setupDarkMode();
});

// Initialize vendor grid with all available vendors
function initVendorGrid() {
  const vendorGrid = document.getElementById('vendor-grid');
  if (!vendorGrid) return;
  
  // Clear existing content
  vendorGrid.innerHTML = '';
  
  // Create vendor cards
  Object.keys(vendorData).forEach(vendorKey => {
    const vendor = vendorData[vendorKey];
    const card = createVendorCard(vendorKey, vendor);
    vendorGrid.appendChild(card);
  });
}

// Create a vendor card element
function createVendorCard(vendorKey, vendor) {
  const card = document.createElement('div');
  card.className = 'vendor-card';
  card.dataset.vendor = vendorKey;
  
  // Create vendor type badge
  const typeClass = getVendorTypeClass(vendor.types);
  const typeLabel = getVendorTypeLabel(vendor.types);
  
  // Create card content
  card.innerHTML = `
    <div class="vendor-type ${typeClass}">${typeLabel}</div>
    <img src="assets/images/vendors/${vendorKey}.png" alt="${vendor.name}" class="vendor-logo">
    <div class="vendor-name">${vendor.name}</div>
  `;
  
  // Add click event
  card.addEventListener('click', function() {
    selectVendor(vendorKey);
  });
  
  return card;
}

// Get CSS class for vendor type badge
function getVendorTypeClass(types) {
  if (types.includes('wired') && types.includes('wireless')) {
    return 'both';
  } else if (types.includes('wired')) {
    return 'wired';
  } else {
    return 'wireless';
  }
}

// Get label for vendor type badge
function getVendorTypeLabel(types) {
  if (types.includes('wired') && types.includes('wireless')) {
    return 'Wired & Wireless';
  } else if (types.includes('wired')) {
    return 'Wired';
  } else {
    return 'Wireless';
  }
}

// Handle vendor selection
function selectVendor(vendorKey) {
  // Update selected card styling
  document.querySelectorAll('.vendor-card').forEach(card => {
    card.classList.remove('selected');
  });
  
  const selectedCard = document.querySelector(`.vendor-card[data-vendor="${vendorKey}"]`);
  if (selectedCard) {
    selectedCard.classList.add('selected');
  }
  
  // Populate platform dropdown
  populatePlatformDropdown(vendorKey);
  
  // Update platform details
  updatePlatformDetails(vendorKey);
  
  // Enable next button
  const platformNext = document.getElementById('platform-next');
  if (platformNext) {
    platformNext.disabled = false;
  }
  
  // Save selection in localStorage
  localStorage.setItem('selectedVendor', vendorKey);
}

// Populate platform dropdown based on selected vendor
function populatePlatformDropdown(vendorKey) {
  const platformSelect = document.getElementById('platform-select');
  if (!platformSelect) return;
  
  // Clear existing options
  platformSelect.innerHTML = '';
  
  // Get platforms for selected vendor
  const vendor = vendorData[vendorKey];
  if (!vendor) return;
  
  // Create default option
  const defaultOption = document.createElement('option');
  defaultOption.value = '';
  defaultOption.textContent = 'Select a platform';
  platformSelect.appendChild(defaultOption);
  
  // Add platform options
  vendor.platforms.forEach(platform => {
    const option = document.createElement('option');
    option.value = platform.toLowerCase().replace(/\s+/g, '-');
    option.textContent = platform;
    platformSelect.appendChild(option);
  });
  
  // Enable the select
  platformSelect.disabled = false;
  
  // Add change event
  platformSelect.addEventListener('change', function() {
    updatePlatformDetails(vendorKey, this.value);
  });
}

// Update platform details section
function updatePlatformDetails(vendorKey, platformKey = null) {
  const platformDetails = document.getElementById('platform-details');
  if (!platformDetails) return;
  
  const vendor = vendorData[vendorKey];
  if (!vendor) return;
  
  // If no platform selected, show vendor overview
  if (!platformKey || platformKey === '') {
    platformDetails.innerHTML = `
      <div class="platform-box">
        <div class="platform-header">
          <div class="platform-info">
            <div class="platform-icon">
              <i class="fa fa-network-wired"></i>
            </div>
            <div>
              <h3 class="platform-title">${vendor.name}</h3>
              <span class="vendor-badge">${getVendorTypeLabel(vendor.types)}</span>
            </div>
          </div>
        </div>
        <p class="platform-description">${vendor.description}</p>
        <div class="capability-label">Supported Features</div>
        <div class="capability-badges">
          ${vendor.capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
        </div>
        <p>Select a platform from the dropdown above to see specific configuration options.</p>
      </div>
    `;
    return;
  }
  
  // Show platform-specific details
  const platformName = vendor.platforms.find(p => p.toLowerCase().replace(/\s+/g, '-') === platformKey);
  
  platformDetails.innerHTML = `
    <div class="platform-box">
      <div class="platform-header">
        <div class="platform-info">
          <div class="platform-icon">
            <i class="fa fa-server"></i>
          </div>
          <div>
            <h3 class="platform-title">${vendor.name} ${platformName}</h3>
            <span class="vendor-badge">${getVendorTypeLabel(vendor.types)}</span>
          </div>
        </div>
      </div>
      <p class="platform-description">
        Configure advanced authentication settings for ${vendor.name} ${platformName} devices including 802.1X, MAB, TACACS+, and more.
      </p>
      <div class="capability-label">Supported Features</div>
      <div class="capability-badges">
        ${vendor.capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
      </div>
      <div class="tabs">
        <div class="tab-nav">
          <div class="tab-item active" data-tab="overview">Overview</div>
          <div class="tab-item" data-tab="capabilities">Capabilities</div>
          <div class="tab-item" data-tab="requirements">Requirements</div>
        </div>
        <div class="tab-content">
          <p>This platform supports comprehensive authentication configuration including 802.1X, MAB, RADIUS, and more. Continue to the Authentication tab to configure these settings.</p>
        </div>
      </div>
    </div>
  `;
  
  // Set up tab navigation
  setupTabNavigation();
}

// Setup tab navigation in platform details
function setupTabNavigation() {
  const tabItems = document.querySelectorAll('.tab-item');
  
  tabItems.forEach(tab => {
    tab.addEventListener('click', function() {
      // Remove active class from all tabs
      tabItems.forEach(t => t.classList.remove('active'));
      
      // Add active class to clicked tab
      this.classList.add('active');
      
      // Update content (simplified for this example)
      const tabContent = document.querySelector('.tab-content');
      const tabName = this.dataset.tab;
      
      if (tabName === 'overview') {
        tabContent.innerHTML = '<p>This platform supports comprehensive authentication configuration including 802.1X, MAB, RADIUS, and more. Continue to the Authentication tab to configure these settings.</p>';
      } else if (tabName === 'capabilities') {
        tabContent.innerHTML = `
          <ul>
            <li><strong>802.1X Authentication:</strong> Support for standard-based port authentication</li>
            <li><strong>MAC Authentication Bypass (MAB):</strong> For legacy devices</li>
            <li><strong>Multi-Domain Authentication:</strong> Separate authentication for voice and data</li>
            <li><strong>Guest VLAN:</strong> For unauthenticated clients</li>
            <li><strong>RADIUS CoA:</strong> Dynamic policy changes post-authentication</li>
            <li><strong>TACACS+:</strong> For device administration</li>
          </ul>
        `;
      } else if (tabName === 'requirements') {
        tabContent.innerHTML = `
          <ul>
            <li><strong>RADIUS Server:</strong> Required for 802.1X and MAB authentication</li>
            <li><strong>Supplicant Software:</strong> Required on endpoints for 802.1X</li>
            <li><strong>VLAN Configuration:</strong> Separate VLANs for authenticated and guest access</li>
            <li><strong>Software Version:</strong> Latest recommended for full feature support</li>
          </ul>
        `;
      }
    });
  });
}

// Setup dark mode support
function setupDarkMode() {
  const storedTheme = localStorage.getItem('theme') || 'light';
  if (storedTheme === 'dark') {
    document.body.classList.add('dark-theme');
  }
  
  // Check for theme toggle button
  const themeToggle = document.getElementById('theme-toggle');
  if (themeToggle) {
    themeToggle.addEventListener('click', function() {
      document.body.classList.toggle('dark-theme');
      const isDark = document.body.classList.contains('dark-theme');
      localStorage.setItem('theme', isDark ? 'dark' : 'light');
    });
  }
}

// Setup event listeners
function setupEventListeners() {
  // Platform next button
  const platformNext = document.getElementById('platform-next');
  if (platformNext) {
    platformNext.addEventListener('click', function() {
      // Navigate to authentication tab
      const authTab = document.querySelector('.tab[data-tab="authentication"]');
      if (authTab) {
        document.querySelectorAll('.tab').forEach(tab => {
          tab.classList.remove('active');
        });
        authTab.classList.add('active');
        
        document.querySelectorAll('.tab-pane').forEach(pane => {
          pane.classList.remove('active');
        });
        document.getElementById('authentication').classList.add('active');
      }
    });
  }
  
  // Authentication tab controls
  const authPrev = document.getElementById('auth-prev');
  if (authPrev) {
    authPrev.addEventListener('click', function() {
      navigateTab('platform');
    });
  }
  
  const authNext = document.getElementById('auth-next');
  if (authNext) {
    authNext.addEventListener('click', function() {
      navigateTab('security');
    });
  }
  
  // Security tab controls
  const securityPrev = document.getElementById('security-prev');
  if (securityPrev) {
    securityPrev.addEventListener('click', function() {
      navigateTab('authentication');
    });
  }
  
  const securityNext = document.getElementById('security-next');
  if (securityNext) {
    securityNext.addEventListener('click', function() {
      navigateTab('network');
    });
  }
  
  // Network tab controls
  const networkPrev = document.getElementById('network-prev');
  if (networkPrev) {
    networkPrev.addEventListener('click', function() {
      navigateTab('security');
    });
  }
  
  const networkNext = document.getElementById('network-next');
  if (networkNext) {
    networkNext.addEventListener('click', function() {
      navigateTab('advanced');
    });
  }
  
  // Advanced tab controls
  const advancedPrev = document.getElementById('advanced-prev');
  if (advancedPrev) {
    advancedPrev.addEventListener('click', function() {
      navigateTab('network');
    });
  }
  
  const advancedNext = document.getElementById('advanced-next');
  if (advancedNext) {
    advancedNext.addEventListener('click', function() {
      navigateTab('preview');
    });
  }
  
  // Preview tab controls
  const previewPrev = document.getElementById('preview-prev');
  if (previewPrev) {
    previewPrev.addEventListener('click', function() {
      navigateTab('advanced');
    });
  }
  
  // Generate configuration button
  const generateConfig = document.getElementById('generate-config');
  if (generateConfig) {
    generateConfig.addEventListener('click', function() {
      generateConfiguration();
    });
  }
  
  // Copy configuration button
  const copyConfig = document.getElementById('copy-config');
  if (copyConfig) {
    copyConfig.addEventListener('click', function() {
      copyToClipboard();
    });
  }
  
  // Download configuration button
  const downloadConfig = document.getElementById('download-config');
  if (downloadConfig) {
    downloadConfig.addEventListener('click', function() {
      downloadConfiguration();
    });
  }
}

// Initialize platform selector
function initPlatformSelector() {
  // Try to restore previous selection
  const savedVendor = localStorage.getItem('selectedVendor');
  if (savedVendor && vendorData[savedVendor]) {
    selectVendor(savedVendor);
  }
}

// Navigate to a specific tab
function navigateTab(tabId) {
  // Activate tab
  document.querySelectorAll('.tab').forEach(tab => {
    tab.classList.remove('active');
  });
  document.querySelector(`.tab[data-tab="${tabId}"]`).classList.add('active');
  
  // Show tab content
  document.querySelectorAll('.tab-pane').forEach(pane => {
    pane.classList.remove('active');
  });
  document.getElementById(tabId).classList.add('active');
}

// Generate configuration based on user inputs
function generateConfiguration() {
  // Get selected vendor and platform
  const vendorKey = localStorage.getItem('selectedVendor');
  const platformSelect = document.getElementById('platform-select');
  const platformKey = platformSelect ? platformSelect.value : null;
  
  if (!vendorKey || !platformKey) {
    alert('Please select a vendor and platform first.');
    return;
  }
  
  // Gather form data
  const formData = gatherFormData();
  
  // Generate configuration template
  const config = generateTemplate(vendorKey, platformKey, formData);
  
  // Display in output area
  const configOutput = document.getElementById('config-output');
  if (configOutput) {
    configOutput.textContent = config;
  }
}

// Gather form data from all tabs
function gatherFormData() {
  return {
    // Authentication tab
    authMethod: document.getElementById('auth-method').value,
    authMode: document.querySelector('input[name="auth-mode"]:checked').value,
    hostMode: document.getElementById('host-mode').value,
    radiusServer1: document.getElementById('radius-server-1').value,
    radiusKey1: document.getElementById('radius-key-1').value,
    radiusAuthPort1: document.getElementById('radius-auth-port-1').value,
    radiusAcctPort1: document.getElementById('radius-acct-port-1').value,
    radiusServer2: document.getElementById('radius-server-2').value,
    radiusKey2: document.getElementById('radius-key-2').value,
    enableAccounting: document.getElementById('enable-accounting').checked,
    
    // Security tab
    reauthPeriod: document.getElementById('reauth-period').value,
    txPeriod: document.getElementById('tx-period').value,
    quietPeriod: document.getElementById('quiet-period').value,
    maxReauth: document.getElementById('max-reauth').value,
    useCoa: document.getElementById('use-coa').checked,
    useRadsec: document.getElementById('use-radsec').checked,
    useMacsec: document.getElementById('use-macsec').checked,
    enableDhcpSnooping: document.getElementById('enable-dhcp-snooping').checked,
    enableDai: document.getElementById('enable-dai').checked,
    enableIpsg: document.getElementById('enable-ipsg').checked,
    enablePortSecurity: document.getElementById('enable-port-security').checked,
    
    // Network tab
    enableDynamicVlan: document.getElementById('enable-dynamic-vlan').checked,
    vlanAuth: document.getElementById('vlan-auth').value,
    vlanUnauth: document.getElementById('vlan-unauth').value,
    vlanGuest: document.getElementById('vlan-guest').value,
    vlanVoice: document.getElementById('vlan-voice').value,
    interface: document.getElementById('interface').value,
    interfaceRange: document.getElementById('interface-range').value,
    
    // Advanced tab
    additionalCommands: document.getElementById('additional-commands').value
  };
}

// Generate configuration template based on vendor, platform and form data
function generateTemplate(vendorKey, platformKey, formData) {
  // Placeholder for actual template generation logic
  let config = `! ${vendorData[vendorKey].name} ${platformKey.replace(/-/g, ' ').toUpperCase()} Configuration\n`;
  config += `! Generated by Dot1Xer Enhanced Edition\n`;
  config += `! Date: ${new Date().toISOString().split('T')[0]}\n\n`;
  
  // Add authentication configuration
  config += `! Authentication Configuration\n`;
  config += `! Method: ${formData.authMethod}\n`;
  config += `! Mode: ${formData.authMode}\n`;
  config += `! Host Mode: ${formData.hostMode}\n\n`;
  
  // Add RADIUS server configuration
  config += `! RADIUS Server Configuration\n`;
  config += `radius-server host ${formData.radiusServer1} key ${formData.radiusKey1}\n`;
  if (formData.radiusServer2) {
    config += `radius-server host ${formData.radiusServer2} key ${formData.radiusKey2}\n`;
  }
  
  // Add 802.1X configuration
  config += `\n! 802.1X Configuration\n`;
  config += `dot1x system-auth-control\n`;
  
  // Add interface configuration
  config += `\n! Interface Configuration\n`;
  config += `interface ${formData.interface}\n`;
  config += `  switchport mode access\n`;
  config += `  switchport access vlan ${formData.vlanAuth}\n`;
  if (formData.vlanVoice) {
    config += `  switchport voice vlan ${formData.vlanVoice}\n`;
  }
  config += `  dot1x port-control ${formData.authMode === 'closed' ? 'auto' : 'force-authorized'}\n`;
  config += `  dot1x host-mode ${formData.hostMode}\n`;
  
  // Add additional commands if provided
  if (formData.additionalCommands) {
    config += `\n! Additional Commands\n${formData.additionalCommands}\n`;
  }
  
  return config;
}

// Copy configuration to clipboard
function copyToClipboard() {
  const configOutput = document.getElementById('config-output');
  if (!configOutput || !configOutput.textContent.trim()) {
    alert('Please generate a configuration first.');
    return;
  }
  
  // Create temporary textarea
  const textarea = document.createElement('textarea');
  textarea.value = configOutput.textContent;
  document.body.appendChild(textarea);
  
  // Select and copy
  textarea.select();
  document.execCommand('copy');
  
  // Clean up
  document.body.removeChild(textarea);
  
  // Show feedback
  alert('Configuration copied to clipboard!');
}

// Download configuration as a text file
function downloadConfiguration() {
  const configOutput = document.getElementById('config-output');
  if (!configOutput || !configOutput.textContent.trim()) {
    alert('Please generate a configuration first.');
    return;
  }
  
  // Get vendor and platform info
  const vendorKey = localStorage.getItem('selectedVendor');
  const platformSelect = document.getElementById('platform-select');
  const platformKey = platformSelect ? platformSelect.value : 'config';
  
  // Create filename
  const filename = `${vendorKey}-${platformKey}-config.txt`;
  
  // Create download link
  const element = document.createElement('a');
  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(configOutput.textContent));
  element.setAttribute('download', filename);
  
  // Simulate click and clean up
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
}
EOL

  # Create JS file for vendor data
  cat > "${JS_DIR}/vendors.js" << 'EOL'
// Vendor data for Dot1Xer
const vendors = {
  cisco: {
    name: "Cisco",
    platforms: [
      { id: "ios", name: "IOS", desc: "For older Cisco switches and routers" },
      { id: "ios-xe", name: "IOS-XE", desc: "For Catalyst 9000, 3650/3850, and newer platforms" },
      { id: "nx-os", name: "NX-OS", desc: "For Nexus data center switches" },
      { id: "wlc-9800", name: "WLC 9800", desc: "For Catalyst 9800 wireless controllers" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: true,
      coa: true,
      deviceTracking: true,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: true
    }
  },
  juniper: {
    name: "Juniper",
    platforms: [
      { id: "junos", name: "JunOS", desc: "For EX, QFX, and MX series devices" },
      { id: "mist", name: "Mist", desc: "For Mist wireless solutions" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: true,
      coa: true,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  aruba: {
    name: "Aruba",
    platforms: [
      { id: "aos-cx", name: "AOS-CX", desc: "For CX series switches" },
      { id: "aos-switch", name: "AOS-Switch", desc: "For Aruba switches" },
      { id: "mobility-controller", name: "Mobility Controller", desc: "For wireless controllers" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: true,
      coa: true,
      deviceTracking: true,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  hp: {
    name: "HP",
    platforms: [
      { id: "procurve", name: "ProCurve", desc: "For ProCurve switches" },
      { id: "aruba-switch", name: "Aruba Switch", desc: "For Aruba branded switches" }
    ],
    capabilities: {
      wired: true,
      wireless: false,
      vpn: false,
      tacacs: true,
      radsec: false,
      coa: true,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: false,
      macsec: false
    }
  },
  extreme: {
    name: "Extreme",
    platforms: [
      { id: "exos", name: "EXOS", desc: "For X-series switches" },
      { id: "voss", name: "VOSS", desc: "For VSP switches" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: false,
      tacacs: true,
      radsec: false,
      coa: true,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  fortinet: {
    name: "Fortinet",
    platforms: [
      { id: "fortiswitch", name: "FortiSwitch", desc: "For FortiSwitch devices" },
      { id: "fortigate", name: "FortiGate", desc: "For FortiGate firewalls with switch ports" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: true,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  dell: {
    name: "Dell",
    platforms: [
      { id: "powerswitch", name: "PowerSwitch", desc: "For Dell PowerSwitch series" },
      { id: "force10", name: "Force10", desc: "For legacy Force10 switches" }
    ],
    capabilities: {
      wired: true,
      wireless: false,
      vpn: false,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: false,
      macsec: false
    }
  },
  paloalto: {
    name: "Palo Alto",
    platforms: [
      { id: "panos", name: "PAN-OS", desc: "For Palo Alto Networks devices" }
    ],
    capabilities: {
      wired: true,
      wireless: false,
      vpn: true,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: false,
      guestAccess: true,
      iot: false,
      dVlan: false,
      dACL: true,
      macsec: false
    }
  },
  checkpoint: {
    name: "Check Point",
    platforms: [
      { id: "gaia", name: "Gaia", desc: "For Check Point Security Gateways" }
    ],
    capabilities: {
      wired: true,
      wireless: false,
      vpn: true,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: false,
      guestAccess: false,
      iot: false,
      dVlan: false,
      dACL: false,
      macsec: false
    }
  },
  arista: {
    name: "Arista",
    platforms: [
      { id: "eos", name: "EOS", desc: "For Arista EOS devices" }
    ],
    capabilities: {
      wired: true,
      wireless: false,
      vpn: false,
      tacacs: true,
      radsec: true,
      coa: true,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: true
    }
  },
  ruckus: {
    name: "Ruckus",
    platforms: [
      { id: "fastiron", name: "FastIron", desc: "For ICX switches" },
      { id: "smartzone", name: "SmartZone", desc: "For wireless controllers" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: false,
      tacacs: true,
      radsec: false,
      coa: true,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: false,
      macsec: false
    }
  },
  ubiquiti: {
    name: "Ubiquiti",
    platforms: [
      { id: "unifi", name: "UniFi", desc: "For UniFi network devices" },
      { id: "edgeswitch", name: "EdgeSwitch", desc: "For EdgeSwitch devices" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: false,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: false,
      dVlan: true,
      dACL: false,
      macsec: false
    }
  },
  meraki: {
    name: "Meraki",
    platforms: [
      { id: "ms", name: "MS Series", desc: "For Meraki switches" },
      { id: "mr", name: "MR Series", desc: "For Meraki wireless APs" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: false,
      radsec: false,
      coa: false,
      deviceTracking: true,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  avaya: {
    name: "Avaya",
    platforms: [
      { id: "ethernet-routing-switch", name: "Ethernet Routing Switch", desc: "For ERS switches" }
    ],
    capabilities: {
      wired: true,
      wireless: false,
      vpn: false,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: false,
      dVlan: true,
      dACL: false,
      macsec: false
    }
  },
  huawei: {
    name: "Huawei",
    platforms: [
      { id: "vrp", name: "VRP", desc: "For Huawei enterprise switches" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  alcatel: {
    name: "Alcatel-Lucent",
    platforms: [
      { id: "aos", name: "AOS", desc: "For OmniSwitch devices" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: false,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  sonicwall: {
    name: "SonicWall",
    platforms: [
      { id: "sonicos", name: "SonicOS", desc: "For SonicWall appliances" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: false,
      guestAccess: true,
      iot: false,
      dVlan: false,
      dACL: true,
      macsec: false
    }
  },
  watchguard: {
    name: "WatchGuard",
    platforms: [
      { id: "fireware", name: "Fireware", desc: "For WatchGuard appliances" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: false,
      guestAccess: true,
      iot: false,
      dVlan: false,
      dACL: true,
      macsec: false
    }
  },
  brocade: {
    name: "Brocade",
    platforms: [
      { id: "fastiron", name: "FastIron", desc: "For FastIron switches" },
      { id: "netiron", name: "NetIron", desc: "For NetIron switches" }
    ],
    capabilities: {
      wired: true,
      wireless: false,
      vpn: false,
      tacacs: true,
      radsec: false,
      coa: true,
      deviceTracking: false,
      mab: true,
      guestAccess: true,
      iot: true,
      dVlan: true,
      dACL: true,
      macsec: false
    }
  },
  sophos: {
    name: "Sophos",
    platforms: [
      { id: "xg", name: "XG Firewall", desc: "For Sophos XG Firewall" }
    ],
    capabilities: {
      wired: true,
      wireless: true,
      vpn: true,
      tacacs: true,
      radsec: false,
      coa: false,
      deviceTracking: false,
      mab: false,
      guestAccess: true,
      iot: false,
      dVlan: false,
      dACL: true,
      macsec: false
    }
  }
};

// Function to initialize the vendor grid
function initVendorGrid() {
  const vendorGrid = document.getElementById('vendor-grid');
  if (!vendorGrid) return;

  // Clear any existing content
  vendorGrid.innerHTML = '';

  // Create vendor logo containers
  Object.keys(vendors).forEach(key => {
    const vendor = vendors[key];
    const vendorType = getVendorType(vendor.capabilities);
    
    const logoContainer = document.createElement('div');
    logoContainer.className = 'vendor-logo-container';
    logoContainer.dataset.vendor = key;
    
    // Create logo image
    const logo = document.createElement('img');
    logo.src = `assets/vendors/${key}.png`;
    logo.alt = vendor.name;
    logo.className = 'vendor-logo';
    
    // Create vendor name
    const vendorName = document.createElement('div');
    vendorName.className = 'vendor-name';
    vendorName.textContent = vendor.name;
    
    // Create vendor type badge
    const vendorVariant = document.createElement('div');
    vendorVariant.className = 'vendor-variant';
    vendorVariant.textContent = vendorType;
    
    // Append elements to container
    logoContainer.appendChild(logo);
    logoContainer.appendChild(vendorName);
    logoContainer.appendChild(vendorVariant);
    
    // Add click handler
    logoContainer.addEventListener('click', function() {
      selectVendor(key);
    });
    
    // Add to grid
    vendorGrid.appendChild(logoContainer);
  });
}

// Function to determine vendor type based on capabilities
function getVendorType(capabilities) {
  if (capabilities.wired && capabilities.wireless) {
    return 'Wired & Wireless';
  } else if (capabilities.wired) {
    return 'Wired';
  } else if (capabilities.wireless) {
    return 'Wireless';
  } else {
    return 'Other';
  }
}

// Function to handle vendor selection
function selectVendor(vendorKey) {
  // Update visual selection
  document.querySelectorAll('.vendor-logo-container').forEach(el => {
    el.classList.remove('selected');
  });
  
  const selectedVendor = document.querySelector(`.vendor-logo-container[data-vendor="${vendorKey}"]`);
  if (selectedVendor) {
    selectedVendor.classList.add('selected');
  }
  
  // Populate platform dropdown
  const platformSelect = document.getElementById('platform-select');
  if (platformSelect) {
    // Clear existing options
    platformSelect.innerHTML = '<option value="">Select a platform</option>';
    
    // Add platform options
    const vendor = vendors[vendorKey];
    if (vendor && vendor.platforms) {
      vendor.platforms.forEach(platform => {
        const option = document.createElement('option');
        option.value = platform.id;
        option.textContent = platform.name;
        platformSelect.appendChild(option);
      });
    }
    
    // Enable the dropdown
    platformSelect.disabled = false;
  }
  
  // Update platform details
  updatePlatformDetails(vendorKey);
  
  // Enable next button
  const nextButton = document.getElementById('platform-next');
  if (nextButton) {
    nextButton.disabled = false;
  }
  
  // Store selected vendor
  localStorage.setItem('selectedVendor', vendorKey);
}

// Function to update platform details section
function updatePlatformDetails(vendorKey) {
  const platformDetails = document.getElementById('platform-details');
  if (!platformDetails) return;
  
  const vendor = vendors[vendorKey];
  if (!vendor) {
    platformDetails.innerHTML = '<p>Please select a vendor to view details.</p>';
    return;
  }
  
  // Create capabilities list
  const capabilitiesList = [];
  if (vendor.capabilities.wired) capabilitiesList.push('802.1X Wired');
  if (vendor.capabilities.wireless) capabilitiesList.push('Wireless Auth');
  if (vendor.capabilities.vpn) capabilitiesList.push('VPN Auth');
  if (vendor.capabilities.tacacs) capabilitiesList.push('TACACS+');
  if (vendor.capabilities.radsec) capabilitiesList.push('RADSEC');
  if (vendor.capabilities.coa) capabilitiesList.push('CoA');
  if (vendor.capabilities.mab) capabilitiesList.push('MAB');
  if (vendor.capabilities.guestAccess) capabilitiesList.push('Guest Access');
  if (vendor.capabilities.dVlan) capabilitiesList.push('Dynamic VLAN');
  if (vendor.capabilities.dACL) capabilitiesList.push('Dynamic ACLs');
  if (vendor.capabilities.macsec) capabilitiesList.push('MACsec');
  
  // Build HTML
  let html = `
    <h3>${vendor.name} Authentication Capabilities</h3>
    <div class="capability-badges">
      ${capabilitiesList.map(cap => `<span class="badge">${cap}</span>`).join('')}
    </div>
    <p>Select a platform from the dropdown above to continue.</p>
    <h4>Supported Platforms:</h4>
    <ul>
  `;
  
  // Add platforms
  vendor.platforms.forEach(platform => {
    html += `<li><strong>${platform.name}</strong>: ${platform.desc}</li>`;
  });
  
  html += '</ul>';
  
  platformDetails.innerHTML = html;
}

// Setup vendor selection events
function setupVendorSelection() {
  // Platform dropdown change event
  const platformSelect = document.getElementById('platform-select');
  if (platformSelect) {
    platformSelect.addEventListener('change', function() {
      const vendorKey = localStorage.getItem('selectedVendor');
      if (vendorKey && this.value) {
        updatePlatformDetails(vendorKey, this.value);
      }
    });
  }
}
EOL

  progress "UI components updated successfully"
}

# Create JavaScript file for configuration generation
create_js_generator() {
  progress "Creating configuration generator JavaScript..."
  
  cat > "${JS_DIR}/config-generator.js" << 'EOL'
// Configuration Generator for Dot1Xer
class ConfigGenerator {
  constructor() {
    this.templates = {};
    this.loadedTemplates = 0;
    this.totalTemplates = 0;
    this.vendor = null;
    this.platform = null;
    this.formData = {};
  }

  // Initialize the generator
  init() {
    console.log("Initializing Configuration Generator...");
    this.setupEventListeners();
  }

  // Set up event listeners
  setupEventListeners() {
    const generateBtn = document.getElementById('generate-config');
    if (generateBtn) {
      generateBtn.addEventListener('click', () => this.generateConfiguration());
    }

    const copyBtn = document.getElementById('copy-config');
    if (copyBtn) {
      copyBtn.addEventListener('click', () => this.copyToClipboard());
    }

    const downloadBtn = document.getElementById('download-config');
    if (downloadBtn) {
      downloadBtn.addEventListener('click', () => this.downloadConfiguration());
    }
  }

  // Load template for vendor/platform
  loadTemplate(vendor, platform) {
    return new Promise((resolve, reject) => {
      const templateUrl = `templates/vendors/${vendor}/${platform}.txt`;
      
      fetch(templateUrl)
        .then(response => {
          if (!response.ok) {
            // Try fallback to basic template
            return fetch(`templates/vendors/${vendor}/basic.txt`);
          }
          return response;
        })
        .then(response => {
          if (!response.ok) {
            throw new Error(`Could not load template for ${vendor}/${platform}`);
          }
          return response.text();
        })
        .then(template => {
          this.templates[`${vendor}/${platform}`] = template;
          resolve(template);
        })
        .catch(error => {
          console.error("Error loading template:", error);
          reject(error);
        });
    });
  }

  // Gather form data
  gatherFormData() {
    this.formData = {
      // Authentication Settings
      authMethod: document.getElementById('auth-method')?.value,
      authMode: document.querySelector('input[name="auth-mode"]:checked')?.value,
      hostMode: document.getElementById('host-mode')?.value,
      
      // RADIUS Server Settings
      radiusServer1: document.getElementById('radius-server-1')?.value,
      radiusKey1: document.getElementById('radius-key-1')?.value,
      radiusAuthPort1: document.getElementById('radius-auth-port-1')?.value || "1812",
      radiusAcctPort1: document.getElementById('radius-acct-port-1')?.value || "1813",
      radiusServer2: document.getElementById('radius-server-2')?.value,
      radiusKey2: document.getElementById('radius-key-2')?.value,
      radiusTimeout: document.getElementById('radius-timeout')?.value || "5",
      radiusRetransmit: document.getElementById('radius-retransmit')?.value || "3",
      radiusDeadtime: document.getElementById('radius-deadtime')?.value || "15",
      enableAccounting: document.getElementById('enable-accounting')?.checked,
      accountingInterval: document.getElementById('accounting-interval')?.value || "1440",
      
      // Security Settings
      reauthPeriod: document.getElementById('reauth-period')?.value || "3600",
      txPeriod: document.getElementById('tx-period')?.value || "30",
      quietPeriod: document.getElementById('quiet-period')?.value || "60",
      maxReauth: document.getElementById('max-reauth')?.value || "2",
      useCoa: document.getElementById('use-coa')?.checked,
      coaPort: document.getElementById('coa-port')?.value || "3799",
      useRadsec: document.getElementById('use-radsec')?.checked,
      radsecPort: document.getElementById('radsec-port')?.value || "2083",
      useMacsec: document.getElementById('use-macsec')?.checked,
      
      // Network Settings
      enableDynamicVlan: document.getElementById('enable-dynamic-vlan')?.checked,
      vlanAuth: document.getElementById('vlan-auth')?.value,
      vlanUnauth: document.getElementById('vlan-unauth')?.value,
      vlanGuest: document.getElementById('vlan-guest')?.value,
      vlanVoice: document.getElementById('vlan-voice')?.value,
      vlanCritical: document.getElementById('vlan-critical')?.value,
      interface: document.getElementById('interface')?.value,
      interfaceRange: document.getElementById('interface-range')?.value,
      
      // DHCP and ARP Settings
      enableDhcpSnooping: document.getElementById('enable-dhcp-snooping')?.checked,
      dhcpSnoopingVlans: document.getElementById('dhcp-snooping-vlans')?.value || "1-4094",
      dhcpSnoopingOption82: document.getElementById('dhcp-snooping-option82')?.checked,
      enableDai: document.getElementById('enable-dai')?.checked,
      daiVlans: document.getElementById('dai-vlans')?.value || "1-4094",
      daiValidateSrc: document.getElementById('dai-validate-src')?.checked,
      daiValidateDst: document.getElementById('dai-validate-dst')?.checked,
      daiValidateIp: document.getElementById('dai-validate-ip')?.checked,
      enableIpsg: document.getElementById('enable-ipsg')?.checked,
      
      // Storm Control
      enableStormControl: document.getElementById('enable-storm-control')?.checked,
      stormControlAction: document.getElementById('storm-control-action')?.value || "trap",
      stormControlBroadcast: document.getElementById('storm-control-broadcast')?.value || "80.00",
      stormControlMulticast: document.getElementById('storm-control-multicast')?.value || "80.00",
      stormControlUnicast: document.getElementById('storm-control-unicast')?.value || "80.00",
      
      // Port Security
      enablePortSecurity: document.getElementById('enable-port-security')?.checked,
      portSecurityMaxMac: document.getElementById('port-security-max-mac')?.value || "5",
      portSecurityViolation: document.getElementById('port-security-violation')?.value || "protect",
      
      // TACACS Settings
      useTacacs: document.getElementById('use-tacacs')?.checked,
      tacacsServer1: document.getElementById('tacacs-server-1')?.value,
      tacacsKey1: document.getElementById('tacacs-key-1')?.value,
      tacacsServer2: document.getElementById('tacacs-server-2')?.value,
      tacacsKey2: document.getElementById('tacacs-key-2')?.value,
      tacacsTimeout: document.getElementById('tacacs-timeout')?.value || "5",
      tacacsSourceInterface: document.getElementById('tacacs-source-interface')?.value,
      
      // Additional Commands
      additionalCommands: document.getElementById('additional-commands')?.value
    };
    
    return this.formData;
  }

  // Generate configuration
  async generateConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput) return;
    
    // Show loading message
    configOutput.textContent = "Generating configuration...";
    
    try {
      // Get vendor and platform
      this.vendor = localStorage.getItem('selectedVendor');
      this.platform = document.getElementById('platform-select')?.value;
      
      if (!this.vendor || !this.platform) {
        configOutput.textContent = "Error: Please select a vendor and platform.";
        return;
      }
      
      // Gather form data
      this.gatherFormData();
      
      // Load template if not already loaded
      if (!this.templates[`${this.vendor}/${this.platform}`]) {
        await this.loadTemplate(this.vendor, this.platform);
      }
      
      // Get template
      let template = this.templates[`${this.vendor}/${this.platform}`];
      
      // Process template with form data
      const config = this.processTemplate(template);
      
      // Display configuration
      configOutput.textContent = config;
      
    } catch (error) {
      console.error("Error generating configuration:", error);
      configOutput.textContent = `Error generating configuration: ${error.message}`;
    }
  }

  // Process template with form data
  processTemplate(template) {
    // Replace variables in template with form data
    let config = template;
    
    // Replace basic field variables
    Object.keys(this.formData).forEach(key => {
      const value = this.formData[key];
      if (value !== undefined && value !== null) {
        // Handle boolean values
        if (typeof value === 'boolean') {
          // Skip section if boolean is false
          const regex = new RegExp(`{{#${key}}}([\\s\\S]*?){{/${key}}}`, 'g');
          if (value) {
            // Keep content but remove the conditional tags
            config = config.replace(regex, '$1');
          } else {
            // Remove content and tags
            config = config.replace(regex, '');
          }
        } else {
          // Replace variable with value
          const regex = new RegExp(`{{${key}}}`, 'g');
          config = config.replace(regex, value);
        }
      }
    });
    
    // Handle conditional blocks that haven't been processed
    config = this.processConditionalBlocks(config);
    
    // Clean up any remaining template variables
    config = this.cleanupTemplate(config);
    
    return config;
  }

  // Process conditional blocks in template
  processConditionalBlocks(template) {
    let config = template;
    
    // Handle equality conditional blocks {{#key eq "value"}}...{{/key}}
    const eqRegex = /{{#(\w+) eq "([^"]+)"}}/g;
    let match;
    
    while ((match = eqRegex.exec(template)) !== null) {
      const [fullMatch, key, value] = match;
      const endTag = `{{/${key}}}`;
      
      // Find the end of this conditional block
      const startIndex = match.index;
      const endIndex = template.indexOf(endTag, startIndex) + endTag.length;
      
      if (endIndex > startIndex) {
        const blockContent = template.substring(startIndex + fullMatch.length, endIndex - endTag.length);
        
        // Check if condition is met
        if (this.formData[key] === value) {
          // Replace the entire block with just the content
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, blockContent);
        } else {
          // Remove the entire block
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, '');
        }
      }
    }
    
    // Handle negation conditional blocks {{^key}}...{{/key}}
    const negRegex = /{{^(\w+)}}/g;
    
    while ((match = negRegex.exec(template)) !== null) {
      const [fullMatch, key] = match;
      const endTag = `{{/${key}}}`;
      
      // Find the end of this conditional block
      const startIndex = match.index;
      const endIndex = template.indexOf(endTag, startIndex) + endTag.length;
      
      if (endIndex > startIndex) {
        const blockContent = template.substring(startIndex + fullMatch.length, endIndex - endTag.length);
        
        // Check if condition is met (value is falsy)
        if (!this.formData[key]) {
          // Replace the entire block with just the content
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, blockContent);
        } else {
          // Remove the entire block
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, '');
        }
      }
    }
    
    return config;
  }

  // Clean up any remaining template variables and conditionals
  cleanupTemplate(template) {
    let config = template;
    
    // Remove any remaining simple variables
    config = config.replace(/{{[^{}]+}}/g, '');
    
    // Remove any remaining conditional blocks
    config = config.replace(/{{#[^{}]+}}[\s\S]*?{{\/[^{}]+}}/g, '');
    config = config.replace(/{{^[^{}]+}}[\s\S]*?{{\/[^{}]+}}/g, '');
    
    // Clean up empty lines (more than 2 consecutive)
    config = config.replace(/\n{3,}/g, '\n\n');
    
    return config;
  }

  // Copy configuration to clipboard
  copyToClipboard() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput || !configOutput.textContent) {
      alert('No configuration to copy. Please generate a configuration first.');
      return;
    }
    
    // Create a temporary textarea element
    const textarea = document.createElement('textarea');
    textarea.value = configOutput.textContent;
    textarea.style.position = 'fixed';
    textarea.style.opacity = 0;
    document.body.appendChild(textarea);
    
    // Select and copy text
    textarea.select();
    document.execCommand('copy');
    
    // Clean up
    document.body.removeChild(textarea);
    
    // Show success message
    alert('Configuration copied to clipboard!');
  }

  // Download configuration as a file
  downloadConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (!configOutput || !configOutput.textContent) {
      alert('No configuration to download. Please generate a configuration first.');
      return;
    }
    
    // Create filename based on vendor and platform
    let filename = 'config.txt';
    if (this.vendor && this.platform) {
      filename = `${this.vendor}-${this.platform}-config.txt`;
    }
    
    // Create a blob and download link
    const blob = new Blob([configOutput.textContent], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.style.display = 'none';
    
    // Trigger download
    document.body.appendChild(a);
    a.click();
    
    // Clean up
    setTimeout(() => {
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }, 100);
  }
}

// Initialize the generator when the document is ready
document.addEventListener('DOMContentLoaded', () => {
  const generator = new ConfigGenerator();
  generator.init();
});
EOL

  progress "Configuration generator JavaScript created successfully"
}

# Create wizard JavaScript for enhanced user experience
create_wizard_js() {
  progress "Creating wizard JavaScript..."
  
  cat > "${JS_DIR}/wizard-init.js" << 'EOL'
// Dot1Xer Wizard Initialization

document.addEventListener('DOMContentLoaded', function() {
  // Initialize Advanced Authentication Wizard
  initWizard();
  
  // Setup form toggling behavior
  setupFormToggles();
  
  // Initialize tooltips
  initTooltips();
});

// Initialize the authentication wizard
function initWizard() {
  // Track current step
  let currentStep = 0;
  const totalSteps = 6;
  
  // Update progress bar function
  function updateProgress(step) {
    const progressFill = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    if (progressFill && progressText) {
      const percent = Math.round((step / (totalSteps - 1)) * 100);
      progressFill.style.width = `${percent}%`;
      progressText.textContent = `${percent}% complete`;
    }
  }
  
  // Step navigation functions
  window.nextStep = function() {
    if (currentStep < totalSteps - 1) {
      // Hide current step
      document.querySelectorAll('.wizard-step').forEach(step => {
        step.classList.remove('active');
      });
      
      // Show next step
      currentStep++;
      document.querySelector(`.wizard-step[data-step="${currentStep}"]`).classList.add('active');
      
      // Update progress
      updateProgress(currentStep);
      
      // Scroll to top
      window.scrollTo(0, 0);
    }
  };
  
  window.prevStep = function() {
    if (currentStep > 0) {
      // Hide current step
      document.querySelectorAll('.wizard-step').forEach(step => {
        step.classList.remove('active');
      });
      
      // Show previous step
      currentStep--;
      document.querySelector(`.wizard-step[data-step="${currentStep}"]`).classList.add('active');
      
      // Update progress
      updateProgress(currentStep);
      
      // Scroll to top
      window.scrollTo(0, 0);
    }
  };
  
  // Set up step navigation buttons
  document.querySelectorAll('.btn-next').forEach(btn => {
    btn.addEventListener('click', window.nextStep);
  });
  
  document.querySelectorAll('.btn-prev').forEach(btn => {
    btn.addEventListener('click', window.prevStep);
  });
  
  // Initialize first step
  document.querySelector('.wizard-step[data-step="0"]').classList.add('active');
  updateProgress(0);
  
  // Toggle wizard visibility
  const wizardToggle = document.querySelector('.wizard-toggle');
  const wizardContainer = document.querySelector('.wizard-container');
  
  if (wizardToggle && wizardContainer) {
    wizardToggle.addEventListener('click', function() {
      if (wizardContainer.style.display === 'none') {
        wizardContainer.style.display = 'block';
        wizardToggle.textContent = 'Hide Advanced Wizard';
      } else {
        wizardContainer.style.display = 'none';
        wizardToggle.textContent = 'Show Advanced Wizard';
      }
    });
  }
}

// Setup form toggle behavior
function setupFormToggles() {
  // RADIUS CoA settings toggle
  const useCoaCheckbox = document.getElementById('use-coa');
  const coaSettings = document.getElementById('coa-settings');
  
  if (useCoaCheckbox && coaSettings) {
    useCoaCheckbox.addEventListener('change', function() {
      coaSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    coaSettings.style.display = useCoaCheckbox.checked ? 'block' : 'none';
  }
  
  // RADSEC settings toggle
  const useRadsecCheckbox = document.getElementById('use-radsec');
  const radsecSettings = document.getElementById('radsec-settings');
  
  if (useRadsecCheckbox && radsecSettings) {
    useRadsecCheckbox.addEventListener('change', function() {
      radsecSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    radsecSettings.style.display = useRadsecCheckbox.checked ? 'block' : 'none';
  }
  
  // DHCP Snooping settings toggle
  const dhcpSnoopingCheckbox = document.getElementById('enable-dhcp-snooping');
  const dhcpSnoopingSettings = document.getElementById('dhcp-snooping-settings');
  
  if (dhcpSnoopingCheckbox && dhcpSnoopingSettings) {
    dhcpSnoopingCheckbox.addEventListener('change', function() {
      dhcpSnoopingSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    dhcpSnoopingSettings.style.display = dhcpSnoopingCheckbox.checked ? 'block' : 'none';
  }
  
  // Dynamic ARP Inspection settings toggle
  const daiCheckbox = document.getElementById('enable-dai');
  const daiSettings = document.getElementById('dai-settings');
  
  if (daiCheckbox && daiSettings) {
    daiCheckbox.addEventListener('change', function() {
      daiSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    daiSettings.style.display = daiCheckbox.checked ? 'block' : 'none';
  }
  
  // Storm Control settings toggle
  const stormControlCheckbox = document.getElementById('enable-storm-control');
  const stormControlSettings = document.getElementById('storm-control-settings');
  
  if (stormControlCheckbox && stormControlSettings) {
    stormControlCheckbox.addEventListener('change', function() {
      stormControlSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    stormControlSettings.style.display = stormControlCheckbox.checked ? 'block' : 'none';
  }
  
  // Port Security settings toggle
  const portSecurityCheckbox = document.getElementById('enable-port-security');
  const portSecuritySettings = document.getElementById('port-security-settings');
  
  if (portSecurityCheckbox && portSecuritySettings) {
    portSecurityCheckbox.addEventListener('change', function() {
      portSecuritySettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    portSecuritySettings.style.display = portSecurityCheckbox.checked ? 'block' : 'none';
  }
  
  // TACACS settings toggle
  const useTacacsCheckbox = document.getElementById('use-tacacs');
  const tacacsSettings = document.getElementById('tacacs-settings');
  
  if (useTacacsCheckbox && tacacsSettings) {
    useTacacsCheckbox.addEventListener('change', function() {
      tacacsSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    tacacsSettings.style.display = useTacacsCheckbox.checked ? 'block' : 'none';
  }
  
  // Authentication method toggle
  const authMethodSelect = document.getElementById('auth-method');
  
  if (authMethodSelect) {
    authMethodSelect.addEventListener('change', function() {
      updateAuthMethodInfo(this.value);
    });
    // Initialize
    if (authMethodSelect.value) {
      updateAuthMethodInfo(authMethodSelect.value);
    }
  }
}

// Update authentication method description
function updateAuthMethodInfo(method) {
  const methodInfo = document.querySelectorAll('.method-info-panel');
  
  // Hide all panels
  methodInfo.forEach(panel => {
    panel.classList.remove('active');
  });
  
  // Show selected panel
  const selectedPanel = document.getElementById(`${method}-info`);
  if (selectedPanel) {
    selectedPanel.classList.add('active');
  }
}

// Initialize tooltips
function initTooltips() {
  const tooltips = document.querySelectorAll('.tooltip');
  
  tooltips.forEach(tooltip => {
    const helpIcon = document.createElement('i');
    helpIcon.className = 'fa fa-question-circle help-icon';
    
    const tooltipText = document.createElement('span');
    tooltipText.className = 'tooltip-text';
    tooltipText.innerHTML = tooltip.getAttribute('data-tooltip');
    
    tooltip.appendChild(helpIcon);
    tooltip.appendChild(tooltipText);
  });
}
EOL

  cat > "${JS_DIR}/vendor-wizard.js" << 'EOL'
// Comprehensive Vendor Configuration Wizard

class VendorWizard {
  constructor() {
    this.currentStep = 0;
    this.formData = {};
    this.vendorData = {};
    this.platformData = {};
    this.templates = {};
  }

  // Initialize the wizard
  async init() {
    // Load vendor data
    await this.loadVendorData();
    
    // Set up event listeners
    this.setupEventListeners();
    
    // Initialize vendor selection grid
    this.initVendorGrid();
    
    // Setup form toggles and validations
    this.setupFormControls();
    
    // Initialize configuration preview
    this.initConfigPreview();
    
    console.log('Vendor Wizard initialized successfully');
  }

  // Load vendor data from server
  async loadVendorData() {
    try {
      const response = await fetch('data/vendors.json');
      if (!response.ok) {
        throw new Error('Failed to load vendor data');
      }
      this.vendorData = await response.json();
      console.log('Vendor data loaded:', Object.keys(this.vendorData).length, 'vendors');
    } catch (error) {
      console.error('Error loading vendor data:', error);
      // Fallback to hardcoded data
      this.vendorData = {
        cisco: {
          name: "Cisco",
          platforms: ["ios", "ios-xe", "nx-os", "wlc-9800"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: true,
            coa: true,
            wireless: true
          }
        },
        juniper: {
          name: "Juniper",
          platforms: ["junos", "mist"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: true,
            coa: true,
            wireless: true
          }
        },
        aruba: {
          name: "Aruba",
          platforms: ["aos-cx", "aos-switch"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: false,
            coa: true,
            wireless: true
          }
        },
        fortinet: {
          name: "Fortinet",
          platforms: ["fortiswitch", "fortigate"],
          types: ["wired", "wireless"],
          capabilities: {
            dot1x: true,
            mab: true,
            tacacs: true,
            radsec: false,
            coa: false,
            wireless: true
          }
        }
      };
    }
  }

  // Set up event listeners
  setupEventListeners() {
    // Next/Previous step buttons
    document.querySelectorAll('.wizard-navigation .btn-next').forEach(btn => {
      btn.addEventListener('click', () => this.nextStep());
    });
    
    document.querySelectorAll('.wizard-navigation .btn-prev').forEach(btn => {
      btn.addEventListener('click', () => this.prevStep());
    });
    
    // Generate config button
    const generateBtn = document.getElementById('generate-config-btn');
    if (generateBtn) {
      generateBtn.addEventListener('click', () => this.generateConfiguration());
    }
    
    // Copy to clipboard button
    const copyBtn = document.getElementById('copy-config-btn');
    if (copyBtn) {
      copyBtn.addEventListener('click', () => this.copyToClipboard());
    }
    
    // Download button
    const downloadBtn = document.getElementById('download-config-btn');
    if (downloadBtn) {
      downloadBtn.addEventListener('click', () => this.downloadConfiguration());
    }
  }

  // Initialize vendor selection grid
  initVendorGrid() {
    const vendorGrid = document.getElementById('vendor-grid');
    if (!vendorGrid) return;
    
    // Clear existing content
    vendorGrid.innerHTML = '';
    
    // Create vendor cards
    Object.keys(this.vendorData).forEach(vendorKey => {
      const vendor = this.vendorData[vendorKey];
      
      const card = document.createElement('div');
      card.className = 'vendor-card';
      card.dataset.vendor = vendorKey;
      
      // Add types badge
      const typeText = vendor.types.includes('wired') && vendor.types.includes('wireless') 
        ? 'Wired & Wireless' 
        : vendor.types.includes('wired') 
          ? 'Wired' 
          : 'Wireless';
          
      const typeBadge = document.createElement('span');
      typeBadge.className = `vendor-type ${vendor.types.join('-')}`;
      typeBadge.textContent = typeText;
      
      // Add vendor logo and name
      const logo = document.createElement('img');
      logo.src = `assets/images/vendors/${vendorKey}.png`;
      logo.alt = vendor.name;
      logo.className = 'vendor-logo';
      
      const name = document.createElement('div');
      name.className = 'vendor-name';
      name.textContent = vendor.name;
      
      // Add elements to card
      card.appendChild(typeBadge);
      card.appendChild(logo);
      card.appendChild(name);
      
      // Add click handler
      card.addEventListener('click', () => this.selectVendor(vendorKey));
      
      // Add card to grid
      vendorGrid.appendChild(card);
    });
  }

  // Handle vendor selection
  selectVendor(vendorKey) {
    // Update UI
    document.querySelectorAll('.vendor-card').forEach(card => {
      card.classList.remove('selected');
    });
    
    const selectedCard = document.querySelector(`.vendor-card[data-vendor="${vendorKey}"]`);
    if (selectedCard) {
      selectedCard.classList.add('selected');
    }
    
    // Store selected vendor
    this.formData.vendor = vendorKey;
    
    // Update platform dropdown
    this.updatePlatformDropdown(vendorKey);
    
    // Update vendor information
    this.updateVendorInfo(vendorKey);
    
    // Enable next button
    const nextBtn = document.querySelector('#vendor-step .btn-next');
    if (nextBtn) {
      nextBtn.disabled = false;
    }
  }

  // Update platform dropdown based on selected vendor
  updatePlatformDropdown(vendorKey) {
    const platformSelect = document.getElementById('platform-select');
    if (!platformSelect) return;
    
    // Clear existing options
    platformSelect.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = 'Select a platform';
    platformSelect.appendChild(defaultOption);
    
    // Add platform options
    const vendor = this.vendorData[vendorKey];
    if (vendor && vendor.platforms) {
      vendor.platforms.forEach(platform => {
        const option = document.createElement('option');
        option.value = platform;
        option.textContent = this.formatPlatformName(platform);
        platformSelect.appendChild(option);
      });
    }
    
    // Enable the dropdown
    platformSelect.disabled = false;
    
    // Add change handler
    platformSelect.addEventListener('change', () => {
      this.formData.platform = platformSelect.value;
      this.updatePlatformInfo(platformSelect.value);
    });
  }

  // Format platform name for display
  formatPlatformName(platform) {
    return platform
      .split('-')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ');
  }

  // Update vendor information display
  updateVendorInfo(vendorKey) {
    const vendorInfoSection = document.getElementById('vendor-info');
    if (!vendorInfoSection) return;
    
    const vendor = this.vendorData[vendorKey];
    if (!vendor) return;
    
    // Create capabilities list
    const capabilities = [];
    if (vendor.capabilities.dot1x) capabilities.push('802.1X');
    if (vendor.capabilities.mab) capabilities.push('MAC Authentication Bypass');
    if (vendor.capabilities.tacacs) capabilities.push('TACACS+');
    if (vendor.capabilities.radsec) capabilities.push('RADIUS over TLS (RadSec)');
    if (vendor.capabilities.coa) capabilities.push('Change of Authorization (CoA)');
    if (vendor.capabilities.wireless) capabilities.push('Wireless Authentication');
    
    // Update info display
    vendorInfoSection.innerHTML = `
      <h4>${vendor.name} Authentication Capabilities</h4>
      <div class="capability-badges">
        ${capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
      </div>
    `;
  }

  // Update platform information display
  updatePlatformInfo(platform) {
    // This would show platform-specific capabilities and information
    const platformInfoSection = document.getElementById('platform-info');
    if (!platformInfoSection) return;
    
    if (!platform) {
      platformInfoSection.innerHTML = '<p>Please select a platform to see details.</p>';
      return;
    }
    
    // Here you would typically load platform-specific details
    platformInfoSection.innerHTML = `
      <h4>${this.formatPlatformName(platform)} Configuration</h4>
      <p>This template provides comprehensive authentication configuration for ${this.formatPlatformName(platform)} including 802.1X, MAB, RADIUS, and more.</p>
    `;
    
    // Enable next button
    const nextBtn = document.querySelector('#vendor-step .btn-next');
    if (nextBtn) {
      nextBtn.disabled = false;
    }
  }

  // Setup form controls
  setupFormControls() {
    // Toggle RADIUS server 2 fields
    const radiusServer2Container = document.getElementById('radius-server-2-container');
    const addRadiusServerBtn = document.getElementById('add-radius-server');
    
    if (radiusServer2Container && addRadiusServerBtn) {
      addRadiusServerBtn.addEventListener('click', () => {
        radiusServer2Container.style.display = 'block';
        addRadiusServerBtn.style.display = 'none';
      });
    }
    
    // Toggle TACACS+ fields
    const useTacacsCheckbox = document.getElementById('use-tacacs');
    const tacacsSettings = document.getElementById('tacacs-settings');
    
    if (useTacacsCheckbox && tacacsSettings) {
      useTacacsCheckbox.addEventListener('change', () => {
        tacacsSettings.style.display = useTacacsCheckbox.checked ? 'block' : 'none';
      });
    }
    
    // Toggle CoA fields
    const useCoaCheckbox = document.getElementById('use-coa');
    const coaSettings = document.getElementById('coa-settings');
    
    if (useCoaCheckbox && coaSettings) {
      useCoaCheckbox.addEventListener('change', () => {
        coaSettings.style.display = useCoaCheckbox.checked ? 'block' : 'none';
      });
    }
    
    // Toggle RadSec fields
    const useRadsecCheckbox = document.getElementById('use-radsec');
    const radsecSettings = document.getElementById('radsec-settings');
    
    if (useRadsecCheckbox && radsecSettings) {
      useRadsecCheckbox.addEventListener('change', () => {
        radsecSettings.style.display = useRadsecCheckbox.checked ? 'block' : 'none';
      });
    }
    
    // Toggle security feature sections
    const securityFeatures = [
      { checkbox: 'enable-dhcp-snooping', settings: 'dhcp-snooping-settings' },
      { checkbox: 'enable-dai', settings: 'dai-settings' },
      { checkbox: 'enable-ipsg', settings: 'ipsg-settings' },
      { checkbox: 'enable-storm-control', settings: 'storm-control-settings' },
      { checkbox: 'enable-port-security', settings: 'port-security-settings' }
    ];
    
    securityFeatures.forEach(feature => {
      const checkbox = document.getElementById(feature.checkbox);
      const settings = document.getElementById(feature.settings);
      
      if (checkbox && settings) {
        checkbox.addEventListener('change', () => {
          settings.style.display = checkbox.checked ? 'block' : 'none';
        });
      }
    });
  }

  // Initialize configuration preview
  initConfigPreview() {
    // This will be populated when generating the configuration
    const configPreview = document.getElementById('config-preview');
    if (configPreview) {
      configPreview.textContent = 'Configuration will be generated when you complete the wizard.';
    }
  }

  // Navigate to next step
  nextStep() {
    // Validate current step
    if (!this.validateStep(this.currentStep)) {
      return;
    }
    
    // Hide current step
    document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.remove('active');
    
    // Increment step counter
    this.currentStep++;
    
    // Show next step
    document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.add('active');
    
    // Update progress bar
    this.updateProgress();
    
    // If final step, generate preview
    if (this.currentStep === 3) {
      this.updateConfigSummary();
    }
  }

  // Navigate to previous step
  prevStep() {
    if (this.currentStep > 0) {
      // Hide current step
      document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.remove('active');
      
      // Decrement step counter
      this.currentStep--;
      
      // Show previous step
      document.querySelector(`.wizard-step[data-step="${this.currentStep}"]`).classList.add('active');
      
      // Update progress bar
      this.updateProgress();
    }
  }

  // Update progress bar
  updateProgress() {
    const progressFill = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    if (progressFill && progressText) {
      const totalSteps = document.querySelectorAll('.wizard-step').length;
      const percentage = Math.round(((this.currentStep + 1) / totalSteps) * 100);
      
      progressFill.style.width = `${percentage}%`;
      progressText.textContent = `${percentage}% complete`;
    }
  }

  // Validate current step
  validateStep(step) {
    // Collect form data from current step
    this.collectFormData(step);
    
    // Validation logic for each step
    switch (step) {
      case 0: // Vendor selection
        if (!this.formData.vendor || !this.formData.platform) {
          alert('Please select a vendor and platform to continue.');
          return false;
        }
        break;
        
      case 1: // Authentication settings
        if (!this.formData.authMethod) {
          alert('Please select an authentication method.');
          return false;
        }
        
        if (!this.formData.radiusServer1 || !this.formData.radiusKey1) {
          alert('Please enter RADIUS server information.');
          return false;
        }
        break;
        
      case 2: // Security features
        // No required fields
        break;
    }
    
    return true;
  }

  // Collect form data from step
  collectFormData(step) {
    switch (step) {
      case 0: // Vendor selection
        // Already collected in selectVendor()
        break;
        
      case 1: // Authentication settings
        this.formData.authMethod = document.getElementById('auth-method')?.value;
        this.formData.authMode = document.querySelector('input[name="auth-mode"]:checked')?.value;
        this.formData.hostMode = document.getElementById('host-mode')?.value;
        
        this.formData.radiusServer1 = document.getElementById('radius-server-1')?.value;
        this.formData.radiusKey1 = document.getElementById('radius-key-1')?.value;
        this.formData.radiusAuthPort1 = document.getElementById('radius-auth-port-1')?.value || '1812';
        this.formData.radiusAcctPort1 = document.getElementById('radius-acct-port-1')?.value || '1813';
        
        this.formData.radiusServer2 = document.getElementById('radius-server-2')?.value;
        this.formData.radiusKey2 = document.getElementById('radius-key-2')?.value;
        
        this.formData.enableAccounting = document.getElementById('enable-accounting')?.checked;
        
        this.formData.useTacacs = document.getElementById('use-tacacs')?.checked;
        if (this.formData.useTacacs) {
          this.formData.tacacsServer1 = document.getElementById('tacacs-server-1')?.value;
          this.formData.tacacsKey1 = document.getElementById('tacacs-key-1')?.value;
          this.formData.tacacsServer2 = document.getElementById('tacacs-server-2')?.value;
          this.formData.tacacsKey2 = document.getElementById('tacacs-key-2')?.value;
        }
        break;
        
      case 2: // Security features
        this.formData.reauthPeriod = document.getElementById('reauth-period')?.value || '3600';
        this.formData.txPeriod = document.getElementById('tx-period')?.value || '30';
        this.formData.quietPeriod = document.getElementById('quiet-period')?.value || '60';
        this.formData.maxReauth = document.getElementById('max-reauth')?.value || '2';
        
        this.formData.useCoa = document.getElementById('use-coa')?.checked;
        if (this.formData.useCoa) {
          this.formData.coaPort = document.getElementById('coa-port')?.value || '3799';
        }
        
        this.formData.useRadsec = document.getElementById('use-radsec')?.checked;
        if (this.formData.useRadsec) {
          this.formData.radsecPort = document.getElementById('radsec-port')?.value || '2083';
        }
        
        this.formData.enableDhcpSnooping = document.getElementById('enable-dhcp-snooping')?.checked;
        if (this.formData.enableDhcpSnooping) {
          this.formData.dhcpSnoopingVlans = document.getElementById('dhcp-snooping-vlans')?.value || '1-4094';
          this.formData.dhcpSnoopingOption82 = document.getElementById('dhcp-snooping-option82')?.checked;
        }
        
        this.formData.enableDai = document.getElementById('enable-dai')?.checked;
        if (this.formData.enableDai) {
          this.formData.daiVlans = document.getElementById('dai-vlans')?.value || '1-4094';
        }
        
        this.formData.enableIpsg = document.getElementById('enable-ipsg')?.checked;
        
        this.formData.enableStormControl = document.getElementById('enable-storm-control')?.checked;
        if (this.formData.enableStormControl) {
          this.formData.stormControlBroadcast = document.getElementById('storm-control-broadcast')?.value || '80.00';
          this.formData.stormControlMulticast = document.getElementById('storm-control-multicast')?.value || '80.00';
          this.formData.stormControlUnicast = document.getElementById('storm-control-unicast')?.value || '80.00';
          this.formData.stormControlAction = document.getElementById('storm-control-action')?.value || 'trap';
        }
        
        this.formData.enablePortSecurity = document.getElementById('enable-port-security')?.checked;
        if (this.formData.enablePortSecurity) {
          this.formData.portSecurityMaxMac = document.getElementById('port-security-max-mac')?.value || '5';
          this.formData.portSecurityViolation = document.getElementById('port-security-violation')?.value || 'protect';
        }
        break;
        
      case 3: // Network settings
        this.formData.vlanAuth = document.getElementById('vlan-auth')?.value || '10';
        this.formData.vlanUnauth = document.getElementById('vlan-unauth')?.value || '999';
        this.formData.vlanGuest = document.getElementById('vlan-guest')?.value || '900';
        this.formData.vlanVoice = document.getElementById('vlan-voice')?.value || '100';
        
        this.formData.interface = document.getElementById('interface')?.value;
        this.formData.interfaceRange = document.getElementById('interface-range')?.value;
        
        this.formData.additionalCommands = document.getElementById('additional-commands')?.value;
        break;
    }
  }

  // Update configuration summary
  updateConfigSummary() {
    const summaryElement = document.getElementById('config-summary');
    if (!summaryElement) return;
    
    // Collect all form data
    for (let i = 0; i <= 3; i++) {
      this.collectFormData(i);
    }
    
    // Create summary HTML
    let summaryHtml = '<div class="config-summary-grid">';
    
    // Vendor & Platform
    summaryHtml += `
      <div class="summary-section">
        <h5>Vendor & Platform</h5>
        <ul>
          <li><strong>Vendor:</strong> ${this.vendorData[this.formData.vendor]?.name || this.formData.vendor}</li>
          <li><strong>Platform:</strong> ${this.formatPlatformName(this.formData.platform)}</li>
        </ul>
      </div>
    `;
    
    // Authentication Settings
    summaryHtml += `
      <div class="summary-section">
        <h5>Authentication</h5>
        <ul>
          <li><strong>Method:</strong> ${this.formatAuthMethod(this.formData.authMethod)}</li>
          <li><strong>Mode:</strong> ${this.formData.authMode === 'closed' ? 'Closed (Secure)' : 'Open (Monitor)'}</li>
          <li><strong>Host Mode:</strong> ${this.formatHostMode(this.formData.hostMode)}</li>
        </ul>
      </div>
    `;
    
    // RADIUS Server
    summaryHtml += `
      <div class="summary-section">
        <h5>RADIUS Server</h5>
        <ul>
          <li><strong>Primary:</strong> ${this.formData.radiusServer1}</li>
          ${this.formData.radiusServer2 ? `<li><strong>Secondary:</strong> ${this.formData.radiusServer2}</li>` : ''}
          <li><strong>Accounting:</strong> ${this.formData.enableAccounting ? 'Enabled' : 'Disabled'}</li>
        </ul>
      </div>
    `;
    
    // Security Features
    summaryHtml += `
      <div class="summary-section">
        <h5>Security Features</h5>
        <ul>
          <li><strong>CoA:</strong> ${this.formData.useCoa ? 'Enabled' : 'Disabled'}</li>
          <li><strong>RadSec:</strong> ${this.formData.useRadsec ? 'Enabled' : 'Disabled'}</li>
          <li><strong>DHCP Snooping:</strong> ${this.formData.enableDhcpSnooping ? 'Enabled' : 'Disabled'}</li>
          <li><strong>Dynamic ARP Inspection:</strong> ${this.formData.enableDai ? 'Enabled' : 'Disabled'}</li>
          <li><strong>IP Source Guard:</strong> ${this.formData.enableIpsg ? 'Enabled' : 'Disabled'}</li>
        </ul>
      </div>
    `;
    
    // Network Settings
    summaryHtml += `
      <div class="summary-section">
        <h5>Network Settings</h5>
        <ul>
          <li><strong>Auth VLAN:</strong> ${this.formData.vlanAuth}</li>
          <li><strong>Unauth VLAN:</strong> ${this.formData.vlanUnauth}</li>
          <li><strong>Guest VLAN:</strong> ${this.formData.vlanGuest}</li>
          ${this.formData.vlanVoice ? `<li><strong>Voice VLAN:</strong> ${this.formData.vlanVoice}</li>` : ''}
        </ul>
      </div>
    `;
    
    // TACACS+ Settings (if enabled)
    if (this.formData.useTacacs) {
      summaryHtml += `
        <div class="summary-section">
          <h5>TACACS+ Settings</h5>
          <ul>
            <li><strong>Primary:</strong> ${this.formData.tacacsServer1}</li>
            ${this.formData.tacacsServer2 ? `<li><strong>Secondary:</strong> ${this.formData.tacacsServer2}</li>` : ''}
          </ul>
        </div>
      `;
    }
    
    summaryHtml += '</div>';
    
    // Update summary element
    summaryElement.innerHTML = summaryHtml;
  }

  // Format authentication method for display
  formatAuthMethod(method) {
    switch (method) {
      case 'dot1x':
        return '802.1X Only';
      case 'mab':
        return 'MAC Authentication Bypass Only';
      case 'dot1x-mab':
        return '802.1X with MAB Fallback';
      case 'concurrent':
        return 'Concurrent 802.1X and MAB';
      default:
        return method;
    }
  }

  // Format host mode for display
  formatHostMode(mode) {
    switch (mode) {
      case 'single-host':
        return 'Single-Host (One device per port)';
      case 'multi-host':
        return 'Multi-Host (Multiple devices, single authentication)';
      case 'multi-auth':
        return 'Multi-Auth (Multiple devices, individual authentication)';
      case 'multi-domain':
        return 'Multi-Domain (Data + Voice)';
      default:
        return mode;
    }
  }

  // Generate configuration
  async generateConfiguration() {
    const configOutput = document.getElementById('config-preview');
    if (!configOutput) return;
    
    // Collect all form data
    for (let i = 0; i <= 3; i++) {
      this.collectFormData(i);
    }
    
    // Show loading message
    configOutput.textContent = 'Generating configuration...';
    
    try {
      // Load template if not already loaded
      if (!this.templates[`${this.formData.vendor}/${this.formData.platform}`]) {
        await this.loadTemplate(this.formData.vendor, this.formData.platform);
      }
      
      // Get template
      let template = this.templates[`${this.formData.vendor}/${this.formData.platform}`];
      
      // Process template with form data
      const config = this.processTemplate(template);
      
      // Display configuration
      configOutput.textContent = config;
      
    } catch (error) {
      console.error('Error generating configuration:', error);
      configOutput.textContent = `Error generating configuration: ${error.message}`;
    }
  }

  // Load template from server
  async loadTemplate(vendor, platform) {
    try {
      const templateUrl = `templates/vendors/${vendor}/${platform}.txt`;
      
      const response = await fetch(templateUrl);
      if (!response.ok) {
        // Try fallback to basic template
        const fallbackResponse = await fetch(`templates/vendors/${vendor}/basic.txt`);
        if (!fallbackResponse.ok) {
          throw new Error(`Could not load template for ${vendor}/${platform}`);
        }
        
        const template = await fallbackResponse.text();
        this.templates[`${vendor}/${platform}`] = template;
        return template;
      }
      
      const template = await response.text();
      this.templates[`${vendor}/${platform}`] = template;
      return template;
      
    } catch (error) {
      console.error('Error loading template:', error);
      throw error;
    }
  }

  // Process template with form data
  processTemplate(template) {
    // Replace variables in template with form data
    let config = template;
    
    // Replace basic field variables
    Object.keys(this.formData).forEach(key => {
      const value = this.formData[key];
      if (value !== undefined && value !== null) {
        // Handle boolean values
        if (typeof value === 'boolean') {
          // Skip section if boolean is false
          const regex = new RegExp(`{{#${key}}}([\\s\\S]*?){{/${key}}}`, 'g');
          if (value) {
            // Keep content but remove the conditional tags
            config = config.replace(regex, '$1');
          } else {
            // Remove content and tags
            config = config.replace(regex, '');
          }
        } else {
          // Replace variable with value
          const regex = new RegExp(`{{${key}}}`, 'g');
          config = config.replace(regex, value);
        }
      }
    });
    
    // Handle conditional blocks that haven't been processed
    config = this.processConditionalBlocks(config);
    
    // Clean up any remaining template variables
    config = this.cleanupTemplate(config);
    
    return config;
  }

  // Process conditional blocks in template
  processConditionalBlocks(template) {
    let config = template;
    
    // Handle equality conditional blocks {{#key eq "value"}}...{{/key}}
    const eqRegex = /{{#(\w+) eq "([^"]+)"}}/g;
    let match;
    
    while ((match = eqRegex.exec(template)) !== null) {
      const [fullMatch, key, value] = match;
      const endTag = `{{/${key}}}`;
      
      // Find the end of this conditional block
      const startIndex = match.index;
      const endIndex = template.indexOf(endTag, startIndex) + endTag.length;
      
      if (endIndex > startIndex) {
        const blockContent = template.substring(startIndex + fullMatch.length, endIndex - endTag.length);
        
        // Check if condition is met
        if (this.formData[key] === value) {
          // Replace the entire block with just the content
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, blockContent);
        } else {
          // Remove the entire block
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, '');
        }
      }
    }
    
    // Handle negation conditional blocks {{^key}}...{{/key}}
    const negRegex = /{{^(\w+)}}/g;
    
    while ((match = negRegex.exec(template)) !== null) {
      const [fullMatch, key] = match;
      const endTag = `{{/${key}}}`;
      
      // Find the end of this conditional block
      const startIndex = match.index;
      const endIndex = template.indexOf(endTag, startIndex) + endTag.length;
      
      if (endIndex > startIndex) {
        const blockContent = template.substring(startIndex + fullMatch.length, endIndex - endTag.length);
        
        // Check if condition is met (value is falsy)
        if (!this.formData[key]) {
          // Replace the entire block with just the content
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, blockContent);
        } else {
          // Remove the entire block
          config = config.replace(`${fullMatch}${blockContent}${endTag}`, '');
        }
      }
    }
    
    return config;
  }

  // Clean up any remaining template variables and conditionals
  cleanupTemplate(template) {
    let config = template;
    
    // Remove any remaining simple variables
    config = config.replace(/{{[^{}]+}}/g, '');
    
    // Remove any remaining conditional blocks
    config = config.replace(/{{#[^{}]+}}[\s\S]*?{{\/[^{}]+}}/g, '');
    config = config.replace(/{{^[^{}]+}}[\s\S]*?{{\/[^{}]+}}/g, '');
    
    // Clean up empty lines (more than 2 consecutive)
    config = config.replace(/\n{3,}/g, '\n\n');
    
    return config;
  }

  // Copy configuration to clipboard
  copyToClipboard() {
    const configOutput = document.getElementById('config-preview');
    if (!configOutput || !configOutput.textContent) {
      alert('No configuration to copy. Please generate a configuration first.');
      return;
    }
    
    // Create a temporary textarea element
    const textarea = document.createElement('textarea');
    textarea.value = configOutput.textContent;
    textarea.style.position = 'fixed';
    textarea.style.opacity = 0;
    document.body.appendChild(textarea);
    
    // Select and copy text
    textarea.select();
    document.execCommand('copy');
    
    // Clean up
    document.body.removeChild(textarea);
    
    // Show success message
    alert('Configuration copied to clipboard!');
  }

  // Download configuration as a file
  downloadConfiguration() {
    const configOutput = document.getElementById('config-preview');
    if (!configOutput || !configOutput.textContent) {
      alert('No configuration to download. Please generate a configuration first.');
      return;
    }
    
    // Create filename based on vendor and platform
    let filename = 'config.txt';
    if (this.formData.vendor && this.formData.platform) {
      filename = `${this.formData.vendor}-${this.formData.platform}-config.txt`;
    }
    
    // Create a blob and download link
    const blob = new Blob([configOutput.textContent], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    
    const a = document.createElement('a');
    a.href = url;
    a.download = filename;
    a.style.display = 'none';
    
    // Trigger download
    document.body.appendChild(a);
    a.click();
    
    // Clean up
    setTimeout(() => {
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    }, 100);
  }
}

// Initialize the wizard when the document is ready
document.addEventListener('DOMContentLoaded', () => {
  const wizard = new VendorWizard();
  wizard.init();
});
EOL

  progress "Wizard JavaScript created successfully"
}

# Enhance the core functionality of Dot1Xer
enhance_core_functionality() {
  progress "Enhancing core functionality..."

  # Create a deployment checklist HTML template
  cat > "${TEMPLATES_DIR}/deployment-checklist.html" << 'EOL'
<div class="checklist-wrapper">
    <div class="checklist-header">
        <h2>802.1X Deployment Checklist</h2>
        <div class="progress-container">
            <div class="progress-bar">
                <div class="progress-fill" style="width: 0%"></div>
            </div>
            <div class="progress-text">0% complete</div>
        </div>
    </div>
    
    <div class="checklist-section">
        <h3>1. Planning Phase</h3>
        <div class="checklist-item">
            <input type="checkbox" id="check-requirements" class="checklist-checkbox">
            <label for="check-requirements">Identify business requirements and scope</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-inventory" class="checklist-checkbox">
            <label for="check-inventory">Inventory network devices for 802.1X compatibility</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-endpoints" class="checklist-checkbox">
            <label for="check-endpoints">Identify endpoint types and authentication methods</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-exceptions" class="checklist-checkbox">
            <label for="check-exceptions">Document exceptions and special devices</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-topology" class="checklist-checkbox">
            <label for="check-topology">Document network topology and RADIUS server placement</label>
        </div>
    </div>
    
    <div class="checklist-section">
        <h3>2. RADIUS Server Setup</h3>
        <div class="checklist-item">
            <input type="checkbox" id="check-radius-install" class="checklist-checkbox">
            <label for="check-radius-install">Install RADIUS server (ISE, ClearPass, NPS, etc.)</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-radius-config" class="checklist-checkbox">
            <label for="check-radius-config">Configure RADIUS server authentication methods</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-radius-policies" class="checklist-checkbox">
            <label for="check-radius-policies">Create authorization policies</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-radius-test" class="checklist-checkbox">
            <label for="check-radius-test">Test RADIUS server basic authentication</label>
        </div>
    </div>
    
    <div class="checklist-section">
        <h3>3. Network Device Configuration</h3>
        <div class="checklist-item">
            <input type="checkbox" id="check-switch-config" class="checklist-checkbox">
            <label for="check-switch-config">Configure global 802.1X settings on switches</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-radius-clients" class="checklist-checkbox">
            <label for="check-radius-clients">Add switches as RADIUS clients on server</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-vlan-config" class="checklist-checkbox">
            <label for="check-vlan-config">Configure VLANs (authenticated, unauthenticated, voice)</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-aaa" class="checklist-checkbox">
            <label for="check-aaa">Configure AAA settings (authentication, authorization, accounting)</label>
        </div>
    </div>
    
    <div class="checklist-section">
        <h3>4. Testing Phase</h3>
        <div class="checklist-item">
            <input type="checkbox" id="check-lab-test" class="checklist-checkbox">
            <label for="check-lab-test">Perform lab testing with all device types</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-monitor-test" class="checklist-checkbox">
            <label for="check-monitor-test">Configure and test Monitor Mode</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-logging" class="checklist-checkbox">
            <label for="check-logging">Set up logging and monitoring</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-pilot" class="checklist-checkbox">
            <label for="check-pilot">Conduct pilot deployment</label>
        </div>
    </div>
    
    <div class="checklist-section">
        <h3>5. Deployment Phase</h3>
        <div class="checklist-item">
            <input type="checkbox" id="check-notifications" class="checklist-checkbox">
            <label for="check-notifications">Send user notifications</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-monitor-mode" class="checklist-checkbox">
            <label for="check-monitor-mode">Deploy in Monitor Mode</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-low-impact" class="checklist-checkbox">
            <label for="check-low-impact">Transition to Low-Impact Mode</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-closed-mode" class="checklist-checkbox">
            <label for="check-closed-mode">Transition to Closed Mode (full enforcement)</label>
        </div>
    </div>
    
    <div class="checklist-section">
        <h3>6. Post-Deployment</h3>
        <div class="checklist-item">
            <input type="checkbox" id="check-documentation" class="checklist-checkbox">
            <label for="check-documentation">Update network documentation</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-monitoring" class="checklist-checkbox">
            <label for="check-monitoring">Set up ongoing monitoring</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-training" class="checklist-checkbox">
            <label for="check-training">Conduct staff training</label>
        </div>
        <div class="checklist-item">
            <input type="checkbox" id="check-audit" class="checklist-checkbox">
            <label for="check-audit">Schedule regular audits</label>
        </div>
    </div>
    
    <div class="checklist-actions">
        <button id="checklist-save" class="btn primary">Save Progress</button>
        <button id="checklist-print" class="btn">Print Checklist</button>
        <button id="checklist-export" class="btn">Export as PDF</button>
    </div>
</div>
EOL

  # Create platform selection HTML template
  cat > "${TEMPLATES_DIR}/platform-selection.html" << 'EOL'
<div class="platform-selection container">
    <h2>Select Vendor and Platform</h2>
    
    <div class="section-info">
        <p>Choose your network vendor and platform to generate a tailored configuration. Select from wired 802.1X, wireless authentication, TACACS+, VPN, or user authentication options.</p>
    </div>
    
    <div class="form-group">
        <label for="deployment-type">Deployment Type</label>
        <select id="deployment-type" class="form-control">
            <option value="wired">Wired 802.1X Authentication</option>
            <option value="wireless">Wireless WPA Enterprise</option>
            <option value="tacacs">TACACS+ Device Administration</option>
            <option value="vpn">VPN Authentication</option>
            <option value="uaac">User Authentication & Access Control</option>
        </select>
    </div>
    
    <h3>Vendor Selection</h3>
    <div id="vendor-grid" class="vendor-selection">
        <!-- Vendor cards will be dynamically populated here -->
        <div class="loading">Loading vendors...</div>
    </div>
    
    <div class="platform-details-container">
        <h3>Platform Details</h3>
        
        <div class="form-group">
            <label for="platform-select">Device Platform</label>
            <select id="platform-select" class="form-control" disabled>
                <option value="">Select a vendor first</option>
            </select>
        </div>
        
        <div id="platform-details" class="platform-details">
            <p>Please select a vendor and platform.</p>
        </div>
        
        <div class="button-group">
            <button id="platform-next" class="btn primary" disabled>Next: Authentication</button>
        </div>
    </div>
</div>

<script>
    // This ensures vendor grid is populated on this page
    document.addEventListener('DOMContentLoaded', function() {
        // Initialize vendor grid directly if it exists on this page
        const vendorGrid = document.getElementById('vendor-grid');
        if (vendorGrid) {
            setTimeout(function() {
                if (typeof initVendorGrid === 'function') {
                    console.log('Initializing vendor grid from embedded script...');
                    initVendorGrid();
                    setupVendorSelection();
                    
                    // Select default vendor if one is saved
                    const savedVendor = localStorage.getItem('selectedVendor');
                    if (savedVendor && window.vendors && window.vendors[savedVendor]) {
                        selectVendor(savedVendor);
                    } else {
                        // Default to Cisco
                        selectVendor('cisco');
                    }
                }
            }, 500);
        }
    });
</script>
EOL

  progress "Core functionality enhanced successfully"
}

# Main execution
main() {
  # Display welcome message
  echo -e "${GREEN}Dot1Xer Enhancement Script${NC}"
  echo -e "${GREEN}=============================${NC}"
  echo "This script will enhance Dot1Xer with comprehensive vendor configurations and advanced authentication settings."
  echo
  
  # Check if running from correct directory
  check_dir "$TEMPLATES_DIR"
  check_dir "$CSS_DIR"
  check_dir "$JS_DIR"
  
  # Create backup
  create_backup
  
  # Setup vendor directories
  setup_vendor_dirs
  
  # Create comprehensive templates
  create_templates
  
  # Update UI components
  update_ui
  
  # Create configuration generator JavaScript
  create_js_generator
  
  # Create wizard JavaScript
  create_wizard_js
  
  # Enhance core functionality
  enhance_core_functionality
  
  # Display success message
  echo
  echo -e "${GREEN}Dot1Xer enhancement completed successfully!${NC}"
  echo "The tool now includes:"
  echo "- Comprehensive configurations for all major network vendors"
  echo "- Advanced authentication settings (802.1X, MAB, TACACS+, RADSEC, CoA, etc.)"
  echo "- Enhanced UI for a seamless configuration experience"
  echo "- Deployment checklist and guidance"
  echo
  echo "A backup of the original files has been created in: $BACKUP_DIR"
  echo
  echo "To use the enhanced Dot1Xer, simply reload the application in your browser."
}

# Run the script
main

exit 0
