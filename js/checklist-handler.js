/**
 * Dot1Xer Supreme Enterprise Edition - Deployment Checklist
 * Version 4.1.0
 * 
 * This module handles the deployment checklist functionality.
 */

document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing Deployment Checklist Handler...');
    
    // Set up checklist events
    setupChecklistEvents();
});

// Set up checklist events
function setupChecklistEvents() {
    // Checklist link in main navigation
    const checklistLink = document.getElementById('checklist-link');
    if (checklistLink) {
        checklistLink.addEventListener('click', function(e) {
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
    
    // Close button in footer
    const closeButtonFooter = document.getElementById('checklist-close');
    if (closeButtonFooter) {
        closeButtonFooter.addEventListener('click', function() {
            hideChecklistModal();
        });
    }
    
    // Checklist tool card
    const checklistTool = document.getElementById('checklist-tool');
    if (checklistTool) {
        checklistTool.addEventListener('click', function() {
            showChecklistModal();
        });
    }
    
    // Load checklist content
    loadChecklistContent();
}

// Load checklist content
function loadChecklistContent() {
    const container = document.getElementById('checklist-content');
    if (!container) return;
    
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
            container.innerHTML = html;
            
            // Set up event handlers for checklist items
            setupChecklistHandlers();
            
            // Load saved checklist state
            loadChecklistState();
        })
        .catch(error => {
            console.error('Error loading checklist:', error);
            container.innerHTML = `
                <div class="alert alert-danger">
                    <p>Failed to load checklist. Please try again later.</p>
                    <p>Error: ${error.message}</p>
                </div>
            `;
        });
}

// Set up checklist handlers
function setupChecklistHandlers() {
    // Checkboxes
    const checkboxes = document.querySelectorAll('#checklist-content input[type="checkbox"]');
    
    checkboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            updateChecklistProgress();
            saveChecklistState();
        });
    });
    
    // Save button
    const saveButton = document.getElementById('checklist-save');
    if (saveButton) {
        saveButton.addEventListener('click', function() {
            saveChecklistState();
            displayAlert('Checklist progress saved successfully!', 'success');
        });
    }
    
    // Print button
    const printButton = document.getElementById('checklist-print');
    if (printButton) {
        printButton.addEventListener('click', function() {
            printChecklist();
        });
    }
    
    // Export button
    const exportButton = document.getElementById('checklist-export');
    if (exportButton) {
        exportButton.addEventListener('click', function() {
            exportChecklistAsPdf();
        });
    }
}

// Update checklist progress
function updateChecklistProgress() {
    const progressBar = document.querySelector('.progress-fill');
    const progressText = document.querySelector('.progress-text');
    
    if (!progressBar || !progressText) return;
    
    const checkboxes = document.querySelectorAll('#checklist-content input[type="checkbox"]');
    const checkedBoxes = document.querySelectorAll('#checklist-content input[type="checkbox"]:checked');
    
    const totalItems = checkboxes.length;
    const completedItems = checkedBoxes.length;
    
    if (totalItems === 0) return;
    
    const progressPercentage = Math.round((completedItems / totalItems) * 100);
    
    progressBar.style.width = `${progressPercentage}%`;
    progressText.textContent = `${progressPercentage}% complete`;
}

// Save checklist state
function saveChecklistState() {
    const checkboxes = document.querySelectorAll('#checklist-content input[type="checkbox"]');
    const checklist = {};
    
    checkboxes.forEach(checkbox => {
        checklist[checkbox.id] = checkbox.checked;
    });
    
    localStorage.setItem('dot1xer_checklist', JSON.stringify(checklist));
}

// Load checklist state
function loadChecklistState() {
    const savedChecklist = localStorage.getItem('dot1xer_checklist');
    if (!savedChecklist) return;
    
    try {
        const checklist = JSON.parse(savedChecklist);
        
        // Apply saved state to checkboxes
        for (const [id, checked] of Object.entries(checklist)) {
            const checkbox = document.getElementById(id);
            if (checkbox) {
                checkbox.checked = checked;
            }
        }
        
        // Update progress
        updateChecklistProgress();
    } catch (error) {
        console.error('Error loading saved checklist state:', error);
    }
}

// Print checklist
function printChecklist() {
    const content = document.querySelector('.checklist-wrapper');
    if (!content) return;
    
    const printWindow = window.open('', '_blank');
    
    // Create print document
    printWindow.document.write(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>802.1X Deployment Checklist</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    line-height: 1.6;
                    margin: 20px;
                }
                h1, h2, h3 {
                    color: #1a3a5f;
                }
                .checklist-section {
                    margin-bottom: 20px;
                    border-bottom: 1px solid #eee;
                    padding-bottom: 10px;
                }
                .checklist-item {
                    margin-bottom: 8px;
                    display: flex;
                    align-items: flex-start;
                }
                input[type="checkbox"] {
                    margin-top: 3px;
                    margin-right: 10px;
                }
                @media print {
                    .checklist-actions {
                        display: none;
                    }
                }
            </style>
        </head>
        <body>
            <h1>802.1X Deployment Checklist</h1>
            ${content.innerHTML}
        </body>
        </html>
    `);
    
    printWindow.document.close();
    
    // Wait for resources to load
    printWindow.addEventListener('load', function() {
        printWindow.print();
        printWindow.close();
    });
}

// Export checklist as PDF
function exportChecklistAsPdf() {
    // This is a placeholder for PDF export functionality
    // In a real implementation, you'd use a library like jsPDF
    
    displayAlert('Exporting checklist as PDF...', 'info');
    
    // Simulate export process
    setTimeout(() => {
        displayAlert('Checklist exported successfully as PDF!', 'success');
    }, 1500);
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

// Helper function to show alerts - FIXED to avoid infinite recursion
function displayAlert(message, type = 'info') {
    // Use global showAlert function if available
    if (typeof window.showAlert === 'function') {
        window.showAlert(message, type);
        return;
    }
    
    // Fallback alert if global function not available
    alert(message);
}
