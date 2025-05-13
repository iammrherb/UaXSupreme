/**
 * Portnox NAC Diagram UI for UaXSupreme
 * @version 1.0.0
 * 
 * User interface for generating and managing Portnox Cloud NAC diagrams
 */

const PortnoxDiagramUI = (function() {
    // Private variables
    let diagramInitialized = false;
    let currentDiagramType = 'basic_cloud_deployment';
    
    // Initialize the diagram UI
    const initialize = function() {
        // Add diagram UI to the documentation tab
        injectDiagramUI();
        
        // Register event handlers
        registerEventHandlers();
    };
    
    // Inject the diagram UI into the page
    const injectDiagramUI = function() {
        const documentationTab = document.querySelector('.tab-pane[data-step="documentation"]');
        if (!documentationTab) {
            console.warn('Documentation tab not found, creating temporary container');
            
            // Create a temporary container if documentation tab doesn't exist
            const tempContainer = document.createElement('div');
            tempContainer.id = 'portnox-diagram-section';
            tempContainer.className = 'diagram-section mt-4';
            tempContainer.innerHTML = createDiagramUI();
            
            // Add after the main content or at the end of body
            const mainContent = document.querySelector('main') || document.body;
            mainContent.appendChild(tempContainer);
        } else {
            // Add to documentation tab
            const diagramSection = document.createElement('div');
            diagramSection.id = 'portnox-diagram-section';
            diagramSection.className = 'diagram-section mt-4';
            diagramSection.innerHTML = createDiagramUI();
            documentationTab.appendChild(diagramSection);
        }
    };
    
    // Create HTML for the diagram UI
    const createDiagramUI = function() {
        return `
        <div class="card mb-4">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="m-0">Portnox Cloud Network Diagrams</h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" data-toggle="collapse" data-target="#diagramOptionsCollapse" aria-expanded="true">
                    <i class="fas fa-cog"></i> Options
                </button>
            </div>
            <div class="card-body">
                <div class="collapse show" id="diagramOptionsCollapse">
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h6>Diagram Type</h6>
                            <div class="form-group">
                                <select class="form-control" id="diagram-type">
                                    <optgroup label="Deployment Scenarios">
                                        <option value="basic_cloud_deployment">Basic Cloud Deployment</option>
                                        <option value="enterprise_deployment">Enterprise Deployment</option>
                                        <option value="multi_vendor_deployment">Multi-Vendor Deployment</option>
                                        <option value="high_security_deployment">High Security Deployment</option>
                                        <option value="cloud_integration">Cloud Service Integration</option>
                                        <option value="multi_site_deployment">Multi-Site Deployment</option>
                                    </optgroup>
                                    <optgroup label="Industry Specific">
                                        <option value="healthcare_deployment">Healthcare Deployment</option>
                                        <option value="education_deployment">Education Deployment</option>
                                        <option value="retail_deployment">Retail Deployment</option>
                                        <option value="manufacturing_deployment">Manufacturing Deployment</option>
                                        <option value="government_deployment">Government Deployment</option>
                                        <option value="financial_deployment">Financial Services Deployment</option>
                                    </optgroup>
                                    <optgroup label="Authentication & Workflows">
                                        <option value="eap_tls_authentication">EAP-TLS Authentication Flow</option>
                                        <option value="byod_onboarding">BYOD Onboarding Flow</option>
                                        <option value="guest_access">Guest Access Portal</option>
                                        <option value="dynamic_vlan_assignment">Dynamic VLAN Assignment</option>
                                        <option value="iot_segmentation">IoT Segmentation</option>
                                    </optgroup>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="vendor-select">Network Equipment Vendor</label>
                                <select class="form-control" id="vendor-select">
                                    <option value="cisco">Cisco</option>
                                    <option value="aruba">Aruba</option>
                                    <option value="juniper">Juniper</option>
                                    <option value="extreme">Extreme</option>
                                    <option value="fortinet">Fortinet</option>
                                    <option value="paloalto">Palo Alto</option>
                                    <option value="hp">HP Enterprise</option>
                                    <option value="dell">Dell</option>
                                    <option value="arista">Arista</option>
                                </select>
                            </div>
                            <button id="generate-diagram-btn" class="btn btn-primary mt-2">
                                <i class="fas fa-project-diagram mr-2"></i>Generate Diagram
                            </button>
                        </div>
                        <div class="col-md-6">
                            <h6>Diagram Components</h6>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-radius" checked>
                                <label class="form-check-label" for="show-radius">
                                    Show RADIUS Server
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-auth" checked>
                                <label class="form-check-label" for="show-auth">
                                    Show Authentication Methods
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-clients" checked>
                                <label class="form-check-label" for="show-clients">
                                    Show Client Devices
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-cloud" checked>
                                <label class="form-check-label" for="show-cloud">
                                    Show Cloud Services
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-legends" checked>
                                <label class="form-check-label" for="show-legends">
                                    Show Legends & Notes
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="show-detailed" checked>
                                <label class="form-check-label" for="show-detailed">
                                    Show Detailed Components
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="diagram-status" class="alert d-none"></div>
                
                <div id="diagram-container" class="diagram-container d-none">
                    <div class="diagram-toolbar">
                        <button id="zoom-in-btn" title="Zoom In">
                            <i class="fas fa-search-plus"></i>
                        </button>
                        <button id="zoom-out-btn" title="Zoom Out">
                            <i class="fas fa-search-minus"></i>
                        </button>
                        <button id="zoom-reset-btn" title="Reset Zoom">
                            <i class="fas fa-compress"></i>
                        </button>
                        <span class="toolbar-separator"></span>
                        <button id="export-png-btn" title="Export as PNG">
                            <i class="fas fa-file-image"></i> PNG
                        </button>
                        <button id="export-svg-btn" title="Export as SVG">
                            <i class="fas fa-file-code"></i> SVG
                        </button>
                        <button id="add-to-config-btn" title="Add to Configuration" class="ml-auto">
                            <i class="fas fa-plus-circle"></i> Add to Configuration
                        </button>
                    </div>
                    <div id="diagram-canvas" class="diagram-canvas"></div>
                </div>
                
                <h6 class="mt-4">Recommended Diagrams</h6>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="basic_cloud_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-network-wired"></i>
                            </div>
                            <div class="template-title">Basic Cloud Deployment</div>
                            <div class="template-description">Standard Portnox Cloud NAC deployment</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="eap_tls_authentication">
                            <div class="template-thumbnail">
                                <i class="fas fa-key"></i>
                            </div>
                            <div class="template-title">EAP-TLS Authentication</div>
                            <div class="template-description">Certificate-based authentication flow</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="dynamic_vlan_assignment">
                            <div class="template-thumbnail">
                                <i class="fas fa-project-diagram"></i>
                            </div>
                            <div class="template-title">Dynamic VLAN Assignment</div>
                            <div class="template-description">Role and device-based network segmentation</div>
                        </div>
                    </div>
                </div>
                
                <h6 class="mt-4">Industry-Specific Diagrams</h6>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="healthcare_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-hospital"></i>
                            </div>
                            <div class="template-title">Healthcare</div>
                            <div class="template-description">HIPAA-compliant segmentation</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="financial_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-university"></i>
                            </div>
                            <div class="template-title">Financial</div>
                            <div class="template-description">PCI-DSS compliance for banking</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="education_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <div class="template-title">Education</div>
                            <div class="template-description">Campus NAC with BYOD</div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="template-card" data-template="manufacturing_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-industry"></i>
                            </div>
                            <div class="template-title">Manufacturing</div>
                            <div class="template-description">OT/IT convergence security</div>
                        </div>
                    </div>
                </div>
                
                <div class="mt-4 p-3 bg-light rounded">
                    <h6><i class="fas fa-info-circle mr-2"></i>Portnox NAC Deployment Best Practices</h6>
                    <ul>
                        <li>Deploy in monitor mode first before enforcing authentication</li>
                        <li>Set up a guest VLAN for unauthenticated or guest devices</li>
                        <li>Use EAP-TLS with certificates for corporate-owned devices</li>
                        <li>Configure MAC Authentication Bypass (MAB) for IoT devices</li>
                        <li>Implement dynamic VLAN assignment based on device type and posture</li>
                        <li>Integrate with existing identity sources (Azure AD, Okta, etc.)</li>
                        <li>Set up compliance checks with MDM integration</li>
                        <li>Configure redundant RADIUS servers for high availability</li>
                    </ul>
                    <button class="btn btn-sm btn-info" id="show-best-practices">View Complete Best Practices</button>
                </div>
            </div>
        </div>
        `;
    };
    
    // Register event handlers
    const registerEventHandlers = function() {
        // Ensure DOM is loaded before attaching events
        document.addEventListener('DOMContentLoaded', function() {
            // Generate diagram button
            const generateBtn = document.getElementById('generate-diagram-btn');
            if (generateBtn) {
                generateBtn.addEventListener('click', handleGenerateDiagram);
            }
            
            // Diagram type select
            const diagramTypeSelect = document.getElementById('diagram-type');
            if (diagramTypeSelect) {
                diagramTypeSelect.addEventListener('change', function() {
                    currentDiagramType = this.value;
                });
            }
            
            // Template cards
            const templateCards = document.querySelectorAll('.template-card');
            templateCards.forEach(function(card) {
                card.addEventListener('click', function() {
                    const template = this.getAttribute('data-template');
                    if (template) {
                        currentDiagramType = template;
                        if (diagramTypeSelect) {
                            diagramTypeSelect.value = template;
                        }
                        handleGenerateDiagram();
                    }
                });
            });
            
            // Zoom buttons
            const zoomInBtn = document.getElementById('zoom-in-btn');
            const zoomOutBtn = document.getElementById('zoom-out-btn');
            const zoomResetBtn = document.getElementById('zoom-reset-btn');
            
            if (zoomInBtn) {
                zoomInBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        PortnoxDiagramGenerator.zoomIn();
                        updateStatus('Zoomed in', 'success');
                    }
                });
            }
            
            if (zoomOutBtn) {
                zoomOutBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        PortnoxDiagramGenerator.zoomOut();
                        updateStatus('Zoomed out', 'success');
                    }
                });
            }
            
            if (zoomResetBtn) {
                zoomResetBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        PortnoxDiagramGenerator.zoomActual();
                        updateStatus('Zoom reset', 'success');
                    }
                });
            }
            
            // Export buttons
            const exportPngBtn = document.getElementById('export-png-btn');
            const exportSvgBtn = document.getElementById('export-svg-btn');
            
            if (exportPngBtn) {
                exportPngBtn.addEventListener('click', function() {
                    handleExport('png');
                });
            }
            
            if (exportSvgBtn) {
                exportSvgBtn.addEventListener('click', function() {
                    handleExport('svg');
                });
            }
            
            // Add to Configuration button
            const addToConfigBtn = document.getElementById('add-to-config-btn');
            if (addToConfigBtn) {
                addToConfigBtn.addEventListener('click', function() {
                    addDiagramToConfiguration();
                });
            }
            
            // Best Practices button
            const bestPracticesBtn = document.getElementById('show-best-practices');
            if (bestPracticesBtn) {
                bestPracticesBtn.addEventListener('click', function() {
                    showBestPracticesModal();
                });
            }
        });
    };
    
    // Handle generate diagram button click
    const handleGenerateDiagram = function() {
        const diagramContainer = document.getElementById('diagram-container');
        const diagramCanvas = document.getElementById('diagram-canvas');
        
        if (!diagramContainer || !diagramCanvas) {
            updateStatus('Diagram container not found', 'error');
            return;
        }
        
        updateStatus('Generating diagram...', 'info');
        
        // Show the diagram container
        diagramContainer.classList.remove('d-none');
        
        // Get diagram options
        const showRadius = document.getElementById('show-radius')?.checked ?? true;
        const showAuth = document.getElementById('show-auth')?.checked ?? true;
        const showClients = document.getElementById('show-clients')?.checked ?? true;
        const showCloud = document.getElementById('show-cloud')?.checked ?? true;
        const showLegends = document.getElementById('show-legends')?.checked ?? true;
        const showDetailed = document.getElementById('show-detailed')?.checked ?? true;
        const vendor = document.getElementById('vendor-select')?.value || 'cisco';
        
        // Create config object
        const config = {
            showRadius,
            showAuth,
            showClients,
            showCloud,
            showLegends,
            showDetailed,
            vendor
        };
        
        // Initialize diagram if not already done
        if (!diagramInitialized) {
            diagramInitialized = PortnoxDiagramGenerator.initialize('diagram-canvas');
            if (!diagramInitialized) {
                updateStatus('Failed to initialize diagram generator', 'error');
                return;
            }
        }
        
        // Generate the diagram
        try {
            const success = PortnoxDiagramGenerator.generateDiagram(config, currentDiagramType);
            if (success) {
                updateStatus(`Successfully generated ${getReadableDiagramType(currentDiagramType)} diagram`, 'success');
            } else {
                updateStatus('Error generating diagram', 'error');
            }
        } catch (error) {
            updateStatus('Error: ' + error.message, 'error');
            console.error('Error generating diagram:', error);
        }
    };
    
    // Handle export button click
    const handleExport = function(format) {
        if (!diagramInitialized) {
            updateStatus('Diagram not initialized', 'error');
            return;
        }
        
        updateStatus(`Exporting diagram as ${format.toUpperCase()}...`, 'info');
        
        try {
            const resultPromise = PortnoxDiagramGenerator.exportDiagram(format);
            
            if (resultPromise instanceof Promise) {
                resultPromise.then(function(result) {
                    downloadDiagram(result, format);
                    updateStatus(`Successfully exported diagram as ${format.toUpperCase()}`, 'success');
                }).catch(function(error) {
                    updateStatus('Error exporting diagram: ' + error.message, 'error');
                    console.error('Error exporting diagram:', error);
                });
            } else {
                downloadDiagram(resultPromise, format);
                updateStatus(`Successfully exported diagram as ${format.toUpperCase()}`, 'success');
            }
        } catch (error) {
            updateStatus('Error exporting diagram: ' + error.message, 'error');
            console.error('Error exporting diagram:', error);
        }
    };
    
    // Helper to download the diagram
    const downloadDiagram = function(data, format) {
        if (!data) {
            updateStatus(`Failed to export diagram as ${format.toUpperCase()}`, 'error');
            return;
        }
        
        // Create download link
        const link = document.createElement('a');
        const diagramName = getReadableDiagramType(currentDiagramType).replace(/\s+/g, '_').toLowerCase();
        const filename = `portnox_${diagramName}_${new Date().toISOString().slice(0, 10)}.${format}`;
        
        if (format === 'png') {
            link.href = data;
            link.download = filename;
        } else if (format === 'svg') {
            const blob = new Blob([data], { type: 'image/svg+xml' });
            link.href = URL.createObjectURL(blob);
            link.download = filename;
        } else if (format === 'xml') {
            const blob = new Blob([data], { type: 'application/xml' });
            link.href = URL.createObjectURL(blob);
            link.download = `portnox_${diagramName}.xml`;
        }
        
        // Trigger download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };
    
    // Add the current diagram to the configuration
    const addDiagramToConfiguration = function() {
        if (!diagramInitialized) {
            updateStatus('No diagram to add to configuration', 'error');
            return;
        }
        
        try {
            // Export current diagram as SVG
            const svgData = PortnoxDiagramGenerator.exportDiagram('svg');
            
            // Add to configuration if possible
            if (typeof window.UaXSupreme !== 'undefined' && typeof window.UaXSupreme.addAsset === 'function') {
                const diagramName = getReadableDiagramType(currentDiagramType);
                const assetName = `portnox_${diagramName.replace(/\s+/g, '_').toLowerCase()}.svg`;
                
                window.UaXSupreme.addAsset({
                    name: assetName,
                    type: 'diagram',
                    data: svgData,
                    description: `Portnox Cloud NAC diagram for ${diagramName}`
                });
                
                updateStatus('Diagram added to configuration', 'success');
            } else {
                updateStatus('Configuration API not available', 'error');
            }
        } catch (error) {
            updateStatus('Error adding diagram to configuration: ' + error.message, 'error');
            console.error('Error adding diagram to configuration:', error);
        }
    };
    
    // Show best practices modal
    const showBestPracticesModal = function() {
        // Create modal if it doesn't exist
        let modal = document.getElementById('portnox-best-practices-modal');
        
        if (!modal) {
            modal = document.createElement('div');
            modal.id = 'portnox-best-practices-modal';
            modal.className = 'modal fade';
            modal.setAttribute('tabindex', '-1');
            modal.setAttribute('role', 'dialog');
            modal.setAttribute('aria-labelledby', 'portnoxBestPracticesTitle');
            modal.setAttribute('aria-hidden', 'true');
            
            modal.innerHTML = `
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="portnoxBestPracticesTitle">Portnox Cloud NAC Best Practices</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="nav nav-tabs" id="bestPracticesTabs" role="tablist">
                                <a class="nav-item nav-link active" id="general-tab" data-toggle="tab" href="#general" role="tab" aria-controls="general" aria-selected="true">General</a>
                                <a class="nav-item nav-link" id="deployment-tab" data-toggle="tab" href="#deployment" role="tab" aria-controls="deployment" aria-selected="false">Deployment</a>
                                <a class="nav-item nav-link" id="auth-tab" data-toggle="tab" href="#auth" role="tab" aria-controls="auth" aria-selected="false">Authentication</a>
                                <a class="nav-item nav-link" id="security-tab" data-toggle="tab" href="#security" role="tab" aria-controls="security" aria-selected="false">Security</a>
                                <a class="nav-item nav-link" id="industry-tab" data-toggle="tab" href="#industry" role="tab" aria-controls="industry" aria-selected="false">Industry-Specific</a>
                            </div>
                            <div class="tab-content p-3" id="bestPracticesTabContent">
                                <div class="tab-pane fade show active" id="general" role="tabpanel" aria-labelledby="general-tab">
                                    <h6>General Best Practices</h6>
                                    <ul>
                                        <li><strong>Phased Approach</strong>: Start with monitor mode before enforcing authentication</li>
                                        <li><strong>Network Visibility</strong>: Use Portnox to gain complete device visibility before enforcement</li>
                                        <li><strong>Documentation</strong>: Document existing network infrastructure, VLANs, and security requirements</li>
                                        <li><strong>Stakeholder Engagement</strong>: Involve IT, security, and business stakeholders in the planning</li>
                                        <li><strong>Training</strong>: Ensure IT staff are trained on NAC concepts and Portnox management</li>
                                        <li><strong>Help Desk</strong>: Prepare help desk with troubleshooting procedures for authentication issues</li>
                                        <li><strong>User Communication</strong>: Notify users about NAC implementation and expected changes</li>
                                        <li><strong>Testing</strong>: Test all device types and authentication scenarios before full deployment</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="deployment" role="tabpanel" aria-labelledby="deployment-tab">
                                    <h6>Deployment Best Practices</h6>
                                    <ul>
                                        <li><strong>Redundancy</strong>: Deploy multiple RADIUS servers for high availability</li>
                                        <li><strong>Guest Network</strong>: Set up a separate guest VLAN with appropriate security controls</li>
                                        <li><strong>Segmentation</strong>: Implement VLANs for different device categories and security levels</li>
                                        <li><strong>Fallback Options</strong>: Configure fallback authentication methods for critical systems</li>
                                        <li><strong>Monitoring</strong>: Implement monitoring for RADIUS servers and authentication events</li>
                                        <li><strong>Device Profiling</strong>: Use profiling to accurately identify and categorize devices</li>
                                        <li><strong>Integration</strong>: Integrate with existing infrastructure and security tools</li>
                                        <li><strong>Scalability</strong>: Plan for future growth in device numbers and locations</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="auth" role="tabpanel" aria-labelledby="auth-tab">
                                    <h6>Authentication Best Practices</h6>
                                    <ul>
                                        <li><strong>Corporate Devices</strong>: Use certificate-based authentication (EAP-TLS) for managed devices</li>
                                        <li><strong>BYOD</strong>: Implement secure onboarding with device registration and posture assessment</li>
                                        <li><strong>IoT Devices</strong>: Use MAC Authentication Bypass (MAB) with device profiling</li>
                                        <li><strong>Guest Access</strong>: Implement captive portal with registration and limited access</li>
                                        <li><strong>Multi-factor Authentication</strong>: Require MFA for sensitive access scenarios</li>
                                        <li><strong>Certificate Management</strong>: Implement secure certificate lifecycle management</li>
                                        <li><strong>Password Policies</strong>: Enforce strong password policies where passwords are used</li>
                                        <li><strong>Vendor Support</strong>: Verify NAC compatibility with all network infrastructure vendors</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="security" role="tabpanel" aria-labelledby="security-tab">
                                    <h6>Security Best Practices</h6>
                                    <ul>
                                        <li><strong>Posture Assessment</strong>: Check device compliance before granting network access</li>
                                        <li><strong>Continuous Monitoring</strong>: Continuously verify device compliance and behavior</li>
                                        <li><strong>Least Privilege</strong>: Grant minimal necessary access based on device and user</li>
                                        <li><strong>Remediation</strong>: Provide self-remediation options for non-compliant devices</li>
                                        <li><strong>Incident Response</strong>: Integrate NAC with security incident response processes</li>
                                        <li><strong>Logging & Auditing</strong>: Maintain comprehensive logs for compliance and forensics</li>
                                        <li><strong>Encryption</strong>: Enforce encryption for all authentication and management traffic</li>
                                        <li><strong>Rogue Device Detection</strong>: Identify and isolate unauthorized devices</li>
                                    </ul>
                                </div>
                                <div class="tab-pane fade" id="industry" role="tabpanel" aria-labelledby="industry-tab">
                                    <h6>Industry-Specific Best Practices</h6>
                                    <ul>
                                        <li><strong>Healthcare</strong>: Implement strict segmentation for medical devices, ensure HIPAA compliance</li>
                                        <li><strong>Financial</strong>: Meet PCI-DSS requirements, implement multi-factor authentication, strict access controls</li>
                                        <li><strong>Education</strong>: Support diverse BYOD environments, implement role-based access for students/faculty</li>
                                        <li><strong>Manufacturing</strong>: Secure OT/IT convergence, protect industrial control systems</li>
                                        <li><strong>Retail</strong>: Isolate POS systems, secure guest WiFi, protect customer data</li>
                                        <li><strong>Government</strong>: Meet FIPS, NIST, and agency-specific requirements</li>
                                        <li><strong>Transportation</strong>: Protect operational technology, support mobile workforce</li>
                                        <li><strong>Utilities</strong>: Secure critical infrastructure, meet regulatory requirements</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                </div>
            `;
            
            document.body.appendChild(modal);
        }
        
        // Show the modal
        if (typeof $ !== 'undefined') {
            $('#portnox-best-practices-modal').modal('show');
        } else {
            const modalElem = document.getElementById('portnox-best-practices-modal');
            modalElem.classList.add('show');
            modalElem.style.display = 'block';
            modalElem.setAttribute('aria-hidden', 'false');
            document.body.classList.add('modal-open');
            
            // Add backdrop
            const backdrop = document.createElement('div');
            backdrop.className = 'modal-backdrop fade show';
            document.body.appendChild(backdrop);
            
            // Add close handlers
            const closeButtons = modalElem.querySelectorAll('[data-dismiss="modal"]');
            closeButtons.forEach(function(button) {
                button.addEventListener('click', function() {
                    modalElem.classList.remove('show');
                    modalElem.style.display = 'none';
                    modalElem.setAttribute('aria-hidden', 'true');
                    document.body.classList.remove('modal-open');
                    document.body.removeChild(backdrop);
                });
            });
        }
    };
    
    // Update status message
    const updateStatus = function(message, type) {
        const statusElement = document.getElementById('diagram-status');
        if (statusElement) {
            statusElement.textContent = message;
            statusElement.className = `alert alert-${type === 'error' ? 'danger' : (type === 'info' ? 'info' : 'success')}`;
            statusElement.classList.remove('d-none');
            
            // Hide after delay for success messages
            if (type === 'success') {
                setTimeout(() => {
                    statusElement.classList.add('d-none');
                }, 3000);
            }
        }
    };
    
    // Get readable diagram type name from key
    const getReadableDiagramType = function(type) {
        const typeMap = {
            'basic_cloud_deployment': 'Basic Cloud Deployment',
            'enterprise_deployment': 'Enterprise Deployment',
            'healthcare_deployment': 'Healthcare Deployment',
            'education_deployment': 'Education Deployment',
            'retail_deployment': 'Retail Deployment',
            'manufacturing_deployment': 'Manufacturing Deployment',
            'government_deployment': 'Government Deployment',
            'financial_deployment': 'Financial Services Deployment',
            'eap_tls_authentication': 'EAP-TLS Authentication Flow',
            'byod_onboarding': 'BYOD Onboarding Flow',
            'dynamic_vlan_assignment': 'Dynamic VLAN Assignment',
            'multi_vendor_deployment': 'Multi-Vendor Deployment',
            'high_security_deployment': 'High Security Deployment',
            'cloud_integration': 'Cloud Integration',
            'multi_site_deployment': 'Multi-Site Deployment',
            'iot_segmentation': 'IoT Segmentation',
            'guest_access': 'Guest Access'
        };
        
        return typeMap[type] || type.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
    };
    
    // Public API
    return {
        initialize: initialize
    };
})();
