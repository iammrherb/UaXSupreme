# RADIUS (Remote Authentication Dial-In User Service)

## Overview

RADIUS is a client-server protocol that provides centralized Authentication, Authorization, and Accounting (AAA) management for users and devices connecting to a network. Originally designed for dial-up network access, RADIUS has evolved to become the standard protocol for network access authentication, especially for 802.1X deployments.

## Protocol Details

1. **Core Specifications**
   - Defined in RFC 2865 (Authentication/Authorization) and RFC 2866 (Accounting)
   - Transport: UDP (connectionless)
   - Default Ports: 1812 (Authentication), 1813 (Accounting)
   - Legacy Ports: 1645 (Authentication), 1646 (Accounting)
   - Encryption: Only password attributes are encrypted, other attributes sent in cleartext
   - Shared secret used for RADIUS message verification

2. **Message Types**
   - **Access-Request**: Client requests authentication
   - **Access-Accept**: Server accepts the authentication
   - **Access-Reject**: Server rejects the authentication
   - **Access-Challenge**: Server requests additional information
   - **Accounting-Request**: Client sends accounting information
   - **Accounting-Response**: Server acknowledges accounting data

3. **Attribute-Value Pairs (AVPs)**
   - RADIUS uses AVPs to communicate information
   - Each attribute has a type, length, and value
   - Standard attributes defined in RFCs
   - Vendor-Specific Attributes (VSAs) for proprietary features

## Key Attributes

1. **Authentication Attributes**
   - **User-Name**: Identity of the user/device
   - **User-Password**: Password (encrypted)
   - **CHAP-Password**: CHAP authentication data
   - **NAS-IP-Address**: IP address of the Network Access Server
   - **NAS-Port**: Physical port number
   - **Service-Type**: Type of service requested
   - **EAP-Message**: EAP payload for 802.1X

2. **Authorization Attributes**
   - **Framed-IP-Address**: IP to assign to user
   - **Framed-IP-Netmask**: Netmask to assign
   - **Filter-Id**: Name of filter list
   - **Session-Timeout**: Maximum session time
   - **Idle-Timeout**: Maximum idle time
   - **Termination-Action**: Action to take when service is completed

3. **Accounting Attributes**
   - **Acct-Status-Type**: Start, Stop, Interim-Update
   - **Acct-Session-Id**: Unique session identifier
   - **Acct-Input-Octets**: Bytes received
   - **Acct-Output-Octets**: Bytes sent
   - **Acct-Session-Time**: Session duration
   - **Acct-Terminate-Cause**: Reason for session termination

4. **Vendor-Specific Attributes**
   - Cisco: VLAN assignment, ACLs, etc.
   - Aruba: User roles, VLAN attributes, etc.
   - Microsoft: MS-CHAP attributes, etc.
   - Custom attributes for specific policies

## RADIUS Server Implementations

1. **Commercial Solutions**
   - **Cisco ISE**: Comprehensive policy server with advanced NAC
   - **Aruba ClearPass**: Policy management platform with profiling
   - **Forescout**: NAC platform with visibility and control
   - **Portnox**: Cloud or on-premises NAC solution

2. **Open Source Options**
   - **FreeRADIUS**: Most widely deployed RADIUS server
   - **Radiator**: Commercial-grade server with free version
   - **PacketFence**: Complete NAC solution with RADIUS

3. **Windows Integration**
   - **Network Policy Server (NPS)**: Microsoft's RADIUS implementation
   - **Active Directory Integration**: User/computer authentication
   - **Certificate Services**: PKI for EAP-TLS

## RADIUS Extensions

1. **CoA (Change of Authorization)**
   - Defined in RFC 5176
   - Allows RADIUS server to dynamically change session attributes
   - Enables policy changes without reauthentication
   - Critical for adaptive access control
   - Implemented as Disconnect-Request and CoA-Request messages

2. **RadSec (RADIUS over TLS/DTLS)**
   - Defined in RFC 6614 (TLS) and RFC 7360 (DTLS)
   - Encrypts entire RADIUS conversation
   - Uses TCP (TLS) or UDP (DTLS) transport
   - Default port 2083
   - Provides mutual authentication and confidentiality
   - Solves many RADIUS security limitations

3. **RADIUS Proxy**
   - Forwards requests between RADIUS clients and servers
   - Enables federation and roaming
   - Supports load balancing and redundancy
   - Allows for policy routing of requests
   - Used in service provider and large enterprise networks

4. **RADIUS Federation**
   - Enables cross-organizational authentication
   - Used in eduroam and similar services
   - Based on realm-based routing
   - Relies on trust relationships
   - Supports global mobility and roaming

## Security Considerations

1. **Shared Secret Management**
   - Use strong, unique secrets per RADIUS client
   - Minimum 16 character random strings recommended
   - Rotate secrets regularly
   - Secure storage of secrets
   - Avoid default or easily guessable secrets

2. **Network Security**
   - Separate management network for RADIUS traffic
   - Firewall rules to restrict RADIUS access
   - Consider IPsec or RadSec for transport security
   - Monitor for unauthorized RADIUS clients
   - Implement intrusion detection

3. **RADIUS Server Hardening**
   - Regular patching and updates
   - Minimize installed services
   - Strong authentication for administration
   - File and directory permissions
   - Audit logging enabled

4. **Known Vulnerabilities**
   - Password attribute is weakly protected
   - Most attributes sent in cleartext
   - Susceptible to offline dictionary attacks
   - Potential for replay attacks
   - Vulnerable to DoS attacks

## High Availability and Scaling

1. **Server Redundancy**
   - Primary and secondary RADIUS servers
   - Load balancing across multiple servers
   - Server pool configuration
   - Deadtime and failover parameters
   - Database replication

2. **Performance Optimization**
   - Caching strategies
   - Connection pooling
   - Thread and process tuning
   - Database optimization
   - Hardware sizing guidelines

3. **Scaling Considerations**
   - Session capacity planning
   - Geographic distribution
   - Request rate limitations
   - Timeout and retry optimization
   - Monitoring and capacity management

## Best Practices

1. **Design Recommendations**
   - Plan for redundancy from the start
   - Implement RADIUS server hierarchy for large deployments
   - Use dedicated management interfaces
   - Consider RadSec for security
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
   - Certificate management
   - Access control to RADIUS servers
   - Change management procedures

4. **Configuration Standards**
   - Standardize attribute usage
   - Consistent naming conventions
   - Template-based client configuration
   - Policy organization
   - Documentation requirements

## Conclusion

RADIUS remains the foundation of network access control and 802.1X deployments despite its age. While it has limitations, particularly around security, extensions like RadSec and features like CoA have kept RADIUS relevant. Understanding its operation, security considerations, and best practices is essential for implementing robust network access control solutions.
