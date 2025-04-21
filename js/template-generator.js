/**
 * UaXSupreme - Template Generator
 * Generates configuration templates based on user selection
 */

(function() {
    'use strict';

    // Template cache
    const templateCache = {};

    // Template placeholder regex
    const placeholderRegex = /\{\{([^}]+)\}\}/g;

    // Template Generator object
    const TemplateGenerator = {
        /**
         * Generate configuration based on parameters
         * @param {Object} params - Configuration parameters
         * @returns {string} Generated configuration
         */
        generateConfig: function(params) {
            console.log('Generating configuration with parameters:', params);

            try {
                // Determine template to use based on vendor, platform, and auth methods
                const template = this.selectTemplate(params);

                // Process template with parameters
                return this.processTemplate(template, params);
            } catch (error) {
                console.error('Error generating configuration:', error);
                throw error;
            }
        },

        /**
         * Select appropriate template based on parameters
         * @param {Object} params - Configuration parameters
         * @returns {string} Selected template
         */
        selectTemplate: function(params) {
            const { vendor, platform, authMethods, deploymentType } = params;

            // Use real template data if available, otherwise use placeholders
            try {
                // Try to load from template cache first
                const cacheKey = `${vendor}_${platform}_${deploymentType}`;

                if (templateCache[cacheKey]) {
                    console.log(`Using cached template for ${cacheKey}`);
                    return templateCache[cacheKey];
                }

                // Load template from server or use placeholder
                let template = '';

                // In a real implementation, this would load from the template directory
                // For now, use placeholders based on vendor and platform
                if (vendor === 'cisco') {
                    if (platform === 'IOS-XE') {
                        if (deploymentType === 'concurrent') {
                            template = this.getCiscoIOSXEConcurrentTemplate();
                        } else {
                            template = this.getCiscoIOSXEStandardTemplate();
                        }
                    } else if (platform === 'IOS') {
                        if (deploymentType === 'concurrent') {
                            template = this.getCiscoIOSConcurrentTemplate();
                        } else {
                            template = this.getCiscoIOSStandardTemplate();
                        }
                    } else if (platform === 'WLC-9800') {
                        if (authMethods.includes('tacacs')) {
                            template = this.getCiscoWLC9800TacacsTemplate();
                        } else {
                            template = this.getCiscoWLC9800RadiusTemplate();
                        }
                    } else {
                        template = this.getGenericTemplate(vendor, platform);
                    }
                } else if (vendor === 'aruba') {
                    if (platform === 'AOS-CX') {
                        template = this.getArubaAOSCXTemplate();
                    } else if (platform === 'AOS-Switch') {
                        template = this.getArubaAOSSwitchTemplate();
                    } else {
                        template = this.getGenericTemplate(vendor, platform);
                    }
                } else {
                    template = this.getGenericTemplate(vendor, platform);
                }

                // Cache template for future use
                templateCache[cacheKey] = template;

                return template;
            } catch (error) {
                console.error('Error selecting template:', error);
                return this.getGenericTemplate(vendor, platform);
            }
        },

        /**
         * Process template by replacing placeholders with values
         * @param {string} template - Template with placeholders
         * @param {Object} params - Parameters for replacement
         * @returns {string} Processed template
         */
        processTemplate: function(template, params) {
            let result = template;

            // Replace simple placeholders
            result = result.replace(placeholderRegex, (match, placeholder) => {
                // Split placeholder path (e.g., "radius.servers[0].ip")
                const path = placeholder.trim().split('.');

                // Navigate through params object to find value
                let value = params;

                for (let i = 0; i < path.length; i++) {
                    const key = path[i];

                    // Handle array access (e.g., "servers[0]")
                    const arrayMatch = key.match(/^([^\[]+)\[(\d+)\]$/);

                    if (arrayMatch) {
                        const arrayName = arrayMatch[1];
                        const arrayIndex = parseInt(arrayMatch[2], 10);

                        if (value[arrayName] && value[arrayName][arrayIndex] !== undefined) {
                            value = value[arrayName][arrayIndex];
                        } else {
                            value = undefined;
                            break;
                        }
                    } else if (value[key] !== undefined) {
                        value = value[key];
                    } else {
                        value = undefined;
                        break;
                    }
                }

                // Return value or empty string if undefined
                return value !== undefined ? value : '';
            });

            // Process conditional sections
            result = this.processConditionalSections(result, params);

            // Process special template logic
            result = this.processSpecialLogic(result, params);

            return result;
        },

        /**
         * Process conditional sections in template
         * @param {string} template - Template with conditionals
         * @param {Object} params - Parameters for evaluation
         * @returns {string} Processed template
         */
        processConditionalSections: function(template, params) {
            let result = template;

            // Simple if/endif conditional processing
            const ifRegex = /\{\{\s*if\s+([^}]+)\s*\}\}([\s\S]*?)\{\{\s*endif\s*\}\}/g;

            result = result.replace(ifRegex, (match, condition, content) => {
                try {
                    // Evaluate condition in the context of params
                    const conditionFn = new Function('params', `return ${condition};`);
                    const conditionResult = conditionFn(params);

                    return conditionResult ? content : '';
                } catch (error) {
                    console.error('Error evaluating condition:', condition, error);
                    return '';
                }
            });

            // if/else/endif conditional processing
            const ifElseRegex = /\{\{\s*if\s+([^}]+)\s*\}\}([\s\S]*?)\{\{\s*else\s*\}\}([\s\S]*?)\{\{\s*endif\s*\}\}/g;

            result = result.replace(ifElseRegex, (match, condition, ifContent, elseContent) => {
                try {
                    // Evaluate condition in the context of params
                    const conditionFn = new Function('params', `return ${condition};`);
                    const conditionResult = conditionFn(params);

                    return conditionResult ? ifContent : elseContent;
                } catch (error) {
                    console.error('Error evaluating condition:', condition, error);
                    return '';
                }
            });

            return result;
        },

        /**
         * Process special template logic
         * @param {string} template - Template with special logic
         * @param {Object} params - Parameters for processing
         * @returns {string} Processed template
         */
        processSpecialLogic: function(template, params) {
            let result = template;

            // Special case for RADIUS source interface
            if (params.radius && params.radius.advanced && params.radius.advanced.sourceInterface) {
                const sourceInterface = params.radius.advanced.sourceInterfaceValue || '';

                if (sourceInterface) {
                    result = result.replace('{{RADIUS_SOURCE_INTERFACE}}', `ip radius source-interface ${sourceInterface}`);
                } else {
                    result = result.replace('{{RADIUS_SOURCE_INTERFACE}}', '');
                }
            }

            // Special case for interface template
            if (params.interfaces && params.interfaces.access && params.interfaces.access.range) {
                // Replace interface range placeholder if present
                result = result.replace('{{INTERFACE_RANGE}}', params.interfaces.access.range);
            }

            // Handle authentication type selection
            const authTypes = params.authMethods || [];

            if (!authTypes.includes('dot1x')) {
                // Remove 802.1X specific configurations
                result = result.replace(/dot1x[^\n]*\n/g, '');
            }

            if (!authTypes.includes('mab')) {
                // Remove MAB specific configurations
                result = result.replace(/mab[^\n]*\n/g, '');
            }

            return result;
        },

        /**
         * Get Cisco IOS-XE concurrent 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSXEConcurrentTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS-XE IBNS 2.0 Concurrent 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
device-tracking tracking auto-source

! Device Tracking Policy for Trunk Ports
device-tracking policy DISABLE-IP-TRACKING
 tracking disable
 trusted-port
 device-role switch

! Device Tracking Policy for Access Ports
device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Concurrent 802.1X and MAB
policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-all
   10 authenticate using dot1x priority 10
   20 authenticate using mab priority 20
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 device-tracking attach-policy IP-TRACKING
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco IOS-XE standard 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSXEStandardTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS-XE IBNS 2.0 Standard 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
device-tracking tracking auto-source

! Device Tracking Policy for Trunk Ports
device-tracking policy DISABLE-IP-TRACKING
 tracking disable
 trusted-port
 device-role switch

! Device Tracking Policy for Access Ports
device-tracking policy IP-TRACKING
 limit address-count 4
 security-level glean
 no protocol ndp
 no protocol dhcp6
 tracking enable reachable-lifetime 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Sequential 802.1X and MAB
policy-map type control subscriber DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-until-failure
   10 authenticate using dot1x priority 10
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class MAB_FAILED do-until-failure
   10 terminate mab
   20 authentication-restart 60
  60 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 device-tracking attach-policy IP-TRACKING
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco IOS concurrent 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSConcurrentTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS IBNS 2.0 Concurrent 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
ip device tracking probe auto-source
ip device tracking probe delay 10
ip device tracking probe interval 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Concurrent 802.1X and MAB
policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-all
   10 authenticate using dot1x priority 10
   20 authenticate using mab priority 20
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 ip device tracking maximum 4
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast edge
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco IOS standard 802.1X and MAB template
         * @returns {string} Template
         */
        getCiscoIOSStandardTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco IOS IBNS 2.0 Standard 802.1X and MAB Configuration
! -----------------------------------------------------

authentication convert-to new-style yes

! Enable AAA services
aaa new-model
aaa session-id common
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting update newinfo periodic 1440
aaa accounting identity default start-stop group {{radius.serverGroup}}
aaa accounting network default start-stop group {{radius.serverGroup}}

! Configure RADIUS servers
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[0].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 key {{radius.servers[1].key}}
 automate-tester username {{radius.advanced.testUsername}} probe-on

! Configure RADIUS server group
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

! Configure Change of Authorization (CoA)
aaa server radius dynamic-author
 client {{radius.servers[0].ip}} server-key {{radius.servers[0].key}}
 client {{radius.servers[1].ip}} server-key {{radius.servers[1].key}}
 auth-type any

! Configure RADIUS attributes
radius-server vsa send authentication
radius-server vsa send accounting
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server load-balance method least-outstanding

! Configure 802.1X
dot1x system-auth-control
dot1x critical eapol
authentication critical recovery delay {{advancedFeatures.security.criticalSettings.recoveryDelay}}
no access-session mac-move deny
access-session acl default passthrough
errdisable recovery cause all
errdisable recovery interval 30

! IP Device Tracking Configuration
ip device tracking probe auto-source
ip device tracking probe delay 10
ip device tracking probe interval 30

! Device Classifier Configuration
device classifier

! Configure service templates
service-template CRITICAL_DATA_ACCESS
 vlan {{advancedFeatures.security.criticalSettings.dataVlan}}
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan {{advancedFeatures.security.criticalSettings.voiceVlan}}
 access-group ACL-OPEN

! Configure Class Maps for IBNS 2.0
class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-all DOT1X
 match method dot1x

class-map type control subscriber match-all DOT1X_FAILED
 match method dot1x
 match result-type method dot1x authoritative

class-map type control subscriber match-all DOT1X_NO_RESP
 match method dot1x
 match result-type method dot1x agent-not-found

class-map type control subscriber match-all DOT1X_TIMEOUT
 match method dot1x
 match result-type method dot1x method-timeout
 match result-type method-timeout

class-map type control subscriber match-all MAB
 match method mab

class-map type control subscriber match-all MAB_FAILED
 match method mab
 match result-type method mab authoritative

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-all AUTHC_SUCCESS-AUTHZ_FAIL
 match authorization-status unauthorized
 match result-type success

! Configure Open ACL
ip access-list extended ACL-OPEN
 permit ip any any

! Configure Policy Map for Sequential 802.1X and MAB
policy-map type control subscriber DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-until-failure
   10 authenticate using dot1x priority 10
 event authentication-failure match-first
  5 class DOT1X_FAILED do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure
   10 clear-authenticated-data-hosts-on-port
   20 activate service-template CRITICAL_DATA_ACCESS
   30 activate service-template CRITICAL_VOICE_ACCESS
   40 authorize
   50 pause reauthentication
  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure
   10 pause reauthentication
   20 authorize
  30 class DOT1X_NO_RESP do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  40 class DOT1X_TIMEOUT do-until-failure
   10 terminate dot1x
   20 authenticate using mab priority 20
  50 class MAB_FAILED do-until-failure
   10 terminate mab
   20 authentication-restart 60
  60 class always do-until-failure
   10 terminate dot1x
   20 terminate mab
   30 authentication-restart 60
 event agent-found match-all
  10 class always do-until-failure
   10 terminate mab
   20 authenticate using dot1x priority 10
 event aaa-available match-all
  10 class IN_CRITICAL_AUTH do-until-failure
   10 clear-session
  20 class NOT_IN_CRITICAL_AUTH do-until-failure
   10 resume reauthentication
 event inactivity-timeout match-all
  10 class always do-until-failure
   10 clear-session
 event authentication-success match-all
  10 class always do-until-failure
   10 activate service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 event violation match-all
  10 class always do-until-failure
   10 restrict
 event authorization-failure match-all
  10 class AUTHC_SUCCESS-AUTHZ_FAIL do-until-failure
   10 authentication-restart 60

! Interface Template Configuration
template WIRED_DOT1X_CLOSED
 dot1x pae authenticator
 dot1x timeout tx-period {{interfaces.access.dot1x.txPeriod}}
 dot1x max-reauth-req {{interfaces.access.dot1x.maxReauthReq}}
 mab
 subscriber aging inactivity-timer {{interfaces.access.dot1x.inactivityTimer}} probe
 access-session control-direction {{interfaces.access.dot1x.controlDirection}}
 access-session host-mode {{interfaces.access.dot1x.hostMode}}
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber DOT1X_MAB_POLICY

! Interface configuration example
interface range {{INTERFACE_RANGE}}
 switchport mode access
 switchport access vlan {{interfaces.access.vlan}}
 switchport voice vlan {{interfaces.access.voiceVlan}}
 switchport nonegotiate
 no switchport port-security
 ip device tracking maximum 4
 ip dhcp snooping limit rate 20
 no macro auto processing
 storm-control broadcast level pps 100 80
 storm-control action trap
 spanning-tree portfast edge
 spanning-tree bpduguard enable
 spanning-tree guard root
 load-interval 30
 source template WIRED_DOT1X_CLOSED`;
        },

        /**
         * Get Cisco WLC 9800 TACACS+ template
         * @returns {string} Template
         */
        getCiscoWLC9800TacacsTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco WLC 9800 TACACS+ Authentication Configuration
! -----------------------------------------------------

! Create local fallback account:
username admin privilege 15 algorithm-type sha256 secret {{tacacs.servers[0].key}}
enable algorithm-type sha256 secret {{tacacs.servers[0].key}}

! Enable AAA services:
aaa new-model

! Configure TACACS+ servers:
tacacs server {{tacacs.servers[0].name}}
 address ipv4 {{tacacs.servers[0].ip}}
 key {{tacacs.servers[0].key}}
 timeout {{tacacs.timeout}}

tacacs server {{tacacs.servers[1].name}}
 address ipv4 {{tacacs.servers[1].ip}}
 key {{tacacs.servers[1].key}}
 timeout {{tacacs.timeout}}

! Configure TACACS+ Server Group:
aaa group server tacacs+ {{tacacs.serverGroup}}
 server name {{tacacs.servers[0].name}}
 server name {{tacacs.servers[1].name}}
 ip vrf forwarding MGMT
 ip tacacs source-interface {{tacacs.sourceInterface}}

! Create Method List to use TACACS+ logins primarily.
! Fallback to Local User Accounts ONLY if all TACACS+ servers fail.
aaa authentication login {{tacacs.authMethod}} group {{tacacs.serverGroup}} local
aaa authorization exec {{tacacs.authzMethod}} group {{tacacs.serverGroup}} local if-authenticated
aaa authorization console

! Configure Accounting
aaa accounting commands 0 default start-stop group {{tacacs.serverGroup}}
aaa accounting commands 1 default start-stop group {{tacacs.serverGroup}}
aaa accounting commands 15 default start-stop group {{tacacs.serverGroup}}

! Activate AAA TACACS+ for HTTPS Web GUI:
ip http authentication aaa login-authentication {{tacacs.authMethod}}
ip http authentication aaa exec-authorization {{tacacs.authzMethod}}

! Activate AAA TACACS+ for NETCONF/RESTCONF authentication
yang-interfaces aaa authentication method-list {{tacacs.authMethod}}
yang-interfaces aaa authorization method-list {{tacacs.authzMethod}}

! Restart HTTP/HTTPS services:
no ip http server
no ip http secure-server
ip http server
ip http secure-server

! Activate AAA TACACS+ authentication for SSH sessions:
line vty 0 97
 exec-timeout 30 0
 login authentication {{tacacs.authMethod}}
 authorization exec {{tacacs.authzMethod}}
 transport preferred none
 transport input ssh
 transport output none

! Activate AAA TACACS+ authentication for the Console port:
line con 0
 exec-timeout 15 0
 transport preferred none
 login authentication {{tacacs.authMethod}}
 authorization exec {{tacacs.authzMethod}}`;
        },

        /**
         * Get Cisco WLC 9800 RADIUS template
         * @returns {string} Template
         */
        getCiscoWLC9800RadiusTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Cisco WLC 9800 RADIUS Authentication Configuration
! -----------------------------------------------------

! Create local fallback account:
username admin privilege 15 algorithm-type sha256 secret {{radius.servers[0].key}}
enable algorithm-type sha256 secret {{radius.servers[0].key}}

! Create non-usable account for RADIUS server probing:
username {{radius.advanced.testUsername}} privilege 0 algorithm-type sha256 secret ciscodisco123!
username {{radius.advanced.testUsername}} autocommand exit

! Enable AAA services:
aaa new-model

! Configure RADIUS servers:
radius server {{radius.servers[0].name}}
 address ipv4 {{radius.servers[0].ip}} auth-port {{radius.servers[0].authPort}} acct-port {{radius.servers[0].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 automate-tester username {{radius.advanced.testUsername}} probe-on
 key {{radius.servers[0].key}}

radius server {{radius.servers[1].name}}
 address ipv4 {{radius.servers[1].ip}} auth-port {{radius.servers[1].authPort}} acct-port {{radius.servers[1].acctPort}}
 timeout {{radius.timeout}}
 retransmit {{radius.advanced.retransmit}}
 automate-tester username {{radius.advanced.testUsername}} probe-on
 key {{radius.servers[1].key}}

! Configure RADIUS Server Group:
aaa group server radius {{radius.serverGroup}}
 server name {{radius.servers[0].name}}
 server name {{radius.servers[1].name}}
 deadtime {{radius.advanced.deadtimeValue}}
 {{RADIUS_SOURCE_INTERFACE}}

radius-server load-balance method {{radius.advanced.loadBalanceMethod}}
radius-server dead-criteria time 5 tries 3

! Create Method List to use RADIUS logins primarily.
! Fallback to Local User Accounts ONLY if all RADIUS servers fail.
aaa authentication login {{radius.authMethod}} group {{radius.serverGroup}} local
aaa authorization exec {{radius.authMethod}} group {{radius.serverGroup}} local if-authenticated
aaa authorization console

! Configure Accounting
aaa accounting exec default start-stop group {{radius.serverGroup}}

! Activate AAA RADIUS for HTTPS Web GUI:
ip http authentication aaa login-authentication {{radius.authMethod}}
ip http authentication aaa exec-authorization {{radius.authMethod}}

! Activate AAA RADIUS for NETCONF/RESTCONF authentication
yang-interfaces aaa authentication method-list {{radius.authMethod}}
yang-interfaces aaa authorization method-list {{radius.authMethod}}

! Restart HTTP/HTTPS services:
no ip http server
no ip http secure-server
ip http server
ip http secure-server

! Activate AAA RADIUS authentication for SSH sessions:
line vty 0 97
 exec-timeout 30 0
 login authentication {{radius.authMethod}}
 authorization exec {{radius.authMethod}}
 transport preferred none
 transport input ssh
 transport output none

! Activate AAA RADIUS authentication for the Console port:
line con 0
 exec-timeout 15 0
 transport preferred none
 login authentication {{radius.authMethod}}
 authorization exec {{radius.authMethod}}`;
        },

        /**
         * Get Aruba AOS-CX template
         * @returns {string} Template
         */
        getArubaAOSCXTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Aruba AOS-CX 802.1X and MAB Authentication Configuration
! -----------------------------------------------------

! Configure RADIUS servers
radius-server host {{radius.servers[0].ip}} key {{radius.servers[0].key}}
radius-server host {{radius.servers[1].ip}} key {{radius.servers[1].key}}

! Configure RADIUS server group
aaa group radius {{radius.serverGroup}}
 server {{radius.servers[0].ip}}
 server {{radius.servers[1].ip}}

! Configure authentication method
aaa authentication dot1x default group {{radius.serverGroup}}
aaa authorization network default group {{radius.serverGroup}}
aaa accounting dot1x default start-stop group {{radius.serverGroup}}

! Enable 802.1X globally
aaa authentication port-access dot1x authenticator

! Configure interface settings for 802.1X
interface {{interfaces.access.range}}
 no shutdown
 aaa authentication port-access dot1x authenticator
 aaa port-access authenticator
 aaa port-access authenticator {{interfaces.access.range}} client-limit 3
 aaa port-access authenticator {{interfaces.access.range}} logoff-period 300
 aaa port-access authenticator {{interfaces.access.range}} max-requests 2
 aaa port-access authenticator {{interfaces.access.range}} max-retries {{interfaces.access.dot1x.maxReauthReq}}
 aaa port-access authenticator {{interfaces.access.range}} quiet-period 60
 aaa port-access authenticator {{interfaces.access.range}} server-timeout 30
 aaa port-access authenticator {{interfaces.access.range}} reauth-period 3600
 aaa port-access authenticator {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}
 aaa port-access authenticator {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}
 aaa port-access authenticator {{interfaces.access.range}} auth-vlan {{interfaces.access.vlan}}
 aaa port-access authenticator {{interfaces.access.range}} initialize
 aaa port-access authenticator active`;
        },

        /**
         * Get Aruba AOS-Switch template
         * @returns {string} Template
         */
        getArubaAOSSwitchTemplate: function() {
            // This would typically load from a file or database
            return `! -----------------------------------------------------
! Aruba AOS-Switch 802.1X and MAB Authentication Configuration
! -----------------------------------------------------

! Configure RADIUS servers
radius-server host {{radius.servers[0].ip}} key {{radius.servers[0].key}}
radius-server host {{radius.servers[1].ip}} key {{radius.servers[1].key}}
radius-server retransmit {{radius.advanced.retransmit}}
radius-server timeout {{radius.timeout}}

! Enable 802.1X and MAB authentication globally
aaa authentication port-access eap-radius
aaa authentication mac-based enable
aaa authentication mac-based address-format no-delimiter uppercase
aaa authentication mac-based auth-vid {{interfaces.access.vlan}}
aaa authentication mac-based unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}

! Configure interface for 802.1X and MAB
interface {{interfaces.access.range}}
 aaa authentication port-access auth-mode {{deploymentType}}
 aaa authentication port-access enable
 aaa authentication port-access {{interfaces.access.range}} auth-mode {{deploymentType}}
 aaa authentication port-access {{interfaces.access.range}} control auto
 aaa authentication port-access {{interfaces.access.range}} dot1x enable
 aaa authentication port-access {{interfaces.access.range}} mac-based enable
 aaa authentication port-access {{interfaces.access.range}} reauth-period server
 aaa authentication port-access {{interfaces.access.range}} max-retries {{interfaces.access.dot1x.maxReauthReq}}
 aaa authentication port-access {{interfaces.access.range}} quiet-period 60
 aaa authentication port-access {{interfaces.access.range}} tx-period {{interfaces.access.dot1x.txPeriod}}
 aaa authentication port-access {{interfaces.access.range}} auth-vid {{interfaces.access.vlan}}
 aaa authentication port-access {{interfaces.access.range}} unauth-vid {{advancedFeatures.guest.guestVlanSettings.id}}
 spanning-tree port-admin edge
 spanning-tree bpdu-guard
 speed-duplex auto
 no allow-jumbo-frames`;
        },

        /**
         * Get generic template for unsupported vendor/platform
         * @param {string} vendor - Vendor name
         * @param {string} platform - Platform name
         * @returns {string} Template
         */
        getGenericTemplate: function(vendor, platform) {
            return `! -----------------------------------------------------
! ${vendor} ${platform} Authentication Configuration
! -----------------------------------------------------

! This is a placeholder template for ${vendor} ${platform}.
! Detailed templates for this platform are currently under development.
!
! Based on your selected options, you would typically configure:
!
! 1. RADIUS/TACACS+ server settings
! 2. Authentication methods (802.1X, MAB, etc.)
! 3. Interface settings for authentication
! 4. Advanced security features
!
! Please refer to ${vendor} documentation for specific commands
! and syntax for ${platform}.`;
        }
    };

    // Export to window
    window.TemplateGenerator = TemplateGenerator;
})();
