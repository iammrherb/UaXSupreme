# 802.1X Authentication Protocol

## Overview

IEEE 802.1X is a standard for port-based Network Access Control (PNAC) that provides an authentication mechanism for devices connecting to a wired or wireless LAN. It forms the foundation of a secure network by ensuring that only authorized devices can access network resources.

## Key Components

### Core Elements

1. **Supplicant**: The client device seeking network access 
   - Endpoint running 802.1X software/agent
   - Provides credentials (username/password or certificate)
   - Examples: Windows/macOS native clients, Cisco AnyConnect, Linux wpa_supplicant

2. **Authenticator**: The network device controlling access
   - Switch port or wireless access point
   - Blocks all traffic except 802.1X authentication
   - Forwards authentication requests to authentication server
   - Enforces access decisions

3. **Authentication Server**: The server validating credentials
   - Usually a RADIUS server
   - Verifies supplicant credentials
   - Makes authorization decisions
   - Examples: Cisco ISE, Aruba ClearPass, Microsoft NPS, FreeRADIUS

### Communication Flow

1. Client connects to network port or wireless SSID
2. Authenticator blocks all non-authentication traffic
3. Authenticator requests identity from supplicant
4. Supplicant provides identity
5. Authenticator forwards credentials to authentication server
6. Authentication server validates credentials
7. Authentication server returns access decision and optional attributes
8. Authenticator enforces decision (allow/deny)

## EAP Methods

Extensible Authentication Protocol (EAP) is the framework used by 802.1X for authentication. Common EAP methods include:

1. **EAP-TLS** (Transport Layer Security)
   - Certificate-based mutual authentication
   - Most secure EAP method
   - Requires PKI infrastructure
   - Provides strong protection against MITM attacks
   - Supported by all major platforms

2. **PEAP** (Protected EAP)
   - Server-side certificate with inner MSCHAPv2 (usually)
   - Password-based authentication in a TLS tunnel
   - Widely deployed in Windows environments
   - More secure than plain password methods
   - Simpler deployment than EAP-TLS

3. **EAP-TTLS** (Tunneled TLS)
   - Similar to PEAP but more flexible
   - Server-side certificate with various inner methods
   - Supports legacy authentication methods
   - Common in mixed environments
   - Better cross-platform support than PEAP

4. **EAP-FAST** (Flexible Authentication via Secure Tunneling)
   - Developed by Cisco as alternative to PEAP/TTLS
   - Uses Protected Access Credentials (PAC)
   - Can avoid certificate requirements
   - Provides fast reconnection
   - Less widely supported than other methods

## Security Considerations

1. **EAP Method Selection**
   - Certificate-based methods (EAP-TLS) provide strongest security
   - Password-based methods vulnerable to password attacks
   - Server certificates critical for preventing MITM attacks
   - Consider management overhead for certificates

2. **RADIUS Server Security**
   - Secure communication between authenticator and RADIUS
   - Use strong, unique shared secrets
   - Consider RADSEC (RADIUS over TLS) for enhanced security
   - Implement RADIUS server redundancy

3. **Client Security**
   - Validate server certificates properly
   - Protect client certificates and private keys
   - Implement timely certificate revocation
   - Consider certificate auto-enrollment

4. **Switch/Authenticator Security**
   - Protect against physical port access
   - Configure appropriate timeout values
   - Implement port security features
   - Plan for RADIUS server failures

## Best Practices

1. **Design Recommendations**
   - Use EAP-TLS when possible
   - Implement multi-tiered access with dynamic VLANs
   - Plan for devices without 802.1X support
   - Design redundant RADIUS infrastructure
   - Consider segmentation needs

2. **Deployment Strategy**
   - Start with monitor mode (open authentication)
   - Gradually transition to closed mode
   - Implement in phases by department/location
   - Create process for exceptions
   - Document thoroughly

3. **Configuration Guidelines**
   - Configure appropriate timeouts and retransmit settings
   - Use voice VLAN for IP phones
   - Implement guest VLAN for devices without 802.1X
   - Configure critical authentication for RADIUS server failures
   - Consider host modes carefully (single/multi/multi-auth)

4. **Operational Considerations**
   - Regular certificate renewal processes
   - Monitoring and logging
   - Performance tuning
   - User education
   - Incident response procedures

## Integration with Other Technologies

1. **MAC Authentication Bypass (MAB)**
   - Fallback for devices without 802.1X capability
   - Uses device MAC address as identity
   - Lower security than 802.1X but better than open access
   - Often used for printers, IP phones, IoT devices

2. **Web Authentication (WebAuth)**
   - Browser-based authentication
   - Often used for guest access
   - Can be a fallback after 802.1X/MAB failure
   - Redirects HTTP traffic to login page

3. **Posture Assessment**
   - Security state validation
   - Checks compliance before granting access
   - Can remediate non-compliant devices
   - Integrates with NAC solutions

4. **Change of Authorization (CoA)**
   - Dynamic policy changes
   - Allows reauthentication or disconnection
   - Supports quarantine or limited access
   - Critical for adaptive network access

## Troubleshooting

1. **Common Issues**
   - EAP method mismatch
   - Certificate validation failures
   - RADIUS server connectivity problems
   - Supplicant configuration errors
   - Timer and retransmission issues

2. **Troubleshooting Methodology**
   - Identify the stage of failure
   - Check client-side logs
   - Examine switch authentication status
   - Review RADIUS server logs
   - Use packet captures when necessary

3. **Key Verification Commands**
   - Check authentication status
   - Verify RADIUS connectivity
   - Examine session details
   - Review policy application
   - Validate dynamic assignments

## Additional Resources

1. **Standards and RFCs**
   - IEEE 802.1X-2010 (Current standard)
   - RFC 3748 (EAP)
   - RFC 2865 (RADIUS)
   - RFC 3580 (RADIUS with 802.1X)
   - RFC 5176 (CoA)

2. **Vendor Documentation**
   - Cisco Identity-Based Networking Services (IBNS) guides
   - Aruba ClearPass and 802.1X deployment guides
   - Microsoft NPS and 802.1X client configuration
   - Juniper 802.1X implementation guides
