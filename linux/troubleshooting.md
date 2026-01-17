## Linux Troubleshooting and Debugging

### General Troubleshooting Approach

1. **Define the problem** - What exactly is not working?
2. **Gather information** - Logs, error messages, symptoms
3. **Analyze** - Look for patterns, recent changes
4. **Form hypothesis** - What could cause this?
5. **Test** - Verify your hypothesis
6. **Fix** - Implement solution
7. **Verify** - Confirm issue is resolved
8. **Document** - Record the problem and solution

### System Logs

#### Main log locations

```bash
# System logs (systemd)
sudo journalctl                     # All logs
sudo journalctl -f                  # Follow in real-time
sudo journalctl -u service-name     # Specific service
sudo journalctl -p err              # Errors only
sudo journalctl --since "1 hour ago"
sudo journalctl --since "2024-01-01"
sudo journalctl -b                  # Current boot
sudo journalctl -b -1               # Previous boot

# Traditional logs (rsyslog)
/var/log/syslog                     # System messages (Debian/Ubuntu)
/var/log/messages                   # System messages (RHEL/CentOS)
/var/log/auth.log                   # Authentication
/var/log/kern.log                   # Kernel messages
/var/log/boot.log                   # Boot messages
/var/log/dmesg                      # Kernel ring buffer

# Service-specific logs
/var/log/apache2/                   # Apache
/var/log/nginx/                     # Nginx
/var/log/mysql/                     # MySQL
/var/log/postgresql/                # PostgreSQL
```

#### View and search logs

```bash
# View logs
sudo tail -f /var/log/syslog        # Follow in real-time
sudo tail -n 100 /var/log/syslog    # Last 100 lines
sudo head -n 50 /var/log/syslog     # First 50 lines
sudo less /var/log/syslog           # Interactive viewing

# Search logs
sudo grep "error" /var/log/syslog
sudo grep -i "failed" /var/log/auth.log  # Case insensitive
sudo grep -r "error" /var/log/      # Recursive search

# Filter by date/time
sudo grep "Jan 15" /var/log/syslog
sudo awk '/Jan 15 14:00/,/Jan 15 15:00/' /var/log/syslog

# Count occurrences
sudo grep -c "error" /var/log/syslog

# Multiple patterns
sudo egrep "error|fail|critical" /var/log/syslog

# Context around match
sudo grep -B 5 -A 5 "error" /var/log/syslog  # 5 lines before/after
```

#### Advanced log analysis

```bash
# Find most common errors
sudo grep error /var/log/syslog | sort | uniq -c | sort -rn | head

# Errors in last hour
sudo journalctl --since "1 hour ago" -p err

# Track specific service failures
sudo journalctl -u nginx.service -p err --since today

# Export logs to file
sudo journalctl --since "2024-01-01" > logs-export.txt

# View logs from specific boot
sudo journalctl --list-boots
sudo journalctl -b -1              # Previous boot
```

### Boot Issues

#### Can't boot - recovery mode

```bash
# Enter recovery mode (GRUB menu → Advanced → Recovery mode)

# Once in recovery mode:
# 1. Enable networking
sudo dhclient

# 2. Remount root as read-write
sudo mount -o remount,rw /

# 3. Check filesystem
sudo fsck -y /dev/sda1

# 4. Check fstab
sudo nano /etc/fstab

# 5. Update GRUB
sudo update-grub

# 6. Exit and reboot
exit
sudo reboot
```

#### GRUB issues

```bash
# Reinstall GRUB (from live USB)
sudo mount /dev/sda1 /mnt
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt
grub-install /dev/sda
update-grub
exit
sudo reboot

# Fix GRUB configuration
sudo update-grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

#### Kernel panic

```bash
# Check kernel logs
dmesg | grep -i panic
sudo journalctl -k -b -1           # Kernel logs from last boot

# Boot with older kernel (GRUB menu → Advanced)

# Remove problematic kernel
sudo apt remove linux-image-X.X.X-XX

# Reinstall kernel
sudo apt install --reinstall linux-image-generic
```

#### Black screen after boot

```bash
# Try different display settings
# At GRUB, press 'e' to edit, add to linux line:
nomodeset                          # Disable kernel mode setting
acpi=off                           # Disable ACPI
noapic                             # Disable APIC
nouveau.modeset=0                  # Disable Nouveau (Nvidia)

# Check display manager
sudo systemctl status gdm          # GNOME
sudo systemctl status lightdm      # LightDM
sudo systemctl restart gdm
```

### Service Issues

#### Service won't start

```bash
# Check service status
sudo systemctl status service-name

# Check if enabled
sudo systemctl is-enabled service-name

# View service logs
sudo journalctl -u service-name -n 50

# Check service file
systemctl cat service-name

# Validate service file
systemd-analyze verify /etc/systemd/system/service-name.service

# Start service with debug
sudo systemd-run --unit=test-service /path/to/binary

# Check dependencies
systemctl list-dependencies service-name
```

#### Service keeps crashing

```bash
# View crash logs
sudo journalctl -u service-name -f

# Check resource limits
systemctl show service-name | grep Limit

# Run manually to see errors
sudo -u service-user /usr/bin/service-binary

# Check permissions
sudo ls -l /usr/bin/service-binary
sudo ls -l /var/run/service/

# Increase restart limits
sudo systemctl edit service-name
# Add:
[Service]
Restart=always
RestartSec=10
StartLimitIntervalSec=0
```

#### Port already in use

```bash
# Find what's using the port
sudo lsof -i :80
sudo ss -tulpn | grep :80
sudo netstat -tulpn | grep :80

# Kill process using port
sudo kill $(sudo lsof -t -i:80)
sudo fuser -k 80/tcp
```

### Network Issues

#### No internet connection

```bash
# Check network interfaces
ip addr show
ip link show

# Bring interface up
sudo ip link set eth0 up

# Check DNS
cat /etc/resolv.conf
nslookup google.com
dig google.com

# Check routing
ip route show
traceroute google.com

# Test connectivity
ping 8.8.8.8                       # Google DNS
ping google.com                    # With DNS resolution

# Check firewall
sudo iptables -L -n
sudo ufw status

# Restart networking
sudo systemctl restart NetworkManager
sudo systemctl restart networking
```

#### DNS not working

```bash
# Check DNS configuration
cat /etc/resolv.conf
resolvectl status

# Test DNS
nslookup google.com
dig google.com
host google.com

# Set DNS temporarily
sudo nano /etc/resolv.conf
# Add:
nameserver 8.8.8.8
nameserver 8.8.4.4

# Flush DNS cache
sudo systemd-resolve --flush-caches
sudo resolvectl flush-caches

# Restart resolver
sudo systemctl restart systemd-resolved
```

#### Slow network

```bash
# Test speed
speedtest-cli

# Check bandwidth usage
iftop
nethogs
nload

# Check for packet loss
ping -c 100 8.8.8.8

# Check network stats
ip -s link
netstat -s
ss -s

# Check MTU
ip link show | grep mtu

# Optimize MTU
sudo ip link set dev eth0 mtu 1400
```

#### Can't SSH to server

```bash
# Test connection
ssh -v user@server                 # Verbose mode
ssh -vv user@server                # More verbose
ssh -vvv user@server               # Maximum verbose

# Check if SSH is running
sudo systemctl status sshd

# Check SSH is listening
sudo ss -tulpn | grep :22

# Check firewall
sudo ufw status | grep 22
sudo iptables -L -n | grep 22

# Check SSH config
sudo sshd -t                       # Test config
sudo nano /etc/ssh/sshd_config

# Check logs
sudo tail -f /var/log/auth.log | grep sshd
sudo journalctl -u sshd -f
```

### Disk Issues

#### Disk full

```bash
# Check disk usage
df -h

# Find large directories
du -sh /*
du -sh /var/* | sort -hr
du -h /home/user | sort -hr | head -20

# Find large files
find / -type f -size +100M -exec ls -lh {} \;
find /var -type f -size +1G

# Find files by age
find /var/log -type f -mtime +30   # Older than 30 days

# Clean package cache
sudo apt clean
sudo dnf clean all

# Remove old kernels
sudo apt autoremove
dpkg --list | grep linux-image

# Clean journal logs
sudo journalctl --vacuum-size=100M
sudo journalctl --vacuum-time=7d

# Clear temp files
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
```

#### High I/O wait

```bash
# Check I/O wait
top                                # Look at 'wa' in CPU line
iostat -x 2                        # Extended I/O stats every 2s

# Find processes doing I/O
sudo iotop
sudo iotop -o                      # Only show active processes

# Check disk health
sudo smartctl -a /dev/sda

# Check for bad blocks
sudo badblocks -v /dev/sda
```

#### Disk errors

```bash
# Check filesystem
sudo fsck /dev/sda1                # Unmount first!

# Check SMART status
sudo smartctl -H /dev/sda
sudo smartctl -a /dev/sda

# Check dmesg for errors
dmesg | grep -i error
dmesg | grep -i ata

# Remount read-only if errors
sudo mount -o remount,ro /
```

### Memory Issues

#### Out of memory

```bash
# Check memory usage
free -h
top
htop

# Find memory-hungry processes
ps aux --sort=-%mem | head
top -o %MEM

# Check OOM killer logs
dmesg | grep -i "out of memory"
dmesg | grep -i "killed process"
sudo journalctl -k | grep -i "out of memory"

# Check swap
swapon --show
free -h

# Add more swap (temporary)
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Clear cache (safe, but temporary relief)
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches
```

#### Memory leak detection

```bash
# Monitor process memory over time
watch -n 1 'ps aux | grep process-name | grep -v grep'

# Track memory growth
while true; do
    ps aux | grep process-name | grep -v grep
    sleep 60
done >> memory-log.txt

# Analyze with valgrind (for debugging)
valgrind --leak-check=full ./program
```

### CPU Issues

#### High CPU usage

```bash
# Check CPU usage
top
htop
mpstat 1                           # CPU stats every second

# Find CPU-hungry processes
ps aux --sort=-%cpu | head
top -o %CPU

# Per-CPU stats
mpstat -P ALL 1

# Check load average
uptime
cat /proc/loadavg

# Limit process CPU (nice)
nice -n 19 ./cpu-intensive-task    # Lowest priority
renice 10 -p PID                   # Change priority

# Limit with cpulimit
cpulimit -p PID -l 50              # Limit to 50% CPU
```

#### System load high

```bash
# Check load average
uptime                             # 1, 5, 15 minute averages
cat /proc/loadavg

# Rule of thumb: Load < number of CPU cores is OK
# Find number of cores
nproc
lscpu | grep "^CPU(s)"

# Find what's causing load
top
ps aux --sort=-%cpu

# Check if I/O bound
iostat -x 2
iotop
```

### Process Issues

#### Zombie processes

```bash
# Find zombie processes
ps aux | grep Z
ps aux | awk '$8 == "Z"'

# Find parent of zombie
ps -o ppid= -p ZOMBIE_PID

# Kill parent (zombie will be cleaned up)
kill PARENT_PID

# If many zombies, check parent process
ps aux | grep PARENT_PID
```

#### Process won't die

```bash
# Try normal kill
kill PID

# Force kill
kill -9 PID

# If still not dead, check process state
ps aux | grep PID

# Uninterruptible sleep (D state) - usually I/O
# Can't be killed, wait for I/O to complete

# Check what file it's waiting on
sudo lsof -p PID
```

#### Too many processes

```bash
# Check process limit
ulimit -u

# Count processes by user
ps aux | awk '{print $1}' | sort | uniq -c | sort -rn

# Find fork bomb
ps aux | grep -E "PID|bash" | head -20

# Kill all user processes
sudo pkill -u username
```

### Permission Issues

#### Permission denied

```bash
# Check file permissions
ls -l /path/to/file

# Check ownership
ls -l /path/to/file

# Fix permissions
sudo chmod 644 /path/to/file       # Files
sudo chmod 755 /path/to/directory  # Directories

# Fix ownership
sudo chown user:group /path/to/file
sudo chown -R user:group /path/to/directory

# Check SELinux/AppArmor
getenforce                         # SELinux
sudo aa-status                     # AppArmor

# Fix SELinux context
sudo restorecon -Rv /path/
```

#### Sudo issues

```bash
# Test sudo
sudo -v

# Check user in sudo group
groups
groups username

# Add user to sudo group
sudo usermod -aG sudo username

# Check sudoers file
sudo visudo

# Test specific command
sudo -l                            # List allowed commands
sudo -U username -l                # For specific user

# Sudo logs
sudo journalctl | grep sudo
sudo cat /var/log/auth.log | grep sudo
```

### Package Issues

#### Broken packages (Debian/Ubuntu)

```bash
# Fix broken packages
sudo apt --fix-broken install
sudo dpkg --configure -a

# Reconfigure package
sudo dpkg-reconfigure package-name

# Remove problematic package
sudo apt remove package-name
sudo apt purge package-name

# Clean package cache
sudo apt clean
sudo apt autoclean
sudo apt autoremove
```

#### Package conflicts

```bash
# See what's wrong
sudo apt upgrade
sudo apt full-upgrade

# Remove conflicting package
sudo apt remove conflicting-package

# Force version
sudo apt install package=version
```

#### Dependency hell (RHEL/CentOS)

```bash
# Check for problems
sudo dnf check
sudo rpm -Va                       # Verify all packages

# Fix broken dependencies
sudo dnf distro-sync

# Force reinstall
sudo dnf reinstall package-name

# Clean metadata
sudo dnf clean all
sudo dnf makecache
```

### Hardware Issues

#### Hardware detection

```bash
# List all hardware
lshw
lshw -short
lshw -class network

# PCI devices
lspci
lspci -v
lspci -k                           # With kernel drivers

# USB devices
lsusb
lsusb -v

# CPU info
lscpu
cat /proc/cpuinfo

# Memory info
lsmem
cat /proc/meminfo

# Block devices
lsblk
```

#### Driver issues

```bash
# Check loaded modules
lsmod

# Load module
sudo modprobe module-name

# Unload module
sudo rmmod module-name

# Check module info
modinfo module-name

# Blacklist module
sudo nano /etc/modprobe.d/blacklist.conf
# Add: blacklist module-name

# Update initramfs
sudo update-initramfs -u
```

### Performance Analysis

#### System information

```bash
# Overall system info
uname -a
hostnamectl
lsb_release -a

# Hardware info
sudo dmidecode
sudo lshw

# Boot time
systemd-analyze
systemd-analyze blame               # What took longest
systemd-analyze critical-chain      # Critical path
```

#### Monitoring tools

```bash
# Interactive monitoring
top                                 # Classic
htop                                # Better interface
atop                                # Advanced
glances                             # All-in-one

# System activity
sar                                 # System activity reporter
vmstat 1                            # Virtual memory stats
iostat 1                            # I/O stats
mpstat 1                            # CPU stats

# Network monitoring
iftop                               # Network traffic
nethogs                             # Per-process network
ss -s                               # Socket stats
```

#### Benchmarking

```bash
# Disk I/O
dd if=/dev/zero of=/tmp/test bs=1M count=1024 conv=fdatasync

# CPU
sysbench cpu run

# Memory
sysbench memory run

# Network
iperf -s                            # Server
iperf -c server-ip                  # Client
```

### Debugging Tools

#### strace - System call tracer

```bash
# Trace program execution
strace ls
strace -o output.txt ls

# Attach to running process
sudo strace -p PID

# Follow forks
strace -f ./program

# Filter system calls
strace -e open,read,write ./program

# Timing info
strace -T ./program
strace -c ./program                 # Summary statistics
```

#### lsof - List open files

```bash
# List all open files
sudo lsof

# Files opened by process
sudo lsof -p PID

# Processes using file
sudo lsof /path/to/file

# Network connections
sudo lsof -i
sudo lsof -i :80                    # Specific port

# Files in directory
sudo lsof +D /var/log
```

#### tcpdump - Network packet analyzer

```bash
# Capture packets
sudo tcpdump -i eth0

# Save to file
sudo tcpdump -i eth0 -w capture.pcap

# Specific host
sudo tcpdump host 192.168.1.100

# Specific port
sudo tcpdump port 80

# HTTP traffic
sudo tcpdump -i eth0 port 80 -A

# Read from file
tcpdump -r capture.pcap
```

### Emergency Toolkit

Essential commands for critical situations:

```bash
# Check what's running
ps aux
top
htop

# Check resources
df -h                               # Disk space
free -h                             # Memory
uptime                              # Load average

# Check network
ip addr                             # IP addresses
ip route                            # Routing
ss -tulpn                           # Listening services

# Check logs
journalctl -xe                      # Recent logs with explanation
dmesg | tail                        # Kernel messages

# Kill runaway processes
pkill process-name
killall process-name
kill -9 PID

# Restart services
systemctl restart service-name

# Reboot (last resort)
sudo reboot
sudo shutdown -r now
```

### Troubleshooting Checklist

When something goes wrong:

1. [ ] What changed recently? (updates, config changes, new software)
2. [ ] Check relevant logs
3. [ ] Check resource usage (CPU, RAM, disk)
4. [ ] Verify service is running
5. [ ] Check network connectivity
6. [ ] Verify permissions and ownership
7. [ ] Check for error messages
8. [ ] Test with minimal configuration
9. [ ] Search for similar issues online
10. [ ] Document the problem and solution
