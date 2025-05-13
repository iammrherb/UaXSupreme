// Global alert function to prevent recursion
window.showAlert = function(message, type = 'info') {
    // Check if we're already showing an alert to prevent recursion
    if (window.isShowingAlert) {
        console.log(`Alert: ${message} (Type: ${type})`);
        return;
    }
    
    window.isShowingAlert = true;
    
    try {
        // Create alert container if it doesn't exist
        let alertContainer = document.getElementById('alert-container');
        if (!alertContainer) {
            alertContainer = document.createElement('div');
            alertContainer.id = 'alert-container';
            alertContainer.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 9999;
                max-width: 400px;
            `;
            document.body.appendChild(alertContainer);
        }
        
        // Create alert element
        const alert = document.createElement('div');
        alert.className = `alert alert-${type}`;
        alert.style.cssText = `
            margin-bottom: 10px;
            padding: 15px;
            border-radius: 4px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            position: relative;
            opacity: 0;
            transform: translateX(50px);
            transition: opacity 0.3s, transform 0.3s;
            background-color: ${type === 'success' ? '#d4edda' : type === 'danger' ? '#f8d7da' : type === 'warning' ? '#fff3cd' : '#d1ecf1'};
            color: ${type === 'success' ? '#155724' : type === 'danger' ? '#721c24' : type === 'warning' ? '#856404' : '#0c5460'};
            border: 1px solid ${type === 'success' ? '#c3e6cb' : type === 'danger' ? '#f5c6cb' : type === 'warning' ? '#ffeeba' : '#bee5eb'};
        `;
        
        // Add message
        alert.textContent = message;
        
        // Add close button
        const closeButton = document.createElement('span');
        closeButton.innerHTML = '&times;';
        closeButton.style.cssText = `
            position: absolute;
            top: 10px;
            right: 10px;
            cursor: pointer;
            font-weight: bold;
            font-size: 18px;
        `;
        closeButton.addEventListener('click', () => {
            alert.style.opacity = '0';
            alert.style.transform = 'translateX(50px)';
            setTimeout(() => {
                if (alert.parentNode) {
                    alert.remove();
                }
            }, 300);
        });
        
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
    } finally {
        window.isShowingAlert = false;
    }
};
