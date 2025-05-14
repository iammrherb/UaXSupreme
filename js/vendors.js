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
