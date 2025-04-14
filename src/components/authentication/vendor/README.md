# Vendor-Specific Authentication Components

This directory contains vendor-specific implementations of authentication components.

## Supported Vendors

### Cisco Systems

**Platforms:** iOS, iOS-XE, NX-OS, ISE

**Capabilities:** dot1x, mab, radsec, macsec, tacacs

### HPE Aruba

**Platforms:** AOS-CX, AOS-Switch, Instant AP, ClearPass

**Capabilities:** dot1x, mab, radius, tacacs, cppm

### Juniper Networks

**Platforms:** JunOS, EX Series, SRX Series

**Capabilities:** dot1x, mab, radius, tacacs

### Hewlett Packard Enterprise

**Platforms:** ProVision, Comware

**Capabilities:** dot1x, mab, radius, tacacs

### Extreme Networks

**Platforms:** EXOS, VOSS, Wing

**Capabilities:** dot1x, mab, radius, tacacs

### Fortinet

**Platforms:** FortiOS, FortiSwitch, FortiWLC

**Capabilities:** dot1x, mab, radius, tacacs, 802.1x

### Dell Technologies

**Platforms:** OS10, OS9, OS6

**Capabilities:** dot1x, mab, radius, tacacs

### Huawei

**Platforms:** VRP, S-Series, USG

**Capabilities:** dot1x, mab, radius, tacacs

### CommScope Ruckus

**Platforms:** FastIron, SmartZone, ICX

**Capabilities:** dot1x, mab, radius

### Palo Alto Networks

**Platforms:** PAN-OS, Panorama

**Capabilities:** vpn, radius, tacacs, certauth

### Check Point Software

**Platforms:** Gaia, MDS

**Capabilities:** vpn, radius, tacacs, identity

### F5 Networks

**Platforms:** BIG-IP, TMOS

**Capabilities:** vpn, radius, tacacs, policyauth

## Usage

Import vendor-specific components directly:

```javascript
import { CiscoRadiusComponent } from './vendor/cisco/radius/CiscoRadiusComponent.js';

// Create an instance
const ciscoRadius = new CiscoRadiusComponent();
```

Or use the factory method:

```javascript
import { getVendorComponent } from './vendor/index.js';

// Get vendor component by name and type
const juniperTacacs = getVendorComponent('juniper', 'tacacs');
```
