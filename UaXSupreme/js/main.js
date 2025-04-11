/**
 * Dot1Xer Supreme Enterprise Edition - Main Application
 * Version 4.1.0
 * 
 * This is the main entry point for the application.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Dot1Xer Supreme Enterprise Edition v4.1.0...');
    
    // Initialize all modules when they are available
    if (typeof initVendorGrid === 'function') {
        initVendorGrid();
    } else {
        console.warn('Vendor grid initialization function not found');
    }
    
    // Initialize AI Integration if available
    if (window.AIIntegration && typeof window.AIIntegration.init === 'function') {
        // Load API keys from localStorage
        const storedKeys = {};
        try {
            const openaiKey = localStorage.getItem('openai_api_key');
            const anthropicKey = localStorage.getItem('anthropic_api_key');
            const geminiKey = localStorage.getItem('gemini_api_key');
            
            if (openaiKey) storedKeys.openai = openaiKey;
            if (anthropicKey) storedKeys.anthropic = anthropicKey;
            if (geminiKey) storedKeys.gemini = geminiKey;
        } catch (e) {
            console.error('Error loading AI API keys:', e);
        }
        
        // Initialize AIIntegration with stored keys
        window.AIIntegration.init({
            provider: localStorage.getItem('ai_provider') || 'openai',
            apiKeys: storedKeys
        });
    }
    
    // Handle "Next" button in the platform tab
    const platformNextButton = document.getElementById('platform-next');
    if (platformNextButton) {
        platformNextButton.addEventListener('click', function() {
            // Validate vendor selection
            const selectedVendor = getSelectedVendor();
            if (!selectedVendor) {
                showAlert('Please select a vendor first', 'warning');
                return;
            }
            
            // Validate platform selection
            const platformSelect = document.getElementById('platform-select');
            if (platformSelect && (!platformSelect.value || platformSelect.value === '')) {
                showAlert('Please select a platform first', 'warning');
                return;
            }
            
            // If validation passes, proceed to next tab
            const authTab = document.querySelector('.tab[data-tab="authentication"]');
            if (authTab) {
                authTab.click();
            }
        });
    }
    
    // Helper function to get selected vendor
    function getSelectedVendor() {
        const selectedContainer = document.querySelector('.vendor-logo-container.selected');
        return selectedContainer ? selectedContainer.getAttribute('data-vendor') : null;
    }
    
    // Helper function to show alerts if showAlert isn't available yet
    function showAlert(message, type = 'info') {
        if (typeof window.showAlert === 'function') {
            window.showAlert(message, type);
            return;
        }
        
        // Fallback alert
        alert(message);
    }
});
