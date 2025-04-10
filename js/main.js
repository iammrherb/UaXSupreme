/**
 * Dot1Xer Supreme Enterprise Edition - Main JavaScript
 * Version 4.0.0
 */

// Global object for application
const Dot1Xer = {
    // Current settings
    settings: {
        vendor: '',
        platform: '',
        authMethod: 'dot1x',
        hostMode: 'multi-auth',
        radiusServer1: '',
        radiusSecret1: '',
        radiusServer2: '',
        radiusSecret2: '',
        authVlan: '',
        unauthVlan: '',
        guestVlan: '',
        voiceVlan: '',
        criticalVlan: '',
        reauthPeriod: 3600,
        txPeriod: 30,
        quietPeriod: 60,
        maxReauth: 2,
        interface: '',
        interfaceRange: '',
        deploymentMode: 'monitor'
    },
    
    // Initialize application
    init: function() {
        console.log('Initializing Dot1Xer Supreme v4.0.0...');
        
        // Initialize UI components
        this.initTabs();
        this.initExpandableSections();
        this.initVendorGrid();
        this.initFormHandlers();
        this.initButtons();
        this.initHelpTooltips();
        
        console.log('Initialization complete');
    },
    
    // Initialize tabs
    initTabs: function() {
        const tabs = document.querySelectorAll('.tab');
        
        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                // Remove active class from all tabs
                tabs.forEach(t => t.classList.remove('active'));
                
                // Add active class to clicked tab
                tab.classList.add('active');
                
                // Get tab content ID
                const tabContent = tab.textContent.trim().toLowerCase();
                
                // Hide all tab panes
                document.querySelectorAll('.tab-pane').forEach(pane => {
                    pane.style.display = 'none';
                });
                
                // Show selected tab pane
                const tabPane = document.getElementById(tabContent);
                if (tabPane) {
                    tabPane.style.display = 'block';
                }
            });
        });
        
        // Activate first tab by default
        if (tabs.length > 0 && !document.querySelector('.tab.active')) {
            tabs[0].click();
        }
    },
    
    // Initialize expandable sections
    initExpandableSections: function() {
        const headers = document.querySelectorAll('.expandable-header');
        
        headers.forEach(header => {
            header.addEventListener('click', () => {
                // Toggle active class
                header.classList.toggle('active');
                
                // Toggle content visibility
                const content = header.nextElementSibling;
                if (content && content.classList.contains('expandable-content')) {
                    if (content.style.display === 'block') {
                        content.style.display = 'none';
                    } else {
                        content.style.display = 'block';
                    }
                }
            });
        });
        
        // Open the first expandable section by default
        if (headers.length > 0) {
            headers[0].click();
        }
    },
    
    // Initialize vendor grid
    initVendorGrid: function() {
        const vendors = [
            'cisco', 'aruba', 'juniper', 'fortinet', 'extreme', 
            'hp', 'dell', 'huawei', 'ruckus', 'paloalto', 'checkpoint'
        ];
        
        const vendorSection = document.querySelector('#vendor-selection .expandable-content');
        if (!vendorSection) return;
        
        // Create vendor grid
        const grid = document.createElement('div');
        grid.className = 'vendor-grid';
        
        // Add vendor options
        vendors.forEach(vendor => {
            const vendorItem = document.createElement('div');
            vendorItem.className = 'vendor-logo-container';
            vendorItem.setAttribute('data-vendor', vendor);
            
            // Add vendor logo or text
            const logo = document.createElement('img');
            logo.src = `assets/logos/${vendor}-logo.svg`;
            logo.alt = vendor.toUpperCase();
            logo.className = 'vendor-logo';
            logo.onerror = function() {
                this.onerror = null;
                this.src = `data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='120' height='60'%3E%3Crect width='120' height='60' fill='%23f0f0f0' rx='4'/%3E%3Ctext x='60' y='30' font-family='Arial' font-size='16' text-anchor='middle' dominant-baseline='middle' fill='%23333333'%3E${vendor.toUpperCase()}%3C/text%3E%3C/svg%3E`;
            };
            
            vendorItem.appendChild(logo);
            
            // Add click handler
            vendorItem.addEventListener('click', () => {
                // Remove selected class from all vendors
                document.querySelectorAll('.vendor-logo-container').forEach(v => {
                    v.classList.remove('selected');
                });
                
                // Add selected class to clicked vendor
                vendorItem.classList.add('selected');
                
                // Update selected vendor
                Dot1Xer.settings.vendor = vendor;
                
                // Update platform options
                Dot1Xer.updatePlatformOptions(vendor);
            });
            
            grid.appendChild(vendorItem);
        });
        
        // Add grid to vendor section
        vendorSection.innerHTML = '';
        vendorSection.appendChild(grid);
    },
    
    // Update platform options based on selected vendor
    updatePlatformOptions: function(vendor) {
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
        
        // Update selected platform
        if (vendorPlatforms.length > 0) {
            Dot1Xer.settings.platform = vendorPlatforms[0].value;
        }
        
        // Display platform details section
        const platformDetails = document.querySelector('#platform-details');
        if (platformDetails) {
            platformDetails.style.display = 'block';
        }
    },
    
    // Initialize form handlers
    initFormHandlers: function() {
        // Handle form input changes
        document.querySelectorAll('input, select, textarea').forEach(input => {
            if (input.id) {
                input.addEventListener('change', () => {
                    // Convert kebab-case to camelCase
                    const key = input.id.replace(/-([a-z])/g, g => g[1].toUpperCase());
                    
                    // Get input value
                    let value = input.value;
                    if (input.type === 'checkbox') {
                        value = input.checked;
                    } else if (input.type === 'number') {
                        value = parseInt(value, 10);
                    }
                    
                    // Update settings
                    if (Dot1Xer.settings.hasOwnProperty(key)) {
                        Dot1Xer.settings[key] = value;
                        console.log(`Updated ${key}: ${value}`);
                    }
                });
            }
        });
        
        // Handle platform select
        const platformSelect = document.getElementById('platform-select');
        if (platformSelect) {
            platformSelect.addEventListener('change', () => {
                Dot1Xer.settings.platform = platformSelect.value;
                console.log(`Selected platform: ${platformSelect.value}`);
            });
        }
    },
    
    // Initialize buttons
    initButtons: function() {
        // Next/Previous step buttons
        document.querySelectorAll('.next-step').forEach(button => {
            button.addEventListener('click', () => {
                const currentTab = document.querySelector('.tab.active');
                const tabs = Array.from(document.querySelectorAll('.tab'));
                const currentIndex = tabs.indexOf(currentTab);
                
                if (currentIndex < tabs.length - 1) {
                    tabs[currentIndex + 1].click();
                }
            });
        });
        
        document.querySelectorAll('.prev-step').forEach(button => {
            button.addEventListener('click', () => {
                const currentTab = document.querySelector('.tab.active');
                const tabs = Array.from(document.querySelectorAll('.tab'));
                const currentIndex = tabs.indexOf(currentTab);
                
                if (currentIndex > 0) {
                    tabs[currentIndex - 1].click();
                }
            });
        });
        
        // Generate configuration button
        const generateBtn = document.getElementById('generate-config');
        if (generateBtn) {
            generateBtn.addEventListener('click', () => {
                Dot1Xer.generateConfiguration();
            });
        }
        
        // Copy configuration button
        const copyBtn = document.getElementById('copy-config');
        if (copyBtn) {
            copyBtn.addEventListener('click', () => {
                Dot1Xer.copyConfiguration();
            });
        }
        
        // Download configuration button
        const downloadBtn = document.getElementById('download-config');
        if (downloadBtn) {
            downloadBtn.addEventListener('click', () => {
                Dot1Xer.downloadConfiguration();
            });
        }
        
        // Analyze configuration button
        const analyzeBtn = document.getElementById('analyze-config');
        if (analyzeBtn) {
            analyzeBtn.addEventListener('click', () => {
                Dot1Xer.analyzeConfiguration();
            });
        }
    },
    
    // Initialize help tooltips
    initHelpTooltips: function() {
        document.querySelectorAll('.help-icon').forEach(icon => {
            icon.addEventListener('click', event => {
                event.stopPropagation(); // Prevent expandable section toggle
                
                const topic = icon.getAttribute('data-help-topic');
                alert(`Help for: ${topic}\n\nThis would display detailed help information for the selected topic.`);
            });
        });
    },
    
    // Generate configuration
    generateConfiguration: function() {
        console.log('Generating configuration with settings:', this.settings);
        
        // Get output element
        const outputEl = document.getElementById('config-output');
        if (!outputEl) return;
        
        // Check if vendor and platform are selected
        if (!this.settings.vendor) {
            outputEl.textContent = "Please select a vendor first.";
            return;
        }
        
        if (!this.settings.platform) {
            outputEl.textContent = "Please select a platform.";
            return;
        }
        
        // Generate configuration based on vendor and platform
        let config = this.generateVendorConfig();
        
        // Display configuration
        outputEl.textContent = config;
    },
    
    // Generate vendor-specific configuration
    generateVendorConfig: function() {
        const vendor = this.settings.vendor;
        const platform = this.settings.platform;
        
        // This is a simplified template - in a real implementation,
        // this would load vendor-specific templates from the server
        return `! ${vendor.toUpperCase()} ${platform.toUpperCase()} 802.1X Configuration
! Generated by Dot1Xer Supreme Enterprise Edition v4.0.0
! ${new Date().toISOString()}

! RADIUS Server Configuration
${vendor === 'cisco' && (platform === 'ios' || platform === 'ios-xe') ? 
`radius server ${this.settings.radiusServer1 || 'PRIMARY'}
 address ipv4 ${this.settings.radiusServer1 || '10.1.1.1'} auth-port 1812 acct-port 1813
 key ${this.settings.radiusSecret1 || 'radiuskey1'}

${this.settings.radiusServer2 ? 
`radius server ${this.settings.radiusServer2 || 'SECONDARY'}
 address ipv4 ${this.settings.radiusServer2 || '10.1.1.2'} auth-port 1812 acct-port 1813
 key ${this.settings.radiusSecret2 || 'radiuskey2'}
` : ''}` : '# RADIUS server configuration would be here'}

! Authentication Method: ${this.settings.authMethod}
! Host Mode: ${this.settings.hostMode}
! Authentication VLAN: ${this.settings.authVlan || 'Not configured'}
! Unauthenticated VLAN: ${this.settings.unauthVlan || 'Not configured'}
${this.settings.guestVlan ? `! Guest VLAN: ${this.settings.guestVlan}` : ''}
${this.settings.voiceVlan ? `! Voice VLAN: ${this.settings.voiceVlan}` : ''}

! Note: This is a placeholder configuration.
! A full implementation would generate complete vendor-specific syntax.

! Authentication parameters:
! Reauthentication period: ${this.settings.reauthPeriod} seconds
! Transmit period: ${this.settings.txPeriod} seconds
! Quiet period: ${this.settings.quietPeriod} seconds
! Maximum retries: ${this.settings.maxReauth}

! Interface configuration would be added here
${this.settings.interface ? `! Interface: ${this.settings.interface}` : ''}
${this.settings.interfaceRange ? `! Interface range: ${this.settings.interfaceRange}` : ''}

! Deployment mode: ${this.settings.deploymentMode}
`;
    },
    
    // Copy configuration to clipboard
    copyConfiguration: function() {
        const outputEl = document.getElementById('config-output');
        if (!outputEl || !outputEl.textContent.trim()) {
            alert('No configuration to copy. Generate configuration first.');
            return;
        }
        
        // Copy to clipboard
        navigator.clipboard.writeText(outputEl.textContent)
            .then(() => {
                alert('Configuration copied to clipboard!');
            })
            .catch(err => {
                console.error('Failed to copy:', err);
                alert('Failed to copy configuration. Please try again.');
            });
    },
    
    // Download configuration as text file
    downloadConfiguration: function() {
        const outputEl = document.getElementById('config-output');
        if (!outputEl || !outputEl.textContent.trim()) {
            alert('No configuration to download. Generate configuration first.');
            return;
        }
        
        // Create filename
        const vendor = this.settings.vendor || 'generic';
        const platform = this.settings.platform || 'default';
        const filename = `${vendor}-${platform}-dot1x-config.txt`;
        
        // Create download link
        const blob = new Blob([outputEl.textContent], {type: 'text/plain'});
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        
        // Trigger download
        document.body.appendChild(a);
        a.click();
        
        // Clean up
        setTimeout(() => {
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        }, 100);
    },
    
    // Analyze configuration
    analyzeConfiguration: function() {
        const outputEl = document.getElementById('config-output');
        if (!outputEl || !outputEl.textContent.trim()) {
            alert('No configuration to analyze. Generate configuration first.');
            return;
        }
        
        // Get analysis element
        const analysisEl = document.getElementById('config-analysis');
        if (!analysisEl) return;
        
        // Clear previous analysis
        analysisEl.innerHTML = '';
        
        // Add analysis items
        const addAnalysisItem = (type, message) => {
            const item = document.createElement('div');
            item.className = `alert alert-${type}`;
            item.textContent = message;
            analysisEl.appendChild(item);
        };
        
        // Perform simple analysis
        if (!this.settings.radiusServer1) {
            addAnalysisItem('danger', 'No primary RADIUS server configured');
        } else {
            addAnalysisItem('success', 'Primary RADIUS server is configured');
        }
        
        if (!this.settings.radiusServer2) {
            addAnalysisItem('warning', 'No secondary RADIUS server configured for redundancy');
        } else {
            addAnalysisItem('success', 'Secondary RADIUS server is configured for redundancy');
        }
        
        if (!this.settings.authVlan) {
            addAnalysisItem('warning', 'No authentication VLAN configured');
        }
        
        if (!this.settings.unauthVlan) {
            addAnalysisItem('warning', 'No unauthenticated VLAN configured');
        }
        
        if (this.settings.authMethod === 'dot1x-mab' && this.settings.hostMode === 'single-host') {
            addAnalysisItem('warning', 'Using MAB with single-host mode may cause disconnects when multiple devices are present');
        }
        
        // Make analysis section visible
        const analysisHeader = document.querySelector('#config-analysis-section .expandable-header');
        if (analysisHeader && !analysisHeader.classList.contains('active')) {
            analysisHeader.click();
        }
    }
};

// Initialize application when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    Dot1Xer.init();
});
