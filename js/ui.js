/**
 * Dot1Xer Supreme Enterprise Edition - UI JavaScript
 * Version 4.0.0
 * 
 * This file contains UI-specific functionality
 */

// Initialize UI when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing UI components...');
    
    // Set up expandable sections if not already handled
    initExpandableSections();
    
    // Initialize video banner
    initVideoBanner();
});

// Initialize expandable sections
function initExpandableSections() {
    const headers = document.querySelectorAll('.expandable-header');
    if (!headers.length) return;
    
    headers.forEach(header => {
        if (!header.hasAttribute('data-initialized')) {
            header.setAttribute('data-initialized', 'true');
            
            header.addEventListener('click', () => {
                header.classList.toggle('active');
                
                const content = header.nextElementSibling;
                if (content && content.classList.contains('expandable-content')) {
                    content.style.display = content.style.display === 'block' ? 'none' : 'block';
                }
            });
        }
    });
}

// Initialize video banner
function initVideoBanner() {
    const banner = document.getElementById('video-banner');
    if (!banner) return;
    
    // If banner is empty, add placeholder
    if (banner.children.length === 0) {
        banner.innerHTML = `
            <div class="video-banner-placeholder">
                <div class="banner-content">
                    <h1>Dot1Xer Supreme</h1>
                    <p>Complete 802.1X Configuration & Management</p>
                </div>
            </div>
        `;
    }
}
