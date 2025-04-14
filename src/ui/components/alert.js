/**
 * Alert - Notification component
 * Shows alerts and notifications to the user
 */
export class Alert {
  constructor(message, type = 'info', options = {}) {
    this.message = message;
    this.type = type;
    this.options = Object.assign({}, this.defaultOptions, options);
    this.element = null;
  }
  
  get defaultOptions() {
    return {
      duration: 5000,
      container: 'alert-container',
      onClose: null
    };
  }
  
  /**
   * Show the alert
   * @returns {Alert} This instance for chaining
   */
  show() {
    // Create container if it doesn't exist
    let container = document.getElementById(this.options.container);
    if (!container) {
      container = document.createElement('div');
      container.id = this.options.container;
      container.style.position = 'fixed';
      container.style.top = '20px';
      container.style.right = '20px';
      container.style.zIndex = '9999';
      container.style.maxWidth = '400px';
      document.body.appendChild(container);
    }
    
    // Create alert element
    this.element = document.createElement('div');
    this.element.className = `alert alert-${this.type}`;
    this.element.style.marginBottom = '10px';
    this.element.style.padding = '15px';
    this.element.style.borderRadius = '4px';
    this.element.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
    this.element.style.position = 'relative';
    this.element.style.opacity = '0';
    this.element.style.transform = 'translateX(50px)';
    this.element.style.transition = 'opacity 0.3s, transform 0.3s';
    
    // Apply type-specific styles
    switch (this.type) {
      case 'success':
        this.element.style.backgroundColor = '#d4edda';
        this.element.style.color = '#155724';
        this.element.style.borderColor = '#c3e6cb';
        break;
      case 'warning':
        this.element.style.backgroundColor = '#fff3cd';
        this.element.style.color = '#856404';
        this.element.style.borderColor = '#ffeeba';
        break;
      case 'danger':
        this.element.style.backgroundColor = '#f8d7da';
        this.element.style.color = '#721c24';
        this.element.style.borderColor = '#f5c6cb';
        break;
      default: // info
        this.element.style.backgroundColor = '#d1ecf1';
        this.element.style.color = '#0c5460';
        this.element.style.borderColor = '#bee5eb';
        break;
    }
    
    // Add close button
    const closeButton = document.createElement('span');
    closeButton.innerHTML = '&times;';
    closeButton.style.position = 'absolute';
    closeButton.style.top = '10px';
    closeButton.style.right = '10px';
    closeButton.style.cursor = 'pointer';
    closeButton.style.fontWeight = 'bold';
    closeButton.addEventListener('click', () => this.close());
    
    // Set message
    this.element.textContent = this.message;
    this.element.appendChild(closeButton);
    
    // Add to container
    container.appendChild(this.element);
    
    // Show with animation
    setTimeout(() => {
      this.element.style.opacity = '1';
      this.element.style.transform = 'translateX(0)';
    }, 10);
    
    // Auto-close after duration
    if (this.options.duration > 0) {
      this.autoCloseTimeout = setTimeout(() => {
        this.close();
      }, this.options.duration);
    }
    
    return this;
  }
  
  /**
   * Close the alert
   */
  close() {
    if (!this.element) {
      return;
    }
    
    // Clear auto-close timeout
    if (this.autoCloseTimeout) {
      clearTimeout(this.autoCloseTimeout);
    }
    
    // Hide with animation
    this.element.style.opacity = '0';
    this.element.style.transform = 'translateX(50px)';
    
    // Remove after animation
    setTimeout(() => {
      if (this.element && this.element.parentNode) {
        this.element.parentNode.removeChild(this.element);
        this.element = null;
        
        if (typeof this.options.onClose === 'function') {
          this.options.onClose.call(this);
        }
      }
    }, 300);
  }
  
  // Static helper methods
  
  /**
   * Show an alert
   * @param {string} message - Alert message
   * @param {string} type - Alert type
   * @param {Object} options - Alert options
   * @returns {Alert} Alert instance
   */
  static show(message, type = 'info', options = {}) {
    return new Alert(message, type, options).show();
  }
  
  /**
   * Show a success alert
   * @param {string} message - Alert message
   * @param {Object} options - Alert options
   * @returns {Alert} Alert instance
   */
  static success(message, options = {}) {
    return Alert.show(message, 'success', options);
  }
  
  /**
   * Show a warning alert
   * @param {string} message - Alert message
   * @param {Object} options - Alert options
   * @returns {Alert} Alert instance
   */
  static warning(message, options = {}) {
    return Alert.show(message, 'warning', options);
  }
  
  /**
   * Show a danger alert
   * @param {string} message - Alert message
   * @param {Object} options - Alert options
   * @returns {Alert} Alert instance
   */
  static danger(message, options = {}) {
    return Alert.show(message, 'danger', options);
  }
  
  /**
   * Show an info alert
   * @param {string} message - Alert message
   * @param {Object} options - Alert options
   * @returns {Alert} Alert instance
   */
  static info(message, options = {}) {
    return Alert.show(message, 'info', options);
  }
}
