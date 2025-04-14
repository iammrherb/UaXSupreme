// src/ui/components/vendor-selector/platform-info.js

import { eventBus } from '../../../core/events.js';
import { stateManager } from '../../../core/state.js';
import { app } from '../../../core/app.js';

export class PlatformInfo {
  constructor(elementId = 'platform-details') {
    this.elementId = elementId;
    this.element = null;
    this.vendorService = app.getService('vendors');
    
    // Bind methods
    this.render = this.render.bind(this);
    this.clear = this.clear.bind(this);
    
    // Subscribe to platform-related events
    eventBus.on('platform:selected', (data) => {
      this.render(data.vendor, data.platform);
    });
  }
  
  /**
   * Initialize the platform info component
   * @returns {PlatformInfo} This instance for chaining
   */
  initialize() {
    // Get element
    this.element = document.getElementById(this.elementId);
    if (!this.element) {
      console.error(`Platform details element not found: ${this.elementId}`);
      return this;
    }
    
    // Initial render (empty)
    this.clear();
    
    // Set up platform select change handler
    const platformSelect = document.getElementById('platform-select');
    if (platformSelect) {
      platformSelect.addEventListener('change', () => {
        const vendorId = stateManager.getState().currentVendor;
        const platformId = platformSelect.value;
        
        if (platformId) {
          // Update state
          stateManager.setPlatform(platformId);
          
          // Render platform details
          this.render(vendorId, platformId);
        } else {
          this.clear();
        }
      });
    }
    
    return this;
  }
  
  /**
   * Render platform details
   * @param {string} vendorId - Vendor ID
   * @param {string} platformId - Platform ID
   */
  render(vendorId, platformId) {
    if (!this.element) return;
    
    // Clear if no selection
    if (!vendorId || !platformId) {
      this.clear();
      return;
    }
    
    // Get vendor and platform
    const vendor = this.vendorService.getVendor(vendorId);
    if (!vendor) {
      this.clear();
      return;
    }
    
    const platform = vendor.getPlatformInfo(platformId);
    if (!platform) {
      this.clear();
      return;
    }
    
    // Create platform details HTML
    let detailsHtml = `
      <div class="platform-details-header">
        <h3>${platform.name}</h3>
        <span class="vendor-badge">${vendor.name}</span>
      </div>
      <p>${platform.description}</p>
      
      <h4>Capabilities</h4>
      <div class="capability-badges">
    `;
    
    // Add capability badges
    const capabilities = platform.capabilities || [];
    const capabilityLabels = {
      'dot1x': '802.1X',
      'mab': 'MAB',
      'radsec': 'RadSec',
      'radius': 'RADIUS',
      'tacacs': 'TACACS+',
      'vpn': 'VPN',
      'uaac': 'User Auth',
      'saml': 'SAML'
    };
    
    capabilities.forEach(capability => {
      const label = capabilityLabels[capability] || capability;
      detailsHtml += `<span class="capability-badge">${label}</span>`;
    });
    
    detailsHtml += '</div>';
    
    // Add version selection
    if (platform.versions && platform.versions.length > 0) {
      detailsHtml += `
        <h4>Software Version</h4>
        <select id="platform-version" class="form-control">
          <option value="">Select a version</option>
      `;
      
      platform.versions.forEach(version => {
        detailsHtml += `<option value="${version}">${version}</option>`;
      });
      
      detailsHtml += '</select>';
    }
    
    // Update platform details
    this.element.innerHTML = detailsHtml;
    
    // Set up version select change handler
    const versionSelect = document.getElementById('platform-version');
    if (versionSelect) {
      versionSelect.addEventListener('change', () => {
        const version = versionSelect.value;
        if (version) {
          // Store in state
          stateManager.setState({
            softwareVersion: version
          });
          
          // Emit event
          eventBus.emit('version:selected', {
            vendor: vendorId,
            platform: platformId,
            version: version
          });
        }
      });
    }
  }
  
  /**
   * Clear platform details
   */
  clear() {
    if (!this.element) return;
    
    this.element.innerHTML = '<p>Please select a vendor and platform.</p>';
  }
}

// Export singleton instance
export const platformInfo = new PlatformInfo();