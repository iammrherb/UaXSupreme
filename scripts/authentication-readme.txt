# Authentication Components Library

This repository contains a comprehensive set of authentication components for network security and access control. The components provide a flexible, vendor-agnostic foundation that can be extended with vendor-specific implementations.

## Overview

The Authentication Components Library is designed to handle various authentication protocols and mechanisms used in enterprise networks, including:

- RADIUS Authentication
- TACACS+ Authentication
- Change of Authorization (CoA)
- RADIUS over TLS (RADSEC)
- Advanced authentication mechanisms (EAP, MAB, WebAuth, etc.)

The library follows a modular, extensible architecture with base components that define common functionality and vendor-specific components that extend the base functionality for particular network equipment vendors.

## Directory Structure

```
src/components/authentication/
├── base/              # Base authentication components
│   ├── radius/        # Base RADIUS component
│   ├── tacacs/        # Base TACACS+ component
│   ├── coa/           # Base CoA component
│   └── radsec/        # Base RADSEC component
├── vendor/            # Vendor-specific implementations
│   ├── cisco/         # Cisco-specific components
│   ├── aruba/         # Aruba-specific components
│   ├── juniper/       # Juniper-specific components
│   └── ...            # Other vendor implementations
├── advanced/          # Advanced authentication components
│   ├── eap/           # EAP method components
│   ├── mab/           # MAC Authentication Bypass components
│   ├── webauth/       # Web Authentication components
│   └── ...            # Other advanced components
└── utils/             # Utilities and helpers
    ├── validation/    # Configuration validation
    ├── factory/       # Component factory service
    ├── templates/     # Configuration templates
    └── converters/    # Configuration converters
```

## Key Components

### Base Components

Base components provide the foundation for all authentication functionality:

1. **BaseRadiusComponent**: Core RADIUS configuration capabilities
2. **BaseTacacsComponent**: Core TACACS+ configuration capabilities
3. **BaseCoaComponent**: Core CoA configuration capabilities
4. **BaseRadsecComponent**: Core RADSEC configuration capabilities

### Vendor-Specific Components

Vendor components extend the base components with vendor-specific features:

1. **CiscoRadiusComponent**: Cisco IOS/IOS-XE/NX-OS RADIUS configuration
2. **ArubaRadiusComponent**: Aruba AOS-CX/AOS-Switch RADIUS configuration
3. **JuniperRadiusComponent**: Juniper JunOS RADIUS configuration
4. **FortinetRadiusComponent**: Fortinet FortiOS RADIUS configuration
5. ... (and other vendor implementations)

### Advanced Authentication Components

Advanced components handle specialized authentication mechanisms:

1. **EapComponent**: EAP method configuration (PEAP, EAP-TLS, EAP-TTLS, etc.)
2. **MabComponent**: MAC Authentication Bypass configuration
3. **WebauthComponent**: Web Authentication configuration
4. **MacsecComponent**: MACsec (802.1AE) configuration
5. ... (and other advanced authentication mechanisms)

### Utility Services

Utility services provide common functionality:

1. **ValidationService**: Configuration validation
2. **ComponentFactory**: Component creation and management
3. **ConfigConverter**: Configuration conversion between vendors
4. **TemplateService**: Configuration template management

## Usage Examples

### Basic Usage

```javascript
// Import the component factory
import componentFactory from './components/authentication/utils/factory/ComponentFactory.js';

// Get a Cisco RADIUS component
const ciscoRadius = componentFactory.getComponent('radius', 'cisco');

// Configure RADIUS settings
ciscoRadius.setConfig({
  primaryServer: {
    address: '10.1.1.100',
    authPort: 1812,
    acctPort: 1813,
    secret: 'mySharedSecret'
  },
  general: {
    timeout: 5,
    retransmit: 3
  }
});

// Generate configuration
const config = ciscoRadius.generateConfig();
console.log(config);
```

### Using Advanced Components

```javascript
// Import the EAP component
import EapComponent from './components/authentication/advanced/eap/index.js';

// Create a Cisco EAP component
import CiscoEapComponent from './components/authentication/vendor/cisco/eap/CiscoEapComponent.js';

const ciscoEap = new CiscoEapComponent();

// Configure EAP methods
ciscoEap.setConfig({
  methods: {
    peap: {
      enabled: true,
      innerMethod: 'mschapv2',
      validateServerCertificate: true
    },
    'eap-tls': {
      enabled: true,
      validateServerCertificate: true,
      clientCertificate: 'client.pem',
      clientKey: 'client-key.pem'
    }
  },
  server: {
    primaryDomain: '10.1.1.100'
  }
});

// Generate EAP configuration
const eapConfig = ciscoEap.generateConfig('ios-xe');
console.log(eapConfig);
```

### Converting Between Vendors

```javascript
// Import the configuration converter
import configConverter from './components/authentication/utils/converters/ConfigConverter.js';

// Convert Cisco RADIUS configuration to Aruba
const ciscoConfig = '...'; // Cisco RADIUS configuration
const result = configConverter.convert(ciscoConfig, 'cisco', 'aruba', 'radius');

if (result.success) {
  console.log('Converted configuration:');
  console.log(result.config);
} else {
  console.error('Conversion failed:', result.errors);
}
```

## Setup and Installation

### Using the Generator Scripts

The library includes a set of scripts to automatically generate the component files and directory structure:

1. Clone the repository
2. Run the main generator script:

```bash
./generate-all.sh
```

This will create all the necessary files and directories for the authentication components library.

Alternatively, you can run individual generator scripts in the `scripts` directory:

```bash
# Create directory structure
./scripts/01-create-structure.sh

# Generate base components
./scripts/02-generate-base-components.sh

# Generate vendor components
./scripts/03-generate-vendor-components.sh

# Generate advanced components
./scripts/04-generate-advanced-components.sh

# Generate utility services
./scripts/05-generate-utils.sh

# Generate main index file
./scripts/06-generate-main-index.sh
```

## Extending the Library

### Adding a New Vendor

To add support for a new vendor:

1. Create a new directory in `src/components/authentication/vendor/` with the vendor name
2. Create subdirectories for different component types (radius, tacacs, coa, radsec)
3. Create vendor-specific components that extend the base components
4. Update the vendor index file to include the new vendor

### Adding a New Authentication Component

To add a new authentication component:

1. Create a new directory in `src/components/authentication/advanced/` with the component name
2. Create a base component for the new functionality
3. Create vendor-specific implementations as needed
4. Update the advanced components index file

## Contributing

Contributions are welcome! If you'd like to add support for a new vendor, improve an existing component, or add a new authentication mechanism, please follow the contribution guidelines:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This library is available under the MIT License. See the LICENSE file for details.

## Acknowledgments

This library is based on best practices and standards for network authentication and incorporates knowledge from various vendor documentation and industry standards.