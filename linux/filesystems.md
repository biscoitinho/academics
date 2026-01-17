---

# 1. Common Linux native filesystems

## **ext4**
**Extended Filesystem v4**

- Default on many Linux distros
- Mature, stable, boring (in a good way)
- Journaling filesystem

**Features**
- Large file & volume support
- Journaling (metadata + optional data)
- Fast fsck compared to older ext versions

**Pros**
- Extremely reliable
- Excellent recovery tools
- Widely supported everywhere

**Cons**
- No snapshots
- No built-in checksumming

**Best for**
- General-purpose Linux systems
- Servers where predictability > features

---

## **XFS**
High-performance journaling filesystem (SGI origin)

**Features**
- Designed for large files
- Allocation groups for parallel I/O
- Metadata journaling

**Pros**
- Very fast for large files
- Scales extremely well
- Default on RHEL / Alma / Rocky

**Cons**
- Shrinking not supported
- Recovery tools less forgiving than ext4

**Best for**
- Media servers
- Databases
- Large-scale storage

---

## **Btrfs**
“B-tree filesystem” (modern Linux FS)

**Features**
- Copy-on-write (CoW)
- Snapshots
- Subvolumes
- Checksumming
- Built-in RAID

**Pros**
- Snapshots & rollback
- Compression
- Online resizing

**Cons**
- RAID5/6 still controversial
- Performance tuning required

**Best for**
- Desktop Linux
- Snapshot-heavy workflows
- openSUSE, Fedora

---

## **ZFS** (POSIX, not Linux-native)
Originally Solaris, now widely used

**Features**
- End-to-end checksumming
- Snapshots & clones
- Copy-on-write
- Integrated volume manager
- Self-healing data

**Pros**
- Industry-leading data integrity
- Incredible snapshot system
- Excellent for backups & NAS

**Cons**
- High RAM usage
- License incompatibility with Linux kernel (external module)

**Best for**
- FreeBSD
- NAS
- Storage servers
- Long-term data safety

---

# 2. POSIX / UNIX filesystems (cross-platform)

## **UFS / UFS2**
Traditional BSD filesystem

**Features**
- Simple, stable design
- Journaling optional (soft updates)

**Pros**
- Very predictable
- Low overhead

**Cons**
- No modern features (snapshots, checksums)

**Best for**
- Older BSD systems
- Embedded / legacy systems

---

## **FAT32 / exFAT**
Portable, non-POSIX filesystem

**Features**
- Very simple structure
- Widely supported across OSes

**Pros**
- Universal compatibility
- No permissions issues between systems

**Cons**
- No Unix permissions
- FAT32 has file size limits

**Best for**
- USB drives
- SD cards
- Cross-platform sharing

---

## **NTFS**
Windows filesystem (supported on POSIX)

**Features**
- Journaling
- Large files
- ACLs

**Pros**
- Good Linux support (ntfs-3g / kernel)
- Handles large volumes

**Cons**
- Not native POSIX semantics
- Permission mapping is artificial

**Best for**
- Dual-boot systems
- Accessing Windows disks

---

# 3. Network filesystems (POSIX-accessible)

## **NFS**
Network File System (Unix-native)

**Features**
- POSIX-like semantics
- Stateless (v3) / stateful (v4)

**Pros**
- Native Unix permissions
- Simple, efficient

**Cons**
- Security requires careful config

**Best for**
- Unix/Linux networks
- Shared home directories

---

## **SMB / CIFS**
Windows network filesystem

**Features**
- File sharing over LAN
- ACL-based permissions

**Pros**
- Excellent Windows interoperability

**Cons**
- POSIX semantics are emulated

**Best for**
- Mixed Windows/Linux environments

---

# 4. Virtual & pseudo filesystems (very important)

## **tmpfs**
Memory-backed filesystem

**Features**
- Stored in RAM (or swap)
- Extremely fast

**Best for**
- `/tmp`
- `/run`
- Temporary files

---

## **procfs (`/proc`)**
Process information filesystem

**Features**
- Kernel interface via files
- No actual storage

**Best for**
- System introspection
- Debugging

---

## **sysfs (`/sys`)**
Hardware & kernel objects interface

**Features**
- Structured kernel data
- Device configuration

**Best for**
- Hardware control
- Power management

---

## **devfs / udev**
Device nodes filesystem

**Features**
- Dynamic device files
- Hardware abstraction

**Best for**
- `/dev`

---

# 5. Filesystem comparison (quick view)

| Filesystem | Journaling | Snapshots | Checksums | Typical OS |
|----|----|----|----|----|
| ext4 | ✅ | ❌ | ❌ | Linux |
| XFS | ✅ | ❌ | ❌ | Linux |
| Btrfs | ✅ | ✅ | ✅ | Linux |
| ZFS | ✅ | ✅ | ✅ | BSD / Linux |
| UFS | ⚠️ | ❌ | ❌ | BSD |
| FAT32 | ❌ | ❌ | ❌ | Portable |
| NTFS | ✅ | ❌ | ❌ | Windows |

---

# 6. POSIX and filesystems (important note)

POSIX defines:
- file hierarchy
- permissions
- links
- file descriptors

POSIX **does NOT require**:
- journaling
- snapshots
- checksumming

That’s why many very different filesystems are still POSIX-compliant.

---

## Final takeaway

- **ext4** → safe default
- **XFS** → performance & scale
- **Btrfs** → modern Linux features
- **ZFS** → maximum data integrity
- **tmpfs / proc / sysfs** → core OS plumbing

