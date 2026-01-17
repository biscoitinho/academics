---

# What is RAID?

**RAID** = **Redundant Array of Independent Disks**

It combines multiple physical disks into **one logical storage unit** to achieve:
- redundancy (fault tolerance)
- performance
- capacity pooling

👉 RAID is about **availability**, not backups.

---

# What RAID is NOT

- ❌ Not a backup
- ❌ Not protection from deletion, ransomware, or corruption
- ❌ Not protection from fire/theft

RAID only protects against **disk failure**.

---

# RAID levels (the important ones)

## RAID 0 – Striping (speed, no safety)
- Data split across disks
- No redundancy

**Min disks:** 2  
**Usable capacity:** 100%  
**Fault tolerance:** 0 disks  

---

## RAID 1 – Mirroring
- Same data written to two disks

**Min disks:** 2  
**Usable capacity:** 50%  
**Fault tolerance:** 1 disk  

---

## RAID 5 – Parity (balanced)
- Data + parity across disks

**Min disks:** 3  
**Usable capacity:** (N−1) disks  
**Fault tolerance:** 1 disk  

⚠️ Risky with large disks

---

## RAID 6 – Dual parity
- Two parity blocks

**Min disks:** 4  
**Usable capacity:** (N−2) disks  
**Fault tolerance:** 2 disks  

---

## RAID 10 (1+0)
- Mirrored pairs + striping

**Min disks:** 4  
**Usable capacity:** 50%  
**Fault tolerance:** 1 disk per mirror  

---

# Types of RAID (OS-wise)

## Hardware RAID
- Dedicated controller
- OS sees one disk

---

## Software RAID (Linux mdadm)
- Kernel-managed
- Portable & reliable

---

## Filesystem-level RAID (ZFS / Btrfs)
- RAID built into filesystem
- Checksums & self-healing

---

# How RAID is used OS-wise (Linux)

## mdadm example
```bash
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb

