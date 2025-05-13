# Juniper JunOS 802.1X Troubleshooting and Verification Guide

## Key Verification Commands

### Authentication Status Commands

Check 802.1X status
show dot1x interface

Check detailed 802.1X interface status
show dot1x interface {{INTERFACE_NAME}} detail

Check 802.1X statistics
show dot1x interface {{INTERFACE_NAME}} statistics

Check MAC authentication
show dot1x mac-address

Check authentication sessions
show network-access aaa subscribers interface {{INTERFACE_NAME}}

Check VLAN assignments
show ethernet-switching interface {{INTERFACE_NAME}}


Copy

### RADIUS Communication

Check RADIUS server configuration
show radius-server

Check RADIUS statistics
show radius statistics

Check access profile
show access profile dot1x-profile

Check AAA statistics
show network-access aaa statistics radius


Copy

### Interface and Port Status

Check interface status
show interfaces {{INTERFACE_NAME}}

Check interface statistics
show interfaces {{INTERFACE_NAME}} statistics

Check spanning-tree status
show spanning-tree interface {{INTERFACE_NAME}}

markdown

Copy

## Common Issues and Solutions

### Authentication Failure Issues

1. **EAP Authentication Failures**
   - **Symptoms:** Client fails 802.1X authentication
   - **Verification:** `show dot1x interface {{INTERFACE_NAME}} detail`
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

## Best Practices

1. **Authentication Configuration**
   - Use supplicant multiple for most access ports
   - Configure reasonable reauthentication period (8-24 hours)
   - Set appropriate transmit-period (5-10 seconds)
   - Configure server-reject-vlan for failed authentications
   - Configure server-fail-vlan for RADIUS server failures

2. **RADIUS Server Configuration**
   - Use multiple RADIUS servers for redundancy
   - Configure timeout and retry parameters
   - Use unique shared secrets per switch
   - Enable RADIUS accounting for auditing
