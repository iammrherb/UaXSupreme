# Cisco WLC 9800 802.1X Troubleshooting and Verification Guide

## Key Verification Commands

### WLAN and Policy Verification

Check WLAN summary
show wlan summary

Check WLAN details
show wlan id <WLAN_ID> detail

Check policy profile
show wireless profile policy detailed <POLICY_PROFILE>

Check policy tag
show wireless tag policy detailed <POLICY_TAG_NAME>

Check client details
show wireless client detail <MAC_ADDRESS>

Check client summary
show wireless client summary


Copy

### AAA and RADIUS Verification

Check RADIUS server status
show aaa servers

Check RADIUS statistics
show radius statistics

Check RADIUS server group
show radius server-group all

Check AAA configuration
show run | include aaa


Copy

### Tag Deployment Verification

Check tag deployment
show wireless tag summary

Check AP tag assignment
show ap tag summary

Check AP details
show ap name <AP_NAME> detailed


Copy

### WLAN Authentication Debugging

Check client authentication
debug client <MAC_ADDRESS>

Check dot1x events
debug dot1x all

Check AAA events
debug aaa all

Check policy manager
debug policy-manager events

markdown

Copy

## Common Issues and Solutions

### Client Association Issues

1. **Client Can't Connect to WLAN**
   - **Symptoms:** Client unable to associate with the WLAN
   - **Verification:** `show wireless client summary`
   - **Possible Causes:** 
     - WLAN not enabled
     - WLAN not assigned to policy tag
     - Policy tag not assigned to AP
   - **Solution:** 
     - Enable WLAN
     - Assign WLAN to policy tag
     - Assign policy tag to APs

2. **Client Authentication Failures**
   - **Symptoms:** Client fails 802.1X authentication
   - **Verification:** `show wireless client detail <MAC_ADDRESS>`
   - **Possible Causes:**
     - Incorrect authentication method
     - RADIUS server not reachable
     - Client credentials/certificate issues
   - **Solution:**
     - Check RADIUS server connectivity
     - Verify authentication configuration
     - Check client supplicant settings

3. **RADIUS Server Communication Issues**
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

### Policy and Tag Issues

1. **Policy Profile Not Applied**
   - **Symptoms:** Client not getting correct VLAN or QoS
   - **Verification:** `show wireless profile policy detailed <POLICY_PROFILE>`
   - **Possible Causes:**
     - Policy profile misconfiguration
     - Policy tag not deployed
     - RADIUS attributes overriding policy
   - **Solution:**
     - Check policy profile configuration
     - Deploy policy tag
     - Verify RADIUS attributes

2. **Tag Deployment Issues**
   - **Symptoms:** APs not using the correct tags
   - **Verification:** `show ap tag summary`
   - **Possible Causes:**
     - Tags not deployed
     - AP tags manually configured differently
     - HA sync issues
   - **Solution:**
     - Deploy tags
     - Check AP configuration
     - Verify HA sync status

### High Availability Considerations

1. **HA Sync Issues**
   - **Symptoms:** Configuration differences between active and standby
   - **Verification:** `show redundancy state`
   - **Possible Causes:**
     - HA pair not properly formed
     - Configuration changes during sync
     - Software version mismatch
   - **Solution:**
     - Check HA status
     - Make configuration changes when pair is stable
     - Ensure matching software versions

2. **RADIUS Server High Availability**
   - **Symptoms:** Authentication failures during RADIUS server failover
   - **Verification:** `show aaa servers`
   - **Possible Causes:**
     - Deadtime too long
     - Only one RADIUS server configured
     - Failover detection parameters too high
   - **Solution:**
     - Configure multiple RADIUS servers
     - Adjust timeout and retransmit settings
     - Set appropriate deadtime

## Best Practices

1. **WLAN Configuration**
   - Use WPA2 Enterprise with AES encryption
   - Set appropriate session timeout (8-24 hours)
   - Enable AAA override for dynamic VLAN assignment
   - Consider 802.11r Fast Transition for voice/video clients

2. **RADIUS Server Configuration**
   - Use multiple RADIUS servers for redundancy
   - Set appropriate timeout (2-5 seconds) and retransmit (2-3 attempts)
   - Implement CoA for dynamic policy changes
   - Use unique shared secrets per WLC

3. **Policy Profile Setup**
   - Create separate policy profiles for different client types
   - Use VLAN selection based on client role
   - Configure appropriate QoS for voice/video clients
   - Enable AAA override in policy profiles

4. **Security Hardening**
   - Implement certificate-based authentication when possible
   - Consider client profiling for device classification
   - Implement role-based access control
   - Configure appropriate client exclusion policies

5. **Monitoring and Troubleshooting**
   - Regularly review authentication statistics
   - Set up logging for authentication events
   - Implement RADIUS accounting
   - Use conditional debugging for specific clients

## Wireless IOS-XE Software Version-Specific Notes

- **16.12.x:** Initial 9800 WLC software version
- **17.1.x:** Improved HA and client roaming
- **17.3.x:** Enhanced policy features and scale
- **17.4.x+:** Best overall stability for production
- **17.6.x+:** Advanced security features and performance improvements
- **17.9.x+:** Enhanced integration with Cisco DNA Center and ISE
