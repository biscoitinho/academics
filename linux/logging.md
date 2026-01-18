## Linux Logging

### systemd Journal

```bash
# View logs
journalctl                         # All
journalctl -f                      # Follow
journalctl -u service              # Specific service
journalctl -k                      # Kernel only
journalctl -b                      # Current boot

# Time filters
journalctl --since "1 hour ago"
journalctl --since "2024-01-15 10:00:00"
journalctl --until "2024-01-15 15:00:00"

# Priority filters
journalctl -p err                  # Errors only
journalctl -p warning              # Warnings and worse

# Process filters
journalctl _PID=1234
journalctl /usr/bin/python3

# Output formats
journalctl -o json-pretty
journalctl -o verbose

# Management
journalctl --disk-usage
sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=7d
```

### rsyslog (Traditional)

```bash
# Log locations
/var/log/syslog          # System (Debian/Ubuntu)
/var/log/messages        # System (RHEL/CentOS)
/var/log/auth.log        # Authentication
/var/log/kern.log        # Kernel

# Configuration
sudo vim /etc/rsyslog.conf

# Examples:
*.info           /var/log/messages
authpriv.*       /var/log/secure
*.err            /var/log/error.log
*.*              @192.168.1.100:514     # Remote UDP
*.*              @@192.168.1.100:514    # Remote TCP
```

### Log Rotation

```bash
# Configuration
sudo vim /etc/logrotate.conf
ls /etc/logrotate.d/

# Example config
/var/log/myapp/*.log {
    daily
    rotate 7
    compress
    delaycompress
    notifempty
    create 0640 root adm
    postrotate
        systemctl reload myapp
    endscript
}

# Manual rotation
sudo logrotate -f /etc/logrotate.conf
```

### Application Logging

```bash
# Shell scripts
logger "Message"
logger -p user.err "Error message"
logger -t myapp "App message"

# Example script
logger -t myscript -p user.info "Script started"
# ... commands ...
logger -t myscript -p user.info "Script completed"
```

### Log Analysis

```bash
# Search
grep -i error /var/log/syslog
grep -i "fail\|error" /var/log/syslog
zgrep "error" /var/log/syslog.*.gz    # Compressed logs

# Count
grep -c "error" /var/log/syslog

# Most common errors
grep error /var/log/syslog | sort | uniq -c | sort -rn | head

# Failed SSH attempts
grep "Failed password" /var/log/auth.log

# Apache analysis
awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -rn | head
awk '{print $9}' /var/log/apache2/access.log | sort | uniq -c
```

### Monitoring

```bash
# Follow logs
tail -f /var/log/syslog
tail -f /var/log/syslog | grep -i error

# Multiple logs
tail -f /var/log/syslog /var/log/auth.log

# Tools
sudo apt install multitail
multitail /var/log/syslog /var/log/auth.log
```

### Security

```bash
# Protect logs
sudo chmod 640 /var/log/syslog
sudo chmod 600 /var/log/auth.log

# Append-only
sudo chattr +a /var/log/critical.log
```

### Troubleshooting

```bash
# Check services
systemctl status systemd-journald
systemctl status rsyslog

# Disk space
df -h /var/log
du -sh /var/log/*

# Test logging
logger "Test message"
tail /var/log/syslog
```

### Quick Reference

```bash
# View
journalctl -f                      # Follow journal
tail -f /var/log/syslog           # Follow syslog

# Filter
journalctl --since "1 hour ago"
journalctl -p err
grep error /var/log/syslog

# Clean
sudo journalctl --vacuum-size=100M
sudo logrotate -f /etc/logrotate.conf

# Send log
logger "Test message"
```
