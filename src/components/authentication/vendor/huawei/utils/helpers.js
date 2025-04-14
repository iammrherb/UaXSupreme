/**
 * Huawei Helper Utilities
 * This file contains helper functions specific to Huawei devices
 */

/**
 * Format command output for Huawei devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'VRP':
    case 'S-Series':
    case 'USG':
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
    VRP: {
    S-Series: {
    USG: {
      dot1x: true,
      mab: true,
      radius: true,
      tacacs: true,
    },
    VRP },
    S-Series },
    USG },
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
    VRP: {
    S-Series: {
    USG: {
      'radius-server': 'huawei-radius-server {address} key {secret}',
      'tacacs-server': 'huawei-tacacs-server {address} key {secret}',
      'aaa': 'huawei-aaa {method} {type}'
    },
    VRP },
    S-Series },
    USG },
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
