import { eventBus } from './events.js';
import { CONFIG } from './config/constants.js';

/**
 * StateManager - Central state management system
 * Provides a single source of truth for application state
 */
export class StateManager {
  constructor() {
    this.state = {
      currentVendor: null,
      currentPlatform: null,
      settings: { ...CONFIG.DEFAULT_SETTINGS },
      formData: {},
      currentTab: 'platform',
      config: {
        generated: false,
        content: '',
        analyzed: false,
        analysis: null
      }
    };
    
    this.subscribers = [];
  }
  
  /**
   * Get the current state
   * @returns {Object} Current state
   */
  getState() {
    return { ...this.state };
  }
  
  /**
   * Update the state
   * @param {Object} newState - State changes to apply
   */
  setState(newState) {
    const previousState = { ...this.state };
    this.state = { ...this.state, ...newState };
    this.notifySubscribers(previousState);
    
    // Emit events for specific state changes
    for (const [key, value] of Object.entries(newState)) {
      eventBus.emit(`state:${key}:changed`, { 
        previous: previousState[key], 
        current: value 
      });
    }
  }
  
  /**
   * Subscribe to state changes
   * @param {Function} callback - Function to call when state changes
   * @returns {Function} Unsubscribe function
   */
  subscribe(callback) {
    this.subscribers.push(callback);
    // Return unsubscribe function
    return () => {
      this.subscribers = this.subscribers.filter(cb => cb !== callback);
    };
  }
  
  /**
   * Notify subscribers of state changes
   * @param {Object} previousState - Previous state before changes
   */
  notifySubscribers(previousState) {
    for (const callback of this.subscribers) {
      callback(this.state, previousState);
    }
  }
  
  // Specialized methods for common operations
  
  /**
   * Set the current vendor
   * @param {string} vendor - Vendor ID
   */
  setVendor(vendor) {
    this.setState({ currentVendor: vendor });
    eventBus.emit('vendor:selected', vendor);
  }
  
  /**
   * Set the current platform
   * @param {string} platform - Platform ID
   */
  setPlatform(platform) {
    this.setState({ currentPlatform: platform });
    eventBus.emit('platform:selected', platform);
  }
  
  /**
   * Set the active tab
   * @param {string} tab - Tab ID
   */
  setTab(tab) {
    this.setState({ currentTab: tab });
    eventBus.emit('tab:changed', tab);
  }
  
  /**
   * Update form data
   * @param {Object} formData - Form data to add to state
   */
  setFormData(formData) {
    this.setState({ formData: { ...this.state.formData, ...formData } });
    eventBus.emit('form:updated', this.state.formData);
  }
  
  /**
   * Set the generated configuration
   * @param {string} config - Generated configuration
   */
  setGeneratedConfig(config) {
    this.setState({ 
      config: { 
        ...this.state.config, 
        generated: true, 
        content: config 
      } 
    });
    eventBus.emit('config:generated', config);
  }
}

// Export singleton instance
export const stateManager = new StateManager();
