## Linux vs BSD vs macOS - Key Differences

### Operating System Overview

#### Linux
- **Type**: Unix-like operating system kernel
- **License**: GNU GPL (open source)
- **Development**: Community-driven, distributed development
- **Distributions**: Ubuntu, Debian, Fedora, RHEL, Arch, etc.
- **Usage**: Servers, embedded systems, desktops, mobile (Android)

#### BSD (Berkeley Software Distribution)
- **Type**: Unix operating system (complete OS, not just kernel)
- **License**: BSD License (very permissive)
- **Variants**: FreeBSD, OpenBSD, NetBSD, DragonFly BSD
- **Development**: Smaller, focused teams
- **Usage**: Servers, embedded systems, network appliances

#### macOS
- **Type**: Unix-based operating system (certified Unix)
- **License**: Proprietary (with some open source components)
- **Base**: Darwin (based on FreeBSD and Mach kernel)
- **Development**: Apple
- **Usage**: Apple desktops and laptops exclusively

### Licensing Comparison

| Aspect | Linux (GPL) | BSD | macOS |
|--------|-------------|-----|-------|
| Open Source | Yes | Yes | Partially (Darwin) |
| Redistribution | Must share source | Can close source | Proprietary |
| Commercial Use | Must stay GPL | Can be proprietary | Apple only |
| Patent Protection | GPLv3 has some | No explicit | N/A |
| Copyleft | Yes | No | N/A |

**Key Difference**: GPL (Linux) requires derivatives to remain open source; BSD allows closed-source derivatives; macOS is mostly proprietary.

### Kernel Architecture

#### Linux
```bash
# Monolithic kernel with loadable modules
# View loaded modules
lsmod

# Load module
sudo modprobe module_name

# Kernel version
uname -r

# Kernel sources
/usr/src/linux/
```

#### BSD
```bash
# Monolithic kernel
# FreeBSD kernel modules
kldstat                    # List loaded modules
kldload module_name        # Load module
kldunload module_name      # Unload module

# Kernel version
uname -r

# Kernel config
/boot/kernel/
```

#### macOS
```bash
# Hybrid kernel (XNU = Mach + BSD)
# Kernel extensions (kexts)
kextstat                   # List loaded extensions
sudo kextload path         # Load extension
sudo kextunload path       # Unload extension

# Kernel version
uname -r

# System info
sw_vers
```

### Package Management

#### Linux (Debian/Ubuntu)
```bash
# APT package manager
sudo apt update
sudo apt install package
sudo apt remove package
sudo apt search package

# List installed
apt list --installed
dpkg -l
```

#### Linux (RHEL/Fedora)
```bash
# DNF/YUM package manager
sudo dnf install package
sudo dnf remove package
sudo dnf search package

# List installed
dnf list installed
rpm -qa
```

#### BSD (FreeBSD)
```bash
# PKG package manager
sudo pkg update
sudo pkg install package
sudo pkg delete package
sudo pkg search package

# List installed
pkg info

# Ports (compile from source)
cd /usr/ports/category/package
make install clean
```

#### macOS
```bash
# Homebrew (third-party)
brew install package
brew uninstall package
brew search package
brew list

# Mac App Store CLI
mas search app
mas install app-id

# MacPorts (alternative)
sudo port install package
```

### Filesystem Hierarchy

#### Linux (FHS - Filesystem Hierarchy Standard)
```
/bin        System binaries
/boot       Boot files
/dev        Device files
/etc        Configuration files
/home       User directories
/lib        Libraries
/opt        Optional software
/proc       Process info (virtual)
/root       Root user home
/sbin       System admin binaries
/tmp        Temporary files
/usr        User programs
/var        Variable data
```

#### BSD (Similar to Linux with differences)
```
/bin        System binaries
/boot       Boot files
/dev        Device files
/etc        Configuration files
/home       User directories (sometimes /usr/home)
/lib        Libraries
/libexec    System daemons
/proc       Optional process filesystem
/root       Root user home
/sbin       System admin binaries
/tmp        Temporary files
/usr        User programs
/var        Variable data
```

#### macOS (Unix base with Apple additions)
```
/Applications    macOS applications
/bin             System binaries
/cores           Core dumps
/dev             Device files
/etc             Configuration files (symlink to /private/etc)
/Library         System-wide resources
/Network         Network resources
/System          macOS system files
/tmp             Temporary files (symlink to /private/tmp)
/Users           User directories
/usr             Unix programs
/var             Variable data (symlink to /private/var)
/Volumes         Mounted filesystems
```

### Init Systems

#### Linux (Modern)
```bash
# systemd (most distributions)
systemctl start service
systemctl stop service
systemctl status service
systemctl enable service
systemctl disable service

# List services
systemctl list-units --type=service

# Logs
journalctl -u service
```

#### Linux (Legacy)
```bash
# SysV init (older systems)
service service-name start
service service-name stop
/etc/init.d/service start

# Runlevels
runlevel
init 3
```

#### BSD (FreeBSD)
```bash
# rc system
service service start
service service stop
service service status
service -e              # List enabled services

# Enable service
sysrc service_enable="YES"

# Configuration
/etc/rc.conf

# Start service at boot
# Add to /etc/rc.conf:
# service_enable="YES"
```

#### macOS
```bash
# launchd
# Start service
launchctl load /path/to/plist
launchctl start service

# Stop service
launchctl stop service
launchctl unload /path/to/plist

# List services
launchctl list

# User services location
~/Library/LaunchAgents/

# System services location
/Library/LaunchDaemons/
/System/Library/LaunchDaemons/
```

### Networking

#### Linux
```bash
# Modern (ip command)
ip addr show
ip link set eth0 up
ip route show
ip route add default via 192.168.1.1

# Legacy (ifconfig)
ifconfig eth0
route -n

# DNS
/etc/resolv.conf
systemd-resolved

# Firewall
iptables -L
ufw status
firewalld
```

#### BSD (FreeBSD)
```bash
# Network interface
ifconfig em0
ifconfig em0 inet 192.168.1.100 netmask 255.255.255.0

# Routing
netstat -r
route add default 192.168.1.1

# DNS
/etc/resolv.conf

# Firewall (pf - Packet Filter)
pfctl -f /etc/pf.conf
pfctl -s rules
pfctl -e                # Enable
pfctl -d                # Disable

# Alternative: ipfw
ipfw list
ipfw add allow all from any to any
```

#### macOS
```bash
# Network interface
ifconfig en0
networksetup -listallnetworkservices
networksetup -getinfo "Wi-Fi"

# DNS
networksetup -getdnsservers Wi-Fi
networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4

# Routing
netstat -r
route -n get default

# Firewall (pf - same as BSD)
sudo pfctl -f /etc/pf.conf
sudo pfctl -s rules
sudo pfctl -e

# Application firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --list
```

### Filesystem Types

#### Linux
```bash
# Native filesystems
ext4          # Default for most distros
XFS           # High performance
Btrfs         # Advanced features (snapshots, etc.)
F2FS          # Flash-optimized

# Others
NTFS          # Windows (via ntfs-3g)
FAT32/exFAT   # Cross-platform
ZFS           # Via OpenZFS

# Mount
sudo mount /dev/sda1 /mnt
sudo mount -t ext4 /dev/sda1 /mnt
```

#### BSD (FreeBSD)
```bash
# Native filesystems
UFS           # Unix File System (default)
UFS2          # Enhanced UFS
ZFS           # Advanced features (default for some)

# Others
NTFS          # Limited support
FAT32         # Support included

# Mount
mount /dev/ada0p1 /mnt
mount -t ufs /dev/ada0p1 /mnt
```

#### macOS
```bash
# Native filesystems
APFS          # Apple File System (default since High Sierra)
HFS+          # Mac OS Extended (legacy)

# Others
NTFS          # Read-only by default
FAT32/exFAT   # Full support
ZFS           # Via third-party (OpenZFS)

# Mount
diskutil mount /dev/disk2s1
diskutil list
hdiutil attach image.dmg
```

### User Management

#### Linux
```bash
# Add user
sudo useradd -m username
sudo adduser username       # Interactive (Debian/Ubuntu)

# Delete user
sudo userdel username
sudo userdel -r username    # With home directory

# Modify user
sudo usermod -aG sudo username
sudo usermod -s /bin/bash username

# Password
sudo passwd username

# Groups
groups username
sudo groupadd groupname
```

#### BSD (FreeBSD)
```bash
# Add user
sudo adduser               # Interactive
sudo pw useradd username -m

# Delete user
sudo rmuser username
sudo pw userdel username

# Modify user
sudo pw usermod username -G wheel
sudo pw usermod username -s /bin/tcsh

# Password
sudo passwd username

# Groups
groups username
sudo pw groupadd groupname
```

#### macOS
```bash
# Add user (GUI preferred)
# Command line:
sudo dscl . -create /Users/username
sudo dscl . -create /Users/username UserShell /bin/bash
sudo dscl . -create /Users/username RealName "User Name"
sudo dscl . -create /Users/username UniqueID 1001
sudo dscl . -create /Users/username PrimaryGroupID 20
sudo dscl . -create /Users/username NFSHomeDirectory /Users/username

# Delete user
sudo dscl . -delete /Users/username

# Password
sudo dscl . -passwd /Users/username password

# Groups
dscl . -read /Groups/admin GroupMembership
sudo dseditgroup -o edit -a username -t user admin
```

### Process Management

#### Linux
```bash
# View processes
ps aux
top
htop

# Kill process
kill PID
killall process_name

# Priority
nice -n 10 command
renice 10 -p PID

# Background/foreground
command &
fg
bg
jobs
```

#### BSD (FreeBSD)
```bash
# View processes (similar to Linux)
ps aux
top

# Kill process
kill PID
killall process_name

# Priority
nice -n 10 command
renice 10 -p PID

# Process accounting
accton /var/account/acct
```

#### macOS
```bash
# View processes
ps aux
top
activity monitor       # GUI

# Kill process
kill PID
killall process_name

# App-specific
pkill -9 -x "App Name"

# Force quit app
osascript -e 'quit app "AppName"'

# GUI force quit
Option + Command + Esc
```

### Shells

#### Linux
```bash
# Default shells
bash          # Most common default
zsh           # Modern alternative
sh            # POSIX shell

# Change shell
chsh -s /bin/zsh

# Shell location
/bin/bash
/usr/bin/bash
```

#### BSD (FreeBSD)
```bash
# Default shells
tcsh          # Default root shell
sh            # Bourne shell
bash          # Install separately
zsh           # Install separately

# Change shell
chsh -s /bin/tcsh

# Shell location
/bin/sh
/bin/tcsh
/usr/local/bin/bash
```

#### macOS
```bash
# Default shells
zsh           # Default since Catalina
bash          # Legacy default (now v3.2 due to licensing)

# Change shell
chsh -s /bin/zsh

# Available shells
cat /etc/shells

# Shell location
/bin/bash
/bin/zsh
/usr/local/bin/bash  # Homebrew bash
```

### Default Software

#### Linux
- GNU Coreutils (ls, cat, grep, etc.)
- GNU Bash
- GNU C Library (glibc)
- X11 or Wayland (GUI)
- Various desktop environments (GNOME, KDE, etc.)

#### BSD (FreeBSD)
- BSD userland tools
- tcsh (default)
- BSD C Library
- X11 (optional)
- Window managers (no full DE by default)
- Ports collection for additional software

#### macOS
- BSD userland tools (modified)
- zsh (default)
- Apple's C library
- Aqua (GUI - proprietary)
- Cocoa framework
- Built-in applications (Safari, Mail, etc.)

### Performance and Optimization

#### Linux
```bash
# CPU governor
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# I/O scheduler
cat /sys/block/sda/queue/scheduler
echo deadline | sudo tee /sys/block/sda/queue/scheduler

# Swappiness
sysctl vm.swappiness
sudo sysctl vm.swappiness=10

# Huge pages
sysctl vm.nr_hugepages
```

#### BSD (FreeBSD)
```bash
# Tuning (sysctl)
sysctl kern.maxfiles
sysctl -w kern.maxfiles=65536

# Loader tuning
/boot/loader.conf

# Kernel tuning
/etc/sysctl.conf

# ZFS tuning
sysctl vfs.zfs.arc_max
```

#### macOS
```bash
# System preferences (GUI)
System Preferences → Energy Saver

# Memory pressure
memory_pressure

# Purge memory
sudo purge

# Disable indexing
sudo mdutil -a -i off

# No exact CPU governor control
# macOS manages automatically
```

### Differences Summary Table

| Feature | Linux | BSD | macOS |
|---------|-------|-----|-------|
| **Kernel** | Monolithic | Monolithic | Hybrid (XNU) |
| **License** | GPL | BSD | Proprietary |
| **Init** | systemd/SysV | rc | launchd |
| **Shell** | bash | tcsh | zsh |
| **Firewall** | iptables/ufw | pf/ipfw | pf |
| **Filesystem** | ext4/XFS/Btrfs | UFS/ZFS | APFS/HFS+ |
| **Package Manager** | apt/dnf/pacman | pkg/ports | brew/mas |
| **Desktop** | Various | Optional | Aqua (only) |
| **Hardware** | Wide support | Server-focused | Apple only |
| **Philosophy** | Freedom | Simplicity | Integration |

### Command Differences

Common task comparison:

#### View Disk Usage
```bash
# Linux
df -h
du -sh /path/

# BSD
df -h
du -h /path/

# macOS
df -h
du -sh /path/
diskutil list
```

#### Find Files
```bash
# Linux
find /path -name "file"
locate file

# BSD
find /path -name "file"
locate file

# macOS
find /path -name "file"
mdfind "file"          # Spotlight search
```

#### Network Connections
```bash
# Linux
ss -tulpn
netstat -tulpn
lsof -i

# BSD
sockstat -4 -6
netstat -an

# macOS
netstat -an
lsof -i
```

#### System Information
```bash
# Linux
lscpu
lspci
lsusb
uname -a

# BSD
dmesg | grep CPU
pciconf -lv
usbconfig
uname -a

# macOS
sysctl -a | grep cpu
system_profiler SPHardwareDataType
uname -a
```

### Use Case Recommendations

**Use Linux when:**
- Need wide hardware support
- Want choice of distributions/desktop environments
- Running on servers (most popular)
- Embedded systems
- Need latest software and drivers
- Cost-conscious (always free)

**Use BSD when:**
- Want clean, consistent system
- Network appliances (pfSense, OPNsense)
- Need ZFS filesystem features
- Prefer permissive licensing
- Value simplicity and documentation
- Building custom solutions

**Use macOS when:**
- Need Apple hardware integration
- Want polished desktop experience
- Developing iOS/macOS applications
- Need commercial software support
- Value GUI consistency
- Running creative software (Final Cut, Logic, etc.)

### Compatibility Notes

#### Linux → BSD
- Most POSIX scripts work
- GNU-specific options may not work
- Different package names
- `/proc` may not exist by default
- Filesystem paths differ slightly

#### Linux → macOS
- Most POSIX scripts work
- GNU tools may differ (use Homebrew for GNU versions)
- Case-insensitive filesystem by default (can change)
- Different user management
- launchd instead of systemd

#### BSD → macOS
- Very similar userland (macOS based on FreeBSD)
- Most commands work the same
- Different package management
- Different kernel internals
- GUI frameworks completely different

### Cross-Platform Development

```bash
# Use POSIX-compliant commands
sh instead of bash
awk, sed (portable subset)
grep (basic options)

# Check platform
case "$(uname -s)" in
    Linux*)     echo "Linux";;
    FreeBSD*)   echo "FreeBSD";;
    Darwin*)    echo "macOS";;
esac

# Install compatible tools
# On macOS: brew install coreutils  # Get GNU tools as gls, ggrep, etc.
# On BSD: pkg install coreutils     # Get GNU tools
```
