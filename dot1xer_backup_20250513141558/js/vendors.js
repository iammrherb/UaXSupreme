/**
 * Dot1Xer Core Edition - Vendor Configuration
 * Version 1.0.0
 */

// Define core vendors with only essential capabilities
const vendors = {
  cisco: {
    name: 'Cisco',
    types: ['wired', 'wireless'],
    platforms: {
      ios: {
        name: 'IOS',
        description: 'Traditional Cisco IOS for Catalyst switches',
        versions: ['15.2(4)E', '15.2(7)E'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      'ios-xe': {
        name: 'IOS-XE',
        description: 'IOS-XE for newer Catalyst switches',
        versions: ['16.12.x', '17.3.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      'nx-os': {
        name: 'NX-OS',
        description: 'NX-OS for Nexus switches',
        versions: ['9.3.x', '10.1.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
  },

  aruba: {
    name: 'Aruba',
    types: ['wired', 'wireless'],
    platforms: {
      'aos-cx': {
        name: 'AOS-CX',
        description: 'AOS-CX for Aruba CX switches',
        versions: ['10.06.x', '10.08.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      'aos-switch': {
        name: 'AOS-Switch',
        description: 'AOS-Switch for Aruba/HP switches',
        versions: ['16.08.x', '16.09.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
  },

  juniper: {
    name: 'Juniper',
    types: ['wired', 'wireless'],
    platforms: {
      junos: {
        name: 'JunOS',
        description: 'JunOS for EX/QFX switches',
        versions: ['19.4R3', '20.4R3'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
  },

  hp: {
    name: 'HP',
    types: ['wired'],
    platforms: {
      provision: {
        name: 'ProVision',
        description: 'ProVision for legacy HP ProCurve switches',
        versions: ['K.16.05', 'K.16.06'],
        capabilities: ['dot1x', 'mab', 'radius'],
      },
      comware: {
        name: 'Comware',
        description: 'Comware for HP H3C switches',
        versions: ['7.1.x', '7.2.x'],
        capabilities: ['dot1x', 'mab', 'radius'],
      }
    },
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
    const vendorCard = document.createElement('div');
    vendorCard.className = 'vendor-logo-container';
    vendorCard.setAttribute('data-vendor', vendorId);

    // Get vendor types and determine primary type for badge
    const types = vendor.types || [];
    let primaryType = types.length > 0 ? types[0] : 'unknown';
    let typeLabel = primaryType.toUpperCase();

    // Create vendor logo
    const logoPath = `assets/logos/${vendorId}-logo.svg`;
    const vendorLogo = document.createElement('img');
    vendorLogo.className = 'vendor-logo';
    vendorLogo.src = logoPath;
    vendorLogo.alt = `${vendor.name} logo`;
    vendorLogo.onerror = function() {
      this.onerror = null;
      this.src = `data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" width="100" height="50"><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" font-size="16" font-weight="bold" fill="%230077cc">${vendor.name}</text></svg>`;
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

    // Add click event
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
    platformSelect.addEventListener('change', updatePlatformDetails);
  }
}

// Select a vendor
function selectVendor(vendorId) {
  // Update selected vendor styling
  const vendorCards = document.querySelectorAll('.vendor-logo-container');
  vendorCards.forEach((card) => {
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

  // Enable the next button
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

  // Add platform options
  for (const [platformId, platform] of Object.entries(vendor.platforms)) {
    const option = document.createElement('option');
    option.value = platformId;
    option.textContent = platform.name;
    platformSelect.appendChild(option);
  }

  // Enable select
  platformSelect.disabled = false;

  // Update platform details
  updatePlatformDetails();
}

// Update platform details
function updatePlatformDetails() {
  const platformDetails = document.getElementById('platform-details');
  if (!platformDetails) return;

  // Get selected vendor and platform
  const selectedVendor = getSelectedVendor();
  const platformSelect = document.getElementById('platform-select');
  const selectedPlatform = platformSelect ? platformSelect.value : '';

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
  platformDetails.innerHTML = `
    <div class="platform-details-header">
      <h3>${platform.name}</h3>
      <span class="vendor-badge">${vendor.name}</span>
    </div>
    <p>${platform.description}</p>
    
    <h4>Capabilities</h4>
    <div class="capability-badges">
      ${(platform.capabilities || []).map(cap => 
        `<span class="capability-badge">${cap.toUpperCase()}</span>`
      ).join('')}
    </div>
    
    <h4>Software Version</h4>
    <select id="platform-version" class="form-control">
      <option value="">Select a version</option>
      ${(platform.versions || []).map(ver => 
        `<option value="${ver}">${ver}</option>`
      ).join('')}
    </select>
  `;
}

// Get selected vendor
function getSelectedVendor() {
  const selectedCard = document.querySelector('.vendor-logo-container.selected');
  return selectedCard ? selectedCard.getAttribute('data-vendor') : '';
}

// Select the default vendor
function selectDefaultVendor() {
  // Check if we have a saved vendor
  const savedVendor = localStorage.getItem('selectedVendor');

  if (savedVendor && vendors[savedVendor]) {
    selectVendor(savedVendor);
  } else {
    // Otherwise select Cisco by default
    selectVendor('cisco');
  }
}
