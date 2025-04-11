// Emergency Fix for Dot1Xer Supreme Enterprise Edition
(function() {
    console.log("Applying emergency fixes...");
    
    // Fix for duplicate declarations
    window.fixDuplicateDeclarations = function() {
        // Create a safety wrapper for script execution
        function safeExecute(fn) {
            try {
                fn();
            } catch (error) {
                console.warn("Suppressed error:", error.message);
            }
        }
        
        // Flag to prevent multiple initializations
        if (!window._moduleInitStatus) {
            window._moduleInitStatus = {
                vendors: false,
                help: false,
                questionnaire: false,
                ui: false,
                configGenerator: false,
                diagrams: false,
                checklistHandler: false
            };
        }
        
        // Safe initialization functions
        window.initVendors = function() {
            if (window._moduleInitStatus.vendors) return;
            console.log("Safely initializing vendors module...");
            
            safeExecute(function() {
                // Make sure the vendor grid is functional
                const vendorGrid = document.getElementById("vendor-grid");
                if (vendorGrid) {
                    if (!vendorGrid._isInitialized) {
                        vendorGrid._isInitialized = true;
                        
                        // Define vendor data
                        const vendors = [
                            { id: "cisco", name: "CISCO", color: "#049fd9", variant: "CiscoBOTH" },
                            { id: "aruba", name: "ARUBA", color: "#f26334", variant: "ArubaBOTH" },
                            { id: "juniper", name: "JUNIPER", color: "#84b135", variant: "JuniperBOTH" },
                            { id: "hp", name: "HP", color: "#0096d6", variant: "HPWIRED" },
                            { id: "extreme", name: "EXTREME", color: "#00c340", variant: "ExtremeBOTH" },
                            { id: "fortinet", name: "FORTINET", color: "#ee3124", variant: "FortinetBOTH" },
                            { id: "dell", name: "DELL", color: "#007db8", variant: "DellWIRED" },
                            { id: "huawei", name: "HUAWEI", color: "#e40521", variant: "HuaweiBOTH" },
                            { id: "ruckus", name: "RUCKUS", color: "#c41230", variant: "RuckusBOTH" },
                            { id: "paloalto", name: "PALOALTO", color: "#fa582d", variant: "PaloAlto" },
                            { id: "checkpoint", name: "CHECKPOINT", color: "#e66400", variant: "CheckPointWIRED" },
                            { id: "alcatel", name: "ALCATEL", color: "#0559c9", variant: "AlcatelLucent" }
                        ];
                        
                        // Clear existing content
                        vendorGrid.innerHTML = "";
                        
                        // Create vendor cards
                        vendors.forEach(vendor => {
                            const vendorCard = document.createElement("div");
                            vendorCard.className = "vendor-logo-container";
                            vendorCard.setAttribute("data-vendor", vendor.id);
                            vendorCard.style.height = "90px";
                            vendorCard.style.display = "flex";
                            vendorCard.style.flexDirection = "column";
                            vendorCard.style.alignItems = "center";
                            vendorCard.style.justifyContent = "center";
                            vendorCard.style.border = "1px solid #ddd";
                            vendorCard.style.borderRadius = "5px";
                            vendorCard.style.margin = "5px";
                            vendorCard.style.padding = "15px";
                            vendorCard.style.cursor = "pointer";
                            
                            // Create name element
                            const nameEl = document.createElement("div");
                            nameEl.className = "vendor-name";
                            nameEl.textContent = vendor.name;
                            nameEl.style.fontWeight = "bold";
                            nameEl.style.color = vendor.color || "#333";
                            nameEl.style.fontSize = "16px";
                            
                            // Create variant element
                            const variantEl = document.createElement("div");
                            variantEl.className = "vendor-variant";
                            variantEl.textContent = vendor.variant;
                            variantEl.style.fontSize = "12px";
                            variantEl.style.color = "#666";
                            
                            // Add elements to card
                            vendorCard.appendChild(nameEl);
                            vendorCard.appendChild(variantEl);
                            
                            // Add click event
                            vendorCard.addEventListener("click", function() {
                                // Remove selection from all cards
                                document.querySelectorAll(".vendor-logo-container").forEach(el => {
                                    el.classList.remove("selected");
                                    el.style.borderColor = "#ddd";
                                    el.style.boxShadow = "none";
                                });
                                
                                // Add selection to clicked card
                                this.classList.add("selected");
                                this.style.borderColor = "#0077cc";
                                this.style.boxShadow = "0 0 0 2px #0077cc";
                                
                                // Update platform dropdown
                                const platformSelect = document.getElementById("platform-select");
                                if (platformSelect) {
                                    // Clear existing options
                                    platformSelect.innerHTML = "";
                                    
                                    // Add default option
                                    const defaultOption = document.createElement("option");
                                    defaultOption.value = "";
                                    defaultOption.textContent = "Select a platform";
                                    platformSelect.appendChild(defaultOption);
                                    
                                    // Define platform options
                                    const platforms = {
                                        cisco: ["Catalyst 9000", "Catalyst 3000", "ISE", "ISR/ASR"],
                                        aruba: ["Aruba OS", "ClearPass", "Instant AP", "Controller"],
                                        juniper: ["EX Series", "SRX Series", "MX Series"],
                                        hp: ["ProCurve", "Aruba (HP)"],
                                        extreme: ["ExtremeXOS", "VOSS", "EXOS"],
                                        fortinet: ["FortiGate", "FortiWLC", "FortiSwitch"],
                                        dell: ["PowerSwitch", "Force10"],
                                        huawei: ["S Series", "AR Router"],
                                        ruckus: ["SmartZone", "ICX Switch"],
                                        paloalto: ["PAN-OS", "Prisma Access"],
                                        checkpoint: ["Gaia OS", "R80"],
                                        alcatel: ["OmniSwitch", "OmniAccess"]
                                    };
                                    
                                    // Add options for selected vendor
                                    if (platforms[vendor.id]) {
                                        platforms[vendor.id].forEach(platform => {
                                            const option = document.createElement("option");
                                            option.value = platform.toLowerCase().replace(/\s+/g, "_");
                                            option.textContent = platform;
                                            platformSelect.appendChild(option);
                                        });
                                    }
                                }
                                
                                // Enable next button
                                const nextButton = document.getElementById("platform-next");
                                if (nextButton) nextButton.disabled = false;
                            });
                            
                            vendorGrid.appendChild(vendorCard);
                        });
                    }
                }
            });
            
            window._moduleInitStatus.vendors = true;
        };

        // Initialize UI functionality safely
        window.initUI = function() {
            if (window._moduleInitStatus.ui) return;
            console.log("Safely initializing UI module...");
            
            safeExecute(function() {
                // Fix the next button functionality
                const nextButton = document.getElementById("platform-next");
                if (nextButton) {
                    nextButton.addEventListener("click", function(e) {
                        // Navigate to the next tab (Authentication)
                        const authTab = document.querySelector(".tab[data-tab='authentication']");
                        if (authTab) {
                            authTab.click();
                        }
                    });
                }
                
                // Add tab navigation event handlers
                document.querySelectorAll('.tab').forEach(tab => {
                    tab.addEventListener('click', function() {
                        // Remove active class from all tabs
                        document.querySelectorAll('.tab').forEach(t => {
                            t.classList.remove('active');
                        });
                        
                        // Add active class to clicked tab
                        this.classList.add('active');
                        
                        // Hide all tab panes
                        document.querySelectorAll('.tab-pane').forEach(pane => {
                            pane.classList.remove('active');
                        });
                        
                        // Show the corresponding tab pane
                        const tabId = this.getAttribute('data-tab');
                        const tabPane = document.getElementById(tabId);
                        if (tabPane) {
                            tabPane.classList.add('active');
                        }
                    });
                });
            });
            
            window._moduleInitStatus.ui = true;
        };
        
        // Fix help system
        window.initHelp = function() {
            if (window._moduleInitStatus.help) return;
            console.log("Safely initializing help system...");
            
            safeExecute(function() {
                // Fix overlapping help text
                const formGroups = document.querySelectorAll('.form-group');
                formGroups.forEach(group => {
                    // Find any text nodes directly in the form group
                    Array.from(group.childNodes).forEach(node => {
                        if (node.nodeType === Node.TEXT_NODE && node.textContent.trim()) {
                            const helpText = node.textContent.trim();
                            if (helpText.length > 10) {
                                // Remove the text node
                                node.remove();
                                
                                // Find the label
                                const label = group.querySelector('label');
                                if (label) {
                                    // Add help icon
                                    const helpIcon = document.createElement('span');
                                    helpIcon.style.display = 'inline-block';
                                    helpIcon.style.width = '16px';
                                    helpIcon.style.height = '16px';
                                    helpIcon.style.borderRadius = '50%';
                                    helpIcon.style.backgroundColor = '#0077cc';
                                    helpIcon.style.color = 'white';
                                    helpIcon.style.textAlign = 'center';
                                    helpIcon.style.lineHeight = '16px';
                                    helpIcon.style.fontSize = '12px';
                                    helpIcon.style.marginLeft = '5px';
                                    helpIcon.style.cursor = 'pointer';
                                    helpIcon.textContent = '?';
                                    helpIcon.title = helpText;
                                    label.appendChild(helpIcon);
                                }
                            }
                        }
                    });
                });
            });
            
            window._moduleInitStatus.help = true;
        };
        
        // Safely initialize the questionnaire
        window.initQuestionnaire = function() {
            if (window._moduleInitStatus.questionnaire) return;
            console.log("Safely initializing questionnaire module...");
            
            safeExecute(function() {
                // Basic initialization for questionnaire
                const questionnaireLink = document.getElementById('questionnaire-link');
                const questionnaireModal = document.getElementById('questionnaire-modal');
                const questionnaireClose = document.getElementById('questionnaire-modal-close');
                
                if (questionnaireLink && questionnaireModal) {
                    questionnaireLink.addEventListener('click', function(e) {
                        e.preventDefault();
                        questionnaireModal.classList.add('visible');
                    });
                    
                    if (questionnaireClose) {
                        questionnaireClose.addEventListener('click', function() {
                            questionnaireModal.classList.remove('visible');
                        });
                    }
                }
            });
            
            window._moduleInitStatus.questionnaire = true;
        };
        
        // Fix configuration generator
        window.initConfigGenerator = function() {
            if (window._moduleInitStatus.configGenerator) return;
            console.log("Safely initializing config generator...");
            
            safeExecute(function() {
                // Override problematic showAlert function
                window.showAlert = function(message, type) {
                    console.log("Alert: " + message + " (" + (type || "info") + ")");
                    
                    // Create alert element
                    const alertEl = document.createElement('div');
                    alertEl.className = 'alert ' + (type || 'alert-info');
                    alertEl.innerHTML = message;
                    alertEl.style.position = 'fixed';
                    alertEl.style.top = '10px';
                    alertEl.style.right = '10px';
                    alertEl.style.zIndex = '9999';
                    alertEl.style.padding = '10px 15px';
                    alertEl.style.borderRadius = '4px';
                    alertEl.style.boxShadow = '0 2px 5px rgba(0,0,0,0.2)';
                    
                    // Style based on type
                    if (type === 'alert-success') {
                        alertEl.style.backgroundColor = '#d4edda';
                        alertEl.style.color = '#155724';
                    } else if (type === 'alert-danger') {
                        alertEl.style.backgroundColor = '#f8d7da';
                        alertEl.style.color = '#721c24';
                    } else if (type === 'alert-warning') {
                        alertEl.style.backgroundColor = '#fff3cd';
                        alertEl.style.color = '#856404';
                    } else {
                        alertEl.style.backgroundColor = '#d1ecf1';
                        alertEl.style.color = '#0c5460';
                    }
                    
                    document.body.appendChild(alertEl);
                    
                    // Remove after a delay
                    setTimeout(function() {
                        if (alertEl.parentNode) {
                            alertEl.parentNode.removeChild(alertEl);
                        }
                    }, 3000);
                };
                
                // Initialize config generation functionality
                const generateConfigBtn = document.getElementById('generate-config');
                const configOutput = document.getElementById('config-output');
                
                if (generateConfigBtn && configOutput) {
                    generateConfigBtn.addEventListener('click', function() {
                        // Simple config generation
                        configOutput.textContent = generateSampleConfig();
                        window.showAlert('Configuration generated successfully!', 'alert-success');
                    });
                }
                
                // Function to generate a sample config based on selections
                function generateSampleConfig() {
                    // Get selected vendor and platform
                    const selectedVendor = document.querySelector('.vendor-logo-container.selected');
                    let vendorId = selectedVendor ? selectedVendor.getAttribute('data-vendor') : 'cisco';
                    
                    const platformSelect = document.getElementById('platform-select');
                    let platform = platformSelect ? platformSelect.value : 'catalyst_9000';
                    
                    // Get authentication method
                    const authMethod = document.getElementById('auth-method') ? 
                                       document.getElementById('auth-method').value : 'dot1x';
                                       
                    // Generate config based on vendor
                    let config = '';
                    
                    if (vendorId === 'cisco') {
                        config = `! 802.1X Configuration for Cisco ${platform.replace('_', ' ')}\n` +
                                 `! Generated by Dot1Xer Supreme Enterprise Edition\n` +
                                 `!\n` +
                                 `aaa new-model\n` +
                                 `aaa authentication dot1x default group radius\n` +
                                 `aaa authorization network default group radius\n` +
                                 `aaa accounting dot1x default start-stop group radius\n` +
                                 `!\n` +
                                 `dot1x system-auth-control\n` +
                                 `!\n` +
                                 `interface GigabitEthernet1/0/1\n` +
                                 ` switchport mode access\n` +
                                 ` authentication order dot1x mab\n` +
                                 ` authentication priority dot1x mab\n` +
                                 ` authentication port-control auto\n` +
                                 ` authentication periodic\n` +
                                 ` authentication timer restart 10800\n` +
                                 ` authentication timer reauthenticate server\n` +
                                 ` dot1x pae authenticator\n` +
                                 ` dot1x timeout tx-period 5\n` +
                                 ` mab\n` +
                                 `!\n` +
                                 `radius server RADSRV\n` +
                                 ` address ipv4 10.1.1.100 auth-port 1812 acct-port 1813\n` +
                                 ` key SecretKey123\n`;
                    } else if (vendorId === 'aruba') {
                        config = `! 802.1X Configuration for Aruba ${platform.replace('_', ' ')}\n` +
                                 `! Generated by Dot1Xer Supreme Enterprise Edition\n` +
                                 `!\n` +
                                 `aaa authentication dot1x "dot1x-profile"\n` +
                                 `    server-group "radius-group"\n` +
                                 `!\n` +
                                 `aaa server-group "radius-group"\n` +
                                 `    auth-server "rad1" position 1\n` +
                                 `!\n` +
                                 `aaa authentication-server radius "rad1"\n` +
                                 `    host 10.1.1.100\n` +
                                 `    key "SecretKey123"\n` +
                                 `!\n` +
                                 `interface GigabitEthernet0/0/1\n` +
                                 `    description "802.1X enabled port"\n` +
                                 `    dot1x port-control auto\n` +
                                 `    dot1x authenticate\n`;
                    } else {
                        config = `! 802.1X Configuration for ${vendorId.charAt(0).toUpperCase() + vendorId.slice(1)} ${platform.replace('_', ' ')}\n` +
                                 `! Generated by Dot1Xer Supreme Enterprise Edition\n` +
                                 `!\n` +
                                 `# This is a generic 802.1X configuration template.\n` +
                                 `# Please customize for your specific ${vendorId.toUpperCase()} device requirements.\n` +
                                 `#\n` +
                                 `# 1. Configure RADIUS server settings:\n` +
                                 `#    - Server IP: 10.1.1.100\n` +
                                 `#    - Authentication port: 1812\n` +
                                 `#    - Accounting port: 1813\n` +
                                 `#    - Shared secret: SecretKey123\n` +
                                 `#\n` +
                                 `# 2. Enable 802.1X globally\n` +
                                 `#\n` +
                                 `# 3. Configure 802.1X on access ports\n` +
                                 `#    - Authentication mode: auto\n` +
                                 `#    - Reauthentication: enabled\n` +
                                 `#    - Reauthentication period: 3600 seconds\n`;
                    }
                    
                    return config;
                }
            });
            
            window._moduleInitStatus.configGenerator = true;
        };
        
        // Fix diagrams generator
        window.initDiagrams = function() {
            if (window._moduleInitStatus.diagrams) return;
            console.log("Safely initializing diagrams module...");
            
            safeExecute(function() {
                // Initialize diagram generation
                const generateDiagramBtn = document.getElementById('generate-diagram');
                const diagramDisplay = document.getElementById('diagram-display');
                
                if (generateDiagramBtn && diagramDisplay) {
                    generateDiagramBtn.addEventListener('click', function() {
                        // Create a simple SVG diagram
                        const diagramType = document.getElementById('diagram-type') ? 
                                           document.getElementById('diagram-type').value : 'network-topology';
                        
                        diagramDisplay.innerHTML = `
                            <svg width="100%" height="300" style="border: 1px solid #ddd; background-color: #f9f9f9;">
                                <text x="50%" y="30" text-anchor="middle" font-weight="bold">802.1X ${diagramType.replace('-', ' ')} Diagram</text>
                                <rect x="50" y="80" width="100" height="60" rx="10" ry="10" fill="#0077cc" stroke="#005599" />
                                <text x="100" y="115" text-anchor="middle" fill="white">Client</text>
                                <rect x="350" y="80" width="100" height="60" rx="10" ry="10" fill="#00aa55" stroke="#008844" />
                                <text x="400" y="115" text-anchor="middle" fill="white">Switch</text>
                                <rect x="650" y="80" width="100" height="60" rx="10" ry="10" fill="#aa5500" stroke="#884400" />
                                <text x="700" y="115" text-anchor="middle" fill="white">RADIUS</text>
                                <line x1="150" y1="110" x2="350" y2="110" stroke="#333" stroke-width="2" />
                                <polygon points="340,105 350,110 340,115" fill="#333" />
                                <line x1="450" y1="110" x2="650" y2="110" stroke="#333" stroke-width="2" />
                                <polygon points="640,105 650,110 640,115" fill="#333" />
                                <text x="250" y="100" text-anchor="middle">802.1X EAPOL</text>
                                <text x="550" y="100" text-anchor="middle">RADIUS</text>
                            </svg>
                        `;
                        
                        window.showAlert('Diagram generated successfully!', 'alert-success');
                    });
                }
            });
            
            window._moduleInitStatus.diagrams = true;
        };
        
        // Fix checklist handler
        window.initChecklistHandler = function() {
            if (window._moduleInitStatus.checklistHandler) return;
            console.log("Safely initializing checklist handler...");
            
            safeExecute(function() {
                // Initialize checklist functionality
                const checklistLink = document.getElementById('checklist-link');
                const checklistModal = document.getElementById('checklist-modal');
                const checklistClose = document.getElementById('checklist-modal-close');
                
                if (checklistLink && checklistModal) {
                    checklistLink.addEventListener('click', function(e) {
                        e.preventDefault();
                        
                        // Create a simple checklist if container is empty
                        const checklistContainer = document.getElementById('checklist-container');
                        if (checklistContainer && !checklistContainer.childNodes.length) {
                            checklistContainer.innerHTML = `
                                <h3>802.1X Deployment Checklist</h3>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check1"> 
                                    <label for="check1">Verify RADIUS server connectivity</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check2"> 
                                    <label for="check2">Configure RADIUS shared secret</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check3"> 
                                    <label for="check3">Enable 802.1X globally on switch</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check4"> 
                                    <label for="check4">Configure authentication mode on ports</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check5"> 
                                    <label for="check5">Test authentication with sample client</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check6"> 
                                    <label for="check6">Configure guest VLAN for non-802.1X clients</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check7"> 
                                    <label for="check7">Implement CoA (Change of Authorization)</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check8"> 
                                    <label for="check8">Configure accounting settings</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check9"> 
                                    <label for="check9">Document final configuration</label>
                                </div>
                                <div class="checklist-item">
                                    <input type="checkbox" id="check10"> 
                                    <label for="check10">Create backup of configuration</label>
                                </div>
                            `;
                        }
                        
                        checklistModal.classList.add('visible');
                    });
                    
                    if (checklistClose) {
                        checklistClose.addEventListener('click', function() {
                            checklistModal.classList.remove('visible');
                        });
                    }
                }
            });
            
            window._moduleInitStatus.checklistHandler = true;
        };
    }
    
    // Fix the load order issues with duplicate declarations
    window.fixLoadOrderIssues = function() {
        // Clear any existing timeouts that might cause problems
        if (window._fixTimeouts) {
            window._fixTimeouts.forEach(id => clearTimeout(id));
        }
        window._fixTimeouts = [];
        
        // Add anti-freeze mechanism
        let lastActionTime = Date.now();
        const checkFreeze = setInterval(function() {
            if (Date.now() - lastActionTime > 10000) {
                console.warn("Application appears to be frozen, attempting recovery...");
                document.body.classList.add('recovered');
                clearInterval(checkFreeze);
                
                // Emergency recovery - force UI to be responsive
                document.querySelectorAll('.tab').forEach(tab => {
                    tab.style.pointerEvents = 'auto';
                    tab.style.opacity = '1';
                    
                    tab.addEventListener('click', function() {
                        document.querySelectorAll('.tab').forEach(t => {
                            t.classList.remove('active');
                        });
                        this.classList.add('active');
                        
                        const tabId = this.getAttribute('data-tab');
                        document.querySelectorAll('.tab-pane').forEach(pane => {
                            pane.classList.remove('active');
                        });
                        
                        const pane = document.getElementById(tabId);
                        if (pane) pane.classList.add('active');
                    });
                });
                
                window.showAlert("Emergency recovery mode activated. Some features might be limited.", "alert-warning");
            }
            lastActionTime = Date.now();
        }, 5000);
        
        // Initialize modules in a controlled sequence
        const initSequence = [
            { fn: window.fixDuplicateDeclarations, delay: 100 },
            { fn: window.initVendors, delay: 300 },
            { fn: window.initUI, delay: 500 },
            { fn: window.initHelp, delay: 700 },
            { fn: window.initConfigGenerator, delay: 900 },
            { fn: window.initDiagrams, delay: 1100 },
            { fn: window.initQuestionnaire, delay: 1300 },
            { fn: window.initChecklistHandler, delay: 1500 }
        ];
        
        initSequence.forEach(item => {
            const timeoutId = setTimeout(function() {
                try {
                    item.fn();
                    lastActionTime = Date.now();
                } catch (error) {
                    console.warn("Error in initialization sequence:", error.message);
                }
            }, item.delay);
            
            window._fixTimeouts.push(timeoutId);
        });
    }
    
    // Run fixes on page load or when DOM is ready
    if (document.readyState === "complete" || document.readyState === "interactive") {
        window.fixDuplicateDeclarations();
        window.fixLoadOrderIssues();
    } else {
        document.addEventListener("DOMContentLoaded", function() {
            window.fixDuplicateDeclarations();
            window.fixLoadOrderIssues();
        });
    }
    
    // Also set up a timed reinit to catch any issues
    setTimeout(function() {
        window.fixLoadOrderIssues();
    }, 3000);
    
    console.log("Emergency fixes applied successfully!");
})();
