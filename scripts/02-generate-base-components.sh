#!/bin/bash

# Base Components Generator Script
# This script generates the base authentication components

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

# Base directory
BASE_DIR="./src/components/authentication"
SCRIPTS_DIR="./scripts"

echo -e "${BLUE}Generating Base Authentication Components...${RESET}"

# Create ValidationService
mkdir -p "$BASE_DIR/utils/validation"
echo -e "${YELLOW}Creating ValidationService...${RESET}"

# Check if ValidationService.js already exists to avoid overwriting
if [ -f "$BASE_DIR/utils/validation/ValidationService.js" ]; then
  echo -e "${YELLOW}ValidationService.js already exists, skipping...${RESET}"
else
  # Copy ValidationService.js from the scripts directory
  cp "$SCRIPTS_DIR/validation-service.js" "$BASE_DIR/utils/validation/ValidationService.js"
  
  echo -e "${GREEN}Created ValidationService${RESET}"
fi

# Create base components
echo -e "${YELLOW}Creating BaseRadiusComponent...${RESET}"

# Check if BaseRadiusComponent.js already exists
if [ -f "$BASE_DIR/base/radius/BaseRadiusComponent.js" ]; then
  echo -e "${YELLOW}BaseRadiusComponent.js already exists, skipping...${RESET}"
else
  # Copy BaseRadiusComponent.js from the scripts directory
  cp "$SCRIPTS_DIR/base-radius-component.js" "$BASE_DIR/base/radius/BaseRadiusComponent.js"
  
  echo -e "${GREEN}Created BaseRadiusComponent${RESET}"
fi

# Repeat for other base components: TACACS+, CoA, RADSEC
echo -e "${YELLOW}Creating BaseTacacsComponent...${RESET}"
if [ -f "$BASE_DIR/base/tacacs/BaseTacacsComponent.js" ]; then
  echo -e "${YELLOW}BaseTacacsComponent.js already exists, skipping...${RESET}"
else
  cp "$SCRIPTS_DIR/base-tacacs-component.js" "$BASE_DIR/base/tacacs/BaseTacacsComponent.js"
  
  echo -e "${GREEN}Created BaseTacacsComponent${RESET}"
fi

echo -e "${YELLOW}Creating BaseCoaComponent...${RESET}"
if [ -f "$BASE_DIR/base/coa/BaseCoaComponent.js" ]; then
  echo -e "${YELLOW}BaseCoaComponent.js already exists, skipping...${RESET}"
else
  cp "$SCRIPTS_DIR/base-coa-component.js" "$BASE_DIR/base/coa/BaseCoaComponent.js"
  
  echo -e "${GREEN}Created BaseCoaComponent${RESET}"
fi

echo -e "${YELLOW}Creating BaseRadsecComponent...${RESET}"
if [ -f "$BASE_DIR/base/radsec/BaseRadsecComponent.js" ]; then
  echo -e "${YELLOW}BaseRadsecComponent.js already exists, skipping...${RESET}"
else
  cp "$SCRIPTS_DIR/base-radsec-component.js" "$BASE_DIR/base/radsec/BaseRadsecComponent.js"
  
  echo -e "${GREEN}Created BaseRadsecComponent${RESET}"
fi

# Create base components index file
echo -e "${YELLOW}Creating base components index file...${RESET}"
cat > "$BASE_DIR/base/index.js" << EOF
/**
 * Base Authentication Components
 * This file exports all base authentication components
 */

import BaseRadiusComponent from './radius/BaseRadiusComponent.js';
import BaseTacacsComponent from './tacacs/BaseTacacsComponent.js';
import BaseCoaComponent from './coa/BaseCoaComponent.js';
import BaseRadsecComponent from './radsec/BaseRadsecComponent.js';

export {
  BaseRadiusComponent,
  BaseTacacsComponent,
  BaseCoaComponent,
  BaseRadsecComponent
};

export default {
  radius: BaseRadiusComponent,
  tacacs: BaseTacacsComponent,
  coa: BaseCoaComponent,
  radsec: BaseRadsecComponent
};
EOF

echo -e "${GREEN}Created base components index file${RESET}"

echo -e "${GREEN}Base components generation completed${RESET}"