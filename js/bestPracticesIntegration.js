/**
 * bestPracticesIntegration.js
 * Integration of Authentication Best Practices module with the UI
 */

// Initialize the Best Practices module
let bestPractices;

// Try to import the module if running in a module context
try {
  const module = await import('../src/components/authentication/utils/AuthenticationBestPractices.js');
  bestPractices = new module.default();
} catch (e) {
  console.warn('Using global AuthenticationBestPractices class');
  // Fallback to global scope if module import fails
  if (typeof AuthenticationBestPractices !== 'undefined') {
    bestPractices = new AuthenticationBestPractices();
  } else {
    console.error('AuthenticationBestPractices class not found');
  }
}

// Initialize the AI integration if available
const aiIntegration = window.AIIntegration || null;

document.addEventListener('DOMContentLoaded', function() {
  console.log('Initializing Best Practices Integration...');
  
  // Set up event handlers
  setupBestPracticesEvents();
  
  // Set up subtabs
  setupSubtabs();
});

// Set up event handlers for Best Practices tab
function setupBestPracticesEvents() {
  // Generate recommendations button
  const generateRecommendationsBtn = document.getElementById('generate-recommendations');
  if (generateRecommendationsBtn) {
    generateRecommendationsBtn.addEventListener('click', generateRecommendations);
  }
  
  // Apply recommendations button
  const applyRecommendationsBtn = document.getElementById('apply-recommendations');
  if (applyRecommendationsBtn) {
    applyRecommendationsBtn.addEventListener('click', applyRecommendations);
  }
  
  // AI review button
  const aiReviewBtn = document.getElementById('ai-review-config');
  if (aiReviewBtn) {
    aiReviewBtn.addEventListener('click', requestAIReview);
  }
}

// Set up subtabs functionality
function setupSubtabs() {
  const subtabs = document.querySelectorAll('.subtab');
  const subtabPanes = document.querySelectorAll('.subtab-pane');
  
  subtabs.forEach(tab => {
    tab.addEventListener('click', () => {
      const subtabId = tab.getAttribute('data-subtab');
      
      // Remove active class from all tabs and panes
      subtabs.forEach(t => t.classList.remove('active'));
      subtabPanes.forEach(p => p.classList.remove('active'));
      
      // Add active class to selected tab and pane
      tab.classList.add('active');
      document.getElementById(subtabId).classList.add('active');
    });
  });
}

// Generate recommendations based on current configuration
function generateRecommendations() {
  if (!bestPractices) {
    showAlert('Best Practices module not initialized', 'danger');
    return;
  }
  
  // Show loading indicator
  showAlert('Generating best practices recommendations...', 'info');
  
  // Get current configuration
  const config = collectFormSettings();
  
  // Get best practices options
  const securityLevel = document.getElementById('best-practices-security-level').value;
  const industry = document.getElementById('best-practices-industry').value;
  
  // Get selected compliance standards
  const complianceStandards = [];
  document.querySelectorAll('input[id^="compliance-"]:checked').forEach(checkbox => {
    complianceStandards.push(checkbox.value);
  });
  
  // Get vendor and component info
  const vendor = getSelectedVendor();
  const platformSelect = document.getElementById('platform-select');
  const platform = platformSelect ? platformSelect.value : '';
  
  // Generate recommendations
  const options = {
    vendor,
    component: 'radius', // Default to radius component for now
    industry: industry || undefined,
    complianceStandards: complianceStandards.length > 0 ? complianceStandards : undefined,
    deviceType: 'wired', // Default to wired device
    securityLevel
  };
  
  const recommendations = bestPractices.generateRecommendations(config, options);
  
  // Display recommendations
  displayRecommendations(recommendations);
  
  // Enable apply button if there are recommendations
  const applyBtn = document.getElementById('apply-recommendations');
  if (applyBtn) {
    applyBtn.disabled = recommendations.recommendations.length === 0;
  }
  
  showAlert('Best practices recommendations generated successfully!', 'success');
}

// Display recommendations in the UI
function displayRecommendations(recommendations) {
  // Update security score
  const scoreElement = document.getElementById('security-score-value');
  if (scoreElement) {
    scoreElement.textContent = recommendations.securityScore;
    
    // Add color class based on score
    const scoreCircle = scoreElement.closest('.score-circle');
    if (scoreCircle) {
      scoreCircle.classList.remove('good', 'warning', 'danger');
      
      if (recommendations.securityScore >= 80) {
        scoreCircle.classList.add('good');
      } else if (recommendations.securityScore >= 60) {
        scoreCircle.classList.add('warning');
      } else {
        scoreCircle.classList.add('danger');
      }
    }
  }
  
  // Update compliance status
  const complianceIndicator = document.getElementById('compliance-status-indicator');
  if (complianceIndicator) {
    complianceIndicator.classList.remove('compliant', 'non-compliant');
    complianceIndicator.classList.add(recommendations.compliant ? 'compliant
    #!/bin/bash
# Continued from previous script

# Create the Best Practices UI components - add to existing CSS file
echo -e "\n${YELLOW}Adding CSS styles for Best Practices UI...${NC}"
cat >> "$BASE_DIR/css/main.css" << 'EOL'
/* Best Practices tab styles */
.subtabs {
    display: flex;
    border-bottom: 1px solid #ddd;
    margin-bottom: 20px;
}

.subtab {
    padding: 10px 20px;
    cursor: pointer;
    border: 1px solid transparent;
    border-bottom: none;
    border-radius: 4px 4px 0 0;
    margin-right: 5px;
}

.subtab.active {
    background-color: #f9f9f9;
    border-color: #ddd;
    border-bottom-color: transparent;
}

.subtab-content {
    margin-bottom: 30px;
}

.subtab-pane {
    display: none;
    padding: 15px;
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-top: none;
    border-radius: 0 0 4px 4px;
}

.subtab-pane.active {
    display: block;
}

.best-practices-options {
    margin-bottom: 20px;
    padding: 15px;
    background-color: #f5f5f5;
    border-radius: 4px;
}

.recommendations-summary {
    display: flex;
    justify-content: space-around;
    margin-bottom: 20px;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 4px;
    background-color: #ffffff;
}

.security-score {
    text-align: center;
}

.score-circle {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background-color: #f3f3f3;
    border: 5px solid #ddd;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 10px;
    font-size: 24px;
    font-weight: bold;
}

.score-circle.good {
    border-color: #28a745;
}

.score-circle.warning {
    border-color: #ffc107;
}

.score-circle.danger {
    border-color: #dc3545;
}

.compliance-status {
    text-align: center;
}

.status-indicator {
    width: 80px;
    height: 80px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 10px;
}

.status-indicator .indicator {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    background-color: #ddd;
}

.status-indicator.compliant .indicator {
    background-color: #28a745;
    box-shadow: 0 0 10px #28a745;
}

.status-indicator.non-compliant .indicator {
    background-color: #dc3545;
    box-shadow: 0 0 10px #dc3545;
}

.expandable-list {
    margin-top: 20px;
}

.expandable-item {
    margin-bottom: 10px;
    border: 1px solid #ddd;
    border-radius: 4px;
}

.expandable-item.applied {
    border-color: #28a745;
}

.expandable-item-header {
    padding: 10px 15px;
    background-color: #f5f5f5;
    border-bottom: 1px solid #ddd;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.expandable-item.applied .expandable-item-header {
    background-color: #d4edda;
}

.expandable-item-header h4 {
    margin: 0;
    font-size: 16px;
}

.expandable-item-header .priority-badge {
    padding: 3px 8px;
    border-radius: 10px;
    font-size: 12px;
    font-weight: bold;
    text-transform: uppercase;
}

.priority-badge.high {
    background-color: #dc3545;
    color: white;
}

.priority-badge.medium {
    background-color: #ffc107;
    color: #333;
}

.priority-badge.low {
    background-color: #6c757d;
    color: white;
}

.expandable-item-content {
    padding: 15px;
    display: none;
}

.expandable-item.expanded .expandable-item-content {
    display: block;
}

.recommendation-action {
    margin-top: 10px;
    text-align: right;
}

/* AI Assistant modal styles */
.ai-assistant-review-modal {
    max-width: 800px;
}

.ai-review-result {
    max-height: 400px;
    overflow-y: auto;
    white-space: pre-wrap;
    background-color: #f9f9f9;
    padding: 15px;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin-bottom: 15px;
}

.loader {
    border: 4px solid #f3f3f3;
    border-radius: 50%;
    border-top: 4px solid #0077cc;
    width: 30px;
    height: 30px;
    margin: 20px auto;
    animation: spin 1s linear infinite;
}

@keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
}
