#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Downloading all vendor and service icons for Portnox diagrams...${NC}"

# Run all vendor downloaders
for script in download_*_icons.sh; do
    echo -e "${YELLOW}Running $script...${NC}"
    ./$script
done

# Create Portnox-specific icons
echo -e "${YELLOW}Creating Portnox-specific icons...${NC}"

# Generate simple SVG icons for Portnox components
mkdir -p images/stencils/portnox

# Portnox Cloud icon
cat > images/stencils/portnox/portnox_cloud.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#1E88E5" stroke="#0D47A1" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox Cloud</text>
</svg>
SVGEOF

# Portnox RADIUS Server icon
cat > images/stencils/portnox/portnox_radius.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#43A047" stroke="#1B5E20" stroke-width="2"/>
  <text x="50" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox</text>
  <text x="50" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="white">RADIUS</text>
</svg>
SVGEOF

# Portnox Clear icon
cat > images/stencils/portnox/portnox_clear.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#7B1FA2" stroke="#4A148C" stroke-width="2"/>
  <text x="50" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox</text>
  <text x="50" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Clear</text>
</svg>
SVGEOF

# Portnox Core icon
cat > images/stencils/portnox/portnox_core.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#E65100" stroke="#BF360C" stroke-width="2"/>
  <text x="50" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox</text>
  <text x="50" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Core</text>
</svg>
SVGEOF

# Portnox AgentP icon
cat > images/stencils/portnox/portnox_agentp.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#F44336" stroke="#B71C1C" stroke-width="2"/>
  <text x="50" y="30" font-family="Arial" font-size="12" text-anchor="middle" fill="white">Portnox</text>
  <text x="50" y="45" font-family="Arial" font-size="12" text-anchor="middle" fill="white">AgentP</text>
</svg>
SVGEOF

# Create authentication protocol icons
mkdir -p images/stencils/authentication

# EAP-TLS icon
cat > images/stencils/authentication/eap_tls.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FDD835" stroke="#F57F17" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">EAP-TLS</text>
</svg>
SVGEOF

# EAP-TTLS icon
cat > images/stencils/authentication/eap_ttls.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FFB300" stroke="#E65100" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">EAP-TTLS</text>
</svg>
SVGEOF

# PEAP icon
cat > images/stencils/authentication/peap.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FFA000" stroke="#E65100" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">PEAP</text>
</svg>
SVGEOF

# MAB icon
cat > images/stencils/authentication/mab.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="100" height="60" viewBox="0 0 100 60">
  <rect x="5" y="5" width="90" height="50" rx="5" ry="5" fill="#FF9800" stroke="#E65100" stroke-width="2"/>
  <text x="50" y="35" font-family="Arial" font-size="14" text-anchor="middle" fill="#000">MAB</text>
</svg>
SVGEOF

# Create device type icons
mkdir -p images/stencils/devices

# BYOD device icon
cat > images/stencils/devices/byod.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="15" y="5" width="30" height="50" rx="3" ry="3" fill="#607D8B" stroke="#263238" stroke-width="2"/>
  <rect x="20" y="10" width="20" height="35" fill="#B0BEC5"/>
  <circle cx="30" cy="50" r="3" fill="#B0BEC5"/>
  <text x="30" y="28" font-family="Arial" font-size="7" text-anchor="middle" fill="#000">BYOD</text>
</svg>
SVGEOF

# IoT device icon
cat > images/stencils/devices/iot.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="20" width="40" height="25" rx="2" ry="2" fill="#00BCD4" stroke="#006064" stroke-width="2"/>
  <circle cx="20" cy="32" r="3" fill="#E0F7FA"/>
  <circle cx="30" cy="32" r="3" fill="#E0F7FA"/>
  <circle cx="40" cy="32" r="3" fill="#E0F7FA"/>
  <text x="30" y="15" font-family="Arial" font-size="7" text-anchor="middle" fill="#000">IoT Device</text>
</svg>
SVGEOF

# Printer icon
cat > images/stencils/devices/printer.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="20" width="40" height="25" rx="2" ry="2" fill="#78909C" stroke="#37474F" stroke-width="2"/>
  <rect x="15" y="12" width="30" height="8" fill="#CFD8DC" stroke="#37474F" stroke-width="1"/>
  <rect x="15" y="45" width="30" height="8" fill="#CFD8DC" stroke="#37474F" stroke-width="1"/>
  <rect x="20" y="25" width="20" height="15" fill="#ECEFF1"/>
  <text x="30" y="53" font-family="Arial" font-size="6" text-anchor="middle" fill="#000">Printer</text>
</svg>
SVGEOF

# IP Phone icon
cat > images/stencils/devices/ip_phone.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <path d="M15,10 L45,10 L45,50 L15,50 Z" fill="#3F51B5" stroke="#1A237E" stroke-width="2"/>
  <rect x="20" y="15" width="20" height="15" fill="#C5CAE9"/>
  <rect x="20" y="35" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="27.5" y="35" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="35" y="35" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="20" y="42" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="27.5" y="42" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <rect x="35" y="42" width="5" height="5" rx="2" ry="2" fill="#C5CAE9"/>
  <text x="30" y="55" font-family="Arial" font-size="6" text-anchor="middle" fill="#000">IP Phone</text>
</svg>
SVGEOF

# Camera icon
cat > images/stencils/devices/camera.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="20" width="30" height="20" rx="2" ry="2" fill="#455A64" stroke="#263238" stroke-width="2"/>
  <circle cx="25" cy="30" r="8" fill="#78909C" stroke="#263238" stroke-width="1"/>
  <circle cx="25" cy="30" r="4" fill="#CFD8DC"/>
  <path d="M40,25 L50,20 L50,40 L40,35 Z" fill="#455A64" stroke="#263238" stroke-width="2"/>
  <text x="30" y="50" font-family="Arial" font-size="6" text-anchor="middle" fill="#000">IP Camera</text>
</svg>
SVGEOF

# Create certificate icons
mkdir -p images/stencils/certificates

# Certificate icon
cat > images/stencils/certificates/certificate.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="2" ry="2" fill="#FFECB3" stroke="#FFA000" stroke-width="2"/>
  <path d="M15,25 L45,25" stroke="#FFA000" stroke-width="1"/>
  <path d="M15,30 L45,30" stroke="#FFA000" stroke-width="1"/>
  <path d="M15,35 L35,35" stroke="#FFA000" stroke-width="1"/>
  <circle cx="40" cy="37" r="7" fill="#FFC107" stroke="#FFA000" stroke-width="1"/>
  <text x="30" y="50" font-family="Arial" font-size="6" text-anchor="middle" fill="#000">Certificate</text>
</svg>
SVGEOF

# CA icon
cat > images/stencils/certificates/ca.svg << 'SVGEOF'
<svg xmlns="http://www.w3.org/2000/svg" width="60" height="60" viewBox="0 0 60 60">
  <rect x="10" y="15" width="40" height="30" rx="2" ry="2" fill="#FFECB3" stroke="#FF6F00" stroke-width="2"/>
  <path d="M15,25 L45,25" stroke="#FF6F00" stroke-width="1"/>
  <path d="M15,30 L45,30" stroke="#FF6F00" stroke-width="1"/>
  <path d="M15,35 L35,35" stroke="#FF6F00" stroke-width="1"/>
  <circle cx="40" cy="37" r="7" fill="#FF9800" stroke="#FF6F00" stroke-width="1"/>
  <path d="M36,40 L44,34" stroke="#FFF" stroke-width="1.5"/>
  <path d="M36,34 L44,40" stroke="#FFF" stroke-width="1.5"/>
  <text x="30" y="50" font-family="Arial" font-size="6" text-anchor="middle" fill="#000">CA</text>
</svg>
SVGEOF

echo -e "${GREEN}All icons downloaded and created successfully!${NC}"
