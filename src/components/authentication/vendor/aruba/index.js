/**
 * HPE Aruba Authentication Components
 * This file exports all Aruba-specific authentication components
 * 
 * Supported platforms:
 * - AOS-CX
 * - AOS-Switch
 * - Instant AP
 * - ClearPass
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 * - tacacs
 * - cppm
 */

import ArubaRadiusComponent from './radius/ArubaRadiusComponent.js';
import ArubaTacacsComponent from './tacacs/ArubaTacacsComponent.js';
import ArubaCoaComponent from './coa/ArubaCoaComponent.js';
import ArubaRadsecComponent from './radsec/ArubaRadsecComponent.js';

export {
  ArubaRadiusComponent,
  ArubaTacacsComponent,
  ArubaCoaComponent,
  ArubaRadsecComponent
};

export default {
  radius: ArubaRadiusComponent,
  tacacs: ArubaTacacsComponent,
  coa: ArubaCoaComponent,
  radsec: ArubaRadsecComponent
};
