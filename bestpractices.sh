#!/bin/bash

# Dot1Xer Supreme Enterprise Edition - Best Practices Integration Script
# This script adds the Best Practices module to the project and updates
# the necessary files to integrate it properly.

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directories
PROJECT_DIR="./"
JS_DIR="$PROJECT_DIR/js"
CSS_DIR="$PROJECT_DIR/css"
TEMPLATES_DIR="$PROJECT_DIR/templates"

echo -e "${BLUE}Dot1Xer Supreme Enterprise Edition - Best Practices Integration${RESET}"
echo -e "${BLUE}===========================================================${RESET}"

# Check if the project directory structure exists
if [ ! -d "$JS_DIR" ]; then
  echo -e "${RED}Error: JavaScript directory not found. Make sure you're running this script from the project root.${RESET}"
  exit 1
fi

# Create best-practices.js file
echo -e "${YELLOW}Creating best-practices.js module...${RESET}"
cat > "$JS_DIR/best-practices.js" << 'EOL'
/**
 * Dot1Xer Supreme Enterprise Edition - Best Practices Module
 * Version 1.0.0
 * 
 * This module provides best practices and recommendations for 802.1X deployments
 * across various vendors and platforms.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Best Practices Module...');
    
    // Initialize best practices UI
    initBestPracticesUI();
    
    // Set up event handlers
    setupBestPracticesEvents();
});

// Best practices data by vendor and platform
const bestPracticesData = {
    // Cisco best practices
    cisco: {
        general: {
            title: "Cisco General Best Practices",
            sections: [
                {
                    title: "Phased Deployment",
                    content: `<p>Cisco recommends a phased approach to 802.1X deployment:</p>
                    <ol>
                        <li><strong>Monitor Mode</strong>: Begin with monitor mode to identify potential issues without impacting network access.</li>
                        <li><strong>Low-Impact Mode</strong>: Configure with guest VLAN and critical VLAN for smooth transition.</li>
                        <li><strong>Closed Mode</strong>: Move to full enforcement once all devices are authenticating properly.</li>
                    </ol>
                    <p>Always keep a backup of your pre-802.1X configuration and test thoroughly in a lab environment.</p>`
                },
                {
                    title: "RADIUS Server Redundancy",
                    content: `<p>Always configure at least two RADIUS servers for redundancy:</p>
                    <ul>
                        <li>Configure appropriate deadtime (5-15 minutes recommended)</li>
                        <li>Use different timeouts for primary vs secondary servers</li>
                        <li>Consider separating authentication and accounting servers</li>
                    </ul>`
                },
                {
                    title: "Security Recommendations",
                    content: `<p>Enhance security with these additional configurations:</p>
                    <ul>
                        <li>Enable DHCP Snooping on all access switches</li>
                        <li>Configure Dynamic ARP Inspection to prevent ARP spoofing</li>
                        <li>Implement IP Source Guard to prevent IP spoofing</li>
                        <li>Use source interface for all RADIUS communication</li>
                        <li>Enable RADIUS Change of Authorization (CoA) for dynamic policy updates</li>
                    </ul>`
                }
            ],
            recommendations: [
                "Deploy with monitor mode first",
                "Use guest VLAN for non-802.1X devices",
                "Enable host mode based on device type (multi-domain for IP phones)",
                "Configure RADIUS server redundancy",
                "Enable additional security features (DHCP Snooping, DAI, IPSG)",
                "Use source interface for RADIUS traffic",
                "Standardize configuration across switches"
            ]
        },
        "ios-xe": {
            title: "Cisco IOS-XE Best Practices",
            sections: [
                {
                    title: "Authentication Configuration",
                    content: `<p>For Catalyst 9000 series and other IOS-XE devices:</p>
                    <ul>
                        <li>Use named RADIUS server groups instead of legacy configurations</li>
                        <li>Configure server dead-time of 15-30 minutes</li>
                        <li>Set appropriate retry counts (2-3 recommended)</li>
                        <li>Enable automate server testing with test username</li>
                    </ul>`
                },
                {
                    title: "Interface Configuration",
                    content: `<p>Recommended interface settings:</p>
                    <ul>
                        <li>Configure interfaces with multi-domain authentication for voice+data</li>
                        <li>Use authentication open with mab for initial deployment</li>
                        <li>Enable portfast and BPDU guard on all access ports</li>
                        <li>Set appropriate authentication timers (tx-period, quiet-period)</li>
                    </ul>`
                }
            ],
            templates: [
                {
                    name: "IOS-XE Monitor Mode",
                    description: "Initial deployment configuration with monitor mode",
                    config: `! IOS-XE Monitor Mode Configuration Template
! 802.1X Global Configuration
aaa new-model
aaa authentication dot1x default group radius
aaa authorization network default group radius
aaa accounting dot1x default start-stop group radius

dot1x system-auth-control

! RADIUS Server Configuration
radius server RADIUS-1
 address ipv4 10.1.1.1 auth-port 1812 acct-port 1813
 key SHARED-SECRET-KEY
 automate-tester username TEST-USER idle-time 60
!
radius server RADIUS-2
 address ipv4 10.1.1.2 auth-port 1812 acct-port 1813
 key SHARED-SECRET-KEY
 automate-tester username TEST-USER idle-time 60
!
radius-server dead-criteria time 15 tries 3
radius-server deadtime 15

! Interface Configuration (Monitor Mode)
interface range GigabitEthernet1/0/1-48
 switchport mode access
 switchport voice vlan 100
 dot1x pae authenticator
 dot1x control-direction both
 authentication port-control auto
 authentication open
 authentication host-mode multi-domain
 authentication periodic
 authentication timer reauthenticate 3600
 authentication timer restart 60
 authentication timer inactivity 60
 mab
 spanning-tree portfast
 spanning-tree bpduguard enable
!

! Additional Security (Optional)
ip dhcp snooping
ip dhcp snooping vlan 10,20,30
no ip dhcp snooping information option
ip arp inspection vlan 10,20,30
ip verify source`
                },
                {
                    name: "IOS-XE Closed Mode",
                    description: "Full enforcement configuration",
                    config: `! IOS-XE Closed Mode Configuration Template
! 802.1X Global Configuration
aaa new-model
aaa authentication dot1x default group radius
aaa authorization network default group radius
aaa accounting dot1x default start-stop group radius

dot1x system-auth-control

! RADIUS Server Configuration
radius server RADIUS-1
 address ipv4 10.1.1.1 auth-port 1812 acct-port 1813
 key SHARED-SECRET-KEY
 automate-tester username TEST-USER idle-time 60
!
radius server RADIUS-2
 address ipv4 10.1.1.2 auth-port 1812 acct-port 1813
 key SHARED-SECRET-KEY
 automate-tester username TEST-USER idle-time 60
!
radius-server dead-criteria time 15 tries 3
radius-server deadtime 15

! Interface Configuration (Closed Mode)
interface range GigabitEthernet1/0/1-48
 switchport mode access
 switchport voice vlan 100
 dot1x pae authenticator
 dot1x control-direction both
 authentication port-control auto
 authentication host-mode multi-domain
 authentication periodic
 authentication timer reauthenticate 3600
 authentication timer restart 60
 authentication timer inactivity 60
 mab
 spanning-tree portfast
 spanning-tree bpduguard enable
!

! Guest VLAN and Auth-Fail VLAN
interface range GigabitEthernet1/0/1-48
 authentication event fail action authorize vlan 999
 authentication event no-response action authorize vlan 900
!

! Additional Security
ip dhcp snooping
ip dhcp snooping vlan 10,20,30,100,900,999
no ip dhcp snooping information option
ip arp inspection vlan 10,20,30,100
ip verify source`
                }
            ]
        },
        "ios": {
            title: "Cisco IOS Best Practices",
            sections: [
                {
                    title: "Legacy Catalyst Configuration",
                    content: `<p>For Catalyst 3750, 3560, 2960 and similar platforms:</p>
                    <ul>
                        <li>Use legacy RADIUS configuration method</li>
                        <li>Configure separate auth and accounting servers if possible</li>
                        <li>Set appropriate auth-fail max-attempts (3 recommended)</li>
                        <li>Configure critical VLAN for RADIUS server unavailability</li>
                    </ul>`
                }
            ],
            templates: [
                {
                    name: "IOS Monitor Mode",
                    description: "Initial deployment configuration with monitor mode for legacy Catalyst switches",
                    config: `! IOS Monitor Mode Configuration Template
! 802.1X Global Configuration
aaa new-model
aaa authentication dot1x default group radius
aaa authorization network default group radius
aaa accounting dot1x default start-stop group radius

dot1x system-auth-control

! RADIUS Server Configuration
radius-server host 10.1.1.1 auth-port 1812 acct-port 1813 key SHARED-SECRET-KEY
radius-server host 10.1.1.2 auth-port 1812 acct-port 1813 key SHARED-SECRET-KEY
radius-server deadtime 15

! Interface Configuration (Monitor Mode)
interface range GigabitEthernet0/1-48
 switchport mode access
 switchport voice vlan 100
 dot1x pae authenticator
 dot1x control-direction both
 dot1x port-control auto
 dot1x host-mode multi-domain
 dot1x auth-fail max-attempts 3
 dot1x timeout tx-period 30
 dot1x timeout quiet-period 60
 dot1x timeout reauth-period 3600
 spanning-tree portfast
 spanning-tree bpduguard enable
!

! Additional Security (Optional)
ip dhcp snooping
ip dhcp snooping vlan 10,20,30
no ip dhcp snooping information option
ip arp inspection vlan 10,20,30`
                }
            ]
        }
    },
    
    // Aruba best practices
    aruba: {
        general: {
            title: "Aruba General Best Practices",
            sections: [
                {
                    title: "Phased Deployment",
                    content: `<p>Aruba recommends a phased approach to 802.1X deployment:</p>
                    <ol>
                        <li><strong>Open Authentication Mode</strong>: Configure authentication but do not enforce access control.</li>
                        <li><strong>MAC Authentication</strong>: Add MAC Authentication for devices that don't support 802.1X.</li>
                        <li><strong>Closed Authentication Mode</strong>: Enforce access control once all devices are properly authenticating.</li>
                    </ol>`
                },
                {
                    title: "ClearPass Integration",
                    content: `<p>When integrating with ClearPass Policy Manager:</p>
                    <ul>
                        <li>Configure RFC 3576 (CoA) on all switches</li>
                        <li>Enable ClearPass OnConnect for enhanced visibility</li>
                        <li>Use OnGuard for endpoint posture assessment</li>
                        <li>Consider Profiling Services for device identification</li>
                    </ul>`
                }
            ],
            recommendations: [
                "Deploy in monitor/open mode first",
                "Use ClearPass for centralized policy management",
                "Configure multiple authentication servers for redundancy",
                "Implement MAC Authentication for IoT and legacy devices",
                "Use role-based access control for granular security",
                "Enable secure guest access through ClearPass",
                "Test thoroughly before full enforcement"
            ]
        },
        "aos-cx": {
            title: "Aruba AOS-CX Best Practices",
            sections: [
                {
                    title: "Authentication Configuration",
                    content: `<p>For AOS-CX platforms:</p>
                    <ul>
                        <li>Use RADIUS server groups for better flexibility</li>
                        <li>Configure proper tracking timeout settings</li>
                        <li>Set appropriate quiet period (30-60 seconds recommended)</li>
                        <li>Enable client limit per port where needed</li>
                    </ul>`
                },
                {
                    title: "User Role Configuration",
                    content: `<p>AOS-CX supports role-based access control:</p>
                    <ul>
                        <li>Define user roles with appropriate permissions</li>
                        <li>Map RADIUS attributes to user roles</li>
                        <li>Configure default roles for different authentication methods</li>
                        <li>Use dynamic VLAN assignment through RADIUS attributes</li>
                    </ul>`
                }
            ],
            templates: [
                {
                    name: "AOS-CX Monitor Mode",
                    description: "Initial deployment configuration with monitor mode",
                    config: `! AOS-CX Monitor Mode Configuration Template
! RADIUS Server Configuration
radius-server host 10.1.1.1 key SHARED-SECRET-KEY
radius-server host 10.1.1.2 key SHARED-SECRET-KEY
radius-server dead-time 15

aaa authentication port-access dot1x authenticator
aaa authentication dot1x default group radius local
aaa authorization network default group radius local

! Interface Configuration (Monitor Mode)
interface 1/1/1-1/1/48
 no shutdown
 spanning-tree port-type admin-edge
 spanning-tree bpdu-guard
 dot1x port-control auto
 dot1x authenticate
 dot1x authenticator
 dot1x timeout tx-period 30
 dot1x timeout quiet-period 60
 dot1x timeout reauth-period 3600
 dot1x supplicant-detection
 dot1x host-mode multi-domain
 dot1x auth-fail max-attempts 3
 mab
!

! Additional Security (Optional)
dhcp-snooping
dhcp-snooping vlan 10,20,30
no dhcp-snooping option 82
arp-protect vlan 10,20,30`
                }
            ]
        },
        "aos-switch": {
            title: "Aruba AOS-Switch Best Practices",
            sections: [
                {
                    title: "Legacy AOS Configuration",
                    content: `<p>For AOS-Switch (formerly ProVision) platforms:</p>
                    <ul>
                        <li>Use legacy RADIUS authentication commands</li>
                        <li>Configure user-based policies where possible</li>
                        <li>Set appropriate logoff period (300-900 seconds recommended)</li>
                        <li>Enable LLDP for voice VLAN discovery</li>
                    </ul>`
                }
            ],
            templates: [
                {
                    name: "AOS-Switch Monitor Mode",
                    description: "Initial deployment configuration with monitor mode for AOS-Switch",
                    config: `; AOS-Switch Monitor Mode Configuration Template
; RADIUS Configuration
radius-server host 10.1.1.1 key SHARED-SECRET-KEY
radius-server host 10.1.1.2 key SHARED-SECRET-KEY
radius-server dead-time 15

aaa authentication port-access eap-radius
aaa port-access authenticator active

; Interface Configuration (Monitor Mode)
interface 1-48
 spanning-tree admin-edge-port
 spanning-tree bpdu-protection
 aaa port-access authenticator
 aaa port-access authenticator quiet-period 60
 aaa port-access authenticator tx-period 30
 aaa port-access authenticator reauth-period 3600
 aaa port-access authenticator auth-pin
 aaa port-access authenticator unauth-vid 900
 aaa port-access authenticator client-limit 32
 aaa port-access mac-based
 aaa port-access controlled-direction both
;

; Additional Security (Optional)
dhcp-snooping
dhcp-snooping vlan 10,20,30
no dhcp-snooping option 82
arp-protect vlan 10,20,30`
                }
            ]
        }
    },
    
    // Juniper best practices
    juniper: {
        general: {
            title: "Juniper General Best Practices",
            sections: [
                {
                    title: "Phased Deployment",
                    content: `<p>Juniper recommends a staged deployment approach:</p>
                    <ol>
                        <li><strong>Authentication mode "none"</strong>: Monitor authentication attempts without enforcement.</li>
                        <li><strong>Guest VLAN implementation</strong>: Add fallback for non-802.1X devices.</li>
                        <li><strong>Authentication mode "802.1X"</strong>: Full enforcement with appropriate fallback mechanisms.</li>
                    </ol>`
                },
                {
                    title: "Server Redundancy",
                    content: `<p>Configure RADIUS server redundancy:</p>
                    <ul>
                        <li>Define multiple RADIUS servers in access profile</li>
                        <li>Configure retry options and timeout values</li>
                        <li>Implement dead-server detection for faster failover</li>
                        <li>Consider separating authentication and accounting servers</li>
                    </ul>`
                }
            ],
            recommendations: [
                "Use firewall filter terms to control access",
                "Deploy in authentication mode 'none' first",
                "Configure multiple RADIUS servers for redundancy",
                "Implement MAC RADIUS authentication for non-802.1X devices",
                "Enable dynamic VLAN and filter assignment",
                "Use server-reject VLAN for failed authentication",
                "Configure guest VLAN for unauthenticated devices",
                "Consider implementing CoA for dynamic policy updates"
            ]
        },
        "junos": {
            title: "Juniper JunOS Best Practices",
            sections: [
                {
                    title: "Access Profile Configuration",
                    content: `<p>For JunOS EX/QFX switches:</p>
                    <ul>
                        <li>Create dedicated access profile for 802.1X</li>
                        <li>Configure appropriate retry counts and timeout</li>
                        <li>Use test profiles to monitor server availability</li>
                        <li>Consider using RADIUS redundancy groups</li>
                    </ul>`
                },
                {
                    title: "Interface Configuration",
                    content: `<p>Recommended interface settings:</p>
                    <ul>
                        <li>Enable MAC RADIUS for non-802.1X capable devices</li>
                        <li>Configure appropriate supplicant modes based on device types</li>
                        <li>Set reauthentication interval that balances security with load</li>
                        <li>Configure guest VLAN for devices that don't respond to 802.1X</li>
                    </ul>`
                }
            ],
            templates: [
                {
                    name: "JunOS Monitor Mode",
                    description: "Initial deployment configuration with monitor mode",
                    config: `# JunOS Monitor Mode Configuration Template
# RADIUS Server Configuration
set access radius-server 10.1.1.1 secret "SHARED-SECRET-KEY"
set access radius-server 10.1.1.1 timeout 5
set access radius-server 10.1.1.1 retry 3
set access radius-server 10.1.1.1 source-address 10.0.0.1
set access radius-server 10.1.1.2 secret "SHARED-SECRET-KEY"
set access radius-server 10.1.1.2 timeout 5
set access radius-server 10.1.1.2 retry 3
set access radius-server 10.1.1.2 source-address 10.0.0.1

# Access Profile Configuration
set access profile DOT1X-PROFILE authentication-order radius
set access profile DOT1X-PROFILE radius authentication-server 10.1.1.1
set access profile DOT1X-PROFILE radius authentication-server 10.1.1.2
set access profile DOT1X-PROFILE radius accounting-server 10.1.1.1
set access profile DOT1X-PROFILE radius accounting-server 10.1.1.2
set access profile DOT1X-PROFILE radius options timeout 5
set access profile DOT1X-PROFILE radius options retries 3

# 802.1X Configuration
set protocols dot1x authenticator authentication-profile-name DOT1X-PROFILE
set protocols dot1x authenticator interface ge-0/0/0.0 supplicant multiple
set protocols dot1x authenticator interface ge-0/0/0.0 mac-radius
set protocols dot1x authenticator interface ge-0/0/0.0 reauthentication 3600
set protocols dot1x authenticator interface ge-0/0/0.0 quiet-period 60
set protocols dot1x authenticator interface ge-0/0/0.0 transmit-period 30
set protocols dot1x authenticator interface ge-0/0/0.0 authentication-mode none

# Interface Group Configuration
set interfaces interface-range ACCESS-PORTS member-range ge-0/0/0 to ge-0/0/47
set protocols dot1x authenticator interface ACCESS-PORTS supplicant multiple
set protocols dot1x authenticator interface ACCESS-PORTS mac-radius
set protocols dot1x authenticator interface ACCESS-PORTS reauthentication 3600
set protocols dot1x authenticator interface ACCESS-PORTS quiet-period 60
set protocols dot1x authenticator interface ACCESS-PORTS transmit-period 30
set protocols dot1x authenticator interface ACCESS-PORTS authentication-mode none

# Additional Security (Optional)
set ethernet-switching-options storm-control interface all bandwidth 1000
set protocols lldp interface all
set protocols lldp-med interface all`
                }
            ]
        }
    },
    
    // HP best practices
    hp: {
        general: {
            title: "HP General Best Practices",
            sections: [
                {
                    title: "Phased Deployment",
                    content: `<p>HP recommends a phased approach to 802.1X deployment:</p>
                    <ol>
                        <li><strong>Monitor Mode</strong>: Configure 802.1X but allow all traffic.</li>
                        <li><strong>Low-Impact Mode</strong>: Implement guest VLAN and critical VLAN.</li>
                        <li><strong>Secure Mode</strong>: Enable full enforcement with appropriate fallbacks.</li>
                    </ol>`
                },
                {
                    title: "RADIUS Server Configuration",
                    content: `<p>Best practices for RADIUS configuration:</p>
                    <ul>
                        <li>Configure at least two RADIUS servers for redundancy</li>
                        <li>Set appropriate timeout and retry values</li>
                        <li>Use source interface for RADIUS traffic when possible</li>
                        <li>Configure different shared secrets for each switch</li>
                    </ul>`
                }
            ],
            recommendations: [
                "Start with monitor/audit mode",
                "Use MAC authentication for legacy devices",
                "Enable guest VLAN for unauthenticated clients",
                "Configure RADIUS server redundancy",
                "Use unique RADIUS shared secrets per device",
                "Implement additional security features (DHCP snooping, ARP protection)",
                "Enable LLDP for voice VLAN discovery"
            ]
        }
    }
};

// Initialize Best Practices UI
function initBestPracticesUI() {
    // Create modal if it doesn't exist
    if (!document.getElementById('best-practices-modal')) {
        createBestPracticesModal();
    }
}

// Create the Best Practices modal
function createBestPracticesModal() {
    const modal = document.createElement('div');
    modal.id = 'best-practices-modal';
    modal.className = 'modal-overlay';
    
    modal.innerHTML = `
        <div class="modal-container best-practices-container">
            <div class="modal-header">
                <h2>802.1X Deployment Best Practices</h2>
                <button id="best-practices-modal-close" class="modal-close">&times;</button>
            </div>
            <div class="modal-body">
                <div class="best-practices-sidebar">
                    <div class="vendor-selector">
                        <label for="best-practices-vendor">Vendor:</label>
                        <select id="best-practices-vendor" class="form-control">
                            <option value="">Select Vendor</option>
                            <option value="cisco">Cisco</option>
                            <option value="aruba">Aruba</option>
                            <option value="juniper">Juniper</option>
                            <option value="hp">HP</option>
                        </select>
                    </div>
                    <div class="platform-selector" style="display: none;">
                        <label for="best-practices-platform">Platform:</label>
                        <select id="best-practices-platform" class="form-control">
                            <option value="general">General Best Practices</option>
                        </select>
                    </div>
                    <div id="best-practices-toc" class="best-practices-toc">
                        <h3>Contents</h3>
                        <ul>
                            <li><a href="#overview">Overview</a></li>
                        </ul>
                    </div>
                </div>
                <div class="best-practices-content">
                    <div id="best-practices-display">
                        <h2>802.1X Deployment Best Practices</h2>
                        <p>Select a vendor from the dropdown menu to view best practices for 802.1X deployment.</p>
                        
                        <h3>General Recommendations</h3>
                        <ul>
                            <li>Deploy 802.1X in phases, starting with monitor mode</li>
                            <li>Test thoroughly in a lab environment before production deployment</li>
                            <li>Always have a rollback plan</li>
                            <li>Configure RADIUS server redundancy</li>
                            <li>Implement a guest VLAN for non-802.1X devices</li>
                            <li>Use MAC Authentication Bypass (MAB) for devices that don't support 802.1X</li>
                            <li>Enable DHCP Snooping and other security features</li>
                            <li>Monitor authentication attempts during deployment</li>
                        </ul>
                        
                        <p>Please select a vendor to see more specific best practices and configuration templates.</p>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
}

// Set up Best Practices events
function setupBestPracticesEvents() {
    // Best Practices button click
    const bestPracticesLink = document.getElementById('best-practices');
    if (bestPracticesLink) {
        bestPracticesLink.addEventListener('click', function(e) {
            e.preventDefault();
            showBestPracticesModal();
        });
    }
    
    // Modal close button
    const closeButton = document.getElementById('best-practices-modal-close');
    if (closeButton) {
        closeButton.addEventListener('click', hideBestPracticesModal);
    }
    
    // Vendor selection change
    const vendorSelect = document.getElementById('best-practices-vendor');
    if (vendorSelect) {
        vendorSelect.addEventListener('change', function() {
            const vendor = this.value;
            updatePlatformOptions(vendor);
            loadBestPractices(vendor, 'general');
        });
    }
    
    // Platform selection change
    const platformSelect = document.getElementById('best-practices-platform');
    if (platformSelect) {
        platformSelect.addEventListener('change', function() {
            const vendor = document.getElementById('best-practices-vendor').value;
            const platform = this.value;
            loadBestPractices(vendor, platform);
        });
    }
    
    // If a vendor is already selected in the main interface, preset that vendor
    document.addEventListener('vendorChange', function(e) {
        const vendorSelect = document.getElementById('best-practices-vendor');
        if (vendorSelect && e.detail && e.detail.vendor) {
            vendorSelect.value = e.detail.vendor;
            updatePlatformOptions(e.detail.vendor);
        }
    });
}

// Show Best Practices modal
function showBestPracticesModal() {
    const modal = document.getElementById('best-practices-modal');
    if (modal) {
        modal.classList.add('visible');
        
        // If a vendor is already selected, load that vendor's best practices
        const selectedVendor = getSelectedVendor();
        if (selectedVendor) {
            const vendorSelect = document.getElementById('best-practices-vendor');
            if (vendorSelect) {
                vendorSelect.value = selectedVendor;
                updatePlatformOptions(selectedVendor);
                loadBestPractices(selectedVendor, 'general');
            }
        }
    }
}

// Hide Best Practices modal
function hideBestPracticesModal() {
    const modal = document.getElementById('best-practices-modal');
    if (modal) {
        modal.classList.remove('visible');
    }
}

// Update platform options based on selected vendor
function updatePlatformOptions(vendor) {
    const platformSelect = document.getElementById('best-practices-platform');
    const platformContainer = document.querySelector('.platform-selector');
    
    if (!platformSelect || !platformContainer) return;
    
    // Reset options
    platformSelect.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = 'general';
    defaultOption.textContent = 'General Best Practices';
    platformSelect.appendChild(defaultOption);
    
    // If no vendor selected, hide platform selector
    if (!vendor || !bestPracticesData[vendor]) {
        platformContainer.style.display = 'none';
        return;
    }
    
    // Add platform options for the selected vendor
    const platforms = Object.keys(bestPracticesData[vendor]);
    
    if (platforms.length > 1) {
        platforms.forEach(platform => {
            if (platform !== 'general') {
                const option = document.createElement('option');
                option.value = platform;
                option.textContent = bestPracticesData[vendor][platform].title || platform;
                platformSelect.appendChild(option);
            }
        });
        
        // Show platform selector
        platformContainer.style.display = 'block';
    } else {
        // Hide platform selector if only general best practices are available
        platformContainer.style.display = 'none';
    }
}

// Load best practices for the selected vendor and platform
function loadBestPractices(vendor, platform) {
    const contentDisplay = document.getElementById('best-practices-display');
    const tocContainer = document.getElementById('best-practices-toc');
    
    if (!contentDisplay || !tocContainer) return;
    
    // Check if vendor exists
    if (!vendor || !bestPracticesData[vendor]) {
        contentDisplay.innerHTML = `
            <h2>802.1X Deployment Best Practices</h2>
            <p>Please select a vendor from the dropdown menu to view best practices for 802.1X deployment.</p>
        `;
        tocContainer.innerHTML = '<h3>Contents</h3><ul><li><a href="#overview">Overview</a></li></ul>';
        return;
    }
    
    // Check if platform exists
    if (!platform || !bestPracticesData[vendor][platform]) {
        platform = 'general'; // Fallback to general best practices
    }
    
    const practiceData = bestPracticesData[vendor][platform];
    if (!practiceData) return;
    
    // Generate content
    let content = `<h2>${practiceData.title}</h2>`;
    
    // Generate TOC
    let toc = '<h3>Contents</h3><ul>';
    let tocIndex = 0;
    
    // Add sections
    if (practiceData.sections && practiceData.sections.length > 0) {
        practiceData.sections.forEach((section, index) => {
            const sectionId = `section-${index}`;
            toc += `<li><a href="#${sectionId}">${section.title}</a></li>`;
            
            content += `<div class="best-practices-section" id="${sectionId}">
                <h3>${section.title}</h3>
                ${section.content}
            </div>`;
            
            tocIndex++;
        });
    }
    
    // Add recommendations
    if (practiceData.recommendations && practiceData.recommendations.length > 0) {
        const recsId = 'recommendations';
        toc += `<li><a href="#${recsId}">Key Recommendations</a></li>`;
        
        content += `<div class="best-practices-section" id="${recsId}">
            <h3>Key Recommendations</h3>
            <ul>
                ${practiceData.recommendations.map(rec => `<li>${rec}</li>`).join('')}
            </ul>
        </div>`;
        
        tocIndex++;
    }
    
    // Add configuration templates
    if (practiceData.templates && practiceData.templates.length > 0) {
        const templatesId = 'templates';
        toc += `<li><a href="#${templatesId}">Configuration Templates</a></li>`;
        
        content += `<div class="best-practices-section" id="${templatesId}">
            <h3>Configuration Templates</h3>`;
        
        practiceData.templates.forEach((template, index) => {
            content += `
                <div class="template-container">
                    <h4>${template.name}</h4>
                    <p>${template.description}</p>
                    <div class="template-actions">
                        <button class="btn copy-template" data-template-index="${index}" data-vendor="${vendor}" data-platform="${platform}">Copy Template</button>
                        <button class="btn apply-template" data-template-index="${index}" data-vendor="${vendor}" data-platform="${platform}">Apply to Configuration</button>
                    </div>
                    <pre class="code-block">${template.config}</pre>
                </div>
            `;
        });
        
        content += '</div>';
        
        tocIndex++;
    }
    
    toc += '</ul>';
    
    // Update the display
    contentDisplay.innerHTML = content;
    tocContainer.innerHTML = toc;
    
    // Add event listeners for copy/apply buttons
    setupTemplateButtons();
}

// Set up event listeners for template buttons
function setupTemplateButtons() {
    // Copy template buttons
    const copyButtons = document.querySelectorAll('.copy-template');
    copyButtons.forEach(button => {
        button.addEventListener('click', function() {
            const vendor = this.getAttribute('data-vendor');
            const platform = this.getAttribute('data-platform');
            const templateIndex = parseInt(this.getAttribute('data-template-index'), 10);
            
            if (vendor && platform && !isNaN(templateIndex) && 
                bestPracticesData[vendor] && 
                bestPracticesData[vendor][platform] && 
                bestPracticesData[vendor][platform].templates && 
                bestPracticesData[vendor][platform].templates[templateIndex]) {
                
                const template = bestPracticesData[vendor][platform].templates[templateIndex];
                copyToClipboard(template.config);
                showAlert(`Template "${template.name}" copied to clipboard!`, 'success');
            }
        });
    });
    
    // Apply template buttons
    const applyButtons = document.querySelectorAll('.apply-template');
    applyButtons.forEach(button => {
        button.addEventListener('click', function() {
            const vendor = this.getAttribute('data-vendor');
            const platform = this.getAttribute('data-platform');
            const templateIndex = parseInt(this.getAttribute('data-template-index'), 10);
            
            if (vendor && platform && !isNaN(templateIndex) && 
                bestPracticesData[vendor] && 
                bestPracticesData[vendor][platform] && 
                bestPracticesData[vendor][platform].templates && 
                bestPracticesData[vendor][platform].templates[templateIndex]) {
                
                const template = bestPracticesData[vendor][platform].templates[templateIndex];
                applyTemplateToConfig(template.config);
                showAlert(`Template "${template.name}" applied to configuration!`, 'success');
                
                // Close modal after applying
                hideBestPracticesModal();
            }
        });
    });
}

// Copy text to clipboard
function copyToClipboard(text) {
    if (navigator.clipboard) {
        navigator.clipboard.writeText(text)
            .catch(err => {
                console.error('Failed to copy text: ', err);
                fallbackCopyToClipboard(text);
            });
    } else {
        fallbackCopyToClipboard(text);
    }
}

// Fallback method for copying to clipboard
function fallbackCopyToClipboard(text) {
    const textarea = document.createElement('textarea');
    textarea.value = text;
    textarea.style.position = 'fixed';
    textarea.style.opacity = '0';
    document.body.appendChild(textarea);
    textarea.select();
    
    try {
        document.execCommand('copy');
    } catch (err) {
        console.error('Fallback: Unable to copy', err);
    }
    
    document.body.removeChild(textarea);
}

// Apply template to configuration
function applyTemplateToConfig(templateConfig) {
    const configOutput = document.getElementById('config-output');
    if (configOutput) {
        configOutput.textContent = templateConfig;
        
        // If analysis exists, update it
        if (typeof analyzeConfiguration === 'function') {
            analyzeConfiguration();
        }
    }
}

// Get the currently selected vendor from the main interface
function getSelectedVendor() {
    const selectedVendorElement = document.querySelector('.vendor-logo-container.selected');
    return selectedVendorElement ? selectedVendorElement.getAttribute('data-vendor') : null;
}

// Helper function to show alerts - uses the global showAlert if available
function showAlert(message, type = 'info') {
    if (typeof window.showAlert === 'function') {
        window.showAlert(message, type);
    } else {
        alert(message);
    }
}
EOL

echo -e "${GREEN}Created best-practices.js module${RESET}"

# Create best-practices CSS styles
echo -e "${YELLOW}Creating best-practices CSS styles...${RESET}"
cat >> "$CSS_DIR/main.css" << 'EOL'

/* Best Practices Modal Styles */
.best-practices-container {
    max-width: 90%;
    width: 1200px;
    height: 80vh;
    display: flex;
    flex-direction: column;
}

.best-practices-container .modal-body {
    display: flex;
    flex: 1;
    overflow: hidden;
}

.best-practices-sidebar {
    width: 250px;
    padding: 15px;
    border-right: 1px solid #ddd;
    background-color: #f8f9fa;
    overflow-y: auto;
}

.best-practices-content {
    flex: 1;
    padding: 15px;
    overflow-y: auto;
}

.best-practices-toc {
    margin-top: 20px;
}

.best-practices-toc ul {
    padding-left: 20px;
}

.best-practices-toc li {
    margin-bottom: 5px;
}

.best-practices-section {
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid #eee;
}

.template-container {
    background-color: #f8f9fa;
    border: 1px solid #ddd;
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 20px;
}

.template-container pre {
    max-height: 300px;
    overflow-y: auto;
    background-color: #f5f5f5;
    padding: 10px;
    border-radius: 4px;
    border: 1px solid #ddd;
    margin-top: 10px;
}

.template-actions {
    margin: 10px 0;
}

.template-actions .btn {
    margin-right: 10px;
}

.dark-theme .best-practices-sidebar {
    background-color: #2c3033;
    border-right-color: #444;
}

.dark-theme .template-container,
.dark-theme .template-container pre {
    background-color: #2c3033;
    border-color: #444;
}

/* For mobile devices */
@media (max-width: 768px) {
    .best-practices-container .modal-body {
        flex-direction: column;
    }
    
    .best-practices-sidebar {
        width: 100%;
        border-right: none;
        border-bottom: 1px solid #ddd;
        max-height: 200px;
    }
}
EOL

echo -e "${GREEN}Added CSS styles for Best Practices${RESET}"

# Update index.html to include the new script
echo -e "${YELLOW}Updating index.html to include best-practices.js...${RESET}"

# Check if the script is already included
if grep -q "best-practices.js" "$PROJECT_DIR/index.html"; then
    echo -e "${YELLOW}best-practices.js is already included in index.html${RESET}"
else
    # Find the closing </body> tag and add the script link before it
    sed -i 's|</body>|    <script src="js/best-practices.js"></script>\n</body>|' "$PROJECT_DIR/index.html"
    echo -e "${GREEN}Added best-practices.js to index.html${RESET}"
fi

# Create directory for templates if it doesn't exist
mkdir -p "$TEMPLATES_DIR"

# Integration complete
echo -e "${GREEN}Best Practices module integration completed successfully!${RESET}"
echo -e "${BLUE}===========================================================${RESET}"
echo -e "The Best Practices module provides vendor-specific recommendations and"
echo -e "configuration templates for 802.1X deployments. Access it from the Resources"
echo -e "menu or by clicking the Best Practices link in the footer."
echo -e "${BLUE}===========================================================${RESET}"