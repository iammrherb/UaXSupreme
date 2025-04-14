/**
 * Fortinet Authentication Components
 * This file exports all Fortinet-specific authentication components
 * 
 * Supported platforms:
 * - FortiOS
 * - FortiSwitch
 * - FortiWLC
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 * - tacacs
 * - 802.1x
 */

import FortinetRadiusComponent from './radius/FortinetRadiusComponent.js';
import FortinetTacacsComponent from './tacacs/FortinetTacacsComponent.js';
import FortinetCoaComponent from './coa/FortinetCoaComponent.js';
import FortinetRadsecComponent from './radsec/FortinetRadsecComponent.js';

export {
  FortinetRadiusComponent,
  FortinetTacacsComponent,
  FortinetCoaComponent,
  FortinetRadsecComponent
};

export default {
  radius: FortinetRadiusComponent,
  tacacs: FortinetTacacsComponent,
  coa: FortinetCoaComponent,
  radsec: FortinetRadsecComponent
};
