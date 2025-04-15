# Web Authentication (WebAuth)

## Overview

Web Authentication is a fallback authentication method that intercepts HTTP/HTTPS traffic from unauthenticated users and redirects them to a captive portal for credentials. It's commonly used for guest access or as a fallback for devices that do not support 802.1X.

## Protocol Operation

1. **Authentication Flow**
   - User connects to the network
   - IP address assigned (typically via DHCP)
   - User attempts to browse the web
   - Switch/controller intercepts HTTP/HTTPS requests
   - User redirected to captive portal
   - User enters credentials
   - Credentials validated against AAA server
   - Access granted based on authorization policy

2. **Types of Web Authentication**
   - **Local WebAuth**: Authentication handled on the network device
   - **Central WebAuth**: Authentication redirected to external portal
   - **Custom WebAuth**: Customized portal hosted locally
   - **Consent WebAuth**: Only requires acceptance of terms, no credentials

3. **Authentication Methods**
   - Username/password
   - Guest self-registration
   - Sponsor-approved access
   - Social media login
   - SMS/email one-time passwords
   - QR code-based authentication

## Deployment Scenarios

1. **Guest Access**
   - Internet-only access for visitors
   - Time-limited authentication
   - Registration and sponsor workflows
   - Terms of service acceptance
   - Minimal network access

2. **BYOD Onboarding**
   - Initial device provisioning
   - Certificate enrollment
   - Supplicant configuration
   - Self-service registration
   - Transition to 802.1X

3. **Fallback Authentication**
   - When 802.1X and MAB fail
   - Limited access for legacy devices
   - Emergency access when primary methods unavailable
   - Temporary access during migration
   - Troubleshooting access

4. **Public Access**
   - Public WiFi hotspots
   - Internet cafes
   - Libraries and educational institutions
   - Airport/transportation hubs
   - Retail establishments

## Vendor Implementation

### Cisco
- **ISE-Based**: Full captive portal customization
- **Local Web Authentication**: Basic authentication on switch/controller
- **Central Web Authentication**: Redirect to external server
- **FlexAuth**: Sequential with 802.1X and MAB

### Aruba
- **ClearPass-Based**: Advanced customization and workflows
- **Controller-Based**: Local authentication on wireless controller
- **Integrated with Airwave**: Monitoring and reporting
- **Policy-Driven**: Context-aware authentication

### Juniper
- **Local Authentication**: Basic captive portal
- **Unified Access Control**: Advanced integration
- **Cloud-Based Option**: With Mist cloud

### Other Vendors
- Most vendors support similar functionality with proprietary implementations

## Security Considerations

1. **Protocol Security**
   - HTTPS for secure credential submission
   - Certificate validation
   - Session timeout and idle timeout
   - Account lockout after failed attempts
   - Preventing session hijacking

2. **Network Segmentation**
   - Guest VLAN isolation
   - Internet-only access limitations
   - DMZ placement of guest services
   - Traffic filtering and inspection
   - Rate limiting and bandwidth control

3. **Credential Management**
   - Temporary credential generation
   - Password complexity and expiration
   - Guest account lifecycle management
   - Sponsor workflows and approvals
   - Self-registration validation

4. **Attack Mitigation**
   - Brute force prevention
   - CSRF protection
   - XSS mitigation
   - Clickjacking defense
   - Rate limiting login attempts

## Best Practices

1. **Design Considerations**
   - Use as fallback, not primary authentication
   - Implement strong session management
   - Secure credential transmission
   - Plan for scalability
   - Consider mobile user experience

2. **Portal Configuration**
   - Responsive design for mobile devices
   - Clear instructions for users
   - Multiple language support
   - Accessible design
   - Branding and customization

3. **Security Enhancement**
   - Implement short session timeouts
   - Enable post-authentication device profiling
   - Apply appropriate ACLs to limit network access
   - Monitor failed login attempts
   - Regular security testing

4. **Operational Management**
   - Maintain audit logs of authentications
   - Monitor usage patterns
   - Implement account cleanup procedures
   - Develop troubleshooting guides
   - Train help desk staff

## Configuration Tips

1. **ACL Configuration**
   - Permit DHCP, DNS, and redirection traffic
   - Allow access to authentication portal
   - Block all other traffic pre-authentication
   - Configure appropriate post-authentication ACLs
   - Consider walled garden for limited services

2. **Redirection Setup**
   - Configure URL redirection rules
   - Set up HTTP and HTTPS interception
   - Configure DNS redirection if needed
   - Test with multiple browsers and devices
   - Ensure IP helper addresses are configured

3. **Session Parameters**
   - Configure appropriate session timeout
   - Set idle timeout for inactive users
   - Configure maximum sessions per user
   - Set up accounting for session tracking
   - Consider bandwidth limitations

4. **Portal Customization**
   - Organization branding
   - Terms of service inclusion
   - Support contact information
   - User-friendly error messages
   - Self-help and troubleshooting information

## Troubleshooting

1. **Common Issues**
   - Redirection not working
   - HTTPS interception problems
   - Authentication server unreachable
   - Session timeout too short
   - Post-authentication access problems

2. **Troubleshooting Steps**
   - Verify IP assignment
   - Check ACL configuration
   - Test redirection mechanism
   - Verify RADIUS/authentication server
   - Check for certificate issues

3. **Verification Commands**
   - Authentication session status
   - ACL application verification
   - Redirection rule checking
   - Session counters and statistics
   - Debug authentication process

## Conclusion

Web Authentication provides a valuable fallback mechanism, especially for guest access and devices without 802.1X capability. While it offers less security than certificate-based 802.1X authentication, it serves an important role in comprehensive network access control strategies. Implementing WebAuth with proper security controls, user experience considerations, and operational procedures ensures effective authentication while maintaining security.
