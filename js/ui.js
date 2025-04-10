/**
 * Dot1Xer Supreme Enterprise Edition - UI Initialization
 * Version 4.0.0
 * 
 * This module handles UI initialization and dynamic content loading.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing UI...');
    
    // Initialize video banner
    initVideoBanner();
    
    // Initialize expandable sections
    initExpandableSections();
    
    // Initialize tabs
    initTabs();
    
    // Load vendor grid
    loadVendorGrid();
    
    // Setup modals
    setupModals();
    
    console.log('UI initialization complete');
});

// Initialize video banner
function initVideoBanner() {
    const videoBanner = document.getElementById('video-banner');
    if (!videoBanner) return;
    
    // Try to load video
    const videoSrc = 'assets/videos/banner-video.mp4';
    
    // Check if video exists
    fetch(videoSrc)
        .then(response => {
            if (response.ok) {
                // Create video element
                const video = document.createElement('video');
                video.autoplay = true;
                video.loop = true;
                video.muted = true;
                video.playsInline = true;
                
                const source = document.createElement('source');
                source.src = videoSrc;
                source.type = 'video/mp4';
                
                video.appendChild(source);
                
                // Add video to banner (before overlay)
                const overlay = videoBanner.querySelector('.video-overlay');
                videoBanner.insertBefore(video, overlay);
            } else {
                // Check for HTML placeholder
                fetch('assets/videos/banner-video.html')
                    .then(response => {
                        if (response.ok) {
                            return response.text();
                        }
                        throw new Error('Video placeholder not found');
                    })
                    .then(html => {
                        // Insert HTML placeholder
                        videoBanner.innerHTML = html + videoBanner.innerHTML;
                    })
                    .catch(error => {
                        console.warn('Video banner placeholder not found:', error);
                    });
            }
        })
        .catch(error => {
            console.warn('Error loading video banner:', error);
        });
}

// Initialize expandable sections
function initExpandableSections() {
    const expandableHeaders = document.querySelectorAll('.expandable-header');
    
    expandableHeaders.forEach(header => {
        header.addEventListener('click', () => {
            // Toggle expanded class
            header.classList.toggle('expanded');
            
            // Get content section
            const content = header.nextElementSibling;
            if (content && content.classList.contains('expandable-content')) {
                content.classList.toggle('expanded');
            }
        });
    });
}

// Initialize tabs
function initTabs() {
    const tabs = document.querySelectorAll('.tab');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // Get tab ID
            const tabId = tab.getAttribute('data-tab');
            
            // Remove active class from all tabs
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            
            // Add active class to clicked tab
            tab.classList.add('active');
            
            // Hide all tab panes
            document.querySelectorAll('.tab-pane').forEach(pane => pane.classList.remove('active'));
            
            // Show selected tab pane
            const selectedPane = document.getElementById(tabId);
            if (selectedPane) {
                selectedPane.classList.add('active');
            }
        });
    });
    
    // Set up next/previous tab navigation
    const navButtons = {
        'platform-next': { current: 'platform', next: 'authentication' },
        'auth-prev': { current: 'authentication', next: 'platform' },
        'auth-next': { current: 'authentication', next: 'security' },
        'security-prev': { current: 'security', next: 'authentication' },
        'security-next': { current: 'security', next: 'network' },
        'network-prev': { current: 'network', next: 'security' },
        'network-next': { current: 'network', next: 'advanced' },
        'advanced-prev': { current: 'advanced', next: 'network' },
        'advanced-next': { current: 'advanced', next: 'preview' },
        'preview-prev': { current: 'preview', next: 'advanced' }
    };
    
    for (const [buttonId, navigation] of Object.entries(navButtons)) {
        const button = document.getElementById(buttonId);
        if (button) {
            button.addEventListener('click', () => {
                const tab = document.querySelector(`.tab[data-tab="${navigation.next}"]`);
                if (tab) {
                    tab.click();
                }
            });
        }
    }
}

// Load vendor grid
function loadVendorGrid() {
    const vendorGrid = document.getElementById('vendor-grid');
    if (!vendorGrid) return;
    
    // Define vendors to display (use the vendorData from vendors.js if available)
    const vendors = window.vendorData ? window.vendorData.vendors : [
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
        { id: 'alcatel', name: 'Alcatel-Lucent', logo: 'alcatel-logo.svg' }
    ];
    
    // Clear grid
    vendorGrid.innerHTML = '';
    
    // Add vendor logos
    vendors.forEach(vendor => {
        const vendorContainer = document.createElement('div');
        vendorContainer.className = 'vendor-logo-container';
        vendorContainer.setAttribute('data-vendor', vendor.id);
        
        const vendorLogo = document.createElement('img');
        vendorLogo.className = 'vendor-logo';
        vendorLogo.src = `assets/logos/${vendor.logo}`;
        vendorLogo.alt = `${vendor.name} Logo`;
        vendorLogo.onerror = function() {
            this.onerror = null;
            this.src = `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='80'%3E%3Crect width='140' height='80' fill='%23f0f0f0' rx='5'/%3E%3Ctext x='70' y='40' font-family='Arial' font-size='16' text-anchor='middle' dominant-baseline='middle' fill='%23333333'%3E${vendor.name}%3C/text%3E%3C/svg%3E`;
        };
        
        vendorContainer.appendChild(vendorLogo);
        vendorGrid.appendChild(vendorContainer);
        
        // Add click handler
        vendorContainer.addEventListener('click', () => {
            // Remove selected class from all vendors
            const allVendors = document.querySelectorAll('.vendor-logo-container');
            allVendors.forEach(v => v.classList.remove('selected'));
            
            // Add selected class to clicked vendor
            vendorContainer.classList.add('selected');
            
            // Update platform options
            updatePlatformOptions(vendor.id);
            
            // Trigger vendor change event
            const event = new CustomEvent('vendorChange', { detail: { vendor: vendor.id } });
            document.dispatchEvent(event);
        });
    });
}

// Update platform options based on selected vendor
function updatePlatformOptions(vendorId) {
    const platformSelect = document.getElementById('platform-select');
    if (!platformSelect) return;
    
    // Clear existing options
    platformSelect.innerHTML = '';
    
    // Get platforms for selected vendor from vendorData in vendors.js
    let platforms = [];
    
    if (window.vendorData && window.vendorData.platforms && window.vendorData.platforms[vendorId]) {
        platforms = window.vendorData.platforms[vendorId];
    } else {
        // Fallback options if vendorData is not available
        switch (vendorId) {
            case 'cisco':
                platforms = [
                    { id: 'ios', name: 'IOS' },
                    { id: 'ios-xe', name: 'IOS-XE' },
                    { id: 'nx-os', name: 'NX-OS' }
                ];
                break;
            case 'aruba':
                platforms = [
                    { id: 'aos-cx', name: 'AOS-CX' },
                    { id: 'aos-switch', name: 'AOS-Switch' }
                ];
                break;
            case 'juniper':
                platforms = [
                    { id: 'junos', name: 'JunOS' },
                    { id: 'ex', name: 'EX Series' }
                ];
                break;
            default:
                platforms = [
                    { id: 'default', name: 'Default Platform' }
                ];
        }
    }
    
    // Add options
    platforms.forEach(platform => {
        const option = document.createElement('option');
        option.value = platform.id;
        option.textContent = platform.name;
        platformSelect.appendChild(option);
    });
    
    // Select first option
    if (platforms.length > 0) {
        platformSelect.value = platforms[0].id;
        
        // Trigger change event
        const event = new Event('change');
        platformSelect.dispatchEvent(event);
    }
}

// Setup modals
function setupModals() {
    // Get all modal elements
    const modals = document.querySelectorAll('.modal-overlay');
    if (!modals.length) return;
    
    // Add click handler to close modals when clicking overlay
    modals.forEach(modal => {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('visible');
            }
        });
    });
    
    // Add ESC key handler to close modals
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
            modals.forEach(modal => {
                modal.classList.remove('visible');
            });
        }
    });
    
    // Set up export documentation modal
    const exportDocBtn = document.getElementById('export-documentation');
    if (exportDocBtn) {
        exportDocBtn.addEventListener('click', () => {
            const modal = document.getElementById('export-modal');
            if (modal) {
                modal.classList.add('visible');
            }
        });
    }
    
    // Set up export modal close button
    const exportModalClose = document.getElementById('export-modal-close');
    if (exportModalClose) {
        exportModalClose.addEventListener('click', () => {
            const modal = document.getElementById('export-modal');
            if (modal) {
                modal.classList.remove('visible');
            }
        });
    }
    
    // Set up AI assistant
    const aiButton = document.getElementById('ai-assistant-button');
    const aiPanel = document.getElementById('ai-assistant-panel');
    const aiClose = document.getElementById('ai-assistant-close');
    
    if (aiButton && aiPanel) {
        aiButton.addEventListener('click', () => {
            aiPanel.classList.toggle('visible');
        });
        
        if (aiClose) {
            aiClose.addEventListener('click', () => {
                aiPanel.classList.remove('visible');
            });
        }
    }
}
