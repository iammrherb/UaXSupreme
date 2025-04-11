/**
 * Targeted Vendor Grid Fix for Dot1Xer Supreme
 * This script focuses solely on fixing the vendor grid
 */
(function() {
    function fixVendorGrid() {
        console.log("Applying targeted vendor grid fix...");

        // Find the vendor grid
        let vendorGrid = document.getElementById('vendor-grid');
        if (!vendorGrid) {
            console.log("Vendor grid not found, creating it...");
            
            // Find the appropriate panel for vendor selection
            const vendorPanel = document.querySelector('.panel:has(h3:contains("Vendor Selection"))');
            if (vendorPanel) {
                // Create vendor grid
                vendorGrid = document.createElement('div');
                vendorGrid.id = 'vendor-grid';
                vendorGrid.className = 'vendor-grid';
                
                // Append after the h3
                const heading = vendorPanel.querySelector('h3');
                if (heading) {
                    heading.insertAdjacentElement('afterend', vendorGrid);
                } else {
                    vendorPanel.appendChild(vendorGrid);
                }
            } else {
                // If we can't find the panel, try to create it in the platform tab
                const platformTab = document.getElementById('platform');
                if (platformTab) {
                    const panel = document.createElement('div');
                    panel.className = 'panel';
                    panel.innerHTML = '<h3>Vendor Selection</h3>';
                    
                    vendorGrid = document.createElement('div');
                    vendorGrid.id = 'vendor-grid';
                    vendorGrid.className = 'vendor-grid';
                    
                    panel.appendChild(vendorGrid);
                    
                    // Insert the panel at the top of the platform tab
                    platformTab.insertBefore(panel, platformTab.firstChild);
                } else {
                    console.error("Cannot find place to create vendor grid!");
                    return;
                }
            }
        }

        // Clear the vendor grid
        vendorGrid.innerHTML = '';
        
        // Define CSS for vendor grid
        const style = document.createElement('style');
        style.textContent = `
            #vendor-grid {
                display: grid !important;
                grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)) !important;
                gap: 15px !important;
                margin-bottom: 20px !important;
            }
            
            .vendor-logo-container {
                position: relative !important;
                height: 100px !important;
                display: flex !important;
                flex-direction: column !important;
                align-items: center !important;
                justify-content: center !important;
                border: 1px solid #ddd !important;
                border-radius: 5px !important;
                padding: 15px !important;
                transition: all 0.2s ease !important;
                cursor: pointer !important;
                background-color: #fff !important;
            }
            
            .vendor-logo-container:hover {
                border-color: #0077cc !important;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1) !important;
            }
            
            .vendor-logo-container.selected {
                border-color: #0077cc !important;
                box-shadow: 0 0 0 2px #0077cc !important;
            }
            
            .vendor-name {
                font-weight: bold !important;
                font-size: 16px !important;
                margin-top: 5px !important;
                text-align: center !important;
            }
            
            .vendor-variant {
                font-size: 12px !important;
                color: #666 !important;
                text-align: center !important;
            }
        `;
        document.head.appendChild(style);

        // Define vendors
        const vendors = [
            { id: 'cisco', name: 'CISCO', color: '#049fd9', variant: 'CiscoBOTH' },
            { id: 'aruba', name: 'ARUBA', color: '#f26334', variant: 'ArubaBOTH' },
            { id: 'juniper', name: 'JUNIPER', color: '#84b135', variant: 'JuniperBOTH' },
            { id: 'hp', name: 'HP', color: '#0096d6', variant: 'HPWIRED' },
            { id: 'extreme', name: 'EXTREME', color: '#00c340', variant: 'ExtremeBOTH' },
            { id: 'fortinet', name: 'FORTINET', color: '#ee3124', variant: 'FortinetBOTH' },
            { id: 'dell', name: 'DELL', color: '#007db8', variant: 'DellWIRED' },
            { id: 'huawei', name: 'HUAWEI', color: '#e40521', variant: 'HuaweiBOTH' },
            { id: 'ruckus', name: 'RUCKUS', color: '#c41230', variant: 'RuckusBOTH' },
            { id: 'paloalto', name: 'PALOALTO', color: '#fa582d', variant: 'PaloAlto' },
            { id: 'checkpoint', name: 'CHECKPOINT', color: '#e66400', variant: 'CheckPointWIRED' },
            { id: 'alcatel', name: 'ALCATEL', color: '#0559c9', variant: 'AlcatelLucent' }
        ];

        // Create vendor cards
        vendors.forEach(vendor => {
            const card = document.createElement('div');
            card.className = 'vendor-logo-container';
            card.setAttribute('data-vendor', vendor.id);
            
            const nameEl = document.createElement('div');
            nameEl.className = 'vendor-name';
            nameEl.textContent = vendor.name;
            nameEl.style.color = vendor.color;
            
            const variantEl = document.createElement('div');
            variantEl.className = 'vendor-variant';
            variantEl.textContent = vendor.variant;
            
            card.appendChild(nameEl);
            card.appendChild(variantEl);
            
            // Click event
            card.addEventListener('click', function() {
                // Remove selection from all cards
                document.querySelectorAll('.vendor-logo-container').forEach(c => {
                    c.classList.remove('selected');
                    c.style.borderColor = '#ddd';
                    c.style.boxShadow = 'none';
                });
                
                // Add selection to this card
                this.classList.add('selected');
                this.style.borderColor = '#0077cc';
                this.style.boxShadow = '0 0 0 2px #0077cc';
                
                // Update platform dropdown
                updatePlatformOptions(vendor.id);
            });
            
            vendorGrid.appendChild(card);
        });
        
        // Update platform dropdown based on vendor selection
        function updatePlatformOptions(vendorId) {
            const platformSelect = document.getElementById('platform-select');
            if (!platformSelect) return;
            
            // Clear existing options
            platformSelect.innerHTML = '';
            
            // Add default option
            const defaultOption = document.createElement('option');
            defaultOption.value = '';
            defaultOption.textContent = 'Select a platform';
            platformSelect.appendChild(defaultOption);
            
            // Define platforms for each vendor
            const platforms = {
                cisco: ['Catalyst 9000', 'Catalyst 3000', 'ISE', 'ISR/ASR', 'Catalyst 2900'],
                aruba: ['Aruba OS', 'ClearPass', 'Instant AP', 'Controller'],
                juniper: ['EX Series', 'SRX Series', 'MX Series', 'QFX Series'],
                hp: ['ProCurve', 'Aruba (HP)', 'HP 5400 Series'],
                extreme: ['ExtremeXOS', 'VOSS', 'EXOS'],
                fortinet: ['FortiGate', 'FortiWLC', 'FortiSwitch'],
                dell: ['PowerSwitch', 'Force10'],
                huawei: ['S Series', 'AR Router', 'CloudEngine'],
                ruckus: ['SmartZone', 'ICX Switch'],
                paloalto: ['PAN-OS', 'Prisma Access'],
                checkpoint: ['Gaia OS', 'R80'],
                alcatel: ['OmniSwitch', 'OmniAccess']
            };
            
            // Add platforms for the selected vendor
            if (platforms[vendorId]) {
                platforms[vendorId].forEach(platform => {
                    const option = document.createElement('option');
                    option.value = platform.toLowerCase().replace(/\s+/g, '_');
                    option.textContent = platform;
                    platformSelect.appendChild(option);
                });
            }
            
            // Enable next button
            const nextButton = document.getElementById('platform-next');
            if (nextButton) nextButton.disabled = false;
        }
        
        // Fix next button
        const nextButton = document.getElementById('platform-next');
        if (nextButton) {
            nextButton.addEventListener('click', function() {
                const authTab = document.querySelector('.tab[data-tab="authentication"]');
                if (authTab) authTab.click();
            });
        }

        console.log("Vendor grid fix applied successfully!");
        
        // Select Cisco by default
        const ciscoCard = document.querySelector('.vendor-logo-container[data-vendor="cisco"]');
        if (ciscoCard) {
            setTimeout(() => {
                ciscoCard.click();
            }, 500);
        }
    }

    // Try to fix vendor grid when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', fixVendorGrid);
    } else {
        fixVendorGrid();
    }
    
    // Also try again after a delay to catch late initialization
    setTimeout(fixVendorGrid, 1000);
})();
