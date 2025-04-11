/**
 * Fix for showAlert function to prevent recursive calls
 */
(function() {
    // Only apply if not already fixed
    if (window.showAlert && !window._alertFixed) {
        console.log("Applying alert function fix...");
        
        // Store the original function
        window._originalShowAlert = window.showAlert;
        window._alertFixed = true;
        
        // Replace with a safe version
        window.showAlert = function(message, type) {
            console.log("Alert: " + message);
            
            // Create alert element
            var alertEl = document.createElement('div');
            alertEl.className = 'alert ' + (type || 'alert-info');
            alertEl.innerHTML = message;
            alertEl.style.position = 'fixed';
            alertEl.style.top = '10px';
            alertEl.style.right = '10px';
            alertEl.style.zIndex = '9999';
            alertEl.style.maxWidth = '300px';
            alertEl.style.padding = '10px 15px';
            alertEl.style.borderRadius = '4px';
            alertEl.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
            
            // Style based on alert type
            if (type === 'alert-success') {
                alertEl.style.backgroundColor = '#d4edda';
                alertEl.style.color = '#155724';
            } else if (type === 'alert-danger') {
                alertEl.style.backgroundColor = '#f8d7da';
                alertEl.style.color = '#721c24';
            } else if (type === 'alert-warning') {
                alertEl.style.backgroundColor = '#fff3cd';
                alertEl.style.color = '#856404';
            } else {
                alertEl.style.backgroundColor = '#d1ecf1';
                alertEl.style.color = '#0c5460';
            }
            
            document.body.appendChild(alertEl);
            
            // Remove after timeout
            setTimeout(function() {
                if (alertEl.parentNode) {
                    alertEl.parentNode.removeChild(alertEl);
                }
            }, 3000);
        };
        
        console.log("Alert function fixed successfully!");
    }
})();
