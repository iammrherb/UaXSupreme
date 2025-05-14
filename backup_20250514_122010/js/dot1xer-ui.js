/**
 * Dot1Xer Supreme Enterprise Edition UI
 * Enhanced UI with modern design and interactions
 */

// Wait for DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
  initializeUI();
});

/**
 * Initialize the UI components and event listeners
 */
function initializeUI() {
  // Initialize theme
  initTheme();
  
  // Initialize sidebar
  initSidebar();
  
  // Initialize tabs
  initTabs();
  
  // Initialize vendor selection
  initVendorSelection();
  
  // Initialize platform details
  initPlatformDetails();
  
  // Initialize modal dialogs
  initModals();
  
  // Initialize breadcrumbs navigation
  initBreadcrumbs();
  
  // Make sure any existing interactive elements keep working
  preserveExistingFunctionality();
  
  // Log initialization message
  console.log('Dot1Xer UI initialized successfully!');
}

/**
 * Initialize theme system with light/dark mode toggle
 */
function initTheme() {
  const themeToggle = document.querySelector('.theme-toggle');
  const savedTheme = localStorage.getItem('dot1xer-theme');
  
  // Set initial theme based on saved preference or system preference
  if (savedTheme === 'dark' || (!savedTheme && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
    document.body.classList.add('dark-theme');
    if (themeToggle) {
      themeToggle.innerHTML = '<i class="fa-solid fa-sun"></i>';
    }
  }
  
  // Add theme toggle event listener
  if (themeToggle) {
    themeToggle.addEventListener('click', function() {
      document.body.classList.toggle('dark-theme');
      
      if (document.body.classList.contains('dark-theme')) {
        localStorage.setItem('dot1xer-theme', 'dark');
        themeToggle.innerHTML = '<i class="fa-solid fa-sun"></i>';
      } else {
        localStorage.setItem('dot1xer-theme', 'light');
        themeToggle.innerHTML = '<i class="fa-solid fa-moon"></i>';
      }
    });
  }
}

/**
 * Initialize sidebar functionality
 */
function initSidebar() {
  const sidebarToggle = document.querySelector('.sidebar-toggle');
  const sidebar = document.querySelector('.sidebar');
  const savedState = localStorage.getItem('dot1xer-sidebar');
  
  // Set initial state based on saved preference
  if (savedState === 'collapsed') {
    sidebar.classList.add('sidebar-collapsed');
    if (sidebarToggle) {
      sidebarToggle.innerHTML = '<i class="fa-solid fa-chevron-right"></i>';
    }
  }
  
  // Add sidebar toggle event listener
  if (sidebarToggle && sidebar) {
    sidebarToggle.addEventListener('click', function() {
      sidebar.classList.toggle('sidebar-collapsed');
      
      if (sidebar.classList.contains('sidebar-collapsed')) {
        localStorage.setItem('dot1xer-sidebar', 'collapsed');
        sidebarToggle.innerHTML = '<i class="fa-solid fa-chevron-right"></i>';
      } else {
        localStorage.setItem('dot1xer-sidebar', 'expanded');
        sidebarToggle.innerHTML = '<i class="fa-solid fa-chevron-left"></i>';
      }
    });
  }
  
  // Add mobile menu toggle for responsive design
  const mobileMenuToggle = document.querySelector('.mobile-menu-toggle');
  if (mobileMenuToggle && sidebar) {
    mobileMenuToggle.addEventListener('click', function() {
      sidebar.classList.toggle('open');
    });
  }
  
  // Handle navigation items
  const navItems = document.querySelectorAll('.nav-item');
  navItems.forEach(item => {
    item.addEventListener('click', function() {
      // Remove active class from all items
      navItems.forEach(navItem => navItem.classList.remove('active'));
      
      // Add active class to clicked item
      this.classList.add('active');
      
      // If mobile view, close sidebar after selection
      if (window.innerWidth <= 768) {
        sidebar.classList.remove('open');
      }
      
      // Handle navigation if href attribute exists
      const href = this.getAttribute('href');
      if (href && href !== '#') {
        window.location.href = href;
      }
    });
  });
}

/**
 * Initialize tab functionality
 */
function initTabs() {
  // Find all tab containers
  const tabContainers = document.querySelectorAll('.tabs');
  
  tabContainers.forEach(container => {
    const tabItems = container.querySelectorAll('.tab-item');
    const tabContents = container.querySelectorAll('.tab-content');
    
    // Add click event to each tab item
    tabItems.forEach((tab, index) => {
      tab.addEventListener('click', function() {
        // Remove active class from all tabs and content
        tabItems.forEach(item => item.classList.remove('active'));
        tabContents.forEach(content => content.classList.remove('active'));
        
        // Add active class to clicked tab and corresponding content
        tab.classList.add('active');
        
        // If there's a content panel with the matching index, show it
        if (tabContents[index]) {
          tabContents[index].classList.add('active');
        }
      });
    });
  });
  
  // Handle main application tabs (if they exist in the old format)
  const mainTabs = document.querySelectorAll('.tab');
  const mainTabPanes = document.querySelectorAll('.tab-pane');
  
  if (mainTabs.length > 0 && mainTabPanes.length > 0) {
    mainTabs.forEach(tab => {
      tab.addEventListener('click', function() {
        const tabId = this.getAttribute('data-tab');
        
        // Remove active class from all tabs and panes
        mainTabs.forEach(t => t.classList.remove('active'));
        mainTabPanes.forEach(p => p.classList.remove('active'));
        
        // Add active class to clicked tab and corresponding pane
        this.classList.add('active');
        document.getElementById(tabId)?.classList.add('active');
        
        // Update progress indicator
        updateProgressIndicator(tabId);
      });
    });
  }
}

/**
 * Update progress indicator based on current tab
 */
function updateProgressIndicator(currentTabId) {
  // Map of tab IDs to their position in the flow
  const tabPositions = {
    'platform': 1,
    'authentication': 2,
    'security': 3,
    'network': 4,
    'advanced': 5,
    'preview': 6
  };
  
  const currentPosition = tabPositions[currentTabId] || 1;
  const totalSteps = Object.keys(tabPositions).length;
  
  // Update step label if it exists
  const stepLabel = document.querySelector('.step-label');
  if (stepLabel) {
    stepLabel.textContent = `Step ${currentPosition} of ${totalSteps} - ${currentTabId.charAt(0).toUpperCase() + currentTabId.slice(1)}`;
  }
  
  // Update step dots if they exist
  const stepDots = document.querySelectorAll('.step-dot');
  if (stepDots.length > 0) {
    stepDots.forEach((dot, index) => {
      if (index < currentPosition) {
        dot.classList.add('active');
      } else {
        dot.classList.remove('active');
      }
    });
  }
  
  // Update progress bar if it exists
  const progressFill = document.querySelector('.progress-fill');
  if (progressFill) {
    const progressPercentage = (currentPosition / totalSteps) * 100;
    progressFill.style.width = `${progressPercentage}%`;
  }
}

/**
 * Initialize vendor selection functionality
 */
function initVendorSelection() {
  // Vendor cards selection
  const vendorCards = document.querySelectorAll('.vendor-card');
  vendorCards.forEach(card => {
    card.addEventListener('click', function() {
      // Toggle selection
      vendorCards.forEach(c => c.classList.remove('selected'));
      this.classList.add('selected');
      
      // Get vendor data
      const vendorName = this.querySelector('.vendor-name').textContent;
      const vendorType = this.querySelector('.vendor-type').textContent;
      
      // Trigger vendor selection event
      const event = new CustomEvent('vendorSelected', {
        detail: {
          name: vendorName,
          type: vendorType
        }
      });
      document.dispatchEvent(event);
      
      // If using old code, update platform select
      updatePlatformSelect(vendorName);
    });
  });
  
  // Filter chips functionality
  const filterChips = document.querySelectorAll('.filter-chip');
  filterChips.forEach(chip => {
    chip.addEventListener('click', function() {
      // Toggle active state
      filterChips.forEach(c => c.classList.remove('active'));
      this.classList.add('active');
      
      // Get filter type
      const filterType = this.textContent.trim().toLowerCase();
      
      // Filter vendor cards
      filterVendorCards(filterType);
    });
  });
  
  // Search functionality
  const vendorSearch = document.querySelector('.vendor-search input');
  if (vendorSearch) {
    vendorSearch.addEventListener('input', function() {
      const searchQuery = this.value.trim().toLowerCase();
      searchVendorCards(searchQuery);
    });
  }
}

/**
 * Filter vendor cards based on type
 */
function filterVendorCards(filterType) {
  const vendorCards = document.querySelectorAll('.vendor-card');
  
  vendorCards.forEach(card => {
    const cardType = card.querySelector('.vendor-type').textContent.trim().toLowerCase();
    
    if (filterType === 'all') {
      card.style.display = 'flex';
    } else if (cardType === filterType) {
      card.style.display = 'flex';
    } else {
      card.style.display = 'none';
    }
  });
}

/**
 * Search vendor cards based on name
 */
function searchVendorCards(query) {
  const vendorCards = document.querySelectorAll('.vendor-card');
  
  vendorCards.forEach(card => {
    const cardName = card.querySelector('.vendor-name').textContent.trim().toLowerCase();
    
    if (query === '') {
      card.style.display = 'flex';
    } else if (cardName.includes(query)) {
      card.style.display = 'flex';
    } else {
      card.style.display = 'none';
    }
  });
}

/**
 * Update platform select dropdown based on selected vendor
 * (For compatibility with existing code)
 */
function updatePlatformSelect(vendorName) {
  const platformSelect = document.getElementById('platform-select');
  if (!platformSelect) return;
  
  // Clear current options
  platformSelect.innerHTML = '';
  
  // Default option
  const defaultOption = document.createElement('option');
  defaultOption.value = '';
  defaultOption.textContent = 'Select a platform';
  platformSelect.appendChild(defaultOption);
  
  // Get platforms for the selected vendor
  const platforms = getPlatformsForVendor(vendorName);
  
  // Add platform options
  platforms.forEach(platform => {
    const option = document.createElement('option');
    option.value = platform.value;
    option.textContent = platform.name;
    platformSelect.appendChild(option);
  });
  
  // Enable the select
  platformSelect.disabled = false;
  
  // Trigger change event to update any existing listeners
  const event = new Event('change');
  platformSelect.dispatchEvent(event);
}

/**
 * Get platforms for a specific vendor
 * This function maps vendor names to their available platforms
 */
function getPlatformsForVendor(vendorName) {
  const vendorPlatforms = {
    'Cisco': [
      { value: 'ios-xe', name: 'IOS-XE' },
      { value: 'ios', name: 'IOS' },
      { value: 'nx-os', name: 'NX-OS' },
      { value: 'catalyst-os', name: 'Catalyst OS' },
      { value: 'ise', name: 'ISE' },
      { value: 'wlc-9800', name: 'WLC 9800' }
    ],
    'Aruba': [
      { value: 'aos-cx', name: 'AOS-CX' },
      { value: 'aos-switch', name: 'AOS-Switch' },
      { value: 'clearpass', name: 'ClearPass' }
    ],
    'Juniper': [
      { value: 'junos', name: 'JunOS' },
      { value: 'ex-series', name: 'EX Series' },
      { value: 'srx-series', name: 'SRX Series' }
    ],
    'HP': [
      { value: 'procurve', name: 'ProCurve' },
      { value: 'comware', name: 'Comware' }
    ],
    'Extreme': [
      { value: 'exos', name: 'EXOS' },
      { value: 'voss', name: 'VOSS' }
    ],
    'Fortinet': [
      { value: 'fortiswitch', name: 'FortiSwitch' },
      { value: 'fortigate', name: 'FortiGate' }
    ],
    'Dell': [
      { value: 'os10', name: 'OS10' },
      { value: 'os9', name: 'OS9' }
    ],
    'Huawei': [
      { value: 'vrp', name: 'VRP' },
      { value: 's-series', name: 'S Series' }
    ],
    'Checkpoint': [
      { value: 'gaia', name: 'Gaia' },
      { value: 'splat', name: 'Splat' }
    ],
    'Palo Alto': [
      { value: 'panos', name: 'PanOS' }
    ],
    'Meraki': [
      { value: 'dashboard', name: 'Dashboard API' }
    ],
    'Ubiquiti': [
      { value: 'unifi', name: 'UniFi' },
      { value: 'edgeswitch', name: 'EdgeSwitch' }
    ],
    'Ruckus': [
      { value: 'fastiron', name: 'FastIron' },
      { value: 'icx', name: 'ICX' }
    ]
  };
  
  // Return platforms for the specified vendor, or an empty array if not found
  return vendorPlatforms[vendorName] || [];
}

/**
 * Initialize platform details functionality
 */
function initPlatformDetails() {
  const platformSelect = document.getElementById('platform-select');
  const softwareVersionSelect = document.getElementById('software-version');
  
  if (platformSelect) {
    platformSelect.addEventListener('change', function() {
      const selectedPlatform = this.value;
      const selectedVendor = getSelectedVendor();
      
      if (selectedPlatform) {
        // Update platform details
        updatePlatformDetails(selectedVendor, selectedPlatform);
        
        // Enable next button
        enableNextButton();
      }
    });
  }
  
  if (softwareVersionSelect) {
    softwareVersionSelect.addEventListener('change', function() {
      // Update platform details with version info
      const selectedPlatform = platformSelect ? platformSelect.value : '';
      const selectedVendor = getSelectedVendor();
      
      if (selectedPlatform) {
        updatePlatformDetails(selectedVendor, selectedPlatform, this.value);
      }
    });
  }
}

/**
 * Get the currently selected vendor
 */
function getSelectedVendor() {
  const selectedCard = document.querySelector('.vendor-card.selected');
  return selectedCard ? selectedCard.querySelector('.vendor-name').textContent : '';
}

/**
 * Update platform details based on selected vendor and platform
 */
function updatePlatformDetails(vendor, platform, version = '') {
  // Find or create platform details container
  let platformDetailsContainer = document.querySelector('.platform-box');
  
  if (!platformDetailsContainer) {
    // If using old UI, look for legacy container
    const legacyContainer = document.getElementById('platform-details');
    
    if (legacyContainer) {
      // Keep using the legacy container
      updateLegacyPlatformDetails(legacyContainer, vendor, platform, version);
      return;
    }
    
    // Create new container if none exists
    platformDetailsContainer = document.createElement('div');
    platformDetailsContainer.className = 'platform-box slide-up';
    
    // Find insertion point
    const insertionPoint = document.querySelector('.form-row');
    if (insertionPoint) {
      insertionPoint.parentNode.appendChild(platformDetailsContainer);
    }
  }
  
  // Update platform details content
  const platformData = getPlatformData(vendor, platform);
  
  // Format and add version if provided
  const versionText = version ? ` ${version}` : '';
  
  platformDetailsContainer.innerHTML = `
    <div class="platform-header">
      <div class="platform-info">
        <div class="platform-icon">
          <i class="fa-solid ${platformData.icon}"></i>
        </div>
        <div>
          <h3 class="platform-title">${platform}${versionText}</h3>
        </div>
      </div>
      <span class="vendor-badge">${vendor}</span>
    </div>
    
    <p class="platform-description">${platformData.description}</p>
    
    <div class="capability-label">Capabilities</div>
    <div class="capability-badges">
      ${platformData.capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
    </div>
    
    <div class="tabs">
      <div class="tab-nav">
        <div class="tab-item active">Overview</div>
        <div class="tab-item">Recommended Settings</div>
        <div class="tab-item">Compatibility</div>
        <div class="tab-item">Documentation</div>
      </div>
      
      <div class="tab-content active">
        <p style="margin-bottom: 1rem">${platformData.overview}</p>
        
        <div class="form-group">
          <label class="form-label">Configuration Template</label>
          <select class="form-control" id="template-select">
            ${platformData.templates.map(tpl => `<option value="${tpl.value}">${tpl.name}</option>`).join('')}
          </select>
        </div>
      </div>
    </div>
  `;
  
  // Initialize tabs in the newly created content
  initTabs();
}

/**
 * Update legacy platform details container
 * For backward compatibility with the original UI
 */
function updateLegacyPlatformDetails(container, vendor, platform, version = '') {
  const platformData = getPlatformData(vendor, platform);
  
  // Format and add version if provided
  const versionText = version ? ` ${version}` : '';
  
  container.innerHTML = `
    <div class="platform-details-header">
      <h3>${platform}${versionText}</h3>
      <span class="vendor-badge">${vendor}</span>
    </div>
    <p>${platformData.description}</p>
    
    <h4>Capabilities</h4>
    <div class="capability-badges">
      ${platformData.capabilities.map(cap => `<span class="capability-badge">${cap}</span>`).join('')}
    </div>
  `;
}

/**
 * Get platform data based on vendor and platform
 */
function getPlatformData(vendor, platform) {
  // Default data if specific platform isn't found
  const defaultData = {
    icon: 'fa-microchip',
    description: 'Network platform supporting 802.1X authentication.',
    capabilities: ['802.1X', 'RADIUS'],
    overview: 'This platform provides standard 802.1X authentication capabilities.',
    templates: [
      { value: 'dot1x-basic', name: 'Basic 802.1X' },
      { value: 'dot1x-advanced', name: 'Advanced 802.1X' }
    ]
  };
  
  // Platform data lookup
  const platformData = {
    'Cisco': {
      'ios-xe': {
        icon: 'fa-network-wired',
        description: 'IOS-XE for newer Catalyst switches and ISR routers with enhanced scalability and modularity.',
        capabilities: ['802.1X', 'MAB', 'RadSec', 'TACACS+', 'RADIUS', 'MACsec'],
        overview: 'Cisco IOS-XE provides a modern operating system for enterprise network devices with enhanced scalability and modularity. It supports the full range of 802.1X authentication methods and security features.',
        templates: [
          { value: 'dot1x-mab-template', name: '802.1X with MAB Fallback' },
          { value: 'dot1x-template', name: '802.1X Only' },
          { value: 'dot1x-mab-concurrent-template', name: 'Concurrent Authentication' },
          { value: 'radsec-template', name: 'RadSec Configuration' },
          { value: 'tacacs-admin-template', name: 'TACACS+ Administration' }
        ]
      },
      'ios': {
        icon: 'fa-server',
        description: 'Traditional IOS for older Catalyst switches and routers.',
        capabilities: ['802.1X', 'MAB', 'TACACS+', 'RADIUS'],
        overview: 'Cisco IOS is the traditional operating system for Cisco switches and routers. It provides robust 802.1X authentication capabilities with varying feature support depending on the device model and IOS version.',
        templates: [
          { value: 'dot1x-mab-template', name: '802.1X with MAB Fallback' },
          { value: 'dot1x-template', name: '802.1X Only' },
          { value: 'tacacs-admin-template', name: 'TACACS+ Administration' }
        ]
      },
      'nx-os': {
        icon: 'fa-sitemap',
        description: 'NX-OS for Nexus switches with data center focused features.',
        capabilities: ['802.1X', 'MAB', 'TACACS+', 'RADIUS'],
        overview: 'Cisco NX-OS is designed for data center environments and Nexus switches. It supports 802.1X authentication with features tailored for high-performance, mission-critical networks.',
        templates: [
          { value: 'dot1x-template', name: '802.1X Configuration' },
          { value: 'tacacs-admin-template', name: 'TACACS+ Administration' }
        ]
      }
    },
    'Aruba': {
      'aos-cx': {
        icon: 'fa-server',
        description: 'Modern, cloud-native OS for Aruba CX switches.',
        capabilities: ['802.1X', 'MAB', 'RADIUS', 'TACACS+', 'MACsec'],
        overview: 'Aruba AOS-CX is a modern, cloud-native operating system designed for the Aruba CX switch portfolio. It provides comprehensive 802.1X authentication capabilities with advanced security features.',
        templates: [
          { value: 'dot1x-template', name: '802.1X Configuration' },
          { value: 'dot1x-mab-template', name: '802.1X with MAB Fallback' }
        ]
      },
      'aos-switch': {
        icon: 'fa-network-wired',
        description: 'Legacy operating system for older Aruba/HPE switches.',
        capabilities: ['802.1X', 'MAB', 'RADIUS', 'TACACS+'],
        overview: 'Aruba AOS-Switch (formerly HPE ProVision) provides reliable 802.1X authentication capabilities for edge access switches.',
        templates: [
          { value: 'dot1x-template', name: '802.1X Configuration' },
          { value: 'dot1x-mab-template', name: '802.1X with MAB Fallback' }
        ]
      }
    },
    'Juniper': {
      'junos': {
        icon: 'fa-network-wired',
        description: 'JunOS for EX, QFX, and SRX series devices.',
        capabilities: ['802.1X', 'MAB', 'RADIUS', 'TACACS+', 'MACsec'],
        overview: 'Juniper JunOS provides a unified operating system across all Juniper networking platforms. It offers robust 802.1X authentication with consistent configuration syntax.',
        templates: [
          { value: 'dot1x-template', name: '802.1X Configuration' },
          { value: 'dot1x-mab-template', name: '802.1X with MAB Fallback' }
        ]
      }
    }
  };
  
  // Look up platform data based on vendor and platform
  if (platformData[vendor] && platformData[vendor][platform]) {
    return platformData[vendor][platform];
  }
  
  // If no specific data is found, return default data
  return defaultData;
}

/**
 * Enable next button when a platform is selected
 */
function enableNextButton() {
  // Enable next button in new UI
  const nextButton = document.querySelector('.btn-primary');
  if (nextButton) {
    nextButton.disabled = false;
  }
  
  // Enable next button in legacy UI
  const legacyNextButton = document.getElementById('platform-next');
  if (legacyNextButton) {
    legacyNextButton.disabled = false;
  }
}

/**
 * Initialize modal dialog functionality
 */
function initModals() {
  // Find all modal triggers
  const modalTriggers = document.querySelectorAll('[data-modal]');
  
  modalTriggers.forEach(trigger => {
    trigger.addEventListener('click', function() {
      const modalId = this.getAttribute('data-modal');
      const modal = document.getElementById(modalId);
      
      if (modal) {
        openModal(modal);
      }
    });
  });
  
  // Find all modal close buttons
  const closeButtons = document.querySelectorAll('.modal-close, [data-close-modal]');
  
  closeButtons.forEach(button => {
    button.addEventListener('click', function() {
      // Find the closest modal
      const modal = this.closest('.modal-overlay');
      if (modal) {
        closeModal(modal);
      }
    });
  });
  
  // Close modal when clicking on the overlay
  const modalOverlays = document.querySelectorAll('.modal-overlay');
  
  modalOverlays.forEach(overlay => {
    overlay.addEventListener('click', function(e) {
      // Close only if the click was directly on the overlay, not its children
      if (e.target === this) {
        closeModal(this);
      }
    });
  });
}

/**
 * Open a modal dialog
 */
function openModal(modal) {
  modal.classList.add('open');
  document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

/**
 * Close a modal dialog
 */
function closeModal(modal) {
  modal.classList.remove('open');
  document.body.style.overflow = ''; // Restore scrolling
}

/**
 * Initialize breadcrumbs navigation
 */
function initBreadcrumbs() {
  const breadcrumbItems = document.querySelectorAll('.breadcrumb-item');
  
  breadcrumbItems.forEach(item => {
    item.addEventListener('click', function(e) {
      // Prevent default only if it's a navigation within the app
      const href = this.getAttribute('href');
      if (href === '#' || href.startsWith('#')) {
        e.preventDefault();
        
        // Get the target tab
        const targetTab = href.replace('#', '');
        
        // Activate the target tab
        const tab = document.querySelector(`[data-tab="${targetTab}"]`);
        if (tab) {
          const event = new MouseEvent('click', {
            bubbles: true,
            cancelable: true,
            view: window
          });
          tab.dispatchEvent(event);
        }
      }
    });
  });
}

/**
 * Preserve existing functionality from the original Dot1Xer code
 */
function preserveExistingFunctionality() {
  // Link old tab events to new navigation if needed
  const oldTabs = document.querySelectorAll('.tab');
  const navItems = document.querySelectorAll('.nav-item');
  
  if (oldTabs.length > 0 && navItems.length > 0) {
    oldTabs.forEach(tab => {
      const tabId = tab.getAttribute('data-tab');
      const navItem = Array.from(navItems).find(item => {
        const text = item.querySelector('.nav-text');
        return text && text.textContent.toLowerCase().includes(tabId);
      });
      
      if (navItem) {
        // Link the old tab click to the new nav item click
        tab.addEventListener('click', function() {
          navItem.click();
        });
        
        // Link the new nav item click to the old tab click
        navItem.addEventListener('click', function() {
          tab.click();
        });
      }
    });
  }
  
  // Connect any existing vendor selection functionality
  document.addEventListener('vendorSelected', function(e) {
    // Trigger the existing vendor selection functionality if it exists
    if (typeof selectVendor === 'function') {
      selectVendor(e.detail.name);
    }
  });
}
