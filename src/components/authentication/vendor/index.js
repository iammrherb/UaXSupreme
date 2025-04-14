/**
 * Vendor-Specific Authentication Components
 * This file exports all vendor-specific authentication components
 */

// Import all vendor modules
import ciscoComponents from './cisco/index.js';
import arubaComponents from './aruba/index.js';
import juniperComponents from './juniper/index.js';
import hpComponents from './hp/index.js';
import extremeComponents from './extreme/index.js';
import fortinetComponents from './fortinet/index.js';
import dellComponents from './dell/index.js';
import huaweiComponents from './huawei/index.js';
import ruckusComponents from './ruckus/index.js';
import paloaltoComponents from './paloalto/index.js';
import checkpointComponents from './checkpoint/index.js';
import f5Components from './f5/index.js';

// Export as named exports
export {
  ciscoComponents,
  arubaComponents,
  juniperComponents,
  hpComponents,
  extremeComponents,
  fortinetComponents,
  dellComponents,
  huaweiComponents,
  ruckusComponents,
  paloaltoComponents,
  checkpointComponents,
  f5Components
};

// Export by vendor name for dynamic access
export default {
  cisco: ciscoComponents,
  aruba: arubaComponents,
  juniper: juniperComponents,
  hp: hpComponents,
  extreme: extremeComponents,
  fortinet: fortinetComponents,
  dell: dellComponents,
  huawei: huaweiComponents,
  ruckus: ruckusComponents,
  paloalto: paloaltoComponents,
  checkpoint: checkpointComponents,
  f5: f5Components
};

/**
 * Get component by vendor and type
 * @param {String} vendor Vendor name
 * @param {String} type Component type (radius, tacacs, coa, radsec)
 * @returns {Object} Vendor-specific component
 */
export function getVendorComponent(vendor, type) {
  if (!vendor || !type) {
    throw new Error('Vendor and type are required');
  }
  
  const vendorMap = {
    'cisco': ciscoComponents,
    'aruba': arubaComponents,
    'juniper': juniperComponents,
    'hp': hpComponents,
    'extreme': extremeComponents,
    'fortinet': fortinetComponents,
    'dell': dellComponents,
    'huawei': huaweiComponents,
    'ruckus': ruckusComponents,
    'paloalto': paloaltoComponents,
    'checkpoint': checkpointComponents,
    'f5': f5Components
  };
  
  // Get vendor components
  const vendorComponents = vendorMap[vendor.toLowerCase()];
  if (!vendorComponents) {
    throw new Error(`Vendor "${vendor}" not found`);
  }
  
  // Get specific component type
  const component = vendorComponents[type.toLowerCase()];
  if (!component) {
    throw new Error(`Component type "${type}" not found for vendor "${vendor}"`);
  }
  
  return component;
}
