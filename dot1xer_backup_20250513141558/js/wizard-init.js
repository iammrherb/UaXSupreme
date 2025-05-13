/**
 * Wizard Initialization Script
 * Integrates the vendor-specific wizard with the existing UI
 */

document.addEventListener('DOMContentLoaded', function() {
    // Listen for vendor selection changes
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    vendorContainers.forEach(container => {
        container.addEventListener('click', function() {
            const vendor = this.getAttribute('data-vendor');
            
            // Dispatch custom event
            const event = new CustomEvent('vendorSelected', {
                detail: vendor
            });
            document.dispatchEvent(event);
        });
    });
    
    // Enhance the existing config generator to support wizard data
    const originalGenerateConfig = window.generateConfiguration;
    window.generateConfiguration = function() {
        // Check if we're using the wizard
        const wizardContainer = document.getElementById('vendor-wizard-container');
        if (wizardContainer && wizardContainer.style.display !== 'none' && window.vendorWizard) {
            // Use wizard to generate config
            window.vendorWizard.generateConfiguration();
        } else {
            // Use original generator
            if (originalGenerateConfig) {
                originalGenerateConfig.apply(this, arguments);
            }
        }
    };
});
