import { CONFIG } from '../core/config/constants.js';
import { eventBus } from '../core/events.js';

/**
 * StorageService - Handles persistent storage operations
 * Provides a consistent interface for localStorage operations
 */
export class StorageService {
  constructor() {
    this.storage = window.localStorage;
    this.keys = CONFIG.STORAGE_KEYS;
  }
  
  /**
   * Initialize the storage service
   * @returns {Promise} Promise that resolves when initialization is complete
   */
  initialize() {
    console.log('Initializing Storage Service...');
    // Set up storage change listener from other tabs/windows
    window.addEventListener('storage', (event) => {
      // Check if the changed key is relevant to our app
      if (Object.values(this.keys).includes(event.key)) {
        eventBus.emit('storage:external-change', {
          key: event.key,
          oldValue: event.oldValue ? JSON.parse(event.oldValue) : null,
          newValue: event.newValue ? JSON.parse(event.newValue) : null
        });
      }
    });
    
    return Promise.resolve();
  }
  
  // Generic methods
  
  /**
   * Get an item from storage
   * @param {string} key - Storage key
   * @param {any} defaultValue - Default value if key doesn't exist
   * @returns {any} Stored value or default
   */
  get(key, defaultValue = null) {
    try {
      const value = this.storage.getItem(key);
      return value !== null ? JSON.parse(value) : defaultValue;
    } catch (error) {
      console.error(`Error getting item from storage: ${key}`, error);
      return defaultValue;
    }
  }
  
  /**
   * Set an item in storage
   * @param {string} key - Storage key
   * @param {any} value - Value to store
   * @returns {boolean} True if successful
   */
  set(key, value) {
    try {
      this.storage.setItem(key, JSON.stringify(value));
      eventBus.emit('storage:change', { key, value });
      return true;
    } catch (error) {
      console.error(`Error setting item in storage: ${key}`, error);
      eventBus.emit('storage:error', { key, error });
      return false;
    }
  }
  
  /**
   * Remove an item from storage
   * @param {string} key - Storage key
   * @returns {boolean} True if successful
   */
  remove(key) {
    try {
      this.storage.removeItem(key);
      eventBus.emit('storage:removed', { key });
      return true;
    } catch (error) {
      console.error(`Error removing item from storage: ${key}`, error);
      return false;
    }
  }
  
  // Application-specific methods
  
  /**
   * Get application settings
   * @returns {Object} Application settings
   */
  getSettings() {
    return this.get(this.keys.SETTINGS, CONFIG.DEFAULT_SETTINGS);
  }
  
  /**
   * Save application settings
   * @param {Object} settings - Settings to save
   * @returns {boolean} True if successful
   */
  saveSettings(settings) {
    return this.set(this.keys.SETTINGS, settings);
  }
  
  /**
   * Get selected vendor
   * @returns {string|null} Selected vendor ID
   */
  getSelectedVendor() {
    return this.get(this.keys.SELECTED_VENDOR);
  }
  
  /**
   * Set selected vendor
   * @param {string} vendor - Vendor ID
   * @returns {boolean} True if successful
   */
  setSelectedVendor(vendor) {
    return this.set(this.keys.SELECTED_VENDOR, vendor);
  }
  
  /**
   * Get saved configurations
   * @returns {Array} Array of saved configurations
   */
  getSavedConfigs() {
    return this.get(this.keys.SAVED_CONFIGS, []);
  }
  
  /**
   * Save a configuration
   * @param {Object} config - Configuration to save
   * @returns {boolean} True if successful
   */
  saveConfig(config) {
    const configs = this.getSavedConfigs();
    configs.push({
      id: Date.now().toString(),
      ...config,
      timestamp: new Date().toISOString()
    });
    return this.set(this.keys.SAVED_CONFIGS, configs);
  }
  
  /**
   * Backup all settings
   * @returns {Object} Backup object
   */
  backup() {
    const backup = {};
    
    // Backup all keys defined in CONFIG.STORAGE_KEYS
    for (const key of Object.values(this.keys)) {
      backup[key] = this.get(key);
    }
    
    return backup;
  }
  
  /**
   * Restore settings from backup
   * @param {Object} backupData - Backup data
   * @returns {boolean} True if successful
   */
  restore(backupData) {
    if (!backupData || typeof backupData !== 'object') {
      return false;
    }
    
    let success = true;
    for (const [key, value] of Object.entries(backupData)) {
      if (!this.set(key, value)) {
        success = false;
      }
    }
    
    if (success) {
      eventBus.emit('storage:restored', { backup: backupData });
    }
    
    return success;
  }
  
  /**
   * Clear all application data
   * @returns {boolean} True if successful
   */
  clear() {
    let success = true;
    
    // Clear only app-specific keys, not all localStorage
    for (const key of Object.values(this.keys)) {
      if (!this.remove(key)) {
        success = false;
      }
    }
    
    if (success) {
      eventBus.emit('storage:cleared');
    }
    
    return success;
  }
}

// Export singleton instance
export const storageService = new StorageService();
