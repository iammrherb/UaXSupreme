/**
 * Huawei Authentication Components
 * This file exports all Huawei-specific authentication components
 * 
 * Supported platforms:
 * - VRP
 * - S-Series
 * - USG
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 * - tacacs
 */

import HuaweiRadiusComponent from './radius/HuaweiRadiusComponent.js';
import HuaweiTacacsComponent from './tacacs/HuaweiTacacsComponent.js';
import HuaweiCoaComponent from './coa/HuaweiCoaComponent.js';
import HuaweiRadsecComponent from './radsec/HuaweiRadsecComponent.js';

export {
  HuaweiRadiusComponent,
  HuaweiTacacsComponent,
  HuaweiCoaComponent,
  HuaweiRadsecComponent
};

export default {
  radius: HuaweiRadiusComponent,
  tacacs: HuaweiTacacsComponent,
  coa: HuaweiCoaComponent,
  radsec: HuaweiRadsecComponent
};
