/**
 * Palo Alto Networks Authentication Components
 * This file exports all Paloalto-specific authentication components
 * 
 * Supported platforms:
 * - PAN-OS
 * - Panorama
 * 
 * Capabilities:
 * - vpn
 * - radius
 * - tacacs
 * - certauth
 */

import PaloaltoRadiusComponent from './radius/PaloaltoRadiusComponent.js';
import PaloaltoTacacsComponent from './tacacs/PaloaltoTacacsComponent.js';
import PaloaltoCoaComponent from './coa/PaloaltoCoaComponent.js';
import PaloaltoRadsecComponent from './radsec/PaloaltoRadsecComponent.js';

export {
  PaloaltoRadiusComponent,
  PaloaltoTacacsComponent,
  PaloaltoCoaComponent,
  PaloaltoRadsecComponent
};

export default {
  radius: PaloaltoRadiusComponent,
  tacacs: PaloaltoTacacsComponent,
  coa: PaloaltoCoaComponent,
  radsec: PaloaltoRadsecComponent
};
