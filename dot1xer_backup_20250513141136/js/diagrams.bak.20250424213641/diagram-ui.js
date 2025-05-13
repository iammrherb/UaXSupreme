/**
 * diagram-ui.js - UI components for Portnox Cloud diagrams
 * @version 3.0.0
 */

const DiagramUI = (function() {
    // Private variables
    let diagramInitialized = false;
    let currentDiagramType = 'basic_deployment';
    
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
            tempContainer.id = 'diagram-section';
            tempContainer.className = 'diagram-section mt-4';
            tempContainer.innerHTML = createDiagramUI();
            
            // Add after the main content or at the end of body
            const mainContent = document.querySelector('main') || document.body;
            mainContent.appendChild(tempContainer);
        } else {
            // Add to documentation tab
            const diagramSection = document.createElement('div');
            diagramSection.className = 'diagram-section mt-4';
            diagramSection.innerHTML = createDiagramUI();
            documentationTab.appendChild(diagramSection);
        }
    };
    
    // Create HTML for the diagram UI
    const createDiagramUI = function() {
        return `
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="m-0">Portnox Network Diagrams</h5>
            </div>
            <div class="card-body">
                <div class="row mb-4">
                    <div class="col-md-6">
                        <h6>Diagram Type</h6>
                        <div class="form-group">
                            <select class="form-control" id="diagram-type">
                                <option value="basic_deployment">Basic Portnox Cloud Deployment</option>
                                <option value="eap_tls_flow">EAP-TLS Authentication Flow</option>
                                <option value="byod_onboarding">BYOD Onboarding Process</option>
                                <option value="dynamic_vlan">Dynamic VLAN Assignment</option>
                                <option value="multi_cloud">Multi-Cloud Deployment</option>
                            </select>
                        </div>
                        <button id="generate-diagram-btn" class="btn btn-primary mt-2">
                            <i class="fas fa-project-diagram mr-2"></i>Generate Diagram
                        </button>
                    </div>
                    <div class="col-md-6">
                        <h6>Diagram Options</h6>
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
                    </div>
                </div>
                
                <div id="diagram-container" class="diagram-container d-none">
                    <div class="diagram-toolbar">
                        <button id="zoom-in-btn" class="btn btn-sm btn-light" title="Zoom In">
                            <i class="fas fa-search-plus"></i>
                        </button>
                        <button id="zoom-out-btn" class="btn btn-sm btn-light" title="Zoom Out">
                            <i class="fas fa-search-minus"></i>
                        </button>
                        <button id="zoom-reset-btn" class="btn btn-sm btn-light" title="Reset Zoom">
                            <i class="fas fa-compress"></i>
                        </button>
                        <span class="toolbar-separator"></span>
                        <button id="export-png-btn" class="btn btn-sm btn-light" title="Export as PNG">
                            <i class="fas fa-file-image"></i> PNG
                        </button>
                        <button id="export-svg-btn" class="btn btn-sm btn-light" title="Export as SVG">
                            <i class="fas fa-file-code"></i> SVG
                        </button>
                    </div>
                    <div id="diagram-canvas" style="position: absolute; top: 40px; left: 0; right: 0; bottom: 0;"></div>
                </div>
                
                <h6 class="mt-4">Template Diagrams</h6>
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="basic_deployment">
                            <div class="template-thumbnail">
                                <i class="fas fa-network-wired fa-3x text-primary"></i>
                            </div>
                            <div class="template-title">Basic Deployment</div>
                            <div class="template-description">Standard Portnox Cloud deployment</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="eap_tls_flow">
                            <div class="template-thumbnail">
                                <i class="fas fa-key fa-3x text-success"></i>
                            </div>
                            <div class="template-title">EAP-TLS Flow</div>
                            <div class="template-description">Certificate-based authentication</div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-3">
                        <div class="template-card" data-template="byod_onboarding">
                            <div class="template-thumbnail">
                                <i class="fas fa-mobile-alt fa-3x text-info"></i>
                            </div>
                            <div class="template-title">BYOD Onboarding</div>
                            <div class="template-description">Device enrollment process</div>
                        </div>
                    </div>
                </div>
                
                <div class="mt-4 p-3 bg-light rounded">
                    <h6><i class="fas fa-info-circle mr-2"></i>Portnox NAC Deployment Best Practices</h6>
                    <ul>
                        <li>Start with monitor mode before enforcing authentication</li>
                        <li>Configure guest VLAN for unauthenticated devices</li>
                        <li>Use certificate-based authentication for corporate devices</li>
                        <li>Implement dynamic VLAN assignment based on device type</li>
                        <li>Set up MDM integration for device compliance checks</li>
                    </ul>
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
                        DiagramGenerator.zoomIn();
                    }
                });
            }
            
            if (zoomOutBtn) {
                zoomOutBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        DiagramGenerator.zoomOut();
                    }
                });
            }
            
            if (zoomResetBtn) {
                zoomResetBtn.addEventListener('click', function() {
                    if (diagramInitialized) {
                        DiagramGenerator.zoomActual();
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
        });
    };
    
    // Handle generate diagram button click
    const handleGenerateDiagram = function() {
        const diagramContainer = document.getElementById('diagram-container');
        const diagramCanvas = document.getElementById('diagram-canvas');
        
        if (!diagramContainer || !diagramCanvas) return;
        
        // Show the diagram container
        diagramContainer.classList.remove('d-none');
        
        // Get diagram options
        const showRadius = document.getElementById('show-radius')?.checked ?? true;
        const showAuth = document.getElementById('show-auth')?.checked ?? true;
        const showClients = document.getElementById('show-clients')?.checked ?? true;
        const showCloud = document.getElementById('show-cloud')?.checked ?? true;
        
        // Get configuration from ConfigSteps if available
        let config = {
            showRadius,
            showAuth,
            showClients,
            showCloud
        };
        
        try {
            if (window.ConfigSteps && typeof ConfigSteps.getConfig === 'function') {
                const userConfig = ConfigSteps.getConfig();
                config = { ...config, ...userConfig };
            }
        } catch (e) {
            console.warn('Could not get configuration from ConfigSteps:', e);
        }
        
        // Initialize diagram if not already done
        if (!diagramInitialized) {
            diagramInitialized = DiagramGenerator.initialize('diagram-canvas');
        }
        
        if (diagramInitialized) {
            // Generate the diagram
            DiagramGenerator.generateDiagram(config, currentDiagramType);
        } else {
            console.error('Failed to initialize diagram generator');
        }
    };
    
    // Handle export button click
    const handleExport = function(format) {
        if (!diagramInitialized) return;
        
        const result = DiagramGenerator.exportDiagram(format);
        if (!result) {
            console.error('Failed to export diagram');
            return;
        }
        
        // Create download link
        const link = document.createElement('a');
        const filename = `portnox_${currentDiagramType}_${new Date().toISOString().slice(0, 10)}.${format}`;
        
        if (format === 'png') {
            link.href = result;
            link.download = filename;
        } else if (format === 'svg') {
            const blob = new Blob([result], { type: 'image/svg+xml' });
            link.href = URL.createObjectURL(blob);
            link.download = filename;
        } else if (format === 'xml') {
            const blob = new Blob([result], { type: 'application/xml' });
            link.href = URL.createObjectURL(blob);
            link.download = filename.replace(`.${format}`, '.xml');
        }
        
        // Trigger download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    };
    
    // Public API
    return {
        initialize: initialize
    };
})();
