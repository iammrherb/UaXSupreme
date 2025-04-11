// Fix duplicate script loading in index.html
const fs = require('fs');
const path = require('path');

const indexPath = path.join(__dirname, 'index.html');

try {
    let content = fs.readFileSync(indexPath, 'utf8');
    
    // Remove duplicate script tags
    const scriptTags = {
        'vendors.js': 0,
        'help.js': 0,
        'questionnaire.js': 0,
        'main.js': 0,
        'ui.js': 0,
        'config-generator.js': 0,
        'diagrams.js': 0,
        'checklist-handler.js': 0
    };
    
    // Find all script tags
    const scriptRegex = /<script src="js\/([^"]+)"><\/script>/g;
    let match;
    let newContent = content;
    
    // First pass: count occurrences
    while ((match = scriptRegex.exec(content)) !== null) {
        const script = match[1];
        if (scriptTags.hasOwnProperty(script)) {
            scriptTags[script]++;
        }
    }
    
    // Second pass: remove duplicates
    for (const [script, count] of Object.entries(scriptTags)) {
        if (count > 1) {
            console.log(`Removing ${count - 1} duplicate(s) of ${script}`);
            
            // Create regex that matches all occurrences of this script tag
            const tagRegex = new RegExp(`<script src="js/${script}"><\\/script>`, 'g');
            
            // Replace all occurrences with empty string temporarily
            newContent = newContent.replace(tagRegex, '');
            
            // Add back exactly one instance before the closing body tag
            newContent = newContent.replace('</body>', `    <script src="js/${script}"></script>\n</body>`);
        }
    }
    
    // Write back the cleaned-up content
    fs.writeFileSync(indexPath, newContent);
    console.log('Successfully removed duplicate script tags');
} catch (error) {
    console.error('Error fixing duplicate script tags:', error);
}
