## Linux vs BSD vs macOS

### Overview

**Linux**: Unix-like kernel, GPL license, community-driven
**BSD**: Complete Unix OS, permissive BSD license, smaller focused teams  
**macOS**: Unix-based (Darwin/FreeBSD), proprietary, Apple only

### Licensing

| Aspect | Linux (GPL) | BSD | macOS |
|--------|-------------|-----|-------|
| Open Source | Yes | Yes | Partial (Darwin) |
| Redistribution | Must share source | Can close source | Proprietary |
| Commercial Use | Must stay GPL | Can be proprietary | Apple only |

### Kernel

**Linux**: Monolithic with modules
**BSD**: Monolithic
**macOS**: Hybrid (XNU = Mach + BSD)

```bash
# Linux - modules
lsmod
sudo modprobe module_name

# BSD - kernel modules
kldstat
kldload module_name

# macOS - kernel extensions
kextstat
sudo kextload path
```

### Package Management

```bash
# Linux (Debian/Ubuntu)
sudo apt update
sudo apt install package

# Linux (RHEL/Fedora)
sudo dnf install package

# BSD (FreeBSD)
sudo pkg install package
cd /usr/ports/category/package && make install clean

# macOS
brew install package
mas install app-id
```

### Init Systems

```bash
# Linux - systemd
systemctl start service
systemctl status service

# BSD - rc
service service start
sysrc service_enable="YES"

# macOS - launchd
launchctl load /path/to/plist
launchctl start service
```

### Networking

```bash
# Linux
ip addr show
ip route show
sudo iptables -L
sudo ufw status

# BSD
ifconfig em0
netstat -r
pfctl -s rules    # Packet filter

# macOS
ifconfig en0
networksetup -listallnetworkservices
sudo pfctl -s rules
```

### Filesystems

**Linux**: ext4, XFS, Btrfs, ZFS (via OpenZFS)
**BSD**: UFS, ZFS
**macOS**: APFS, HFS+

```bash
# Linux
sudo mkfs.ext4 /dev/sda1

# BSD
sudo newfs /dev/ada0p1    # UFS
sudo zpool create pool /dev/ada1

# macOS
diskutil list
diskutil eraseVolume APFS "Name" /dev/disk2s1
```

### User Management

```bash
# Linux
sudo useradd -m username
sudo usermod -aG sudo username

# BSD
sudo adduser
sudo pw usermod username -G wheel

# macOS
sudo dscl . -create /Users/username
sudo dseditgroup -o edit -a username -t user admin
```

### Shells

**Linux**: bash (common), zsh, sh
**BSD**: tcsh (default root), sh, bash (install)
**macOS**: zsh (default since Catalina), bash (legacy)

### Key Differences Table

| Feature | Linux | BSD | macOS |
|---------|-------|-----|-------|
| Kernel | Monolithic | Monolithic | Hybrid (XNU) |
| License | GPL | BSD | Proprietary |
| Init | systemd/SysV | rc | launchd |
| Shell | bash | tcsh | zsh |
| Firewall | iptables/ufw | pf/ipfw | pf |
| Filesystem | ext4/XFS | UFS/ZFS | APFS |
| Package Mgr | apt/dnf | pkg/ports | brew |
| Hardware | Wide support | Server-focused | Apple only |

### Command Differences

```bash
# View disk usage
# Linux
df -h
du -sh /path/

# BSD & macOS - same
df -h
du -sh /path/

# Network connections
# Linux
ss -tulpn
netstat -tulpn

# BSD
sockstat -4 -6

# macOS
netstat -an
lsof -i

# System info
# Linux
lscpu
lspci

# BSD
dmesg | grep CPU
pciconf -lv

# macOS
sysctl -a | grep cpu
system_profiler SPHardwareDataType
```

### Use Cases

**Use Linux for:**
- Wide hardware support
- Choice of distributions
- Servers (most popular)
- Latest software/drivers
- Cost-effective (free)

**Use BSD for:**
- Clean, consistent system
- Network appliances (pfSense)
- ZFS filesystem
- Permissive licensing
- Stability

**Use macOS for:**
- Apple hardware integration
- Polished desktop experience
- iOS/macOS development
- Creative software (Final Cut, Logic)

### Cross-Platform Tips

```bash
# Check platform
case "$(uname -s)" in
    Linux*)     echo "Linux";;
    FreeBSD*)   echo "FreeBSD";;
    Darwin*)    echo "macOS";;
esac

# Use POSIX-compliant commands
sh instead of bash
awk, sed (portable subset)
grep (basic options)

# Install compatible tools
# macOS: brew install coreutils  # Get GNU tools
# BSD: pkg install coreutils
```

### Quick Reference

| Task | Linux | BSD | macOS |
|------|-------|-----|-------|
| Install | apt/dnf | pkg | brew |
| Service | systemctl | service | launchctl |
| Firewall | ufw/iptables | pf | pf |
| Users | useradd | adduser | dscl |
| Network | ip | ifconfig | ifconfig/networksetup |
| Kernel | uname -r | uname -r | uname -r |
