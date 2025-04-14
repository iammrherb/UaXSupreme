#!/bin/bash
# Launch script for Dot1Xer Supreme Enterprise Edition

# Install dependencies if node_modules directory doesn't exist
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
fi

# Start the development server
echo "Starting development server..."
npm run dev
