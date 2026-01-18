## SELinux

SELinux provides Mandatory Access Control (MAC) through security policies using labels.

### Status and Modes

```bash
# Check status
getenforce
sestatus

# Set mode (temporary)
sudo setenforce 0       # Permissive
sudo setenforce 1       # Enforcing

# Set mode (permanent)
sudo vim /etc/selinux/config
# SELINUX=enforcing
# SELINUX=permissive
# SELINUX=disabled
sudo reboot
```

### Security Contexts

```bash
# View contexts
ls -Z /path/to/file
ps -eZ
id -Z

# Format: user:role:type:level
# Example: system_u:object_r:httpd_sys_content_t:s0
```

### Change Contexts

```bash
# Temporary
sudo chcon -t httpd_sys_content_t /var/www/html/file.html

# Permanent
sudo semanage fcontext -a -t httpd_sys_content_t "/web/content(/.*)?"
sudo restorecon -Rv /web/content

# Restore defaults
sudo restorecon -Rv /var/www/html/
```

### Booleans

```bash
# List all
getsebool -a

# Get specific
getsebool httpd_can_network_connect

# Set
sudo setsebool httpd_can_network_connect on
sudo setsebool -P httpd_can_network_connect on    # Permanent

# Common booleans
httpd_can_network_connect
httpd_enable_homedirs
ftpd_full_access
```

### Ports

```bash
# List ports
sudo semanage port -l | grep http

# Add port
sudo semanage port -a -t http_port_t -p tcp 8080

# Delete port
sudo semanage port -d -t http_port_t -p tcp 8080
```

### Troubleshooting

```bash
# View denials
sudo ausearch -m avc -ts recent
sudo grep denied /var/log/audit/audit.log

# Analyze with sealert
sudo sealert -a /var/log/audit/audit.log

# Create policy from denials
sudo ausearch -m avc -c httpd | audit2allow -M mypolicy
sudo semodule -i mypolicy.pp
```

### Common Scenarios

```bash
# Web server
sudo semanage fcontext -a -t httpd_sys_content_t "/var/www/html(/.*)?"
sudo restorecon -Rv /var/www/html/
sudo setsebool -P httpd_can_network_connect on

# Custom port
sudo semanage port -a -t http_port_t -p tcp 8080

# Database
sudo semanage fcontext -a -t mysqld_db_t "/data/mysql(/.*)?"
sudo restorecon -Rv /data/mysql/
```

### Quick Reference

```bash
# Status
getenforce
sestatus

# Modes
sudo setenforce 0                   # Permissive
sudo setenforce 1                   # Enforcing

# Contexts
ls -Z file
sudo restorecon -Rv /path/
sudo semanage fcontext -a -t TYPE "/path(/.*)?"

# Booleans
getsebool -a
sudo setsebool -P NAME on

# Ports
sudo semanage port -a -t http_port_t -p tcp 8080

# Troubleshoot
sudo ausearch -m avc -ts recent
sudo sealert -a /var/log/audit/audit.log
```
