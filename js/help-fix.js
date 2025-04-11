// Help Tips Fix Script
(function() {
    console.log("Applying help tips fix...");
    
    // Function to fix help text overlays
    function fixHelpText() {
        // Find all form groups
        const formGroups = document.querySelectorAll('.form-group');
        
        formGroups.forEach(group => {
            // Find the label
            const label = group.querySelector('label');
            if (!label) return;
            
            // Check for any text directly in the form-group that might be overlapping
            Array.from(group.childNodes).forEach(node => {
                if (node.nodeType === Node.TEXT_NODE && node.textContent.trim().length > 10) {
                    // This is likely help text incorrectly placed
                    const helpText = node.textContent.trim();
                    
                    // Remove the original text node
                    node.remove();
                    
                    // Create a help icon
                    const helpIcon = document.createElement('span');
                    helpIcon.className = 'help-icon';
                    helpIcon.textContent = '?';
                    label.appendChild(helpIcon);
                    
                    // Create a tooltip
                    const tooltip = document.createElement('div');
                    tooltip.className = 'help-tooltip';
                    tooltip.textContent = helpText;
                    label.appendChild(tooltip);
                }
            });
            
            // Also handle help text that might be positioned absolutely
            const computedStyle = window.getComputedStyle(group);
            if (computedStyle.position === 'relative' || computedStyle.position === 'static') {
                const bounds = group.getBoundingClientRect();
                const allElements = document.elementsFromPoint(bounds.left + bounds.width/2, bounds.top + bounds.height/2);
                
                // Check if there are multiple text elements overlapping
                allElements.forEach(el => {
                    if (el !== group && el !== label && !group.contains(el) && 
                        el.textContent && el.textContent.trim().length > 10) {
                        // This could be overlapping text
                        const helpText = el.textContent.trim();
                        el.classList.add('help-text-overlay');
                        
                        // Only add help icon if one doesn't exist
                        if (!label.querySelector('.help-icon')) {
                            // Create a help icon
                            const helpIcon = document.createElement('span');
                            helpIcon.className = 'help-icon';
                            helpIcon.textContent = '?';
                            label.appendChild(helpIcon);
                            
                            // Create a tooltip
                            const tooltip = document.createElement('div');
                            tooltip.className = 'help-tooltip';
                            tooltip.textContent = helpText;
                            label.appendChild(tooltip);
                        }
                    }
                });
            }
        });
        
        // Special case for common help text patterns
        const helpTexts = [
            "Determine if",
            "Choose how",
            "Select how",
            "Specify your",
            "Configure",
            "Select which",
            "Authenticate"
        ];
        
        // Find text nodes containing these patterns
        const textNodes = [];
        function findTextNodes(element) {
            if (element.nodeType === Node.TEXT_NODE) {
                for (const pattern of helpTexts) {
                    if (element.textContent.includes(pattern)) {
                        textNodes.push(element);
                        break;
                    }
                }
            } else {
                for (const child of element.childNodes) {
                    findTextNodes(child);
                }
            }
        }
        
        findTextNodes(document.body);
        
        // Process found text nodes
        textNodes.forEach(node => {
            const helpText = node.textContent.trim();
            if (helpText.length > 10 && node.parentNode) {
                // Find the closest form group or label
                let formGroup = node.parentNode.closest('.form-group');
                if (formGroup) {
                    const label = formGroup.querySelector('label');
                    if (label && !label.querySelector('.help-icon')) {
                        // Hide the original text
                        node.textContent = '';
                        
                        // Create a help icon
                        const helpIcon = document.createElement('span');
                        helpIcon.className = 'help-icon';
                        helpIcon.textContent = '?';
                        label.appendChild(helpIcon);
                        
                        // Create a tooltip
                        const tooltip = document.createElement('div');
                        tooltip.className = 'help-tooltip';
                        tooltip.textContent = helpText;
                        label.appendChild(tooltip);
                    }
                }
            }
        });
    }
    
    // Initialize the fix
    function init() {
        // Wait for the page to be fully loaded
        setTimeout(fixHelpText, 500);
        
        // Also run the fix when changing tabs
        const tabs = document.querySelectorAll('.tab');
        tabs.forEach(tab => {
            tab.addEventListener('click', function() {
                setTimeout(fixHelpText, 300);
            });
        });
    }
    
    // Run on document ready
    if (document.readyState === "complete" || document.readyState === "interactive") {
        init();
    } else {
        document.addEventListener("DOMContentLoaded", init);
    }
})();
