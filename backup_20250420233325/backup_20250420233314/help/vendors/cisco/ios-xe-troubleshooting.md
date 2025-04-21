# Cisco IOS-XE 802.1X Troubleshooting and Verification Guide

## Key Verification Commands

### Authentication Status Commands

Check 802.1X system status
show dot1x

Check 802.1X interface status
show dot1x interface <interface>

Check authentication sessions
show authentication sessions [interface <interface>]

Check detailed session information
show authentication sessions interface <interface> details

Check authentication manager status
show authentication manager

Check Class Maps
show class-map type control subscriber all

Check Policy Maps
show policy-map type control subscriber <policy_name>

Check Policy Map statistics
show policy-map interface <interface> type control subscriber

Check access-session information
show access-session interface <interface> details


Copy

### RADIUS Communication

Check RADIUS server status
show aaa servers

Check RADIUS statistics
show radius statistics

Check RADIUS server group
show radius server-group [<group-name>]

Check pending RADIUS requests
show radius pending


Copy

### Device Tracking

Check device tracking status
show device-tracking database

Check device tracking policies
show device-tracking policy <policy-name>

Check device tracking counters
show device-tracking counters


Copy

### Interface and Port Status

Check interface status
show interfaces <interface> status

Check interface switchport configuration
show interfaces <interface> switchport

Check spanning-tree status (for portfast/bpduguard)
show spanning-tree interface <interface> detail

Check template application
show derived-config interface <interface>

angelscript

Copy

## Common Issues and Solutions

### Authentication Failure Issues

1. **EAP Authentication Failures**
   - **Symptoms:** Client fails 802.1X authentication with EAP failure
   - **Verification:** `show authentication sessions interface <interface> details`
   - **Possible Causes:** 
     - Invalid credentials or certificate
     - EAP method mismatch
     - RADIUS server policy issues
   - **Solution:** 
     - Verify EAP method configuration on client and server
     - Check RADIUS server logs for specific failure reason
     - Ensure time synchronization if using certificates

2. **RADIUS Server Connectivity Issues**
   - **Symptoms:** Authentication timeouts, server marked dead
   - **Verification:** `show aaa servers`
   - **Possible Causes:**
     - Network connectivity issues
     - Incorrect RADIUS shared secret
     - Firewall blocking RADIUS traffic
   - **Solution:**
     - Verify connectivity to RADIUS server (ping)
     - Check shared secret configuration
     - Verify port connectivity (UDP 1812/1813)

3. **MAB Authentication Failures**
   - **Symptoms:** MAB authentication fails after 802.1X timeout
   - **Verification:** `show authentication sessions interface <interface> details`
   - **Possible Causes:**
     - MAC address not in RADIUS database
     - Incorrect MAC format in RADIUS
     - MAB not correctly configured on the port
   - **Solution:**
     - Verify MAC address in RADIUS database
     - Check MAC format (delimiter, case)
     - Ensure MAB is enabled on the port

### Configuration Issues

1. **Policy Map Not Applied**
   - **Symptoms:** Authentication behavior doesn't match policy configuration
   - **Verification:** `show policy-map type control subscriber <policy_name>`
   - **Possible Causes:**
     - Policy not applied to template
     - Template not applied to interface
     - Syntax error in policy map
   - **Solution:**
     - Verify policy map configuration
     - Check template configuration
     - Apply template to interface

2. **Critical Authentication Issues**
   - **Symptoms:** Devices not getting access when RADIUS server is down
   - **Verification:** `show authentication sessions interface <interface> details`
   - **Possible Causes:**
     - Critical authentication not configured
     - Critical VLAN not defined
     - Service templates not correctly configured
   - **Solution:**
     - Configure critical authentication
     - Define critical VLAN
     - Verify service template configuration

3. **Device Tracking Issues**
   - **Symptoms:** IP-based features not working correctly (dACLs, URL-redirect)
   - **Verification:** `show device-tracking database`
   - **Possible Causes:**
     - Device tracking policy not attached to interface
     - Incorrect policy parameters
     - IPv6 issues with device tracking
   - **Solution:**
     - Attach proper policy to interface
     - Adjust policy parameters
     - Disable IPv6 tracking if not needed

### Performance and Scale Issues

1. **High CPU During Authentication Storms**
   - **Symptoms:** High CPU utilization during multiple simultaneous authentications
   - **Verification:** `show processes cpu history`
   - **Possible Causes:**
     - Too many simultaneous authentications
     - Low tx-period timer values
     - RADIUS server latency
   - **Solution:**
     - Stagger device connections
     - Adjust tx-period and other timers
     - Consider authentication rate limiting

2. **Memory Issues with Large Session Tables**
   - **Symptoms:** Memory depletion with large number of authenticated sessions
   - **Verification:** `show memory statistics`
   - **Possible Causes:**
     - Too many authenticated sessions
     - Memory leaks
   - **Solution:**
     - Optimize authentication session count
     - Upgrade IOS version if memory leak suspected
     - Consider hardware with more memory

## Best Practices

1. **Authentication Timers**
   - Set reasonable tx-period (5-10 seconds) to balance responsiveness and overhead
   - Configure 2-3 max-reauth-req values to allow for network delays
   - Use server-assigned reauthentication periods when possible

2. **RADIUS Server Configuration**
   - Configure both primary and secondary RADIUS servers
   - Use unique shared secrets per device
   - Enable RADIUS server automate-tester to detect server failures
   - Configure deadtime (15 minutes recommended) to avoid overloading servers

3. **Security Hardening**
   - Implement BPDU guard and portfast on access ports
   - Configure storm control to prevent broadcast storms
   - Use device tracking to enable dynamic ACLs
   - Consider implementing DHCP snooping and dynamic ARP inspection

4. **Monitoring and Logging**
   - Use logging discriminators to filter 802.1X related logs
   - Configure RADIUS accounting for auditing
   - Consider implementing SNMP monitoring for authentication failures
   - Regularly review authentication statistics

5. **Deployment Strategy**
   - Start with monitor mode (open authentication)
   - Gradually transition to closed mode
   - Use guest VLAN for devices without 802.1X capability
   - Implement critical authentication for RADIUS server failures

6. **Template Usage**
   - Use templates for consistent port configuration
   - Separate templates for different port types (access, trunk)
   - Verify template application with `show derived-config`
   - Be aware that some template commands may not survive reloads in certain IOS versions

## Debugging Commands

**Note:** Use debugging commands with caution in production environments as they can increase CPU utilization.

Basic 802.1X debugging
debug dot1x all

Authentication manager debugging
debug authentication all

RADIUS debugging
debug radius authentication
debug radius accounting

AAA debugging
debug aaa authentication
debug aaa authorization

Policy map debugging
debug policy-map control subscriber all

routeros

Copy

## IOS-XE Version-Specific Notes

- **16.9.x**: Enhanced device-tracking replacing IP device tracking
- **16.12.x**: Improved policy map performance and scalability
- **17.1.x+**: Enhanced service templates and critical authentication
- **17.3.x+**: Improved integration with Cisco ISE pxGrid features
- **17.6.x+**: Enhanced VLAN assignment and authorization features
