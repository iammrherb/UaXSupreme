// Vendor data with proper logo handling
window.vendors = {
    cisco: {
        name: 'Cisco',
        platforms: ['ios', 'ios-xe', 'nx-os', 'wlc-9800'],
        logo: 'assets/logos/cisco.png'  // Will handle missing logos
    },
    aruba: {
        name: 'Aruba',
        platforms: ['aos-cx', 'aos'],
        logo: 'assets/logos/aruba.png'
    },
    juniper: {
        name: 'Juniper',
        platforms: ['junos', 'ex-series'],
        logo: 'assets/logos/juniper.png'
    },
    huawei: {
        name: 'Huawei',
        platforms: ['basic'],
        logo: 'assets/logos/huawei.png'
    },
    fortinet: {
        name: 'Fortinet',
        platforms: ['fortiswitch'],
        logo: 'assets/logos/fortinet.png'
    }
};

// Initialize vendor grid with error handling
function initVendorGrid() {
    console.log('Initializing vendor grid with enhanced error handling...');
    const vendorGrid = document.getElementById('vendor-grid');
    
    if (!vendorGrid) {
        console.error('Vendor grid element not found');
        return;
    }
    
    // Clear existing content
    vendorGrid.innerHTML = '';
    
    // Create vendor cards
    Object.entries(window.vendors).forEach(([key, vendor]) => {
        const vendorCard = document.createElement('div');
        vendorCard.className = 'vendor-logo-container';
        vendorCard.setAttribute('data-vendor', key);
        
        // Create vendor content without relying on logos
        vendorCard.innerHTML = `
            <div class="vendor-logo" style="background-color: #f0f0f0; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; color: #333;">
                ${vendor.name.charAt(0)}
            </div>
            <span class="vendor-name">${vendor.name}</span>
        `;
        
        vendorCard.addEventListener('click', () => selectVendor(key));
        vendorGrid.appendChild(vendorCard);
    });
}

// Safe vendor selection
function selectVendor(vendorKey) {
    const vendor = window.vendors[vendorKey];
    if (!vendor) return;
    
    // Update UI
    document.querySelectorAll('.vendor-logo-container').forEach(container => {
        container.classList.toggle('selected', container.getAttribute('data-vendor') === vendorKey);
    });
    
    // Update platform dropdown
    const platformSelect = document.getElementById('platform-select');
    if (platformSelect) {
        platformSelect.disabled = false;
        platformSelect.innerHTML = '<option value="">Select a platform</option>';
        
        vendor.platforms.forEach(platform => {
            const option = document.createElement('option');
            option.value = platform;
            option.textContent = platform.toUpperCase();
            platformSelect.appendChild(option);
        });
    }
    
    // Dispatch vendor change event
    const event = new CustomEvent('vendorChange', {
        detail: { vendor: vendorKey, vendorData: vendor }
    });
    document.dispatchEvent(event);
}

// Auto-initialize when DOM is ready
document.addEventListener('DOMContentLoaded', initVendorGrid);

// Export functions
window.initVendorGrid = initVendorGrid;
window.selectVendor = selectVendor;
