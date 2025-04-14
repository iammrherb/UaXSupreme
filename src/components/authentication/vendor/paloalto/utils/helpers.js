/**
 * Palo Alto Networks Helper Utilities
 * This file contains helper functions specific to Palo Alto Networks devices
 */

/**
 * Format command output for Palo Alto Networks devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'PAN-OS':
    case 'Panorama':
      // Add platform-specific formatting
      return command;
    default:
      return command;
  }
}

/**
 * Check if a feature is supported on this platform
 * @param {String} feature Feature to check
 * @param {String} platform Platform name
 * @returns {Boolean} True if feature is supported
 */
export function isFeatureSupported(feature, platform) {
  // Define platform-feature support matrix
  const featureMatrix = {
    PAN-OS: {
    Panorama: {
      vpn: true,
      radius: true,
      tacacs: true,
      certauth: true,
    },
    PAN-OS },
    Panorama },
  };
  
  return featureMatrix[platform] && featureMatrix[platform][feature] === true;
}

/**
 * Get platform-specific command syntax
 * @param {String} commandType Type of command
 * @param {String} platform Platform name
 * @returns {String} Command syntax template
 */
export function getCommandSyntax(commandType, platform) {
  // Define command syntax for different platforms
  const syntaxMatrix = {
    PAN-OS: {
    Panorama: {
      'radius-server': 'paloalto-radius-server {address} key {secret}',
      'tacacs-server': 'paloalto-tacacs-server {address} key {secret}',
      'aaa': 'paloalto-aaa {method} {type}'
    },
    PAN-OS },
    Panorama },
  };
  
  if (syntaxMatrix[platform] && syntaxMatrix[platform][commandType]) {
    return syntaxMatrix[platform][commandType];
  }
  
  // Default syntax
  return '{command} {params}';
}

export default {
  formatCommand,
  isFeatureSupported,
  getCommandSyntax
};
