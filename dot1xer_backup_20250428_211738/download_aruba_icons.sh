#!/bin/bash

# Script to download aruba icons for UaXSupreme diagrams
echo "Downloading aruba icons..."

mkdir -p images/stencils/vendors/aruba
curl -L -o aruba_icons.zip "https://example.com/aruba-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q aruba_icons.zip -d images/stencils/vendors/aruba
    rm aruba_icons.zip
    echo "aruba icons downloaded successfully!"
else
    echo "Failed to download aruba icons!"
fi
