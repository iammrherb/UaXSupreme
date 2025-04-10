/**
 * Dot1Xer Supreme Enterprise Edition - Main JavaScript
 * Version 4.0.0
 * 
 * This file handles core functionality including initialization,
 * UI management, and application bootstrapping.
 */

// Main application object
const Dot1Xer = {
    // Application version
    version: '4.0.0',
    
    // Configuration object
    config: {},
    
    // Saved configurations
    savedConfigs: [],
    
    // Current vendor theme
    currentVendorTheme: '',
    
    // Initialization function
    init: function() {
        console.log('Initializing Dot1Xer Supreme Enterprise Edition v' + this.version);
        
        // Load saved configurations from localStorage
        this.loadSavedConfigurations();
        
        // Load components
        this.loadUI();
        this.setupEventHandlers();
        this.loadVendors();
        this.initHelp();
        this.initAI();
        
        // Set default form values from previous session if available
        this.loadLastSession();
        
        console.log('Initialization complete');
    },
    
    // Load UI components
    loadUI: function() {
        console.log('Loading UI components...');
        
        // Set up theme handler
        document.addEventListener('vendorChange', (event) => {
            const vendor = event.detail.vendor;
            this.setVendorTheme(vendor);
        });
    },
    
    // Set up event handlers
    setupEventHandlers: function() {
        console.log('Setting up event handlers...');
        
        // Export documentation button
        const exportButton = document.getElementById('export-documentation');
        if (exportButton) {
            exportButton.addEventListener('click', () => {
                // Show export modal
                const modal = document.getElementById('export-modal');
                if (modal) modal.classList.add('visible');
            });
        }
        
        // Export modal close button
        const exportModalClose = document.getElementById('export-modal-close');
        if (exportModalClose) {
            exportModalClose.addEventListener('click', () => {
                // Hide export modal
                const modal = document.getElementById('export-modal');
                if (modal) modal.classList.remove('visible');
            });
        }
        
        // Export cancel button
        const exportCancel = document.getElementById('export-cancel');
        if (exportCancel) {
            exportCancel.addEventListener('click', () => {
                // Hide export modal
                const modal = document.getElementById('export-modal');
                if (modal) modal.classList.remove('visible');
            });
        }
        
        // Help link
        const helpLink = document.getElementById('help-link');
        if (helpLink) {
            helpLink.addEventListener('click', (e) => {
                e.preventDefault();
                this.showHelp();
            });
        }
        
        // Footer help link
        const helpFooter = document.getElementById('help-footer');
        if (helpFooter) {
            helpFooter.addEventListener('click', (e) => {
                e.preventDefault();
                this.showHelp();
            });
        }
        
        // About link
        const aboutLink = document.getElementById('about-link');
        if (aboutLink) {
            aboutLink.addEventListener('click', (e) => {
                e.preventDefault();
                this.showAbout();
            });
        }
        
        // Footer about link
        const aboutFooter = document.getElementById('about-footer');
        if (aboutFooter) {
            aboutFooter.addEventListener('click', (e) => {
                e.preventDefault();
                this.showAbout();
            });
        }
        
        // Updates link
        const updatesFooter = document.getElementById('updates-footer');
        if (updatesFooter) {
            updatesFooter.addEventListener('click', (e) => {
                e.preventDefault();
                this.checkForUpdates();
            });
        }
    },
    
    // Load vendor information
    loadVendors: function() {
        console.log('Loading vendor information...');
        // This functionality is implemented in vendors.js
    },
    
    // Initialize help system
    initHelp: function() {
        console.log('Initializing help system...');
        // This functionality is implemented in help.js
    },
    
    // Initialize AI integration
    initAI: function() {
        console.log('Initializing AI integration...');
        
        // Initialize AI with settings
        if (window.AIAssistant && typeof window.AIAssistant.init === 'function') {
            const aiSettings = this.loadAISettings();
            window.AIAssistant.init(aiSettings);
        } else {
            console.log('AI Assistant not available or init method missing');
        }
    },
    
    // Load AI settings from localStorage
    loadAISettings: function() {
        try {
            const saved = localStorage.getItem('dot1xer_ai_settings');
            if (saved) {
                return JSON.parse(saved);
            }
        } catch (e) {
            console.error('Error loading AI settings:', e);
        }
        
        // Return default settings if none saved
        return {
            provider: 'local',
            apiKeys: {}
        };
    },
    
    // Set vendor theme
    setVendorTheme: function(vendor) {
        if (!vendor) return;
        
        // Remove previous vendor theme
        if (this.currentVendorTheme) {
            document.body.classList.remove(`${this.currentVendorTheme}-theme`);
            document.body.removeAttribute('data-vendor-theme');
        }
        
        // Set new vendor theme
        document.body.classList.add(`${vendor}-theme`);
        document.body.setAttribute('data-vendor-theme', vendor);
        this.currentVendorTheme = vendor;
        
        console.log(`Vendor theme set to: ${vendor}`);
    },
    
    // Load saved configurations
    loadSavedConfigurations: function() {
        try {
            const saved = localStorage.getItem('dot1xer_saved_configs');
            if (saved) {
                this.savedConfigs = JSON.parse(saved);
                console.log(`Loaded ${this.savedConfigs.length} saved configurations`);
            }
        } catch (e) {
            console.error('Error loading saved configurations:', e);
            this.savedConfigs = [];
        }
    },
    
    // Save a new configuration
    saveConfiguration: function(name, config) {
        // Create a configuration object
        const savedConfig = {
            name: name,
            date: new Date().toISOString(),
            config: config,
            vendor: config.vendor,
            platform: config.platform
        };
        
        // Add to saved configs
        this.savedConfigs.push(savedConfig);
        
        // Save to localStorage
        try {
            localStorage.setItem('dot1xer_saved_configs', JSON.stringify(this.savedConfigs));
            console.log(`Configuration "${name}" saved successfully`);
            return true;
        } catch (e) {
            console.error('Error saving configuration:', e);
            return false;
        }
    },
    
    // Load session from localStorage
    loadLastSession: function() {
        try {
            const lastSession = localStorage.getItem('dot1xer_last_session');
            if (lastSession) {
                const session = JSON.parse(lastSession);
                
                // Apply session values to form fields
                for (const [key, value] of Object.entries(session)) {
                    const element = document.getElementById(key);
                    if (element) {
                        if (element.type === 'checkbox') {
                            element.checked = value;
                        } else if (element.type === 'radio') {
                            if (element.value === value) {
                                element.checked = true;
                            }
                        } else {
                            element.value = value;
                        }
                    }
                }
                
                console.log('Last session restored');
            }
        } catch (e) {
            console.error('Error loading last session:', e);
        }
    },
    
    // Save current session to localStorage
    saveSession: function() {
        const session = {};
        
        // Collect form field values
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            const elements = form.elements;
            for (let i = 0; i < elements.length; i++) {
                const element = elements[i];
                if (element.id) {
                    if (element.type === 'checkbox') {
                        session[element.id] = element.checked;
                    } else if (element.type === 'radio') {
                        if (element.checked) {
                            session[element.name] = element.value;
                        }
                    } else {
                        session[element.id] = element.value;
                    }
                }
            }
        });
        
        // Save to localStorage
        try {
            localStorage.setItem('dot1xer_last_session', JSON.stringify(session));
            console.log('Session saved');
        } catch (e) {
            console.error('Error saving session:', e);
        }
    },
    
    // Show help panel
    showHelp: function() {
        console.log('Showing help panel...');
        // This functionality is implemented in help.js
        if (window.HelpSystem && typeof window.HelpSystem.showHelpPanel === 'function') {
            window.HelpSystem.showHelpPanel();
        } else {
            alert('Help system is being loaded. Please try again in a moment.');
        }
    },
    
    // Show about dialog
    showAbout: function() {
        alert(`Dot1Xer Supreme Enterprise Edition\nVersion ${this.version}\n\nA comprehensive 802.1X configuration and documentation platform supporting multiple vendors, advanced security features, and complete deployment assistance.`);
    },
    
    // Check for updates
    checkForUpdates: function() {
        console.log('Checking for updates...');
        
        // In a real implementation, this would call an API to check for updates
        setTimeout(() => {
            alert(`You are running the latest version of Dot1Xer Supreme Enterprise Edition (v${this.version}).`);
        }, 500);
    }
};

// Initialize application when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    Dot1Xer.init();
});

// Save session before page unload
window.addEventListener('beforeunload', function() {
    Dot1Xer.saveSession();
});
