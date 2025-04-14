/**
 * Application constants and default settings
 */
export const CONFIG = {
  VERSION: '4.2.0',
  APP_NAME: 'Dot1Xer Supreme Enterprise Edition',
  DEFAULT_SETTINGS: {
    theme: 'light',
    fontSize: 'medium',
    aiProvider: 'openai',
    defaultVendor: 'cisco',
    autoSaveInterval: 5,
    rememberSettings: true,
    showAdvancedOptions: false
  },
  STORAGE_KEYS: {
    SETTINGS: 'dot1xer_settings',
    LAST_VISIT: 'dot1xer_last_visit',
    SELECTED_VENDOR: 'selectedVendor',
    SELECTED_PLATFORM: 'selectedPlatform',
    SOFTWARE_VERSION: 'softwareVersion',
    SAVED_CONFIGS: 'dot1xer_saved_configs',
    CHECKLIST: 'dot1xer_checklist'
  }
};
