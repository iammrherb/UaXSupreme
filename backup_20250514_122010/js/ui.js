/**
 * Dot1Xer Core Edition - UI Functionality
 * Version 1.0.0
 */

document.addEventListener('DOMContentLoaded', function() {
  console.log('Initializing UI functionality...');
  initTabs();
  initModals();
  initSettings();
  initTooltips();
});

// Initialize tabs functionality
function initTabs() {
  // Main content tabs
  const tabLinks = document.querySelectorAll('.tab');
  const tabPanes = document.querySelectorAll('.tab-pane');

  tabLinks.forEach((tab) => {
    tab.addEventListener('click', () => {
      const tabId = tab.getAttribute('data-tab');
      tabLinks.forEach((t) => t.classList.remove('active'));
      tabPanes.forEach((p) => p.classList.remove('active'));
      tab.classList.add('active');
      document.getElementById(tabId)?.classList.add('active');
    });
  });

  // Tab navigation buttons
  setupTabNavigation();
}

// Setup tab navigation buttons
function setupTabNavigation() {
  const tabs = ['platform', 'authentication', 'security', 'network', 'advanced', 'preview'];
  
  tabs.forEach((tab, index) => {
    const nextTab = tabs[index + 1];
    const prevTab = tabs[index - 1];
    
    if (nextTab) {
      const nextBtn = document.getElementById(`${tab}-next`);
      if (nextBtn) {
        nextBtn.addEventListener('click', () => activateTab(nextTab));
      }
    }
    
    if (prevTab) {
      const prevBtn = document.getElementById(`${tab}-prev`);
      if (prevBtn) {
        prevBtn.addEventListener('click', () => activateTab(prevTab));
      }
    }
  });
}

// Activate a specific tab
function activateTab(tabId) {
  const tab = document.querySelector(`.tab[data-tab="${tabId}"]`);
  if (tab) tab.click();
}

// Initialize modals
function initModals() {
  // Close modals when clicking outside
  document.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal-overlay') && 
        event.target.classList.contains('visible')) {
      event.target.classList.remove('visible');
    }
  });

  // Setup common modals
  setupModal('settings-link', 'settings-modal', 'settings-modal-close', 'settings-cancel');
  setupModal('export-documentation', 'export-modal', 'export-modal-close', 'export-cancel');
  setupModal('save-config', 'save-config-modal', 'save-config-modal-close', 'save-config-cancel');
}

// Set up a modal dialog
function setupModal(triggerButtonId, modalId, closeButtonId, cancelButtonId) {
  const triggerButton = document.getElementById(triggerButtonId);
  const modal = document.getElementById(modalId);
  const closeButton = document.getElementById(closeButtonId);
  const cancelButton = document.getElementById(cancelButtonId);

  if (triggerButton && modal) {
    triggerButton.addEventListener('click', (e) => {
      e.preventDefault();
      modal.classList.add('visible');
    });
  }

  if (closeButton && modal) {
    closeButton.addEventListener('click', () => {
      modal.classList.remove('visible');
    });
  }

  if (cancelButton && modal) {
    cancelButton.addEventListener('click', () => {
      modal.classList.remove('visible');
    });
  }
}

// Initialize settings
function initSettings() {
  // Load saved settings
  loadSettings();

  // Save settings button
  const saveSettingsButton = document.getElementById('settings-save');
  if (saveSettingsButton) {
    saveSettingsButton.addEventListener('click', saveSettings);
  }

  // Theme selector
  const themeSelect = document.getElementById('theme-select');
  if (themeSelect) {
    themeSelect.addEventListener('change', () => {
      applyTheme(themeSelect.value);
    });
  }
}

// Load settings from localStorage
function loadSettings() {
  try {
    // Theme settings
    const theme = localStorage.getItem('theme') || 'light';
    applyTheme(theme);

    // Update settings form
    const themeSelect = document.getElementById('theme-select');
    if (themeSelect) themeSelect.value = theme;
  } catch (error) {
    console.error('Error loading settings:', error);
  }
}

// Save settings to localStorage
function saveSettings() {
  try {
    // Theme settings
    const themeSelect = document.getElementById('theme-select');
    if (themeSelect) localStorage.setItem('theme', themeSelect.value);
    
    // Apply theme
    if (themeSelect) applyTheme(themeSelect.value);
    
    // Close modal
    const modal = document.getElementById('settings-modal');
    if (modal) modal.classList.remove('visible');

    // Show success message
    showAlert('Settings saved successfully', 'success');
  } catch (error) {
    console.error('Error saving settings:', error);
    showAlert('Error saving settings: ' + error.message, 'danger');
  }
}

// Apply theme
function applyTheme(theme) {
  if (theme === 'dark') {
    document.body.classList.add('dark-theme');
  } else if (theme === 'light') {
    document.body.classList.remove('dark-theme');
  } else if (theme === 'system') {
    // Check system preference
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
      document.body.classList.add('dark-theme');
    } else {
      document.body.classList.remove('dark-theme');
    }
  }
}

// Initialize tooltips
function initTooltips() {
  // Find all elements with tooltip data attribute
  const tooltips = document.querySelectorAll('[data-tooltip]');

  tooltips.forEach((tooltip) => {
    // Add a span for the tooltip text if it doesn't exist
    if (!tooltip.querySelector('.tooltip-text')) {
      const tooltipText = document.createElement('span');
      tooltipText.className = 'tooltip-text';
      tooltipText.textContent = tooltip.getAttribute('data-tooltip') || 'Tooltip';
      tooltip.appendChild(tooltipText);
    }
  });
}

// Helper function to show alerts - moved to main.js as global function
function showAlert(message, type = 'info') {
  // Use global showAlert function if available
  if (typeof window.showAlert === 'function') {
    window.showAlert(message, type);
    return;
  }

  alert(message);
}
