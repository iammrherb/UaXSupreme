// Create alert container
function createAlertContainer() {
    if (!document.getElementById('alert-container')) {
        const alertContainer = document.createElement('div');
        alertContainer.id = 'alert-container';
        alertContainer.style.position = 'fixed';
        alertContainer.style.top = '20px';
        alertContainer.style.right = '20px';
        alertContainer.style.zIndex = '9999';
        alertContainer.style.maxWidth = '400px';
        document.body.appendChild(alertContainer);
    }
}

// Global alert function
window.showAlert = function(message, type = 'info') {
    // Create alert container if it doesn't exist
    createAlertContainer();
    
    // Get alert container
    const alertContainer = document.getElementById('alert-container');
    
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
    
    // Apply type-specific styles
    switch (type) {
        case 'success':
            alert.style.backgroundColor = '#d4edda';
            alert.style.color = '#155724';
            alert.style.borderColor = '#c3e6cb';
            break;
        case 'warning':
            alert.style.backgroundColor = '#fff3cd';
            alert.style.color = '#856404';
            alert.style.borderColor = '#ffeeba';
            break;
        case 'danger':
            alert.style.backgroundColor = '#f8d7da';
            alert.style.color = '#721c24';
            alert.style.borderColor = '#f5c6cb';
            break;
        default: // info
            alert.style.backgroundColor = '#d1ecf1';
            alert.style.color = '#0c5460';
            alert.style.borderColor = '#bee5eb';
            break;
    }
    
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
};
