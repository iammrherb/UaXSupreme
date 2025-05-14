/**
 * Main JavaScript file for Dot1Xer Supreme Enterprise Edition
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Dot1Xer Supreme Enterprise Edition...');
    
    // Initialize all modules
    initializeApplication();
});

function initializeApplication() {
    // Initialize vendor selection
    if (typeof initVendorGrid === 'function') {
        initVendorGrid();
    }
    
    // Initialize UI functionality
    initializeUI();
    
    // Initialize configuration generator
    initializeConfigGenerator();
    
    // Initialize wizard if available
    if (typeof VendorConfigWizard !== 'undefined') {
        window.vendorWizard = new VendorConfigWizard();
    }
}

function initializeUI() {
    // Tab functionality
    const tabs = document.querySelectorAll('.tab');
    const tabPanes = document.querySelectorAll('.tab-pane');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const targetTab = tab.getAttribute('data-tab');
            
            // Update active states
            tabs.forEach(t => t.classList.remove('active'));
            tabPanes.forEach(p => p.classList.remove('active'));
            
            tab.classList.add('active');
            document.getElementById(targetTab).classList.add('active');
        });
    });
    
    // Settings modal
    const settingsLink = document.getElementById('settings-link');
    const settingsModal = document.getElementById('settings-modal');
    const settingsClose = document.getElementById('settings-modal-close');
    const settingsCancel = document.getElementById('settings-cancel');
    const settingsSave = document.getElementById('settings-save');
    
    if (settingsLink && settingsModal) {
        settingsLink.addEventListener('click', (e) => {
            e.preventDefault();
            settingsModal.classList.add('visible');
        });
        
        [settingsClose, settingsCancel].forEach(el => {
            if (el) {
                el.addEventListener('click', () => {
                    settingsModal.classList.remove('visible');
                });
            }
        });
        
        if (settingsSave) {
            settingsSave.addEventListener('click', () => {
                // Save settings logic here
                settingsModal.classList.remove('visible');
            });
        }
    }
}

function initializeConfigGenerator() {
    const generateBtn = document.getElementById('generate-config');
    const copyBtn = document.getElementById('copy-config');
    const downloadBtn = document.getElementById('download-config');
    
    if (generateBtn) {
        generateBtn.addEventListener('click', generateConfiguration);
    }
    
    if (copyBtn) {
        copyBtn.addEventListener('click', copyConfiguration);
    }
    
    if (downloadBtn) {
        downloadBtn.addEventListener('click', downloadConfiguration);
    }
}

function generateConfiguration() {
    // Check if wizard is active
    const wizardContainer = document.getElementById('vendor-wizard-container');
    if (wizardContainer && wizardContainer.style.display !== 'none' && window.vendorWizard) {
        window.vendorWizard.generateConfiguration();
    } else {
        // Use standard generation
        const settings = collectSettings();
        const config = generateConfigFromSettings(settings);
        displayConfiguration(config);
    }
}

function collectSettings() {
    return {
        vendor: document.querySelector('.vendor-logo-container.selected')?.getAttribute('data-vendor'),
        platform: document.getElementById('platform-select')?.value,
        interface: document.getElementById('interface')?.value,
        authMethod: document.getElementById('auth-method')?.value,
        authMode: document.querySelector('input[name="auth-mode"]:checked')?.value,
        hostMode: document.getElementById('host-mode')?.value,
        radiusServer: document.getElementById('radius-server-1')?.value,
        radiusKey: document.getElementById('radius-key-1')?.value,
        // ... collect other settings
    };
}

function generateConfigFromSettings(settings) {
    if (!settings.vendor || !settings.platform) {
        showAlert('Please select a vendor and platform', 'danger');
        return '';
    }
    
    // Use the vendor config generator if available
    if (typeof VendorConfigGenerator !== 'undefined') {
        const generator = new VendorConfigGenerator(settings);
        return generator.generate();
    }
    
    // Fallback to basic generation
    return `! Basic configuration
! Vendor: ${settings.vendor}
! Platform: ${settings.platform}
`;
}

function displayConfiguration(config) {
    const configOutput = document.getElementById('config-output');
    if (configOutput) {
        configOutput.textContent = config;
    }
}

function copyConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (configOutput) {
        navigator.clipboard.writeText(configOutput.textContent).then(() => {
            showAlert('Configuration copied to clipboard!', 'success');
        }).catch(err => {
            showAlert('Failed to copy configuration', 'danger');
        });
    }
}

function downloadConfiguration() {
    const configOutput = document.getElementById('config-output');
    if (configOutput) {
        const config = configOutput.textContent;
        const blob = new Blob([config], { type: 'text/plain' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        
        a.href = url;
        a.download = 'dot1x-config.txt';
        document.body.appendChild(a);
        a.click();
        
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);
        
        showAlert('Configuration downloaded successfully!', 'success');
    }
}
