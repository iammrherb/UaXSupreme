# Dot1Xer Core Edition

A streamlined 802.1X configuration generator for network devices.

## Overview

Dot1Xer Core Edition is a simplified version of the original Dot1Xer tool, focusing on essential 802.1X configuration generation without deployment-specific code, environment dependencies, or bloated features.

## Features

- Support for major network vendors (Cisco, Aruba, Juniper, HP)
- 802.1X and MAB authentication configuration
- RADIUS server settings
- VLAN assignment
- Security features (DHCP Snooping, DAI, IP Source Guard)
- Easy-to-use web interface

## Project Structure

```
.
├── assets/
│   ├── images/
│   └── logos/
├── css/
│   ├── main.css           # Main stylesheet
│   ├── vendor-cards.css   # Vendor selection styling
│   └── help.css           # Help tooltips styling
├── js/
│   ├── main.js            # Core initialization
│   ├── vendors.js         # Vendor definitions
│   ├── ui.js              # UI functionality
│   └── config-generator.js # Configuration generation
├── index.html             # Main application page
└── README.md              # This file
```

## Usage

1. Open `index.html` in a web browser
2. Select your network device vendor and platform
3. Configure authentication settings
4. Configure security features
5. Set up VLANs and interfaces
6. Generate your 802.1X configuration
7. Copy or download the configuration

## Cleanup Process

This repository was created by removing deployment, environment, and bloated code from the original project. The following files were removed or simplified:

- Removed `js/checklist-handler.js`
- Removed `auth-best-practices-final-part.txt`
- Removed `Comprehensive 802.1X Deployment Checklist with IoT, Onboarding, Guest Access & Discovery.tsx`
- Removed `js/diagrams.js` 
- Simplified `js/config-generator.js`
- Simplified `js/vendors.js`
- Simplified `js/main.js`
- Simplified `js/ui.js`
- Simplified CSS files
- Updated HTML to match simplified structure

## License

MIT License
