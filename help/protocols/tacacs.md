# TACACS+ (Terminal Access Controller Access-Control System Plus)

## Overview

TACACS+ is a AAA (Authentication, Authorization, and Accounting) protocol developed by Cisco that provides centralized validation of users attempting to gain access to network devices. It is commonly used for device administration rather than network access control, complementing RADIUS in many environments.

## Protocol Details

1. **Core Specifications**
   - Based on Cisco proprietary implementation
   - IETF Informational RFC 8907 (August 2020)
   - Transport: TCP (connection-oriented)
   - Default Port: 49
   - Full encryption of entire packet body
   - Shared secret used for encryption key derivation

2. **Key Differences from RADIUS**
   - Uses TCP instead of UDP for reliability
   - Encrypts entire packet body, not just password
   - Separates AAA functions (Authentication, Authorization, Accounting)
   - Better support for command authorization
   - More detailed accounting information
   - More flexible attribute handling

3. **Packet Types**
   - Authentication: START, REPLY, CONTINUE
   - Authorization: REQUEST, RESPONSE
   - Accounting: REQUEST, RESPONSE
   - Session tracking through session ID

## Key Features

1. **Authentication**
   - Multiple authentication methods
   - PAP, CHAP, MS-CHAP support
   - Multi-factor authentication capabilities
   - Interactive challenge-response
   - Authentication method negotiation

2. **Authorization**
   - Command-level authorization
   - Service-level authorization
   - Attribute-value pair (AVP) based policies
   - Command privilege levels
   - Per-user or per-group authorization
   - Context-aware authorization rules

3. **Accounting**
   - Command accounting
   - Connection accounting
   - System event accounting
   - Detailed session tracking
   - Start/Stop/Watchdog records
   - Configurable accounting levels

## Server Implementations

1. **Commercial Solutions**
   - **Cisco ISE**: Comprehensive policy server with advanced features
   - **Cisco ACS**: Legacy TACACS+ server (End of Life)
   - **Aruba ClearPass**: Integrated with network access control
   - **Tac_plus**: Classic TACACS+ server implementation

2. **Open Source Options**
   - **tac_plus**: Shrubbery Networks implementation
   - **TACACS+ Daemon**: Open source implementation
   - **Free TACACS+**: Community supported implementation

## Security Considerations

1. **Encryption**
   - Entire packet body is encrypted
   - Uses MD5-based hashing for key derivation
   - Modern cryptographic standards not supported
   - Single shared secret for both authentication and encryption
   - No forward secrecy

2. **Shared Secret Management**
   - Use strong, unique secrets per TACACS+ client
   - Minimum 16 character random strings recommended
   - Rotate secrets regularly
   - Secure storage of secrets
   - Avoid default or easily guessable secrets

3. **Network Security**
   - Separate management network for TACACS+ traffic
   - Firewall rules to restrict TACACS+ access
   - Consider IPsec for transport security
   - Monitor for unauthorized TACACS+ clients
   - Implement intrusion detection

4. **Known Issues**
   - No client identity verification beyond IP address
   - Simplified key derivation algorithm (MD5-based)
   - No protection against replay attacks
   - No perfect forward secrecy
   - Sensitive to timing attacks

## Deployment Models

1. **Centralized Management**
   - Single TACACS+ server or cluster
   - All network devices authenticate to central server
   - Unified policy management
   - Centralized accounting and logging

2. **Distributed Management**
   - Multiple TACACS+ servers
   - Regional or functional distribution
   - Local fallback options
   - Policy synchronization between servers

3. **Hybrid Approach**
   - TACACS+ for device administration
   - RADIUS for network access control
   - Separate authentication domains
   - Integrated user databases

## Best Practices

1. **Design Recommendations**
   - Plan for redundancy from the start
   - Implement TACACS+ server hierarchy for large deployments
   - Use dedicated management interfaces
   - Consider IPsec for security enhancement
   - Document attribute usage

2. **Operational Guidelines**
   - Regular backup of configuration
   - Monitor server health and performance
   - Implement audit logging
   - Develop testing procedures
   - Create operational runbooks

3. **Security Protocols**
   - Regular shared secret rotation
   - Security reviews and audits
   - Access control to TACACS+ servers
   - Change management procedures
   - Fine-grained command authorization

4. **Configuration Standards**
   - Standardize attribute usage
   - Consistent naming conventions
   - Template-based client configuration
   - Policy organization
   - Documentation requirements

## Conclusion

TACACS+ remains a crucial protocol for device administration in network environments, particularly those with Cisco infrastructure. Its strengths in command authorization and accounting make it an excellent complement to RADIUS, which is typically used for network access control. While it has security limitations, when properly implemented with strong security controls, TACACS+ provides a robust solution for administrative access management.
