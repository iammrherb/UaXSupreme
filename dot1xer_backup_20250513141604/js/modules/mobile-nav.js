/**
 * Mobile Navigation Module
 * Handles the responsive mobile menu for small screens
 */

class MobileNav {
  constructor() {
    this.menuToggle = null;
    this.sidebar = null;
    this.overlay = null;
    this.initialized = false;
  }
  
  init() {
    // Don't initialize twice
    if (this.initialized) return;
    
    // Create menu toggle button if it doesn't exist
    if (!document.querySelector('.mobile-menu-toggle')) {
      this.createMenuToggle();
    } else {
      this.menuToggle = document.querySelector('.mobile-menu-toggle');
    }
    
    // Find sidebar
    this.sidebar = document.querySelector('.sidebar');
    
    // Create overlay for mobile menu
    this.createOverlay();
    
    // Add event listeners
    this.addEventListeners();
    
    this.initialized = true;
    console.log('Mobile navigation initialized');
  }
  
  createMenuToggle() {
    // Create the mobile menu toggle button
    this.menuToggle = document.createElement('button');
    this.menuToggle.className = 'mobile-menu-toggle';
    this.menuToggle.innerHTML = '<i class="fa-solid fa-bars"></i>';
    this.menuToggle.setAttribute('aria-label', 'Toggle navigation menu');
    
    // Find header to append the button
    const header = document.querySelector('.app-header');
    if (header) {
      // Insert as first child to appear at the left
      if (header.firstChild) {
        header.insertBefore(this.menuToggle, header.firstChild);
      } else {
        header.appendChild(this.menuToggle);
      }
    }
  }
  
  createOverlay() {
    // Create backdrop overlay for mobile menu
    this.overlay = document.createElement('div');
    this.overlay.className = 'mobile-nav-overlay';
    this.overlay.style.position = 'fixed';
    this.overlay.style.top = '0';
    this.overlay.style.left = '0';
    this.overlay.style.right = '0';
    this.overlay.style.bottom = '0';
    this.overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
    this.overlay.style.zIndex = '40';
    this.overlay.style.opacity = '0';
    this.overlay.style.visibility = 'hidden';
    this.overlay.style.transition = 'opacity 0.3s, visibility 0.3s';
    
    document.body.appendChild(this.overlay);
  }
  
  addEventListeners() {
    // Toggle menu on button click
    if (this.menuToggle && this.sidebar) {
      this.menuToggle.addEventListener('click', () => {
        this.toggleMenu();
      });
    }
    
    // Close menu when clicking the overlay
    if (this.overlay) {
      this.overlay.addEventListener('click', () => {
        this.closeMenu();
      });
    }
    
    // Close menu on window resize (if moving to desktop view)
    window.addEventListener('resize', () => {
      if (window.innerWidth > 768 && this.isMenuOpen()) {
        this.closeMenu();
      }
    });
  }
  
  toggleMenu() {
    if (this.isMenuOpen()) {
      this.closeMenu();
    } else {
      this.openMenu();
    }
  }
  
  openMenu() {
    if (this.sidebar) {
      this.sidebar.classList.add('open');
      document.body.style.overflow = 'hidden'; // Prevent background scrolling
      
      // Show overlay
      if (this.overlay) {
        this.overlay.style.opacity = '1';
        this.overlay.style.visibility = 'visible';
      }
      
      // Change toggle icon
      if (this.menuToggle) {
        this.menuToggle.innerHTML = '<i class="fa-solid fa-xmark"></i>';
      }
    }
  }
  
  closeMenu() {
    if (this.sidebar) {
      this.sidebar.classList.remove('open');
      document.body.style.overflow = ''; // Restore scrolling
      
      // Hide overlay
      if (this.overlay) {
        this.overlay.style.opacity = '0';
        this.overlay.style.visibility = 'hidden';
      }
      
      // Restore toggle icon
      if (this.menuToggle) {
        this.menuToggle.innerHTML = '<i class="fa-solid fa-bars"></i>';
      }
    }
  }
  
  isMenuOpen() {
    return this.sidebar && this.sidebar.classList.contains('open');
  }
}

// Initialize mobile navigation on page load
document.addEventListener('DOMContentLoaded', () => {
  const mobileNav = new MobileNav();
  mobileNav.init();
  
  // Make available globally
  window.mobileNav = mobileNav;
});
