/**
 * Dot1Xer Supreme Enterprise Edition - UI Initialization
 * Version 3.0.0
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
    
    // Setup AI assistant
    setupAIAssistant();
    
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
            tabs.forEach(t => t.classList.remove('active'));
            
            // Add active class to clicked tab
            tab.classList.add('active');
            
            // Hide all tab panes
            const tabPanes = document.querySelectorAll('.tab-pane');
            tabPanes.forEach(pane => pane.classList.remove('active'));
            
            // Show selected tab pane
            const selectedPane = document.getElementById(tabId);
            if (selectedPane) {
                selectedPane.classList.add('active');
            }
        });
    });
}

// Load vendor grid
function loadVendorGrid() {
    const vendorGrid = document.getElementById('vendor-grid');
    if (!vendorGrid) return;
    
    // List of vendors to display
    const vendors = [
        'cisco', 'aruba', 'juniper', 'hp', 'fortinet', 'extreme', 
        'huawei', 'dell', 'arista', 'ubiquiti', 'ruckus', 'meraki'
    ];
    
    // Clear grid
    vendorGrid.innerHTML = '';
    
    // Add vendor logos
    vendors.forEach(vendor => {
        const vendorContainer = document.createElement('div');
        vendorContainer.className = 'vendor-logo-container';
        vendorContainer.setAttribute('data-vendor', vendor);
        
        const vendorLogo = document.createElement('img');
        vendorLogo.className = 'vendor-logo';
        vendorLogo.src = `assets/logos/${vendor}-logo.svg`;
        vendorLogo.alt = `${vendor.charAt(0).toUpperCase() + vendor.slice(1)} Logo`;
        vendorLogo.onerror = function() {
            this.onerror = null;
            this.src = `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='140' height='80'%3E%3Crect width='140' height='80' fill='%23f0f0f0' rx='5'/%3E%3Ctext x='70' y='40' font-family='Arial' font-size='16' text-anchor='middle' dominant-baseline='middle' fill='%23333333'%3E${vendor.toUpperCase()}%3C/text%3E%3C/svg%3E`;
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
            
            // Trigger vendor change event
            const event = new CustomEvent('vendorChange', { detail: { vendor } });
            document.dispatchEvent(event);
        });
    });
}

// Setup AI assistant
function setupAIAssistant() {
    const aiButton = document.getElementById('ai-assistant-button');
    const aiPanel = document.getElementById('ai-assistant-panel');
    const aiClose = document.getElementById('ai-assistant-close');
    const aiSend = document.getElementById('ai-assistant-send');
    const aiInput = document.getElementById('ai-assistant-input');
    const aiBody = document.getElementById('ai-assistant-body');
    
    if (!aiButton || !aiPanel || !aiClose || !aiSend || !aiInput || !aiBody) return;
    
    // Toggle AI panel
    aiButton.addEventListener('click', () => {
        aiPanel.classList.toggle('visible');
        if (aiPanel.classList.contains('visible')) {
            aiInput.focus();
        }
    });
    
    // Close AI panel
    aiClose.addEventListener('click', () => {
        aiPanel.classList.remove('visible');
    });
    
    // Send message
    function sendMessage() {
        const message = aiInput.value.trim();
        if (!message) return;
        
        // Add user message
        const userMessage = document.createElement('div');
        userMessage.className = 'ai-message user';
        userMessage.textContent = message;
        aiBody.appendChild(userMessage);
        
        // Clear input
        aiInput.value = '';
        
        // Scroll to bottom
        aiBody.scrollTop = aiBody.scrollHeight;
        
        // For this basic implementation, just respond with a placeholder message
        setTimeout(() => {
            const assistantMessage = document.createElement('div');
            assistantMessage.className = 'ai-message assistant';
            assistantMessage.textContent = `I'll help you with "${message}" shortly. AI assistance is being implemented.`;
            aiBody.appendChild(assistantMessage);
            
            // Scroll to bottom
            aiBody.scrollTop = aiBody.scrollHeight;
        }, 1000);
    }
    
    // Send button click
    aiSend.addEventListener('click', sendMessage);
    
    // Enter key press
    aiInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            sendMessage();
        }
    });
}
