# Portnox Cloud NAC Deployment Checklist

## Pre-Deployment

### Network Assessment
- [ ] Identify all access switches and wireless controllers
- [ ] Document network topology and VLAN structure
- [ ] Confirm all switches support 802.1X
- [ ] Verify RADIUS connectivity from network devices
- [ ] Document existing authentication methods

### Directory Services
- [ ] Configure Azure AD/Entra ID connection
- [ ] Set up Google Workspace integration (if applicable)
- [ ] Configure on-premises AD connector (if applicable)
- [ ] Verify user and group synchronization
- [ ] Test directory service authentication

### Certificate Infrastructure
- [ ] Set up certificate authority (for EAP-TLS)
- [ ] Create server certificates for RADIUS servers
- [ ] Establish certificate template for client devices
- [ ] Configure certificate revocation checking
- [ ] Test certificate enrollment process

## Initial Configuration

### Portnox Cloud Setup
- [ ] Create and configure Portnox Cloud tenant
- [ ] Set up administrator accounts and roles
- [ ] Configure network device communication settings
- [ ] Set up RADIUS server endpoint details
- [ ] Configure RADIUS shared secrets

### Authentication Methods
- [ ] Configure EAP-TLS settings
- [ ] Configure EAP-TTLS/PEAP settings (if applicable)
- [ ] Set up MAC Authentication Bypass for non-802.1X devices
- [ ] Configure guest network authentication
- [ ] Test each authentication method

### Endpoint Groups
- [ ] Create endpoint groups by device type
- [ ] Configure group-based policies
- [ ] Set up dynamic VLAN assignment rules
- [ ] Configure access control lists
- [ ] Test group policy application

## Network Device Configuration

### Switch Configuration
- [ ] Configure global 802.1X settings
- [ ] Set up RADIUS server parameters
- [ ] Configure interface authentication settings
- [ ] Set up guest VLAN for unauthenticated devices
- [ ] Configure critical authentication for RADIUS server failures

### Wireless Controller Configuration
- [ ] Configure RADIUS server settings
- [ ] Set up secure SSID with 802.1X
- [ ] Configure guest SSID with appropriate authentication
- [ ] Set up RADIUS accounting
- [ ] Test wireless authentication flows

## Phased Deployment

### Monitor Mode Phase
- [ ] Deploy 802.1X in monitor mode
- [ ] Collect authentication statistics
- [ ] Identify and resolve authentication failures
- [ ] Verify endpoint classification
- [ ] Generate compliance reports

### Production Deployment
- [ ] Convert from monitor mode to closed mode
- [ ] Roll out by department/location
- [ ] Implement dynamic VLAN assignment
- [ ] Enable enforcement policies
- [ ] Verify post-authentication access

## Post-Deployment

### Monitoring
- [ ] Set up alerting for authentication failures
- [ ] Configure daily/weekly reports
- [ ] Monitor RADIUS server health
- [ ] Set up logging and log retention
- [ ] Configure security incident alerting

### Optimization
- [ ] Fine-tune authentication timeouts
- [ ] Optimize VLAN assignments
- [ ] Review and adjust ACLs
- [ ] Configure automated remediation
- [ ] Document performance statistics

### Documentation
- [ ] Update network diagrams
- [ ] Document authentication workflows
- [ ] Create troubleshooting guide
- [ ] Document policy exceptions
- [ ] Create user onboarding documentation

## Special Considerations

### BYOD
- [ ] Configure device onboarding portal
- [ ] Set up certificate enrollment process
- [ ] Define BYOD policies
- [ ] Test user self-service functions
- [ ] Document user instructions

### IoT Devices
- [ ] Inventory all IoT devices
- [ ] Configure MAC Authentication Bypass
- [ ] Set up IoT VLAN segregation
- [ ] Implement IoT-specific ACLs
- [ ] Test IoT device connectivity

### Guest Access
- [ ] Configure guest portal
- [ ] Set up guest account provisioning
- [ ] Define guest access limitations
- [ ] Configure guest expiration policy
- [ ] Test guest user experience
