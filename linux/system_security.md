## System Security

### SSH Hardening

```bash
# /etc/ssh/sshd_config
Port 2222                      # Non-standard port
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
MaxAuthTries 3

sudo systemctl restart sshd
```

### Firewall

```bash
# UFW
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22
sudo ufw allow 80/tcp
sudo ufw allow from 192.168.1.100
sudo ufw enable
sudo ufw status

# iptables
sudo iptables -L -n
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -P INPUT DROP

# firewalld (RHEL/CentOS)
sudo firewall-cmd --add-service=http
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload
```

### fail2ban

```bash
sudo apt install fail2ban

# /etc/fail2ban/jail.local
[sshd]
enabled = true
port = 22
maxretry = 3
bantime = 86400

sudo systemctl restart fail2ban
sudo fail2ban-client status sshd
sudo fail2ban-client set sshd unbanip 192.168.1.100
```

### Password Policies

```bash
# /etc/security/pwquality.conf
minlen = 12
dcredit = -1    # Digit
ucredit = -1    # Uppercase
lcredit = -1    # Lowercase

# /etc/login.defs
PASS_MAX_DAYS   90
PASS_MIN_DAYS   7
PASS_WARN_AGE   14

# For existing user
sudo chage -M 90 -m 7 -W 14 username
```

### Security Auditing

```bash
# Lynis
sudo apt install lynis
sudo lynis audit system

# RKHunter
sudo apt install rkhunter
sudo rkhunter --update
sudo rkhunter --check

# ClamAV
sudo apt install clamav
sudo freshclam
clamscan -r /home/
```

### Kernel Hardening

```bash
# /etc/sysctl.conf
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.icmp_echo_ignore_all = 1
net.ipv4.tcp_syncookies = 1

sudo sysctl -p
```

### LUKS Encryption

```bash
# Encrypt partition
sudo cryptsetup luksFormat /dev/sdb1
sudo cryptsetup luksOpen /dev/sdb1 encrypted_data
sudo mkfs.ext4 /dev/mapper/encrypted_data
sudo mount /dev/mapper/encrypted_data /mnt/encrypted
```

### Quick Reference

```bash
# SSH
sudo vim /etc/ssh/sshd_config
sudo systemctl restart sshd

# Firewall
sudo ufw allow 22
sudo ufw enable

# fail2ban
sudo fail2ban-client status

# Audit
sudo lynis audit system
sudo rkhunter --check
```
