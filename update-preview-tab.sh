#!/bin/bash
# This script attempts to update the preview tab in index.html

# Define base directory
BASE_DIR="."
if [ ! -z "$1" ]; then
    BASE_DIR="$1"
fi

# Create a temporary file
TEMP_FILE=$(mktemp)

# Extract the preview tab from preview-tab-update.html
cat "$BASE_DIR/preview-tab-update.html" > "$TEMP_FILE"

# Try to replace the preview tab in index.html
sed -i '/<div class="tab-pane" id="preview">/,/<\/div><!--.*preview.*-->/c\
'"$(cat $TEMP_FILE)" "$BASE_DIR/index.html"

# Clean up
rm "$TEMP_FILE"

echo "Preview tab update attempted. Please check index.html to verify the changes."
