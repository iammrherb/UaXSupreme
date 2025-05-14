/**
 * UaXSupreme - Main Application
 * Controls the main application flow and UI
 */

(function() {
    'use strict';

    // Application object
    const App = {
        /**
         * Initialize application
         */
        init: function() {
            console.log('Initializing UaXSupreme Application...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Nav steps
            const navSteps = document.querySelectorAll('.nav-steps li');
            navSteps.forEach(step => {
                step.addEventListener('click', this.changeSection.bind(this));
            });
            
            // Next/Back buttons
            const nextButtons = document.querySelectorAll('.btn-next');
            nextButtons.forEach(button => {
                button.addEventListener('click', this.nextSection.bind(this));
            });
            
            const backButtons = document.querySelectorAll('.btn-back');
            backButtons.forEach(button => {
                button.addEventListener('click', this.prevSection.bind(this));
            });
            
            // Tabs
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => {
                tab.addEventListener('click', this.changeTab.bind(this));
            });
            
            // Help button
            const helpBtn = document.getElementById('helpBtn');
            if (helpBtn) {
                helpBtn.addEventListener('click', this.showHelp.bind(this));
            }
            
            // Settings button
            const settingsBtn = document.getElementById('settingsBtn');
            if (settingsBtn) {
                settingsBtn.addEventListener('click', this.showSettings.bind(this));
            }
            
            // Close buttons for modals
            const closeButtons = document.querySelectorAll('.modal .close');
            closeButtons.forEach(button => {
                button.addEventListener('click', this.closeModal.bind(this));
            });
            
            // Vendor selection
            const vendorSelect = document.getElementById('vendor');
            if (vendorSelect) {
                vendorSelect.addEventListener('change', this.updatePlatformOptions.bind(this));
            }
            
            // Clear configuration button
            const clearConfigBtn = document.getElementById('clearConfigBtn');
            if (clearConfigBtn) {
                clearConfigBtn.addEventListener('click', this.clearConfiguration.bind(this));
            }
            
            // Add server button
            const addServerBtn = document.getElementById('addServerBtn');
            if (addServerBtn) {
                addServerBtn.addEventListener('click', this.addServerContainer.bind(this));
            }
            
            // Add TACACS server button
            const addTacacsServerBtn = document.getElementById('addTacacsServerBtn');
            if (addTacacsServerBtn) {
                addTacacsServerBtn.addEventListener('click', this.addTacacsServerContainer.bind(this));
            }
            
            // Save settings button
            const saveSettingsBtn = document.getElementById('saveSettingsBtn');
            if (saveSettingsBtn) {
                saveSettingsBtn.addEventListener('click', this.saveSettings.bind(this));
            }
            
            // Reset settings button
            const resetSettingsBtn = document.getElementById('resetSettingsBtn');
            if (resetSettingsBtn) {
                resetSettingsBtn.addEventListener('click', this.resetSettings.bind(this));
            }
        },
        
        /**
         * Change current section
         * @param {Event} event - Click event
         */
        changeSection: function(event) {
            const stepElement = event.currentTarget;
            const stepName = stepElement.getAttribute('data-step');
            
            // Check if step is disabled
            if (stepElement.classList.contains('disabled')) {
                return;
            }
            
            // Update active step
            document.querySelectorAll('.nav-steps li').forEach(step => {
                step.classList.remove('active');
            });
            stepElement.classList.add('active');
            
            // Update active section
            document.querySelectorAll('.config-section').forEach(section => {
                section.classList.remove('active');
            });
            document.getElementById(`${stepName}-section`).classList.add('active');
        },
        
        /**
         * Go to next section
         */
        nextSection: function() {
            const activeStep = document.querySelector('.nav-steps li.active');
            const nextStep = activeStep.nextElementSibling;
            
            if (nextStep && !nextStep.classList.contains('disabled')) {
                nextStep.click();
            }
        },
        
        /**
         * Go to previous section
         */
        prevSection: function() {
            const activeStep = document.querySelector('.nav-steps li.active');
            const prevStep = activeStep.previousElementSibling;
            
            if (prevStep) {
                prevStep.click();
            }
        },
        
        /**
         * Change active tab
         * @param {Event} event - Click event
         */
        changeTab: function(event) {
            const tabElement = event.currentTarget;
            const tabName = tabElement.getAttribute('data-tab');
            const tabsContainer = tabElement.closest('.tabs-container');
            
            // Update active tab
            tabsContainer.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });
            tabElement.classList.add('active');
            
            // Update active tab content
            tabsContainer.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            tabsContainer.querySelector(`#${tabName}`).classList.add('active');
        },
        
        /**
         * Show help modal
         */
        showHelp: function() {
            document.getElementById('helpModal').style.display = 'block';
        },
        
        /**
         * Show settings modal
         */
        showSettings: function() {
            document.getElementById('settingsModal').style.display = 'block';
            
            // Load current settings
            this.loadSettings();
        },
        
        /**
         * Close modal
         * @param {Event} event - Click event
         */
        closeModal: function(event) {
            const modal = event.currentTarget.closest('.modal');
            modal.style.display = 'none';
        },
        
        /**
         * Update platform options based on selected vendor
         */
        updatePlatformOptions: function() {
            const vendor = document.getElementById('vendor').value;
            const platformSelect = document.getElementById('platform');
            
            // Clear current options
            platformSelect.innerHTML = '';
            
            // Add options based on vendor
            switch (vendor) {
                case 'cisco':
                    this.addOption(platformSelect, 'ios', 'IOS');
                    this.addOption(platformSelect, 'ios-xe', 'IOS-XE');
                    this.addOption(platformSelect, 'ios-xr', 'IOS-XR');
                    this.addOption(platformSelect, 'nx-os', 'NX-OS');
                    break;
                case 'aruba':
                    this.addOption(platformSelect, 'arubaos-cx', 'ArubaOS-CX');
                    this.addOption(platformSelect, 'arubaos-switch', 'ArubaOS-Switch');
                    this.addOption(platformSelect, 'procurve', 'ProCurve');
                    break;
                case 'juniper':
                    this.addOption(platformSelect, 'junos', 'Junos OS');
                    this.addOption(platformSelect, 'junos-ex', 'Junos EX');
                    this.addOption(platformSelect, 'junos-qfx', 'Junos QFX');
                    break;
                case 'fortinet':
                    this.addOption(platformSelect, 'fortios', 'FortiOS');
                    break;
                case 'extreme':
                    this.addOption(platformSelect, 'exos', 'EXOS');
                    this.addOption(platformSelect, 'voss', 'VOSS');
                    break;
                case 'dell':
                    this.addOption(platformSelect, 'os10', 'OS10');
                    this.addOption(platformSelect, 'os9', 'OS9');
                    this.addOption(platformSelect, 'os6', 'OS6');
                    break;
                default:
                    this.addOption(platformSelect, 'generic', 'Generic');
            }
        },
        
        /**
         * Add option to select element
         * @param {HTMLSelectElement} select - Select element
         * @param {string} value - Option value
         * @param {string} text - Option text
         */
        addOption: function(select, value, text) {
            const option = document.createElement('option');
            option.value = value;
            option.textContent = text;
            select.appendChild(option);
        },
        
        /**
         * Clear configuration
         */
        clearConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            if (configOutput && confirm('Are you sure you want to clear the configuration?')) {
                configOutput.value = '';
            }
        },
        
        /**
         * Add server container for RADIUS configuration
         */
        addServerContainer: function() {
            const serversContainer = document.getElementById('radiusServersContainer');
            if (!serversContainer) return;
            
            const serverCount = serversContainer.querySelectorAll('.server-container').length + 1;
            
            const serverContainer = document.createElement('div');
            serverContainer.className = 'server-container';
            serverContainer.innerHTML = `
                <h3>RADIUS Server ${serverCount}</h3>
                <div class="form-group">
                    <label for="radiusServer${serverCount}">Server IP Address:</label>
                    <input type="text" id="radiusServer${serverCount}" class="form-control" placeholder="10.1.1.100">
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="radiusAuthPort${serverCount}">Authentication Port:</label>
                        <input type="number" id="radiusAuthPort${serverCount}" class="form-control" value="1812">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="radiusAcctPort${serverCount}">Accounting Port:</label>
                        <input type="number" id="radiusAcctPort${serverCount}" class="form-control" value="1813">
                    </div>
                </div>
                <div class="form-group">
                    <label for="radiusKey${serverCount}">Shared Secret:</label>
                    <div class="password-field">
                        <input type="password" id="radiusKey${serverCount}" class="form-control" placeholder="Enter shared secret">
                        <span class="password-toggle" onclick="App.togglePasswordVisibility('radiusKey${serverCount}')"><i class="fas fa-eye"></i></span>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="radiusTimeout${serverCount}">Timeout (seconds):</label>
                        <input type="number" id="radiusTimeout${serverCount}" class="form-control" value="3">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="radiusRetransmit${serverCount}">Retransmit Count:</label>
                        <input type="number" id="radiusRetransmit${serverCount}" class="form-control" value="2">
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox-item">
                        <input type="checkbox" id="radiusProbingEnabled${serverCount}" name="radiusFeature" value="probing">
                        <label for="radiusProbingEnabled${serverCount}">Enable Server Probing</label>
                    </div>
                </div>
                <button type="button" class="btn-secondary" onclick="App.removeServerContainer(this)">
                    <i class="fas fa-trash"></i> Remove Server
                </button>
            `;
            
            serversContainer.appendChild(serverContainer);
        },
        
        /**
         * Remove server container
         * @param {HTMLButtonElement} button - Remove button
         */
        removeServerContainer: function(button) {
            const container = button.closest('.server-container');
            container.remove();
        },
        
        /**
         * Add TACACS server container
         */
        addTacacsServerContainer: function() {
            const serversContainer = document.getElementById('tacacsServersContainer');
            if (!serversContainer) return;
            
            const serverCount = serversContainer.querySelectorAll('.server-container').length + 1;
            
            const serverContainer = document.createElement('div');
            serverContainer.className = 'server-container';
            serverContainer.innerHTML = `
                <h3>TACACS+ Server ${serverCount}</h3>
                <div class="form-group">
                    <label for="tacacsServer${serverCount}">Server IP Address:</label>
                    <input type="text" id="tacacsServer${serverCount}" class="form-control" placeholder="10.1.1.100">
                </div>
                <div class="form-group">
                    <label for="tacacsPort${serverCount}">Port:</label>
                    <input type="number" id="tacacsPort${serverCount}" class="form-control" value="49">
                </div>
                <div class="form-group">
                    <label for="tacacsKey${serverCount}">Shared Secret:</label>
                    <div class="password-field">
                        <input type="password" id="tacacsKey${serverCount}" class="form-control" placeholder="Enter shared secret">
                        <span class="password-toggle" onclick="App.togglePasswordVisibility('tacacsKey${serverCount}')"><i class="fas fa-eye"></i></span>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="tacacsTimeout${serverCount}">Timeout (seconds):</label>
                        <input type="number" id="tacacsTimeout${serverCount}" class="form-control" value="3">
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox-item">
                        <input type="checkbox" id="tacacsSingleConnection${serverCount}" name="tacacsFeature" value="singleConnection">
                        <label for="tacacsSingleConnection${serverCount}">Enable Single Connection</label>
                    </div>
                </div>
                <button type="button" class="btn-secondary" onclick="App.removeServerContainer(this)">
                    <i class="fas fa-trash"></i> Remove Server
                </button>
            `;
            
            serversContainer.appendChild(serverContainer);
        },
        
        /**
         * Toggle password visibility
         * @param {string} inputId - Password input ID
         */
        togglePasswordVisibility: function(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        },
        
        /**
         * Load settings from local storage
         */
        loadSettings: function() {
            // Theme
            const theme = localStorage.getItem('uaxTheme') || 'light';
            const themeSelect = document.getElementById('appTheme');
            if (themeSelect) {
                themeSelect.value = theme;
            }
            
            // Code font
            const codeFont = localStorage.getItem('uaxCodeFont') || 'monospace';
            const fontSelect = document.getElementById('codeFont');
            if (fontSelect) {
                fontSelect.value = codeFont;
            }
            
            // Tab size
            const tabSize = localStorage.getItem('uaxTabSize') || '2';
            const tabSizeSelect = document.getElementById('tabSize');
            if (tabSizeSelect) {
                tabSizeSelect.value = tabSize;
            }
            
            // Enable AI
            const enableAI = localStorage.getItem('uaxEnableAI') !== 'false'; // default to true
            const enableAICheckbox = document.getElementById('enableAI');
            if (enableAICheckbox) {
                enableAICheckbox.checked = enableAI;
            }
            
            // AI model
            const aiModel = localStorage.getItem('uaxAIModel') || 'standard';
            const aiModelSelect = document.getElementById('aiModel');
            if (aiModelSelect) {
                aiModelSelect.value = aiModel;
            }
            
            // AI response style
            const aiResponseStyle = localStorage.getItem('uaxAIResponseStyle') || 'concise';
            const aiResponseStyleSelect = document.getElementById('aiResponseStyle');
            if (aiResponseStyleSelect) {
                aiResponseStyleSelect.value = aiResponseStyle;
            }
            
            // Auto-save
            const autoSave = localStorage.getItem('uaxAutoSave') !== 'false'; // default to true
            const autoSaveCheckbox = document.getElementById('autoSave');
            if (autoSaveCheckbox) {
                autoSaveCheckbox.checked = autoSave;
            }
            
            // Auto-save interval
            const autoSaveInterval = localStorage.getItem('uaxAutoSaveInterval') || '5';
            const autoSaveIntervalInput = document.getElementById('autoSaveInterval');
            if (autoSaveIntervalInput) {
                autoSaveIntervalInput.value = autoSaveInterval;
            }
            
            // Show advanced options
            const showAdvanced = localStorage.getItem('uaxShowAdvanced') !== 'false'; // default to true
            const showAdvancedCheckbox = document.getElementById('showAdvanced');
            if (showAdvancedCheckbox) {
                showAdvancedCheckbox.checked = showAdvanced;
            }
            
            // Apply theme
            this.applyTheme(theme);
            
            // Apply code font
            this.applyCodeFont(codeFont);
            
            // Apply tab size
            this.applyTabSize(tabSize);
        },
        
        /**
         * Save settings to local storage
         */
        saveSettings: function() {
            // Theme
            const theme = document.getElementById('appTheme').value;
            localStorage.setItem('uaxTheme', theme);
            
            // Code font
            const codeFont = document.getElementById('codeFont').value;
            localStorage.setItem('uaxCodeFont', codeFont);
            
            // Tab size
            const tabSize = document.getElementById('tabSize').value;
            localStorage.setItem('uaxTabSize', tabSize);
            
            // Enable AI
            const enableAI = document.getElementById('enableAI').checked;
            localStorage.setItem('uaxEnableAI', enableAI);
            
            // AI model
            const aiModel = document.getElementById('aiModel').value;
            localStorage.setItem('uaxAIModel', aiModel);
            
            // AI response style
            const aiResponseStyle = document.getElementById('aiResponseStyle').value;
            localStorage.setItem('uaxAIResponseStyle', aiResponseStyle);
            
            // Auto-save
            const autoSave = document.getElementById('autoSave').checked;
            localStorage.setItem('uaxAutoSave', autoSave);
            
            // Auto-save interval
            const autoSaveInterval = document.getElementById('autoSaveInterval').value;
            localStorage.setItem('uaxAutoSaveInterval', autoSaveInterval);
            
            // Show advanced options
            const showAdvanced = document.getElementById('showAdvanced').checked;
            localStorage.setItem('uaxShowAdvanced', showAdvanced);
            
            // Apply settings
            this.applyTheme(theme);
            this.applyCodeFont(codeFont);
            this.applyTabSize(tabSize);
            
            // Close settings modal
            document.getElementById('settingsModal').style.display = 'none';
            
            // Show success message
            this.showToast('Settings saved successfully');
        },
        
        /**
         * Reset settings to defaults
         */
        resetSettings: function() {
            if (confirm('Are you sure you want to reset all settings to default?')) {
                // Reset to defaults
                localStorage.removeItem('uaxTheme');
                localStorage.removeItem('uaxCodeFont');
                localStorage.removeItem('uaxTabSize');
                localStorage.removeItem('uaxEnableAI');
                localStorage.removeItem('uaxAIModel');
                localStorage.removeItem('uaxAIResponseStyle');
                localStorage.removeItem('uaxAutoSave');
                localStorage.removeItem('uaxAutoSaveInterval');
                localStorage.removeItem('uaxShowAdvanced');
                
                // Load default settings
                this.loadSettings();
                
                // Show success message
                this.showToast('Settings reset to default');
            }
        },
        
        /**
         * Apply theme
         * @param {string} theme - Theme name
         */
        applyTheme: function(theme) {
            const body = document.body;
            
            // Remove existing theme classes
            body.classList.remove('theme-light', 'theme-dark');
            
            // Add theme class
            if (theme === 'dark') {
                body.classList.add('theme-dark');
            } else if (theme === 'system') {
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                if (prefersDark) {
                    body.classList.add('theme-dark');
                } else {
                    body.classList.add('theme-light');
                }
            } else {
                body.classList.add('theme-light');
            }
        },
        
        /**
         * Apply code font
         * @param {string} font - Font name
         */
        applyCodeFont: function(font) {
            const codeElements = document.querySelectorAll('.code-output, pre, code');
            
            codeElements.forEach(el => {
                switch (font) {
                    case 'monospace':
                        el.style.fontFamily = 'monospace';
                        break;
                    case 'consolas':
                        el.style.fontFamily = 'Consolas, Monaco, monospace';
                        break;
                    case 'courier':
                        el.style.fontFamily = 'Courier New, Courier, monospace';
                        break;
                    case 'firacode':
                        el.style.fontFamily = 'Fira Code, monospace';
                        break;
                    default:
                        el.style.fontFamily = 'monospace';
                }
            });
        },
        
        /**
         * Apply tab size
         * @param {string} size - Tab size
         */
        applyTabSize: function(size) {
            const codeElements = document.querySelectorAll('.code-output, pre, code');
            
            codeElements.forEach(el => {
                el.style.tabSize = size;
            });
        },
        
        /**
         * Show toast notification
         * @param {string} message - Toast message
         */
        showToast: function(message) {
            // Create toast element
            const toast = document.createElement('div');
            toast.className = 'toast-notification';
            toast.innerHTML = `
                <div class="toast-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="toast-message">
                    ${message}
                </div>
            `;
            
            // Add to body
            document.body.appendChild(toast);
            
            // Remove after 3 seconds
            setTimeout(() => {
                toast.classList.add('toast-hide');
                setTimeout(() => {
                    document.body.removeChild(toast);
                }, 500);
            }, 3000);
        }
    };

    // Initialize App on page load
    document.addEventListener('DOMContentLoaded', function() {
        App.init();
    });

    // Export to window
    window.App = App;
})();
