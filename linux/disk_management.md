## Disk Management

### Viewing Disk Information

#### List block devices

```bash
# List all block devices
lsblk

# With filesystem info
lsblk -f

# Show sizes in different formats
lsblk -h    # Human readable
lsblk -b    # Bytes

# Example output:
# NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
# sda      8:0    0 238.5G  0 disk
# ├─sda1   8:1    0   512M  0 part /boot/efi
# ├─sda2   8:2    0   200G  0 part /
# └─sda3   8:3    0  38.5G  0 part [SWAP]
```

#### Disk usage

```bash
# Show disk space
df -h              # Human readable
df -i              # Inodes
df -T              # Include filesystem type

# Show directory size
du -sh /path/      # Summary
du -h --max-depth=1 /path/  # One level deep

# Find large files
du -ah /path/ | sort -rh | head -n 20
find /path/ -type f -size +100M -exec ls -lh {} \;
```

#### Disk information

```bash
# Show disk info
sudo fdisk -l /dev/sda

# Show partition table
sudo parted /dev/sda print

# Show SMART status
sudo smartctl -a /dev/sda

# Show disk model and serial
sudo hdparm -I /dev/sda | grep -E "Model|Serial"
```

### Partitioning with fdisk

#### Basic operations

```bash
# Start fdisk
sudo fdisk /dev/sdb

# Commands in fdisk:
# m    Help
# p    Print partition table
# n    New partition
# d    Delete partition
# t    Change partition type
# w    Write changes (save)
# q    Quit without saving

# Example: Create new partition
n      # New partition
p      # Primary
1      # Partition number
<Enter> # First sector (default)
+10G   # Last sector (size)
w      # Write changes
```

#### Partition types

```bash
# In fdisk, press 't' then 'L' to list types
# Common types:
# 83  Linux filesystem
# 82  Linux swap
# 8e  Linux LVM
# fd  Linux RAID auto
# ef  EFI System
```

#### Practical examples

```bash
# Create 3 partitions
sudo fdisk /dev/sdb
n, p, 1, <enter>, +20G    # 20GB partition
n, p, 2, <enter>, +30G    # 30GB partition
n, p, 3, <enter>, <enter> # Rest of disk
w                          # Write changes

# After partitioning, inform kernel
sudo partprobe /dev/sdb
# Or
sudo blockdev --rereadpt /dev/sdb
```

### Partitioning with parted

#### Basic operations

```bash
# Start parted
sudo parted /dev/sdb

# Non-interactive mode
sudo parted /dev/sdb print
sudo parted /dev/sdb mklabel gpt
sudo parted /dev/sdb mkpart primary 0% 50%

# Commands in parted:
# print          Show partition table
# mklabel TYPE   Create partition table (gpt/msdos)
# mkpart         Create partition
# rm NUMBER      Delete partition
# resizepart     Resize partition
# quit           Exit
```

#### Create GPT partition table

```bash
# Create GPT table
sudo parted /dev/sdb mklabel gpt

# Create partition
sudo parted /dev/sdb mkpart primary ext4 0% 100%

# Set partition name
sudo parted /dev/sdb name 1 "Data"

# Set flags
sudo parted /dev/sdb set 1 boot on
```

#### Partition alignment

```bash
# Create aligned partitions (for SSDs)
sudo parted -a optimal /dev/sdb mkpart primary ext4 0% 50%

# Check alignment
sudo parted /dev/sdb align-check optimal 1
```

### Filesystems

#### Create filesystems

```bash
# ext4
sudo mkfs.ext4 /dev/sdb1
sudo mkfs.ext4 -L DataDisk /dev/sdb1  # With label

# ext3
sudo mkfs.ext3 /dev/sdb1

# XFS
sudo mkfs.xfs /dev/sdb1
sudo mkfs.xfs -f /dev/sdb1  # Force (overwrites)

# Btrfs
sudo mkfs.btrfs /dev/sdb1
sudo mkfs.btrfs -L MyData /dev/sdb1

# FAT32
sudo mkfs.vfat -F 32 /dev/sdb1

# NTFS
sudo mkfs.ntfs /dev/sdb1
```

#### Filesystem options

```bash
# ext4 with options
sudo mkfs.ext4 \
  -L DataDisk \          # Label
  -m 1 \                 # Reserved blocks % (default 5%)
  -O ^has_journal \      # Disable journal
  /dev/sdb1

# XFS with options
sudo mkfs.xfs \
  -L DataDisk \
  -b size=4096 \         # Block size
  -i size=512 \          # Inode size
  /dev/sdb1
```

#### Check and repair filesystems

```bash
# Check filesystem (unmounted!)
sudo fsck /dev/sdb1
sudo fsck -y /dev/sdb1  # Auto yes to prompts

# ext4 specific
sudo e2fsck /dev/sdb1
sudo e2fsck -f /dev/sdb1  # Force check

# XFS specific
sudo xfs_repair /dev/sdb1
sudo xfs_repair -n /dev/sdb1  # Dry run

# Check filesystem integrity
sudo tune2fs -l /dev/sdb1  # ext4 info
sudo xfs_info /dev/sdb1    # XFS info
```

### Mounting Filesystems

#### Manual mounting

```bash
# Mount filesystem
sudo mount /dev/sdb1 /mnt/data

# Mount with options
sudo mount -o rw,noatime /dev/sdb1 /mnt/data

# Mount by UUID
sudo mount UUID=abc123... /mnt/data

# Mount by label
sudo mount LABEL=DataDisk /mnt/data

# Unmount
sudo umount /mnt/data
# Or by device
sudo umount /dev/sdb1

# Force unmount (if busy)
sudo umount -f /mnt/data
sudo umount -l /mnt/data  # Lazy unmount
```

#### Common mount options

```bash
# Read-only
sudo mount -o ro /dev/sdb1 /mnt/data

# Read-write
sudo mount -o rw /dev/sdb1 /mnt/data

# No access time updates (faster)
sudo mount -o noatime /dev/sdb1 /mnt/data

# No execute
sudo mount -o noexec /dev/sdb1 /mnt/data

# No setuid
sudo mount -o nosuid /dev/sdb1 /mnt/data

# Remount with different options
sudo mount -o remount,ro /mnt/data
```

#### Check what's using a mount

```bash
# List processes using mount
sudo lsof /mnt/data
sudo fuser -v /mnt/data

# Kill processes using mount
sudo fuser -km /mnt/data
```

### /etc/fstab - Persistent Mounts

#### fstab format

```bash
# /etc/fstab format:
# <device> <mount point> <type> <options> <dump> <pass>

# Examples:
UUID=abc-123        /                ext4    defaults           0 1
UUID=def-456        /home            ext4    defaults,noatime   0 2
UUID=ghi-789        /data            ext4    defaults,nofail    0 2
UUID=jkl-012        none             swap    sw                 0 0
/dev/sdb1           /mnt/backup      xfs     defaults,noauto    0 0
```

#### Get UUID

```bash
# List UUIDs
sudo blkid

# Get specific UUID
sudo blkid /dev/sdb1

# Alternative
lsblk -f
ls -l /dev/disk/by-uuid/
```

#### fstab options

```bash
# defaults: rw, suid, dev, exec, auto, nouser, async
# rw/ro: read-write / read-only
# auto/noauto: mount at boot / manual mount only
# user: allow non-root users to mount
# noatime: don't update access time
# nofail: don't report errors if device missing
# x-systemd.automount: automount on access
```

#### Test fstab

```bash
# Test mount all
sudo mount -a

# Test specific mount
sudo mount /mnt/data

# Check for errors
findmnt --verify
```

#### Example fstab entries

```bash
# Root partition
UUID=abc-123  /      ext4  defaults,noatime  0 1

# Home partition
UUID=def-456  /home  ext4  defaults,noatime  0 2

# Data partition (don't fail boot if missing)
UUID=ghi-789  /data  xfs   defaults,nofail   0 2

# Swap
UUID=jkl-012  none   swap  sw                0 0

# External backup (manual mount)
UUID=mno-345  /mnt/backup  ext4  noauto,user,rw  0 0

# Network share
//server/share  /mnt/share  cifs  credentials=/root/.smbcred,uid=1000  0 0

# Temp filesystem in RAM
tmpfs  /tmp  tmpfs  defaults,noatime,mode=1777  0 0
```

### LVM - Logical Volume Management

#### LVM concepts

- **Physical Volume (PV)**: Physical disk or partition
- **Volume Group (VG)**: Pool of storage from PVs
- **Logical Volume (LV)**: Virtual partition from VG

#### Create LVM

```bash
# 1. Create physical volumes
sudo pvcreate /dev/sdb1
sudo pvcreate /dev/sdc1

# Show physical volumes
sudo pvdisplay
sudo pvs

# 2. Create volume group
sudo vgcreate vg_data /dev/sdb1 /dev/sdc1

# Show volume groups
sudo vgdisplay
sudo vgs

# 3. Create logical volumes
sudo lvcreate -L 50G -n lv_data1 vg_data
sudo lvcreate -L 30G -n lv_data2 vg_data
sudo lvcreate -l 100%FREE -n lv_data3 vg_data  # Use remaining space

# Show logical volumes
sudo lvdisplay
sudo lvs

# 4. Create filesystem
sudo mkfs.ext4 /dev/vg_data/lv_data1

# 5. Mount
sudo mount /dev/vg_data/lv_data1 /mnt/data1
```

#### Extend LVM

```bash
# Add new physical volume to VG
sudo pvcreate /dev/sdd1
sudo vgextend vg_data /dev/sdd1

# Extend logical volume
sudo lvextend -L +20G /dev/vg_data/lv_data1
# Or use all free space
sudo lvextend -l +100%FREE /dev/vg_data/lv_data1

# Resize filesystem (online resize for ext4/XFS)
sudo resize2fs /dev/vg_data/lv_data1  # ext4
sudo xfs_growfs /mnt/data1            # XFS
```

#### Reduce LVM

```bash
# Reduce LV (ext4 only, not XFS!)
# MUST unmount first!
sudo umount /mnt/data1

# Check filesystem
sudo e2fsck -f /dev/vg_data/lv_data1

# Resize filesystem
sudo resize2fs /dev/vg_data/lv_data1 40G

# Reduce LV
sudo lvreduce -L 40G /dev/vg_data/lv_data1

# Remount
sudo mount /dev/vg_data/lv_data1 /mnt/data1
```

#### Remove LVM

```bash
# Remove logical volume
sudo umount /mnt/data1
sudo lvremove /dev/vg_data/lv_data1

# Remove volume group
sudo vgremove vg_data

# Remove physical volume
sudo pvremove /dev/sdb1
```

#### LVM snapshots

```bash
# Create snapshot (5GB space for changes)
sudo lvcreate -L 5G -s -n lv_data1_snap /dev/vg_data/lv_data1

# Mount snapshot
sudo mount /dev/vg_data/lv_data1_snap /mnt/snapshot

# Restore from snapshot
sudo umount /mnt/data1
sudo lvconvert --merge /dev/vg_data/lv_data1_snap
# On next mount, data will be restored

# Remove snapshot
sudo lvremove /dev/vg_data/lv_data1_snap
```

### Swap Management

#### Create swap file

```bash
# Create 2GB swap file
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
# Or faster:
sudo fallocate -l 2G /swapfile

# Set permissions
sudo chmod 600 /swapfile

# Format as swap
sudo mkswap /swapfile

# Enable swap
sudo swapon /swapfile

# Make permanent (add to /etc/fstab)
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

#### Create swap partition

```bash
# Create partition with type 82 (Linux swap)
sudo fdisk /dev/sdb
# n, p, 1, <enter>, +4G, t, 82, w

# Format as swap
sudo mkswap /dev/sdb1

# Enable swap
sudo swapon /dev/sdb1

# Add to /etc/fstab
UUID=xxx-yyy none swap sw 0 0
```

#### Manage swap

```bash
# Show swap
swapon --show
free -h
cat /proc/swaps

# Disable swap
sudo swapoff /swapfile
sudo swapoff -a  # All swap

# Enable swap
sudo swapon /swapfile
sudo swapon -a  # All in fstab

# Change swappiness (0-100, default 60)
# Lower = less aggressive swapping
sudo sysctl vm.swappiness=10
# Make permanent
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
```

### RAID Management

#### Software RAID with mdadm

```bash
# Install mdadm
sudo apt install mdadm

# Create RAID 1 (mirror)
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Create RAID 5 (parity)
sudo mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sdb1 /dev/sdc1 /dev/sdd1

# Create RAID 0 (stripe)
sudo mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Check RAID status
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Save RAID configuration
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf

# Update initramfs
sudo update-initramfs -u
```

#### Manage RAID

```bash
# Add spare disk
sudo mdadm /dev/md0 --add /dev/sde1

# Remove disk
sudo mdadm /dev/md0 --fail /dev/sdb1
sudo mdadm /dev/md0 --remove /dev/sdb1

# Stop RAID
sudo mdadm --stop /dev/md0

# Assemble RAID
sudo mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1

# Monitor RAID
sudo mdadm --monitor --scan --daemonise
```

### Disk Performance

#### Test disk speed

```bash
# Write test
dd if=/dev/zero of=/tmp/test bs=1M count=1024 conv=fdatasync

# Read test
dd if=/tmp/test of=/dev/null bs=1M

# Using hdparm (cached reads)
sudo hdparm -t /dev/sda
sudo hdparm -T /dev/sda

# Using fio (advanced)
sudo apt install fio
fio --name=random-write --ioengine=libaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --time_based --runtime=60 --end_fsync=1
```

#### I/O monitoring

```bash
# Monitor I/O
iostat -x 2         # Extended stats every 2 seconds
iotop               # Like top for I/O
sudo iotop -o       # Only show processes doing I/O

# Per-process I/O
pidstat -d 2
```

### Best Practices

1. **Always backup data before partitioning**
2. **Use UUID in fstab** (device names can change)
3. **Use LVM** for flexibility in disk management
4. **Set proper permissions** on mount points
5. **Use noatime** mount option for better performance
6. **Monitor disk health** regularly (SMART)
7. **Leave some free space** in volume groups (for snapshots)
8. **Test fstab changes** before rebooting
9. **Document disk layouts** and configurations
10. **Use appropriate filesystem** for use case:
    - ext4: General purpose, default
    - XFS: Large files, high performance
    - Btrfs: Snapshots, compression
    - NTFS/FAT32: Windows compatibility
