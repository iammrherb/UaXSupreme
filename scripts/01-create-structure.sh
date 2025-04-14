#!/bin/bash

# Authentication Components Structure Setup Script
# This script sets up the directory structure for authentication components

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"

echo -e "${BLUE}Creating Authentication Components Directory Structure...${RESET}"

# Create base directories
mkdir -p "$BASE_DIR/base"
mkdir -p "$BASE_DIR/vendor"
mkdir -p "$BASE_DIR/advanced"
mkdir -p "$BASE_DIR/utils"

# Create base component directories
mkdir -p "$BASE_DIR/base/radius"
mkdir -p "$BASE_DIR/base/tacacs"
mkdir -p "$BASE_DIR/base/coa"
mkdir -p "$BASE_DIR/base/radsec"
mkdir -p "$BASE_DIR/base/common"

# Create vendor-specific directories for major vendors
VENDORS=("cisco" "aruba" "juniper" "hp" "extreme" "fortinet" "dell" "huawei" "ruckus" "paloalto" "checkpoint" "f5")

for vendor in "${VENDORS[@]}"; do
  mkdir -p "$BASE_DIR/vendor/$vendor/radius"
  mkdir -p "$BASE_DIR/vendor/$vendor/tacacs"
  mkdir -p "$BASE_DIR/vendor/$vendor/coa"
  mkdir -p "$BASE_DIR/vendor/$vendor/radsec"
  mkdir -p "$BASE_DIR/vendor/$vendor/utils"
  
  echo -e "${GREEN}Created directory structure for vendor: $vendor${RESET}"
done

# Create advanced authentication components directories
mkdir -p "$BASE_DIR/advanced/eap"
mkdir -p "$BASE_DIR/advanced/mab"
mkdir -p "$BASE_DIR/advanced/webauth"
mkdir -p "$BASE_DIR/advanced/macsec"
mkdir -p "$BASE_DIR/advanced/pki"
mkdir -p "$BASE_DIR/advanced/posture"
mkdir -p "$BASE_DIR/advanced/mfa"
mkdir -p "$BASE_DIR/advanced/byod"
mkdir -p "$BASE_DIR/advanced/guest"
mkdir -p "$BASE_DIR/advanced/profiling"
mkdir -p "$BASE_DIR/advanced/idp"

# Create utility directories
mkdir -p "$BASE_DIR/utils/validation"
mkdir -p "$BASE_DIR/utils/templates"
mkdir -p "$BASE_DIR/utils/generators"
mkdir -p "$BASE_DIR/utils/converters"
mkdir -p "$BASE_DIR/utils/factory"

echo -e "${GREEN}Directory structure created successfully.${RESET}"