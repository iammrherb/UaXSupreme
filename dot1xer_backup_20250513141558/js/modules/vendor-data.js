/**
 * Vendor Data Module
 * Provides vendor information, logos, and capabilities
 */

const VendorData = {
  vendors: [
    {
      id: 'cisco',
      name: 'Cisco',
      logo: 'assets/images/vendors/cisco.png',
      type: 'both',
      capabilities: ['802.1X', 'MAB', 'TACACS+', 'RADIUS', 'RadSec', 'MACsec'],
      platforms: [
        { id: 'ios-xe', name: 'IOS-XE', icon: 'fa-network-wired' },
        { id: 'ios', name: 'IOS', icon: 'fa-server' },
        { id: 'nx-os', name: 'NX-OS', icon: 'fa-sitemap' },
        { id: 'catalyst-os', name: 'Catalyst OS', icon: 'fa-network-wired' },
        { id: 'ise', name: 'ISE', icon: 'fa-shield-alt' },
        { id: 'wlc-9800', name: 'WLC 9800', icon: 'fa-wifi' }
      ]
    },
    {
      id: 'aruba',
      name: 'Aruba',
      logo: 'assets/images/vendors/aruba.png',
      type: 'both',
      capabilities: ['802.1X', 'MAB', 'TACACS+', 'RADIUS', 'MACsec'],
      platforms: [
        { id: 'aos-cx', name: 'AOS-CX', icon: 'fa-server' },
        { id: 'aos-switch', name: 'AOS-Switch', icon: 'fa-network-wired' },
        { id: 'clearpass', name: 'ClearPass', icon: 'fa-shield-alt' }
      ]
    },
    {
      id: 'juniper',
      name: 'Juniper',
      logo: 'assets/images/vendors/juniper.png',
      type: 'both',
      capabilities: ['802.1X', 'MAB', 'TACACS+', 'RADIUS', 'MACsec'],
      platforms: [
        { id: 'junos', name: 'JunOS', icon: 'fa-network-wired' },
        { id: 'ex-series', name: 'EX Series', icon: 'fa-server' },
        { id: 'srx-series', name: 'SRX Series', icon: 'fa-shield-alt' }
      ]
    },
    {
      id: 'hp',
      name: 'HP',
      logo: 'assets/images/vendors/hp.png',
      type: 'wired',
      capabilities: ['802.1X', 'MAB', 'RADIUS'],
      platforms: [
        { id: 'procurve', name: 'ProCurve', icon: 'fa-network-wired' },
        { id: 'comware', name: 'Comware', icon: 'fa-server' }
      ]
    },
    {
      id: 'extreme',
      name: 'Extreme',
      logo: 'assets/images/vendors/extreme.png',
      type: 'both',
      capabilities: ['802.1X', 'MAB', 'RADIUS', 'TACACS+'],
      platforms: [
        { id: 'exos', name: 'EXOS', icon: 'fa-network-wired' },
        { id: 'voss', name: 'VOSS', icon: 'fa-server' }
      ]
    },
    {
      id: 'fortinet',
      name: 'Fortinet',
      logo: 'assets/images/vendors/fortinet.png',
      type: 'both',
      capabilities: ['802.1X', 'RADIUS', 'TACACS+'],
      platforms: [
        { id: 'fortiswitch', name: 'FortiSwitch', icon: 'fa-network-wired' },
        { id: 'fortigate', name: 'FortiGate', icon: 'fa-shield-alt' }
      ]
    },
    {
      id: 'paloalto',
      name: 'Palo Alto',
      logo: 'assets/images/vendors/paloalto.png',
      type: 'both',
      capabilities: ['802.1X', 'RADIUS', 'TACACS+'],
      platforms: [
        { id: 'panos', name: 'PanOS', icon: 'fa-shield-alt' }
      ]
    },
    {
      id: 'checkpoint',
      name: 'Checkpoint',
      logo: 'assets/images/vendors/checkpoint.png',
      type: 'both',
      capabilities: ['802.1X', 'RADIUS', 'TACACS+'],
      platforms: [
        { id: 'gaia', name: 'Gaia', icon: 'fa-shield-alt' },
        { id: 'splat', name: 'Splat', icon: 'fa-network-wired' }
      ]
    },
    {
      id: 'dell',
      name: 'Dell',
      logo: 'assets/images/vendors/dell.png',
      type: 'wired',
      capabilities: ['802.1X', 'MAB', 'RADIUS'],
      platforms: [
        { id: 'os10', name: 'OS10', icon: 'fa-network-wired' },
        { id: 'os9', name: 'OS9', icon: 'fa-server' }
      ]
    },
    {
      id: 'huawei',
      name: 'Huawei',
      logo: 'assets/images/vendors/huawei.png',
      type: 'both',
      capabilities: ['802.1X', 'MAB', 'RADIUS'],
      platforms: [
        { id: 'vrp', name: 'VRP', icon: 'fa-network-wired' },
        { id: 's-series', name: 'S Series', icon: 'fa-server' }
      ]
    },
    {
      id: 'avaya',
      name: 'Avaya',
      logo: 'assets/images/vendors/avaya.png',
      type: 'wired',
      capabilities: ['802.1X', 'RADIUS'],
      platforms: [
        { id: 'aos', name: 'AOS', icon: 'fa-network-wired' }
      ]
    },
    {
      id: 'meraki',
      name: 'Meraki',
      logo: 'assets/images/vendors/meraki.png',
      type: 'both',
      capabilities: ['802.1X', 'RADIUS', 'MAB'],
      platforms: [
        { id: 'dashboard', name: 'Dashboard API', icon: 'fa-cloud' }
      ]
    },
    {
      id: 'ubiquiti',
      name: 'Ubiquiti',
      logo: 'assets/images/vendors/ubiquiti.png',
      type: 'both',
      capabilities: ['802.1X', 'RADIUS'],
      platforms: [
        { id: 'unifi', name: 'UniFi', icon: 'fa-wifi' },
        { id: 'edgeswitch', name: 'EdgeSwitch', icon: 'fa-network-wired' }
      ]
    },
    {
      id: 'ruckus',
      name: 'Ruckus',
      logo: 'assets/images/vendors/ruckus.png',
      type: 'both',
      capabilities: ['802.1X', 'RADIUS'],
      platforms: [
        { id: 'fastiron', name: 'FastIron', icon: 'fa-network-wired' },
        { id: 'icx', name: 'ICX', icon: 'fa-server' }
      ]
    },
    {
      id: 'alcatel',
      name: 'Alcatel',
      logo: 'assets/images/vendors/alcatel.png',
      type: 'wired',
      capabilities: ['802.1X', 'RADIUS'],
      platforms: [
        { id: 'aos', name: 'AOS', icon: 'fa-network-wired' }
      ]
    }
  ],
  
  // Get all vendors
  getAllVendors() {
    return this.vendors;
  },
  
  // Get vendor by ID
  getVendorById(vendorId) {
    return this.vendors.find(vendor => vendor.id === vendorId);
  },
  
  // Get vendors by capability
  getVendorsByCapability(capability) {
    return this.vendors.filter(vendor => vendor.capabilities.includes(capability));
  },
  
  // Get vendors by type
  getVendorsByType(type) {
    return this.vendors.filter(vendor => vendor.type === type);
  },
  
  // Get platforms for a vendor
  getPlatformsForVendor(vendorId) {
    const vendor = this.getVendorById(vendorId);
    return vendor ? vendor.platforms : [];
  }
};

// Export for module use
if (typeof module !== 'undefined' && module.exports) {
  module.exports = VendorData;
} else {
  // Make available in window for direct browser use
  window.VendorData = VendorData;
}
