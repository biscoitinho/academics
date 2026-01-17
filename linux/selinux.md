## SELinux - Security-Enhanced Linux

### What is SELinux?

SELinux (Security-Enhanced Linux) is a Linux security module that provides **Mandatory Access Control (MAC)** through security policies. Unlike traditional Linux permissions (DAC - Discretionary Access Control), SELinux adds an additional layer of security by labeling all system resources (files, processes, ports, etc.) and enforcing policies on their interactions.

Originally developed by the NSA, now maintained by Red Hat.

### Key Concepts

**Security Context (Label)**: Every resource has a context in format:
```
user:role:type:level
```

**Modes**:
- **Enforcing**: SELinux enforces policies, denies access
- **Permissive**: Logs violations but allows them (audit mode)
- **Disabled**: SELinux is turned off

**Policy Types**:
- **Targeted**: Only specific processes are confined (default)
- **Strict**: All processes are confined
- **MLS**: Multi-Level Security (classified environments)

### Installation and Setup

```bash
# Install SELinux (RHEL/CentOS/Fedora - usually pre-installed)
sudo dnf install selinux-policy selinux-policy-targeted

# Install tools
sudo dnf install policycoreutils policycoreutils-python-utils setroubleshoot-server

# On Debian/Ubuntu (not default)
sudo apt install selinux-basics selinux-policy-default auditd
```

### Checking SELinux Status

```bash
# Check if SELinux is enabled
getenforce

# Detailed status
sestatus

# Example output:
# SELinux status:                 enabled
# SELinuxfs mount:                /sys/fs/selinux
# SELinux root directory:         /etc/selinux
# Loaded policy name:             targeted
# Current mode:                   enforcing
# Mode from config file:          enforcing
# Policy MLS status:              enabled
# Policy deny_unknown status:     allowed
```

### Changing SELinux Modes

#### Temporary mode change (until reboot)

```bash
# Set to permissive
sudo setenforce 0
sudo setenforce Permissive

# Set to enforcing
sudo setenforce 1
sudo setenforce Enforcing

# Check current mode
getenforce
```

#### Permanent mode change

```bash
# Edit config file
sudo vim /etc/selinux/config

# Set mode:
SELINUX=enforcing    # Enforce policies
SELINUX=permissive   # Log but don't enforce
SELINUX=disabled     # Disable SELinux

# Reboot required
sudo reboot

# Note: Changing from disabled to enabled requires filesystem relabel
sudo touch /.autorelabel
sudo reboot
```

### Security Contexts

#### View contexts

```bash
# View file contexts
ls -Z /path/to/file
ls -lZ /path/to/directory/

# View process contexts
ps -eZ
ps -efZ | grep httpd

# View current user context
id -Z

# View port contexts
sudo semanage port -l

# View boolean values
getsebool -a
```

#### Understanding context format

```
user:role:type:level

Example: system_u:object_r:httpd_sys_content_t:s0

- user: SELinux user (system_u, unconfined_u, user_u)
- role: Role (object_r for files, system_r for processes)
- type: Type/domain (most important part)
- level: MLS/MCS level (s0 = no level)
```

#### Change file contexts temporarily

```bash
# Change type (temporary - reset on relabel)
sudo chcon -t httpd_sys_content_t /var/www/html/index.html

# Change entire context
sudo chcon -u system_u -r object_r -t httpd_sys_content_t file.txt

# Copy context from reference file
sudo chcon --reference=/var/www/html/index.html newfile.html

# Recursive
sudo chcon -R -t httpd_sys_content_t /var/www/html/
```

#### Change file contexts permanently

```bash
# Set policy for file (survives relabel)
sudo semanage fcontext -a -t httpd_sys_content_t "/web/content(/.*)?"

# Apply the context
sudo restorecon -Rv /web/content

# List custom contexts
sudo semanage fcontext -l -C

# Delete custom context
sudo semanage fcontext -d "/web/content(/.*)?"
```

#### Restore default contexts

```bash
# Restore single file
sudo restorecon -v /var/www/html/index.html

# Restore directory recursively
sudo restorecon -Rv /var/www/html/

# Force restore (even if context looks correct)
sudo restorecon -Fv /path/to/file

# Full system relabel (slow!)
sudo touch /.autorelabel
sudo reboot
```

### Common File Contexts (Types)

```bash
# Web server content
httpd_sys_content_t          # Read-only web content
httpd_sys_rw_content_t       # Read-write web content
httpd_sys_script_exec_t      # CGI scripts

# Database
mysqld_db_t                  # MySQL data files
postgresql_db_t              # PostgreSQL data files

# User files
user_home_t                  # User home directories
user_tmp_t                   # User temp files

# System
etc_t                        # /etc files
var_log_t                    # Log files
tmp_t                        # /tmp files
```

### SELinux Booleans

Booleans are on/off switches for SELinux policies.

```bash
# List all booleans
getsebool -a

# Get specific boolean
getsebool httpd_can_network_connect

# Set boolean temporarily
sudo setsebool httpd_can_network_connect on

# Set boolean permanently
sudo setsebool -P httpd_can_network_connect on

# Common booleans:
httpd_can_network_connect       # Allow httpd to connect to network
httpd_enable_homedirs           # Allow httpd to access home directories
httpd_execmem                   # Allow httpd to execute memory
ftpd_full_access                # Allow FTP full access
allow_ftpd_anon_write          # Allow anonymous FTP uploads
```

### Port Management

```bash
# List all port contexts
sudo semanage port -l

# List specific service ports
sudo semanage port -l | grep http

# Add port to context
sudo semanage port -a -t http_port_t -p tcp 8080

# Modify existing port
sudo semanage port -m -t http_port_t -p tcp 8080

# Delete port context
sudo semanage port -d -t http_port_t -p tcp 8080

# Common port types:
http_port_t                  # HTTP/HTTPS (80, 443, 8080, etc.)
ssh_port_t                   # SSH (22)
smtp_port_t                  # SMTP (25, 587)
mysql_port_t                 # MySQL (3306)
```

### Troubleshooting SELinux

#### View denials in logs

```bash
# Audit log (main location)
sudo ausearch -m avc -ts recent
sudo ausearch -m avc -ts today

# All SELinux denials today
sudo ausearch -m AVC,USER_AVC,SELINUX_ERR,USER_SELINUX_ERR -ts today

# Search for specific process
sudo ausearch -m avc -c httpd

# Using grep
sudo grep denied /var/log/audit/audit.log
sudo grep AVC /var/log/audit/audit.log

# Follow in real-time
sudo tail -f /var/log/audit/audit.log | grep denied
```

#### Understanding denial messages

```bash
# Example denial:
type=AVC msg=audit(1234567890.123:456): avc: denied { write } for pid=1234 comm="httpd" name="index.html" dev="sda1" ino=678901 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:user_home_t:s0 tclass=file permissive=0

# Breaking it down:
# denied { write }           - Action that was denied
# comm="httpd"               - Process trying to access
# name="index.html"          - File being accessed
# scontext=...httpd_t        - Source context (process)
# tcontext=...user_home_t    - Target context (file)
# tclass=file                - Class of object
```

#### Using sealert (setroubleshoot)

```bash
# Install
sudo dnf install setroubleshoot-server

# Analyze recent denials
sudo sealert -a /var/log/audit/audit.log

# Analyze specific alert
sudo sealert -l 12345678-1234-1234-1234-123456789012

# Follow in real-time
sudo journalctl -f -u auditd | grep sealert

# sealert provides:
# - Description of the problem
# - Why it happened
# - How to fix it
```

#### Common issues and solutions

**Issue**: Web server can't access files

```bash
# Check context
ls -Z /var/www/html/file.html

# Fix context
sudo restorecon -v /var/www/html/file.html
# Or
sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
sudo restorecon -Rv /var/www/html/
```

**Issue**: Web server can't connect to database

```bash
# Check boolean
getsebool httpd_can_network_connect_db

# Enable
sudo setsebool -P httpd_can_network_connect_db on
```

**Issue**: Service can't bind to custom port

```bash
# Check port context
sudo semanage port -l | grep 8080

# Add port
sudo semanage port -a -t http_port_t -p tcp 8080
```

**Issue**: Service can't access custom directory

```bash
# Set context policy
sudo semanage fcontext -a -t httpd_sys_content_t "/custom/path(/.*)?"

# Apply context
sudo restorecon -Rv /custom/path/
```

### Creating Custom Policies

#### Using audit2allow

```bash
# Generate policy from denials
sudo ausearch -m avc -ts recent | audit2allow

# Create policy module
sudo ausearch -m avc -ts recent | audit2allow -M mypolicy

# Install policy module
sudo semodule -i mypolicy.pp

# Example workflow:
# 1. Put SELinux in permissive for testing
sudo setenforce 0

# 2. Run application and generate denials
/path/to/myapp

# 3. Generate policy from denials
sudo ausearch -m avc -c myapp | audit2allow -M myapp

# 4. Install policy
sudo semodule -i myapp.pp

# 5. Put back in enforcing
sudo setenforce 1

# 6. Test
/path/to/myapp
```

#### Managing policy modules

```bash
# List installed modules
sudo semodule -l

# Install module
sudo semodule -i module.pp

# Remove module
sudo semodule -r modulename

# Enable module
sudo semodule -e modulename

# Disable module
sudo semodule -d modulename

# Rebuild policy
sudo semodule -B

# Extract module for editing
sudo semodule -e modulename
```

### Practical Examples

#### Apache/Nginx web server

```bash
# Standard web content
sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
sudo restorecon -Rv /var/www/html/

# Writable web content (uploads)
sudo semanage fcontext -a -t httpd_sys_rw_content_t "/var/www/html/uploads(/.*)?"
sudo restorecon -Rv /var/www/html/uploads/

# CGI scripts
sudo semanage fcontext -a -t httpd_sys_script_exec_t "/var/www/cgi-bin(/.*)?"
sudo restorecon -Rv /var/www/cgi-bin/

# Allow network connections (proxy, APIs)
sudo setsebool -P httpd_can_network_connect on

# Allow database connections
sudo setsebool -P httpd_can_network_connect_db on

# Custom port
sudo semanage port -a -t http_port_t -p tcp 8080
```

#### Samba file server

```bash
# Set Samba context
sudo semanage fcontext -a -t samba_share_t "/srv/samba(/.*)?"
sudo restorecon -Rv /srv/samba/

# Enable Samba booleans
sudo setsebool -P samba_enable_home_dirs on
sudo setsebool -P samba_export_all_rw on
```

#### FTP server

```bash
# FTP content
sudo semanage fcontext -a -t public_content_t "/var/ftp(/.*)?"
sudo restorecon -Rv /var/ftp/

# Allow anonymous writes
sudo setsebool -P allow_ftpd_anon_write on

# Allow full access
sudo setsebool -P ftpd_full_access on
```

#### MySQL/MariaDB

```bash
# Custom data directory
sudo semanage fcontext -a -t mysqld_db_t "/data/mysql(/.*)?"
sudo restorecon -Rv /data/mysql/

# Allow connections
sudo setsebool -P mysql_connect_any on
```

#### Custom application

```bash
# Create directory
sudo mkdir /opt/myapp

# Set context
sudo semanage fcontext -a -t usr_t "/opt/myapp(/.*)?"
sudo restorecon -Rv /opt/myapp/

# Create policy for denied actions
# Run in permissive mode
sudo setenforce 0

# Run application
/opt/myapp/myapp

# Generate policy
sudo ausearch -m avc -c myapp | audit2allow -M myapp
sudo semodule -i myapp.pp

# Back to enforcing
sudo setenforce 1
```

### SELinux User Management

```bash
# List SELinux users
sudo semanage user -l

# Map Linux user to SELinux user
sudo semanage login -a -s user_u username

# List mappings
sudo semanage login -l

# Remove mapping
sudo semanage login -d username

# Common SELinux users:
unconfined_u    # Unconfined user (most Linux users)
user_u          # Regular user (confined)
staff_u         # Staff user (some admin tasks)
sysadm_u        # System admin (full admin)
system_u        # System processes
```

### Debugging Tools

```bash
# Check why access was denied
sesearch --allow -s httpd_t -t user_home_t -c file -p write

# Find transitions
sesearch --allow -s init_t -c process -p transition

# List all rules for domain
sesearch --allow -s httpd_t

# Get process context
ps -eZ | grep httpd

# Test file access
runcon system_u:system_r:httpd_t:s0 cat /path/to/file

# Sandbox application
sandbox -X -H ~/sandbox_home /path/to/app
```

### Best Practices

1. **Don't disable SELinux** - Fix policies instead
   ```bash
   # Bad: setenforce 0
   # Good: Find and fix the denial
   ```

2. **Use permissive mode for troubleshooting**
   ```bash
   sudo setenforce 0
   # Debug
   sudo setenforce 1
   ```

3. **Use semanage, not chcon** - For permanent changes
   ```bash
   # Temporary (lost on relabel):
   sudo chcon -t httpd_sys_content_t file.html

   # Permanent:
   sudo semanage fcontext -a -t httpd_sys_content_t "/path(/.*)?"
   sudo restorecon -Rv /path/
   ```

4. **Monitor audit logs** - Watch for denials
   ```bash
   sudo tail -f /var/log/audit/audit.log | grep denied
   ```

5. **Use booleans** - Before creating custom policies
   ```bash
   getsebool -a | grep httpd
   ```

6. **Document changes** - Keep track of customizations
   ```bash
   # Save output
   sudo semanage fcontext -l -C > selinux-contexts.txt
   sudo semanage port -l -C > selinux-ports.txt
   getsebool -a > selinux-booleans.txt
   ```

7. **Test in permissive** - Before enforcing
   ```bash
   sudo setenforce 0
   # Run tests
   sudo setenforce 1
   ```

8. **Use sealert** - For suggestions
   ```bash
   sudo sealert -a /var/log/audit/audit.log
   ```

9. **Backup before changes**
   ```bash
   sudo semanage fcontext -l > selinux-backup.txt
   ```

10. **Keep system updated** - Policies improve over time
    ```bash
    sudo dnf update selinux-policy
    ```

### Common Commands Reference

```bash
# Status
getenforce                          # Get current mode
sestatus                            # Detailed status

# Mode changes
sudo setenforce 0                   # Permissive mode
sudo setenforce 1                   # Enforcing mode

# Contexts
ls -Z file                          # View file context
ps -eZ                              # View process contexts
id -Z                               # View user context

# Change contexts
sudo chcon -t TYPE file             # Temporary
sudo semanage fcontext -a ...       # Permanent policy
sudo restorecon -Rv /path/          # Apply contexts

# Booleans
getsebool -a                        # List all
getsebool NAME                      # Get specific
sudo setsebool NAME on              # Set temporary
sudo setsebool -P NAME on           # Set permanent

# Ports
sudo semanage port -l               # List ports
sudo semanage port -a -t TYPE -p tcp PORT  # Add port

# Troubleshooting
sudo ausearch -m avc -ts recent     # View denials
sudo sealert -a /var/log/audit/audit.log  # Analyze
sudo audit2allow                    # Generate policy

# Policy modules
sudo semodule -l                    # List modules
sudo semodule -i module.pp          # Install module
sudo semodule -r modulename         # Remove module
```

### SELinux vs AppArmor

| Feature | SELinux | AppArmor |
|---------|---------|----------|
| Complexity | More complex | Simpler |
| Learning curve | Steeper | Easier |
| Method | Context/label-based | Path-based |
| Distribution | RHEL, CentOS, Fedora | Ubuntu, Debian, SUSE |
| Granularity | More granular | Less granular |
| Flexibility | More flexible | Less flexible |
| File identification | Security contexts | File paths |

Choose SELinux if:
- You're on RHEL/CentOS/Fedora
- You need fine-grained security
- You need MLS (classified environments)
- You want NSA-developed security
