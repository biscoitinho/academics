## SSH and SCP - Secure Remote Access and File Transfer

### SSH (Secure Shell)

SSH is a network protocol for secure remote login and command execution.

#### Basic SSH Usage

```bash
# Connect to remote host
ssh username@hostname
ssh username@192.168.1.100

# Connect on specific port
ssh -p 2222 username@hostname

# Connect with verbose output (debugging)
ssh -v username@hostname
ssh -vv username@hostname    # More verbose
ssh -vvv username@hostname   # Maximum verbosity

# Connect and run command
ssh username@hostname 'ls -la /var/log'
ssh username@hostname 'uptime && free -h'

# Connect and run interactive command
ssh -t username@hostname 'sudo systemctl status nginx'
# -t forces pseudo-terminal allocation (needed for sudo)
```

#### SSH Keys

```bash
# Generate SSH key pair
ssh-keygen -t ed25519 -C "your_email@example.com"
# Or RSA (more compatible)
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# Keys saved to:
# ~/.ssh/id_ed25519      (private key - keep secret!)
# ~/.ssh/id_ed25519.pub  (public key - share this)

# Generate key with custom name
ssh-keygen -t ed25519 -f ~/.ssh/id_work -C "work@example.com"

# Generate key without passphrase (automation - less secure)
ssh-keygen -t ed25519 -N "" -f ~/.ssh/id_automation

# Change key passphrase
ssh-keygen -p -f ~/.ssh/id_ed25519
```

#### Copy SSH Key to Server

```bash
# Easiest method
ssh-copy-id username@hostname

# Specific key
ssh-copy-id -i ~/.ssh/id_work.pub username@hostname

# Specific port
ssh-copy-id -i ~/.ssh/id_ed25519.pub -p 2222 username@hostname

# Manual method
cat ~/.ssh/id_ed25519.pub | ssh username@hostname "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"

# Set correct permissions on server
ssh username@hostname "chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
```

#### SSH Config File

```bash
# Create/edit SSH config
vim ~/.ssh/config

# Example configuration:
Host myserver
    HostName 192.168.1.100
    User admin
    Port 22
    IdentityFile ~/.ssh/id_work

Host github
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_github

Host dev-*
    User developer
    IdentityFile ~/.ssh/id_dev
    ForwardAgent yes

Host *
    ServerAliveInterval 60
    ServerAliveCountMax 3

# Now connect easily:
ssh myserver
ssh github
ssh dev-server1
```

#### Common SSH Options

```bash
# Use specific key
ssh -i ~/.ssh/id_work username@hostname

# Forward X11 (GUI apps)
ssh -X username@hostname
ssh -X username@hostname 'firefox'

# Forward agent (use local keys on remote)
ssh -A username@hostname

# Disable host key checking (testing only!)
ssh -o StrictHostKeyChecking=no username@hostname

# Keep connection alive
ssh -o ServerAliveInterval=60 username@hostname

# Compression (slow networks)
ssh -C username@hostname

# Quiet mode (suppress warnings)
ssh -q username@hostname

# Background mode (with port forwarding)
ssh -f -N username@hostname
```

#### SSH Port Forwarding (Tunneling)

```bash
# Local port forwarding
# Forward local port 8080 to remote localhost:80
ssh -L 8080:localhost:80 username@hostname
# Now access http://localhost:8080 to reach remote port 80

# Forward to different host through SSH server
ssh -L 8080:database.internal:3306 username@jumphost
# Access database through jumphost

# Remote port forwarding
# Make local service accessible from remote
ssh -R 8080:localhost:80 username@hostname
# Remote users can access your local port 80 via remote port 8080

# Dynamic port forwarding (SOCKS proxy)
ssh -D 8080 username@hostname
# Configure browser to use localhost:8080 as SOCKS5 proxy

# Keep tunnel open in background
ssh -f -N -L 8080:localhost:80 username@hostname
# -f = background, -N = no command execution
```

#### SSH ProxyJump (Bastion/Jump Host)

```bash
# Connect through jump host
ssh -J jumphost username@destination
ssh -J user1@jump1 user2@destination

# Multiple jump hosts
ssh -J user1@jump1,user2@jump2 user3@destination

# In SSH config:
Host destination
    HostName 10.0.1.100
    User admin
    ProxyJump jumphost

Host jumphost
    HostName jump.example.com
    User jumper

# Now just:
ssh destination
```

#### SSH Agent (Key Management)

```bash
# Start SSH agent
eval "$(ssh-agent -s)"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# Add key with lifetime (1 hour)
ssh-add -t 3600 ~/.ssh/id_ed25519

# List loaded keys
ssh-add -l

# Remove key from agent
ssh-add -d ~/.ssh/id_ed25519

# Remove all keys
ssh-add -D

# Forward agent to remote
ssh -A username@hostname
```

#### SSH Escape Sequences

When connected, press `~` then:

```bash
~.    # Disconnect
~^Z   # Suspend SSH (bg to resume)
~#    # List forwarded connections
~?    # Help (show all escape sequences)
~C    # Open command line (for port forwarding)
```

#### SSH Multiplexing (Reuse Connections)

```bash
# In ~/.ssh/config:
Host *
    ControlMaster auto
    ControlPath ~/.ssh/sockets/%r@%h:%p
    ControlPersist 10m

# Create socket directory
mkdir -p ~/.ssh/sockets

# First connection creates master
ssh server

# Subsequent connections reuse master (much faster)
ssh server  # Instant connection!
```

### SCP (Secure Copy)

Copy files securely over SSH.

#### Basic SCP Usage

```bash
# Copy file to remote
scp file.txt username@hostname:/path/to/destination/

# Copy file from remote
scp username@hostname:/path/to/file.txt /local/path/

# Copy to home directory
scp file.txt username@hostname:~/

# Copy and rename
scp file.txt username@hostname:~/newname.txt
```

#### Copy Directories

```bash
# Copy directory recursively
scp -r directory/ username@hostname:/path/

# Copy directory from remote
scp -r username@hostname:/path/to/directory/ /local/path/

# Copy multiple files
scp file1.txt file2.txt username@hostname:~/
```

#### SCP Options

```bash
# Preserve timestamps and permissions
scp -p file.txt username@hostname:~/

# Specific port
scp -P 2222 file.txt username@hostname:~/
# Note: -P (uppercase) for scp, -p for ssh

# Specific SSH key
scp -i ~/.ssh/id_work file.txt username@hostname:~/

# Compress during transfer
scp -C large_file.tar.gz username@hostname:~/

# Limit bandwidth (KB/s)
scp -l 1024 file.txt username@hostname:~/

# Verbose output
scp -v file.txt username@hostname:~/

# Quiet mode
scp -q file.txt username@hostname:~/
```

#### Copy Between Remote Hosts

```bash
# Copy from one remote to another (through local)
scp user1@host1:/path/file.txt user2@host2:/path/

# Using 3-way copy (faster, direct)
scp -3 user1@host1:/path/file.txt user2@host2:/path/
```

#### Copy with Progress

```bash
# SCP doesn't show detailed progress by default
# Use rsync for progress bar
rsync -avP --rsh=ssh file.txt username@hostname:~/

# Or use verbose mode
scp -v file.txt username@hostname:~/
```

#### SCP with SSH Config

```bash
# If you have SSH config:
Host myserver
    HostName 192.168.1.100
    User admin
    IdentityFile ~/.ssh/id_work

# Just use the alias:
scp file.txt myserver:~/
scp -r directory/ myserver:/var/www/
```

#### Common SCP Patterns

```bash
# Backup to remote server
scp -r /var/www/html/ backup@server:/backups/$(date +%Y%m%d)/

# Download logs from remote
scp server:/var/log/nginx/access.log ~/logs/

# Copy configuration files
scp server:/etc/nginx/nginx.conf ~/configs/nginx.conf.backup

# Upload and preserve permissions
scp -rp /etc/myapp/ server:/etc/myapp/

# Copy through jump host
scp -o "ProxyJump jumphost" file.txt destination:~/
```

### SFTP (SSH File Transfer Protocol)

Interactive file transfer over SSH.

#### Basic SFTP Usage

```bash
# Connect to remote
sftp username@hostname

# With specific port
sftp -P 2222 username@hostname

# Connect and run command
sftp username@hostname <<EOF
get /remote/file.txt
quit
EOF
```

#### SFTP Commands

```bash
# Once connected:

# Navigation
pwd                    # Remote working directory
lpwd                   # Local working directory
ls                     # List remote files
lls                    # List local files
cd /path               # Change remote directory
lcd /path              # Change local directory

# Transfer files
get remote_file.txt                    # Download file
get remote_file.txt local_name.txt     # Download and rename
put local_file.txt                     # Upload file
put local_file.txt remote_name.txt     # Upload and rename

# Multiple files
mget *.txt            # Download multiple files
mput *.txt            # Upload multiple files

# Directories
get -r directory      # Download directory recursively
put -r directory      # Upload directory recursively

# Other
mkdir dirname         # Create remote directory
lmkdir dirname        # Create local directory
rm file.txt           # Delete remote file
rmdir dirname         # Delete remote directory
rename old new        # Rename remote file
!command              # Execute local shell command

# Exit
quit
bye
exit
```

#### SFTP Batch Mode

```bash
# Create batch file
cat > batch.sftp <<EOF
cd /var/www/html
get index.html
put new_file.txt
quit
EOF

# Execute batch
sftp -b batch.sftp username@hostname
```

### Rsync (Better Alternative)

Rsync is often better than SCP for file transfers.

```bash
# Basic rsync over SSH
rsync -avz file.txt username@hostname:/path/

# Why rsync is better:
# -a: Archive mode (preserves everything)
# -v: Verbose
# -z: Compress during transfer
# -P: Progress bar + resume partial transfers

# Sync directory (trailing slash matters!)
rsync -avz /source/ username@hostname:/dest/
# Copies contents of /source/ to /dest/

rsync -avz /source username@hostname:/dest/
# Copies /source directory itself to /dest/source

# Delete files in dest not in source
rsync -avz --delete /source/ username@hostname:/dest/

# Dry run (see what would happen)
rsync -avzn /source/ username@hostname:/dest/

# Show progress
rsync -avP /source/ username@hostname:/dest/

# Specific SSH port
rsync -avz -e "ssh -p 2222" /source/ username@hostname:/dest/

# Specific SSH key
rsync -avz -e "ssh -i ~/.ssh/id_work" /source/ username@hostname:/dest/

# Exclude files
rsync -avz --exclude='*.log' /source/ username@hostname:/dest/

# Bandwidth limit
rsync -avz --bwlimit=1024 /source/ username@hostname:/dest/
```

### Security Best Practices

#### SSH Server Configuration

```bash
# Edit SSH server config
sudo vim /etc/ssh/sshd_config

# Recommended settings:
Port 2222                      # Non-standard port
PermitRootLogin no             # Disable root login
PasswordAuthentication no      # Keys only
PubkeyAuthentication yes       # Enable key auth
PermitEmptyPasswords no        # No empty passwords
X11Forwarding no               # Disable X11 unless needed
MaxAuthTries 3                 # Limit attempts
AllowUsers user1 user2         # Whitelist users
ClientAliveInterval 300        # Timeout idle sessions
ClientAliveCountMax 2

# Restart SSH
sudo systemctl restart sshd
```

#### Client Security

```bash
# Proper key permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/authorized_keys

# Use strong passphrase on keys
ssh-keygen -t ed25519 -C "user@example.com"
# Enter passphrase when prompted

# Verify host fingerprint on first connect
ssh username@hostname
# Check fingerprint matches expected value

# Disable outdated algorithms
# In ~/.ssh/config:
Host *
    KexAlgorithms curve25519-sha256@libssh.org
    HostKeyAlgorithms ssh-ed25519
    Ciphers chacha20-poly1305@openssh.com
```

### Troubleshooting

```bash
# Debug connection
ssh -vvv username@hostname

# Test SSH server is listening
telnet hostname 22
nc -zv hostname 22

# Check SSH service
sudo systemctl status sshd

# Check SSH logs
sudo tail -f /var/log/auth.log          # Debian/Ubuntu
sudo tail -f /var/log/secure            # RHEL/CentOS
sudo journalctl -u sshd -f              # systemd

# Check SSH config syntax
sudo sshd -t

# Permission issues
ls -la ~/.ssh/
# Should be:
# drwx------ .ssh/
# -rw------- id_ed25519
# -rw-r--r-- id_ed25519.pub
# -rw------- authorized_keys

# Known hosts issues
ssh-keygen -R hostname              # Remove host from known_hosts
rm ~/.ssh/known_hosts               # Remove all (last resort)

# Connection timeout
ssh -o ConnectTimeout=10 username@hostname

# Firewall blocking
sudo ufw allow 22
sudo firewall-cmd --add-port=22/tcp --permanent
```

### Quick Reference

```bash
# SSH
ssh user@host                          # Connect
ssh -p 2222 user@host                  # Custom port
ssh -i key user@host                   # Specific key
ssh user@host command                  # Run command
ssh-keygen -t ed25519                  # Generate key
ssh-copy-id user@host                  # Copy key to server

# SCP
scp file.txt user@host:/path/          # Upload file
scp user@host:/path/file.txt .         # Download file
scp -r dir/ user@host:/path/           # Upload directory
scp -P 2222 file.txt user@host:~/      # Custom port

# Port Forwarding
ssh -L 8080:localhost:80 user@host     # Local forward
ssh -R 8080:localhost:80 user@host     # Remote forward
ssh -D 8080 user@host                  # SOCKS proxy

# Rsync (recommended over SCP)
rsync -avz file.txt user@host:/path/   # Upload with progress
rsync -avP user@host:/path/ .          # Download with progress
rsync -avz --delete src/ user@host:/dst/  # Sync directories
```
