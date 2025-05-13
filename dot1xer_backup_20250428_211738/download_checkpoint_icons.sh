#!/bin/bash

# Script to download checkpoint icons for UaXSupreme diagrams
echo "Downloading checkpoint icons..."

mkdir -p images/stencils/vendors/checkpoint
curl -L -o checkpoint_icons.zip "https://example.com/checkpoint-icons.zip"

if [ $? -eq 0 ]; then
    unzip -o -q checkpoint_icons.zip -d images/stencils/vendors/checkpoint
    rm checkpoint_icons.zip
    echo "checkpoint icons downloaded successfully!"
else
    echo "Failed to download checkpoint icons!"
fi
