## Linux Troubleshooting

### System Logs

```bash
# systemd logs
sudo journalctl -f                      # Follow all
sudo journalctl -u service-name        # Specific service
sudo journalctl -p err                  # Errors only
sudo journalctl --since "1 hour ago"
sudo journalctl -b                      # Current boot

# Traditional logs
/var/log/syslog          # System messages (Debian/Ubuntu)
/var/log/messages        # System messages (RHEL/CentOS)
/var/log/auth.log        # Authentication
/var/log/kern.log        # Kernel

# Search logs
sudo grep "error" /var/log/syslog
sudo grep -i "fail" /var/log/auth.log
sudo journalctl | grep -i error
```

### Boot Issues

```bash
# Recovery mode - boot from GRUB menu → Advanced → Recovery

# Remount root read-write
sudo mount -o remount,rw /

# Check filesystem
sudo fsck -y /dev/sda1

# Fix GRUB
sudo mount /dev/sda1 /mnt
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo chroot /mnt
grub-install /dev/sda
update-grub

# Kernel panic - boot with older kernel from GRUB menu
```

### Service Issues

```bash
# Check service
sudo systemctl status service-name
sudo journalctl -u service-name -n 50

# Restart service
sudo systemctl restart service-name

# Check dependencies
systemctl list-dependencies service-name

# Port in use
sudo lsof -i :80
sudo ss -tulpn | grep :80
sudo kill $(sudo lsof -t -i:80)
```

### Network Issues

```bash
# Check connection
ip addr show
ip route show
ping 8.8.8.8
ping google.com

# DNS issues
cat /etc/resolv.conf
nslookup google.com
sudo systemd-resolve --flush-caches

# Restart networking
sudo systemctl restart NetworkManager

# SSH issues
ssh -vvv user@server                   # Debug
sudo systemctl status sshd
sudo tail -f /var/log/auth.log
```

### Disk Issues

```bash
# Disk full
df -h
du -sh /*
find / -type f -size +100M

# Clean up
sudo apt clean
sudo journalctl --vacuum-size=100M
sudo rm -rf /tmp/*

# Find large directories
du -sh /var/* | sort -hr | head -10

# Check disk health
sudo smartctl -H /dev/sda

# High I/O
iostat -x 2
sudo iotop
```

### Memory Issues

```bash
# Check memory
free -h
top
ps aux --sort=-%mem | head

# OOM killer logs
dmesg | grep -i "out of memory"
sudo journalctl -k | grep -i oom

# Clear cache (safe)
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches
```

### CPU Issues

```bash
# Check CPU usage
top
htop
ps aux --sort=-%cpu | head

# Check load
uptime
cat /proc/loadavg

# Limit CPU
nice -n 19 ./program
cpulimit -p PID -l 50
```

### Process Issues

```bash
# Find zombie processes
ps aux | awk '$8 == "Z"'

# Kill processes
kill PID
kill -9 PID
killall process_name

# Process state
ps aux | grep PID
```

### Permission Issues

```bash
# Check permissions
ls -l /path/to/file

# Fix permissions
sudo chmod 644 file
sudo chmod 755 directory
sudo chown user:group file

# SELinux/AppArmor
getenforce
sudo restorecon -Rv /path/
sudo aa-status
```

### Package Issues

```bash
# Debian/Ubuntu
sudo apt --fix-broken install
sudo dpkg --configure -a
sudo apt clean

# RHEL/CentOS
sudo dnf check
sudo dnf clean all
```

### Debugging Tools

```bash
# strace - trace system calls
strace ls
strace -p PID

# lsof - list open files
sudo lsof
sudo lsof -p PID
sudo lsof /path/to/file
sudo lsof -i :80

# tcpdump - network packets
sudo tcpdump -i eth0
sudo tcpdump port 80
```

### Emergency Commands

```bash
# Quick checks
ps aux | grep process
df -h
free -h
uptime
ip addr
ss -tulpn
journalctl -xe
dmesg | tail

# Kill runaway process
pkill process-name
killall process-name

# Reboot
sudo reboot
```

### Troubleshooting Checklist

1. What changed recently?
2. Check logs
3. Check resources (CPU, RAM, disk)
4. Verify service is running
5. Check network
6. Verify permissions
7. Search similar issues
8. Document solution
