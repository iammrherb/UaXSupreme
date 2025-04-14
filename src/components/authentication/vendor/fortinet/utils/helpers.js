/**
 * Fortinet Helper Utilities
 * This file contains helper functions specific to Fortinet devices
 */

/**
 * Format command output for Fortinet devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'FortiOS':
    case 'FortiSwitch':
    case 'FortiWLC':
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
    FortiOS: {
    FortiSwitch: {
    FortiWLC: {
      dot1x: true,
      mab: true,
      radius: true,
      tacacs: true,
      802.1x: true,
    },
    FortiOS },
    FortiSwitch },
    FortiWLC },
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
    FortiOS: {
    FortiSwitch: {
    FortiWLC: {
      'radius-server': 'fortinet-radius-server {address} key {secret}',
      'tacacs-server': 'fortinet-tacacs-server {address} key {secret}',
      'aaa': 'fortinet-aaa {method} {type}'
    },
    FortiOS },
    FortiSwitch },
    FortiWLC },
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
