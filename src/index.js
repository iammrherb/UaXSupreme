import { app } from './core/app.js';
import { storageService } from './services/storage.js';
import { vendorService } from './services/vendors/index.js';
import { Alert } from './ui/components/alert.js';

// Global error handler
window.addEventListener('error', (event) => {
  console.error('Global error:', event.error);
  Alert.danger('An error occurred: ' + event.error.message);
});

// Migrate global functions to use new components
function migrateGlobalFunctions() {
  // Replace global showAlert with Alert component
  window.legacyCompat.showAlert = (message, type = 'info') => {
    Alert.show(message, type);
  };
  
  console.log('Global functions migrated to new architecture');
}

// Initialize application
document.addEventListener('DOMContentLoaded', async () => {
  try {
    console.log('Initializing application...');
    
    // Register services
    app.registerService('storage', storageService);
    app.registerService('vendors', vendorService);
    
    // Initialize the application
    await app.initialize();
    
    // Migrate global functions
    migrateGlobalFunctions();
    
    // Start the application
    app.start();
    
    console.log('Application initialized successfully');
  } catch (error) {
    console.error('Failed to initialize application:', error);
    Alert.danger('Failed to initialize application: ' + error.message);
  }
});
// src/index.js

import { app } from './core/app.js';
import { storageService } from './services/storage.js';
import { vendorService } from './services/vendors/index.js';
import { Alert } from './ui/components/alert.js';
import { platformTabController } from './ui/pages/platform.js';

// Global error handler
window.addEventListener('error', (event) => {
  console.error('Global error:', event.error);
  Alert.danger('An error occurred: ' + event.error.message);
});

// Migrate global functions to use new components
function migrateGlobalFunctions() {
  // Replace global showAlert with Alert component
  window.legacyCompat.showAlert = (message, type = 'info') => {
    Alert.show(message, type);
  };
  
  // Override window.showAlert to use our Alert component
  window.showAlert = (message, type = 'info') => {
    Alert.show(message, type);
  };
  
  console.log('Global functions migrated to new architecture');
}

// Initialize tab navigation
function initTabNavigation() {
  // Set up tab click handlers
  const tabLinks = document.querySelectorAll('.tab');
  const tabPanes = document.querySelectorAll('.tab-pane');
  
  tabLinks.forEach(tab => {
    tab.addEventListener('click', () => {
      const tabId = tab.getAttribute('data-tab');
      
      // Remove active class from all tabs and panes
      tabLinks.forEach(t => t.classList.remove('active'));
      tabPanes.forEach(p => p.classList.remove('active'));
      
      // Add active class to selected tab and pane
      tab.classList.add('active');
      document.getElementById(tabId).classList.add('active');
      
      // Update state
      app.stateManager.setTab(tabId);
    });
  });
}

// Initialize application
document.addEventListener('DOMContentLoaded', async () => {
  try {
    console.log('Initializing application...');
    
    // Register services
    app.registerService('storage', storageService);
    app.registerService('vendors', vendorService);
    
    // Initialize the application
    await app.initialize();
    
    // Migrate global functions
    migrateGlobalFunctions();
    
    // Initialize tab navigation
    initTabNavigation();
    
    // Start the application
    app.start();
    
    // Platform tab controller is already initialized via the event system
    
    console.log('Application initialized successfully');
  } catch (error) {
    console.error('Failed to initialize application:', error);
    Alert.danger('Failed to initialize application: ' + error.message);
  }
});