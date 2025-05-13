#!/bin/bash
# UaXSupreme Enhancement Script - Complete Version

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Check if we're in the right directory
if [ ! -f "index.html" ]; then
  print_error "This script must be run from the UaXSupreme root directory"
fi

# Create directory structure if it doesn't exist
print_message "Creating directory structure..."
mkdir -p css js data/cisco/vsa data/templates assets/images

# Create banner logo animation 
print_message "Creating animated logo for application banner..."

# Create a placeholder svg logo for use until the canvas animated logo kicks in
cat > assets/images/logo-placeholder.svg << 'EOF'
<svg xmlns="http://www.w3.org/2000/svg" width="300" height="70" viewBox="0 0 300 70">
  <rect width="300" height="70" fill="#2c3e50"/>
  <text x="20" y="40" font-family="Arial" font-size="28" font-weight="bold" fill="#3498db">UaX</text>
  <text x="80" y="40" font-family="Arial" font-size="28" font-weight="bold" fill="#ecf0f1">Supreme</text>
  <circle cx="250" cy="35" r="20" fill="#27ae60"/>
  <path d="M240,35 L248,43 L260,30" stroke="white" stroke-width="3" fill="none"/>
</svg>
EOF

# Create the logo generator JavaScript
print_message "Creating logo generator script..."
cat > js/logo-generator.js << 'EOF'
/**
 * UaXSupreme - Logo Generator
 * Creates an animated logo for the application header
 */

(function() {
    'use strict';

    // Logo Generator object
    const LogoGenerator = {
        /**
         * Initialize Logo Generator
         */
        init: function() {
            console.log('Initializing Logo Generator...');
            this.setupLogo();
        },
        
        /**
         * Set up animated logo
         */
        setupLogo: function() {
            const logoCanvas = document.getElementById('logoCanvas');
            if (!logoCanvas) return;
            
            // Clear any previous content
            logoCanvas.innerHTML = '';
            
            // Create canvas element
            const canvas = document.createElement('canvas');
            canvas.width = 50;
            canvas.height = 50;
            logoCanvas.appendChild(canvas);
            
            // Get canvas context
            const ctx = canvas.getContext('2d');
            
            // Set up animation
            this.animateLogo(ctx, canvas.width, canvas.height);
        },
        
        /**
         * Animate the logo
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} width - Canvas width
         * @param {number} height - Canvas height
         */
        animateLogo: function(ctx, width, height) {
            const centerX = width / 2;
            const centerY = height / 2;
            const radius = Math.min(width, height) / 2 - 2;
            
            // Animation variables
            let rotation = 0;
            let locked = false;
            let lockAnimation = 0;
            
            // Animation function
            function animate() {
                // Clear canvas
                ctx.clearRect(0, 0, width, height);
                
                // Draw outer circle
                ctx.beginPath();
                ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
                ctx.fillStyle = '#3498db';
                ctx.fill();
                
                // Draw lock icon when animation completes
                if (locked) {
                    // Draw lock body
                    ctx.beginPath();
                    ctx.rect(centerX - 10, centerY - 5, 20, 15);
                    ctx.fillStyle = '#2c3e50';
                    ctx.fill();
                    
                    // Draw lock shackle
                    ctx.beginPath();
                    ctx.arc(centerX, centerY - 10, 8, Math.PI, Math.PI * 2);
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = '#2c3e50';
                    ctx.stroke();
                    
                    // Draw keyhole
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, 3, 0, Math.PI * 2);
                    ctx.fillStyle = '#3498db';
                    ctx.fill();
                    
                    // Continue lock appearing animation
                    lockAnimation += 0.05;
                    if (lockAnimation < 1) {
                        requestAnimationFrame(animate);
                    }
                    
                    // Apply fade-in effect
                    ctx.globalAlpha = lockAnimation;
                } else {
                    // Draw rotating shield segments
                    for (let i = 0; i < 4; i++) {
                        ctx.beginPath();
                        ctx.moveTo(centerX, centerY);
                        ctx.arc(centerX, centerY, radius, 
                              rotation + i * Math.PI / 2, 
                              rotation + i * Math.PI / 2 + Math.PI / 3);
                        ctx.closePath();
                        
                        // Alternate colors
                        ctx.fillStyle = i % 2 === 0 ? '#2c3e50' : '#2ecc71';
                        ctx.fill();
                    }
                    
                    // Update rotation
                    rotation += 0.05;
                    
                    // Check if animation should complete
                    if (rotation >= Math.PI * 6) {
                        locked = true;
                        lockAnimation = 0;
                    }
                    
                    // Continue rotation animation
                    requestAnimationFrame(animate);
                }
            }
            
            // Start animation
            animate();
        }
    };

    // Initialize Logo Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        LogoGenerator.init();
    });

    // Export to window
    window.LogoGenerator = LogoGenerator;
})();
EOF

# Create CSS styles
print_message "Creating CSS styles..."
cat > css/styles.css << 'EOF'
/* UaXSupreme Styles */
:root {
    --primary-color: #3498db;
    --primary-dark: #2980b9;
    --secondary-color: #2c3e50;
    --success-color: #2ecc71;
    --warning-color: #f39c12;
    --danger-color: #e74c3c;
    --light-color: #ecf0f1;
    --dark-color: #34495e;
    --gray-color: #95a5a6;
    --border-color: #ddd;
    --sidebar-width: 250px;
    --header-height: 70px;
}

* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    color: #333;
    background-color: #f5f7fa;
}

/* App Container */
.app-container {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}

/* Header */
header {
    background-color: var(--secondary-color);
    color: white;
    padding: 15px 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    height: var(--header-height);
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.logo {
    display: flex;
    flex-direction: column;
    position: relative;
}

.logo h1 {
    font-size: 24px;
    margin: 0;
}

.logo span {
    font-size: 14px;
    opacity: 0.8;
}

.logo-animation {
    position: absolute;
    top: 0;
    right: -60px;
    width: 50px;
    height: 50px;
}

.header-controls {
    display: flex;
    gap: 10px;
}

.btn-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background-color: rgba(255, 255, 255, 0.1);
    border: none;
    color: white;
    font-size: 18px;
    cursor: pointer;
    transition: background-color 0.3s;
    display: flex;
    align-items: center;
    justify-content: center;
}

.btn-icon:hover {
    background-color: rgba(255, 255, 255, 0.2);
}

/* Main Content */
.main-content {
    display: flex;
    flex: 1;
}

/* Sidebar */
.sidebar {
    width: var(--sidebar-width);
    background-color: var(--dark-color);
    color: white;
    display: flex;
    flex-direction: column;
}

.sidebar-header {
    padding: 15px;
    font-weight: bold;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    background-color: var(--secondary-color);
}

.nav-steps {
    list-style: none;
    flex: 1;
    overflow-y: auto;
}

.nav-steps li {
    padding: 12px 15px;
    cursor: pointer;
    border-left: 3px solid transparent;
    transition: all 0.3s;
    display: flex;
    align-items: center;
}

.nav-steps li i {
    margin-right: 10px;
    width: 20px;
    text-align: center;
}

.nav-steps li.active {
    background-color: rgba(255, 255, 255, 0.1);
    border-left-color: var(--primary-color);
}

.nav-steps li:hover {
    background-color: rgba(255, 255, 255, 0.05);
}

.sidebar-footer {
    padding: 15px;
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    display: flex;
    flex-direction: column;
    gap: 10px;
}

/* Content Area */
.content-area {
    flex: 1;
    padding: 20px;
    overflow-y: auto;
    overflow-x: hidden;
}

/* Config Sections */
.config-section {
    display: none;
    animation: fadeIn 0.3s;
}

.config-section.active {
    display: block;
}

.config-section h2 {
    margin-bottom: 20px;
    padding-bottom: 10px;
    border-bottom: 1px solid var(--border-color);
    color: var(--secondary-color);
}

.section-content {
    margin-bottom: 30px;
}

.section-footer {
    display: flex;
    justify-content: space-between;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid var(--border-color);
}

/* Forms */
.form-group {
    margin-bottom: 20px;
}

.form-row {
    display: flex;
    margin: 0 -10px;
}

.form-row .form-group {
    padding: 0 10px;
    flex: 1;
}

.col-md-6 {
    width: 50%;
}

.col-md-4 {
    width: 33.333333%;
}

label {
    display: block;
    margin-bottom: 5px;
    font-weight: 500;
}

.form-control {
    width: 100%;
    padding: 10px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    font-size: 14px;
}

select.form-control {
    height: 40px;
    background-color: white;
}

textarea.form-control {
    min-height: 100px;
}

.form-text {
    font-size: 12px;
    color: var(--gray-color);
    margin-top: 5px;
}

/* Password Field */
.password-field {
    position: relative;
}

.password-toggle {
    position: absolute;
    right: 10px;
    top: 50%;
    transform: translateY(-50%);
    cursor: pointer;
    color: var(--gray-color);
}

/* Checkbox and Radio Groups */
.checkbox-group, .radio-group {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
}

.checkbox-item, .radio-item {
    display: flex;
    align-items: center;
    min-width: 200px;
}

.checkbox-item input, .radio-item input {
    margin-right: 8px;
}

/* Buttons */
.btn-primary, .btn-secondary {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-weight: 500;
    transition: background-color 0.3s;
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.btn-primary {
    background-color: var(--primary-color);
    color: white;
}

.btn-primary:hover {
    background-color: var(--primary-dark);
}

.btn-secondary {
    background-color: var(--light-color);
    color: var(--secondary-color);
}

.btn-secondary:hover {
    background-color: #dde4e6;
}

.btn-next i, .btn-back i {
    font-size: 12px;
}

/* Tabs */
.tabs-container {
    margin-bottom: 30px;
}

.tabs {
    display: flex;
    border-bottom: 1px solid var(--border-color);
    margin-bottom: 20px;
    flex-wrap: wrap;
}

.tab {
    padding: 10px 20px;
    cursor: pointer;
    border-bottom: 2px solid transparent;
    transition: all 0.3s;
}

.tab.active {
    border-bottom-color: var(--primary-color);
    color: var(--primary-color);
    font-weight: 500;
}

.tab:hover:not(.active) {
    border-bottom-color: var(--gray-color);
}

.tab-content {
    display: none;
    animation: fadeIn 0.3s;
}

.tab-content.active {
    display: block;
}

/* Server Containers */
.server-container {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 20px;
}

.server-container h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Feature Info */
.feature-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.method-info-panel {
    display: none;
}

.method-info-panel.active {
    display: block;
    animation: fadeIn 0.3s;
}

.feature-info h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

.feature-info h4 {
    color: var(--primary-color);
    margin-bottom: 10px;
    font-size: 15px;
}

/* Feature Settings */
.feature-settings {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 15px;
    margin-bottom: 20px;
}

.feature-settings h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Security Features Info */
.security-features-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.security-feature-detail {
    margin-bottom: 20px;
}

.security-feature-detail:last-child {
    margin-bottom: 0;
}

.security-feature-detail h4 {
    color: var(--primary-color);
    margin-bottom: 10px;
    font-size: 15px;
}

/* Code Output */
.code-output {
    font-family: 'Courier New', Courier, monospace;
    background-color: #2c3e50;
    color: #ecf0f1;
    border: none;
    border-radius: 4px;
    padding: 15px;
    font-size: 14px;
    line-height: 1.5;
}

/* Action Buttons */
.action-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 15px;
}

/* Hidden Elements */
.hidden {
    display: none;
}

/* Animations */
@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

/* Template Buttons */
.template-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 10px;
}

/* Diagram Canvas */
.diagram-canvas {
    width: 100%;
    height: 400px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    background-color: white;
    margin-top: 15px;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.placeholder-text {
    color: var(--gray-color);
    text-align: center;
    padding: 20px;
}

/* Checklist Preview */
.checklist-preview, .troubleshooting-preview {
    background-color: white;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 15px;
    margin-bottom: 15px;
    min-height: 300px;
}

.checklist-item {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
    padding: 10px;
    border-radius: 4px;
    background-color: #f9f9f9;
}

.checklist-item input {
    margin-right: 10px;
}

/* Platform Info */
.platform-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.platform-info h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Deployment Info */
.deployment-info {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.deployment-info h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Config Validation */
.config-validation {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
}

.config-validation h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Modal */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.5);
    animation: fadeIn 0.3s;
}

.modal-content {
    background-color: white;
    margin: 5% auto;
    border-radius: 8px;
    width: 80%;
    max-width: 1000px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    animation: slideDown 0.3s;
}

.modal-header {
    background-color: var(--secondary-color);
    color: white;
    padding: 15px 20px;
    border-radius: 8px 8px 0 0;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.modal-header h2 {
    margin: 0;
    font-size: 20px;
    border-bottom: none;
}

.close {
    color: white;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.modal-body {
    padding: 20px;
    max-height: 70vh;
    overflow-y: auto;
}

@keyframes slideDown {
    from {
        transform: translateY(-50px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

/* AI Assistant Modal */
.chat-container {
    display: flex;
    flex-direction: column;
    height: 400px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    background-color: #f9f9f9;
}

.chat-messages {
    flex: 1;
    overflow-y: auto;
    padding: 15px;
}

.ai-message, .user-message {
    margin-bottom: 15px;
    display: flex;
}

.ai-message {
    align-items: flex-start;
}

.user-message {
    align-items: flex-start;
    flex-direction: row-reverse;
}

.message-avatar {
    background-color: var(--primary-color);
    color: white;
    width: 36px;
    height: 36px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 10px;
}

.user-message .message-avatar {
    background-color: var(--secondary-color);
    margin-right: 0;
    margin-left: 10px;
}

.message-content {
    background-color: white;
    padding: 10px 15px;
    border-radius: 8px;
    max-width: 80%;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.user-message .message-content {
    background-color: var(--primary-color);
    color: white;
}

.message-content p {
    margin: 0 0 10px 0;
}

.message-content p:last-child {
    margin-bottom: 0;
}

.message-content ul {
    margin-left: 20px;
}

.chat-input {
    display: flex;
    padding: 10px;
    border-top: 1px solid var(--border-color);
}

.chat-input input {
    flex: 1;
    padding: 10px;
    border: 1px solid var(--border-color);
    border-radius: 4px 0 0 4px;
    font-size: 14px;
}

.chat-input button {
    width: 40px;
    background-color: var(--primary-color);
    color: white;
    border: none;
    border-radius: 0 4px 4px 0;
    cursor: pointer;
}

.ai-suggestions {
    margin-top: 20px;
}

.suggestion-title {
    font-weight: 500;
    margin-bottom: 10px;
}

.suggestion-buttons {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
}

.suggestion-btn {
    background-color: #f1f1f1;
    border: 1px solid var(--border-color);
    border-radius: 20px;
    padding: 8px 15px;
    font-size: 13px;
    cursor: pointer;
    transition: all 0.3s;
}

.suggestion-btn:hover {
    background-color: #e1e1e1;
}

/* Help Modal */
.help-navigation {
    width: 250px;
    float: left;
    border-right: 1px solid var(--border-color);
    height: 500px;
}

.help-search {
    padding: 10px;
    border-bottom: 1px solid var(--border-color);
}

.help-search input {
    width: 100%;
    padding: 8px;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    font-size: 14px;
}

.help-topics {
    list-style: none;
    margin-top: 10px;
    overflow-y: auto;
    max-height: calc(500px - 50px);
}

.help-topics li {
    padding: 10px 15px;
    cursor: pointer;
    border-left: 3px solid transparent;
    transition: all 0.3s;
}

.help-topics li.active {
    background-color: rgba(52, 152, 219, 0.1);
    border-left-color: var(--primary-color);
    color: var(--primary-color);
}

.help-topics li:hover:not(.active) {
    background-color: rgba(0, 0, 0, 0.05);
}

.help-content {
    margin-left: 260px;
    padding: 15px;
    height: 500px;
    overflow-y: auto;
}

#helpContentArea h3 {
    margin-bottom: 15px;
    color: var(--secondary-color);
}

#helpContentArea h4 {
    margin: 20px 0 10px;
    color: var(--dark-color);
}

#helpContentArea p {
    margin-bottom: 15px;
    line-height: 1.6;
}

#helpContentArea ul, #helpContentArea ol {
    margin-left: 20px;
    margin-bottom: 15px;
}

#helpContentArea li {
    margin-bottom: 8px;
}

/* Settings Modal */
.settings-section {
    margin-bottom: 25px;
    border-bottom: 1px solid var(--border-color);
    padding-bottom: 15px;
}

.settings-section:last-child {
    border-bottom: none;
}

.settings-section h3 {
    margin-bottom: 15px;
    color: var(--secondary-color);
    font-size: 16px;
}

/* Custom Attributes Table */
.custom-attributes-container {
    margin-top: 15px;
    overflow-x: auto;
}

.custom-attributes-table {
    width: 100%;
    border-collapse: collapse;
}

.custom-attributes-table th, 
.custom-attributes-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.custom-attributes-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

/* Fallback Priority */
.fallback-priority-container {
    margin-top: 10px;
}

.fallback-priority-list {
    list-style: none;
    border: 1px solid var(--border-color);
    border-radius: 4px;
}

.fallback-item {
    display: flex;
    align-items: center;
    padding: 10px;
    border-bottom: 1px solid var(--border-color);
    background-color: white;
    cursor: move;
}

.fallback-item:last-child {
    border-bottom: none;
}

.fallback-handle {
    margin-right: 10px;
    color: var(--gray-color);
    cursor: grab;
}

/* SGT and IoT Device Tables */
.sgt-table-container,
.iot-device-table-container {
    margin-top: 15px;
    overflow-x: auto;
}

.sgt-table,
.iot-device-table {
    width: 100%;
    border-collapse: collapse;
}

.sgt-table th, .sgt-table td,
.iot-device-table th, .iot-device-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.sgt-table th,
.iot-device-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

/* Command Privilege Table */
.command-privilege-container {
    margin-top: 15px;
    margin-bottom: 15px;
}

.command-privilege-table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 10px;
}

.command-privilege-table th, 
.command-privilege-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.command-privilege-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

.command-privilege-table code {
    background-color: #f0f0f0;
    padding: 2px 5px;
    border-radius: 3px;
    font-family: monospace;
}

/* Template List */
.template-list-container {
    margin-top: 15px;
    overflow-x: auto;
}

.template-list-table {
    width: 100%;
    border-collapse: collapse;
}

.template-list-table th, 
.template-list-table td {
    padding: 8px;
    text-align: left;
    border-bottom: 1px solid var(--border-color);
}

.template-list-table th {
    background-color: #f5f7fa;
    font-weight: 500;
}

.template-action {
    background: none;
    border: none;
    cursor: pointer;
    color: var(--primary-color);
    font-size: 14px;
    margin-right: 5px;
}

/* Deployment Details */
.deployment-details {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 15px;
    margin-bottom: 20px;
}

.deployment-details h3 {
    margin-bottom: 15px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* AI Status */
.ai-status-container {
    margin-bottom: 20px;
}

.ai-status {
    display: flex;
    align-items: center;
    background-color: #f0f7ff;
    border: 1px solid #c5d9f1;
    border-radius: 4px;
    padding: 15px;
}

.ai-status-indicator {
    color: var(--success-color);
    font-size: 24px;
    margin-right: 15px;
}

.ai-status-message h3 {
    margin: 0 0 5px 0;
    color: var(--secondary-color);
    font-size: 16px;
}

.ai-status-message p {
    margin: 0;
    color: #555;
}

/* Security Score Card */
.security-score-container {
    margin-bottom: 20px;
}

.security-score-card {
    display: flex;
    background-color: white;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 20px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.security-score-circle {
    width: 120px;
    height: 120px;
    border-radius: 50%;
    background-color: #f5f7fa;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    margin-right: 30px;
    border: 5px solid var(--success-color);
}

.score-value {
    font-size: 36px;
    font-weight: bold;
    color: var(--secondary-color);
}

.score-label {
    font-size: 14px;
    color: var(--gray-color);
}

.security-score-details {
    flex: 1;
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 15px;
}

.security-score-item {
    background-color: #f5f7fa;
    border-radius: 4px;
    padding: 10px;
}

.security-score-item-label {
    font-size: 14px;
    color: var(--gray-color);
    margin-bottom: 5px;
}

.security-score-item-value {
    font-size: 24px;
    font-weight: bold;
    color: var(--secondary-color);
}

/* Security Analysis */
.security-category {
    margin-bottom: 20px;
}

.security-category h4 {
    margin-bottom: 10px;
    color: var(--secondary-color);
    font-size: 16px;
}

.security-issues {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
}

/* Recommendations */
.ai-recommendation-status {
    background-color: #f0f7ff;
    border: 1px solid #c5d9f1;
    border-radius: 4px;
    padding: 15px;
    margin-bottom: 20px;
}

.recommendation-category {
    margin-bottom: 20px;
}

.recommendation-category h3 {
    margin-bottom: 10px;
    color: var(--secondary-color);
    font-size: 16px;
}

/* Optimization Results */
.optimization-results {
    background-color: #f9f9f9;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    padding: 15px;
    margin-top: 20px;
    margin-bottom: 20px;
}

.optimization-results h3 {
    margin-bottom: 10px;
    font-size: 16px;
    color: var(--secondary-color);
}

/* Severity Badges */
.severity-badge {
    display: inline-block;
    padding: 4px 8px;
    border-radius: 3px;
    font-size: 12px;
    font-weight: bold;
    text-transform: uppercase;
    color: white;
}

.severity-badge.critical {
    background-color: #e74c3c;
}

.severity-badge.high {
    background-color: #e67e22;
}

.severity-badge.medium {
    background-color: #f39c12;
}

.severity-badge.low {
    background-color: #3498db;
}

/* Issues List */
.issues-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.issue-item {
    margin-bottom: 10px;
    padding: 10px;
    background-color: #f9f9f9;
    border-radius: 4px;
    border-left: 4px solid #ddd;
}

.issue-item.critical {
    border-left-color: #e74c3c;
}

.issue-item.high {
    border-left-color: #e67e22;
}

.issue-item.medium {
    border-left-color: #f39c12;
}

.issue-item.low {
    border-left-color: #3498db;
}

.issue-header {
    display: flex;
    align-items: center;
    margin-bottom: 5px;
}

.issue-title {
    margin-left: 10px;
    font-weight: 500;
}

.issue-details {
    margin-left: 54px;
    font-size: 14px;
}

.issue-details p {
    margin: 5px 0;
}

/* Recommendations List */
.recommendations-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.recommendation-item {
    margin-bottom: 15px;
    padding: 10px;
    background-color: #f9f9f9;
    border-radius: 4px;
    border-left: 4px solid #3498db;
}

.recommendation-header {
    display: flex;
    align-items: center;
    margin-bottom: 10px;
}

.recommendation-title {
    margin-left: 10px;
    font-weight: 500;
}

.recommendation-details {
    margin-left: 5px;
}

.recommendation-config {
    margin: 10px 0;
    padding: 10px;
    background-color: #2c3e50;
    color: #ecf0f1;
    border-radius: 4px;
    font-family: monospace;
    font-size: 12px;
    white-space: pre;
    overflow-x: auto;
}

/* AI Loading Indicator */
.ai-loading-indicator {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.7);
    display: none;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    z-index: 2000;
}

.ai-spinner {
    color: white;
    font-size: 48px;
    margin-bottom: 20px;
}

.ai-loading-message {
    color: white;
    font-size: 18px;
}

/* Toast Notification */
.toast-notification {
    position: fixed;
    bottom: 20px;
    right: 20px;
    background-color: #27ae60;
    color: white;
    padding: 15px 20px;
    border-radius: 4px;
    display: flex;
    align-items: center;
    gap: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    z-index: 1000;
    animation: fadeIn 0.3s;
}

.toast-icon {
    font-size: 24px;
}

.toast-message {
    font-size: 16px;
}

.toast-hide {
    animation: fadeOut 0.5s;
}

@keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
}

@keyframes fadeOut {
    from { opacity: 1; transform: translateY(0); }
    to { opacity: 0; transform: translateY(20px); }
}

/* Changes List */
.changes-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.change-type {
    margin-bottom: 15px;
}

.change-type ul {
    margin-top: 5px;
    padding-left: 20px;
}

.change-type ul li {
    margin-bottom: 5px;
}

/* Responsive Styles */
@media (max-width: 992px) {
    .sidebar {
        width: 200px;
    }
    
    .modal-content {
        width: 95%;
    }
    
    .help-navigation {
        width: 200px;
    }
    
    .help-content {
        margin-left: 210px;
    }
    
    .security-score-card {
        flex-direction: column;
        align-items: center;
    }
    
    .security-score-circle {
        margin-right: 0;
        margin-bottom: 20px;
    }
    
    .security-score-details {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    .form-row {
        flex-direction: column;
    }
    
    .form-row .form-group {
        width: 100%;
    }
    
    .col-md-6, .col-md-4 {
        width: 100%;
    }
    
    .tabs {
        flex-direction: column;
    }
    
    .tab {
        border-left: 2px solid transparent;
        border-bottom: none;
    }
    
    .tab.active {
        border-left-color: var(--primary-color);
        border-bottom-color: transparent;
    }
    
    .help-navigation {
        float: none;
        width: 100%;
        height: auto;
        border-right: none;
        border-bottom: 1px solid var(--border-color);
        margin-bottom: 15px;
    }
    
    .help-content {
        margin-left: 0;
    }
    
    .action-buttons {
        flex-direction: column;
    }
}

@media (max-width: 576px) {
    .sidebar {
        display: none;
    }
    
    .header-controls {
        gap: 5px;
    }
    
    .btn-icon {
        width: 35px;
        height: 35px;
        font-size: 16px;
    }
    
    .section-footer {
        flex-direction: column;
        gap: 10px;
    }
}
EOF

# Create template generator
print_message "Creating template generator script..."
cat > js/template-generator.js << 'EOF'
/**
 * UaXSupreme - Template Generator
 * Generates configuration templates for network devices
 */

(function() {
    'use strict';

    // Template Generator object
    const TemplateGenerator = {
        /**
         * Initialize Template Generator
         */
        init: function() {
            console.log('Initializing Template Generator...');
            
            // Set up event listeners
            this.setupEventListeners();
            
            // Add templates to storage
            this.loadTemplates();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Generate configuration button
            const generateConfigBtn = document.getElementById('generateConfigBtn');
            if (generateConfigBtn) {
                generateConfigBtn.addEventListener('click', this.generateConfiguration.bind(this));
            }
            
            // Template type selector
            const templateType = document.getElementById('templateType');
            if (templateType) {
                templateType.addEventListener('change', this.updateTemplateContent.bind(this));
            }
            
            // Add interface templates
            const templateButtons = document.querySelectorAll('.template-buttons button');
            templateButtons.forEach(button => {
                button.addEventListener('click', this.addInterfaceTemplate.bind(this, button.id.replace('template', '').toLowerCase()));
            });
            
            // Create template button
            const createTemplateBtn = document.getElementById('createTemplateBtn');
            if (createTemplateBtn) {
                createTemplateBtn.addEventListener('click', this.createTemplate.bind(this));
            }
            
            // Reauthentication period
            const reauthPeriod = document.getElementById('reauthPeriod');
            if (reauthPeriod) {
                reauthPeriod.addEventListener('change', function() {
                    const customGroup = document.getElementById('customReauthPeriodGroup');
                    if (customGroup) {
                        customGroup.style.display = this.value === 'custom' ? 'block' : 'none';
                    }
                });
            }
            
            // Trunk encapsulation
            const trunkEncapsulation = document.getElementById('trunkEncapsulation');
            if (trunkEncapsulation) {
                trunkEncapsulation.addEventListener('change', function() {
                    const encapsulationGroup = document.getElementById('encapsulationGroup');
                    if (encapsulationGroup) {
                        encapsulationGroup.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }
            
            // Command sets
            const cmdSetCustom = document.getElementById('cmdSetCustom');
            if (cmdSetCustom) {
                cmdSetCustom.addEventListener('change', function() {
                    const customCmdSet = document.getElementById('customCmdSet');
                    if (customCmdSet) {
                        customCmdSet.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }
            
            // Default command sets
            const cmdSetDefault = document.getElementById('cmdSetDefault');
            if (cmdSetDefault) {
                cmdSetDefault.addEventListener('change', function() {
                    const defaultCmdSets = document.getElementById('defaultCmdSets');
                    if (defaultCmdSets) {
                        defaultCmdSets.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }
            
            // Command privilege add button
            const addCommandBtn = document.getElementById('addCommandBtn');
            if (addCommandBtn) {
                addCommandBtn.addEventListener('click', this.addCommandRow.bind(this));
            }
            
            // Copy configuration button
            const copyConfigBtn = document.getElementById('copyConfigBtn');
            if (copyConfigBtn) {
                copyConfigBtn.addEventListener('click', this.copyToClipboard.bind(this));
            }
            
            // Download configuration button
            const downloadConfigBtn = document.getElementById('downloadConfigBtn');
            if (downloadConfigBtn) {
                downloadConfigBtn.addEventListener('click', this.downloadConfiguration.bind(this));
            }
            
            // Attribute customization level
            const attrCustomizationLevel = document.getElementById('attrCustomizationLevel');
            if (attrCustomizationLevel) {
                attrCustomizationLevel.addEventListener('change', function() {
                    const customAttributesSection = document.getElementById('customAttributesSection');
                    if (customAttributesSection) {
                        customAttributesSection.style.display = this.value === 'custom' ? 'block' : 'none';
                    }
                });
            }
            
            // Feature checkboxes
            const featureCheckboxes = document.querySelectorAll('.checkbox-item input[type="checkbox"]');
            featureCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', this.handleFeatureToggle.bind(this));
            });
            
            // Validation level
            const validationLevel = document.getElementById('validationLevel');
            if (validationLevel) {
                validationLevel.addEventListener('change', this.updateValidationOptions.bind(this));
            }
            
            // Validate configuration button
            const validateConfigBtn = document.getElementById('validateConfigBtn');
            if (validateConfigBtn) {
                validateConfigBtn.addEventListener('click', this.validateConfiguration.bind(this));
            }
            
            // Deployment method
            const deploymentMethod = document.getElementById('deploymentMethod');
            if (deploymentMethod) {
                deploymentMethod.addEventListener('change', this.updateDeploymentOptions.bind(this));
            }
            
            // Deployment schedule
            const deploymentSchedule = document.getElementById('deploymentSchedule');
            if (deploymentSchedule) {
                deploymentSchedule.addEventListener('change', function() {
                    const scheduledDeployment = document.getElementById('scheduledDeployment');
                    if (scheduledDeployment) {
                        scheduledDeployment.style.display = this.value === 'scheduled' ? 'block' : 'none';
                    }
                });
            }
            
            // Authentication method checkboxes
            const authMethodCheckboxes = document.querySelectorAll('input[name="authMethod"]');
            authMethodCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', this.showMethodInfo.bind(this));
            });
            
            // Security feature checkboxes for macSec
            const macSecCheckbox = document.getElementById('macsec');
            if (macSecCheckbox) {
                macSecCheckbox.addEventListener('change', function() {
                    // Show MACsec settings in Advanced Features section when MACsec is checked
                    const macSecSettings = document.getElementById('macSecSettings');
                    if (macSecSettings) {
                        macSecSettings.style.display = this.checked ? 'block' : 'none';
                    }
                });
            }

            // Monitor authentication method checkboxes
            const authMethodToggles = document.querySelectorAll('input[name="authMethod"]');
            if (authMethodToggles.length > 0) {
                authMethodToggles.forEach(toggle => {
                    toggle.addEventListener('change', function() {
                        // Update dependent sections based on enabled authentication methods
                        TemplateGenerator.updateDependentSections();
                    });
                });
            }
        },
        
        /**
         * Load templates into local storage
         */
        loadTemplates: function() {
            // Default templates
            const defaultTemplates = {
                dot1x: {
                    name: 'WIRED_DOT1X_CLOSED',
                    type: '802.1X',
                    description: 'Standard 802.1X closed mode authentication',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\nmab\nsubscriber aging inactivity-timer 60 probe\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session closed\naccess-session port-control auto\nauthentication periodic\nauthentication timer reauthenticate server\nservice-policy type control subscriber DOT1X_MAB_POLICY'
                },
                monitor: {
                    name: 'WIRED_DOT1X_MONITOR',
                    type: '802.1X',
                    description: 'Monitor mode authentication for testing',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\nmab\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session port-control auto\nauthentication open\nauthentication periodic\nauthentication timer reauthenticate server\nservice-policy type control subscriber DOT1X_MAB_POLICY'
                },
                mab: {
                    name: 'IOT_MAB_ONLY',
                    type: 'MAB',
                    description: 'MAB-only for IoT devices',
                    content: 'mab\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session port-control auto\nauthentication open\nservice-policy type control subscriber MAB_POLICY'
                },
                webauth: {
                    name: 'WEBAUTH_GUEST',
                    type: 'WebAuth',
                    description: 'Guest web authentication',
                    content: 'access-session control-direction in\naccess-session port-control auto\nauthentication open\nip access-group ACL-WEBAUTH-REDIRECT in\nip admission WEBAUTH\nservice-policy type control subscriber WEBAUTH_POLICY'
                },
                macsec: {
                    name: 'MACSEC_DOT1X',
                    type: 'MACsec',
                    description: '802.1X with MACsec encryption',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\naccess-session control-direction in\naccess-session host-mode multi-auth\naccess-session closed\naccess-session port-control auto\nauthentication periodic\nauthentication timer reauthenticate server\nmacsec\nmacsec replay-protection window-size 0\nmls qos trust dscp\nservice-policy type control subscriber DOT1X_POLICY'
                },
                hybrid: {
                    name: 'HYBRID_AUTH',
                    type: 'Hybrid Authentication',
                    description: 'Hybrid authentication with 802.1X, MAB, and Web Authentication',
                    content: 'dot1x pae authenticator\ndot1x timeout tx-period 7\ndot1x max-reauth-req 2\nmab\naccess-session control-direction in\naccess-session host-mode multi-domain\naccess-session closed\naccess-session port-control auto\nauthentication periodic\nauthentication timer reauthenticate server\nip access-group ACL-WEBAUTH-REDIRECT in\nip admission WEBAUTH\nservice-policy type control subscriber HYBRID_POLICY'
                }
            };
            
            // Store templates in local storage
            if (!localStorage.getItem('uaxTemplates')) {
                localStorage.setItem('uaxTemplates', JSON.stringify(defaultTemplates));
            }
        },
        
        /**
         * Update dependent sections based on selected authentication methods
         */
        updateDependentSections: function() {
            // Check if RADIUS section should be shown based on selected auth methods
            const dot1xEnabled = document.getElementById('dot1x')?.checked || false;
            const mabEnabled = document.getElementById('mab')?.checked || false;
            const webauthEnabled = document.getElementById('webauth')?.checked || false;
            const radsecEnabled = document.getElementById('radsec')?.checked || false;
            const tacacsEnabled = document.getElementById('tacacs')?.checked || false;
            const macsecEnabled = document.getElementById('macsec')?.checked || false;
            
            // Determine which sections to show/hide
            const radiusNeeded = dot1xEnabled || mabEnabled || webauthEnabled || radsecEnabled;
            const tacacsNeeded = tacacsEnabled;
            
            // Get step elements
            const radiusStep = document.querySelector('.nav-steps li[data-step="radius-config"]');
            const tacacsStep = document.querySelector('.nav-steps li[data-step="tacacs-config"]');
            
            // Show/hide steps based on selections
            if (radiusStep) {
                radiusStep.style.display = radiusNeeded ? 'flex' : 'none';
            }
            
            if (tacacsStep) {
                tacacsStep.style.display = tacacsNeeded ? 'flex' : 'none';
            }
            
            // Show warning if no authentication method is selected
            const warningElement = document.querySelector('.authentication-warning');
            if (!warningElement && !radiusNeeded && !tacacsNeeded) {
                const warning = document.createElement('div');
                warning.className = 'authentication-warning';
                warning.style.backgroundColor = '#f8d7da';
                warning.style.color = '#721c24';
                warning.style.padding = '10px';
                warning.style.borderRadius = '4px';
                warning.style.marginTop = '10px';
                warning.innerHTML = '<i class="fas fa-exclamation-triangle"></i> Warning: No authentication method selected. Please select at least one authentication method.';
                
                const tabContent = document.getElementById('auth-methods');
                if (tabContent) {
                    tabContent.appendChild(warning);
                }
            } else if (warningElement && (radiusNeeded || tacacsNeeded)) {
                warningElement.remove();
            }
        },
        
        /**
         * Show method info when checkbox is checked
         * @param {Event} event - Change event
         */
        showMethodInfo: function(event) {
            const checkbox = event.target;
            const methodId = checkbox.id;
            const infoPanel = document.getElementById(`${methodId}-info`);
            
            // Hide all info panels
            const allInfoPanels = document.querySelectorAll('.method-info-panel');
            allInfoPanels.forEach(panel => {
                panel.classList.add('hidden');
            });
            
            // Show selected info panel
            if (checkbox.checked && infoPanel) {
                infoPanel.classList.remove('hidden');
            }
        },
        
        /**
         * Handle feature toggle
         * @param {Event} event - Change event
         */
        handleFeatureToggle: function(event) {
            const checkbox = event.target;
            const featureId = checkbox.id;
            const settingsId = `${featureId}Settings`;
            const settingsPanel = document.getElementById(settingsId);
            
            // Show/hide settings panel if it exists
            if (settingsPanel) {
                settingsPanel.style.display = checkbox.checked ? 'block' : 'none';
            }
        },
        
        /**
         * Update validation options based on level
         */
        updateValidationOptions: function() {
            const level = document.getElementById('validationLevel').value;
            
            // Update validation checkboxes based on level
            const validateSyntax = document.getElementById('validateSyntax');
            const validateSecurity = document.getElementById('validateSecurity');
            const validateCompatibility = document.getElementById('validateCompatibility');
            const validatePerformance = document.getElementById('validatePerformance');
            
            if (validateSyntax) validateSyntax.checked = true; // Always checked
            
            if (validateSecurity) {
                validateSecurity.checked = level !== 'basic';
            }
            
            if (validateCompatibility) {
                validateCompatibility.checked = level !== 'basic';
            }
            
            if (validatePerformance) {
                validatePerformance.checked = level === 'strict' || level === 'comprehensive';
            }
        },
        
        /**
         * Update deployment options based on method
         */
        updateDeploymentOptions: function() {
            const method = document.getElementById('deploymentMethod').value;
            
            // Show/hide SSH details based on method
            const sshDetails = document.getElementById('sshDetails');
            if (sshDetails) {
                sshDetails.style.display = method === 'ssh' ? 'block' : 'none';
            }
        },
        
        /**
         * Add command row to command privilege table
         */
        addCommandRow: function() {
            const table = document.querySelector('.command-privilege-table tbody');
            if (!table) return;
            
            const newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td><input type="text" class="form-control" placeholder="Enter command"></td>
                <td>
                    <select class="form-control">
                        <option>15</option>
                        <option>10</option>
                        <option>5</option>
                        <option>1</option>
                    </select>
                </td>
                <td>
                    <select class="form-control">
                        <option>Allow</option>
                        <option>Deny</option>
                    </select>
                </td>
            `;
            
            table.appendChild(newRow);
        },
        
        /**
         * Update template content when template type changes
         */
        updateTemplateContent: function() {
            const templateType = document.getElementById('templateType').value;
            const templateContent = document.getElementById('templateContent');
            
            if (!templateContent) return;
            
            // Get templates from storage
            const templates = JSON.parse(localStorage.getItem('uaxTemplates') || '{}');
            
            // Set template content based on type
            if (templates[templateType]) {
                templateContent.value = templates[templateType].content;
            } else {
                templateContent.value = 'Select a template type to see content...';
            }
        },
        
        /**
         * Add interface template to specific interfaces
         * @param {string} type - Template type
         */
        addInterfaceTemplate: function(type) {
            const specificInterfaces = document.getElementById('specificInterfaces');
            if (!specificInterfaces) return;
            
            let template = '';
            
            // Define templates for different device types
            switch (type) {
                case 'ap':
                    template = `interface GigabitEthernet1/0/1
 description Access Point - 802.1X Authentication
 switchport access vlan 10
 switchport mode access
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 dot1x pae authenticator
 dot1x timeout tx-period 7
 dot1x max-reauth-req 2
 mab
 access-session host-mode multi-auth
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'ipphone':
                    template = `interface GigabitEthernet1/0/2
 description IP Phone - 802.1X + Voice
 switchport access vlan 10
 switchport mode access
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 dot1x pae authenticator
 dot1x timeout tx-period 7
 dot1x max-reauth-req 2
 mab
 access-session host-mode multi-domain
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'printer':
                    template = `interface GigabitEthernet1/0/3
 description Printer - MAB Authentication
 switchport access vlan 30
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 mab
 access-session host-mode single-host
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'server':
                    template = `interface GigabitEthernet1/0/4
 description Server - Static Assignment
 switchport access vlan 100
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 storm-control broadcast level pps 1k
 storm-control action trap
 no shutdown`;
                    break;
                case 'uplink':
                    template = `interface GigabitEthernet1/0/48
 description Uplink to Core Switch
 switchport trunk encapsulation dot1q
 switchport trunk native vlan 999
 switchport trunk allowed vlan 10,20,30,100
 switchport mode trunk
 spanning-tree guard root
 storm-control broadcast level pps 5k
 storm-control action trap
 no shutdown`;
                    break;
                case 'iot':
                    template = `interface GigabitEthernet1/0/5
 description IoT Device - MAB Authentication
 switchport access vlan 40
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 mab
 access-session host-mode multi-auth
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown`;
                    break;
                case 'camera':
                    template = `interface GigabitEthernet1/0/6
 description IP Camera - MAB Authentication
 switchport access vlan 50
 switchport mode access
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 mab
 access-session host-mode single-host
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 storm-control broadcast level pps 500
 storm-control action trap
 no shutdown`;
                    break;
            }
            
            // Add template to textarea
            specificInterfaces.value += (specificInterfaces.value ? '\n\n' : '') + template;
        },
        
        /**
         * Create a new template
         */
        createTemplate: function() {
            const templateName = document.getElementById('templateName').value;
            const templateType = document.getElementById('templateType').value;
            const templateContent = document.getElementById('templateContent').value;
            
            if (!templateName || !templateContent) {
                alert('Please enter a template name and content.');
                return;
            }
            
            // Get templates from storage
            const templates = JSON.parse(localStorage.getItem('uaxTemplates') || '{}');
            
            // Add new template
            templates[templateName.toLowerCase()] = {
                name: templateName,
                type: templateType,
                description: `Custom ${templateType} template`,
                content: templateContent
            };
            
            // Save templates to storage
            localStorage.setItem('uaxTemplates', JSON.stringify(templates));
            
            alert(`Template "${templateName}" created successfully.`);
        },
        
        /**
         * Create configuration parameter object from form inputs
         * @returns {Object} Configuration parameters
         */
        getConfigParameters: function() {
            // Get vendor and platform
            const vendor = document.getElementById('vendor')?.value || '';
            const platform = document.getElementById('platform')?.value || '';
            
            // Get authentication methods
            const authMethods = Array.from(document.querySelectorAll('input[name="authMethod"]:checked')).map(el => el.value);
            
            // Get deployment and fallover settings
            const deploymentType = document.getElementById('deploymentType')?.value || 'standard';
            const failoverPolicy = document.getElementById('failoverPolicy')?.value || 'strict';
            
            // Get RADIUS server settings
            const radiusServer1 = document.getElementById('radiusServer1')?.value || '';
            const radiusServer2 = document.getElementById('radiusServer2')?.value || '';
            const radiusKey1 = document.getElementById('radiusKey1')?.value || '';
            const radiusKey2 = document.getElementById('radiusKey2')?.value || '';
            const radiusServerGroup = document.getElementById('radiusServerGroup')?.value || 'RAD-SERVERS';
            
            // Get general settings
            const hostMode = document.getElementById('hostMode')?.value || 'multi-auth';
            const controlDirection = document.getElementById('controlDirection')?.value || 'in';
            const dot1xTxPeriod = document.getElementById('dot1xTxPeriod')?.value || '7';
            const dot1xMaxReauthReq = document.getElementById('dot1xMaxReauthReq')?.value || '2';
            
            // Get security features
            const securityFeatures = Array.from(document.querySelectorAll('input[name="securityFeature"]:checked')).map(el => el.value);
            
            // Get interface settings
            const accessInterfaceRange = document.getElementById('accessInterfaceRange')?.value || '';
            const accessVlan = document.getElementById('accessVlan')?.value || '';
            const voiceVlan = document.getElementById('voiceVlan')?.value || '';
            
            // Return configuration parameters object
            return {
                vendor,
                platform,
                authMethods,
                deploymentType,
                failoverPolicy,
                radiusServer1,
                radiusServer2,
                radiusKey1,
                radiusKey2,
                radiusServerGroup,
                hostMode,
                controlDirection,
                dot1xTxPeriod,
                dot1xMaxReauthReq,
                securityFeatures,
                accessInterfaceRange,
                accessVlan,
                voiceVlan
            };
        },
        
        /**
         * Generate configuration based on form inputs
         */
        generateConfiguration: function() {
            // Get configuration parameters
            const params = this.getConfigParameters();
            
            // Get configuration output textarea
            const configOutput = document.getElementById('configOutput');
            if (!configOutput) return;
            
            // Clear previous configuration
            configOutput.value = '';
            
            // Generate configuration
            let config = this.generateBaseConfig(params);
            
            // Add TACACS configuration if selected
            if (params.authMethods.includes('tacacs')) {
                config += this.generateTacacsConfig(params);
            }
            
            // Add RADIUS configuration if needed
            if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab') || 
                params.authMethods.includes('webauth') || params.authMethods.includes('radsec')) {
                config += this.generateRadiusConfig(params);
            }
            
            // Add authentication configuration
            config += this.generateAuthenticationConfig(params);
            
            // Add security features
            config += this.generateSecurityConfig(params);
            
            // Add interface configuration
            config += this.generateInterfaceConfig(params);
            
            // Set configuration output
            configOutput.value = config;
            
            // Show success message
            this.showToast('Configuration generated successfully');
        },
        
        /**
         * Generate base configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Base configuration
         */
        generateBaseConfig: function(params) {
            // Create base configuration based on vendor
            let config = '';
            
            // Get current date for comments
            const date = new Date().toISOString().split('T')[0];
            
            // Add version and hostname
            config += `! UaXSupreme Generated Configuration\n`;
            config += `! Vendor: ${params.vendor}\n`;
            config += `! Platform: ${params.platform}\n`;
            config += `! Date: ${date}\n`;
            config += `!\n`;
            
            // Add base configuration based on vendor
            switch (params.vendor) {
                case 'cisco':
                    config += `hostname SWITCH-${Math.floor(1000 + Math.random() * 9000)}\n`;
                    config += `!\n`;
                    config += `! Base services\n`;
                    config += `no service pad\n`;
                    config += `service timestamps debug datetime msec localtime show-timezone\n`;
                    config += `service timestamps log datetime msec localtime show-timezone\n`;
                    config += `service password-encryption\n`;
                    config += `!\n`;
                    
                    // Add AAA base config
                    config += `! AAA Configuration\n`;
                    config += `aaa new-model\n`;
                    
                    // Add device tracking (required for 802.1X and dACLs)
                    if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab')) {
                        if (params.platform === 'ios-xe') {
                            config += `!\n`;
                            config += `! Device Tracking Configuration\n`;
                            config += `device-tracking tracking auto-source\n`;
                            config += `!\n`;
                            config += `device-tracking policy IP-TRACKING\n`;
                            config += ` limit address-count 4\n`;
                            config += ` security-level glean\n`;
                            config += ` no protocol ndp\n`;
                            config += ` no protocol dhcp6\n`;
                            config += ` tracking enable reachable-lifetime 30\n`;
                            config += `!\n`;
                            config += `device-tracking policy DISABLE-IP-TRACKING\n`;
                            config += ` tracking disable\n`;
                            config += ` trusted-port\n`;
                            config += ` device-role switch\n`;
                        } else {
                            config += `!\n`;
                            config += `! IP Device Tracking Configuration\n`;
                            config += `ip device tracking probe auto-source\n`;
                            config += `ip device tracking probe delay 30\n`;
                            config += `ip device tracking probe interval 30\n`;
                            config += `ip device tracking\n`;
                        }
                    }
                    break;
                    
                case 'aruba':
                    config += `hostname SWITCH-${Math.floor(1000 + Math.random() * 9000)}\n`;
                    config += `!\n`;
                    config += `time timezone pst -8\n`;
                    config += `time daylight-time-rule continental-us-and-canada\n`;
                    config += `!\n`;
                    config += `! AAA Configuration\n`;
                    config += `aaa authentication port-access eap-radius\n`;
                    break;
                    
                case 'juniper':
                    config = `# UaXSupreme Generated Configuration\n`;
                    config += `# Vendor: ${params.vendor}\n`;
                    config += `# Platform: ${params.platform}\n`;
                    config += `# Date: ${date}\n`;
                    config += `#\n`;
                    config += `system {\n`;
                    config += `    host-name SWITCH-${Math.floor(1000 + Math.random() * 9000)};\n`;
                    config += `    time-zone America/Los_Angeles;\n`;
                    config += `}\n`;
                    break;
                    
                default:
                    config += `hostname SWITCH-${Math.floor(1000 + Math.random() * 9000)}\n`;
                    config += `!\n`;
            }
            
            return config;
        },
        
        /**
         * Generate TACACS configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} TACACS configuration
         */
        generateTacacsConfig: function(params) {
            // Create TACACS configuration based on vendor
            let config = '\n';
            
            // Check if TACACS server information exists
            const tacacsServer1 = document.getElementById('tacacsServer1')?.value || '';
            const tacacsServer2 = document.getElementById('tacacsServer2')?.value || '';
            const tacacsKey1 = document.getElementById('tacacsKey1')?.value || '';
            const tacacsServerGroup = document.getElementById('tacacsServerGroup')?.value || 'SG-TAC-SERVERS';
            
            // Skip if no server is defined
            if (!tacacsServer1) {
                return '\n! TACACS+ Configuration (servers not defined)\n';
            }
            
            // Add TACACS configuration based on vendor
            switch (params.vendor) {
                case 'cisco':
                    config += `! TACACS+ Configuration\n`;
                    
                    // TACACS server definitions
                    if (params.platform === 'ios-xe') {
                        config += `tacacs server TAC-SERVER-1\n`;
                        config += ` address ipv4 ${tacacsServer1}\n`;
                        config += ` key ${tacacsKey1}\n`;
                        config += ` timeout 1\n`;
                        config += ` single-connection\n`;
                        
                        if (tacacsServer2) {
                            config += `!\n`;
                            config += `tacacs server TAC-SERVER-2\n`;
                            config += ` address ipv4 ${tacacsServer2}\n`;
                            config += ` key ${tacacsKey1}\n`;
                            config += ` timeout 1\n`;
                            config += ` single-connection\n`;
                        }
                    } else {
                        config += `tacacs-server host ${tacacsServer1} key ${tacacsKey1}\n`;
                        
                        if (tacacsServer2) {
                            config += `tacacs-server host ${tacacsServer2} key ${tacacsKey1}\n`;
                        }
                        
                        config += `tacacs-server timeout 1\n`;
                    }
                    
                    // TACACS server group
                    config += `!\n`;
                    config += `aaa group server tacacs+ ${tacacsServerGroup}\n`;
                    
                    if (params.platform === 'ios-xe') {
                        config += ` server name TAC-SERVER-1\n`;
                        
                        if (tacacsServer2) {
                            config += ` server name TAC-SERVER-2\n`;
                        }
                    } else {
                        config += ` server ${tacacsServer1}\n`;
                        
                        if (tacacsServer2) {
                            config += ` server ${tacacsServer2}\n`;
                        }
                    }
                    
                    config += ` ip tacacs source-interface Vlan10\n`;
                    
                    // TACACS configuration
                    config += `!\n`;
                    config += `aaa authentication login default group ${tacacsServerGroup} local\n`;
                    config += `aaa authentication enable default group ${tacacsServerGroup} enable\n`;
                    config += `aaa authorization exec default group ${tacacsServerGroup} local if-authenticated\n`;
                    config += `aaa authorization commands 15 default group ${tacacsServerGroup} local if-authenticated\n`;
                    config += `aaa accounting exec default start-stop group ${tacacsServerGroup}\n`;
                    config += `aaa accounting commands 15 default start-stop group ${tacacsServerGroup}\n`;
                    break;
                    
                case 'aruba':
                    config += `! TACACS+ Configuration\n`;
                    config += `tacacs-server host ${tacacsServer1} key ${tacacsKey1}\n`;
                    
                    if (tacacsServer2) {
                        config += `tacacs-server host ${tacacsServer2} key ${tacacsKey1}\n`;
                    }
                    
                    config += `tacacs-server timeout 1\n`;
                    config += `aaa authentication login default group tacacs local\n`;
                    config += `aaa authentication enable default group tacacs enable\n`;
                    config += `aaa authorization commands 15 default group tacacs local\n`;
                    config += `aaa accounting exec default start-stop group tacacs\n`;
                    config += `aaa accounting commands 15 default start-stop group tacacs\n`;
                    break;
                    
                case 'juniper':
                    config = `# TACACS+ Configuration\n`;
                    config += `system {\n`;
                    config += `    tacplus-server {\n`;
                    config += `        ${tacacsServer1} {\n`;
                    config += `            secret "${tacacsKey1}";\n`;
                    config += `            timeout 1;\n`;
                    config += `            single-connection;\n`;
                    config += `        }\n`;
                    
                    if (tacacsServer2) {
                        config += `        ${tacacsServer2} {\n`;
                        config += `            secret "${tacacsKey1}";\n`;
                        config += `            timeout 1;\n`;
                        config += `            single-connection;\n`;
                        config += `        }\n`;
                    }
                    
                    config += `    }\n`;
                    config += `    authentication-order [ tacplus password ];\n`;
                    config += `    accounting {\n`;
                    config += `        events [ login interactive-commands ];\n`;
                    config += `        destination {\n`;
                    config += `            tacplus;\n`;
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    break;
                    
                default:
                    config += `! TACACS+ Configuration\n`;
                    config += `tacacs-server host ${tacacsServer1} key ${tacacsKey1}\n`;
                    
                    if (tacacsServer2) {
                        config += `tacacs-server host ${tacacsServer2} key ${tacacsKey1}\n`;
                    }
                    
                    config += `tacacs-server timeout 1\n`;
                    config += `aaa authentication login default group tacacs local\n`;
                    config += `aaa authentication enable default group tacacs enable\n`;
                    config += `aaa authorization commands 15 default group tacacs local\n`;
                    config += `aaa accounting exec default start-stop group tacacs\n`;
                    config += `aaa accounting commands 15 default start-stop group tacacs\n`;
            }
            
            return config;
        },
        
        /**
         * Generate RADIUS configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} RADIUS configuration
         */
        generateRadiusConfig: function(params) {
            // Create RADIUS configuration based on vendor
            let config = '\n';
            
            // Skip if no RADIUS-based authentication methods are selected
            if (!params.authMethods.includes('dot1x') && !params.authMethods.includes('mab') && 
                !params.authMethods.includes('webauth') && !params.authMethods.includes('radsec')) {
                return '\n! RADIUS Configuration (not required)\n';
            }
            
            // Check if RADIUS server information exists
            if (!params.radiusServer1) {
                return '\n! RADIUS Configuration (servers not defined)\n';
            }
            
            // Define RADIUS configuration based on vendor
            switch (params.vendor) {
                case 'cisco':
                    config += `! RADIUS Configuration\n`;
                    
                    // RADIUS server definitions
                    if (params.platform === 'ios-xe') {
                        config += `radius server RAD-ISE-PSN-1\n`;
                        config += ` address ipv4 ${params.radiusServer1} auth-port 1812 acct-port 1813\n`;
                        config += ` key ${params.radiusKey1}\n`;
                        config += ` timeout 2\n`;
                        config += ` retransmit 2\n`;
                        config += ` automate-tester username test-user probe-on\n`;
                        
                        if (params.radiusServer2) {
                            config += `!\n`;
                            config += `radius server RAD-ISE-PSN-2\n`;
                            config += ` address ipv4 ${params.radiusServer2} auth-port 1812 acct-port 1813\n`;
                            config += ` key ${params.radiusKey2 || params.radiusKey1}\n`;
                            config += ` timeout 2\n`;
                            config += ` retransmit 2\n`;
                            config += ` automate-tester username test-user probe-on\n`;
                        }
                    } else {
                        config += `radius-server host ${params.radiusServer1} auth-port 1812 acct-port 1813 key ${params.radiusKey1}\n`;
                        
                        if (params.radiusServer2) {
                            config += `radius-server host ${params.radiusServer2} auth-port 1812 acct-port 1813 key ${params.radiusKey2 || params.radiusKey1}\n`;
                        }
                        
                        config += `radius-server timeout 2\n`;
                        config += `radius-server retransmit 2\n`;
                        config += `radius-server dead-criteria time 5 tries 3\n`;
                    }
                    
                    // RADIUS server group
                    config += `!\n`;
                    config += `aaa group server radius ${params.radiusServerGroup}\n`;
                    
                    if (params.platform === 'ios-xe') {
                        config += ` server name RAD-ISE-PSN-1\n`;
                        
                        if (params.radiusServer2) {
                            config += ` server name RAD-ISE-PSN-2\n`;
                        }
                    } else {
                        config += ` server ${params.radiusServer1} auth-port 1812 acct-port 1813\n`;
                        
                        if (params.radiusServer2) {
                            config += ` server ${params.radiusServer2} auth-port 1812 acct-port 1813\n`;
                        }
                    }
                    
                    config += ` deadtime 15\n`;
                    if (params.radiusServer2) {
                        config += ` load-balance method least-outstanding\n`;
                    }
                    config += ` ip radius source-interface Vlan10\n`;
                    
                    // RADIUS attributes
                    config += `!\n`;
                    config += `radius-server attribute 6 on-for-login-auth\n`;
                    config += `radius-server attribute 8 include-in-access-req\n`;
                    config += `radius-server attribute 25 access-request include\n`;
                    config += `radius-server attribute 31 mac format ietf upper-case\n`;
                    config += `radius-server attribute 31 send nas-port-detail mac-only\n`;
                    config += `radius-server vsa send authentication\n`;
                    config += `radius-server vsa send accounting\n`;
                    
                    // RADIUS dead criteria
                    config += `radius-server dead-criteria time 5 tries 3\n`;
                    
                    // Change of Authorization (CoA)
                    config += `!\n`;
                    config += `aaa server radius dynamic-author\n`;
                    config += ` client ${params.radiusServer1} server-key ${params.radiusKey1}\n`;
                    
                    if (params.radiusServer2) {
                        config += ` client ${params.radiusServer2} server-key ${params.radiusKey2 || params.radiusKey1}\n`;
                    }
                    
                    config += ` auth-type any\n`;
                    
                    // AAA authentication, authorization, and accounting
                    config += `!\n`;
                    config += `aaa authentication dot1x default group ${params.radiusServerGroup} local\n`;
                    config += `aaa authorization network default group ${params.radiusServerGroup} local\n`;
                    config += `aaa accounting dot1x default start-stop group ${params.radiusServerGroup}\n`;
                    config += `aaa accounting update newinfo periodic 1440\n`;
                    break;
                    
                case 'aruba':
                    config += `! RADIUS Configuration\n`;
                    config += `radius-server host ${params.radiusServer1} key ${params.radiusKey1}\n`;
                    
                    if (params.radiusServer2) {
                        config += `radius-server host ${params.radiusServer2} key ${params.radiusKey2 || params.radiusKey1}\n`;
                    }
                    
                    config += `radius-server timeout 2\n`;
                    config += `radius-server retransmit 2\n`;
                    config += `radius-server deadtime 15\n`;
                    config += `radius-server key ${params.radiusKey1}\n`;
                    config += `radius-server cppm server-group ${params.radiusServerGroup}\n`;
                    
                    if (params.radiusServer2) {
                        config += `radius-server cppm server-group ${params.radiusServerGroup} server ${params.radiusServer1}\n`;
                        config += `radius-server cppm server-group ${params.radiusServerGroup} server ${params.radiusServer2}\n`;
                    } else {
                        config += `radius-server cppm server-group ${params.radiusServerGroup} server ${params.radiusServer1}\n`;
                    }
                    
                    config += `aaa authentication port-access eap-radius server-group ${params.radiusServerGroup}\n`;
                    config += `aaa authentication mac-auth server-group ${params.radiusServerGroup}\n`;
                    break;
                    
                case 'juniper':
                    config = `# RADIUS Configuration\n`;
                    config += `system {\n`;
                    config += `    radius-server {\n`;
                    config += `        ${params.radiusServer1} {\n`;
                    config += `            secret "${params.radiusKey1}";\n`;
                    config += `            timeout 2;\n`;
                    config += `            retry 2;\n`;
                    config += `            source-address <vlan-10-ip>;\n`;
                    config += `        }\n`;
                    
                    if (params.radiusServer2) {
                        config += `        ${params.radiusServer2} {\n`;
                        config += `            secret "${params.radiusKey2 || params.radiusKey1}";\n`;
                        config += `            timeout 2;\n`;
                        config += `            retry 2;\n`;
                        config += `            source-address <vlan-10-ip>;\n`;
                        config += `        }\n`;
                    }
                    
                    config += `    }\n`;
                    config += `    authentication-order radius;\n`;
                    config += `    accounting {\n`;
                    config += `        events [ login interactive-commands ];\n`;
                    config += `        destination {\n`;
                    config += `            radius;\n`;
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    
                    config += `access {\n`;
                    config += `    radius-server {\n`;
                    config += `        ${params.radiusServer1} {\n`;
                    config += `            secret "${params.radiusKey1}";\n`;
                    config += `            timeout 2;\n`;
                    config += `            retry 2;\n`;
                    config += `            source-address <vlan-10-ip>;\n`;
                    config += `        }\n`;
                    
                    if (params.radiusServer2) {
                        config += `        ${params.radiusServer2} {\n`;
                        config += `            secret "${params.radiusKey2 || params.radiusKey1}";\n`;
                        config += `            timeout 2;\n`;
                        config += `            retry 2;\n`;
                        config += `            source-address <vlan-10-ip>;\n`;
                        config += `        }\n`;
                    }
                    
                    config += `    }\n`;
                    config += `    profile dot1x-profile {\n`;
                    config += `        authentication-protocol eap-peap;\n`;
                    config += `        radius-authentication-server {\n`;
                    config += `            ${params.radiusServer1};\n`;
                    
                    if (params.radiusServer2) {
                        config += `            ${params.radiusServer2};\n`;
                    }
                    
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    break;
                    
                default:
                    config += `! RADIUS Configuration\n`;
                    config += `radius-server host ${params.radiusServer1} key ${params.radiusKey1}\n`;
                    
                    if (params.radiusServer2) {
                        config += `radius-server host ${params.radiusServer2} key ${params.radiusKey2 || params.radiusKey1}\n`;
                    }
                    
                    config += `radius-server timeout 2\n`;
                    config += `radius-server retransmit 2\n`;
                    config += `radius-server deadtime 15\n`;
                    config += `aaa authentication dot1x default group radius local\n`;
                    config += `aaa authorization network default group radius local\n`;
                    config += `aaa accounting dot1x default start-stop group radius\n`;
            }
            
            return config;
        },
        
        /**
         * Generate authentication configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Authentication configuration
         */
        generateAuthenticationConfig: function(params) {
            // Create authentication configuration based on vendor and methods
            let config = '\n';
            
            // Check if any authentication method is selected
            if (!params.authMethods || params.authMethods.length === 0) {
                return '\n! Authentication Configuration (methods not selected)\n';
            }
            
            switch (params.vendor) {
                case 'cisco':
                    config += `! Authentication Configuration\n`;
                    
                    // Enable 802.1X system authentication control
                    if (params.authMethods.includes('dot1x')) {
                        config += `dot1x system-auth-control\n`;
                    }
                    
                    // Enable MACsec if selected
                    if (params.authMethods.includes('macsec')) {
                        config += `mka default-policy\n`;
                    }
                    
                    // IOS-XE with Identity-Based Networking Services (IBNS) 2.0
                    if (params.platform === 'ios-xe' && (params.authMethods.includes('dot1x') || params.authMethods.includes('mab'))) {
                        // Advanced authentication configuration with IBNS 2.0
                        config += `!\n`;
                        config += `! Convert to IBNS 2.0\n`;
                        config += `authentication convert-to new-style\n`;
                        
                        // ACL for critical authentication
                        config += `!\n`;
                        config += `ip access-list extended ACL-OPEN\n`;
                        config += ` permit ip any any\n`;
                        
                        // Critical authentication service template
                        config += `!\n`;
                        config += `service-template CRITICAL_DATA_ACCESS\n`;
                        config += ` vlan 999\n`;
                        config += ` access-group ACL-OPEN\n`;
                        
                        config += `!\n`;
                        config += `service-template CRITICAL_VOICE_ACCESS\n`;
                        config += ` voice vlan 999\n`;
                        config += ` access-group ACL-OPEN\n`;
                        
                        // Class maps for authentication
                        config += `!\n`;
                        config += `class-map type control subscriber match-all DOT1X\n`;
                        config += ` match method dot1x\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all MAB\n`;
                        config += ` match method mab\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all DOT1X_FAILED\n`;
                        config += ` match method dot1x\n`;
                        config += ` match result-type method dot1x authoritative\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all MAB_FAILED\n`;
                        config += ` match method mab\n`;
                        config += ` match result-type method mab authoritative\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all AAA_SVR_DOWN_AUTHD_HOST\n`;
                        config += ` match result-type aaa-timeout\n`;
                        config += ` match authorization-status authorized\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all AAA_SVR_DOWN_UNAUTHD_HOST\n`;
                        config += ` match result-type aaa-timeout\n`;
                        config += ` match authorization-status unauthorized\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-all IN_CRITICAL_AUTH\n`;
                        config += ` match activated-service-template CRITICAL_DATA_ACCESS\n`;
                        config += ` match activated-service-template CRITICAL_VOICE_ACCESS\n`;
                        
                        config += `!\n`;
                        config += `class-map type control subscriber match-none NOT_IN_CRITICAL_AUTH\n`;
                        config += ` match activated-service-template CRITICAL_DATA_ACCESS\n`;
                        config += ` match activated-service-template CRITICAL_VOICE_ACCESS\n`;
                        
                        // Policy map for 802.1X and MAB
                        if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                            // Policy map name based on deployment type
                            let policyMapName = 'DOT1X_MAB_POLICY';
                            if (params.deploymentType === 'concurrent') {
                                policyMapName = 'CONCURRENT_DOT1X_MAB_POLICY';
                            }
                            
                            config += `!\n`;
                            config += `policy-map type control subscriber ${policyMapName}\n`;
                            
                            // Session start event
                            config += ` event session-started match-all\n`;
                            
                            // Sequential vs Concurrent based on deployment type
                            if (params.deploymentType === 'concurrent') {
                                config += `  10 class always do-all\n`;
                                config += `   10 authenticate using dot1x priority 10\n`;
                                config += `   20 authenticate using mab priority 20\n`;
                            } else {
                                config += `  10 class always do-until-failure\n`;
                                config += `   10 authenticate using dot1x priority 10\n`;
                                config += `  20 class DOT1X_FAILED do-until-failure\n`;
                                config += `   10 authenticate using mab priority 20\n`;
                            }
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 activate service-template DEFAULT_LINKSEC_POLICY_MUST_SECURE\n`;
                            config += `   20 authorize\n`;
                            config += `   30 pause reauthentication\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n`;
                            config += `   10 clear-authenticated-data-hosts-on-port\n`;
                            config += `   20 activate service-template CRITICAL_DATA_ACCESS\n`;
                            config += `   30 activate service-template CRITICAL_VOICE_ACCESS\n`;
                            config += `   40 authorize\n`;
                            config += `   50 pause reauthentication\n`;
                            config += `  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n`;
                            config += `   10 pause reauthentication\n`;
                            config += `   20 authorize\n`;
                            config += `  30 class DOT1X_FAILED do-until-failure\n`;
                            config += `   10 authenticate using mab priority 20\n`;
                            config += `  40 class MAB_FAILED do-until-failure\n`;
                            
                            // Actions based on deployment type
                            if (params.deploymentType === 'monitor') {
                                config += `   10 authorize\n`;
                            } else if (params.failoverPolicy === 'guest' && params.authMethods.includes('webauth')) {
                                config += `   10 authenticate using webauth priority 30\n`;
                            } else if (params.failoverPolicy === 'restricted') {
                                config += `   10 activate service-template RESTRICTED_ACCESS\n`;
                                config += `   20 authorize\n`;
                                config += `   30 pause reauthentication\n`;
                            } else {
                                config += `   10 terminate dot1x\n`;
                                config += `   20 terminate mab\n`;
                                config += `   30 authentication-restart 60\n`;
                            }
                            
                            // AAA available event (for critical auth recovery)
                            config += ` event aaa-available match-all\n`;
                            config += `  10 class IN_CRITICAL_AUTH do-until-failure\n`;
                            config += `   10 clear-session\n`;
                            config += `  20 class NOT_IN_CRITICAL_AUTH do-until-failure\n`;
                            config += `   10 resume reauthentication\n`;
                            
                            // Authorization policy change event
                            config += ` event violation match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 restrict\n`;
                        }
                        // 802.1X only policy map
                        else if (params.authMethods.includes('dot1x')) {
                            config += `!\n`;
                            config += `policy-map type control subscriber DOT1X_POLICY\n`;
                            config += ` event session-started match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authenticate using dot1x priority 10\n`;
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authorize\n`;
                            config += `   20 pause reauthentication\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n`;
                            config += `   10 activate service-template CRITICAL_DATA_ACCESS\n`;
                            config += `   20 activate service-template CRITICAL_VOICE_ACCESS\n`;
                            config += `   30 authorize\n`;
                            config += `   40 pause reauthentication\n`;
                            config += `  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n`;
                            config += `   10 pause reauthentication\n`;
                            config += `   20 authorize\n`;
                            config += `  30 class always do-until-failure\n`;
                            
                            // Actions based on deployment type
                            if (params.deploymentType === 'monitor') {
                                config += `   10 authorize\n`;
                            } else if (params.failoverPolicy === 'restricted') {
                                config += `   10 activate service-template RESTRICTED_ACCESS\n`;
                                config += `   20 authorize\n`;
                                config += `   30 pause reauthentication\n`;
                            } else {
                                config += `   10 terminate dot1x\n`;
                                config += `   20 authentication-restart 60\n`;
                            }
                        }
                        // MAB only policy map
                        else if (params.authMethods.includes('mab')) {
                            config += `!\n`;
                            config += `policy-map type control subscriber MAB_POLICY\n`;
                            config += ` event session-started match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authenticate using mab priority 10\n`;
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authorize\n`;
                            config += `   20 pause reauthentication\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class AAA_SVR_DOWN_UNAUTHD_HOST do-until-failure\n`;
                            config += `   10 activate service-template CRITICAL_DATA_ACCESS\n`;
                            config += `   20 activate service-template CRITICAL_VOICE_ACCESS\n`;
                            config += `   30 authorize\n`;
                            config += `   40 pause reauthentication\n`;
                            config += `  20 class AAA_SVR_DOWN_AUTHD_HOST do-until-failure\n`;
                            config += `   10 pause reauthentication\n`;
                            config += `   20 authorize\n`;
                            config += `  30 class always do-until-failure\n`;
                            
                            // Actions based on deployment type
                            if (params.deploymentType === 'monitor') {
                                config += `   10 authorize\n`;
                            } else if (params.failoverPolicy === 'restricted') {
                                config += `   10 activate service-template RESTRICTED_ACCESS\n`;
                                config += `   20 authorize\n`;
                                config += `   30 pause reauthentication\n`;
                            } else {
                                config += `   10 terminate mab\n`;
                                config += `   20 authentication-restart 60\n`;
                            }
                        }
                        
                        // Web Authentication policy map if needed
                        if (params.authMethods.includes('webauth')) {
                            config += `!\n`;
                            config += `ip access-list extended ACL-WEBAUTH-REDIRECT\n`;
                            config += ` permit tcp any any eq www\n`;
                            config += ` permit tcp any any eq 443\n`;
                            
                            config += `!\n`;
                            config += `ip admission name WEBAUTH proxy http\n`;
                            
                            config += `!\n`;
                            config += `policy-map type control subscriber WEBAUTH_POLICY\n`;
                            config += ` event session-started match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authenticate using webauth priority 10\n`;
                            
                            // Authentication success event
                            config += ` event authentication-success match-all\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 authorize\n`;
                            
                            // Authentication failure event
                            config += ` event authentication-failure match-first\n`;
                            config += `  10 class always do-until-failure\n`;
                            config += `   10 terminate webauth\n`;
                            config += `   20 authentication-restart 60\n`;
                        }
                        
                        // Critical authentication configuration
                        config += `!\n`;
                        config += `dot1x critical eapol\n`;
                        config += `authentication critical recovery delay 2000\n`;
                    }
                    // Standard IOS authentication configuration
                    else if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab')) {
                        // Basic authentication configuration without IBNS 2.0
                        config += `!\n`;
                        config += `dot1x pae authenticator\n`;
                        config += `dot1x timeout tx-period ${params.dot1xTxPeriod}\n`;
                        config += `dot1x max-reauth-req ${params.dot1xMaxReauthReq}\n`;
                        
                        if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                            config += `dot1x critical eapol\n`;
                            
                            // Critical VLAN configuration
                            if (params.failoverPolicy === 'critical') {
                                config += `dot1x critical vlan 999\n`;
                            }
                            
                            // Configure fallback policies
                            if (params.deploymentType === 'closed') {
                                config += `authentication fallback FAILOVER\n`;
                                config += `!\n`;
                                config += `fallback profile FAILOVER\n`;
                                
                                if (params.failoverPolicy === 'restricted') {
                                    config += ` ip access-group ACL-RESTRICTED in\n`;
                                } else if (params.failoverPolicy === 'guest') {
                                    config += ` ip access-group ACL-GUEST in\n`;
                                }
                            }
                            
                            // Enable authentication features
                            config += `authentication order dot1x mab\n`;
                            config += `authentication priority dot1x mab\n`;
                        } else if (params.authMethods.includes('dot1x')) {
                            config += `authentication order dot1x\n`;
                            config += `authentication priority dot1x\n`;
                        } else if (params.authMethods.includes('mab')) {
                            config += `authentication order mab\n`;
                            config += `authentication priority mab\n`;
                        }
                        
                        // Authentication modes and settings
                        config += `authentication port-control auto\n`;
                        
                        if (params.deploymentType === 'monitor') {
                            config += `authentication open\n`;
                        }
                        
                        config += `authentication host-mode ${params.hostMode}\n`;
                        config += `authentication control-direction ${params.controlDirection}\n`;
                        config += `authentication periodic\n`;
                        config += `authentication timer reauthenticate server\n`;
                    }
                    break;
                    
                case 'aruba':
                    config += `! Authentication Configuration\n`;
                    
                    // Configure authentication modes based on methods
                    if (params.authMethods.includes('dot1x')) {
                        config += `!\n`;
                        config += `! 802.1X Configuration\n`;
                        
                        if (params.deploymentType === 'monitor') {
                            config += `aaa authentication port-access auth-mode monitor\n`;
                        } else {
                            config += `aaa authentication port-access auth-mode 1x\n`;
                        }
                        
                        config += `aaa authentication port-access dot1x username-compare other\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} client-limit ${params.hostMode === 'multi-auth' ? '32' : '1'}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} tx-period ${params.dot1xTxPeriod}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} max-requests ${params.dot1xMaxReauthReq}\n`;
                        config += `aaa port-access authenticator ${params.accessInterfaceRange} reauth-period server\n`;
                    }
                    
                    if (params.authMethods.includes('mab')) {
                        config += `!\n`;
                        config += `! MAC Authentication Configuration\n`;
                        
                        if (params.deploymentType === 'monitor') {
                            config += `aaa authentication port-access auth-mode monitor\n`;
                        } else {
                            config += `aaa authentication port-access auth-mode mac\n`;
                        }
                        
                        config += `aaa port-access mac-auth ${params.accessInterfaceRange}\n`;
                        config += `aaa port-access mac-auth ${params.accessInterfaceRange} auth-mac-format no-delimiter uppercase\n`;
                    }
                    
                    // Configure combined authentication modes
                    if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                        if (params.deploymentType === 'concurrent') {
                            config += `aaa authentication port-access auth-mode dot1x-mac\n`;
                        } else {
                            config += `aaa authentication port-access auth-mode dot1x-then-mac\n`;
                        }
                    }
                    
                    break;
                    
                case 'juniper':
                    config = `# Authentication Configuration\n`;
                    
                    if (params.authMethods.includes('dot1x')) {
                        config += `protocols {\n`;
                        config += `    dot1x {\n`;
                        config += `        authenticator {\n`;
                        config += `            interface {\n`;
                        config += `                <interface-range> {\n`;
                        config += `                    supplicant multiple;\n`;
                        config += `                    transmit-period ${params.dot1xTxPeriod};\n`;
                        config += `                    maximum-requests ${params.dot1xMaxReauthReq};\n`;
                        config += `                    server-timeout 30;\n`;
                        config += `                    authentication-profile-name dot1x-profile;\n`;
                        config += `                }\n`;
                        config += `            }\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    
                    if (params.authMethods.includes('mab')) {
                        config += `ethernet-switching-options {\n`;
                        config += `    secure-access-port {\n`;
                        config += `        interface <interface-range> {\n`;
                        config += `            mac-limit 4 action drop;\n`;
                        config += `            allowed-mac <mac-1>;\n`;
                        config += `            allowed-mac <mac-2>;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    break;
                    
                default:
                    config += `! Authentication Configuration\n`;
                    
                    if (params.authMethods.includes('dot1x')) {
                        config += `dot1x system-auth-control\n`;
                    }
            }
            
            return config;
        },
        
        /**
         * Generate security configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Security configuration
         */
        generateSecurityConfig: function(params) {
            // Create security configuration based on vendor and features
            let config = '\n';
            
            // Check if any security features are selected
            if (!params.securityFeatures || params.securityFeatures.length === 0) {
                return '\n! Security Configuration (features not selected)\n';
            }
            
            switch (params.vendor) {
                case 'cisco':
                    config += `! Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `!\n`;
                        config += `! DHCP Snooping\n`;
                        config += `ip dhcp snooping vlan 1-4094\n`;
                        config += `ip dhcp snooping information option\n`;
                        config += `ip dhcp snooping\n`;
                    }
                    
                    // Dynamic ARP Inspection
                    if (params.securityFeatures.includes('arpInspection')) {
                        config += `!\n`;
                        config += `! Dynamic ARP Inspection\n`;
                        config += `ip arp inspection vlan 1-4094\n`;
                        config += `ip arp inspection validate src-mac dst-mac ip\n`;
                    }
                    
                    // IP Source Guard
                    if (params.securityFeatures.includes('ipSourceGuard')) {
                        config += `!\n`;
                        config += `! IP Source Guard\n`;
                        config += `! (Applied on individual interfaces)\n`;
                    }
                    
                    // Storm Control - set up in interface template
                    if (params.securityFeatures.includes('stormControl')) {
                        config += `!\n`;
                        config += `! Storm Control (Applied on individual interfaces)\n`;
                    }
                    
                    // BPDU Guard - set up in interface template
                    if (params.securityFeatures.includes('bpduGuard')) {
                        config += `!\n`;
                        config += `! BPDU Guard (Applied on individual interfaces)\n`;
                        config += `spanning-tree portfast bpduguard default\n`;
                    }
                    
                    // Device Sensor
                    if (params.securityFeatures.includes('deviceSensor')) {
                        config += `!\n`;
                        config += `! Device Sensor Configuration\n`;
                        config += `device-sensor filter-list dhcp list DS_DHCP_LIST\n`;
                        config += ` option name host-name\n`;
                        config += ` option name requested-address\n`;
                        config += ` option name parameter-request-list\n`;
                        config += ` option name class-identifier\n`;
                        config += ` option name client-identifier\n`;
                        config += `device-sensor filter-spec dhcp include list DS_DHCP_LIST\n`;
                        
                        config += `!\n`;
                        config += `cdp run\n`;
                        config += `device-sensor filter-list cdp list DS_CDP_LIST\n`;
                        config += ` tlv name device-name\n`;
                        config += ` tlv name address-type\n`;
                        config += ` tlv name capabilities-type\n`;
                        config += ` tlv name platform-type\n`;
                        config += ` tlv name version-type\n`;
                        config += `device-sensor filter-spec cdp include list DS_CDP_LIST\n`;
                        
                        config += `!\n`;
                        config += `lldp run\n`;
                        config += `device-sensor filter-list lldp list DS_LLDP_LIST\n`;
                        config += ` tlv name system-name\n`;
                        config += ` tlv name system-description\n`;
                        config += ` tlv name system-capabilities\n`;
                        config += `device-sensor filter-spec lldp include list DS_LLDP_LIST\n`;
                        
                        config += `!\n`;
                        config += `device-sensor notify all-changes\n`;
                        
                        // If using RADIUS accounting with device-sensor
                        config += `!\n`;
                        config += `access-session accounting attributes filter-spec include list DS_SEND_LIST\n`;
                        config += `access-session accounting attributes filter-list DS_SEND_LIST cdp device-name platform-type\n`;
                        config += `access-session accounting attributes filter-list DS_SEND_LIST lldp system-name system-description\n`;
                        config += `access-session accounting attributes filter-list DS_SEND_LIST dhcp host-name client-identifier\n`;
                        config += `access-session authentication attributes filter-spec include list DS_SEND_LIST\n`;
                    }
                    
                    // MACsec if enabled
                    if (params.authMethods.includes('macsec')) {
                        config += `!\n`;
                        config += `! MACsec Configuration\n`;
                        config += `service-template DEFAULT_LINKSEC_POLICY_MUST_SECURE\n`;
                        config += ` linksec policy must-secure\n`;
                    }
                    break;
                    
                case 'aruba':
                    config += `! Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `!\n`;
                        config += `! DHCP Snooping\n`;
                        config += `dhcp-snooping\n`;
                        config += `dhcp-snooping vlan 1-4094\n`;
                    }
                    
                    // ARP Protection
                    if (params.securityFeatures.includes('arpInspection')) {
                        config += `!\n`;
                        config += `! ARP Protection\n`;
                        config += `arp-protect\n`;
                        config += `arp-protect vlan 1-4094\n`;
                    }
                    
                    // BPDU Guard and other features are configured on interfaces
                    break;
                    
                case 'juniper':
                    config = `# Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `forwarding-options {\n`;
                        config += `    dhcp-security {\n`;
                        config += `        group all-vlans {\n`;
                        config += `            overrides no-option82;\n`;
                        config += `            interface <interface-range> {\n`;
                        config += `                static-ip 0.0.0.0/0 mac <mac-address>;\n`;
                        config += `            }\n`;
                        config += `        }\n`;
                        config += `        dhcp-snooping;\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    
                    // ARP Inspection
                    if (params.securityFeatures.includes('arpInspection')) {
                        config += `ethernet-switching-options {\n`;
                        config += `    secure-access-port {\n`;
                        config += `        vlan all {\n`;
                        config += `            arp-inspection;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    break;
                    
                default:
                    config += `! Security Feature Configuration\n`;
                    
                    // DHCP Snooping
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += `ip dhcp snooping\n`;
                    }
            }
            
            return config;
        },
        
        /**
         * Generate interface configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Interface configuration
         */
        generateInterfaceConfig: function(params) {
            // Create interface configuration based on vendor and parameters
            let config = '\n';
            
            // Check if interface range is defined
            if (!params.accessInterfaceRange) {
                return '\n! Interface Configuration (interfaces not specified)\n';
            }
            
            switch (params.vendor) {
                case 'cisco':
                    config += `! Interface Configuration\n`;
                    
                    // Access port configuration
                    config += `!\n`;
                    config += `interface range ${params.accessInterfaceRange}\n`;
                    config += ` description 802.1X Authentication Port\n`;
                    config += ` switchport access vlan ${params.accessVlan}\n`;
                    
                    // Add voice VLAN if specified
                    if (params.voiceVlan) {
                        config += ` switchport voice vlan ${params.voiceVlan}\n`;
                    }
                    
                    config += ` switchport mode access\n`;
                    config += ` switchport nonegotiate\n`;
                    
                    // Add security features
                    if (params.securityFeatures.includes('bpduGuard')) {
                        config += ` spanning-tree portfast\n`;
                        config += ` spanning-tree bpduguard enable\n`;
                    }
                    
                    if (params.securityFeatures.includes('stormControl')) {
                        config += ` storm-control broadcast level pps 100\n`;
                        config += ` storm-control action trap\n`;
                    }
                    
                    if (params.securityFeatures.includes('ipSourceGuard')) {
                        config += ` ip verify source\n`;
                    }
                    
                    if (params.securityFeatures.includes('dhcpSnooping')) {
                        config += ` ip dhcp snooping limit rate 20\n`;
                    }
                    
                    // Add authentication features
                    if (params.authMethods.includes('dot1x')) {
                        config += ` dot1x pae authenticator\n`;
                        config += ` dot1x timeout tx-period ${params.dot1xTxPeriod}\n`;
                        config += ` dot1x max-reauth-req ${params.dot1xMaxReauthReq}\n`;
                    }
                    
                    if (params.authMethods.includes('mab')) {
                        config += ` mab\n`;
                    }
                    
                    // Device tracking for IBNS 2.0
                    if (params.platform === 'ios-xe' && params.securityFeatures.includes('deviceTracking')) {
                        config += ` device-tracking attach-policy IP-TRACKING\n`;
                    }
                    
                    // Authentication settings
                    if (params.authMethods.includes('dot1x') || params.authMethods.includes('mab')) {
                        if (params.platform === 'ios-xe') {
                            config += ` access-session host-mode ${params.hostMode}\n`;
                            config += ` access-session control-direction ${params.controlDirection}\n`;
                            
                            if (params.deploymentType !== 'monitor') {
                                config += ` access-session closed\n`;
                            }
                            
                            config += ` access-session port-control auto\n`;
                            config += ` authentication periodic\n`;
                            config += ` authentication timer reauthenticate server\n`;
                            config += ` subscriber aging inactivity-timer 60 probe\n`;
                            
                            // Determine which policy to apply
                            let policyName = '';
                            if (params.authMethods.includes('dot1x') && params.authMethods.includes('mab')) {
                                policyName = params.deploymentType === 'concurrent' ? 'CONCURRENT_DOT1X_MAB_POLICY' : 'DOT1X_MAB_POLICY';
                            } else if (params.authMethods.includes('dot1x')) {
                                policyName = 'DOT1X_POLICY';
                            } else if (params.authMethods.includes('mab')) {
                                policyName = 'MAB_POLICY';
                            }
                            
                            if (policyName) {
                                config += ` service-policy type control subscriber ${policyName}\n`;
                            }
                        } else {
                            config += ` authentication port-control auto\n`;
                            
                            if (params.deploymentType === 'monitor') {
                                config += ` authentication open\n`;
                            }
                            
                            config += ` authentication host-mode ${params.hostMode}\n`;
                            config += ` authentication control-direction ${params.controlDirection}\n`;
                            config += ` authentication periodic\n`;
                            config += ` authentication timer reauthenticate server\n`;
                        }
                    }
                    
                    // MACsec if enabled
                    if (params.authMethods.includes('macsec')) {
                        config += ` macsec\n`;
                        config += ` macsec replay-protection window-size 0\n`;
                    }
                    
                    // Web Authentication if enabled
                    if (params.authMethods.includes('webauth')) {
                        config += ` ip access-group ACL-WEBAUTH-REDIRECT in\n`;
                        config += ` ip admission WEBAUTH\n`;
                    }
                    
                    // Enable port
                    config += ` no shutdown\n`;
                    break;
                    
                case 'aruba':
                    config += `! Interface Configuration\n`;
                    
                    // Aruba has a different approach, with most auth settings configured globally
                    // Additional port-specific settings:
                    const interfaces = params.accessInterfaceRange.split(',');
                    
                    for (const iface of interfaces) {
                        config += `!\n`;
                        config += `interface ${iface}\n`;
                        config += ` name "802.1X Authentication Port"\n`;
                        
                        if (params.securityFeatures.includes('bpduGuard')) {
                            config += ` spanning-tree bpdu-guard\n`;
                            config += ` spanning-tree port-type admin-edge\n`;
                        }
                        
                        if (params.securityFeatures.includes('stormControl')) {
                            config += ` broadcast-limit 1\n`;
                            config += ` multicast-limit 1\n`;
                        }
                        
                        config += ` no shutdown\n`;
                    }
                    
                    // VLAN configuration
                    config += `!\n`;
                    config += `vlan ${params.accessVlan}\n`;
                    config += ` name "User-VLAN"\n`;
                    
                    if (params.voiceVlan) {
                        config += `!\n`;
                        config += `vlan ${params.voiceVlan}\n`;
                        config += ` name "Voice-VLAN"\n`;
                    }
                    break;
                    
                case 'juniper':
                    config = `# Interface Configuration\n`;
                    
                    // Create interface configuration
                    config += `interfaces {\n`;
                    config += `    <interface-name> {\n`;
                    config += `        unit 0 {\n`;
                    config += `            family ethernet-switching {\n`;
                    config += `                port-mode access;\n`;
                    config += `                vlan {\n`;
                    config += `                    members ${params.accessVlan};\n`;
                    config += `                }\n`;
                    
                    if (params.voiceVlan) {
                        config += `                voip {\n`;
                        config += `                    vlan ${params.voiceVlan};\n`;
                        config += `                }\n`;
                    }
                    
                    config += `            }\n`;
                    config += `        }\n`;
                    config += `    }\n`;
                    config += `}\n`;
                    
                    // Security features for interfaces
                    config += `protocols {\n`;
                    
                    if (params.securityFeatures.includes('bpduGuard')) {
                        config += `    rstp {\n`;
                        config += `        interface <interface-name> {\n`;
                        config += `            edge;\n`;
                        config += `            bpdu-block-on-edge;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                    }
                    
                    config += `}\n`;
                    
                    if (params.securityFeatures.includes('stormControl')) {
                        config += `forwarding-options {\n`;
                        config += `    storm-control-profiles default {\n`;
                        config += `        all {\n`;
                        config += `            bandwidth-percentage 80;\n`;
                        config += `        }\n`;
                        config += `    }\n`;
                        config += `}\n`;
                    }
                    break;
                    
                default:
                    config += `! Interface Configuration\n`;
                    config += `interface range ${params.accessInterfaceRange}\n`;
                    config += ` switchport access vlan ${params.accessVlan}\n`;
                    config += ` switchport mode access\n`;
            }
            
            return config;
        },
        
        /**
         * Copy configuration to clipboard
         */
        copyToClipboard: function() {
            const configOutput = document.getElementById('configOutput');
            if (!configOutput) return;
            
            // Copy configuration to clipboard
            configOutput.select();
            document.execCommand('copy');
            
            // Show success message
            this.showToast('Configuration copied to clipboard');
        },
        
        /**
         * Download configuration as a text file
         */
        downloadConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            if (!configOutput || !configOutput.value.trim()) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get vendor and platform
            const vendor = document.getElementById('vendor')?.value || 'network';
            const platform = document.getElementById('platform')?.value || 'device';
            
            // Create file name with date
            const date = new Date().toISOString().slice(0, 10);
            const fileName = `${vendor}_${platform}_config_${date}.txt`;
            
            // Create a blob and download link
            const blob = new Blob([configOutput.value], { type: 'text/plain' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = fileName;
            
            // Trigger download
            document.body.appendChild(a);
            a.click();
            
            // Clean up
            setTimeout(() => {
                document.body.removeChild(a);
                URL.revokeObjectURL(url);
            }, 0);
            
            // Show success message
            this.showToast('Configuration downloaded successfully');
        },
        
        /**
         * Validate configuration
         */
        validateConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            const validationResults = document.getElementById('validationResults');
            
            if (!configOutput || !configOutput.value.trim() || !validationResults) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get validation options
            const validateSyntax = document.getElementById('validateSyntax')?.checked || true;
            const validateSecurity = document.getElementById('validateSecurity')?.checked || false;
            const validateCompatibility = document.getElementById('validateCompatibility')?.checked || false;
            const validatePerformance = document.getElementById('validatePerformance')?.checked || false;
            
            // Simulate validation by checking common configuration elements
            const config = configOutput.value;
            const results = [];
            
            // Syntax validation
            if (validateSyntax) {
                // Check for missing 'aaa new-model'
                if (config.includes('aaa authentication') && !config.includes('aaa new-model')) {
                    results.push({
                        type: 'error',
                        message: 'AAA commands found but "aaa new-model" is missing.',
                        recommendation: 'Add "aaa new-model" before AAA commands.'
                    });
                }
                
                // Check for interface ranges without interfaces
                if (config.includes('interface range') && !/interface range\s+\w+/i.test(config)) {
                    results.push({
                        type: 'error',
                        message: 'Interface range command found without interface specifications.',
                        recommendation: 'Specify interfaces in the interface range command.'
                    });
                }
                
                // Check for missing VLAN in access port configuration
                if (config.includes('switchport mode access') && !config.includes('switchport access vlan')) {
                    results.push({
                        type: 'warning',
                        message: 'Access port configuration found without VLAN assignment.',
                        recommendation: 'Add "switchport access vlan <vlan-id>" to access ports.'
                    });
                }
                
                // Check for incomplete policy maps
                if (config.includes('policy-map') && !config.includes('class ')) {
                    results.push({
                        type: 'error',
                        message: 'Policy map found without class configuration.',
                        recommendation: 'Add class configuration to policy maps.'
                    });
                }
                
                // Check for proper command indentation
                if (/^\s+\S+/m.test(config) && !/^\s\s\S+/m.test(config)) {
                    results.push({
                        type: 'warning',
                        message: 'Inconsistent command indentation detected.',
                        recommendation: 'Use consistent indentation (2 spaces) for nested commands.'
                    });
                }
            }
            
            // Security validation
            if (validateSecurity) {
                // Check for 802.1X with dot1x system-auth-control
                if (config.includes('dot1x pae authenticator') && !config.includes('dot1x system-auth-control')) {
                    results.push({
                        type: 'error',
                        message: '802.1X interface configuration found but "dot1x system-auth-control" is missing.',
                        recommendation: 'Add "dot1x system-auth-control" to enable 802.1X globally.'
                    });
                }
                
                // Check for DHCP snooping without IP Source Guard
                if (config.includes('ip dhcp snooping') && !config.includes('ip verify source')) {
                    results.push({
                        type: 'warning',
                        message: 'DHCP snooping enabled but IP Source Guard is not configured on interfaces.',
                        recommendation: 'Consider adding "ip verify source" to protect against IP spoofing.'
                    });
                }
                
                // Check for unused native VLAN on trunks
                if (config.includes('switchport mode trunk') && !config.includes('switchport trunk native vlan')) {
                    results.push({
                        type: 'warning',
                        message: 'Trunk ports found without explicit native VLAN configuration.',
                        recommendation: 'Set unused native VLAN with "switchport trunk native vlan <vlan-id>".'
                    });
                }
                
                // Check for authentication open
                if (config.includes('authentication open') || config.includes('access-session closed') === false) {
                    results.push({
                        type: 'info',
                        message: 'Monitor mode (open authentication) is enabled.',
                        recommendation: 'This is suitable for initial deployment but should be changed to closed mode for production.'
                    });
                }
                
                // Check for critical authentication
                if ((config.includes('dot1x') || config.includes('mab')) && !config.includes('critical')) {
                    results.push({
                        type: 'warning',
                        message: 'Authentication enabled but critical authentication is not configured.',
                        recommendation: 'Add critical authentication for RADIUS server failure handling.'
                    });
                }
            }
            
            // Compatibility validation
            if (validateCompatibility) {
                // Check for new vs old style authentication commands
                if (config.includes('authentication port-control') && config.includes('access-session port-control')) {
                    results.push({
                        type: 'error',
                        message: 'Mixed old-style and new-style authentication commands detected.',
                        recommendation: 'Use consistently either old-style or new-style authentication commands.'
                    });
                }
                
                // Check for conflicting host modes
                if (config.includes('authentication host-mode multi-auth') && config.includes('dot1x host-mode')) {
                    results.push({
                        type: 'error',
                        message: 'Conflicting host mode commands detected.',
                        recommendation: 'Use either "authentication host-mode" or "dot1x host-mode" but not both.'
                    });
                }
                
                // Check for IOS vs IOS-XE commands
                if (config.includes('device-tracking attach-policy') && config.includes('ip device tracking')) {
                    results.push({
                        type: 'error',
                        message: 'Mixed IOS and IOS-XE device tracking commands detected.',
                        recommendation: 'Use consistently either IOS or IOS-XE device tracking commands.'
                    });
                }
            }
            
            // Performance validation
            if (validatePerformance) {
                // Check for excessive tx-period
                const txPeriodMatch = config.match(/tx-period\s+(\d+)/);
                if (txPeriodMatch && parseInt(txPeriodMatch[1]) > 10) {
                    results.push({
                        type: 'warning',
                        message: `TX period value (${txPeriodMatch[1]}) is high which can delay authentication.`,
                        recommendation: 'Set tx-period to a value between 5-10 seconds for better performance.'
                    });
                }
                
                // Check for sequential vs concurrent authentication
                if (config.includes('do-until-failure') && config.includes('authenticate using dot1x') && config.includes('authenticate using mab')) {
                    results.push({
                        type: 'info',
                        message: 'Sequential authentication detected (dot1x then mab).',
                        recommendation: 'Consider using concurrent authentication with "do-all" for faster authentication.'
                    });
                }
                
                // Check for RADIUS timeouts
                const timeoutMatch = config.match(/timeout\s+(\d+)/);
                if (timeoutMatch && parseInt(timeoutMatch[1]) > 5) {
                    results.push({
                        type: 'warning',
                        message: `RADIUS timeout value (${timeoutMatch[1]}) is high which can delay authentication.`,
                        recommendation: 'Set timeout to 3-5 seconds for better performance.'
                    });
                }
            }
            
            // Display validation results
            if (results.length === 0) {
                validationResults.innerHTML = `
                    <div class="validation-success">
                        <i class="fas fa-check-circle"></i>
                        <span>Validation successful! No issues found.</span>
                    </div>
                `;
            } else {
                let html = `
                    <div class="validation-summary">
                        <span>Found ${results.length} issue${results.length > 1 ? 's' : ''}.</span>
                    </div>
                    <div class="validation-issues">
                `;
                
                // Sort results by type (error, warning, info)
                results.sort((a, b) => {
                    const typeOrder = { error: 0, warning: 1, info: 2 };
                    return typeOrder[a.type] - typeOrder[b.type];
                });
                
                // Add each issue
                for (const result of results) {
                    html += `
                        <div class="validation-issue ${result.type}">
                            <div class="issue-icon">
                                <i class="fas fa-${result.type === 'error' ? 'times' : (result.type === 'warning' ? 'exclamation' : 'info')}-circle"></i>
                            </div>
                            <div class="issue-content">
                                <div class="issue-message">${result.message}</div>
                                <div class="issue-recommendation">${result.recommendation}</div>
                            </div>
                        </div>
                    `;
                }
                
                html += `</div>`;
                validationResults.innerHTML = html;
                
                // Add validation styles if not already added
                this.addValidationStyles();
            }
        },
        
        /**
         * Add validation styles to document
         */
        addValidationStyles: function() {
            if (!document.getElementById('validationStyles')) {
                const style = document.createElement('style');
                style.id = 'validationStyles';
                style.innerHTML = `
                    .validation-success {
                        background-color: #d4edda;
                        color: #155724;
                        padding: 15px;
                        border-radius: 4px;
                        display: flex;
                        align-items: center;
                    }
                    
                    .validation-success i {
                        font-size: 20px;
                        margin-right: 10px;
                    }
                    
                    .validation-summary {
                        margin-bottom: 15px;
                        font-weight: 500;
                    }
                    
                    .validation-issues {
                        display: flex;
                        flex-direction: column;
                        gap: 10px;
                    }
                    
                    .validation-issue {
                        display: flex;
                        padding: 10px;
                        border-radius: 4px;
                    }
                    
                    .validation-issue.error {
                        background-color: #f8d7da;
                        color: #721c24;
                    }
                    
                    .validation-issue.warning {
                        background-color: #fff3cd;
                        color: #856404;
                    }
                    
                    .validation-issue.info {
                        background-color: #d1ecf1;
                        color: #0c5460;
                    }
                    
                    .issue-icon {
                        margin-right: 10px;
                        font-size: 18px;
                        display: flex;
                        align-items: center;
                    }
                    
                    .issue-content {
                        flex: 1;
                    }
                    
                    .issue-message {
                        font-weight: 500;
                        margin-bottom: 5px;
                    }
                    
                    .issue-recommendation {
                        font-size: 14px;
                    }
                `;
                document.head.appendChild(style);
            }
        },
        
        /**
         * Show toast message
         * @param {string} message - Message to display
         */
        showToast: function(message) {
            // Create toast element
            const toast = document.createElement('div');
            toast.className = 'toast-notification';
            toast.innerHTML = `
                <div class="toast-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="toast-message">
                    ${message}
                </div>
            `;
            
            // Add to body
            document.body.appendChild(toast);
            
            // Remove after 3 seconds
            setTimeout(() => {
                toast.classList.add('toast-hide');
                setTimeout(() => {
                    document.body.removeChild(toast);
                }, 500);
            }, 3000);
        }
    };

    // Initialize Template Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        TemplateGenerator.init();
    });

    // Export to window
    window.TemplateGenerator = TemplateGenerator;
})();
EOF

# Create validation script
print_message "Creating validation script..."
cat > js/validation.js << 'EOF'
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
EOF

# Create AI assistant script
print_message "Creating AI assistant script..."
cat > js/ai-assistant.js << 'EOF'
/**
 * UaXSupreme - AI Assistant
 * Provides AI-powered assistance for network configuration
 */

(function() {
    'use strict';

    // AI Assistant object
    const AIAssistant = {
        /**
         * Initialize AI Assistant
         */
        init: function() {
            console.log('Initializing AI Assistant...');
            
            // Set up event listeners
            this.setupEventListeners();
            
            // Load AI model capabilities
            this.capabilities = {
                dot1x: true,
                mab: true,
                webauth: true,
                radsec: true,
                tacacs: true,
                macsec: true,
                deviceTracking: true,
                dACL: true,
                sgacl: true,
                avc: true,
                cisco: true,
                aruba: true,
                juniper: true,
                fortinet: true,
                extreme: true,
                dell: true
            };
            
            // Load knowledge base
            this.loadKnowledgeBase();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // AI Assistant button
            const aiAssistBtn = document.getElementById('aiAssistBtn');
            if (aiAssistBtn) {
                aiAssistBtn.addEventListener('click', this.showAssistant.bind(this));
            }
            
            // Close button for AI Assistant modal
            const closeAIModal = document.querySelector('#aiAssistantModal .close');
            if (closeAIModal) {
                closeAIModal.addEventListener('click', this.hideAssistant.bind(this));
            }
            
            // Send message button
            const sendMessageBtn = document.getElementById('sendMessageBtn');
            if (sendMessageBtn) {
                sendMessageBtn.addEventListener('click', this.sendMessage.bind(this));
            }
            
            // Send message on Enter key
            const userMessage = document.getElementById('userMessage');
            if (userMessage) {
                userMessage.addEventListener('keydown', function(e) {
                    if (e.key === 'Enter') {
                        AIAssistant.sendMessage();
                    }
                });
            }
            
            // Suggested question buttons
            const suggestionBtns = document.querySelectorAll('.suggestion-btn');
            suggestionBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const message = this.textContent;
                    document.getElementById('userMessage').value = message;
                    AIAssistant.sendMessage();
                });
            });
        },
        
        /**
         * Load knowledge base for AI Assistant
         */
        loadKnowledgeBase: function() {
            // In a real implementation, this would load from a database or API
            // For now, we'll use a simple object
            this.knowledgeBase = {
                'dot1x': {
                    description: '802.1X is an IEEE standard for port-based Network Access Control (PNAC). It provides an authentication mechanism to devices wishing to connect to a LAN or WLAN.',
                    components: [
                        'Supplicant - The client device requesting access',
                        'Authenticator - The network device (switch, access point)',
                        'Authentication Server - RADIUS server (e.g., Cisco ISE, Aruba ClearPass)'
                    ],
                    benefits: [
                        'Strong security with user-based authentication',
                        'Dynamic policy assignment (VLAN, ACL, QoS)',
                        'Integration with identity stores (AD, LDAP)',
                        'Support for certificate-based authentication'
                    ],
                    configuration: {
                        cisco: 'dot1x system-auth-control\n\ninterface GigabitEthernet1/0/1\n switchport mode access\n dot1x pae authenticator\n authentication port-control auto',
                        aruba: 'aaa authentication port-access eap-radius\naaa port-access authenticator 1/1\naaa port-access authenticator active'
                    }
                },
                'mab': {
                    description: 'MAC Authentication Bypass (MAB) allows devices that do not support 802.1X to be authenticated based on their MAC address.',
                    use_cases: [
                        'Printers, IP phones, and IoT devices',
                        'Legacy devices without 802.1X supplicant',
                        'Fallback mechanism when 802.1X fails'
                    ],
                    benefits: [
                        'Support for non-802.1X capable devices',
                        'Simplified deployment for specific device types',
                        'Can be used as fallback for 802.1X'
                    ],
                    configuration: {
                        cisco: 'interface GigabitEthernet1/0/1\n switchport mode access\n mab\n authentication port-control auto',
                        aruba: 'aaa authentication port-access mac-auth\naaa port-access mac-auth 1/1\naaa port-access mac-auth active'
                    }
                },
                'closed vs monitor': {
                    description: 'Closed mode enforces authentication, while Monitor mode allows traffic regardless of authentication outcome.',
                    comparison: [
                        {
                            name: 'Closed Mode',
                            description: 'Authentication is enforced and only authorized traffic is allowed.',
                            use_case: 'Production environments where security is critical.',
                            cisco_config: 'access-session closed\nauthentication port-control auto',
                            aruba_config: 'aaa authentication port-access auth-mode 1x'
                        },
                        {
                            name: 'Monitor Mode',
                            description: 'Authentication occurs but all traffic is allowed regardless of result.',
                            use_case: 'Testing and initial deployment phases.',
                            cisco_config: 'authentication open\nauthentication port-control auto',
                            aruba_config: 'aaa authentication port-access auth-mode monitor'
                        }
                    ],
                    recommendation: 'Start with Monitor Mode during deployment to identify and fix issues, then transition to Closed Mode for production.'
                },
                'troubleshooting 802.1x': {
                    description: 'Common steps for troubleshooting 802.1X authentication issues.',
                    steps: [
                        {
                            name: 'Verify Configuration',
                            commands: [
                                'show authentication sessions interface <interface>',
                                'show dot1x all',
                                'show dot1x interface <interface> details'
                            ]
                        },
                        {
                            name: 'Check RADIUS Connectivity',
                            commands: [
                                'test aaa group radius <username> <password> new-code',
                                'show radius statistics',
                                'debug radius authentication'
                            ]
                        },
                        {
                            name: 'Monitor Authentication Process',
                            commands: [
                                'debug dot1x all',
                                'debug authentication all',
                                'debug radius authentication'
                            ]
                        },
                        {
                            name: 'Check Client Status',
                            actions: [
                                'Verify supplicant configuration on client',
                                'Check client logs',
                                'Ensure proper credentials are being used'
                            ]
                        },
                        {
                            name: 'Verify Policy Application',
                            commands: [
                                'show access-session interface <interface> details',
                                'show authentication sessions interface <interface> details',
                                'show ip access-list'
                            ]
                        }
                    ],
                    common_issues: [
                        'RADIUS server unreachable',
                        'Certificate validation issues',
                        'Incompatible EAP methods',
                        'Missing or incorrect AAA configuration',
                        'Incorrect VLAN assignment',
                        'Authorization policy misconfiguration'
                    ]
                },
                'radius redundancy': {
                    description: 'Best practices for RADIUS server redundancy and high availability.',
                    best_practices: [
                        'Configure at least two RADIUS servers',
                        'Implement RADIUS server load balancing',
                        'Configure appropriate timeouts and deadtime',
                        'Use RADIUS server testing probes',
                        'Configure critical authentication for RADIUS server failure',
                        'Implement local authentication fallback',
                        'Monitor RADIUS server health'
                    ],
                    configuration: {
                        cisco_ios_xe: 'radius server RAD-SERVER-1\n address ipv4 10.1.1.1 auth-port 1812 acct-port 1813\n key <key>\n automate-tester username probe-user probe-on\n\nradius server RAD-SERVER-2\n address ipv4 10.1.1.2 auth-port 1812 acct-port 1813\n key <key>\n automate-tester username probe-user probe-on\n\naaa group server radius RAD-SERVERS\n server name RAD-SERVER-1\n server name RAD-SERVER-2\n deadtime 15\n load-balance method least-outstanding\n\naaa authentication dot1x default group RAD-SERVERS local\naaa authorization network default group RAD-SERVERS local\n\nradius-server dead-criteria time 5 tries 3\n\ndot1x critical eapol\nauthentication critical recovery delay 2000',
                        cisco_ios: 'radius-server host 10.1.1.1 auth-port 1812 acct-port 1813 key <key>\nradius-server host 10.1.1.2 auth-port 1812 acct-port 1813 key <key>\nradius-server deadtime 15\naaa group server radius RAD-SERVERS\n server 10.1.1.1 auth-port 1812 acct-port 1813\n server 10.1.1.2 auth-port 1812 acct-port 1813\naaa authentication dot1x default group RAD-SERVERS local\naaa authorization network default group RAD-SERVERS local\ndot1x critical eapol'
                    }
                },
                'mab for printers': {
                    description: 'Configuration for MAC Authentication Bypass (MAB) for printers and non-802.1X capable devices.',
                    configuration_steps: [
                        {
                            step: 'Enable AAA',
                            cisco_config: 'aaa new-model\naaa authentication dot1x default group radius\naaa authorization network default group radius'
                        },
                        {
                            step: 'Configure RADIUS',
                            cisco_config: 'radius server RADIUS-SERVER\n address ipv4 10.1.1.1 auth-port 1812 acct-port 1813\n key <key>'
                        },
                        {
                            step: 'Configure Authentication Global Settings',
                            cisco_config: 'dot1x system-auth-control\nip device tracking'
                        },
                        {
                            step: 'Configure Interface for MAB',
                            cisco_config: 'interface GigabitEthernet1/0/10\n description Printer\n switchport access vlan 20\n switchport mode access\n mab\n authentication port-control auto\n authentication order mab\n authentication priority mab\n spanning-tree portfast'
                        },
                        {
                            step: 'Configure RADIUS Server',
                            notes: [
                                'Add printer MAC addresses to RADIUS server',
                                'Configure authorization policy to assign appropriate VLAN and permissions',
                                'Set authentication method to MAC address'
                            ]
                        }
                    ],
                    best_practices: [
                        'Use dedicated VLAN for printers',
                        'Implement IP source guard for additional security',
                        'Consider using ACLs to restrict printer communications',
                        'Regularly audit authorized MAC addresses',
                        'Monitor for suspicious activity from printer VLAN'
                    ]
                },
                'ibns vs legacy': {
                    description: 'Identity-Based Networking Services (IBNS) 2.0 is Cisco\'s framework for identity and access control using new authentication commands.',
                    comparison: [
                        {
                            name: 'Legacy 802.1X',
                            commands: [
                                'dot1x pae authenticator',
                                'dot1x port-control auto',
                                'authentication host-mode multi-auth',
                                'authentication order dot1x mab',
                                'authentication priority dot1x mab'
                            ],
                            limitations: [
                                'Limited flexibility',
                                'Restricted policy application',
                                'Sequential authentication only',
                                'Limited failure handling'
                            ]
                        },
                        {
                            name: 'IBNS 2.0',
                            commands: [
                                'dot1x pae authenticator',
                                'access-session port-control auto',
                                'access-session host-mode multi-auth',
                                'service-policy type control subscriber POLICY_NAME'
                            ],
                            advantages: [
                                'Flexible policy definition',
                                'Event-driven policy control',
                                'Concurrent authentication',
                                'Fine-grained failure handling',
                                'Improved critical authentication',
                                'Service templates for policy application'
                            ]
                        }
                    ],
                    migration: [
                        'Use "authentication convert-to new-style" command',
                        'Create policy-maps for different authentication scenarios',
                        'Define service templates for policy application',
                        'Update interface configurations to use new commands'
                    ]
                },
                'radsec': {
                    description: 'RADIUS over TLS (RadSec) provides secure RADIUS communications using TLS encryption.',
                    benefits: [
                        'Encrypted RADIUS traffic',
                        'Mutual authentication using certificates',
                        'TCP transport for better reliability',
                        'Better high availability support',
                        'Protection of RADIUS credentials and attributes'
                    ],
                    requirements: [
                        'TLS-capable network devices',
                        'PKI infrastructure',
                        'TCP port 2083 connectivity',
                        'RADIUS servers with RadSec support'
                    ],
                    configuration: {
                        cisco: 'crypto pki trustpoint RADSEC-CLIENT\n enrollment self\n revocation-check none\n rsakeypair RADSEC-KEY 2048\n\ncrypto pki trustpoint RADSEC-SERVER\n enrollment terminal\n revocation-check none\n\nradius server RADSEC-SERVER\n address ipv4 10.1.1.1 auth-port 2083 acct-port 2083\n tls connectiontimeout 5\n tls trustpoint client RADSEC-CLIENT\n tls trustpoint server RADSEC-SERVER\n key <key>\n\naaa group server radius RADSEC-GROUP\n server name RADSEC-SERVER\n\naaa authentication dot1x default group RADSEC-GROUP\naaa authorization network default group RADSEC-GROUP'
                    },
                    when_to_use: 'RadSec should be used when RADIUS traffic traverses untrusted networks, when security compliance requires encryption of authentication traffic, or in environments with high security requirements.'
                }
            };
        },
        
        /**
         * Show AI Assistant modal
         */
        showAssistant: function() {
            const modal = document.getElementById('aiAssistantModal');
            if (modal) {
                modal.style.display = 'block';
                
                // Focus on message input
                setTimeout(() => {
                    const userMessage = document.getElementById('userMessage');
                    if (userMessage) {
                        userMessage.focus();
                    }
                }, 300);
            }
        },
        
        /**
         * Hide AI Assistant modal
         */
        hideAssistant: function() {
            const modal = document.getElementById('aiAssistantModal');
            if (modal) {
                modal.style.display = 'none';
            }
        },
        
        /**
         * Send message to AI Assistant
         */
        sendMessage: function() {
            const userMessage = document.getElementById('userMessage');
            const chatMessages = document.getElementById('chatMessages');
            
            if (!userMessage || !chatMessages) return;
            
            // Get user message
            const message = userMessage.value.trim();
            if (!message) return;
            
            // Clear input
            userMessage.value = '';
            
            // Add user message to chat
            chatMessages.innerHTML += `
                <div class="user-message">
                    <div class="message-content">
                        <p>${this.escapeHTML(message)}</p>
                    </div>
                    <div class="message-avatar"><i class="fas fa-user"></i></div>
                </div>
            `;
            
            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Generate AI response
            this.generateResponse(message);
        },
        
        /**
         * Generate AI response to user message
         * @param {string} message - User message
         */
        generateResponse: function(message) {
            // Simulate typing indicator
            const chatMessages = document.getElementById('chatMessages');
            
            const typingIndicator = document.createElement('div');
            typingIndicator.className = 'ai-message typing-indicator';
            typingIndicator.innerHTML = `
                <div class="message-avatar"><i class="fas fa-robot"></i></div>
                <div class="message-content">
                    <p>Thinking<span class="typing-dots">...</span></p>
                </div>
            `;
            
            chatMessages.appendChild(typingIndicator);
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Animate typing dots
            let dots = 0;
            const dotsInterval = setInterval(() => {
                const dotsElement = typingIndicator.querySelector('.typing-dots');
                dots = (dots + 1) % 4;
                dotsElement.textContent = '.'.repeat(dots);
            }, 500);
            
            // Process the message and generate a response
            setTimeout(() => {
                // Clear typing indicator
                clearInterval(dotsInterval);
                chatMessages.removeChild(typingIndicator);
                
                // Get response based on message
                const response = this.getResponseForMessage(message);
                
                // Add AI response to chat
                chatMessages.innerHTML += `
                    <div class="ai-message">
                        <div class="message-avatar"><i class="fas fa-robot"></i></div>
                        <div class="message-content">
                            ${response}
                        </div>
                    </div>
                `;
                
                // Scroll to bottom
                chatMessages.scrollTop = chatMessages.scrollHeight;
            }, 1000 + Math.random() * 1000); // Random delay between 1-2 seconds
        },
        
        /**
         * Get response for user message
         * @param {string} message - User message
         * @returns {string} AI response
         */
        getResponseForMessage: function(message) {
            // Convert message to lowercase for easier matching
            const lowerMessage = message.toLowerCase();
            
            // Check for specific topics
            if (lowerMessage.includes('closed') && lowerMessage.includes('monitor') && 
                (lowerMessage.includes('mode') || lowerMessage.includes('difference'))) {
                return this.generateKnowledgeResponse('closed vs monitor');
            }
            
            if ((lowerMessage.includes('trouble') || lowerMessage.includes('debug')) && 
                lowerMessage.includes('802.1x')) {
                return this.generateKnowledgeResponse('troubleshooting 802.1x');
            }
            
            if (lowerMessage.includes('radius') && 
                (lowerMessage.includes('redundancy') || lowerMessage.includes('redundant') || 
                 lowerMessage.includes('ha') || lowerMessage.includes('high availability'))) {
                return this.generateKnowledgeResponse('radius redundancy');
            }
            
            if (lowerMessage.includes('mab') && 
                (lowerMessage.includes('printer') || lowerMessage.includes('printers'))) {
                return this.generateKnowledgeResponse('mab for printers');
            }
            
            if ((lowerMessage.includes('ibns') || lowerMessage.includes('new-style')) && 
                (lowerMessage.includes('legacy') || lowerMessage.includes('traditional') || 
                 lowerMessage.includes('old') || lowerMessage.includes('differ'))) {
                return this.generateKnowledgeResponse('ibns vs legacy');
            }
            
            if (lowerMessage.includes('radsec') || 
                (lowerMessage.includes('radius') && lowerMessage.includes('tls'))) {
                return this.generateKnowledgeResponse('radsec');
            }
            
            // Check for general authentication terms
            if (lowerMessage.includes('802.1x') || 
                lowerMessage.includes('dot1x') || 
                (lowerMessage.includes('ieee') && lowerMessage.includes('802.1x'))) {
                return this.generateKnowledgeResponse('dot1x');
            }
            
            if (lowerMessage.includes('mab') || 
                lowerMessage.includes('mac authentication bypass') || 
                (lowerMessage.includes('mac') && lowerMessage.includes('authentication'))) {
                return this.generateKnowledgeResponse('mab');
            }
            
            // Generic responses for other questions
            if (lowerMessage.includes('hello') || lowerMessage.includes('hi ')) {
                return '<p>Hello! How can I help you with your authentication configuration today?</p>';
            }
            
            if (lowerMessage.includes('thank')) {
                return '<p>You\'re welcome! If you need any more help, just ask.</p>';
            }
            
            // Default response for unrecognized questions
            return `
                <p>I don't have a specific answer for that question. Here are some topics I can help with:</p>
                <ul>
                    <li>802.1X authentication configuration</li>
                    <li>MAC Authentication Bypass (MAB) setup</li>
                    <li>Closed vs. Monitor mode differences</li>
                    <li>Troubleshooting 802.1X authentication</li>
                    <li>RADIUS server redundancy</li>
                    <li>MAB configuration for printers</li>
                    <li>IBNS 2.0 vs traditional 802.1X</li>
                    <li>RadSec implementation</li>
                </ul>
                <p>Please ask about one of these topics or rephrase your question.</p>
            `;
        },
        
        /**
         * Generate knowledge-based response
         * @param {string} topic - Knowledge base topic
         * @returns {string} Formatted response
         */
        generateKnowledgeResponse: function(topic) {
            const knowledge = this.knowledgeBase[topic];
            if (!knowledge) {
                return `<p>I don't have specific information about ${topic}. Please try asking about another topic.</p>`;
            }
            
            let response = '';
            
            // Add description
            if (knowledge.description) {
                response += `<p>${knowledge.description}</p>`;
            }
            
            // Add components if available
            if (knowledge.components) {
                response += '<p><strong>Components:</strong></p><ul>';
                knowledge.components.forEach(component => {
                    response += `<li>${component}</li>`;
                });
                response += '</ul>';
            }
            
            // Add benefits if available
            if (knowledge.benefits) {
                response += '<p><strong>Benefits:</strong></p><ul>';
                knowledge.benefits.forEach(benefit => {
                    response += `<li>${benefit}</li>`;
                });
                response += '</ul>';
            }
            
            // Add use cases if available
            if (knowledge.use_cases) {
                response += '<p><strong>Use Cases:</strong></p><ul>';
                knowledge.use_cases.forEach(use_case => {
                    response += `<li>${use_case}</li>`;
                });
                response += '</ul>';
            }
            
            // Add comparison if available
            if (knowledge.comparison) {
                knowledge.comparison.forEach(item => {
                    response += `<p><strong>${item.name}:</strong> ${item.description || ''}</p>`;
                    
                    if (item.commands) {
                        response += '<p>Configuration:</p><pre>';
                        item.commands.forEach(cmd => {
                            response += `${cmd}\n`;
                        });
                        response += '</pre>';
                    }
                    
                    if (item.advantages) {
                        response += '<p>Advantages:</p><ul>';
                        item.advantages.forEach(adv => {
                            response += `<li>${adv}</li>`;
                        });
                        response += '</ul>';
                    }
                    
                    if (item.limitations) {
                        response += '<p>Limitations:</p><ul>';
                        item.limitations.forEach(lim => {
                            response += `<li>${lim}</li>`;
                        });
                        response += '</ul>';
                    }
                    
                    if (item.use_case) {
                        response += `<p>Use Case: ${item.use_case}</p>`;
                    }
                });
            }
            
            // Add migration steps if available
            if (knowledge.migration) {
                response += '<p><strong>Migration Steps:</strong></p><ul>';
                knowledge.migration.forEach(step => {
                    response += `<li>${step}</li>`;
                });
                response += '</ul>';
            }
            
            // Add steps if available
            if (knowledge.steps) {
                response += '<p><strong>Troubleshooting Steps:</strong></p>';
                knowledge.steps.forEach(step => {
                    response += `<p><strong>${step.name}</strong></p>`;
                    
                    if (step.commands) {
                        response += '<p>Commands to use:</p><pre>';
                        step.commands.forEach(cmd => {
                            response += `${cmd}\n`;
                        });
                        response += '</pre>';
                    }
                    
                    if (step.actions) {
                        response += '<ul>';
                        step.actions.forEach(action => {
                            response += `<li>${action}</li>`;
                        });
                        response += '</ul>';
                    }
                });
            }
            
            // Add best practices if available
            if (knowledge.best_practices) {
                response += '<p><strong>Best Practices:</strong></p><ul>';
                knowledge.best_practices.forEach(practice => {
                    response += `<li>${practice}</li>`;
                });
                response += '</ul>';
            }
            
            // Add common issues if available
            if (knowledge.common_issues) {
                response += '<p><strong>Common Issues:</strong></p><ul>';
                knowledge.common_issues.forEach(issue => {
                    response += `<li>${issue}</li>`;
                });
                response += '</ul>';
            }
            
            // Add configuration steps if available
            if (knowledge.configuration_steps) {
                response += '<p><strong>Configuration Steps:</strong></p>';
                knowledge.configuration_steps.forEach((step, index) => {
                    response += `<p>${index + 1}. <strong>${step.step}</strong></p>`;
                    
                    if (step.cisco_config) {
                        response += '<pre>' + step.cisco_config + '</pre>';
                    }
                    
                    if (step.notes) {
                        response += '<ul>';
                        step.notes.forEach(note => {
                            response += `<li>${note}</li>`;
                        });
                        response += '</ul>';
                    }
                });
            }
            
            // Add configuration examples if available
            if (knowledge.configuration) {
                response += '<p><strong>Configuration Examples:</strong></p>';
                
                if (typeof knowledge.configuration === 'object') {
                    // Multiple configuration examples
                    for (const [platform, config] of Object.entries(knowledge.configuration)) {
                        response += `<p><strong>${platform.replace(/_/g, ' ')}:</strong></p><pre>${config}</pre>`;
                    }
                } else {
                    // Single configuration example
                    response += `<pre>${knowledge.configuration}</pre>`;
                }
            }
            
            // Add recommendation if available
            if (knowledge.recommendation) {
                response += `<p><strong>Recommendation:</strong> ${knowledge.recommendation}</p>`;
            }
            
            // Add when to use if available
            if (knowledge.when_to_use) {
                response += `<p><strong>When to Use:</strong> ${knowledge.when_to_use}</p>`;
            }
            
            // Add requirements if available
            if (knowledge.requirements) {
                response += '<p><strong>Requirements:</strong></p><ul>';
                knowledge.requirements.forEach(req => {
                    response += `<li>${req}</li>`;
                });
                response += '</ul>';
            }
            
            return response;
        },
        
        /**
         * Escape HTML special characters
         * @param {string} html - String to escape
         * @returns {string} Escaped string
         */
        escapeHTML: function(html) {
            const div = document.createElement('div');
            div.textContent = html;
            return div.innerHTML;
        }
    };

    // Initialize AI Assistant on page load
    document.addEventListener('DOMContentLoaded', function() {
        AIAssistant.init();
    });

    // Export to window
    window.AIAssistant = AIAssistant;
})();
EOF

# Create AI analyzer module
print_message "Creating AI analyzer module..."
cat > js/ai-analyzer.js << 'EOF'
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
EOF

# Create diagram generator
print_message "Creating diagram generator..."
cat > js/diagram-generator.js << 'EOF'
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
EOF

# Create documentation module
print_message "Creating documentation module..."
cat > js/documentation.js << 'EOF'
/**
 * UaXSupreme - Documentation Generator
 * Generates deployment documentation for authentication implementations
 */

(function() {
    'use strict';

    // Documentation Generator object
    const DocumentationGenerator = {
        /**
         * Initialize Documentation Generator
         */
        init: function() {
            console.log('Initializing Documentation Generator...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Generate documentation button
            const generateDocBtn = document.getElementById('generateDocBtn');
            if (generateDocBtn) {
                generateDocBtn.addEventListener('click', this.generateDocumentation.bind(this));
            }
            
            // Download documentation button
            const downloadDocBtn = document.getElementById('downloadDocBtn');
            if (downloadDocBtn) {
                downloadDocBtn.addEventListener('click', this.downloadDocumentation.bind(this));
            }
            
            // Generate checklist button
            const generateChecklistBtn = document.getElementById('generateChecklistBtn');
            if (generateChecklistBtn) {
                generateChecklistBtn.addEventListener('click', this.generateChecklist.bind(this));
            }
            
            // Download checklist button
            const downloadChecklistBtn = document.getElementById('downloadChecklistBtn');
            if (downloadChecklistBtn) {
                downloadChecklistBtn.addEventListener('click', this.downloadChecklist.bind(this));
            }
            
            // Generate troubleshooting guide button
            const generateTroubleshootingBtn = document.getElementById('generateTroubleshootingBtn');
            if (generateTroubleshootingBtn) {
                generateTroubleshootingBtn.addEventListener('click', this.generateTroubleshootingGuide.bind(this));
            }
            
            // Download troubleshooting guide button
            const downloadTroubleshootingBtn = document.getElementById('downloadTroubleshootingBtn');
            if (downloadTroubleshootingBtn) {
                downloadTroubleshootingBtn.addEventListener('click', this.downloadTroubleshootingGuide.bind(this));
            }
        },
        
        /**
         * Generate documentation
         */
        generateDocumentation: function() {
            const configOutput = document.getElementById('configOutput');
            const documentationPreview = document.getElementById('documentationPreview');
            
            if (!configOutput || !configOutput.value.trim() || !documentationPreview) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get the configuration
            const config = configOutput.value;
            
            // Get documentation options
            const docFormat = document.getElementById('docFormat').value;
            const includeConfig = document.getElementById('includeConfig').checked;
            const includeDeployment = document.getElementById('includeDeployment').checked;
            const includeVerification = document.getElementById('includeVerification').checked;
            
            // Parse configuration parameters
            const params = this.parseConfigParameters(config);
            
            // Generate documentation HTML
            let docHTML = `
                <div class="doc-header">
                    <h1>Network Authentication Implementation Documentation</h1>
                    <p class="doc-meta">Generated on: ${new Date().toLocaleDateString()}</p>
                </div>
                
                <div class="doc-section">
                    <h2>1. Overview</h2>
                    <p>This document provides details for the implementation of network authentication using ${params.authMethods.join(', ')} on ${params.vendor} ${params.platform} platform.</p>
                    
                    <h3>1.1 Authentication Methods</h3>
                    <ul>
            `;
            
            // Add authentication methods details
            params.authMethods.forEach(method => {
                docHTML += `<li><strong>${this.getFullMethodName(method)}</strong>: ${this.getMethodDescription(method)}</li>`;
            });
            
            docHTML += `
                    </ul>
                    
                    <h3>1.2 Implementation Summary</h3>
                    <table class="doc-table">
                        <tr>
                            <th>Item</th>
                            <th>Value</th>
                        </tr>
                        <tr>
                            <td>Network Vendor</td>
                            <td>${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)}</td>
                        </tr>
                        <tr>
                            <td>Platform</td>
                            <td>${params.platform}</td>
                        </tr>
                        <tr>
                            <td>Authentication Methods</td>
                            <td>${params.authMethods.map(m => this.getFullMethodName(m)).join(', ')}</td>
                        </tr>
                        <tr>
                            <td>RADIUS Servers</td>
                            <td>${params.radiusServers.length > 0 ? params.radiusServers.join('<br>') : 'None'}</td>
                        </tr>
                        <tr>
                            <td>Host Mode</td>
                            <td>${params.hostMode || 'Not specified'}</td>
                        </tr>
                        <tr>
                            <td>Deployment Type</td>
                            <td>${params.deploymentType || 'Standard'}</td>
                        </tr>
                    </table>
                </div>
            `;
            
            // Add architecture section
            docHTML += this.generateArchitectureSection(params);
            
            // Add configuration section if requested
            if (includeConfig) {
                docHTML += this.generateConfigurationSection(config, params);
            }
            
            // Add deployment section if requested
            if (includeDeployment) {
                docHTML += this.generateDeploymentSection(params);
            }
            
            // Add verification section if requested
            if (includeVerification) {
                docHTML += this.generateVerificationSection(params);
            }
            
            // Add troubleshooting section
            docHTML += this.generateTroubleshootingSection(params);
            
            // Add appendices
            docHTML += `
                <div class="doc-section">
                    <h2>Appendix A: Reference Documents</h2>
                    <ul>
                        <li><a href="#">${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)} ${params.platform.toUpperCase()} Configuration Guide</a></li>
                        <li><a href="#">IEEE 802.1X Standard</a></li>
                        <li><a href="#">RADIUS Protocol (RFC 2865)</a></li>
                    </ul>
                </div>
            `;
            
            // Apply document format
            if (docFormat === 'formal') {
                documentationPreview.className = 'documentation-preview formal';
            } else if (docFormat === 'technical') {
                documentationPreview.className = 'documentation-preview technical';
            } else {
                documentationPreview.className = 'documentation-preview standard';
            }
            
            // Apply document style
            this.applyDocumentStyle(docFormat);
            
            // Set the documentation HTML
            documentationPreview.innerHTML = docHTML;
        },
        
        /**
         * Generate architecture section
         * @param {Object} params - Configuration parameters
         * @returns {string} Architecture section HTML
         */
        generateArchitectureSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>2. Architecture</h2>
                    
                    <h3>2.1 Logical Architecture</h3>
                    <p>The authentication architecture consists of the following components:</p>
                    <ul>
                        <li><strong>Supplicants</strong>: End-user devices that authenticate to the network</li>
                        <li><strong>Authenticators</strong>: ${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)} ${params.platform} switches that enforce authentication</li>
                        <li><strong>Authentication Servers</strong>: RADIUS servers that validate credentials and return policy attributes</li>
                    </ul>
                    
                    <div class="doc-image-placeholder">
                        [Logical Architecture Diagram]
                    </div>
                    
                    <h3>2.2 Authentication Flow</h3>
                    <p>The authentication process follows these steps:</p>
                    <ol>
                        <li>Client connects to the network port</li>
                        <li>Switch initiates authentication (${params.authMethods.includes('dot1x') ? 'sends EAPOL-Start' : 'checks MAC address'})</li>
                        <li>Client responds with credentials</li>
                        <li>Switch forwards authentication request to RADIUS server</li>
                        <li>RADIUS server validates credentials and returns attributes (VLAN, ACLs, etc.)</li>
                        <li>Switch applies policies and permits access</li>
                    </ol>
                    
                    <div class="doc-image-placeholder">
                        [Authentication Flow Diagram]
                    </div>
                    
                    <h3>2.3 Security Policies</h3>
                    <p>The implementation includes the following security policies:</p>
                    <ul>
                        ${params.authMethods.includes('dot1x') ? '<li>802.1X port-based authentication</li>' : ''}
                        ${params.authMethods.includes('mab') ? '<li>MAC Authentication Bypass for non-802.1X devices</li>' : ''}
                        ${params.authMethods.includes('webauth') ? '<li>Web Authentication for guest access</li>' : ''}
                        ${params.securityFeatures.includes('dhcpSnooping') ? '<li>DHCP Snooping for DHCP security</li>' : ''}
                        ${params.securityFeatures.includes('arpInspection') ? '<li>Dynamic ARP Inspection for ARP spoofing prevention</li>' : ''}
                        ${params.securityFeatures.includes('ipSourceGuard') ? '<li>IP Source Guard for IP spoofing prevention</li>' : ''}
                        <li>VLAN assignment based on authentication results</li>
                        <li>Access control lists for traffic filtering</li>
                    </ul>
                </div>
            `;
        },
        
        /**
         * Generate configuration section
         * @param {string} config - Complete configuration
         * @param {Object} params - Configuration parameters
         * @returns {string} Configuration section HTML
         */
        generateConfigurationSection: function(config, params) {
            return `
                <div class="doc-section">
                    <h2>3. Configuration Details</h2>
                    
                    <h3>3.1 Global Authentication Configuration</h3>
                    <p>The following global configuration is applied:</p>
                    <pre class="doc-code">${this.extractGlobalAuthConfig(config)}</pre>
                    
                    <h3>3.2 RADIUS Server Configuration</h3>
                    <p>The following RADIUS servers are configured:</p>
                    <pre class="doc-code">${this.extractRadiusConfig(config)}</pre>
                    
                    ${params.authMethods.includes('dot1x') ? `
                    <h3>3.3 802.1X Configuration</h3>
                    <p>The following 802.1X configuration is applied:</p>
                    <pre class="doc-code">${this.extract801xConfig(config)}</pre>
                    ` : ''}
                    
                    ${params.authMethods.includes('mab') ? `
                    <h3>3.4 MAC Authentication Bypass Configuration</h3>
                    <p>The following MAB configuration is applied:</p>
                    <pre class="doc-code">${this.extractMabConfig(config)}</pre>
                    ` : ''}
                    
                    <h3>3.5 Interface Configuration</h3>
                    <p>The following interface configuration is applied to authentication ports:</p>
                    <pre class="doc-code">${this.extractInterfaceConfig(config)}</pre>
                </div>
            `;
        },
        
        /**
         * Generate deployment section
         * @param {Object} params - Configuration parameters
         * @returns {string} Deployment section HTML
         */
        generateDeploymentSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>4. Deployment Guidelines</h2>
                    
                    <h3>4.1 Pre-Deployment Checklist</h3>
                    <ul>
                        <li>Ensure RADIUS servers are accessible from network devices</li>
                        <li>Verify RADIUS shared secrets match between servers and network devices</li>
                        <li>Confirm network time is synchronized (NTP)</li>
                        <li>Backup existing configuration</li>
                        <li>Schedule maintenance window for implementation</li>
                        <li>Prepare rollback plan</li>
                    </ul>
                    
                    <h3>4.2 Deployment Phases</h3>
                    
                    <h4>Phase 1: Setup and Testing</h4>
                    <ol>
                        <li>Configure RADIUS servers and test authentication</li>
                        <li>Configure global authentication settings on network devices</li>
                        <li>Deploy configuration on test ports</li>
                        <li>Verify authentication works as expected</li>
                    </ol>
                    
                    <h4>Phase 2: Monitor Mode Deployment</h4>
                    <ol>
                        <li>Deploy configuration in monitor mode to production ports</li>
                        <li>Monitor authentication attempts and results</li>
                        <li>Identify and remediate issues</li>
                        <li>Communicate with end users about upcoming enforcement</li>
                    </ol>
                    
                    <h4>Phase 3: Enforcement Mode Deployment</h4>
                    <ol>
                        <li>Convert ports from monitor mode to closed mode</li>
                        <li>Implement in groups (e.g., by department or floor)</li>
                        <li>Monitor help desk tickets and address issues promptly</li>
                        <li>Complete deployment across all network ports</li>
                    </ol>
                    
                    <h3>4.3 Rollback Procedure</h3>
                    <p>If critical issues occur during deployment, follow these steps to roll back:</p>
                    <ol>
                        <li>Identify affected ports or devices</li>
                        <li>Disable authentication on affected ports:
                            <pre class="doc-code">interface range &lt;affected-ports&gt;
no authentication port-control auto
spanning-tree portfast
no shutdown</pre>
                        </li>
                        <li>If global rollback is needed, disable 802.1X globally:
                            <pre class="doc-code">no dot1x system-auth-control</pre>
                        </li>
                        <li>Restore previous configuration if necessary</li>
                    </ol>
                </div>
            `;
        },
        
        /**
         * Generate verification section
         * @param {Object} params - Configuration parameters
         * @returns {string} Verification section HTML
         */
        generateVerificationSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>5. Verification Procedures</h2>
                    
                    <h3>5.1 Authentication Status Verification</h3>
                    <p>Use the following commands to verify authentication status:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Command</th>
                            <th>Purpose</th>
                        </tr>
                        ${params.vendor === 'cisco' ? `
                        <tr>
                            <td><code>show authentication sessions</code></td>
                            <td>Displays all authenticated sessions</td>
                        </tr>
                        <tr>
                            <td><code>show authentication sessions interface &lt;interface&gt;</code></td>
                            <td>Displays authentication details for a specific interface</td>
                        </tr>
                        <tr>
                            <td><code>show dot1x all</code></td>
                            <td>Displays 802.1X status for all interfaces</td>
                        </tr>
                        <tr>
                            <td><code>show dot1x interface &lt;interface&gt; details</code></td>
                            <td>Displays detailed 802.1X information for a specific interface</td>
                        </tr>
                        <tr>
                            <td><code>show mab all</code></td>
                            <td>Displays MAB status for all interfaces</td>
                        </tr>
                        ` : params.vendor === 'aruba' ? `
                        <tr>
                            <td><code>show port-access authenticator</code></td>
                            <td>Displays authentication status for all ports</td>
                        </tr>
                        <tr>
                            <td><code>show port-access authenticator &lt;interface&gt;</code></td>
                            <td>Displays authentication details for a specific interface</td>
                        </tr>
                        <tr>
                            <td><code>show port-access mac-auth</code></td>
                            <td>Displays MAC authentication status</td>
                        </tr>
                        ` : `
                        <tr>
                            <td><code>show authentication status</code></td>
                            <td>Displays authentication status for all ports</td>
                        </tr>
                        <tr>
                            <td><code>show authentication interface &lt;interface&gt;</code></td>
                            <td>Displays authentication details for a specific interface</td>
                        </tr>
                        `}
                    </table>
                    
                    <h3>5.2 RADIUS Server Verification</h3>
                    <p>Use the following commands to verify RADIUS server status:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Command</th>
                            <th>Purpose</th>
                        </tr>
                        ${params.vendor === 'cisco' ? `
                        <tr>
                            <td><code>show radius statistics</code></td>
                            <td>Displays RADIUS server statistics</td>
                        </tr>
                        <tr>
                            <td><code>test aaa group radius &lt;username&gt; &lt;password&gt; new-code</code></td>
                            <td>Tests RADIUS authentication</td>
                        </tr>
                        ` : `
                        <tr>
                            <td><code>show radius statistics</code></td>
                            <td>Displays RADIUS server statistics</td>
                        </tr>
                        <tr>
                            <td><code>test radius authentication</code></td>
                            <td>Tests RADIUS authentication</td>
                        </tr>
                        `}
                    </table>
                    
                    <h3>5.3 Validation Tests</h3>
                    <p>Perform the following tests to validate the implementation:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Test</th>
                            <th>Procedure</th>
                            <th>Expected Result</th>
                        </tr>
                        <tr>
                            <td>802.1X Authentication</td>
                            <td>Connect 802.1X-capable device to port</td>
                            <td>Device authenticates and receives correct VLAN and policy</td>
                        </tr>
                        <tr>
                            <td>MAB Authentication</td>
                            <td>Connect non-802.1X device with authorized MAC to port</td>
                            <td>Device authenticates via MAB and receives correct VLAN and policy</td>
                        </tr>
                        <tr>
                            <td>Authentication Failure</td>
                            <td>Connect device with invalid credentials or unauthorized MAC</td>
                            <td>Device fails authentication and is denied access or placed in restricted VLAN</td>
                        </tr>
                        <tr>
                            <td>RADIUS Server Failure</td>
                            <td>Disable primary RADIUS server</td>
                            <td>Authentication continues using secondary server</td>
                        </tr>
                        <tr>
                            <td>All RADIUS Servers Failure</td>
                            <td>Disable all RADIUS servers</td>
                            <td>${params.criticalAuth ? 'Critical authentication activates and permits restricted access' : 'Authentication fails and devices denied access'}</td>
                        </tr>
                    </table>
                </div>
            `;
        },
        
        /**
         * Generate troubleshooting section
         * @param {Object} params - Configuration parameters
         * @returns {string} Troubleshooting section HTML
         */
        generateTroubleshootingSection: function(params) {
            return `
                <div class="doc-section">
                    <h2>6. Troubleshooting</h2>
                    
                    <h3>6.1 Common Issues and Resolutions</h3>
                    <table class="doc-table">
                        <tr>
                            <th>Issue</th>
                            <th>Possible Causes</th>
                            <th>Resolution</th>
                        </tr>
                        <tr>
                            <td>Authentication Failures</td>
                            <td>
                                <ul>
                                    <li>Incorrect credentials</li>
                                    <li>Expired account</li>
                                    <li>Misconfigured supplicant</li>
                                    <li>RADIUS server issues</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Verify credentials</li>
                                    <li>Check account status</li>
                                    <li>Verify supplicant configuration</li>
                                    <li>Check RADIUS server connectivity</li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>RADIUS Connectivity Issues</td>
                            <td>
                                <ul>
                                    <li>Network connectivity</li>
                                    <li>Firewall blocking</li>
                                    <li>Incorrect shared secret</li>
                                    <li>Server down</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Check network connectivity</li>
                                    <li>Verify firewall rules</li>
                                    <li>Confirm shared secret matches</li>
                                    <li>Check server status</li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>VLAN Assignment Issues</td>
                            <td>
                                <ul>
                                    <li>Missing VLAN on switch</li>
                                    <li>Incorrect RADIUS attributes</li>
                                    <li>Trunk port configuration</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Verify VLAN exists on switch</li>
                                    <li>Check RADIUS attribute format</li>
                                    <li>Ensure VLANs are allowed on trunk</li>
                                </ul>
                            </td>
                        </tr>
                        <tr>
                            <td>Intermittent Authentication</td>
                            <td>
                                <ul>
                                    <li>Supplicant timeout issues</li>
                                    <li>Network instability</li>
                                    <li>Server overload</li>
                                    <li>EAP method incompatibility</li>
                                </ul>
                            </td>
                            <td>
                                <ul>
                                    <li>Adjust timers</li>
                                    <li>Check for network issues</li>
                                    <li>Verify server capacity</li>
                                    <li>Test different EAP methods</li>
                                </ul>
                            </td>
                        </tr>
                    </table>
                    
                    <h3>6.2 Diagnostic Commands</h3>
                    <p>Use the following commands for troubleshooting:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Command</th>
                            <th>Purpose</th>
                        </tr>
                        ${params.vendor === 'cisco' ? `
                        <tr>
                            <td><code>debug dot1x all</code></td>
                            <td>Debug 802.1X authentication process</td>
                        </tr>
                        <tr>
                            <td><code>debug authentication all</code></td>
                            <td>Debug authentication manager</td>
                        </tr>
                        <tr>
                            <td><code>debug radius authentication</code></td>
                            <td>Debug RADIUS authentication</td>
                        </tr>
                        <tr>
                            <td><code>debug aaa authentication</code></td>
                            <td>Debug AAA authentication</td>
                        </tr>
                        ` : params.vendor === 'aruba' ? `
                        <tr>
                            <td><code>debug port-access authenticator</code></td>
                            <td>Debug port authentication process</td>
                        </tr>
                        <tr>
                            <td><code>debug radius</code></td>
                            <td>Debug RADIUS communication</td>
                        </tr>
                        <tr>
                            <td><code>debug security port-access</code></td>
                            <td>Debug port security</td>
                        </tr>
                        ` : `
                        <tr>
                            <td><code>debug authentication</code></td>
                            <td>Debug authentication process</td>
                        </tr>
                        <tr>
                            <td><code>debug radius</code></td>
                            <td>Debug RADIUS communication</td>
                        </tr>
                        `}
                    </table>
                    
                    <h3>6.3 Logs and Error Messages</h3>
                    <p>Monitor the following logs for authentication issues:</p>
                    <ul>
                        <li>Switch authentication logs</li>
                        <li>RADIUS server logs</li>
                        <li>Client supplicant logs</li>
                        <li>System logs for port status changes</li>
                    </ul>
                    
                    <p>Common error messages and their meanings:</p>
                    <table class="doc-table">
                        <tr>
                            <th>Error Message</th>
                            <th>Meaning</th>
                        </tr>
                        <tr>
                            <td>RADIUS-3-NOSERVERS</td>
                            <td>No RADIUS servers responding</td>
                        </tr>
                        <tr>
                            <td>DOT1X-5-FAIL</td>
                            <td>Authentication failed</td>
                        </tr>
                        <tr>
                            <td>MAB-5-FAIL</td>
                            <td>MAC authentication failed</td>
                        </tr>
                        <tr>
                            <td>DOT1X-5-SUCCESS</td>
                            <td>Authentication succeeded</td>
                        </tr>
                    </table>
                </div>
            `;
        },
        
        /**
         * Extract global authentication configuration
         * @param {string} config - Complete configuration
         * @returns {string} Global authentication configuration
         */
        extractGlobalAuthConfig: function(config) {
            // Extract AAA and authentication global configuration
            const globalConfig = [];
            
            // Match AAA configuration
            const aaaMatch = config.match(/aaa new-model[\s\S]*?(?=\n\S|$)/m);
            if (aaaMatch) {
                globalConfig.push(aaaMatch[0]);
            }
            
            // Match dot1x global configuration
            const dot1xMatch = config.match(/dot1x system-auth-control[\s\S]*?(?=\n\S|$)/m);
            if (dot1xMatch) {
                globalConfig.push(dot1xMatch[0]);
            }
            
            // Match critical auth configuration
            const criticalMatch = config.match(/(?:dot1x critical|authentication critical)[\s\S]*?(?=\n\S|$)/m);
            if (criticalMatch) {
                globalConfig.push(criticalMatch[0]);
            }
            
            return globalConfig.join('\n\n') || 'No global authentication configuration found.';
        },
        
        /**
         * Extract RADIUS server configuration
         * @param {string} config - Complete configuration
         * @returns {string} RADIUS server configuration
         */
        extractRadiusConfig: function(config) {
            // Extract RADIUS server configuration
            let radiusConfig = '';
            
            // Match RADIUS server definitions - IOS-XE style
            const radServerMatch = config.match(/radius server[\s\S]*?(?=\n\S|$)/gm);
            if (radServerMatch) {
                radiusConfig += radServerMatch.join('\n\n');
            }
            
            // Match RADIUS server definitions - IOS style
            const radOldMatch = config.match(/radius-server host.*(?:\n\s+.*)*(?=\n\S|$)/gm);
            if (radOldMatch) {
                radiusConfig += (radiusConfig ? '\n\n' : '') + radOldMatch.join('\n');
            }
            
            // Match AAA server group configuration
            const aaaGroupMatch = config.match(/aaa group server radius[\s\S]*?(?=\n\S|$)/m);
            if (aaaGroupMatch) {
                radiusConfig += (radiusConfig ? '\n\n' : '') + aaaGroupMatch[0];
            }
            
            return radiusConfig || 'No RADIUS configuration found.';
        },
        
        /**
         * Extract 802.1X configuration
         * @param {string} config - Complete configuration
         * @returns {string} 802.1X configuration
         */
        extract801xConfig: function(config) {
            // Extract 802.1X specific configuration
            const dot1xConfig = [];
            
            // Match dot1x global config
            const dot1xGlobalMatch = config.match(/dot1x system-auth-control[\s\S]*?(?=\n\S|$)/m);
            if (dot1xGlobalMatch) {
                dot1xConfig.push(dot1xGlobalMatch[0]);
            }
            
            // Match IBNS 2.0 policy maps if available
            const policyMapMatch = config.match(/policy-map type control subscriber[\s\S]*?(?=\n\S|$)/gm);
            if (policyMapMatch) {
                dot1xConfig.push(policyMapMatch.join('\n\n'));
            }
            
            // Match class maps if available
            const classMapMatch = config.match(/class-map type control subscriber[\s\S]*?(?=\n\S|$)/gm);
            if (classMapMatch) {
                dot1xConfig.push(classMapMatch.join('\n\n'));
            }
            
            // Match dot1x configuration on a sample interface
            const interfaceMatch = config.match(/interface[\s\S]*?dot1x[\s\S]*?(?=\n\S|$)/m);
            if (interfaceMatch) {
                dot1xConfig.push('# Sample Interface Configuration:\n' + interfaceMatch[0]);
            }
            
            return dot1xConfig.join('\n\n') || 'No 802.1X specific configuration found.';
        },
        
        /**
         * Extract MAB configuration
         * @param {string} config - Complete configuration
         * @returns {string} MAB configuration
         */
        extractMabConfig: function(config) {
            // Extract MAB specific configuration
            const mabConfig = [];
            
            // Match MAB configuration on a sample interface
            const interfaceMatch = config.match(/interface[\s\S]*?mab[\s\S]*?(?=\n\S|$)/m);
            if (interfaceMatch) {
                mabConfig.push('# Sample Interface Configuration:\n' + interfaceMatch[0]);
            }
            
            // Match MAB policy maps if available
            const mabPolicyMatch = config.match(/policy-map[\s\S]*?mab[\s\S]*?(?=\n\S|$)/gm);
            if (mabPolicyMatch) {
                mabConfig.push(mabPolicyMatch.join('\n\n'));
            }
            
            return mabConfig.join('\n\n') || 'No MAB specific configuration found.';
        },
        
        /**
         * Extract interface configuration
         * @param {string} config - Complete configuration
         * @returns {string} Interface configuration
         */
        extractInterfaceConfig: function(config) {
            // Extract interface configuration with authentication
            const interfaceMatch = config.match(/interface[\s\S]*?(?:authentication|dot1x|mab)[\s\S]*?(?=\n\S|$)/m);
            
            if (interfaceMatch) {
                return interfaceMatch[0];
            }
            
            return 'No interface configuration with authentication found.';
        },
        
        /**
         * Apply document style
         * @param {string} format - Document format
         */
        applyDocumentStyle: function(format) {
            // Remove previous style if it exists
            const oldStyle = document.getElementById('docStyle');
            if (oldStyle) {
                oldStyle.remove();
            }
            
            // Create new style element
            const style = document.createElement('style');
            style.id = 'docStyle';
            
            // Set style based on format
            if (format === 'formal') {
                style.textContent = `
                    .documentation-preview {
                        font-family: 'Times New Roman', Times, serif;
                        line-height: 1.6;
                        color: #000000;
                    }
                    
                    .doc-header h1 {
                        font-size: 20px;
                        text-align: center;
                        margin-bottom: 10px;
                    }
                    
                    .doc-meta {
                        text-align: center;
                        font-style: italic;
                        margin-bottom: 30px;
                    }
                    
                    .doc-section {
                        margin-bottom: 30px;
                    }
                    
                    .doc-section h2 {
                        font-size: 16px;
                        border-bottom: 1px solid #000000;
                        padding-bottom: 5px;
                        margin-bottom: 15px;
                    }
                    
                    .doc-section h3 {
                        font-size: 14px;
                        margin-top: 20px;
                        margin-bottom: 10px;
                    }
                    
                    .doc-section h4 {
                        font-size: 12px;
                        margin-top: 15px;
                        margin-bottom: 5px;
                    }
                    
                    .doc-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }
                    
                    .doc-table th, .doc-table td {
                        border: 1px solid #000000;
                        padding: 8px;
                        text-align: left;
                    }
                    
                    .doc-table th {
                        background-color: #f0f0f0;
                    }
                    
                    .doc-code {
                        font-family: Courier, monospace;
                        background-color: #f5f5f5;
                        padding: 10px;
                        margin: 10px 0;
                        border: 1px solid #ddd;
                        white-space: pre-wrap;
                    }
                    
                    .doc-image-placeholder {
                        border: 1px dashed #999;
                        padding: 30px;
                        text-align: center;
                        margin: 20px 0;
                        background-color: #f9f9f9;
                    }
                `;
            } else if (format === 'technical') {
                style.textContent = `
                    .documentation-preview {
                        font-family: Arial, Helvetica, sans-serif;
                        line-height: 1.5;
                        color: #333333;
                    }
                    
                    .doc-header h1 {
                        font-size: 22px;
                        color: #0056b3;
                        margin-bottom: 10px;
                    }
                    
                    .doc-meta {
                        color: #666;
                        margin-bottom: 30px;
                    }
                    
                    .doc-section {
                        margin-bottom: 30px;
                    }
                    
                    .doc-section h2 {
                        font-size: 18px;
                        color: #0056b3;
                        border-bottom: 2px solid #0056b3;
                        padding-bottom: 5px;
                        margin-bottom: 15px;
                    }
                    
                    .doc-section h3 {
                        font-size: 16px;
                        color: #0077cc;
                        margin-top: 20px;
                        margin-bottom: 10px;
                    }
                    
                    .doc-section h4 {
                        font-size: 14px;
                        color: #0077cc;
                        margin-top: 15px;
                        margin-bottom: 5px;
                    }
                    
                    .doc-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }
                    
                    .doc-table th, .doc-table td {
                        border: 1px solid #ddd;
                        padding: 8px;
                        text-align: left;
                    }
                    
                    .doc-table th {
                        background-color: #f0f0f0;
                    }
                    
                    .doc-code {
                        font-family: 'Courier New', Courier, monospace;
                        background-color: #f8f8f8;
                        padding: 10px;
                        margin: 10px 0;
                        border: 1px solid #ddd;
                        border-left: 3px solid #0056b3;
                        white-space: pre-wrap;
                    }
                    
                    .doc-image-placeholder {
                        border: 1px dashed #999;
                        padding: 30px;
                        text-align: center;
                        margin: 20px 0;
                        background-color: #f9f9f9;
                    }
                `;
            } else {
                style.textContent = `
                    .documentation-preview {
                        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                        line-height: 1.6;
                        color: #333333;
                    }
                    
                    .doc-header h1 {
                        font-size: 24px;
                        color: #2c3e50;
                        margin-bottom: 10px;
                    }
                    
                    .doc-meta {
                        color: #7f8c8d;
                        margin-bottom: 30px;
                    }
                    
                    .doc-section {
                        margin-bottom: 30px;
                    }
                    
                    .doc-section h2 {
                        font-size: 20px;
                        color: #2c3e50;
                        border-bottom: 1px solid #ecf0f1;
                        padding-bottom: 5px;
                        margin-bottom: 15px;
                    }
                    
                    .doc-section h3 {
                        font-size: 18px;
                        color: #3498db;
                        margin-top: 20px;
                        margin-bottom: 10px;
                    }
                    
                    .doc-section h4 {
                        font-size: 16px;
                        color: #2980b9;
                        margin-top: 15px;
                        margin-bottom: 5px;
                    }
                    
                    .doc-table {
                        width: 100%;
                        border-collapse: collapse;
                        margin-bottom: 20px;
                    }
                    
                    .doc-table th, .doc-table td {
                        border: 1px solid #ecf0f1;
                        padding: 8px;
                        text-align: left;
                    }
                    
                    .doc-table th {
                        background-color: #f9f9f9;
                    }
                    
                    .doc-code {
                        font-family: Consolas, Monaco, 'Andale Mono', monospace;
                        background-color: #f8f9fa;
                        padding: 10px;
                        margin: 10px 0;
                        border: 1px solid #ecf0f1;
                        border-radius: 4px;
                        white-space: pre-wrap;
                    }
                    
                    .doc-image-placeholder {
                        border: 1px dashed #bdc3c7;
                        padding: 30px;
                        text-align: center;
                        margin: 20px 0;
                        background-color: #f9f9f9;
                        border-radius: 4px;
                    }
                `;
            }
            
            // Add style to document
            document.head.appendChild(style);
        },
        
        /**
         * Get full method name
         * @param {string} method - Method short name
         * @returns {string} Full method name
         */
        getFullMethodName: function(method) {
            switch (method) {
                case 'dot1x':
                    return 'IEEE 802.1X';
                case 'mab':
                    return 'MAC Authentication Bypass (MAB)';
                case 'webauth':
                    return 'Web Authentication';
                case 'macsec':
                    return 'MACsec (802.1AE)';
                case 'radsec':
                    return 'RADIUS over TLS (RadSec)';
                case 'tacacs':
                    return 'TACACS+';
                default:
                    return method;
            }
        },
        
        /**
         * Get method description
         * @param {string} method - Method short name
         * @returns {string} Method description
         */
        getMethodDescription: function(method) {
            switch (method) {
                case 'dot1x':
                    return 'Port-based Network Access Control for authenticating and authorizing devices before they can access the network';
                case 'mab':
                    return 'Allows non-802.1X capable devices to authenticate based on their MAC address';
                case 'webauth':
                    return 'Web-based authentication typically used for guest access';
                case 'macsec':
                    return 'IEEE 802.1AE standard for MAC Security providing point-to-point encryption on wired networks';
                case 'radsec':
                    return 'RADIUS over TLS providing secure transportation of RADIUS messages';
                case 'tacacs':
                    return 'Authentication protocol providing centralized authentication for administrative access';
                default:
                    return 'Authentication method';
            }
        },
        
        /**
         * Parse configuration parameters from configuration
         * @param {string} config - Configuration text
         * @returns {Object} Configuration parameters
         */
        parseConfigParameters: function(config) {
            const params = {
                vendor: 'unknown',
                platform: 'unknown',
                authMethods: [],
                radiusServers: [],
                hostMode: '',
                deploymentType: '',
                securityFeatures: [],
                criticalAuth: false
            };
            
            // Detect vendor and platform
            if (config.includes('aaa new-model') || config.includes('interface GigabitEthernet')) {
                params.vendor = 'cisco';
                
                if (config.includes('IBNS') || config.includes('POLICY') || 
                    config.includes('service-policy type control subscriber') ||
                    config.includes('access-session')) {
                    params.platform = 'ios-xe';
                } else {
                    params.platform = 'ios';
                }
            } else if (config.includes('aaa authentication port-access') || 
                        config.includes('aaa port-access authenticator')) {
                params.vendor = 'aruba';
                
                if (config.includes('aaa port-access authenticator active')) {
                    params.platform = 'arubaos-switch';
                } else {
                    params.platform = 'arubaos-cx';
                }
            } else if (config.includes('system {') || config.includes('protocols {')) {
                params.vendor = 'juniper';
                params.platform = 'junos';
            }
            
            // Detect authentication methods
            if (config.includes('dot1x')) {
                params.authMethods.push('dot1x');
            }
            
            if (config.includes('mab')) {
                params.authMethods.push('mab');
            }
            
            if (config.includes('webauth') || config.includes('web-auth') || 
                config.includes('web authentication')) {
                params.authMethods.push('webauth');
            }
            
            if (config.includes('macsec')) {
                params.authMethods.push('macsec');
            }
            
            if (config.includes('tacacs')) {
                params.authMethods.push('tacacs');
            }
            
            // Extract RADIUS servers
            const radiusMatches = config.match(/(?:radius server|radius-server host|address ipv4)\s+(\d+\.\d+\.\d+\.\d+)/g);
            if (radiusMatches) {
                radiusMatches.forEach(match => {
                    const ipMatch = match.match(/(\d+\.\d+\.\d+\.\d+)/);
                    if (ipMatch && !params.radiusServers.includes(ipMatch[1])) {
                        params.radiusServers.push(ipMatch[1]);
                    }
                });
            }
            
            // Detect host mode
            const hostModeMatch = config.match(/host-mode\s+(\S+)/);
            if (hostModeMatch) {
                params.hostMode = hostModeMatch[1];
            }
            
            // Detect deployment type
            if (config.includes('authentication open') || config.includes('auth-mode monitor')) {
                params.deploymentType = 'monitor';
            } else if (config.includes('do-all') && config.includes('authenticate using dot1x') && 
                        config.includes('authenticate using mab')) {
                params.deploymentType = 'concurrent';
            } else {
                params.deploymentType = 'closed';
            }
            
            // Detect security features
            if (config.includes('ip dhcp snooping') || config.includes('dhcp-snooping')) {
                params.securityFeatures.push('dhcpSnooping');
            }
            
            if (config.includes('ip arp inspection') || config.includes('arp-protect')) {
                params.securityFeatures.push('arpInspection');
            }
            
            if (config.includes('ip verify source')) {
                params.securityFeatures.push('ipSourceGuard');
            }
            
            // Detect critical authentication
            if (config.includes('critical') || config.includes('CRITICAL_')) {
                params.criticalAuth = true;
            }
            
            return params;
        },
        
        /**
         * Download documentation as a file
         */
        downloadDocumentation: function() {
            const documentationPreview = document.getElementById('documentationPreview');
            
            if (!documentationPreview || !documentationPreview.innerHTML) {
                alert('Please generate documentation first.');
                return;
            }
            
            // Get document format
            const format = document.getElementById('docFormat').value || 'standard';
            
            // Create document content
            const docContent = `<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Network Authentication Documentation</title>
    <style>
        ${document.getElementById('docStyle').textContent}
    </style>
</head>
<body>
    <div class="documentation-preview ${format}">
        ${documentationPreview.innerHTML}
    </div>
</body>
</html>`;
            
            // Create download link
            const link = document.createElement('a');
            link.href = 'data:text/html;charset=utf-8,' + encodeURIComponent(docContent);
            link.download = 'network-authentication-documentation.html';
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        },
        
        /**
         * Generate deployment checklist
         */
        generateChecklist: function() {
            const configOutput = document.getElementById('configOutput');
            const checklistPreview = document.getElementById('checklistPreview');
            
            if (!configOutput || !configOutput.value.trim() || !checklistPreview) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get the configuration
            const config = configOutput.value;
            
            // Parse configuration parameters
            const params = this.parseConfigParameters(config);
            
            // Generate checklist HTML
            let checklistHTML = `
                <div class="checklist-header">
                    <h2>Network Authentication Deployment Checklist</h2>
                    <p class="checklist-meta">Generated on: ${new Date().toLocaleDateString()}</p>
                </div>
                
                <div class="checklist-section">
                    <h3>1. Pre-Deployment Tasks</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-1">
                        <label for="pre-1">Backup current network device configurations</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-2">
                        <label for="pre-2">Verify RADIUS server connectivity from network devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-3">
                        <label for="pre-3">Test RADIUS authentication with sample credentials</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-4">
                        <label for="pre-4">Verify NTP configuration and time synchronization</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-5">
                        <label for="pre-5">Document current network state (VLANs, port assignments, etc.)</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-6">
                        <label for="pre-6">Create user/device database in RADIUS server</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-7">
                        <label for="pre-7">Define authorization policies in RADIUS server</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="pre-8">
                        <label for="pre-8">Prepare client supplicant configuration templates</label>
                    </div>
                </div>
                
                <div class="checklist-section">
                    <h3>2. Network Device Configuration</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-1">
                        <label for="net-1">Configure global AAA settings</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-2">
                        <label for="net-2">Configure RADIUS server settings</label>
                    </div>
                    
                    ${params.authMethods.includes('dot1x') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-3">
                        <label for="net-3">Configure global 802.1X settings</label>
                    </div>
                    ` : ''}
                    
                    ${params.securityFeatures.includes('dhcpSnooping') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-4">
                        <label for="net-4">Configure DHCP snooping</label>
                    </div>
                    ` : ''}
                    
                    ${params.securityFeatures.includes('arpInspection') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-5">
                        <label for="net-5">Configure Dynamic ARP Inspection</label>
                    </div>
                    ` : ''}
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-6">
                        <label for="net-6">Configure authentication ${params.deploymentType === 'monitor' ? 'in monitor mode' : 'in closed mode'}</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="net-7">
                        <label for="net-7">Configure authentication policies and templates</label>
                    </div>
                    
                    ${params.criticalAuth ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="net-8">
                        <label for="net-8">Configure critical authentication for RADIUS failure handling</label>
                    </div>
                    ` : ''}
                </div>
                
                <div class="checklist-section">
                    <h3>3. Interface Configuration</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-1">
                        <label for="int-1">Configure authentication on test ports</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-2">
                        <label for="int-2">Verify authentication works on test ports</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-3">
                        <label for="int-3">Create interface templates for different port types</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-4">
                        <label for="int-4">Roll out configuration to first batch of production ports</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-5">
                        <label for="int-5">Verify authentication and policy application</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-6">
                        <label for="int-6">Document any issues and resolutions</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="int-7">
                        <label for="int-7">Complete rollout to all remaining ports</label>
                    </div>
                </div>
                
                <div class="checklist-section">
                    <h3>4. Client Configuration</h3>
                    
                    ${params.authMethods.includes('dot1x') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-1">
                        <label for="cli-1">Configure supplicants on Windows devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-2">
                        <label for="cli-2">Configure supplicants on macOS devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-3">
                        <label for="cli-3">Configure supplicants on Linux devices</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-4">
                        <label for="cli-4">Configure supplicants on mobile devices</label>
                    </div>
                    ` : ''}
                    
                    ${params.authMethods.includes('mab') ? `
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-5">
                        <label for="cli-5">Add MAC addresses of non-802.1X devices to RADIUS server</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-6">
                        <label for="cli-6">Verify MAB authentication for printers</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="cli-7">
                        <label for="cli-7">Verify MAB authentication for IoT devices</label>
                    </div>
                    ` : ''}
                </div>
                
                <div class="checklist-section">
                    <h3>5. Verification and Testing</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-1">
                        <label for="ver-1">Test successful 802.1X authentication</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-2">
                        <label for="ver-2">Test failed authentication handling</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-3">
                        <label for="ver-3">Test RADIUS server failover</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-4">
                        <label for="ver-4">Verify VLAN assignment</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-5">
                        <label for="ver-5">Verify policy (ACL) application</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-6">
                        <label for="ver-6">Verify authentication accounting logs</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="ver-7">
                        <label for="ver-7">Conduct load testing if applicable</label>
                    </div>
                </div>
                
                <div class="checklist-section">
                    <h3>6. Post-Deployment Tasks</h3>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-1">
                        <label for="post-1">Document final configuration</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-2">
                        <label for="post-2">Create monitoring dashboards</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-3">
                        <label for="post-3">Set up alerts for authentication failures</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-4">
                        <label for="post-4">Create user documentation</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-5">
                        <label for="post-5">Train help desk staff on troubleshooting</label>
                    </div>
                    
                    <div class="checklist-item">
                        <input type="checkbox" id="post-6">
                        <label for="post-6">Conduct post-implementation review</label>
                    </div>
                </div>
            `;
            
            // Set the checklist HTML
            checklistPreview.innerHTML = checklistHTML;
        },
        
        /**
         * Download checklist as a file
         */
        downloadChecklist: function() {
            const checklistPreview = document.getElementById('checklistPreview');
            
            if (!checklistPreview || !checklistPreview.innerHTML) {
                alert('Please generate a checklist first.');
                return;
            }
            
            // Create checklist content
            const checklistContent = `<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Network Authentication Deployment Checklist</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .checklist-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .checklist-header h2 {
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .checklist-meta {
            color: #7f8c8d;
        }
        
        .checklist-section {
            margin-bottom: 30px;
        }
        
        .checklist-section h3 {
            color: #3498db;
            border-bottom: 1px solid #ecf0f1;
            padding-bottom: 5px;
            margin-bottom: 15px;
        }
        
        .checklist-item {
            display: flex;
            align-items: baseline;
            margin-bottom: 10px;
            padding: 8px;
            border-radius: 4px;
            background-color: #f8f9fa;
        }
        
        .checklist-item input[type="checkbox"] {
            margin-right: 10px;
            width: 16px;
            height: 16px;
        }
        
        .checklist-item label {
            flex: 1;
        }
        
        .checklist-item:hover {
            background-color: #e9ecef;
        }
        
        @media print {
            .checklist-item {
                break-inside: avoid;
                background-color: #fff;
                border: 1px solid #ddd;
            }
            
            .checklist-section {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
    ${checklistPreview.innerHTML}
</body>
</html>`;
            
            // Create download link
            const link = document.createElement('a');
            link.href = 'data:text/html;charset=utf-8,' + encodeURIComponent(checklistContent);
            link.download = 'network-authentication-checklist.html';
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        },
        
        /**
         * Generate troubleshooting guide
         */
        generateTroubleshootingGuide: function() {
            const configOutput = document.getElementById('configOutput');
            const troubleshootingPreview = document.getElementById('troubleshootingPreview');
            
            if (!configOutput || !configOutput.value.trim() || !troubleshootingPreview) {
                alert('Please generate a configuration first.');
                return;
            }
            
            // Get the configuration
            const config = configOutput.value;
            
            // Parse configuration parameters
            const params = this.parseConfigParameters(config);
            
            // Generate troubleshooting guide HTML
            let guideHTML = `
                <div class="guide-header">
                    <h2>Network Authentication Troubleshooting Guide</h2>
                    <p class="guide-meta">Generated on: ${new Date().toLocaleDateString()}</p>
                </div>
                
                <div class="guide-section">
                    <h3>1. Common Authentication Issues</h3>
                    
                    <div class="guide-problem">
                        <h4>Problem: Authentication Failures</h4>
                        <div class="guide-symptoms">
                            <h5>Symptoms:</h5>
                            <ul>
                                <li>Client cannot access network resources</li>
                                <li>Port shows "unauthorized" status</li>
                                <li>Authentication failure messages in logs</li>
                            </ul>
                        </div>
                        
                        <div class="guide-steps">
                            <h5>Troubleshooting Steps:</h5>
                            <ol>
                                <li>
                                    <strong>Verify port status:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.vendor === 'cisco' && params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') : 'show port-access authenticator'}</pre>
                                </li>
                                <li>
                                    <strong>Check authentication method:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.vendor === 'cisco' && params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + ' details' : 'show port-access authenticator ' + (params.vendor === 'aruba' ? '1/1' : '')}</pre>
                                </li>
                                <li>
                                    <strong>Verify RADIUS server connectivity:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'test aaa group radius username password new-code' : 'test radius auth server-group radius username password'}</pre>
                                </li>
                                <li>
                                    <strong>Check RADIUS server statistics:</strong>
                                    <pre class="guide-command">show radius statistics</pre>
                                </li>
                                <li>
                                    <strong>Verify client configuration:</strong>
                                    <ul>
                                        <li>Check 802.1X supplicant settings on client</li>
                                        <li>Verify user credentials</li>
                                        <li>Check EAP method configuration</li>
                                    </ul>
                                </li>
                                <li>
                                    <strong>Debug authentication process:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'debug authentication all\ndebug dot1x all\ndebug radius authentication' : 'debug port-access authenticator\ndebug radius'}</pre>
                                </li>
                            </ol>
                        </div>
                        
                        <div class="guide-resolution">
                            <h5>Common Resolutions:</h5>
                            <ul>
                                <li>Correct user credentials</li>
                                <li>Update supplicant configuration</li>
                                <li>Ensure RADIUS server is reachable</li>
                                <li>Verify correct shared secret configured</li>
                                <li>Check EAP method compatibility</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="guide-problem">
                        <h4>Problem: RADIUS Server Connectivity Issues</h4>
                        <div class="guide-symptoms">
                            <h5>Symptoms:</h5>
                            <ul>
                                <li>Authentication timeouts</li>
                                <li>RADIUS server unreachable messages</li>
                                <li>Fallback to secondary server or critical authentication</li>
                            </ul>
                        </div>
                        
                        <div class="guide-steps">
                            <h5>Troubleshooting Steps:</h5>
                            <ol>
                                <li>
                                    <strong>Check RADIUS server status:</strong>
                                    <pre class="guide-command">show radius statistics</pre>
                                </li>
                                <li>
                                    <strong>Verify network connectivity:</strong>
                                    <pre class="guide-command">ping ${params.radiusServers.length > 0 ? params.radiusServers[0] : '10.1.1.100'}</pre>
                                </li>
                                <li>
                                    <strong>Check RADIUS configuration:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'show run | section radius server' : 'show run | include radius-server') : 'show radius'}</pre>
                                </li>
                                <li>
                                    <strong>Verify port connectivity:</strong>
                                    <pre class="guide-command">telnet ${params.radiusServers.length > 0 ? params.radiusServers[0] : '10.1.1.100'} 1812</pre>
                                </li>
                                <li>
                                    <strong>Check firewall rules:</strong>
                                    <ul>
                                        <li>Ensure RADIUS ports (1812/1813) are allowed</li>
                                        <li>Check for any ACLs blocking RADIUS traffic</li>
                                    </ul>
                                </li>
                                <li>
                                    <strong>Debug RADIUS communication:</strong>
                                    <pre class="guide-command">debug radius authentication</pre>
                                </li>
                            </ol>
                        </div>
                        
                        <div class="guide-resolution">
                            <h5>Common Resolutions:</h5>
                            <ul>
                                <li>Restore network connectivity to RADIUS server</li>
                                <li>Correct RADIUS server IP address configuration</li>
                                <li>Update shared secret to match RADIUS server</li>
                                <li>Adjust firewall rules to allow RADIUS traffic</li>
                                <li>Check RADIUS server logs for errors</li>
                            </ul>
                        </div>
                    </div>
                    
                    <div class="guide-problem">
                        <h4>Problem: VLAN Assignment Issues</h4>
                        <div class="guide-symptoms">
                            <h5>Symptoms:</h5>
                            <ul>
                                <li>Authentication succeeds but client assigned to wrong VLAN</li>
                                <li>Client not receiving IP address</li>
                                <li>VLAN assignment errors in logs</li>
                            </ul>
                        </div>
                        
                        <div class="guide-steps">
                            <h5>Troubleshooting Steps:</h5>
                            <ol>
                                <li>
                                    <strong>Check current VLAN assignment:</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + ' details' : 'show port-access authenticator ' + (params.vendor === 'aruba' ? '1/1' : '')}</pre>
                                </li>
                                <li>
                                    <strong>Verify VLAN exists on switch:</strong>
                                    <pre class="guide-command">show vlan</pre>
                                </li>
                                <li>
                                    <strong>Check RADIUS attributes:</strong>
                                    <ul>
                                        <li>Tunnel-Type = VLAN (13)</li>
                                        <li>Tunnel-Medium-Type = 802 (6)</li>
                                        <li>Tunnel-Private-Group-ID = [VLAN ID]</li>
                                    </ul>
                                </li>
                                <li>
                                    <strong>Verify trunk configuration (if applicable):</strong>
                                    <pre class="guide-command">${params.vendor === 'cisco' ? 'show interfaces trunk' : 'show interfaces trunk'}</pre>
                                </li>
                                <li>
                                    <strong>Debug RADIUS attributes:</strong>
                                    <pre class="guide-command">debug radius attributes</pre>
                                </li>
                            </ol>
                        </div>
                        
                        <div class="guide-resolution">
                            <h5>Common Resolutions:</h5>
                            <ul>
                                <li>Create missing VLAN on switch</li>
                                <li>Correct RADIUS attribute format</li>
                                <li>Add VLAN to allowed list on trunk ports</li>
                                <li>Check DHCP configuration for the VLAN</li>
                                <li>Verify IP helper addresses configured</li>
                            </ul>
                        </div>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>2. ${params.vendor.charAt(0).toUpperCase() + params.vendor.slice(1)} ${params.platform.toUpperCase()} Specific Commands</h3>
                    
                    <div class="guide-commands">
                        <h4>Status and Verification Commands</h4>
                        <table class="guide-table">
                            <tr>
                                <th>Purpose</th>
                                <th>Command</th>
                            </tr>
                            ${params.vendor === 'cisco' ? `
                            <tr>
                                <td>View authentication sessions</td>
                                <td><code>show authentication sessions</code></td>
                            </tr>
                            <tr>
                                <td>View interface authentication</td>
                                <td><code>show authentication sessions interface ${params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1'}</code></td>
                            </tr>
                            <tr>
                                <td>View 802.1X status</td>
                                <td><code>show dot1x all</code></td>
                            </tr>
                            <tr>
                                <td>View detailed 802.1X status</td>
                                <td><code>show dot1x interface ${params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1'} details</code></td>
                            </tr>
                            <tr>
                                <td>View MAB status</td>
                                <td><code>show mab all</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS statistics</td>
                                <td><code>show radius statistics</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS configuration</td>
                                <td><code>${params.platform === 'ios-xe' ? 'show run | section radius server' : 'show run | include radius-server'}</code></td>
                            </tr>
                            <tr>
                                <td>Test RADIUS authentication</td>
                                <td><code>test aaa group radius username password new-code</code></td>
                            </tr>
                            ` : params.vendor === 'aruba' ? `
                            <tr>
                                <td>View authentication status</td>
                                <td><code>show port-access authenticator</code></td>
                            </tr>
                            <tr>
                                <td>View interface authentication</td>
                                <td><code>show port-access authenticator 1/1</code></td>
                            </tr>
                            <tr>
                                <td>View MAC authentication</td>
                                <td><code>show port-access mac-auth</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS statistics</td>
                                <td><code>show radius authentication</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS configuration</td>
                                <td><code>show radius</code></td>
                            </tr>
                            <tr>
                                <td>Test RADIUS authentication</td>
                                <td><code>test radius authentication</code></td>
                            </tr>
                            ` : `
                            <tr>
                                <td>View authentication status</td>
                                <td><code>show authentication status</code></td>
                            </tr>
                            <tr>
                                <td>View interface authentication</td>
                                <td><code>show authentication interface ge-0/0/1</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS statistics</td>
                                <td><code>show radius statistics</code></td>
                            </tr>
                            <tr>
                                <td>View RADIUS configuration</td>
                                <td><code>show configuration system radius-server</code></td>
                            </tr>
                            `}
                        </table>
                    </div>
                    
                    <div class="guide-commands">
                        <h4>Debug Commands</h4>
                        <table class="guide-table">
                            <tr>
                                <th>Purpose</th>
                                <th>Command</th>
                                <th>Notes</th>
                            </tr>
                            ${params.vendor === 'cisco' ? `
                            <tr>
                                <td>Debug 802.1X authentication</td>
                                <td><code>debug dot1x all</code></td>
                                <td>Shows detailed 802.1X packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug authentication manager</td>
                                <td><code>debug authentication all</code></td>
                                <td>Shows authentication state machine</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS communication</td>
                                <td><code>debug radius authentication</code></td>
                                <td>Shows RADIUS packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS attributes</td>
                                <td><code>debug radius attributes</code></td>
                                <td>Shows detailed RADIUS attributes</td>
                            </tr>
                            <tr>
                                <td>Debug AAA authentication</td>
                                <td><code>debug aaa authentication</code></td>
                                <td>Shows AAA process for authentication</td>
                            </tr>
                            <tr>
                                <td>Debug AAA authorization</td>
                                <td><code>debug aaa authorization</code></td>
                                <td>Shows AAA process for authorization</td>
                            </tr>
                            ` : params.vendor === 'aruba' ? `
                            <tr>
                                <td>Debug port authentication</td>
                                <td><code>debug port-access authenticator</code></td>
                                <td>Shows detailed authentication process</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS communication</td>
                                <td><code>debug radius</code></td>
                                <td>Shows RADIUS packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug port security</td>
                                <td><code>debug security port-access</code></td>
                                <td>Shows port security state changes</td>
                            </tr>
                            <tr>
                                <td>Debug all authentication</td>
                                <td><code>debug all</code></td>
                                <td>Shows all debugging (use carefully)</td>
                            </tr>
                            ` : `
                            <tr>
                                <td>Debug 802.1X authentication</td>
                                <td><code>debug dot1x</code></td>
                                <td>Shows detailed 802.1X packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug RADIUS communication</td>
                                <td><code>debug radius</code></td>
                                <td>Shows RADIUS packet exchange</td>
                            </tr>
                            <tr>
                                <td>Debug authentication process</td>
                                <td><code>debug authentication</code></td>
                                <td>Shows authentication state machine</td>
                            </tr>
                            `}
                        </table>
                        
                        <div class="guide-warning">
                            <p><strong>Warning:</strong> Debug commands can generate a large amount of output and impact device performance. Use them in a controlled environment and disable debugging when finished.</p>
                            <p><code>${params.vendor === 'cisco' ? 'undebug all' : 'no debug all'}</code></p>
                        </div>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>3. Error Message Reference</h3>
                    
                    <div class="guide-errors">
                        <table class="guide-table">
                            <tr>
                                <th>Error Message</th>
                                <th>Description</th>
                                <th>Resolution</th>
                            </tr>
                            <tr>
                                <td>%DOT1X-5-FAIL</td>
                                <td>802.1X authentication failed</td>
                                <td>Verify user credentials, check EAP method, check RADIUS server</td>
                            </tr>
                            <tr>
                                <td>%MAB-5-FAIL</td>
                                <td>MAC authentication failed</td>
                                <td>Verify MAC address in RADIUS database, check format (hyphen, colon, etc.)</td>
                            </tr>
                            <tr>
                                <td>%RADIUS-4-RADIUS_DEAD</td>
                                <td>RADIUS server not responding</td>
                                <td>Check network connectivity, server status, shared secret</td>
                            </tr>
                            <tr>
                                <td>%RADIUS-4-RADIUS_ALIVE</td>
                                <td>RADIUS server returned to service</td>
                                <td>Informational only, no action required</td>
                            </tr>
                            <tr>
                                <td>%DOT1X-5-ERR_VLAN_NOT_FOUND</td>
                                <td>VLAN from RADIUS not found on switch</td>
                                <td>Create VLAN on switch or correct RADIUS attribute</td>
                            </tr>
                            <tr>
                                <td>%DOT1X-5-ERR_INVALID_AAA_ATTR</td>
                                <td>Invalid AAA attribute received</td>
                                <td>Check RADIUS attribute format</td>
                            </tr>
                            <tr>
                                <td>%AUTHMGR-7-RESULT</td>
                                <td>Authentication result</td>
                                <td>Informational, shows authentication outcome</td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>4. Advanced Troubleshooting Scenarios</h3>
                    
                    <div class="guide-scenario">
                        <h4>Scenario: Intermittent Authentication Failures</h4>
                        <p><strong>Description:</strong> Clients authenticate successfully sometimes but fail at other times.</p>
                        
                        <h5>Possible Causes:</h5>
                        <ul>
                            <li>RADIUS server overload or performance issues</li>
                            <li>Network connectivity problems</li>
                            <li>Timer misconfigurations</li>
                            <li>Client supplicant issues</li>
                        </ul>
                        
                        <h5>Troubleshooting Approach:</h5>
                        <ol>
                            <li>Check RADIUS server performance metrics</li>
                            <li>Examine network for intermittent connectivity issues:
                                <pre class="guide-command">ping ${params.radiusServers.length > 0 ? params.radiusServers[0] : '10.1.1.100'} repeat 100</pre>
                            </li>
                            <li>Adjust timeouts and retransmits:
                                <pre class="guide-command">${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'radius server SERVER1\n timeout 5\n retransmit 3' : 'radius-server timeout 5\nradius-server retransmit 3') : 'radius-server timeout 5\nradius-server retransmit 3'}</pre>
                            </li>
                            <li>Enable RADIUS server load balancing (if multiple servers available):
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'aaa group server radius RAD_SERVERS\n load-balance method least-outstanding' : 'radius-server host 10.1.1.1 loadbalance\nradius-server host 10.1.1.2 loadbalance'}</pre>
                            </li>
                            <li>Check for client-specific issues by testing with different devices</li>
                        </ol>
                    </div>
                    
                    <div class="guide-scenario">
                        <h4>Scenario: Authentication Succeeds but Access is Limited</h4>
                        <p><strong>Description:</strong> Clients authenticate successfully but cannot access network resources.</p>
                        
                        <h5>Possible Causes:</h5>
                        <ul>
                            <li>DACL or VLAN ACL issues</li>
                            <li>Incorrect VLAN assignment</li>
                            <li>Routing issues</li>
                            <li>DHCP problems</li>
                        </ul>
                        
                        <h5>Troubleshooting Approach:</h5>
                        <ol>
                            <li>Check assigned VLAN and IP address:
                                <pre class="guide-command">show authentication sessions interface ${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') : 'ge-0/0/1'} details</pre>
                            </li>
                            <li>Verify applied ACLs:
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show ip access-lists' : 'show access-lists'}</pre>
                            </li>
                            <li>Check DHCP snooping (if enabled):
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show ip dhcp snooping binding' : 'show dhcp snooping binding'}</pre>
                            </li>
                            <li>Verify routing between VLANs:
                                <pre class="guide-command">show ip route</pre>
                            </li>
                            <li>Test connectivity from the device:
                                <pre class="guide-command">ping default-gateway-ip</pre>
                            </li>
                        </ol>
                    </div>
                    
                    <div class="guide-scenario">
                        <h4>Scenario: All RADIUS Servers Unavailable</h4>
                        <p><strong>Description:</strong> All RADIUS servers are unreachable, causing authentication issues.</p>
                        
                        <h5>Expected Behavior:</h5>
                        <p>${params.criticalAuth ? 'Critical authentication should activate and permit restricted access based on configured policies.' : 'Authentication will fail unless local fallback is configured.'}</p>
                        
                        <h5>Troubleshooting Approach:</h5>
                        <ol>
                            <li>Verify RADIUS server status:
                                <pre class="guide-command">show radius statistics</pre>
                            </li>
                            <li>Check critical authentication status:
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show authentication sessions interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + ' details' : 'show port-access authenticator'}</pre>
                            </li>
                            <li>Verify critical authentication configuration:
                                <pre class="guide-command">${params.vendor === 'cisco' ? (params.platform === 'ios-xe' ? 'show run | section critical' : 'show run | include critical') : 'show port-access critical-vlan'}</pre>
                            </li>
                            <li>Check local fallback authentication:
                                <pre class="guide-command">${params.vendor === 'cisco' ? 'show run | include local' : 'show authentication'}</pre>
                            </li>
                            <li>Restore connectivity to RADIUS servers</li>
                        </ol>
                    </div>
                </div>
                
                <div class="guide-section">
                    <h3>5. Configuration Snippets for Quick Fixes</h3>
                    
                    <div class="guide-snippets">
                        <div class="guide-snippet">
                            <h4>Enable Monitor Mode for Testing</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + '\n authentication open\n authentication port-control auto' : params.vendor === 'aruba' ? 'aaa port-access authenticator 1/1\n auth-mode monitor' : 'set protocols dot1x interface ge-0/0/1 authentication open'}</pre>
                        </div>
                        
                        <div class="guide-snippet">
                            <h4>Disable Authentication on a Port</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + '\n no authentication port-control auto\n no dot1x pae authenticator\n no mab\n spanning-tree portfast' : params.vendor === 'aruba' ? 'no aaa port-access authenticator 1/1' : 'delete protocols dot1x interface ge-0/0/1'}</pre>
                        </div>
                        
                        <div class="guide-snippet">
                            <h4>Reset Interface</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') + '\n shutdown\n no shutdown' : params.vendor === 'aruba' ? 'interface 1/1 disable\ninterface 1/1 enable' : 'set interface ge-0/0/1 disable\nset interface ge-0/0/1 enable'}</pre>
                        </div>
                        
                        <div class="guide-snippet">
                            <h4>Clear Authentication Sessions</h4>
                            <pre class="guide-code">${params.vendor === 'cisco' ? 'clear authentication sessions interface ' + (params.platform === 'ios-xe' ? 'gigabitEthernet 1/0/1' : 'gigabitEthernet 0/1') : params.vendor === 'aruba' ? 'aaa port-access authenticator 1/1 clear' : 'clear dot1x interface ge-0/0/1'}</pre>
                        </div>
                    </div>
                </div>
            `;
            
            // Apply guide style
            this.applyGuideStyle();
            
            // Set the troubleshooting HTML
            troubleshootingPreview.innerHTML = guideHTML;
        },
        
        /**
         * Apply guide style
         */
        applyGuideStyle: function() {
            // Remove previous style if it exists
            const oldStyle = document.getElementById('guideStyle');
            if (oldStyle) {
                oldStyle.remove();
            }
            
            // Create new style element
            const style = document.createElement('style');
            style.id = 'guideStyle';
            
            // Set style
            style.textContent = `
                .troubleshooting-preview {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    line-height: 1.6;
                    color: #333;
                }
                
                .guide-header {
                    margin-bottom: 30px;
                }
                
                .guide-header h2 {
                    color: #2c3e50;
                    font-size: 24px;
                    margin-bottom: 10px;
                }
                
                .guide-meta {
                    color: #7f8c8d;
                }
                
                .guide-section {
                    margin-bottom: 30px;
                }
                
                .guide-section h3 {
                    color: #2c3e50;
                    font-size: 20px;
                    border-bottom: 1px solid #ecf0f1;
                    padding-bottom: 5px;
                    margin-bottom: 15px;
                }
                
                .guide-problem {
                    background-color: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 4px;
                    padding: 15px;
                    margin-bottom: 20px;
                }
                
                .guide-problem h4 {
                    color: #e74c3c;
                    font-size: 18px;
                    margin-bottom: 10px;
                }
                
                .guide-symptoms {
                    margin-bottom: 15px;
                }
                
                .guide-symptoms h5, .guide-steps h5, .guide-resolution h5 {
                    color: #2c3e50;
                    font-size: 16px;
                    margin-bottom: 10px;
                }
                
                .guide-command {
                    background-color: #2c3e50;
                    color: #ecf0f1;
                    padding: 8px;
                    border-radius: 4px;
                    font-family: monospace;
                    margin: 10px 0;
                    overflow-x: auto;
                    white-space: nowrap;
                }
                
                .guide-code {
                    background-color: #2c3e50;
                    color: #ecf0f1;
                    padding: 12px;
                    border-radius: 4px;
                    font-family: monospace;
                    margin: 10px 0;
                    white-space: pre;
                    overflow-x: auto;
                }
                
                .guide-resolution {
                    background-color: #e1f5fe;
                    border-left: 4px solid #03a9f4;
                    padding: 10px 15px;
                    margin-top: 15px;
                }
                
                .guide-commands {
                    margin-bottom: 20px;
                }
                
                .guide-commands h4 {
                    color: #3498db;
                    font-size: 18px;
                    margin-bottom: 10px;
                }
                
                .guide-table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-bottom: 20px;
                }
                
                .guide-table th, .guide-table td {
                    border: 1px solid #e9ecef;
                    padding: 8px;
                    text-align: left;
                }
                
                .guide-table th {
                    background-color: #f8f9fa;
                    font-weight: 600;
                }
                
                .guide-table code {
                    background-color: #f8f9fa;
                    padding: 2px 5px;
                    border-radius: 4px;
                    font-family: monospace;
                }
                
                .guide-warning {
                    background-color: #fff3cd;
                    border-left: 4px solid #ffc107;
                    padding: 15px;
                    margin-top: 15px;
                    margin-bottom: 15px;
                }
                
                .guide-warning code {
                    background-color: #2c3e50;
                    color: #ecf0f1;
                    padding: 2px 5px;
                    border-radius: 4px;
                    font-family: monospace;
                }
                
                .guide-scenario {
                    margin-bottom: 20px;
                    padding: 15px;
                    background-color: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 4px;
                }
                
                .guide-scenario h4 {
                    color: #3498db;
                    font-size: 18px;
                    margin-bottom: 10px;
                }
                
                .guide-scenario h5 {
                    color: #2c3e50;
                    font-size: 16px;
                    margin-top: 15px;
                    margin-bottom: 10px;
                }
                
                .guide-snippets {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 20px;
                }
                
                .guide-snippet {
                    background-color: #f8f9fa;
                    border: 1px solid #e9ecef;
                    border-radius: 4px;
                    padding: 15px;
                }
                
                .guide-snippet h4 {
                    color: #2c3e50;
                    font-size: 16px;
                    margin-bottom: 10px;
                }
                
                @media print {
                    .guide-command, .guide-code {
                        background-color: #f8f9fa !important;
                        color: #333 !important;
                        border: 1px solid #ddd;
                    }
                    
                    .guide-problem, .guide-scenario, .guide-snippet {
                        break-inside: avoid;
                    }
                    
                    .guide-section {
                        page-break-after: always;
                    }
                    
                    .guide-section:last-child {
                        page-break-after: auto;
                    }
                }
            `;
            
            // Add style to document
            document.head.appendChild(style);
        },
        
        /**
         * Download troubleshooting guide as a file
         */
        downloadTroubleshootingGuide: function() {
            const troubleshootingPreview = document.getElementById('troubleshootingPreview');
            
            if (!troubleshootingPreview || !troubleshootingPreview.innerHTML) {
                alert('Please generate a troubleshooting guide first.');
                return;
            }
            
            // Create guide content
            const guideContent = `<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Network Authentication Troubleshooting Guide</title>
    <style>
        ${document.getElementById('guideStyle').textContent}
    </style>
</head>
<body>
    <div class="troubleshooting-preview">
        ${troubleshootingPreview.innerHTML}
    </div>
</body>
</html>`;
            
            // Create download link
            const link = document.createElement('a');
            link.href = 'data:text/html;charset=utf-8,' + encodeURIComponent(guideContent);
            link.download = 'network-authentication-troubleshooting-guide.html';
            
            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    };

    // Initialize Documentation Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        DocumentationGenerator.init();
    });

    // Export to window
    window.DocumentationGenerator = DocumentationGenerator;
})();
EOF

# Create application JavaScript
print_message "Creating application JavaScript..."
cat > js/app.js << 'EOF'
/**
 * UaXSupreme - Main Application
 * Controls the main application flow and UI
 */

(function() {
    'use strict';

    // Application object
    const App = {
        /**
         * Initialize application
         */
        init: function() {
            console.log('Initializing UaXSupreme Application...');
            
            // Set up event listeners
            this.setupEventListeners();
        },
        
        /**
         * Set up event listeners
         */
        setupEventListeners: function() {
            // Nav steps
            const navSteps = document.querySelectorAll('.nav-steps li');
            navSteps.forEach(step => {
                step.addEventListener('click', this.changeSection.bind(this));
            });
            
            // Next/Back buttons
            const nextButtons = document.querySelectorAll('.btn-next');
            nextButtons.forEach(button => {
                button.addEventListener('click', this.nextSection.bind(this));
            });
            
            const backButtons = document.querySelectorAll('.btn-back');
            backButtons.forEach(button => {
                button.addEventListener('click', this.prevSection.bind(this));
            });
            
            // Tabs
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => {
                tab.addEventListener('click', this.changeTab.bind(this));
            });
            
            // Help button
            const helpBtn = document.getElementById('helpBtn');
            if (helpBtn) {
                helpBtn.addEventListener('click', this.showHelp.bind(this));
            }
            
            // Settings button
            const settingsBtn = document.getElementById('settingsBtn');
            if (settingsBtn) {
                settingsBtn.addEventListener('click', this.showSettings.bind(this));
            }
            
            // Close buttons for modals
            const closeButtons = document.querySelectorAll('.modal .close');
            closeButtons.forEach(button => {
                button.addEventListener('click', this.closeModal.bind(this));
            });
            
            // Vendor selection
            const vendorSelect = document.getElementById('vendor');
            if (vendorSelect) {
                vendorSelect.addEventListener('change', this.updatePlatformOptions.bind(this));
            }
            
            // Clear configuration button
            const clearConfigBtn = document.getElementById('clearConfigBtn');
            if (clearConfigBtn) {
                clearConfigBtn.addEventListener('click', this.clearConfiguration.bind(this));
            }
            
            // Add server button
            const addServerBtn = document.getElementById('addServerBtn');
            if (addServerBtn) {
                addServerBtn.addEventListener('click', this.addServerContainer.bind(this));
            }
            
            // Add TACACS server button
            const addTacacsServerBtn = document.getElementById('addTacacsServerBtn');
            if (addTacacsServerBtn) {
                addTacacsServerBtn.addEventListener('click', this.addTacacsServerContainer.bind(this));
            }
            
            // Save settings button
            const saveSettingsBtn = document.getElementById('saveSettingsBtn');
            if (saveSettingsBtn) {
                saveSettingsBtn.addEventListener('click', this.saveSettings.bind(this));
            }
            
            // Reset settings button
            const resetSettingsBtn = document.getElementById('resetSettingsBtn');
            if (resetSettingsBtn) {
                resetSettingsBtn.addEventListener('click', this.resetSettings.bind(this));
            }
        },
        
        /**
         * Change current section
         * @param {Event} event - Click event
         */
        changeSection: function(event) {
            const stepElement = event.currentTarget;
            const stepName = stepElement.getAttribute('data-step');
            
            // Check if step is disabled
            if (stepElement.classList.contains('disabled')) {
                return;
            }
            
            // Update active step
            document.querySelectorAll('.nav-steps li').forEach(step => {
                step.classList.remove('active');
            });
            stepElement.classList.add('active');
            
            // Update active section
            document.querySelectorAll('.config-section').forEach(section => {
                section.classList.remove('active');
            });
            document.getElementById(`${stepName}-section`).classList.add('active');
        },
        
        /**
         * Go to next section
         */
        nextSection: function() {
            const activeStep = document.querySelector('.nav-steps li.active');
            const nextStep = activeStep.nextElementSibling;
            
            if (nextStep && !nextStep.classList.contains('disabled')) {
                nextStep.click();
            }
        },
        
        /**
         * Go to previous section
         */
        prevSection: function() {
            const activeStep = document.querySelector('.nav-steps li.active');
            const prevStep = activeStep.previousElementSibling;
            
            if (prevStep) {
                prevStep.click();
            }
        },
        
        /**
         * Change active tab
         * @param {Event} event - Click event
         */
        changeTab: function(event) {
            const tabElement = event.currentTarget;
            const tabName = tabElement.getAttribute('data-tab');
            const tabsContainer = tabElement.closest('.tabs-container');
            
            // Update active tab
            tabsContainer.querySelectorAll('.tab').forEach(tab => {
                tab.classList.remove('active');
            });
            tabElement.classList.add('active');
            
            // Update active tab content
            tabsContainer.querySelectorAll('.tab-content').forEach(content => {
                content.classList.remove('active');
            });
            tabsContainer.querySelector(`#${tabName}`).classList.add('active');
        },
        
        /**
         * Show help modal
         */
        showHelp: function() {
            document.getElementById('helpModal').style.display = 'block';
        },
        
        /**
         * Show settings modal
         */
        showSettings: function() {
            document.getElementById('settingsModal').style.display = 'block';
            
            // Load current settings
            this.loadSettings();
        },
        
        /**
         * Close modal
         * @param {Event} event - Click event
         */
        closeModal: function(event) {
            const modal = event.currentTarget.closest('.modal');
            modal.style.display = 'none';
        },
        
        /**
         * Update platform options based on selected vendor
         */
        updatePlatformOptions: function() {
            const vendor = document.getElementById('vendor').value;
            const platformSelect = document.getElementById('platform');
            
            // Clear current options
            platformSelect.innerHTML = '';
            
            // Add options based on vendor
            switch (vendor) {
                case 'cisco':
                    this.addOption(platformSelect, 'ios', 'IOS');
                    this.addOption(platformSelect, 'ios-xe', 'IOS-XE');
                    this.addOption(platformSelect, 'ios-xr', 'IOS-XR');
                    this.addOption(platformSelect, 'nx-os', 'NX-OS');
                    break;
                case 'aruba':
                    this.addOption(platformSelect, 'arubaos-cx', 'ArubaOS-CX');
                    this.addOption(platformSelect, 'arubaos-switch', 'ArubaOS-Switch');
                    this.addOption(platformSelect, 'procurve', 'ProCurve');
                    break;
                case 'juniper':
                    this.addOption(platformSelect, 'junos', 'Junos OS');
                    this.addOption(platformSelect, 'junos-ex', 'Junos EX');
                    this.addOption(platformSelect, 'junos-qfx', 'Junos QFX');
                    break;
                case 'fortinet':
                    this.addOption(platformSelect, 'fortios', 'FortiOS');
                    break;
                case 'extreme':
                    this.addOption(platformSelect, 'exos', 'EXOS');
                    this.addOption(platformSelect, 'voss', 'VOSS');
                    break;
                case 'dell':
                    this.addOption(platformSelect, 'os10', 'OS10');
                    this.addOption(platformSelect, 'os9', 'OS9');
                    this.addOption(platformSelect, 'os6', 'OS6');
                    break;
                default:
                    this.addOption(platformSelect, 'generic', 'Generic');
            }
        },
        
        /**
         * Add option to select element
         * @param {HTMLSelectElement} select - Select element
         * @param {string} value - Option value
         * @param {string} text - Option text
         */
        addOption: function(select, value, text) {
            const option = document.createElement('option');
            option.value = value;
            option.textContent = text;
            select.appendChild(option);
        },
        
        /**
         * Clear configuration
         */
        clearConfiguration: function() {
            const configOutput = document.getElementById('configOutput');
            if (configOutput && confirm('Are you sure you want to clear the configuration?')) {
                configOutput.value = '';
            }
        },
        
        /**
         * Add server container for RADIUS configuration
         */
        addServerContainer: function() {
            const serversContainer = document.getElementById('radiusServersContainer');
            if (!serversContainer) return;
            
            const serverCount = serversContainer.querySelectorAll('.server-container').length + 1;
            
            const serverContainer = document.createElement('div');
            serverContainer.className = 'server-container';
            serverContainer.innerHTML = `
                <h3>RADIUS Server ${serverCount}</h3>
                <div class="form-group">
                    <label for="radiusServer${serverCount}">Server IP Address:</label>
                    <input type="text" id="radiusServer${serverCount}" class="form-control" placeholder="10.1.1.100">
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="radiusAuthPort${serverCount}">Authentication Port:</label>
                        <input type="number" id="radiusAuthPort${serverCount}" class="form-control" value="1812">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="radiusAcctPort${serverCount}">Accounting Port:</label>
                        <input type="number" id="radiusAcctPort${serverCount}" class="form-control" value="1813">
                    </div>
                </div>
                <div class="form-group">
                    <label for="radiusKey${serverCount}">Shared Secret:</label>
                    <div class="password-field">
                        <input type="password" id="radiusKey${serverCount}" class="form-control" placeholder="Enter shared secret">
                        <span class="password-toggle" onclick="App.togglePasswordVisibility('radiusKey${serverCount}')"><i class="fas fa-eye"></i></span>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="radiusTimeout${serverCount}">Timeout (seconds):</label>
                        <input type="number" id="radiusTimeout${serverCount}" class="form-control" value="3">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="radiusRetransmit${serverCount}">Retransmit Count:</label>
                        <input type="number" id="radiusRetransmit${serverCount}" class="form-control" value="2">
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox-item">
                        <input type="checkbox" id="radiusProbingEnabled${serverCount}" name="radiusFeature" value="probing">
                        <label for="radiusProbingEnabled${serverCount}">Enable Server Probing</label>
                    </div>
                </div>
                <button type="button" class="btn-secondary" onclick="App.removeServerContainer(this)">
                    <i class="fas fa-trash"></i> Remove Server
                </button>
            `;
            
            serversContainer.appendChild(serverContainer);
        },
        
        /**
         * Remove server container
         * @param {HTMLButtonElement} button - Remove button
         */
        removeServerContainer: function(button) {
            const container = button.closest('.server-container');
            container.remove();
        },
        
        /**
         * Add TACACS server container
         */
        addTacacsServerContainer: function() {
            const serversContainer = document.getElementById('tacacsServersContainer');
            if (!serversContainer) return;
            
            const serverCount = serversContainer.querySelectorAll('.server-container').length + 1;
            
            const serverContainer = document.createElement('div');
            serverContainer.className = 'server-container';
            serverContainer.innerHTML = `
                <h3>TACACS+ Server ${serverCount}</h3>
                <div class="form-group">
                    <label for="tacacsServer${serverCount}">Server IP Address:</label>
                    <input type="text" id="tacacsServer${serverCount}" class="form-control" placeholder="10.1.1.100">
                </div>
                <div class="form-group">
                    <label for="tacacsPort${serverCount}">Port:</label>
                    <input type="number" id="tacacsPort${serverCount}" class="form-control" value="49">
                </div>
                <div class="form-group">
                    <label for="tacacsKey${serverCount}">Shared Secret:</label>
                    <div class="password-field">
                        <input type="password" id="tacacsKey${serverCount}" class="form-control" placeholder="Enter shared secret">
                        <span class="password-toggle" onclick="App.togglePasswordVisibility('tacacsKey${serverCount}')"><i class="fas fa-eye"></i></span>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="tacacsTimeout${serverCount}">Timeout (seconds):</label>
                        <input type="number" id="tacacsTimeout${serverCount}" class="form-control" value="3">
                    </div>
                </div>
                <div class="form-group">
                    <div class="checkbox-item">
                        <input type="checkbox" id="tacacsSingleConnection${serverCount}" name="tacacsFeature" value="singleConnection">
                        <label for="tacacsSingleConnection${serverCount}">Enable Single Connection</label>
                    </div>
                </div>
                <button type="button" class="btn-secondary" onclick="App.removeServerContainer(this)">
                    <i class="fas fa-trash"></i> Remove Server
                </button>
            `;
            
            serversContainer.appendChild(serverContainer);
        },
        
        /**
         * Toggle password visibility
         * @param {string} inputId - Password input ID
         */
        togglePasswordVisibility: function(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.querySelector('i');
            
            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        },
        
        /**
         * Load settings from local storage
         */
        loadSettings: function() {
            // Theme
            const theme = localStorage.getItem('uaxTheme') || 'light';
            const themeSelect = document.getElementById('appTheme');
            if (themeSelect) {
                themeSelect.value = theme;
            }
            
            // Code font
            const codeFont = localStorage.getItem('uaxCodeFont') || 'monospace';
            const fontSelect = document.getElementById('codeFont');
            if (fontSelect) {
                fontSelect.value = codeFont;
            }
            
            // Tab size
            const tabSize = localStorage.getItem('uaxTabSize') || '2';
            const tabSizeSelect = document.getElementById('tabSize');
            if (tabSizeSelect) {
                tabSizeSelect.value = tabSize;
            }
            
            // Enable AI
            const enableAI = localStorage.getItem('uaxEnableAI') !== 'false'; // default to true
            const enableAICheckbox = document.getElementById('enableAI');
            if (enableAICheckbox) {
                enableAICheckbox.checked = enableAI;
            }
            
            // AI model
            const aiModel = localStorage.getItem('uaxAIModel') || 'standard';
            const aiModelSelect = document.getElementById('aiModel');
            if (aiModelSelect) {
                aiModelSelect.value = aiModel;
            }
            
            // AI response style
            const aiResponseStyle = localStorage.getItem('uaxAIResponseStyle') || 'concise';
            const aiResponseStyleSelect = document.getElementById('aiResponseStyle');
            if (aiResponseStyleSelect) {
                aiResponseStyleSelect.value = aiResponseStyle;
            }
            
            // Auto-save
            const autoSave = localStorage.getItem('uaxAutoSave') !== 'false'; // default to true
            const autoSaveCheckbox = document.getElementById('autoSave');
            if (autoSaveCheckbox) {
                autoSaveCheckbox.checked = autoSave;
            }
            
            // Auto-save interval
            const autoSaveInterval = localStorage.getItem('uaxAutoSaveInterval') || '5';
            const autoSaveIntervalInput = document.getElementById('autoSaveInterval');
            if (autoSaveIntervalInput) {
                autoSaveIntervalInput.value = autoSaveInterval;
            }
            
            // Show advanced options
            const showAdvanced = localStorage.getItem('uaxShowAdvanced') !== 'false'; // default to true
            const showAdvancedCheckbox = document.getElementById('showAdvanced');
            if (showAdvancedCheckbox) {
                showAdvancedCheckbox.checked = showAdvanced;
            }
            
            // Apply theme
            this.applyTheme(theme);
            
            // Apply code font
            this.applyCodeFont(codeFont);
            
            // Apply tab size
            this.applyTabSize(tabSize);
        },
        
        /**
         * Save settings to local storage
         */
        saveSettings: function() {
            // Theme
            const theme = document.getElementById('appTheme').value;
            localStorage.setItem('uaxTheme', theme);
            
            // Code font
            const codeFont = document.getElementById('codeFont').value;
            localStorage.setItem('uaxCodeFont', codeFont);
            
            // Tab size
            const tabSize = document.getElementById('tabSize').value;
            localStorage.setItem('uaxTabSize', tabSize);
            
            // Enable AI
            const enableAI = document.getElementById('enableAI').checked;
            localStorage.setItem('uaxEnableAI', enableAI);
            
            // AI model
            const aiModel = document.getElementById('aiModel').value;
            localStorage.setItem('uaxAIModel', aiModel);
            
            // AI response style
            const aiResponseStyle = document.getElementById('aiResponseStyle').value;
            localStorage.setItem('uaxAIResponseStyle', aiResponseStyle);
            
            // Auto-save
            const autoSave = document.getElementById('autoSave').checked;
            localStorage.setItem('uaxAutoSave', autoSave);
            
            // Auto-save interval
            const autoSaveInterval = document.getElementById('autoSaveInterval').value;
            localStorage.setItem('uaxAutoSaveInterval', autoSaveInterval);
            
            // Show advanced options
            const showAdvanced = document.getElementById('showAdvanced').checked;
            localStorage.setItem('uaxShowAdvanced', showAdvanced);
            
            // Apply settings
            this.applyTheme(theme);
            this.applyCodeFont(codeFont);
            this.applyTabSize(tabSize);
            
            // Close settings modal
            document.getElementById('settingsModal').style.display = 'none';
            
            // Show success message
            this.showToast('Settings saved successfully');
        },
        
        /**
         * Reset settings to defaults
         */
        resetSettings: function() {
            if (confirm('Are you sure you want to reset all settings to default?')) {
                // Reset to defaults
                localStorage.removeItem('uaxTheme');
                localStorage.removeItem('uaxCodeFont');
                localStorage.removeItem('uaxTabSize');
                localStorage.removeItem('uaxEnableAI');
                localStorage.removeItem('uaxAIModel');
                localStorage.removeItem('uaxAIResponseStyle');
                localStorage.removeItem('uaxAutoSave');
                localStorage.removeItem('uaxAutoSaveInterval');
                localStorage.removeItem('uaxShowAdvanced');
                
                // Load default settings
                this.loadSettings();
                
                // Show success message
                this.showToast('Settings reset to default');
            }
        },
        
        /**
         * Apply theme
         * @param {string} theme - Theme name
         */
        applyTheme: function(theme) {
            const body = document.body;
            
            // Remove existing theme classes
            body.classList.remove('theme-light', 'theme-dark');
            
            // Add theme class
            if (theme === 'dark') {
                body.classList.add('theme-dark');
            } else if (theme === 'system') {
                const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
                if (prefersDark) {
                    body.classList.add('theme-dark');
                } else {
                    body.classList.add('theme-light');
                }
            } else {
                body.classList.add('theme-light');
            }
        },
        
        /**
         * Apply code font
         * @param {string} font - Font name
         */
        applyCodeFont: function(font) {
            const codeElements = document.querySelectorAll('.code-output, pre, code');
            
            codeElements.forEach(el => {
                switch (font) {
                    case 'monospace':
                        el.style.fontFamily = 'monospace';
                        break;
                    case 'consolas':
                        el.style.fontFamily = 'Consolas, Monaco, monospace';
                        break;
                    case 'courier':
                        el.style.fontFamily = 'Courier New, Courier, monospace';
                        break;
                    case 'firacode':
                        el.style.fontFamily = 'Fira Code, monospace';
                        break;
                    default:
                        el.style.fontFamily = 'monospace';
                }
            });
        },
        
        /**
         * Apply tab size
         * @param {string} size - Tab size
         */
        applyTabSize: function(size) {
            const codeElements = document.querySelectorAll('.code-output, pre, code');
            
            codeElements.forEach(el => {
                el.style.tabSize = size;
            });
        },
        
        /**
         * Show toast notification
         * @param {string} message - Toast message
         */
        showToast: function(message) {
            // Create toast element
            const toast = document.createElement('div');
            toast.className = 'toast-notification';
            toast.innerHTML = `
                <div class="toast-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="toast-message">
                    ${message}
                </div>
            `;
            
            // Add to body
            document.body.appendChild(toast);
            
            // Remove after 3 seconds
            setTimeout(() => {
                toast.classList.add('toast-hide');
                setTimeout(() => {
                    document.body.removeChild(toast);
                }, 500);
            }, 3000);
        }
    };

    // Initialize App on page load
    document.addEventListener('DOMContentLoaded', function() {
        App.init();
    });

    // Export to window
    window.App = App;
})();
EOF

# Create main index.html file
print_message "Creating index.html file..."
cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UaXSupreme - Ultimate 802.1X & RADIUS Configuration Tool</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <div class="app-container">
        <header>
            <div class="logo">
                <h1>UaXSupreme</h1>
                <span>Ultimate Authentication Platform</span>
                <div id="logoCanvas" class="logo-animation"></div>
            </div>
            <div class="header-controls">
                <button id="aiAssistBtn" class="btn-icon" title="AI Assistant">
                    <i class="fas fa-robot"></i>
                </button>
                <button id="helpBtn" class="btn-icon" title="Help">
                    <i class="fas fa-question-circle"></i>
                </button>
                <button id="settingsBtn" class="btn-icon" title="Settings">
                    <i class="fas fa-cog"></i>
                </button>
            </div>
        </header>
        
        <div class="main-content">
            <div class="sidebar">
                <div class="sidebar-header">
                    Configuration Steps
                </div>
                <ul class="nav-steps">
                    <li data-step="vendor-selection" class="active">
                        <i class="fas fa-server"></i> Vendor Selection
                    </li>
                    <li data-step="auth-methods">
                        <i class="fas fa-key"></i> Authentication Methods
                    </li>
                    <li data-step="radius-config">
                        <i class="fas fa-shield-alt"></i> RADIUS Configuration
                    </li>
                    <li data-step="tacacs-config">
                        <i class="fas fa-user-shield"></i> TACACS+ Configuration
                    </li>
                    <li data-step="advanced-features">
                        <i class="fas fa-cogs"></i> Advanced Features
                    </li>
                    <li data-step="interfaces">
                        <i class="fas fa-network-wired"></i> Interfaces
                    </li>
                    <li data-step="generate-config">
                        <i class="fas fa-code"></i> Generate Configuration
                    </li>
                    <li data-step="ai-analysis">
                        <i class="fas fa-brain"></i> AI Analysis
                    </li>
                    <li data-step="optimization">
                        <i class="fas fa-bolt"></i> Optimization
                    </li>
                    <li data-step="documentation">
                        <i class="fas fa-file-alt"></i> Documentation
                    </li>
                    <li data-step="deployment">
                        <i class="fas fa-rocket"></i> Deployment
                    </li>
                    <li data-step="troubleshooting">
                        <i class="fas fa-tools"></i> Troubleshooting
                    </li>
                </ul>
                <div class="sidebar-footer">
                    <button id="clearConfigBtn" class="btn-secondary">
                        <i class="fas fa-trash"></i> Clear Configuration
                    </button>
                </div>
            </div>
            
            <div class="content-area">
                <!-- VENDOR SELECTION -->
                <section id="vendor-selection-section" class="config-section active">
                    <h2>Vendor Selection</h2>
                    
                    <div class="section-content">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="vendor">Network Vendor:</label>
                                <select id="vendor" class="form-control">
                                    <option value="cisco">Cisco</option>
                                    <option value="aruba">Aruba/HP</option>
                                    <option value="juniper">Juniper</option>
                                    <option value="fortinet">Fortinet</option>
                                    <option value="extreme">Extreme</option>
                                    <option value="dell">Dell</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="platform">Platform:</label>
                                <select id="platform" class="form-control">
                                    <option value="ios">IOS</option>
                                    <option value="ios-xe">IOS-XE</option>
                                    <option value="ios-xr">IOS-XR</option>
                                    <option value="nx-os">NX-OS</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="deploymentType">Deployment Type:</label>
                                <select id="deploymentType" class="form-control">
                                    <option value="closed">Closed Mode (Enforce Authentication)</option>
                                    <option value="monitor">Monitor Mode (For Testing)</option>
                                    <option value="concurrent">Concurrent Authentication (Dot1x & MAB)</option>
                                </select>
                                <div class="form-text">Select closed mode for production, monitor for initial testing, or concurrent for faster authentication.</div>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="failoverPolicy">Authentication Failover Policy:</label>
                                <select id="failoverPolicy" class="form-control">
                                    <option value="strict">Strict (No Access on Failure)</option>
                                    <option value="critical">Critical Auth (Restricted Access)</option>
                                    <option value="guest">Guest VLAN (Unauthenticated Access)</option>
                                </select>
                                <div class="form-text">Determines behavior when authentication fails or servers are unreachable.</div>
                            </div>
                        </div>
                        
                        <div class="platform-info">
                            <h3>Platform Information</h3>
                            <p>Selected platform: <strong>Cisco IOS</strong></p>
                            <p>Supported authentication methods: 802.1X, MAB, WebAuth</p>
                            <p>802.1X support level: <strong>Full</strong></p>
                            <p>MACsec support: <strong>Yes</strong></p>
                            <p>RADIUS features: VSA, CoA, Authentication, Authorization, Accounting</p>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <div></div>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- AUTHENTICATION METHODS -->
                <section id="auth-methods-section" class="config-section">
                    <h2>Authentication Methods</h2>
                    
                    <div class="section-content">
                        <div class="tabs-container">
                            <div class="tabs">
                                <div class="tab active" data-tab="auth-methods">Authentication Methods</div>
                                <div class="tab" data-tab="auth-settings">General Settings</div>
                                <div class="tab" data-tab="auth-templates">Templates</div>
                            </div>
                            
                            <!-- Authentication Methods Tab -->
                            <div id="auth-methods" class="tab-content active">
                                <p>Select the authentication methods you want to implement:</p>
                                
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="dot1x" name="authMethod" value="dot1x" checked>
                                        <label for="dot1x">802.1X</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="mab" name="authMethod" value="mab" checked>
                                        <label for="mab">MAC Authentication Bypass (MAB)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="webauth" name="authMethod" value="webauth">
                                        <label for="webauth">Web Authentication</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radsec" name="authMethod" value="radsec">
                                        <label for="radsec">RadSec (RADIUS over TLS)</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="tacacs" name="authMethod" value="tacacs">
                                        <label for="tacacs">TACACS+</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="macsec" name="authMethod" value="macsec">
                                        <label for="macsec">MACsec (802.1AE)</label>
                                    </div>
                                </div>
                                
                                <div class="feature-info">
                                    <div id="dot1x-info" class="method-info-panel active">
                                        <h3>802.1X Authentication</h3>
                                        <p>IEEE 802.1X is a port-based network access control (PNAC) standard that provides an authentication mechanism for devices wishing to connect to a LAN or WLAN. It requires:</p>
                                        <ul>
                                            <li>A supplicant (client device)</li>
                                            <li>An authenticator (network switch)</li>
                                            <li>An authentication server (typically RADIUS)</li>
                                        </ul>
                                        <p>802.1X provides strong security through user-based authentication before allowing network access.</p>
                                        
                                        <h4>Key Features:</h4>
                                        <ul>
                                            <li>Supports various EAP methods (PEAP, EAP-TLS, EAP-TTLS, etc.)</li>
                                            <li>Allows dynamic VLAN assignment</li>
                                            <li>Supports downloadable ACLs</li>
                                            <li>Provides user-based access control</li>
                                        </ul>
                                    </div>
                                    
                                    <div id="mab-info" class="method-info-panel hidden">
                                        <h3>MAC Authentication Bypass (MAB)</h3>
                                        <p>MAB allows non-802.1X capable devices to authenticate using their MAC address. This is useful for devices like:</p>
                                        <ul>
                                            <li>Printers</li>
                                            <li>IP phones</li>
                                            <li>IoT devices</li>
                                            <li>Legacy equipment</li>
                                        </ul>
                                        <p>The device's MAC address is sent to the RADIUS server as both username and password for authentication.</p>
                                        
                                        <h4>Key Features:</h4>
                                        <ul>
                                            <li>Fallback mechanism for 802.1X failures</li>
                                            <li>Compatible with existing 802.1X infrastructure</li>
                                            <li>Supports dynamic VLAN assignment</li>
                                            <li>Can be used with MAC address whitelisting</li>
                                        </ul>
                                    </div>
                                    
                                    <div id="webauth-info" class="method-info-panel hidden">
                                        <h3>Web Authentication</h3>
                                        <p>Web Authentication redirects users to a login page where they can enter credentials. This is commonly used for:</p>
                                        <ul>
                                            <li>Guest networks</li>
                                            <li>Public hotspots</li>
                                            <li>Fallback authentication when 802.1X fails</li>
                                        </ul>
                                        <p>Users are redirected to a captive portal when they first open a browser.</p>
                                        
                                        <h4>Key Features:</h4>
                                        <ul>
                                            <li>No client-side configuration required</li>
                                            <li>Can work with RADIUS server or local authentication</li>
                                            <li>Supports terms of service acceptance</li>
                                            <li>Can integrate with guest management systems</li>
                                        </ul>
                                    </div>
                                    
                                    <div id="radsec-info" class="method-info-panel hidden">
                                        <h3>RadSec (RADIUS over TLS)</h3>
                                        <p>RadSec encapsulates RADIUS protocol traffic within Transport Layer Security (TLS). This provides:</p>
                                        <ul>
                                            <li>Encryption of RADIUS traffic</li>
                                            <li>Mutual authentication through certificates</li>
                                            <li>TCP as transport instead of UDP</li>
                                            <li>Efficient connection handling</li>
                                        </ul>
                                        <p>RadSec is particularly useful when RADIUS traffic traverses untrusted networks.</p>
                                        
                                        <h4>Key Features:</h4>
                                        <ul>
                                            <li>End-to-end security for RADIUS communications</li>
                                            <li>Support for high availability and load balancing</li>
                                            <li>Protection of RADIUS shared secrets</li>
                                            <li>Enhanced resilience through TCP</li>
                                        </ul>
                                    </div>
                                    
                                    <div id="tacacs-info" class="method-info-panel hidden">
                                        <h3>TACACS+</h3>
                                        <p>TACACS+ (Terminal Access Controller Access-Control System Plus) is a protocol developed by Cisco for AAA services. It is commonly used for:</p>
                                        <ul>
                                            <li>Network device administration</li>
                                            <li>Command authorization</li>
                                            <li>Accounting of administrative actions</li>
                                        </ul>
                                        <p>TACACS+ separates authentication, authorization, and accounting functions.</p>
                                        
                                        <h4>Key Features:</h4>
                                        <ul>
                                            <li>Encrypted protocol communications</li>
                                            <li>Granular command authorization</li>
                                            <li>Detailed accounting of user actions</li>
                                            <li>Multiple authentication methods support</li>
                                        </ul>
                                    </div>
                                    
                                    <div id="macsec-info" class="method-info-panel hidden">
                                        <h3>MACsec (802.1AE)</h3>
                                        <p>MACsec (Media Access Control Security) provides secure communication for wired networks. It delivers:</p>
                                        <ul>
                                            <li>Data confidentiality</li>
                                            <li>Data integrity</li>
                                            <li>Data origin authentication</li>
                                        </ul>
                                        <p>MACsec secures all traffic on Ethernet links between directly connected nodes.</p>
                                        
                                        <h4>Key Features:</h4>
                                        <ul>
                                            <li>Layer 2 encryption</li>
                                            <li>Line-rate performance</li>
                                            <li>Protection against man-in-the-middle attacks</li>
                                            <li>Can be used with 802.1X for key management</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Authentication Settings Tab -->
                            <div id="auth-settings" class="tab-content">
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="hostMode">Host Mode:</label>
                                        <select id="hostMode" class="form-control">
                                            <option value="multi-auth">Multi-Authentication (Multiple Devices)</option>
                                            <option value="multi-domain">Multi-Domain (Voice + Data)</option>
                                            <option value="multi-host">Multi-Host (Single Auth for Multiple Devices)</option>
                                            <option value="single-host">Single-Host (One Device Only)</option>
                                        </select>
                                        <div class="form-text">Determines how many devices can authenticate on a port.</div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="controlDirection">Control Direction:</label>
                                        <select id="controlDirection" class="form-control">
                                            <option value="in">In (Control Inbound Traffic Only)</option>
                                            <option value="both">Both (Control Inbound and Outbound)</option>
                                        </select>
                                        <div class="form-text">Controls traffic direction that requires authentication.</div>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="dot1xTxPeriod">Dot1x TX Period (seconds):</label>
                                        <input type="number" id="dot1xTxPeriod" class="form-control" value="7">
                                        <div class="form-text">Interval for retransmitting EAP-Request/Identity frames.</div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="dot1xMaxReauthReq">Max Reauth Requests:</label>
                                        <input type="number" id="dot1xMaxReauthReq" class="form-control" value="2">
                                        <div class="form-text">Maximum number of times to retry authentication.</div>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="reauthPeriod">Reauthentication Period:</label>
                                        <select id="reauthPeriod" class="form-control">
                                            <option value="server">Use RADIUS Server Value</option>
                                            <option value="1hour">1 Hour</option>
                                            <option value="8hours">8 Hours</option>
                                            <option value="24hours">24 Hours</option>
                                            <option value="custom">Custom</option>
                                        </select>
                                        <div class="form-text">How often to reauthenticate clients.</div>
                                    </div>
                                    <div id="customReauthPeriodGroup" class="form-group col-md-6" style="display:none;">
                                        <label for="customReauthPeriod">Custom Period (seconds):</label>
                                        <input type="number" id="customReauthPeriod" class="form-control" value="3600">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="periodicReauth" name="authFeature" value="periodicReauth" checked>
                                        <label for="periodicReauth">Enable Periodic Reauthentication</label>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Authentication Templates Tab -->
                            <div id="auth-templates" class="tab-content">
                                <div class="form-group">
                                    <label for="templateType">Select Template Type:</label>
                                    <select id="templateType" class="form-control">
                                        <option value="dot1x">802.1X Standard</option>
                                        <option value="monitor">Monitor Mode</option>
                                        <option value="mab">MAB Only</option>
                                        <option value="webauth">WebAuth Guest</option>
                                        <option value="macsec">MACsec with 802.1X</option>
                                        <option value="hybrid">Hybrid Authentication</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="templateContent">Template Configuration:</label>
                                    <textarea id="templateContent" class="form-control code-output" rows="12" readonly>dot1x pae authenticator
dot1x timeout tx-period 7
dot1x max-reauth-req 2
mab
subscriber aging inactivity-timer 60 probe
access-session control-direction in
access-session host-mode multi-auth
access-session closed
access-session port-control auto
authentication periodic
authentication timer reauthenticate server
service-policy type control subscriber DOT1X_MAB_POLICY</textarea>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="templateName">Save Template As:</label>
                                        <input type="text" id="templateName" class="form-control" placeholder="Enter template name">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label>&nbsp;</label>
                                        <button id="createTemplateBtn" class="btn-primary form-control">Save Template</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- RADIUS CONFIGURATION -->
                <section id="radius-config-section" class="config-section">
                    <h2>RADIUS Configuration</h2>
                    
                    <div class="section-content">
                        <div class="tabs-container">
                            <div class="tabs">
                                <div class="tab active" data-tab="radius-servers">RADIUS Servers</div>
                                <div class="tab" data-tab="radius-attributes">RADIUS Attributes</div>
                                <div class="tab" data-tab="radius-advanced">Advanced Settings</div>
                            </div>
                            
                            <!-- RADIUS Servers Tab -->
                            <div id="radius-servers" class="tab-content active">
                                <div id="radiusServersContainer">
                                    <div class="server-container">
                                        <h3>RADIUS Server 1</h3>
                                        <div class="form-group">
                                            <label for="radiusServer1">Server IP Address:</label>
                                            <input type="text" id="radiusServer1" class="form-control" placeholder="10.1.1.100">
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="radiusAuthPort1">Authentication Port:</label>
                                                <input type="number" id="radiusAuthPort1" class="form-control" value="1812">
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label for="radiusAcctPort1">Accounting Port:</label>
                                                <input type="number" id="radiusAcctPort1" class="form-control" value="1813">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="radiusKey1">Shared Secret:</label>
                                            <div class="password-field">
                                                <input type="password" id="radiusKey1" class="form-control" placeholder="Enter shared secret">
                                                <span class="password-toggle" onclick="App.togglePasswordVisibility('radiusKey1')"><i class="fas fa-eye"></i></span>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="radiusTimeout1">Timeout (seconds):</label>
                                                <input type="number" id="radiusTimeout1" class="form-control" value="3">
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label for="radiusRetransmit1">Retransmit Count:</label>
                                                <input type="number" id="radiusRetransmit1" class="form-control" value="2">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="checkbox-item">
                                                <input type="checkbox" id="radiusProbingEnabled1" name="radiusFeature" value="probing" checked>
                                                <label for="radiusProbingEnabled1">Enable Server Probing</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="addServerBtn" class="btn-secondary">
                                        <i class="fas fa-plus"></i> Add Another Server
                                    </button>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="radiusServerGroup">RADIUS Server Group Name:</label>
                                        <input type="text" id="radiusServerGroup" class="form-control" value="RAD-SERVERS">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="radiusSourceInterface">Source Interface:</label>
                                        <input type="text" id="radiusSourceInterface" class="form-control" value="Vlan10">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- RADIUS Attributes Tab -->
                            <div id="radius-attributes" class="tab-content">
                                <div class="form-group">
                                    <label for="attrCustomizationLevel">Attribute Customization Level:</label>
                                    <select id="attrCustomizationLevel" class="form-control">
                                        <option value="basic">Basic (Standard Attributes)</option>
                                        <option value="advanced">Advanced (Common VSAs)</option>
                                        <option value="custom">Custom (Specific VSAs)</option>
                                    </select>
                                </div>
                                
                                <div id="customAttributesSection" style="display:none;">
                                    <h3>Custom Attributes</h3>
                                    
                                    <div class="custom-attributes-container">
                                        <table class="custom-attributes-table">
                                            <thead>
                                                <tr>
                                                    <th>Attribute</th>
                                                    <th>Format</th>
                                                    <th>Usage</th>
                                                    <th>Enable</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>Tunnel-Type</td>
                                                    <td>13 (VLAN)</td>
                                                    <td>Required for VLAN assignment</td>
                                                    <td><input type="checkbox" checked></td>
                                                </tr>
                                                <tr>
                                                    <td>Tunnel-Medium-Type</td>
                                                    <td>6 (802)</td>
                                                    <td>Required for VLAN assignment</td>
                                                    <td><input type="checkbox" checked></td>
                                                </tr>
                                                <tr>
                                                    <td>Tunnel-Private-Group-ID</td>
                                                    <td>VLAN ID</td>
                                                    <td>Specifies VLAN assignment</td>
                                                    <td><input type="checkbox" checked></td>
                                                </tr>
                                                <tr>
                                                    <td>Filter-Id</td>
                                                    <td>ACL name</td>
                                                    <td>Applies named ACLs</td>
                                                    <td><input type="checkbox" checked></td>
                                                </tr>
                                                <tr>
                                                    <td>cisco-avpair (dACL)</td>
                                                    <td>ip:inacl#n=...</td>
                                                    <td>Downloadable ACLs</td>
                                                    <td><input type="checkbox" checked></td>
                                                </tr>
                                                <tr>
                                                    <td>cisco-avpair (Voice VLAN)</td>
                                                    <td>device-traffic-class=voice</td>
                                                    <td>Voice VLAN assignment</td>
                                                    <td><input type="checkbox" checked></td>
                                                </tr>
                                                <tr>
                                                    <td>cisco-avpair (SGT)</td>
                                                    <td>cts:security-group-tag=...</td>
                                                    <td>Security Group Tag assignment</td>
                                                    <td><input type="checkbox"></td>
                                                </tr>
                                                <tr>
                                                    <td>cisco-avpair (URL Redirect)</td>
                                                    <td>url-redirect=...</td>
                                                    <td>Web redirection for posture</td>
                                                    <td><input type="checkbox"></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>RADIUS Attribute Settings</h3>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="radiusNasPort" name="radiusAttr" value="nasPort" checked>
                                            <label for="radiusNasPort">Send NAS Port Details</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="radiusNasId" name="radiusAttr" value="nasId" checked>
                                            <label for="radiusNasId">Send NAS-Identifier</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="radiusServiceType" name="radiusAttr" value="serviceType" checked>
                                            <label for="radiusServiceType">Send Service-Type</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="radiusClassAttr" name="radiusAttr" value="classAttr" checked>
                                            <label for="radiusClassAttr">Process Class Attribute</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="radiusVsaAuthentication" name="radiusAttr" value="vsaAuth" checked>
                                            <label for="radiusVsaAuthentication">VSA Send Authentication</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="radiusVsaAccounting" name="radiusAttr" value="vsaAcct" checked>
                                            <label for="radiusVsaAccounting">VSA Send Accounting</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- RADIUS Advanced Settings Tab -->
                            <div id="radius-advanced" class="tab-content">
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="radiusDeadtime">Server Deadtime (minutes):</label>
                                        <input type="number" id="radiusDeadtime" class="form-control" value="15">
                                        <div class="form-text">Time to skip a dead RADIUS server for new requests.</div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="radiusLoadBalance">Load Balancing Method:</label>
                                        <select id="radiusLoadBalance" class="form-control">
                                            <option value="none">None</option>
                                            <option value="least-outstanding" selected>Least Outstanding Requests</option>
                                            <option value="batch">Batch</option>
                                            <option value="host-hash">Host Hash</option>
                                        </select>
                                        <div class="form-text">Method for distributing authentication requests.</div>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="radiusDtls">DTLS Security:</label>
                                        <select id="radiusDtls" class="form-control">
                                            <option value="none">None</option>
                                            <option value="authentication">Authentication Only</option>
                                            <option value="accounting">Accounting Only</option>
                                            <option value="both">Authentication & Accounting</option>
                                        </select>
                                        <div class="form-text">Use DTLS for RADIUS security if supported.</div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="radiusDeadCriteria">Dead Criteria:</label>
                                        <select id="radiusDeadCriteria" class="form-control">
                                            <option value="default">Default</option>
                                            <option value="custom" selected>Custom</option>
                                        </select>
                                        <div class="form-text">Criteria for marking a server as dead.</div>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="radiusDeadTime">Dead Criteria Time (sec):</label>
                                        <input type="number" id="radiusDeadTime" class="form-control" value="5">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="radiusDeadTries">Dead Criteria Tries:</label>
                                        <input type="number" id="radiusDeadTries" class="form-control" value="3">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radiusDynAuth" name="radiusFeature" value="dynAuth" checked>
                                        <label for="radiusDynAuth">Enable Dynamic Authorization (CoA)</label>
                                    </div>
                                </div>
                                
                                <div id="radiusDynAuthSettings" class="feature-settings">
                                    <h3>Dynamic Authorization Settings</h3>
                                    <div class="form-row">
                                        <div class="form-group col-md-6">
                                            <label for="radiusDynAuthPort">CoA Port:</label>
                                            <input type="number" id="radiusDynAuthPort" class="form-control" value="1700">
                                        </div>
                                        <div class="form-group col-md-6">
                                            <label for="radiusDynAuthType">Authorization Type:</label>
                                            <select id="radiusDynAuthType" class="form-control">
                                                <option value="any">Any</option>
                                                <option value="all">All</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- TACACS+ CONFIGURATION -->
                <section id="tacacs-config-section" class="config-section">
                    <h2>TACACS+ Configuration</h2>
                    
                    <div class="section-content">
                        <div class="tabs-container">
                            <div class="tabs">
                                <div class="tab active" data-tab="tacacs-servers">TACACS+ Servers</div>
                                <div class="tab" data-tab="tacacs-authorization">Authorization</div>
                                <div class="tab" data-tab="tacacs-accounting">Accounting</div>
                            </div>
                            
                            <!-- TACACS+ Servers Tab -->
                            <div id="tacacs-servers" class="tab-content active">
                                <div id="tacacsServersContainer">
                                    <div class="server-container">
                                        <h3>TACACS+ Server 1</h3>
                                        <div class="form-group">
                                            <label for="tacacsServer1">Server IP Address:</label>
                                            <input type="text" id="tacacsServer1" class="form-control" placeholder="10.1.1.100">
                                        </div>
                                        <div class="form-group">
                                            <label for="tacacsPort1">Port:</label>
                                            <input type="number" id="tacacsPort1" class="form-control" value="49">
                                        </div>
                                        <div class="form-group">
                                            <label for="tacacsKey1">Shared Secret:</label>
                                            <div class="password-field">
                                                <input type="password" id="tacacsKey1" class="form-control" placeholder="Enter shared secret">
                                                <span class="password-toggle" onclick="App.togglePasswordVisibility('tacacsKey1')"><i class="fas fa-eye"></i></span>
                                            </div>
                                        </div>
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="tacacsTimeout1">Timeout (seconds):</label>
                                                <input type="number" id="tacacsTimeout1" class="form-control" value="3">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="checkbox-item">
                                                <input type="checkbox" id="tacacsSingleConnection1" name="tacacsFeature" value="singleConnection" checked>
                                                <label for="tacacsSingleConnection1">Enable Single Connection</label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="addTacacsServerBtn" class="btn-secondary">
                                        <i class="fas fa-plus"></i> Add Another Server
                                    </button>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="tacacsServerGroup">TACACS+ Server Group Name:</label>
                                        <input type="text" id="tacacsServerGroup" class="form-control" value="TAC-SERVERS">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="tacacsSourceInterface">Source Interface:</label>
                                        <input type="text" id="tacacsSourceInterface" class="form-control" value="Vlan10">
                                    </div>
                                </div>
                            </div>
                            
                            <!-- TACACS+ Authorization Tab -->
                            <div id="tacacs-authorization" class="tab-content">
                                <div class="form-group">
                                    <label for="tacacsAuthorization">Authorization Type:</label>
                                    <select id="tacacsAuthorization" class="form-control">
                                        <option value="commands">Commands</option>
                                        <option value="commands-config">Configuration Commands</option>
                                        <option value="exec">EXEC</option>
                                        <option value="all">All</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="tacacsAuthorLevel">Authorization Default Level:</label>
                                    <select id="tacacsAuthorLevel" class="form-control">
                                        <option value="0">Level 0 (Basic)</option>
                                        <option value="1">Level 1 (Minimal)</option>
                                        <option value="15" selected>Level 15 (Full)</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="cmdSetDefault" name="cmdSetType" value="default" checked>
                                        <label for="cmdSetDefault">Use Default Command Sets</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="cmdSetCustom" name="cmdSetType" value="custom">
                                        <label for="cmdSetCustom">Define Custom Command Sets</label>
                                    </div>
                                </div>
                                
                                <div id="defaultCmdSets" class="feature-settings">
                                    <h3>Default Command Sets</h3>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="cmdSetNetwork" name="defaultCmdSet" value="network" checked>
                                            <label for="cmdSetNetwork">Network Commands</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="cmdSetSecurity" name="defaultCmdSet" value="security" checked>
                                            <label for="cmdSetSecurity">Security Commands</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="cmdSetSystem" name="defaultCmdSet" value="system" checked>
                                            <label for="cmdSetSystem">System Commands</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="cmdSetInterface" name="defaultCmdSet" value="interface" checked>
                                            <label for="cmdSetInterface">Interface Commands</label>
                                        </div>
                                    </div>
                                </div>
                                
                                <div id="customCmdSet" class="feature-settings" style="display:none;">
                                    <h3>Custom Command Authorization</h3>
                                    
                                    <div class="command-privilege-container">
                                        <table class="command-privilege-table">
                                            <thead>
                                                <tr>
                                                    <th>Command</th>
                                                    <th>Privilege Level</th>
                                                    <th>Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><input type="text" class="form-control" value="show running-config"></td>
                                                    <td>
                                                        <select class="form-control">
                                                            <option>15</option>
                                                            <option>10</option>
                                                            <option>5</option>
                                                            <option>1</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select class="form-control">
                                                            <option>Allow</option>
                                                            <option>Deny</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" class="form-control" value="configure terminal"></td>
                                                    <td>
                                                        <select class="form-control">
                                                            <option>15</option>
                                                            <option>10</option>
                                                            <option>5</option>
                                                            <option>1</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select class="form-control">
                                                            <option>Allow</option>
                                                            <option>Deny</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td><input type="text" class="form-control" value="show interfaces"></td>
                                                    <td>
                                                        <select class="form-control">
                                                            <option>15</option>
                                                            <option selected>10</option>
                                                            <option>5</option>
                                                            <option>1</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <select class="form-control">
                                                            <option>Allow</option>
                                                            <option>Deny</option>
                                                        </select>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    
                                    <button id="addCommandBtn" class="btn-secondary">
                                        <i class="fas fa-plus"></i> Add Command
                                    </button>
                                </div>
                            </div>
                            
                            <!-- TACACS+ Accounting Tab -->
                            <div id="tacacs-accounting" class="tab-content">
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctSystem" name="acctType" value="system" checked>
                                        <label for="acctSystem">System Events</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctCommands" name="acctType" value="commands" checked>
                                        <label for="acctCommands">Commands</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctConnection" name="acctType" value="connection" checked>
                                        <label for="acctConnection">Connection Events</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctExec" name="acctType" value="exec" checked>
                                        <label for="acctExec">EXEC Sessions</label>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="acctCommandLevel">Commands Privilege Level:</label>
                                        <select id="acctCommandLevel" class="form-control">
                                            <option value="0">Level 0 (All)</option>
                                            <option value="1">Level 1+</option>
                                            <option value="15" selected>Level 15 Only</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="acctRecordType">Record Type:</label>
                                        <select id="acctRecordType" class="form-control">
                                            <option value="start-stop">Start and Stop</option>
                                            <option value="stop-only">Stop Only</option>
                                            <option value="start-only">Start Only</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="acctBroadcast" name="acctFeature" value="broadcast">
                                        <label for="acctBroadcast">Broadcast to All Servers</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- ADVANCED FEATURES -->
                <section id="advanced-features-section" class="config-section">
                    <h2>Advanced Features</h2>
                    
                    <div class="section-content">
                        <div class="tabs-container">
                            <div class="tabs">
                                <div class="tab active" data-tab="security-features">Security Features</div>
                                <div class="tab" data-tab="client-features">Client Features</div>
                                <div class="tab" data-tab="vsa-features">VSA Features</div>
                                <div class="tab" data-tab="radsec-features">RadSec</div>
                                <div class="tab" data-tab="macsec-features">MACsec</div>
                            </div>
                            
                            <!-- Security Features Tab -->
                            <div id="security-features" class="tab-content active">
                                <p>Select additional security features to enable:</p>
                                
                                <div class="checkbox-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="dhcpSnooping" name="securityFeature" value="dhcpSnooping" checked>
                                        <label for="dhcpSnooping">DHCP Snooping</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="arpInspection" name="securityFeature" value="arpInspection" checked>
                                        <label for="arpInspection">Dynamic ARP Inspection</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="ipSourceGuard" name="securityFeature" value="ipSourceGuard">
                                        <label for="ipSourceGuard">IP Source Guard</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="stormControl" name="securityFeature" value="stormControl" checked>
                                        <label for="stormControl">Storm Control</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="bpduGuard" name="securityFeature" value="bpduGuard" checked>
                                        <label for="bpduGuard">BPDU Guard</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="portSecurity" name="securityFeature" value="portSecurity">
                                        <label for="portSecurity">Port Security</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="deviceSensor" name="securityFeature" value="deviceSensor">
                                        <label for="deviceSensor">Device Sensor</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="deviceTracking" name="securityFeature" value="deviceTracking" checked>
                                        <label for="deviceTracking">Device Tracking</label>
                                    </div>
                                </div>
                                
                                <div class="security-features-info">
                                    <div class="security-feature-detail">
                                        <h4>DHCP Snooping</h4>
                                        <p>DHCP snooping prevents unauthorized DHCP servers from offering IP addresses to DHCP clients. It builds a database of valid IP-to-MAC bindings which is used by other security features.</p>
                                        <p>Key features:</p>
                                        <ul>
                                            <li>Prevents rogue DHCP servers</li>
                                            <li>Builds bindings database</li>
                                            <li>Option 82 insertion</li>
                                            <li>Rate limiting of DHCP messages</li>
                                        </ul>
                                    </div>
                                    <div class="security-feature-detail">
                                        <h4>Dynamic ARP Inspection</h4>
                                        <p>Dynamic ARP Inspection (DAI) prevents ARP spoofing attacks by validating ARP packets against the DHCP snooping database.</p>
                                        <p>Key features:</p>
                                        <ul>
                                            <li>Prevents ARP spoofing and man-in-the-middle attacks</li>
                                            <li>Validates MAC address to IP address bindings</li>
                                            <li>Can validate additional fields in ARP packets</li>
                                        </ul>
                                    </div>
                                    <div class="security-feature-detail">
                                        <h4>Device Tracking</h4>
                                        <p>Device tracking provides a database of end-host IP and MAC address bindings collected via various methods. It's essential for features like SGT, dACL, and DACL.</p>
                                        <p>Key features:</p>
                                        <ul>
                                            <li>Required for downloadable ACLs</li>
                                            <li>Supports SGT assignment</li>
                                            <li>Provides IP-to-MAC binding database</li>
                                            <li>Allows flexible policy application</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Client Features Tab -->
                            <div id="client-features" class="tab-content">
                                <p>Configure client-related features:</p>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="authenticationOrder">Authentication Order:</label>
                                        <select id="authenticationOrder" class="form-control">
                                            <option value="dot1x-mab">802.1X then MAB</option>
                                            <option value="mab-dot1x">MAB then 802.1X</option>
                                            <option value="concurrent">Concurrent (802.1X & MAB)</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="maxReauthReq">Maximum Reauthentication Attempts:</label>
                                        <input type="number" id="maxReauthReq" class="form-control" value="2">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="guestVlan">Guest VLAN:</label>
                                        <input type="number" id="guestVlan" class="form-control" placeholder="Leave empty to disable">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="authFailVlan">Auth-Fail VLAN:</label>
                                        <input type="number" id="authFailVlan" class="form-control" placeholder="Leave empty to disable">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="criticalVlan">Critical VLAN:</label>
                                        <input type="number" id="criticalVlan" class="form-control" value="999">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="criticalVoiceVlan">Critical Voice VLAN:</label>
                                        <input type="number" id="criticalVoiceVlan" class="form-control" value="999">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="fallbackPriority">Fallback Priority:</label>
                                    <div class="fallback-priority-container">
                                        <ul class="fallback-priority-list">
                                            <li class="fallback-item"><span class="fallback-handle"><i class="fas fa-grip-lines"></i></span> 1. 802.1X Authentication</li>
                                            <li class="fallback-item"><span class="fallback-handle"><i class="fas fa-grip-lines"></i></span> 2. MAC Authentication Bypass</li>
                                            <li class="fallback-item"><span class="fallback-handle"><i class="fas fa-grip-lines"></i></span> 3. Critical Authentication</li>
                                            <li class="fallback-item"><span class="fallback-handle"><i class="fas fa-grip-lines"></i></span> 4. Web Authentication</li>
                                        </ul>
                                    </div>
                                    <div class="form-text">Drag to reorder. First successful method will be used.</div>
                                </div>
                            </div>
                            
                            <!-- VSA Features Tab -->
                            <div id="vsa-features" class="tab-content">
                                <p>Configure Vendor-Specific Attribute (VSA) features:</p>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="dAclSupport">Downloadable ACL Support:</label>
                                        <select id="dAclSupport" class="form-control">
                                            <option value="enabled">Enabled</option>
                                            <option value="disabled">Disabled</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="urlRedirectSupport">URL Redirect Support:</label>
                                        <select id="urlRedirectSupport" class="form-control">
                                            <option value="enabled">Enabled</option>
                                            <option value="disabled">Disabled</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="sgtSupport">Security Group Tag Support:</label>
                                        <select id="sgtSupport" class="form-control">
                                            <option value="enabled">Enabled</option>
                                            <option value="disabled">Disabled</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="airSpaceVsa">Airespace VSA Support:</label>
                                        <select id="airSpaceVsa" class="form-control">
                                            <option value="enabled">Enabled</option>
                                            <option value="disabled">Disabled</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <!-- SGT Configuration -->
                                <div class="form-group">
                                    <h3>Security Group Tags (SGT)</h3>
                                    <div class="sgt-table-container">
                                        <table class="sgt-table">
                                            <thead>
                                                <tr>
                                                    <th>ID</th>
                                                    <th>Name</th>
                                                    <th>Description</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>2</td>
                                                    <td>TrustSec_Devices</td>
                                                    <td>Network infrastructure devices</td>
                                                </tr>
                                                <tr>
                                                    <td>3</td>
                                                    <td>Employee</td>
                                                    <td>Regular employees</td>
                                                </tr>
                                                <tr>
                                                    <td>4</td>
                                                    <td>Contractor</td>
                                                    <td>Temporary contractors</td>
                                                </tr>
                                                <tr>
                                                    <td>5</td>
                                                    <td>Guest</td>
                                                    <td>Guest users</td>
                                                </tr>
                                                <tr>
                                                    <td>6</td>
                                                    <td>Servers</td>
                                                    <td>Server resources</td>
                                                </tr>
                                                <tr>
                                                    <td>7</td>
                                                    <td>IoT_Devices</td>
                                                    <td>Internet of Things devices</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <!-- Downloadable ACL Examples -->
                                <div class="form-group">
                                    <h3>Downloadable ACL Examples</h3>
                                    <select id="daclExample" class="form-control">
                                        <option value="">Select a DACL example...</option>
                                        <option value="employee">Employee DACL</option>
                                        <option value="contractor">Contractor DACL</option>
                                        <option value="guest">Guest DACL</option>
                                        <option value="iot">IoT Device DACL</option>
                                    </select>
                                </div>
                                <textarea id="daclContent" class="form-control code-output" rows="6" readonly placeholder="Select a DACL example to view content..."></textarea>
                            </div>
                            
                            <!-- RadSec Features Tab -->
                            <div id="radsec-features" class="tab-content">
                                <p>Configure RADIUS over TLS (RadSec) features:</p>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="radsecPort">RadSec Port:</label>
                                        <input type="number" id="radsecPort" class="form-control" value="2083">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="radsecTimeout">Connection Timeout (sec):</label>
                                        <input type="number" id="radsecTimeout" class="form-control" value="5">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>Certificate Information</h3>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="clientTrustpoint">Client Trustpoint:</label>
                                        <input type="text" id="clientTrustpoint" class="form-control" value="RADSEC-CLIENT">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="serverTrustpoint">Server Trustpoint:</label>
                                        <input type="text" id="serverTrustpoint" class="form-control" value="RADSEC-SERVER">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="keyLength">RSA Key Length:</label>
                                        <select id="keyLength" class="form-control">
                                            <option value="1024">1024 bits</option>
                                            <option value="2048" selected>2048 bits</option>
                                            <option value="4096">4096 bits</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="revocationCheck">Revocation Check:</label>
                                        <select id="revocationCheck" class="form-control">
                                            <option value="none">None</option>
                                            <option value="crl">CRL</option>
                                            <option value="ocsp">OCSP</option>
                                            <option value="both">CRL and OCSP</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="radsecLoadBalance" name="radsecFeature" value="loadBalance" checked>
                                        <label for="radsecLoadBalance">Enable Load Balancing</label>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>RadSec Sample Configuration</h3>
                                    <textarea class="form-control code-output" rows="6" readonly>crypto pki trustpoint RADSEC-CLIENT
 enrollment self
 revocation-check none
 rsakeypair RADSEC-KEY 2048

crypto pki trustpoint RADSEC-SERVER
 enrollment terminal
 revocation-check none

radius server RADSEC-SERVER
 address ipv4 10.1.1.1 auth-port 2083 acct-port 2083
 tls connectiontimeout 5
 tls trustpoint client RADSEC-CLIENT
 tls trustpoint server RADSEC-SERVER
 key SecretKey123</textarea>
                                </div>
                            </div>
                            
                            <!-- MACsec Features Tab -->
                            <div id="macsec-features" class="tab-content">
                                <p>Configure MACsec (802.1AE) features:</p>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="macsecPolicy">Security Policy:</label>
                                        <select id="macsecPolicy" class="form-control">
                                            <option value="should-secure">Should Secure (Preferred)</option>
                                            <option value="must-secure">Must Secure (Required)</option>
                                        </select>
                                        <div class="form-text">Determines if MACsec is required or preferred.</div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="macsecCipher">Cipher Suite:</label>
                                        <select id="macsecCipher" class="form-control">
                                            <option value="gcm-aes-128">GCM-AES-128 (Default)</option>
                                            <option value="gcm-aes-256">GCM-AES-256</option>
                                        </select>
                                        <div class="form-text">Selects the encryption algorithm.</div>
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="macsecKeyServer">Key Server Priority:</label>
                                        <input type="number" id="macsecKeyServer" class="form-control" value="16" min="0" max="255">
                                        <div class="form-text">Higher value means higher priority to become key server.</div>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="macsecSakExpiry">SAK Expiry Time (seconds):</label>
                                        <input type="number" id="macsecSakExpiry" class="form-control" value="0" min="0" max="86400">
                                        <div class="form-text">0 means no expiry (default). Max 86400 seconds (24 hours).</div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="macsecReplay" name="macsecFeature" value="replay" checked>
                                            <label for="macsecReplay">Enable Replay Protection</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="macsecIncludeCredentials" name="macsecFeature" value="credentials" checked>
                                            <label for="macsecIncludeCredentials">Include MACsec Credentials in EAP</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="macsecPmk" name="macsecFeature" value="pmk">
                                            <label for="macsecPmk">Generate PMK from Local EAP</label>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="macsecReplayWindow">Replay Protection Window:</label>
                                    <select id="macsecReplayWindow" class="form-control">
                                        <option value="0">0 - Strict Ordering</option>
                                        <option value="30">30 - Minimal Window</option>
                                        <option value="100">100 - Balanced</option>
                                        <option value="250">250 - Large Window</option>
                                    </select>
                                    <div class="form-text">Number of out-of-order frames to accept. 0 requires strict ordering.</div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>MACsec Sample Configuration</h3>
                                    <textarea class="form-control code-output" rows="6" readonly>interface GigabitEthernet1/0/1
 macsec
 macsec replay-protection window-size 0
 authentication periodic
 authentication timer reauthenticate server
 access-session host-mode multi-auth
 access-session closed
 access-session port-control auto
 dot1x pae authenticator
 dot1x timeout tx-period 7
 dot1x max-reauth-req 2
 service-policy type control subscriber DOT1X_POLICY</textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- INTERFACES -->
                <section id="interfaces-section" class="config-section">
                    <h2>Interface Configuration</h2>
                    
                    <div class="section-content">
                        <div class="tabs-container">
                            <div class="tabs">
                                <div class="tab active" data-tab="access-interfaces">Access Interfaces</div>
                                <div class="tab" data-tab="specific-interfaces">Specific Interfaces</div>
                                <div class="tab" data-tab="iot-devices">IoT & BYOD</div>
                                <div class="tab" data-tab="guest-access">Guest Access</div>
                            </div>
                            
                            <!-- Access Interfaces Tab -->
                            <div id="access-interfaces" class="tab-content active">
                                <div class="form-group">
                                    <label for="accessInterfaceRange">Access Interface Range:</label>
                                    <input type="text" id="accessInterfaceRange" class="form-control" placeholder="e.g. GigabitEthernet1/0/1-48">
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="accessVlan">Access VLAN:</label>
                                        <input type="number" id="accessVlan" class="form-control" value="10">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="voiceVlan">Voice VLAN (optional):</label>
                                        <input type="number" id="voiceVlan" class="form-control" value="20">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="maxHosts">Maximum Hosts per Port:</label>
                                        <input type="number" id="maxHosts" class="form-control" value="10">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="inactivityTimeout">Inactivity Timeout (seconds):</label>
                                        <input type="number" id="inactivityTimeout" class="form-control" value="60">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="portfast" name="interfaceFeature" value="portfast" checked>
                                            <label for="portfast">Enable PortFast</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="portfastBpduguard" name="interfaceFeature" value="bpduguard" checked>
                                            <label for="portfastBpduguard">Enable BPDU Guard</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="portSecurity" name="interfaceFeature" value="portsecurity">
                                            <label for="portSecurity">Enable Port Security</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="stormControlBroadcast" name="interfaceFeature" value="stormcontrol" checked>
                                            <label for="stormControlBroadcast">Enable Storm Control</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="nonegotiate" name="interfaceFeature" value="nonegotiate" checked>
                                            <label for="nonegotiate">Enable Nonegotiate</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="ipVerifySource" name="interfaceFeature" value="ipverifysource">
                                            <label for="ipVerifySource">Enable IP Verify Source</label>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>Port Configuration Templates</h3>
                                    <p>Select a template to add to the interface configuration:</p>
                                    
                                    <div class="template-buttons">
                                        <button id="templateAP" class="btn-secondary">Access Point</button>
                                        <button id="templateIPPhone" class="btn-secondary">IP Phone</button>
                                        <button id="templatePrinter" class="btn-secondary">Printer</button>
                                        <button id="templateServer" class="btn-secondary">Server</button>
                                        <button id="templateUplink" class="btn-secondary">Uplink</button>
                                        <button id="templateIoT" class="btn-secondary">IoT Device</button>
                                        <button id="templateCamera" class="btn-secondary">IP Camera</button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- Specific Interfaces Tab -->
                            <div id="specific-interfaces" class="tab-content">
                                <div class="form-group">
                                    <label for="specificInterfaces">Specific Interface Configuration:</label>
                                    <textarea id="specificInterfaces" class="form-control code-output" rows="15" placeholder="Add specific interface configurations here..."></textarea>
                                </div>
                                
                                <div class="form-group">
                                    <h3>Trunk Configuration</h3>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="trunkEncapsulation" name="trunkFeature" value="encapsulation">
                                        <label for="trunkEncapsulation">Configure Trunk Encapsulation</label>
                                    </div>
                                    
                                    <div id="encapsulationGroup" style="display:none;" class="form-group">
                                        <div class="form-row">
                                            <div class="form-group col-md-6">
                                                <label for="trunkEncapsulationType">Encapsulation Type:</label>
                                                <select id="trunkEncapsulationType" class="form-control">
                                                    <option value="dot1q">802.1Q</option>
                                                    <option value="isl">ISL</option>
                                                </select>
                                            </div>
                                            <div class="form-group col-md-6">
                                                <label for="nativeVlan">Native VLAN:</label>
                                                <input type="number" id="nativeVlan" class="form-control" value="999">
                                            </div>
                                        </div>
                                        
                                        <div class="form-row">
                                            <div class="form-group col-md-12">
                                                <label for="allowedVlans">Allowed VLANs:</label>
                                                <input type="text" id="allowedVlans" class="form-control" value="10,20,30,40">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>Saved Interface Templates</h3>
                                    <div class="template-list-container">
                                        <table class="template-list-table">
                                            <thead>
                                                <tr>
                                                    <th>Template Name</th>
                                                    <th>Description</th>
                                                    <th>Actions</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>Employee Wired</td>
                                                    <td>Standard 802.1X configuration for employee workstations</td>
                                                    <td>
                                                        <button class="template-action" data-template="employee"><i class="fas fa-plus"></i> Add</button>
                                                        <button class="template-action" data-template="employee"><i class="fas fa-eye"></i> View</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>IP Phone</td>
                                                    <td>Multi-domain authentication for IP phones and PC daisy chains</td>
                                                    <td>
                                                        <button class="template-action" data-template="ipphone"><i class="fas fa-plus"></i> Add</button>
                                                        <button class="template-action" data-template="ipphone"><i class="fas fa-eye"></i> View</button>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>IOT Devices</td>
                                                    <td>MAB authentication for IoT devices with limited access</td>
                                                    <td>
                                                        <button class="template-action" data-template="iot"><i class="fas fa-plus"></i> Add</button>
                                                        <button class="template-action" data-template="iot"><i class="fas fa-eye"></i> View</button>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- IoT & BYOD Tab -->
                            <div id="iot-devices" class="tab-content">
                                <p>Configure IoT and BYOD device settings:</p>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="iotVlan">IoT VLAN:</label>
                                        <input type="number" id="iotVlan" class="form-control" value="30">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="byodVlan">BYOD VLAN:</label>
                                        <input type="number" id="byodVlan" class="form-control" value="40">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="iotAuthType">IoT Authentication Type:</label>
                                        <select id="iotAuthType" class="form-control">
                                            <option value="mab">MAC Authentication Bypass</option>
                                            <option value="dot1x">802.1X</option>
                                            <option value="both">Both (802.1X then MAB)</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="byodAuthType">BYOD Authentication Type:</label>
                                        <select id="byodAuthType" class="form-control">
                                            <option value="dot1x">802.1X</option>
                                            <option value="webauth">Web Authentication</option>
                                            <option value="both">Both (802.1X then WebAuth)</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>IoT Device Types</h3>
                                    <div class="iot-device-table-container">
                                        <table class="iot-device-table">
                                            <thead>
                                                <tr>
                                                    <th>Device Type</th>
                                                    <th>Authentication</th>
                                                    <th>VLAN</th>
                                                    <th>ACL</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>IP Cameras</td>
                                                    <td>MAB</td>
                                                    <td>30</td>
                                                    <td>ACL-CAMERA</td>
                                                </tr>
                                                <tr>
                                                    <td>Building Controls</td>
                                                    <td>MAB</td>
                                                    <td>31</td>
                                                    <td>ACL-BLDG</td>
                                                </tr>
                                                <tr>
                                                    <td>Medical Devices</td>
                                                    <td>MAB</td>
                                                    <td>32</td>
                                                    <td>ACL-MED</td>
                                                </tr>
                                                <tr>
                                                    <td>Printers</td>
                                                    <td>MAB</td>
                                                    <td>33</td>
                                                    <td>ACL-PRINT</td>
                                                </tr>
                                                <tr>
                                                    <td>Smart TVs</td>
                                                    <td>MAB</td>
                                                    <td>34</td>
                                                    <td>ACL-TV</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>BYOD Onboarding</h3>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="enableByodOnboarding" name="byodFeature" value="onboarding" checked>
                                            <label for="enableByodOnboarding">Enable BYOD Onboarding</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="byodUrlRedirection" name="byodFeature" value="redirect" checked>
                                            <label for="byodUrlRedirection">Enable URL Redirection</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="byodPosture" name="byodFeature" value="posture">
                                            <label for="byodPosture">Enable Posture Assessment</label>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>ACL Templates</h3>
                                    <select id="iotAclTemplate" class="form-control">
                                        <option value="">Select an ACL template...</option>
                                        <option value="camera">IP Camera ACL</option>
                                        <option value="printer">Printer ACL</option>
                                        <option value="medical">Medical Device ACL</option>
                                        <option value="building">Building Control ACL</option>
                                    </select>
                                </div>
                                <textarea id="iotAclContent" class="form-control code-output" rows="6" readonly placeholder="Select an ACL template to view content..."></textarea>
                            </div>
                            
                            <!-- Guest Access Tab -->
                            <div id="guest-access" class="tab-content">
                                <p>Configure guest access settings:</p>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="guestAuthMethod">Guest Authentication Method:</label>
                                        <select id="guestAuthMethod" class="form-control">
                                            <option value="webauth">Web Authentication</option>
                                            <option value="mac">MAC Authentication</option>
                                            <option value="dot1x">802.1X</option>
                                        </select>
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="guestVlanId">Guest VLAN ID:</label>
                                        <input type="number" id="guestVlanId" class="form-control" value="50">
                                    </div>
                                </div>
                                
                                <div class="form-row">
                                    <div class="form-group col-md-6">
                                        <label for="guestAcl">Guest Access ACL:</label>
                                        <input type="text" id="guestAcl" class="form-control" value="ACL-GUEST">
                                    </div>
                                    <div class="form-group col-md-6">
                                        <label for="guestTimeout">Session Timeout (minutes):</label>
                                        <input type="number" id="guestTimeout" class="form-control" value="720">
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <h3>Web Authentication Configuration</h3>
                                    <div class="checkbox-group">
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="webAuthCustomPage" name="webAuthFeature" value="custompage">
                                            <label for="webAuthCustomPage">Use Custom Login Page</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="webAuthLocalFallback" name="webAuthFeature" value="localfallback" checked>
                                            <label for="webAuthLocalFallback">Enable Local Fallback</label>
                                        </div>
                                        <div class="checkbox-item">
                                            <input type="checkbox" id="webAuthRedirect" name="webAuthFeature" value="redirect" checked>
                                            <label for="webAuthRedirect">Enable Auto Redirect</label>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label for="webAuthAcl">Web Authentication Redirect ACL:</label>
                                    <textarea id="webAuthAcl" class="form-control code-output" rows="4" readonly>ip access-list extended ACL-WEBAUTH-REDIRECT
 permit tcp any any eq www
 permit tcp any any eq 443</textarea>
                                </div>
                                
                                <div class="form-group">
                                    <label for="webAuthApplyTo">Apply Web Authentication to:</label>
                                    <select id="webAuthApplyTo" class="form-control">
                                        <option value="specific">Specific Interfaces</option>
                                        <option value="vlan">VLAN</option>
                                        <option value="all">All Access Ports</option>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="webAuthRedirectUrl">Redirect URL:</label>
                                    <input type="text" id="webAuthRedirectUrl" class="form-control" value="https://guest.example.com/portal">
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- GENERATE CONFIGURATION -->
                <section id="generate-config-section" class="config-section">
                    <h2>Generate Configuration</h2>
                    
                    <div class="section-content">
                        <div class="form-group">
                            <button id="generateConfigBtn" class="btn-primary">
                                <i class="fas fa-code"></i> Generate Configuration
                            </button>
                        </div>
                        
                        <div class="form-group">
                            <label for="configOutput">Configuration Output:</label>
                            <textarea id="configOutput" class="form-control code-output" rows="20" placeholder="Generated configuration will appear here..."></textarea>
                        </div>
                        
                        <div class="action-buttons">
                            <button id="copyConfigBtn" class="btn-secondary">
                                <i class="fas fa-copy"></i> Copy to Clipboard
                            </button>
                            <button id="downloadConfigBtn" class="btn-secondary">
                                <i class="fas fa-download"></i> Download Configuration
                            </button>
                            <button id="validateConfigBtn" class="btn-secondary">
                                <i class="fas fa-check-circle"></i> Validate Configuration
                            </button>
                        </div>
                        
                        <div id="validationResults" class="config-validation"></div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- AI ANALYSIS -->
                <section id="ai-analysis-section" class="config-section">
                    <h2>AI Analysis</h2>
                    
                    <div class="section-content">
                        <div class="ai-status-container">
                            <div class="ai-status">
                                <div class="ai-status-indicator">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="ai-status-message">
                                    <h3>AI Ready for Analysis</h3>
                                    <p>Click "Analyze Configuration" to have AI analyze your configuration for security, best practices, and optimization opportunities.</p>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <button id="analyzeConfigBtn" class="btn-primary">
                                <i class="fas fa-brain"></i> Analyze Configuration
                            </button>
                        </div>
                        
                        <div class="security-score-container">
                            <div class="security-score-card">
                                <div class="security-score-circle">
                                    <span class="score-value" id="securityScoreValue">90</span>
                                    <span class="score-label">Security Score</span>
                                </div>
                                <div class="security-score-details">
                                    <div class="security-score-item">
                                        <div class="security-score-item-label">Authentication</div>
                                        <div class="security-score-item-value" id="authScore">85</div>
                                    </div>
                                    <div class="security-score-item">
                                        <div class="security-score-item-label">Authorization</div>
                                        <div class="security-score-item-value" id="authzScore">90</div>
                                    </div>
                                    <div class="security-score-item">
                                        <div class="security-score-item-label">Infrastructure</div>
                                        <div class="security-score-item-value" id="infraScore">95</div>
                                    </div>
                                    <div class="security-score-item">
                                        <div class="security-score-item-label">Resilience</div>
                                        <div class="security-score-item-value" id="resilScore">88</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <button id="securityAnalysisBtn" class="btn-primary">
                                <i class="fas fa-shield-alt"></i> Detailed Security Analysis
                            </button>
                        </div>
                        
                        <div class="security-analysis hidden">
                            <h3>Security Analysis</h3>
                            
                            <div class="security-category">
                                <h4>Critical Issues</h4>
                                <div id="criticalIssues" class="security-issues">
                                    <p>No critical issues found.</p>
                                </div>
                            </div>
                            
                            <div class="security-category">
                                <h4>High Impact Issues</h4>
                                <div id="highIssues" class="security-issues">
                                    <ul class="issues-list">
                                        <li class="issue-item high">
                                            <div class="issue-header">
                                                <span class="severity-badge high">high</span>
                                                <span class="issue-title">RADIUS server redundancy not configured</span>
                                            </div>
                                            <div class="issue-details">
                                                <p><strong>Recommendation:</strong> Configure at least two RADIUS servers for redundancy.</p>
                                                <p><strong>Category:</strong> Availability</p>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="security-category">
                                <h4>Medium Impact Issues</h4>
                                <div id="mediumIssues" class="security-issues">
                                    <ul class="issues-list">
                                        <li class="issue-item medium">
                                            <div class="issue-header">
                                                <span class="severity-badge medium">medium</span>
                                                <span class="issue-title">Critical authentication not configured</span>
                                            </div>
                                            <div class="issue-details">
                                                <p><strong>Recommendation:</strong> Configure critical authentication to handle RADIUS server failures.</p>
                                                <p><strong>Category:</strong> Availability</p>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="security-category">
                                <h4>Low Impact Issues</h4>
                                <div id="lowIssues" class="security-issues">
                                    <ul class="issues-list">
                                        <li class="issue-item low">
                                            <div class="issue-header">
                                                <span class="severity-badge low">low</span>
                                                <span class="issue-title">Authentication is in monitor mode</span>
                                            </div>
                                            <div class="issue-details">
                                                <p><strong>Recommendation:</strong> Switch to closed mode for production environments.</p>
                                                <p><strong>Category:</strong> Authentication</p>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <button id="fixSecurityIssuesBtn" class="btn-primary">
                                    <i class="fas fa-wrench"></i> Fix Security Issues
                                </button>
                            </div>
                        </div>
                        
                        <div class="optimization-results">
                            <h3>Configuration Analysis</h3>
                            <div id="optimizationResultsContent">
                                <div class="placeholder-text">
                                    <i class="fas fa-search"></i>
                                    <p>Analyze your configuration to see optimization opportunities and recommendations.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- OPTIMIZATION -->
                <section id="optimization-section" class="config-section">
                    <h2>Configuration Optimization</h2>
                    
                    <div class="section-content">
                        <div class="ai-recommendation-status">
                            <p>Based on AI analysis, the following recommendations can improve your configuration.</p>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="optimizationFocus">Optimization Focus:</label>
                                <select id="optimizationFocus" class="form-control">
                                    <option value="balanced">Balanced (Security & Performance)</option>
                                    <option value="security">Security Focus</option>
                                    <option value="performance">Performance Focus</option>
                                    <option value="simplicity">Simplicity Focus</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="optimizationLevel">Optimization Level:</label>
                                <select id="optimizationLevel" class="form-control">
                                    <option value="safe">Safe (Recommended Changes Only)</option>
                                    <option value="moderate">Moderate (Some Structure Changes)</option>
                                    <option value="aggressive">Aggressive (Major Restructuring)</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <button id="optimizeConfigBtn" class="btn-primary">
                                <i class="fas fa-magic"></i> Optimize Configuration
                            </button>
                        </div>
                        
                        <div class="recommendations-content hidden">
                            <h3>Recommendations</h3>
                            
                            <div class="recommendation-category">
                                <h3>Authentication Recommendations</h3>
                                <div id="authRecommendations" class="recommendation-content">
                                    <ul class="recommendations-list">
                                        <li class="recommendation-item">
                                            <div class="recommendation-header">
                                                <span class="severity-badge medium">medium</span>
                                                <span class="recommendation-title">Switch to concurrent authentication</span>
                                            </div>
                                            <div class="recommendation-details">
                                                <p>Using concurrent authentication for both 802.1X and MAB improves authentication speed by processing both methods at the same time.</p>
                                                <div class="recommendation-config">policy-map type control subscriber CONCURRENT_DOT1X_MAB_POLICY
 event session-started match-all
  10 class always do-all
   10 authenticate using dot1x priority 10
   20 authenticate using mab priority 20</div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="recommendation-category">
                                <h3>Security Recommendations</h3>
                                <div id="securityRecommendations" class="recommendation-content">
                                    <ul class="recommendations-list">
                                        <li class="recommendation-item">
                                            <div class="recommendation-header">
                                                <span class="severity-badge high">high</span>
                                                <span class="recommendation-title">Add critical authentication for RADIUS server failure</span>
                                            </div>
                                            <div class="recommendation-details">
                                                <p>Critical authentication provides a fallback mechanism when RADIUS servers are unavailable, ensuring continuous operations.</p>
                                                <div class="recommendation-config">dot1x critical eapol
authentication critical recovery delay 2000
service-template CRITICAL_DATA_ACCESS
 vlan 999
 access-group ACL-OPEN

service-template CRITICAL_VOICE_ACCESS
 voice vlan 999
 access-group ACL-OPEN</div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="recommendation-category">
                                <h3>Infrastructure Recommendations</h3>
                                <div id="infraRecommendations" class="recommendation-content">
                                    <ul class="recommendations-list">
                                        <li class="recommendation-item">
                                            <div class="recommendation-header">
                                                <span class="severity-badge medium">medium</span>
                                                <span class="recommendation-title">Add RADIUS server load balancing</span>
                                            </div>
                                            <div class="recommendation-details">
                                                <p>RADIUS server load balancing improves performance and high availability by distributing authentication requests across multiple servers.</p>
                                                <div class="recommendation-config">aaa group server radius RAD-SERVERS
 server name RAD-ISE-PSN-1
 server name RAD-ISE-PSN-2
 load-balance method least-outstanding
 deadtime 15</div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="recommendation-category">
                                <h3>Operational Recommendations</h3>
                                <div id="opsRecommendations" class="recommendation-content">
                                    <ul class="recommendations-list">
                                        <li class="recommendation-item">
                                            <div class="recommendation-header">
                                                <span class="severity-badge low">low</span>
                                                <span class="recommendation-title">Optimize RADIUS timeout and retry settings</span>
                                            </div>
                                            <div class="recommendation-details">
                                                <p>Adjusting RADIUS timeout and retry settings can improve authentication performance and reliability.</p>
                                                <div class="recommendation-config">radius server RAD-ISE-PSN-1
 timeout 2
 retransmit 2
radius-server dead-criteria time 5 tries 3</div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <button id="applyRecommendationsBtn" class="btn-primary">
                                    <i class="fas fa-check"></i> Apply Recommendations
                                </button>
                            </div>
                        </div>
                        
                        <div class="optimization-changes">
                            <h3>Changes to Be Applied</h3>
                            <div class="changes-list">
                                <div class="change-type">
                                    <h4>Added Configuration</h4>
                                    <ul>
                                        <li>RADIUS server load balancing</li>
                                        <li>Critical authentication templates</li>
                                        <li>Optimized timeout parameters</li>
                                    </ul>
                                </div>
                                <div class="change-type">
                                    <h4>Modified Configuration</h4>
                                    <ul>
                                        <li>Authentication policy changed to concurrent mode</li>
                                        <li>Updated interface template for better error handling</li>
                                    </ul>
                                </div>
                                <div class="change-type">
                                    <h4>Removed Configuration</h4>
                                    <ul>
                                        <li>Redundant authentication parameters</li>
                                        <li>Unused ACL references</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <button id="startOptimizationBtn" class="btn-primary">
                                <i class="fas fa-bolt"></i> Start Optimization
                            </button>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- DOCUMENTATION -->
                <section id="documentation-section" class="config-section">
                    <h2>Documentation</h2>
                    
                    <div class="section-content">
                        <div class="tabs-container">
                            <div class="tabs">
                                <div class="tab active" data-tab="documentation-tab">Documentation</div>
                                <div class="tab" data-tab="checklist-tab">Deployment Checklist</div>
                                <div class="tab" data-tab="troubleshooting-tab">Troubleshooting Guide</div>
                                <div class="tab" data-tab="diagram-tab">Network Diagrams</div>
                            </div>
                            
                            <!-- Documentation Tab -->
                            <div id="documentation-tab" class="tab-content active">
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="docFormat">Documentation Format:</label>
                                        <select id="docFormat" class="form-control">
                                            <option value="standard">Standard (Modern)</option>
                                            <option value="formal">Formal (Traditional)</option>
                                            <option value="technical">Technical (Detailed)</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeConfig" name="docSection" value="config" checked>
                                        <label for="includeConfig">Include Configuration Details</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeDeployment" name="docSection" value="deployment" checked>
                                        <label for="includeDeployment">Include Deployment Guidelines</label>
                                    </div>
                                    <div class="checkbox-item">
                                        <input type="checkbox" id="includeVerification" name="docSection" value="verification" checked>
                                        <label for="includeVerification">Include Verification Procedures</label>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="generateDocBtn" class="btn-primary">
                                        <i class="fas fa-file-alt"></i> Generate Documentation
                                    </button>
                                </div>
                                
                                <div id="documentationPreview" class="documentation-preview">
                                    <div class="placeholder-text">
                                        <i class="fas fa-file-alt"></i>
                                        <p>Documentation will appear here after generation.</p>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="downloadDocBtn" class="btn-secondary">
                                        <i class="fas fa-download"></i> Download Documentation
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Deployment Checklist Tab -->
                            <div id="checklist-tab" class="tab-content">
                                <div class="form-group">
                                    <button id="generateChecklistBtn" class="btn-primary">
                                        <i class="fas fa-tasks"></i> Generate Deployment Checklist
                                    </button>
                                </div>
                                
                                <div id="checklistPreview" class="checklist-preview">
                                    <div class="placeholder-text">
                                        <i class="fas fa-tasks"></i>
                                        <p>Deployment checklist will appear here after generation.</p>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="downloadChecklistBtn" class="btn-secondary">
                                        <i class="fas fa-download"></i> Download Checklist
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Troubleshooting Guide Tab -->
                            <div id="troubleshooting-tab" class="tab-content">
                                <div class="form-group">
                                    <button id="generateTroubleshootingBtn" class="btn-primary">
                                        <i class="fas fa-tools"></i> Generate Troubleshooting Guide
                                    </button>
                                </div>
                                
                                <div id="troubleshootingPreview" class="troubleshooting-preview">
                                    <div class="placeholder-text">
                                        <i class="fas fa-tools"></i>
                                        <p>Troubleshooting guide will appear here after generation.</p>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="downloadTroubleshootingBtn" class="btn-secondary">
                                        <i class="fas fa-download"></i> Download Troubleshooting Guide
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Network Diagrams Tab -->
                            <div id="diagram-tab" class="tab-content">
                                <div class="form-row">
                                    <div class="form-group col-md-4">
                                        <label for="diagramType">Diagram Type:</label>
                                        <select id="diagramType" class="form-control">
                                            <option value="logical">Logical Network</option>
                                            <option value="physical">Physical Network</option>
                                            <option value="authentication">Authentication Flow</option>
                                            <option value="all">All Diagrams</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="generateDiagramBtn" class="btn-primary">
                                        <i class="fas fa-project-diagram"></i> Generate Diagram
                                    </button>
                                </div>
                                
                                <div id="diagramPreview" class="diagram-canvas">
                                    <div class="placeholder-text">
                                        <i class="fas fa-project-diagram"></i>
                                        <p>Network diagram will appear here after generation.</p>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <button id="downloadDiagramBtn" class="btn-secondary">
                                        <i class="fas fa-download"></i> Download Diagram
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- DEPLOYMENT -->
                <section id="deployment-section" class="config-section">
                    <h2>Deployment</h2>
                    
                    <div class="section-content">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="deploymentMethod">Deployment Method:</label>
                                <select id="deploymentMethod" class="form-control">
                                    <option value="ssh">SSH</option>
                                    <option value="console">Console</option>
                                    <option value="tftp">TFTP</option>
                                    <option value="scp">SCP</option>
                                    <option value="manual">Manual</option>
                                </select>
                            </div>
                            <div class="form-group col-md-6">
                                <label for="deploymentSchedule">Deployment Schedule:</label>
                                <select id="deploymentSchedule" class="form-control">
                                    <option value="immediate">Immediate</option>
                                    <option value="scheduled">Scheduled</option>
                                </select>
                            </div>
                        </div>
                        
                        <div id="sshDetails" class="form-group">
                            <h3>SSH Connection Details</h3>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="deviceIpAddress">Device IP Address:</label>
                                    <input type="text" id="deviceIpAddress" class="form-control" placeholder="10.1.1.1">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="sshUsername">Username:</label>
                                    <input type="text" id="sshUsername" class="form-control" placeholder="admin">
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="sshPassword">Password:</label>
                                    <div class="password-field">
                                        <input type="password" id="sshPassword" class="form-control" placeholder="Enter password">
                                        <span class="password-toggle" onclick="App.togglePasswordVisibility('sshPassword')"><i class="fas fa-eye"></i></span>
                                    </div>
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="sshPort">SSH Port:</label>
                                    <input type="number" id="sshPort" class="form-control" value="22">
                                </div>
                            </div>
                        </div>
                        
                        <div id="scheduledDeployment" class="form-group" style="display:none;">
                            <h3>Scheduled Deployment</h3>
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="deploymentDate">Deployment Date:</label>
                                    <input type="date" id="deploymentDate" class="form-control">
                                </div>
                                <div class="form-group col-md-6">
                                    <label for="deploymentTime">Deployment Time:</label>
                                    <input type="time" id="deploymentTime" class="form-control">
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="checkbox-item">
                                <input type="checkbox" id="backupBeforeDeployment" name="deploymentOption" value="backup" checked>
                                <label for="backupBeforeDeployment">Backup Configuration Before Deployment</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="verifyAfterDeployment" name="deploymentOption" value="verify" checked>
                                <label for="verifyAfterDeployment">Verify After Deployment</label>
                            </div>
                            <div class="checkbox-item">
                                <input type="checkbox" id="rollbackOnFailure" name="deploymentOption" value="rollback" checked>
                                <label for="rollbackOnFailure">Rollback On Failure</label>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="deploymentValidationLevel">Validation Level:</label>
                            <select id="deploymentValidationLevel" class="form-control">
                                <option value="basic">Basic (Syntax Check)</option>
                                <option value="standard" selected>Standard (Syntax + Connectivity)</option>
                                <option value="comprehensive">Comprehensive (Full Verification)</option>
                            </select>
                        </div>
                        
                        <div class="deployment-details">
                            <h3>Deployment Details</h3>
                            <ol>
                                <li>Connect to device using SSH</li>
                                <li>Backup current configuration</li>
                                <li>Enter configuration mode</li>
                                <li>Apply configuration changes</li>
                                <li>Verify configuration was applied successfully</li>
                                <li>Run validation tests</li>
                                <li>Save configuration if successful</li>
                            </ol>
                        </div>
                        
                        <div class="form-group">
                            <button id="startDeploymentBtn" class="btn-primary">
                                <i class="fas fa-rocket"></i> Start Deployment
                            </button>
                        </div>
                        
                        <div class="deployment-status">
                            <h3>Deployment Status</h3>
                            <div class="deployment-progress">
                                <div class="progress">
                                    <div class="progress-bar" style="width: 0%"></div>
                                </div>
                                <div class="deployment-step">Waiting to start deployment...</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <button class="btn-primary btn-next">Next <i class="fas fa-chevron-right"></i></button>
                    </div>
                </section>
                
                <!-- TROUBLESHOOTING -->
                <section id="troubleshooting-section" class="config-section">
                    <h2>Troubleshooting</h2>
                    
                    <div class="section-content">
                        <div class="form-row">
                            <div class="form-group col-md-6">
                                <label for="validationLevel">Validation Level:</label>
                                <select id="validationLevel" class="form-control">
                                    <option value="basic">Basic (Syntax Only)</option>
                                    <option value="standard" selected>Standard (Syntax + Structure)</option>
                                    <option value="strict">Strict (Syntax + Structure + Best Practices)</option>
                                    <option value="comprehensive">Comprehensive (All Validations)</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <h3>Validation Options</h3>
                            <div class="checkbox-group">
                                <div class="checkbox-item">
                                    <input type="checkbox" id="validateSyntax" name="validateOption" value="syntax" checked>
                                    <label for="validateSyntax">Validate Syntax</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="validateSecurity" name="validateOption" value="security" checked>
                                    <label for="validateSecurity">Validate Security</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="validateCompatibility" name="validateOption" value="compatibility" checked>
                                    <label for="validateCompatibility">Validate Compatibility</label>
                                </div>
                                <div class="checkbox-item">
                                    <input type="checkbox" id="validatePerformance" name="validateOption" value="performance">
                                    <label for="validatePerformance">Validate Performance</label>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <button id="generateRecommendationsBtn" class="btn-primary">
                                <i class="fas fa-lightbulb"></i> Generate Recommendations
                            </button>
                        </div>
                        
                        <div class="troubleshooting-resources">
                            <h3>Common Issues and Solutions</h3>
                            
                            <div class="accordion">
                                <div class="accordion-item">
                                    <div class="accordion-header">
                                        <h4>Authentication Failures</h4>
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content">
                                        <p>Common causes of authentication failures:</p>
                                        <ul>
                                            <li>Incorrect RADIUS shared secret</li>
                                            <li>RADIUS server unreachable</li>
                                            <li>Mismatched EAP methods</li>
                                            <li>Client supplicant misconfiguration</li>
                                            <li>User credentials issues</li>
                                        </ul>
                                        <p>Troubleshooting commands:</p>
                                        <pre class="guide-command">show authentication sessions interface GigabitEthernet1/0/1 details
debug dot1x all
debug radius authentication</pre>
                                    </div>
                                </div>
                                
                                <div class="accordion-item">
                                    <div class="accordion-header">
                                        <h4>VLAN Assignment Issues</h4>
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content">
                                        <p>Common causes of VLAN assignment issues:</p>
                                        <ul>
                                            <li>Missing VLAN on the switch</li>
                                            <li>Incorrect RADIUS attribute format</li>
                                            <li>Trunk port not allowing VLAN</li>
                                            <li>RADIUS server policy misconfiguration</li>
                                        </ul>
                                        <p>Troubleshooting commands:</p>
                                        <pre class="guide-command">show vlan
show interface GigabitEthernet1/0/1 switchport
debug radius attributes</pre>
                                    </div>
                                </div>
                                
                                <div class="accordion-item">
                                    <div class="accordion-header">
                                        <h4>RADIUS Server Issues</h4>
                                        <i class="fas fa-chevron-down"></i>
                                    </div>
                                    <div class="accordion-content">
                                        <p>Common RADIUS server issues:</p>
                                        <ul>
                                            <li>Network connectivity problems</li>
                                            <li>Firewall blocking RADIUS traffic</li>
                                            <li>Server overload</li>
                                            <li>Certificate validation errors (for PEAP/EAP-TLS)</li>
                                        </ul>
                                        <p>Troubleshooting commands:</p>
                                        <pre class="guide-command">show radius statistics
test aaa group radius username password new-code
ping radius-server-ip</pre>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <h3>Diagnostic Commands</h3>
                            <textarea class="form-control code-output" rows="8" readonly># Authentication Status
show authentication sessions
show authentication sessions interface GigabitEthernet1/0/1 details
show dot1x all
show dot1x interface GigabitEthernet1/0/1 details

# RADIUS Status
show radius statistics
show radius servers

# Debug Commands
debug dot1x all
debug radius authentication
debug radius attributes</textarea>
                        </div>
                    </div>
                    
                    <div class="section-footer">
                        <button class="btn-secondary btn-back"><i class="fas fa-chevron-left"></i> Back</button>
                        <div></div>
                    </div>
                </section>
            </div>
        </div>
    </div>
    
    <!-- MODALS -->
    
    <!-- AI Assistant Modal -->
    <div id="aiAssistantModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>AI Assistant</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="chat-container">
                    <div id="chatMessages" class="chat-messages">
                        <div class="ai-message">
                            <div class="message-avatar"><i class="fas fa-robot"></i></div>
                            <div class="message-content">
                                <p>Hello! I'm your AI Assistant for network authentication configuration. How can I help you today?</p>
                                <p>I can help with:</p>
                                <ul>
                                    <li>802.1X configuration questions</li>
                                    <li>MAB setup for IoT devices</li>
                                    <li>RADIUS server configuration</li>
                                    <li>Troubleshooting authentication issues</li>
                                    <li>Best practices for secure deployment</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="chat-input">
                        <input type="text" id="userMessage" placeholder="Ask a question...">
                        <button id="sendMessageBtn"><i class="fas fa-paper-plane"></i></button>
                    </div>
                </div>
                <div class="ai-suggestions">
                    <div class="suggestion-title">Suggested Questions:</div>
                    <div class="suggestion-buttons">
                        <button class="suggestion-btn">What's the difference between closed and monitor mode?</button>
                        <button class="suggestion-btn">How do I troubleshoot 802.1X issues?</button>
                        <button class="suggestion-btn">How do I configure MAB for printers?</button>
                        <button class="suggestion-btn">What is RadSec and when should I use it?</button>
                        <button class="suggestion-btn">How do I set up RADIUS server redundancy?</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Help Modal -->
    <div id="helpModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Help</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="help-navigation">
                    <div class="help-search">
                        <input type="text" placeholder="Search help topics...">
                    </div>
                    <ul class="help-topics">
                        <li class="active" data-topic="getting-started">Getting Started</li>
                        <li data-topic="auth-methods">Authentication Methods</li>
                        <li data-topic="radius-config">RADIUS Configuration</li>
                        <li data-topic="advanced-features">Advanced Features</li>
                        <li data-topic="template-usage">Using Templates</li>
                        <li data-topic="ai-features">AI Features</li>
                        <li data-topic="troubleshooting">Troubleshooting</li>
                        <li data-topic="deployment">Deployment</li>
                        <li data-topic="faq">FAQ</li>
                    </ul>
                </div>
                <div class="help-content">
                    <div id="helpContentArea">
                        <h3>Getting Started with UaXSupreme</h3>
                        
                        <p>UaXSupreme is a comprehensive tool for configuring network authentication using various methods like 802.1X, MAB, and Web Authentication. This guide will help you get started with the basics of using the application.</p>
                        
                        <h4>Navigation</h4>
                        <p>The application is organized in a step-by-step workflow:</p>
                        <ol>
                            <li><strong>Vendor Selection</strong> - Choose your network equipment vendor and platform</li>
                            <li><strong>Authentication Methods</strong> - Select which authentication methods to implement</li>
                            <li><strong>RADIUS Configuration</strong> - Configure RADIUS server settings</li>
                            <li><strong>TACACS+ Configuration</strong> - Configure TACACS+ if selected</li>
                            <li><strong>Advanced Features</strong> - Configure security and additional features</li>
                            <li><strong>Interfaces</strong> - Configure interface-specific settings</li>
                            <li><strong>Generate Configuration</strong> - Create configuration code for deployment</li>
                        </ol>
                        
                        <p>Use the sidebar to navigate between these steps, or use the Next/Back buttons at the bottom of each section.</p>
                        
                        <h4>Basic Workflow</h4>
                        <ol>
                            <li>Select your vendor and platform</li>
                            <li>Choose authentication methods</li>
                            <li>Configure RADIUS/TACACS+ servers</li>
                            <li>Configure advanced features as needed</li>
                            <li>Set up interface configuration</li>
                            <li>Generate configuration</li>
                            <li>Analyze, optimize, and document</li>
                            <li>Deploy to your network devices</li>
                        </ol>
                        
                        <h4>Using AI Features</h4>
                        <p>UaXSupreme includes several AI-powered features to help optimize your configuration:</p>
                        <ul>
                            <li><strong>AI Assistant</strong> - Click the robot icon in the header to ask questions</li>
                            <li><strong>AI Analysis</strong> - Analyzes your configuration for security and best practices</li>
                            <li><strong>Optimization</strong> - Suggests improvements to your configuration</li>
                        </ul>
                        
                        <h4>Getting Help</h4>
                        <p>If you need assistance, you can:</p>
                        <ul>
                            <li>Use the AI Assistant by clicking the robot icon</li>
                            <li>Open this help modal by clicking the question mark icon</li>
                            <li>Explore the FAQ section for common questions</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Settings Modal -->
    <div id="settingsModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Settings</h2>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="settings-section">
                    <h3>Appearance</h3>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="appTheme">Theme:</label>
                            <select id="appTheme" class="form-control">
                                <option value="light">Light</option>
                                <option value="dark">Dark</option>
                                <option value="system">System (Auto)</option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="codeFont">Code Font:</label>
                            <select id="codeFont" class="form-control">
                                <option value="monospace">Monospace</option>
                                <option value="consolas">Consolas</option>
                                <option value="courier">Courier New</option>
                                <option value="firacode">Fira Code</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="tabSize">Tab Size:</label>
                            <select id="tabSize" class="form-control">
                                <option value="2">2 Spaces</option>
                                <option value="4">4 Spaces</option>
                                <option value="8">8 Spaces</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="settings-section">
                    <h3>AI Settings</h3>
                    <div class="form-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="enableAI" checked>
                            <label for="enableAI">Enable AI Features</label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="aiModel">AI Model:</label>
                            <select id="aiModel" class="form-control">
                                <option value="standard">Standard</option>
                                <option value="enhanced">Enhanced</option>
                                <option value="max">Maximum</option>
                            </select>
                        </div>
                        <div class="form-group col-md-6">
                            <label for="aiResponseStyle">Response Style:</label>
                            <select id="aiResponseStyle" class="form-control">
                                <option value="concise">Concise</option>
                                <option value="detailed">Detailed</option>
                                <option value="technical">Technical</option>
                            </select>
                        </div>
                    </div>
                </div>
                
                <div class="settings-section">
                    <h3>Auto-Save</h3>
                    <div class="form-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="autoSave" checked>
                            <label for="autoSave">Enable Auto-Save</label>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group col-md-6">
                            <label for="autoSaveInterval">Auto-Save Interval (minutes):</label>
                            <input type="number" id="autoSaveInterval" class="form-control" value="5" min="1" max="60">
                        </div>
                    </div>
                </div>
                
                <div class="settings-section">
                    <h3>Advanced</h3>
                    <div class="form-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="showAdvanced" checked>
                            <label for="showAdvanced">Show Advanced Options</label>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <div class="action-buttons">
                        <button id="saveSettingsBtn" class="btn-primary">
                            <i class="fas fa-save"></i> Save Settings
                        </button>
                        <button id="resetSettingsBtn" class="btn-secondary">
                            <i class="fas fa-undo"></i> Reset to Default
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- AI Loading Indicator -->
    <div id="aiLoadingIndicator" class="ai-loading-indicator">
        <div class="ai-spinner">
            <i class="fas fa-circle-notch fa-spin"></i>
        </div>
        <div id="aiLoadingMessage" class="ai-loading-message">
            Analyzing configuration with AI...
        </div>
    </div>
    
    <!-- Scripts -->
    <script src="js/logo-generator.js"></script>
    <script src="js/template-generator.js"></script>
    <script src="js/validation.js"></script>
    <script src="js/ai-assistant.js"></script>
    <script src="js/ai-analyzer.js"></script>
    <script src="js/diagram-generator.js"></script>
    <script src="js/documentation.js"></script>
    <script src="js/app.js"></script>
</body>
</html>
#!/bin/bash
# EnhanceComplete.sh - Script that runs after the main enhancement script

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Check permissions and ensure files are executable
print_message "Checking permissions..."
chmod +x *.sh
chmod -R 755 js css data

# Create a sample readme file
print_message "Creating README file..."

cat > README.md << 'EOF'
# UaXSupreme - Ultimate 802.1X & RADIUS Configuration Tool

UaXSupreme is a comprehensive web-based tool for configuring network authentication using 802.1X, MAB, RADIUS, and related technologies.

## Features

- Support for multiple vendors: Cisco, Aruba, Juniper, and more
- Multiple authentication methods: 802.1X, MAB, WebAuth, RadSec, TACACS+, MACsec
- Intelligent configuration generation with AI analysis and optimization
- Detailed documentation and deployment assistance
- Security analysis and best practice recommendations
- Network diagram generation
- Troubleshooting assistance

## Getting Started

1. Open `index.html` in a web browser
2. Select your network vendor and platform
3. Choose authentication methods
4. Configure RADIUS servers
5. Set up advanced features
6. Configure interfaces
7. Generate, analyze, and optimize your configuration
8. Use the documentation tools to assist with deployment

## Browser Compatibility

For best results, use a modern browser like:
- Google Chrome
- Mozilla Firefox
- Microsoft Edge

## AI Features

UaXSupreme includes several AI-powered features:
- AI Assistant for answering questions and providing guidance
- AI Analysis for security and best practice evaluation
- AI Optimization for improving configurations
- AI-generated documentation and diagrams

## Configuration Templates

The application includes templates for common scenarios:
- Standard 802.1X deployment
- Monitor mode deployment
- IoT device authentication
- Guest access configuration
- BYOD onboarding
- MACsec encryption

## Support

For questions or support, use the AI Assistant feature within the application.
EOF

# Set up a simple server script
print_message "Creating server start script..."

cat > serve.sh << 'EOF'
#!/bin/bash
# Simple HTTP server for UaXSupreme

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Check if python is installed
if command -v python3 &>/dev/null; then
    print_message "Starting UaXSupreme server using Python 3..."
    print_success "Server running at http://localhost:8000"
    print_message "Press Ctrl+C to stop."
    python3 -m http.server 8000
elif command -v python &>/dev/null; then
    PYTHON_VERSION=$(python --version 2>&1)
    if [[ $PYTHON_VERSION == *"Python 3"* ]]; then
        print_message "Starting UaXSupreme server using Python 3..."
        print_success "Server running at http://localhost:8000"
        print_message "Press Ctrl+C to stop."
        python -m http.server 8000
    else
        print_message "Starting UaXSupreme server using Python 2..."
        print_success "Server running at http://localhost:8000"
        print_message "Press Ctrl+C to stop."
        python -m SimpleHTTPServer 8000
    fi
else
    print_error "Python is not installed. Please install Python or use another web server."
fi
EOF

chmod +x serve.sh

print_success "Enhancement completed successfully!"
print_message "You can now open index.html in your browser or run './serve.sh' to start a simple web server."
print_message "Your UaXSupreme tool now includes advanced authentication features, documentation, and AI-assisted configuration."
# Create directories for data and documentation
print_message "Creating additional directories for data and documentation..."
mkdir -p data/tutorials
mkdir -p data/examples
mkdir -p data/reports

# Add example data
print_message "Adding example data files..."

cat > data/examples/example_config_cisco.txt << 'EOF'
! Example Cisco Switch Configuration with 802.1X and MAB

aaa new-model

! RADIUS Server Configuration
radius server ISE-1
 address ipv4 10.1.1.10 auth-port 1812 acct-port 1813
 key ISEsecretKey123
 automate-tester username test-user probe-on

radius server ISE-2
 address ipv4 10.1.1.11 auth-port 1812 acct-port 1813
 key ISEsecretKey123
 automate-tester username test-user probe-on

aaa group server radius RAD-SERVERS
 server name ISE-1
 server name ISE-2
 deadtime 15
 load-balance method least-outstanding
 ip radius source-interface Vlan10

! AAA Authentication/Authorization
aaa authentication dot1x default group RAD-SERVERS local
aaa authorization network default group RAD-SERVERS local
aaa accounting dot1x default start-stop group RAD-SERVERS

! Global 802.1X Configuration
dot1x system-auth-control
dot1x critical eapol

! Advanced Authentication Settings
authentication critical recovery delay 2000
radius-server dead-criteria time 5 tries 3
radius-server vsa send authentication
radius-server vsa send accounting

! Change of Authorization (CoA)
aaa server radius dynamic-author
 client 10.1.1.10 server-key ISEsecretKey123
 client 10.1.1.11 server-key ISEsecretKey123
 auth-type any

! Interface Configuration - Employee Access
interface range GigabitEthernet1/0/1-24
 description Employee Access Port
 switchport access vlan 10
 switchport mode access
 switchport voice vlan 20
 switchport nonegotiate
 spanning-tree portfast
 spanning-tree bpduguard enable
 dot1x pae authenticator
 dot1x timeout tx-period 7
 dot1x max-reauth-req 2
 mab
 access-session host-mode multi-auth
 access-session closed
 access-session port-control auto
 authentication periodic
 authentication timer reauthenticate server
 service-policy type control subscriber DOT1X_MAB_POLICY
 storm-control broadcast level pps 100
 storm-control action trap
 no shutdown
EOF

cat > data/examples/example_config_aruba.txt << 'EOF'
! Example Aruba Switch Configuration with 802.1X and MAB

! RADIUS Server Configuration
radius-server host 10.1.1.10 key "ISEsecretKey123"
radius-server host 10.1.1.11 key "ISEsecretKey123"
radius-server timeout 5
radius-server retransmit 3
radius-server deadtime 15

aaa authentication port-access eap-radius server-group radius
aaa authentication mac-auth server-group radius

! Global Authentication Settings
aaa port-access authenticator active
aaa port-access authenticator cached-reauth
aaa port-access authenticator logoff-period 300
aaa port-access mac-auth

! Interface Configuration
interface 1-24
 aaa port-access authenticator
 aaa port-access authenticator auth-mode 1x
 aaa port-access authenticator reauthentication
 aaa port-access authenticator reauth-period server
 aaa port-access mac-auth
 aaa port-access authenticator client-limit 32
 spanning-tree port-type admin-edge
 spanning-tree bpdu-guard
EOF

cat > data/examples/example_config_juniper.txt << 'EOF'
# Example Juniper Switch Configuration with 802.1X

system {
    radius-server {
        10.1.1.10 {
            secret "$9$example-secret-key"; ## SECRET-DATA
            source-address 10.1.10.1;
            retry 3;
            timeout 5;
        }
        10.1.1.11 {
            secret "$9$example-secret-key"; ## SECRET-DATA
            source-address 10.1.10.1;
            retry 3;
            timeout 5;
        }
    }
}

access {
    radius-server {
        10.1.1.10 {
            port 1812;
            secret "$9$example-secret-key"; ## SECRET-DATA
            source-address 10.1.10.1;
        }
        10.1.1.11 {
            port 1812;
            secret "$9$example-secret-key"; ## SECRET-DATA
            source-address 10.1.10.1;
        }
    }
    profile dot1x-profile {
        authentication-protocol eap-peap;
        radius-authentication-server {
            10.1.1.10;
            10.1.1.11;
        }
    }
}

protocols {
    dot1x {
        authenticator {
            authentication-profile-name dot1x-profile;
            interface {
                ge-0/0/[1-24] {
                    supplicant multiple;
                    transmit-period 5;
                    maximum-requests 3;
                    server-timeout 30;
                    reauthentication 3600;
                }
            }
        }
    }
}
EOF

# Add tutorial file
print_message "Adding tutorial data..."

cat > data/tutorials/dot1x_deployment_guide.md << 'EOF'
# 802.1X Deployment Guide

This guide outlines the recommended phases for deploying 802.1X authentication on your network.

## Phase 1: Planning and Preparation

**Documentation and Inventory:**
- Document your existing network topology
- Inventory all network devices (switches, access points)
- Inventory all endpoints that will connect to the network
- Identify devices that can't support 802.1X

**Identity Store Preparation:**
- Set up or integrate with existing identity stores (Active Directory, LDAP)
- Plan user groups and permissions
- Create test accounts for each user type

**RADIUS Server Setup:**
- Install and configure RADIUS server (ISE, NPS, Clearpass)
- Configure high availability
- Set up integration with identity stores
- Create basic authentication policies

## Phase 2: Pilot Deployment

**Initial Configuration:**
- Configure a small set of switches (1-2) for testing
- Start with monitor mode (open authentication)
- Configure for both 802.1X and MAB
- Set up logging and monitoring

**Test with Known Devices:**
- Test authentication with various device types
- Document successful and failed authentications
- Adjust policies as needed
- Test failover scenarios

**Limited User Testing:**
- Expand to a small group of cooperative users
- Provide clear instructions and support
- Gather feedback and troubleshoot issues
- Document common problems and solutions

## Phase 3: Limited Production Deployment

**Expand Deployment:**
- Configure additional switches in monitor mode
- Implement learned best practices
- Refine authentication policies
- Develop troubleshooting processes

**Enhanced Monitoring:**
- Set up enhanced monitoring and alerts
- Define authentication success metrics
- Develop reporting on authentication activity
- Create dashboards for operational visibility

**User Communication:**
- Communicate with broader user base
- Provide documentation and self-help resources
- Ensure help desk is prepared for support calls
- Set expectations for full deployment

## Phase 4: Full Deployment

**Switch to Closed Mode:**
- Gradually convert monitor mode to closed mode
- Start with lower-impact areas
- Schedule changes during maintenance windows
- Have rollback procedures ready

**Full Network Coverage:**
- Expand to all network access points
- Implement consistent policy across the network
- Maintain regular monitoring and reporting
- Document final configuration

**Operational Procedures:**
- Establish routine maintenance procedures
- Create onboarding processes for new devices
- Document exception handling
- Develop regular review and audit processes

## Phase 5: Optimization

**Policy Refinement:**
- Refine authorization policies based on real-world usage
- Implement more granular access controls
- Consider integrating with posture assessment
- Add profiling for device-type-based policies

**Performance Tuning:**
- Optimize timeout and retry settings
- Fine-tune RADIUS server performance
- Implement load balancing if needed
- Review and adjust monitoring thresholds

**Security Enhancements:**
- Implement additional security controls
- Consider adding MACsec for wired encryption
- Integrate with security incident monitoring
- Regularly audit authentication logs

## Appendix: Common Issues and Solutions

**Authentication Failures:**
- Verify RADIUS server connectivity
- Check server certificates for EAP-TLS/PEAP
- Ensure correct shared secrets are configured
- Verify user credentials in identity store

**MAB Issues:**
- Ensure MAC addresses are in correct format
- Verify MAC address is in the database
- Check MAB is enabled on the port
- Confirm authorization policy for MAB

**Client Supplicant Issues:**
- Verify supplicant configuration
- Check EAP method compatibility
- Update supplicant software if needed
- Validate certificate trust (for PEAP/EAP-TLS)
EOF

# Create a quick start guide
print_message "Creating quick start guide..."

cat > QUICKSTART.md << 'EOF'
# UaXSupreme Quick Start Guide

This guide will help you quickly get started with UaXSupreme for configuring network authentication.

## Step 1: Launch the Application

Open `index.html` in your web browser, or run the included server:

```bash
./serve.sh
Then open http://localhost:8000 in your browser.

Step 2: Configure Basic Settings
Vendor Selection

Choose your network equipment vendor (e.g., Cisco, Aruba)
Select the platform (e.g., IOS, IOS-XE)
Choose deployment type (Monitor/Closed)
Authentication Methods

Select authentication methods (802.1X, MAB, etc.)
Configure general authentication settings
Review the template for your selected methods
Step 3: Configure RADIUS Settings
Add your RADIUS server details:

Server IP address
Shared secret
Authentication/accounting ports
Server group name
Configure RADIUS attributes and advanced settings as needed

Step 4: Configure Advanced Features
Enable security features:

DHCP Snooping
Dynamic ARP Inspection
BPDU Guard
Device Tracking
Configure client features and VSA features if needed

Step 5: Configure Interfaces
Specify access interface range
Configure VLAN and port settings
Enable interface-specific security features
Customize settings for specific interfaces as needed
Step 6: Generate Configuration
Click "Generate Configuration" to create your switch configuration
Review the generated configuration
Use the validation tool to check for issues
Copy, download, or deploy the configuration
Step 7: Analyze and Optimize (Optional)
Use the AI Analysis feature to evaluate your configuration
Review security scores and recommendations
Apply suggested optimizations to improve your configuration
Step 8: Generate Documentation (Optional)
Generate deployment documentation
Create a deployment checklist
Generate a troubleshooting guide
Create network diagrams
Getting Help
If you have questions or need assistance:

Use the AI Assistant (robot icon in the header)
Check the help documentation (question mark icon)
Refer to example configurations in the data/examples directory
Review the deployment guide in data/tutorials
Next Steps
After your initial configuration:

Deploy in monitor mode first to test
Gradually transition to closed mode
Implement additional security features
Refine authorization policies based on your environment
EOF
Create a simple CHANGELOG file
print_message "Creating change log..."

cat > CHANGELOG.md << 'EOF'

UaXSupreme Changelog
v1.0.0 (Initial Release)
Features
Support for multiple vendors (Cisco, Aruba, Juniper, etc.)
Multiple authentication methods (802.1X, MAB, WebAuth, etc.)
RADIUS server configuration
TACACS+ configuration
Advanced security features
AI-assisted configuration
Documentation generation
Deployment assistance
Network diagram generation
Troubleshooting assistance
Components
Interactive UI with step-by-step workflow
Template-based configuration
AI analysis and optimization
Configuration validation
Documentation and diagram generation
UI Improvements
Responsive design for various screen sizes
Tabbed interface for easier navigation
Support for light and dark themes
Customizable code display
AI Capabilities
AI Assistant for answering questions
Configuration analysis and scoring
Security evaluation
Optimization recommendations
Documentation assistance
EOF
Create a backup script
print_message "Creating backup script..."

cat > backup.sh << 'EOF'
#!/bin/bash

Backup script for UaXSupreme
Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

Function to display script messages
print_message() {
echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
echo -e "${RED}[ERROR]${NC} $1"
exit 1
}

Create backup directory if it doesn't exist
BACKUP_DIR="backups"
mkdir -p $BACKUP_DIR

Create timestamp for backup file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_FILE="$BACKUP_DIR/uaxsupreme_backup_$TIMESTAMP.tar.gz"

print_message "Creating backup of UaXSupreme data..."

Create tar archive of important files and directories
tar -czf $BACKUP_FILE index.html css js data *.md *.sh

Check if backup was successful
if [ $? -eq 0 ]; then
print_success "Backup created successfully: $BACKUP_FILE"
echo "Backup size: $(du -h $BACKUP_FILE | cut -f1)"
else
print_error "Backup failed"
fi
EOF

chmod +x backup.sh

Create a basic update script for future updates
print_message "Creating update script for future updates..."

cat > update.sh << 'EOF'
#!/bin/bash

Update script for UaXSupreme
Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

Function to display script messages
print_message() {
echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
echo -e "${RED}[ERROR]${NC} $1"
exit 1
}

Check for backup script and run it first
if [ -f "backup.sh" ]; then
print_message "Creating backup before update..."
./backup.sh
else
print_warning "Backup script not found. Continuing without backup."
fi

Check for updates (placeholder for future functionality)
print_message "Checking for updates..."
print_message "This is a placeholder for future update functionality."
print_message "In a real implementation, this would:"
print_message "1. Check for new versions"
print_message "2. Download updates"
print_message "3. Apply updates while preserving user data"

Update placeholder
print_message "No updates available at this time."

print_success "Update check completed."
EOF

chmod +x update.sh

Create a simple example report
print_message "Creating example report..."

cat > data/reports/example_security_report.html << 'EOF'


css

Copy
    h1, h2, h3, h4 {
        color: #2c3e50;
    }

    .report-header {
        text-align: center;
        margin-bottom: 30px;
    }

    .report-header h1 {
        margin-bottom: 5px;
    }

    .report-meta {
        color: #7f8c8d;
        font-style: italic;
        margin-bottom: 20px;
    }

    .report-section {
        margin-bottom: 30px;
    }

    .security-score {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }

    .score-circle {
        width: 100px;
        height: 100px;
        border-radius: 50%;
        background-color: #f5f5f5;
        border: 5px solid #2ecc71;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        margin-right: 20px;
    }

    .score-value {
        font-size: 36px;
        font-weight: bold;
        color: #2c3e50;
    }

    .score-label {
        font-size: 12px;
        color: #7f8c8d;
    }

    .score-details {
        flex: 1;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    table th, table td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: left;
    }

    table th {
        background-color: #f5f5f5;
        font-weight: 600;
    }

    .issue-item {
        margin-bottom: 15px;
        padding: 10px;
        border-radius: 4px;
    }

    .issue-critical {
        background-color: #ffeaea;
        border-left: 4px solid #e74c3c;
    }

    .issue-high {
        background-color: #fff4e5;
        border-left: 4px solid #e67e22;
    }

    .issue-medium {
        background-color: #fff9e5;
        border-left: 4px solid #f39c12;
    }

    .issue-low {
        background-color: #e5f7ff;
        border-left: 4px solid #3498db;
    }

    .issue-title {
        font-weight: 600;
        margin-bottom: 5px;
    }

    .issue-description {
        margin-bottom: 5px;
    }

    .issue-recommendation {
        font-style: italic;
    }

    .recommendation {
        background-color: #e5f7ff;
        padding: 15px;
        border-radius: 4px;
        margin-bottom: 15px;
    }

    .recommendation-title {
        font-weight: 600;
        margin-bottom: 5px;
    }

    .recommendation-details {
        margin-bottom: 10px;
    }

    .strength {
        background-color: #e5ffe7;
        padding: 15px;
        border-radius: 4px;
        margin-bottom: 15px;
    }

    .appendix {
        margin-top: 40px;
        padding-top: 20px;
        border-top: 1px solid #ddd;
    }

    code {
        font-family: Consolas, Monaco, 'Andale Mono', monospace;
        background-color: #f5f5f5;
        padding: 2px 4px;
        border-radius: 3px;
    }

    pre {
        background-color: #f5f5f5;
        padding: 10px;
        border-radius: 4px;
        overflow-x: auto;
    }
</style>
</head>

<body>

<div class="report-header">

<h1>Network Authentication Security Report</h1>

<div class="report-meta">

<p>Generated on: April 15, 2023</p>

<p>Generated by: UaXSupreme AI Analysis</p>

</div>

</div>

angelscript

Copy
<div class="report-section">
    <h2>Executive Summary</h2>
    <p>This report provides an analysis of the network authentication configuration for ABC Company's primary access switches. The overall security score is <strong>85%</strong>, which indicates a generally strong configuration with some areas for improvement.</p>

    <div class="security-score">
        <div class="score-circle">
            <span class="score-value">85</span>
            <span class="score-label">Security Score</span>
        </div>
        <div class="score-details">
            <p>The network authentication implementation shows strong security fundamentals with 802.1X and MAB configurations. Key security features like DHCP Snooping and Dynamic ARP Inspection are implemented, with some opportunities for improvement in high availability and monitoring.</p>
        </div>
    </div>

    <table>
        <tr>
            <th>Category</th>
            <th>Score</th>
            <th>Comments</th>
        </tr>
        <tr>
            <td>Authentication</td>
            <td>90%</td>
            <td>Strong 802.1X implementation with MAB fallback</td>
        </tr>
        <tr>
            <td>Authorization</td>
            <td>85%</td>
            <td>Good VLAN segregation, could use more granular ACLs</td>
        </tr>
        <tr>
            <td>Infrastructure Security</td>
            <td>80%</td>
            <td>Core security features implemented, missing IP Source Guard</td>
        </tr>
        <tr>
            <td>Resilience</td>
            <td>75%</td>
            <td>Some redundancy, but RADIUS server failover could be improved</td>
        </tr>
    </table>
</div>

<div class="report-section">
    <h2>Key Findings</h2>

    <h3>Security Issues</h3>

    <div class="issue-item issue-high">
        <div class="issue-title">RADIUS Server Redundancy Not Optimized</div>
        <div class="issue-description">The configuration includes two RADIUS servers but lacks load balancing and optimized failover settings.</div>
        <div class="issue-recommendation">Recommendation: Implement RADIUS server load balancing and optimize deadtime settings.</div>
    </div>

    <div class="issue-item issue-medium">
        <div class="issue-title">Critical Authentication Not Fully Configured</div>
        <div class="issue-description">Critical authentication for RADIUS server failure is configured but missing voice VLAN parameters.</div>
        <div class="issue-recommendation">Recommendation: Complete critical authentication configuration with voice VLAN support.</div>
    </div>

    <div class="issue-item issue-medium">
        <div class="issue-title">IP Source Guard Not Enabled</div>
        <div class="issue-description">DHCP Snooping is configured but IP Source Guard is not enabled on access interfaces.</div>
        <div class="issue-recommendation">Recommendation: Enable IP Source Guard on access interfaces to prevent IP spoofing.</div>
    </div>

    <div class="issue-item issue-low">
        <div class="issue-title">RADIUS Server Probe Configuration Incomplete</div>
        <div class="issue-description">RADIUS server probes are configured but not optimized for early detection of server failures.</div>
        <div class="issue-recommendation">Recommendation: Adjust RADIUS server probe parameters for earlier failure detection.</div>
    </div>

    <h3>Security Strengths</h3>

    <div class="strength">
        <div class="issue-title">Strong 802.1X Implementation</div>
        <div class="issue-description">The configuration implements 802.1X with appropriate timers, in closed mode, with MAB fallback for non-802.1X devices.</div>
    </div>

    <div class="strength">
        <div class="issue-title">Comprehensive Layer 2 Security</div>
        <div class="issue-description">The configuration includes DHCP Snooping, Dynamic ARP Inspection, and BPDU Guard on all access ports.</div>
    </div>

    <div class="strength">
        <div class="issue-title">Change of Authorization Support</div>
        <div class="issue-description">The configuration supports RADIUS Change of Authorization (CoA), enabling dynamic policy changes.</div>
    </div>
</div>

<div class="report-section">
    <h2>Recommendations</h2>

    <div class="recommendation">
        <div class="recommendation-title">Improve RADIUS Server High Availability</div>
        <div class="recommendation-details">Implement RADIUS server load balancing and optimize timeout and deadtime settings for faster failover.</div>
        <pre>aaa group server radius RAD-SERVERS
server name ISE-1
server name ISE-2
deadtime 15
load-balance method least-outstanding</pre>
</div>

angelscript

Copy
    <div class="recommendation">
        <div class="recommendation-title">Complete Critical Authentication Configuration</div>
        <div class="recommendation-details">Add voice VLAN support to critical authentication for comprehensive failure handling.</div>
        <pre>service-template CRITICAL_VOICE_ACCESS
voice vlan 999
access-group ACL-OPEN</pre>
</div>

angelscript

Copy
    <div class="recommendation">
        <div class="recommendation-title">Enable IP Source Guard</div>
        <div class="recommendation-details">Enable IP Source Guard on all access interfaces to prevent IP spoofing attacks.</div>
        <pre>interface range GigabitEthernet1/0/1-24
ip verify source</pre>
</div>

angelscript

Copy
    <div class="recommendation">
        <div class="recommendation-title">Optimize Authentication Timers</div>
        <div class="recommendation-details">Adjust RADIUS timeouts and 802.1X timers for better performance and faster failover.</div>
        <pre>radius server ISE-1
timeout 2
retransmit 2
radius-server dead-criteria time 5 tries 3</pre>
</div>
</div>

angelscript

Copy
<div class="appendix">
    <h2>Appendix: Analysis Methodology</h2>
    <p>This report was generated using UaXSupreme's AI Analysis feature, which evaluates network authentication configurations against industry best practices and security standards. The analysis includes:</p>

    <ul>
        <li>Authentication method assessment (802.1X, MAB, WebAuth)</li>
        <li>RADIUS server configuration evaluation</li>
        <li>Security feature implementation check</li>
        <li>High availability and resilience analysis</li>
        <li>Configuration syntax and structure validation</li>
    </ul>

    <p>The security score is calculated based on weighted factors including authentication strength, authorization policies, infrastructure security features, and resilience mechanisms.</p>
</div>
</body>

</html>

EOF

Create a sample import.sh script
print_message "Creating import utility script..."

cat > import.sh << 'EOF'
#!/bin/bash

Import script for UaXSupreme - import existing configuration for analysis
Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

Function to display script messages
print_message() {
echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
echo -e "${RED}[ERROR]${NC} $1"
exit 1
}

Check if a file was provided
if [ $# -ne 1 ]; then
print_error "Usage: $0 <config_file>"
fi

CONFIG_FILE=$1

Check if the file exists
if [ ! -f "$CONFIG_FILE" ]; then
print_error "File not found: $CONFIG_FILE"
fi

Create import directory if it doesn't exist
IMPORT_DIR="data/imports"
mkdir -p $IMPORT_DIR

Create timestamp
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

Copy the file to imports directory
cp "$CONFIG_FILE" "$IMPORT_DIR/config_$TIMESTAMP.txt"

print_success "Configuration imported: $CONFIG_FILE"
print_message "To analyze this configuration, open UaXSupreme and load the file from the Generate Configuration section."
print_message "File saved as: $IMPORT_DIR/config_$TIMESTAMP.txt"

Try to detect the device type
if grep -q "aaa new-model" "$CONFIG_FILE"; then
print_message "Detected: Cisco IOS/IOS-XE configuration"
elif grep -q "aaa authentication port-access" "$CONFIG_FILE"; then
print_message "Detected: Aruba/HP configuration"
elif grep -q "system {" "$CONFIG_FILE"; then
print_message "Detected: Juniper configuration"
else
print_warning "Could not automatically detect configuration type"
fi

print_message "Configuration ready for analysis in UaXSupreme!"
EOF

chmod +x import.sh

Create a simple CONTRIBUTING.md file
print_message "Creating contributing guidelines..."

cat > CONTRIBUTING.md << 'EOF'

Contributing to UaXSupreme
Thank you for your interest in contributing to UaXSupreme! This document provides guidelines and instructions for contributing to this project.

Ways to Contribute
There are several ways you can contribute to UaXSupreme:

Bug Fixes: Identify and fix bugs in the existing code
Feature Enhancements: Add new features or enhance existing ones
Documentation: Improve documentation, add examples, or create tutorials
Testing: Test the application and report issues
Security Improvements: Suggest or implement security enhancements
Development Setup
Clone the repository:

basic

Copy
git clone https://github.com/yourusername/uaxsupreme.git
cd uaxsupreme
Make your changes to the code, documentation, or other files

Test your changes by opening index.html in a browser or using the included server:


Copy
./serve.sh
Code Style Guidelines
When contributing code, please follow these guidelines:

Use consistent indentation (2 spaces for JavaScript and HTML)
Follow camelCase naming convention for variables and functions
Use meaningful variable and function names
Comment your code appropriately
Keep functions focused on a single responsibility
Test your changes before submitting
Pull Request Process
Create a new branch for your feature or bugfix:


Copy
git checkout -b feature/your-feature-name
Make your changes and commit them with clear commit messages:


Copy
git commit -m "Add feature: description of the feature"
Push your branch to your fork:


Copy
git push origin feature/your-feature-name
Create a Pull Request against the main repository

In your Pull Request description, explain:

What changes you've made
Why these changes are beneficial
Any related issues these changes address
Adding New Vendor Support
When adding support for a new network vendor:

Create a vendor-specific template in js/template-generator.js
Add vendor detection in js/ai-analyzer.js
Add vendor-specific commands in js/documentation.js
Test thoroughly with example configurations
Update documentation to mention the new vendor support
Bug Reports
When reporting bugs, please include:

A clear description of the bug
Steps to reproduce the issue
Expected behavior
Actual behavior
Browser and version information
Screenshots if applicable
Feature Requests
Feature requests are welcome! Please provide:

A clear description of the proposed feature
Why the feature would be beneficial
Any implementation ideas you have
License
By contributing to UaXSupreme, you agree that your contributions will be licensed under the same license as the project.

Thank you for contributing to UaXSupreme!
EOF

print_success "All enhancement scripts have been completed successfully!"
print_message "Your UaXSupreme application is now ready to use."
print_message "You can start the application by opening index.html in your browser or by running ./serve.sh"
print_message "Additional utilities are available: backup.sh, update.sh, and import.sh"
print_message "Documentation is available in README.md, QUICKSTART.md, and data/tutorials/"
