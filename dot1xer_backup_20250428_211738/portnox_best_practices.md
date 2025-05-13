# Portnox Cloud NAC Best Practices Guide

## Authentication Configuration

### EAP-TLS Implementation
- **Use certificate-based authentication** for corporate devices when possible
- Implement proper certificate validation including revocation checking
- Configure certificate templates with appropriate validity periods (12-24 months)
- Set up automated certificate renewal processes
- Ensure all RADIUS servers have valid server certificates

### MAB Configuration
- Reserve MAC Authentication Bypass for devices that cannot support 802.1X
- Maintain a regularly updated database of authorized MAC addresses
- Implement strict ACLs for MAB-authenticated devices
- Consider implementing device profiling to validate device type
- Monitor for MAC spoofing attempts

### Fallback Methods
- Configure authentication order: 802.1X first, then MAB
- Implement guest VLAN for unauthenticated devices
- Configure auth-fail VLAN for failed authentication attempts
- Set up critical authentication for RADIUS server unavailability
- Test fallback scenarios regularly

## Network Device Configuration

### Switch Configuration
- Start with monitor mode before enforcing authentication
- Configure appropriate authentication timers (30-60 second timeouts)
- Use multi-domain authentication mode for IP phones + PC
- Enable BPDU guard on all access ports
- Configure Voice VLAN for IP telephony devices

### Wireless Configuration
- Use WPA2-Enterprise or WPA3-Enterprise
- Configure separate SSIDs for different security levels
- Implement PMF (Protected Management Frames) when available
- Configure client isolation on guest networks
- Set appropriate session timeouts (8-24 hours)

## Segmentation Strategy

### VLAN Segmentation
- Assign VLANs dynamically based on device type and user role
- Implement separate VLANs for:
  - Corporate devices
  - BYOD devices
  - IoT devices
  - Guest access
  - Voice communications
- Use appropriate subnet sizing for each segment

### Access Control
- Implement post-authentication ACLs
- Configure east-west traffic restrictions between segments
- Use downloadable ACLs for dynamic policy assignment
- Consider micro-segmentation for high-security environments
- Test ACL effectiveness regularly

## High Availability

### RADIUS Redundancy
- Configure at least two RADIUS servers
- Implement proper load balancing
- Set appropriate server failover and deadtime values
- Configure different shared secrets for each RADIUS server
- Monitor RADIUS server health

### Resiliency
- Implement local authentication caching for outage scenarios
- Configure critical authentication for RADIUS server failures
- Document recovery procedures
- Test failover scenarios quarterly
- Back up device configurations regularly

## Security Monitoring

### Accounting
- Enable RADIUS accounting
- Configure accounting update interval (15-60 minutes)
- Store accounting data for at least 90 days
- Implement accounting for authentication failures
- Set up regular reports on authentication statistics

### Alerting
- Configure alerts for:
  - Authentication server unavailability
  - High authentication failure rates
  - Unauthorized access attempts
  - Certificate expiration
  - Configuration changes
- Set up escalation procedures for critical alerts

## BYOD and Onboarding

### Device Onboarding
- Implement seamless enrollment portal
- Automate certificate provisioning
- Create clear user instructions
- Enforce minimum security requirements
- Test onboarding process with various device types

### Ongoing Management
- Set up periodic re-authentication (daily or weekly)
- Implement posture checking for enrolled devices
- Configure automated remediation actions
- Establish clear off-boarding procedures
- Regularly audit enrolled devices

## Compliance and Auditing

### Logging
- Capture detailed authentication logs
- Implement secure log transport (syslog over TLS)
- Maintain logs for at least 90 days (or as required by regulations)
- Configure log rotation policies
- Integrate with SIEM solutions

### Reporting
- Generate regular compliance reports
- Document all policy exceptions
- Maintain historical authentication data
- Configure automated report distribution
- Schedule regular compliance reviews

## Deployment Methodology

### Phased Rollout
- Start with IT department
- Move to smaller, less critical departments next
- Implement in monitor mode initially
- Allow 2-4 weeks of monitoring before enforcement
- Provide adequate user communication prior to enforcement

### Transition Strategy
- Configure per-port fallback to prevent user lockout
- Maintain helpdesk staff availability during transition
- Document common issues and solutions
- Create user-friendly troubleshooting guides
- Schedule transitions during low-activity periods
