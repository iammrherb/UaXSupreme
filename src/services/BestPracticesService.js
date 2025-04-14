/**
 * BestPracticesService.js
 * Service for accessing the Authentication Best Practices module
 */

class BestPracticesService {
  constructor() {
    // Try to import the module if running in a module context
    try {
      import('../components/authentication/utils/AuthenticationBestPractices.js')
        .then(module => {
          this.bestPractices = new module.default();
          console.log('BestPractices module loaded via import');
        })
        .catch(err => {
          console.warn('Failed to import BestPractices module, falling back to global', err);
          this.initFallback();
        });
    } catch (e) {
      console.warn('Module import not supported, falling back to global');
      this.initFallback();
    }
  }
  
  initFallback() {
    // Fallback to global scope if module import fails
    if (typeof AuthenticationBestPractices !== 'undefined') {
      this.bestPractices = new AuthenticationBestPractices();
    } else {
      console.error('AuthenticationBestPractices class not found');
    }
  }
  
  // Wait for the module to be ready
  async ensureReady() {
    if (!this.bestPractices) {
      return new Promise((resolve) => {
        const checkInterval = setInterval(() => {
          if (this.bestPractices) {
            clearInterval(checkInterval);
            resolve();
          }
        }, 100);
        
        // Timeout after 5 seconds
        setTimeout(() => {
          clearInterval(checkInterval);
          console.error('Timed out waiting for BestPractices module');
          resolve();
        }, 5000);
      });
    }
  }
  
  async analyzeConfiguration(config, options) {
    await this.ensureReady();
    if (!this.bestPractices) {
      return { error: 'BestPractices module not initialized' };
    }
    return this.bestPractices.generateRecommendations(config, options);
  }
  
  async getComplianceRequirements(standard) {
    await this.ensureReady();
    if (!this.bestPractices) {
      return {};
    }
    return this.bestPractices.getCompliancePractices(standard);
  }
  
  async getIndustryRecommendations(industry) {
    await this.ensureReady();
    if (!this.bestPractices) {
      return {};
    }
    return this.bestPractices.getIndustryPractices(industry);
  }
  
  async getVendorGuidelines(vendor, component) {
    await this.ensureReady();
    if (!this.bestPractices) {
      return {};
    }
    return this.bestPractices.getVendorPractices(vendor, component);
  }
}

// Export as both a module and a global
const bestPracticesService = new BestPracticesService();

// Export for module environments
export default bestPracticesService;

// Also make available globally
window.BestPracticesService = bestPracticesService;
