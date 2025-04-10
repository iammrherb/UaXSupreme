/**
 * Dot1Xer Supreme Enterprise Edition - Main JavaScript
 * Version 4.0.0
 * 
 * This file contains the core functionality for the Dot1Xer Supreme application
 */

// When the DOM is loaded, initialize the application
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Dot1Xer Supreme Enterprise Edition v4.0.0');
    
    // Initialize UI components
    initTabs();
    initExpandableSections();
    initHelpIcons();
    initStepNavigation();
    initVendorGrid();
    
    // Set up event listeners for the configurator
    document.getElementById('generate-config').addEventListener('click', generateConfiguration);
    document.getElementById('copy-config').addEventListener('click', copyConfiguration);
    document.getElementById('download-config').addEventListener('click', downloadConfiguration);
    document.getElementById('analyze-config').addEventListener('click', analyzeConfiguration);
    document.getElementById('optimize-config').addEventListener('click', optimizeConfiguration);
    
    // Set up event listeners for form interactions
    setupFormInteractions();
    
    console.log('Initialization complete');
});

// Initialize tabs
function initTabs() {
    const tabs = document.querySelectorAll('.tab');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // Get target tab pane
            const target = tab.getAttribute('data-tab');
            
            // Deactivate all tabs and panes
            document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
            document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
            
            // Activate selected tab and pane
            tab.classList.add('active');
            document.getElementById(target).classList.add('active');
        });
    });
}

// Initialize expandable sections
function initExpandableSections() {
    const headers = document.querySelectorAll('.expandable-header');
    headers.forEach(header => {
        header.addEventListener('click', () => {
            // Toggle active class on header
            header.classList.toggle('active');
            
            // Toggle expanded class on content
            const content = header.nextElementSibling;
            if (content.classList.contains('expandable-content')) {
                content.classList.toggle('expanded');
            }
        });
    });
}

// Initialize help icons
function initHelpIcons() {
    const helpIcons = document.querySelectorAll('.help-icon');
    helpIcons.forEach(icon => {
        icon.addEventListener('click', (e) => {
            e.stopPropagation(); // Prevent triggering expandable section
            
            // Get help topic
            const topic = icon.getAttribute('data-help-topic');
            showHelpTopic(topic);
        });
    });
}

// Show help topic
function showHelpTopic(topic) {
    console.log('Showing help for:', topic);
    alert('Help information for: ' + topic + '\n\nThis would display detailed help in a proper implementation.');
}

// Initialize step navigation
function initStepNavigation() {
    // Next step buttons
    const nextButtons = document.querySelectorAll('.next-step');
    nextButtons.forEach(button => {
        button.addEventListener('click', () => {
            const nextTab = button.getAttribute('data-next');
            document.querySelector(`.tab[data-tab="${nextTab}"]`).click();
        });
    });
    
    // Previous step buttons
    const prevButtons = document.querySelectorAll('.prev-step');
    prevButtons.forEach(button => {
        button.addEventListener('click', () => {
            const prevTab = button.getAttribute('data-prev');
            document.querySelector(`.tab[data-tab="${prevTab}"]`).click();
        });
    });
}

// Initialize vendor grid
function initVendorGrid() {
    // Vendor selection would be populated with actual vendor logos
    const vendorGrid = document.getElementById('vendor-grid');
    if (!vendorGrid) return;
    
    // List of supported vendors
    const vendors = [
        'cisco', 'aruba', 'juniper', 'extreme', 'hp', 'fortinet', 
        'dell', 'huawei', 'ruckus', 'paloalto', 'checkpoint', 'alcatel'
    ];
    
    // Create vendor logo elements
    vendors.forEach(vendor => {
        const container = document.createElement('div');
        container.className = 'vendor-logo-container';
        container.setAttribute('data-vendor', vendor);
        
        const img = document.createElement('img');
        img.className = 'vendor-logo';
        img.src = `assets/logos/${vendor}-logo.svg`;
        img.alt = `${vendor.charAt(0).toUpperCase() + vendor.slice(1)} Logo`;
        img.onerror = function() {
            // Fallback if logo not found
            this.src = `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='100' height='50'%3E%3Crect width='100' height='50' fill='%23f0f0f0' rx='5'/%3E%3Ctext x='50' y='25' font-family='Arial' font-size='16' text-anchor='middle' dominant-baseline='middle' fill='%23333333'%3E${vendor.toUpperCase()}%3C/text%3E%3C/svg%3E`;
        };
        
        container.appendChild(img);
        vendorGrid.appendChild(container);
        
        // Add click event handler
        container.addEventListener('click', () => {
            // Remove selected class from all vendors
            document.querySelectorAll('.vendor-logo-container').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Add selected class to clicked vendor
            container.classList.add('selected');
            
            // Update platform options
            updatePlatformOptions(vendor);
        });
    });
}

// Update platform options based on vendor selection
function updatePlatformOptions(vendor) {
    const platformSelect = document.getElementById('platform-select');
    if (!platformSelect) return;
    
    // Clear existing options
    platformSelect.innerHTML = '';
    
    // Define platform options for each vendor
    const platforms = {};
    platforms.cisco = [
        {value: 'ios', text: 'IOS'},
        {value: 'ios-xe', text: 'IOS-XE'},
        {value: 'nx-os', text: 'NX-OS'},
        {value: 'wlc-9800', text: 'WLC 9800 Series'}
    ];
    platforms.aruba = [
        {value: 'aos-cx', text: 'AOS-CX'},
        {value: 'aos-switch', text: 'AOS-Switch (ProVision)'}
    ];
    platforms.juniper = [
        {value: 'junos', text: 'JunOS'},
        {value: 'mist', text: 'Mist Cloud'}
    ];
    platforms.extreme = [
        {value: 'exos', text: 'EXOS'},
        {value: 'voss', text: 'VOSS'}
    ];
    platforms.hp = [
        {value: 'procurve', text: 'ProCurve'},
        {value: 'comware', text: 'Comware'}
    ];
    platforms.fortinet = [
        {value: 'fortiswitch', text: 'FortiSwitch'},
        {value: 'fortigate', text: 'FortiGate'}
    ];
    platforms.dell = [
        {value: 'os10', text: 'OS10'},
        {value: 'os9', text: 'OS9'}
    ];
    platforms.huawei = [
        {value: 'vrp', text: 'VRP'},
        {value: 's-series', text: 'S-Series'}
    ];
    platforms.ruckus = [
        {value: 'icx', text: 'ICX'},
        {value: 'fastiron', text: 'FastIron'}
    ];
    
    // Default platforms for other vendors
    const defaultPlatforms = [
        {value: 'default', text: 'Default Platform'}
    ];
    
    // Get platforms for selected vendor or use default
    const vendorPlatforms = platforms[vendor] || defaultPlatforms;
    
    // Add platform options
    vendorPlatforms.forEach(platform => {
        const option = document.createElement('option');
        option.value = platform.value;
        option.textContent = platform.text;
        platformSelect.appendChild(option);
    });
}

// Setup form interactions
function setupFormInteractions() {
    // Toggle TACACS+ options visibility based on management authentication selection
    const tacacsRadio = document.getElementById('mgmt-tacacs');
    if (tacacsRadio) {
        tacacsRadio.addEventListener('change', function() {
            const tacacsOptions = document.querySelector('.tacacs-options');
            if (tacacsOptions) {
                tacacsOptions.style.display = this.checked ? 'block' : 'none';
            }
        });
    }
}

// Generate configuration based on user inputs
function generateConfiguration() {
    console.log('Generating configuration...');
    
    // Get selected vendor and platform
    const vendorElement = document.querySelector('.vendor-logo-container.selected');
    if (!vendorElement) {
        alert('Please select a vendor first');
        return;
    }
    
    const vendor = vendorElement.getAttribute('data-vendor');
    const platform = document.getElementById('platform-select').value;
    
    // Collect form values
    const formData = collectFormData();
    
    // Get output element
    const outputElement = document.getElementById('config-output');
    
    // Generate configuration based on vendor and platform
    let config = '';
    try {
        config = generateVendorConfig(vendor, platform, formData);
        outputElement.textContent = config;
    } catch (error) {
        console.error('Error generating configuration:', error);
        outputElement.textContent = `Error generating configuration: ${error.message}`;
    }
}

// Collect form data from all inputs
function collectFormData() {
    const formData = {};
    
    // Process text inputs and selects
    document.querySelectorAll('input[type="text"], input[type="password"], input[type="number"], select, textarea').forEach(el => {
        if (el.id) {
            formData[el.id] = el.value;
        }
    });
    
    // Process checkboxes
    document.querySelectorAll('input[type="checkbox"]').forEach(el => {
        if (el.id) {
            formData[el.id] = el.checked;
        }
    });
    
    // Process radio buttons
    document.querySelectorAll('input[type="radio"]:checked').forEach(el => {
        if (el.name) {
            formData[el.name] = el.value;
        }
    });
    
    return formData;
}

// Generate vendor-specific configuration
function generateVendorConfig(vendor, platform, formData) {
    console.log(`Generating configuration for ${vendor} ${platform}`);
    
    // For a real implementation, this would load vendor-specific templates
    // and fill in the values from formData
    
    // Simple placeholder implementation
    return `
! ${vendor.toUpperCase()} ${platform.toUpperCase()} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
! ${new Date().toISOString()}
!
! This is a placeholder configuration. In a real implementation,
! this would contain a complete, vendor-specific configuration.
!
! Authentication Method: ${formData['auth-method']}
! Host Mode: ${formData['host-mode']}
! RADIUS Server: ${formData['radius-server1']}
! VLANs: Auth=${formData['vlan-auth']}, Unauth=${formData['vlan-unauth']}
!
! See vendor-specific templates for complete configuration.
    `;
}

// Copy configuration to clipboard
function copyConfiguration() {
    const output = document.getElementById('config-output');
    if (!output.textContent.trim()) {
        alert('No configuration to copy. Generate a configuration first.');
        return;
    }
    
    // Create a temporary textarea to copy from
    const textarea = document.createElement('textarea');
    textarea.value = output.textContent;
    document.body.appendChild(textarea);
    textarea.select();
    
    try {
        document.execCommand('copy');
        alert('Configuration copied to clipboard!');
    } catch (err) {
        console.error('Failed to copy text: ', err);
        alert('Failed to copy configuration');
    }
    
    document.body.removeChild(textarea);
}

// Download configuration as a file
function downloadConfiguration() {
    const output = document.getElementById('config-output');
    if (!output.textContent.trim()) {
        alert('No configuration to download. Generate a configuration first.');
        return;
    }
    
    // Get selected vendor and platform
    const vendorElement = document.querySelector('.vendor-logo-container.selected');
    const vendor = vendorElement ? vendorElement.getAttribute('data-vendor') : 'generic';
    const platform = document.getElementById('platform-select').value || 'default';
    
    // Create filename
    const filename = `${vendor}-${platform}-dot1x-config.txt`;
    
    // Create download link
    const link = document.createElement('a');
    link.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(output.textContent));
    link.setAttribute('download', filename);
    link.style.display = 'none';
    
    // Add to document, click, and remove
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
}

// Analyze configuration for potential issues
function analyzeConfiguration() {
    const output = document.getElementById('config-output');
    if (!output.textContent.trim()) {
        alert('No configuration to analyze. Generate a configuration first.');
        return;
    }
    
    // Get analysis element
    const analysisElement = document.getElementById('config-analysis');
    
    // Perform analysis
    const analysisResults = [
        { type: 'success', message: 'RADIUS server configuration is valid' },
        { type: 'info', message: 'Consider adding a secondary RADIUS server for redundancy' },
        { type: 'warning', message: 'Authentication mode is set to "open" which is less secure but good for initial deployments' },
        { type: 'danger', message: 'No VLAN configuration specified for authenticated devices' }
    ];
    
    // Display analysis results
    analysisElement.innerHTML = '';
    analysisResults.forEach(result => {
        const item = document.createElement('div');
        item.className = `alert alert-${result.type}`;
        item.textContent = result.message;
        analysisElement.appendChild(item);
    });
    
    // Show analysis section
    const analysisHeader = document.querySelector('.expandable-header:nth-of-type(2)');
    const analysisContent = document.querySelector('.expandable-content:nth-of-type(2)');
    
    if (analysisHeader && !analysisHeader.classList.contains('active')) {
        analysisHeader.click();
    }
}

// Use AI to optimize configuration
function optimizeConfiguration() {
    alert('This feature would use AI to optimize your configuration based on industry best practices. In a complete implementation, it would connect to an AI service.');
}
