# Arch Linux and Omarchy - Overview and Comparison

Guide to Arch Linux and Omarchy distribution with comparison to Ubuntu and Red Hat Enterprise Linux.

---

## Table of Contents

1. [Arch Linux Overview](#arch-linux-overview)
2. [Omarchy Linux Overview](#omarchy-linux-overview)
3. [Comparison with Ubuntu and RHEL](#comparison-with-ubuntu-and-rhel)
4. [Package Management](#package-management)
5. [Installation](#installation)
6. [Use Cases](#use-cases)

---

## Arch Linux Overview

### Philosophy

**KISS Principle** (Keep It Simple, Stupid):
- User-centric, not user-friendly
- Pragmatic minimalism
- Rolling release model
- Transparency and control
- Vanilla upstream software (no patching)

**Key Characteristics**:
```
Release Model: Rolling (no versions)
Package Manager: pacman
Init System: systemd
Repositories: Binary packages
Build System: PKGBUILD (makepkg)
Documentation: ArchWiki (legendary quality)
AUR: 85,000+ user packages
```

### Package Repositories

```
[core]      - Essential system packages
[extra]     - Additional official software
[community] - User-contributed (Trusted Users)
[multilib]  - 32-bit libraries on 64-bit

AUR (Arch User Repository)
  - User-submitted build scripts
  - Not officially supported
  - Review before installing
```

### Pacman Commands

```bash
# System update
sudo pacman -Syu

# Install/remove
sudo pacman -S package_name
sudo pacman -Rs package_name      # Remove with deps

# Search and query
pacman -Ss search_term            # Search repos
pacman -Q                         # List installed
pacman -Ql package                # List files
pacman -Qo /path/to/file          # Find owner

# Maintenance
sudo pacman -Sc                   # Clean cache
sudo pacman -Rns $(pacman -Qdtq)  # Remove orphans
```

### AUR Usage

**AUR Helpers** (yay/paru):
```bash
yay -S package_name               # Install from AUR
yay -Syu                          # Update everything

# Manual installation
git clone https://aur.archlinux.org/package.git
cd package
makepkg -si
```

**PKGBUILD Example**:
```bash
pkgname=myapp
pkgver=1.0.0
pkgrel=1
arch=('x86_64')
depends=('python')

build() {
    python setup.py build
}

package() {
    python setup.py install --root="$pkgdir"
}
```

**Security**: Always review PKGBUILD before installing:
```bash
cat PKGBUILD
grep -E "curl|wget|sudo" PKGBUILD
```

---

## Omarchy Linux Overview

### What is Omarchy?

**Created by**: David Heinemeier Hansson (DHH, Ruby on Rails creator)
**Philosophy**: "Omakase" (おまかせ) - curated, chef's choice Arch experience
**Version**: 3.3.0 (January 2026)

**Concept**:
- Arch base with opinionated defaults
- Developer-focused workflow
- Security-first (mandatory encryption)
- Pre-configured Hyprland (Wayland)
- Zero-configuration productivity

### Key Features

**1. Hyprland Wayland Compositor**:
```
- Tiling window manager (pre-configured)
- Beautiful animations
- Multi-monitor support
- Touch gestures
- Waybar status bar
- Wofi launcher
```

**2. Mandatory Security**:
```
LUKS Encryption:
  - Full disk encryption (required)
  - Encrypted swap
  - No opt-out

Firewall (default enabled):
  - Block all incoming except:
    - Port 22 (SSH)
    - Port 53317 (LocalSend)
```

**3. Developer Tooling**:
```
Pre-installed:
  - Neovim (configured)
  - Ghostty terminal
  - Git, Docker
  - Chromium
  - Language runtimes (Python, Node.js, Ruby, etc.)
```

### Arch vs Omarchy

| Feature | Arch | Omarchy |
|---------|------|---------|
| **Installation** | Manual (1-3 hours) | Guided TUI (20 mins) |
| **Desktop** | None | Hyprland (Wayland) |
| **Configuration** | DIY everything | Pre-configured |
| **Security** | Optional | Mandatory (LUKS + firewall) |
| **Software** | Base system only | Developer toolkit |
| **Learning Curve** | Steep | Moderate |
| **Customization** | Unlimited | High (but opinionated) |
| **Target** | Linux enthusiasts | Productive developers |

---

## Comparison with Ubuntu and RHEL

### Arch vs Ubuntu

| Feature | Arch | Ubuntu |
|---------|------|--------|
| **Release Model** | Rolling | Point (6 months) + LTS (2 years) |
| **Stability** | Bleeding edge | Stable, tested |
| **Updates** | Continuous | Scheduled releases |
| **Package Manager** | pacman | apt/snap |
| **Default Desktop** | None | GNOME |
| **Corporate Support** | None | Canonical |
| **Target User** | Advanced | Beginner-friendly |
| **Philosophy** | Minimal, user control | User-friendly, batteries included |
| **Documentation** | ArchWiki (excellent) | Ubuntu docs (good) |
| **Software Repos** | ~13k + 85k AUR | ~60k packages |

**Ubuntu Advantages**:
- Beginner-friendly GUI tools
- Long-term support (LTS = 5 years)
- Corporate backing (Canonical)
- Extensive hardware support out-of-box
- Larger user base for support

**Arch Advantages**:
- Latest software immediately
- Minimal bloat
- Complete control
- Superior documentation (ArchWiki)
- AUR ecosystem

**When to Choose**:
- **Arch**: Latest packages, learning Linux, full control, development workstation
- **Ubuntu**: Stability, enterprise use, beginners, GUI preference, LTS support

### Arch vs RHEL/Fedora

| Feature | Arch | RHEL/Fedora |
|---------|------|-------------|
| **Release Model** | Rolling | Point (RHEL: 3 years, Fedora: 6 months) |
| **Corporate Backing** | None | Red Hat (IBM) |
| **Package Manager** | pacman | dnf (rpm) |
| **Target** | Enthusiasts | Enterprise (RHEL), Developers (Fedora) |
| **SELinux** | Optional | Enabled (strong security) |
| **Support** | Community | Enterprise contracts (RHEL) |
| **Certifications** | None | Red Hat certifications |
| **Cost** | Free | RHEL: Paid, Fedora: Free |

**RHEL/Fedora Advantages**:
- Enterprise support contracts (RHEL)
- Strong default security (SELinux enforcing)
- Testing ground for RHEL (Fedora)
- Certification programs
- Stability and long lifecycle (RHEL)

**Arch Advantages**:
- True rolling release
- More minimal base
- Faster access to new software
- No corporate decisions
- Better for desktop/workstation

**When to Choose**:
- **Arch**: Desktop/laptop, development, latest software, learning
- **RHEL**: Servers, enterprise, mission-critical, support contracts
- **Fedora**: Development, testing RHEL features, balanced approach

### Package Management Comparison

```bash
# Update system
pacman -Syu                  # Arch
apt update && apt upgrade    # Ubuntu
dnf upgrade                  # RHEL/Fedora

# Install package
pacman -S firefox            # Arch
apt install firefox          # Ubuntu
dnf install firefox          # RHEL/Fedora

# Search
pacman -Ss firefox           # Arch
apt search firefox           # Ubuntu
dnf search firefox           # RHEL/Fedora

# Remove
pacman -Rs firefox           # Arch (with deps)
apt remove firefox           # Ubuntu
dnf remove firefox           # RHEL/Fedora
```

---

## Package Management

### Pacman Deep Dive

**Database Locations**:
```
/var/lib/pacman/local/       # Installed packages
/var/lib/pacman/sync/        # Repo databases
/var/cache/pacman/pkg/       # Package cache
```

**Advanced Commands**:
```bash
# Install from file
sudo pacman -U package.pkg.tar.zst

# List package files
pacman -Ql package_name

# Find file owner
pacman -Qo /usr/bin/vim

# Orphaned packages
pacman -Qdt
sudo pacman -Rns $(pacman -Qdtq)

# Downgrade (from cache)
cd /var/cache/pacman/pkg
sudo pacman -U package-old-version.pkg.tar.zst
```

**Pacman Hooks** (`/etc/pacman.d/hooks/`):
```ini
[Trigger]
Operation = Upgrade
Type = Package
Target = systemd

[Action]
Description = Clearing journal...
When = PostTransaction
Exec = /usr/bin/journalctl --vacuum-time=7d
```

### AUR Best Practices

**Security Checklist**:
```bash
# Review PKGBUILD
cat PKGBUILD

# Check for suspicious commands
grep -i "curl\|wget\|sudo\|rm -rf" PKGBUILD

# Verify checksums
makepkg -g

# Check AUR page for:
# - Vote count
# - Last updated
# - Maintainer activity
# - Comments (security issues)
```

**Common Issues**:
```bash
# PGP key errors
gpg --recv-keys KEY_ID

# Dependency conflicts
yay -Sy --needed package

# Build failures
makepkg --nobuild  # Download only, check deps
```

---

## Installation

### Traditional Arch Installation

**Condensed Steps**:

```bash
# 1. Boot live environment, verify UEFI
ls /sys/firmware/efi/efivars

# 2. Connect to internet
iwctl
station wlan0 connect "SSID"

# 3. Partition disk (UEFI example)
cfdisk /dev/sda
# /dev/sda1: 512M (EFI)
# /dev/sda2: Rest (Linux)

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

# 4. Install base system
pacstrap /mnt base linux linux-firmware
genfstab -U /mnt >> /mnt/etc/fstab

# 5. Chroot and configure
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Region/City /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

echo "myhostname" > /etc/hostname
passwd

# 6. Install bootloader
pacman -S grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# 7. Reboot
exit
umount -R /mnt
reboot
```

**Post-Install**:
```bash
# Create user
useradd -m -G wheel username
passwd username
EDITOR=nano visudo  # Uncomment %wheel ALL=(ALL) ALL

# Network
pacman -S networkmanager
systemctl enable NetworkManager

# Desktop (example: GNOME)
pacman -S gnome
systemctl enable gdm

# AUR helper
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
```

**Time**: 1-3 hours (experienced), 4-8 hours (beginner)

### Omarchy Installation

**Steps**:
1. Download ISO from omarchy.org
2. Create bootable USB: `dd if=omarchy.iso of=/dev/sdX bs=4M`
3. Boot and follow TUI installer:
   - Language/keyboard
   - Network setup
   - Auto LUKS encryption (mandatory)
   - User creation
   - Timezone
4. Reboot into configured system

**Time**: 20-30 minutes total

**Post-Install**:
```bash
# Already configured:
# - Hyprland + Waybar
# - Neovim, Ghostty
# - Audio (Pipewire)
# - Firewall
# - Developer tools

# Customization
~/.config/hypr/hyprland.conf
~/.config/waybar/config
~/.config/ghostty/config
```

---

## Use Cases

### Arch Linux

**Best For**:
- Learning Linux internals
- Latest software (cutting-edge development)
- Full customization freedom
- Development workstations
- Gaming (latest drivers)
- Minimalist setups

**Not For**:
- Mission-critical servers (use RHEL/Debian)
- Beginners (steep learning curve)
- "Set and forget" systems
- Enterprise with support contracts

**Maintenance**:
```bash
# Regular updates (weekly recommended)
sudo pacman -Syu

# Check Arch news before major updates
https://archlinux.org/news/

# Backup strategy
pacman -Qqe > pkglist.txt     # Save package list
```

### Omarchy

**Best For**:
- Software developers
- Security-conscious users
- Arch benefits without DIY burden
- Wayland/Hyprland enthusiasts
- macOS refugees
- Productivity-focused workflow

**Not For**:
- GNOME/KDE preference
- X11 requirement
- Complete customization freedom
- Traditional desktop users

### Ubuntu LTS

**Best For**:
- Beginners to Linux
- Stability over latest features
- Enterprise deployments
- Long-term support (5 years)
- GUI-focused users
- Wide hardware compatibility

### RHEL/Fedora

**Best For**:
- **RHEL**: Enterprise servers, support contracts, certifications
- **Fedora**: Developers, testing latest features, Red Hat ecosystem
- Strong security requirements (SELinux)
- Corporate environments

---

## Key Takeaways

**Choose Arch if**:
- You want latest software
- Enjoy learning and tinkering
- Need complete control
- Desktop/development use
- Accept occasional breakage

**Choose Omarchy if**:
- You want Arch benefits pre-configured
- Security is priority (mandatory encryption)
- Developer-focused workflow
- Save setup time
- Like Hyprland/Wayland

**Choose Ubuntu if**:
- You're new to Linux
- Need stability and LTS
- Want GUI tools
- Prefer "it just works"
- Enterprise backing matters

**Choose RHEL/Fedora if**:
- Enterprise server use (RHEL)
- Need support contracts (RHEL)
- Want Red Hat ecosystem
- Development with stability (Fedora)
- SELinux security model

**Rolling vs Point Release**:
- **Rolling** (Arch): Continuous updates, latest software, potential breakage
- **Point** (Ubuntu/RHEL): Scheduled releases, tested stability, older packages

---

## Sources

- [Omarchy: The brand new Arch Linux experience](https://rashm1n.medium.com/omarchy-the-brand-new-arch-linux-experience-what-and-why-40c602f6745e)
- [The Omarchy Manual](https://learn.omacom.io/2/the-omarchy-manual)
- [Omarchy: DHH Made an Arch Linux Distro](https://fivenines.io/blog/omarchy-what-it-is-how-it-works/)
- [Omarchy Linux Review](https://www.thinklet.blog/omarchy-linux-review-arch-hyprland)
- [Omarchy is out](https://world.hey.com/dhh/omarchy-is-out-4666dd31)
