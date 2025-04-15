# RadSec (RADIUS over TLS/DTLS)

## Overview

RadSec is a protocol that provides transport layer security for RADIUS communications by encapsulating RADIUS packets within TLS (Transport Layer Security) or DTLS (Datagram TLS) sessions. It addresses the fundamental security limitations of traditional RADIUS by encrypting the entire RADIUS conversation, not just the password attributes.

## Protocol Details

1. **Standards and Specifications**
   - RFC 6614: Transport Layer Security (TLS) Encryption for RADIUS
   - RFC 7360: Datagram Transport Layer Security (DTLS) as a Transport Layer for RADIUS
   - Uses TCP (for TLS) or UDP (for DTLS) as transport protocols
   - Default port: 2083
   - Provides mutual authentication, message integrity, and confidentiality

2. **Key Differences from Standard RADIUS**
   - Full encryption of all RADIUS attributes
   - Certificate-based mutual authentication
   - Persistent connections (for TLS)
   - No shared secrets required (replaced by certificates)
   - Better reliability and error detection
   - Support for fragmentation of large packets

3. **Connection Models**
   - **Direct model**: Direct TLS connection between RADIUS client and server
   - **Tunnel model**: RADIUS messages tunneled through TLS to a proxy
   - **Hybrid model**: Mix of traditional RADIUS and RadSec

## Security Improvements

1. **Enhanced Protection**
   - Encrypts entire RADIUS packet, not just password
   - Protects sensitive attributes (usernames, accounting data)
   - Prevents eavesdropping on network segments
   - Provides stronger authentication of RADIUS clients/servers
   - Eliminates shared secret limitations

2. **Certificate-Based Security**
   - Mutual authentication through certificates
   - PKI infrastructure for trust validation
   - Certificate revocation capabilities
   - Strong cryptographic protection
   - Central management of trust relationships

3. **Attack Mitigation**
   - Prevents offline dictionary attacks
   - Eliminates packet capture and replay risks
   - Reduces man-in-the-middle attack vectors
   - Protects against shared secret brute-forcing
   - Avoids shared secret entropy problems

## Vendor Implementation

### Cisco
- Supported in IOS 15.3(1)T and later
- Uses DTLS (UDP-based) implementation
- Requires X.509 certificates
- Configuration under radius server and CoA sections

### Juniper
- Supported in JunOS 13.3 and later
- TLS implementation
- Configurable under access profile

### FreeRADIUS
- Supported as both client and server
- Both TLS and DTLS implementations
- Proxying capabilities
- Extensive configuration options

## Deployment Considerations

1. **Certificate Management**
   - Plan PKI infrastructure
   - Implement certificate lifecycle management
   - Consider certificate revocation methods
   - Automate certificate renewal when possible

2. **Network Architecture**
   - RadSec proxies for federation
   - Firewall rules (port 2083 TCP/UDP)
   - Certificate distribution
   - High availability considerations

3. **Migration Strategy**
   - Parallel deployment with traditional RADIUS
   - Phased rollout to clients
   - Testing methodology
   - Fallback mechanisms

## Best Practices

1. **Implementation**
   - Use strong TLS ciphers (TLS 1.2 or higher)
   - Implement certificate validation
   - Configure appropriate session timeouts
   - Monitor certificate expiration

2. **Operations**
   - Regular certificate rotation
   - Performance monitoring
   - Connection pooling where supported
   - Logging and auditing

3. **Security**
   - Private key protection
   - Certificate Authority security
   - Regular security reviews
   - Secure certificate distribution

## Troubleshooting

1. **Common Issues**
   - Certificate validation failures
   - TLS handshake problems
   - Network connectivity issues
   - Certificate expiration

2. **Verification Commands**
   - Check certificate status
   - Verify TLS/DTLS connection
   - Test RadSec server connectivity
   - Review connection logs

3. **Debug Techniques**
   - TLS/DTLS handshake debugging
   - Certificate chain validation
   - Protocol analysis tools
   - RADIUS packet examination
