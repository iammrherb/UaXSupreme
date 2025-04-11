// This script updates the index.html file to load init.js first
const fs = require('fs');
const path = require('path');

const indexPath = path.join(__dirname, 'index.html');

try {
    let indexContent = fs.readFileSync(indexPath, 'utf8');
    
    // Remove old script loading
    indexContent = indexContent.replace(/<script src="js\/.*?"><\/script>/g, '');
    
    // Add init.js script tag before closing body tag
    indexContent = indexContent.replace('</body>', '    <script src="js/init.js"></script>\n</body>');
    
    fs.writeFileSync(indexPath, indexContent);
    console.log('Successfully updated index.html to load init.js');
} catch (error) {
    console.error('Error updating index.html:', error);
}
