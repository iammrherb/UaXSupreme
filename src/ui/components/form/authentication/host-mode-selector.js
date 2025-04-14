// src/ui/components/form/authentication/host-mode-selector.js

import { eventBus } from '../../../../core/events.js';
import { stateManager } from '../../../../core/state.js';

export class HostModeSelector {
  constructor(elementId = 'host-mode') {
    this.elementId = elementId;
    this.element = null;
    
    // Bind methods
    this.handleChange = this.handleChange.bind(this);
    
    // Subscribe to relevant events
    eventBus.on('form:reset', this.reset.bind(this));
  }
  
  /**
   * Initialize the component
   * @returns {HostModeSelector} This instance for chaining
   */
  initialize() {
    // Get element
    this.element = document.getElementById(this.elementId);
    if (!this.element) {
      console.error(`Host mode select element not found: ${this.elementId}`);
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
    
    const hostMode = this.element.value;
    
    // Update state
    stateManager.setFormData({
      hostMode: hostMode
    });
    
    // Emit event
    eventBus.emit('auth:host-mode-changed', { hostMode });
    
    // Update related settings based on host mode
    this.updateRelatedSettings(hostMode);
  }
  
  /**
   * Update related settings visibility based on selected host mode
   * @param {string} hostMode - Selected host mode
   */
  updateRelatedSettings(hostMode) {
    // Handle voice VLAN settings
    const voiceVlanSettings = document.getElementById('voice-vlan-settings');
    if (voiceVlanSettings) {
      if (hostMode === 'multi-domain') {
        voiceVlanSettings.style.display = 'block';
      } else {
        voiceVlanSettings.style.display = 'none';
      }
    }
  }
  
  /**
   * Set the selected host mode
   * @param {string} hostMode - Host mode
   */
  setValue(hostMode) {
    if (!this.element) return;
    
    // Set select value
    this.element.value = hostMode;
    
    // Trigger change event
    this.handleChange();
  }
  
  /**
   * Reset to default value
   */
  reset() {
    if (!this.element) return;
    
    // Reset to default (multi-auth)
    this.setValue('multi-auth');
  }
}

// Export singleton instance
export const hostModeSelector = new HostModeSelector();