// src/ui/components/vendor-selector/vendor-grid.js

import { eventBus } from '../../../core/events.js';
import { stateManager } from '../../../core/state.js';
import { app } from '../../../core/app.js';

export class VendorGrid {
  constructor(elementId = 'vendor-grid') {
    this.elementId = elementId;
    this.element = null;
    this.vendorService = app.getService('vendors');
    this.selectedVendor = null;
    
    // Bind methods
    this.render = this.render.bind(this);
    this.handleVendorClick = this.handleVendorClick.bind(this);
    
    // Subscribe to vendor-related events
    eventBus.on('vendors:initialized', this.render);
    eventBus.on('vendor:selected', (vendorId) => {
      this.updateSelection(vendorId);
    });
  }
  
  /**
   * Initialize the vendor grid
   * @returns {VendorGrid} This instance for chaining
   */
  initialize() {
    // Get grid element
    this.element = document.getElementById(this.elementId);
    if (!this.element) {
      console.error(`Vendor grid element not found: ${this.elementId}`);
      return this;
    }
    
    // Render initial grid
    this.render();
    
    return this;
  }
  
  /**
   * Render the vendor grid
   */
  render() {
    if (!this.element) return;
    
    // Get all vendors from the service
    const vendors = this.vendorService.getAllVendors();
    
    // Clear existing content
    this.element.innerHTML = '';
    
    // Create vendor cards
    vendors.forEach(vendor => {
      const vendorCard = document.createElement('div');
      vendorCard.className = 'vendor-logo-container';
      vendorCard.setAttribute('data-vendor', vendor.id);
      
      // Determine primary type for badge
      const types = vendor.types || [];
      let primaryType = types.length > 0 ? types[0] : 'unknown';
      let typeLabel = primaryType.toUpperCase();
      
      // If vendor supports both wired and wireless, show as "BOTH"
      if (types.includes('wired') && types.includes('wireless')) {
        primaryType = 'both';
        typeLabel = 'BOTH';
      }
      
      // Create vendor logo
      const logoPath = `assets/logos/${vendor.id}-logo.svg`;
      const vendorLogo = document.createElement('img');
      vendorLogo.className = 'vendor-logo';
      vendorLogo.src = logoPath;
      vendorLogo.alt = `${vendor.name} logo`;
      vendorLogo.onerror = function() {
        // If image fails to load, replace with text logo
        this.onerror = null;
        this.src = this.createTextLogoDataUrl(vendor.name);
      }.bind(this);
      
      // Create vendor name
      const vendorName = document.createElement('span');
      vendorName.className = 'vendor-name';
      vendorName.textContent = vendor.name;
      
      // Create vendor type badge
      const vendorType = document.createElement('span');
      vendorType.className = `vendor-type vendor-type-${primaryType}`;
      vendorType.textContent = typeLabel;
      
      // Add all elements to card
      vendorCard.appendChild(vendorLogo);
      vendorCard.appendChild(vendorName);
      vendorCard.appendChild(vendorType);
      
      // Add click event listener
      vendorCard.addEventListener('click', () => this.handleVendorClick(vendor.id));
      
      // Add card to grid
      this.element.appendChild(vendorCard);
    });
    
    // Restore selection if any
    if (this.selectedVendor) {
      this.updateSelection(this.selectedVendor);
    }
  }
  
  /**
   * Handle vendor card click
   * @param {string} vendorId - Vendor ID
   */
  handleVendorClick(vendorId) {
    // Set selected vendor in state manager
    stateManager.setVendor(vendorId);
    
    // Store in local variable
    this.selectedVendor = vendorId;
    
    // Update UI to reflect selection
    this.updateSelection(vendorId);
    
    // Update the platform select dropdown
    this.updatePlatformSelect(vendorId);
  }
  
  /**
   * Update the UI to reflect the selected vendor
   * @param {string} vendorId - Vendor ID
   */
  updateSelection(vendorId) {
    if (!this.element) return;
    
    // Update stored selection
    this.selectedVendor = vendorId;
    
    // Remove selection from all cards
    const vendorCards = this.element.querySelectorAll('.vendor-logo-container');
    vendorCards.forEach(card => {
      card.classList.remove('selected');
    });
    
    // Add selection to the selected card
    const selectedCard = this.element.querySelector(`.vendor-logo-container[data-vendor="${vendorId}"]`);
    if (selectedCard) {
      selectedCard.classList.add('selected');
    }
  }
  
  /**
   * Update the platform select dropdown for selected vendor
   * @param {string} vendorId - Vendor ID
   */
  updatePlatformSelect(vendorId) {
    const platformSelect = document.getElementById('platform-select');
    if (!platformSelect) return;
    
    // Clear existing options
    platformSelect.innerHTML = '';
    
    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = 'Select a platform';
    platformSelect.appendChild(defaultOption);
    
    // Get vendor platforms
    const vendor = this.vendorService.getVendor(vendorId);
    if (!vendor) return;
    
    // Get deployment type (will add this functionality later)
    const deploymentType = document.getElementById('deployment-type');
    const currentDeploymentType = deploymentType ? deploymentType.value : 'wired';
    
    // Get all platforms
    const platforms = vendor.getPlatforms();
    
    // Add platform options that support the selected deployment type
    platforms.forEach(platformId => {
      const platform = vendor.getPlatformInfo(platformId);
      
      // Check if platform supports deployment type
      if (vendor.supportsCapability(platformId, currentDeploymentType) ||
          (currentDeploymentType === 'wired' && vendor.supportsCapability(platformId, 'dot1x')) ||
          (currentDeploymentType === 'wireless' && vendor.supportsCapability(platformId, 'dot1x')) ||
          (currentDeploymentType === 'tacacs' && vendor.supportsCapability(platformId, 'tacacs')) ||
          (currentDeploymentType === 'vpn' && vendor.supportsCapability(platformId, 'vpn')) ||
          (currentDeploymentType === 'uaac' && vendor.supportsCapability(platformId, 'radius'))) {
        
        const option = document.createElement('option');
        option.value = platformId;
        option.textContent = platform.name;
        platformSelect.appendChild(option);
      }
    });
    
    // Enable select
    platformSelect.disabled = false;
    
    // Let the application know platform options have been updated
    eventBus.emit('platform:options-updated', {
      vendor: vendorId,
      platforms: platforms
    });
    
    // Enable the next button if it exists
    const nextButton = document.getElementById('platform-next');
    if (nextButton) {
      nextButton.disabled = false;
    }
  }
  
  /**
   * Create text logo as data URL if image fails to load
   * @param {string} vendorName - Vendor name
   * @returns {string} Data URL
   */
  createTextLogoDataUrl(vendorName) {
    // Create a canvas element
    const canvas = document.createElement('canvas');
    canvas.width = 120;
    canvas.height = 60;
    
    // Get the context
    const ctx = canvas.getContext('2d');
    
    // Draw background (transparent)
    ctx.clearRect(0, 0, 120, 60);
    
    // Draw text
    ctx.fillStyle = '#0077cc';
    ctx.font = 'bold 20px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText(vendorName, 60, 30);
    
    // Return data URL
    return canvas.toDataURL('image/png');
  }
}

// Export singleton instance
export const vendorGrid = new VendorGrid();