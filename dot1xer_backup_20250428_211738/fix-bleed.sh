#!/bin/bash
# UaXSupreme-fix-script-bleed.sh - Script to fix the shell script content bleeding onto the webpage

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme Fix]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Create backup of index.html
print_message "Creating backup of index.html..."
cp index.html index.html.bak.$(date +"%Y%m%d%H%M%S")
print_success "Backup created"

# Fix the script bleed by removing shell script content from HTML file
print_message "Cleaning script content from HTML file..."

# Create a temporary file with clean HTML (without shell script content)
# Look for the closing HTML tag and remove everything after it
awk '
  BEGIN { found_html_end = 0 }
  /<\/html>/ { found_html_end = 1; print; next }
  found_html_end == 0 { print }
' index.html > index.html.clean

# Also handle the case where </html> might be missing
# Look for common shell script patterns and remove them
grep -v "#!/bin/bash" index.html.clean > index.html.clean2
grep -v "print_message" index.html.clean2 > index.html.clean3
grep -v "print_success" index.html.clean3 > index.html.clean4
grep -v "print_warning" index.html.clean4 > index.html.clean5
grep -v "print_error" index.html.clean5 > index.html.clean6

# Replace the original file with the cleaned version
mv index.html.clean6 index.html

# Clean up temporary files
rm -f index.html.clean*

# Ensure the HTML file is properly closed
if ! grep -q "</html>" index.html; then
  print_message "Adding closing HTML tag..."
  echo "</body>" >> index.html
  echo "</html>" >> index.html
fi

# Create a diagnostic HTML file to help identify script bleed causes
print_message "Creating script bleed diagnostic tool..."

cat > detect-script-bleed.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>UaXSupreme Script Bleed Detector</title>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; }
    h1 { color: #2c3e50; }
    pre { background-color: #f5f5f5; padding: 10px; border-radius: 4px; overflow-x: auto; }
    .issue { color: #e74c3c; font-weight: bold; }
    .success { color: #27ae60; font-weight: bold; }
    button { padding: 10px 15px; background-color: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; }
    button:hover { background-color: #2980b9; }
    #results { margin-top: 20px; }
  </style>
</head>
<body>
  <h1>UaXSupreme Script Bleed Detector</h1>
  <p>This tool helps identify script content that may be embedded in your HTML files.</p>
  
  <button id="check-button">Check for Script Bleed</button>
  
  <div id="results"></div>

  <script>
    document.getElementById('check-button').addEventListener('click', function() {
      const resultsDiv = document.getElementById('results');
      resultsDiv.innerHTML = '<h2>Checking for script bleed...</h2>';
      
      // Get the entire HTML content
      const htmlContent = document.documentElement.outerHTML;
      
      // Check for common shell script patterns
      const shellPatterns = [
        '#!/bin/bash',
        'print_message',
        'print_success',
        'print_warning',
        'print_error',
        'function',
        'echo -e',
        'if [',
        'for (',
        'while [',
        'EOF',
        'cat >'
      ];
      
      let foundIssues = false;
      let resultsHTML = '<h2>Results:</h2>';
      
      shellPatterns.forEach(pattern => {
        if (htmlContent.includes(pattern)) {
          foundIssues = true;
          resultsHTML += `<p class="issue">Found shell script pattern: <code>${pattern}</code></p>`;
        }
      });
      
      // Check for content after closing HTML tag
      const htmlEndPos = htmlContent.indexOf('</html>');
      if (htmlEndPos !== -1 && htmlEndPos < htmlContent.length - 7) {
        foundIssues = true;
        const extraContent = htmlContent.substring(htmlEndPos + 7);
        resultsHTML += `<p class="issue">Found content after closing HTML tag:</p>`;
        resultsHTML += `<pre>${extraContent.substring(0, 200)}${extraContent.length > 200 ? '...' : ''}</pre>`;
      }
      
      if (!foundIssues) {
        resultsHTML += `<p class="success">No script bleed detected!</p>`;
      } else {
        resultsHTML += `
          <h3>How to fix:</h3>
          <ol>
            <li>Run the UaXSupreme-fix-script-bleed.sh script</li>
            <li>Manually edit index.html to remove any remaining script content</li>
            <li>Ensure your shell scripts don't append content to HTML files</li>
          </ol>
        `;
      }
      
      resultsDiv.innerHTML = resultsHTML;
    });
  </script>
</body>
</html>
EOF

# Create a fix script specifically for cleaning the HTML file
print_message "Creating fix script for HTML cleanup..."

cat > fix-script-bleed.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>UaXSupreme Script Bleed Fixer</title>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; }
    h1, h2 { color: #2c3e50; }
    pre { background-color: #f5f5f5; padding: 10px; border-radius: 4px; overflow-x: auto; }
    .issue { color: #e74c3c; }
    .success { color: #27ae60; }
    button { padding: 10px 15px; background-color: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; }
    button:hover { background-color: #2980b9; }
    textarea { width: 100%; height: 300px; margin: 10px 0; padding: 10px; font-family: monospace; }
    #results { margin-top: 20px; }
  </style>
</head>
<body>
  <h1>UaXSupreme Script Bleed Fixer</h1>
  <p>This tool helps clean script content from your HTML file.</p>
  
  <div>
    <button id="load-button">Load Current HTML</button>
    <button id="fix-button">Clean Script Content</button>
    <button id="save-button">Generate Clean HTML</button>
  </div>
  
  <h2>HTML Content</h2>
  <textarea id="html-content"></textarea>
  
  <div id="results"></div>

  <script>
    document.getElementById('load-button').addEventListener('click', function() {
      fetch(window.location.origin + '/index.html')
        .then(response => response.text())
        .then(html => {
          document.getElementById('html-content').value = html;
        })
        .catch(error => {
          document.getElementById('results').innerHTML = `
            <p class="issue">Error loading HTML: ${error}</p>
          `;
        });
    });
    
    document.getElementById('fix-button').addEventListener('click', function() {
      const htmlContent = document.getElementById('html-content').value;
      const resultsDiv = document.getElementById('results');
      
      // Find the closing HTML tag position
      const htmlEndPos = htmlContent.indexOf('</html>');
      
      if (htmlEndPos !== -1) {
        // Keep only content up to </html>
        const cleanedHTML = htmlContent.substring(0, htmlEndPos + 7);
        document.getElementById('html-content').value = cleanedHTML;
        
        resultsDiv.innerHTML = `
          <p class="success">HTML cleaned! All content after closing HTML tag has been removed.</p>
        `;
      } else {
        // If </html> tag not found, try to clean common script patterns
        let cleanedHTML = htmlContent;
        
        // Remove shell script patterns
        const shellPatterns = [
          '#!/bin/bash',
          'print_message\\([^)]*\\)',
          'print_success\\([^)]*\\)',
          'print_warning\\([^)]*\\)',
          'print_error\\([^)]*\\)',
          'function [a-zA-Z0-9_]+\\(\\)',
          'echo -e',
          'if \\[',
          'for \\(',
          'while \\[',
          'cat >',
          'EOF'
        ];
        
        shellPatterns.forEach(pattern => {
          cleanedHTML = cleanedHTML.replace(new RegExp(pattern, 'g'), '');
        });
        
        document.getElementById('html-content').value = cleanedHTML;
        
        resultsDiv.innerHTML = `
          <p class="issue">No closing HTML tag found. Basic script pattern removal applied.</p>
          <p>You may need to manually add closing tags:</p>
          <pre>&lt;/body&gt;
&lt;/html&gt;</pre>
        `;
      }
    });
    
    document.getElementById('save-button').addEventListener('click', function() {
      const htmlContent = document.getElementById('html-content').value;
      const blob = new Blob([htmlContent], { type: 'text/html' });
      const url = URL.createObjectURL(blob);
      
      const a = document.createElement('a');
      a.href = url;
      a.download = 'clean-index.html';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
      
      document.getElementById('results').innerHTML = `
        <p class="success">Clean HTML file generated. Download should start automatically.</p>
        <p>Save this file as index.html in your UaXSupreme directory to replace the current version.</p>
      `;
    });
  </script>
</body>
</html>
EOF

# Create a script to fix script bleeding by hiding script blocks
print_message "Creating hide-script-blocks tool..."

cat > hide-script-blocks.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>UaXSupreme Hide Script Blocks</title>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; }
    h1, h2 { color: #2c3e50; }
    pre { background-color: #f5f5f5; padding: 10px; border-radius: 4px; overflow-x: auto; }
    .success { color: #27ae60; font-weight: bold; }
    .warning { color: #f39c12; font-weight: bold; }
    .script-control { display: flex; align-items: center; margin-bottom: 10px; }
    .script-control input { margin-right: 10px; }
    button { padding: 10px 15px; background-color: #3498db; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 10px; }
    button:hover { background-color: #2980b9; }
    #results { margin-top: 20px; }
  </style>
</head>
<body>
  <h1>UaXSupreme Hide Script Blocks</h1>
  <p>This tool detects and allows you to hide script blocks that might be causing display issues.</p>
  
  <button id="detect-button">Detect Script Blocks</button>
  
  <div id="script-blocks"></div>
  <div id="controls" style="margin-top: 20px; display: none;">
    <button id="hide-selected">Hide Selected Script Blocks</button>
    <button id="hide-all">Hide All Script Blocks</button>
  </div>
  
  <div id="results"></div>

  <script>
    // Function to sanitize HTML for display
    function escapeHTML(html) {
      return html
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;')
        .replace(/'/g, '&#039;');
    }
    
    document.getElementById('detect-button').addEventListener('click', function() {
      const scriptBlocks = document.querySelectorAll('script');
      const scriptBlocksDiv = document.getElementById('script-blocks');
      const controlsDiv = document.getElementById('controls');
      const resultsDiv = document.getElementById('results');
      
      if (scriptBlocks.length === 0) {
        resultsDiv.innerHTML = '<p class="warning">No script blocks found on the page.</p>';
        return;
      }
      
      let scriptBlocksHTML = '<h2>Detected Script Blocks</h2>';
      
      scriptBlocks.forEach((script, index) => {
        const source = script.src ? `External: ${script.src}` : 'Inline script';
        const content = script.innerHTML.substring(0, 100) + (script.innerHTML.length > 100 ? '...' : '');
        
        scriptBlocksHTML += `
          <div class="script-control">
            <input type="checkbox" id="script-${index}" data-index="${index}">
            <label for="script-${index}">
              <strong>Script ${index + 1}:</strong> ${source}
              <pre>${escapeHTML(content)}</pre>
            </label>
          </div>
        `;
      });
      
      scriptBlocksDiv.innerHTML = scriptBlocksHTML;
      controlsDiv.style.display = 'block';
      
      resultsDiv.innerHTML = `
        <p class="success">Found ${scriptBlocks.length} script blocks. Select the ones you want to hide and click "Hide Selected Script Blocks".</p>
      `;
    });
    
    document.getElementById('hide-selected').addEventListener('click', function() {
      const checkboxes = document.querySelectorAll('input[type="checkbox"]:checked');
      const resultsDiv = document.getElementById('results');
      
      if (checkboxes.length === 0) {
        resultsDiv.innerHTML += '<p class="warning">No script blocks selected.</p>';
        return;
      }
      
      const scriptBlocks = document.querySelectorAll('script');
      const indices = Array.from(checkboxes).map(cb => parseInt(cb.getAttribute('data-index')));
      
      indices.forEach(index => {
        if (index < scriptBlocks.length) {
          scriptBlocks[index].style.display = 'none';
        }
      });
      
      resultsDiv.innerHTML = `
        <p class="success">Hidden ${indices.length} selected script blocks.</p>
        <p>To permanently fix this issue, you should edit your HTML file to properly structure and close all script tags.</p>
      `;
    });
    
    document.getElementById('hide-all').addEventListener('click', function() {
      const scriptBlocks = document.querySelectorAll('script');
      const resultsDiv = document.getElementById('results');
      
      scriptBlocks.forEach(script => {
        script.style.display = 'none';
      });
      
      resultsDiv.innerHTML = `
        <p class="success">Hidden all ${scriptBlocks.length} script blocks.</p>
        <p>To permanently fix this issue, you should edit your HTML file to properly structure and close all script tags.</p>
      `;
    });
  </script>
</body>
</html>
EOF

# Create a shell script to clean index.html file properly
print_message "Creating a shell script to clean index.html..."

cat > clean-index.html.sh << 'EOF'
#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme Fix]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Create backup
print_message "Creating backup of index.html..."
BACKUP_FILE="index.html.bak.$(date +"%Y%m%d%H%M%S")"
cp index.html "$BACKUP_FILE"
print_success "Backup created: $BACKUP_FILE"

# Clean the index.html file
print_message "Cleaning index.html file..."

# Extract HTML content up to the closing </html> tag
sed -n '1,/<\/html>/p' index.html > index.html.clean

# Check if we found the closing HTML tag
if grep -q "</html>" index.html.clean; then
  print_success "Found closing HTML tag"
else
  print_warning "No closing HTML tag found, will attempt to clean known script patterns"
  
  # If no </html> tag, try to remove script content
  grep -v "#!/bin/bash" index.html > index.html.clean
  grep -v "print_message" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_success" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_warning" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_error" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "function" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "echo -e" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  
  # Add closing tags if missing
  echo "</body>" >> index.html.clean
  echo "</html>" >> index.html.clean
fi

# Replace the original with the cleaned version
mv index.html.clean index.html
print_success "index.html cleaned successfully"

print_message "You should now refresh your browser to see the changes"
EOF

# Make the cleanup script executable
chmod +x clean-index.html.sh

# Create a final fix bookmarklet for quick fixes
print_message "Creating a bookmarklet for quick fixes..."

cat > final-fix-bookmarklet.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>UaXSupreme Fix Bookmarklet</title>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; max-width: 800px; margin: 0 auto; }
    h1, h2 { color: #2c3e50; }
    .bookmarklet { display: inline-block; padding: 10px 15px; background-color: #3498db; color: white; border-radius: 4px; text-decoration: none; margin: 10px 0; }
    .instructions { background-color: #f8f9fa; padding: 15px; border-radius: 4px; }
    code { background-color: #f5f5f5; padding: 2px 4px; border-radius: 4px; }
  </style>
</head>
<body>
  <h1>UaXSupreme Fix Bookmarklet</h1>
  <p>Drag the bookmarklet below to your bookmarks bar. When you see script bleed on the UaXSupreme page, click the bookmarklet to fix it.</p>
  
  <a class="bookmarklet" href="javascript:(function(){
    // Find all text nodes in the body
    const walk = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
    const scriptPatterns = [
      /#!/,
      /print_message/,
      /print_success/,
      /print_warning/,
      /print_error/,
      /function [a-zA-Z0-9_]+\(\)/,
      /echo -e/
    ];
    
    // Check each text node for script content
    const nodesToRemove = [];
    while (node = walk.nextNode()) {
      const text = node.nodeValue;
      if (scriptPatterns.some(pattern => pattern.test(text))) {
        nodesToRemove.push(node);
      }
    }
    
    // Remove text nodes with script content
    nodesToRemove.forEach(node => {
      node.parentNode.removeChild(node);
    });
    
    // Create a notification
    const notification = document.createElement('div');
    notification.style.position = 'fixed';
    notification.style.bottom = '20px';
    notification.style.right = '20px';
    notification.style.padding = '10px 15px';
    notification.style.backgroundColor = '#27ae60';
    notification.style.color = 'white';
    notification.style.borderRadius = '4px';
    notification.style.zIndex = '9999';
    notification.textContent = `Removed ${nodesToRemove.length} script content nodes`;
    
    document.body.appendChild(notification);
    setTimeout(() => notification.remove(), 3000);
  })();">Fix Script Bleed</a>
  
  <h2>Instructions</h2>
  <div class="instructions">
    <ol>
      <li>Drag the "Fix Script Bleed" bookmarklet to your bookmarks bar</li>
      <li>When you see script content on the UaXSupreme page, click the bookmarklet</li>
      <li>The script will remove visible script content from the page</li>
      <li>This is a temporary fix for viewing the page - to permanently fix the issue, use the <code>clean-index.html.sh</code> script</li>
    </ol>
  </div>
  
  <h2>Permanent Solution</h2>
  <p>For a permanent fix, run the shell script created earlier:</p>
  <code>./clean-index.html.sh</code>
</body>
</html>
EOF

# Create a restore bookmarklet
print_message "Creating a restore bookmarklet..."

cat > restore-uaxsupreme-bookmarklet.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>UaXSupreme Restore Bookmarklet</title>
  <style>
    body { font-family: Arial, sans-serif; line-height: 1.6; padding: 20px; max-width: 800px; margin: 0 auto; }
    h1, h2 { color: #2c3e50; }
    .bookmarklet { display: inline-block; padding: 10px 15px; background-color: #3498db; color: white; border-radius: 4px; text-decoration: none; margin: 10px 0; }
    .instructions { background-color: #f8f9fa; padding: 15px; border-radius: 4px; }
    code { background-color: #f5f5f5; padding: 2px 4px; border-radius: 4px; }
  </style>
</head>
<body>
  <h1>UaXSupreme Restore Bookmarklet</h1>
  <p>This bookmarklet will rebuild the UaXSupreme interface directly in the browser.</p>
  
  <a class="bookmarklet" href="javascript:(function(){
    // Create clean HTML structure
    document.body.innerHTML = `
    <header>
      <nav class='navbar navbar-expand-lg navbar-dark bg-primary'>
        <div class='container-fluid'>
          <a class='navbar-brand' href='#'>UaXSupreme</a>
          <small class='text-light'>Ultimate Authentication Platform</small>
          <div class='d-flex'>
            <button class='btn btn-light btn-sm mr-2 ai-assistant-button' title='AI Assistant'>
              <i class='fas fa-robot'></i>
            </button>
            <button class='btn btn-light btn-sm mr-2 help-button' title='Help'>
              <i class='fas fa-question-circle'></i>
            </button>
            <button class='btn btn-light btn-sm mr-2 settings-button' title='Settings'>
              <i class='fas fa-cog'></i>
            </button>
          </div>
        </div>
      </nav>
    </header>

    <div class='container-fluid'>
      <div class='row'>
        <!-- Sidebar Navigation -->
        <nav class='col-md-3 col-lg-2 d-md-block bg-light sidebar'>
          <div class='sidebar-sticky'>
            <h6 class='sidebar-heading'>Configuration Steps</h6>
            <ul class='nav flex-column'>
              <li class='nav-item'>
                <a class='nav-link active' href='#vendor-selection'>
                  <i class='fas fa-server'></i> Vendor Selection
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#authentication-methods'>
                  <i class='fas fa-key'></i> Authentication Methods
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#radius-configuration'>
                  <i class='fas fa-broadcast-tower'></i> RADIUS Configuration
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#tacacs-configuration'>
                  <i class='fas fa-user-shield'></i> TACACS+ Configuration
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#advanced-features'>
                  <i class='fas fa-sliders-h'></i> Advanced Features
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#interfaces'>
                  <i class='fas fa-network-wired'></i> Interfaces
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#generate-configuration'>
                  <i class='fas fa-code'></i> Generate Configuration
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#ai-analysis'>
                  <i class='fas fa-brain'></i> AI Analysis
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#optimization'>
                  <i class='fas fa-bolt'></i> Optimization
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#documentation'>
                  <i class='fas fa-file-alt'></i> Documentation
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#deployment'>
                  <i class='fas fa-upload'></i> Deployment
                </a>
              </li>
              <li class='nav-item'>
                <a class='nav-link' href='#troubleshooting'>
                  <i class='fas fa-bug'></i> Troubleshooting
                </a>
              </li>
            </ul>
            
            <div class='mt-4 text-center'>
              <button id='clear-config' class='btn btn-sm btn-outline-danger'>
                <i class='fas fa-trash'></i> Clear Configuration
              </button>
            </div>
          </div>
        </nav>

        <!-- Main Content Area -->
        <main class='col-md-9 ml-sm-auto col-lg-10 px-md-4 py-4'>
          <div id='main-content'>
            <!-- Content will be loaded here -->
            <h2>Loading content...</h2>
            <p>Please wait while the interface is being restored.</p>
          </div>
        </main>
      </div>
    </div>
    `;
    
    // Create notification
    const notification = document.createElement('div');
    notification.style.position = 'fixed';
    notification.style.bottom = '20px';
    notification.style.right = '20px';
    notification.style.padding = '10px 15px';
    notification.style.backgroundColor = '#27ae60';
    notification.style.color = 'white';
    notification.style.borderRadius = '4px';
    notification.style.zIndex = '9999';
    notification.innerHTML = 'UaXSupreme interface restored!<br>Reload the page to fully restore functionality.';
    
    document.body.appendChild(notification);
    setTimeout(() => notification.remove(), 5000);
  })();">Restore UaXSupreme UI</a>
  
  <h2>Instructions</h2>
  <div class="instructions">
    <ol>
      <li>Drag the "Restore UaXSupreme UI" bookmarklet to your bookmarks bar</li>
      <li>When the UaXSupreme page is broken or showing script content, click the bookmarklet</li>
      <li>The script will rebuild the basic interface structure</li>
      <li>For full functionality, reload the page after applying the permanent fix with <code>clean-index.html.sh</code></li>
    </ol>
  </div>
</body>
</html>
EOF

# Create a fixbleed.sh script that combines all fixes
print_message "Creating comprehensive fixbleed.sh script..."

cat > fixbleed.sh << 'EOF'
#!/bin/bash

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme Fix]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Create backup of index.html
print_message "Creating backup of index.html..."
BACKUP_FILE="index.html.bak.$(date +"%Y%m%d%H%M%S")"
cp index.html "$BACKUP_FILE"
print_success "Backup created: $BACKUP_FILE"

# Fix the index.html file
print_message "Fixing index.html file..."

# Step 1: Extract everything up to the closing HTML tag
if grep -q "</html>" index.html; then
  print_message "Found closing HTML tag. Extracting clean HTML..."
  sed -n '1,/<\/html>/p' index.html > index.html.clean
else
  print_warning "No closing HTML tag found. Using alternative cleaning method..."
  # Copy the original file as a starting point
  cp index.html index.html.clean
  
  # Look for shell script patterns and remove them
  print_message "Removing shell script patterns..."
  grep -v "#!/bin/bash" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_message" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_success" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_warning" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "print_error" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "function " index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "echo -e" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "if \[" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "for " index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "while " index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "cat >" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  grep -v "EOF" index.html.clean > index.html.tmp && mv index.html.tmp index.html.clean
  
  # Make sure body and html tags are closed properly
  if ! grep -q "</body>" index.html.clean; then
    print_message "Adding missing </body> tag..."
    echo "</body>" >> index.html.clean
  fi
  
  if ! grep -q "</html>" index.html.clean; then
    print_message "Adding missing </html> tag..."
    echo "</html>" >> index.html.clean
  fi
fi

# Step 2: Ensure DOCTYPE declaration
if ! grep -q "<!DOCTYPE html>" index.html.clean; then
  print_message "Adding DOCTYPE declaration..."
  sed -i '1i<!DOCTYPE html>' index.html.clean
fi

# Step 3: Fix any broken script tags
print_message "Fixing script tags..."
sed -i 's/<script[^>]*>\([^<]*\)<script/<script>\1/g' index.html.clean

# Step 4: Replace the original with the cleaned version
mv index.html.clean index.html
print_success "index.html fixed successfully"

print_message "You should now refresh your browser to see the changes"
print_message "If you still see issues, try using one of the provided HTML tools:"
print_message "  - detect-script-bleed.html: For diagnosing script bleed issues"
print_message "  - fix-script-bleed.html: For manually cleaning the HTML file"
print_message "  - hide-script-blocks.html: For hiding problematic script blocks"
print_message "  - final-fix-bookmarklet.html: For a quick in-browser fix"
EOF

# Make the fixbleed.sh script executable
chmod +x fixbleed.sh

print_success "All script bleed fixing tools have been created"
print_message "To fix the script bleed issue, run: ./fixbleed.sh"
print_message "This script will clean up your index.html file and remove shell script content"
print_message "After running the script, refresh your browser to see the changes"
