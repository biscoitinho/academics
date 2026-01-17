## Linux Logging Systems

### Overview

Linux logging systems capture and store messages from the kernel, system services, and applications. Understanding logging is crucial for system monitoring, troubleshooting, and security auditing.

### Logging Systems

**Traditional**: syslog/rsyslog
- Text-based log files in `/var/log/`
- Hierarchical structure with facilities and priorities
- Simple grep-able format

**Modern**: systemd journald
- Binary log format
- Structured logging with metadata
- Unified logging for all systemd services
- Accessed via `journalctl`

### systemd Journal (journald)

#### Basic usage

```bash
# View all logs
journalctl

# Follow logs in real-time
journalctl -f

# Show only kernel messages
journalctl -k

# Show logs from current boot
journalctl -b
journalctl -b 0           # Current boot
journalctl -b -1          # Previous boot

# List available boots
journalctl --list-boots
```

#### Filtering by time

```bash
# Since specific time
journalctl --since "2024-01-15 10:00:00"
journalctl --since "1 hour ago"
journalctl --since "yesterday"
journalctl --since today

# Until specific time
journalctl --until "2024-01-15 15:00:00"

# Time range
journalctl --since "2024-01-15 10:00:00" --until "2024-01-15 15:00:00"

# Last N lines
journalctl -n 50          # Last 50 lines
journalctl -n 100 -f      # Last 100 lines, then follow
```

#### Filtering by service/unit

```bash
# Specific service
journalctl -u nginx.service
journalctl -u apache2.service

# Multiple services
journalctl -u nginx.service -u mysql.service

# Follow service logs
journalctl -u nginx.service -f

# Show service status with recent logs
systemctl status nginx.service
```

#### Filtering by priority

```bash
# Priority levels (highest to lowest):
# 0: emerg   - System is unusable
# 1: alert   - Action must be taken immediately
# 2: crit    - Critical conditions
# 3: err     - Error conditions
# 4: warning - Warning conditions
# 5: notice  - Normal but significant
# 6: info    - Informational
# 7: debug   - Debug messages

# Show only errors and worse
journalctl -p err

# Show warnings and worse
journalctl -p warning

# Show specific priority
journalctl -p 3           # Errors only
```

#### Filtering by process

```bash
# By PID
journalctl _PID=1234

# By executable
journalctl /usr/bin/python3

# By command name
journalctl -t nginx
```

#### Output formats

```bash
# Short format (default)
journalctl -o short

# Detailed format
journalctl -o verbose

# JSON format
journalctl -o json
journalctl -o json-pretty

# Export format (for backup/transfer)
journalctl -o export

# Cat format (for parsing)
journalctl -o cat
```

#### Advanced filtering

```bash
# Combine filters
journalctl -u nginx.service -p err --since "1 hour ago"

# Filter by user
journalctl _UID=1000

# Filter by systemd unit type
journalctl -t systemd

# Show only kernel messages with priority
journalctl -k -p warning

# Reverse order (newest first)
journalctl -r

# Show explanation of log entries
journalctl -x
journalctl -xe            # End of log with explanations
```

#### Journal management

```bash
# Show disk usage
journalctl --disk-usage

# Vacuum by size (keep only 100MB)
sudo journalctl --vacuum-size=100M

# Vacuum by time (keep only 7 days)
sudo journalctl --vacuum-time=7d

# Vacuum by number of files
sudo journalctl --vacuum-files=5

# Verify journal integrity
sudo journalctl --verify

# Rotate journal files
sudo systemctl kill --kill-who=main --signal=SIGUSR2 systemd-journald
```

#### Journal configuration

```bash
# Configuration file
sudo vim /etc/systemd/journald.conf

# Important settings:
[Journal]
Storage=persistent        # Store logs on disk
SystemMaxUse=500M         # Max disk space
SystemKeepFree=1G         # Keep this much free
SystemMaxFileSize=100M    # Max size per file
MaxRetentionSec=7day      # Keep logs for 7 days
MaxFileSec=1day           # Rotate daily
ForwardToSyslog=yes       # Also send to rsyslog
Compress=yes              # Compress old logs

# Restart to apply changes
sudo systemctl restart systemd-journald
```

#### Persistent journal

```bash
# Make journal persistent (survives reboot)
sudo mkdir -p /var/log/journal
sudo systemctl restart systemd-journald

# Or edit config
sudo vim /etc/systemd/journald.conf
# Set: Storage=persistent
```

### rsyslog (Traditional Logging)

#### Log file locations

```bash
# Main system logs
/var/log/syslog           # All system logs (Debian/Ubuntu)
/var/log/messages         # All system logs (RHEL/CentOS)
/var/log/auth.log         # Authentication logs (Debian/Ubuntu)
/var/log/secure           # Authentication logs (RHEL/CentOS)
/var/log/kern.log         # Kernel logs
/var/log/dmesg            # Boot messages
/var/log/boot.log         # Boot process logs

# Service-specific logs
/var/log/apache2/         # Apache web server
/var/log/nginx/           # Nginx web server
/var/log/mysql/           # MySQL database
/var/log/postgresql/      # PostgreSQL database
/var/log/mail.log         # Mail server
/var/log/cron.log         # Cron job logs

# Application logs
/var/log/daemon.log       # Daemon processes
/var/log/user.log         # User-level logs
```

#### rsyslog configuration

```bash
# Main config
sudo vim /etc/rsyslog.conf

# Additional configs
ls /etc/rsyslog.d/

# Syntax:
# facility.priority    action

# Examples:
*.info;mail.none;authpriv.none;cron.none    /var/log/messages
authpriv.*                                   /var/log/secure
mail.*                                       /var/log/maillog
cron.*                                       /var/log/cron
*.emerg                                      :omusrmsg:*
```

#### Facilities

```bash
# Standard facilities:
auth, authpriv    # Authentication
cron              # Cron daemon
daemon            # System daemons
kern              # Kernel messages
lpr               # Printing system
mail              # Mail system
news              # News system
syslog            # Syslog itself
user              # User processes
local0-local7     # Custom facilities
*                 # All facilities
```

#### Priorities (same as journald)

```bash
emerg     # Emergency (0)
alert     # Alert (1)
crit      # Critical (2)
err       # Error (3)
warning   # Warning (4)
notice    # Notice (5)
info      # Info (6)
debug     # Debug (7)
*         # All priorities
none      # Disable
```

#### Custom logging rules

```bash
# Send all errors to specific file
*.err                    /var/log/error.log

# Log authentication to separate file
auth,authpriv.*          /var/log/auth.log

# Send critical messages to console
*.crit                   /dev/console

# Send logs to remote server
*.*                      @192.168.1.100:514      # UDP
*.*                      @@192.168.1.100:514     # TCP

# Execute program on specific event
*.emerg                  ^/usr/local/bin/alert.sh

# Discard specific logs
mail.none                /var/log/syslog

# Multiple facilities
mail,news.=info          /var/log/info.log
```

#### Restart rsyslog

```bash
# Check configuration
sudo rsyslogd -N1

# Restart service
sudo systemctl restart rsyslog

# Reload configuration
sudo systemctl reload rsyslog
```

### Remote Logging

#### Central log server (rsyslog)

```bash
# On log server - receive logs
sudo vim /etc/rsyslog.conf

# Enable TCP/UDP reception
module(load="imudp")
input(type="imudp" port="514")

module(load="imtcp")
input(type="imtcp" port="514")

# Template for organizing logs by hostname
$template RemoteLogs,"/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log"
*.* ?RemoteLogs

# Restart
sudo systemctl restart rsyslog
```

#### Clients - send logs to server

```bash
# On client machines
sudo vim /etc/rsyslog.conf

# Send all logs to remote server
*.*    @192.168.1.100:514      # UDP
*.*    @@192.168.1.100:514     # TCP

# Send only specific logs
*.err  @@192.168.1.100:514

# Restart
sudo systemctl restart rsyslog
```

#### Central log server (journald)

```bash
# On log server
sudo vim /etc/systemd/journal-remote.conf

[Remote]
Seal=false
SplitMode=host

# Enable journal-remote
sudo systemctl enable systemd-journal-remote.socket
sudo systemctl start systemd-journal-remote.socket

# On clients, forward journal
sudo vim /etc/systemd/journal-upload.conf

[Upload]
URL=http://log-server:19532

# Enable journal-upload
sudo systemctl enable systemd-journal-upload
sudo systemctl start systemd-journal-upload
```

### Log Rotation

#### logrotate configuration

```bash
# Main config
sudo vim /etc/logrotate.conf

# Service-specific configs
ls /etc/logrotate.d/

# Example logrotate config
/var/log/myapp/*.log {
    daily                  # Rotate daily
    rotate 7               # Keep 7 old logs
    compress               # Compress old logs
    delaycompress          # Compress on next rotation
    missingok              # Don't error if missing
    notifempty             # Don't rotate if empty
    create 0640 root adm   # Create new log with permissions
    sharedscripts          # Run scripts once for all logs
    postrotate
        systemctl reload myapp
    endscript
}
```

#### Rotation frequency

```bash
daily      # Rotate daily
weekly     # Rotate weekly
monthly    # Rotate monthly
yearly     # Rotate yearly
size 100M  # Rotate when reaches size
```

#### Manual rotation

```bash
# Force rotation
sudo logrotate -f /etc/logrotate.conf

# Test configuration (dry run)
sudo logrotate -d /etc/logrotate.conf

# Verbose mode
sudo logrotate -v /etc/logrotate.conf

# Force rotation of specific config
sudo logrotate -f /etc/logrotate.d/nginx
```

#### Common logrotate examples

```bash
# Web server logs
/var/log/nginx/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 nginx adm
    sharedscripts
    postrotate
        [ -f /var/run/nginx.pid ] && kill -USR1 $(cat /var/run/nginx.pid)
    endscript
}

# Application logs with size limit
/var/log/myapp/app.log {
    size 100M
    rotate 5
    compress
    copytruncate
    notifempty
}

# Database logs
/var/log/mysql/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 640 mysql adm
    postrotate
        if test -x /usr/bin/mysqladmin && /usr/bin/mysqladmin ping &>/dev/null
        then
            /usr/bin/mysqladmin flush-logs
        fi
    endscript
}
```

### Application Logging

#### Logger command (shell scripts)

```bash
# Send message to syslog
logger "This is a test message"

# With priority
logger -p user.info "Info message"
logger -p user.err "Error message"

# With tag
logger -t myapp "Application message"

# With facility and priority
logger -p local0.notice -t backup "Backup completed"

# From file
logger -f /path/to/logfile

# Example in script
#!/bin/bash
logger -t myscript -p user.info "Script started"
# ... script commands ...
if [ $? -eq 0 ]; then
    logger -t myscript -p user.info "Script completed successfully"
else
    logger -t myscript -p user.err "Script failed with error"
fi
```

#### Python logging

```python
import logging
import logging.handlers

# Basic configuration
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('/var/log/myapp/app.log'),
        logging.StreamHandler()  # Also print to console
    ]
)

logger = logging.getLogger(__name__)

# Log messages
logger.debug('Debug message')
logger.info('Info message')
logger.warning('Warning message')
logger.error('Error message')
logger.critical('Critical message')

# Syslog handler
syslog_handler = logging.handlers.SysLogHandler(
    address='/dev/log',
    facility=logging.handlers.SysLogHandler.LOG_USER
)
logger.addHandler(syslog_handler)

# Rotating file handler
rotating_handler = logging.handlers.RotatingFileHandler(
    '/var/log/myapp/app.log',
    maxBytes=10*1024*1024,  # 10MB
    backupCount=5
)
logger.addHandler(rotating_handler)
```

### Log Analysis

#### Viewing and searching logs

```bash
# View logs
less /var/log/syslog
tail -f /var/log/syslog
tail -n 100 /var/log/syslog

# Search for errors
grep -i error /var/log/syslog
grep -i "fail\|error\|critical" /var/log/syslog

# Count occurrences
grep -c "error" /var/log/syslog

# Show context
grep -B 5 -A 5 "error" /var/log/syslog

# Search all logs
grep -r "error" /var/log/

# Search compressed logs
zgrep "error" /var/log/syslog.*.gz
```

#### Log analysis tools

```bash
# Most common error messages
grep error /var/log/syslog | sort | uniq -c | sort -rn | head

# Errors by hour
awk '/error/ {print $1, $2, $3}' /var/log/syslog | uniq -c

# Failed SSH attempts
grep "Failed password" /var/log/auth.log | wc -l

# Top IPs with failed SSH
grep "Failed password" /var/log/auth.log | \
    grep -oP 'from \K[\d.]+' | sort | uniq -c | sort -rn

# Apache access log analysis
# Top 10 IP addresses
awk '{print $1}' /var/log/apache2/access.log | sort | uniq -c | sort -rn | head

# Top 10 requested URLs
awk '{print $7}' /var/log/apache2/access.log | sort | uniq -c | sort -rn | head

# HTTP status codes
awk '{print $9}' /var/log/apache2/access.log | sort | uniq -c | sort -rn

# 404 errors
awk '$9 == 404' /var/log/apache2/access.log

# Requests by hour
awk '{print $4}' /var/log/apache2/access.log | cut -d: -f2 | sort | uniq -c
```

#### Advanced analysis with awk

```bash
# Show only specific fields
awk '{print $1, $5, $6}' /var/log/syslog

# Filter and format
awk '/error/ {print $1, $2, $3, $5}' /var/log/syslog

# Count by field
awk '{count[$5]++} END {for (word in count) print word, count[word]}' /var/log/syslog

# Sum numeric values
awk '{sum+=$10} END {print sum}' /var/log/access.log
```

### Log Monitoring and Alerting

#### Watch logs in real-time

```bash
# Follow multiple logs
tail -f /var/log/syslog /var/log/auth.log

# With color highlighting
tail -f /var/log/syslog | grep --color=always -E "error|warning|$"

# Filter while following
tail -f /var/log/syslog | grep -i error

# Multitail (tool for multiple logs)
sudo apt install multitail
multitail /var/log/syslog /var/log/auth.log
```

#### Simple alerting script

```bash
#!/bin/bash
# alert-on-error.sh

LOG_FILE="/var/log/syslog"
SEARCH_TERM="error"
EMAIL="admin@example.com"

tail -Fn0 "$LOG_FILE" | while read line; do
    if echo "$line" | grep -qi "$SEARCH_TERM"; then
        echo "$line" | mail -s "Error detected in logs" "$EMAIL"
    fi
done
```

#### Log monitoring tools

```bash
# GoAccess - real-time web log analyzer
sudo apt install goaccess
goaccess /var/log/nginx/access.log -o report.html --log-format=COMBINED

# Logwatch - log analyzer and reporter
sudo apt install logwatch
sudo logwatch --detail High --mailto admin@example.com --range today

# Fail2ban - monitor logs and ban IPs
sudo apt install fail2ban
# See system_security.md for configuration
```

### Best Practices

1. **Centralized logging** - Send all logs to central server
2. **Log retention** - Keep logs for compliance requirements
3. **Log rotation** - Prevent disk space issues
4. **Monitoring** - Alert on critical errors
5. **Structured logging** - Use consistent formats
6. **Security** - Protect logs from tampering
7. **Separate logs** - Different logs for different purposes
8. **Timestamps** - Always include timestamps
9. **Log levels** - Use appropriate severity levels
10. **Regular review** - Analyze logs periodically

### Security Considerations

```bash
# Protect log files
sudo chmod 640 /var/log/syslog
sudo chown root:adm /var/log/syslog

# Separate authentication logs
sudo chmod 600 /var/log/auth.log
sudo chown root:root /var/log/auth.log

# Prevent log tampering
sudo chattr +a /var/log/critical.log  # Append-only

# Encrypt logs
# Use encrypted filesystem or encrypt during rotation
/var/log/secure.log {
    compress
    postrotate
        gpg --encrypt /var/log/secure.log.1.gz
        rm /var/log/secure.log.1.gz
    endscript
}

# Send logs immediately to remote server
# So local compromise doesn't erase evidence
```

### Troubleshooting Logging Issues

```bash
# Check if journald is running
systemctl status systemd-journald

# Check if rsyslog is running
systemctl status rsyslog

# Check journal for corruption
journalctl --verify

# Check disk space
df -h /var/log

# Check inode usage
df -i /var/log

# Find large log files
du -sh /var/log/* | sort -hr

# Check log permissions
ls -la /var/log/

# Test syslog
logger -p user.info "Test message"
tail /var/log/syslog

# Check rsyslog configuration
sudo rsyslogd -N1

# Check for rsyslog errors
journalctl -u rsyslog -n 50

# Restart logging services
sudo systemctl restart systemd-journald
sudo systemctl restart rsyslog
```

### Quick Reference

```bash
# View logs
journalctl                         # All journal logs
journalctl -f                      # Follow journal
journalctl -u service              # Service logs
journalctl -k                      # Kernel logs
tail -f /var/log/syslog           # Follow syslog

# Filter logs
journalctl --since "1 hour ago"   # Time filter
journalctl -p err                 # Priority filter
grep error /var/log/syslog        # Search syslog

# Manage journal
journalctl --disk-usage           # Check size
sudo journalctl --vacuum-size=100M  # Clean journal
sudo journalctl --vacuum-time=7d   # Keep 7 days

# Log rotation
sudo logrotate -f /etc/logrotate.conf  # Force rotation
sudo logrotate -d /etc/logrotate.conf  # Test rotation

# Send to syslog
logger "Test message"             # Simple
logger -p user.err "Error"        # With priority

# Analysis
grep -r "error" /var/log/         # Search all logs
journalctl -p err --since today   # Today's errors
```
