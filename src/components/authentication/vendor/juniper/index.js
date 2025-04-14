/**
 * Juniper Networks Authentication Components
 * This file exports all Juniper-specific authentication components
 * 
 * Supported platforms:
 * - JunOS
 * - EX Series
 * - SRX Series
 * 
 * Capabilities:
 * - dot1x
 * - mab
 * - radius
 * - tacacs
 */

import JuniperRadiusComponent from './radius/JuniperRadiusComponent.js';
import JuniperTacacsComponent from './tacacs/JuniperTacacsComponent.js';
import JuniperCoaComponent from './coa/JuniperCoaComponent.js';
import JuniperRadsecComponent from './radsec/JuniperRadsecComponent.js';

export {
  JuniperRadiusComponent,
  JuniperTacacsComponent,
  JuniperCoaComponent,
  JuniperRadsecComponent
};

export default {
  radius: JuniperRadiusComponent,
  tacacs: JuniperTacacsComponent,
  coa: JuniperCoaComponent,
  radsec: JuniperRadsecComponent
};
