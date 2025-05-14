// Dot1Xer Wizard Initialization

document.addEventListener('DOMContentLoaded', function() {
  // Initialize Advanced Authentication Wizard
  initWizard();
  
  // Setup form toggling behavior
  setupFormToggles();
  
  // Initialize tooltips
  initTooltips();
});

// Initialize the authentication wizard
function initWizard() {
  // Track current step
  let currentStep = 0;
  const totalSteps = 6;
  
  // Update progress bar function
  function updateProgress(step) {
    const progressFill = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    if (progressFill && progressText) {
      const percent = Math.round((step / (totalSteps - 1)) * 100);
      progressFill.style.width = `${percent}%`;
      progressText.textContent = `${percent}% complete`;
    }
  }
  
  // Step navigation functions
  window.nextStep = function() {
    if (currentStep < totalSteps - 1) {
      // Hide current step
      document.querySelectorAll('.wizard-step').forEach(step => {
        step.classList.remove('active');
      });
      
      // Show next step
      currentStep++;
      document.querySelector(`.wizard-step[data-step="${currentStep}"]`).classList.add('active');
      
      // Update progress
      updateProgress(currentStep);
      
      // Scroll to top
      window.scrollTo(0, 0);
    }
  };
  
  window.prevStep = function() {
    if (currentStep > 0) {
      // Hide current step
      document.querySelectorAll('.wizard-step').forEach(step => {
        step.classList.remove('active');
      });
      
      // Show previous step
      currentStep--;
      document.querySelector(`.wizard-step[data-step="${currentStep}"]`).classList.add('active');
      
      // Update progress
      updateProgress(currentStep);
      
      // Scroll to top
      window.scrollTo(0, 0);
    }
  };
  
  // Set up step navigation buttons
  document.querySelectorAll('.btn-next').forEach(btn => {
    btn.addEventListener('click', window.nextStep);
  });
  
  document.querySelectorAll('.btn-prev').forEach(btn => {
    btn.addEventListener('click', window.prevStep);
  });
  
  // Initialize first step
  document.querySelector('.wizard-step[data-step="0"]').classList.add('active');
  updateProgress(0);
  
  // Toggle wizard visibility
  const wizardToggle = document.querySelector('.wizard-toggle');
  const wizardContainer = document.querySelector('.wizard-container');
  
  if (wizardToggle && wizardContainer) {
    wizardToggle.addEventListener('click', function() {
      if (wizardContainer.style.display === 'none') {
        wizardContainer.style.display = 'block';
        wizardToggle.textContent = 'Hide Advanced Wizard';
      } else {
        wizardContainer.style.display = 'none';
        wizardToggle.textContent = 'Show Advanced Wizard';
      }
    });
  }
}

// Setup form toggle behavior
function setupFormToggles() {
  // RADIUS CoA settings toggle
  const useCoaCheckbox = document.getElementById('use-coa');
  const coaSettings = document.getElementById('coa-settings');
  
  if (useCoaCheckbox && coaSettings) {
    useCoaCheckbox.addEventListener('change', function() {
      coaSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    coaSettings.style.display = useCoaCheckbox.checked ? 'block' : 'none';
  }
  
  // RADSEC settings toggle
  const useRadsecCheckbox = document.getElementById('use-radsec');
  const radsecSettings = document.getElementById('radsec-settings');
  
  if (useRadsecCheckbox && radsecSettings) {
    useRadsecCheckbox.addEventListener('change', function() {
      radsecSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    radsecSettings.style.display = useRadsecCheckbox.checked ? 'block' : 'none';
  }
  
  // DHCP Snooping settings toggle
  const dhcpSnoopingCheckbox = document.getElementById('enable-dhcp-snooping');
  const dhcpSnoopingSettings = document.getElementById('dhcp-snooping-settings');
  
  if (dhcpSnoopingCheckbox && dhcpSnoopingSettings) {
    dhcpSnoopingCheckbox.addEventListener('change', function() {
      dhcpSnoopingSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    dhcpSnoopingSettings.style.display = dhcpSnoopingCheckbox.checked ? 'block' : 'none';
  }
  
  // Dynamic ARP Inspection settings toggle
  const daiCheckbox = document.getElementById('enable-dai');
  const daiSettings = document.getElementById('dai-settings');
  
  if (daiCheckbox && daiSettings) {
    daiCheckbox.addEventListener('change', function() {
      daiSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    daiSettings.style.display = daiCheckbox.checked ? 'block' : 'none';
  }
  
  // Storm Control settings toggle
  const stormControlCheckbox = document.getElementById('enable-storm-control');
  const stormControlSettings = document.getElementById('storm-control-settings');
  
  if (stormControlCheckbox && stormControlSettings) {
    stormControlCheckbox.addEventListener('change', function() {
      stormControlSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    stormControlSettings.style.display = stormControlCheckbox.checked ? 'block' : 'none';
  }
  
  // Port Security settings toggle
  const portSecurityCheckbox = document.getElementById('enable-port-security');
  const portSecuritySettings = document.getElementById('port-security-settings');
  
  if (portSecurityCheckbox && portSecuritySettings) {
    portSecurityCheckbox.addEventListener('change', function() {
      portSecuritySettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    portSecuritySettings.style.display = portSecurityCheckbox.checked ? 'block' : 'none';
  }
  
  // TACACS settings toggle
  const useTacacsCheckbox = document.getElementById('use-tacacs');
  const tacacsSettings = document.getElementById('tacacs-settings');
  
  if (useTacacsCheckbox && tacacsSettings) {
    useTacacsCheckbox.addEventListener('change', function() {
      tacacsSettings.style.display = this.checked ? 'block' : 'none';
    });
    // Initialize
    tacacsSettings.style.display = useTacacsCheckbox.checked ? 'block' : 'none';
  }
  
  // Authentication method toggle
  const authMethodSelect = document.getElementById('auth-method');
  
  if (authMethodSelect) {
    authMethodSelect.addEventListener('change', function() {
      updateAuthMethodInfo(this.value);
    });
    // Initialize
    if (authMethodSelect.value) {
      updateAuthMethodInfo(authMethodSelect.value);
    }
  }
}

// Update authentication method description
function updateAuthMethodInfo(method) {
  const methodInfo = document.querySelectorAll('.method-info-panel');
  
  // Hide all panels
  methodInfo.forEach(panel => {
    panel.classList.remove('active');
  });
  
  // Show selected panel
  const selectedPanel = document.getElementById(`${method}-info`);
  if (selectedPanel) {
    selectedPanel.classList.add('active');
  }
}

// Initialize tooltips
function initTooltips() {
  const tooltips = document.querySelectorAll('.tooltip');
  
  tooltips.forEach(tooltip => {
    const helpIcon = document.createElement('i');
    helpIcon.className = 'fa fa-question-circle help-icon';
    
    const tooltipText = document.createElement('span');
    tooltipText.className = 'tooltip-text';
    tooltipText.innerHTML = tooltip.getAttribute('data-tooltip');
    
    tooltip.appendChild(helpIcon);
    tooltip.appendChild(tooltipText);
  });
}
