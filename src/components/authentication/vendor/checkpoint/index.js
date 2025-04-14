/**
 * Check Point Software Authentication Components
 * This file exports all Checkpoint-specific authentication components
 * 
 * Supported platforms:
 * - Gaia
 * - MDS
 * 
 * Capabilities:
 * - vpn
 * - radius
 * - tacacs
 * - identity
 */

import CheckpointRadiusComponent from './radius/CheckpointRadiusComponent.js';
import CheckpointTacacsComponent from './tacacs/CheckpointTacacsComponent.js';
import CheckpointCoaComponent from './coa/CheckpointCoaComponent.js';
import CheckpointRadsecComponent from './radsec/CheckpointRadsecComponent.js';

export {
  CheckpointRadiusComponent,
  CheckpointTacacsComponent,
  CheckpointCoaComponent,
  CheckpointRadsecComponent
};

export default {
  radius: CheckpointRadiusComponent,
  tacacs: CheckpointTacacsComponent,
  coa: CheckpointCoaComponent,
  radsec: CheckpointRadsecComponent
};
