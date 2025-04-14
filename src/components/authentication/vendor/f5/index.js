/**
 * F5 Networks Authentication Components
 * This file exports all F5-specific authentication components
 * 
 * Supported platforms:
 * - BIG-IP
 * - TMOS
 * 
 * Capabilities:
 * - vpn
 * - radius
 * - tacacs
 * - policyauth
 */

import F5RadiusComponent from './radius/F5RadiusComponent.js';
import F5TacacsComponent from './tacacs/F5TacacsComponent.js';
import F5CoaComponent from './coa/F5CoaComponent.js';
import F5RadsecComponent from './radsec/F5RadsecComponent.js';

export {
  F5RadiusComponent,
  F5TacacsComponent,
  F5CoaComponent,
  F5RadsecComponent
};

export default {
  radius: F5RadiusComponent,
  tacacs: F5TacacsComponent,
  coa: F5CoaComponent,
  radsec: F5RadsecComponent
};
