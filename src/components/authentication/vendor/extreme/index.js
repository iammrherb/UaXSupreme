/**
 * Extreme Networks Authentication Components
 * This file exports all Extreme-specific authentication components
 * 
 * Supported platforms:
 * - EXOS
 * - VOSS
 * - Wing
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 * - tacacs
 */

import ExtremeRadiusComponent from './radius/ExtremeRadiusComponent.js';
import ExtremeTacacsComponent from './tacacs/ExtremeTacacsComponent.js';
import ExtremeCoaComponent from './coa/ExtremeCoaComponent.js';
import ExtremeRadsecComponent from './radsec/ExtremeRadsecComponent.js';

export {
  ExtremeRadiusComponent,
  ExtremeTacacsComponent,
  ExtremeCoaComponent,
  ExtremeRadsecComponent
};

export default {
  radius: ExtremeRadiusComponent,
  tacacs: ExtremeTacacsComponent,
  coa: ExtremeCoaComponent,
  radsec: ExtremeRadsecComponent
};
