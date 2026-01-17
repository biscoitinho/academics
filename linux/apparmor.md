## AppArmor - Application Security

### What is AppArmor?

AppArmor (Application Armor) is a Linux security module that provides **Mandatory Access Control (MAC)** by confining programs to a limited set of resources. It uses **profiles** to define what resources (files, capabilities, network access) each application can access.

### Key Concepts

**Profiles**: Define rules for what an application can do
- Located in `/etc/apparmor.d/`
- Text-based, human-readable

**Modes**:
- **Enforce**: Actively prevents policy violations
- **Complain**: Logs violations but allows them (audit mode)
- **Unconfined**: No restrictions applied

### Installation and Setup

```bash
# Install AppArmor (usually pre-installed on Ubuntu/Debian)
sudo apt install apparmor apparmor-utils apparmor-profiles apparmor-profiles-extra

# Check if AppArmor is enabled
sudo aa-enabled
sudo systemctl status apparmor

# Check AppArmor status
sudo aa-status

# Check kernel support
cat /sys/module/apparmor/parameters/enabled
```

### Basic Commands

#### View status

```bash
# Overall status
sudo aa-status

# Show loaded profiles
sudo apparmor_status

# Count profiles by mode
sudo aa-status | grep profiles

# Example output:
# 34 profiles are loaded.
# 32 profiles are in enforce mode.
# 2 profiles are in complain mode.
```

#### Managing profile modes

```bash
# Put profile in complain mode (audit/learning)
sudo aa-complain /etc/apparmor.d/usr.bin.firefox

# Put profile in enforce mode
sudo aa-enforce /etc/apparmor.d/usr.bin.firefox

# Disable profile (unload)
sudo aa-disable /etc/apparmor.d/usr.bin.firefox

# Enable profile (reload)
sudo aa-enforce /etc/apparmor.d/usr.bin.firefox

# Put all profiles in complain mode
sudo aa-complain /etc/apparmor.d/*

# Put all profiles in enforce mode
sudo aa-enforce /etc/apparmor.d/*
```

#### Reload and manage profiles

```bash
# Reload all profiles
sudo systemctl reload apparmor

# Reload specific profile
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.firefox

# Remove profile from kernel
sudo apparmor_parser -R /etc/apparmor.d/usr.bin.firefox

# Parse and load profile (with debug)
sudo apparmor_parser -v /etc/apparmor.d/usr.bin.firefox
```

### Profile Location and Structure

#### Profile locations

```bash
# Main profiles directory
/etc/apparmor.d/

# Abstractions (reusable components)
/etc/apparmor.d/abstractions/

# Tunables (variables)
/etc/apparmor.d/tunables/

# Local customizations
/etc/apparmor.d/local/

# Cache (compiled profiles)
/var/cache/apparmor/
```

#### Profile naming

Profiles are named after the full path of the executable with slashes replaced by dots:
- `/usr/bin/firefox` → `/etc/apparmor.d/usr.bin.firefox`
- `/usr/sbin/nginx` → `/etc/apparmor.d/usr.sbin.nginx`

### Profile Syntax

#### Basic profile structure

```bash
# /etc/apparmor.d/usr.bin.example

#include <tunables/global>

/usr/bin/example {
  #include <abstractions/base>

  # File access rules
  /etc/example.conf r,              # Read
  /var/log/example.log w,           # Write
  /tmp/** rw,                       # Read/write in /tmp
  /home/*/.example/** rw,           # User config files

  # Capabilities
  capability net_bind_service,      # Bind to ports < 1024

  # Network access
  network inet stream,              # TCP
  network inet dgram,               # UDP

  # Execute rules
  /bin/bash ix,                     # Inherit profile
  /usr/bin/helper Px,               # Use helper's profile

  # Deny rules
  deny /etc/shadow r,               # Explicitly deny
}
```

#### File access modes

```bash
r     # Read
w     # Write
a     # Append
k     # Lock
l     # Link
m     # Memory map with PROT_EXEC
x     # Execute

# Execute modes:
ix    # Inherit current profile
Px    # Use new profile, scrub environment
Cx    # Use child profile
Ux    # Execute unconfined
px    # Use new profile, keep environment
ux    # Execute unconfined (dangerous!)
```

#### Common patterns

```bash
# Wildcards
*         # Match anything except /
**        # Match anything including /
?         # Match single character
[abc]     # Match a, b, or c
{a,b}     # Match a or b

# Examples:
/etc/*.conf r,                    # All .conf in /etc
/var/log/** w,                    # All files under /var/log
/home/*/.config/** rw,            # All user configs
/tmp/file-[0-9]* rw,              # Numbered temp files
/etc/{passwd,group} r,            # Multiple specific files
```

#### Abstractions

```bash
# Include common abstractions
#include <abstractions/base>           # Basic system files
#include <abstractions/nameservice>    # DNS, NSS
#include <abstractions/ssl-certs>      # SSL certificates
#include <abstractions/dbus>           # D-Bus access
#include <abstractions/user-tmp>       # /tmp access
#include <abstractions/audio>          # Audio devices
#include <abstractions/X>              # X11 display
```

### Creating Profiles

#### Manual profile creation

```bash
# Create new profile
sudo vim /etc/apparmor.d/usr.bin.myapp

#include <tunables/global>

/usr/bin/myapp {
  #include <abstractions/base>

  /usr/bin/myapp r,
  /etc/myapp/** r,
  /var/lib/myapp/** rw,
  /var/log/myapp.log w,

  capability net_bind_service,
  network inet stream,
}

# Load profile
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.myapp

# Set to enforce
sudo aa-enforce /etc/apparmor.d/usr.bin.myapp
```

#### Using aa-genprof (interactive profile generation)

```bash
# Start profile generation
sudo aa-genprof /usr/bin/myapp

# In another terminal, run the application
# and exercise all its functionality
/usr/bin/myapp

# Back in aa-genprof:
# - Press 'S' to scan logs
# - Choose options for each event
# - 'A' to allow, 'D' to deny, 'I' to ignore
# - 'F' to finish

# Profile saved to /etc/apparmor.d/
```

#### Using aa-logprof (update from logs)

```bash
# Put profile in complain mode
sudo aa-complain /etc/apparmor.d/usr.bin.myapp

# Run application and generate events
/usr/bin/myapp

# Update profile from logs
sudo aa-logprof

# Review and approve suggested rules
# 'A' to allow, 'D' to deny
# 'S' to save

# Put back in enforce mode
sudo aa-enforce /etc/apparmor.d/usr.bin.myapp
```

### Example Profiles

#### Simple web server

```bash
# /etc/apparmor.d/usr.bin.webserver

#include <tunables/global>

/usr/bin/webserver {
  #include <abstractions/base>
  #include <abstractions/nameservice>
  #include <abstractions/ssl-certs>

  # Executable
  /usr/bin/webserver mr,

  # Configuration
  /etc/webserver/** r,

  # Content
  /var/www/** r,

  # Logs
  /var/log/webserver/** w,

  # PID file
  /var/run/webserver.pid w,

  # Capabilities
  capability net_bind_service,
  capability setuid,
  capability setgid,

  # Network
  network inet stream,
  network inet6 stream,
}
```

#### Application with child processes

```bash
# /etc/apparmor.d/usr.bin.parent

#include <tunables/global>

/usr/bin/parent {
  #include <abstractions/base>

  /usr/bin/parent mr,
  /usr/bin/child Px,            # Child uses its own profile

  /tmp/** rw,

  # Child profile
  profile /usr/bin/child {
    #include <abstractions/base>

    /usr/bin/child mr,
    /tmp/** r,                   # Child only reads from /tmp
    /var/lib/child/** rw,
  }
}
```

#### Deny-by-default profile

```bash
# /etc/apparmor.d/usr.bin.restricted

#include <tunables/global>

/usr/bin/restricted {
  #include <abstractions/base>

  # Executable
  /usr/bin/restricted mr,

  # Specific allowed paths only
  /etc/restricted.conf r,
  /var/lib/restricted/** rw,

  # Deny everything else explicitly
  deny /** w,                    # No writes anywhere else
  deny /home/** r,               # No reading home dirs
  deny /root/** rw,              # No access to root
  deny /etc/shadow r,            # No password file

  # No network
  deny network,
}
```

### Local Customizations

```bash
# Don't edit main profiles directly
# Use local includes instead

# Main profile includes local customization:
# /etc/apparmor.d/usr.bin.myapp
#include <tunables/global>

/usr/bin/myapp {
  #include <abstractions/base>

  # ... default rules ...

  #include <local/usr.bin.myapp>    # Local customizations
}

# Add custom rules to local file:
# /etc/apparmor.d/local/usr.bin.myapp
/custom/path/** rw,
/opt/mydata/** rw,

# Reload profile
sudo apparmor_parser -r /etc/apparmor.d/usr.bin.myapp
```

### Debugging and Troubleshooting

#### View denials in logs

```bash
# Check audit log
sudo grep -i apparmor /var/log/syslog
sudo grep -i denied /var/log/syslog

# Check audit daemon logs
sudo ausearch -m avc -ts recent
sudo ausearch -m avc -c firefox

# Follow logs in real-time
sudo tail -f /var/log/syslog | grep apparmor
sudo tail -f /var/log/audit/audit.log | grep denied

# Using journalctl
sudo journalctl -f -u apparmor
sudo journalctl | grep -i denied
```

#### Common denial messages

```bash
# File access denied
type=AVC msg=audit(...): apparmor="DENIED" operation="open" profile="/usr/bin/myapp" name="/etc/secret.conf" requested_mask="r"

# Network access denied
type=AVC msg=audit(...): apparmor="DENIED" operation="connect" profile="/usr/bin/myapp" family="inet" sock_type="stream"

# Capability denied
type=AVC msg=audit(...): apparmor="DENIED" operation="capable" profile="/usr/bin/myapp" capname="net_admin"
```

#### Debug profile issues

```bash
# Check profile syntax
sudo apparmor_parser -p /etc/apparmor.d/usr.bin.myapp

# Dry run (don't load)
sudo apparmor_parser -d /etc/apparmor.d/usr.bin.myapp

# Verbose output
sudo apparmor_parser -v /etc/apparmor.d/usr.bin.myapp

# Debug mode
sudo apparmor_parser -D /etc/apparmor.d/usr.bin.myapp
```

#### Test profile

```bash
# 1. Put in complain mode
sudo aa-complain /etc/apparmor.d/usr.bin.myapp

# 2. Run application
/usr/bin/myapp

# 3. Check for denials
sudo grep denied /var/log/syslog

# 4. Update profile if needed
sudo aa-logprof

# 5. Put in enforce mode
sudo aa-enforce /etc/apparmor.d/usr.bin.myapp

# 6. Test again
/usr/bin/myapp
```

#### Bypass for debugging

```bash
# Temporarily disable AppArmor
sudo systemctl stop apparmor

# Unload all profiles
sudo systemctl stop apparmor
sudo systemctl disable apparmor

# Test if AppArmor is causing issue
sudo aa-complain /etc/apparmor.d/*

# Re-enable
sudo systemctl start apparmor
sudo systemctl enable apparmor
```

### Common Applications

#### Firefox

```bash
# Disable Firefox profile (can be restrictive)
sudo aa-disable /etc/apparmor.d/usr.bin.firefox

# Or put in complain mode
sudo aa-complain /etc/apparmor.d/usr.bin.firefox
```

#### Nginx

```bash
# View Nginx profile
cat /etc/apparmor.d/usr.sbin.nginx

# Customize
sudo vim /etc/apparmor.d/local/usr.sbin.nginx
# Add custom paths:
/var/www/mysite/** r,

# Reload
sudo systemctl reload apparmor
```

#### Docker

```bash
# Docker creates profiles dynamically
# View loaded Docker profiles
sudo aa-status | grep docker

# Default Docker profile template
/etc/apparmor.d/docker

# Disable AppArmor for specific container
docker run --security-opt apparmor=unconfined myimage
```

### Best Practices

1. **Start with complain mode**
   ```bash
   sudo aa-complain /etc/apparmor.d/usr.bin.myapp
   ```

2. **Use abstractions** - Don't reinvent common rules
   ```bash
   #include <abstractions/base>
   ```

3. **Use local includes** - Keep customizations separate
   ```bash
   #include <local/usr.bin.myapp>
   ```

4. **Test thoroughly** - Exercise all application features

5. **Monitor logs** - Watch for unexpected denials
   ```bash
   sudo tail -f /var/log/syslog | grep denied
   ```

6. **Principle of least privilege** - Only allow what's needed

7. **Document changes** - Comment your profiles
   ```bash
   # Allow access to custom data directory (2024-01-15)
   /opt/custom/** rw,
   ```

8. **Keep profiles updated** - When application changes

9. **Use deny rules sparingly** - Allow-by-default is better

10. **Backup before changes**
    ```bash
    sudo cp /etc/apparmor.d/usr.bin.myapp{,.bak}
    ```

### AppArmor vs SELinux

| Feature | AppArmor | SELinux |
|---------|----------|---------|
| Complexity | Simpler, path-based | More complex, context-based |
| Learning curve | Easier | Steeper |
| Profiles | Human-readable text | Policy language |
| Distribution | Ubuntu, Debian, SUSE | RHEL, CentOS, Fedora |
| File identification | Path names | Labels/contexts |
| Granularity | Less granular | More granular |

Choose AppArmor if:
- You want simpler, path-based security
- You're on Ubuntu/Debian/SUSE
- You need easier profile management

### Quick Reference

```bash
# Status
sudo aa-status                         # View all profiles
sudo aa-enabled                        # Check if enabled

# Mode changes
sudo aa-enforce /etc/apparmor.d/profile   # Enforce mode
sudo aa-complain /etc/apparmor.d/profile  # Complain mode
sudo aa-disable /etc/apparmor.d/profile   # Disable profile

# Profile generation
sudo aa-genprof /usr/bin/app           # Generate new profile
sudo aa-logprof                        # Update from logs

# Reload
sudo systemctl reload apparmor         # Reload all
sudo apparmor_parser -r /etc/apparmor.d/profile  # Reload one

# Logs
sudo grep denied /var/log/syslog       # View denials
sudo journalctl -f | grep apparmor     # Follow logs

# Debug
sudo apparmor_parser -p /etc/apparmor.d/profile  # Check syntax
sudo apparmor_parser -v /etc/apparmor.d/profile  # Verbose load
```
