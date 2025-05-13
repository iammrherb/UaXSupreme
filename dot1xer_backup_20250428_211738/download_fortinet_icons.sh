#!/bin/bash

# Script to download fortinet icons for UaXSupreme diagrams
echo "Downloading fortinet icons..."

mkdir -p images/stencils/vendors/fortinet
curl -L -o fortinet_icons.zip "https://example.com/fortinet-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q fortinet_icons.zip -d images/stencils/vendors/fortinet
    rm fortinet_icons.zip
    echo "fortinet icons downloaded successfully!"
else
    echo "Failed to download fortinet icons!"
fi
