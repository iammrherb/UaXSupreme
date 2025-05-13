/**
 * UaXSupreme - Logo Generator
 * Creates an animated logo for the application header
 */

(function() {
    'use strict';

    // Logo Generator object
    const LogoGenerator = {
        /**
         * Initialize Logo Generator
         */
        init: function() {
            console.log('Initializing Logo Generator...');
            this.setupLogo();
        },
        
        /**
         * Set up animated logo
         */
        setupLogo: function() {
            const logoCanvas = document.getElementById('logoCanvas');
            if (!logoCanvas) return;
            
            // Clear any previous content
            logoCanvas.innerHTML = '';
            
            // Create canvas element
            const canvas = document.createElement('canvas');
            canvas.width = 50;
            canvas.height = 50;
            logoCanvas.appendChild(canvas);
            
            // Get canvas context
            const ctx = canvas.getContext('2d');
            
            // Set up animation
            this.animateLogo(ctx, canvas.width, canvas.height);
        },
        
        /**
         * Animate the logo
         * @param {CanvasRenderingContext2D} ctx - Canvas context
         * @param {number} width - Canvas width
         * @param {number} height - Canvas height
         */
        animateLogo: function(ctx, width, height) {
            const centerX = width / 2;
            const centerY = height / 2;
            const radius = Math.min(width, height) / 2 - 2;
            
            // Animation variables
            let rotation = 0;
            let locked = false;
            let lockAnimation = 0;
            
            // Animation function
            function animate() {
                // Clear canvas
                ctx.clearRect(0, 0, width, height);
                
                // Draw outer circle
                ctx.beginPath();
                ctx.arc(centerX, centerY, radius, 0, Math.PI * 2);
                ctx.fillStyle = '#3498db';
                ctx.fill();
                
                // Draw lock icon when animation completes
                if (locked) {
                    // Draw lock body
                    ctx.beginPath();
                    ctx.rect(centerX - 10, centerY - 5, 20, 15);
                    ctx.fillStyle = '#2c3e50';
                    ctx.fill();
                    
                    // Draw lock shackle
                    ctx.beginPath();
                    ctx.arc(centerX, centerY - 10, 8, Math.PI, Math.PI * 2);
                    ctx.lineWidth = 3;
                    ctx.strokeStyle = '#2c3e50';
                    ctx.stroke();
                    
                    // Draw keyhole
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, 3, 0, Math.PI * 2);
                    ctx.fillStyle = '#3498db';
                    ctx.fill();
                    
                    // Continue lock appearing animation
                    lockAnimation += 0.05;
                    if (lockAnimation < 1) {
                        requestAnimationFrame(animate);
                    }
                    
                    // Apply fade-in effect
                    ctx.globalAlpha = lockAnimation;
                } else {
                    // Draw rotating shield segments
                    for (let i = 0; i < 4; i++) {
                        ctx.beginPath();
                        ctx.moveTo(centerX, centerY);
                        ctx.arc(centerX, centerY, radius, 
                              rotation + i * Math.PI / 2, 
                              rotation + i * Math.PI / 2 + Math.PI / 3);
                        ctx.closePath();
                        
                        // Alternate colors
                        ctx.fillStyle = i % 2 === 0 ? '#2c3e50' : '#2ecc71';
                        ctx.fill();
                    }
                    
                    // Update rotation
                    rotation += 0.05;
                    
                    // Check if animation should complete
                    if (rotation >= Math.PI * 6) {
                        locked = true;
                        lockAnimation = 0;
                    }
                    
                    // Continue rotation animation
                    requestAnimationFrame(animate);
                }
            }
            
            // Start animation
            animate();
        }
    };

    // Initialize Logo Generator on page load
    document.addEventListener('DOMContentLoaded', function() {
        LogoGenerator.init();
    });

    // Export to window
    window.LogoGenerator = LogoGenerator;
})();
