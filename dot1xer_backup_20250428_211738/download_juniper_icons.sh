#!/bin/bash

# Script to download juniper icons for UaXSupreme diagrams
echo "Downloading juniper icons..."

mkdir -p images/stencils/vendors/juniper
curl -L -o juniper_icons.zip "https://example.com/juniper-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q juniper_icons.zip -d images/stencils/vendors/juniper
    rm juniper_icons.zip
    echo "juniper icons downloaded successfully!"
else
    echo "Failed to download juniper icons!"
fi
