# MAC Authentication Bypass (MAB)

## Overview

MAC Authentication Bypass (MAB) is an authentication method that uses a device's MAC address as its identity credential. It serves as a fallback authentication mechanism for devices that don't support 802.1X supplicants, providing a way to authenticate devices based on their hardware address rather than username/password or certificate credentials.

## How MAB Works

1. **Authentication Flow**
   - Device connects to a switch port
   - Switch attempts 802.1X authentication (if configured)
   - If 802.1X authentication times out or fails
   - Switch captures the device's MAC address
   - MAC address is sent to RADIUS server as both username and password
   - RADIUS server checks if MAC address is authorized
   - If authorized, access is granted based on RADIUS attributes

2. **Implementation Options**
   - **Sequential (After 802.1X)**: MAB occurs only after 802.1X times out
   - **Concurrent (Simultaneous)**: MAB runs at the same time as 802.1X
   - **Standalone**: MAB is the only authentication method on the port

3. **MAC Address Format Options**
   - **Delimiters**: None (aabbccddeeff), hyphen (aa-bb-cc-dd-ee-ff), colon (aa:bb:cc:dd:ee:ff)
   - **Case**: Uppercase (AABBCCDDEEFF) or lowercase (aabbccddeeff)
   - Must match format expected by RADIUS server

## Use Cases

1. **Device Types**
   - **IP Phones**: Legacy devices without 802.1X support
   - **Printers**: Network printers often lack 802.1X capabilities
   - **IoT Devices**: Cameras, sensors, industrial equipment
   - **Medical Equipment**: Legacy medical devices
   - **Building Controls**: HVAC, lighting, access control systems

2. **Deployment Scenarios**
   - **Transition Strategy**: During 802.1X rollout
   - **Mixed Environment**: Supporting both 802.1X and non-802.1X devices
   - **Limited Device Control**: Guest or contractor-owned devices
   - **Legacy Equipment Support**: Maintaining compatibility with older devices

3. **Security Considerations**
   - **Risk Level**: Higher than 802.1X, lower than open access
   - **Threat Surface**: MAC addresses can be spoofed
   - **Mitigation**: Combine with device profiling and posture assessment
   - **Monitoring**: Implement anomaly detection for suspicious behavior

## Configuration Best Practices

1. **RADIUS Server Configuration**
   - Maintain current database of authorized MAC addresses
   - Use descriptive naming for MAC address entries
   - Group similar devices for easier management
   - Configure appropriate authorization attributes
   - Consider separate identity stores for MAB vs 802.1X

2. **Switch Configuration**
   - Configure consistent MAC format across all devices
   - Set appropriate timers for MAB fallback
   - Consider host mode implications (multi-auth vs single-host)
   - Implement appropriate security controls
   - Document exceptions and special configurations

3. **Security Enhancements**
   - Combine with device profiling for validation
   - Implement dynamic VLAN assignment
   - Apply appropriate ACLs to limit network access
   - Consider MAC address aging or periodic revalidation
   - Implement logging and monitoring

4. **Operational Management**
   - Document authorized MAB devices
   - Implement MAC address lifecycle management
   - Regular auditing of MAB database
   - Monitor for unusual authentication patterns
   - Review security logs regularly

## Vendor-Specific Implementation

### Cisco

1. **MAC Format**
   - Default: No delimiter, lowercase
   - Configurable with `radius-server attribute 31 mac format [ietf | cisco]`
   - Case configurable with `radius-server attribute 31 mac format [upper-case | lower-case]`

2. **Configuration Commands**
   - IBNS 1.0: `mab`
   - IBNS 2.0: `mab` and policy-map with `authenticate using mab priority 20`

3. **Sequential vs Concurrent**
   - Sequential: Default behavior
   - Concurrent: Requires IBNS 2.0 with `do-all` action in policy-map

### Aruba

1. **MAC Format**
   - Default: No delimiter, uppercase
   - Configurable with `aaa port-access mac-auth addr-format [no-delimiter | single-dash | multi-dash | single-colon | multi-colon]`
   - Case configurable with `aaa port-access mac-auth addr-format [uppercase | lowercase]`

2. **Configuration Commands**
   - AOS-CX: `aaa port-access mac-auth {{MAB_PROFILE}}`
   - AOS-Switch: `aaa port-access mac-auth`

### Juniper

1. **MAC Format**
   - Default: Hyphen delimiter, lowercase
   - Configurable in RADIUS server profile

2. **Configuration Commands**
   - `mac-radius` under 802.1X authenticator configuration
   - Parameters for restrict/authentication order

### Other Vendors

Each vendor has their own implementation details, configuration commands, and default settings.

## Troubleshooting MAB

1. **Common Issues**
   - MAC address not in RADIUS database
   - MAC format mismatch
   - MAB not enabled on port
   - Timers set incorrectly
   - Authorization failure

2. **Verification Commands**
   - Authentication status
   - Client information
   - RADIUS statistics
   - Debug/packet capture

3. **Methodology**
   - Verify configuration on switch and RADIUS
   - Check authentication logs
   - Test with known working device
   - Isolate formatting issues
   - Validate RADIUS connectivity

## Security Considerations

1. **Inherent Risks**
   - MAC addresses can be easily spoofed
   - No cryptographic verification
   - Physical access may allow bypass
   - Limited identity validation

2. **Mitigation Strategies**
   - Implement device profiling
   - Combine with posture assessment
   - Apply restrictive authorization
   - Monitor for unusual patterns
   - Use physical security controls

3. **Best Practices**
   - Use MAB only when 802.1X is not possible
   - Apply principle of least privilege
   - Implement defense in depth
   - Regular security reviews
   - Maintain accurate inventory

## Integration with Other Technologies

1. **Device Profiling**
   - Validates device type matches MAC
   - Uses DHCP, HTTP, and other fingerprinting
   - Enhances security of MAB
   - Detects MAC spoofing attempts

2. **Dynamic Authorization**
   - Allows policy changes based on behavior
   - Supports quarantine for suspicious devices
   - Enables adaptive network access
   - Critical for security response

3. **Network Segmentation**
   - Places MAB devices in appropriate zones
   - Limits exposure of critical systems
   - Controls lateral movement
   - Aligns with zero trust principles

4. **Security Monitoring**
   - Detects anomalous behavior
   - Identifies potential MAC spoofing
   - Monitors session characteristics
   - Enables security response

## Conclusion

While MAB provides a useful fallback authentication mechanism for devices that can't support 802.1X, it should be implemented with an understanding of its security limitations. By combining MAB with other security technologies like device profiling, network segmentation, and continuous monitoring, organizations can achieve a reasonable security posture while supporting legacy and IoT devices.
