## Cron - Scheduled Tasks

### Cron Syntax

```
* * * * * command
│ │ │ │ │
│ │ │ │ └─── Day of week (0-7, 0 and 7 = Sunday)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

### Special Characters

```
*     - Any value
,     - List (1,2,3)
-     - Range (1-5)
/     - Step (*/5 = every 5)
```

### Crontab Commands

```bash
# Edit crontab
crontab -e

# List crontab
crontab -l

# Remove crontab
crontab -r

# Edit another user's crontab
sudo crontab -u username -e
```

### Common Schedules

```bash
# Every minute
* * * * * command

# Every 5 minutes
*/5 * * * * command

# Every hour
0 * * * * command

# Every day at 3am
0 3 * * * command

# Every Monday at 5pm
0 17 * * 1 command

# First day of every month
0 0 1 * * command

# Every weekday at 8am
0 8 * * 1-5 command

# Every 6 hours
0 */6 * * * command
```

### Special Strings

```bash
@reboot     command  # Run at startup
@yearly     command  # 0 0 1 1 *
@annually   command  # Same as @yearly
@monthly    command  # 0 0 1 * *
@weekly     command  # 0 0 * * 0
@daily      command  # 0 0 * * *
@midnight   command  # Same as @daily
@hourly     command  # 0 * * * *
```

### Examples

```bash
# Backup database daily at 2am
0 2 * * * /scripts/backup-db.sh

# Clean temp files every Sunday at 3am
0 3 * * 0 rm -rf /tmp/*

# Check disk space every hour
0 * * * * df -h > /var/log/diskspace.log

# Run script every 15 minutes
*/15 * * * * /scripts/check-status.sh

# Send email every Monday at 9am
0 9 * * 1 echo "Weekly report" | mail -s "Report" user@example.com
```

### Environment Variables

```bash
# Set variables in crontab
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=user@example.com

# Use in cron job
0 2 * * * /scripts/backup.sh
```

### Logging

```bash
# Redirect output to log
* * * * * command >> /var/log/cron.log 2>&1

# Send errors to log
* * * * * command 2>> /var/log/cron-errors.log

# Suppress output
* * * * * command > /dev/null 2>&1

# View cron logs
sudo tail -f /var/log/syslog | grep CRON
sudo tail -f /var/log/cron
journalctl -u cron
```

### Systemd Timers (Alternative)

```bash
# List timers
systemctl list-timers

# Create timer unit
/etc/systemd/system/backup.timer

[Unit]
Description=Backup Timer

[Timer]
OnCalendar=daily
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target

# Enable timer
sudo systemctl enable backup.timer
sudo systemctl start backup.timer
```

### Anacron - For Systems Not Always On

```bash
# /etc/anacrontab
# period  delay  job-identifier  command
1         5      daily-backup    /scripts/backup.sh
7         10     weekly-clean    /scripts/cleanup.sh
@monthly  15     monthly-report  /scripts/report.sh
```

### Best Practices

```bash
# 1. Use absolute paths
0 2 * * * /usr/bin/python3 /home/user/script.py

# 2. Test scripts before scheduling
/path/to/script.sh  # Run manually first

# 3. Add comments
# Backup database every night
0 2 * * * /scripts/backup.sh

# 4. Check logs
tail -f /var/log/syslog | grep CRON

# 5. Use locking to prevent overlaps
* * * * * flock -n /tmp/script.lock /scripts/script.sh
```
