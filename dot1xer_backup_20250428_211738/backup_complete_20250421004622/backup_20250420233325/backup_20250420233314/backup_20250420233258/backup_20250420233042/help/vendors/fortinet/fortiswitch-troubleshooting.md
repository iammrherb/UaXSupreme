# FortiSwitch 802.1X Troubleshooting and Verification Guide

## Key Verification Commands

### Authentication Status Commands

Check 802.1X configuration
get switch security-feature 802-1X

Check 802.1X interface status
diagnose switch 802-1X status interface {{INTERFACE_NAME}}

Check 802.1X statistics
diagnose switch 802-1X statistics interface {{INTERFACE_NAME}}

Check authenticated clients
diagnose switch 802-1X authenticated

Check MAC authentication
diagnose switch 802-1X mac-auth


Copy

### RADIUS Communication

Check RADIUS server configuration
get user radius

Check RADIUS statistics
diagnose test authserver radius {{RADIUS_NAME}}

Check RADIUS connectivity
execute ping {{RADIUS_SERVER_IP}}


Copy

### Interface and Port Status

Check interface status
get switch interface {{INTERFACE_NAME}}

Check interface statistics
diagnose switch interface stats {{INTERFACE_NAME}}

Check VLAN configuration
get system interface

markdown

Copy

## Common Issues and Solutions

### Authentication Failure Issues

1. **EAP Authentication Failures**
   - **Symptoms:** Client fails 802.1X authentication
   - **Verification:** `diagnose switch 802-1X status interface {{INTERFACE_NAME}}`
   - **Possible Causes:** 
     - Invalid credentials or certificate
     - EAP method mismatch
     - RADIUS server policy issues
   - **Solution:** 
     - Verify EAP method configuration on client and server
     - Check RADIUS server logs for specific failure reason
     - Ensure time synchronization if using certificates

2. **RADIUS Server Connectivity Issues**
   - **Symptoms:** Authentication timeouts
   - **Verification:** `diagnose test authserver radius {{RADIUS_NAME}}`
   - **Possible Causes:**
     - Network connectivity issues
     - Incorrect RADIUS shared secret
     - Firewall blocking RADIUS traffic
   - **Solution:**
     - Verify connectivity to RADIUS server (ping)
     - Check shared secret configuration
     - Verify port connectivity (UDP 1812/1813)

## Best Practices

1. **Authentication Configuration**
   - Use appropriate security-mode for your environment
   - Configure reasonable reauth-period (8-24 hours)
   - Set appropriate radius-timeout (5 seconds recommended)
   - Configure auth-fail-vlan for failed authentications
   - Enable guest-vlan for non-802.1X devices

2. **Deployment Strategy**
   - Start with open-auth enabled (monitor mode)
   - Phase implementation by building or department
   - Document exceptions and special configurations
   - Gradually transition to closed mode (set open-auth disable)
