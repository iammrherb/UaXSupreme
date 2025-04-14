// src/ui/components/form/authentication/method-selector.js

import { eventBus } from '../../../../core/events.js';
import { stateManager } from '../../../../core/state.js';

export class AuthMethodSelector {
  constructor(elementId = 'auth-method') {
    this.elementId = elementId;
    this.element = null;
    
    // Bind methods
    this.handleChange = this.handleChange.bind(this);
    
    // Subscribe to relevant events
    eventBus.on('form:reset', this.reset.bind(this));
  }
  
  /**
   * Initialize the component
   * @returns {AuthMethodSelector} This instance for chaining
   */
  initialize() {
    // Get element
    this.element = document.getElementById(this.elementId);
    if (!this.element) {
      console.error(`Authentication method select element not found: ${this.elementId}`);
      return this;
    }
    
    // Set up change handler
    this.element.addEventListener('change', this.handleChange);
    
    // Initial state update
    this.handleChange();
    
    return this;
  }
  
  /**
   * Handle select change
   * @param {Event} event - Change event
   */
  handleChange(event) {
    if (!this.element) return;
    
    const method = this.element.value;
    
    // Update state
    stateManager.setFormData({
      authMethod: method
    });
    
    // Emit event
    eventBus.emit('auth:method-changed', { method });
    
    // Hide/show related settings based on selection
    this.updateRelatedSettings(method);
  }
  
  /**
   * Update related settings visibility based on selected method
   * @param {string} method - Selected authentication method
   */
  updateRelatedSettings(method) {
    // Handle MAB-related settings
    const mabSettings = document.getElementById('mab-settings');
    if (mabSettings) {
      if (['mab', 'dot1x-mab', 'concurrent', 'dot1x-mab-webauth'].includes(method)) {
        mabSettings.style.display = 'block';
      } else {
        mabSettings.style.display = 'none';
      }
    }
    
    // Handle WebAuth-related settings
    const webauthSettings = document.getElementById('webauth-settings');
    if (webauthSettings) {
      if (['dot1x-mab-webauth'].includes(method)) {
        webauthSettings.style.display = 'block';
      } else {
        webauthSettings.style.display = 'none';
      }
    }
  }
  
  /**
   * Set the selected authentication method
   * @param {string} method - Authentication method
   */
  setValue(method) {
    if (!this.element) return;
    
    // Set select value
    this.element.value = method;
    
    // Trigger change event
    this.handleChange();
  }
  
  /**
   * Reset to default value
   */
  reset() {
    if (!this.element) return;
    
    // Reset to default (dot1x)
    this.setValue('dot1x');
  }
}

// Export singleton instance
export const authMethodSelector = new AuthMethodSelector();