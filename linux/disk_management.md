## Disk Management

### View Disk Information

```bash
# List block devices
lsblk
lsblk -f            # With filesystem info

# Disk usage
df -h
du -sh /*
du -h /var | sort -hr | head -10

# Find large files
find / -type f -size +100M
du -ah /path | sort -rh | head -20

# Disk info
sudo fdisk -l /dev/sda
sudo smartctl -a /dev/sda
```

### Partitioning

```bash
# fdisk
sudo fdisk /dev/sdb
# Commands: m (help), p (print), n (new), d (delete), w (write), q (quit)

# parted
sudo parted /dev/sdb
sudo parted /dev/sdb print
sudo parted /dev/sdb mklabel gpt
sudo parted /dev/sdb mkpart primary 0% 100%

# Inform kernel
sudo partprobe /dev/sdb
```

### Filesystems

```bash
# Create
sudo mkfs.ext4 /dev/sdb1
sudo mkfs.xfs /dev/sdb1
sudo mkfs.btrfs /dev/sdb1

# Check
sudo fsck /dev/sdb1    # Unmount first!
sudo e2fsck -f /dev/sdb1
```

### Mounting

```bash
# Mount
sudo mount /dev/sdb1 /mnt/data
sudo mount -o rw,noatime /dev/sdb1 /mnt/data

# Unmount
sudo umount /mnt/data

# Check what's using mount
sudo lsof /mnt/data
sudo fuser -v /mnt/data
```

### /etc/fstab

```bash
# Format: <device> <mount> <type> <options> <dump> <pass>

# Get UUID
sudo blkid /dev/sdb1

# Examples
UUID=abc-123  /data  ext4  defaults,noatime  0 2
UUID=def-456  none   swap  sw                0 0

# Test fstab
sudo mount -a
```

### LVM

```bash
# Create physical volume
sudo pvcreate /dev/sdb1
sudo pvs

# Create volume group
sudo vgcreate vg_data /dev/sdb1
sudo vgs

# Create logical volume
sudo lvcreate -L 50G -n lv_data1 vg_data
sudo lvs

# Create filesystem and mount
sudo mkfs.ext4 /dev/vg_data/lv_data1
sudo mount /dev/vg_data/lv_data1 /mnt/data1

# Extend LV
sudo lvextend -L +20G /dev/vg_data/lv_data1
sudo resize2fs /dev/vg_data/lv_data1    # ext4
sudo xfs_growfs /mnt/data1              # XFS
```

### Swap

```bash
# Create swap file
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Add to /etc/fstab
/swapfile none swap sw 0 0

# Manage swap
swapon --show
free -h
sudo swapoff /swapfile
sudo swapon -a
```

### RAID

```bash
# Create RAID 1 (mirror)
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1

# Check status
cat /proc/mdstat
sudo mdadm --detail /dev/md0

# Save config
sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
```

### Performance

```bash
# Test disk speed
dd if=/dev/zero of=/tmp/test bs=1M count=1024 conv=fdatasync
sudo hdparm -t /dev/sda

# Monitor I/O
iostat -x 2
sudo iotop
```

### Quick Reference

```bash
# Info
lsblk
df -h
sudo fdisk -l

# Create filesystem
sudo mkfs.ext4 /dev/sdb1

# Mount
sudo mount /dev/sdb1 /mnt/data
sudo umount /mnt/data

# LVM
sudo pvcreate /dev/sdb1
sudo vgcreate vg_data /dev/sdb1
sudo lvcreate -L 50G -n lv_data vg_data

# Swap
sudo fallocate -l 2G /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```
