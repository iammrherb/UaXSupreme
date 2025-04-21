/**
 * UaXSupreme - Configuration Validator
 * Validates generated configuration for errors and best practices
 */

(function() {
    'use strict';

    // Configuration Validator object
    const ConfigValidator = {
        /**
         * Validate configuration
         * @param {string} config - Configuration to validate
         * @returns {Object} Validation results
         */
        validate: function(config) {
            console.log('Validating configuration...');

            const issues = [];

            // Check for missing or incomplete configurations
            this.checkForMissingConfigurations(config, issues);

            // Check for security best practices
            this.checkSecurityBestPractices(config, issues);

            // Check for vendor-specific recommendations
            this.checkVendorSpecificRecommendations(config, issues);

            return {
                valid: issues.length === 0,
                issues: issues
            };
        },

        /**
         * Check for missing or incomplete configurations
         * @param {string} config - Configuration to check
         * @param {Array} issues - Array to collect issues
         */
        checkForMissingConfigurations: function(config, issues) {
            // Check for missing RADIUS/TACACS+ server configuration
            if (config.includes('{{') && config.includes('}}')) {
                issues.push('Configuration contains unresolved placeholders. Please fill in all required fields.');
            }

            // Check for empty or default passwords
            if (config.includes('secret cisco') || config.includes('key cisco')) {
                issues.push('Default or weak passwords detected. Please use strong, unique passwords.');
            }

            // Check if RADIUS/TACACS+ server IPs are specified
            if (config.includes('address ipv4 10.10.10.101') || config.includes('address ipv4 10.10.10.102')) {
                issues.push('Default RADIUS server IP addresses detected. Please specify actual server addresses.');
            }

            // Check for missing interface range
            if (config.includes('interface range Gigabit')) {
                issues.push('Generic interface range detected. Please specify actual interface range.');
            }
        },

        /**
         * Check for security best practices
         * @param {string} config - Configuration to check
         * @param {Array} issues - Array to collect issues
         */
        checkSecurityBestPractices: function(config, issues) {
            // Check for DHCP snooping
            if (!config.includes('ip dhcp snooping') && !config.includes('dhcpipv4 snooping')) {
                issues.push('DHCP Snooping is not enabled. Consider enabling it for additional security.');
            }

            // Check for BPDU guard
            if (!config.includes('spanning-tree bpduguard enable') && !config.includes('bpdu-guard')) {
                issues.push('BPDU Guard is not enabled on access ports. Consider enabling it to prevent Layer 2 loops.');
            }

            // Check for port security
            if (config.includes('no switchport port-security')) {
                issues.push('Port security is explicitly disabled. Consider enabling it for MAC address-based security.');
            }

            // Check for encrypted passwords
            if (config.includes('secret 0') || config.includes('key 0')) {
                issues.push('Unencrypted passwords detected. Consider using encrypted passwords.');
            }

            // Check for recommended timeouts
            if (!config.includes('exec-timeout') || config.includes('exec-timeout 0')) {
                issues.push('Console/VTY timeout is not properly configured. Consider setting appropriate timeouts.');
            }
        },

        /**
         * Check for vendor-specific recommendations
         * @param {string} config - Configuration to check
         * @param {Array} issues - Array to collect issues
         */
        checkVendorSpecificRecommendations: function(config, issues) {
            // Cisco IOS/IOS-XE specific checks
            if (config.includes('Cisco IOS') || config.includes('Cisco IOS-XE')) {
                // Check for device tracking
                if (!config.includes('device-tracking')) {
                    issues.push('IP Device Tracking is not configured. This is required for downloadable ACLs to work properly.');
                }

                // Check for dot1x system-auth-control
                if (!config.includes('dot1x system-auth-control')) {
                    issues.push('Global 802.1X is not enabled (dot1x system-auth-control).');
                }

                // Check for CoA
                if (!config.includes('aaa server radius dynamic-author')) {
                    issues.push('RADIUS Change of Authorization (CoA) is not configured. This is required for dynamic policy changes.');
                }
            }

            // Aruba specific checks
            if (config.includes('Aruba AOS-CX') || config.includes('Aruba AOS-Switch')) {
                // Aruba-specific checks would go here
            }
        }
    };

    // Export to window
    window.ConfigValidator = ConfigValidator;
})();
