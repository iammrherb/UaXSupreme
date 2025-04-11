/**
 * Dot1Xer Supreme Enterprise Edition - Vendor Configuration
 * Version 4.2.0
 */

// Define all vendors with their capabilities
const vendors = {
    cisco: {
        name: "Cisco",
        types: ["wired", "wireless", "tacacs", "vpn", "uaac"],
        platforms: {
            "ios": {
                name: "IOS",
                description: "Traditional Cisco IOS for older Catalyst switches",
                versions: ["12.2(55)SE", "15.0(2)SE", "15.2(2)E", "15.2(4)E", "15.2(7)E"],
                capabilities: ["dot1x", "mab", "tacacs", "radius"]
            },
            "ios-xe": {
                name: "IOS-XE",
                description: "IOS-XE for newer Catalyst switches and ISR routers",
                versions: ["16.12.x", "17.3.x", "17.6.x", "17.9.x", "17.11.x"],
                capabilities: ["dot1x", "mab", "radsec", "tacacs", "radius"]
            },
            "ios-xr": {
                name: "IOS-XR",
                description: "IOS-XR for high-end routers",
                versions: ["7.3.x", "7.5.x", "7.8.x"],
                capabilities: ["tacacs", "radius"]
            },
            "nx-os": {
                name: "NX-OS",
                description: "NX-OS for Nexus switches",
                versions: ["9.3.x", "10.1.x", "10.2.x"],
                capabilities: ["dot1x", "mab", "tacacs", "radius"]
            },
            "catalyst-os": {
                name: "Catalyst OS",
                description: "Software for Catalyst 9800 Series Wireless Controllers",
                versions: ["17.3.x", "17.6.x", "17.9.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "aireos": {
                name: "AireOS",
                description: "AireOS for Cisco Wireless LAN Controllers",
                versions: ["8.5.x", "8.10.x"],
                capabilities: ["dot1x", "radius", "tacacs"]
            },
            "asa": {
                name: "ASA",
                description: "Adaptive Security Appliance for firewalls & VPN",
                versions: ["9.12.x", "9.15.x", "9.17.x", "9.18.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            },
            "firepower": {
                name: "Firepower",
                description: "Firepower Threat Defense for next-gen firewalls",
                versions: ["7.0.x", "7.1.x", "7.2.x", "7.3.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            },
            "meraki": {
                name: "Meraki",
                description: "Meraki Dashboard for cloud-managed networks",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            },
            "ise": {
                name: "ISE",
                description: "Identity Services Engine for network access control",
                versions: ["2.7.x", "3.0.x", "3.1.x", "3.2.x"],
                capabilities: ["uaac", "radius", "tacacs"]
            }
        }
    },
    
    aruba: {
        name: "Aruba",
        types: ["wired", "wireless", "tacacs", "uaac"],
        platforms: {
            "aos-cx": {
                name: "AOS-CX",
                description: "AOS-CX for Aruba CX switches",
                versions: ["10.04.x", "10.05.x", "10.06.x", "10.08.x", "10.09.x", "10.10.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "aos-switch": {
                name: "AOS-Switch",
                description: "AOS-Switch for Aruba/HP switches (former ProVision)",
                versions: ["16.08.x", "16.09.x", "16.10.x", "16.11.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "arubaos": {
                name: "ArubaOS",
                description: "ArubaOS for Mobility Controllers",
                versions: ["8.6.x", "8.7.x", "8.8.x", "8.9.x", "8.10.x"],
                capabilities: ["dot1x", "radius", "tacacs"]
            },
            "instant": {
                name: "Instant",
                description: "Aruba Instant for autonomous APs",
                versions: ["8.6.x", "8.7.x", "8.8.x", "8.9.x", "8.10.x"],
                capabilities: ["dot1x", "radius"]
            },
            "central": {
                name: "Central",
                description: "Aruba Central for cloud-managed networks",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            },
            "clearpass": {
                name: "ClearPass",
                description: "ClearPass Policy Manager for network access control",
                versions: ["6.9.x", "6.10.x", "6.11.x"],
                capabilities: ["uaac", "radius", "tacacs"]
            }
        }
    },
    
    juniper: {
        name: "Juniper",
        types: ["wired", "wireless", "vpn", "tacacs"],
        platforms: {
            "junos": {
                name: "JunOS",
                description: "JunOS for EX/QFX switches, SRX firewalls, and MX routers",
                versions: ["19.4R3", "20.4R3", "21.2R3", "21.4R3", "22.1R1", "22.2R1", "22.3R1", "22.4R1"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "mist": {
                name: "Mist",
                description: "Mist for cloud-managed wireless",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            },
            "srx": {
                name: "SRX",
                description: "SRX Services Gateway firewalls",
                versions: ["19.4R3", "20.4R3", "21.2R3", "21.4R3", "22.1R1", "22.2R1"],
                capabilities: ["vpn", "radius", "tacacs"]
            }
        }
    },
    
    hp: {
        name: "HP",
        types: ["wired"],
        platforms: {
            "provision": {
                name: "ProVision",
                description: "ProVision for legacy HP ProCurve/Aruba switches",
                versions: ["K.16.05", "K.16.06", "K.16.07", "K.16.08", "K.16.09"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "comware": {
                name: "Comware",
                description: "Comware for HP H3C/3Com switches",
                versions: ["7.1.x", "7.2.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    extreme: {
        name: "Extreme",
        types: ["wired", "wireless", "tacacs"],
        platforms: {
            "exos": {
                name: "EXOS",
                description: "EXOS for Summit and X Series switches",
                versions: ["30.7.x", "31.1.x", "31.2.x", "31.3.x", "31.4.x", "31.5.x", "31.6.x", "31.7.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "voss": {
                name: "VOSS",
                description: "VOSS for VSP Series switches",
                versions: ["8.4.x", "8.5.x", "8.6.x", "8.7.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "wing": {
                name: "WiNG",
                description: "WiNG for Extreme wireless APs (former Motorola/Symbol/Zebra)",
                versions: ["7.6.x", "7.7.x", "7.8.x"],
                capabilities: ["dot1x", "radius"]
            },
            "identifi": {
                name: "IdentiFi",
                description: "IdentiFi for wireless controllers",
                versions: ["10.51.x", "10.52.x"],
                capabilities: ["dot1x", "radius"]
            },
            "xiq": {
                name: "XIQ",
                description: "ExtremeCloud IQ for cloud-managed networks",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            }
        }
    },
    
    fortinet: {
        name: "Fortinet",
        types: ["wired", "wireless", "vpn", "tacacs"],
        platforms: {
            "fortiswitch": {
                name: "FortiSwitch",
                description: "FortiSwitch operating system",
                versions: ["6.4.x", "7.0.x", "7.2.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "fortigate": {
                name: "FortiGate",
                description: "FortiGate for firewall and VPN",
                versions: ["6.4.x", "7.0.x", "7.2.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            },
            "fortiwlc": {
                name: "FortiWLC",
                description: "FortiWLC for wireless controllers",
                versions: ["8.6.x"],
                capabilities: ["dot1x", "radius"]
            },
            "fortiauth": {
                name: "FortiAuthenticator",
                description: "FortiAuthenticator for authentication server",
                versions: ["6.4.x", "7.0.x", "7.2.x"],
                capabilities: ["uaac", "radius", "tacacs", "saml"]
            }
        }
    },
    
    dell: {
        name: "Dell",
        types: ["wired", "tacacs"],
        platforms: {
            "os10": {
                name: "OS10",
                description: "OS10 for newest Dell EMC PowerSwitch",
                versions: ["10.5.x", "10.6.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "os9": {
                name: "OS9",
                description: "OS9 for Dell EMC PowerSwitch (former Force10)",
                versions: ["9.14.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "os6": {
                name: "OS6",
                description: "OS6 for Dell PowerSwitch N-Series",
                versions: ["6.6.x", "6.7.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    huawei: {
        name: "Huawei",
        types: ["wired", "wireless", "vpn", "tacacs"],
        platforms: {
            "vrp": {
                name: "VRP",
                description: "Versatile Routing Platform for switches and routers",
                versions: ["8.x", "9.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "ac": {
                name: "AC",
                description: "Huawei Wireless Access Controller",
                versions: ["8.x", "9.x"],
                capabilities: ["dot1x", "radius"]
            },
            "usg": {
                name: "USG",
                description: "Unified Security Gateway for firewalls and VPN",
                versions: ["6.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            }
        }
    },
    
    ruckus: {
        name: "Ruckus",
        types: ["wired", "wireless"],
        platforms: {
            "fastiron": {
                name: "FastIron",
                description: "FastIron for ICX switches",
                versions: ["8.0.x", "9.0.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "smartzone": {
                name: "SmartZone",
                description: "SmartZone for wireless controllers",
                versions: ["5.2.x", "6.0.x"],
                capabilities: ["dot1x", "radius"]
            },
            "unleashed": {
                name: "Unleashed",
                description: "Unleashed for autonomous APs",
                versions: ["200.7.x"],
                capabilities: ["dot1x", "radius"]
            }
        }
    },
    
    paloalto: {
        name: "Palo Alto",
        types: ["vpn", "tacacs"],
        platforms: {
            "panos": {
                name: "PAN-OS",
                description: "PAN-OS for Palo Alto firewalls",
                versions: ["9.1.x", "10.0.x", "10.1.x", "10.2.x", "11.0.x"],
                capabilities: ["vpn", "radius", "tacacs", "saml"]
            },
            "panorama": {
                name: "Panorama",
                description: "Panorama for centralized management",
                versions: ["9.1.x", "10.0.x", "10.1.x", "10.2.x", "11.0.x"],
                capabilities: ["radius", "tacacs"]
            }
        }
    },
    
    checkpoint: {
        name: "CheckPoint",
        types: ["vpn", "tacacs"],
        platforms: {
            "gaia": {
                name: "Gaia",
                description: "Gaia for Check Point security gateways",
                versions: ["R80.20", "R80.30", "R80.40", "R81", "R81.10", "R81.20"],
                capabilities: ["vpn", "radius", "tacacs", "saml"]
            },
            "mds": {
                name: "MDS",
                description: "Multi-Domain Security Management",
                versions: ["R80.20", "R80.30", "R80.40", "R81", "R81.10", "R81.20"],
                capabilities: ["radius", "tacacs"]
            }
        }
    },
    
    alcatel: {
        name: "Alcatel-Lucent",
        types: ["wired", "wireless"],
        platforms: {
            "aos": {
                name: "AOS",
                description: "Alcatel-Lucent Operating System for OmniSwitch",
                versions: ["8.6.x", "8.7.x", "8.8.x", "8.9.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "omnivista": {
                name: "OmniVista",
                description: "OmniVista for network management",
                versions: ["4.x"],
                capabilities: ["radius", "tacacs"]
            },
            "stellar": {
                name: "Stellar",
                description: "Stellar for wireless APs",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            }
        }
    },
    
    meraki: {
        name: "Meraki",
        types: ["wired", "wireless", "vpn"],
        platforms: {
            "dashboard": {
                name: "Dashboard",
                description: "Meraki Dashboard for MS switches, MR APs, and MX security appliances",
                versions: ["current"],
                capabilities: ["dot1x", "radius", "vpn"]
            }
        }
    },
    
    arista: {
        name: "Arista",
        types: ["wired", "tacacs"],
        platforms: {
            "eos": {
                name: "EOS",
                description: "Extensible Operating System for Arista switches",
                versions: ["4.27.x", "4.28.x", "4.29.x", "4.30.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            },
            "cloudvision": {
                name: "CloudVision",
                description: "CloudVision for network management",
                versions: ["2021.x", "2022.x"],
                capabilities: ["radius", "tacacs"]
            }
        }
    },
    
    ubiquiti: {
        name: "Ubiquiti",
        types: ["wired", "wireless", "vpn"],
        platforms: {
            "unifi": {
                name: "UniFi",
                description: "UniFi controllers for switches and APs",
                versions: ["5.14.x", "6.0.x", "7.1.x", "7.2.x", "7.3.x"],
                capabilities: ["dot1x", "radius", "vpn"]
            },
            "edgeos": {
                name: "EdgeOS",
                description: "EdgeOS for EdgeRouter",
                versions: ["2.0.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            },
            "edgeswitch": {
                name: "EdgeSwitch",
                description: "EdgeSwitch for EdgeSwitch models",
                versions: ["1.9.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    brocade: {
        name: "Brocade",
        types: ["wired"],
        platforms: {
            "fastiron": {
                name: "FastIron",
                description: "FastIron for ICX switches",
                versions: ["8.0.x", "9.0.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    allied: {
        name: "Allied Telesis",
        types: ["wired", "wireless"],
        platforms: {
            "awplus": {
                name: "AlliedWare Plus",
                description: "AlliedWare Plus for switches and routers",
                versions: ["5.4.x", "5.5.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    enterasys: {
        name: "Enterasys",
        types: ["wired"],
        platforms: {
            "eos": {
                name: "EOS",
                description: "Enterasys Operating System for legacy switches",
                versions: ["8.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    avaya: {
        name: "Avaya",
        types: ["wired"],
        platforms: {
            "acli": {
                name: "ACLI",
                description: "Avaya Command Line Interface for ERS switches",
                versions: ["7.x"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    cambium: {
        name: "Cambium",
        types: ["wireless"],
        platforms: {
            "cnmaestro": {
                name: "cnMaestro",
                description: "cnMaestro for wireless network management",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            },
            "cnmatrix": {
                name: "cnMatrix",
                description: "cnMatrix for switches",
                versions: ["current"],
                capabilities: ["dot1x", "mab", "radius", "tacacs"]
            }
        }
    },
    
    sonicwall: {
        name: "SonicWall",
        types: ["vpn", "tacacs"],
        platforms: {
            "sonicOS": {
                name: "SonicOS",
                description: "SonicOS for firewalls and VPN appliances",
                versions: ["7.0.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            }
        }
    },
    
    watchguard: {
        name: "WatchGuard",
        types: ["wireless", "vpn", "tacacs"],
        platforms: {
            "fireware": {
                name: "Fireware",
                description: "Fireware OS for Firebox appliances",
                versions: ["12.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            },
            "wgap": {
                name: "WatchGuard AP",
                description: "WatchGuard AP firmware",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            }
        }
    },
    
    sophos: {
        name: "Sophos",
        types: ["vpn", "tacacs"],
        platforms: {
            "sfos": {
                name: "SFOS",
                description: "Sophos Firewall OS",
                versions: ["18.x", "19.x"],
                capabilities: ["vpn", "radius", "tacacs"]
            }
        }
    },
    
    netgear: {
        name: "Netgear",
        types: ["wired", "wireless"],
        platforms: {
            "gsm": {
                name: "GSM",
                description: "Netgear Smart Managed Pro for switches",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            }
        }
    },
    
    arubaio: {
        name: "Aruba Instant On",
        types: ["wired", "wireless"],
        platforms: {
            "instanton": {
                name: "Instant On",
                description: "Aruba Instant On for SMB switches and APs",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            }
        }
    },
    
    ciscosmb: {
        name: "Cisco SMB",
        types: ["wired", "wireless"],
        platforms: {
            "cbs": {
                name: "CBS",
                description: "Cisco Business Switches",
                versions: ["current"],
                capabilities: ["dot1x", "radius"]
            },
            "rv": {
                name: "RV",
                description: "Cisco Small Business RV Series",
                versions: ["current"],
                capabilities: ["dot1x", "vpn", "radius"]
            }
        }
    },
    
    clearpass: {
        name: "ClearPass",
        types: ["uaac"],
        platforms: {
            "cppm": {
                name: "CPPM",
                description: "ClearPass Policy Manager",
                versions: ["6.9.x", "6.10.x", "6.11.x"],
                capabilities: ["uaac", "radius", "tacacs"]
            }
        }
    },
    
    ise: {
        name: "Cisco ISE",
        types: ["uaac"],
        platforms: {
            "ise": {
                name: "ISE",
                description: "Identity Services Engine",
                versions: ["2.7.x", "3.0.x", "3.1.x", "3.2.x"],
                capabilities: ["uaac", "radius", "tacacs"]
            }
        }
    },
    
    freeradius: {
        name: "FreeRADIUS",
        types: ["uaac"],
        platforms: {
            "freeradius": {
                name: "FreeRADIUS",
                description: "Open source RADIUS server",
                versions: ["3.0.x", "3.2.x"],
                capabilities: ["uaac", "radius"]
            }
        }
    },
    
    nps: {
        name: "Microsoft NPS",
        types: ["uaac"],
        platforms: {
            "nps": {
                name: "NPS",
                description: "Network Policy Server",
                versions: ["Windows Server 2016", "Windows Server 2019", "Windows Server 2022"],
                capabilities: ["uaac", "radius"]
            }
        }
    },
    
    portnox: {
        name: "Portnox",
        types: ["uaac"],
        platforms: {
            "portnox": {
                name: "Portnox",
                description: "Portnox CLEAR/CORE for network access control",
                versions: ["current"],
                capabilities: ["uaac", "radius"]
            }
        }
    },
    
    packetfence: {
        name: "PacketFence",
        types: ["uaac"],
        platforms: {
            "packetfence": {
                name: "PacketFence",
                description: "Open source NAC solution",
                versions: ["10.x", "11.x", "12.x"],
                capabilities: ["uaac", "radius"]
            }
        }
    }
};

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing vendor selection system...');
    initVendorGrid();
    setupVendorSelection();
});

// Initialize vendor grid
function initVendorGrid() {
    const vendorGrid = document.getElementById('vendor-grid');
    if (!vendorGrid) {
        console.error('Vendor grid element not found!');
        return;
    }
    
    // Clear existing content
    vendorGrid.innerHTML = '';
    
    // Create vendor cards
    for (const [vendorId, vendor] of Object.entries(vendors)) {
        // Skip duplicates
        if (vendorId === 'fortinetalt') continue;
        
        const vendorCard = document.createElement('div');
        vendorCard.className = 'vendor-logo-container';
        vendorCard.setAttribute('data-vendor', vendorId);
        
        // Get vendor types and determine primary type for badge
        const types = vendor.types || [];
        let primaryType = types.length > 0 ? types[0] : 'unknown';
        let typeLabel = primaryType.toUpperCase();
        
        // If vendor supports both wired and wireless, show as "BOTH"
        if (types.includes('wired') && types.includes('wireless')) {
            primaryType = 'both';
            typeLabel = 'BOTH';
        }
        
        // Create vendor logo
        const logoPath = `assets/logos/${vendorId}-logo.svg`;
        const vendorLogo = document.createElement('img');
        vendorLogo.className = 'vendor-logo';
        vendorLogo.src = logoPath;
        vendorLogo.alt = `${vendor.name} logo`;
        vendorLogo.onerror = function() {
            // If image fails to load, replace with text logo
            this.onerror = null;
            this.src = createTextLogoDataUrl(vendor.name);
        };
        
        // Create vendor name
        const vendorName = document.createElement('span');
        vendorName.className = 'vendor-name';
        vendorName.textContent = vendor.name;
        
        // Create vendor type badge
        const vendorType = document.createElement('span');
        vendorType.className = `vendor-type vendor-type-${primaryType}`;
        vendorType.textContent = typeLabel;
        
        // Add all elements to card
        vendorCard.appendChild(vendorLogo);
        vendorCard.appendChild(vendorName);
        vendorCard.appendChild(vendorType);
        
        // Add click event listener
        vendorCard.addEventListener('click', function() {
            selectVendor(vendorId);
        });
        
        // Add card to grid
        vendorGrid.appendChild(vendorCard);
    }
}

// Setup vendor selection event handling
function setupVendorSelection() {
    // Listen for platform selection changes
    const platformSelect = document.getElementById('platform-select');
    if (platformSelect) {
        platformSelect.addEventListener('change', function() {
            updatePlatformDetails();
        });
    }
    
    // Listen for deployment type changes
    const deploymentType = document.getElementById('deployment-type');
    if (deploymentType) {
        deploymentType.addEventListener('change', function() {
            updatePlatformOptions();
        });
    }
}

// Select a vendor
function selectVendor(vendorId) {
    console.log('Selecting vendor:', vendorId);
    
    // Update selected vendor styling
    const vendorCards = document.querySelectorAll('.vendor-logo-container');
    vendorCards.forEach(card => {
        if (card.getAttribute('data-vendor') === vendorId) {
            card.classList.add('selected');
        } else {
            card.classList.remove('selected');
        }
    });
    
    // Update platform select
    updatePlatformSelect(vendorId);
    
    // Store selected vendor
    localStorage.setItem('selectedVendor', vendorId);
    
    // Enable the next button if it exists
    const nextButton = document.getElementById('platform-next');
    if (nextButton) {
        nextButton.disabled = false;
    }
}

// Update platform select dropdown for selected vendor
function updatePlatformSelect(vendorId) {
    const platformSelect = document.getElementById('platform-select');
    if (!platformSelect) return;
    
    // Clear existing options
    platformSelect.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = 'Select a platform';
    platformSelect.appendChild(defaultOption);
    
    // Get vendor platforms
    const vendor = vendors[vendorId];
    if (!vendor) return;
    
    // Get deployment type
    const deploymentType = document.getElementById('deployment-type');
    const currentDeploymentType = deploymentType ? deploymentType.value : 'wired';
    
    console.log(`Updating platform select for ${vendorId} with deployment type ${currentDeploymentType}`);
    
    // Add platform options that support the selected deployment type
    for (const [platformId, platform] of Object.entries(vendor.platforms)) {
        // Check if platform supports deployment type
        if (platform.capabilities.includes(currentDeploymentType) || 
            (currentDeploymentType === 'wired' && platform.capabilities.includes('dot1x')) ||
            (currentDeploymentType === 'wireless' && platform.capabilities.includes('dot1x')) ||
            (currentDeploymentType === 'tacacs' && platform.capabilities.includes('tacacs')) ||
            (currentDeploymentType === 'vpn' && platform.capabilities.includes('vpn')) ||
            (currentDeploymentType === 'uaac' && platform.capabilities.includes('radius'))) {
            
            const option = document.createElement('option');
            option.value = platformId;
            option.textContent = platform.name;
            platformSelect.appendChild(option);
        }
    }
    
    // Enable select
    platformSelect.disabled = false;
    
    // Trigger platform details update
    updatePlatformDetails();
}

// Update platform options based on deployment type
function updatePlatformOptions() {
    const selectedVendor = getSelectedVendor();
    if (selectedVendor) {
        updatePlatformSelect(selectedVendor);
    }
}

// Update platform details based on selected vendor and platform
function updatePlatformDetails() {
    const platformDetails = document.getElementById('platform-details');
    if (!platformDetails) return;
    
    // Get selected vendor and platform
    const selectedVendor = getSelectedVendor();
    const platformSelect = document.getElementById('platform-select');
    const selectedPlatform = platformSelect ? platformSelect.value : '';
    
    console.log(`Updating platform details for ${selectedVendor}/${selectedPlatform}`);
    
    // Clear if nothing selected
    if (!selectedVendor || !selectedPlatform) {
        platformDetails.innerHTML = '<p>Please select a vendor and platform.</p>';
        return;
    }
    
    // Get vendor and platform data
    const vendor = vendors[selectedVendor];
    if (!vendor) return;
    
    const platform = vendor.platforms[selectedPlatform];
    if (!platform) return;
    
    // Create platform details HTML
    let detailsHtml = `
        <div class="platform-details-header">
            <h3>${platform.name}</h3>
            <span class="vendor-badge">${vendor.name}</span>
        </div>
        <p>${platform.description}</p>
        
        <h4>Capabilities</h4>
        <div class="capability-badges">
    `;
    
    // Add capability badges
    const capabilities = platform.capabilities || [];
    const capabilityLabels = {
        'dot1x': '802.1X',
        'mab': 'MAB',
        'radsec': 'RadSec',
        'radius': 'RADIUS',
        'tacacs': 'TACACS+',
        'vpn': 'VPN',
        'uaac': 'User Auth',
        'saml': 'SAML'
    };
    
    capabilities.forEach(capability => {
        const label = capabilityLabels[capability] || capability;
        detailsHtml += `<span class="capability-badge">${label}</span>`;
    });
    
    detailsHtml += '</div>';
    
    // Add version selection
    if (platform.versions && platform.versions.length > 0) {
        detailsHtml += `
            <h4>Software Version</h4>
            <select id="platform-version" class="form-control">
                <option value="">Select a version</option>
        `;
        
        platform.versions.forEach(version => {
            detailsHtml += `<option value="${version}">${version}</option>`;
        });
        
        detailsHtml += '</select>';
    }
    
    // Update platform details
    platformDetails.innerHTML = detailsHtml;
}

// Get selected vendor
function getSelectedVendor() {
    const selectedCard = document.querySelector('.vendor-logo-container.selected');
    return selectedCard ? selectedCard.getAttribute('data-vendor') : '';
}

// Create text logo as data URL if image fails to load
function createTextLogoDataUrl(vendorName) {
    // Create a canvas element
    const canvas = document.createElement('canvas');
    canvas.width = 120;
    canvas.height = 60;
    
    // Get the context
    const ctx = canvas.getContext('2d');
    
    // Draw background (transparent)
    ctx.clearRect(0, 0, 120, 60);
    
    // Draw text
    ctx.fillStyle = '#0077cc';
    ctx.font = 'bold 20px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(vendorName, 60, 30);
    
    // Return data URL
    return canvas.toDataURL('image/png');
}

// Select the default vendor when the page is loaded
function selectDefaultVendor() {
    console.log('Selecting default vendor...');
    
    // Check if we have a saved vendor
    const savedVendor = localStorage.getItem('selectedVendor');
    
    if (savedVendor && vendors[savedVendor]) {
        console.log('Using saved vendor:', savedVendor);
        selectVendor(savedVendor);
    } else {
        // Otherwise select Cisco by default
        console.log('Selecting default vendor (Cisco)');
        selectVendor('cisco');
    }
}

// Wait a moment then select default vendor
setTimeout(function() {
    console.log('Initializing vendor selection...');
    selectDefaultVendor();
}, 500);
