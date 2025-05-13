/**
 * UaXSupreme - Update Index
 * Updates the index.html file to focus on a specific vendor
 */

// Import required modules
const fs = require('fs');
const path = require('path');

// Parse command line arguments
const args = process.argv.slice(2);
let selectedVendor = '';

// Parse arguments in the format --vendor=cisco
args.forEach(arg => {
    if (arg.startsWith('--vendor=')) {
        selectedVendor = arg.split('=')[1];
    }
});

// Validate vendor
const validVendors = ['cisco', 'aruba', 'juniper', 'fortinet', 'extreme', 'dell'];
if (!selectedVendor || !validVendors.includes(selectedVendor)) {
    console.log('Error: Valid vendor must be specified');
    console.log('Usage: node update-index.js --vendor=<vendor>');
    console.log('Available vendors:', validVendors.join(', '));
    process.exit(1);
}

// Path to index.html
const indexPath = path.join(__dirname, 'index.html');

// Check if index.html exists
if (!fs.existsSync(indexPath)) {
    console.log('Error: index.html file not found');
    process.exit(1);
}

// Read index.html content
let indexContent = fs.readFileSync(indexPath, 'utf8');

// Update vendor dropdown to preselect the specified vendor
indexContent = indexContent.replace(/<option value="([^"]+)"(\s*selected)?>/g, (match, vendor) => {
    if (vendor.toLowerCase() === selectedVendor.toLowerCase()) {
        return `<option value="${vendor}" selected>`;
    }
    return `<option value="${vendor}">`;
});

// Write updated content back to index.html
fs.writeFileSync(indexPath, indexContent);

console.log(`index.html updated to focus on ${selectedVendor}`);
