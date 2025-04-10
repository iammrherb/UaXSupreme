/**
 * Dot1Xer Supreme Enterprise Edition - Vendor Configuration Generators
 * Version 4.0.0
 */

// Vendor configuration data
const vendorData = {
    // List of all supported vendors
    vendors: [
        { id: 'cisco', name: 'Cisco', logo: 'cisco-logo.svg' },
        { id: 'aruba', name: 'Aruba', logo: 'aruba-logo.svg' },
        { id: 'juniper', name: 'Juniper', logo: 'juniper-logo.svg' },
        { id: 'hp', name: 'HP', logo: 'hp-logo.svg' },
        { id: 'extreme', name: 'Extreme', logo: 'extreme-logo.svg' },
        { id: 'fortinet', name: 'Fortinet', logo: 'fortinet-logo.svg' },
        { id: 'dell', name: 'Dell', logo: 'dell-logo.svg' },
        { id: 'huawei', name: 'Huawei', logo: 'huawei-logo.svg' },
        { id: 'ruckus', name: 'Ruckus', logo: 'ruckus-logo.svg' },
        { id: 'paloalto', name: 'Palo Alto', logo: 'paloalto-logo.svg' },
        { id: 'checkpoint', name: 'Check Point', logo: 'checkpoint-logo.svg' },
        { id: 'alcatel', name: 'Alcatel-Lucent', logo: 'alcatel-logo.svg' },
        { id: 'meraki', name: 'Cisco Meraki', logo: 'meraki-logo.svg' },
        { id: 'arista', name: 'Arista', logo: 'arista-logo.svg' },
        { id: 'ubiquiti', name: 'Ubiquiti', logo: 'ubiquiti-logo.svg' }
    ],
    
    // Platforms by vendor
    platforms: {
        'cisco': [
            { id: 'ios', name: 'IOS' },
            { id: 'ios-xe', name: 'IOS-XE' },
            { id: 'nx-os', name: 'NX-OS' },
            { id: 'ise', name: 'ISE (RADIUS Server)' }
        ],
        'aruba': [
            { id: 'aos-cx', name: 'AOS-CX' },
            { id: 'aos-switch', name: 'AOS-Switch' },
            { id: 'clearpass', name: 'ClearPass (RADIUS Server)' },
            { id: 'instant', name: 'Aruba Instant' }
        ],
        'juniper': [
            { id: 'junos', name: 'JunOS' },
            { id: 'ex', name: 'EX Series' },
            { id: 'srx', name: 'SRX Series' },
            { id: 'mist', name: 'Mist Cloud' }
        ],
        'hp': [
            { id: 'procurve', name: 'ProCurve' },
            { id: 'comware', name: 'Comware' }
        ],
        'extreme': [
            { id: 'exos', name: 'EXOS' },
            { id: 'voss', name: 'VOSS' }
        ],
        'fortinet': [
            { id: 'fortiswitch', name: 'FortiSwitch' },
            { id: 'fortigate', name: 'FortiGate' },
            { id: 'fortinac', name: 'FortiNAC' }
        ],
        'dell': [
            { id: 'os10', name: 'OS10' },
            { id: 'os9', name: 'OS9' }
        ],
        'huawei': [
            { id: 'vrp', name: 'VRP' },
            { id: 's-series', name: 'S-Series' }
        ],
        'ruckus': [
            { id: 'icx', name: 'ICX' },
            { id: 'fastiron', name: 'FastIron' },
            { id: 'smartzone', name: 'SmartZone' }
        ],
        'paloalto': [
            { id: 'panos', name: 'PAN-OS' }
        ],
        'checkpoint': [
            { id: 'gaia', name: 'Gaia OS' }
        ],
        'alcatel': [
            { id: 'aos', name: 'AOS' },
            { id: 'omniswitch', name: 'OmniSwitch' }
        ],
        'meraki': [
            { id: 'ms', name: 'MS Switch' },
            { id: 'mx', name: 'MX Security Appliance' },
            { id: 'mr', name: 'MR Wireless' }
        ],
        'arista': [
            { id: 'eos', name: 'EOS' }
        ],
        'ubiquiti': [
            { id: 'unifi', name: 'UniFi' },
            { id: 'edgeswitch', name: 'EdgeSwitch' }
        ]
    }
};

// Main function to generate vendor-specific configuration
window.generateVendorConfig = function(vendor, platform, settings) {
    console.log(`Generating configuration for ${vendor} ${platform}`, settings);
    
    // Dispatch based on vendor and platform
    switch (vendor) {
        case 'cisco':
            return generateCiscoConfig(platform, settings);
        case 'aruba':
            return generateArubaConfig(platform, settings);
        case 'juniper':
            return generateJuniperConfig(platform, settings);
        case 'hp':
            return generateHpConfig(platform, settings);
        case 'extreme':
            return generateExtremeConfig(platform, settings);
        case 'fortinet':
            return generateFortinetConfig(platform, settings);
        case 'dell':
            return generateDellConfig(platform, settings);
        case 'huawei':
            return generateHuaweiConfig(platform, settings);
        case 'ruckus':
            return generateRuckusConfig(platform, settings);
        case 'paloalto':
            return generatePaloAltoConfig(platform, settings);
        case 'checkpoint':
            return generateCheckPointConfig(platform, settings);
        case 'alcatel':
            return generateAlcatelConfig(platform, settings);
        case 'meraki':
            return generateMerakiConfig(platform, settings);
        case 'arista':
            return generateAristaConfig(platform, settings);
        case 'ubiquiti':
            return generateUbiquitiConfig(platform, settings);
        default:
            return generateGenericConfig(vendor, platform, settings);
    }
};

// Cisco configuration generator
function generateCiscoConfig(platform, settings) {
    switch (platform) {
        case 'ios':
            return `! Cisco IOS 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Global AAA Configuration
aaa new-model
aaa authentication dot1x default group radius
aaa authorization network default group radius
${settings.enableAccounting ? 'aaa accounting dot1x default start-stop group radius' : '!aaa accounting is disabled'}

! RADIUS Server Configuration
radius server PRIMARY
 address ipv4 ${settings.radiusServer || '10.1.1.1'} auth-port 1812 acct-port 1813
 key ${settings.radiusKey || 'radiuskey'}
 timeout 5
 retransmit 3

${settings.secondaryServer ? `radius server SECONDARY
 address ipv4 ${settings.secondaryServer} auth-port 1812 acct-port 1813
 key ${settings.secondaryKey || 'radiuskey'}
 timeout 5
 retransmit 3
` : ''}
! RADIUS Server Group
aaa group server radius DOT1X-SERVERS
 server name PRIMARY
${settings.secondaryServer ? ' server name SECONDARY' : ''}
 deadtime 15

! Enable 802.1X Globally
dot1x system-auth-control
authentication mac-move permit

${settings.useRadsec ? `! RadSec Configuration (RADIUS over TLS)
radius server RADSEC
 address ipv4 ${settings.radiusServer || '10.1.1.1'} auth-port 2083 acct-port 2083
 key radsec
 dtls
  encryption aes256-gcm-sha384
  port 2083
  source-interface ${settings.mgmtInterface || 'Loopback0'}
  trustpoint client DOT1X-CERT
  trustpoint server DOT1X-CA
` : ''}

${settings.useCoa ? `! RADIUS Change of Authorization (CoA)
aaa server radius dynamic-author
 client ${settings.radiusServer || '10.1.1.1'} server-key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? ` client ${settings.secondaryServer} server-key ${settings.secondaryKey || 'radiuskey'}` : ''}
 auth-type any
` : ''}

! VLAN Configuration
${settings.vlanAuth ? `vlan ${settings.vlanAuth}
 name AUTH_VLAN` : ''}
${settings.vlanUnauth ? `vlan ${settings.vlanUnauth}
 name UNAUTH_VLAN` : ''}
${settings.vlanGuest ? `vlan ${settings.vlanGuest}
 name GUEST_VLAN` : ''}
${settings.vlanVoice ? `vlan ${settings.vlanVoice}
 name VOICE_VLAN` : ''}
${settings.vlanCritical ? `vlan ${settings.vlanCritical}
 name CRITICAL_VLAN` : ''}

${settings.enableDhcpSnooping ? `! DHCP Snooping Configuration
ip dhcp snooping
ip dhcp snooping vlan ${settings.vlanAuth || '1'}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}
no ip dhcp snooping information option
ip dhcp snooping database flash:dhcp-snooping.txt
` : ''}

${settings.enableDai ? `! Dynamic ARP Inspection
ip arp inspection vlan ${settings.vlanAuth || '1'}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}
ip arp inspection validate src-mac dst-mac ip
` : ''}

${settings.enableIpsg ? `! IP Source Guard
ip source binding interface ${settings.interface || 'GigabitEthernet1/0/1'} ${settings.vlanAuth || '1'} 0000.0000.0000 dhcp snooping
` : ''}

! Interface Configuration
interface ${settings.interface || 'GigabitEthernet1/0/1'}
 switchport mode access
 switchport access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ` switchport voice vlan ${settings.vlanVoice}` : ''}
 dot1x pae authenticator
 dot1x timeout tx-period ${settings.txPeriod}
 dot1x timeout quiet-period ${settings.quietPeriod}
 dot1x timeout reauth-period ${settings.reauthPeriod}
 dot1x max-reauth-req ${settings.maxReauth}
${settings.vlanUnauth ? ` authentication event fail action authorize vlan ${settings.vlanUnauth}
 authentication event server dead action authorize vlan ${settings.vlanUnauth}` : ''}
 authentication event server alive action reinitialize
${settings.hostMode === 'multi-domain' ? ' authentication host-mode multi-domain' : 
  settings.hostMode === 'multi-auth' ? ' authentication host-mode multi-auth' : 
  settings.hostMode === 'multi-host' ? ' authentication host-mode multi-host' : 
  ' authentication host-mode single-host'}
${settings.authMethod === 'mab' ? ' authentication order mab\n authentication priority mab\n mab' : 
  settings.authMethod === 'dot1x-mab' ? ' authentication order dot1x mab\n authentication priority dot1x mab\n dot1x pae authenticator\n mab' : 
  settings.authMethod === 'concurrent' ? ' authentication order dot1x mab\n dot1x pae authenticator\n mab' :
  ' authentication order dot1x\n authentication priority dot1x\n dot1x pae authenticator'}
${settings.authMode === 'open' || settings.deployStrategy === 'monitor' ? ' authentication open' : ''}
 authentication port-control auto
 spanning-tree portfast
${settings.vlanGuest ? ` dot1x guest-vlan ${settings.vlanGuest}` : ''}
${settings.enableDhcpSnooping ? ' ip dhcp snooping limit rate 20' : ''}
${settings.enableIpsg ? ' ip verify source' : ''}
${settings.useMacsec ? ' macsec' : ''}

${settings.interfaceRange ? `! Interface Range Configuration
interface range ${settings.interfaceRange}
 switchport mode access
 switchport access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ` switchport voice vlan ${settings.vlanVoice}` : ''}
 dot1x pae authenticator
 dot1x timeout tx-period ${settings.txPeriod}
 dot1x timeout quiet-period ${settings.quietPeriod}
 dot1x timeout reauth-period ${settings.reauthPeriod}
 dot1x max-reauth-req ${settings.maxReauth}
${settings.vlanUnauth ? ` authentication event fail action authorize vlan ${settings.vlanUnauth}
 authentication event server dead action authorize vlan ${settings.vlanUnauth}` : ''}
 authentication event server alive action reinitialize
${settings.hostMode === 'multi-domain' ? ' authentication host-mode multi-domain' : 
  settings.hostMode === 'multi-auth' ? ' authentication host-mode multi-auth' : 
  settings.hostMode === 'multi-host' ? ' authentication host-mode multi-host' : 
  ' authentication host-mode single-host'}
${settings.authMethod === 'mab' ? ' authentication order mab\n authentication priority mab\n mab' : 
  settings.authMethod === 'dot1x-mab' ? ' authentication order dot1x mab\n authentication priority dot1x mab\n dot1x pae authenticator\n mab' : 
  settings.authMethod === 'concurrent' ? ' authentication order dot1x mab\n dot1x pae authenticator\n mab' :
  ' authentication order dot1x\n authentication priority dot1x\n dot1x pae authenticator'}
${settings.authMode === 'open' || settings.deployStrategy === 'monitor' ? ' authentication open' : ''}
 authentication port-control auto
 spanning-tree portfast
${settings.vlanGuest ? ` dot1x guest-vlan ${settings.vlanGuest}` : ''}
${settings.enableDhcpSnooping ? ' ip dhcp snooping limit rate 20' : ''}
${settings.enableIpsg ? ' ip verify source' : ''}
${settings.useMacsec ? ' macsec' : ''}
` : ''}

! Show commands for verification
! show dot1x all
! show authentication sessions
! show authentication sessions interface ${settings.interface || 'GigabitEthernet1/0/1'} details`;

        case 'ios-xe':
            return `! Cisco IOS-XE 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Global AAA Configuration
aaa new-model
aaa authentication dot1x default group radius
aaa authorization network default group radius
${settings.enableAccounting ? 'aaa accounting dot1x default start-stop group radius' : '!aaa accounting is disabled'}

! RADIUS Server Configuration
radius server PRIMARY
 address ipv4 ${settings.radiusServer || '10.1.1.1'} auth-port 1812 acct-port 1813
 key ${settings.radiusKey || 'radiuskey'}
 timeout 5
 retransmit 3

${settings.secondaryServer ? `radius server SECONDARY
 address ipv4 ${settings.secondaryServer} auth-port 1812 acct-port 1813
 key ${settings.secondaryKey || 'radiuskey'}
 timeout 5
 retransmit 3
` : ''}
! RADIUS Server Group
aaa group server radius DOT1X-SERVERS
 server name PRIMARY
${settings.secondaryServer ? ' server name SECONDARY' : ''}
 deadtime 15

! Enable 802.1X Globally
dot1x system-auth-control
authentication mac-move permit

${settings.useRadsec ? `! RadSec Configuration (RADIUS over TLS)
radius server RADSEC
 address ipv4 ${settings.radiusServer || '10.1.1.1'} auth-port 2083 acct-port 2083
 key radsec
 dtls
  encryption aes256-gcm-sha384
  port 2083
  source-interface ${settings.mgmtInterface || 'Loopback0'}
  trustpoint client DOT1X-CERT
  trustpoint server DOT1X-CA
` : ''}

${settings.useCoa ? `! RADIUS Change of Authorization (CoA)
aaa server radius dynamic-author
 client ${settings.radiusServer || '10.1.1.1'} server-key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? ` client ${settings.secondaryServer} server-key ${settings.secondaryKey || 'radiuskey'}` : ''}
 auth-type any
` : ''}

! Device Tracking Configuration
device-tracking tracking
device-tracking policy IPDT_POLICY
 tracking enable
 no IPv6 tracking

! VLAN Configuration
${settings.vlanAuth ? `vlan ${settings.vlanAuth}
 name AUTH_VLAN` : ''}
${settings.vlanUnauth ? `vlan ${settings.vlanUnauth}
 name UNAUTH_VLAN` : ''}
${settings.vlanGuest ? `vlan ${settings.vlanGuest}
 name GUEST_VLAN` : ''}
${settings.vlanVoice ? `vlan ${settings.vlanVoice}
 name VOICE_VLAN` : ''}
${settings.vlanCritical ? `vlan ${settings.vlanCritical}
 name CRITICAL_VLAN` : ''}

${settings.enableDhcpSnooping ? `! DHCP Snooping Configuration
ip dhcp snooping
ip dhcp snooping vlan ${settings.vlanAuth || '1'}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}
no ip dhcp snooping information option
ip dhcp snooping database flash:dhcp-snooping.txt
` : ''}

${settings.enableDai ? `! Dynamic ARP Inspection
ip arp inspection vlan ${settings.vlanAuth || '1'}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}
ip arp inspection validate src-mac dst-mac ip
` : ''}

! Interface Configuration
interface ${settings.interface || 'GigabitEthernet1/0/1'}
 switchport mode access
 switchport access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ` switchport voice vlan ${settings.vlanVoice}` : ''}
 dot1x pae authenticator
 dot1x timeout tx-period ${settings.txPeriod}
 dot1x timeout quiet-period ${settings.quietPeriod}
 dot1x timeout reauth-period ${settings.reauthPeriod}
 dot1x max-reauth-req ${settings.maxReauth}
${settings.vlanUnauth ? ` authentication event fail action authorize vlan ${settings.vlanUnauth}
 authentication event server dead action authorize vlan ${settings.vlanUnauth}` : ''}
 authentication event server alive action reinitialize
${settings.hostMode === 'multi-domain' ? ' authentication host-mode multi-domain' : 
  settings.hostMode === 'multi-auth' ? ' authentication host-mode multi-auth' : 
  settings.hostMode === 'multi-host' ? ' authentication host-mode multi-host' : 
  ' authentication host-mode single-host'}
${settings.authMethod === 'mab' ? ' authentication order mab\n authentication priority mab\n mab' : 
  settings.authMethod === 'dot1x-mab' ? ' authentication order dot1x mab\n authentication priority dot1x mab\n dot1x pae authenticator\n mab' : 
  settings.authMethod === 'concurrent' ? ' authentication order dot1x mab\n dot1x pae authenticator\n mab' :
  ' authentication order dot1x\n authentication priority dot1x\n dot1x pae authenticator'}
${settings.authMode === 'open' || settings.deployStrategy === 'monitor' ? ' authentication open' : ''}
 authentication port-control auto
 spanning-tree portfast
${settings.vlanGuest ? ` dot1x guest-vlan ${settings.vlanGuest}` : ''}
 device-tracking attach-policy IPDT_POLICY
${settings.enableDhcpSnooping ? ' ip dhcp snooping limit rate 20' : ''}
${settings.enableIpsg ? ' ip verify source' : ''}
${settings.useMacsec ? ' macsec' : ''}

${settings.interfaceRange ? `! Interface Range Configuration
interface range ${settings.interfaceRange}
 switchport mode access
 switchport access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ` switchport voice vlan ${settings.vlanVoice}` : ''}
 dot1x pae authenticator
 dot1x timeout tx-period ${settings.txPeriod}
 dot1x timeout quiet-period ${settings.quietPeriod}
 dot1x timeout reauth-period ${settings.reauthPeriod}
 dot1x max-reauth-req ${settings.maxReauth}
${settings.vlanUnauth ? ` authentication event fail action authorize vlan ${settings.vlanUnauth}
 authentication event server dead action authorize vlan ${settings.vlanUnauth}` : ''}
 authentication event server alive action reinitialize
${settings.hostMode === 'multi-domain' ? ' authentication host-mode multi-domain' : 
  settings.hostMode === 'multi-auth' ? ' authentication host-mode multi-auth' : 
  settings.hostMode === 'multi-host' ? ' authentication host-mode multi-host' : 
  ' authentication host-mode single-host'}
${settings.authMethod === 'mab' ? ' authentication order mab\n authentication priority mab\n mab' : 
  settings.authMethod === 'dot1x-mab' ? ' authentication order dot1x mab\n authentication priority dot1x mab\n dot1x pae authenticator\n mab' : 
  settings.authMethod === 'concurrent' ? ' authentication order dot1x mab\n dot1x pae authenticator\n mab' :
  ' authentication order dot1x\n authentication priority dot1x\n dot1x pae authenticator'}
${settings.authMode === 'open' || settings.deployStrategy === 'monitor' ? ' authentication open' : ''}
 authentication port-control auto
 spanning-tree portfast
${settings.vlanGuest ? ` dot1x guest-vlan ${settings.vlanGuest}` : ''}
 device-tracking attach-policy IPDT_POLICY
${settings.enableDhcpSnooping ? ' ip dhcp snooping limit rate 20' : ''}
${settings.enableIpsg ? ' ip verify source' : ''}
${settings.useMacsec ? ' macsec' : ''}
` : ''}

! Additional IOS-XE specific commands
access-session attributes filter-list list DEFAULT-list
 device-type
 mac-address
 service-type
access-session accounting attributes filter-spec include list DEFAULT-list

! Show commands for verification
! show dot1x all
! show authentication sessions
! show authentication sessions interface ${settings.interface || 'GigabitEthernet1/0/1'} details`;

        case 'nx-os':
            return `! Cisco NX-OS 802.1X Configuration
! Cisco NX-OS 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Enable 802.1X feature
feature dot1x
${settings.enableDhcpSnooping ? 'feature dhcp' : ''}
${settings.enableDai ? 'feature dhcp\nfeature arp-inspection' : ''}

! AAA Configuration
aaa authentication dot1x default group radius
${settings.enableAccounting ? 'aaa accounting dot1x default group radius' : ''}

! RADIUS Server Configuration
radius-server host ${settings.radiusServer || '10.1.1.1'} key ${settings.radiusKey || 'radiuskey'} authentication accounting
${settings.secondaryServer ? `radius-server host ${settings.secondaryServer} key ${settings.secondaryKey || 'radiuskey'} authentication accounting` : ''}
radius-server deadtime 15

${settings.enableDhcpSnooping ? `! DHCP Snooping Configuration
ip dhcp snooping
ip dhcp snooping vlan ${settings.vlanAuth || '1'}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}
` : ''}

${settings.enableDai ? `! Dynamic ARP Inspection
ip arp inspection vlan ${settings.vlanAuth || '1'}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}
` : ''}

! Interface Configuration
interface ${settings.interface || 'Ethernet1/1'}
 switchport mode access
 switchport access vlan ${settings.vlanAuth || '1'}
 dot1x pae authenticator
 dot1x timeout tx-period ${settings.txPeriod}
 dot1x timeout quiet-period ${settings.quietPeriod}
 dot1x timeout re-authperiod ${settings.reauthPeriod}
 dot1x max-req ${settings.maxReauth}
 dot1x port-control auto
${settings.hostMode === 'multi-host' ? ' dot1x host-mode multi-host' : settings.hostMode === 'single-host' ? ' dot1x host-mode single-host' : ''}
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' ? ' mac-authentication' : ''}
${settings.enableDhcpSnooping ? ' ip dhcp snooping limit rate 30' : ''}
${settings.enableIpsg ? ' ip verify source dhcp-snooping-vlan' : ''}
 no shutdown

${settings.interfaceRange ? `! Interface Range Configuration
interface range ${settings.interfaceRange}
 switchport mode access
 switchport access vlan ${settings.vlanAuth || '1'}
 dot1x pae authenticator
 dot1x timeout tx-period ${settings.txPeriod}
 dot1x timeout quiet-period ${settings.quietPeriod}
 dot1x timeout re-authperiod ${settings.reauthPeriod}
 dot1x max-req ${settings.maxReauth}
 dot1x port-control auto
${settings.hostMode === 'multi-host' ? ' dot1x host-mode multi-host' : settings.hostMode === 'single-host' ? ' dot1x host-mode single-host' : ''}
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' ? ' mac-authentication' : ''}
${settings.enableDhcpSnooping ? ' ip dhcp snooping limit rate 30' : ''}
${settings.enableIpsg ? ' ip verify source dhcp-snooping-vlan' : ''}
 no shutdown
` : ''}

! Show commands for verification
! show dot1x all
! show dot1x interface ${settings.interface || 'Ethernet1/1'} details`;

        case 'ise':
            return `! Cisco ISE RADIUS Server Configuration for 802.1X
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Note: These are CLI reference configurations for ISE. Actual configuration is done via web UI.
!
! RADIUS Configuration in ISE
!
! 1. Add Network Devices:
!    Administration > Network Resources > Network Devices > Add
!    - Name: Switch1
!    - IP Address: <switch-ip>
!    - Device Profile: Cisco
!    - RADIUS Authentication Settings: Shared Secret: ${settings.radiusKey || 'radiuskey'}
!
! 2. Configure Authentication Policy:
!    Policy > Policy Sets > Default > Authentication Policy
!    - Rule Name: Dot1X_Authentication
!    - Conditions: Network Access:AuthenticationMethod EQUALS EAP
!    - Use: Internal Endpoints and AD (if applicable)
!
! 3. Configure Authorization Policy:
!    Policy > Policy Sets > Default > Authorization Policy
!    - Rule Name: Authenticated_Access
!    - Conditions: Network Access:AuthenticationMethod EQUALS EAP
!    - Profiles: PermitAccess
!    - RADIUS Attributes: Tunnel-Private-Group-ID=${settings.vlanAuth || '1'}
!
! 4. Configure Authorization Policy for MAB if needed:
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? `!    Policy > Policy Sets > Default > Authorization Policy
!    - Rule Name: MAB_Access
!    - Conditions: Network Access:AuthenticationMethod EQUALS MAB
!    - Profiles: PermitAccess
!    - RADIUS Attributes: Tunnel-Private-Group-ID=${settings.vlanAuth || '1'}
` : ''}!
! 5. Configure Guest VLAN if needed:
${settings.vlanGuest ? `!    Policy > Policy Sets > Default > Authorization Policy
!    - Rule Name: Guest_Access
!    - Conditions: (Create condition for guest devices)
!    - Profiles: PermitAccess
!    - RADIUS Attributes: Tunnel-Private-Group-ID=${settings.vlanGuest}
` : ''}!
! 6. Configure Change of Authorization (CoA) if needed:
${settings.useCoa ? `!    Administration > System > Settings > Profiling
!    - Enable RADIUS CoA: Yes
` : ''}!
! Switch Configuration for ISE RADIUS:
!
radius server ISE
 address ipv4 <ise-ip> auth-port 1812 acct-port 1813
 key ${settings.radiusKey || 'radiuskey'}
 timeout 5
 retransmit 3
!
aaa group server radius ISE_GROUP
 server name ISE
!
aaa authentication dot1x default group ISE_GROUP
aaa authorization network default group ISE_GROUP
${settings.enableAccounting ? 'aaa accounting dot1x default start-stop group ISE_GROUP' : ''}
!
! For more detailed ISE configuration, refer to Cisco ISE documentation.`;

        default:
            return `! Cisco ${platform} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Note: Specific configuration syntax for ${platform} is not available.
! Please refer to Cisco documentation for exact configuration syntax.
!
! General parameters that would be configured:
! - RADIUS server: ${settings.radiusServer || 'Not specified'}
! - Authentication method: ${settings.authMethod}
! - Authentication VLAN: ${settings.vlanAuth || 'Not specified'}
! - Authentication mode: ${settings.authMode}
! - Host mode: ${settings.hostMode}`;
    }
}

// Aruba configuration generator
function generateArubaConfig(platform, settings) {
    switch (platform) {
        case 'aos-cx':
            return `! Aruba AOS-CX 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! RADIUS Authentication Configuration
radius-server host ${settings.radiusServer || '10.1.1.1'} key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? `radius-server host ${settings.secondaryServer} key ${settings.secondaryKey || 'radiuskey'}` : ''}

radius-server retransmit 3
radius-server timeout 5

! AAA Configuration
aaa authentication port-access dot1x authenticator
aaa authentication dot1x default group radius local
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? 'aaa authentication mac-auth default group radius local' : ''}
aaa authorization network default group radius
${settings.enableAccounting ? 'aaa accounting network start-stop group radius' : ''}

! 802.1X and MAC Authentication Timers
${settings.vlanUnauth ? `aaa port-access auth-failure-vlan ${settings.vlanUnauth}` : ''}
${settings.vlanCritical ? `aaa port-access auth-server-down-vlan ${settings.vlanCritical}` : ''}
${settings.vlanGuest ? `aaa port-access guest-vlan ${settings.vlanGuest}` : ''}

aaa port-access authenticator active
aaa port-access authenticator reauth-period ${settings.reauthPeriod}
aaa port-access authenticator quiet-period ${settings.quietPeriod}
aaa port-access authenticator tx-period ${settings.txPeriod}
aaa port-access authenticator max-requests ${settings.maxReauth}
aaa port-access authenticator max-retries 3

! Define 802.1X Authentication Profiles
aaa port-access authentication dot1x-profile
 authenticator
 active
${settings.authMode === 'closed' ? ' control unauthorized' : ' control auto'}
 interface-mode port-control-mode
 use-lldp
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' allow-mbv' : ''}
${settings.hostMode === 'multi-auth' ? ' multiauth' : settings.hostMode === 'multi-host' ? ' multihost' : ''}
 reauthenticate
 reauth-period ${settings.reauthPeriod}
${settings.vlanUnauth ? ` auth-fail-vlan ${settings.vlanUnauth}` : ''}
${settings.vlanCritical ? ` critical-vlan ${settings.vlanCritical}` : ''}
${settings.vlanVoice ? ` voice-vlan ${settings.vlanVoice}` : ''}

${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? `! Define MAC Authentication Profiles
aaa port-access mac-auth mac-auth-profile
 addr-format no-delimiter uppercase
 auth-vid ${settings.vlanAuth || '1'}
 unauth-vid ${settings.vlanUnauth || '999'}
 reauth-period ${settings.reauthPeriod}
` : ''}

! Interface Configuration
interface ${settings.interface || '1/1/1'}
 no routing
 vlan access ${settings.vlanAuth || '1'}
 aaa port-access authentication dot1x-profile
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' aaa port-access mac-auth mac-auth-profile' : ''}
${settings.vlanVoice ? ` voice-vlan ${settings.vlanVoice}` : ''}
 spanning-tree bpdu-protection
 spanning-tree port-type admin-edge
 no shutdown

${settings.interfaceRange ? `! Interface Range Configuration
interface range ${settings.interfaceRange}
 no routing
 vlan access ${settings.vlanAuth || '1'}
 aaa port-access authentication dot1x-profile
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' aaa port-access mac-auth mac-auth-profile' : ''}
${settings.vlanVoice ? ` voice-vlan ${settings.vlanVoice}` : ''}
 spanning-tree bpdu-protection
 spanning-tree port-type admin-edge
 no shutdown
` : ''}

${settings.enableDhcpSnooping ? `! DHCP Snooping Configuration
dhcp-snooping
vlan ${settings.vlanAuth || '1'} ${settings.vlanUnauth ? settings.vlanUnauth : ''} ${settings.vlanGuest ? settings.vlanGuest : ''}
dhcp-snooping trust
` : ''}

${settings.enableDai ? `! Dynamic ARP Inspection Configuration
arp-protect
vlan ${settings.vlanAuth || '1'} ${settings.vlanUnauth ? settings.vlanUnauth : ''} ${settings.vlanGuest ? settings.vlanGuest : ''}
arp-protect trust
` : ''}

! Show commands for verification
! show port-access authenticator
! show port-access authenticator interface ${settings.interface || '1/1/1'}
! show port-access clients`;

        case 'aos-switch':
            return `! Aruba AOS-Switch 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! RADIUS Authentication Configuration
radius-server host ${settings.radiusServer || '10.1.1.1'} key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? `radius-server host ${settings.secondaryServer} key ${settings.secondaryKey || 'radiuskey'}` : ''}

radius-server timeout 5
radius-server retransmit 3
radius-server dead-time 15

! AAA Configuration
aaa authentication port-access eap-radius
aaa authentication dot1x default radius local
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? 'aaa authentication mac-auth default radius local' : ''}
aaa authorization network default radius
${settings.enableAccounting ? 'aaa accounting network start-stop radius' : ''}

! 802.1X Global Configuration
aaa port-access authenticator active
aaa port-access authenticator reauth-period ${settings.reauthPeriod}
aaa port-access authenticator quiet-period ${settings.quietPeriod}
aaa port-access authenticator tx-period ${settings.txPeriod}
aaa port-access authenticator max-requests ${settings.maxReauth}
aaa port-access authenticator max-retries 3

! MAC Address Format for MAB
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? 'aaa port-access mac-auth addr-format no-delimiter\naaa port-access mac-auth addr-format uppercase' : ''}

! User Role Configuration
aaa authorization user-role name "Authenticated"
 vlan-id ${settings.vlanAuth || '1'}

${settings.vlanUnauth ? `aaa authorization user-role name "Unauthenticated"
 vlan-id ${settings.vlanUnauth}
` : ''}

${settings.vlanVoice ? `aaa authorization user-role name "VoIP"
 vlan-id ${settings.vlanVoice}
` : ''}

! Interface Configuration
interface ${settings.interface || '1/1'}
 no routing
 aaa port-access authenticator active
 aaa port-access authenticator reauth-period ${settings.reauthPeriod}
 aaa port-access authenticator quiet-period ${settings.quietPeriod}
 aaa port-access authenticator tx-period ${settings.txPeriod}
 aaa port-access authenticator max-requests ${settings.maxReauth}
 aaa port-access authenticator max-retries 3
 aaa port-access authenticator client-limit 1
${settings.vlanUnauth ? ` aaa port-access authenticator unauth-vid ${settings.vlanUnauth}` : ''}
${settings.vlanAuth ? ` aaa port-access authenticator auth-vid ${settings.vlanAuth}` : ''}
 aaa port-access authenticator logoff-period 300
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' aaa port-access mac-auth' : ''}
${settings.vlanVoice ? ` voice-vlan ${settings.vlanVoice}` : ''}
 spanning-tree bpdu-protection
 spanning-tree admin-edge-port

${settings.interfaceRange ? `! Interface Range Configuration
interface range ${settings.interfaceRange}
 no routing
 aaa port-access authenticator active
 aaa port-access authenticator reauth-period ${settings.reauthPeriod}
 aaa port-access authenticator quiet-period ${settings.quietPeriod}
 aaa port-access authenticator tx-period ${settings.txPeriod}
 aaa port-access authenticator max-requests ${settings.maxReauth}
 aaa port-access authenticator max-retries 3
 aaa port-access authenticator client-limit 1
${settings.vlanUnauth ? ` aaa port-access authenticator unauth-vid ${settings.vlanUnauth}` : ''}
${settings.vlanAuth ? ` aaa port-access authenticator auth-vid ${settings.vlanAuth}` : ''}
 aaa port-access authenticator logoff-period 300
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' aaa port-access mac-auth' : ''}
${settings.vlanVoice ? ` voice-vlan ${settings.vlanVoice}` : ''}
 spanning-tree bpdu-protection
 spanning-tree admin-edge-port
` : ''}

${settings.enableDhcpSnooping ? `! DHCP Snooping Configuration
dhcp-snooping
dhcp-snooping vlan ${settings.vlanAuth || '1'} ${settings.vlanUnauth ? settings.vlanUnauth : ''} ${settings.vlanGuest ? settings.vlanGuest : ''}
dhcp-snooping trust
` : ''}

! Show commands for verification
! show port-access authenticator
! show port-access authenticator ${settings.interface || '1/1'}
! show port-access clients`;

        case 'clearpass':
            return `! Aruba ClearPass Policy Manager Configuration for 802.1X
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Note: These are reference configurations for ClearPass. Actual configuration is done via web UI.
!
! ClearPass Configuration Steps
!
! 1. Add Network Device:
!    Configuration > Network > Devices > Add
!    - Name: Network_Switch
!    - IP Address/Subnet: <switch-ip>/32
!    - Vendor: Aruba
!    - RADIUS Shared Secret: ${settings.radiusKey || 'radiuskey'}
!    - Enable RADIUS CoA: ${settings.useCoa ? 'Yes' : 'No'}
!
! 2. Configure Authentication Methods:
!    Configuration > Authentication > Methods
!    - Method Name: Dot1X_Authentication
!    - Authentication Type: ${settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? 'EAPOL or MAC Auth' : 'EAPOL'}
!    - Authentication Sources: [Add appropriate authentication sources like Active Directory, etc.]
!
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? `!    - Method Name: MAC_Authentication
!    - Authentication Type: MAC Auth
!    - Authentication Sources: [Add appropriate authentication sources for MAC Auth]
!` : ''}
! 3. Configure Enforcement Policies:
!    Configuration > Enforcement > Policies
!    - Policy Name: Authenticated_Access
!    - Default Profile: Default_Allow_Access
!    - Rules:
!      - Conditions: Authentication:AuthMethod EQUALS 802.1X
!      - Profiles: Authenticated_Profile
!
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? `!    - Policy Name: MAB_Access
!    - Default Profile: Default_Allow_Access
!    - Rules:
!      - Conditions: Authentication:AuthMethod EQUALS MAC Auth
!      - Profiles: MAB_Profile
!` : ''}
! 4. Configure Enforcement Profiles:
!    Configuration > Enforcement > Profiles
!    - Profile Name: Authenticated_Profile
!    - Type: RADIUS
!    - Attributes:
!      - Tunnel-Type = 13 [VLAN]
!      - Tunnel-Medium-Type = 6 [IEEE-802]
!      - Tunnel-Private-Group-ID = ${settings.vlanAuth || '1'}
!
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? `!    - Profile Name: MAB_Profile
!    - Type: RADIUS
!    - Attributes:
!      - Tunnel-Type = 13 [VLAN]
!      - Tunnel-Medium-Type = 6 [IEEE-802]
!      - Tunnel-Private-Group-ID = ${settings.vlanAuth || '1'}
!` : ''}
${settings.vlanGuest ? `!    - Profile Name: Guest_Profile
!    - Type: RADIUS
!    - Attributes:
!      - Tunnel-Type = 13 [VLAN]
!      - Tunnel-Medium-Type = 6 [IEEE-802]
!      - Tunnel-Private-Group-ID = ${settings.vlanGuest}
!` : ''}
! 5. Configure Service:
!    Configuration > Services > Add
!    - Service Name: 802.1X_Service
!    - Type: 802.1X Wired
!    - Authentication Methods: [Select methods created above]
!    - Authorization Sources: [Select appropriate sources]
!    - Enforcement Policy: [Select policies created above]
!
! For more detailed ClearPass configuration, refer to Aruba documentation.
!
! Switch Configuration for ClearPass:
!
! radius-server host ${settings.radiusServer || '10.1.1.1'} key ${settings.radiusKey || 'radiuskey'}
! aaa authentication dot1x default radius
! aaa authorization network default radius
! ${settings.enableAccounting ? 'aaa accounting dot1x default start-stop radius' : ''}`;

        default:
            return `! Aruba ${platform} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Note: Specific configuration syntax for ${platform} is not available.
! Please refer to Aruba documentation for exact configuration syntax.
!
! General parameters that would be configured:
! - RADIUS server: ${settings.radiusServer || 'Not specified'}
! - Authentication method: ${settings.authMethod}
! - Authentication VLAN: ${settings.vlanAuth || 'Not specified'}
! - Authentication mode: ${settings.authMode}
! - Host mode: ${settings.hostMode}`;
    }
}

// Juniper configuration generator
function generateJuniperConfig(platform, settings) {
    switch (platform) {
        case 'junos':
        case 'ex':
            return `# Juniper ${platform} 802.1X Configuration
# Generated by Dot1Xer Supreme Enterprise Edition v4.0.0

system {
    radius-server {
        ${settings.radiusServer || '10.1.1.1'} {
            secret "${settings.radiusKey || 'radiuskey'}";
            timeout 5;
            retry 3;
            port 1812;
            accounting-port 1813;
        }
${settings.secondaryServer ? `        ${settings.secondaryServer} {
            secret "${settings.secondaryKey || 'radiuskey'}";
            timeout 5;
            retry 3;
            port 1812;
            accounting-port 1813;
        }` : ''}
    }
}

access {
    profile dot1x-profile {
        authentication-order [${settings.authMethod === 'mab' ? 'mac-radius' : settings.authMethod === 'dot1x-mab' ? 'dot1x mac-radius' : 'dot1x'}];
        radius {
            authentication-server [${settings.radiusServer || '10.1.1.1'}${settings.secondaryServer ? ' ' + settings.secondaryServer : ''}];
            accounting-server [${settings.radiusServer || '10.1.1.1'}${settings.secondaryServer ? ' ' + settings.secondaryServer : ''}];
        }
        accounting {
            order radius;
            accounting-stop-on-failure;
            accounting-stop-on-access-deny;
        }
    }
}

protocols {
    dot1x {
        authenticator {
            authentication-profile-name dot1x-profile;
            interface {
                ${settings.interface || 'ge-0/0/0'} {
${settings.hostMode === 'multi-host' ? '                    supplicant multiple;' : 
  settings.hostMode === 'single-host' ? '                    supplicant single;' : 
  settings.hostMode === 'multi-auth' || settings.hostMode === 'multi-domain' ? '                    supplicant multiple;' : 
  '                    supplicant multiple;'}
                    retries ${settings.maxReauth};
                    quiet-period ${settings.quietPeriod};
                    transmit-period ${settings.txPeriod};
                    mac-radius {
                        restrict;
                    }
                    server-timeout 30;
                    supplicant-timeout 30;
                    reauthentication ${settings.reauthPeriod};
${settings.vlanGuest ? `                    guest-vlan ${settings.vlanGuest};` : ''}
${settings.vlanUnauth ? `                    server-fail vlan-name ${settings.vlanUnauth};` : ''}
${settings.vlanUnauth ? `                    server-reject-vlan ${settings.vlanUnauth};` : ''}
                }
${settings.interfaceRange ? `
                ${settings.interfaceRange} {
${settings.hostMode === 'multi-host' ? '                    supplicant multiple;' : 
  settings.hostMode === 'single-host' ? '                    supplicant single;' : 
  settings.hostMode === 'multi-auth' || settings.hostMode === 'multi-domain' ? '                    supplicant multiple;' : 
  '                    supplicant multiple;'}
                    retries ${settings.maxReauth};
                    quiet-period ${settings.quietPeriod};
                    transmit-period ${settings.txPeriod};
                    mac-radius {
                        restrict;
                    }
                    server-timeout 30;
                    supplicant-timeout 30;
                    reauthentication ${settings.reauthPeriod};
${settings.vlanGuest ? `                    guest-vlan ${settings.vlanGuest};` : ''}
${settings.vlanUnauth ? `                    server-fail vlan-name ${settings.vlanUnauth};` : ''}
${settings.vlanUnauth ? `                    server-reject-vlan ${settings.vlanUnauth};` : ''}
                }` : ''}
            }
        }
    }
}

vlans {
${settings.vlanAuth ? `    auth-vlan {
        vlan-id ${settings.vlanAuth};
    }` : ''}
${settings.vlanUnauth ? `    unauth-vlan {
        vlan-id ${settings.vlanUnauth};
    }` : ''}
${settings.vlanGuest ? `    guest-vlan {
        vlan-id ${settings.vlanGuest};
    }` : ''}
${settings.vlanVoice ? `    voice-vlan {
        vlan-id ${settings.vlanVoice};
    }` : ''}
${settings.vlanCritical ? `    critical-vlan {
        vlan-id ${settings.vlanCritical};
    }` : ''}
}

# Interface Configuration
interfaces {
    ${settings.interface || 'ge-0/0/0'} {
        unit 0 {
            family ethernet-switching {
                interface-mode access;
                vlan {
                    members ${settings.vlanAuth ? 'auth-vlan' : 'default'};
                }
${settings.vlanVoice ? `                voip {
                    vlan ${settings.vlanVoice};
                }` : ''}
            }
        }
    }
}

${settings.enableDhcpSnooping ? `# DHCP Snooping Configuration
forwarding-options {
    dhcp-security {
        group dot1x-interfaces {
            interface ${settings.interface || 'ge-0/0/0'};
${settings.interfaceRange ? `            interface ${settings.interfaceRange};` : ''}
        }
        option-82 {
            circuit-id prefix hostname;
        }
    }
}
` : ''}

# Show commands for verification
# run show dot1x interface
# run show dot1x interface detail
# run show ethernet-switching interfaces`;

        default:
            return `# Juniper ${platform} 802.1X Configuration
# Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
#
# Note: Specific configuration syntax for ${platform} is not available.
# Please refer to Juniper documentation for exact configuration syntax.
#
# General parameters that would be configured:
# - RADIUS server: ${settings.radiusServer || 'Not specified'}
# - Authentication method: ${settings.authMethod}
# - Authentication VLAN: ${settings.vlanAuth || 'Not specified'}
# - Authentication mode: ${settings.authMode}
# - Host mode: ${settings.hostMode}`;
    }
}

// HP configuration generator
function generateHpConfig(platform, settings) {
    switch (platform) {
        case 'procurve':
            return `! HP ProCurve 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! RADIUS Authentication Configuration
radius-server host ${settings.radiusServer || '10.1.1.1'} key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? `radius-server host ${settings.secondaryServer} key ${settings.secondaryKey || 'radiuskey'}` : ''}

radius-server timeout 5
radius-server retransmit 3
radius-server dead-time 15

! AAA Configuration
aaa authentication port-access eap-radius
aaa authentication dot1x default radius local
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? 'aaa authentication mac-auth default radius local' : ''}
aaa authorization network default radius
${settings.enableAccounting ? 'aaa accounting network start-stop radius' : ''}

! 802.1X Global Configuration
aaa port-access authenticator active
aaa port-access authenticator reauth-period ${settings.reauthPeriod}
aaa port-access authenticator quiet-period ${settings.quietPeriod}
aaa port-access authenticator tx-period ${settings.txPeriod}
aaa port-access authenticator max-requests ${settings.maxReauth}
aaa port-access authenticator max-retries 3

! MAC Address Format for MAB
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? 'aaa port-access mac-auth addr-format no-delimiter\naaa port-access mac-auth addr-format uppercase' : ''}

! User Role Configuration
aaa authorization user-role name "Authenticated"
 vlan-id ${settings.vlanAuth || '1'}

${settings.vlanUnauth ? `aaa authorization user-role name "Unauthenticated"
 vlan-id ${settings.vlanUnauth}
` : ''}

${settings.vlanVoice ? `aaa authorization user-role name "VoIP"
 vlan-id ${settings.vlanVoice}
` : ''}

! Interface Configuration
interface ${settings.interface || '1/1'}
 no routing
 aaa port-access authenticator active
 aaa port-access authenticator reauth-period ${settings.reauthPeriod}
 aaa port-access authenticator quiet-period ${settings.quietPeriod}
 aaa port-access authenticator tx-period ${settings.txPeriod}
 aaa port-access authenticator max-requests ${settings.maxReauth}
 aaa port-access authenticator max-retries 3
 aaa port-access authenticator client-limit 1
${settings.vlanUnauth ? ` aaa port-access authenticator unauth-vid ${settings.vlanUnauth}` : ''}
${settings.vlanAuth ? ` aaa port-access authenticator auth-vid ${settings.vlanAuth}` : ''}
 aaa port-access authenticator logoff-period 300
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' aaa port-access mac-auth' : ''}
${settings.vlanVoice ? ` voice-vlan ${settings.vlanVoice}` : ''}
 spanning-tree bpdu-protection
 spanning-tree admin-edge-port

${settings.interfaceRange ? `! Interface Range Configuration
interface range ${settings.interfaceRange}
 no routing
 aaa port-access authenticator active
 aaa port-access authenticator reauth-period ${settings.reauthPeriod}
 aaa port-access authenticator quiet-period ${settings.quietPeriod}
 aaa port-access authenticator tx-period ${settings.txPeriod}
 aaa port-access authenticator max-requests ${settings.maxReauth}
 aaa port-access authenticator max-retries 3
 aaa port-access authenticator client-limit 1
${settings.vlanUnauth ? ` aaa port-access authenticator unauth-vid ${settings.vlanUnauth}` : ''}
${settings.vlanAuth ? ` aaa port-access authenticator auth-vid ${settings.vlanAuth}` : ''}
 aaa port-access authenticator logoff-period 300
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' aaa port-access mac-auth' : ''}
${settings.vlanVoice ? ` voice-vlan ${settings.vlanVoice}` : ''}
 spanning-tree bpdu-protection
 spanning-tree admin-edge-port
` : ''}

${settings.enableDhcpSnooping ? `! DHCP Snooping Configuration
dhcp-snooping
dhcp-snooping vlan ${settings.vlanAuth || '1'} ${settings.vlanUnauth ? settings.vlanUnauth : ''} ${settings.vlanGuest ? settings.vlanGuest : ''}
` : ''}

! Show commands for verification
! show port-access authenticator
! show port-access authenticator ${settings.interface || '1/1'}
! show port-access clients`;

        case 'comware':
            return `# HP Comware 802.1X Configuration
# Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
#
# RADIUS and AAA Configuration
radius scheme radius-scheme
 primary authentication ${settings.radiusServer || '10.1.1.1'} 1812
 primary accounting ${settings.radiusServer || '10.1.1.1'} 1813
 key authentication cipher ${settings.radiusKey || 'radiuskey'}
 key accounting cipher ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? ` secondary authentication ${settings.secondaryServer} 1812
 secondary accounting ${settings.secondaryServer} 1813` : ''}
 user-name-format without-domain

domain dot1x-domain
 authentication default radius-scheme radius-scheme
 authorization default radius-scheme radius-scheme
 accounting default radius-scheme radius-scheme

domain default enable dot1x-domain

# 802.1X Global Configuration
dot1x authentication-method eap
dot1x timer quiet ${settings.quietPeriod}
dot1x timer tx-period ${settings.txPeriod}
dot1x timer reauth-period ${settings.reauthPeriod}
dot1x timer handshake 15
dot1x retry 2
dot1x max-user ${settings.hostMode === 'single-host' ? '1' : settings.hostMode === 'multi-host' ? '32' : '256'}

# MAC Authentication Configuration
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? `mac-authentication domain dot1x-domain
mac-authentication user-name-format mac-address with-hyphen uppercase` : ''}

# Interface Configuration
interface ${settings.interface || 'GigabitEthernet1/0/1'}
 port link-type access
 port access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ` voice vlan ${settings.vlanVoice}` : ''}
 dot1x port-method ${settings.authMode === 'open' ? 'macbased' : 'portbased'}
 dot1x port-control auto
 dot1x max-user ${settings.hostMode === 'single-host' ? '1' : settings.hostMode === 'multi-host' ? '32' : '256'}
 dot1x re-authenticate
 dot1x re-authentication timer ${settings.reauthPeriod}
 dot1x retry 2
${settings.vlanGuest ? ` dot1x guest-vlan ${settings.vlanGuest}` : ''}
${settings.vlanUnauth ? ` dot1x auth-fail vlan ${settings.vlanUnauth}` : ''}
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' mac-authentication' : ''}
 stp edged-port enable
 port-security enable
${settings.authMode === 'open' ? ' port-security port-mode autolearn' : ''}

${settings.interfaceRange ? `# Interface Range Configuration
interface range ${settings.interfaceRange}
 port link-type access
 port access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ` voice vlan ${settings.vlanVoice}` : ''}
 dot1x port-method ${settings.authMode === 'open' ? 'macbased' : 'portbased'}
 dot1x port-control auto
 dot1x max-user ${settings.hostMode === 'single-host' ? '1' : settings.hostMode === 'multi-host' ? '32' : '256'}
 dot1x re-authenticate
 dot1x re-authentication timer ${settings.reauthPeriod}
 dot1x retry 2
${settings.vlanGuest ? ` dot1x guest-vlan ${settings.vlanGuest}` : ''}
${settings.vlanUnauth ? ` dot1x auth-fail vlan ${settings.vlanUnauth}` : ''}
${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? ' mac-authentication' : ''}
 stp edged-port enable
 port-security enable
${settings.authMode === 'open' ? ' port-security port-mode autolearn' : ''}
` : ''}

${settings.enableDhcpSnooping ? `# DHCP Snooping Configuration
dhcp-snooping enable
dhcp-snooping vlan ${settings.vlanAuth || '1'} ${settings.vlanUnauth ? settings.vlanUnauth : ''} ${settings.vlanGuest ? settings.vlanGuest : ''}
` : ''}

# Show commands for verification
# display dot1x
# display dot1x interface ${settings.interface || 'GigabitEthernet1/0/1'}
# display mac-authentication`;

        default:
            return `! HP ${platform} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
!
! Note: Specific configuration syntax for ${platform} is not available.
! Please refer to HP documentation for exact configuration syntax.
!
! General parameters that would be configured:
! - RADIUS server: ${settings.radiusServer || 'Not specified'}
! - Authentication method: ${settings.authMethod}
! - Authentication VLAN: ${settings.vlanAuth || 'Not specified'}
! - Authentication mode: ${settings.authMode}
! - Host mode: ${settings.hostMode}`;
    }
}

// Generate configurations for other vendors...

// Add the remaining vendor configuration generators here
// For brevity, I'm showing only a few, but the complete implementation would include all vendors

// Generic configuration generator as fallback
function generateGenericConfig(vendor, platform, settings) {
    return `# ${vendor.toUpperCase()} ${platform.toUpperCase()} 802.1X Configuration
# Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
#
# Note: Specific configuration syntax for ${vendor} ${platform} is not available.
# Please refer to vendor documentation for exact configuration syntax.
#
# Configuration Parameters:
# - RADIUS Server: ${settings.radiusServer || 'Not specified'}
# - Secondary RADIUS: ${settings.secondaryServer || 'Not specified'}
# - Authentication Method: ${settings.authMethod}
# - Authentication Mode: ${settings.authMode}
# - Host Mode: ${settings.hostMode}
# - Authentication VLAN: ${settings.vlanAuth || 'Not specified'}
# - Unauthenticated VLAN: ${settings.vlanUnauth || 'Not specified'}
# - Guest VLAN: ${settings.vlanGuest || 'Not specified'}
# - Voice VLAN: ${settings.vlanVoice || 'Not specified'}
# - Interface: ${settings.interface || 'Not specified'}
# - Reauthentication Period: ${settings.reauthPeriod} seconds
# - Transmit Period: ${settings.txPeriod} seconds
# - Quiet Period: ${settings.quietPeriod} seconds
# - Max Retries: ${settings.maxReauth}
# 
# Additional Features:
# - RADIUS CoA: ${settings.useCoa ? 'Enabled' : 'Disabled'}
# - RADIUS Accounting: ${settings.enableAccounting ? 'Enabled' : 'Disabled'}
# - MACsec: ${settings.useMacsec ? 'Enabled' : 'Disabled'}
# - RadSec: ${settings.useRadsec ? 'Enabled' : 'Disabled'}
# - DHCP Snooping: ${settings.enableDhcpSnooping ? 'Enabled' : 'Disabled'}
# - Dynamic ARP Inspection: ${settings.enableDai ? 'Enabled' : 'Disabled'}
# - IP Source Guard: ${settings.enableIpsg ? 'Enabled' : 'Disabled'}`;
}
