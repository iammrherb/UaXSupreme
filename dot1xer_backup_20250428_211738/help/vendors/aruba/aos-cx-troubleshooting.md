# Aruba AOS-CX 802.1X Troubleshooting and Verification Guide

## Key Verification Commands

### Authentication Status Commands

Check 802.1X configuration
show aaa port-access config

Check 802.1X authenticators
show aaa port-access authenticators [<interface>]

Check 802.1X clients
show aaa port-access clients [<interface>]

Check MAC authentication
show aaa port-access mac-auth [<interface>]

Check authentication statistics
show aaa authentication

Check authentication counters
show aaa port-access counters [<interface>]


Copy

### RADIUS Communication

Check RADIUS server status
show radius-server

Check RADIUS statistics
show radius statistics

Check RADIUS accounting
show radius accounting statistics


Copy

### Interface and Port Status

Check interface status
show interface <interface>

Check interface statistics
show interface <interface> statistics

Check spanning-tree status
show spanning-tree interface <interface>

angelscript

Copy

## Common Issues and Solutions

### Authentication Failure Issues

1. **EAP Authentication Failures**
   - **Symptoms:** Client fails 802.1X authentication
   - **Verification:** `show aaa port-access authenticators <interface>`
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
   - **Verification:** `show radius-server`
   - **Possible Causes:**
     - Network connectivity issues
     - Incorrect RADIUS shared secret
     - Firewall blocking RADIUS traffic
   - **Solution:**
     - Verify connectivity to RADIUS server (ping)
     - Check shared secret configuration
     - Verify port connectivity (UDP 1812/1813)

3. **MAB Authentication Failures**
   - **Symptoms:** MAB authentication fails
   - **Verification:** `show aaa port-access mac-auth <interface>`
   - **Possible Causes:**
     - MAC address not in RADIUS database
     - Incorrect MAC format in RADIUS
     - MAB not correctly configured on the port
   - **Solution:**
     - Verify MAC address in RADIUS database
     - Check MAC format (delimiter, case)
     - Ensure MAB is enabled on the port

## Best Practices

1. **Authentication Configuration**
   - Use multi-auth mode for most access ports
   - Configure reasonable reauthentication period (8-24 hours)
   - Set appropriate tx-period (5-10 seconds)
   - Configure auth-fail VLAN for failed authentications
   - Configure critical VLAN for RADIUS server failures

2. **RADIUS Server Configuration**
   - Use multiple RADIUS servers for redundancy
   - Configure timeout and retransmit parameters
   - Use unique shared secrets per switch
   - Consider RADIUS accounting for auditing

3. **Security Hardening**
   - Enable BPDU protection on access ports
   - Configure admin-edge-port for faster convergence
   - Implement rate limiting on access ports
   - Consider MAC lockout for repeated failures
