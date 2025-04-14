// src/ui/pages/platform.js

import { vendorGrid } from '../components/vendor-selector/vendor-grid.js';
import { platformInfo } from '../components/vendor-selector/platform-info.js';
import { eventBus } from '../../core/events.js';
import { stateManager } from '../../core/state.js';
import { app } from '../../core/app.js';
import { Alert } from '../components/alert.js';

export class PlatformTabController {
  constructor() {
    this.vendorGrid = vendorGrid;
    this.platformInfo = platformInfo;
    this.storageService = app.getService('storage');
    
    // Bind methods
    this.initialize = this.initialize.bind(this);
    this.handleNextButton = this.handleNextButton.bind(this);
    this.restorePreviousSelection = this.restorePreviousSelection.bind(this);
    
    // Subscribe to relevant events
    eventBus.on('app:initialized', this.initialize);
  }
  
  /**
   * Initialize the platform tab
   */
  initialize() {
    console.log('Initializing Platform Tab Controller...');
    
    // Initialize components
    this.vendorGrid.initialize();
    this.platformInfo.initialize();
    
    // Set up next button
    const nextButton = document.getElementById('platform-next');
    if (nextButton) {
      nextButton.addEventListener('click', this.handleNextButton);
      nextButton.disabled = true; // Disabled until vendor and platform are selected
    }
    
    // Restore previous selection (if any)
    this.restorePreviousSelection();
  }
  
  /**
   * Handle next button click
   * @param {Event} event - Click event
   */
  handleNextButton(event) {
    event.preventDefault();
    
    // Get current state
    const state = stateManager.getState();
    const selectedVendor = state.currentVendor;
    const selectedPlatform = state.currentPlatform;
    const softwareVersion = state.softwareVersion;
    
    // Validate selections
    if (!selectedVendor) {
      Alert.warning('Please select a vendor.');
      return;
    }
    
    if (!selectedPlatform) {
      Alert.warning('Please select a platform.');
      return;
    }
    
    // Store selections
    if (this.storageService) {
      this.storageService.setSelectedVendor(selectedVendor);
      this.storageService.set('selectedPlatform', selectedPlatform);
      if (softwareVersion) {
        this.storageService.set('softwareVersion', softwareVersion);
      }
    }
    
    // Emit navigation event
    eventBus.emit('navigation:next-tab', { 
      currentTab: 'platform', 
      nextTab: 'authentication' 
    });
    
    // Navigate to authentication tab
    const authTab = document.querySelector('.tab[data-tab="authentication"]');
    if (authTab) {
      authTab.click();
    }
  }
  
  /**
   * Restore previous vendor and platform selection
   */
  restorePreviousSelection() {
    if (!this.storageService) return;
    
    // Get saved selections
    const savedVendor = this.storageService.getSelectedVendor();
    const savedPlatform = this.storageService.get('selectedPlatform');
    const savedVersion = this.storageService.get('softwareVersion');
    
    // Restore vendor selection if available
    if (savedVendor) {
      // Update state
      stateManager.setVendor(savedVendor);
      
      // Update UI
      this.vendorGrid.updateSelection(savedVendor);
      
      // If there's a saved platform, restore it after vendor is selected
      if (savedPlatform) {
        // Need a slight delay to ensure platform options are populated
        setTimeout(() => {
          // Set platform select value
          const platformSelect = document.getElementById('platform-select');
          if (platformSelect) {
            platformSelect.value = savedPlatform;
            
            // Trigger change event to update platform details
            const event = new Event('change');
            platformSelect.dispatchEvent(event);
            
            // Update state
            stateManager.setPlatform(savedPlatform);
          }
          
          // If there's a saved version, restore it
          if (savedVersion) {
            // Need another slight delay to ensure version options are populated
            setTimeout(() => {
              const versionSelect = document.getElementById('platform-version');
              if (versionSelect) {
                versionSelect.value = savedVersion;
                
                // Update state
                stateManager.setState({ softwareVersion: savedVersion });
              }
            }, 100);
          }
        }, 100);
      }
    }
  }
}

// Export singleton instance
export const platformTabController = new PlatformTabController();