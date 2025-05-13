#!/bin/bash

# Dot1Xer UI Enhancement Fix Script
# This script fixes issues with the initial setup and applies minimal UI enhancements

# Set colors for terminal output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Applying fixes to Dot1Xer UI Enhancement...${NC}"

# Step 1: Clean up problematic files
echo -e "Cleaning up problematic files..."
rm -f setup-dot1xer-ui.sh
rm -f integrate-ui.js

# Step 2: Create necessary directories
echo -e "Creating directories..."
mkdir -p css/enhanced js/enhanced

# Step 3: Create simplified CSS file
echo -e "Creating enhanced CSS..."
cat > css/enhanced/dot1xer-ui.css << 'ENDCSS'
/* Dot1Xer Enhanced UI - Resource-friendly version */
:root {
  --primary: #1e40af;
  --primary-light: #3b82f6;
  --secondary: #10b981;
  --accent: #8b5cf6;
  --background: #f9fafb;
  --surface: white;
  --text: #1f2937;
  --text-light: #6b7280;
  --border: #e5e7eb;
  --border-active: #3b82f6;
  --shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  --radius: 8px;
}

/* Global enhancements */
body {
  background-color: var(--background);
  color: var(--text);
}

/* Card enhancements */
.card, .panel {
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  background-color: var(--surface);
  margin-bottom: 20px;
  overflow: hidden;
  border: 1px solid var(--border);
  transition: box-shadow 0.2s;
}

.card:hover, .panel:hover {
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.card-header, .panel h3 {
  padding: 15px 20px;
  border-bottom: 1px solid var(--border);
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: #f9fafb;
}

.card-title {
  font-weight: 600;
  font-size: 18px;
  margin: 0;
}

.card-body {
  padding: 20px;
}

/* Button enhancements */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 16px;
  border-radius: 4px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.btn.primary {
  background-color: var(--primary);
  color: white;
  border: none;
}

.btn.primary:hover {
  background-color: var(--primary-light);
}

/* Vendor grid enhancements */
.vendor-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 15px;
}

.vendor-logo-container {
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 15px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: all 0.3s;
  position: relative;
}

.vendor-logo-container:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  border-color: var(--primary-light);
}

.vendor-logo-container.selected {
  border-color: var(--primary);
  background-color: rgba(59, 130, 246, 0.05);
  box-shadow: 0 0 0 2px var(--border-active);
}

.vendor-logo {
  max-width: 100%;
  max-height: 40px;
  margin-bottom: 10px;
}

.vendor-name {
  font-weight: 600;
  font-size: 14px;
  text-align: center;
}

.vendor-type {
  position: absolute;
  top: 5px;
  right: 5px;
  font-size: 10px;
  padding: 2px 6px;
  border-radius: 9999px;
  background-color: #f3f4f6;
}

.vendor-type.both {
  background-color: #dbeafe;
  color: #1e40af;
}

.vendor-type.wired {
  background-color: #d1fae5;
  color: #065f46;
}

.vendor-type.wireless {
  background-color: #fef3c7;
  color: #92400e;
}

/* Form enhancements */
.form-group {
  margin-bottom: 20px;
}

.form-control {
  width: 100%;
  padding: 8px 12px;
  border: 1px solid var(--border);
  border-radius: 4px;
  font-size: 14px;
  transition: border-color 0.2s;
}

.form-control:focus {
  outline: none;
  border-color: var(--primary-light);
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.2);
}

/* Tab enhancements */
.tab {
  padding: 10px 16px;
  cursor: pointer;
  border-bottom: 2px solid transparent;
  transition: all 0.2s;
}

.tab:hover {
  color: var(--primary);
}

.tab.active {
  color: var(--primary);
  border-bottom-color: var(--primary);
  font-weight: 500;
}

/* Platform details enhancements */
#platform-details {
  background-color: var(--background);
  border: 1px solid var(--border);
  border-radius: var(--radius);
  padding: 20px;
  margin-top: 20px;
  transition: all 0.3s ease;
}

.platform-details-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 15px;
}

.capability-badges {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-top: 10px;
}

.capability-badge {
  font-size: 12px;
  padding: 4px 10px;
  background-color: #f3f4f6;
  border-radius: 9999px;
  font-weight: 500;
}
ENDCSS

# Step 4: Create simplified JS file
echo -e "Creating enhanced JS..."
cat > js/enhanced/dot1xer-ui.js << 'ENDJS'
/**
 * Dot1Xer UI Enhancement - Resource-friendly version
 */
document.addEventListener('DOMContentLoaded', function() {
  console.log('Dot1Xer UI Enhancement loaded');
  
  // Enhance elements
  enhanceVendorSelection();
  enhancePlatformDetails();
  enhanceButtons();
  enhanceTabs();
  
  // Add animation classes
  document.querySelectorAll('.card, .panel').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(10px)';
    
    setTimeout(() => {
      el.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
      el.style.opacity = '1';
      el.style.transform = 'translateY(0)';
    }, 100);
  });
});

// Enhance vendor selection
function enhanceVendorSelection() {
  // Add vendor types if they don't exist
  document.querySelectorAll('.vendor-logo-container').forEach(container => {
    const vendorName = container.getAttribute('data-vendor') || 
                       container.querySelector('.vendor-name')?.textContent || '';
    
    // Add vendor type if it doesn't exist
    if (!container.querySelector('.vendor-type')) {
      const typeSpan = document.createElement('div');
      typeSpan.className = 'vendor-type';
      
      // Default to "both" but try to determine from image or attributes
      let type = 'both';
      if (vendorName.toLowerCase().includes('switch') || 
          vendorName.toLowerCase().includes('router')) {
        type = 'wired';
      } else if (vendorName.toLowerCase().includes('wireless') || 
                vendorName.toLowerCase().includes('wifi')) {
        type = 'wireless';
      }
      
      typeSpan.textContent = type.toUpperCase();
      typeSpan.classList.add(type.toLowerCase());
      container.appendChild(typeSpan);
    }
    
    // Add click animation
    container.addEventListener('click', function() {
      this.style.transform = 'scale(0.98)';
      setTimeout(() => {
        this.style.transform = '';
      }, 100);
    });
  });
}

// Enhance platform details
function enhancePlatformDetails() {
  const platformDetails = document.getElementById('platform-details');
  if (!platformDetails) return;
  
  // Add transition for smooth updates
  platformDetails.style.transition = 'all 0.3s ease';
  
  // Add animation on platform selection change
  const platformSelect = document.getElementById('platform-select');
  if (platformSelect) {
    platformSelect.addEventListener('change', function() {
      if (platformDetails) {
        platformDetails.style.opacity = '0';
        platformDetails.style.transform = 'translateY(10px)';
        
        setTimeout(() => {
          platformDetails.style.opacity = '1';
          platformDetails.style.transform = 'translateY(0)';
        }, 300);
      }
    });
  }
}

// Enhance buttons
function enhanceButtons() {
  document.querySelectorAll('.btn').forEach(btn => {
    // Add ripple effect on click
    btn.addEventListener('click', function(e) {
      // Only add effect if not disabled
      if (!this.hasAttribute('disabled')) {
        const rect = this.getBoundingClientRect();
        const x = e.clientX - rect.left;
        const y = e.clientY - rect.top;
        
        // Create ripple element
        const ripple = document.createElement('span');
        ripple.style.position = 'absolute';
        ripple.style.width = '1px';
        ripple.style.height = '1px';
        ripple.style.backgroundColor = 'rgba(255, 255, 255, 0.6)';
        ripple.style.borderRadius = '50%';
        ripple.style.transform = 'scale(0)';
        ripple.style.left = x + 'px';
        ripple.style.top = y + 'px';
        ripple.style.pointerEvents = 'none';
        
        // Add to button
        this.style.position = 'relative';
        this.style.overflow = 'hidden';
        this.appendChild(ripple);
        
        // Animate ripple
        requestAnimationFrame(() => {
          ripple.style.transition = 'transform 0.5s ease-out';
          ripple.style.transform = 'scale(100)';
          setTimeout(() => {
            ripple.style.opacity = '0';
            setTimeout(() => {
              this.removeChild(ripple);
            }, 300);
          }, 300);
        });
      }
    });
  });
}

// Enhance tabs
function enhanceTabs() {
  document.querySelectorAll('.tab').forEach(tab => {
    tab.addEventListener('click', function() {
      // Add click indicator
      const indicator = document.createElement('span');
      indicator.style.position = 'absolute';
      indicator.style.bottom = '0';
      indicator.style.left = '0';
      indicator.style.width = '100%';
      indicator.style.height = '2px';
      indicator.style.backgroundColor = 'var(--primary)';
      indicator.style.transform = 'scaleX(0)';
      indicator.style.transition = 'transform 0.2s ease-out';
      indicator.style.transformOrigin = 'center';
      
      // Position tab for indicator
      if (getComputedStyle(this).position === 'static') {
        this.style.position = 'relative';
      }
      
      this.appendChild(indicator);
      
      // Animate indicator
      requestAnimationFrame(() => {
        indicator.style.transform = 'scaleX(1)';
        setTimeout(() => {
          this.removeChild(indicator);
        }, 300);
      });
    });
  });
}
ENDJS

# Step 5: Try to update index.html
echo -e "Updating index.html..."

# Backup original file
cp index.html index.html.backup.$(date +%Y%m%d%H%M%S)

# Add CSS reference
if grep -q "</head>" index.html; then
  sed -i '/<\/head>/i \    <!-- Enhanced UI styles -->\n    <link rel="stylesheet" href="css/enhanced/dot1xer-ui.css">' index.html
  echo -e "${GREEN}Added CSS reference to head${NC}"
else
  # Try alternative approach - look for first style tag
  if grep -q "<link.*stylesheet" index.html; then
    sed -i '/<link.*stylesheet/a <link rel="stylesheet" href="css/enhanced/dot1xer-ui.css">' index.html
    echo -e "${GREEN}Added CSS reference after existing stylesheet${NC}"
  else
    echo -e "${YELLOW}Could not automatically add CSS reference. Please add manually:${NC}"
    echo -e '<link rel="stylesheet" href="css/enhanced/dot1xer-ui.css">'
  fi
fi

# Add JS reference
if grep -q "</body>" index.html; then
  sed -i '/<\/body>/i \    <!-- Enhanced UI script -->\n    <script src="js/enhanced/dot1xer-ui.js"></script>' index.html
  echo -e "${GREEN}Added JS reference before body end${NC}"
else
  # Try alternative approach - look for last script tag
  if grep -q "<script" index.html; then
    sed -i '$a<script src="js/enhanced/dot1xer-ui.js"></script>' index.html
    echo -e "${GREEN}Added JS reference at end of file${NC}"
  else
    echo -e "${YELLOW}Could not automatically add JS reference. Please add manually:${NC}"
    echo -e '<script src="js/enhanced/dot1xer-ui.js"></script>'
  fi
fi

# Final message
echo -e "${GREEN}UI enhancement fixes applied!${NC}"
echo -e "The script has:"
echo -e "1. Created a resource-friendly UI enhancement"
echo -e "2. Added modern styling to existing elements"
echo -e "3. Enhanced vendor selection and platform details"
echo -e "4. Added subtle animations and visual improvements"
echo -e ""
echo -e "${YELLOW}If you encounter any issues, your original index.html has been backed up.${NC}"
echo -e "You can restore it with: cp index.html.backup.* index.html"
