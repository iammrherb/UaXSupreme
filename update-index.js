// This script updates the index.html file to load vendors.js first
const fs = require('fs');
const path = require('path');

const indexPath = path.join(__dirname, 'index.html');

try {
    let indexContent = fs.readFileSync(indexPath, 'utf8');
    
    // Add vendors.js before main.js
    if (indexContent.includes('<script src="js/main.js"></script>') && 
        !indexContent.includes('<script src="js/vendors.js"></script>')) {
        
        indexContent = indexContent.replace(
            '<script src="js/main.js"></script>', 
            '<script src="js/vendors.js"></script>\n    <script src="js/main.js"></script>'
        );
        
        fs.writeFileSync(indexPath, indexContent);
        console.log('Successfully updated index.html to load vendors.js first');
    } else {
        console.log('No update needed or vendors.js already included');
    }
} catch (error) {
    console.error('Error updating index.html:', error);
}
