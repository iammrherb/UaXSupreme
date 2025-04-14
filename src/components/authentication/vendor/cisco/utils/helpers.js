/**
 * Cisco Systems Helper Utilities
 * This file contains helper functions specific to Cisco Systems devices
 */

/**
 * Format command output for Cisco Systems devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'iOS':
    case 'iOS-XE':
    case 'NX-OS':
    case 'ISE':
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
    iOS: {
    iOS-XE: {
    NX-OS: {
    ISE: {
      dot1x: true,
      mab: true,
      radsec: true,
      macsec: true,
      tacacs: true,
    },
    iOS },
    iOS-XE },
    NX-OS },
    ISE },
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
    iOS: {
    iOS-XE: {
    NX-OS: {
    ISE: {
      'radius-server': 'cisco-radius-server {address} key {secret}',
      'tacacs-server': 'cisco-tacacs-server {address} key {secret}',
      'aaa': 'cisco-aaa {method} {type}'
    },
    iOS },
    iOS-XE },
    NX-OS },
    ISE },
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
