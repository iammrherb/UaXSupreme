/**
 * UaXSupreme - Diagram Generator
 * Generates network diagrams for authentication implementations
 */

(function() {
    'use strict';

    // Diagram Generator object
    const DiagramGenerator = {
        /**
         * Initialize Diagram Generator
         */
        init: function() {
            console.log('Initializing Diagram Generator...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Generate diagram button
            const generateDiagramBtn = document.getElementById('generateDiagramBtn');
            if (generateDiagramBtn) {
                generateDiagramBtn.addEventListener('click', this.generateDiagram.bind(this));
            }
            
            // Download diagram button
            const downloadDiagramBtn = document.getElementById('downloadDiagramBtn');
            if (downloadDiagramBtn) {
                downloadDiagramBtn.addEventListener('click', this.downloadDiagram.bind(this));
            }
        },
        
        /**
         * Generate network diagram
         */
        generateDiagram: function() {
            const diagramType = document.getElementById('diagramType').value;
            const diagramPreview = document.getElementById('diagramPreview');
            
            // Clear previous diagram
            diagramPreview.innerHTML = '';
            
            // Create canvas for diagram
            const canvas = document.createElement('canvas');
            canvas.id = 'diagramCanvas';
            canvas.width = diagramPreview.offsetWidth;
            canvas.height = 400;
            diagramPreview.appendChild(canvas);
            
            // Generate different types of diagrams
            switch (diagramType) {
                case 'logical':
                    this.generateLogicalDiagram(canvas);
                    break;
                case 'physical':
                    this.generatePhysicalDiagram(canvas);
                    break;
                case 'authentication':
                    this.generateAuthenticationDiagram(canvas);
                    break;
                case 'all':
                    // Create multiple canvases for all diagram types
                    diagramPreview.innerHTML = '';
                    
                    const logicalDiv = document.createElement('div');
                    logicalDiv.className = 'diagram-section';
                    logicalDiv.innerHTML = '<h3>Logical Network Diagram</h3>';
                    const logicalCanvas = document.createElement('canvas');
                    logicalCanvas.width = diagramPreview.offsetWidth;
                    logicalCanvas.height = 300;
                    logicalDiv.appendChild(logicalCanvas);
                    diagramPreview.appendChild(logicalDiv);
                    
                    const physicalDiv = document.createElement('div');
                    physicalDiv.className = 'diagram-section';
                    physicalDiv.innerHTML = '<h3>Physical Network Diagram</h3>';
                    const physicalCanvas = document.createElement('canvas');
                    physicalCanvas.width = diagramPreview.offsetWidth;
                    physicalCanvas.height = 300;
                    physicalDiv.appendChild(physicalCanvas);
                    diagramPreview.appendChild(physicalDiv);
                    
                    const authDiv = document.createElement('div');
                    authDiv.className = 'diagram-section';
                    authDiv.innerHTML = '<h3>Authentication Flow Diagram</h3>';
                    const authCanvas = document.createElement('canvas');
                    authCanvas.width = diagramPreview.offsetWidth;
                    authCanvas.height = 300;
                    authDiv.appendChild(authCanvas);
                    diagramPreview.appendChild(authDiv);
                    
                    // Generate all diagrams
                    this.generateLogicalDiagram(logicalCanvas);
                    this.generatePhysicalDiagram(physicalCanvas);
                    this.generateAuthenticationDiagram(authCanvas);
                    break;
                default:
                    this.generateLogicalDiagram(canvas);
            }
        },
        
        /**
         * Generate logical network diagram
         * @param {HTMLCanvasElement} canvas - Canvas element to draw on
         */
        generateLogicalDiagram: function(canvas) {
            const ctx = canvas.getContext('2d');
            
            // Clear canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            
            // Set up colors
            const colors = {
                background: '#ffffff',
                lines: '#666666',
                devices: {
                    radius: '#3498db',
                    switch: '#2c3e50',
                    client: '#27ae60',
                    printer: '#e74c3c'
                },
                text: '#333333',
                highlight: '#f39c12'
            };
            
            // Fill background
            ctx.fillStyle = colors.background;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            // Draw logical network diagram
            this.drawRADIUSServer(ctx, canvas.width * 0.75, 80, colors.devices.radius, '10.1.1.100');
            this.drawRADIUSServer(ctx, canvas.width * 0.85, 80, colors.devices.radius, '10.1.1.101');
            
            this.drawSwitch(ctx, canvas.width * 0.5, 180, colors.devices.switch, 'Core Switch');
            
            const accessSwitch1 = this.drawSwitch(ctx, canvas.width * 0.3, 280, colors.devices.switch, 'Access Switch 1');
            const accessSwitch2 = this.drawSwitch(ctx, canvas.width * 0.7, 280, colors.devices.switch, 'Access Switch 2');
            
            // Draw clients
            this.drawClient(ctx, canvas.width * 0.15, 360, colors.devices.client, 'Client 1');
            this.drawClient(ctx, canvas.width * 0.3, 360, colors.devices.client, 'Client 2');
            this.drawClient(ctx, canvas.width * 0.45, 360, colors.devices.client, 'Client 3');
            
            this.drawPrinter(ctx, canvas.width * 0.6, 360, colors.devices.printer, 'Printer');
            this.drawClient(ctx, canvas.width * 0.75, 360, colors.devices.client, 'Client 4');
            this.drawClient(ctx, canvas.width * 0.9, 360, colors.devices.client, 'Client 5');
            
            // Draw connections
            ctx.strokeStyle = colors.lines;
            ctx.lineWidth = 2;
            
            // RADIUS to Core
            this.drawLine(ctx, canvas.width * 0.75, 110, canvas.width * 0.5, 165);
            this.drawLine(ctx, canvas.width * 0.85, 110, canvas.width * 0.5, 165);
            
            // Core to Access
            this.drawLine(ctx, canvas.width * 0.5, 195, canvas.width * 0.3, 265);
            this.drawLine(ctx, canvas.width * 0.5, 195, canvas.width * 0.7, 265);
            
            // Access to Clients
            this.drawLine(ctx, canvas.width * 0.3, 295, canvas.width * 0.15, 345);
            this.drawLine(ctx, canvas.width * 0.3, 295, canvas.width * 0.3, 345);
            this.drawLine(ctx, canvas.width * 0.3, 295, canvas.width * 0.45, 345);
            
            this.drawLine(ctx, canvas.width * 0.7, 295, canvas.width * 0.6, 345);
            this.drawLine(ctx, canvas.width * 0.7, 295, canvas.width * 0.75, 345);
            this.drawLine(ctx, canvas.width * 0.7, 295, canvas.width * 0.9, 345);
            
            // Add VLANs
            ctx.fillStyle = colors.highlight;
            ctx.font = '12px Arial';
            ctx.fillText('VLAN 10', canvas.width * 0.35, 230);
            ctx.fillText('VLAN 20', canvas.width * 0.6, 230);
            
            // Add RADIUS info
            ctx.fillStyle = colors.text;
            ctx.font = 'bold 14px Arial';
            ctx.fillText('RADIUS Servers', canvas.width * 0.75, 50);
            
            // Add legend
            this.drawLegend(ctx, canvas.width - 150, canvas.height - 100, colors);
        },
        
        /**
         * Generate physical network diagram
         * @param {HTMLCanvasElement} canvas - Canvas element to draw on
         */
        generatePhysicalDiagram: function(canvas) {
            const ctx = canvas.getContext('2d');
            
            // Clear canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            
            // Set up colors
            const colors = {
                background: '#ffffff',
                lines: '#666666',
                vlan: {
                    data: '#3498db',
                    voice: '#2ecc71',
                    guest: '#e74c3c',
                    mgmt: '#f39c12'
                },
                devices: {
                    radius: '#8e44ad',
                    switch: '#2c3e50',
                    client: '#27ae60',
                    phone: '#3498db',
                    printer: '#e74c3c'
                },
                text: '#333333'
            };
            
            // Fill background
            ctx.fillStyle = colors.background;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            // Draw room layout
            ctx.strokeStyle = colors.lines;
            ctx.lineWidth = 1;
            
            // Draw floor layout
            this.drawRectangle(ctx, 50, 50, canvas.width - 100, canvas.height - 100, colors.lines, 'Floor Plan');
            
            // Draw server room
            this.drawRectangle(ctx, 70, 70, 150, 100, colors.lines, 'Server Room');
            
            // Draw offices
            this.drawRectangle(ctx, 70, 180, 150, 80, colors.lines, 'Office 1');
            this.drawRectangle(ctx, 70, 270, 150, 80, colors.lines, 'Office 2');
            
            // Draw conference room
            this.drawRectangle(ctx, 230, 70, 200, 120, colors.lines, 'Conference Room');
            
            // Draw open area
            this.drawRectangle(ctx, 230, 200, 200, 150, colors.lines, 'Open Area');
            
            // Draw network elements
            
            // Server room
            const radiusServer1 = this.drawServerIcon(ctx, 100, 100, colors.devices.radius, 'RADIUS 1');
            const radiusServer2 = this.drawServerIcon(ctx, 140, 100, colors.devices.radius, 'RADIUS 2');
            const coreSwitch = this.drawSwitchIcon(ctx, 120, 140, colors.devices.switch, 'Core SW');
            
            // Office 1
            const accessSwitch1 = this.drawSwitchIcon(ctx, 120, 200, colors.devices.switch, 'SW1');
            const workstation1 = this.drawWorkstationIcon(ctx, 180, 200, colors.devices.client, 'PC1');
            const phone1 = this.drawPhoneIcon(ctx, 180, 230, colors.devices.phone, 'Phone1');
            
            // Office 2
            const accessSwitch2 = this.drawSwitchIcon(ctx, 120, 290, colors.devices.switch, 'SW2');
            const workstation2 = this.drawWorkstationIcon(ctx, 180, 290, colors.devices.client, 'PC2');
            const phone2 = this.drawPhoneIcon(ctx, 180, 320, colors.devices.phone, 'Phone2');
            
            // Conference room
            const accessSwitch3 = this.drawSwitchIcon(ctx, 260, 100, colors.devices.switch, 'SW3');
            const wirelessAP = this.drawAPIcon(ctx, 330, 100, colors.devices.client, 'AP1');
            const printer = this.drawPrinterIcon(ctx, 330, 140, colors.devices.printer, 'Printer');
            
            // Open area
            const accessSwitch4 = this.drawSwitchIcon(ctx, 260, 230, colors.devices.switch, 'SW4');
            const workstation3 = this.drawWorkstationIcon(ctx, 310, 230, colors.devices.client, 'PC3');
            const workstation4 = this.drawWorkstationIcon(ctx, 350, 230, colors.devices.client, 'PC4');
            const workstation5 = this.drawWorkstationIcon(ctx, 310, 270, colors.devices.client, 'PC5');
            const workstation6 = this.drawWorkstationIcon(ctx, 350, 270, colors.devices.client, 'PC6');
            const phone3 = this.drawPhoneIcon(ctx, 310, 310, colors.devices.phone, 'Phone3');
            const phone4 = this.drawPhoneIcon(ctx, 350, 310, colors.devices.phone, 'Phone4');
            
            // Draw connections
            ctx.lineWidth = 2;
            
            // RADIUS to Core
            ctx.strokeStyle = colors.vlan.mgmt;
            this.drawLine(ctx, radiusServer1.x, radiusServer1.y + 15, coreSwitch.x - 5, coreSwitch.y - 10);
            this.drawLine(ctx, radiusServer2.x, radiusServer2.y + 15, coreSwitch.x + 5, coreSwitch.y - 10);
            
            // Core to Access Switches
            ctx.strokeStyle = colors.lines;
            this.drawLine(ctx, coreSwitch.x, coreSwitch.y + 10, accessSwitch1.x, accessSwitch1.y - 10);
            this.drawLine(ctx, coreSwitch.x, coreSwitch.y + 10, accessSwitch2.x, accessSwitch2.y - 10);
            this.drawLine(ctx, coreSwitch.x + 10, coreSwitch.y, accessSwitch3.x - 10, accessSwitch3.y);
            this.drawLine(ctx, coreSwitch.x + 10, coreSwitch.y + 5, accessSwitch4.x - 10, accessSwitch4.y);
            
            // Access Switches to Devices
            ctx.strokeStyle = colors.vlan.data;
            this.drawLine(ctx, accessSwitch1.x + 10, accessSwitch1.y, workstation1.x - 10, workstation1.y);
            this.drawLine(ctx, accessSwitch2.x + 10, accessSwitch2.y, workstation2.x - 10, workstation2.y);
            this.drawLine(ctx, accessSwitch3.x + 10, accessSwitch3.y, wirelessAP.x - 10, wirelessAP.y);
            this.drawLine(ctx, accessSwitch3.x + 10, accessSwitch3.y + 5, printer.x - 10, printer.y);
            
            this.drawLine(ctx, accessSwitch4.x + 10, accessSwitch4.y, workstation3.x - 10, workstation3.y);
            this.drawLine(ctx, accessSwitch4.x + 10, accessSwitch4.y + 5, workstation4.x - 10, workstation4.y);
            this.drawLine(ctx, accessSwitch4.x + 5, accessSwitch4.y + 10, workstation5.x - 5, workstation5.y - 10);
            this.drawLine(ctx, accessSwitch4.x + 10, accessSwitch4.y + 10, workstation6.x - 10, workstation6.y - 10);
            
            // Phones
            ctx.strokeStyle = colors.vlan.voice;
            this.drawLine(ctx, workstation1.x, workstation1.y + 10, phone1.x, phone1.y - 10);
            this.drawLine(ctx, workstation2.x, workstation2.y + 10, phone2.x, phone2.y - 10);
            this.drawLine(ctx, workstation5.x, workstation5.y + 10, phone3.x, phone3.y - 10);
            this.drawLine(ctx, workstation6.x, workstation6.y + 10, phone4.x, phone4.y - 10);
            
            // Add legend
            this.drawNetworkLegend(ctx, canvas.width - 160, 60, colors);
        },
        
        /**
         * Generate authentication flow diagram
         * @param {HTMLCanvasElement} canvas - Canvas element to draw on
         */
        generateAuthenticationDiagram: function(canvas) {
            const ctx = canvas.getContext('2d');
            
            // Clear canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            
            // Set up colors
            const colors = {
                background: '#ffffff',
                lines: {
                    request: '#3498db',
                    response: '#2ecc71',
                    failure: '#e74c3c'
                },
                devices: {
                    client: '#27ae60',
                    switch: '#2c3e50',
                    radius: '#8e44ad'
                },
                text: '#333333',
                box: {
                    background: '#f8f9fa',
                    border: '#dee2e6'
                }
            };
            
            // Fill background
            ctx.fillStyle = colors.background;
            ctx.fillRect(0, 0, canvas.width, canvas.height);
            
            // Draw devices
            const clientX = 100;
            const switchX = canvas.width / 2;
            const radiusX = canvas.width - 100;
            const baseY = 60;
            
            this.drawAuthClient(ctx, clientX, baseY, colors.devices.client, 'Client');
            this.drawAuthSwitch(ctx, switchX, baseY, colors.devices.switch, 'Switch');
            this.drawAuthServer(ctx, radiusX, baseY, colors.devices.radius, 'RADIUS');
            
            // Draw authentication flow
            const timelineY = baseY + 40;
            const stepHeight = 40;
            
            // Draw vertical timelines
            ctx.setLineDash([5, 3]);
            ctx.strokeStyle = '#cccccc';
            ctx.beginPath();
            ctx.moveTo(clientX, timelineY);
            ctx.lineTo(clientX, canvas.height - 20);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(switchX, timelineY);
            ctx.lineTo(switchX, canvas.height - 20);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.moveTo(radiusX, timelineY);
            ctx.lineTo(radiusX, canvas.height - 20);
            ctx.stroke();
            
            ctx.setLineDash([]);
            
            // Step 1: Client connects to switch
            this.drawAuthStep(ctx, 1, clientX, switchX, timelineY, 
                            colors.lines.request, 'Client connects to port');
            
            // Step 2: Switch sends EAP-Request Identity
            this.drawAuthStep(ctx, 2, switchX, clientX, timelineY + stepHeight, 
                            colors.lines.request, 'EAP-Request Identity');
            
            // Step 3: Client sends EAP-Response Identity
            this.drawAuthStep(ctx, 3, clientX, switchX, timelineY + stepHeight * 2, 
                            colors.lines.response, 'EAP-Response Identity');
            
            // Step 4: Switch forwards to RADIUS
            this.drawAuthStep(ctx, 4, switchX, radiusX, timelineY + stepHeight * 3, 
                            colors.lines.request, 'RADIUS Access-Request');
            
            // Step 5: RADIUS sends Challenge
            this.drawAuthStep(ctx, 5, radiusX, switchX, timelineY + stepHeight * 4, 
                            colors.lines.request, 'RADIUS Access-Challenge');
            
            // Step 6: Switch forwards Challenge to Client
            this.drawAuthStep(ctx, 6, switchX, clientX, timelineY + stepHeight * 5, 
                            colors.lines.request, 'EAP-Request (Challenge)');
            
            // Step 7: Client sends Response
            this.drawAuthStep(ctx, 7, clientX, switchX, timelineY + stepHeight * 6, 
                            colors.lines.response, 'EAP-Response (Credentials)');
            
            // Step 8: Switch forwards to RADIUS
            this.drawAuthStep(ctx, 8, switchX, radiusX, timelineY + stepHeight * 7, 
                            colors.lines.request, 'RADIUS Access-Request');
            
            // Step 9: RADIUS sends Accept
            this.drawAuthStep(ctx, 9, radiusX, switchX, timelineY + stepHeight * 8, 
                            colors.lines.response, 'RADIUS Access-Accept + VLAN, ACL');
            
            // Step 10: Switch sends Success to Client
            this.drawAuthStep(ctx, 10, switchX, clientX, timelineY + stepHeight * 9, 
                            colors.lines.response, 'EAP-Success');
            
            // Step 11: Client port authorized
            this.drawAuthStepBox(ctx, timelineY + stepHeight * 10, 'Port authorized, client assigned to VLAN', colors.box);
        },
        
        /**
         * Draw RADIUS server
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Server color
         * @param {string} label - Server label
         * @returns {Object} Server position
         */
        drawRADIUSServer: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw server
            ctx.fillRect(x - 20, y - 25, 40, 50);
            ctx.strokeRect(x - 20, y - 25, 40, 50);
            
            // Draw server details
            ctx.fillStyle = '#ffffff';
            
            // Draw server slots
            ctx.fillRect(x - 15, y - 20, 30, 5);
            ctx.fillRect(x - 15, y - 10, 30, 5);
            ctx.fillRect(x - 15, y, 30, 5);
            ctx.fillRect(x - 15, y + 10, 30, 5);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 40);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw switch
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Switch color
         * @param {string} label - Switch label
         * @returns {Object} Switch position
         */
        drawSwitch: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw switch
            ctx.fillRect(x - 30, y - 15, 60, 30);
            ctx.strokeRect(x - 30, y - 15, 60, 30);
            
            // Draw ports
            ctx.fillStyle = '#ffffff';
            for (let i = 0; i < 6; i++) {
                ctx.fillRect(x - 24 + i * 8, y + 5, 6, 3);
            }
            
            // Draw label
            ctx.fillStyle = '#ffffff';
            ctx.font = 'bold 10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y - 2);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw client
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Client color
         * @param {string} label - Client label
         * @returns {Object} Client position
         */
        drawClient: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw monitor
            ctx.fillRect(x - 15, y - 15, 30, 25);
            ctx.strokeRect(x - 15, y - 15, 30, 25);
            
            // Draw stand
            ctx.fillRect(x - 5, y + 10, 10, 5);
            ctx.strokeRect(x - 5, y + 10, 10, 5);
            
            // Draw base
            ctx.fillRect(x - 10, y + 15, 20, 3);
            ctx.strokeRect(x - 10, y + 15, 20, 3);
            
            // Draw screen
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(x - 12, y - 12, 24, 19);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 30);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw printer
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Printer color
         * @param {string} label - Printer label
         * @returns {Object} Printer position
         */
        drawPrinter: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw printer body
            ctx.fillRect(x - 20, y - 10, 40, 25);
            ctx.strokeRect(x - 20, y - 10, 40, 25);
            
            // Draw paper tray
            ctx.fillRect(x - 15, y - 18, 30, 8);
            ctx.strokeRect(x - 15, y - 18, 30, 8);
            
            // Draw controls
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(x + 5, y, 10, 8);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 30);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw server icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Server color
         * @param {string} label - Server label
         * @returns {Object} Position
         */
        drawServerIcon: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw server
            ctx.fillRect(x - 15, y - 15, 30, 30);
            ctx.strokeRect(x - 15, y - 15, 30, 30);
            
            // Draw server details
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(x - 10, y - 10, 20, 5);
            ctx.fillRect(x - 10, y, 20, 5);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 25);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw switch icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Switch color
         * @param {string} label - Switch label
         * @returns {Object} Position
         */
        drawSwitchIcon: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw switch
            ctx.fillRect(x - 15, y - 10, 30, 20);
            ctx.strokeRect(x - 15, y - 10, 30, 20);
            
            // Draw ports
            ctx.fillStyle = '#ffffff';
            for (let i = 0; i < 4; i++) {
                ctx.fillRect(x - 12 + i * 8, y + 5, 6, 2);
            }
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 20);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw workstation icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Workstation color
         * @param {string} label - Workstation label
         * @returns {Object} Position
         */
        drawWorkstationIcon: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw monitor
            ctx.fillRect(x - 10, y - 10, 20, 15);
            ctx.strokeRect(x - 10, y - 10, 20, 15);
            
            // Draw stand
            ctx.fillRect(x - 3, y + 5, 6, 3);
            ctx.strokeRect(x - 3, y + 5, 6, 3);
            
            // Draw base
            ctx.fillRect(x - 7, y + 8, 14, 2);
            ctx.strokeRect(x - 7, y + 8, 14, 2);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 20);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw phone icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Phone color
         * @param {string} label - Phone label
         * @returns {Object} Position
         */
        drawPhoneIcon: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw phone body
            ctx.fillRect(x - 8, y - 8, 16, 16);
            ctx.strokeRect(x - 8, y - 8, 16, 16);
            
            // Draw handset
            ctx.beginPath();
            ctx.arc(x - 10, y - 2, 4, 0, Math.PI * 2);
            ctx.fill();
            ctx.stroke();
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 15);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw access point icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - AP color
         * @param {string} label - AP label
         * @returns {Object} Position
         */
        drawAPIcon: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw AP body
            ctx.beginPath();
            ctx.arc(x, y, 10, 0, Math.PI * 2);
            ctx.fill();
            ctx.stroke();
            
            // Draw signal waves
            ctx.beginPath();
            ctx.arc(x, y, 15, -Math.PI / 4, Math.PI / 4);
            ctx.stroke();
            
            ctx.beginPath();
            ctx.arc(x, y, 20, -Math.PI / 6, Math.PI / 6);
            ctx.stroke();
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 25);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw printer icon
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Printer color
         * @param {string} label - Printer label
         * @returns {Object} Position
         */
        drawPrinterIcon: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw printer body
            ctx.fillRect(x - 12, y - 8, 24, 16);
            ctx.strokeRect(x - 12, y - 8, 24, 16);
            
            // Draw paper
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(x - 8, y - 15, 16, 7);
            ctx.strokeRect(x - 8, y - 15, 16, 7);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = '10px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y + 15);
            
            return { x: x, y: y };
        },
        
        /**
         * Draw line between two points
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x1 - Start X position
         * @param {number} y1 - Start Y position
         * @param {number} x2 - End X position
         * @param {number} y2 - End Y position
         */
        drawLine: function(ctx, x1, y1, x2, y2) {
            ctx.beginPath();
            ctx.moveTo(x1, y1);
            ctx.lineTo(x2, y2);
            ctx.stroke();
        },
        
        /**
         * Draw legend for diagram
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {Object} colors - Color scheme
         */
        drawLegend: function(ctx, x, y, colors) {
            const boxSize = 15;
            const textOffset = 20;
            const lineHeight = 20;
            
            ctx.font = '12px Arial';
            ctx.textAlign = 'left';
            ctx.fillStyle = '#000000';
            ctx.fillText('Legend:', x, y);
            
            // RADIUS Server
            ctx.fillStyle = colors.devices.radius;
            ctx.fillRect(x, y + lineHeight - boxSize / 2, boxSize, boxSize);
            ctx.strokeStyle = '#000000';
            ctx.strokeRect(x, y + lineHeight - boxSize / 2, boxSize, boxSize);
            ctx.fillStyle = '#000000';
            ctx.fillText('RADIUS Server', x + textOffset, y + lineHeight);
            
            // Switch
            ctx.fillStyle = colors.devices.switch;
            ctx.fillRect(x, y + lineHeight * 2 - boxSize / 2, boxSize, boxSize);
            ctx.strokeStyle = '#000000';
            ctx.strokeRect(x, y + lineHeight * 2 - boxSize / 2, boxSize, boxSize);
            ctx.fillStyle = '#000000';
            ctx.fillText('Switch', x + textOffset, y + lineHeight * 2);
            
            // Client
            ctx.fillStyle = colors.devices.client;
            ctx.fillRect(x, y + lineHeight * 3 - boxSize / 2, boxSize, boxSize);
            ctx.strokeStyle = '#000000';
            ctx.strokeRect(x, y + lineHeight * 3 - boxSize / 2, boxSize, boxSize);
            ctx.fillStyle = '#000000';
            ctx.fillText('Client Workstation', x + textOffset, y + lineHeight * 3);
            
            // Printer
            ctx.fillStyle = colors.devices.printer;
            ctx.fillRect(x, y + lineHeight * 4 - boxSize / 2, boxSize, boxSize);
            ctx.strokeStyle = '#000000';
            ctx.strokeRect(x, y + lineHeight * 4 - boxSize / 2, boxSize, boxSize);
            ctx.fillStyle = '#000000';
            ctx.fillText('Printer', x + textOffset, y + lineHeight * 4);
        },
        
        /**
         * Draw network legend
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {Object} colors - Color scheme
         */
        drawNetworkLegend: function(ctx, x, y, colors) {
            const boxSize = 15;
            const textOffset = 20;
            const lineHeight = 20;
            
            ctx.font = '12px Arial';
            ctx.textAlign = 'left';
            ctx.fillStyle = '#000000';
            ctx.fillText('Legend:', x, y);
            
            // Data VLAN
            ctx.strokeStyle = colors.vlan.data;
            ctx.lineWidth = 3;
            ctx.beginPath();
            ctx.moveTo(x, y + lineHeight);
            ctx.lineTo(x + boxSize, y + lineHeight);
            ctx.stroke();
            ctx.fillStyle = '#000000';
            ctx.fillText('Data VLAN', x + textOffset, y + lineHeight + 5);
            
            // Voice VLAN
            ctx.strokeStyle = colors.vlan.voice;
            ctx.beginPath();
            ctx.moveTo(x, y + lineHeight * 2);
            ctx.lineTo(x + boxSize, y + lineHeight * 2);
            ctx.stroke();
            ctx.fillStyle = '#000000';
            ctx.fillText('Voice VLAN', x + textOffset, y + lineHeight * 2 + 5);
            
            // Management VLAN
            ctx.strokeStyle = colors.vlan.mgmt;
            ctx.beginPath();
            ctx.moveTo(x, y + lineHeight * 3);
            ctx.lineTo(x + boxSize, y + lineHeight * 3);
            ctx.stroke();
            ctx.fillStyle = '#000000';
            ctx.fillText('Management VLAN', x + textOffset, y + lineHeight * 3 + 5);
            
            // Switch
            ctx.fillStyle = colors.devices.switch;
            ctx.fillRect(x, y + lineHeight * 4 - boxSize / 2, boxSize, boxSize);
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            ctx.strokeRect(x, y + lineHeight * 4 - boxSize / 2, boxSize, boxSize);
            ctx.fillStyle = '#000000';
            ctx.fillText('Switch', x + textOffset, y + lineHeight * 4 + 5);
            
            // Client
            ctx.fillStyle = colors.devices.client;
            ctx.fillRect(x, y + lineHeight * 5 - boxSize / 2, boxSize, boxSize);
            ctx.strokeRect(x, y + lineHeight * 5 - boxSize / 2, boxSize, boxSize);
            ctx.fillStyle = '#000000';
            ctx.fillText('Client', x + textOffset, y + lineHeight * 5 + 5);
        },
        
        /**
         * Draw rectangle for floor plan
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {number} width - Width
         * @param {number} height - Height
         * @param {string} color - Border color
         * @param {string} label - Room label
         */
        drawRectangle: function(ctx, x, y, width, height, color, label) {
            ctx.strokeStyle = color;
            ctx.strokeRect(x, y, width, height);
            
            ctx.fillStyle = '#000000';
            ctx.font = '12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x + width / 2, y + 20);
        },
        
        /**
         * Draw authentication client
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Client color
         * @param {string} label - Client label
         */
        drawAuthClient: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw client icon (laptop)
            ctx.fillRect(x - 15, y - 10, 30, 20);
            ctx.strokeRect(x - 15, y - 10, 30, 20);
            
            // Draw screen
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(x - 13, y - 8, 26, 16);
            
            // Draw keyboard
            ctx.fillStyle = color;
            ctx.fillRect(x - 15, y + 10, 30, 3);
            ctx.strokeRect(x - 15, y + 10, 30, 3);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = 'bold 12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y - 20);
        },
        
        /**
         * Draw authentication switch
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Switch color
         * @param {string} label - Switch label
         */
        drawAuthSwitch: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw switch
            ctx.fillRect(x - 20, y - 10, 40, 20);
            ctx.strokeRect(x - 20, y - 10, 40, 20);
            
            // Draw ports
            ctx.fillStyle = '#ffffff';
            for (let i = 0; i < 6; i++) {
                ctx.fillRect(x - 18 + i * 6, y + 4, 5, 3);
            }
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = 'bold 12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y - 20);
        },
        
        /**
         * Draw authentication server
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} x - X position
         * @param {number} y - Y position
         * @param {string} color - Server color
         * @param {string} label - Server label
         */
        drawAuthServer: function(ctx, x, y, color, label) {
            ctx.fillStyle = color;
            ctx.strokeStyle = '#000000';
            ctx.lineWidth = 1;
            
            // Draw server
            ctx.fillRect(x - 20, y - 15, 40, 30);
            ctx.strokeRect(x - 20, y - 15, 40, 30);
            
            // Draw server slots
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(x - 15, y - 10, 30, 5);
            ctx.fillRect(x - 15, y, 30, 5);
            ctx.fillRect(x - 15, y + 10, 30, 5);
            
            // Draw label
            ctx.fillStyle = '#000000';
            ctx.font = 'bold 12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(label, x, y - 25);
        },
        
        /**
         * Draw authentication flow step
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} step - Step number
         * @param {number} fromX - Starting X position
         * @param {number} toX - Ending X position
         * @param {number} y - Y position
         * @param {string} color - Arrow color
         * @param {string} label - Step label
         */
        drawAuthStep: function(ctx, step, fromX, toX, y, color, label) {
            // Draw arrow
            ctx.strokeStyle = color;
            ctx.fillStyle = color;
            ctx.lineWidth = 2;
            
            // Arrow line
            ctx.beginPath();
            ctx.moveTo(fromX, y);
            ctx.lineTo(toX, y);
            ctx.stroke();
            
            // Arrow head
            const headSize = 6;
            const direction = fromX < toX ? 1 : -1;
            
            ctx.beginPath();
            ctx.moveTo(toX, y);
            ctx.lineTo(toX - direction * headSize, y - headSize / 2);
            ctx.lineTo(toX - direction * headSize, y + headSize / 2);
            ctx.closePath();
            ctx.fill();
            
            // Step label
            ctx.fillStyle = '#333333';
            ctx.font = '12px Arial';
            ctx.textAlign = fromX < toX ? 'left' : 'right';
            
            // Add step number
            ctx.fillText(`${step}. ${label}`, (fromX + toX) / 2, y - 8);
        },
        
        /**
         * Draw authentication step box
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} y - Y position
         * @param {string} text - Box text
         * @param {Object} boxColors - Box colors
         */
        drawAuthStepBox: function(ctx, y, text, boxColors) {
            const width = 300;
            const height = 30;
            const x = (ctx.canvas.width - width) / 2;
            
            // Draw box
            ctx.fillStyle = boxColors.background;
            ctx.strokeStyle = boxColors.border;
            ctx.lineWidth = 1;
            
            ctx.fillRect(x, y, width, height);
            ctx.strokeRect(x, y, width, height);
            
            // Draw text
            ctx.fillStyle = '#333333';
            ctx.font = 'bold 12px Arial';
            ctx.textAlign = 'center';
            ctx.fillText(text, ctx.canvas.width / 2, y + height / 2 + 5);
        },
        
        /**
         * Download the current diagram as a PNG image
         */
        downloadDiagram: function() {
            const diagramType = document.getElementById('diagramType').value;
            const canvas = document.getElementById('diagramCanvas');
            
            if (!canvas) {
                alert('Please generate a diagram first.');
                return;
            }
            
            // Create a temporary link
            const link = document.createElement('a');
            link.download = `network-${diagramType}-diagram.png`;
            link.href = canvas.toDataURL('image/png');
            
            // Click the link to trigger the download
            link.click();
        }
    };

    // Initialize Diagram Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        DiagramGenerator.init();
    });

    // Export to window
    window.DiagramGenerator = DiagramGenerator;
})();
