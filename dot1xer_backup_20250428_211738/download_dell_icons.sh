#!/bin/bash

# Script to download dell icons for UaXSupreme diagrams
echo "Downloading dell icons..."

mkdir -p images/stencils/vendors/dell
curl -L -o dell_icons.zip "https://example.com/dell-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q dell_icons.zip -d images/stencils/vendors/dell
    rm dell_icons.zip
    echo "dell icons downloaded successfully!"
else
    echo "Failed to download dell icons!"
fi
