/**
 * ValidationService.js
 * A flexible validation service for authentication components.
 */

export class ValidationService {
  constructor() {
    this.validators = {};
  }
  
  /**
   * Register a validator for a field
   * @param {String} field Field to validate (supports dot notation and wildcards)
   * @param {Object} rules Validation rules
   */
  register(field, rules) {
    this.validators[field] = rules;
  }
  
  /**
   * Validate an object against registered validators
   * @param {Object} object Object to validate
   * @returns {Object} Validation result {valid, errors}
   */
  validate(object) {
    const errors = [];
    
    for (const [field, rules] of Object.entries(this.validators)) {
      // Handle wildcards in field names
      if (field.includes('*')) {
        this.validateWildcard(object, field, rules, errors);
      } else {
        // Handle regular fields
        this.validateField(object, field, rules, errors);
      }
    }
    
    return {
      valid: errors.length === 0,
      errors
    };
  }
  
  /**
   * Validate a specific field
   * @param {Object} object Object containing the field
   * @param {String} field Field to validate (supports dot notation)
   * @param {Object} rules Validation rules
   * @param {Array} errors Array to collect errors
   */
  validateField(object, field, rules, errors) {
    // Extract actual value using dot notation (e.g., 'user.name')
    const value = this.getValueByPath(object, field);
    
    // Skip validation if field doesn't exist and is not required
    if (value === undefined) {
      // Check if field is required
      if (rules.required) {
        // Handle function-based requirement
        if (typeof rules.required === 'function') {
          if (rules.required(object)) {
            errors.push({
              field,
              message: rules.message || `${field} is required`
            });
          }
        } else if (rules.required === true) {
          errors.push({
            field,
            message: rules.message || `${field} is required`
          });
        }
      }
      return;
    }
    
    // Type validation
    if (rules.type && typeof value !== rules.type) {
      // Special handling for numbers
      if (rules.type === 'number' && !isNaN(Number(value))) {
        // Value can be converted to a number, so it's valid
      } else {
        errors.push({
          field,
          message: rules.message || `${field} must be of type ${rules.type}`
        });
        return;
      }
    }
    
    // Min/max validation for numbers
    if (rules.type === 'number' || typeof value === 'number') {
      const numValue = Number(value);
      
      if (rules.min !== undefined && numValue < rules.min) {
        errors.push({
          field,
          message: rules.message || `${field} must be at least ${rules.min}`
        });
      }
      
      if (rules.max !== undefined && numValue > rules.max) {
        errors.push({
          field,
          message: rules.message || `${field} must be at most ${rules.max}`
        });
      }
    }
    
    // Min/max length validation for strings
    if ((rules.type === 'string' || typeof value === 'string') && typeof value !== 'number') {
      if (rules.minLength !== undefined && value.length < rules.minLength) {
        errors.push({
          field,
          message: rules.message || `${field} must be at least ${rules.minLength} characters`
        });
      }
      
      if (rules.maxLength !== undefined && value.length > rules.maxLength) {
        errors.push({
          field,
          message: rules.message || `${field} must be at most ${rules.maxLength} characters`
        });
      }
    }
    
    // Custom validator function
    if (rules.validator && typeof rules.validator === 'function') {
      if (!rules.validator(value, object)) {
        errors.push({
          field,
          message: rules.message || `${field} failed validation`
        });
      }
    }
    
    // Enum validation
    if (rules.enum && Array.isArray(rules.enum) && !rules.enum.includes(value)) {
      errors.push({
        field,
        message: rules.message || `${field} must be one of: ${rules.enum.join(', ')}`
      });
    }
    
    // Pattern validation
    if (rules.pattern && value && !rules.pattern.test(value)) {
      errors.push({
        field,
        message: rules.message || `${field} does not match the required pattern`
      });
    }
  }
  
  /**
   * Validate fields that match a wildcard pattern
   * @param {Object} object Object containing the fields
   * @param {String} wildcard Wildcard pattern (e.g., '*.name')
   * @param {Object} rules Validation rules
   * @param {Array} errors Array to collect errors
   */
  validateWildcard(object, wildcard, rules, errors) {
    const parts = wildcard.split('.');
    const wildcardIndex = parts.findIndex(part => part === '*');
    
    if (wildcardIndex === -1) {
      // No wildcard found, treat as regular field
      this.validateField(object, wildcard, rules, errors);
      return;
    }
    
    // Get the object that contains the wildcard
    const parentPath = parts.slice(0, wildcardIndex).join('.');
    const parentObject = parentPath ? this.getValueByPath(object, parentPath) : object;
    
    if (!parentObject || typeof parentObject !== 'object') {
      return;
    }
    
    // Get the remaining path after the wildcard
    const remainingPath = parts.slice(wildcardIndex + 1).join('.');
    
    // Validate each matching field
    for (const key of Object.keys(parentObject)) {
      const fullPath = parentPath ? `${parentPath}.${key}` : key;
      const fieldToValidate = remainingPath ? `${fullPath}.${remainingPath}` : fullPath;
      
      this.validateField(object, fieldToValidate, rules, errors);
    }
  }
  
  /**
   * Get a value from an object using dot notation
   * @param {Object} obj Source object
   * @param {String} path Path to the value (e.g., 'user.address.street')
   * @returns {*} Value at the path or undefined if not found
   */
  getValueByPath(obj, path) {
    // Handle empty path
    if (!path) return obj;
    
    // Split the path into parts
    const parts = path.split('.');
    let current = obj;
    
    // Navigate through the object
    for (const part of parts) {
      if (current === null || current === undefined || typeof current !== 'object') {
        return undefined;
      }
      
      current = current[part];
    }
    
    return current;
  }
  
  /**
   * Clear all registered validators
   */
  clear() {
    this.validators = {};
  }
  
  /**
   * Remove a specific validator
   * @param {String} field Field to remove validator for
   */
  removeValidator(field) {
    delete this.validators[field];
  }
  
  /**
   * Create a validation schema from an object
   * @param {Object} schema Validation schema
   * @returns {ValidationService} This ValidationService instance
   */
  createSchema(schema) {
    // Reset validators
    this.clear();
    
    // Process schema
    this.processSchemaObject(schema, '');
    
    return this;
  }
  
  /**
   * Process a schema object and register validators
   * @param {Object} schemaObject Schema object
   * @param {String} prefix Field prefix
   */
  processSchemaObject(schemaObject, prefix) {
    for (const [key, value] of Object.entries(schemaObject)) {
      const fieldName = prefix ? `${prefix}.${key}` : key;
      
      if (value && typeof value === 'object' && !Array.isArray(value)) {
        // Check if this is a validator object or a nested schema
        if ('type' in value || 'required' in value || 'validator' in value) {
          // This is a validator object
          this.register(fieldName, value);
        } else {
          // This is a nested schema
          this.processSchemaObject(value, fieldName);
        }
      }
    }
  }
}

export default ValidationService;