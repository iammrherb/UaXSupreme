/**
 * Portnox NAC Diagram Generator for UaXSupreme
 * @version 1.0.0
 * 
 * A comprehensive diagram generator for Portnox Cloud NAC deployments
 * that includes support for all vendors, authentication methods, and
 * deployment scenarios.
 */

const PortnoxDiagramGenerator = (function() {
    // Private variables
    let graph = null;
    let currentConfig = null;
    let diagramContainer = null;
    
    // Initialize the diagram generator
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
            
            // Create a graph inside the given container
            graph = new mxGraph(diagramContainer);
            
            // Configure graph behavior
            configureGraph();
            
            // Load stencil libraries
            loadStencils();
            
            return true;
        } catch (e) {
            console.error('Failed to initialize diagram generator:', e);
            return false;
        }
    };
    
    // Configure graph display and behavior
    const configureGraph = function() {
        // Enable basic features
        graph.setEnabled(true);
        graph.setPanning(true);
        graph.setTooltips(true);
        graph.setConnectable(true);
        graph.setCellsEditable(false);
        
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
        
        // Custom switch styles for each vendor
        const vendors = ['cisco', 'aruba', 'juniper', 'hp', 'dell', 'extreme', 'arista', 'fortinet', 'paloalto'];
        vendors.forEach(vendor => {
            stylesheet.putCellStyle(`${vendor}Switch`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/switch.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
            
            stylesheet.putCellStyle(`${vendor}Router`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/router.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
            
            stylesheet.putCellStyle(`${vendor}Firewall`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/firewall.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
            
            stylesheet.putCellStyle(`${vendor}WirelessAP`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/vendors/${vendor}/wireless_ap.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
        });
        
        // Add custom styles for authentication methods
        const authMethods = ['eap_tls', 'peap', 'eap_ttls', 'eap_fast', 'mab'];
        authMethods.forEach(method => {
            stylesheet.putCellStyle(`auth${method.replace('eap_', '').toUpperCase()}`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/authentication/${method}.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
        });
        
        // Add device styles
        const devices = ['byod', 'iot', 'printer', 'phone', 'camera', 'desktop', 'server'];
        devices.forEach(device => {
            stylesheet.putCellStyle(`device${device.charAt(0).toUpperCase() + device.slice(1)}`, {
                [mxConstants.STYLE_SHAPE]: mxConstants.SHAPE_IMAGE,
                [mxConstants.STYLE_IMAGE]: `images/stencils/devices/${device}.svg`,
                [mxConstants.STYLE_VERTICAL_LABEL_POSITION]: 'bottom',
                [mxConstants.STYLE_VERTICAL_ALIGN]: 'top'
            });
        });
        
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
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/authentication.xml');
            console.log('Loaded Authentication stencils');
            
            // Load device stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/devices.xml');
            console.log('Loaded Device stencils');
            
            // Load vendor stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/vendors.xml');
            console.log('Loaded Vendor stencils');
            
            // Load cloud service stencils
            mxStencilRegistry.loadStencilSet('js/diagrams/stencils/cloud_services.xml');
            console.log('Loaded Cloud service stencils');
        } catch (e) {
            console.error('Error loading stencils:', e);
        }
    };
    
    // Generate a diagram based on the specified type and configuration
    const generateDiagram = function(config, diagramType) {
        try {
            // Store current configuration
            currentConfig = config || {};
            
            // Clear existing diagram
            graph.getModel().beginUpdate();
            try {
                // Remove all cells
                graph.removeCells(graph.getChildCells(graph.getDefaultParent()));
            } finally {
                graph.getModel().endUpdate();
            }
            
            // Generate the diagram based on the specified type
            switch (diagramType) {
                case 'basic_cloud_deployment':
                    generateBasicCloudDeployment();
                    break;
                case 'enterprise_deployment':
                    generateEnterpriseDeployment();
                    break;
                case 'healthcare_deployment':
                    generateHealthcareDeployment();
                    break;
                case 'education_deployment':
                    generateEducationDeployment();
                    break;
                case 'retail_deployment':
                    generateRetailDeployment();
                    break;
                case 'manufacturing_deployment':
                    generateManufacturingDeployment();
                    break;
                case 'government_deployment':
                    generateGovernmentDeployment();
                    break;
                case 'financial_deployment':
                    generateFinancialDeployment();
                    break;
                case 'eap_tls_authentication':
                    generateEapTlsAuthenticationFlow();
                    break;
                case 'byod_onboarding':
                    generateByodOnboardingFlow();
                    break;
                case 'dynamic_vlan_assignment':
                    generateDynamicVlanAssignment();
                    break;
                case 'multi_vendor_deployment':
                    generateMultiVendorDeployment();
                    break;
                case 'high_security_deployment':
                    generateHighSecurityDeployment();
                    break;
                case 'cloud_integration':
                    generateCloudIntegration();
                    break;
                case 'multi_site_deployment':
                    generateMultiSiteDeployment();
                    break;
                case 'iot_segmentation':
                    generateIoTSegmentation();
                    break;
                case 'guest_access':
                    generateGuestAccess();
                    break;
                default:
                    generateBasicCloudDeployment();
            }
            
            return true;
        } catch (e) {
            console.error('Error generating diagram:', e);
            return false;
        }
    };
    
    // Basic Portnox Cloud Deployment diagram
    const generateBasicCloudDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 50, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server if enabled
            let radiusServer = null;
            if (currentConfig.showRadius !== false) {
                radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                    350, 180, 150, 60, 'portnoxRadius');
                
                // Connect Portnox Cloud to RADIUS
                graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            }
            
            // Add Network
            const network = graph.insertVertex(parent, null, 'Corporate Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect RADIUS to Network if RADIUS is shown, otherwise connect Cloud directly
            if (radiusServer) {
                graph.insertEdge(parent, null, 'RADIUS', radiusServer, network);
            } else {
                graph.insertEdge(parent, null, 'RADIUS', portnoxCloud, network);
            }
            
            // Add network devices
            const vendor = currentConfig.vendor || 'cisco';
            const switchDevice = graph.insertVertex(parent, null, 'Switch', 
                200, 400, 60, 60, `${vendor}Switch`);
            
            const wirelessAP = graph.insertVertex(parent, null, 'Wireless AP', 
                500, 400, 60, 60, `${vendor}WirelessAP`);
            
            // Connect network devices to network
            graph.insertEdge(parent, null, '', switchDevice, network);
            graph.insertEdge(parent, null, '', wirelessAP, network);
            
            // Add client devices if enabled
            if (currentConfig.showClients !== false) {
                // Add wired clients
                const byodDevice = graph.insertVertex(parent, null, 'BYOD Device', 
                    120, 500, 60, 60, 'deviceByod');
                
                const iotDevice = graph.insertVertex(parent, null, 'IoT Device', 
                    220, 500, 60, 60, 'deviceIot');
                
                const printer = graph.insertVertex(parent, null, 'Printer', 
                    320, 500, 60, 60, 'devicePrinter');
                
                // Connect wired devices to switch
                graph.insertEdge(parent, null, '', byodDevice, switchDevice);
                graph.insertEdge(parent, null, '', iotDevice, switchDevice);
                graph.insertEdge(parent, null, '', printer, switchDevice);
                
                // Add wireless clients
                const wirelessClient = graph.insertVertex(parent, null, 'Wireless Client', 
                    500, 500, 60, 60, 'deviceByod');
                
                // Connect wireless device to AP
                graph.insertEdge(parent, null, '', wirelessClient, wirelessAP);
            }
            
            // Add authentication methods if enabled
            if (currentConfig.showAuth !== false) {
                const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                    600, 180, 100, 60, 'authTLS');
                
                if (radiusServer) {
                    graph.insertEdge(parent, null, 'Authentication', eapTls, radiusServer);
                } else {
                    graph.insertEdge(parent, null, 'Authentication', eapTls, portnoxCloud);
                }
            }
            
            // Add cloud services if enabled
            if (currentConfig.showCloud !== false) {
                const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                    600, 50, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
                
                graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            }
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Enterprise deployment with high security and segmentation
    const generateEnterpriseDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Enterprise Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 70, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add DMZ and Internal Networks
            const dmzNetwork = graph.insertVertex(parent, null, 'DMZ', 
                150, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;');
            
            const internalNetwork = graph.insertVertex(parent, null, 'Internal Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const serverNetwork = graph.insertVertex(parent, null, 'Server Network', 
                550, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#e1d5e7;strokeColor=#9673a6;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, dmzNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, internalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, internalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, serverNetwork);
            
            // Add network devices
            const vendor = currentConfig.vendor || 'cisco';
            
            // DMZ Devices
            const dmzFirewall = graph.insertVertex(parent, null, 'DMZ Firewall', 
                150, 400, 60, 60, `${vendor}Firewall`);
            
            // Internal Devices
            const coreSwitch = graph.insertVertex(parent, null, 'Core Switch', 
                350, 400, 60, 60, `${vendor}Switch`);
            
            // Server Devices
            const serverSwitch = graph.insertVertex(parent, null, 'Server Switch', 
                550, 400, 60, 60, `${vendor}Switch`);
            
            // Connect network devices to networks
            graph.insertEdge(parent, null, '', dmzFirewall, dmzNetwork);
            graph.insertEdge(parent, null, '', coreSwitch, internalNetwork);
            graph.insertEdge(parent, null, '', serverSwitch, serverNetwork);
            
            // Add Access Layer
            const accessSwitch1 = graph.insertVertex(parent, null, 'Access Switch 1', 
                250, 500, 60, 60, `${vendor}Switch`);
            
            const accessSwitch2 = graph.insertVertex(parent, null, 'Access Switch 2', 
                350, 500, 60, 60, `${vendor}Switch`);
            
            const wirelessController = graph.insertVertex(parent, null, 'Wireless Controller', 
                450, 500, 60, 60, `${vendor}WirelessAP`);
            
            // Connect access layer to core
            graph.insertEdge(parent, null, '', accessSwitch1, coreSwitch);
            graph.insertEdge(parent, null, '', accessSwitch2, coreSwitch);
            graph.insertEdge(parent, null, '', wirelessController, coreSwitch);
            
            // Add client devices
            const desktop1 = graph.insertVertex(parent, null, 'Desktop', 
                200, 600, 60, 60, 'deviceDesktop');
            
            const desktop2 = graph.insertVertex(parent, null, 'Desktop', 
                300, 600, 60, 60, 'deviceDesktop');
            
            const wirelessAP1 = graph.insertVertex(parent, null, 'AP', 
                420, 600, 60, 60, `${vendor}WirelessAP`);
            
            const wirelessAP2 = graph.insertVertex(parent, null, 'AP', 
                500, 600, 60, 60, `${vendor}WirelessAP`);
            
            // Connect devices
            graph.insertEdge(parent, null, '', desktop1, accessSwitch1);
            graph.insertEdge(parent, null, '', desktop2, accessSwitch2);
            graph.insertEdge(parent, null, '', wirelessAP1, wirelessController);
            graph.insertEdge(parent, null, '', wirelessAP2, wirelessController);
            
            // Add server
            const server = graph.insertVertex(parent, null, 'Server', 
                550, 500, 60, 60, 'deviceServer');
            
            graph.insertEdge(parent, null, '', server, serverSwitch);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Auth', mab, portnoxCloud);
            
            // Add Identity Sources
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                700, 70, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Healthcare specific deployment
    const generateHealthcareDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Healthcare Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle with focus on HIPAA compliance
            const subtitle = graph.insertVertex(parent, null, 'HIPAA Compliant NAC Solution', 
                350, 50, 200, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Segmented Networks
            const adminNetwork = graph.insertVertex(parent, null, 'Administrative Network', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const clinicalNetwork = graph.insertVertex(parent, null, 'Clinical Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            const medicalDevicesNetwork = graph.insertVertex(parent, null, 'Medical Devices Network', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, adminNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, clinicalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, clinicalNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, medicalDevicesNetwork);
            
            // Add network devices
            const vendor = currentConfig.vendor || 'cisco';
            
            // Admin Network Devices
            const adminSwitch = graph.insertVertex(parent, null, 'Admin Switch', 
                150, 400, 60, 60, `${vendor}Switch`);
            
            // Clinical Network Devices
            const clinicalSwitch = graph.insertVertex(parent, null, 'Clinical Switch', 
                350, 400, 60, 60, `${vendor}Switch`);
            
            // Medical Devices Network
            const medicalSwitch = graph.insertVertex(parent, null, 'Medical Device Switch', 
                550, 400, 60, 60, `${vendor}Switch`);
            
            // Connect network devices to networks
            graph.insertEdge(parent, null, '', adminSwitch, adminNetwork);
            graph.insertEdge(parent, null, '', clinicalSwitch, clinicalNetwork);
            graph.insertEdge(parent, null, '', medicalSwitch, medicalDevicesNetwork);
            
            // Add client devices
            const adminComputer = graph.insertVertex(parent, null, 'Admin PC', 
                150, 500, 60, 60, 'deviceDesktop');
            
            const clinicalWorkstation = graph.insertVertex(parent, null, 'Clinical Workstation', 
                300, 500, 60, 60, 'deviceDesktop');
            
            const tablet = graph.insertVertex(parent, null, 'Medical Tablet', 
                400, 500, 60, 60, 'deviceByod');
            
            const mriMachine = graph.insertVertex(parent, null, 'MRI Machine', 
                500, 500, 60, 60, 'deviceIot');
            
            const patientMonitor = graph.insertVertex(parent, null, 'Patient Monitor', 
                600, 500, 60, 60, 'deviceIot');
            
            // Connect devices to switches
            graph.insertEdge(parent, null, '', adminComputer, adminSwitch);
            graph.insertEdge(parent, null, '', clinicalWorkstation, clinicalSwitch);
            graph.insertEdge(parent, null, '', tablet, clinicalSwitch);
            graph.insertEdge(parent, null, '', mriMachine, medicalSwitch);
            graph.insertEdge(parent, null, '', patientMonitor, medicalSwitch);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'Corporate Devices', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Medical Devices', mab, portnoxCloud);
            
            // Add compliance box
            const complianceBox = graph.insertVertex(parent, null, 
                'HIPAA Compliance Features:\n• Network Segmentation\n• Device Authentication\n• Continuous Monitoring\n• Audit Logging\n• Automated Remediation', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;');
            
            // Add Identity Sources
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                550, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Education deployment with specific focus on campus environments
    const generateEducationDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Education Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on campus environment
            const subtitle = graph.insertVertex(parent, null, 'Campus-Wide NAC Solution with BYOD Support', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                350, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Campus Networks
            const studentNetwork = graph.insertVertex(parent, null, 'Student Network', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            const facultyNetwork = graph.insertVertex(parent, null, 'Faculty Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestNetwork = graph.insertVertex(parent, null, 'Guest Network', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, studentNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, facultyNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, guestNetwork);
            
            // Add Campus Buildings with network devices
            const vendor = currentConfig.vendor || 'cisco';
            
            // Dorm Building
            const dormBuilding = graph.insertVertex(parent, null, 'Dormitory', 
                150, 400, 100, 60, 'shape=image;html=1;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;imageAspect=0;aspect=fixed;image=images/stencils/network/building.svg;');
            
            // Academic Building
            const academicBuilding = graph.insertVertex(parent, null, 'Academic Building', 
                350, 400, 100, 60, 'shape=image;html=1;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;imageAspect=0;aspect=fixed;image=images/stencils/network/building.svg;');
            
            // Library
            const libraryBuilding = graph.insertVertex(parent, null, 'Library', 
                550, 400, 100, 60, 'shape=image;html=1;verticalAlign=top;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;imageAspect=0;aspect=fixed;image=images/stencils/network/building.svg;');
            
            // Connect buildings to networks
            graph.insertEdge(parent, null, '', dormBuilding, studentNetwork);
            graph.insertEdge(parent, null, '', academicBuilding, facultyNetwork);
            graph.insertEdge(parent, null, '', libraryBuilding, guestNetwork);
            
            // Add access points
            const studentAP = graph.insertVertex(parent, null, 'Student AP', 
                150, 500, 60, 60, `${vendor}WirelessAP`);
            
            const facultyAP = graph.insertVertex(parent, null, 'Faculty AP', 
                350, 500, 60, 60, `${vendor}WirelessAP`);
            
            const guestAP = graph.insertVertex(parent, null, 'Guest AP', 
                550, 500, 60, 60, `${vendor}WirelessAP`);
            
            // Connect APs to buildings
            graph.insertEdge(parent, null, '', studentAP, dormBuilding);
            graph.insertEdge(parent, null, '', facultyAP, academicBuilding);
            graph.insertEdge(parent, null, '', guestAP, libraryBuilding);
            
            // Add client devices
            const studentLaptop = graph.insertVertex(parent, null, 'Student Laptop', 
                100, 600, 60, 60, 'deviceByod');
            
            const studentPhone = graph.insertVertex(parent, null, 'Student Phone', 
                200, 600, 60, 60, 'deviceByod');
            
            const facultyLaptop = graph.insertVertex(parent, null, 'Faculty Laptop', 
                350, 600, 60, 60, 'deviceDesktop');
            
            const guestDevice = graph.insertVertex(parent, null, 'Guest Device', 
                550, 600, 60, 60, 'deviceByod');
            
            // Connect devices to APs
            graph.insertEdge(parent, null, '', studentLaptop, studentAP);
            graph.insertEdge(parent, null, '', studentPhone, studentAP);
            graph.insertEdge(parent, null, '', facultyLaptop, facultyAP);
            graph.insertEdge(parent, null, '', guestDevice, guestAP);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const webAuth = graph.insertVertex(parent, null, 'Web Auth', 
                700, 250, 100, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/authentication/webauth.svg;');
            
            graph.insertEdge(parent, null, 'Secure Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Guest Auth', webAuth, portnoxCloud);
            
            // Add features box
            const featuresBox = graph.insertVertex(parent, null, 
                'Education Features:\n• BYOD Onboarding\n• Guest Access Portal\n• Device Profiling\n• Role-Based Access\n• Self-Service Portal', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#d5e8d4;strokeColor=#82b366;align=left;');
            
            // Add Identity Sources
            const googleWorkspace = graph.insertVertex(parent, null, 'Google Workspace', 
                550, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/idp/google/workspace.svg;');
            
            graph.insertEdge(parent, null, 'Identity', googleWorkspace, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Retail deployment with POS and guest WiFi
    const generateRetailDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Retail Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on PCI compliance
            const subtitle = graph.insertVertex(parent, null, 'PCI-DSS Compliant NAC Solution for Retail', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                350, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Retail Networks
            const posNetwork = graph.insertVertex(parent, null, 'POS Network (PCI)', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const corporateNetwork = graph.insertVertex(parent, null, 'Corporate Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestNetwork = graph.insertVertex(parent, null, 'Guest WiFi', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, posNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, corporateNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, guestNetwork);
            
            // Add Retail Store components
            const vendor = currentConfig.vendor || 'cisco';
            
            // Store Layout
            const storeLayout = graph.insertVertex(parent, null, 'Retail Store', 
                350, 400, 300, 200, 'shape=rectangle;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // POS Area
            const posArea = graph.insertVertex(parent, null, 'POS Area', 
                200, 450, 100, 60, 'shape=rectangle;fillColor=#ffe6cc;strokeColor=#d79b00;parent=storeLayout;');
            
            // Back Office
            const backOffice = graph.insertVertex(parent, null, 'Back Office', 
                350, 450, 100, 60, 'shape=rectangle;fillColor=#e1d5e7;strokeColor=#9673a6;parent=storeLayout;');
            
            // Customer Area
            const customerArea = graph.insertVertex(parent, null, 'Customer Area', 
                500, 450, 100, 60, 'shape=rectangle;fillColor=#dae8fc;strokeColor=#6c8ebf;parent=storeLayout;');
            
            // Add network devices
            const posSwitch = graph.insertVertex(parent, null, 'POS Switch', 
                200, 520, 60, 40, `${vendor}Switch;parent=storeLayout;`);
            
            const officeSwitch = graph.insertVertex(parent, null, 'Office Switch', 
                350, 520, 60, 40, `${vendor}Switch;parent=storeLayout;`);
            
            const guestAP = graph.insertVertex(parent, null, 'Guest AP', 
                500, 520, 60, 40, `${vendor}WirelessAP;parent=storeLayout;`);
            
            // Connect devices to areas
            graph.insertEdge(parent, null, '', posSwitch, posArea, 'parent=storeLayout;');
            graph.insertEdge(parent, null, '', officeSwitch, backOffice, 'parent=storeLayout;');
            graph.insertEdge(parent, null, '', guestAP, customerArea, 'parent=storeLayout;');
            
            // Connect networks to areas
            graph.insertEdge(parent, null, '', posNetwork, posSwitch);
            graph.insertEdge(parent, null, '', corporateNetwork, officeSwitch);
            graph.insertEdge(parent, null, '', guestNetwork, guestAP);
            
            // Add endpoint devices
            const posTerminal = graph.insertVertex(parent, null, 'POS Terminal', 
                150, 650, 60, 60, 'deviceIot');
            
            const backOfficePC = graph.insertVertex(parent, null, 'Office PC', 
                350, 650, 60, 60, 'deviceDesktop');
            
            const customerPhone = graph.insertVertex(parent, null, 'Customer Phone', 
                550, 650, 60, 60, 'deviceByod');
            
            // Connect endpoints to network devices
            graph.insertEdge(parent, null, '', posTerminal, posSwitch);
            graph.insertEdge(parent, null, '', backOfficePC, officeSwitch);
            graph.insertEdge(parent, null, '', customerPhone, guestAP);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const webAuth = graph.insertVertex(parent, null, 'Web Auth', 
                700, 250, 100, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/authentication/webauth.svg;');
            
            graph.insertEdge(parent, null, 'Corporate Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'Guest Auth', webAuth, portnoxCloud);
            
            // Add PCI compliance box
            const complianceBox = graph.insertVertex(parent, null, 
                'PCI-DSS Compliance Features:\n• Network Segmentation\n• Device Authentication\n• Continuous Monitoring\n• Restricted Access\n• Guest Isolation', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f8cecc;strokeColor=#b85450;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Manufacturing deployment with OT/IT segmentation
    const generateManufacturingDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Manufacturing Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on OT/IT convergence
            const subtitle = graph.insertVertex(parent, null, 'OT/IT Convergence with Secure NAC', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                350, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Manufacturing Networks
            const itNetwork = graph.insertVertex(parent, null, 'IT Network', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const otNetwork = graph.insertVertex(parent, null, 'OT Network', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const dmzNetwork = graph.insertVertex(parent, null, 'DMZ', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#fff2cc;strokeColor=#d6b656;');
            
            // Connect RADIUS to Networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, itNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, otNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, dmzNetwork);
            
            // Add Plant Floor Layout
            const vendor = currentConfig.vendor || 'cisco';
            
            // Plant Layout
            const plantLayout = graph.insertVertex(parent, null, 'Manufacturing Plant', 
                350, 400, 500, 200, 'shape=rectangle;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // IT Area
            const itArea = graph.insertVertex(parent, null, 'IT & Office Area', 
                200, 450, 100, 60, 'shape=rectangle;fillColor=#d5e8d4;strokeColor=#82b366;parent=plantLayout;');
            
            // Production Floor
            const productionArea = graph.insertVertex(parent, null, 'Production Floor', 
                350, 450, 100, 60, 'shape=rectangle;fillColor=#f8cecc;strokeColor=#b85450;parent=plantLayout;');
            
            // External Access
            const externalArea = graph.insertVertex(parent, null, 'External Access', 
                500, 450, 100, 60, 'shape=rectangle;fillColor=#fff2cc;strokeColor=#d6b656;parent=plantLayout;');
            
            // Add network devices
            const itSwitch = graph.insertVertex(parent, null, 'Office Switch', 
                200, 520, 60, 40, `${vendor}Switch;parent=plantLayout;`);
            
            const industrialSwitch = graph.insertVertex(parent, null, 'Industrial Switch', 
                350, 520, 60, 40, `${vendor}Switch;parent=plantLayout;`);
            
            const dmzFirewall = graph.insertVertex(parent, null, 'DMZ Firewall', 
                500, 520, 60, 40, `${vendor}Firewall;parent=plantLayout;`);
            
            // Connect devices to areas
            graph.insertEdge(parent, null, '', itSwitch, itArea, 'parent=plantLayout;');
            graph.insertEdge(parent, null, '', industrialSwitch, productionArea, 'parent=plantLayout;');
            graph.insertEdge(parent, null, '', dmzFirewall, externalArea, 'parent=plantLayout;');
            
            // Connect networks to areas
            graph.insertEdge(parent, null, '', itNetwork, itSwitch);
            graph.insertEdge(parent, null, '', otNetwork, industrialSwitch);
            graph.insertEdge(parent, null, '', dmzNetwork, dmzFirewall);
            
            // Add endpoint devices
            const officePC = graph.insertVertex(parent, null, 'Office PC', 
                150, 650, 60, 60, 'deviceDesktop');
            
            const plc = graph.insertVertex(parent, null, 'PLC Controller', 
                300, 650, 60, 60, 'deviceIot');
            
            const hmi = graph.insertVertex(parent, null, 'HMI Terminal', 
                400, 650, 60, 60, 'deviceIot');
            
            const vendor = graph.insertVertex(parent, null, 'Vendor Access', 
                550, 650, 60, 60, 'deviceByod');
            
            // Connect endpoints to network devices
            graph.insertEdge(parent, null, '', officePC, itSwitch);
            graph.insertEdge(parent, null, '', plc, industrialSwitch);
            graph.insertEdge(parent, null, '', hmi, industrialSwitch);
            graph.insertEdge(parent, null, '', vendor, dmzFirewall);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'IT Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'OT Auth', mab, portnoxCloud);
            
            // Add security features box
            const featuresBox = graph.insertVertex(parent, null, 
                'OT/IT Security Features:\n• Network Segmentation\n• Protocol Filtering\n• Device Profiling\n• MAC Authentication\n• Vendor Access Control', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#ffe6cc;strokeColor=#d79b00;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Government deployment with high security requirements
    const generateGovernmentDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Government Deployment', 
                350, 20, 300, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on high security
            const subtitle = graph.insertVertex(parent, null, 'High Security NAC Implementation with FIPS Compliance', 
                350, 50, 350, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Security Zones
            const highSecurityZone = graph.insertVertex(parent, null, 'High Security Zone', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const standardZone = graph.insertVertex(parent, null, 'Standard Zone', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const publicZone = graph.insertVertex(parent, null, 'Public Access Zone', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to Zones
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, highSecurityZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, standardZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, standardZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, publicZone);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            
            // Firewalls for zone isolation
            const highSecurityFirewall = graph.insertVertex(parent, null, 'HS Firewall', 
                150, 400, 60, 60, `${vendor}Firewall`);
            
            const standardFirewall = graph.insertVertex(parent, null, 'Standard Firewall', 
                350, 400, 60, 60, `${vendor}Firewall`);
            
            const publicFirewall = graph.insertVertex(parent, null, 'Public Firewall', 
                550, 400, 60, 60, `${vendor}Firewall`);
            
            // Connect firewalls to zones
            graph.insertEdge(parent, null, '', highSecurityFirewall, highSecurityZone);
            graph.insertEdge(parent, null, '', standardFirewall, standardZone);
            graph.insertEdge(parent, null, '', publicFirewall, publicZone);
            
            // Add switches behind firewalls
            const highSecuritySwitch = graph.insertVertex(parent, null, 'HS Switch', 
                150, 500, 60, 60, `${vendor}Switch`);
            
            const standardSwitch = graph.insertVertex(parent, null, 'Standard Switch', 
                350, 500, 60, 60, `${vendor}Switch`);
            
            const publicSwitch = graph.insertVertex(parent, null, 'Public Switch', 
                550, 500, 60, 60, `${vendor}Switch`);
            
            // Connect switches to firewalls
            graph.insertEdge(parent, null, '', highSecuritySwitch, highSecurityFirewall);
            graph.insertEdge(parent, null, '', standardSwitch, standardFirewall);
            graph.insertEdge(parent, null, '', publicSwitch, publicFirewall);
            
            // Add endpoint devices
            const secureWorkstation = graph.insertVertex(parent, null, 'Secure Workstation', 
                150, 600, 60, 60, 'deviceDesktop');
            
            const standardWorkstation = graph.insertVertex(parent, null, 'Standard Workstation', 
                350, 600, 60, 60, 'deviceDesktop');
            
            const publicKiosk = graph.insertVertex(parent, null, 'Public Kiosk', 
                550, 600, 60, 60, 'deviceIot');
            
            // Connect endpoints to switches
            graph.insertEdge(parent, null, '', secureWorkstation, highSecuritySwitch);
            graph.insertEdge(parent, null, '', standardWorkstation, standardSwitch);
            graph.insertEdge(parent, null, '', publicKiosk, publicSwitch);
            
            // Add authentication methods
            const certificates = graph.insertVertex(parent, null, 'Certificate', 
                50, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/certificate.svg;');
            
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const smartCard = graph.insertVertex(parent, null, 'Smart Card', 
                700, 250, 100, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/smart_card.svg;');
            
            graph.insertEdge(parent, null, '', certificates, portnoxCloud);
            graph.insertEdge(parent, null, 'High Security Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'PIV Card Auth', smartCard, portnoxCloud);
            
            // Add compliance features box
            const complianceBox = graph.insertVertex(parent, null, 
                'Government Security Features:\n• FIPS 140-2 Compliance\n• Certificate-Based Auth\n• Smart Card / PIV Support\n• Network Segmentation\n• Continuous Monitoring\n• Comprehensive Auditing', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Financial services deployment
    const generateFinancialDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Financial Services Deployment', 
                350, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add subtitle focusing on compliance
            const subtitle = graph.insertVertex(parent, null, 'PCI-DSS and GLBA Compliant NAC Solution', 
                350, 50, 300, 20, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Servers (Primary and Secondary for redundancy)
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                250, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                450, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Security Zones
            const cardholdersZone = graph.insertVertex(parent, null, 'Cardholder Data Zone', 
                150, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const employeeZone = graph.insertVertex(parent, null, 'Employee Zone', 
                350, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestZone = graph.insertVertex(parent, null, 'Guest Zone', 
                550, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to Zones
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, cardholdersZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, employeeZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, employeeZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, guestZone);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            
            // Financial Institution Layout
            const bankLayout = graph.insertVertex(parent, null, 'Financial Institution', 
                350, 400, 500, 200, 'shape=rectangle;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Payment Processing Area
            const paymentArea = graph.insertVertex(parent, null, 'Payment Processing', 
                200, 450, 100, 60, 'shape=rectangle;fillColor=#f8cecc;strokeColor=#b85450;parent=bankLayout;');
            
            // Employee Office Area
            const officeArea = graph.insertVertex(parent, null, 'Office Area', 
                350, 450, 100, 60, 'shape=rectangle;fillColor=#d5e8d4;strokeColor=#82b366;parent=bankLayout;');
            
            // Lobby/Customer Area
            const lobbyArea = graph.insertVertex(parent, null, 'Lobby/Customer Area', 
                500, 450, 100, 60, 'shape=rectangle;fillColor=#dae8fc;strokeColor=#6c8ebf;parent=bankLayout;');
            
            // Add network devices in each area
            const paymentSwitch = graph.insertVertex(parent, null, 'PCI Switch', 
                200, 520, 60, 40, `${vendor}Switch;parent=bankLayout;`);
            
            const officeSwitch = graph.insertVertex(parent, null, 'Office Switch', 
                350, 520, 60, 40, `${vendor}Switch;parent=bankLayout;`);
            
            const lobbyAP = graph.insertVertex(parent, null, 'Lobby AP', 
                500, 520, 60, 40, `${vendor}WirelessAP;parent=bankLayout;`);
            
            // Connect devices to areas
            graph.insertEdge(parent, null, '', paymentSwitch, paymentArea, 'parent=bankLayout;');
            graph.insertEdge(parent, null, '', officeSwitch, officeArea, 'parent=bankLayout;');
            graph.insertEdge(parent, null, '', lobbyAP, lobbyArea, 'parent=bankLayout;');
            
            // Connect zones to areas
            graph.insertEdge(parent, null, '', cardholdersZone, paymentSwitch);
            graph.insertEdge(parent, null, '', employeeZone, officeSwitch);
            graph.insertEdge(parent, null, '', guestZone, lobbyAP);
            
            // Add endpoint devices
            const paymentTerminal = graph.insertVertex(parent, null, 'Payment Terminal', 
                150, 650, 60, 60, 'deviceIot');
            
            const employeeLaptop = graph.insertVertex(parent, null, 'Employee Laptop', 
                350, 650, 60, 60, 'deviceDesktop');
            
            const customerDevice = graph.insertVertex(parent, null, 'Customer Device', 
                550, 650, 60, 60, 'deviceByod');
            
            // Connect endpoints to switches
            graph.insertEdge(parent, null, '', paymentTerminal, paymentSwitch);
            graph.insertEdge(parent, null, '', employeeLaptop, officeSwitch);
            graph.insertEdge(parent, null, '', customerDevice, lobbyAP);
            
            // Add authentication methods
            const eapTls = graph.insertVertex(parent, null, 'EAP-TLS', 
                700, 150, 100, 60, 'authTLS');
            
            const mab = graph.insertVertex(parent, null, 'MAB', 
                700, 250, 100, 60, 'authMAB');
            
            graph.insertEdge(parent, null, 'Employee Auth', eapTls, portnoxCloud);
            graph.insertEdge(parent, null, 'POS Auth', mab, portnoxCloud);
            
            // Add compliance features box
            const complianceBox = graph.insertVertex(parent, null, 
                'Financial Compliance Features:\n• PCI-DSS Compliance\n• GLBA Data Protection\n• Network Segmentation\n• Multi-factor Authentication\n• Continuous Compliance\n• Detailed Audit Trails', 
                700, 350, 200, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // EAP-TLS Authentication Flow diagram
    const generateEapTlsAuthenticationFlow = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'EAP-TLS Authentication Flow with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add main components - Client, Switch, RADIUS, Portnox Cloud
            const client = graph.insertVertex(parent, null, 'Client\n(Supplicant)', 
                100, 100, 120, 60, 'shape=rectangle;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;fontSize=12;');
            
            const nacSwitch = graph.insertVertex(parent, null, 'Switch\n(Authenticator)', 
                300, 100, 120, 60, 'shape=rectangle;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;fontSize=12;');
            
            const radiusServer = graph.insertVertex(parent, null, 'RADIUS Server', 
                500, 100, 120, 60, 'portnoxRadius;fontSize=12;');
            
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                700, 100, 120, 60, 'portnoxCloud;fontSize=12;');
            
            // Connect components
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add authentication flow steps
            const stepY = 200;
            const stepHeight = 40;
            const stepGap = 10;
            
            // 1. EAPOL-Start
            const step1 = graph.insertVertex(parent, null, '1. EAPOL-Start', 
                400, stepY, 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from client to switch
            const step1Edge = graph.insertEdge(parent, null, '', client, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 2. EAP-Request Identity
            const step2 = graph.insertVertex(parent, null, '2. EAP-Request Identity', 
                400, stepY + (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to client
            const step2Edge = graph.insertEdge(parent, null, '', nacSwitch, client, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 3. EAP-Response Identity
            const step3 = graph.insertVertex(parent, null, '3. EAP-Response Identity', 
                400, stepY + 2 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from client to switch
            const step3Edge = graph.insertEdge(parent, null, '', client, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 4. RADIUS Access-Request (Identity)
            const step4 = graph.insertVertex(parent, null, '4. RADIUS Access-Request (Identity)', 
                400, stepY + 3 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to RADIUS
            const step4Edge = graph.insertEdge(parent, null, '', nacSwitch, radiusServer, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 5. RADIUS Access-Challenge (TLS Start)
            const step5 = graph.insertVertex(parent, null, '5. RADIUS Access-Challenge (TLS Start)', 
                400, stepY + 4 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from RADIUS to switch
            const step5Edge = graph.insertEdge(parent, null, '', radiusServer, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 6. EAP-Request (TLS Start)
            const step6 = graph.insertVertex(parent, null, '6. EAP-Request (TLS Start)', 
                400, stepY + 5 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to client
            const step6Edge = graph.insertEdge(parent, null, '', nacSwitch, client, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 7. EAP-Response (Client Hello)
            const step7 = graph.insertVertex(parent, null, '7. EAP-Response (Client Hello)', 
                400, stepY + 6 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from client to switch
            const step7Edge = graph.insertEdge(parent, null, '', client, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 8. RADIUS Access-Request (Client Hello)
            const step8 = graph.insertVertex(parent, null, '8. RADIUS Access-Request (Client Hello)', 
                400, stepY + 7 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from switch to RADIUS
            const step8Edge = graph.insertEdge(parent, null, '', nacSwitch, radiusServer, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 9. Certificate Validation
            const step9 = graph.insertVertex(parent, null, '9. Certificate Validation', 
                400, stepY + 8 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Draw arrow from RADIUS to Portnox Cloud
            const step9Edge = graph.insertEdge(parent, null, '', radiusServer, portnoxCloud, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 10. RADIUS Access-Accept
            const step10 = graph.insertVertex(parent, null, '10. RADIUS Access-Accept', 
                400, stepY + 9 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Draw arrow from RADIUS to switch
            const step10Edge = graph.insertEdge(parent, null, '', radiusServer, nacSwitch, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 11. EAP-Success
            const step11 = graph.insertVertex(parent, null, '11. EAP-Success', 
                400, stepY + 10 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Draw arrow from switch to client
            const step11Edge = graph.insertEdge(parent, null, '', nacSwitch, client, 
                'startArrow=none;endArrow=classic;dashed=0;html=1;strokeWidth=1.5;');
            
            // 12. Port Authorized
            const step12 = graph.insertVertex(parent, null, '12. Port Authorized - Full Network Access', 
                400, stepY + 11 * (stepHeight + stepGap), 200, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1');
            
            // Add authentication states on the right
            const uncontrolledState = graph.insertVertex(parent, null, 'Port Uncontrolled State', 
                850, 250, 150, 200, 'fillColor=#f8cecc;strokeColor=#b85450;fontSize=11;');
            
            const controlledState = graph.insertVertex(parent, null, 'Port Controlled State', 
                850, 500, 150, 120, 'fillColor=#d5e8d4;strokeColor=#82b366;fontSize=11;');
            
            // Add notes about certificates
            const certificateNote = graph.insertVertex(parent, null, 
                'Certificate Validation:\n- Client presents certificate\n- RADIUS validates with Portnox\n- Portnox checks certificate\n  against trusted CAs\n- Validates revocation status', 
                850, 650, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;fontSize=10;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // BYOD Onboarding Flow
    const generateByodOnboardingFlow = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'BYOD Onboarding Flow with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add main components
            const userDevice = graph.insertVertex(parent, null, 'User Device', 
                100, 100, 100, 60, 'deviceByod');
            
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                350, 100, 150, 60, 'portnoxCloud');
            
            const captivePortal = graph.insertVertex(parent, null, 'Captive Portal', 
                600, 100, 150, 60, 'shape=rectangle;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            const ca = graph.insertVertex(parent, null, 'Certificate Authority', 
                600, 200, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/ca.svg;');
            
            // Connect main components
            graph.insertEdge(parent, null, '', portnoxCloud, captivePortal);
            graph.insertEdge(parent, null, '', portnoxCloud, ca);
            
            // Add network zones on the left
            const guestVLAN = graph.insertVertex(parent, null, 'Guest VLAN', 
                100, 250, 120, 80, 'fillColor=#fff2cc;strokeColor=#d6b656;');
            
            const corporateVLAN = graph.insertVertex(parent, null, 'Corporate VLAN', 
                100, 450, 120, 80, 'fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Add onboarding flow steps
            const stepY = 250;
            const stepHeight = 40;
            const stepGap = 15;
            
            // 1. Connect to network
            const step1 = graph.insertVertex(parent, null, '1. Device connects to network', 
                400, stepY, 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from user device to step 1
            const step1Edge = graph.insertEdge(parent, null, '', userDevice, step1);
            
            // 2. Redirect to portal
            const step2 = graph.insertVertex(parent, null, '2. Redirect to captive portal', 
                400, stepY + (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 1 to step 2
            const step2Edge = graph.insertEdge(parent, null, '', step1, step2);
            
            // 3. User authentication
            const step3 = graph.insertVertex(parent, null, '3. User logs in with corporate credentials', 
                400, stepY + 2 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 2 to step 3
            const step3Edge = graph.insertEdge(parent, null, '', step2, step3);
            
            // 4. Device assessment
            const step4 = graph.insertVertex(parent, null, '4. Portnox performs device assessment', 
                400, stepY + 3 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 3 to step 4
            const step4Edge = graph.insertEdge(parent, null, '', step3, step4);
            
            // 5. Certificate generation
            const step5 = graph.insertVertex(parent, null, '5. Certificate generation for device', 
                400, stepY + 4 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Draw arrow from step 4 to step 5
            const step5Edge = graph.insertEdge(parent, null, '', step4, step5);
            
            // Connect step 5 to CA
            const step5ToCA = graph.insertEdge(parent, null, 'Request cert', step5, ca);
            
            // 6. Profile installation
            const step6 = graph.insertVertex(parent, null, '6. User installs configuration profile', 
                400, stepY + 5 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Draw arrow from step 5 to step 6
            const step6Edge = graph.insertEdge(parent, null, '', step5, step6);
            
            // 7. Device reauthenticates
            const step7 = graph.insertVertex(parent, null, '7. Device reconnects with EAP-TLS', 
                400, stepY + 6 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            // Draw arrow from step 6 to step 7
            const step7Edge = graph.insertEdge(parent, null, '', step6, step7);
            
            // 8. Full access granted
            const step8 = graph.insertVertex(parent, null, '8. Full corporate access granted', 
                400, stepY + 7 * (stepHeight + stepGap), 250, stepHeight, 'shape=process;whiteSpace=wrap;fillColor=#d5e8d4;strokeColor=#82b366;fontStyle=1');
            
            // Draw arrow from step 7 to step 8
            const step8Edge = graph.insertEdge(parent, null, '', step7, step8);
            
            // Connect flow to VLANs
            const flowToGuestVLAN = graph.insertEdge(parent, null, 'Initial Connection', step1, guestVLAN, 'dashed=1;');
            const flowToCorporateVLAN = graph.insertEdge(parent, null, 'After Onboarding', step8, corporateVLAN, 'dashed=1;');
            
            // Add notes about onboarding
            const onboardingNote = graph.insertVertex(parent, null, 
                'BYOD Onboarding Benefits:\n- Secure device authentication\n- User-friendly self-service\n- Certificate-based security\n- Automatic VLAN assignment\n- Compliance validation', 
                700, 400, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Dynamic VLAN Assignment diagram
    const generateDynamicVlanAssignment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Dynamic VLAN Assignment with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add network components
            const vendor = currentConfig.vendor || 'cisco';
            const networkSwitch = graph.insertVertex(parent, null, 'Network Switch', 
                400, 300, 60, 60, `${vendor}Switch`);
            
            // Connect RADIUS to switch
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, networkSwitch);
            
            // Add different device types
            const devices = [
                { name: 'Corporate Laptop', image: 'deviceDesktop', x: 200, y: 400, 
                  vlan: 'VLAN 10 - Corporate', vlanColor: '#d5e8d4', vlanStroke: '#82b366', attributes: 'User Group, Device Type' },
                { name: 'BYOD Device', image: 'deviceByod', x: 400, y: 400, 
                  vlan: 'VLAN 20 - BYOD', vlanColor: '#dae8fc', vlanStroke: '#6c8ebf', attributes: 'User Group, Device Posture' },
                { name: 'IoT Device', image: 'deviceIot', x: 600, y: 400, 
                  vlan: 'VLAN 30 - IoT', vlanColor: '#ffe6cc', vlanStroke: '#d79b00', attributes: 'Device Type, MAC OUI' }
            ];
            
            // Add devices and VLANs
            devices.forEach(device => {
                // Add device
                const deviceVertex = graph.insertVertex(parent, null, device.name, 
                    device.x, device.y, 60, 60, device.image);
                
                // Connect device to switch
                graph.insertEdge(parent, null, '', deviceVertex, networkSwitch);
                
                // Add VLAN for the device
                const vlanVertex = graph.insertVertex(parent, null, device.vlan, 
                    device.x - 50, device.y + 100, 160, 40, `shape=rectangle;rounded=1;fillColor=${device.vlanColor};strokeColor=${device.vlanStroke};`);
                
                // Connect device to VLAN
                graph.insertEdge(parent, null, device.attributes, deviceVertex, vlanVertex, 'dashed=1;endArrow=classic;');
            });
            
            // Add RADIUS attributes box
            const attributesBox = graph.insertVertex(parent, null, 
                'RADIUS Attributes:\n- Tunnel-Type (13)\n- Tunnel-Medium-Type (6)\n- Tunnel-Private-Group-ID (VLAN)', 
                600, 180, 200, 60, 'fillColor=#ffe6cc;strokeColor=#d79b00;align=left;');
            
            // Connect RADIUS to attributes
            graph.insertEdge(parent, null, '', radiusServer, attributesBox, 'dashed=1;');
            
            // Add detailed explanation
            const explanationBox = graph.insertVertex(parent, null, 
                'Dynamic VLAN Assignment:\n\n1. Device authenticates to the network\n2. Portnox evaluates device & user attributes\n3. Portnox determines appropriate VLAN\n4. RADIUS returns VLAN attributes\n5. Switch places device in assigned VLAN', 
                150, 180, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f5f5f5;strokeColor=#666666;align=left;');
            
            // Add benefits/use cases box
            const benefitsBox = graph.insertVertex(parent, null, 
                'Use Cases:\n• Device-based segmentation\n• User role-based access\n• Compliance-based access\n• Guest isolation\n• IoT segmentation\n• Dynamic security isolation', 
                700, 350, 160, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Multi-vendor deployment diagram
    const generateMultiVendorDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Multi-Vendor Deployment with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add network zones
            const hqNetwork = graph.insertVertex(parent, null, 'Headquarters', 
                200, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const branchNetwork = graph.insertVertex(parent, null, 'Branch Office', 
                400, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            const datacenterNetwork = graph.insertVertex(parent, null, 'Data Center', 
                600, 300, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Connect RADIUS to Network zones
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, hqNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, branchNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, datacenterNetwork);
            
            // Add different vendor equipment in each zone
            
            // Headquarters - Cisco equipment
            const ciscoSwitch = graph.insertVertex(parent, null, 'Cisco Switch', 
                150, 400, 60, 60, 'ciscoSwitch');
            
            const ciscoWLC = graph.insertVertex(parent, null, 'Cisco WLC', 
                250, 400, 60, 60, 'ciscoWirelessAP');
            
            // Connect Cisco equipment to HQ
            graph.insertEdge(parent, null, '', ciscoSwitch, hqNetwork);
            graph.insertEdge(parent, null, '', ciscoWLC, hqNetwork);
            
            // Branch - Aruba equipment
            const arubaSwitch = graph.insertVertex(parent, null, 'Aruba Switch', 
                350, 400, 60, 60, 'arubaSwitch');
            
            const arubaAP = graph.insertVertex(parent, null, 'Aruba AP', 
                450, 400, 60, 60, 'arubaWirelessAP');
            
            // Connect Aruba equipment to Branch
            graph.insertEdge(parent, null, '', arubaSwitch, branchNetwork);
            graph.insertEdge(parent, null, '', arubaAP, branchNetwork);
            
            // Data Center - Juniper equipment
            const juniperSwitch = graph.insertVertex(parent, null, 'Juniper Switch', 
                550, 400, 60, 60, 'juniperSwitch');
            
            const paloAltoFW = graph.insertVertex(parent, null, 'Palo Alto FW', 
                650, 400, 60, 60, 'paloaltoFirewall');
            
            // Connect Juniper equipment to Data Center
            graph.insertEdge(parent, null, '', juniperSwitch, datacenterNetwork);
            graph.insertEdge(parent, null, '', paloAltoFW, datacenterNetwork);
            
            // Add endpoints
            const ciscoPhone = graph.insertVertex(parent, null, 'IP Phone', 
                150, 500, 60, 60, 'devicePhone');
            
            const workstation = graph.insertVertex(parent, null, 'Workstation', 
                250, 500, 60, 60, 'deviceDesktop');
            
            const laptop = graph.insertVertex(parent, null, 'Laptop', 
                350, 500, 60, 60, 'deviceByod');
            
            const mobileDevice = graph.insertVertex(parent, null, 'Mobile Device', 
                450, 500, 60, 60, 'deviceByod');
            
            const server = graph.insertVertex(parent, null, 'Server', 
                550, 500, 60, 60, 'deviceServer');
            
            const storageArray = graph.insertVertex(parent, null, 'Storage Array', 
                650, 500, 60, 60, 'deviceIot');
            
            // Connect endpoints to switches/APs
            graph.insertEdge(parent, null, '', ciscoPhone, ciscoSwitch);
            graph.insertEdge(parent, null, '', workstation, ciscoSwitch);
            graph.insertEdge(parent, null, '', laptop, ciscoWLC);
            graph.insertEdge(parent, null, '', mobileDevice, arubaAP);
            graph.insertEdge(parent, null, '', server, juniperSwitch);
            graph.insertEdge(parent, null, '', storageArray, juniperSwitch);
            
            // Add multi-vendor support information
            const vendorSupportBox = graph.insertVertex(parent, null, 
                'Multi-Vendor Support:\n• Vendor-specific attributes (VSAs)\n• Standardized RADIUS attributes\n• Customizable authentication policies\n• Unified reporting & management\n• Consistent user experience', 
                700, 250, 200, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f5f5f5;strokeColor=#666666;align=left;');
            
            // Add vendor logos/icons
            const vendorLogos = graph.insertVertex(parent, null, '', 
                700, 100, 140, 100, 'shape=rectangle;fillColor=none;strokeColor=none;align=center;', 'container=1');
            
            const ciscoLogo = graph.insertVertex(vendorLogos, null, 'Cisco', 
                700, 100, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/cisco/logo.svg;');
            
            const arubaLogo = graph.insertVertex(vendorLogos, null, 'Aruba', 
                750, 100, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/aruba/logo.svg;');
            
            const juniperLogo = graph.insertVertex(vendorLogos, null, 'Juniper', 
                800, 100, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/juniper/logo.svg;');
            
            const extremeLogo = graph.insertVertex(vendorLogos, null, 'Extreme', 
                700, 160, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/extreme/logo.svg;');
            
            const paloaltoLogo = graph.insertVertex(vendorLogos, null, 'Palo Alto', 
                750, 160, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/paloalto/logo.svg;');
            
            const fortinetLogo = graph.insertVertex(vendorLogos, null, 'Fortinet', 
                800, 160, 40, 40, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/vendors/fortinet/logo.svg;');
            
            // Connect logos to Portnox
            graph.insertEdge(parent, null, '', portnoxCloud, vendorLogos, 'dashed=1;endArrow=none;startArrow=none;');
            
            // Add Vendor-Agnostic NAC title
            const nacTitle = graph.insertVertex(parent, null, 'Vendor-Agnostic NAC', 
                770, 60, 140, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontStyle=1');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // High security deployment diagram
    const generateHighSecurityDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'High Security Portnox Cloud Deployment', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add Azure AD / Identity integration
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                600, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            // Connect Portnox to Azure AD
            graph.insertEdge(parent, null, 'Identity', azureAD, portnoxCloud);
            
            // Add MFA service
            const mfaService = graph.insertVertex(parent, null, 'MFA Service', 
                200, 80, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/security/mfa.svg;');
            
            // Connect Portnox to MFA
            graph.insertEdge(parent, null, '2FA', mfaService, portnoxCloud);
            
            // Add RADIUS Servers
            const radiusPrimary = graph.insertVertex(parent, null, 'Primary RADIUS', 
                300, 180, 150, 60, 'portnoxRadius');
            
            const radiusSecondary = graph.insertVertex(parent, null, 'Secondary RADIUS', 
                500, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox to RADIUS servers
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusPrimary);
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusSecondary);
            
            // Add Certificate Authority
            const ca = graph.insertVertex(parent, null, 'Certificate Authority', 
                700, 180, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/certificates/ca.svg;');
            
            // Connect CA to Portnox
            graph.insertEdge(parent, null, 'Certificate Management', ca, portnoxCloud, 'dashed=1;');
            
            // Add security zones
            const restrictedZone = graph.insertVertex(parent, null, 'Restricted Zone', 
                200, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            const secureZone = graph.insertVertex(parent, null, 'Secure Zone', 
                400, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const standardZone = graph.insertVertex(parent, null, 'Standard Zone', 
                600, 300, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect RADIUS to zones
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, restrictedZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusPrimary, secureZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, secureZone);
            graph.insertEdge(parent, null, 'RADIUS', radiusSecondary, standardZone);
            
            // Add network components
            const vendor = currentConfig.vendor || 'cisco';
            
            // Add firewalls in each zone
            const restrictedFirewall = graph.insertVertex(parent, null, 'Restricted Firewall', 
                200, 400, 60, 60, `${vendor}Firewall`);
            
            const secureFirewall = graph.insertVertex(parent, null, 'Secure Firewall', 
                400, 400, 60, 60, `${vendor}Firewall`);
            
            const standardFirewall = graph.insertVertex(parent, null, 'Standard Firewall', 
                600, 400, 60, 60, `${vendor}Firewall`);
            
            // Connect firewalls to zones
            graph.insertEdge(parent, null, '', restrictedFirewall, restrictedZone);
            graph.insertEdge(parent, null, '', secureFirewall, secureZone);
            graph.insertEdge(parent, null, '', standardFirewall, standardZone);
            
            // Add switches behind firewalls
            const restrictedSwitch = graph.insertVertex(parent, null, 'Restricted Switch', 
                200, 500, 60, 60, `${vendor}Switch`);
            
            const secureSwitch = graph.insertVertex(parent, null, 'Secure Switch', 
                400, 500, 60, 60, `${vendor}Switch`);
            
            const standardSwitch = graph.insertVertex(parent, null, 'Standard Switch', 
                600, 500, 60, 60, `${vendor}Switch`);
            
            // Connect switches to firewalls
            graph.insertEdge(parent, null, '', restrictedSwitch, restrictedFirewall);
            graph.insertEdge(parent, null, '', secureSwitch, secureFirewall);
            graph.insertEdge(parent, null, '', standardSwitch, standardFirewall);
            
            // Add endpoints
            const restrictedWorkstation = graph.insertVertex(parent, null, 'High Security\nWorkstation', 
                200, 600, 60, 60, 'deviceDesktop');
            
            const secureWorkstation = graph.insertVertex(parent, null, 'Secure Workstation', 
                400, 600, 60, 60, 'deviceDesktop');
            
            const standardWorkstation = graph.insertVertex(parent, null, 'Standard Device', 
                600, 600, 60, 60, 'deviceByod');
            
            // Connect endpoints to switches
            graph.insertEdge(parent, null, '', restrictedWorkstation, restrictedSwitch);
            graph.insertEdge(parent, null, '', secureWorkstation, secureSwitch);
            graph.insertEdge(parent, null, '', standardWorkstation, standardSwitch);
            
            // Add authentication methods by zone
            // High Security
            const highSecAuth = graph.insertVertex(parent, null, 
                'Restricted Zone Security:\n• EAP-TLS with hardware tokens\n• Smart Card / PIV cards\n• Posture assessment\n• Continuous monitoring', 
                50, 400, 130, 80, 'shape=document;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#f8cecc;strokeColor=#b85450;align=left;fontSize=10;');
            
            // Secure
            const secureAuth = graph.insertVertex(parent, null, 
                'Secure Zone Security:\n• EAP-TLS with certificates\n• MFA when required\n• Device compliance\n• Remediation capabilities', 
                800, 400, 130, 80, 'shape=document;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#d5e8d4;strokeColor=#82b366;align=left;fontSize=10;');
            
            // Standard
            const standardAuth = graph.insertVertex(parent, null, 
                'Standard Zone Security:\n• Multiple auth methods\n• Web authentication\n• BYOD onboarding\n• Basic posture checks', 
                800, 500, 130, 80, 'shape=document;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#dae8fc;strokeColor=#6c8ebf;align=left;fontSize=10;');
            
            // Add security components box
            const securityBox = graph.insertVertex(parent, null, 
                'Security Components:\n• Certificate-based authentication\n• Multi-factor authentication\n• Zero Trust architecture\n• Micro-segmentation\n• Continuous compliance monitoring\n• Automated threat response', 
                50, 500, 130, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;fontSize=10;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Portnox Cloud integration with other cloud services
    const generateCloudIntegration = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Portnox Cloud Integration with Cloud Services', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud in center
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 300, 150, 60, 'portnoxCloud');
            
            // Add Identity Providers (top)
            const azureAD = graph.insertVertex(parent, null, 'Azure AD', 
                300, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            const googleWorkspace = graph.insertVertex(parent, null, 'Google Workspace', 
                400, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/idp/google/workspace.svg;');
            
            const okta = graph.insertVertex(parent, null, 'Okta', 
                500, 150, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/idp/okta/okta.svg;');
            
            // Connect Identity Providers to Portnox
            graph.insertEdge(parent, null, 'SAML/OIDC', azureAD, portnoxCloud);
            graph.insertEdge(parent, null, 'SAML/OIDC', googleWorkspace, portnoxCloud);
            graph.insertEdge(parent, null, 'SAML/OIDC', okta, portnoxCloud);
            
            // Add device management (right)
            const intune = graph.insertVertex(parent, null, 'Microsoft Intune', 
                600, 250, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/mdm/intune/intune.svg;');
            
            const jamf = graph.insertVertex(parent, null, 'Jamf', 
                600, 350, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/mdm/jamf/jamf.svg;');
            
            // Connect MDM solutions to Portnox
            graph.insertEdge(parent, null, 'Device Compliance', intune, portnoxCloud);
            graph.insertEdge(parent, null, 'Device Compliance', jamf, portnoxCloud);
            
            // Add SIEM/Security tools (bottom)
            const splunk = graph.insertVertex(parent, null, 'Splunk', 
                300, 450, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/security/splunk.svg;');
            
            const sentinel = graph.insertVertex(parent, null, 'MS Sentinel', 
                500, 450, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/security/sentinel.svg;');
            
            // Connect SIEM to Portnox
            graph.insertEdge(parent, null, 'Logs & Events', portnoxCloud, splunk);
            graph.insertEdge(parent, null, 'Security Events', portnoxCloud, sentinel);
            
            // Add ITSM/Ticketing (left)
            const serviceNow = graph.insertVertex(parent, null, 'ServiceNow', 
                200, 250, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/services/servicenow.svg;');
            
            const jira = graph.insertVertex(parent, null, 'Jira', 
                200, 350, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/services/jira.svg;');
            
            // Connect ITSM to Portnox
            graph.insertEdge(parent, null, 'Ticketing', serviceNow, portnoxCloud);
            graph.insertEdge(parent, null, 'Issue Tracking', jira, portnoxCloud);
            
            // Add on-premises components
            const radius = graph.insertVertex(parent, null, 'RADIUS', 
                400, 550, 150, 60, 'portnoxRadius');
            
            // Connect Portnox to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radius);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            const switch1 = graph.insertVertex(parent, null, 'Switch', 
                300, 650, 60, 60, `${vendor}Switch`);
            
            const wireless = graph.insertVertex(parent, null, 'Wireless', 
                500, 650, 60, 60, `${vendor}WirelessAP`);
            
            // Connect network components to RADIUS
            graph.insertEdge(parent, null, 'RADIUS', radius, switch1);
            graph.insertEdge(parent, null, 'RADIUS', radius, wireless);
            
            // Add Cloud Integration benefits panel
            const benefitsBox = graph.insertVertex(parent, null, 
                'Cloud Integration Benefits:\n• Single sign-on (SSO)\n• Automated user provisioning\n• Device compliance checking\n• Automated incident response\n• Centralized reporting\n• API-driven workflows', 
                700, 300, 170, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Add Integration Types panel
            const integrationTypes = graph.insertVertex(parent, null, 
                'Integration Types:\n• REST APIs\n• SAML/OIDC\n• SCIM\n• Webhooks\n• RADIUS\n• Syslog/CEF', 
                100, 150, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#dae8fc;strokeColor=#6c8ebf;align=left;');
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Multi-site deployment diagram
    const generateMultiSiteDeployment = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Multi-Site Portnox Cloud Deployment', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 100, 150, 60, 'portnoxCloud');
            
            // Add Identity provider
            const identityProvider = graph.insertVertex(parent, null, 'Identity Provider', 
                600, 100, 60, 60, 'shape=image;verticalLabelPosition=bottom;labelBackgroundColor=#ffffff;verticalAlign=top;aspect=fixed;imageAspect=0;image=images/stencils/cloud/azure/active_directory.svg;');
            
            // Connect Identity Provider to Portnox
            graph.insertEdge(parent, null, 'Identity', identityProvider, portnoxCloud);
            
            // Add Internet cloud
            const internet = graph.insertVertex(parent, null, 'Internet', 
                400, 200, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect Portnox to Internet
            graph.insertEdge(parent, null, '', portnoxCloud, internet);
            
            // Add sites with different layouts
            
            // Headquarters container
            const hqSite = graph.insertVertex(parent, null, 'Headquarters', 
                150, 300, 200, 250, 'shape=rectangle;fillColor=#dae8fc;strokeColor=#6c8ebf;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // HQ RADIUS server
            const hqRadius = graph.insertVertex(parent, null, 'Primary RADIUS', 
                150, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // HQ Backup RADIUS
            const hqRadiusBackup = graph.insertVertex(parent, null, 'Backup RADIUS', 
                250, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // HQ Network devices
            const vendor = currentConfig.vendor || 'cisco';
            const hqCore = graph.insertVertex(parent, null, 'Core Switch', 
                200, 400, 50, 50, `${vendor}Switch;fontSize=10;`);
            
            const hqAccess = graph.insertVertex(parent, null, 'Access', 
                150, 470, 40, 40, `${vendor}Switch;fontSize=9;`);
            
            const hqWireless = graph.insertVertex(parent, null, 'WiFi', 
                250, 470, 40, 40, `${vendor}WirelessAP;fontSize=9;`);
            
            // Connect HQ components
            graph.insertEdge(parent, null, '', internet, hqRadius);
            graph.insertEdge(parent, null, '', internet, hqRadiusBackup);
            graph.insertEdge(parent, null, '', hqRadius, hqCore);
            graph.insertEdge(parent, null, '', hqRadiusBackup, hqCore);
            graph.insertEdge(parent, null, '', hqCore, hqAccess);
            graph.insertEdge(parent, null, '', hqCore, hqWireless);
            
            // Branch Office 1 container
            const branch1Site = graph.insertVertex(parent, null, 'Branch Office 1', 
                400, 300, 150, 200, 'shape=rectangle;fillColor=#d5e8d4;strokeColor=#82b366;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // Branch 1 RADIUS server
            const branch1Radius = graph.insertVertex(parent, null, 'RADIUS', 
                425, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // Branch 1 Network devices
            const branch1Switch = graph.insertVertex(parent, null, 'Switch', 
                425, 400, 50, 50, `${vendor}Switch;fontSize=10;`);
            
            const branch1Wireless = graph.insertVertex(parent, null, 'WiFi', 
                475, 400, 40, 40, `${vendor}WirelessAP;fontSize=9;`);
            
            // Connect Branch 1 components
            graph.insertEdge(parent, null, '', internet, branch1Radius);
            graph.insertEdge(parent, null, '', branch1Radius, branch1Switch);
            graph.insertEdge(parent, null, '', branch1Radius, branch1Wireless);
            
            // Branch Office 2 container
            const branch2Site = graph.insertVertex(parent, null, 'Branch Office 2', 
                600, 300, 150, 200, 'shape=rectangle;fillColor=#ffe6cc;strokeColor=#d79b00;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // Branch 2 RADIUS server
            const branch2Radius = graph.insertVertex(parent, null, 'RADIUS', 
                625, 330, 100, 40, 'portnoxRadius;fontSize=10;');
            
            // Branch 2 Network devices - different vendor
            const branch2Switch = graph.insertVertex(parent, null, 'Switch', 
                625, 400, 50, 50, 'arubaSwitch;fontSize=10;');
            
            const branch2Wireless = graph.insertVertex(parent, null, 'WiFi', 
                675, 400, 40, 40, 'arubaWirelessAP;fontSize=9;');
            
            // Connect Branch 2 components
            graph.insertEdge(parent, null, '', internet, branch2Radius);
            graph.insertEdge(parent, null, '', branch2Radius, branch2Switch);
            graph.insertEdge(parent, null, '', branch2Radius, branch2Wireless);
            
            // Remote Site container
            const remoteSite = graph.insertVertex(parent, null, 'Remote Site / Work From Home', 
                400, 550, 150, 150, 'shape=rectangle;fillColor=#e1d5e7;strokeColor=#9673a6;verticalAlign=top;fontStyle=1;fontSize=12;');
            
            // Remote devices 
            const remoteRouter = graph.insertVertex(parent, null, 'Router', 
                425, 600, 40, 40, `${vendor}Router;fontSize=9;`);
            
            const remoteLaptop = graph.insertVertex(parent, null, 'Laptop', 
                475, 600, 40, 40, 'deviceByod;fontSize=9;');
            
            // Connect Remote components
            graph.insertEdge(parent, null, '', internet, remoteRouter);
            graph.insertEdge(parent, null, '', remoteRouter, remoteLaptop);
            
            // Add multi-site management box
            const managementBox = graph.insertVertex(parent, null, 
                'Multi-Site Management Features:\n• Centralized policy management\n• Global visibility and reporting\n• Site-specific policies\n• Redundant RADIUS servers\n• Automatic failover\n• VPN integration\n• Offline authentication', 
                800, 200, 170, 140, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#f5f5f5;strokeColor=#666666;align=left;fontSize=10;');
            
            // Add Global Policy box
            const policyBox = graph.insertVertex(parent, null, 
                'Global Policy Engine', 
                200, 100, 120, 40, 'shape=cylinder;whiteSpace=wrap;html=1;boundedLbl=1;fillColor=#f8cecc;strokeColor=#b85450;');
            
            // Connect Policy to Portnox
            graph.insertEdge(parent, null, '', policyBox, portnoxCloud);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // IoT Segmentation diagram
    const generateIoTSegmentation = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'IoT Segmentation with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Core Network
            const coreNetwork = graph.insertVertex(parent, null, 'Core Network', 
                400, 280, 120, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect RADIUS to Core Network
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, coreNetwork);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            const coreSwitch = graph.insertVertex(parent, null, 'Core Switch', 
                400, 380, 60, 60, `${vendor}Switch`);
            
            // Connect core switch to core network
            graph.insertEdge(parent, null, '', coreSwitch, coreNetwork);
            
            // Add IoT segments/VLANs
            const segments = [
                { name: 'Medical Devices', color: '#f8cecc', stroke: '#b85450', x: 200, devices: ['Heart Monitor', 'Infusion Pump', 'X-Ray Machine'] },
                { name: 'Building Systems', color: '#d5e8d4', stroke: '#82b366', x: 400, devices: ['HVAC Controller', 'Access Control', 'Elevator System'] },
                { name: 'Video & Voice', color: '#dae8fc', stroke: '#6c8ebf', x: 600, devices: ['IP Camera', 'Video Recorder', 'IP Phone'] }
            ];
            
            // Add each segment with devices
            segments.forEach(segment => {
                // Add segment VLAN
                const segmentVLAN = graph.insertVertex(parent, null, `${segment.name} VLAN`, 
                    segment.x, 450, 120, 40, `fillColor=${segment.color};strokeColor=${segment.stroke};rounded=1;`);
                
                // Add segment switch
                const segmentSwitch = graph.insertVertex(parent, null, `${segment.name} Switch`, 
                    segment.x, 520, 60, 60, `${vendor}Switch`);
                
                // Connect segment switch to VLAN and core switch
                graph.insertEdge(parent, null, '', segmentVLAN, segmentSwitch);
                graph.insertEdge(parent, null, '', coreSwitch, segmentSwitch);
                
                // Add IoT devices for this segment
                let deviceY = 600;
                segment.devices.forEach((device, i) => {
                    const iotDevice = graph.insertVertex(parent, null, device, 
                        segment.x - 40 + i * 40, deviceY, 60, 60, 'deviceIot');
                    
                    // Connect device to segment switch
                    graph.insertEdge(parent, null, '', iotDevice, segmentSwitch);
                });
            });
            
            // Add IoT device profiling box
            const profilingBox = graph.insertVertex(parent, null, 
                'IoT Device Profiling:\n• MAC OUI identification\n• Behavioral analysis\n• Protocol analysis\n• Classification rules\n• Automated categorization', 
                200, 180, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#ffe6cc;strokeColor=#d79b00;align=left;');
            
            // Add security controls box
            const securityBox = graph.insertVertex(parent, null, 
                'IoT Segmentation Security:\n• MAC Authentication Bypass (MAB)\n• Dynamic VLAN assignment\n• Micro-segmentation\n• Traffic filtering\n• Behavioral anomaly detection', 
                600, 180, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#e1d5e7;strokeColor=#9673a6;align=left;');
            
            // Add Segmentation Benefits box
            const benefitsBox = graph.insertVertex(parent, null, 
                'Segmentation Benefits:\n• Reduces attack surface\n• Limits lateral movement\n• Protects vulnerable devices\n• Ensures regulatory compliance\n• Simplifies device management', 
                800, 350, 150, 100, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#d5e8d4;strokeColor=#82b366;align=left;');
            
            // Add firewall
            const firewall = graph.insertVertex(parent, null, 'Firewall', 
                800, 480, 60, 60, `${vendor}Firewall`);
            
            // Add connections between segments through firewall
            segments.forEach(segment => {
                const vlan = graph.getModel().getCell(3 + segments.indexOf(segment) * 3 + 1); // Get the VLAN cell
                if (vlan) {
                    graph.insertEdge(parent, null, 'Controlled\nTraffic', vlan, firewall, 'dashed=1;dashPattern=1 4;');
                }
            });
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Guest Access diagram
    const generateGuestAccess = function() {
        const parent = graph.getDefaultParent();
        
        graph.getModel().beginUpdate();
        try {
            // Add title
            const title = graph.insertVertex(parent, null, 'Guest Access with Portnox Cloud', 
                400, 20, 350, 30, 'text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=16;fontStyle=1');
            
            // Add Portnox Cloud
            const portnoxCloud = graph.insertVertex(parent, null, 'Portnox Cloud', 
                400, 80, 150, 60, 'portnoxCloud');
            
            // Add Captive Portal
            const captivePortal = graph.insertVertex(parent, null, 'Guest Portal', 
                600, 80, 150, 60, 'shape=rectangle;rounded=1;fillColor=#dae8fc;strokeColor=#6c8ebf;');
            
            // Connect Portnox to Captive Portal
            graph.insertEdge(parent, null, 'Hosts', portnoxCloud, captivePortal);
            
            // Add RADIUS Server
            const radiusServer = graph.insertVertex(parent, null, 'Portnox RADIUS', 
                400, 180, 150, 60, 'portnoxRadius');
            
            // Connect Portnox Cloud to RADIUS
            graph.insertEdge(parent, null, 'API', portnoxCloud, radiusServer);
            
            // Add Corporate and Guest Networks
            const corpNetwork = graph.insertVertex(parent, null, 'Corporate Network', 
                250, 280, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#d5e8d4;strokeColor=#82b366;');
            
            const guestNetwork = graph.insertVertex(parent, null, 'Guest Network', 
                550, 280, 150, 60, 'shape=cloud;whiteSpace=wrap;rounded=1;fillColor=#ffe6cc;strokeColor=#d79b00;');
            
            // Connect RADIUS to networks
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, corpNetwork);
            graph.insertEdge(parent, null, 'RADIUS', radiusServer, guestNetwork);
            
            // Add network infrastructure
            const vendor = currentConfig.vendor || 'cisco';
            
            // Corporate infrastructure
            const corpSwitch = graph.insertVertex(parent, null, 'Corporate Switch', 
                200, 380, 60, 60, `${vendor}Switch`);
            
            const corpAP = graph.insertVertex(parent, null, 'Corporate AP', 
                300, 380, 60, 60, `${vendor}WirelessAP`);
            
            // Guest infrastructure
            const guestSwitch = graph.insertVertex(parent, null, 'Guest Switch', 
                500, 380, 60, 60, `${vendor}Switch`);
            
            const guestAP = graph.insertVertex(parent, null, 'Guest AP', 
                600, 380, 60, 60, `${vendor}WirelessAP`);
            
            // Connect network devices to networks
            graph.insertEdge(parent, null, '', corpSwitch, corpNetwork);
            graph.insertEdge(parent, null, '', corpAP, corpNetwork);
            graph.insertEdge(parent, null, '', guestSwitch, guestNetwork);
            graph.insertEdge(parent, null, '', guestAP, guestNetwork);
            
            // Add firewall between networks
            const firewall = graph.insertVertex(parent, null, 'Firewall', 
                400, 330, 60, 60, `${vendor}Firewall`);
            
            // Connect firewall to networks
            graph.insertEdge(parent, null, 'Restricted\nAccess', corpNetwork, firewall);
            graph.insertEdge(parent, null, 'Internet\nOnly', firewall, guestNetwork);
            
            // Add Guest Access Flow
            const flowStart = graph.insertVertex(parent, null, 'Guest Connects', 
                400, 500, 120, 40, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
            
            // Connect guest device to WiFi
            const guestDevice = graph.insertVertex(parent, null, 'Guest Device', 
                600, 500, 60, 60, 'deviceByod');
            
            // Connect guest device to guest AP
            graph.insertEdge(parent, null, '', guestDevice, guestAP);
            
            // Create guest access flow steps
            const flowSteps = [
                { text: '1. Guest connects to guest WiFi', y: 580 },
                { text: '2. Redirected to captive portal', y: 630 },
                { text: '3. Self-registration or sponsor approval', y: 680 },
                { text: '4. Temporary credentials provided', y: 730 },
                { text: '5. Limited network access granted', y: 780 }
            ];
            
            // Add guest flow steps
            let prevStep = flowStart;
            flowSteps.forEach((step, i) => {
                const flowStep = graph.insertVertex(parent, null, step.text, 
                    400, step.y, 250, 40, 'shape=process;whiteSpace=wrap;fillColor=#f5f5f5;strokeColor=#666666;');
                
                // Connect to previous step
                graph.insertEdge(parent, null, '', prevStep, flowStep);
                
                prevStep = flowStep;
            });
            
            // Add Guest Portal Features box
            const featuresBox = graph.insertVertex(parent, null, 
                'Guest Portal Features:\n• Self-registration\n• Sponsor approval\n• Social login\n• Terms & conditions\n• Custom branding\n• Usage policy\n• Time-limited access\n• Usage tracking', 
                750, 200, 150, 150, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#dae8fc;strokeColor=#6c8ebf;align=left;');
            
            // Add Guest Auth Methods box
            const authBox = graph.insertVertex(parent, null, 
                'Guest Authentication Methods:\n• Web Authentication\n• SMS verification\n• Email verification\n• Sponsor verification\n• Social login\n• Vouchers/access codes', 
                150, 200, 150, 120, 'shape=note;whiteSpace=wrap;html=1;backgroundOutline=1;darkOpacity=0.05;fillColor=#fff2cc;strokeColor=#d6b656;align=left;');
            
            // Add corporate devices
            const corpDevice = graph.insertVertex(parent, null, 'Corporate Device', 
                200, 500, 60, 60, 'deviceDesktop');
            
            // Connect corporate device
            graph.insertEdge(parent, null, '', corpDevice, corpSwitch);
            
            // Center the graph
            graph.center(true, true, 0.5, 0.5);
        } finally {
            graph.getModel().endUpdate();
        }
    };
    
    // Zoom in function
    const zoomIn = function() {
        if (graph) {
            graph.zoomIn();
        }
    };
    
    // Zoom out function
    const zoomOut = function() {
        if (graph) {
            graph.zoomOut();
        }
    };
    
    // Reset zoom function
    const zoomActual = function() {
        if (graph) {
            graph.zoomActual();
        }
    };
    
    // Export diagram as image or XML
    const exportDiagram = function(format) {
        if (!graph) {
            console.error('Graph not initialized');
            return null;
        }
        
        try {
            if (format === 'png') {
                // Create a canvas for PNG export
                const bounds = graph.getGraphBounds();
                const canvas = document.createElement('canvas');
                
                // Scale appropriately
                const scale = 1;
                canvas.width = Math.max(1, Math.ceil(bounds.width * scale + 2));
                canvas.height = Math.max(1, Math.ceil(bounds.height * scale + 2));
                
                // Render graph to canvas
                const ctx = canvas.getContext('2d');
                ctx.scale(scale, scale);
                ctx.translate(-bounds.x, -bounds.y);
                
                // Draw SVG to canvas
                const svgString = new XMLSerializer().serializeToString(diagramContainer.querySelector('svg'));
                return new Promise((resolve, reject) => {
                    const img = new Image();
                    img.onload = function() {
                        ctx.drawImage(img, 0, 0);
                        resolve(canvas.toDataURL('image/png'));
                    };
                    img.onerror = function(error) {
                        reject(error);
                    };
                    img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgString)));
                });
            } else if (format === 'svg') {
                // Get SVG content
                const svg = diagramContainer.querySelector('svg').cloneNode(true);
                
                // Add XML declaration and doctype
                return '<?xml version="1.0" encoding="UTF-8"?>\n' +
                       '<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">\n' +
                       new XMLSerializer().serializeToString(svg);
            } else if (format === 'xml') {
                // Export graph model as XML
                const encoder = new mxCodec();
                const result = encoder.encode(graph.getModel());
                return mxUtils.getXml(result);
            } else {
                console.error('Unsupported format:', format);
                return null;
            }
        } catch (e) {
            console.error('Error exporting diagram:', e);
            return null;
        }
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
