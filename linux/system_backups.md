## System Backups & Recovery

### Backup Strategies

#### 3-2-1 Rule
- **3** copies of your data
- **2** different media types
- **1** copy offsite

#### Backup Types

**Full Backup**
- Complete copy of all data
- Slowest but simplest to restore
- Most storage space required

**Incremental Backup**
- Only changes since last backup (any type)
- Fastest, least storage
- Restore requires full + all incrementals

**Differential Backup**
- Changes since last full backup
- Moderate speed and storage
- Restore requires full + last differential

### rsync - Efficient File Synchronization

#### Basic usage

```bash
# Sync directory
rsync -av /source/ /destination/

# Options:
# -a  Archive mode (preserves permissions, times, etc)
# -v  Verbose
# -z  Compress during transfer
# -h  Human-readable sizes
# --progress  Show progress
# --delete  Delete files in dest not in source

# Remote sync (push)
rsync -avz /local/dir/ user@remote:/remote/dir/

# Remote sync (pull)
rsync -avz user@remote:/remote/dir/ /local/dir/
```

#### Incremental backups with rsync

```bash
# Using hard links for space efficiency
rsync -av --delete \
  --link-dest=/backups/latest \
  /source/ /backups/$(date +%Y%m%d)/

# Update latest symlink
ln -nsf /backups/$(date +%Y%m%d) /backups/latest
```

#### Exclude patterns

```bash
# Exclude files/directories
rsync -av \
  --exclude='*.log' \
  --exclude='temp/' \
  --exclude-from='exclude-list.txt' \
  /source/ /destination/

# Example exclude-list.txt:
# *.tmp
# .cache/
# node_modules/
```

#### Common rsync scenarios

```bash
# Backup system (excluding certain directories)
rsync -aAXv --delete \
  --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} \
  / /backup/location/

# Sync only newer files
rsync -avu /source/ /destination/

# Dry run (test without changes)
rsync -avn /source/ /destination/

# Show what would be deleted
rsync -avn --delete /source/ /destination/

# Limit bandwidth (KB/s)
rsync -av --bwlimit=1000 /source/ /destination/
```

### tar - Archive Files

#### Creating archives

```bash
# Create tar archive
tar -cvf archive.tar /path/to/files

# Create compressed archives
tar -czvf archive.tar.gz /path/to/files    # gzip
tar -cjvf archive.tar.bz2 /path/to/files   # bzip2
tar -cJvf archive.tar.xz /path/to/files    # xz

# Options:
# -c  Create
# -x  Extract
# -t  List contents
# -v  Verbose
# -f  File
# -z  gzip compression
# -j  bzip2 compression
# -J  xz compression
# -p  Preserve permissions
```

#### Extracting archives

```bash
# Extract to current directory
tar -xvf archive.tar

# Extract to specific directory
tar -xvf archive.tar -C /destination/

# Extract specific files
tar -xvf archive.tar file1.txt dir/file2.txt

# List contents without extracting
tar -tvf archive.tar

# Extract compressed archives
tar -xzvf archive.tar.gz
tar -xjvf archive.tar.bz2
tar -xJvf archive.tar.xz
```

#### Incremental backups with tar

```bash
# Create full backup
tar -czf full-backup.tar.gz \
  --listed-incremental=backup.snar \
  /data/

# Create incremental backup
tar -czf incremental-backup.tar.gz \
  --listed-incremental=backup.snar \
  /data/
```

#### Exclude patterns

```bash
# Exclude files/directories
tar -czf backup.tar.gz \
  --exclude='*.log' \
  --exclude='temp' \
  --exclude-from='exclude-list.txt' \
  /data/
```

### dd - Disk Imaging

#### Create disk image

```bash
# Clone entire disk
sudo dd if=/dev/sda of=/dev/sdb bs=64K conv=noerror,sync status=progress

# Create disk image file
sudo dd if=/dev/sda of=/backup/disk.img bs=64K status=progress

# Create compressed image
sudo dd if=/dev/sda bs=64K status=progress | gzip > /backup/disk.img.gz

# Options:
# if=  Input file (source)
# of=  Output file (destination)
# bs=  Block size (64K is good for speed)
# conv=noerror,sync  Continue on errors, pad with zeros
# status=progress  Show progress
```

#### Restore from image

```bash
# Restore disk from image
sudo dd if=/backup/disk.img of=/dev/sda bs=64K status=progress

# Restore from compressed image
gunzip -c /backup/disk.img.gz | sudo dd of=/dev/sda bs=64K status=progress
```

#### Backup specific partitions

```bash
# Backup partition
sudo dd if=/dev/sda1 of=/backup/sda1.img bs=64K status=progress

# Backup MBR (Master Boot Record)
sudo dd if=/dev/sda of=/backup/mbr.img bs=512 count=1

# Restore MBR
sudo dd if=/backup/mbr.img of=/dev/sda bs=512 count=1
```

### System Backup Tools

#### Timeshift (System snapshots)

```bash
# Install
sudo apt install timeshift    # Debian/Ubuntu
sudo dnf install timeshift    # Fedora

# Create snapshot
sudo timeshift --create --comments "Before upgrade"

# List snapshots
sudo timeshift --list

# Restore snapshot
sudo timeshift --restore --snapshot "SNAPSHOT_NAME"

# Delete snapshot
sudo timeshift --delete --snapshot "SNAPSHOT_NAME"
```

#### Duplicity (Encrypted backups)

```bash
# Install
sudo apt install duplicity

# Full backup to remote
duplicity /home/user sftp://user@remote//backup/

# Incremental backup
duplicity incremental /home/user sftp://user@remote//backup/

# Restore
duplicity restore sftp://user@remote//backup/ /restore/path/

# Restore specific file
duplicity restore --file-to-restore path/to/file \
  sftp://user@remote//backup/ /restore/path/
```

#### Restic (Fast, encrypted backups)

```bash
# Install
sudo apt install restic

# Initialize repository
restic -r /backup/repo init

# Create backup
restic -r /backup/repo backup /home/user

# List snapshots
restic -r /backup/repo snapshots

# Restore latest snapshot
restic -r /backup/repo restore latest --target /restore/path

# Mount snapshots as filesystem
mkdir /mnt/restic
restic -r /backup/repo mount /mnt/restic
```

### Database Backups

#### MySQL/MariaDB

```bash
# Backup single database
mysqldump -u root -p database_name > backup.sql

# Backup all databases
mysqldump -u root -p --all-databases > all_databases.sql

# Backup with compression
mysqldump -u root -p database_name | gzip > backup.sql.gz

# Restore database
mysql -u root -p database_name < backup.sql
gunzip < backup.sql.gz | mysql -u root -p database_name
```

#### PostgreSQL

```bash
# Backup single database
pg_dump database_name > backup.sql

# Backup all databases
pg_dumpall > all_databases.sql

# Backup with custom format (compressed)
pg_dump -Fc database_name > backup.dump

# Restore database
psql database_name < backup.sql
pg_restore -d database_name backup.dump
```

#### MongoDB

```bash
# Backup database
mongodump --db database_name --out /backup/

# Backup all databases
mongodump --out /backup/

# Restore database
mongorestore --db database_name /backup/database_name/
```

### Automated Backup Scripts

#### Simple backup script

```bash
#!/bin/bash
set -euo pipefail

# Configuration
BACKUP_DIR="/backups"
SOURCE_DIR="/data"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

# Create backup
BACKUP_FILE="${BACKUP_DIR}/backup_${DATE}.tar.gz"
tar -czf "$BACKUP_FILE" "$SOURCE_DIR"

# Remove old backups
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "Backup completed: $BACKUP_FILE"
```

#### Advanced rsync backup script

```bash
#!/bin/bash
set -euo pipefail

# Configuration
BACKUP_ROOT="/backups"
SOURCE_DIR="/data"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="${BACKUP_ROOT}/${DATE}"
LATEST_LINK="${BACKUP_ROOT}/latest"
RETENTION_COPIES=7
LOG_FILE="${BACKUP_ROOT}/backup.log"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Perform backup
echo "[$(date)] Starting backup..." | tee -a "$LOG_FILE"

rsync -av --delete \
  --link-dest="$LATEST_LINK" \
  --exclude='*.tmp' \
  --exclude='.cache/' \
  "$SOURCE_DIR/" "$BACKUP_DIR/" 2>&1 | tee -a "$LOG_FILE"

# Update latest link
ln -nsf "$BACKUP_DIR" "$LATEST_LINK"

# Remove old backups (keep last N)
cd "$BACKUP_ROOT"
ls -t | grep -v "^latest$" | tail -n +$((RETENTION_COPIES + 1)) | xargs -r rm -rf

echo "[$(date)] Backup completed: $BACKUP_DIR" | tee -a "$LOG_FILE"
```

#### Database backup script

```bash
#!/bin/bash
set -euo pipefail

# Configuration
BACKUP_DIR="/backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=14
DB_USER="backup_user"
DB_PASS="backup_password"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Get list of databases
DATABASES=$(mysql -u "$DB_USER" -p"$DB_PASS" -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)")

# Backup each database
for DB in $DATABASES; do
    echo "Backing up database: $DB"
    BACKUP_FILE="${BACKUP_DIR}/${DB}_${DATE}.sql.gz"
    mysqldump -u "$DB_USER" -p"$DB_PASS" \
      --single-transaction \
      --quick \
      --lock-tables=false \
      "$DB" | gzip > "$BACKUP_FILE"
done

# Remove old backups
find "$BACKUP_DIR" -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete

echo "Database backups completed"
```

### Scheduling Backups

#### Using cron

```bash
# Edit crontab
crontab -e

# Daily backup at 2 AM
0 2 * * * /scripts/backup.sh

# Weekly backup on Sunday at 3 AM
0 3 * * 0 /scripts/weekly-backup.sh

# Hourly backups
0 * * * * /scripts/hourly-backup.sh
```

#### Using systemd timer

```ini
# /etc/systemd/system/backup.service
[Unit]
Description=System Backup
Wants=backup.timer

[Service]
Type=oneshot
ExecStart=/scripts/backup.sh
User=root

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/backup.timer
[Unit]
Description=Daily System Backup
Requires=backup.service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

```bash
# Enable and start timer
sudo systemctl enable backup.timer
sudo systemctl start backup.timer

# Check timer status
sudo systemctl list-timers
```

### Recovery Procedures

#### Restore files from backup

```bash
# Rsync restore
rsync -av /backups/latest/ /restore/location/

# Tar restore
tar -xzvf backup.tar.gz -C /restore/location/

# Restore specific files
tar -xzvf backup.tar.gz -C /restore/location/ path/to/file
```

#### System recovery

```bash
# Boot from live USB/CD
# Mount root partition
sudo mount /dev/sda1 /mnt
sudo mount /dev/sda2 /mnt/boot  # If separate boot partition

# Mount system directories
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys

# Chroot into system
sudo chroot /mnt

# Restore from backup
rsync -av /backup/location/ /

# Reinstall bootloader if needed
grub-install /dev/sda
update-grub

# Exit chroot and reboot
exit
sudo reboot
```

#### Disaster recovery checklist

1. **Assess the situation**
   - What failed? (disk, system, data corruption)
   - When was last good backup?
   - What data is critical?

2. **Prepare recovery environment**
   - Boot from live media
   - Have backup media available
   - Check disk health: `smartctl -a /dev/sda`

3. **Recover critical data first**
   - User data
   - Configuration files
   - Databases

4. **Restore system**
   - Reinstall OS if needed
   - Restore from backup
   - Verify integrity

5. **Test recovery**
   - Boot system
   - Check services
   - Verify data

### Best Practices

#### General
- Test backups regularly
- Automate backup process
- Monitor backup jobs
- Document recovery procedures
- Keep offsite copies
- Encrypt sensitive backups

#### Backup verification

```bash
# Verify tar archive
tar -tzf backup.tar.gz > /dev/null && echo "OK" || echo "FAILED"

# Compare directories
diff -r /source/ /backup/

# Check rsync backup
rsync -avcn /source/ /backup/
```

#### Monitoring backup success

```bash
# Check backup age
BACKUP_FILE="/backups/latest/timestamp"
if [ -f "$BACKUP_FILE" ]; then
    AGE=$(($(date +%s) - $(stat -c %Y "$BACKUP_FILE")))
    if [ $AGE -gt 86400 ]; then
        echo "WARNING: Backup is older than 24 hours"
    fi
fi

# Check backup size
SIZE=$(du -sb /backups/latest/ | cut -f1)
if [ $SIZE -lt 1000000 ]; then
    echo "WARNING: Backup size is suspiciously small"
fi
```

#### Security considerations

```bash
# Encrypt backup with GPG
tar -czf - /data/ | gpg --symmetric --cipher-algo AES256 -o backup.tar.gz.gpg

# Decrypt backup
gpg -d backup.tar.gz.gpg | tar -xzf -

# Set proper permissions on backups
chmod 600 /backups/*.tar.gz
chown root:root /backups/*.tar.gz
```

### Cloud Backups

#### AWS S3 with aws-cli

```bash
# Install AWS CLI
sudo apt install awscli

# Configure credentials
aws configure

# Sync to S3
aws s3 sync /local/dir/ s3://bucket-name/backup/

# Sync from S3
aws s3 sync s3://bucket-name/backup/ /restore/dir/

# Use with lifecycle rules for automated retention
```

#### rclone (Multi-cloud support)

```bash
# Install
sudo apt install rclone

# Configure remote
rclone config

# Sync to cloud
rclone sync /local/dir/ remote:backup/

# Sync from cloud
rclone sync remote:backup/ /local/dir/

# Encrypted sync
rclone sync /local/dir/ encrypted:backup/
```
