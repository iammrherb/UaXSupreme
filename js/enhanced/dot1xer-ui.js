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
