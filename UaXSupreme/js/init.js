/**
 * Dot1Xer Supreme Enterprise Edition - Initialization
 * Version 4.2.0
 */

// This is executed immediately when the script loads
(function() {
    console.log('Loading initialization script...');
    
    // Load our critical modules first
    loadScript('js/vendors.js', function() {
        // Then load the rest of our functionality
        loadScript('js/ui.js');
        loadScript('js/tooltips.js');
        loadScript('js/config-generator.js');
        loadScript('js/checklist-handler.js');
        loadScript('js/questionnaire.js');
        loadScript('js/diagrams.js');
        
        // Initialize the application when DOM is ready
        document.addEventListener('DOMContentLoaded', initApplication);
    });
})();

// Load a script dynamically
function loadScript(src, callback) {
    const script = document.createElement('script');
    script.src = src;
    
    if (callback) {
        script.onload = callback;
    }
    
    script.onerror = function() {
        console.error('Failed to load script:', src);
    };
    
    document.head.appendChild(script);
}

// Initialize the application
function initApplication() {
    console.log('Initializing application...');
    
    // Ensure vendor grid is initialized if it exists on the page
    const vendorGrid = document.getElementById('vendor-grid');
    if (vendorGrid && typeof initVendorGrid === 'function') {
        console.log('Initializing vendor grid...');
        initVendorGrid();
        setupVendorSelection();
        
        // Select default vendor after a short delay
        setTimeout(function() {
            const savedVendor = localStorage.getItem('selectedVendor') || 'cisco';
            if (window.vendors && window.vendors[savedVendor]) {
                selectVendor(savedVendor);
            }
        }, 300);
    }
    
    // Initialize expandable sections
    initExpandableSections();
    
    // Initialize tab navigation
    initTabNavigation();
}

// Initialize expandable sections
function initExpandableSections() {
    const expandableHeaders = document.querySelectorAll('.expandable-header');
    expandableHeaders.forEach(header => {
        header.addEventListener('click', function() {
            this.classList.toggle('expanded');
            const content = this.nextElementSibling;
            if (content && content.classList.contains('expandable-content')) {
                content.classList.toggle('expanded');
            }
        });
    });
}

// Initialize tab navigation
function initTabNavigation() {
    const tabs = document.querySelectorAll('.tab');
    const tabPanes = document.querySelectorAll('.tab-pane');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', function() {
            const tabId = this.getAttribute('data-tab');
            
            // Remove active class from all tabs and tab panes
            tabs.forEach(t => t.classList.remove('active'));
            tabPanes.forEach(pane => pane.classList.remove('active'));
            
            // Add active class to clicked tab and corresponding tab pane
            this.classList.add('active');
            const targetPane = document.getElementById(tabId);
            if (targetPane) {
                targetPane.classList.add('active');
            }
        });
    });
}
