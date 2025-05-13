#!/bin/bash

# Script to download hp icons for UaXSupreme diagrams
echo "Downloading hp icons..."

mkdir -p images/stencils/vendors/hp
curl -L -o hp_icons.zip "https://example.com/hp-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q hp_icons.zip -d images/stencils/vendors/hp
    rm hp_icons.zip
    echo "hp icons downloaded successfully!"
else
    echo "Failed to download hp icons!"
fi
