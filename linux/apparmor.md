## AppArmor

AppArmor provides Mandatory Access Control using path-based profiles.

### Status and Management

```bash
# Check status
sudo aa-status
sudo aa-enabled

# Profile modes
sudo aa-complain /etc/apparmor.d/usr.bin.firefox  # Complain (audit)
sudo aa-enforce /etc/apparmor.d/usr.bin.firefox   # Enforce
sudo aa-disable /etc/apparmor.d/usr.bin.firefox   # Disable

# Reload
sudo systemctl reload apparmor
sudo apparmor_parser -r /etc/apparmor.d/profile
```

### Profile Syntax

```bash
# /etc/apparmor.d/usr.bin.example
#include <tunables/global>

/usr/bin/example {
  #include <abstractions/base>

  # File access
  /etc/example.conf r,              # Read
  /var/log/example.log w,           # Write
  /tmp/** rw,                       # Read/write

  # Capabilities
  capability net_bind_service,

  # Network
  network inet stream,

  # Execute
  /bin/bash ix,
}
```

### Create Profile

```bash
# Generate interactively
sudo aa-genprof /usr/bin/myapp

# Update from logs
sudo aa-logprof

# Manual profile
sudo vim /etc/apparmor.d/usr.bin.myapp
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.myapp
```

### Debugging

```bash
# View denials
sudo grep denied /var/log/syslog
sudo journalctl | grep -i denied

# Check syntax
sudo apparmor_parser -p /etc/apparmor.d/profile

# Test in complain mode
sudo aa-complain /etc/apparmor.d/profile
# Run application
sudo aa-logprof
sudo aa-enforce /etc/apparmor.d/profile
```

### Quick Reference

```bash
# Status
sudo aa-status

# Modes
sudo aa-enforce /etc/apparmor.d/profile
sudo aa-complain /etc/apparmor.d/profile
sudo aa-disable /etc/apparmor.d/profile

# Create/update
sudo aa-genprof /usr/bin/app
sudo aa-logprof

# Debug
sudo grep denied /var/log/syslog
sudo apparmor_parser -p /etc/apparmor.d/profile
```
