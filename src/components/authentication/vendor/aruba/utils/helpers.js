/**
 * HPE Aruba Helper Utilities
 * This file contains helper functions specific to HPE Aruba devices
 */

/**
 * Format command output for HPE Aruba devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'AOS-CX':
    case 'AOS-Switch':
    case 'Instant AP':
    case 'ClearPass':
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
    AOS-CX: {
    AOS-Switch: {
    Instant AP: {
    ClearPass: {
      dot1x: true,
      mab: true,
      radius: true,
      tacacs: true,
      cppm: true,
    },
    AOS-CX },
    AOS-Switch },
    Instant AP },
    ClearPass },
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
    AOS-CX: {
    AOS-Switch: {
    Instant AP: {
    ClearPass: {
      'radius-server': 'aruba-radius-server {address} key {secret}',
      'tacacs-server': 'aruba-tacacs-server {address} key {secret}',
      'aaa': 'aruba-aaa {method} {type}'
    },
    AOS-CX },
    AOS-Switch },
    Instant AP },
    ClearPass },
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
