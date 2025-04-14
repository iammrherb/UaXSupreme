/**
 * Check Point Software Helper Utilities
 * This file contains helper functions specific to Check Point Software devices
 */

/**
 * Format command output for Check Point Software devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'Gaia':
    case 'MDS':
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
    Gaia: {
    MDS: {
      vpn: true,
      radius: true,
      tacacs: true,
      identity: true,
    },
    Gaia },
    MDS },
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
    Gaia: {
    MDS: {
      'radius-server': 'checkpoint-radius-server {address} key {secret}',
      'tacacs-server': 'checkpoint-tacacs-server {address} key {secret}',
      'aaa': 'checkpoint-aaa {method} {type}'
    },
    Gaia },
    MDS },
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
