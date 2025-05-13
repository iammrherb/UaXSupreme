/**
 * Dot1Xer Supreme Enterprise Edition - Main Application
 * Version 4.2.0
 */

// Ensure vendors.js is loaded first
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Dot1Xer Supreme Enterprise Edition v4.2.0...');
    
    // Create the alert container
    createAlertContainer();
    
    // Load critical modules first
    loadVendorsModule(function() {
        // Then load other functionality
        loadAndApplySettings();
        initModals();
        showWelcomeMessage();
        
        // Initialize the vendor selection if we're on that page
        const vendorGrid = document.getElementById('vendor-grid');
        if (vendorGrid) {
            console.log('Vendor grid found, initializing...');
            if (typeof initVendorGrid === 'function') {
                initVendorGrid();
                setupVendorSelection();
                selectDefaultVendor();
            } else {
                console.error('Vendor grid functions not available yet');
            }
        }
  // Initialize Portnox diagram UI
  if (typeof DiagramUI !== "undefined") {
    DiagramUI.initialize();
  }
    });
});

// Load vendors.js first
function loadVendorsModule(callback) {
    // Check if vendors.js is already loaded
    if (typeof vendors !== 'undefined') {
        console.log('Vendors module already loaded');
        callback();
        return;
    }
    
    console.log('Loading vendors module...');
    const script = document.createElement('script');
    script.src = 'js/vendors.js';
    script.onload = function() {
        console.log('Vendors module loaded successfully');
        callback();
    };
    script.onerror = function() {
        console.error('Failed to load vendors module');
        callback();
    };
    document.head.appendChild(script);
}

// Create alert container
function createAlertContainer() {
    if (!document.getElementById('alert-container')) {
        const alertContainer = document.createElement('div');
        alertContainer.id = 'alert-container';
        alertContainer.style.position = 'fixed';
        alertContainer.style.top = '20px';
        alertContainer.style.right = '20px';
        alertContainer.style.zIndex = '9999';
        alertContainer.style.maxWidth = '400px';
        document.body.appendChild(alertContainer);
    }
}

// Load and apply settings
function loadAndApplySettings() {
    const savedSettings = localStorage.getItem('dot1xer_settings');
    
    if (savedSettings) {
        try {
            const settings = JSON.parse(savedSettings);
            applySettings(settings);
        } catch (error) {
            console.error('Error loading settings:', error);
        }
    }
}

// Apply settings
function applySettings(settings) {
    // Apply theme
    if (settings.theme === 'dark') {
        document.body.classList.add('dark-theme');
    } else {
        document.body.classList.remove('dark-theme');
    }
    
    // Apply font size
    document.body.classList.remove('font-small', 'font-medium', 'font-large');
    document.body.classList.add(`font-${settings.fontSize || 'medium'}`);
}

// Initialize modals
function initModals() {
    // Close modals when clicking outside
    document.addEventListener('click', function(event) {
        if (event.target.classList.contains('modal') && event.target.classList.contains('visible')) {
            event.target.classList.remove('visible');
        }
    });
    
    // Stop propagation on modal dialog clicks
    document.querySelectorAll('.modal-dialog').forEach(dialog => {
        dialog.addEventListener('click', function(event) {
            event.stopPropagation();
        });
    });
}

// Show welcome message
function showWelcomeMessage() {
    const lastVisit = localStorage.getItem('dot1xer_last_visit');
    const now = new Date().toISOString();
    
    // Show welcome message if first visit or not visited today
    if (!lastVisit || !isSameDay(new Date(lastVisit), new Date())) {
        showAlert('Welcome to Dot1Xer Supreme Enterprise Edition v4.2.0! Select a vendor and platform to get started.', 'info');
    }
    
    // Update last visit
    localStorage.setItem('dot1xer_last_visit', now);
}

// Check if two dates are the same day
function isSameDay(date1, date2) {
    return date1.getFullYear() === date2.getFullYear() &&
           date1.getMonth() === date2.getMonth() &&
           date1.getDate() === date2.getDate();
}

// Global alert function
window.showAlert = function(message, type = 'info') {
    // Create alert container if it doesn't exist
    createAlertContainer();
    
    // Get alert container
    const alertContainer = document.getElementById('alert-container');
    
    // Create alert element
    const alert = document.createElement('div');
    alert.className = `alert alert-${type}`;
    alert.style.marginBottom = '10px';
    alert.style.padding = '15px';
    alert.style.borderRadius = '4px';
    alert.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
    alert.style.position = 'relative';
    alert.style.opacity = '0';
    alert.style.transform = 'translateX(50px)';
    alert.style.transition = 'opacity 0.3s, transform 0.3s';
    
    // Apply type-specific styles
    switch (type) {
        case 'success':
            alert.style.backgroundColor = '#d4edda';
            alert.style.color = '#155724';
            alert.style.borderColor = '#c3e6cb';
            break;
        case 'warning':
            alert.style.backgroundColor = '#fff3cd';
            alert.style.color = '#856404';
            alert.style.borderColor = '#ffeeba';
            break;
        case 'danger':
            alert.style.backgroundColor = '#f8d7da';
            alert.style.color = '#721c24';
            alert.style.borderColor = '#f5c6cb';
            break;
        default: // info
            alert.style.backgroundColor = '#d1ecf1';
            alert.style.color = '#0c5460';
            alert.style.borderColor = '#bee5eb';
            break;
    }
    
    // Close button
    const closeButton = document.createElement('span');
    closeButton.innerHTML = '&times;';
    closeButton.style.position = 'absolute';
    closeButton.style.top = '10px';
    closeButton.style.right = '10px';
    closeButton.style.cursor = 'pointer';
    closeButton.style.fontWeight = 'bold';
    closeButton.addEventListener('click', () => {
        alert.style.opacity = '0';
        alert.style.transform = 'translateX(50px)';
        setTimeout(() => alert.remove(), 300);
    });
    
    alert.textContent = message;
    alert.appendChild(closeButton);
    alertContainer.appendChild(alert);
    
    // Show the alert with animation
    setTimeout(() => {
        alert.style.opacity = '1';
        alert.style.transform = 'translateX(0)';
    }, 10);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alert.parentNode) {
            alert.style.opacity = '0';
            alert.style.transform = 'translateX(50px)';
            setTimeout(() => {
                if (alert.parentNode) {
                    alert.remove();
                }
            }, 300);
        }
    }, 5000);
};
