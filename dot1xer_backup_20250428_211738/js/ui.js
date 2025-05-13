/**
 * Dot1Xer Supreme Enterprise Edition - UI Functionality
 * Version 4.1.0
 * 
 * This module handles user interface functionality, including tab switching,
 * form interactions, modal displays, and other UI-related features.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing UI functionality...');
    
    // Initialize tabs
    initTabs();
    
    // Initialize expandable sections
    initExpandableSections();
    
    // Initialize modals
    initModals();
    
    // Initialize settings
    initSettings();
    
    // Initialize video banner
    initVideoBanner();
    
    // Initialize tooltips
    initTooltips();
});

// Initialize tabs functionality
function initTabs() {
    // Main content tabs
    const tabLinks = document.querySelectorAll('.tab');
    const tabPanes = document.querySelectorAll('.tab-pane');
    
    tabLinks.forEach(tab => {
        tab.addEventListener('click', () => {
            const tabId = tab.getAttribute('data-tab');
            
            // Remove active class from all tabs and panes
            tabLinks.forEach(t => t.classList.remove('active'));
            tabPanes.forEach(p => p.classList.remove('active'));
            
            // Add active class to selected tab and pane
            tab.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        });
    });
    
    // Tab navigation buttons
    setupTabNavigation();
    
    // Settings tabs
    const settingsTabs = document.querySelectorAll('.settings-tabs .tab');
    const settingsPanes = document.querySelectorAll('#settings-modal .tab-pane');
    
    settingsTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const tabId = tab.getAttribute('data-tab');
            
            // Remove active class from all tabs and panes
            settingsTabs.forEach(t => t.classList.remove('active'));
            settingsPanes.forEach(p => p.classList.remove('active'));
            
            // Add active class to selected tab and pane
            tab.classList.add('active');
            document.getElementById(tabId).classList.add('active');
        });
    });
}

// Setup tab navigation buttons
function setupTabNavigation() {
    // Platform tab navigation
    const platformNext = document.getElementById('platform-next');
    if (platformNext) {
        platformNext.addEventListener('click', () => {
            activateTab('authentication');
        });
    }
    
    // Authentication tab navigation
    const authPrev = document.getElementById('auth-prev');
    const authNext = document.getElementById('auth-next');
    
    if (authPrev) {
        authPrev.addEventListener('click', () => {
            activateTab('platform');
        });
    }
    
    if (authNext) {
        authNext.addEventListener('click', () => {
            activateTab('security');
        });
    }
    
    // Security tab navigation
    const securityPrev = document.getElementById('security-prev');
    const securityNext = document.getElementById('security-next');
    
    if (securityPrev) {
        securityPrev.addEventListener('click', () => {
            activateTab('authentication');
        });
    }
    
    if (securityNext) {
        securityNext.addEventListener('click', () => {
            activateTab('network');
        });
    }
    
    // Network tab navigation
    const networkPrev = document.getElementById('network-prev');
    const networkNext = document.getElementById('network-next');
    
    if (networkPrev) {
        networkPrev.addEventListener('click', () => {
            activateTab('security');
        });
    }
    
    if (networkNext) {
        networkNext.addEventListener('click', () => {
            activateTab('advanced');
        });
    }
    
    // Advanced tab navigation
    const advancedPrev = document.getElementById('advanced-prev');
    const advancedNext = document.getElementById('advanced-next');
    
    if (advancedPrev) {
        advancedPrev.addEventListener('click', () => {
            activateTab('network');
        });
    }
    
    if (advancedNext) {
        advancedNext.addEventListener('click', () => {
            activateTab('preview');
        });
    }
    
    // Preview tab navigation
    const previewPrev = document.getElementById('preview-prev');
    
    if (previewPrev) {
        previewPrev.addEventListener('click', () => {
            activateTab('advanced');
        });
    }
}

// Activate a specific tab
function activateTab(tabId) {
    const tab = document.querySelector(`.tab[data-tab="${tabId}"]`);
    if (tab) {
        tab.click();
    }
}

// Initialize expandable sections
function initExpandableSections() {
    const expandableHeaders = document.querySelectorAll('.expandable-header');
    
    expandableHeaders.forEach(header => {
        header.addEventListener('click', () => {
            header.classList.toggle('expanded');
            const content = header.nextElementSibling;
            if (content && content.classList.contains('expandable-content')) {
                content.classList.toggle('expanded');
            }
        });
    });
}

// Initialize modal dialogs
function initModals() {
    // Settings modal
    setupModal('settings-link', 'settings-modal', 'settings-modal-close', 'settings-cancel');
    
    // Export documentation modal
    setupModal('export-documentation', 'export-modal', 'export-modal-close', 'export-cancel');
    
    // Save config modal
    setupModal('save-config', 'save-config-modal', 'save-config-modal-close', 'save-config-cancel');
    
    // Checklist modal
    setupModal('checklist-link', 'checklist-modal', 'checklist-modal-close', 'checklist-close');
    setupModal('checklist-tool', 'checklist-modal', 'checklist-modal-close', 'checklist-close');
    
    // AI Assistant
    const aiButton = document.getElementById('ai-assistant-button');
    const aiPanel = document.getElementById('ai-assistant-panel');
    const aiClose = document.getElementById('ai-assistant-close');
    
    if (aiButton && aiPanel && aiClose) {
        aiButton.addEventListener('click', () => {
            aiPanel.classList.add('visible');
        });
        
        aiClose.addEventListener('click', () => {
            aiPanel.classList.remove('visible');
        });
    }
}

// Set up a modal dialog
function setupModal(triggerButtonId, modalId, closeButtonId, cancelButtonId) {
    const triggerButton = document.getElementById(triggerButtonId);
    const modal = document.getElementById(modalId);
    const closeButton = document.getElementById(closeButtonId);
    const cancelButton = document.getElementById(cancelButtonId);
    
    if (triggerButton && modal) {
        triggerButton.addEventListener('click', (e) => {
            e.preventDefault();
            modal.classList.add('visible');
        });
    }
    
    if (closeButton && modal) {
        closeButton.addEventListener('click', () => {
            modal.classList.remove('visible');
        });
    }
    
    if (cancelButton && modal) {
        cancelButton.addEventListener('click', () => {
            modal.classList.remove('visible');
        });
    }
    
    // Close modal when clicking outside
    if (modal) {
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('visible');
            }
        });
    }
}

// Initialize settings functionality
function initSettings() {
    // Load saved settings
    loadSettings();
    
    // Save settings button
    const saveSettingsButton = document.getElementById('settings-save');
    if (saveSettingsButton) {
        saveSettingsButton.addEventListener('click', saveSettings);
    }
    
    // Theme selector
    const themeSelect = document.getElementById('theme-select');
    if (themeSelect) {
        themeSelect.addEventListener('change', () => {
            applyTheme(themeSelect.value);
        });
    }
    
    // Font size selector
    const fontSizeSelect = document.getElementById('font-size');
    if (fontSizeSelect) {
        fontSizeSelect.addEventListener('change', () => {
            applyFontSize(fontSizeSelect.value);
        });
    }
    
    // AI provider selector
    const aiProviderSelect = document.getElementById('ai-provider');
    if (aiProviderSelect) {
        aiProviderSelect.addEventListener('change', updateAIModelOptions);
    }
    
    // Backup and restore
    const backupButton = document.getElementById('backup-all-settings');
    if (backupButton) {
        backupButton.addEventListener('click', backupAllSettings);
    }
    
    const restoreButton = document.getElementById('restore-settings');
    if (restoreButton) {
        restoreButton.addEventListener('click', restoreSettingsFromFile);
    }
    
    const clearButton = document.getElementById('clear-all-settings');
    if (clearButton) {
        clearButton.addEventListener('click', confirmAndClearAllSettings);
    }
}

// Load settings from localStorage
function loadSettings() {
    try {
        // Theme settings
        const theme = localStorage.getItem('theme') || 'light';
        const fontSize = localStorage.getItem('fontSize') || 'medium';
        
        // Apply visual settings
        applyTheme(theme);
        applyFontSize(fontSize);
        
        // Update settings form
        const themeSelect = document.getElementById('theme-select');
        const fontSizeSelect = document.getElementById('font-size');
        
        if (themeSelect) themeSelect.value = theme;
        if (fontSizeSelect) fontSizeSelect.value = fontSize;
        
        // Load AI settings
        const aiProvider = localStorage.getItem('ai_provider') || 'openai';
        const openaiKey = localStorage.getItem('openai_api_key') || '';
        const anthropicKey = localStorage.getItem('anthropic_api_key') || '';
        const geminiKey = localStorage.getItem('gemini_api_key') || '';
        
        // Update AI settings form
        const aiProviderSelect = document.getElementById('ai-provider');
        const openaiKeyInput = document.getElementById('openai-api-key');
        const anthropicKeyInput = document.getElementById('anthropic-api-key');
        const geminiKeyInput = document.getElementById('gemini-api-key');
        
        if (aiProviderSelect) aiProviderSelect.value = aiProvider;
        if (openaiKeyInput) openaiKeyInput.value = openaiKey;
        if (anthropicKeyInput) anthropicKeyInput.value = anthropicKey;
        if (geminiKeyInput) geminiKeyInput.value = geminiKey;
        
        // Update AI model options
        updateAIModelOptions();
        
        // General settings
        const defaultVendor = localStorage.getItem('default_vendor') || '';
        const autoSaveInterval = localStorage.getItem('auto_save_interval') || '5';
        const rememberSettings = localStorage.getItem('remember_settings') !== 'false';
        const showAdvanced = localStorage.getItem('show_advanced_options') === 'true';
        
        // Update general settings form
        const defaultVendorSelect = document.getElementById('default-vendor');
        const autoSaveInput = document.getElementById('auto-save-interval');
        const rememberSettingsCheckbox = document.getElementById('remember-settings');
        const showAdvancedCheckbox = document.getElementById('show-advanced-options');
        
        if (defaultVendorSelect) defaultVendorSelect.value = defaultVendor;
        if (autoSaveInput) autoSaveInput.value = autoSaveInterval;
        if (rememberSettingsCheckbox) rememberSettingsCheckbox.checked = rememberSettings;
        if (showAdvancedCheckbox) showAdvancedCheckbox.checked = showAdvanced;
        
        console.log('Settings loaded successfully');
    } catch (error) {
        console.error('Error loading settings:', error);
    }
}

// Save settings to localStorage
function saveSettings() {
    try {
        // Theme settings
        const themeSelect = document.getElementById('theme-select');
        const fontSizeSelect = document.getElementById('font-size');
        
        if (themeSelect) localStorage.setItem('theme', themeSelect.value);
        if (fontSizeSelect) localStorage.setItem('fontSize', fontSizeSelect.value);
        
        // Apply visual settings
        if (themeSelect) applyTheme(themeSelect.value);
        if (fontSizeSelect) applyFontSize(fontSizeSelect.value);
        
        // AI settings
        const aiProviderSelect = document.getElementById('ai-provider');
        const openaiKeyInput = document.getElementById('openai-api-key');
        const anthropicKeyInput = document.getElementById('anthropic-api-key');
        const geminiKeyInput = document.getElementById('gemini-api-key');
        
        if (aiProviderSelect) localStorage.setItem('ai_provider', aiProviderSelect.value);
        if (openaiKeyInput) localStorage.setItem('openai_api_key', openaiKeyInput.value);
        if (anthropicKeyInput) localStorage.setItem('anthropic_api_key', anthropicKeyInput.value);
        if (geminiKeyInput) localStorage.setItem('gemini_api_key', geminiKeyInput.value);
        
        // General settings
        const defaultVendorSelect = document.getElementById('default-vendor');
        const autoSaveInput = document.getElementById('auto-save-interval');
        const rememberSettingsCheckbox = document.getElementById('remember-settings');
        const showAdvancedCheckbox = document.getElementById('show-advanced-options');
        
        if (defaultVendorSelect) localStorage.setItem('default_vendor', defaultVendorSelect.value);
        if (autoSaveInput) localStorage.setItem('auto_save_interval', autoSaveInput.value);
        if (rememberSettingsCheckbox) localStorage.setItem('remember_settings', rememberSettingsCheckbox.checked.toString());
        if (showAdvancedCheckbox) localStorage.setItem('show_advanced_options', showAdvancedCheckbox.checked.toString());
        
        // Initialize AI with updated settings
        if (window.AIIntegration && typeof window.AIIntegration.init === 'function') {
            window.AIIntegration.init({
                provider: aiProviderSelect ? aiProviderSelect.value : 'openai',
                apiKeys: {
                    openai: openaiKeyInput ? openaiKeyInput.value : '',
                    anthropic: anthropicKeyInput ? anthropicKeyInput.value : '',
                    gemini: geminiKeyInput ? geminiKeyInput.value : ''
                }
            });
        }
        
        // Close modal
        const modal = document.getElementById('settings-modal');
        if (modal) modal.classList.remove('visible');
        
        // Show success message
        showAlert('Settings saved successfully', 'success');
        
        console.log('Settings saved successfully');
    } catch (error) {
        console.error('Error saving settings:', error);
        showAlert('Error saving settings: ' + error.message, 'danger');
    }
}

// Apply theme
function applyTheme(theme) {
    if (theme === 'dark') {
        document.body.classList.add('dark-theme');
    } else if (theme === 'light') {
        document.body.classList.remove('dark-theme');
    } else if (theme === 'system') {
        // Check system preference
        if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
            document.body.classList.add('dark-theme');
        } else {
            document.body.classList.remove('dark-theme');
        }
    }
}

// Apply font size
function applyFontSize(size) {
    document.body.classList.remove('font-small', 'font-medium', 'font-large');
    document.body.classList.add(`font-${size}`);
}

// Update AI model options based on selected provider
function updateAIModelOptions() {
    const aiProviderSelect = document.getElementById('ai-provider');
    const aiModelSelect = document.getElementById('ai-model');
    
    if (!aiProviderSelect || !aiModelSelect) return;
    
    // Clear existing options
    aiModelSelect.innerHTML = '';
    
    // Get selected provider
    const provider = aiProviderSelect.value;
    
    // Define models for each provider
    const models = {
        openai: [
            { value: 'gpt-3.5-turbo', label: 'GPT-3.5 Turbo' },
            { value: 'gpt-4-turbo', label: 'GPT-4 Turbo' },
            { value: 'gpt-4o', label: 'GPT-4o' }
        ],
        anthropic: [
            { value: 'claude-3-haiku', label: 'Claude 3 Haiku' },
            { value: 'claude-3-sonnet', label: 'Claude 3 Sonnet' },
            { value: 'claude-3-opus', label: 'Claude 3 Opus' }
        ],
        gemini: [
            { value: 'gemini-pro', label: 'Gemini Pro' },
            { value: 'gemini-ultra', label: 'Gemini Ultra' }
        ]
    };
    
    // Add options for selected provider
    const providerModels = models[provider] || [];
    providerModels.forEach(model => {
        const option = document.createElement('option');
        option.value = model.value;
        option.textContent = model.label;
        aiModelSelect.appendChild(option);
    });
    
    // Select first model by default
    if (providerModels.length > 0) {
        aiModelSelect.value = providerModels[0].value;
    }
}

// Backup all settings
function backupAllSettings() {
    try {
        // Collect all settings from localStorage
        const settings = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith('dot1xer_') || 
                key === 'theme' || 
                key === 'fontSize' || 
                key === 'ai_provider' || 
                key === 'default_vendor' || 
                key === 'auto_save_interval' || 
                key === 'remember_settings' || 
                key === 'show_advanced_options') {
                settings[key] = localStorage.getItem(key);
            }
        }
        
        // Convert to JSON
        const settingsJson = JSON.stringify(settings, null, 2);
        
        // Create download
        const blob = new Blob([settingsJson], { type: 'application/json' });
        const filename = `dot1xer-settings-backup-${new Date().toISOString().split('T')[0]}.json`;
        
        if (window.saveAs) {
            // Use FileSaver.js if available
            saveAs(blob, filename);
        } else {
            // Fallback to manual download
            const element = document.createElement('a');
            element.href = URL.createObjectURL(blob);
            element.download = filename;
            element.style.display = 'none';
            document.body.appendChild(element);
            element.click();
            setTimeout(() => {
                document.body.removeChild(element);
                URL.revokeObjectURL(element.href);
            }, 100);
        }
        
        showAlert('Settings backup created successfully', 'success');
    } catch (error) {
        console.error('Error backing up settings:', error);
        showAlert('Error backing up settings: ' + error.message, 'danger');
    }
}

// Restore settings from file
function restoreSettingsFromFile() {
    const fileInput = document.getElementById('restore-file');
    if (!fileInput || !fileInput.files || fileInput.files.length === 0) {
        showAlert('Please select a backup file to restore', 'warning');
        return;
    }
    
    const file = fileInput.files[0];
    const reader = new FileReader();
    
    reader.onload = function(e) {
        try {
            const settings = JSON.parse(e.target.result);
            
            // Restore settings to localStorage
            Object.keys(settings).forEach(key => {
                localStorage.setItem(key, settings[key]);
            });
            
            // Reload settings
            loadSettings();
            
            showAlert('Settings restored successfully. Reloading page...', 'success');
            
            // Reload page after a short delay
            setTimeout(() => {
                window.location.reload();
            }, 2000);
        } catch (error) {
            console.error('Error restoring settings:', error);
            showAlert('Error restoring settings: ' + error.message, 'danger');
        }
    };
    
    reader.onerror = function() {
        showAlert('Error reading backup file', 'danger');
    };
    
    reader.readAsText(file);
}

// Confirm and clear all settings
function confirmAndClearAllSettings() {
    const confirmed = confirm('This will reset all settings to default values. This action cannot be undone. Are you sure you want to continue?');
    
    if (confirmed) {
        clearAllSettings();
    }
}

// Clear all settings
function clearAllSettings() {
    try {
        // Remove all Dot1Xer-related items from localStorage
        const keysToRemove = [];
        
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            if (key.startsWith('dot1xer_') || 
                key === 'theme' || 
                key === 'fontSize' || 
                key === 'ai_provider' || 
                key === 'openai_api_key' || 
                key === 'anthropic_api_key' || 
                key === 'gemini_api_key' || 
                key === 'default_vendor' || 
                key === 'auto_save_interval' || 
                key === 'remember_settings' || 
                key === 'show_advanced_options') {
                keysToRemove.push(key);
            }
        }
        
        keysToRemove.forEach(key => {
            localStorage.removeItem(key);
        });
        
        showAlert('All settings have been reset. Reloading page...', 'success');
        
        // Reload page after a short delay
        setTimeout(() => {
            window.location.reload();
        }, 2000);
    } catch (error) {
        console.error('Error clearing settings:', error);
        showAlert('Error clearing settings: ' + error.message, 'danger');
    }
}

// Initialize video banner
function initVideoBanner() {
    const videoBanner = document.getElementById('video-banner');
    if (!videoBanner) return;
    
    // Try to load video
    try {
        const video = document.createElement('video');
        video.autoplay = true;
        video.loop = true;
        video.muted = true;
        video.playsInline = true;
        video.style.width = '100%';
        video.style.height = '100%';
        video.style.objectFit = 'cover';
        
        // Add source
        const source = document.createElement('source');
        source.src = 'assets/videos/banner-video.mp4';
        source.type = 'video/mp4';
        
        // Error handling - fallback to image
        video.onerror = function() {
            loadFallbackImage(videoBanner);
        };
        
        source.onerror = function() {
            loadFallbackImage(videoBanner);
        };
        
        video.appendChild(source);
        
        // Insert before overlay
        const overlay = videoBanner.querySelector('.video-overlay');
        if (overlay) {
            videoBanner.insertBefore(video, overlay);
        } else {
            videoBanner.appendChild(video);
        }
        
        // Start playing
        video.play().catch(err => {
            console.warn('Auto-play prevented:', err);
            // Fallback to image
            loadFallbackImage(videoBanner);
        });
    } catch (error) {
        console.error('Error loading video:', error);
        loadFallbackImage(videoBanner);
    }
}

// Load fallback image for video banner
function loadFallbackImage(container) {
    // Remove any existing video
    const existingVideo = container.querySelector('video');
    if (existingVideo) {
        container.removeChild(existingVideo);
    }
    
    // Use a gradient background as fallback
    container.style.background = 'linear-gradient(45deg, #1a3a5f, #0077cc)';
}

// Initialize tooltips
function initTooltips() {
    // Find all elements with tooltip-text class
    const tooltips = document.querySelectorAll('.tooltip');
    
    tooltips.forEach(tooltip => {
        // Add a span for the tooltip text if it doesn't exist
        if (!tooltip.querySelector('.tooltip-text')) {
            const tooltipText = document.createElement('span');
            tooltipText.className = 'tooltip-text';
            tooltipText.textContent = tooltip.getAttribute('data-tooltip') || 'Tooltip';
            tooltip.appendChild(tooltipText);
        }
    });
}

// Helper function to show alerts
function showAlert(message, type = 'info') {
    // Create alert container if it doesn't exist
    let alertContainer = document.getElementById('alert-container');
    if (!alertContainer) {
        alertContainer = document.createElement('div');
        alertContainer.id = 'alert-container';
        alertContainer.style.position = 'fixed';
        alertContainer.style.top = '20px';
        alertContainer.style.right = '20px';
        alertContainer.style.zIndex = '9999';
        alertContainer.style.maxWidth = '400px';
        document.body.appendChild(alertContainer);
    }
    
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
}

// Export showAlert function globally
window.showAlert = showAlert;
