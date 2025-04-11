// Dot1Xer Supreme Enterprise Edition - Vendor Grid Fix
(function() {
    console.log("Applying vendor selection system fixes...");
    
    // Fix for recursive showAlert function
    if (window.showAlert) {
        var originalShowAlert = window.showAlert;
        window.showAlert = function(message, type) {
            // Simple replacement to prevent stack overflow
            console.log("[Alert] " + message);
            var alertDiv = document.createElement("div");
            alertDiv.className = "alert " + (type || "alert-info");
            alertDiv.innerHTML = message;
            alertDiv.style.position = "fixed";
            alertDiv.style.top = "10px";
            alertDiv.style.right = "10px";
            alertDiv.style.zIndex = "9999";
            alertDiv.style.padding = "15px";
            alertDiv.style.borderRadius = "5px";
            alertDiv.style.boxShadow = "0 2px 5px rgba(0,0,0,0.2)";
            
            // Style based on alert type
            if (type === "alert-success") alertDiv.style.backgroundColor = "#d4edda";
            else if (type === "alert-danger") alertDiv.style.backgroundColor = "#f8d7da";
            else if (type === "alert-warning") alertDiv.style.backgroundColor = "#fff3cd";
            else alertDiv.style.backgroundColor = "#d1ecf1";
            
            document.body.appendChild(alertDiv);
            setTimeout(function() {
                alertDiv.remove();
            }, 3000);
        };
    }
    
    // Rebuild the vendor grid completely
    function rebuildVendorGrid() {
        const vendorGrid = document.getElementById("vendor-grid");
        if (!vendorGrid) {
            console.error("Vendor grid element not found");
            return;
        }
        
        // Clear existing content
        vendorGrid.innerHTML = "";
        
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
            { id: "alcatel", name: "ALCATEL", color: "#0559c9", variant: "AlcatelLucent" },
            { id: "meraki", name: "MERAKI", color: "#78be20", variant: "MerakiBOTH" },
            { id: "arista", name: "ARISTA", color: "#0077cc", variant: "AristaWIRED" },
            { id: "ubiquiti", name: "UBIQUITI", color: "#0559c9", variant: "UbiquitiBOTH" },
            { id: "brocade", name: "BROCADE", color: "#e40521", variant: "BrocadeWIRED" },
            { id: "allied", name: "ALLIED", color: "#0077cc", variant: "AlliedTelesis" },
            { id: "enterasys", name: "ENTERASYS", color: "#e66400", variant: "EnterasysWIRED" },
            { id: "avaya", name: "AVAYA", color: "#cc0000", variant: "AvayaVOIP" },
            { id: "cambium", name: "CAMBIUM", color: "#00aa55", variant: "CambiumWIRED" },
            { id: "sonicwall", name: "SONICWALL", color: "#0066cc", variant: "SonicwallFW" },
            { id: "watchguard", name: "WATCHGUARD", color: "#cc0000", variant: "WatchGuardWIRED" },
            { id: "sophos", name: "SOPHOS", color: "#0077cc", variant: "SophosVPN" },
            { id: "netgear", name: "NETGEAR", color: "#0077cc", variant: "NetgearBOTH" }
        ];
        
        // Create vendor cards
        vendors.forEach(vendor => {
            const vendorCard = document.createElement("div");
            vendorCard.className = "vendor-logo-container";
            vendorCard.setAttribute("data-vendor", vendor.id);
            
            // Create name element
            const nameEl = document.createElement("div");
            nameEl.className = "vendor-name";
            nameEl.textContent = vendor.name;
            nameEl.style.color = vendor.color || "#333";
            
            // Create variant element
            const variantEl = document.createElement("div");
            variantEl.className = "vendor-variant";
            variantEl.textContent = vendor.variant;
            
            // Add elements to card
            vendorCard.appendChild(nameEl);
            vendorCard.appendChild(variantEl);
            
            // Add click event
            vendorCard.addEventListener("click", function() {
                // Remove selection from all cards
                document.querySelectorAll(".vendor-logo-container").forEach(el => {
                    el.classList.remove("selected");
                });
                
                // Add selection to clicked card
                this.classList.add("selected");
                
                // Update platform dropdown
                updatePlatformDropdown(vendor.id);
                
                // Store selection
                sessionStorage.setItem("selectedVendor", vendor.id);
                console.log("Selected vendor: " + vendor.id);
            });
            
            vendorGrid.appendChild(vendorCard);
        });
    }
    
    // Update platform dropdown based on selected vendor
    function updatePlatformDropdown(vendorId) {
        const platformSelect = document.getElementById("platform-select");
        if (!platformSelect) return;
        
        // Clear existing options
        platformSelect.innerHTML = "";
        
        // Add default option
        const defaultOption = document.createElement("option");
        defaultOption.value = "";
        defaultOption.textContent = "Select a platform";
        platformSelect.appendChild(defaultOption);
        
        // Define platform options for each vendor
        const platformOptions = {
            cisco: ["Catalyst 9000", "Catalyst 3000", "ISE", "ISR/ASR", "Catalyst 2900", "Catalyst 9800 WLC"],
            aruba: ["Aruba OS", "ClearPass", "Instant AP", "Controller", "Aruba Central"],
            juniper: ["EX Series", "SRX Series", "MX Series", "QFX Series"],
            hp: ["ProCurve", "Aruba (HP)", "HP 5400 Series"],
            extreme: ["ExtremeXOS", "VOSS", "EXOS", "Network OS"],
            fortinet: ["FortiGate", "FortiWLC", "FortiSwitch", "FortiNAC"],
            dell: ["PowerSwitch", "Force10", "Dell EMC"],
            huawei: ["S Series", "AR Router", "CloudEngine"],
            ruckus: ["SmartZone", "ICX Switch", "ZoneDirector"],
            paloalto: ["PAN-OS", "Prisma Access"],
            checkpoint: ["Gaia OS", "R80"],
            alcatel: ["OmniSwitch", "OmniAccess"],
            meraki: ["MS Switch", "MR Access Point", "MX Security Appliance"],
            arista: ["EOS", "CloudVision"],
            ubiquiti: ["UniFi", "EdgeOS", "AirOS"],
            brocade: ["ICX", "VDX", "MLX"],
            allied: ["AT-8000", "AT-9000", "x930 Series"],
            enterasys: ["K-Series", "S-Series", "C-Series"],
            avaya: ["ERS 4000", "VSP 7000", "VSP 8000"],
            cambium: ["cnMatrix", "cnPilot", "cnMaestro"],
            sonicwall: ["TZ Series", "NSA Series", "SuperMassive"],
            watchguard: ["Firebox", "XTM", "T Series"],
            sophos: ["XG Firewall", "SG UTM", "Access Points"],
            netgear: ["ProSAFE", "Smart Managed Pro", "Insight Managed"]
        };
        
        // Add options for selected vendor
        if (platformOptions[vendorId]) {
            platformOptions[vendorId].forEach(platform => {
                const option = document.createElement("option");
                option.value = platform.toLowerCase().replace(/\s+/g, "_");
                option.textContent = platform;
                platformSelect.appendChild(option);
            });
        }
        
        // Enable the next button
        const nextButton = document.getElementById("platform-next");
        if (nextButton) {
            nextButton.disabled = false;
        }
    }
    
    // Fix next button functionality
    function fixNextButton() {
        const nextButton = document.getElementById("platform-next");
        if (!nextButton) return;
        
        // Remove existing event listeners by cloning and replacing
        const newButton = nextButton.cloneNode(true);
        nextButton.parentNode.replaceChild(newButton, nextButton);
        
        newButton.addEventListener("click", function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            // Validate selections
            const selectedVendor = document.querySelector(".vendor-logo-container.selected");
            const platformSelect = document.getElementById("platform-select");
            const softwareVersion = document.getElementById("software-version");
            
            if (!selectedVendor) {
                window.showAlert("Please select a vendor.", "alert-warning");
                return false;
            }
            
            if (platformSelect && !platformSelect.value) {
                window.showAlert("Please select a platform.", "alert-warning");
                return false;
            }
            
            // Store selections
            if (platformSelect) {
                sessionStorage.setItem("selectedPlatform", platformSelect.value);
            }
            if (softwareVersion) {
                sessionStorage.setItem("softwareVersion", softwareVersion.value);
            }
            
            // Navigate to next tab
            const authTab = document.querySelector(".tab[data-tab='authentication']");
            if (authTab) {
                authTab.click();
                console.log("Navigation to Authentication tab");
                return true;
            }
            
            return false;
        });
    }
    
    // Restore previously selected values
    function restorePreviousSelections() {
        const savedVendor = sessionStorage.getItem("selectedVendor");
        if (savedVendor) {
            const vendorElement = document.querySelector(`.vendor-logo-container[data-vendor="${savedVendor}"]`);
            if (vendorElement) {
                vendorElement.click();
                
                // Also restore platform selection
                const savedPlatform = sessionStorage.getItem("selectedPlatform");
                const platformSelect = document.getElementById("platform-select");
                if (savedPlatform && platformSelect) {
                    platformSelect.value = savedPlatform;
                }
                
                // And restore software version
                const savedVersion = sessionStorage.getItem("softwareVersion");
                const versionInput = document.getElementById("software-version");
                if (savedVersion && versionInput) {
                    versionInput.value = savedVersion;
                }
            }
        }
    }
    
    // Initialize all fixes
    function init() {
        // Wait a bit for the page to fully load
        setTimeout(function() {
            rebuildVendorGrid();
            fixNextButton();
            restorePreviousSelections();
            console.log("Vendor selection system fixes applied successfully");
        }, 500);
    }
    
    // Run on document ready
    if (document.readyState === "complete" || document.readyState === "interactive") {
        init();
    } else {
        document.addEventListener("DOMContentLoaded", init);
    }
})();
