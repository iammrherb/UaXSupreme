#!/bin/bash

# Script to download paloalto icons for UaXSupreme diagrams
echo "Downloading paloalto icons..."

mkdir -p images/stencils/vendors/paloalto
curl -L -o paloalto_icons.zip "https://example.com/paloalto-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q paloalto_icons.zip -d images/stencils/vendors/paloalto
    rm paloalto_icons.zip
    echo "paloalto icons downloaded successfully!"
else
    echo "Failed to download paloalto icons!"
fi
