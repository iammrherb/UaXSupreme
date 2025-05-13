/**
 * UaXSupreme - Validation Module
 * Validates network authentication configurations
 */

(function() {
    'use strict';

    // Validation object
    const Validation = {
        /**
         * Initialize Validation
         */
        init: function() {
            console.log('Initializing Validation Module...');
            
            // Load validation rules
            this.loadRules();
        },
        
        /**
         * Load validation rules
         */
        loadRules: function() {
            // Common validation rules
            this.rules = {
                syntax: {
                    missingNewModel: {
                        pattern: /aaa authentication(?:(?!aaa new-model).)*$/is,
                        message: 'AAA commands found but "aaa new-model" is missing.',
                        recommendation: 'Add "aaa new-model" before AAA commands.',
                        severity: 'error'
                    },
                    emptyInterfaceRange: {
                        pattern: /interface range\s*(?:\n|$)/i,
                        message: 'Interface range command found without interface specifications.',
                        recommendation: 'Specify interfaces in the interface range command.',
                        severity: 'error'
                    },
                    missingVlan: {
                        pattern: /switchport mode access(?:(?!switchport access vlan).)*(?:\n\S|\n\s*\n|$)/is,
                        message: 'Access port configuration found without VLAN assignment.',
                        recommendation: 'Add "switchport access vlan <vlan-id>" to access ports.',
                        severity: 'warning'
                    },
                    emptyPolicyMap: {
                        pattern: /policy-map[^\n]*\n(?:(?!\s+class ).)*(?:\n\S|\n\s*\n|$)/is,
                        message: 'Policy map found without class configuration.',
                        recommendation: 'Add class configuration to policy maps.',
                        severity: 'error'
                    }
                },
                security: {
                    missingSystemAuthControl: {
                        pattern: /dot1x pae authenticator(?:(?!dot1x system-auth-control).)*$/is,
                        message: '802.1X interface configuration found but "dot1x system-auth-control" is missing.',
                        recommendation: 'Add "dot1x system-auth-control" to enable 802.1X globally.',
                        severity: 'error'
                    },
                    missingSourceGuard: {
                        pattern: /ip dhcp snooping(?:(?!ip verify source).)*$/is,
                        message: 'DHCP snooping enabled but IP Source Guard is not configured on interfaces.',
                        recommendation: 'Consider adding "ip verify source" to protect against IP spoofing.',
                        severity: 'warning'
                    },
                    missingNativeVlan: {
                        pattern: /switchport mode trunk(?:(?!switchport trunk native vlan).)*$/is,
                        message: 'Trunk ports found without explicit native VLAN configuration.',
                        recommendation: 'Set unused native VLAN with "switchport trunk native vlan <vlan-id>".',
                        severity: 'warning'
                    },
                    openAuthentication: {
                        pattern: /(authentication open|access-session (?:(?!closed).)*$)/is,
                        message: 'Monitor mode (open authentication) is enabled.',
                        recommendation: 'This is suitable for initial deployment but should be changed to closed mode for production.',
                        severity: 'info'
                    },
                    missingCriticalAuth: {
                        pattern: /(dot1x|mab)(?:(?!critical).)*$/is,
                        message: 'Authentication enabled but critical authentication is not configured.',
                        recommendation: 'Add critical authentication for RADIUS server failure handling.',
                        severity: 'warning'
                    }
                },
                compatibility: {
                    mixedAuthStyles: {
                        pattern: /authentication port-control.*access-session port-control/is,
                        message: 'Mixed old-style and new-style authentication commands detected.',
                        recommendation: 'Use consistently either old-style or new-style authentication commands.',
                        severity: 'error'
                    },
                    conflictingHostModes: {
                        pattern: /authentication host-mode.*dot1x host-mode/is,
                        message: 'Conflicting host mode commands detected.',
                        recommendation: 'Use either "authentication host-mode" or "dot1x host-mode" but not both.',
                        severity: 'error'
                    },
                    mixedDeviceTracking: {
                        pattern: /device-tracking attach-policy.*ip device tracking/is,
                        message: 'Mixed IOS and IOS-XE device tracking commands detected.',
                        recommendation: 'Use consistently either IOS or IOS-XE device tracking commands.',
                        severity: 'error'
                    }
                },
                performance: {
                    highTxPeriod: {
                        pattern: /tx-period\s+(\d\d+)/i,
                        message: 'TX period value is high which can delay authentication.',
                        recommendation: 'Set tx-period to a value between 5-10 seconds for better performance.',
                        severity: 'warning',
                        getValue: true
                    },
                    sequentialAuth: {
                        pattern: /do-until-failure.*authenticate using dot1x.*authenticate using mab/is,
                        message: 'Sequential authentication detected (dot1x then mab).',
                        recommendation: 'Consider using concurrent authentication with "do-all" for faster authentication.',
                        severity: 'info'
                    },
                    highTimeout: {
                        pattern: /timeout\s+(\d\d+)/i,
                        message: 'RADIUS timeout value is high which can delay authentication.',
                        recommendation: 'Set timeout to 3-5 seconds for better performance.',
                        severity: 'warning',
                        getValue: true
                    }
                }
            };
        },
        
        /**
         * Validate configuration against rules
         * @param {string} config - Configuration to validate
         * @param {Object} options - Validation options
         * @returns {Object} Validation results
         */
        validateConfig: function(config, options = {}) {
            const results = {
                issues: [],
                success: true,
                issueCount: {
                    error: 0,
                    warning: 0,
                    info: 0
                }
            };
            
            // Default options
            const defaultOptions = {
                syntax: true,
                security: true,
                compatibility: true,
                performance: true
            };
            
            const validateOptions = { ...defaultOptions, ...options };
            
            // Validate syntax
            if (validateOptions.syntax) {
                this.validateCategory(config, 'syntax', results);
            }
            
            // Validate security
            if (validateOptions.security) {
                this.validateCategory(config, 'security', results);
            }
            
            // Validate compatibility
            if (validateOptions.compatibility) {
                this.validateCategory(config, 'compatibility', results);
            }
            
            // Validate performance
            if (validateOptions.performance) {
                this.validateCategory(config, 'performance', results);
            }
            
            // Set success flag based on errors
            results.success = results.issueCount.error === 0;
            
            return results;
        },
        
        /**
         * Validate a single category of rules
         * @param {string} config - Configuration to validate
         * @param {string} category - Rule category
         * @param {Object} results - Results object to update
         */
        validateCategory: function(config, category, results) {
            const categoryRules = this.rules[category];
            
            for (const [ruleId, rule] of Object.entries(categoryRules)) {
                const match = config.match(rule.pattern);
                
                if (match) {
                    let message = rule.message;
                    
                    // If rule extracts a value, include it in the message
                    if (rule.getValue && match[1]) {
                        message = message.replace('value', `value (${match[1]})`);
                    }
                    
                    results.issues.push({
                        id: ruleId,
                        category: category,
                        message: message,
                        recommendation: rule.recommendation,
                        severity: rule.severity
                    });
                    
                    // Increment issue count
                    results.issueCount[rule.severity]++;
                }
            }
        },
        
        /**
         * Format validation results as HTML
         * @param {Object} results - Validation results
         * @returns {string} Formatted HTML
         */
        formatResults: function(results) {
            if (results.issues.length === 0) {
                return `
                    <div class="validation-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Validation successful! No issues found.</span>
                    </div>
                `;
            }
            
            let html = `
                <div class="validation-summary">
                    <span>Found ${results.issues.length} issue${results.issues.length > 1 ? 's' : ''}:</span>
                    <span class="issue-count error">${results.issueCount.error} error${results.issueCount.error !== 1 ? 's' : ''}</span>
                    <span class="issue-count warning">${results.issueCount.warning} warning${results.issueCount.warning !== 1 ? 's' : ''}</span>
                    <span class="issue-count info">${results.issueCount.info} info</span>
                </div>
                <div class="validation-issues">
            `;
            
            // Sort issues by severity (error, warning, info)
            const sortedIssues = [...results.issues].sort((a, b) => {
                const severityOrder = { error: 0, warning: 1, info: 2 };
                return severityOrder[a.severity] - severityOrder[b.severity];
            });
            
            // Add each issue
            for (const issue of sortedIssues) {
                html += `
                    <div class="validation-issue ${issue.severity}">
                        <div class="issue-icon">
                            <i class="fas fa-${issue.severity === 'error' ? 'times' : (issue.severity === 'warning' ? 'exclamation' : 'info')}-circle"></i>
                        </div>
                        <div class="issue-content">
                            <div class="issue-message">${issue.message}</div>
                            <div class="issue-recommendation">${issue.recommendation}</div>
                        </div>
                    </div>
                `;
            }
            
            html += `</div>`;
            return html;
        }
    };

    // Initialize Validation on page load
    document.addEventListener('DOMContentLoaded', function() {
        Validation.init();
    });

    // Export to window
    window.Validation = Validation;
})();
