## System Security

### SSH Hardening

#### Basic SSH configuration

```bash
# Edit SSH config
sudo vim /etc/ssh/sshd_config

# Recommended settings:
Port 2222                          # Change default port
PermitRootLogin no                 # Disable root login
PasswordAuthentication no          # Use keys only
PubkeyAuthentication yes           # Enable key auth
PermitEmptyPasswords no            # No empty passwords
X11Forwarding no                   # Disable X11
MaxAuthTries 3                     # Limit auth attempts
ClientAliveInterval 300            # Timeout idle sessions
ClientAliveCountMax 2              # Max idle checks
AllowUsers user1 user2             # Limit users
Protocol 2                         # Use SSH protocol 2

# Restart SSH
sudo systemctl restart sshd
```

#### SSH key authentication

```bash
# Generate SSH key (on client)
ssh-keygen -t ed25519 -C "your_email@example.com"
# Or RSA 4096-bit
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Copy public key to server
ssh-copy-id user@server
# Or manually:
cat ~/.ssh/id_ed25519.pub | ssh user@server "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# Set correct permissions on server
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Disable password auth after keys work
sudo vim /etc/ssh/sshd_config
# Set: PasswordAuthentication no
sudo systemctl restart sshd
```

#### SSH two-factor authentication

```bash
# Install Google Authenticator
sudo apt install libpam-google-authenticator

# Setup for user
google-authenticator

# Configure PAM
sudo vim /etc/pam.d/sshd
# Add: auth required pam_google_authenticator.so

# Configure SSH
sudo vim /etc/ssh/sshd_config
# Set: ChallengeResponseAuthentication yes
# Set: AuthenticationMethods publickey,keyboard-interactive

# Restart SSH
sudo systemctl restart sshd
```

#### SSH tunneling and port forwarding

```bash
# Local port forwarding (access remote service)
ssh -L 8080:localhost:80 user@server
# Now localhost:8080 connects to server's port 80

# Remote port forwarding (expose local service)
ssh -R 8080:localhost:80 user@server
# Now server:8080 connects to your port 80

# Dynamic port forwarding (SOCKS proxy)
ssh -D 8080 user@server
# Configure browser to use localhost:8080 as SOCKS proxy

# Keep connection alive
ssh -o ServerAliveInterval=60 user@server
```

### Firewall Configuration

#### UFW (Uncomplicated Firewall)

```bash
# Install
sudo apt install ufw

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (before enabling!)
sudo ufw allow 22/tcp
# Or specific port
sudo ufw allow 2222/tcp

# Allow services
sudo ufw allow http
sudo ufw allow https
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow from specific IP
sudo ufw allow from 192.168.1.100
sudo ufw allow from 192.168.1.100 to any port 22

# Allow subnet
sudo ufw allow from 192.168.1.0/24

# Deny specific
sudo ufw deny from 203.0.113.0/24

# Enable firewall
sudo ufw enable

# Check status
sudo ufw status verbose
sudo ufw status numbered

# Delete rule
sudo ufw delete 2           # By number
sudo ufw delete allow 80    # By rule

# Reset firewall
sudo ufw reset
```

#### iptables

```bash
# View current rules
sudo iptables -L -v -n
sudo iptables -S

# Save rules
sudo iptables-save > /tmp/iptables.rules

# Restore rules
sudo iptables-restore < /tmp/iptables.rules

# Basic firewall setup
# Accept established connections
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Accept loopback
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Drop invalid packets
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# Default policies
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Delete rule
sudo iptables -D INPUT 2        # By number
sudo iptables -D INPUT -p tcp --dport 80 -j ACCEPT  # By specification

# Flush all rules
sudo iptables -F
```

#### Persistent iptables rules

```bash
# Debian/Ubuntu with iptables-persistent
sudo apt install iptables-persistent
sudo netfilter-persistent save
sudo netfilter-persistent reload

# Manual save/restore
sudo iptables-save | sudo tee /etc/iptables/rules.v4
# Restore on boot (add to /etc/rc.local or systemd service)
iptables-restore < /etc/iptables/rules.v4
```

#### firewalld (RHEL/CentOS/Fedora)

```bash
# Check status
sudo firewall-cmd --state

# List zones
sudo firewall-cmd --get-zones
sudo firewall-cmd --get-active-zones

# Add service
sudo firewall-cmd --add-service=http
sudo firewall-cmd --add-service=https
sudo firewall-cmd --permanent --add-service=http  # Make permanent

# Add port
sudo firewall-cmd --add-port=8080/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp

# Add rich rule
sudo firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" accept'

# Reload
sudo firewall-cmd --reload

# List all
sudo firewall-cmd --list-all
```

### Fail2ban - Intrusion Prevention

#### Install and configure

```bash
# Install
sudo apt install fail2ban

# Copy default config
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Edit configuration
sudo vim /etc/fail2ban/jail.local

# Basic settings:
[DEFAULT]
bantime = 3600              # Ban for 1 hour
findtime = 600              # Time window for maxretry
maxretry = 5                # Max failed attempts
destemail = admin@example.com
sendername = Fail2Ban
action = %(action_mwl)s     # Ban and email with logs

[sshd]
enabled = true
port = 22
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400             # 24 hours

# Restart fail2ban
sudo systemctl restart fail2ban
```

#### Manage fail2ban

```bash
# Check status
sudo fail2ban-client status

# Check specific jail
sudo fail2ban-client status sshd

# Unban IP
sudo fail2ban-client set sshd unbanip 192.168.1.100

# Ban IP manually
sudo fail2ban-client set sshd banip 192.168.1.100

# View banned IPs
sudo iptables -L -n | grep DROP
```

#### Custom fail2ban jails

```bash
# Create custom filter
sudo vim /etc/fail2ban/filter.d/custom-app.conf

[Definition]
failregex = ^.*Failed login attempt from <HOST>.*$
ignoreregex =

# Add jail
sudo vim /etc/fail2ban/jail.local

[custom-app]
enabled = true
port = 8080
logpath = /var/log/custom-app.log
maxretry = 3
bantime = 3600

# Restart
sudo systemctl restart fail2ban
```

### User and Permission Security

#### Sudo configuration

```bash
# Edit sudoers (always use visudo!)
sudo visudo

# Allow user to run all commands
username ALL=(ALL:ALL) ALL

# Allow without password
username ALL=(ALL) NOPASSWD: ALL

# Allow specific commands
username ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx

# Allow group
%admin ALL=(ALL:ALL) ALL

# Set sudo timeout
Defaults timestamp_timeout=30    # Minutes

# Require password for each sudo
Defaults timestamp_timeout=0

# Sudo logs
sudo tail -f /var/log/auth.log | grep sudo
```

#### Password policies

```bash
# Install PAM modules
sudo apt install libpam-pwquality

# Configure password quality
sudo vim /etc/security/pwquality.conf

minlen = 12                 # Minimum length
dcredit = -1                # At least 1 digit
ucredit = -1                # At least 1 uppercase
lcredit = -1                # At least 1 lowercase
ocredit = -1                # At least 1 special char
maxrepeat = 3               # Max repeated chars
usercheck = 1               # Check against username

# Password aging
sudo vim /etc/login.defs

PASS_MAX_DAYS   90          # Expire after 90 days
PASS_MIN_DAYS   7           # Can't change for 7 days
PASS_WARN_AGE   14          # Warn 14 days before

# Set for existing user
sudo chage -M 90 -m 7 -W 14 username

# Check password status
sudo chage -l username
```

#### Lock/unlock accounts

```bash
# Lock account
sudo passwd -l username
sudo usermod -L username

# Unlock account
sudo passwd -u username
sudo usermod -U username

# Check locked accounts
sudo passwd -S username
```

### File Integrity Monitoring

#### AIDE (Advanced Intrusion Detection Environment)

```bash
# Install
sudo apt install aide

# Initialize database
sudo aideinit

# Move database to active location
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Check for changes
sudo aide --check

# Update database
sudo aide --update
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Automate with cron
sudo vim /etc/cron.daily/aide
#!/bin/bash
/usr/bin/aide --check | mail -s "AIDE Report" admin@example.com
```

#### Tripwire

```bash
# Install
sudo apt install tripwire

# Initialize
sudo tripwire --init

# Check integrity
sudo tripwire --check

# Update database
sudo tripwire --update
```

### Security Auditing

#### Lynis - Security auditing

```bash
# Install
sudo apt install lynis

# Run audit
sudo lynis audit system

# Results location
/var/log/lynis.log
/var/log/lynis-report.dat

# Automate
sudo lynis audit system --cronjob
```

#### RKHunter - Rootkit detection

```bash
# Install
sudo apt install rkhunter

# Update database
sudo rkhunter --update

# Run scan
sudo rkhunter --check

# Skip keypress
sudo rkhunter --check --sk

# Automate with cron
sudo vim /etc/cron.daily/rkhunter
#!/bin/bash
/usr/bin/rkhunter --check --skip-keypress --report-warnings-only | mail -s "rkhunter Daily Report" admin@example.com
```

#### ClamAV - Antivirus

```bash
# Install
sudo apt install clamav clamav-daemon

# Update virus definitions
sudo systemctl stop clamav-freshclam
sudo freshclam
sudo systemctl start clamav-freshclam

# Scan directory
clamscan -r /home/
clamscan -r --infected --remove /home/

# Scan with options
clamscan -r -i --bell --move=/quarantine/ /home/

# Schedule scans
sudo vim /etc/cron.daily/clamav-scan
#!/bin/bash
clamscan -r -i /home/ | mail -s "ClamAV Daily Scan" admin@example.com
```

### System Hardening

#### Disable unnecessary services

```bash
# List running services
systemctl list-units --type=service --state=running

# Disable service
sudo systemctl disable service-name
sudo systemctl stop service-name

# Common services to consider disabling:
sudo systemctl disable bluetooth
sudo systemctl disable cups           # If no printing needed
sudo systemctl disable avahi-daemon   # If no mDNS needed
```

#### Kernel hardening

```bash
# Edit sysctl
sudo vim /etc/sysctl.conf

# IP forwarding (disable if not router)
net.ipv4.ip_forward = 0

# Disable ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0

# Ignore ICMP ping requests
net.ipv4.icmp_echo_ignore_all = 1

# Protect against SYN flood attacks
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2

# Log suspicious packets
net.ipv4.conf.all.log_martians = 1

# Apply changes
sudo sysctl -p
```

#### Secure shared memory

```bash
# Edit fstab
sudo vim /etc/fstab

# Add this line:
tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0

# Remount
sudo mount -o remount /run/shm
```

#### Remove unnecessary packages

```bash
# List installed packages
dpkg --list | less

# Remove package
sudo apt remove package-name
sudo apt purge package-name

# Remove unused dependencies
sudo apt autoremove
```

### Encryption

#### Encrypt partition with LUKS

```bash
# Install cryptsetup
sudo apt install cryptsetup

# Create encrypted partition
sudo cryptsetup luksFormat /dev/sdb1

# Open encrypted partition
sudo cryptsetup luksOpen /dev/sdb1 encrypted_data

# Create filesystem
sudo mkfs.ext4 /dev/mapper/encrypted_data

# Mount
sudo mount /dev/mapper/encrypted_data /mnt/encrypted

# Auto-mount with key file
# Create key
sudo dd if=/dev/urandom of=/root/keyfile bs=1024 count=4
sudo chmod 0400 /root/keyfile

# Add key to LUKS
sudo cryptsetup luksAddKey /dev/sdb1 /root/keyfile

# Add to /etc/crypttab
encrypted_data /dev/sdb1 /root/keyfile luks

# Add to /etc/fstab
/dev/mapper/encrypted_data /mnt/encrypted ext4 defaults 0 2
```

#### Encrypt home directory

```bash
# Install ecryptfs
sudo apt install ecryptfs-utils

# Encrypt existing user home
sudo ecryptfs-migrate-home -u username

# Encrypt new user home
sudo adduser --encrypt-home newuser
```

### Logging and Monitoring

#### Configure rsyslog

```bash
# Edit rsyslog
sudo vim /etc/rsyslog.conf

# Log to remote server
*.* @192.168.1.100:514      # UDP
*.* @@192.168.1.100:514     # TCP

# Restart
sudo systemctl restart rsyslog
```

#### Monitor auth logs

```bash
# Watch auth log
sudo tail -f /var/log/auth.log

# Failed SSH attempts
grep "Failed password" /var/log/auth.log

# Successful SSH logins
grep "Accepted password" /var/log/auth.log

# Sudo usage
grep "sudo" /var/log/auth.log
```

#### Process monitoring

```bash
# Monitor processes
ps aux | grep suspicious

# Monitor network connections
sudo netstat -tulpn
sudo ss -tulpn

# Find listening services
sudo lsof -i -P -n
```

### Security Checklist

#### Daily tasks
- [ ] Review system logs
- [ ] Check for failed login attempts
- [ ] Monitor running processes
- [ ] Check disk usage

#### Weekly tasks
- [ ] Review user accounts
- [ ] Check for security updates
- [ ] Review firewall logs
- [ ] Verify backup success

#### Monthly tasks
- [ ] Run security audit (Lynis)
- [ ] Run rootkit scan (rkhunter)
- [ ] Review and update firewall rules
- [ ] Review sudo access
- [ ] Update antivirus definitions
- [ ] Test backup restore

#### After any incident
- [ ] Check all logs
- [ ] Run full system scan
- [ ] Verify file integrity (AIDE)
- [ ] Change passwords
- [ ] Review access logs
- [ ] Update security policies

### Best Practices

1. **Keep system updated**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Use strong passwords** - minimum 12 characters, mixed case, numbers, symbols

3. **Enable automatic security updates**
   ```bash
   sudo apt install unattended-upgrades
   sudo dpkg-reconfigure --priority=low unattended-upgrades
   ```

4. **Principle of least privilege** - users only get access they need

5. **Regular backups** - test restore procedures

6. **Monitor logs** - set up alerts for suspicious activity

7. **Keep services minimal** - only run what's needed

8. **Use SELinux or AppArmor** - mandatory access control

9. **Document everything** - security policies, procedures, incidents

10. **Stay informed** - subscribe to security mailing lists
