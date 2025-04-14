/**
 * Base Authentication Components
 * This file exports all base authentication components
 */

import BaseRadiusComponent from './radius/BaseRadiusComponent.js';
import BaseTacacsComponent from './tacacs/BaseTacacsComponent.js';
import BaseCoaComponent from './coa/BaseCoaComponent.js';
import BaseRadsecComponent from './radsec/BaseRadsecComponent.js';

export {
  BaseRadiusComponent,
  BaseTacacsComponent,
  BaseCoaComponent,
  BaseRadsecComponent
};

export default {
  radius: BaseRadiusComponent,
  tacacs: BaseTacacsComponent,
  coa: BaseCoaComponent,
  radsec: BaseRadsecComponent
};
