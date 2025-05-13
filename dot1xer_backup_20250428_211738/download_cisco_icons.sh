#!/bin/bash

# Script to download cisco icons for UaXSupreme diagrams
echo "Downloading cisco icons..."

mkdir -p images/stencils/vendors/cisco
curl -L -o cisco_icons.zip "https://example.com/cisco-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q cisco_icons.zip -d images/stencils/vendors/cisco
    rm cisco_icons.zip
    echo "cisco icons downloaded successfully!"
else
    echo "Failed to download cisco icons!"
fi
