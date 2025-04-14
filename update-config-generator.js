/**
 * Update to config-generator.js to integrate with Best Practices module
 * 
 * Instructions:
 * 1. Import the bestPracticesIntegration.js
 * 2. Add event listener for Export Documentation to include best practices
 */

// At the top of config-generator.js, add:
// import { generateRecommendations, applyRecommendations, exportEnhancedConfiguration } from './bestPracticesIntegration.js';

// Then add this to the existing setupConfigGeneratorEvents function
function setupConfigGeneratorEvents() {
    // Your existing code...
    
    // Add event listener for Export Documentation to include best practices
    const exportDocBtn = document.getElementById('export-documentation');
    if (exportDocBtn) {
        const originalClickHandler = exportDocBtn.onclick;
        exportDocBtn.onclick = function(e) {
            // First enhance the configuration with best practices
            const enhancedConfig = exportEnhancedConfiguration();
            
            // Store it temporarily
            window.enhancedConfig = enhancedConfig;
            
            // Call original handler
            if (originalClickHandler) {
                originalClickHandler.call(this, e);
            }
        };
    }
}
