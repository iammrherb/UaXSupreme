/**
 * Advanced Authentication Components
 * This file exports all advanced authentication components
 */

// Import all advanced component modules
import EapComponent from './eap/index.js';
import MabComponent from './mab/index.js';
import WebauthComponent from './webauth/index.js';
import MacsecComponent from './macsec/index.js';
import PkiComponent from './pki/index.js';
import PostureComponent from './posture/index.js';
import MfaComponent from './mfa/index.js';
import ByodComponent from './byod/index.js';
import GuestComponent from './guest/index.js';
import ProfilingComponent from './profiling/index.js';
import IdpComponent from './idp/index.js';

// Export as named exports
export {
  EapComponent,
  MabComponent,
  WebauthComponent,
  MacsecComponent,
  PkiComponent,
  PostureComponent,
  MfaComponent,
  ByodComponent,
  GuestComponent,
  ProfilingComponent,
  IdpComponent
};

// Export by component type for dynamic access
export default {
  eap: EapComponent,
  mab: MabComponent,
  webauth: WebauthComponent,
  macsec: MacsecComponent,
  pki: PkiComponent,
  posture: PostureComponent,
  mfa: MfaComponent,
  byod: ByodComponent,
  guest: GuestComponent,
  profiling: ProfilingComponent,
  idp: IdpComponent
};
