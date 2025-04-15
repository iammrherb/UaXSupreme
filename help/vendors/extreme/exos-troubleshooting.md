# Extreme EXOS 802.1X Troubleshooting and Verification Guide

## Key Verification Commands

### Authentication Status Commands

Check Network Login configuration
show netlogin

Check Network Login port configuration
show netlogin port {{PORT_LIST}}

Check authenticated clients
show netlogin session

Check RADIUS configuration
show radius

Check RADIUS statistics
show radius statistics

Check VLAN configuration
show vlan

markdown

Copy

## Common Issues and Solutions

1. **Authentication Failures**
   - **Symptoms:** Client cannot authenticate
   - **Verification:** Check session status with `show netlogin session`
   - **Solution:** Verify RADIUS server connectivity and credentials

2. **VLAN Assignment Issues**
   - **Symptoms:** Client not placed in correct VLAN
   - **Verification:** Check `show netlogin session` for VLAN assignment
   - **Solution:** Verify RADIUS attributes and VLAN configuration

3. **MAC Authentication Problems**
   - **Symptoms:** MAC authentication failing
   - **Verification:** Check MAC list with `show netlogin mac`
   - **Solution:** Verify MAC format and database entries

## Best Practices

1. Use appropriate authentication mode for your environment
2. Configure redundant RADIUS servers
3. Implement guest VLAN for non-802.1X devices
4. Set reasonable reauthentication periods
5. Document special configurations
