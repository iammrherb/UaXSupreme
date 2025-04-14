/**
 * TemplateService.js
 * Service for managing configuration templates
 */

export class TemplateService {
  constructor() {
    this.templates = {};
  }
  
  /**
   * Register a template
   * @param {String} name Template name
   * @param {Object} template Template object
   * @param {String} template.vendor Vendor
   * @param {String} template.type Component type
   * @param {Object} template.config Configuration
   * @param {String} template.description Description
   * @returns {Boolean} Success status
   */
  registerTemplate(name, template) {
    if (!name || !template || !template.vendor || !template.type || !template.config) {
      return false;
    }
    
    this.templates[name] = {
      ...template,
      timestamp: new Date().toISOString()
    };
    
    return true;
  }
  
  /**
   * Get a template by name
   * @param {String} name Template name
   * @returns {Object} Template object or null if not found
   */
  getTemplate(name) {
    return this.templates[name] || null;
  }
  
  /**
   * Get all templates
   * @returns {Object} Templates object
   */
  getAllTemplates() {
    return { ...this.templates };
  }
  
  /**
   * Get templates for a specific vendor and type
   * @param {String} vendor Vendor
   * @param {String} type Component type
   * @returns {Array} Array of template objects
   */
  getTemplatesForVendorAndType(vendor, type) {
    return Object.entries(this.templates)
      .filter(([_, template]) => template.vendor === vendor && template.type === type)
      .map(([name, template]) => ({ name, ...template }));
  }
  
  /**
   * Remove a template
   * @param {String} name Template name
   * @returns {Boolean} Success status
   */
  removeTemplate(name) {
    if (!this.templates[name]) {
      return false;
    }
    
    delete this.templates[name];
    return true;
  }
  
  /**
   * Save templates to localStorage
   * @returns {Boolean} Success status
   */
  saveTemplates() {
    try {
      localStorage.setItem('auth_templates', JSON.stringify(this.templates));
      return true;
    } catch (error) {
      console.error('Error saving templates:', error);
      return false;
    }
  }
  
  /**
   * Load templates from localStorage
   * @returns {Boolean} Success status
   */
  loadTemplates() {
    try {
      const templates = localStorage.getItem('auth_templates');
      if (templates) {
        this.templates = JSON.parse(templates);
      }
      return true;
    } catch (error) {
      console.error('Error loading templates:', error);
      return false;
    }
  }
}

// Export a singleton instance
export default new TemplateService();
