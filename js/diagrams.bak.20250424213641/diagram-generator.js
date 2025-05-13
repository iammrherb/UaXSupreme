/**
 * diagram-generator.js - Comprehensive diagram generation for Portnox Cloud deployments
 * @version 3.0.0
 */

const DiagramGenerator = (function() {
    // Private variables
    let editor = null;
    let graph = null;
    let currentConfig = null;
    let diagramContainer = null;
    
    // Initialize the diagram editor
    const initialize = function(containerId) {
        diagramContainer = document.getElementById(containerId);
        if (!diagramContainer) {
            console.error('Container element not found:', containerId);
            return false;
        }
        
        try {
            if (typeof mxClient === 'undefined') {
                console.error('mxClient is not defined. Make sure draw.io libraries are loaded.');
                return false;
            }
            
            if (!mxClient.isBrowserSupported()) {
                console.error('Browser is not supported by mxGraph');
                return false;
            }
            
            // Disables the built-in context menu
            mxEvent.disableContextMenu(diagramContainer);
            
            // Creates the graph inside the given container
            editor = new mxEditor();
            graph = editor.graph;
            
            // Configure graph behavior
            configureGraph();
            
            // Load stencil libraries
            loadStencils();
            
            return true;
        } catch (e) {
            console.error('Failed to initialize diagram editor:', e);
            return false;
        }
    };
    
    // Configure graph display and behavior
    const configureGraph = function() {
        // Enable basic graph features
        graph.setEnabled(true);
        graph.setCellsResizable(true);
        graph.setCellsEditable(false);
        graph.setConnectable(true);
        graph.setPanning(true);
        graph.setTooltips(true);
        graph.setAllowDanglingEdges(false);
        
        // Create default styles
        const stylesheet = graph.getStylesheet();
        
        // Default vertex style
        const vertexStyle = stylesheet.getDefaultVertexStyle();
        vertexStyle[mxConstants.STYLE_SHAPE] = mxConstants.SHAPE_RECTANGLE;
        vertexStyle[mxConstants.STYLE_PERIMETER] = mxPerimeter.RectanglePerimeter;
        vertexStyle[mxConstants.STYLE_FONTCOLOR] = '#000000';
        vertexStyle[mxConstants.STYLE_FILLCOLOR] = '#FFFFFF';
        vertexStyle[mxConstants.STYLE_STROKECOLOR] = '#000000';
        vertexStyle[mxConstants.STYLE_ROUNDED] = true;
        vertexStyle[mxConstants.STYLE_SHADOW] = false;
        
        // Default edge style
        const edgeStyle = stylesheet.getDefaultEdgeStyle();
        edgeStyle[mxConstants.STYLE_STROKECOLOR] = '#333333';
        edgeStyle[mxConstants.STYLE_FONTCOLOR] = '#333333';
        edgeStyle[mxConstants.STYLE_LABEL_BACKGROUNDCOLOR] = '#FFFFFF';
        edgeStyle[mxConstants.STYLE_EDGE] = mxEdgeStyle.OrthConnector;
        edgeStyle[mxConstants.STYLE_ROUNDED] = true;
        edgeStyle[mxConstants.STYLE_STROKEWIDTH] = 2;
        edgeStyle[mxConstants.STYLE_ENDARROW] = mxConstants.ARROW_CLASSIC;
        
        // Add custom styles for Portnox components
        stylesheet.putCellStyle('portnoxCloud', {
            [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
            [mxConstants.STYLE_IMAGE]: 'images/stencils/portnox/portnox_cloud.svg',
            [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
            [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
        });
        
        stylesheet.putCellStyle('portnoxRadius', {
            [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
            [mxConstants.STYLE_IMAGE]: 'images/stencils/portnox/portnox_radius.svg',
            [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
            [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
        });
        
        // Enable double-click to collapse/expand groups
        graph.setEnabled(true);
        
        // Enable mouse wheel for zoom
        mxEvent.addMouseWheelListener(function(evt, up) {
            if (mxEvent.isControlDown(evt)) {
                if (up) {
                    graph.zoomIn();
                } else {
                    graph.zoomOut();
                }
                mxEvent.consume(evt);
            }
        });
    };
    
    // Load custom stencil sets
    const loadStencils = function() {
        try {
            // Load Portnox stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/portnox.xml');
            console.log('Loaded Portnox stencils');
            
            // Load authentication stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/authentication_methods.xml');
            console.log('Loaded Authentication stencils');
            
            // Load device stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/devices.xml');
            console.log('Loaded Device stencils');
            
            // Load vendor stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/all_vendors.xml');
            console.log('Loaded Vendor stencils');
            
            // Load cloud service stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/cloud_services.xml');
            console.log('Loaded Cloud service stencils');
            
            // Check for any additional stencil libraries from draw.io
            try {
                if (mxUtils.isNode(mxStencilRegistry.packages['general'])) {
                    console.log('General stencils already loaded');
                } else {
                    mxStencilRegistry.loadStencilSet('js/diagrams/stencils/general.xml');
                    console.log('Loaded General stencils');
                }
                
                if (mxUtils.isNode(mxStencilRegistry.packages['network'])) {
                    console.log('Network stencils already loaded');
                } else {
                    mxStencilRegistry.loadStencilSet('js/diagrams/stencils/network.xml');
                    console.log('Loaded Network stencils');
                }
            } catch (e) {
                console.warn('Some additional stencils might not be loaded:', e);
            }
        } catch (e) {
            console.error('Error loading stencils:', e);
        }
    };
    
    // Generate diagram based on the template and configuration
    const generateDiagram = function(config, diagramType) {
        try {
            // Store current configuration
            currentConfig = config;
            
            // Clear existing diagram
            graph.getModel().beginUpdate();
            try {
                // Remove all cells
                graph.removeCells(graph.getChildCells(graph.getDefaultParent()));
            } finally {
                graph.getModel().endUpdate();
            }
            
            // Load appropriate template
            let templatePath;
            switch (diagramType) {
                case 'basic_deployment':
                    templatePath = 'js/diagrams/templates/deployment/basic_cloud_deployment.xml';
                    break;
                case 'eap_tls_flow':
                    templatePath = 'js/diagrams/templates/authentication/eap_tls_flow.xml';
                    break;
                case 'byod_onboarding':
                    templatePath = 'js/diagrams/templates/onboarding/byod_onboarding.xml';
                    break;
                case 'dynamic_vlan':
                    templatePath = 'js/diagrams/templates/segmentation/dynamic_vlan.xml';
                    break;
                case 'multi_cloud':
                    templatePath = 'js/diagrams/templates/deployment/multi_cloud_deployment.xml';
                    break;
                default:
                    templatePath = 'js/diagrams/templates/deployment/basic_cloud_deployment.xml';
            }
            
            // Load the template
            loadTemplate(templatePath);
            
            return true;
        } catch (e) {
            console.error('Error generating diagram:', e);
            return false;
        }
    };
    
    // Load template from file
    const loadTemplate = function(templatePath) {
        const request = new XMLHttpRequest();
        request.open('GET', templatePath, true);
        
        request.onreadystatechange = function() {
            if (request.readyState === 4) {
                if (request.status === 200) {
                    const xmlDoc = mxUtils.parseXml(request.responseText);
                    importGraphFromXml(xmlDoc);
                } else {
                    console.error('Error loading template: ' + templatePath);
                    // Create a minimal blank diagram as fallback
                    createBasicDiagram();
                }
            }
        };
        
        request.onerror = function() {
            console.error('Network error while loading template');
            createBasicDiagram();
        };
        
        request.send();
    };
    
    // Import XML into the graph
    const importGraphFromXml = function(xmlDoc) {
        try {
            const codec = new mxCodec(xmlDoc);
            const model = codec.decode(xmlDoc.documentElement);
            
            graph.getModel().beginUpdate();
            try {
                graph.getModel().clear();
                graph.getModel().setRoot(model.getRoot());
                
                // Customize based on configuration
                customizeDiagram(currentConfig);
                
                // Center the graph
                graph.center(true, true, 0.5, 0.5);
                
                // Reset zoom
                graph.zoomActual();
            } finally {
                graph.getModel().endUpdate();
            }
        } catch (e) {
            console.error('Error importing graph from XML:', e);
            createBasicDiagram();
        }
    };
    
    // Create a basic diagram as fallback
    const createBasicDiagram = function() {
        graph.getModel().beginUpdate();
        try {
            const parent = graph.getDefaultParent();
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                100, 100, 120, 60, 'portnoxCloud');
            
            // Add Corporate Network
            const network = graph.insertVertex(parent, null, 'Corporate Network', 
                100, 220, 120, 60, 'rounded=1;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect them
            graph.insertEdge(parent, null, 'RADIUS', portnoxCloud, network);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Customize diagram based on configuration
    const customizeDiagram = function(config) {
        // This would be implemented based on the specific configuration options
        // For example, showing/hiding certain elements based on user selections
    };
    
    // Zoom in
    const zoomIn = function() {
        graph.zoomIn();
    };
    
    // Zoom out
    const zoomOut = function() {
        graph.zoomOut();
    };
    
    // Reset zoom
    const zoomActual = function() {
        graph.zoomActual();
    };
    
    // Export the diagram as image or XML
    const exportDiagram = function(format) {
        if (format === 'png') {
            const bounds = graph.getGraphBounds();
            const vs = graph.view.scale;
            
            // Create a PNG image
            const imgExport = new mxImageExport();
            const imgCanvas = new mxImageCanvas2D(document.createElement('canvas'));
            imgCanvas.canvas.width = Math.round(bounds.width * vs) + 2;
            imgCanvas.canvas.height = Math.round(bounds.height * vs) + 2;
            imgCanvas.scale = vs;
            imgCanvas.translate(-bounds.x, -bounds.y);
            
            imgExport.drawState(graph.getView().getState(graph.model.root), imgCanvas);
            
            return imgCanvas.canvas.toDataURL('image/png');
        } else if (format === 'svg') {
            // Create an SVG image
            const svgCanvas = new mxSvgCanvas2D(document.createElement('svg'));
            const imgExport = new mxImageExport();
            const bounds = graph.getGraphBounds();
            const svgDocument = svgCanvas.getDocument();
            
            svgCanvas.translate(-bounds.x, -bounds.y);
            imgExport.drawState(graph.getView().getState(graph.model.root), svgCanvas);
            
            return mxUtils.getXml(svgDocument);
        } else if (format === 'xml') {
            // Export as XML
            const encoder = new mxCodec();
            const result = encoder.encode(graph.getModel());
            return mxUtils.getXml(result);
        }
        
        return null;
    };
    
    // Public API
    return {
        initialize: initialize,
        generateDiagram: generateDiagram,
        zoomIn: zoomIn,
        zoomOut: zoomOut,
        zoomActual: zoomActual,
        exportDiagram: exportDiagram
    };
})();
