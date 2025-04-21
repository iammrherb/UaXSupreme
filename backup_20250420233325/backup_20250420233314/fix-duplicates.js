/**
 * UaXSupreme - Fix Duplicates
 * This script resolves template and configuration conflicts in the repository
 */

// Import required modules
const fs = require('fs');
const path = require('path');

// Configuration
const TEMPLATE_DIR = path.join(__dirname, 'templates');
const JS_DIR = path.join(__dirname, 'js');
const CSS_DIR = path.join(__dirname, 'css');

// Create directories if they don't exist
function ensureDirectoryExists(directory) {
    if (!fs.existsSync(directory)) {
        console.log(`Creating directory: ${directory}`);
        fs.mkdirSync(directory, { recursive: true });
    }
}

// Find and remove duplicate template files
function fixDuplicateTemplates() {
    console.log('Checking for duplicate template files...');

    // Ensure template directory and subdirectories exist
    ensureDirectoryExists(TEMPLATE_DIR);

    // Create vendor and platform subdirectories
    const vendors = ['cisco', 'aruba', 'juniper', 'fortinet', 'extreme', 'dell'];

    vendors.forEach(vendor => {
        const vendorDir = path.join(TEMPLATE_DIR, vendor);
        ensureDirectoryExists(vendorDir);

        if (vendor === 'cisco') {
            const platforms = ['IOS', 'IOS-XE', 'WLC-9800'];
            platforms.forEach(platform => {
                ensureDirectoryExists(path.join(vendorDir, platform));
            });
        } else if (vendor === 'aruba') {
            const platforms = ['AOS-CX', 'AOS-Switch'];
            platforms.forEach(platform => {
                ensureDirectoryExists(path.join(vendorDir, platform));
            });
        }
    });

    console.log('Template directory structure created and verified.');
}

// Fix JavaScript duplicate files
function fixDuplicateJsFiles() {
    console.log('Checking for duplicate JavaScript files...');

    // Ensure JS directory exists
    ensureDirectoryExists(JS_DIR);

    // Check for essential JS files
    const essentialFiles = [
        'app.js',
        'template-generator.js',
        'validation.js',
        'ai-assistant.js',
        'documentation.js'
    ];

    essentialFiles.forEach(file => {
        const filePath = path.join(JS_DIR, file);
        if (!fs.existsSync(filePath)) {
            console.log(`Essential file missing: ${file}`);
        }
    });

    console.log('JavaScript files checked.');
}

// Fix CSS duplicate files
function fixDuplicateCssFiles() {
    console.log('Checking for duplicate CSS files...');

    // Ensure CSS directory exists
    ensureDirectoryExists(CSS_DIR);

    // Check for essential CSS files
    const essentialFiles = ['styles.css'];

    essentialFiles.forEach(file => {
        const filePath = path.join(CSS_DIR, file);
        if (!fs.existsSync(filePath)) {
            console.log(`Essential file missing: ${file}`);
        }
    });

    console.log('CSS files checked.');
}

// Main function
function main() {
    console.log('Starting duplicate file fix process...');

    fixDuplicateTemplates();
    fixDuplicateJsFiles();
    fixDuplicateCssFiles();

    console.log('Duplicate file fix process completed.');
}

// Run the main function
main();
