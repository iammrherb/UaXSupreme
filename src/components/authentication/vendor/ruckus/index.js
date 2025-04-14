/**
 * CommScope Ruckus Authentication Components
 * This file exports all Ruckus-specific authentication components
 * 
 * Supported platforms:
 * - FastIron
 * - SmartZone
 * - ICX
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 */

import RuckusRadiusComponent from './radius/RuckusRadiusComponent.js';
import RuckusTacacsComponent from './tacacs/RuckusTacacsComponent.js';
import RuckusCoaComponent from './coa/RuckusCoaComponent.js';
import RuckusRadsecComponent from './radsec/RuckusRadsecComponent.js';

export {
  RuckusRadiusComponent,
  RuckusTacacsComponent,
  RuckusCoaComponent,
  RuckusRadsecComponent
};

export default {
  radius: RuckusRadiusComponent,
  tacacs: RuckusTacacsComponent,
  coa: RuckusCoaComponent,
  radsec: RuckusRadsecComponent
};
