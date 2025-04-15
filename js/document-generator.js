/**
 * Document Generator Module
 * Generates documentation and exports in various formats
 */

const DocumentGenerator = {
  init: function() {
    console.log('Document Generator initialized');
    this.bindEvents();
  },
  
  bindEvents: function() {
    // Listen for document generation requests
    const exportButtons = document.querySelectorAll('.export-btn');
    exportButtons.forEach(btn => {
      btn.addEventListener('click', (e) => {
        const format = e.target.dataset.format;
        this.generateDocument(format);
      });
    });
  },
  
  generateDocument: function(format) {
    console.log(`Generating document in ${format} format`);
    
    // Gather all configuration and project data
    const documentData = this.collectDocumentData();
    
    // Show generation in progress message
    showAlert(`Generating ${format.toUpperCase()} document...`, 'info');
    
    // Based on format, call the appropriate generation method
    switch (format.toLowerCase()) {
      case 'pdf':
        this.generatePDF(documentData);
        break;
      case 'word':
        this.generateWord(documentData);
        break;
      case 'html':
        this.generateHTML(documentData);
        break;
      case 'text':
        this.generateText(documentData);
        break;
      default:
        showAlert('Unsupported document format', 'danger');
    }
  },
  
  collectDocumentData: function() {
    // This would collect all the configuration and project data
    // For this implementation, we'll return mock data
    return {
      projectName: document.querySelector('#project-name')?.value || 'New 802.1X Deployment',
      organization: document.querySelector('#organization')?.value || 'Example Organization',
      date: new Date().toISOString().split('T')[0],
      author: document.querySelector('#author')?.value || 'Network Administrator',
      vendorConfigurations: this.getVendorConfigurations(),
      deploymentSteps: this.getDeploymentSteps(),
      networkDiagram: this.captureNetworkDiagram()
    };
  },
  
  getVendorConfigurations: function() {
    // In a real implementation, this would gather all vendor configurations
    // Here we'll return a simple mock object
    return {
      'cisco': document.querySelector('#cisco-config')?.value || 'aaa new-model\naaa authentication dot1x default group radius\ndot1x system-auth-control',
      'aruba': document.querySelector('#aruba-config')?.value || 'aaa authentication dot1x profile\nradius-server host 192.168.1.100',
      'juniper': document.querySelector('#juniper-config')?.value || 'system { authentication-order [ radius password ]; }',
      // Add other vendors as needed
    };
  },
  
  getDeploymentSteps: function() {
    // Gather deployment steps from the UI
    const steps = [];
    const stepElements = document.querySelectorAll('.deployment-step');
    
    stepElements.forEach((el, index) => {
      steps.push({
        number: index + 1,
        title: el.querySelector('.step-title')?.textContent || `Step ${index + 1}`,
        description: el.querySelector('.step-description')?.textContent || 'No description provided'
      });
    });
    
    // If no steps were found, return default steps
    if (steps.length === 0) {
      return [
        { number: 1, title: 'Prepare RADIUS Server', description: 'Install and configure RADIUS server with user credentials.' },
        { number: 2, title: 'Configure Network Devices', description: 'Apply 802.1X configuration to switches and wireless controllers.' },
        { number: 3, title: 'Test Authentication', description: 'Verify authentication works with test clients.' },
        { number: 4, title: 'Deploy to Production', description: 'Roll out 802.1X to production environment.' }
      ];
    }
    
    return steps;
  },
  
  captureNetworkDiagram: function() {
    // In a real implementation, this might capture a canvas or SVG diagram
    // Here we'll return a placeholder
    return 'Network diagram placeholder';
  },
  
  generatePDF: function(data) {
    console.log('Generating PDF document with data:', data);
    
    // In a real implementation, this would use a library like jsPDF
    // For now, we'll simulate PDF generation
    setTimeout(() => {
      // Create a simple text representation
      let content = this.createDocumentContent(data);
      
      try {
        // Check if jsPDF is available
        if (typeof jspdf !== 'undefined' && typeof jspdf.jsPDF === 'function') {
          const { jsPDF } = jspdf;
          const doc = new jsPDF();
          
          // Add content to PDF
          const lines = content.split('\n');
          let y = 20;
          
          doc.setFontSize(16);
          doc.text(data.projectName, 20, y);
          y += 10;
          
          doc.setFontSize(12);
          lines.forEach(line => {
            if (y > 280) {
              doc.addPage();
              y = 20;
            }
            doc.text(line, 20, y);
            y += 7;
          });
          
          // Save the PDF
          doc.save(`${data.projectName.replace(/\s+/g, '_')}_documentation.pdf`);
          showAlert('PDF document generated successfully', 'success');
        } else {
          // If jsPDF is not available, offer text download
          this.generateText(data);
          showAlert('PDF generation requires jsPDF library', 'warning');
        }
      } catch (error) {
        console.error('Error generating PDF:', error);
        showAlert('Error generating PDF', 'danger');
      }
    }, 1500);
  },
  
  generateWord: function(data) {
    console.log('Generating Word document with data:', data);
    
    // Simulate Word document generation
    setTimeout(() => {
      // Create a simple HTML representation
      let content = this.createDocumentContent(data, 'html');
      
      try {
        // Create a Blob containing the HTML content
        const blob = new Blob([content], { type: 'application/vnd.ms-word' });
        
        // Create a download link
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `${data.projectName.replace(/\s+/g, '_')}_documentation.doc`;
        
        // Trigger download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        showAlert('Word document generated successfully', 'success');
      } catch (error) {
        console.error('Error generating Word document:', error);
        showAlert('Error generating Word document', 'danger');
      }
    }, 1500);
  },
  
  generateHTML: function(data) {
    console.log('Generating HTML document with data:', data);
    
    // Generate HTML content
    setTimeout(() => {
      // Create HTML content
      let content = `<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${data.projectName} Documentation</title>
  <style>
    body { font-family: Arial, sans-serif; max-width: 800px; margin: 0 auto; padding: 20px; }
    h1, h2, h3 { color: #333; }
    pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; }
    .step { margin-bottom: 20px; }
    .step-title { font-weight: bold; }
  </style>
</head>
<body>
  <h1>${data.projectName}</h1>
  <p><strong>Organization:</strong> ${data.organization}</p>
  <p><strong>Date:</strong> ${data.date}</p>
  <p><strong>Author:</strong> ${data.author}</p>
  
  <h2>Vendor Configurations</h2>
  ${Object.entries(data.vendorConfigurations).map(([vendor, config]) => `
    <h3>${vendor.charAt(0).toUpperCase() + vendor.slice(1)}</h3>
    <pre>${config}</pre>
  `).join('')}
  
  <h2>Deployment Steps</h2>
  ${data.deploymentSteps.map(step => `
    <div class="step">
      <div class="step-title">${step.number}. ${step.title}</div>
      <div class="step-description">${step.description}</div>
    </div>
  `).join('')}
</body>
</html>`;
      
      try {
        // Create a Blob containing the HTML content
        const blob = new Blob([content], { type: 'text/html' });
        
        // Create a download link
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `${data.projectName.replace(/\s+/g, '_')}_documentation.html`;
        
        // Trigger download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        showAlert('HTML document generated successfully', 'success');
      } catch (error) {
        console.error('Error generating HTML document:', error);
        showAlert('Error generating HTML document', 'danger');
      }
    }, 1500);
  },
  
  generateText: function(data) {
    console.log('Generating text document with data:', data);
    
    // Generate plain text content
    setTimeout(() => {
      // Create plain text content
      let content = this.createDocumentContent(data);
      
      try {
        // Create a Blob containing the text content
        const blob = new Blob([content], { type: 'text/plain' });
        
        // Create a download link
        const link = document.createElement('a');
        link.href = URL.createObjectURL(blob);
        link.download = `${data.projectName.replace(/\s+/g, '_')}_documentation.txt`;
        
        // Trigger download
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        
        showAlert('Text document generated successfully', 'success');
      } catch (error) {
        console.error('Error generating text document:', error);
        showAlert('Error generating text document', 'danger');
      }
    }, 1500);
  },
  
  createDocumentContent: function(data, format = 'text') {
    // Create document content based on format
    if (format === 'html') {
      return this.createHTMLContent(data);
    }
    
    // Default to text format
    let content = '';
    content += `${data.projectName}\n`;
    content += `Organization: ${data.organization}\n`;
    content += `Date: ${data.date}\n`;
    content += `Author: ${data.author}\n\n`;
    
    content += `VENDOR CONFIGURATIONS\n`;
    content += `=====================\n\n`;
    
    Object.entries(data.vendorConfigurations).forEach(([vendor, config]) => {
      content += `${vendor.toUpperCase()}\n`;
      content += `${'-'.repeat(vendor.length)}\n`;
      content += `${config}\n\n`;
    });
    
    content += `DEPLOYMENT STEPS\n`;
    content += `===============\n\n`;
    
    data.deploymentSteps.forEach(step => {
      content += `${step.number}. ${step.title}\n`;
      content += `   ${step.description}\n\n`;
    });
    
    return content;
  },
  
  createHTMLContent: function(data) {
    let content = `<html><head><title>${data.projectName}</title></head><body>`;
    
    content += `<h1>${data.projectName}</h1>`;
    content += `<p><strong>Organization:</strong> ${data.organization}</p>`;
    content += `<p><strong>Date:</strong> ${data.date}</p>`;
    content += `<p><strong>Author:</strong> ${data.author}</p>`;
    
    content += `<h2>Vendor Configurations</h2>`;
    
    Object.entries(data.vendorConfigurations).forEach(([vendor, config]) => {
      content += `<h3>${vendor.charAt(0).toUpperCase() + vendor.slice(1)}</h3>`;
      content += `<pre>${config}</pre>`;
    });
    
    content += `<h2>Deployment Steps</h2>`;
    
    data.deploymentSteps.forEach(step => {
      content += `<div><strong>${step.number}. ${step.title}</strong></div>`;
      content += `<div>${step.description}</div><br>`;
    });
    
    content += `</body></html>`;
    
    return content;
  }
};

// Initialize the Document Generator when the DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  DocumentGenerator.init();
});

// Expose to global scope
window.DocumentGenerator = DocumentGenerator;
