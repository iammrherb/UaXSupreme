/**
 * F5 Networks Helper Utilities
 * This file contains helper functions specific to F5 Networks devices
 */

/**
 * Format command output for F5 Networks devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'BIG-IP':
    case 'TMOS':
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
    BIG-IP: {
    TMOS: {
      vpn: true,
      radius: true,
      tacacs: true,
      policyauth: true,
    },
    BIG-IP },
    TMOS },
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
    BIG-IP: {
    TMOS: {
      'radius-server': 'f5-radius-server {address} key {secret}',
      'tacacs-server': 'f5-tacacs-server {address} key {secret}',
      'aaa': 'f5-aaa {method} {type}'
    },
    BIG-IP },
    TMOS },
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
