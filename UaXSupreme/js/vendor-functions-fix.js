// Direct fix for vendor selection functions

// Fix for select vendor function
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

// Fix for update platform select dropdown
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
    
    console.log(`Updating platforms for ${vendorId} with type ${currentDeploymentType}`);
    
    // Add platform options
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
    
    // Add change event listener if not already added
    if (!platformSelect.hasAttribute('data-event-added')) {
        platformSelect.addEventListener('change', function() {
            updatePlatformDetails();
        });
        platformSelect.setAttribute('data-event-added', 'true');
    }
    
    // Update platform details
    updatePlatformDetails();
}

// Fix for update platform details
function updatePlatformDetails() {
    const platformDetails = document.getElementById('platform-details');
    if (!platformDetails) return;
    
    // Get selected vendor and platform
    const selectedVendor = getSelectedVendor();
    const platformSelect = document.getElementById('platform-select');
    const selectedPlatform = platformSelect ? platformSelect.value : '';
    
    console.log(`Updating details for ${selectedVendor}/${selectedPlatform}`);
    
    // Clear if nothing selected
    if (!selectedVendor || !selectedPlatform) {
        platformDetails.innerHTML = '<p class="placeholder-text">Please select a vendor and platform to view details.</p>';
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

// Add these fixed functions directly to window
window.selectVendor = selectVendor;
window.updatePlatformSelect = updatePlatformSelect;
window.updatePlatformDetails = updatePlatformDetails;

// Ensure vendor selection works
document.addEventListener('DOMContentLoaded', function() {
    // Initialize vendor grid if on the right page
    const vendorGrid = document.getElementById('vendor-grid');
    if (vendorGrid) {
        if (typeof initVendorGrid === 'function') {
            initVendorGrid();
            setupVendorSelection();
            
            // Wait for vendors to load then select default
            setTimeout(function() {
                const savedVendor = localStorage.getItem('selectedVendor') || 'cisco';
                if (window.vendors && window.vendors[savedVendor]) {
                    selectVendor(savedVendor);
                }
            }, 300);
        }
    }
});
