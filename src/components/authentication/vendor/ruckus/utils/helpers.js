/**
 * CommScope Ruckus Helper Utilities
 * This file contains helper functions specific to CommScope Ruckus devices
 */

/**
 * Format command output for CommScope Ruckus devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'FastIron':
    case 'SmartZone':
    case 'ICX':
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
    FastIron: {
    SmartZone: {
    ICX: {
      dot1x: true,
      mab: true,
      radius: true,
    },
    FastIron },
    SmartZone },
    ICX },
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
    FastIron: {
    SmartZone: {
    ICX: {
      'radius-server': 'ruckus-radius-server {address} key {secret}',
      'tacacs-server': 'ruckus-tacacs-server {address} key {secret}',
      'aaa': 'ruckus-aaa {method} {type}'
    },
    FastIron },
    SmartZone },
    ICX },
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
