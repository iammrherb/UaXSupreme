/**
 * Cisco Systems Authentication Components
 * This file exports all Cisco-specific authentication components
 * 
 * Supported platforms:
 * - iOS
 * - iOS-XE
 * - NX-OS
 * - ISE
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radsec
 * - macsec
 * - tacacs
 */

import CiscoRadiusComponent from './radius/CiscoRadiusComponent.js';
import CiscoTacacsComponent from './tacacs/CiscoTacacsComponent.js';
import CiscoCoaComponent from './coa/CiscoCoaComponent.js';
import CiscoRadsecComponent from './radsec/CiscoRadsecComponent.js';

export {
  CiscoRadiusComponent,
  CiscoTacacsComponent,
  CiscoCoaComponent,
  CiscoRadsecComponent
};

export default {
  radius: CiscoRadiusComponent,
  tacacs: CiscoTacacsComponent,
  coa: CiscoCoaComponent,
  radsec: CiscoRadsecComponent
};
