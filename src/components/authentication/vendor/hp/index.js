/**
 * Hewlett Packard Enterprise Authentication Components
 * This file exports all Hp-specific authentication components
 * 
 * Supported platforms:
 * - ProVision
 * - Comware
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 * - tacacs
 */

import HpRadiusComponent from './radius/HpRadiusComponent.js';
import HpTacacsComponent from './tacacs/HpTacacsComponent.js';
import HpCoaComponent from './coa/HpCoaComponent.js';
import HpRadsecComponent from './radsec/HpRadsecComponent.js';

export {
  HpRadiusComponent,
  HpTacacsComponent,
  HpCoaComponent,
  HpRadsecComponent
};

export default {
  radius: HpRadiusComponent,
  tacacs: HpTacacsComponent,
  coa: HpCoaComponent,
  radsec: HpRadsecComponent
};
