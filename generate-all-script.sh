#!/bin/bash

# Master script to run all component generation scripts

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
RESET="\033[0m"

SCRIPTS_DIR="./scripts"

echo -e "${BLUE}Starting Authentication Components Generation...${RESET}"

# Run each script in order
echo -e "${YELLOW}Step 1: Creating directory structure...${RESET}"
"$SCRIPTS_DIR/01-create-structure.sh"

echo -e "${YELLOW}Step 2: Generating base components...${RESET}"
"$SCRIPTS_DIR/02-generate-base-components.sh"

echo -e "${YELLOW}Step 3: Generating vendor-specific components...${RESET}"
"$SCRIPTS_DIR/03-generate-vendor-components.sh"

echo -e "${YELLOW}Step 4: Generating advanced components...${RESET}"
"$SCRIPTS_DIR/04-generate-advanced-components.sh"

echo -e "${YELLOW}Step 5: Generating utility services...${RESET}"
"$SCRIPTS_DIR/05-generate-utils.sh"

echo -e "${YELLOW}Step 6: Generating main index file...${RESET}"
"$SCRIPTS_DIR/06-generate-main-index.sh"

echo -e "${GREEN}Authentication Components Generation Completed!${RESET}"
echo -e "The components are available in ${BLUE}./src/components/authentication${RESET}"