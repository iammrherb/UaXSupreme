#!/bin/bash
# Simple HTTP server for UaXSupreme

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to display script messages
print_message() {
  echo -e "${BLUE}[UaXSupreme]${NC} $1"
}

print_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
  echo -e "${RED}[ERROR]${NC} $1"
  exit 1
}

# Check if python is installed
if command -v python3 &>/dev/null; then
    print_message "Starting UaXSupreme server using Python 3..."
    print_success "Server running at http://localhost:8000"
    print_message "Press Ctrl+C to stop."
    python3 -m http.server 8000
elif command -v python &>/dev/null; then
    PYTHON_VERSION=$(python --version 2>&1)
    if [[ $PYTHON_VERSION == *"Python 3"* ]]; then
        print_message "Starting UaXSupreme server using Python 3..."
        print_success "Server running at http://localhost:8000"
        print_message "Press Ctrl+C to stop."
        python -m http.server 8000
    else
        print_message "Starting UaXSupreme server using Python 2..."
        print_success "Server running at http://localhost:8000"
        print_message "Press Ctrl+C to stop."
        python -m SimpleHTTPServer 8000
    fi
else
    print_error "Python is not installed. Please install Python or use another web server."
fi
