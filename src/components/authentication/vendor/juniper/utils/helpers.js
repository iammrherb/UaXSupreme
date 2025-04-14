/**
 * Juniper Networks Helper Utilities
 * This file contains helper functions specific to Juniper Networks devices
 */

/**
 * Format command output for Juniper Networks devices
 * @param {String} command Command to format
 * @param {String} platform Platform name
 * @returns {String} Formatted command
 */
export function formatCommand(command, platform) {
  // Platform-specific formatting
  switch(platform.toLowerCase()) {
    case 'JunOS':
    case 'EX Series':
    case 'SRX Series':
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
    JunOS: {
    EX Series: {
    SRX Series: {
      dot1x: true,
      mab: true,
      radius: true,
      tacacs: true,
    },
    JunOS },
    EX Series },
    SRX Series },
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
    JunOS: {
    EX Series: {
    SRX Series: {
      'radius-server': 'juniper-radius-server {address} key {secret}',
      'tacacs-server': 'juniper-tacacs-server {address} key {secret}',
      'aaa': 'juniper-aaa {method} {type}'
    },
    JunOS },
    EX Series },
    SRX Series },
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
