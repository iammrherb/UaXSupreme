import { eventBus } from './events.js';
import { stateManager } from './state.js';
import { CONFIG } from './config/constants.js';

/**
 * Application - Main application class
 * Orchestrates services and provides the application lifecycle
 */
export class Application {
  constructor() {
    this.services = new Map();
    this.initialized = false;
    
    // Register core modules
    this.eventBus = eventBus;
    this.stateManager = stateManager;
    this.config = CONFIG;
  }
  
  /**
   * Register a service
   * @param {string} name - Service name
   * @param {Object} serviceInstance - Service instance
   * @returns {Application} This instance for chaining
   */
  registerService(name, serviceInstance) {
    this.services.set(name, serviceInstance);
    return this;
  }
  
  /**
   * Get a registered service
   * @param {string} name - Service name
   * @returns {Object|null} Service instance or null if not found
   */
  getService(name) {
    if (!this.services.has(name)) {
      console.error(`Service '${name}' is not registered.`);
      return null;
    }
    return this.services.get(name);
  }
  
  /**
   * Initialize the application
   * @returns {Promise} Promise that resolves when initialization is complete
   */
  async initialize() {
    if (this.initialized) {
      return;
    }
    
    console.log(`Initializing ${this.config.APP_NAME} v${this.config.VERSION}...`);
    
    // Initialize all registered services
    const initPromises = [];
    for (const [name, service] of this.services.entries()) {
      if (typeof service.initialize === 'function') {
        console.log(`Initializing service: ${name}`);
        initPromises.push(service.initialize());
      }
    }
    
    try {
      await Promise.all(initPromises);
      this.initialized = true;
      console.log('Application initialized successfully');
      eventBus.emit('app:initialized');
    } catch (error) {
      console.error('Error initializing application:', error);
      eventBus.emit('app:error', error);
    }
  }
  
  /**
   * Start the application
   * @returns {Application} This instance for chaining
   */
  start() {
    if (!this.initialized) {
      return this.initialize().then(() => this.start());
    }
    
    console.log('Starting application...');
    eventBus.emit('app:started');
    
    // Setup default state based on stored settings
    const storageService = this.getService('storage');
    if (storageService) {
      const settings = storageService.getSettings();
      this.stateManager.setState({ settings });
    }
    
    return this;
  }
}

// Export singleton instance
export const app = new Application();
