/**
 * Dot1Xer Supreme Enterprise Edition - Diagram Generator
 * Version 4.1.0
 * 
 * This module handles the generation of network diagrams for 802.1X deployments.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Diagram Generator...');
    
    // Set up event handlers
    const generateDiagramButton = document.getElementById('generate-diagram');
    if (generateDiagramButton) {
        generateDiagramButton.addEventListener('click', generateDiagram);
    }
});

// Generate diagram based on selected type
function generateDiagram() {
    const diagramType = document.getElementById('diagram-type').value;
    const diagramDisplay = document.getElementById('diagram-display');
    
    if (!diagramDisplay) return;
    
    // Show loading indicator
    diagramDisplay.innerHTML = '<p>Generating diagram...</p>';
    
    // Get settings for diagram
    const settings = collectDiagramSettings();
    
    // Generate different diagram types
    switch (diagramType) {
        case 'network-topology':
            generateNetworkTopologyDiagram(diagramDisplay, settings);
            break;
        case 'authentication-flow':
            generateAuthenticationFlowDiagram(diagramDisplay, settings);
            break;
        case 'deployment-architecture':
            generateDeploymentArchitectureDiagram(diagramDisplay, settings);
            break;
        case 'radius-communication':
            generateRadiusCommunicationDiagram(diagramDisplay, settings);
            break;
        default:
            diagramDisplay.innerHTML = '<p>Unknown diagram type selected.</p>';
    }
}

// Collect settings for diagram generation
function collectDiagramSettings() {
    // Get vendor and platform
    const vendorContainers = document.querySelectorAll('.vendor-logo-container');
    let selectedVendor = 'unknown';
    
    vendorContainers.forEach(container => {
        if (container.classList.contains('selected')) {
            selectedVendor = container.getAttribute('data-vendor');
        }
    });
    
    const platformSelect = document.getElementById('platform-select');
    const platform = platformSelect ? platformSelect.value : 'unknown';
    
    // Get relevant settings from form
    return {
        vendor: selectedVendor,
        platform: platform,
        authMethod: getSelectValue('auth-method', 'dot1x'),
        authMode: getRadioValue('auth-mode', 'closed'),
        hostMode: getSelectValue('host-mode', 'multi-auth'),
        radiusServer: getInputValue('radius-server-1', '10.1.1.1'),
        secondaryServer: getInputValue('radius-server-2', ''),
        vlanAuth: getInputValue('vlan-auth', '100'),
        vlanUnauth: getInputValue('vlan-unauth', '999'),
        vlanGuest: getInputValue('vlan-guest', '900'),
        vlanVoice: getInputValue('vlan-voice', '200'),
        interface: getInputValue('interface', 'GigabitEthernet1/0/1'),
        useMab: ['mab', 'dot1x-mab', 'concurrent', 'dot1x-mab-webauth'].includes(getSelectValue('auth-method', 'dot1x')),
        useRadSec: getCheckboxValue('use-radsec', false),
        useCoa: getCheckboxValue('use-coa', true)
    };
}

// Generate Network Topology Diagram
function generateNetworkTopologyDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "500");
    svg.setAttribute("viewBox", "0 0 800 500");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "802.1X Network Topology";
    svg.appendChild(title);
    
    // Add subtitle with vendor information
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = `${settings.vendor.toUpperCase()} ${settings.platform.toUpperCase()} Deployment`;
    svg.appendChild(subtitle);
    
    // Draw network elements
    
    // RADIUS Server(s)
    drawRadiusServer(svg, 650, 200, settings.radiusServer, "Primary RADIUS");
    if (settings.secondaryServer) {
        drawRadiusServer(svg, 650, 300, settings.secondaryServer, "Secondary RADIUS");
    }
    
    // Network switch
    drawNetworkSwitch(svg, 400, 250, settings);
    
    // Client devices
    if (settings.hostMode === 'single-host') {
        // Single client
        drawClientDevice(svg, 150, 250, "Client Device", "standard");
        drawConnection(svg, 150, 250, 400, 250, "#0077cc", "802.1X");
    } else if (settings.hostMode === 'multi-host') {
        // Multiple clients through one authentication
        drawClientDevice(svg, 150, 200, "Authenticated Client", "standard");
        drawClientDevice(svg, 150, 250, "Piggyback Client", "light");
        drawClientDevice(svg, 150, 300, "Piggyback Client", "light");
        drawConnection(svg, 150, 200, 400, 250, "#0077cc", "802.1X");
        drawConnection(svg, 150, 250, 400, 250, "#999", "Non-auth traffic");
        drawConnection(svg, 150, 300, 400, 250, "#999", "Non-auth traffic");
    } else if (settings.hostMode === 'multi-domain') {
        // Data + voice device
        drawClientDevice(svg, 150, 200, "Data Device", "standard");
        drawClientDevice(svg, 150, 300, "Voice Device", "phone");
        drawConnection(svg, 150, 200, 400, 250, "#0077cc", "802.1X (Data)");
        drawConnection(svg, 150, 300, 400, 250, "#28a745", "802.1X (Voice)");
    } else {
        // Multi-auth (multiple devices)
        drawClientDevice(svg, 100, 150, "Client 1", "standard");
        drawClientDevice(svg, 150, 200, "Client 2", "standard");
        drawClientDevice(svg, 150, 300, "Client 3", "phone");
        drawConnection(svg, 100, 150, 400, 250, "#0077cc", "802.1X");
        drawConnection(svg, 150, 200, 400, 250, "#0077cc", "802.1X");
        drawConnection(svg, 150, 300, 400, 250, "#28a745", "802.1X (Voice)");
    }
    
    // RADIUS connections
    drawConnection(svg, 400, 250, 650, 200, "#dc3545", settings.useRadSec ? "RadSec (TLS)" : "RADIUS");
    if (settings.secondaryServer) {
        drawConnection(svg, 400, 250, 650, 300, "#dc3545", "Failover RADIUS");
    }
    
    // Draw legend
    drawLegend(svg, 50, 400);
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "network-topology");
}

// Generate Authentication Flow Diagram
function generateAuthenticationFlowDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "600");
    svg.setAttribute("viewBox", "0 0 800 600");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "802.1X Authentication Flow";
    svg.appendChild(title);
    
    // Add subtitle with method information
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = getAuthMethodName(settings.authMethod);
    svg.appendChild(subtitle);
    
    // Draw column headers
    const columns = ["Supplicant", "Authenticator", "Authentication Server"];
    const columnX = [150, 400, 650];
    
    columns.forEach((text, index) => {
        const header = document.createElementNS("http://www.w3.org/2000/svg", "text");
        header.setAttribute("x", columnX[index]);
        header.setAttribute("y", "90");
        header.setAttribute("text-anchor", "middle");
        header.setAttribute("font-family", "Arial, sans-serif");
        header.setAttribute("font-size", "16");
        header.setAttribute("font-weight", "bold");
        header.setAttribute("fill", "#333");
        header.textContent = text;
        svg.appendChild(header);
        
        // Draw column vertical lines
        const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", columnX[index]);
        line.setAttribute("y1", "100");
        line.setAttribute("x2", columnX[index]);
        line.setAttribute("y2", "550");
        line.setAttribute("stroke", "#ccc");
        line.setAttribute("stroke-width", "2");
        line.setAttribute("stroke-dasharray", "5,5");
        svg.appendChild(line);
        
        // Draw icons for each column
        if (index === 0) {
            // Supplicant icon
            drawIcon(svg, columnX[index], 130, "laptop");
        } else if (index === 1) {
            // Authenticator icon
            drawIcon(svg, columnX[index], 130, "switch");
        } else {
            // Authentication Server icon
            drawIcon(svg, columnX[index], 130, "server");
        }
    });
    
    // Draw authentication flow arrows and labels
    let startY = 180;
    const stepHeight = 50;
    
    // Standard 802.1X flow
    if (settings.authMethod === 'dot1x' || settings.authMethod === 'dot1x-mab' || 
        settings.authMethod === 'concurrent' || settings.authMethod === 'dot1x-mab-webauth') {
        
        // Link initialization
        drawArrow(svg, columnX[0], startY, columnX[1], startY, "#0077cc");
        drawFlowLabel(svg, "EAPOL-Start", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        // Identity request
        drawArrow(svg, columnX[1], startY, columnX[0], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Request/Identity", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        // Identity response
        drawArrow(svg, columnX[0], startY, columnX[1], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Response/Identity", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        // RADIUS Access-Request
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#dc3545");
        drawFlowLabel(svg, "RADIUS Access-Request", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // EAP challenge (multiple rounds)
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#dc3545");
        drawFlowLabel(svg, "Access-Challenge", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[1], startY, columnX[0], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Request (Challenge)", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[0], startY, columnX[1], startY, "#0077cc");
        drawFlowLabel(svg, "EAP-Response", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#dc3545");
        drawFlowLabel(svg, "RADIUS Access-Request", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // Success scenario
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#28a745");
        drawFlowLabel(svg, "Access-Accept + VLAN, ACL, etc.", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        drawArrow(svg, columnX[1], startY, columnX[0], startY, "#28a745");
        drawFlowLabel(svg, "EAP-Success", (columnX[0] + columnX[1]) / 2, startY - 10);
        startY += stepHeight;
    }
    
    // Add MAB flow if applicable
    if (settings.authMethod === 'mab' || settings.authMethod === 'dot1x-mab' || 
        settings.authMethod === 'dot1x-mab-webauth') {
        
        if (settings.authMethod !== 'mab') {
            // Add fallback text
            const fallbackText = document.createElementNS("http://www.w3.org/2000/svg", "text");
            fallbackText.setAttribute("x", "400");
            fallbackText.setAttribute("y", startY + 10);
            fallbackText.setAttribute("text-anchor", "middle");
            fallbackText.setAttribute("font-family", "Arial, sans-serif");
            fallbackText.setAttribute("font-size", "14");
            fallbackText.setAttribute("font-style", "italic");
            fallbackText.setAttribute("fill", "#666");
            fallbackText.textContent = "If 802.1X fails or times out, MAB occurs:";
            svg.appendChild(fallbackText);
            startY += 30;
        }
        
        // MAC address capture
        drawArrow(svg, columnX[1], startY, columnX[1] - 50, startY, "#f8bd1c");
        drawArrow(svg, columnX[1] - 50, startY, columnX[1], startY + 10, "#f8bd1c");
        drawFlowLabel(svg, "Capture MAC Address", columnX[1] - 80, startY - 10);
        startY += stepHeight;
        
        // RADIUS MAB request
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#f8bd1c");
        drawFlowLabel(svg, "RADIUS Access-Request (MAC as username/password)", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // MAB success
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#28a745");
        drawFlowLabel(svg, "Access-Accept + VLAN, ACL, etc.", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
    }
    
    // Add CoA if enabled
    if (settings.useCoa) {
        // Add CoA information
        const coaText = document.createElementNS("http://www.w3.org/2000/svg", "text");
        coaText.setAttribute("x", "400");
        coaText.setAttribute("y", startY + 10);
        coaText.setAttribute("text-anchor", "middle");
        coaText.setAttribute("font-family", "Arial, sans-serif");
        coaText.setAttribute("font-size", "14");
        coaText.setAttribute("font-style", "italic");
        coaText.setAttribute("fill", "#666");
        coaText.textContent = "Later, if policies change:";
        svg.appendChild(coaText);
        startY += 30;
        
        // CoA Request
        drawArrow(svg, columnX[2], startY, columnX[1], startY, "#e83e8c");
        drawFlowLabel(svg, "RADIUS CoA-Request", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
        
        // CoA ACK
        drawArrow(svg, columnX[1], startY, columnX[2], startY, "#e83e8c");
        drawFlowLabel(svg, "RADIUS CoA-ACK", (columnX[1] + columnX[2]) / 2, startY - 10);
        startY += stepHeight;
    }
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "authentication-flow");
}

// Generate Deployment Architecture Diagram
function generateDeploymentArchitectureDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "600");
    svg.setAttribute("viewBox", "0 0 800 600");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "802.1X Deployment Architecture";
    svg.appendChild(title);
    
    // Add subtitle
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = `${settings.vendor.toUpperCase()} ${settings.platform.toUpperCase()} with ${getAuthMethodName(settings.authMethod)}`;
    svg.appendChild(subtitle);
    
    // Draw network components
    
    // Core Network (cloud)
    drawCloud(svg, 400, 120, 200, 80, "Core Network");
    
    // Distribution switches
    drawNetworkSwitch(svg, 250, 220, { label: "Distribution Switch" });
    drawNetworkSwitch(svg, 550, 220, { label: "Distribution Switch" });
    
    // Connect core to distribution
    drawConnection(svg, 250, 220, 400, 120, "#333", "Trunk");
    drawConnection(svg, 550, 220, 400, 120, "#333", "Trunk");
    
    // Access switches (multiple)
    drawNetworkSwitch(svg, 150, 320, { label: "Access Switch", small: true });
    drawNetworkSwitch(svg, 350, 320, { label: "Access Switch", small: true });
    drawNetworkSwitch(svg, 450, 320, { label: "Access Switch", small: true });
    drawNetworkSwitch(svg, 650, 320, { label: "Access Switch", small: true });
    
    // Connect distribution to access
    drawConnection(svg, 150, 320, 250, 220, "#333", "Trunk");
    drawConnection(svg, 350, 320, 250, 220, "#333", "Trunk");
    drawConnection(svg, 450, 320, 550, 220, "#333", "Trunk");
    drawConnection(svg, 650, 320, 550, 220, "#333", "Trunk");
    
    // RADIUS Servers
    drawRadiusServer(svg, 300, 120, settings.radiusServer, "Primary RADIUS");
    if (settings.secondaryServer) {
        drawRadiusServer(svg, 500, 120, settings.secondaryServer, "Secondary RADIUS");
    }
    
    // Connect switches to RADIUS
    drawConnection(svg, 250, 220, 300, 120, "#dc3545", settings.useRadSec ? "RadSec" : "RADIUS");
    drawConnection(svg, 550, 220, 300, 120, "#dc3545", settings.useRadSec ? "RadSec" : "RADIUS");
    if (settings.secondaryServer) {
        drawConnection(svg, 250, 220, 500, 120, "#dc3545", "Failover", true);
        drawConnection(svg, 550, 220, 500, 120, "#dc3545", "Failover", true);
    }
    
    // End devices (multiple clients)
    // Row 1
    drawClientDevice(svg, 100, 420, "PC", "standard");
    drawClientDevice(svg, 150, 420, "Laptop", "laptop");
    drawClientDevice(svg, 200, 420, "Phone", "phone");
    // Row 2
    drawClientDevice(svg, 300, 420, "PC", "standard");
    drawClientDevice(svg, 350, 420, "Printer", "printer");
    drawClientDevice(svg, 400, 420, "Phone", "phone");
    // Row 3
    drawClientDevice(svg, 400, 420, "PC", "standard");
    drawClientDevice(svg, 450, 420, "Laptop", "laptop");
    drawClientDevice(svg, 500, 420, "Phone", "phone");
    // Row 4
    drawClientDevice(svg, 600, 420, "PC", "standard");
    drawClientDevice(svg, 650, 420, "IoT Device", "iot");
    drawClientDevice(svg, 700, 420, "Phone", "phone");
    
    // Connect clients to access switches
    drawConnection(svg, 100, 420, 150, 320, "#0077cc", "802.1X");
    drawConnection(svg, 150, 420, 150, 320, "#0077cc", "802.1X");
    drawConnection(svg, 200, 420, 150, 320, "#28a745", "802.1X (Voice)");
    
    drawConnection(svg, 300, 420, 350, 320, "#0077cc", "802.1X");
    drawConnection(svg, 350, 420, 350, 320, "#f8bd1c", "MAB");
    drawConnection(svg, 400, 420, 350, 320, "#28a745", "802.1X (Voice)");
    
    drawConnection(svg, 400, 420, 450, 320, "#0077cc", "802.1X");
    drawConnection(svg, 450, 420, 450, 320, "#0077cc", "802.1X");
    drawConnection(svg, 500, 420, 450, 320, "#28a745", "802.1X (Voice)");
    
    drawConnection(svg, 600, 420, 650, 320, "#0077cc", "802.1X");
    drawConnection(svg, 650, 420, 650, 320, "#f8bd1c", "MAB");
    drawConnection(svg, 700, 420, 650, 320, "#28a745", "802.1X (Voice)");
    
    // Add VLANs information
    const vlansInfo = document.createElementNS("http://www.w3.org/2000/svg", "text");
    vlansInfo.setAttribute("x", "400");
    vlansInfo.setAttribute("y", "520");
    vlansInfo.setAttribute("text-anchor", "middle");
    vlansInfo.setAttribute("font-family", "Arial, sans-serif");
    vlansInfo.setAttribute("font-size", "14");
    vlansInfo.setAttribute("fill", "#333");
    vlansInfo.textContent = `VLANs: Auth=${settings.vlanAuth || 'N/A'}, Unauth=${settings.vlanUnauth || 'N/A'}, Guest=${settings.vlanGuest || 'N/A'}, Voice=${settings.vlanVoice || 'N/A'}`;
    svg.appendChild(vlansInfo);
    
    // Draw legend
    drawLegend(svg, 50, 550);
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "deployment-architecture");
}

// Generate RADIUS Communication Diagram
function generateRadiusCommunicationDiagram(container, settings) {
    // Create SVG canvas for the diagram
    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("width", "100%");
    svg.setAttribute("height", "600");
    svg.setAttribute("viewBox", "0 0 800 600");
    svg.style.border = "1px solid #ddd";
    svg.style.borderRadius = "4px";
    svg.style.backgroundColor = "#f9f9f9";
    
    // Add title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", "400");
    title.setAttribute("y", "30");
    title.setAttribute("text-anchor", "middle");
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "20");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#1a3a5f");
    title.textContent = "RADIUS Communication";
    svg.appendChild(title);
    
    // Add subtitle
    const subtitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    subtitle.setAttribute("x", "400");
    subtitle.setAttribute("y", "55");
    subtitle.setAttribute("text-anchor", "middle");
    subtitle.setAttribute("font-family", "Arial, sans-serif");
    subtitle.setAttribute("font-size", "14");
    subtitle.setAttribute("fill", "#666");
    subtitle.textContent = settings.useRadSec ? "Using RadSec (RADIUS over TLS)" : "Standard RADIUS Protocol";
    svg.appendChild(subtitle);
    
    // Draw network components
    
    // Switch
    drawNetworkSwitch(svg, 200, 250, settings);
    
    // RADIUS Server
    drawRadiusServer(svg, 600, 250, settings.radiusServer, "RADIUS Server");
    
    // Draw protocol details
    
    // Authentication
    drawArrow(svg, 200, 200, 600, 200, "#dc3545");
    drawPacketLabel(svg, "Access-Request", 400, 180, "#dc3545");
    drawPacketDetails(svg, "Username, Password, NAS-IP, Called-Station-ID", 400, 195);
    
    drawArrow(svg, 600, 230, 200, 230, "#28a745");
    drawPacketLabel(svg, "Access-Accept", 400, 210, "#28a745");
    drawPacketDetails(svg, "Tunnel-Type=VLAN, Tunnel-Medium-Type=802, Tunnel-Private-Group-ID=" + (settings.vlanAuth || "100"), 400, 225);
    
    // Accounting (if enabled)
    if (settings.enableAccounting) {
        drawArrow(svg, 200, 280, 600, 280, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Request (Start)", 400, 260, "#17a2b8");
        drawPacketDetails(svg, "Acct-Status-Type=Start, User-Name, Framed-IP-Address", 400, 275);
        
        drawArrow(svg, 600, 310, 200, 310, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Response", 400, 290, "#17a2b8");
        
        drawArrow(svg, 200, 350, 600, 350, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Request (Interim)", 400, 330, "#17a2b8");
        drawPacketDetails(svg, "Acct-Status-Type=Interim, Acct-Input-Octets, Acct-Output-Octets", 400, 345);
        
        drawArrow(svg, 600, 380, 200, 380, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Response", 400, 360, "#17a2b8");
        
        drawArrow(svg, 200, 420, 600, 420, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Request (Stop)", 400, 400, "#17a2b8");
        drawPacketDetails(svg, "Acct-Status-Type=Stop, Acct-Input-Octets, Acct-Output-Octets", 400, 415);
        
        drawArrow(svg, 600, 450, 200, 450, "#17a2b8");
        drawPacketLabel(svg, "Accounting-Response", 400, 430, "#17a2b8");
    }
    
    // CoA (if enabled)
    if (settings.useCoa) {
        drawArrow(svg, 600, 500, 200, 500, "#e83e8c");
        drawPacketLabel(svg, "CoA-Request", 400, 480, "#e83e8c");
        drawPacketDetails(svg, "User-Name, Class, Filter-Id", 400, 495);
        
        drawArrow(svg, 200, 530, 600, 530, "#e83e8c");
        drawPacketLabel(svg, "CoA-ACK", 400, 510, "#e83e8c");
    }
    
    // Add protocol information
    const protocolInfo = document.createElementNS("http://www.w3.org/2000/svg", "text");
    protocolInfo.setAttribute("x", "400");
    protocolInfo.setAttribute("y", "560");
    protocolInfo.setAttribute("text-anchor", "middle");
    protocolInfo.setAttribute("font-family", "Arial, sans-serif");
    protocolInfo.setAttribute("font-size", "12");
    protocolInfo.setAttribute("fill", "#666");
    
    if (settings.useRadSec) {
        protocolInfo.textContent = `RadSec: Port ${settings.radsecPort || 2083}, TLS-encrypted RADIUS traffic`;
    } else {
        protocolInfo.textContent = `RADIUS: Auth Port ${settings.radiusAuthPort || 1812}, Acct Port ${settings.radiusAcctPort || 1813}, Shared Secret Authentication`;
    }
    
    svg.appendChild(protocolInfo);
    
    // Add diagram to container
    container.innerHTML = '';
    container.appendChild(svg);
    
    // Add download button
    addDownloadButton(container, svg, "radius-communication");
}

// Drawing helper functions

// Draw RADIUS server
function drawRadiusServer(svg, x, y, label, title) {
    // Server box
    const server = document.createElementNS("http://www.w3.org/2000/svg", "rect");
    server.setAttribute("x", x - 50);
    server.setAttribute("y", y - 40);
    server.setAttribute("width", 100);
    server.setAttribute("height", 80);
    server.setAttribute("rx", 5);
    server.setAttribute("ry", 5);
    server.setAttribute("fill", "#f8f9fa");
    server.setAttribute("stroke", "#dc3545");
    server.setAttribute("stroke-width", 2);
    svg.appendChild(server);
    
    // Server details
    const serverLines = document.createElementNS("http://www.w3.org/2000/svg", "g");
    for (let i = 0; i < 4; i++) {
        const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
        line.setAttribute("x1", x - 40);
        line.setAttribute("y1", y - 25 + (i * 15));
        line.setAttribute("x2", x + 40);
        line.setAttribute("y2", y - 25 + (i * 15));
        line.setAttribute("stroke", "#dc3545");
        line.setAttribute("stroke-width", 1);
        line.setAttribute("stroke-opacity", "0.5");
        serverLines.appendChild(line);
    }
    svg.appendChild(serverLines);
    
    // Server IP text
    const serverIP = document.createElementNS("http://www.w3.org/2000/svg", "text");
    serverIP.setAttribute("x", x);
    serverIP.setAttribute("y", y + 20);
    serverIP.setAttribute("text-anchor", "middle");
    serverIP.setAttribute("font-family", "Arial, sans-serif");
    serverIP.setAttribute("font-size", "12");
    serverIP.setAttribute("fill", "#333");
    serverIP.textContent = label || "RADIUS Server";
    svg.appendChild(serverIP);
    
    // Server title
    const serverTitle = document.createElementNS("http://www.w3.org/2000/svg", "text");
    serverTitle.setAttribute("x", x);
    serverTitle.setAttribute("y", y - 50);
    serverTitle.setAttribute("text-anchor", "middle");
    serverTitle.setAttribute("font-family", "Arial, sans-serif");
    serverTitle.setAttribute("font-size", "12");
    serverTitle.setAttribute("fill", "#333");
    serverTitle.textContent = title || "RADIUS Server";
    svg.appendChild(serverTitle);
}

// Draw network switch
function drawNetworkSwitch(svg, x, y, settings) {
    // Default size
    const width = settings.small ? 80 : 100;
    const height = settings.small ? 40 : 50;
    
    // Switch box
    const switchBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
    switchBox.setAttribute("x", x - width/2);
    switchBox.setAttribute("y", y - height/2);
    switchBox.setAttribute("width", width);
    switchBox.setAttribute("height", height);
    switchBox.setAttribute("rx", 3);
    switchBox.setAttribute("ry", 3);
    switchBox.setAttribute("fill", "#f8f9fa");
    switchBox.setAttribute("stroke", "#0077cc");
    switchBox.setAttribute("stroke-width", 2);
    svg.appendChild(switchBox);
    
    // Switch ports
    const portsGroup = document.createElementNS("http://www.w3.org/2000/svg", "g");
    const portCount = settings.small ? 6 : 8;
    const portWidth = (width - 20) / portCount;
    
    for (let i = 0; i < portCount; i++) {
        const port = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        port.setAttribute("x", (x - width/2 + 10) + (i * portWidth));
        port.setAttribute("y", y - height/2 + 10);
        port.setAttribute("width", portWidth - 2);
        port.setAttribute("height", 10);
        port.setAttribute("fill", "#333");
        port.setAttribute("rx", 1);
        port.setAttribute("ry", 1);
        portsGroup.appendChild(port);
    }
    svg.appendChild(portsGroup);
    
    // Switch label
    const switchLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
    switchLabel.setAttribute("x", x);
    switchLabel.setAttribute("y", y + 5);
    switchLabel.setAttribute("text-anchor", "middle");
    switchLabel.setAttribute("font-family", "Arial, sans-serif");
    switchLabel.setAttribute("font-size", settings.small ? "10" : "12");
    switchLabel.setAttribute("fill", "#333");
    switchLabel.textContent = settings.label || settings.vendor || "Network Switch";
    svg.appendChild(switchLabel);
}

// Draw client device
function drawClientDevice(svg, x, y, label, type) {
    let deviceShape;
    
    switch (type) {
        case "laptop":
            // Laptop shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "path");
            deviceShape.setAttribute("d", `M${x-20},${y-10} L${x+20},${y-10} L${x+25},${y+10} L${x-25},${y+10} Z`);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#333");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Screen
            const laptopScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            laptopScreen.setAttribute("x", x - 15);
            laptopScreen.setAttribute("y", y - 8);
            laptopScreen.setAttribute("width", 30);
            laptopScreen.setAttribute("height", 15);
            laptopScreen.setAttribute("fill", "#0077cc");
            laptopScreen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(laptopScreen);
            break;
            
        case "phone":
            // Phone shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 8);
            deviceShape.setAttribute("y", y - 15);
            deviceShape.setAttribute("width", 16);
            deviceShape.setAttribute("height", 30);
            deviceShape.setAttribute("rx", 3);
            deviceShape.setAttribute("ry", 3);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#28a745");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Screen
            const phoneScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            phoneScreen.setAttribute("x", x - 5);
            phoneScreen.setAttribute("y", y - 12);
            phoneScreen.setAttribute("width", 10);
            phoneScreen.setAttribute("height", 20);
            phoneScreen.setAttribute("fill", "#28a745");
            phoneScreen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(phoneScreen);
            
            // Home button
            const homeButton = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            homeButton.setAttribute("cx", x);
            homeButton.setAttribute("cy", y + 10);
            homeButton.setAttribute("r", 2);
            homeButton.setAttribute("fill", "#333");
            svg.appendChild(homeButton);
            break;
            
        case "printer":
            // Printer shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 15);
            deviceShape.setAttribute("y", y - 10);
            deviceShape.setAttribute("width", 30);
            deviceShape.setAttribute("height", 20);
            deviceShape.setAttribute("rx", 2);
            deviceShape.setAttribute("ry", 2);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#f8bd1c");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Paper tray
            const paperTray = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            paperTray.setAttribute("x", x - 10);
            paperTray.setAttribute("y", y - 15);
            paperTray.setAttribute("width", 20);
            paperTray.setAttribute("height", 5);
            paperTray.setAttribute("fill", "#f8f9fa");
            paperTray.setAttribute("stroke", "#f8bd1c");
            paperTray.setAttribute("stroke-width", 1.5);
            svg.appendChild(paperTray);
            
            // Control panel
            const controlPanel = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            controlPanel.setAttribute("x", x - 5);
            controlPanel.setAttribute("y", y - 5);
            controlPanel.setAttribute("width", 10);
            controlPanel.setAttribute("height", 5);
            controlPanel.setAttribute("fill", "#f8bd1c");
            controlPanel.setAttribute("fill-opacity", "0.2");
            svg.appendChild(controlPanel);
            break;
            
        case "iot":
            // IoT device (circular)
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "circle");
            deviceShape.setAttribute("cx", x);
            deviceShape.setAttribute("cy", y);
            deviceShape.setAttribute("r", 15);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#e83e8c");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // IoT indicators
            for (let i = 0; i < 3; i++) {
                const indicator = document.createElementNS("http://www.w3.org/2000/svg", "circle");
                indicator.setAttribute("cx", x + (i * 5) - 5);
                indicator.setAttribute("cy", y - 5);
                indicator.setAttribute("r", 2);
                indicator.setAttribute("fill", "#e83e8c");
                svg.appendChild(indicator);
            }
            break;
            
        case "light":
            // Light client (transparent)
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 15);
            deviceShape.setAttribute("y", y - 15);
            deviceShape.setAttribute("width", 30);
            deviceShape.setAttribute("height", 30);
            deviceShape.setAttribute("rx", 3);
            deviceShape.setAttribute("ry", 3);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#999");
            deviceShape.setAttribute("stroke-width", 1);
            deviceShape.setAttribute("stroke-dasharray", "3,3");
            svg.appendChild(deviceShape);
            
            // Screen
            const lightScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            lightScreen.setAttribute("x", x - 10);
            lightScreen.setAttribute("y", y - 8);
            lightScreen.setAttribute("width", 20);
            lightScreen.setAttribute("height", 16);
            lightScreen.setAttribute("fill", "#999");
            lightScreen.setAttribute("fill-opacity", "0.1");
            svg.appendChild(lightScreen);
            break;
            
        case "standard":
        default:
            // Default PC shape
            deviceShape = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            deviceShape.setAttribute("x", x - 15);
            deviceShape.setAttribute("y", y - 15);
            deviceShape.setAttribute("width", 30);
            deviceShape.setAttribute("height", 30);
            deviceShape.setAttribute("rx", 3);
            deviceShape.setAttribute("ry", 3);
            deviceShape.setAttribute("fill", "#f8f9fa");
            deviceShape.setAttribute("stroke", "#0077cc");
            deviceShape.setAttribute("stroke-width", 1.5);
            svg.appendChild(deviceShape);
            
            // Screen
            const screen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            screen.setAttribute("x", x - 10);
            screen.setAttribute("y", y - 10);
            screen.setAttribute("width", 20);
            screen.setAttribute("height", 16);
            screen.setAttribute("fill", "#0077cc");
            screen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(screen);
            
            // Base
            const base = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            base.setAttribute("x", x - 5);
            base.setAttribute("y", y + 6);
            base.setAttribute("width", 10);
            base.setAttribute("height", 4);
            base.setAttribute("fill", "#0077cc");
            base.setAttribute("fill-opacity", "0.3");
            svg.appendChild(base);
    }
    
    // Device label
    const deviceLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
    deviceLabel.setAttribute("x", x);
    deviceLabel.setAttribute("y", y + 30);
    deviceLabel.setAttribute("text-anchor", "middle");
    deviceLabel.setAttribute("font-family", "Arial, sans-serif");
    deviceLabel.setAttribute("font-size", "10");
    deviceLabel.setAttribute("fill", "#333");
    deviceLabel.textContent = label || "Client";
    svg.appendChild(deviceLabel);
}

// Draw connection between components
function drawConnection(svg, x1, y1, x2, y2, color, label, dashed = false) {
    // Connection line
    const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
    line.setAttribute("x1", x1);
    line.setAttribute("y1", y1);
    line.setAttribute("x2", x2);
    line.setAttribute("y2", y2);
    line.setAttribute("stroke", color || "#333");
    line.setAttribute("stroke-width", 2);
    if (dashed) {
        line.setAttribute("stroke-dasharray", "5,5");
    }
    svg.appendChild(line);
    
    // Connection label if provided
    if (label) {
        const text = document.createElementNS("http://www.w3.org/2000/svg", "text");
        const midX = (x1 + x2) / 2;
        const midY = (y1 + y2) / 2;
        
        // Calculate angle for text rotation
        const angle = Math.atan2(y2 - y1, x2 - x1) * 180 / Math.PI;
        
        text.setAttribute("x", midX);
        text.setAttribute("y", midY);
        text.setAttribute("dy", "-5");
        text.setAttribute("text-anchor", "middle");
        text.setAttribute("font-family", "Arial, sans-serif");
        text.setAttribute("font-size", "10");
        text.setAttribute("fill", color || "#333");
        
        // Adjust text rotation for readability
        let adjustedAngle = angle;
        if (angle > 90 || angle < -90) {
            adjustedAngle = angle + 180;
        }
        
        // Only rotate if the line isn't mostly horizontal
        if (Math.abs(angle) > 15 && Math.abs(angle) < 165) {
            text.setAttribute("transform", `rotate(${adjustedAngle}, ${midX}, ${midY})`);
        }
        
        text.textContent = label;
        svg.appendChild(text);
    }
}

// Draw arrow for flow diagrams
function drawArrow(svg, x1, y1, x2, y2, color) {
    // Main line
    const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
    line.setAttribute("x1", x1);
    line.setAttribute("y1", y1);
    line.setAttribute("x2", x2);
    line.setAttribute("y2", y2);
    line.setAttribute("stroke", color || "#333");
    line.setAttribute("stroke-width", 2);
    svg.appendChild(line);
    
    // Arrow head
    const arrowSize = 6;
    const dx = x2 - x1;
    const dy = y2 - y1;
    const angle = Math.atan2(dy, dx);
    
    const arrowHead = document.createElementNS("http://www.w3.org/2000/svg", "polygon");
    const x3 = x2 - arrowSize * Math.cos(angle - Math.PI / 6);
    const y3 = y2 - arrowSize * Math.sin(angle - Math.PI / 6);
    const x4 = x2 - arrowSize * Math.cos(angle + Math.PI / 6);
    const y4 = y2 - arrowSize * Math.sin(angle + Math.PI / 6);
    
    arrowHead.setAttribute("points", `${x2},${y2} ${x3},${y3} ${x4},${y4}`);
    arrowHead.setAttribute("fill", color || "#333");
    svg.appendChild(arrowHead);
}

// Draw cloud shape
function drawCloud(svg, x, y, width, height, label) {
    // Cloud path
    const cloudPath = document.createElementNS("http://www.w3.org/2000/svg", "path");
    const halfWidth = width / 2;
    const halfHeight = height / 2;
    
    const path = `
        M${x - halfWidth * 0.8},${y}
        C${x - halfWidth * 0.8},${y - halfHeight * 0.6}
        ${x - halfWidth * 0.4},${y - halfHeight}
        ${x},${y - halfHeight * 0.7}
        C${x + halfWidth * 0.4},${y - halfHeight}
        ${x + halfWidth * 0.8},${y - halfHeight * 0.8}
        ${x + halfWidth * 0.8},${y}
        C${x + halfWidth * 0.8},${y + halfHeight * 0.6}
        ${x + halfWidth * 0.4},${y + halfHeight}
        ${x},${y + halfHeight * 0.7}
        C${x - halfWidth * 0.4},${y + halfHeight}
        ${x - halfWidth * 0.8},${y + halfHeight * 0.6}
        ${x - halfWidth * 0.8},${y}
        Z
    `;
    
    cloudPath.setAttribute("d", path);
    cloudPath.setAttribute("fill", "#f8f9fa");
    cloudPath.setAttribute("stroke", "#333");
    cloudPath.setAttribute("stroke-width", 2);
    svg.appendChild(cloudPath);
    
    // Cloud label
    const cloudLabel = document.createElementNS("http://www.w3.org/2000/svg", "text");
    cloudLabel.setAttribute("x", x);
    cloudLabel.setAttribute("y", y + 5);
    cloudLabel.setAttribute("text-anchor", "middle");
    cloudLabel.setAttribute("font-family", "Arial, sans-serif");
    cloudLabel.setAttribute("font-size", "14");
    cloudLabel.setAttribute("fill", "#333");
    cloudLabel.textContent = label || "Cloud";
    svg.appendChild(cloudLabel);
}

// Draw icon in the flow diagram
function drawIcon(svg, x, y, type) {
    switch (type) {
        case "laptop":
            // Laptop icon
            const laptop = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            laptop.setAttribute("x", x - 15);
            laptop.setAttribute("y", y - 10);
            laptop.setAttribute("width", 30);
            laptop.setAttribute("height", 20);
            laptop.setAttribute("rx", 2);
            laptop.setAttribute("fill", "#f8f9fa");
            laptop.setAttribute("stroke", "#0077cc");
            laptop.setAttribute("stroke-width", 1.5);
            svg.appendChild(laptop);
            
            // Screen
            const laptopScreen = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            laptopScreen.setAttribute("x", x - 12);
            laptopScreen.setAttribute("y", y - 8);
            laptopScreen.setAttribute("width", 24);
            laptopScreen.setAttribute("height", 16);
            laptopScreen.setAttribute("fill", "#0077cc");
            laptopScreen.setAttribute("fill-opacity", "0.2");
            svg.appendChild(laptopScreen);
            break;
            
        case "switch":
            // Switch icon
            const switchBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            switchBox.setAttribute("x", x - 20);
            switchBox.setAttribute("y", y - 10);
            switchBox.setAttribute("width", 40);
            switchBox.setAttribute("height", 20);
            switchBox.setAttribute("rx", 2);
            switchBox.setAttribute("fill", "#f8f9fa");
            switchBox.setAttribute("stroke", "#0077cc");
            switchBox.setAttribute("stroke-width", 1.5);
            svg.appendChild(switchBox);
            
            // Ports
            for (let i = 0; i < 5; i++) {
                const port = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                port.setAttribute("x", x - 15 + (i * 7));
                port.setAttribute("y", y - 5);
                port.setAttribute("width", 5);
                port.setAttribute("height", 3);
                port.setAttribute("fill", "#0077cc");
                svg.appendChild(port);
                
                const port2 = document.createElementNS("http://www.w3.org/2000/svg", "rect");
                port2.setAttribute("x", x - 15 + (i * 7));
                port2.setAttribute("y", y + 2);
                port2.setAttribute("width", 5);
                port2.setAttribute("height", 3);
                port2.setAttribute("fill", "#0077cc");
                svg.appendChild(port2);
            }
            break;
            
        case "server":
            // Server icon
            const server = document.createElementNS("http://www.w3.org/2000/svg", "rect");
            server.setAttribute("x", x - 20);
            server.setAttribute("y", y - 15);
            server.setAttribute("width", 40);
            server.setAttribute("height", 30);
            server.setAttribute("rx", 2);
            server.setAttribute("fill", "#f8f9fa");
            server.setAttribute("stroke", "#dc3545");
            server.setAttribute("stroke-width", 1.5);
            svg.appendChild(server);
            
            // Server details
            for (let i = 0; i < 3; i++) {
                const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
                line.setAttribute("x1", x - 15);
                line.setAttribute("y1", y - 10 + (i * 10));
                line.setAttribute("x2", x + 15);
                line.setAttribute("y2", y - 10 + (i * 10));
                line.setAttribute("stroke", "#dc3545");
                line.setAttribute("stroke-width", 1);
                svg.appendChild(line);
            }
            break;
    }
}

// Draw flow label (protocol or message type)
function drawFlowLabel(svg, text, x, y) {
    const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
    label.setAttribute("x", x);
    label.setAttribute("y", y);
    label.setAttribute("text-anchor", "middle");
    label.setAttribute("font-family", "Arial, sans-serif");
    label.setAttribute("font-size", "12");
    label.setAttribute("font-weight", "bold");
    label.setAttribute("fill", "#333");
    label.textContent = text;
    svg.appendChild(label);
}

// Draw packet details (attributes)
function drawPacketDetails(svg, text, x, y) {
    const details = document.createElementNS("http://www.w3.org/2000/svg", "text");
    details.setAttribute("x", x);
    details.setAttribute("y", y);
    details.setAttribute("text-anchor", "middle");
    details.setAttribute("font-family", "Arial, sans-serif");
    details.setAttribute("font-size", "10");
    details.setAttribute("font-style", "italic");
    details.setAttribute("fill", "#666");
    details.textContent = text;
    svg.appendChild(details);
}

// Draw packet label (protocol message type)
function drawPacketLabel(svg, text, x, y, color) {
    const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
    label.setAttribute("x", x);
    label.setAttribute("y", y);
    label.setAttribute("text-anchor", "middle");
    label.setAttribute("font-family", "Arial, sans-serif");
    label.setAttribute("font-size", "12");
    label.setAttribute("font-weight", "bold");
    label.setAttribute("fill", color || "#333");
    label.textContent = text;
    svg.appendChild(label);
}

// Draw legend
function drawLegend(svg, x, y) {
    // Legend box
    const legendBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
    legendBox.setAttribute("x", x);
    legendBox.setAttribute("y", y);
    legendBox.setAttribute("width", 300);
    legendBox.setAttribute("height", 80);
    legendBox.setAttribute("rx", 5);
    legendBox.setAttribute("fill", "white");
    legendBox.setAttribute("fill-opacity", "0.9");
    legendBox.setAttribute("stroke", "#ddd");
    legendBox.setAttribute("stroke-width", 1);
    svg.appendChild(legendBox);
    
    // Legend title
    const title = document.createElementNS("http://www.w3.org/2000/svg", "text");
    title.setAttribute("x", x + 10);
    title.setAttribute("y", y + 20);
    title.setAttribute("font-family", "Arial, sans-serif");
    title.setAttribute("font-size", "12");
    title.setAttribute("font-weight", "bold");
    title.setAttribute("fill", "#333");
    title.textContent = "Legend";
    svg.appendChild(title);
    
    // Legend items
    const items = [
        { color: "#0077cc", label: "802.1X Authentication" },
        { color: "#f8bd1c", label: "MAC Authentication Bypass" },
        { color: "#dc3545", label: "RADIUS Communication" },
        { color: "#28a745", label: "Voice VLAN" }
    ];
    
    items.forEach((item, index) => {
        // Item color box
        const colorBox = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        colorBox.setAttribute("x", x + 10 + (index % 2) * 150);
        colorBox.setAttribute("y", y + 30 + Math.floor(index / 2) * 20);
        colorBox.setAttribute("width", 12);
        colorBox.setAttribute("height", 12);
        colorBox.setAttribute("fill", item.color);
        svg.appendChild(colorBox);
        
        // Item label
        const label = document.createElementNS("http://www.w3.org/2000/svg", "text");
        label.setAttribute("x", x + 30 + (index % 2) * 150);
        label.setAttribute("y", y + 40 + Math.floor(index / 2) * 20);
        label.setAttribute("font-family", "Arial, sans-serif");
        label.setAttribute("font-size", "10");
        label.setAttribute("fill", "#333");
        label.textContent = item.label;
        svg.appendChild(label);
    });
}

// Add download button for the diagram
function addDownloadButton(container, svg, filename) {
    // Create download button
    const downloadButton = document.createElement('button');
    downloadButton.className = 'btn';
    downloadButton.innerHTML = 'Download Diagram';
    downloadButton.style.marginTop = '10px';
    
    // Add click handler
    downloadButton.addEventListener('click', () => {
        // Convert SVG to a data URL
        const svgData = new XMLSerializer().serializeToString(svg);
        const svgBlob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' });
        const url = URL.createObjectURL(svgBlob);
        
        // Create download link
        const link = document.createElement('a');
        link.href = url;
        link.download = `${filename}-diagram.svg`;
        link.click();
        
        // Clean up
        URL.revokeObjectURL(url);
    });
    
    // Add button to container
    container.appendChild(downloadButton);
}

// Helper function for checkbox values
function getCheckboxValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.checked : defaultValue;
}

// Helper function for input values
function getInputValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

// Helper function for select values
function getSelectValue(id, defaultValue) {
    const element = document.getElementById(id);
    return element ? element.value : defaultValue;
}

// Helper function for radio values
function getRadioValue(name, defaultValue) {
    const elements = document.getElementsByName(name);
    for (let i = 0; i < elements.length; i++) {
        if (elements[i].checked) {
            return elements[i].value;
        }
    }
    return defaultValue;
}

// Helper function to get authentication method name
function getAuthMethodName(method) {
    switch (method) {
        case 'dot1x':
            return '802.1X Authentication Only';
        case 'mab':
            return 'MAC Authentication Bypass Only';
        case 'dot1x-mab':
            return '802.1X with MAB Fallback';
        case 'concurrent':
            return '802.1X and MAB Concurrent';
        case 'dot1x-mab-webauth':
            return '802.1X + MAB + WebAuth';
        default:
            return '802.1X Authentication';
    }
}
