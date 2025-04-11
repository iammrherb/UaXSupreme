/**
 * Dot1Xer Supreme Enterprise Edition - Deployment Checklist Handler
 * Version 4.1.0
 * 
 * This module handles functionality for the 802.1X deployment checklist.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Deployment Checklist Handler...');
    
    // Load checklist content
    loadChecklistContent();
    
    // Set up event handlers
    setupChecklistEvents();
});

// Load checklist content into the modal
function loadChecklistContent() {
    const checklistContainer = document.getElementById('checklist-content');
    if (!checklistContainer) return;
    
    // Fetch the checklist HTML file
    fetch('templates/deployment-checklist.html')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to load checklist content');
            }
            return response.text();
        })
        .then(html => {
            // Insert the checklist HTML
            checklistContainer.innerHTML = html;
            
            // Initialize checklist functionality
            initializeChecklist();
            
            // Load saved checklist state
            loadChecklistState();
        })
        .catch(error => {
            console.error('Error loading checklist:', error);
            checklistContainer.innerHTML = `
                <div class="alert alert-danger">
                    <p>Failed to load deployment checklist. Please try again later.</p>
                    <p>Error: ${error.message}</p>
                </div>
            `;
        });
}

// Initialize checklist functionality
function initializeChecklist() {
    // Get all checkboxes
    const checkboxes = document.querySelectorAll('.checklist-item input[type="checkbox"]');
    if (!checkboxes.length) return;
    
    // Add change event to each checkbox to update progress
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', updateChecklistProgress);
    });
    
    // Set up save button
    const saveButton = document.getElementById('checklist-save');
    if (saveButton) {
        saveButton.addEventListener('click', saveChecklistState);
    }
    
    // Set up print button
    const printButton = document.getElementById('checklist-print');
    if (printButton) {
        printButton.addEventListener('click', printChecklist);
    }
    
    // Set up export button
    const exportButton = document.getElementById('checklist-export');
    if (exportButton) {
        exportButton.addEventListener('click', exportChecklistAsPDF);
    }
    
    // Update initial progress
    updateChecklistProgress();
}

// Update checklist progress
function updateChecklistProgress() {
    const checkboxes = document.querySelectorAll('.checklist-item input[type="checkbox"]');
    const progressBar = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    if (!checkboxes.length || !progressBar || !progressText) return;
    
    // Calculate progress
    const total = checkboxes.length;
    const checked = Array.from(checkboxes).filter(checkbox => checkbox.checked).length;
    const percentage = Math.round((checked / total) * 100);
    
    // Update progress bar and text
    progressBar.style.width = `${percentage}%`;
    progressText.textContent = `${percentage}% complete`;
}

// Save checklist state to localStorage
function saveChecklistState() {
    const checkboxes = document.querySelectorAll('.checklist-item input[type="checkbox"]');
    if (!checkboxes.length) return;
    
    // Create state object
    const state = {};
    checkboxes.forEach(checkbox => {
        state[checkbox.id] = checkbox.checked;
    });
    
    // Save to localStorage
    localStorage.setItem('dot1xer_checklist_state', JSON.stringify(state));
    
    // Show confirmation
    showAlert('Checklist progress saved successfully!', 'success');
}

// Load checklist state from localStorage
function loadChecklistState() {
    const checkboxes = document.querySelectorAll('.checklist-item input[type="checkbox"]');
    if (!checkboxes.length) return;
    
    // Get saved state
    const savedState = localStorage.getItem('dot1xer_checklist_state');
    if (!savedState) return;
    
    try {
        // Parse saved state
        const state = JSON.parse(savedState);
        
        // Update checkboxes
        checkboxes.forEach(checkbox => {
            if (state[checkbox.id] !== undefined) {
                checkbox.checked = state[checkbox.id];
            }
        });
        
        // Update progress
        updateChecklistProgress();
    } catch (error) {
        console.error('Error loading checklist state:', error);
    }
}

// Print checklist
function printChecklist() {
    window.print();
}

// Export checklist as PDF
function exportChecklistAsPDF() {
    // Check if jsPDF is available
    if (typeof jspdf === 'undefined' || typeof jspdf.jsPDF === 'undefined') {
        showAlert('PDF export library not available. Please try again later.', 'warning');
        return;
    }
    
    try {
        const { jsPDF } = jspdf;
        const doc = new jsPDF();
        
        // Set document properties
        doc.setProperties({
            title: '802.1X Deployment Checklist',
            subject: 'Deployment Checklist',
            author: 'Dot1Xer Supreme Enterprise Edition',
            keywords: '802.1X, Checklist, Deployment',
            creator: 'Dot1Xer Supreme'
        });
        
        // Add title
        doc.setFontSize(18);
        doc.text('802.1X Deployment Checklist', 105, 20, { align: 'center' });
        
        // Add date
        doc.setFontSize(12);
        doc.text(`Generated: ${new Date().toLocaleDateString()}`, 105, 30, { align: 'center' });
        
        // Add sections
        let y = 45;
        
        // Get all sections
        const sections = document.querySelectorAll('.checklist-section');
        
        sections.forEach(section => {
            // Check if we need a new page
            if (y > 250) {
                doc.addPage();
                y = 20;
            }
            
            // Add section title
            const sectionTitle = section.querySelector('h3').textContent;
            doc.setFontSize(14);
            doc.setFont(undefined, 'bold');
            doc.text(sectionTitle, 20, y);
            y += 10;
            
            // Add section items
            doc.setFontSize(12);
            doc.setFont(undefined, 'normal');
            
            const items = section.querySelectorAll('.checklist-item');
            items.forEach(item => {
                // Check if we need a new page
                if (y > 275) {
                    doc.addPage();
                    y = 20;
                }
                
                const checkbox = item.querySelector('input[type="checkbox"]');
                const label = item.querySelector('label').textContent;
                
                // Draw checkbox
                doc.rect(20, y - 4, 4, 4);
                
                // Fill checkbox if checked
                if (checkbox.checked) {
                    doc.setFillColor(0, 119, 204);
                    doc.rect(20, y - 4, 4, 4, 'F');
                }
                
                // Add label text
                doc.text(label, 30, y);
                y += 8;
            });
            
            y += 10;
        });
        
        // Add footer
        const pageCount = doc.getNumberOfPages();
        for (let i = 1; i <= pageCount; i++) {
            doc.setPage(i);
            doc.setFontSize(10);
            doc.text(`Dot1Xer Supreme Enterprise Edition - Page ${i} of ${pageCount}`, 105, 290, { align: 'center' });
        }
        
        // Save the PDF
        doc.save('802.1X_Deployment_Checklist.pdf');
        
        showAlert('Checklist exported as PDF successfully!', 'success');
    } catch (error) {
        console.error('Error exporting PDF:', error);
        showAlert('Error exporting PDF: ' + error.message, 'danger');
    }
}

// Set up checklist event handlers
function setupChecklistEvents() {
    // Checklist link in main navigation
    const checklistLink = document.getElementById('checklist-link');
    if (checklistLink) {
        checklistLink.addEventListener('click', function(e) {
            e.preventDefault();
            showChecklistModal();
        });
    }
    
    // Checklist tool button
    const checklistTool = document.getElementById('checklist-tool');
    if (checklistTool) {
        checklistTool.addEventListener('click', function(e) {
            e.preventDefault();
            showChecklistModal();
        });
    }
    
    // Close button
    const closeButton = document.getElementById('checklist-modal-close');
    if (closeButton) {
        closeButton.addEventListener('click', function() {
            hideChecklistModal();
        });
    }
    
    // Close link
    const closeLink = document.getElementById('checklist-close');
    if (closeLink) {
        closeLink.addEventListener('click', function(e) {
            e.preventDefault();
            hideChecklistModal();
        });
    }
}

// Show checklist modal
function showChecklistModal() {
    const modal = document.getElementById('checklist-modal');
    if (modal) {
        modal.classList.add('visible');
    }
}

// Hide checklist modal
function hideChecklistModal() {
    const modal = document.getElementById('checklist-modal');
    if (modal) {
        modal.classList.remove('visible');
    }
}

// Helper function to show alerts
function showAlert(message, type = 'info') {
    // Check if global showAlert function exists
    if (typeof window.showAlert === 'function') {
        window.showAlert(message, type);
        return;
    }
    
    // Fallback alert
    alert(message);
}
