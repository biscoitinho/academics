## SSH and SCP

### SSH Basics

```bash
# Connect
ssh username@hostname
ssh username@192.168.1.100
ssh -p 2222 username@hostname

# Run command
ssh username@hostname 'ls -la'
ssh -t username@hostname 'sudo systemctl status nginx'

# Verbose (debugging)
ssh -v username@hostname
ssh -vvv username@hostname
```

### SSH Keys

```bash
# Generate key
ssh-keygen -t ed25519 -C "email@example.com"
ssh-keygen -t rsa -b 4096 -C "email@example.com"

# Copy to server
ssh-copy-id username@hostname
ssh-copy-id -i ~/.ssh/id_work.pub -p 2222 username@hostname

# Manual copy
cat ~/.ssh/id_ed25519.pub | ssh username@hostname "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

### SSH Config

```bash
# ~/.ssh/config
Host myserver
    HostName 192.168.1.100
    User admin
    Port 22
    IdentityFile ~/.ssh/id_work

Host *
    ServerAliveInterval 60

# Usage
ssh myserver
```

### Port Forwarding

```bash
# Local forward (access remote service)
ssh -L 8080:localhost:80 username@hostname

# Remote forward (expose local service)
ssh -R 8080:localhost:80 username@hostname

# Dynamic (SOCKS proxy)
ssh -D 8080 username@hostname
```

### Jump Host

```bash
# Single jump
ssh -J jumphost username@destination

# Multiple jumps
ssh -J jump1,jump2 username@destination

# In config
Host destination
    ProxyJump jumphost
```

### SSH Agent

```bash
# Start agent
eval "$(ssh-agent -s)"

# Add key
ssh-add ~/.ssh/id_ed25519

# List keys
ssh-add -l

# Forward agent
ssh -A username@hostname
```

### SCP

```bash
# Upload
scp file.txt username@hostname:/path/
scp -r directory/ username@hostname:/path/

# Download
scp username@hostname:/path/file.txt .
scp -r username@hostname:/path/directory/ .

# Options
scp -P 2222 file.txt username@hostname:~/       # Port
scp -i ~/.ssh/key file.txt username@hostname:~/ # Key
scp -C large_file.tar.gz username@hostname:~/   # Compress
```

### SFTP

```bash
# Connect
sftp username@hostname

# Commands
get remote_file.txt
put local_file.txt
get -r directory
put -r directory
ls
lls
cd /path
lcd /path
quit
```

### Rsync (Better Alternative)

```bash
# Basic
rsync -avz file.txt username@hostname:/path/
rsync -avz username@hostname:/path/ /local/path/

# With progress
rsync -avP /source/ username@hostname:/dest/

# Delete in dest
rsync -avz --delete /source/ username@hostname:/dest/

# Exclude
rsync -avz --exclude='*.log' /source/ username@hostname:/dest/

# Custom SSH port
rsync -avz -e "ssh -p 2222" /source/ username@hostname:/dest/
```

### Security

```bash
# Permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config

# Server config (/etc/ssh/sshd_config)
Port 2222
PermitRootLogin no
PasswordAuthentication no
```

### Troubleshooting

```bash
# Debug
ssh -vvv username@hostname

# Test connection
nc -zv hostname 22

# Check logs
sudo tail -f /var/log/auth.log
sudo journalctl -u sshd -f

# Remove known host
ssh-keygen -R hostname
```

### Quick Reference

```bash
# SSH
ssh user@host
ssh -p 2222 user@host
ssh-keygen -t ed25519
ssh-copy-id user@host

# SCP
scp file.txt user@host:/path/
scp user@host:/path/file.txt .
scp -r dir/ user@host:/path/

# Port forwarding
ssh -L 8080:localhost:80 user@host
ssh -R 8080:localhost:80 user@host
ssh -D 8080 user@host

# Rsync
rsync -avP /source/ user@host:/dest/
```
