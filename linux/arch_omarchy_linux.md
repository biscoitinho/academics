# Arch Linux and Omarchy - Overview and Comparison

Comprehensive guide to Arch Linux, Omarchy distribution, and how they compare to other Linux distributions.

---

## Table of Contents

1. [Arch Linux Overview](#arch-linux-overview)
2. [Omarchy Linux Overview](#omarchy-linux-overview)
3. [Comparison with Other Distributions](#comparison-with-other-distributions)
4. [Package Management](#package-management)
5. [Installation Process](#installation-process)
6. [System Configuration](#system-configuration)
7. [Use Cases](#use-cases)

---

## Arch Linux Overview

### What is Arch Linux?

**Philosophy**:
- KISS (Keep It Simple, Stupid)
- User-centric, not user-friendly
- Pragmatic minimalism
- Rolling release model
- Transparency and control

**Key Characteristics**:
```
Release Model: Rolling release (no versions)
Package Manager: pacman
Init System: systemd
Default Shell: bash
Repository: Binary packages
Build System: PKGBUILD (makepkg)
Documentation: ArchWiki (best Linux wiki)
```

### Arch Principles

**1. Simplicity**:
- No unnecessary additions or modifications
- Clean, vanilla upstream software
- Minimal default install

**2. Modernity**:
- Latest stable packages
- Cutting-edge software
- Rapid updates

**3. Pragmatism**:
- User makes decisions
- No hand-holding
- Freedom to break system

**4. User-Centrality**:
- Designed for competent users
- Complete control
- Manual configuration

**5. Versatility**:
- General-purpose distribution
- Can be anything you make it
- No predefined use case

### Package Repositories

```
[core]
  - Essential packages
  - System base
  - Boot process

[extra]
  - Additional software
  - Desktop environments
  - Applications

[community]
  - User-contributed packages
  - Maintained by TUs (Trusted Users)

[multilib]
  - 32-bit libraries on 64-bit systems
  - Wine, Steam compatibility

AUR (Arch User Repository)
  - User-submitted PKGBUILDs
  - Not officially supported
  - 85,000+ packages
  - Build from source
```

### Pacman Package Manager

**Basic Commands**:
```bash
# Update system
sudo pacman -Syu

# Install package
sudo pacman -S package_name

# Remove package
sudo pacman -R package_name

# Remove with dependencies
sudo pacman -Rs package_name

# Search packages
pacman -Ss search_term

# Query installed packages
pacman -Q

# Get package info
pacman -Si package_name

# Clean cache
sudo pacman -Sc

# Show package dependencies
pactree package_name
```

**Configuration** (`/etc/pacman.conf`):
```ini
[options]
HoldPkg = pacman glibc
Architecture = auto
Color
CheckSpace
VerbosePkgLists
ParallelDownloads = 5

[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[community]
Include = /etc/pacman.d/mirrorlist
```

### AUR (Arch User Repository)

**AUR Helpers** (not official):

```bash
# yay (most popular)
yay -S package_name
yay -Syu              # Update system + AUR

# paru (Rust-based, yay alternative)
paru -S package_name
paru -Syu

# Manual AUR installation
git clone https://aur.archlinux.org/package.git
cd package
makepkg -si
```

**PKGBUILD Example**:
```bash
# Maintainer: Your Name <email>
pkgname=myapp
pkgver=1.0.0
pkgrel=1
pkgdesc="My application"
arch=('x86_64')
url="https://example.com/myapp"
license=('MIT')
depends=('python' 'python-requests')
makedepends=('git')
source=("$pkgname-$pkgver.tar.gz::$url/archive/$pkgver.tar.gz")
sha256sums=('SKIP')

build() {
    cd "$srcdir/$pkgname-$pkgver"
    python setup.py build
}

package() {
    cd "$srcdir/$pkgname-$pkgver"
    python setup.py install --root="$pkgdir" --optimize=1
}
```

### System Management

**systemd**:
```bash
# Service management
sudo systemctl start service_name
sudo systemctl stop service_name
sudo systemctl restart service_name
sudo systemctl enable service_name
sudo systemctl disable service_name
sudo systemctl status service_name

# System state
systemctl list-units
systemctl list-unit-files
systemd-analyze blame    # Boot time analysis

# Logs
journalctl -xe           # Recent errors
journalctl -u service    # Service logs
journalctl --since today # Today's logs
journalctl -f            # Follow logs
```

---

## Omarchy Linux Overview

### What is Omarchy?

**Definition**: Opinionated, pre-configured Arch Linux distribution with Hyprland window manager, created by David Heinemeier Hansson (DHH, creator of Ruby on Rails).

**"Omakase"** (おまかせ): Japanese for "I'll leave it up to you" - a curated, chef's choice experience.

**Philosophy**:
- Arch Linux base with sane defaults
- Developer-focused workflow
- Aesthetically pleasing out-of-box
- Security-first approach
- No DIY configuration burden

**Version**: Latest is Omarchy 3.3.0 (January 2026)

### Key Features

**1. Pre-configured Hyprland**:
```
Window Manager: Hyprland (Wayland compositor)
  - Tiling window manager
  - Dynamic workspaces
  - Animations and eye candy
  - Touch gesture support
  - Multi-monitor support

Configuration:
  - Pre-themed with beautiful aesthetics
  - Keybindings configured
  - Status bar (waybar) setup
  - Application launcher ready
```

**2. Mandatory Security**:
```
Full Disk Encryption:
  - LUKS (Linux Unified Key Setup)
  - Mandatory, not optional
  - Protects against physical theft
  - Encrypted swap

Firewall (enabled by default):
  - All incoming traffic blocked except:
    - Port 22: SSH
    - Port 53317: LocalSend
  - Outgoing traffic allowed
  - Easy management interface
```

**3. Developer Tools Pre-installed**:
```
Editor: Neovim (pre-configured)
Terminal: Ghostty (modern GPU-accelerated)
Browser: Chromium
Communication: Slack, Discord
Writing: Typora (Markdown editor), LibreOffice
Media: Spotify
Development: Git, Docker, various language runtimes
```

**4. Streamlined Installation**:
- Guided installer (unlike Arch)
- Interactive TUI (Text User Interface)
- Automated partitioning option
- Network configuration wizard
- User creation helper

### Differences from Stock Arch

| Feature | Arch Linux | Omarchy |
|---------|-----------|---------|
| **Installation** | Manual, complex | Guided installer |
| **Desktop** | None (choose your own) | Hyprland (Wayland) |
| **Configuration** | DIY everything | Pre-configured |
| **Security** | Optional | Mandatory (LUKS, firewall) |
| **Default Software** | Minimal | Developer toolkit |
| **Theme** | None | Curated aesthetic |
| **Target Audience** | DIY enthusiasts | Productive developers |
| **Learning Curve** | Steep | Moderate |
| **Setup Time** | Hours/days | Minutes |
| **Customization** | Unlimited | Still flexible |

### Omarchy Package Management

**Custom Repository**:
```
Omarchy maintains its own package repository:
  - Omarchy-specific configurations
  - Pre-configured applications
  - Custom themes and tools
  - Security patches

Access to Arch Repos:
  - [core], [extra], [community]
  - Full Arch package ecosystem
  - AUR compatibility maintained
```

**Package Manager**:
```bash
# Same pacman interface
sudo pacman -Syu

# AUR helpers work (yay, paru)
yay -S package_name

# Omarchy-specific packages
pacman -Ss omarchy
```

### Omarchy Installation Process

**Step-by-Step**:

1. **Download ISO**
   ```bash
   wget https://omarchy.org/download/omarchy-latest.iso
   ```

2. **Create Bootable USB**
   ```bash
   sudo dd if=omarchy-latest.iso of=/dev/sdX bs=4M status=progress
   ```

3. **Boot and Run Installer**
   ```
   Omarchy Installer (TUI)
   ├── Language Selection
   ├── Keyboard Layout
   ├── Network Configuration (WiFi/Ethernet)
   ├── Disk Partitioning
   │   ├── Auto (recommended): LUKS encryption
   │   └── Manual: Custom layout
   ├── User Creation
   │   ├── Username
   │   ├── Password
   │   └── Hostname
   ├── Timezone Selection
   └── Installation Confirmation
   ```

4. **Post-Install**
   ```
   System boots to:
   - LUKS password prompt
   - Hyprland login
   - Pre-configured desktop
   - Ready to use
   ```

---

## Comparison with Other Distributions

### Arch vs Ubuntu

| Feature | Arch | Ubuntu |
|---------|------|--------|
| **Release Model** | Rolling | Point release (6 months) |
| **Stability** | Cutting-edge | Stable, tested |
| **Package Management** | pacman | apt |
| **Default Desktop** | None | GNOME |
| **Target User** | Advanced | Beginner-friendly |
| **Documentation** | Excellent (ArchWiki) | Good (Ubuntu docs) |
| **Corporate Support** | Community | Canonical |
| **PPAs** | AUR | PPAs |
| **Philosophy** | Minimalist | User-friendly |
| **Updates** | Continuous | Scheduled |

**When to use Arch**:
- Want latest software
- Enjoy customization
- Learn Linux internals
- Need specific configurations

**When to use Ubuntu**:
- Want stability
- Need enterprise support
- Prefer GUI tools
- New to Linux

### Arch vs Fedora

| Feature | Arch | Fedora |
|---------|------|--------|
| **Release Model** | Rolling | Point (6 months) |
| **Bleeding Edge** | Yes | Moderate |
| **Corporate Backing** | None | Red Hat |
| **Default Desktop** | None | GNOME (Workstation) |
| **Package Manager** | pacman | dnf |
| **SELinux** | Optional | Enabled |
| **Target** | Enthusiasts | Developers, Red Hat users |
| **Systemd Integration** | Standard | Deep (systemd origin) |

**Fedora Advantages**:
- Testing ground for RHEL
- Strong security defaults (SELinux)
- Corporate backing
- Balanced between cutting-edge and stable

**Arch Advantages**:
- True rolling release
- More minimal base
- Better documentation (ArchWiki)
- Larger AUR ecosystem

### Arch vs Debian

| Feature | Arch | Debian |
|---------|------|--------|
| **Stability** | Latest | Rock-solid |
| **Release Cycle** | Rolling | 2 years |
| **Package Freshness** | Very fresh | Conservative |
| **Init System** | systemd | systemd (default) |
| **Package Count** | ~13,000 + AUR | ~59,000 |
| **Philosophy** | Simplicity | Universal OS |
| **Testing** | Minimal | Extensive |
| **Target** | Enthusiasts | Servers, stability |

**Use Debian for**:
- Servers (rock-solid stability)
- Mission-critical systems
- Long-term support needs
- "Set and forget" mentality

**Use Arch for**:
- Desktop/laptop (latest features)
- Development workstation
- Learning experience
- Customization freedom

### Arch vs Gentoo

| Feature | Arch | Gentoo |
|---------|------|---------|
| **Packages** | Binary | Source (compiled) |
| **Installation Speed** | Fast | Very slow |
| **Customization** | High | Extreme |
| **USE Flags** | No | Yes (fine-grained control) |
| **Compile Optimization** | Generic | CPU-specific |
| **Complexity** | High | Very high |
| **Update Time** | Minutes | Hours |

**Gentoo Advantage**: Ultimate customization, compile-time optimization
**Arch Advantage**: Faster installation/updates, still highly customizable

### Arch-based Distributions

**Popular Arch Derivatives**:

1. **Manjaro**
   - Beginner-friendly Arch
   - GUI installer
   - Delayed packages (stability)
   - Pre-configured desktop environments

2. **EndeavourOS**
   - Near-vanilla Arch
   - Friendly installer
   - Community-focused
   - Minimal bloat

3. **Garuda Linux**
   - Gaming-focused
   - Performance tweaks
   - Beautiful themes
   - Btrfs + snapshots

4. **Omarchy**
   - Developer-focused
   - Hyprland + Wayland
   - Security-first
   - Curated experience

5. **ArcoLinux**
   - Educational
   - Multiple desktop editions
   - Learning platform

---

## Package Management

### Pacman Deep Dive

**Database Location**:
```
/var/lib/pacman/local/    # Installed packages
/var/lib/pacman/sync/     # Repository databases
/var/cache/pacman/pkg/    # Downloaded packages (cache)
```

**Advanced Usage**:
```bash
# Install from local file
sudo pacman -U /path/to/package.pkg.tar.zst

# Download without installing
sudo pacman -Sw package_name

# Reinstall package
sudo pacman -S --needed package_name

# List files in package
pacman -Ql package_name

# Find which package owns a file
pacman -Qo /path/to/file

# List orphaned packages
pacman -Qdt

# Remove orphans
sudo pacman -Rns $(pacman -Qdtq)

# Check for package updates
checkupdates

# Downgrade package (cache)
cd /var/cache/pacman/pkg
sudo pacman -U package-old-version.pkg.tar.zst
```

**Hooks** (`/etc/pacman.d/hooks/`):
```ini
# Example: Clear systemd journal after upgrade
[Trigger]
Operation = Upgrade
Type = Package
Target = systemd

[Action]
Description = Clearing old journal entries...
When = PostTransaction
Exec = /usr/bin/journalctl --vacuum-time=7d
```

### AUR Best Practices

**Security Considerations**:
```bash
# Always review PKGBUILD
cat PKGBUILD

# Check for malicious commands
grep -i "curl" PKGBUILD
grep -i "wget" PKGBUILD
grep -i "sudo" PKGBUILD

# Verify checksums
makepkg -g  # Generate checksums

# Check comments on AUR page
# Look for:
#   - Number of votes
#   - Maintainer activity
#   - Recent comments
#   - Orphaned status
```

**Common Issues**:
```bash
# PGP key errors
gpg --recv-keys <KEY_ID>

# Dependency conflicts
yay -Sy --needed package

# Build failures
# Check .SRCINFO and dependencies
makepkg --nobuild  # Download only
```

---

## Installation Process

### Traditional Arch Installation

**Step-by-Step** (condensed):

1. **Boot Live Environment**
   ```bash
   # Verify boot mode (UEFI)
   ls /sys/firmware/efi/efivars
   ```

2. **Connect to Internet**
   ```bash
   # WiFi
   iwctl
   station wlan0 connect "SSID"

   # Test connection
   ping archlinux.org
   ```

3. **Update System Clock**
   ```bash
   timedatectl set-ntp true
   ```

4. **Partition Disks**
   ```bash
   # List disks
   lsblk

   # Partition (example for UEFI)
   cfdisk /dev/sda
   # /dev/sda1: 512M (EFI System)
   # /dev/sda2: Rest (Linux filesystem)

   # Format
   mkfs.fat -F32 /dev/sda1
   mkfs.ext4 /dev/sda2

   # Mount
   mount /dev/sda2 /mnt
   mkdir /mnt/boot
   mount /dev/sda1 /mnt/boot
   ```

5. **Install Base System**
   ```bash
   pacstrap /mnt base linux linux-firmware

   # Generate fstab
   genfstab -U /mnt >> /mnt/etc/fstab
   ```

6. **Chroot and Configure**
   ```bash
   arch-chroot /mnt

   # Set timezone
   ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
   hwclock --systohc

   # Localization
   echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
   locale-gen
   echo "LANG=en_US.UTF-8" > /etc/locale.conf

   # Network
   echo "myhostname" > /etc/hostname

   # Root password
   passwd

   # Bootloader (GRUB)
   pacman -S grub efibootmgr
   grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
   grub-mkconfig -o /boot/grub/grub.cfg
   ```

7. **Reboot**
   ```bash
   exit
   umount -R /mnt
   reboot
   ```

**Time Required**: 1-3 hours (experienced), 4-8 hours (beginner)

### Omarchy Installation

**Simplified Process**:

1. **Boot Omarchy Installer**
2. **Follow TUI Prompts**
   - Language, keyboard, network
   - Automatic LUKS encryption
   - User creation
3. **Wait for Installation** (~10-15 minutes)
4. **Reboot into Configured System**

**Time Required**: 20-30 minutes total

---

## System Configuration

### Arch Post-Install Tasks

**Essential Steps**:

1. **Create User**
   ```bash
   useradd -m -G wheel -s /bin/bash username
   passwd username

   # Enable sudo
   EDITOR=nano visudo
   # Uncomment: %wheel ALL=(ALL) ALL
   ```

2. **Install Network Manager**
   ```bash
   pacman -S networkmanager
   systemctl enable NetworkManager
   systemctl start NetworkManager
   ```

3. **Install Desktop Environment**
   ```bash
   # GNOME
   pacman -S gnome gnome-extra
   systemctl enable gdm

   # KDE Plasma
   pacman -S plasma-meta kde-applications
   systemctl enable sddm

   # Hyprland (like Omarchy)
   pacman -S hyprland kitty waybar wofi
   ```

4. **Install Essential Software**
   ```bash
   # Audio
   pacman -S pipewire pipewire-alsa pipewire-pulse

   # Fonts
   pacman -S ttf-dejavu ttf-liberation noto-fonts

   # Browser
   pacman -S firefox

   # AUR helper
   git clone https://aur.archlinux.org/yay.git
   cd yay && makepkg -si
   ```

### Omarchy Configuration

**Already Configured**:
- Hyprland window manager
- Audio (Pipewire)
- Fonts and themes
- Developer tools
- Security (firewall, encryption)

**Customization**:
```bash
# Hyprland config
~/.config/hypr/hyprland.conf

# Waybar (status bar)
~/.config/waybar/config

# Terminal (Ghostty)
~/.config/ghostty/config

# Neovim
~/.config/nvim/
```

---

## Use Cases

### When to Use Arch Linux

**Ideal For**:
- Learning Linux internals
- Full customization control
- Latest software packages
- Minimalist philosophy
- DIY approach to computing
- Development workstation
- Gaming (latest drivers)

**Not Ideal For**:
- Mission-critical servers (use Debian/RHEL)
- Beginners (steep learning curve)
- "Set and forget" systems
- Enterprise environments
- Users who want GUI tools

### When to Use Omarchy

**Ideal For**:
- Software developers
- Users who want Arch benefits without setup burden
- Security-conscious users
- Wayland/Hyprland enthusiasts
- Those who value aesthetics
- Productivity-focused workflow
- Former macOS users switching to Linux

**Not Ideal For**:
- Users who want GNOME/KDE
- Those who prefer X11
- Users wanting complete customization freedom
- Traditional desktop paradigm users

### Arch Maintenance

**Daily/Weekly Tasks**:
```bash
# Update system (do regularly!)
sudo pacman -Syu

# Check for news
https://archlinux.org/news/

# Clear package cache (monthly)
sudo pacman -Sc

# Remove orphans (as needed)
sudo pacman -Rns $(pacman -Qdtq)
```

**Breaking Changes**:
- Read news before updating
- Manual intervention sometimes required
- Configuration files may need merging
- Accept that things might break

**Backup Strategy**:
```bash
# Timeshift (Btrfs snapshots)
yay -S timeshift

# rsync backup
rsync -aAXv --exclude={"/dev/*","/proc/*"} / /mnt/backup/

# Package list backup
pacman -Qqe > pkglist.txt
# Restore: pacman -S - < pkglist.txt
```

---

## Key Takeaways

**Arch Linux**:
- Ultimate flexibility and control
- Rolling release (always up-to-date)
- Excellent documentation (ArchWiki)
- Large package ecosystem (pacman + AUR)
- Steep learning curve
- Not for everyone

**Omarchy**:
- Arch benefits with sane defaults
- Developer-optimized workflow
- Security-first approach
- Beautiful out-of-box experience
- Saves setup time
- Still maintains Arch flexibility

**Choose Arch if**:
- You enjoy tinkering
- Want to learn Linux deeply
- Need complete control
- Have time for maintenance

**Choose Omarchy if**:
- You want productivity
- Value security defaults
- Like Arch but not the setup
- Prefer Hyprland/Wayland
- Developer workflow focused

**Avoid Both if**:
- You need guaranteed stability
- Want enterprise support
- Prefer point releases
- Need GUI-based management

---

## Sources

- [Omarchy: The brand new Arch Linux experience](https://rashm1n.medium.com/omarchy-the-brand-new-arch-linux-experience-what-and-why-40c602f6745e)
- [The Omarchy Manual](https://learn.omacom.io/2/the-omarchy-manual)
- [Omarchy: DHH Made an Arch Linux Distro](https://fivenines.io/blog/omarchy-what-it-is-how-it-works/)
- [It's time to try OMARCHY!](https://dev.to/pkorsch/its-time-to-try-omarchy-2k9j)
- [Omarchy Linux Review: Opinionated Arch + Hyprland](https://www.thinklet.blog/omarchy-linux-review-arch-hyprland)
- [DistroWatch.com: Omarchy](https://distrowatch.com/omarchy)
- [My Journey from macOS to Arch Linux with Omarchy](https://www.ssp.sh/blog/macbook-to-arch-linux-omarchy/)
- [Omarchy is out](https://world.hey.com/dhh/omarchy-is-out-4666dd31)
- [Omarchy: A New Arch Linux Distro from 37signals](https://blog.openreplay.com/omarchy-new-arch-linux-distro-37signals/)
