/**
 * Dot1Xer Supreme Enterprise Edition - Vendor Functionality
 * Version 4.1.0
 * 
 * This module handles vendor-specific functionality, including:
 * - Vendor selection and display
 * - Platform selection based on vendor
 * - Vendor-specific configuration templates
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Vendor functionality...');
    
    // Initialize vendor grid
    initVendorGrid();
    
    // Set up change listeners
    setupVendorChangeListeners();
});

// List of supported vendors with their platforms
const vendors = {
    cisco: {
        name: "Cisco",
        logo: "assets/logos/cisco-logo.svg",
        platforms: [
            { value: "ios", name: "IOS" },
            { value: "ios-xe", name: "IOS-XE" },
            { value: "nx-os", name: "NX-OS" },
            { value: "catalyst", name: "Catalyst OS" }
        ]
    },
    aruba: {
        name: "Aruba",
        logo: "assets/logos/aruba-logo.svg",
        platforms: [
            { value: "aos-cx", name: "AOS-CX" },
            { value: "aos-switch", name: "AOS-Switch" },
            { value: "clearpass", name: "ClearPass" }
        ]
    },
    juniper: {
        name: "Juniper",
        logo: "assets/logos/juniper-logo.svg",
        platforms: [
            { value: "junos", name: "JunOS" },
            { value: "ex-series", name: "EX Series" },
            { value: "srx-series", name: "SRX Series" }
        ]
    },
    hp: {
        name: "HP",
        logo: "assets/logos/hp-logo.svg",
        platforms: [
            { value: "procurve", name: "ProCurve" },
            { value: "comware", name: "Comware" }
        ]
    },
    extreme: {
        name: "Extreme",
        logo: "assets/logos/extreme-logo.svg",
        platforms: [
            { value: "exos", name: "EXOS" },
            { value: "voss", name: "VOSS" }
        ]
    },
    fortinet: {
        name: "Fortinet",
        logo: "assets/logos/fortinet-logo.svg",
        platforms: [
            { value: "fortiswitch", name: "FortiSwitch" },
            { value: "fortigate", name: "FortiGate" },
            { value: "fortinac", name: "FortiNAC" }
        ]
    },
    dell: {
        name: "Dell",
        logo: "assets/logos/dell-logo.svg",
        platforms: [
            { value: "os10", name: "OS10" },
            { value: "os9", name: "OS9" }
        ]
    },
    huawei: {
        name: "Huawei",
        logo: "assets/logos/huawei-logo.svg",
        platforms: [
            { value: "vrp", name: "VRP" },
            { value: "s-series", name: "S-Series" }
        ]
    },
    ruckus: {
        name: "Ruckus",
        logo: "assets/logos/ruckus-logo.svg",
        platforms: [
            { value: "icx", name: "ICX" },
            { value: "fastiron", name: "FastIron" },
            { value: "smartzone", name: "SmartZone" }
        ]
    },
    paloalto: {
        name: "Palo Alto",
        logo: "assets/logos/paloalto-logo.svg",
        platforms: [
            { value: "panos", name: "PAN-OS" }
        ]
    },
    checkpoint: {
        name: "CheckPoint",
        logo: "assets/logos/checkpoint-logo.svg",
        platforms: [
            { value: "gaia", name: "Gaia" }
        ]
    },
    alcatel: {
        name: "Alcatel-Lucent",
        logo: "assets/logos/alcatel-logo.svg",
        platforms: [
            { value: "aos", name: "AOS" }
        ]
    },
    meraki: {
        name: "Meraki",
        logo: "assets/logos/meraki-logo.svg",
        platforms: [
            { value: "meraki-ms", name: "Meraki MS Switch" }
        ]
    },
    arista: {
        name: "Arista",
        logo: "assets/logos/arista-logo.svg",
        platforms: [
            { value: "eos", name: "EOS" }
        ]
    },
    ubiquiti: {
        name: "Ubiquiti",
        logo: "assets/logos/ubiquiti-logo.svg",
        platforms: [
            { value: "unifi", name: "UniFi" },
            { value: "edgeswitch", name: "EdgeSwitch" }
        ]
    }
};

// Initialize vendor grid
function initVendorGrid() {
    const vendorGrid = document.getElementById('vendor-grid');
    if (!vendorGrid) return;
    
    // Clear existing content
    vendorGrid.innerHTML = '';
    
    // Add vendor logo containers
    Object.keys(vendors).forEach(vendorId => {
        const vendor = vendors[vendorId];
        
        // Create vendor logo container
        const vendorContainer = document.createElement('div');
        vendorContainer.className = 'vendor-logo-container';
        vendorContainer.setAttribute('data-vendor', vendorId);
        
        // Create vendor logo
        const vendorLogo = document.createElement('img');
        vendorLogo.className = 'vendor-logo';
        vendorLogo.src = vendor.logo;
        vendorLogo.alt = vendor.name;
        vendorLogo.onerror = function() {
            // Fallback if logo loading fails
            this.onerror = null;
            this.src = createFallbackLogo(vendor.name);
        };
        
        // Create vendor name
        const vendorName = document.createElement('div');
        vendorName.className = 'vendor-name';
        vendorName.textContent = vendor.name;
        
        // Add to container
        vendorContainer.appendChild(vendorLogo);
        vendorContainer.appendChild(vendorName);
        
        // Add click handler
        vendorContainer.addEventListener('click', () => {
            selectVendor(vendorId);
        });
        
        // Add to grid
        vendorGrid.appendChild(vendorContainer);
    });
    
    // Check for default vendor
    const defaultVendor = localStorage.getItem('default_vendor');
    if (defaultVendor && vendors[defaultVendor]) {
        selectVendor(defaultVendor);
    }
}

// Create fallback logo as data URL
function createFallbackLogo(vendorName) {
    const canvas = document.createElement('canvas');
    canvas.width = 120;
    canvas.height = 60;
    const ctx = canvas.getContext('2d');
    
    // Draw background
    ctx.fillStyle = '#f8f8f8';
    ctx.fillRect(0, 0, 120, 60);
    
    // Draw text
    ctx.fillStyle = '#0077cc';
    ctx.font = 'bold 14px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(vendorName.toUpperCase(), 60, 30);
    
    return canvas.toDataURL();
}

// Select a vendor
function selectVendor(vendorId) {
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    
    // Remove selected class from all vendors
    vendorContainers.forEach(container => {
        container.classList.remove('selected');
    });
    
    // Add selected class to clicked vendor
    const selectedContainer = document.querySelector(`.vendor-logo-container[data-vendor="${vendorId}"]`);
    if (selectedContainer) {
        selectedContainer.classList.add('selected');
    }
    
    // Update platform dropdown
    updatePlatformOptions(vendorId);
    
    // Trigger change event
    const event = new CustomEvent('vendorChange', { detail: { vendor: vendorId } });
    document.dispatchEvent(event);
}

// Update platform dropdown based on selected vendor
function updatePlatformOptions(vendorId) {
    const platformSelect = document.getElementById('platform-select');
    if (!platformSelect) return;
    
    // Clear existing options
    platformSelect.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = '-- Select Platform --';
    platformSelect.appendChild(defaultOption);
    
    // If no vendor selected, return
    if (!vendorId || !vendors[vendorId]) return;
    
    // Add platform options for selected vendor
    vendors[vendorId].platforms.forEach(platform => {
        const option = document.createElement('option');
        option.value = platform.value;
        option.textContent = platform.name;
        platformSelect.appendChild(option);
    });
}

// Setup vendor change listeners
function setupVendorChangeListeners() {
    // Listen for vendor change events
    document.addEventListener('vendorChange', function(e) {
        const vendorId = e.detail.vendor;
        console.log('Vendor changed to:', vendorId);
        
        // Perform any other vendor-specific actions here
    });
    
    // Listen for platform changes
    const platformSelect = document.getElementById('platform-select');
    if (platformSelect) {
        platformSelect.addEventListener('change', function() {
            const selectedVendor = getSelectedVendor();
            const selectedPlatform = this.value;
            
            if (selectedVendor && selectedPlatform) {
                console.log('Platform changed to:', selectedPlatform);
                
                // Perform any platform-specific actions here
            }
        });
    }
}

// Get the currently selected vendor
function getSelectedVendor() {
    const selectedContainer = document.querySelector('.vendor-logo-container.selected');
    return selectedContainer ? selectedContainer.getAttribute('data-vendor') : null;
}

// Generate vendor-specific configuration
function generateVendorConfig(vendorId, platform, settings) {
    console.log(`Generating configuration for ${vendorId} ${platform}`);
    
    // Check if vendor and platform are valid
    if (!vendorId || !platform) {
        return '# Please select a vendor and platform first.';
    }
    
    // Get vendor-specific generator function
    const generatorFunction = vendorConfigGenerators[vendorId] && vendorConfigGenerators[vendorId][platform];
    
    if (generatorFunction && typeof generatorFunction === 'function') {
        return generatorFunction(settings);
    } else if (vendorConfigGenerators[vendorId] && vendorConfigGenerators[vendorId]['default']) {
        // Use default generator for this vendor if platform-specific one doesn't exist
        return vendorConfigGenerators[vendorId]['default'](platform, settings);
    } else {
        // Use generic template
        return generateGenericConfig(vendorId, platform, settings);
    }
}

// Generate generic configuration
function generateGenericConfig(vendorId, platform, settings) {
    const vendor = vendors[vendorId];
    const vendorName = vendor ? vendor.name : vendorId.toUpperCase();
    
    return `! ${vendorName} ${platform.toUpperCase()} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
! Note: This is a generic template. For vendor-specific optimizations, update vendorConfigGenerators.
!
! ===================== AUTHENTICATION CONFIGURATION =====================
!
${settings.authMethod === 'dot1x' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' || settings.authMethod === 'dot1x-mab-webauth' ? 
`! Configure 802.1X globally
aaa authentication dot1x default group radius
aaa authorization network default group radius
dot1x system-auth-control` : ''}

${settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' || settings.authMethod === 'dot1x-mab-webauth' ? 
`! Configure MAC Authentication Bypass
mac-authentication bypass
aaa authentication mac-auth default group radius` : ''}

! Configure RADIUS servers
radius server ${settings.radiusServer || 'PRIMARY-RADIUS'}
 address ipv4 ${settings.radiusServer || '10.1.1.100'} auth-port ${settings.radiusAuthPort || '1812'} acct-port ${settings.radiusAcctPort || '1813'}
 key ${settings.radiusKey || 'radiuskey'}
 timeout ${settings.radiusTimeout || '5'}
 retransmit ${settings.radiusRetransmit || '3'}
${settings.radiusNasId ? ` nas-id ${settings.radiusNasId}` : ''}

${settings.secondaryServer ? 
`radius server ${settings.secondaryServer}
 address ipv4 ${settings.secondaryServer} auth-port ${settings.secondaryAuthPort || '1812'} acct-port ${settings.secondaryAcctPort || '1813'}
 key ${settings.secondaryKey || 'radiuskey'}
 timeout ${settings.radiusTimeout || '5'}
 retransmit ${settings.radiusRetransmit || '3'}` : ''}

${settings.tertiaryServer ? 
`radius server ${settings.tertiaryServer}
 address ipv4 ${settings.tertiaryServer} auth-port ${settings.tertiaryAuthPort || '1812'} acct-port ${settings.tertiaryAcctPort || '1813'}
 key ${settings.tertiaryKey || 'radiuskey'}
 timeout ${settings.radiusTimeout || '5'}
 retransmit ${settings.radiusRetransmit || '3'}` : ''}

! Configure AAA for 802.1X
aaa group server radius dot1x-radios
 server ${settings.radiusServer || 'PRIMARY-RADIUS'}
${settings.secondaryServer ? ` server ${settings.secondaryServer}` : ''}
${settings.tertiaryServer ? ` server ${settings.tertiaryServer}` : ''}
 deadtime ${settings.radiusDeadtime || '15'}

${settings.enableAccounting ? 
`! Configure RADIUS accounting
aaa accounting dot1x default start-stop group radius
${settings.accountingUpdate ? `accounting update periodic ${settings.accountingUpdate}` : ''}` : ''}

${settings.useCoa ? 
`! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client ${settings.radiusServer} server-key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? ` client ${settings.secondaryServer} server-key ${settings.secondaryKey || 'radiuskey'}` : ''}
${settings.tertiaryServer ? ` client ${settings.tertiaryServer} server-key ${settings.tertiaryKey || 'radiuskey'}` : ''}
 port ${settings.coaPort || '1700'}` : ''}

!
! ===================== INTERFACE CONFIGURATION =====================
!
${settings.interface ? 
`! Configure interface ${settings.interface}
interface ${settings.interface}
 description 802.1X Authenticated Port
${settings.interfaceAdminShutdown ? ' shutdown' : ' no shutdown'}
${settings.interfaceMtu ? ` mtu ${settings.interfaceMtu}` : ''}
${settings.vlanAuth ? ` switchport access vlan ${settings.vlanAuth}` : ''}
${settings.vlanVoice ? ` switchport voice vlan ${settings.vlanVoice}` : ''}
 switchport mode access
 
 ! Authentication settings
 dot1x pae authenticator
 authentication port-control ${settings.authMode === 'open' ? 'auto' : 'force-authorized'}
 authentication host-mode ${settings.hostMode}
 authentication violation restrict
 
${settings.authMethod === 'dot1x' ? 
` ! 802.1X only
 authentication order dot1x
 authentication priority dot1x` : ''}
 
${settings.authMethod === 'mab' ? 
` ! MAB only
 authentication order mab
 authentication priority mab
 mab` : ''}
 
${settings.authMethod === 'dot1x-mab' ? 
` ! 802.1X with MAB fallback
 authentication order dot1x mab
 authentication priority dot1x mab
 mab` : ''}
 
${settings.authMethod === 'concurrent' ? 
` ! 802.1X and MAB concurrent
 authentication order dot1x mab
 authentication priority dot1x mab
 authentication event fail action next-method
 mab` : ''}
 
${settings.authMethod === 'dot1x-mab-webauth' ? 
` ! 802.1X + MAB + WebAuth
 authentication order dot1x mab webauth
 authentication priority dot1x mab
 authentication event fail action next-method
 mab
 web-auth` : ''}
 
 ! Authentication timing
 dot1x timeout quiet-period ${settings.quietPeriod || '60'}
 dot1x timeout tx-period ${settings.txPeriod || '30'}
 dot1x timeout re-authperiod ${settings.reauthPeriod || '3600'}
 dot1x max-req ${settings.maxReauth || '2'}
${settings.vlanGuest ? ` dot1x guest-vlan ${settings.vlanGuest}` : ''}
${settings.vlanUnauth ? ` dot1x auth-fail vlan ${settings.vlanUnauth}` : ''}
${settings.vlanCritical ? ` dot1x critical vlan ${settings.vlanCritical}` : ''}
 
${settings.enableDynamicVlan ? ' dot1x dynamic-vlan enable' : ''}
 
${settings.interfacePortfast ? 
` ! Port security features
 spanning-tree portfast
${settings.interfaceBpduGuard ? ' spanning-tree bpduguard enable' : ''}` : ''}
 
${settings.enablePortSecurity ? 
` ! Port security
 switchport port-security
 switchport port-security maximum ${settings.portSecurityMaxMac || '1'}
 switchport port-security violation ${settings.portSecurityViolation || 'shutdown'}` : ''}
` : ''}

${settings.interfaceRange ? 
`! Apply same configuration to range ${settings.interfaceRange}
interface range ${settings.interfaceRange}
 description 802.1X Authenticated Ports
 ! Same configuration as above would be applied to this range
` : ''}

!
! ===================== SECURITY FEATURES =====================
!
${settings.enableDhcpSnooping ? 
`! Configure DHCP Snooping
ip dhcp snooping
ip dhcp snooping vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}
${settings.dhcpOption82 ? 'ip dhcp snooping information option' : ''}
ip dhcp snooping rate-limit ${settings.dhcpRateLimit || '20'}` : ''}

${settings.enableDai ? 
`! Configure Dynamic ARP Inspection
ip arp inspection vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? `,${settings.vlanGuest}` : ''}${settings.vlanUnauth ? `,${settings.vlanUnauth}` : ''}
${settings.daiValidateSrcMac ? 'ip arp inspection validate src-mac' : ''}
${settings.daiValidateDstMac ? 'ip arp inspection validate dst-mac' : ''}
${settings.daiValidateIp ? 'ip arp inspection validate ip' : ''}` : ''}

${settings.enableIpsg ? 
`! Configure IP Source Guard
ip source binding
${settings.enableDhcpSnooping ? 'ip verify source dhcp-snooping-binding' : 'ip verify source'}` : ''}

${settings.enableStormControl ? 
`! Configure Storm Control
interface ${settings.interface}
 storm-control broadcast level ${settings.stormControlBroadcast || '20'}
 storm-control multicast level ${settings.stormControlMulticast || '30'}
 storm-control unicast level ${settings.stormControlUnicast || '50'}` : ''}

${settings.useMacsec ? 
`! Configure MACsec
interface ${settings.interface}
 macsec
 macsec policy ${settings.macsecPolicy || 'should-secure'}
 macsec cipher-suite ${settings.macsecCipher || 'gcm-aes-256'}
${settings.macsecIncludeSci ? ' macsec include-sci' : ' no macsec include-sci'}
${settings.macsecReplayProtection ? ` macsec replay-protection window-size ${settings.macsecReplayWindow || '0'}` : ' no macsec replay-protection'}` : ''}

${settings.enableDeviceTracking ? 
`! Configure Device Tracking
device-tracking policy DEVICE-TRACK-POLICY
 tracking enable
${settings.deviceTrackingIpv6 ? ' tracking ipv6 enable' : ''}
 tracking interval ${settings.deviceTrackingInterval || '30'}
 device-role host
interface ${settings.interface}
 device-tracking attach-policy DEVICE-TRACK-POLICY` : ''}

${settings.enableAcl ? 
`! Configure Access Control Lists
${settings.aclNameAuth ? 
`ip access-list extended ${settings.aclNameAuth}
 permit ip any any
interface ${settings.interface}
 ip access-group ${settings.aclNameAuth} in` : ''}

${settings.aclNameUnauth ? 
`ip access-list extended ${settings.aclNameUnauth}
 deny ip any any
 permit udp any any eq bootps
 permit udp any any eq bootpc
 permit udp any any eq domain
 permit tcp any any eq domain
 permit icmp any any echo-reply
 permit icmp any any time-exceeded
 permit icmp any any unreachable
interface ${settings.interface}
 authentication event fail action apply acl ${settings.aclNameUnauth}` : ''}` : ''}

!
! ===================== ADDITIONAL COMMANDS =====================
!
${settings.enableAaaLogging ? 
`! Enable AAA logging
logging trap notifications
logging origin-id hostname
logging host ${settings.radiusServer}` : ''}

${settings.additionalCommands ? settings.additionalCommands : '! No additional commands specified'}

! End of configuration
`;
}

// Vendor-specific configuration generators
const vendorConfigGenerators = {
    cisco: {
        'ios': function(settings) {
            return `! Cisco IOS 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
!
! ================== GLOBAL CONFIGURATION ==================
!
aaa new-model
!
aaa authentication dot1x default group radius
aaa authorization network default group radius
${settings.enableAccounting ? 'aaa accounting dot1x default start-stop group radius' : ''}
!
${settings.authMethod !== 'mab' ? 'dot1x system-auth-control' : ''}
!
radius server ${settings.radiusServer || 'RADIUS1'}
 address ipv4 ${settings.radiusServer || '10.1.1.100'} auth-port ${settings.radiusAuthPort || '1812'} acct-port ${settings.radiusAcctPort || '1813'}
 key ${settings.radiusKey || 'radiuskey'}
 timeout ${settings.radiusTimeout || '5'}
 retransmit ${settings.radiusRetransmit || '3'}
${settings.radiusNasId ? ' nas-id ' + settings.radiusNasId : ''}
!
${settings.secondaryServer ? 
`radius server ${settings.secondaryServer}
 address ipv4 ${settings.secondaryServer} auth-port ${settings.secondaryAuthPort || '1812'} acct-port ${settings.secondaryAcctPort || '1813'}
 key ${settings.secondaryKey || 'radiuskey'}
 timeout ${settings.radiusTimeout || '5'}
 retransmit ${settings.radiusRetransmit || '3'}
!` : ''}
!
radius-server dead-criteria time ${settings.radiusDeadtime || '15'} tries 3
!
${settings.useCoa ? 
`aaa server radius dynamic-author
 client ${settings.radiusServer} server-key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? ' client ' + settings.secondaryServer + ' server-key ' + (settings.secondaryKey || 'radiuskey') : ''}
 port ${settings.coaPort || '1700'}
 auth-type all
!` : ''}
!
${settings.enableDhcpSnooping ? 
`ip dhcp snooping
ip dhcp snooping vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? ',' + settings.vlanGuest : ''}${settings.vlanUnauth ? ',' + settings.vlanUnauth : ''}
${settings.dhcpOption82 ? 'ip dhcp snooping information option' : ''}
!` : ''}
!
${settings.enableDai ? 
`ip arp inspection vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? ',' + settings.vlanGuest : ''}${settings.vlanUnauth ? ',' + settings.vlanUnauth : ''}
${settings.daiValidateSrcMac ? 'ip arp inspection validate src-mac' : ''}${settings.daiValidateDstMac ? ' dst-mac' : ''}${settings.daiValidateIp ? ' ip' : ''}
!` : ''}
!
! ================== INTERFACE CONFIGURATION ==================
!
interface ${settings.interface || 'GigabitEthernet1/0/1'}
 description 802.1X Authenticated Port
${settings.interfaceAdminShutdown ? ' shutdown' : ' no shutdown'}
${settings.interfaceMtu ? ' mtu ' + settings.interfaceMtu : ''}
 switchport access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ' switchport voice vlan ' + settings.vlanVoice : ''}
 switchport mode access
!
 ! Authentication settings
 authentication port-control ${settings.authMode === 'open' ? 'auto' : 'force-authorized'}
 authentication host-mode ${settings.hostMode}
 authentication violation restrict
!
${settings.authMethod === 'dot1x' ? 
` ! 802.1X only
 authentication order dot1x
 authentication priority dot1x` : ''}
!
${settings.authMethod === 'mab' ? 
` ! MAB only
 authentication order mab
 authentication priority mab
 mab` : ''}
!
${settings.authMethod === 'dot1x-mab' ? 
` ! 802.1X with MAB fallback
 authentication order dot1x mab
 authentication priority dot1x mab
 mab` : ''}
!
${settings.authMethod === 'concurrent' ? 
` ! 802.1X and MAB concurrent
 authentication order dot1x mab
 authentication priority dot1x mab
 authentication event fail action next-method
 mab` : ''}
!
${settings.authMethod === 'dot1x-mab-webauth' ? 
` ! 802.1X + MAB + WebAuth
 authentication order dot1x mab webauth
 authentication priority dot1x mab
 authentication event fail action next-method
 mab
 web-auth` : ''}
!
 ! Authentication timing
 authentication timer reauthenticate ${settings.reauthPeriod || '3600'}
 authentication timer restart ${settings.txPeriod || '30'}
 authentication timer quiet-period ${settings.quietPeriod || '60'}
 authentication max-attempts ${settings.maxReauth || '2'}
!
${settings.vlanGuest ? ' authentication event no-response action authorize vlan ' + settings.vlanGuest : ''}
${settings.vlanUnauth ? ' authentication event fail action authorize vlan ' + settings.vlanUnauth : ''}
${settings.vlanCritical ? ' authentication event server dead action authorize vlan ' + settings.vlanCritical : ''}
!
${settings.interfacePortfast ? 
` ! Port security features
 spanning-tree portfast
${settings.interfaceBpduGuard ? ' spanning-tree bpduguard enable' : ''}` : ''}
!
${settings.enablePortSecurity ? 
` ! Port security
 switchport port-security
 switchport port-security maximum ${settings.portSecurityMaxMac || '1'}
 switchport port-security violation ${settings.portSecurityViolation || 'shutdown'}` : ''}
!
${settings.enableIpsg ? 
` ! IP Source Guard
 ip verify source${settings.enableDhcpSnooping ? ' dhcp-snooping-binding' : ''}` : ''}
!
${settings.enableDhcpSnooping ? 
` ! DHCP Snooping
 ip dhcp snooping limit rate ${settings.dhcpRateLimit || '20'}` : ''}
!
${settings.enableStormControl ? 
` ! Storm Control
 storm-control broadcast level ${settings.stormControlBroadcast || '20.00'}
 storm-control multicast level ${settings.stormControlMulticast || '30.00'}
 storm-control unicast level ${settings.stormControlUnicast || '50.00'}` : ''}
!
${settings.enableAcl ? 
` ! Access Control
${settings.aclNameAuth ? ' ip access-group ' + settings.aclNameAuth + ' in' : ''}` : ''}
!
${settings.useMacsec ? 
` ! MACsec
 macsec
 macsec policy ${settings.macsecPolicy || 'should-secure'}
 macsec cipher-suite ${settings.macsecCipher || 'gcm-aes-256'}
${settings.macsecIncludeSci ? ' macsec include-sci' : ' no macsec include-sci'}
${settings.macsecReplayProtection ? ' macsec replay-protection window-size ' + (settings.macsecReplayWindow || '0') : ' no macsec replay-protection'}` : ''}
!
end`;
        },
        'ios-xe': function(settings) {
            // IOS-XE is similar to IOS but with some differences
            return this['ios'](settings).replace('! Cisco IOS 802.1X Configuration', '! Cisco IOS-XE 802.1X Configuration');
        },
        'nx-os': function(settings) {
            return `! Cisco NX-OS 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
!
! ================== GLOBAL CONFIGURATION ==================
!
feature dot1x
${settings.enableDhcpSnooping ? 'feature dhcp' : ''}
${settings.enableDai ? 'feature arp-inspection' : ''}
${settings.enableIpsg ? 'feature ipsg' : ''}
!
aaa authentication dot1x default group radius
${settings.enableAccounting ? 'aaa accounting dot1x default group radius' : ''}
!
radius-server host ${settings.radiusServer || '10.1.1.100'} key ${settings.radiusKey || 'radiuskey'} authentication accounting 
radius-server timeout ${settings.radiusTimeout || '5'}
radius-server retransmit ${settings.radiusRetransmit || '3'}
!
${settings.secondaryServer ? 
`radius-server host ${settings.secondaryServer} key ${settings.secondaryKey || 'radiuskey'} authentication accounting` : ''}
!
${settings.useCoa ? 
`aaa server radius dynamic-author
 client ${settings.radiusServer} vrf default security-group ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? ' client ' + settings.secondaryServer + ' vrf default security-group ' + (settings.secondaryKey || 'radiuskey') : ''}
 port ${settings.coaPort || '1700'}
!` : ''}
!
${settings.enableDhcpSnooping ? 
`ip dhcp snooping
ip dhcp snooping vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? ',' + settings.vlanGuest : ''}${settings.vlanUnauth ? ',' + settings.vlanUnauth : ''}
${settings.dhcpOption82 ? 'ip dhcp snooping information option' : ''}
!` : ''}
!
${settings.enableDai ? 
`ip arp inspection vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? ',' + settings.vlanGuest : ''}${settings.vlanUnauth ? ',' + settings.vlanUnauth : ''}
!` : ''}
!
! ================== INTERFACE CONFIGURATION ==================
!
interface ${settings.interface || 'Ethernet1/1'}
 description 802.1X Authenticated Port
${settings.interfaceAdminShutdown ? ' shutdown' : ' no shutdown'}
${settings.interfaceMtu ? ' mtu ' + settings.interfaceMtu : ''}
 switchport access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ' switchport voice vlan ' + settings.vlanVoice : ''}
 switchport mode access
!
 ! Authentication settings
 dot1x port-control ${settings.authMode === 'open' ? 'auto' : 'force-authorized'}
 dot1x host-mode ${settings.hostMode === 'multi-auth' ? 'multi-host' : 
                   settings.hostMode === 'multi-domain' ? 'multi-domain' :
                   settings.hostMode === 'single-host' ? 'single-host' : 'multi-host'}
!
${settings.authMethod === 'mab' ? 
` ! MAB configuration
 mac-authentication` : ''}
!
${settings.authMethod === 'dot1x-mab' || settings.authMethod === 'concurrent' ? 
` ! 802.1X with MAB
 dot1x mac-auth bypass` : ''}
!
 ! Authentication timing
 dot1x timeout quiet-period ${settings.quietPeriod || '60'}
 dot1x timeout tx-period ${settings.txPeriod || '30'}
 dot1x timeout re-authperiod ${settings.reauthPeriod || '3600'}
 dot1x max-req ${settings.maxReauth || '2'}
!
${settings.vlanGuest ? ' dot1x guest-vlan ' + settings.vlanGuest : ''}
${settings.vlanUnauth ? ' dot1x auth-fail vlan ' + settings.vlanUnauth : ''}
!
${settings.enablePortSecurity ? 
` ! Port security
 switchport port-security
 switchport port-security maximum ${settings.portSecurityMaxMac || '1'}
 switchport port-security violation ${settings.portSecurityViolation || 'shutdown'}` : ''}
!
${settings.enableIpsg ? 
` ! IP Source Guard
 ip verify source` : ''}
!
${settings.enableDhcpSnooping ? 
` ! DHCP Snooping
 ip dhcp snooping limit rate ${settings.dhcpRateLimit || '20'}` : ''}
!
${settings.enableStormControl ? 
` ! Storm Control
 storm-control broadcast level ${settings.stormControlBroadcast || '20.0'}
 storm-control multicast level ${settings.stormControlMulticast || '30.0'}
 storm-control unicast level ${settings.stormControlUnicast || '50.0'}` : ''}
!
end`;
        },
        'default': function(platform, settings) {
            return `! Cisco ${platform.toUpperCase()} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
! Note: This is using a default Cisco template. For platform-specific optimizations, update vendorConfigGenerators.
!
! ================== GLOBAL CONFIGURATION ==================
!
aaa new-model
!
aaa authentication dot1x default group radius
aaa authorization network default group radius
${settings.enableAccounting ? 'aaa accounting dot1x default start-stop group radius' : ''}
!
${settings.authMethod !== 'mab' ? 'dot1x system-auth-control' : ''}
!
radius server ${settings.radiusServer || 'RADIUS1'}
 address ipv4 ${settings.radiusServer || '10.1.1.100'} auth-port ${settings.radiusAuthPort || '1812'} acct-port ${settings.radiusAcctPort || '1813'}
 key ${settings.radiusKey || 'radiuskey'}
 timeout ${settings.radiusTimeout || '5'}
 retransmit ${settings.radiusRetransmit || '3'}
!
! ================== INTERFACE CONFIGURATION ==================
!
interface ${settings.interface || 'GigabitEthernet1/0/1'}
 description 802.1X Authenticated Port
${settings.interfaceAdminShutdown ? ' shutdown' : ' no shutdown'}
 switchport access vlan ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ' switchport voice vlan ' + settings.vlanVoice : ''}
 switchport mode access
!
 ! Authentication settings
 authentication port-control ${settings.authMode === 'open' ? 'auto' : 'force-authorized'}
 authentication host-mode ${settings.hostMode}
!
 ! Authentication timing
 dot1x timeout quiet-period ${settings.quietPeriod || '60'}
 dot1x timeout tx-period ${settings.txPeriod || '30'}
 dot1x timeout re-authperiod ${settings.reauthPeriod || '3600'}
 dot1x max-req ${settings.maxReauth || '2'}
!
end`;
        }
    },
    aruba: {
        'aos-cx': function(settings) {
            return `! Aruba AOS-CX 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
!
! ================== GLOBAL CONFIGURATION ==================
!
aaa authentication port-access dot1x authenticator enable
!
radius-server host ${settings.radiusServer || '10.1.1.100'} key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? 'radius-server host ' + settings.secondaryServer + ' key ' + (settings.secondaryKey || 'radiuskey') : ''}
!
aaa server-group radius "dot1x-radius"
 server ${settings.radiusServer || '10.1.1.100'}
${settings.secondaryServer ? ' server ' + settings.secondaryServer : ''}
!
aaa authentication port-access dot1x authenticator radius-server-group "dot1x-radius"
!
${settings.enableAccounting ? 
`aaa accounting port-access dot1x start-stop radius-server-group "dot1x-radius"
${settings.accountingUpdate ? 'aaa accounting update periodic ' + settings.accountingUpdate : ''}` : ''}
!
aaa authentication port-access dot1x authenticator cached-reauth ${settings.reauthPeriod || '3600'}
aaa authentication port-access dot1x authenticator tx-period ${settings.txPeriod || '30'}
aaa authentication port-access dot1x authenticator quiet-period ${settings.quietPeriod || '60'}
aaa authentication port-access dot1x authenticator max-requests ${settings.maxReauth || '2'}
!
${settings.vlanGuest ? 'aaa authentication port-access dot1x authenticator guest-vlan ' + settings.vlanGuest : ''}
${settings.vlanUnauth ? 'aaa authentication port-access dot1x authenticator auth-fail-vlan ' + settings.vlanUnauth : ''}
!
! ================== INTERFACE CONFIGURATION ==================
!
interface ${settings.interface || '1/1/1'}
 description 802.1X Authenticated Port
${settings.interfaceAdminShutdown ? ' shutdown' : ' no shutdown'}
${settings.interfaceMtu ? ' mtu ' + settings.interfaceMtu : ''}
 vlan access ${settings.vlanAuth || '1'}
${settings.vlanVoice ? ' vlan voice ' + settings.vlanVoice : ''}
!
 ! Authentication settings
 aaa authentication port-access dot1x authenticator enable
 aaa authentication port-access dot1x authenticator port-control ${settings.authMode === 'open' ? 'auto' : 'force-authorized'}
 aaa authentication port-access dot1x authenticator host-mode ${settings.hostMode === 'multi-auth' ? 'multi' : 
                                                               settings.hostMode === 'multi-domain' ? 'multi-domain' :
                                                               settings.hostMode === 'single-host' ? 'single' : 'multi'}
!
${settings.authMethod === 'mab' ? 
` ! MAB configuration
 aaa authentication port-access mac-auth enable
 no aaa authentication port-access dot1x authenticator enable` : ''}
!
${settings.authMethod === 'dot1x-mab' ? 
` ! 802.1X with MAB fallback
 aaa authentication port-access mac-auth enable
 aaa authentication port-access mac-auth radius-server-group "dot1x-radius"
 aaa authentication port-access auth-order dot1x mac-auth` : ''}
!
${settings.authMethod === 'concurrent' ? 
` ! 802.1X and MAB concurrent
 aaa authentication port-access mac-auth enable
 aaa authentication port-access mac-auth radius-server-group "dot1x-radius"
 aaa authentication port-access auth-order dot1x_mac-auth` : ''}
!
${settings.enablePortSecurity ? 
` ! Port security
 port-security
 port-security maximum ${settings.portSecurityMaxMac || '1'}
 port-security violation ${settings.portSecurityViolation === 'protect' ? 'restrict' : 
                           settings.portSecurityViolation === 'restrict' ? 'restrict' : 
                           settings.portSecurityViolation === 'shutdown' ? 'shutdown' : 'shutdown'}` : ''}
!
end`;
        },
        'aos-switch': function(settings) {
            return `! Aruba AOS-Switch 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
!
! ================== GLOBAL CONFIGURATION ==================
!
aaa authentication port-access eap-radius
!
radius-server host ${settings.radiusServer || '10.1.1.100'} key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? 'radius-server host ' + settings.secondaryServer + ' key ' + (settings.secondaryKey || 'radiuskey') : ''}
!
radius-server timeout ${settings.radiusTimeout || '5'}
radius-server retransmit ${settings.radiusRetransmit || '3'}
radius-server deadtime ${settings.radiusDeadtime || '15'}
!
aaa port-access authenticator ${settings.interface || '1'}
aaa port-access authenticator ${settings.interface || '1'} auth-vid ${settings.vlanAuth || '1'}
!
${settings.vlanUnauth ? 'aaa port-access authenticator ' + settings.interface + ' unauth-vid ' + settings.vlanUnauth : ''}
${settings.vlanGuest ? 'aaa port-access authenticator ' + settings.interface + ' guest-vid ' + settings.vlanGuest : ''}
!
aaa port-access authenticator ${settings.interface || '1'} quiet-period ${settings.quietPeriod || '60'}
aaa port-access authenticator ${settings.interface || '1'} tx-period ${settings.txPeriod || '30'}
aaa port-access authenticator ${settings.interface || '1'} reauth-period ${settings.reauthPeriod || '3600'}
aaa port-access authenticator ${settings.interface || '1'} max-requests ${settings.maxReauth || '2'}
!
aaa port-access authenticator ${settings.interface || '1'} supplicant-timeout 30
aaa port-access authenticator ${settings.interface || '1'} server-timeout 30
!
aaa port-access authenticator ${settings.interface || '1'} control ${settings.authMode === 'open' ? 'auto' : 'force-authorized'}
!
aaa port-access authenticator ${settings.interface || '1'} client-limit ${settings.hostMode === 'single-host' ? '1' : 
                                                                        settings.hostMode === 'multi-domain' ? '2' : 
                                                                        '32'}
!
${settings.authMethod === 'dot1x-mab' || settings.authMethod === 'mab' ? 
`aaa port-access mac-auth ${settings.interface || '1'}
aaa port-access mac-auth ${settings.interface || '1'} addr-format no-delimiter uppercase` : ''}
!
${settings.enablePortSecurity ? 
`port-security ${settings.interface || '1'} learn-mode static action ${settings.portSecurityViolation === 'protect' ? 'none' : 
                                                                   settings.portSecurityViolation === 'restrict' ? 'send-disable' : 
                                                                   settings.portSecurityViolation === 'shutdown' ? 'send-disable' : 'send-disable'}
port-security ${settings.interface || '1'} mac-address-limit ${settings.portSecurityMaxMac || '1'}` : ''}
!
${settings.enableDhcpSnooping ? 
`dhcp-snooping
dhcp-snooping vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? ',' + settings.vlanGuest : ''}${settings.vlanUnauth ? ',' + settings.vlanUnauth : ''}
${settings.dhcpOption82 ? 'dhcp-snooping option 82' : ''}` : ''}
!
${settings.enableDai ? 
`arp-protect
arp-protect vlan ${settings.vlanAuth || '1'}${settings.vlanGuest ? ',' + settings.vlanGuest : ''}${settings.vlanUnauth ? ',' + settings.vlanUnauth : ''}` : ''}
!
${settings.enableIpsg ? 'ip source-port-filter' : ''}
!
end`;
        },
        'default': function(platform, settings) {
            return `! Aruba ${platform.toUpperCase()} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
! Note: This is using a default Aruba template. For platform-specific optimizations, update vendorConfigGenerators.
!
! ================== GLOBAL CONFIGURATION ==================
!
aaa authentication port-access eap-radius
!
radius-server host ${settings.radiusServer || '10.1.1.100'} key ${settings.radiusKey || 'radiuskey'}
${settings.secondaryServer ? 'radius-server host ' + settings.secondaryServer + ' key ' + (settings.secondaryKey || 'radiuskey') : ''}
!
! ================== INTERFACE CONFIGURATION ==================
!
interface ${settings.interface || '1/1'}
 description 802.1X Authenticated Port
${settings.interfaceAdminShutdown ? ' shutdown' : ' no shutdown'}
 vlan access ${settings.vlanAuth || '1'}
!
 ! Authentication settings
 aaa authentication port-access dot1x
 aaa authentication port-access dot1x port-control ${settings.authMode === 'open' ? 'auto' : 'force-authorized'}
!
 ! Authentication timing
 aaa authentication port-access dot1x quiet-period ${settings.quietPeriod || '60'}
 aaa authentication port-access dot1x tx-period ${settings.txPeriod || '30'}
 aaa authentication port-access dot1x reauth-period ${settings.reauthPeriod || '3600'}
 aaa authentication port-access dot1x max-requests ${settings.maxReauth || '2'}
!
end`;
        }
    },
    juniper: {
        'junos': function(settings) {
            // JunOS configuration is in a different format
            return `# Juniper JunOS 802.1X Configuration
# Generated by Dot1Xer Supreme Enterprise Edition v4.1.0

# Authentication configuration
set system authentication-order radius
set system radius-server ${settings.radiusServer || '10.1.1.100'} port ${settings.radiusAuthPort || '1812'}
set system radius-server ${settings.radiusServer || '10.1.1.100'} accounting-port ${settings.radiusAcctPort || '1813'}
set system radius-server ${settings.radiusServer || '10.1.1.100'} secret ${settings.radiusKey || 'radiuskey'}
set system radius-server ${settings.radiusServer || '10.1.1.100'} retry ${settings.radiusRetransmit || '3'}
set system radius-server ${settings.radiusServer || '10.1.1.100'} timeout ${settings.radiusTimeout || '5'}
${settings.secondaryServer ? 
`set system radius-server ${settings.secondaryServer} port ${settings.secondaryAuthPort || '1812'}
set system radius-server ${settings.secondaryServer} accounting-port ${settings.secondaryAcctPort || '1813'}
set system radius-server ${settings.secondaryServer} secret ${settings.secondaryKey || 'radiuskey'}
set system radius-server ${settings.secondaryServer} retry ${settings.radiusRetransmit || '3'}
set system radius-server ${settings.secondaryServer} timeout ${settings.radiusTimeout || '5'}` : ''}

# Enable 802.1X globally
set protocols dot1x authenticator authentication-profile-name dot1x-auth

# Configure RADIUS profile
set access profile dot1x-auth authentication-order radius
set access profile dot1x-auth radius authentication-server ${settings.radiusServer || '10.1.1.100'}
${settings.secondaryServer ? 'set access profile dot1x-auth radius authentication-server ' + settings.secondaryServer : ''}

${settings.enableAccounting ? 
`set access profile dot1x-auth accounting order radius
set access profile dot1x-auth radius accounting-server ${settings.radiusServer || '10.1.1.100'}
${settings.secondaryServer ? 'set access profile dot1x-auth radius accounting-server ' + settings.secondaryServer : ''}` : ''}

# Interface configuration
set interfaces ${settings.interface || 'ge-0/0/1'} description "802.1X Authenticated Port"
${settings.interfaceAdminShutdown ? 'set interfaces ' + (settings.interface || 'ge-0/0/1') + ' disable' : ''}
${settings.interfaceMtu ? 'set interfaces ' + (settings.interface || 'ge-0/0/1') + ' mtu ' + settings.interfaceMtu : ''}
set interfaces ${settings.interface || 'ge-0/0/1'} unit 0 family ethernet-switching vlan members ${settings.vlanAuth || '1'}

# 802.1X authentication
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 supplicant ${settings.hostMode === 'single-host' ? 'single' : 
                                                                                          settings.hostMode === 'multi-domain' ? 'multiple' : 
                                                                                          settings.hostMode === 'multi-auth' ? 'multiple' : 'multiple'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 quiet-period ${settings.quietPeriod || '60'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 transmit-period ${settings.txPeriod || '30'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 reauthentication ${settings.reauthPeriod ? 'interval ' + settings.reauthPeriod : '3600'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 maximum-requests ${settings.maxReauth || '2'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 server-timeout 30
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 supplicant-timeout 30

${settings.authMode === 'open' ? 
'set protocols dot1x authenticator interface ' + (settings.interface || 'ge-0/0/1') + '.0 controlled-port auto' : ''}

${settings.authMethod === 'mab' ? 
`set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 mac-radius
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 mac-radius restrict` : ''}

${settings.authMethod === 'dot1x-mab' ? 
`set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 mac-radius
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 mac-radius restrict
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 eapol-block` : ''}

${settings.vlanGuest ? 
'set protocols dot1x authenticator interface ' + (settings.interface || 'ge-0/0/1') + '.0 guest-vlan ' + settings.vlanGuest : ''}

${settings.vlanUnauth ? 
'set protocols dot1x authenticator interface ' + (settings.interface || 'ge-0/0/1') + '.0 server-fail vlan-name ' + settings.vlanUnauth : ''}

${settings.interfacePortfast ? 
`set protocols rstp interface ${settings.interface || 'ge-0/0/1'} edge
${settings.interfaceBpduGuard ? 'set protocols rstp bpdu-block-on-edge interface ' + (settings.interface || 'ge-0/0/1') : ''}` : ''}

${settings.enableDhcpSnooping ? 
`set forwarding-options dhcp-security group ${settings.vlanAuth || '1'} overrides client-idle-timeout 300
set forwarding-options dhcp-security arp-inspection
set ethernet-switching-options secure-access-port vlan ${settings.vlanAuth || '1'} dhcp-snooping` : ''}

${settings.enableIpsg ? 
'set ethernet-switching-options secure-access-port vlan ' + (settings.vlanAuth || '1') + ' ip-source-guard' : ''}

${settings.enableStormControl ? 
`set interfaces ${settings.interface || 'ge-0/0/1'} unit 0 family ethernet-switching storm-control bandwidth-percentage ${settings.stormControlBroadcast || '20'}` : ''}

${settings.enablePortSecurity ? 
`set ethernet-switching-options secure-access-port interface ${settings.interface || 'ge-0/0/1'} mac-limit ${settings.portSecurityMaxMac || '1'} action ${settings.portSecurityViolation === 'protect' ? 'none' : 
                                                                                    settings.portSecurityViolation === 'restrict' ? 'drop' : 
                                                                                    settings.portSecurityViolation === 'shutdown' ? 'shutdown' : 'shutdown'}` : ''}

${settings.additionalCommands || '# No additional commands specified'}`;
        },
        'default': function(platform, settings) {
            // Default Juniper template
            return `# Juniper ${platform.toUpperCase()} 802.1X Configuration
# Generated by Dot1Xer Supreme Enterprise Edition v4.1.0
# Note: This is using a default Juniper template. For platform-specific optimizations, update vendorConfigGenerators.

# Authentication configuration
set system authentication-order radius
set system radius-server ${settings.radiusServer || '10.1.1.100'} secret ${settings.radiusKey || 'radiuskey'}

# Enable 802.1X globally
set protocols dot1x authenticator authentication-profile-name dot1x-auth

# Configure RADIUS profile
set access profile dot1x-auth authentication-order radius
set access profile dot1x-auth radius authentication-server ${settings.radiusServer || '10.1.1.100'}

# Interface configuration
set interfaces ${settings.interface || 'ge-0/0/1'} unit 0 family ethernet-switching vlan members ${settings.vlanAuth || '1'}

# 802.1X authentication
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 supplicant multiple
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 quiet-period ${settings.quietPeriod || '60'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 transmit-period ${settings.txPeriod || '30'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 reauthentication interval ${settings.reauthPeriod || '3600'}
set protocols dot1x authenticator interface ${settings.interface || 'ge-0/0/1'}.0 maximum-requests ${settings.maxReauth || '2'}`;
        }
    }
};

// Make the vendor functions available to the main script
window.generateVendorConfig = generateVendorConfig;
