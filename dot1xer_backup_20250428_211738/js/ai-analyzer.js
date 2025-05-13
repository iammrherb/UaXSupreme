/**
 * UaXSupreme - AI Analyzer
 * Analyzes and optimizes network authentication configurations
 */

(function() {
    'use strict';

    // AI Analyzer object
    const AIAnalyzer = {
        /**
         * Initialize AI Analyzer
         */
        init: function() {
            console.log('Initializing AI Analyzer...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Analyze configuration button
            const analyzeConfigBtn = document.getElementById('analyzeConfigBtn');
            if (analyzeConfigBtn) {
                analyzeConfigBtn.addEventListener('click', this.analyzeConfiguration.bind(this));
            }
            
            // Security analysis button
            const securityAnalysisBtn = document.getElementById('securityAnalysisBtn');
            if (securityAnalysisBtn) {
                securityAnalysisBtn.addEventListener('click', this.performSecurityAnalysis.bind(this));
            }
            
            // Optimize configuration button
            const optimizeConfigBtn = document.getElementById('optimizeConfigBtn');
            if (optimizeConfigBtn) {
                optimizeConfigBtn.addEventListener('click', this.optimizeConfiguration.bind(this));
            }
            
            // Start optimization button
            const startOptimizationBtn = document.getElementById('startOptimizationBtn');
            if (startOptimizationBtn) {
                startOptimizationBtn.addEventListener('click', this.startOptimization.bind(this));
            }
            
            // Generate recommendations button
            const generateRecommendationsBtn = document.getElementById('generateRecommendationsBtn');
            if (generateRecommendationsBtn) {
                generateRecommendationsBtn.addEventListener('click', this.generateRecommendations.bind(this));
            }
            
            // Apply recommendations button
            const applyRecommendationsBtn = document.getElementById('applyRecommendationsBtn');
            if (applyRecommendationsBtn) {
                applyRecommendationsBtn.addEventListener('click', this.applyRecommendations.bind(this));
            }
            
            // Fix security issues button
            const fixSecurityIssuesBtn = document.getElementById('fixSecurityIssuesBtn');
            if (fixSecurityIssuesBtn) {
                fixSecurityIssuesBtn.addEventListener('click', this.fixSecurityIssues.bind(this));
            }
        },
        
        /**
         * Analyze configuration for security, performance, and best practices
         */
        analyzeConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;
            
            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Show loading indicator
            this.showLoadingIndicator('Analyzing configuration with AI...');
            
            // Simulate analysis by adding a delay
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();
                
                // Analyze the configuration
                const analysisResults = this.performAnalysis(config);
                
                // Display analysis results
                this.displayAnalysisResults(analysisResults);
                
                // Switch to AI Analysis tab
                const aiAnalysisStep = document.querySelector('.nav-steps li[data-step="ai-analysis"]');
                if (aiAnalysisStep) {
                    aiAnalysisStep.click();
                }
                
                // Show success message
                this.showToast('Configuration analyzed successfully.');
            }, 2000);
        },
        
        /**
         * Show loading indicator
         * @param {string} message - Loading message
         */
        showLoadingIndicator: function(message) {
            // Create loading indicator if it doesn't exist
            if (!document.getElementById('aiLoadingIndicator')) {
                const loadingDiv = document.createElement('div');
                loadingDiv.id = 'aiLoadingIndicator';
                loadingDiv.className = 'ai-loading-indicator';
                
                const spinnerDiv = document.createElement('div');
                spinnerDiv.className = 'ai-spinner';
                spinnerDiv.innerHTML = '<i class="fas fa-circle-notch fa-spin"></i>';
                
                const messageDiv = document.createElement('div');
                messageDiv.id = 'aiLoadingMessage';
                messageDiv.className = 'ai-loading-message';
                
                loadingDiv.appendChild(spinnerDiv);
                loadingDiv.appendChild(messageDiv);
                
                // Add to body
                document.body.appendChild(loadingDiv);
            }
            
            // Update message and show
            document.getElementById('aiLoadingMessage').textContent = message;
            document.getElementById('aiLoadingIndicator').style.display = 'flex';
        },
        
        /**
         * Hide loading indicator
         */
        hideLoadingIndicator: function() {
            const loadingIndicator = document.getElementById('aiLoadingIndicator');
            if (loadingIndicator) {
                loadingIndicator.style.display = 'none';
            }
        },
        
        /**
         * Perform analysis on configuration
         * @param {string} config - Configuration to analyze
         * @returns {Object} Analysis results
         */
        performAnalysis: function(config) {
            // Detect vendor and platform
            const vendorInfo = this.detectVendorAndPlatform(config);
            
            // Analyze security aspects
            const securityScore = this.analyzeSecurityAspects(config, vendorInfo);
            
            // Analyze best practices
            const bestPractices = this.analyzeBestPractices(config, vendorInfo);
            
            // Analyze performance aspects
            const performanceScore = this.analyzePerformance(config, vendorInfo);
            
            // Generate recommendations
            const recommendations = this.generateRecommendationList(config, vendorInfo, securityScore, bestPractices, performanceScore);
            
            // Calculate overall score (weighted average)
            const overallScore = Math.round(
                (securityScore.score * 0.5) + 
                (bestPractices.score * 0.3) + 
                (performanceScore.score * 0.2)
            );
            
            return {
                vendor: vendorInfo.vendor,
                platform: vendorInfo.platform,
                overallScore: overallScore,
                securityScore: securityScore,
                bestPractices: bestPractices,
                performanceScore: performanceScore,
                recommendations: recommendations
            };
        },
        
        /**
         * Detect vendor and platform from configuration
         * @param {string} config - Configuration to analyze
         * @returns {Object} Vendor and platform information
         */
        detectVendorAndPlatform: function(config) {
            let vendor = 'unknown';
            let platform = 'unknown';
            
            // Check for Cisco IOS/IOS-XE
            if (config.includes('aaa new-model') || config.includes('interface GigabitEthernet')) {
                vendor = 'cisco';
                
                if (config.includes('IBNS') || config.includes('POLICY') || 
                    config.includes('service-policy type control subscriber') ||
                    config.includes('access-session')) {
                    platform = 'ios-xe';
                } else {
                    platform = 'ios';
                }
            }
            // Check for Aruba
            else if (config.includes('aaa authentication port-access') || 
                     config.includes('aaa port-access authenticator')) {
                vendor = 'aruba';
                
                if (config.includes('aaa port-access authenticator active')) {
                    platform = 'arubaos-switch';
                } else {
                    platform = 'arubaos-cx';
                }
            }
            // Check for Juniper
            else if (config.includes('system {') || config.includes('protocols {')) {
                vendor = 'juniper';
                platform = 'junos';
            }
            
            return { vendor, platform };
        },
        
        /**
         * Analyze security aspects of the configuration
         * @param {string} config - Configuration to analyze
         * @param {Object} vendorInfo - Vendor and platform information
         * @returns {Object} Security analysis results
         */
        analyzeSecurityAspects: function(config, vendorInfo) {
            const issues = [];
            const strengths = [];
            
            // Check for 802.1X authentication
            if (config.includes('dot1x') || config.includes('port-access')) {
                strengths.push({
                    category: 'Authentication',
                    description: '802.1X authentication is configured, providing strong security.'
                });
            } else {
                issues.push({
                    category: 'Authentication',
                    severity: 'high',
                    description: '802.1X authentication is not configured.',
                    recommendation: 'Implement 802.1X authentication for stronger security.'
                });
            }
            
            // Check for DHCP snooping
            if (config.includes('ip dhcp snooping') || config.includes('dhcp-snooping')) {
                strengths.push({
                    category: 'Layer 2 Security',
                    description: 'DHCP snooping is enabled, protecting against rogue DHCP servers.'
                });
            } else {
                issues.push({
                    category: 'Layer 2 Security',
                    severity: 'medium',
                    description: 'DHCP snooping is not configured.',
                    recommendation: 'Enable DHCP snooping to prevent rogue DHCP servers and IP spoofing attacks.'
                });
            }
            
            // Check for Dynamic ARP Inspection
            if (config.includes('ip arp inspection') || config.includes('arp-protect')) {
                strengths.push({
                    category: 'Layer 2 Security',
                    description: 'Dynamic ARP Inspection is enabled, protecting against ARP spoofing.'
                });
            } else {
                issues.push({
                    category: 'Layer 2 Security',
                    severity: 'medium',
                    description: 'Dynamic ARP Inspection is not configured.',
                    recommendation: 'Enable Dynamic ARP Inspection to prevent ARP spoofing attacks.'
                });
            }
            
            // Check for BPDU Guard
            if (config.includes('spanning-tree bpduguard') || config.includes('bpdu-guard')) {
                strengths.push({
                    category: 'Layer 2 Security',
                    description: 'BPDU Guard is enabled, protecting against spanning-tree attacks.'
                });
            } else {
                issues.push({
                    category: 'Layer 2 Security',
                    severity: 'medium',
                    description: 'BPDU Guard is not configured.',
                    recommendation: 'Enable BPDU Guard on access ports to prevent spanning-tree manipulation.'
                });
            }
            
            // Check for authentication mode (closed vs monitor)
            if (config.includes('authentication open') || 
                (config.includes('access-session') && !config.includes('access-session closed'))) {
                issues.push({
                    category: 'Authentication',
                    severity: 'low',
                    description: 'Authentication is in monitor mode (open).',
                    recommendation: 'Switch to closed mode in production environments for better security.'
                });
            } else if (config.includes('access-session closed') || 
                       (!config.includes('authentication open') && config.includes('authentication port-control auto'))) {
                strengths.push({
                    category: 'Authentication',
                    description: 'Authentication is in closed mode, enforcing authentication policies.'
                });
            }
            
            // Check for RADIUS server redundancy
            const radiusServerCount = (config.match(/radius[\s-]server/g) || []).length;
            if (radiusServerCount >= 2) {
                strengths.push({
                    category: 'Availability',
                    description: 'Multiple RADIUS servers configured for redundancy.'
                });
            } else if (radiusServerCount === 1) {
                issues.push({
                    category: 'Availability',
                    severity: 'medium',
                    description: 'Only one RADIUS server configured.',
                    recommendation: 'Configure at least two RADIUS servers for redundancy.'
                });
            }
            
            // Check for critical authentication
            if (config.includes('critical') || config.includes('CRITICAL_')) {
                strengths.push({
                    category: 'Availability',
                    description: 'Critical authentication configured for RADIUS server failure.'
                });
            } else {
                issues.push({
                    category: 'Availability',
                    severity: 'medium',
                    description: 'Critical authentication not configured.',
                    recommendation: 'Configure critical authentication to handle RADIUS server failures.'
                });
            }
            
            // Calculate security score (0-100)
            // More weight to high severity issues
            const highIssuesCount = issues.filter(issue => issue.severity === 'high').length;
            const mediumIssuesCount = issues.filter(issue => issue.severity === 'medium').length;
            const lowIssuesCount = issues.filter(issue => issue.severity === 'low').length;
            
            let score = 100;
            score -= highIssuesCount * 15; // Each high issue reduces score by 15
            score -= mediumIssuesCount * 10; // Each medium issue reduces score by 10
            score -= lowIssuesCount * 5; // Each low issue reduces score by 5
            
            // Bonus for strengths
            score += Math.min(20, strengths.length * 5); // Up to 20 points bonus
            
            // Ensure score is between 0 and 100
            score = Math.max(0, Math.min(100, score));
            
            return {
                score: score,
                issues: issues,
                strengths: strengths
            };
        },
        
        /**
         * Analyze best practices implementation
         * @param {string} config - Configuration to analyze
         * @param {Object} vendorInfo - Vendor and platform information
         * @returns {Object} Best practices analysis results
         */
        analyzeBestPractices: function(config, vendorInfo) {
            const implemented = [];
            const missing = [];
            
            // Check for IBNS 2.0 (for Cisco IOS-XE)
            if (vendorInfo.vendor === 'cisco' && vendorInfo.platform === 'ios-xe') {
                if (config.includes('policy-map type control subscriber')) {
                    implemented.push({
                        name: 'IBNS 2.0',
                        description: 'Using Identity-Based Networking Services 2.0 framework.',
                        importance: 'high'
                    });
                    
                    // Check for concurrent authentication
                    if (config.includes('do-all') && config.includes('authenticate using dot1x') && 
                        config.includes('authenticate using mab')) {
                        implemented.push({
                            name: 'Concurrent Authentication',
                            description: 'Using concurrent 802.1X and MAB authentication.',
                            importance: 'medium'
                        });
                    } else if (config.includes('do-until-failure') && config.includes('authenticate using dot1x') && 
                               config.includes('authenticate using mab')) {
                        missing.push({
                            name: 'Concurrent Authentication',
                            description: 'Using sequential instead of concurrent authentication.',
                            importance: 'low'
                        });
                    }
                } else {
                    missing.push({
                        name: 'IBNS 2.0',
                        description: 'Not using Identity-Based Networking Services 2.0 framework.',
                        importance: 'medium'
                    });
                }
            }
            
            // Check for device tracking (Cisco)
            if (vendorInfo.vendor === 'cisco') {
                if (vendorInfo.platform === 'ios-xe' && config.includes('device-tracking')) {
                    implemented.push({
                        name: 'Device Tracking',
                        description: 'Device tracking configured for IOS-XE.',
                        importance: 'medium'
                    });
                } else if (vendorInfo.platform === 'ios' && config.includes('ip device tracking')) {
                    implemented.push({
                        name: 'Device Tracking',
                        description: 'IP device tracking configured for IOS.',
                        importance: 'medium'
                    });
                } else {
                    missing.push({
                        name: 'Device Tracking',
                        description: 'Device tracking not configured, which is required for downloadable ACLs.',
                        importance: 'medium'
                    });
                }
            }
            
            // Check for RADIUS deadtime
            if (config.includes('deadtime')) {
                implemented.push({
                    name: 'RADIUS Deadtime',
                    description: 'RADIUS server deadtime configured for failover optimization.',
                    importance: 'medium'
                });
            } else {
                missing.push({
                    name: 'RADIUS Deadtime',
                    description: 'RADIUS server deadtime not configured.',
                    importance: 'low'
                });
            }
            
            // Check for RADIUS load balancing
            if (config.includes('load-balance')) {
                implemented.push({
                    name: 'RADIUS Load Balancing',
                    description: 'RADIUS server load balancing configured.',
                    importance: 'medium'
                });
            } else {
                missing.push({
                    name: 'RADIUS Load Balancing',
                    description: 'RADIUS server load balancing not configured.',
                    importance: 'low'
                });
            }
            
            // Check for Change of Authorization (CoA)
            if (config.includes('dynamic-author')) {
                implemented.push({
                    name: 'Change of Authorization',
                    description: 'RADIUS Change of Authorization (CoA) configured.',
                    importance: 'medium'
                });
            } else {
                missing.push({
                    name: 'Change of Authorization',
                    description: 'RADIUS Change of Authorization (CoA) not configured.',
                    importance: 'low'
                });
            }
            
            // Check for RADIUS VSA support
            if (config.includes('radius-server vsa send') || config.includes('radius server') && config.includes('attribute')) {
                implemented.push({
                    name: 'RADIUS VSA Support',
                    description: 'RADIUS Vendor-Specific Attributes (VSA) support configured.',
                    importance: 'medium'
                });
            } else {
                missing.push({
                    name: 'RADIUS VSA Support',
                    description: 'RADIUS Vendor-Specific Attributes (VSA) support not configured.',
                    importance: 'low'
                });
            }
            
            // Check for host mode multi-auth
            if (config.includes('host-mode multi-auth') || config.includes('host-mode multi-domain')) {
                implemented.push({
                    name: 'Multi-Auth Host Mode',
                    description: 'Multiple authentication host mode configured.',
                    importance: 'medium'
                });
            } else {
                missing.push({
                    name: 'Multi-Auth Host Mode',
                    description: 'Multiple authentication host mode not configured.',
                    importance: 'medium'
                });
            }
            
            // Check for periodic reauthentication
            if (config.includes('authentication periodic') || config.includes('authentication timer reauthenticate')) {
                implemented.push({
                    name: 'Periodic Reauthentication',
                    description: 'Periodic reauthentication configured.',
                    importance: 'low'
                });
            } else {
                missing.push({
                    name: 'Periodic Reauthentication',
                    description: 'Periodic reauthentication not configured.',
                    importance: 'low'
                });
            }
            
            // Calculate best practices score (0-100)
            const totalPractices = implemented.length + missing.length;
            if (totalPractices === 0) {
                return { score: 100, implemented: [], missing: [] };
            }
            
            // Weight by importance
            const implementedWeight = implemented.reduce((sum, practice) => {
                if (practice.importance === 'high') return sum + 3;
                if (practice.importance === 'medium') return sum + 2;
                return sum + 1;
            }, 0);
            
            const totalWeight = (implemented.concat(missing)).reduce((sum, practice) => {
                if (practice.importance === 'high') return sum + 3;
                if (practice.importance === 'medium') return sum + 2;
                return sum + 1;
            }, 0);
            
            const score = Math.round((implementedWeight / totalWeight) * 100);
            
            return {
                score: score,
                implemented: implemented,
                missing: missing
            };
        },
        
        /**
         * Analyze performance aspects of the configuration
         * @param {string} config - Configuration to analyze
         * @param {Object} vendorInfo - Vendor and platform information
         * @returns {Object} Performance analysis results
         */
        analyzePerformance: function(config, vendorInfo) {
            const issues = [];
            const optimizations = [];
            
            // Check RADIUS timeout
            const timeoutMatch = config.match(/timeout\s+(\d+)/);
            if (timeoutMatch) {
                const timeout = parseInt(timeoutMatch[1]);
                if (timeout > 5) {
                    issues.push({
                        name: 'RADIUS Timeout',
                        description: `RADIUS timeout of ${timeout} seconds is high.`,
                        recommendation: 'Reduce RADIUS timeout to 2-5 seconds for better performance.',
                        impact: 'high'
                    });
                } else if (timeout >= 2 && timeout <= 5) {
                    optimizations.push({
                        name: 'RADIUS Timeout',
                        description: `RADIUS timeout of ${timeout} seconds is optimal.`,
                        impact: 'low'
                    });
                } else {
                    issues.push({
                        name: 'RADIUS Timeout',
                        description: `RADIUS timeout of ${timeout} seconds is too low.`,
                        recommendation: 'Set RADIUS timeout to at least 2 seconds to avoid premature timeouts.',
                        impact: 'medium'
                    });
                }
            }
            
            // Check dot1x tx-period
            const txPeriodMatch = config.match(/tx-period\s+(\d+)/);
            if (txPeriodMatch) {
                const txPeriod = parseInt(txPeriodMatch[1]);
                if (txPeriod > 10) {
                    issues.push({
                        name: 'Dot1x Tx Period',
                        description: `Dot1x tx-period of ${txPeriod} seconds is high.`,
                        recommendation: 'Reduce tx-period to 5-10 seconds for faster authentication.',
                        impact: 'medium'
                    });
                } else if (txPeriod >= 5 && txPeriod <= 10) {
                    optimizations.push({
                        name: 'Dot1x Tx Period',
                        description: `Dot1x tx-period of ${txPeriod} seconds is optimal.`,
                        impact: 'low'
                    });
                } else if (txPeriod < 3) {
                    issues.push({
                        name: 'Dot1x Tx Period',
                        description: `Dot1x tx-period of ${txPeriod} seconds is too low.`,
                        recommendation: 'Set tx-period to at least 3 seconds to avoid excessive EAP traffic.',
                        impact: 'low'
                    });
                }
            }
            
            // Check for concurrent authentication (already checked in best practices)
            if (config.includes('do-all') && config.includes('authenticate using dot1x') && 
                config.includes('authenticate using mab')) {
                optimizations.push({
                    name: 'Concurrent Authentication',
                    description: 'Using concurrent 802.1X and MAB authentication for faster login.',
                    impact: 'high'
                });
            } else if (config.includes('do-until-failure') && config.includes('authenticate using dot1x') && 
                       config.includes('authenticate using mab')) {
                issues.push({
                    name: 'Sequential Authentication',
                    description: 'Using sequential instead of concurrent authentication.',
                    recommendation: 'Use concurrent authentication with "do-all" for faster authentication.',
                    impact: 'medium'
                });
            }
            
            // Check for excessive authentication retries
            const maxReauthReqMatch = config.match(/max-reauth-req\s+(\d+)/);
            if (maxReauthReqMatch) {
                const maxReauthReq = parseInt(maxReauthReqMatch[1]);
                if (maxReauthReq > 3) {
                    issues.push({
                        name: 'Max Reauth Requests',
                        description: `Max reauth requests of ${maxReauthReq} is high.`,
                        recommendation: 'Reduce max-reauth-req to 2-3 for faster failure detection.',
                        impact: 'low'
                    });
                } else {
                    optimizations.push({
                        name: 'Max Reauth Requests',
                        description: `Max reauth requests of ${maxReauthReq} is optimal.`,
                        impact: 'low'
                    });
                }
            }
            
            // Check for RADIUS server probes
            if (config.includes('automate-tester') || config.includes('test aaa')) {
                optimizations.push({
                    name: 'RADIUS Server Probes',
                    description: 'RADIUS server probes configured for proactive failure detection.',
                    impact: 'medium'
                });
            } else {
                issues.push({
                    name: 'RADIUS Server Probes',
                    description: 'RADIUS server probes not configured.',
                    recommendation: 'Configure RADIUS server probes for proactive failure detection.',
                    impact: 'low'
                });
            }
            
            // Calculate performance score (0-100)
            // Weight by impact
            const issuesWeight = issues.reduce((sum, issue) => {
                if (issue.impact === 'high') return sum + 15;
                if (issue.impact === 'medium') return sum + 10;
                return sum + 5;
            }, 0);
            
            const optimizationsWeight = optimizations.reduce((sum, opt) => {
                if (opt.impact === 'high') return sum + 10;
                if (opt.impact === 'medium') return sum + 5;
                return sum + 3;
            }, 0);
            
            // Start at 70 (base score), add optimizations, subtract issues
            let score = 70 + optimizationsWeight - issuesWeight;
            
            // Ensure score is between 0 and 100
            score = Math.max(0, Math.min(100, score));
            
            return {
                score: score,
                issues: issues,
                optimizations: optimizations
            };
        },
        
        /**
         * Generate list of recommendations based on analysis
         * @param {string} config - Configuration to analyze
         * @param {Object} vendorInfo - Vendor and platform information
         * @param {Object} securityScore - Security analysis results
         * @param {Object} bestPractices - Best practices analysis results
         * @param {Object} performanceScore - Performance analysis results
         * @returns {Array} List of recommendations
         */
        generateRecommendationList: function(config, vendorInfo, securityScore, bestPractices, performanceScore) {
            const recommendations = [];
            
            // Add security recommendations first (they're most important)
            securityScore.issues.forEach(issue => {
                recommendations.push({
                    category: 'security',
                    severity: issue.severity,
                    description: issue.description,
                    recommendation: issue.recommendation || 'No specific recommendation.'
                });
            });
            
            // Add best practice recommendations
            bestPractices.missing.forEach(practice => {
                recommendations.push({
                    category: 'best-practice',
                    severity: practice.importance, // Use importance as severity
                    description: practice.description,
                    recommendation: `Implement ${practice.name} for better authentication performance and security.`
                });
            });
            
            // Add performance recommendations
            performanceScore.issues.forEach(issue => {
                recommendations.push({
                    category: 'performance',
                    severity: issue.impact, // Use impact as severity
                    description: issue.description,
                    recommendation: issue.recommendation || 'No specific recommendation.'
                });
            });
            
            // Sort recommendations by severity (high, medium, low)
            return recommendations.sort((a, b) => {
                const severityOrder = { high: 0, medium: 1, low: 2 };
                return severityOrder[a.severity] - severityOrder[b.severity];
            });
        },
        
        /**
         * Display analysis results in UI
         * @param {Object} results - Analysis results
         */
        displayAnalysisResults: function(results) {
            // Update security score
            const securityScoreValue = document.getElementById('securityScoreValue');
            if (securityScoreValue) {
                securityScoreValue.textContent = results.securityScore.score;
            }
            
            // Update category scores
            const authScore = document.getElementById('authScore');
            const authzScore = document.getElementById('authzScore');
            const infraScore = document.getElementById('infraScore');
            const resilScore = document.getElementById('resilScore');
            
            if (authScore) authScore.textContent = this.calculateCategoryScore(results, 'Authentication');
            if (authzScore) authzScore.textContent = this.calculateCategoryScore(results, 'Authorization');
            if (infraScore) infraScore.textContent = this.calculateCategoryScore(results, 'Layer 2 Security');
            if (resilScore) resilScore.textContent = this.calculateCategoryScore(results, 'Availability');
            
            // Update security score circle color
            this.updateSecurityScoreColor(results.securityScore.score);
            
            // Update optimization results
            const optimizationResultsContent = document.getElementById('optimizationResultsContent');
            if (optimizationResultsContent) {
                let html = `
                    <div class="optimization-summary">
                        <p><i class="fas fa-search"></i> Configuration analysis complete.</p>
                    </div>
                    
                    <h3>Security Score: ${results.securityScore.score}%</h3>
                    <div class="progress">
                        <div class="progress-bar" style="width: ${results.securityScore.score}%"></div>
                    </div>
                    
                    <h3>Best Practices Score: ${results.bestPractices.score}%</h3>
                    <div class="progress">
                        <div class="progress-bar" style="width: ${results.bestPractices.score}%"></div>
                    </div>
                    
                    <h3>Performance Score: ${results.performanceScore.score}%</h3>
                    <div class="progress">
                        <div class="progress-bar" style="width: ${results.performanceScore.score}%"></div>
                    </div>
                    
                    <h3>Top Recommendations</h3>
                    <ul class="recommendations-list">
                `;
                
                // Add top 5 recommendations
                results.recommendations.slice(0, 5).forEach(rec => {
                    html += `
                        <li class="recommendation-item">
                            <div class="recommendation-header">
                                <span class="severity-badge ${rec.severity}">${rec.severity}</span>
                                <span class="recommendation-title">${rec.description}</span>
                            </div>
                            <div class="recommendation-details">
                                <p>${rec.recommendation}</p>
                            </div>
                        </li>
                    `;
                });
                
                html += `
                    </ul>
                    
                    <p>Click "Optimize Configuration" to automatically implement these recommendations.</p>
                `;
                
                optimizationResultsContent.innerHTML = html;
                
                // Add progress bar styles if not already added
                this.addProgressBarStyles();
            }
        },
        
        /**
         * Add progress bar styles
         */
        addProgressBarStyles: function() {
            if (!document.getElementById('progressBarStyles')) {
                const style = document.createElement('style');
                style.id = 'progressBarStyles';
                style.innerHTML = `
                    .progress {
                        height: 20px;
                        background-color: #f5f5f5;
                        border-radius: 4px;
                        margin-bottom: 20px;
                        overflow: hidden;
                    }
                    
                    .progress-bar {
                        height: 100%;
                        background-color: #3498db;
                        transition: width 0.5s;
                    }
                `;
                document.head.appendChild(style);
            }
        },
        
        /**
         * Calculate category score for a specific category
         * @param {Object} results - Analysis results
         * @param {string} category - Category to calculate score for
         * @returns {number} Category score (0-100)
         */
        calculateCategoryScore: function(results, category) {
            // Get issues for the category
            const categoryIssues = results.securityScore.issues.filter(issue => issue.category === category);
            const categoryStrengths = results.securityScore.strengths.filter(strength => strength.category === category);
            
            // If no issues or strengths for this category, return N/A
            if (categoryIssues.length === 0 && categoryStrengths.length === 0) {
                return '??';
            }
            
            // Calculate score
            const highIssuesCount = categoryIssues.filter(issue => issue.severity === 'high').length;
            const mediumIssuesCount = categoryIssues.filter(issue => issue.severity === 'medium').length;
            const lowIssuesCount = categoryIssues.filter(issue => issue.severity === 'low').length;
            
            let score = 100;
            score -= highIssuesCount * 30; // Each high issue reduces score by 30
            score -= mediumIssuesCount * 15; // Each medium issue reduces score by 15
            score -= lowIssuesCount * 5; // Each low issue reduces score by 5
            
            // Bonus for strengths
            score += Math.min(20, categoryStrengths.length * 10); // Up to 20 points bonus
            
            // Ensure score is between 0 and 100
            return Math.max(0, Math.min(100, score));
        },
        
        /**
         * Update security score circle color based on score
         * @param {number} score - Security score
         */
        updateSecurityScoreColor: function(score) {
            const securityScoreCircle = document.querySelector('.security-score-circle');
            if (securityScoreCircle) {
                if (score >= 90) {
                    securityScoreCircle.style.borderColor = '#27ae60'; // green
                } else if (score >= 70) {
                    securityScoreCircle.style.borderColor = '#2ecc71'; // light green
                } else if (score >= 40) {
                    securityScoreCircle.style.borderColor = '#f39c12'; // orange
                } else {
                    securityScoreCircle.style.borderColor = '#e74c3c'; // red
                }
            }
        },
        
        /**
         * Perform security analysis
         */
        performSecurityAnalysis: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;
            
            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Show loading indicator
            this.showLoadingIndicator('Performing detailed security analysis...');
            
            // Simulate analysis by adding a delay
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();
                
                // Perform the analysis
                const vendorInfo = this.detectVendorAndPlatform(config);
                const securityResults = this.analyzeSecurityAspects(config, vendorInfo);
                
                // Update security score
                document.getElementById('securityScoreValue').textContent = securityResults.score;
                
                // Update category scores
                const authScore = this.calculateCategoryScore({ securityScore: securityResults }, 'Authentication');
                const authzScore = this.calculateCategoryScore({ securityScore: securityResults }, 'Authorization');
                const infraScore = this.calculateCategoryScore({ securityScore: securityResults }, 'Layer 2 Security');
                const resilScore = this.calculateCategoryScore({ securityScore: securityResults }, 'Availability');
                
                document.getElementById('authScore').textContent = authScore;
                document.getElementById('authzScore').textContent = authzScore;
                document.getElementById('infraScore').textContent = infraScore;
                document.getElementById('resilScore').textContent = resilScore;
                
                // Update security score circle color
                this.updateSecurityScoreColor(securityResults.score);
                
                // Show security analysis section
                document.querySelector('.security-analysis').classList.remove('hidden');
                
                // Update security issues sections
                this.updateSecurityIssuesSection(securityResults);
                
                // Show success message
                this.showToast('Security analysis completed successfully.');
            }, 2000);
        },
        
        /**
         * Update security issues sections in the UI
         * @param {Object} securityResults - Security analysis results
         */
        updateSecurityIssuesSection: function(securityResults) {
            // Find issues by severity
            const criticalIssues = securityResults.issues.filter(issue => issue.severity === 'critical');
            const highIssues = securityResults.issues.filter(issue => issue.severity === 'high');
            const mediumIssues = securityResults.issues.filter(issue => issue.severity === 'medium');
            const lowIssues = securityResults.issues.filter(issue => issue.severity === 'low');
            
            // Update critical issues section
            const criticalIssuesElement = document.getElementById('criticalIssues');
            if (criticalIssuesElement) {
                if (criticalIssues.length === 0) {
                    criticalIssuesElement.innerHTML = '<p>No critical issues found.</p>';
                } else {
                    criticalIssuesElement.innerHTML = this.formatIssuesList(criticalIssues);
                }
            }
            
            // Update high impact issues section
            const highIssuesElement = document.getElementById('highIssues');
            if (highIssuesElement) {
                if (highIssues.length === 0) {
                    highIssuesElement.innerHTML = '<p>No high impact issues found.</p>';
                } else {
                    highIssuesElement.innerHTML = this.formatIssuesList(highIssues);
                }
            }
            
            // Update medium impact issues section
            const mediumIssuesElement = document.getElementById('mediumIssues');
            if (mediumIssuesElement) {
                if (mediumIssues.length === 0) {
                    mediumIssuesElement.innerHTML = '<p>No medium impact issues found.</p>';
                } else {
                    mediumIssuesElement.innerHTML = this.formatIssuesList(mediumIssues);
                }
            }
            
            // Update low impact issues section
            const lowIssuesElement = document.getElementById('lowIssues');
            if (lowIssuesElement) {
                if (lowIssues.length === 0) {
                    lowIssuesElement.innerHTML = '<p>No low impact issues found.</p>';
                } else {
                    lowIssuesElement.innerHTML = this.formatIssuesList(lowIssues);
                }
            }
        },
        
        /**
         * Format issues list as HTML
         * @param {Array} issues - List of issues
         * @returns {string} Formatted HTML
         */
        formatIssuesList: function(issues) {
            let html = '<ul class="issues-list">';
            
            issues.forEach(issue => {
                html += `
                    <li class="issue-item ${issue.severity}">
                        <div class="issue-header">
                            <span class="severity-badge ${issue.severity}">${issue.severity}</span>
                            <span class="issue-title">${issue.description}</span>
                        </div>
                        <div class="issue-details">
                            ${issue.recommendation ? `<p><strong>Recommendation:</strong> ${issue.recommendation}</p>` : ''}
                            ${issue.category ? `<p><strong>Category:</strong> ${issue.category}</p>` : ''}
                        </div>
                    </li>
                `;
            });
            
            html += '</ul>';
            return html;
        },
        
        /**
         * Optimize configuration
         */
        optimizeConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;
            
            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Show loading indicator
            this.showLoadingIndicator('Optimizing configuration with AI...');
            
            // Simulate optimization by adding a delay
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();
                
                // Perform optimization
                const optimizedConfig = this.optimizeConfig(config);
                
                // Update configuration output
                configOutput.value = optimizedConfig;
                
                // Show success message
                this.showOptimizationSuccess();
            }, 2000);
        },
        
        /**
         * Start optimization
         */
        startOptimization: function() {
            this.optimizeConfiguration();
        },
        
        /**
         * Generate recommendations
         */
        generateRecommendations: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;
            
            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Show loading indicator
            this.showLoadingIndicator('Generating intelligent recommendations...');
            
            // Simulate generating recommendations
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();
                
                // Perform analysis
                const vendorInfo = this.detectVendorAndPlatform(config);
                const securityResults = this.analyzeSecurityAspects(config, vendorInfo);
                const bestPractices = this.analyzeBestPractices(config, vendorInfo);
                const performanceResults = this.analyzePerformance(config, vendorInfo);
                
                // Generate recommendations
                const recommendations = this.generateRecommendationList(
                    config, vendorInfo, securityResults, bestPractices, performanceResults
                );
                
                // Group recommendations by category
                const authRecommendations = recommendations.filter(rec => 
                    rec.category === 'security' && (rec.description.includes('Authentication') || rec.description.toLowerCase().includes('802.1x') || rec.description.toLowerCase().includes('mab'))
                );
                
                const securityRecommendations = recommendations.filter(rec => 
                    rec.category === 'security' && !authRecommendations.includes(rec)
                );
                
                const infraRecommendations = recommendations.filter(rec => 
                    rec.category === 'best-practice'
                );
                
                const opsRecommendations = recommendations.filter(rec => 
                    rec.category === 'performance'
                );
                
                // Update UI with recommendations
                this.updateRecommendationsUI(
                    authRecommendations, 
                    securityRecommendations, 
                    infraRecommendations, 
                    opsRecommendations
                );
                
                // Show recommendations content
                document.querySelector('.recommendations-content').classList.remove('hidden');
                
                // Show success message
                this.showToast('Recommendations generated successfully.');
            }, 2000);
        },
        
        /**
         * Apply recommendations to configuration
         */
        applyRecommendations: function() {
            // This is essentially the same as optimize configuration
            this.optimizeConfiguration();
        },
        
        /**
         * Fix security issues
         */
        fixSecurityIssues: function() {
            const configOutput = document.getElementById('configOutput');
            const config = configOutput.value;
            
            if (!config.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Show loading indicator
            this.showLoadingIndicator('Fixing security issues...');
            
            // Simulate fixing issues
            setTimeout(() => {
                // Hide loading indicator
                this.hideLoadingIndicator();
                
                // Perform optimization with focus on security
                const optimizedConfig = this.optimizeConfig(config, { focusSecurity: true });
                
                // Update configuration output
                configOutput.value = optimizedConfig;
                
                // Show success message
                this.showToast('Security issues fixed successfully.');
            }, 2000);
        },
        
        /**
         * Update recommendations UI
         * @param {Array} authRecommendations - Authentication recommendations
         * @param {Array} securityRecommendations - Security recommendations
         * @param {Array} infraRecommendations - Infrastructure recommendations
         * @param {Array} opsRecommendations - Operations recommendations
         */
        updateRecommendationsUI: function(authRecommendations, securityRecommendations, infraRecommendations, opsRecommendations) {
            // Update authentication recommendations
            const authRecommendationsElement = document.getElementById('authRecommendations');
            if (authRecommendationsElement) {
                if (authRecommendations.length === 0) {
                    authRecommendationsElement.innerHTML = '<p>No authentication recommendations available.</p>';
                } else {
                    authRecommendationsElement.innerHTML = this.formatRecommendationsList(authRecommendations);
                }
            }
            
            // Update security recommendations
            const securityRecommendationsElement = document.getElementById('securityRecommendations');
            if (securityRecommendationsElement) {
                if (securityRecommendations.length === 0) {
                    securityRecommendationsElement.innerHTML = '<p>No security recommendations available.</p>';
                } else {
                    securityRecommendationsElement.innerHTML = this.formatRecommendationsList(securityRecommendations);
                }
            }
            
            // Update infrastructure recommendations
            const infraRecommendationsElement = document.getElementById('infraRecommendations');
            if (infraRecommendationsElement) {
                if (infraRecommendations.length === 0) {
                    infraRecommendationsElement.innerHTML = '<p>No infrastructure recommendations available.</p>';
                } else {
                    infraRecommendationsElement.innerHTML = this.formatRecommendationsList(infraRecommendations);
                }
            }
            
            // Update operations recommendations
            const opsRecommendationsElement = document.getElementById('opsRecommendations');
            if (opsRecommendationsElement) {
                if (opsRecommendations.length === 0) {
                    opsRecommendationsElement.innerHTML = '<p>No operational recommendations available.</p>';
                } else {
                    opsRecommendationsElement.innerHTML = this.formatRecommendationsList(opsRecommendations);
                }
            }
        },
        
        /**
         * Format recommendations list as HTML
         * @param {Array} recommendations - List of recommendations
         * @returns {string} Formatted HTML
         */
        formatRecommendationsList: function(recommendations) {
            let html = '<ul class="recommendations-list">';
            
            recommendations.forEach(rec => {
                html += `
                    <li class="recommendation-item">
                        <div class="recommendation-header">
                            <span class="severity-badge ${rec.severity}">${rec.severity}</span>
                            <span class="recommendation-title">${rec.description}</span>
                        </div>
                        <div class="recommendation-details">
                            <p>${rec.recommendation}</p>
                        </div>
                    </li>
                `;
            });
            
            html += '</ul>';
            return html;
        },
        
        /**
         * Optimize configuration
         * @param {string} config - Configuration to optimize
         * @param {Object} options - Optimization options
         * @returns {string} Optimized configuration
         */
        optimizeConfig: function(config, options = {}) {
            // Detect vendor and platform
            const vendorInfo = this.detectVendorAndPlatform(config);
            
            // Start with original config
            let optimizedConfig = config;
            
            // Cisco-specific optimizations
            if (vendorInfo.vendor === 'cisco') {
                // IOS-XE specific optimizations
                if (vendorInfo.platform === 'ios-xe') {
                    // Add device tracking if missing
                    if (!optimizedConfig.includes('device-tracking')) {
                        optimizedConfig = optimizedConfig.replace(
                            /(aaa new-model[\s\S]*?)(\n\S)/m,
                            '$1\n\n! Device Tracking Configuration\ndevice-tracking tracking auto-source\n\ndevice-tracking policy IP-TRACKING\n limit address-count 4\n security-level glean\n no protocol ndp\n no protocol dhcp6\n tracking enable reachable-lifetime 30\n\ndevice-tracking policy DISABLE-IP-TRACKING\n tracking disable\n trusted-port\n device-role switch$2'
                        );
                    }
                    
                    // Convert sequential authentication to concurrent
                    if (optimizedConfig.includes('policy-map type control subscriber') && 
                        optimizedConfig.includes('authenticate using dot1x priority 10') && 
                        !optimizedConfig.includes('do-all') && 
                        optimizedConfig.includes('authenticate using mab priority 20')) {
                        
                        optimizedConfig = optimizedConfig.replace(
                            /event session-started match-all\s+10 class always do-until-failure\s+10 authenticate using dot1x priority 10/g,
                            'event session-started match-all\n  10 class always do-all\n   10 authenticate using dot1x priority 10\n   20 authenticate using mab priority 20'
                        );
                        
                        // Also update policy map name
                        optimizedConfig = optimizedConfig.replace(
                            /policy-map type control subscriber DOT1X_MAB_POLICY/g,
                            'policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY'
                        );
                        
                        // Update service-policy reference
                        optimizedConfig = optimizedConfig.replace(
                            /service-policy type control subscriber DOT1X_MAB_POLICY/g,
                            'service-policy type control subscriber CONCURRENT_DOT1X_MAB_POLICY'
                        );
                    }
                    
                    // Add critical authentication if missing
                    if (!optimizedConfig.includes('critical') && !optimizedConfig.includes('CRITICAL_')) {
                        // Add service templates and class maps for critical authentication
                        const criticalConfig = `
! Critical Authentication Configuration
service-template CRITICAL_DATA_ACCESS
 vlan 999
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan 999
 access-group ACL-OPEN

class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST
 match result-type aaa-timeout
 match authorization-status authorized

class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST
 match result-type aaa-timeout
 match authorization-status unauthorized

class-map type control subscriber match-any IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH
 match activated-service-template CRITICAL_DATA_ACCESS
 match activated-service-template CRITICAL_VOICE_ACCESS

dot1x critical eapol
authentication critical recovery delay 2000

ip access-list extended ACL-OPEN
 permit ip any any`;
                        
                        // Find place to insert critical config
                        const classMapsMatch = optimizedConfig.match(/class-map type control subscriber/);
                        if (classMapsMatch) {
                            // Insert before first class-map
                            optimizedConfig = optimizedConfig.replace(
                                /(class-map type control subscriber)/,
                                `${criticalConfig}\n\n$1`
                            );
                        } else {
                            // If no class maps, insert after policy map section or at the end
                            const policyMapMatch = optimizedConfig.match(/policy-map type control subscriber[\s\S]*?(?=\n\S)/);
                            if (policyMapMatch) {
                                const policyMapEnd = optimizedConfig.indexOf(policyMapMatch[0]) + policyMapMatch[0].length;
                                optimizedConfig = optimizedConfig.substring(0, policyMapEnd) + 
                                                 '\n\n' + criticalConfig + 
                                                 optimizedConfig.substring(policyMapEnd);
                            } else {
                                // Add at the end
                                optimizedConfig += '\n\n' + criticalConfig;
                            }
                        }
                        
                        // Update policy maps to include critical authentication handling
                        // Find authentication-failure event
                        optimizedConfig = optimizedConfig.replace(
                            /(event authentication-failure match-first\s+(?:\d+ class [\s\S]*?)*?)(\s+\d+ class (?:DOT1X|MAB)_FAILED|\s+\d+ class always|\s*\n\s*event)/m,
                            '$1\n 10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n  10 clear-authenticated-data-hosts-on-port\n  20 activate service-template CRITICAL_DATA_ACCESS\n  30 activate service-template CRITICAL_VOICE_ACCESS\n  40 authorize\n  50 pause reauthentication\n 20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n  10 pause reauthentication\n  20 authorize$2'
                        );
                        
                        // Add aaa-available event
                        optimizedConfig = optimizedConfig.replace(
                            /(policy-map type control subscriber [\w-]+\s+(?:event [\s\S]*?)*?)(\s*\n\S)/m,
                            '$1\n event aaa-available match-all\n  10 class IN_CRITICAL_AUTH do-until-failure\n   10 clear-session\n  20 class NOT_IN_CRITICAL_AUTH do-until-failure\n   10 resume reauthentication$2'
                        );
                    }
                }
                // IOS specific optimizations
                else {
                    // Add IP device tracking if missing
                    if (!optimizedConfig.includes('ip device tracking')) {
                        optimizedConfig = optimizedConfig.replace(
                            /(aaa new-model[\s\S]*?)(\n\S)/m,
                            '$1\n\n! IP Device Tracking Configuration\nip device tracking probe auto-source\nip device tracking probe delay 30\nip device tracking probe interval 30\nip device tracking$2'
                        );
                    }
                    
                    // Add critical authentication if missing
                    if (!optimizedConfig.includes('dot1x critical') && 
                        (optimizedConfig.includes('dot1x') || optimizedConfig.includes('authentication'))) {
                        optimizedConfig = optimizedConfig.replace(
                            /(dot1x system-auth-control[\s\S]*?)(\n\S)/m,
                            '$1\n\n! Critical Authentication Configuration\ndot1x critical eapol\ndot1x critical vlan 999\nauthentication event server dead action authorize vlan 999\nauthentication event server dead action authorize voice$2'
                        );
                    }
                }
                
                // Common Cisco optimizations
                
                // Add DHCP snooping if missing
                if (!optimizedConfig.includes('ip dhcp snooping') && (options.focusSecurity || true)) {
                    const dhcpSnoopingConfig = `
! DHCP Snooping Configuration
ip dhcp snooping vlan 1-4094
ip dhcp snooping information option
ip dhcp snooping`;
                    
                    // Find place to insert DHCP snooping config
                    optimizedConfig = optimizedConfig.replace(
                        /(aaa new-model[\s\S]*?)(\n\S)/m,
                        `$1\n\n${dhcpSnoopingConfig}$2`
                    );
                }
                
                // Add Dynamic ARP Inspection if missing
                if (!optimizedConfig.includes('ip arp inspection') && (options.focusSecurity || true)) {
                    const arpInspectionConfig = `
! Dynamic ARP Inspection Configuration
ip arp inspection vlan 1-4094
ip arp inspection validate src-mac dst-mac ip`;
                    
                    // Find place to insert ARP inspection config
                    if (optimizedConfig.includes('ip dhcp snooping')) {
                        optimizedConfig = optimizedConfig.replace(
                            /(ip dhcp snooping[\s\S]*?)(\n\S)/m,
                            `$1\n\n${arpInspectionConfig}$2`
                        );
                    } else {
                        optimizedConfig = optimizedConfig.replace(
                            /(aaa new-model[\s\S]*?)(\n\S)/m,
                            `$1\n\n${arpInspectionConfig}$2`
                        );
                    }
                }
                
                // Optimize RADIUS server timeout if too high
                const timeoutMatch = optimizedConfig.match(/timeout\s+(\d+)/);
                if (timeoutMatch && parseInt(timeoutMatch[1]) > 5) {
                    optimizedConfig = optimizedConfig.replace(
                        /timeout\s+\d+/g,
                        'timeout 2'
                    );
                }
                
                // Optimize RADIUS deadtime if missing
                if (!optimizedConfig.includes('deadtime') && optimizedConfig.includes('radius')) {
                    if (optimizedConfig.includes('aaa group server radius')) {
                        optimizedConfig = optimizedConfig.replace(
                            /(aaa group server radius[\s\S]*?)(\n\S)/m,
                            '$1\n deadtime 15$2'
                        );
                    }
                }
                
                // Optimize dot1x tx-period if too high
                const txPeriodMatch = optimizedConfig.match(/tx-period\s+(\d+)/);
                if (txPeriodMatch && parseInt(txPeriodMatch[1]) > 10) {
                    optimizedConfig = optimizedConfig.replace(
                        /tx-period\s+\d+/g,
                        'tx-period 7'
                    );
                }
                
                // Add RADIUS VSA support if missing
                if (!optimizedConfig.includes('radius-server vsa send') && optimizedConfig.includes('radius')) {
                    optimizedConfig = optimizedConfig.replace(
                        /(radius[\s-]server[\s\S]*?)(\n\S)/m,
                        '$1\n\nradius-server vsa send authentication\nradius-server vsa send accounting$2'
                    );
                }
                
                // Add RADIUS load balancing if multiple servers and no load balancing
                if (!optimizedConfig.includes('load-balance') && 
                    ((optimizedConfig.match(/radius[\s-]server/g) || []).length >= 2)) {
                    
                    if (optimizedConfig.includes('aaa group server radius')) {
                        optimizedConfig = optimizedConfig.replace(
                            /(aaa group server radius[\s\S]*?)(\n\S)/m,
                            '$1\n load-balance method least-outstanding$2'
                        );
                    }
                }
                
                // Add IP Source Guard to interfaces if not present
                if (!optimizedConfig.includes('ip verify source') && 
                    optimizedConfig.includes('ip dhcp snooping') && 
                    (options.focusSecurity || true)) {
                    
                    optimizedConfig = optimizedConfig.replace(
                        /(interface.*?switchport mode access[\s\S]*?)(\n\s*!|$)/gm,
                        '$1\n ip verify source$2'
                    );
                }
                
                // Add BPDU Guard to interfaces if not present
                if (!optimizedConfig.includes('spanning-tree bpduguard enable') && 
                    (options.focusSecurity || true)) {
                    
                    optimizedConfig = optimizedConfig.replace(
                        /(interface.*?switchport mode access[\s\S]*?)(\n\s*!|$)/gm,
                        '$1\n spanning-tree portfast\n spanning-tree bpduguard enable$2'
                    );
                }
            }
            
            return optimizedConfig;
        },
        
        /**
         * Show optimization success message
         */
        showOptimizationSuccess: function() {
            // Create toast notification if it doesn't exist
            if (!document.getElementById('optimizationToast')) {
                const toastDiv = document.createElement('div');
                toastDiv.id = 'optimizationToast';
                toastDiv.className = 'toast-notification';
                
                toastDiv.innerHTML = `
                    <div class="toast-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="toast-message">
                        Configuration optimized successfully
                    </div>
                `;
                
                document.body.appendChild(toastDiv);
                
                // Auto-hide toast after 5 seconds
                setTimeout(() => {
                    toastDiv.classList.add('toast-hide');
                    setTimeout(() => {
                        toastDiv.remove();
                    }, 500);
                }, 5000);
            }
        },
        
        /**
         * Show toast notification
         * @param {string} message - Message to show in toast
         */
        showToast: function(message) {
            const toastDiv = document.createElement('div');
            toastDiv.className = 'toast-notification';
            
            toastDiv.innerHTML = `
                <div class="toast-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="toast-message">
                    ${message}
                </div>
            `;
            
            document.body.appendChild(toastDiv);
            
            // Auto-hide toast after 5 seconds
            setTimeout(() => {
                toastDiv.classList.add('toast-hide');
                setTimeout(() => {
                    toastDiv.remove();
                }, 500);
            }, 5000);
        }
    };

    // Initialize AI Analyzer on page load
    document.addEventListener('DOMContentLoaded', function() {
        AIAnalyzer.init();
    });

    // Export to window
    window.AIAnalyzer = AIAnalyzer;
})();
