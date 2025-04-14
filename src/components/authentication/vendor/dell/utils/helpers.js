/**
 * Dell Technologies Helper Utilities
 * This file contains helper functions specific to Dell Technologies devices
 */

/**
 * Format command output for Dell Technologies devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'OS10':
    case 'OS9':
    case 'OS6':
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
    OS10: {
    OS9: {
    OS6: {
      dot1x: true,
      mab: true,
      radius: true,
      tacacs: true,
    },
    OS10 },
    OS9 },
    OS6 },
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
    OS10: {
    OS9: {
    OS6: {
      'radius-server': 'dell-radius-server {address} key {secret}',
      'tacacs-server': 'dell-tacacs-server {address} key {secret}',
      'aaa': 'dell-aaa {method} {type}'
    },
    OS10 },
    OS9 },
    OS6 },
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
