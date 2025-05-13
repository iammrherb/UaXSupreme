#!/bin/bash

# Script to download extreme icons for UaXSupreme diagrams
echo "Downloading extreme icons..."

mkdir -p images/stencils/vendors/extreme
curl -L -o extreme_icons.zip "https://example.com/extreme-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q extreme_icons.zip -d images/stencils/vendors/extreme
    rm extreme_icons.zip
    echo "extreme icons downloaded successfully!"
else
    echo "Failed to download extreme icons!"
fi
