/**
 * Dell Technologies Authentication Components
 * This file exports all Dell-specific authentication components
 * 
 * Supported platforms:
 * - OS10
 * - OS9
 * - OS6
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 * - tacacs
 */

import DellRadiusComponent from './radius/DellRadiusComponent.js';
import DellTacacsComponent from './tacacs/DellTacacsComponent.js';
import DellCoaComponent from './coa/DellCoaComponent.js';
import DellRadsecComponent from './radsec/DellRadsecComponent.js';

export {
  DellRadiusComponent,
  DellTacacsComponent,
  DellCoaComponent,
  DellRadsecComponent
};

export default {
  radius: DellRadiusComponent,
  tacacs: DellTacacsComponent,
  coa: DellCoaComponent,
  radsec: DellRadsecComponent
};
