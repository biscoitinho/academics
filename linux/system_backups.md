## System Backups & Recovery

### Backup Strategies

**3-2-1 Rule**: 3 copies, 2 different media, 1 offsite

**Types**: Full, Incremental, Differential

### rsync

```bash
# Basic sync
rsync -av /source/ /destination/
rsync -avz /source/ user@remote:/dest/    # Compressed

# With progress and delete
rsync -avP --delete /source/ /dest/

# Incremental with hard links
rsync -av --delete \
  --link-dest=/backups/latest \
  /source/ /backups/$(date +%Y%m%d)/

# Exclude patterns
rsync -av --exclude='*.log' --exclude='temp/' /source/ /dest/

# Dry run
rsync -avn /source/ /dest/
```

### tar

```bash
# Create archives
tar -czf backup.tar.gz /data/
tar -cjf backup.tar.bz2 /data/   # bzip2
tar -cJf backup.tar.xz /data/    # xz

# Extract
tar -xzf backup.tar.gz
tar -xzf backup.tar.gz -C /restore/path/

# List contents
tar -tzf backup.tar.gz

# Exclude
tar -czf backup.tar.gz --exclude='*.log' /data/
```

### dd

```bash
# Clone disk
sudo dd if=/dev/sda of=/dev/sdb bs=64K status=progress

# Create image
sudo dd if=/dev/sda of=/backup/disk.img bs=64K status=progress

# Compressed image
sudo dd if=/dev/sda bs=64K | gzip > /backup/disk.img.gz

# Restore
sudo dd if=/backup/disk.img of=/dev/sda bs=64K status=progress
gunzip -c /backup/disk.img.gz | sudo dd of=/dev/sda bs=64K

# Backup MBR
sudo dd if=/dev/sda of=/backup/mbr.img bs=512 count=1
```

### Database Backups

```bash
# MySQL/MariaDB
mysqldump -u root -p database_name > backup.sql
mysqldump -u root -p --all-databases > all_dbs.sql
mysqldump -u root -p database_name | gzip > backup.sql.gz

# Restore
mysql -u root -p database_name < backup.sql

# PostgreSQL
pg_dump database_name > backup.sql
pg_dumpall > all_dbs.sql
pg_restore -d database_name backup.dump

# MongoDB
mongodump --db database_name --out /backup/
mongorestore --db database_name /backup/database_name/
```

### Automated Backup Script

```bash
#!/bin/bash
BACKUP_DIR="/backups"
SOURCE_DIR="/data"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=30

# Create backup
tar -czf "${BACKUP_DIR}/backup_${DATE}.tar.gz" "$SOURCE_DIR"

# Remove old backups
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete

echo "Backup completed: backup_${DATE}.tar.gz"
```

### Schedule with Cron

```bash
# Edit crontab
crontab -e

# Daily backup at 2 AM
0 2 * * * /scripts/backup.sh

# Weekly backup on Sunday
0 3 * * 0 /scripts/weekly-backup.sh
```

### Cloud Backups

```bash
# AWS S3
aws s3 sync /local/dir/ s3://bucket-name/backup/
aws s3 sync s3://bucket-name/backup/ /restore/dir/

# rclone (multi-cloud)
rclone sync /local/dir/ remote:backup/
```

### Recovery

```bash
# Restore from rsync backup
rsync -av /backups/latest/ /restore/location/

# Restore from tar
tar -xzf backup.tar.gz -C /restore/location/

# Restore specific files
tar -xzf backup.tar.gz -C /restore/location/ path/to/file

# System recovery from live USB
sudo mount /dev/sda1 /mnt
sudo rsync -av /backup/ /mnt/
```

### Quick Reference

```bash
# rsync
rsync -avP /source/ /dest/
rsync -avz /source/ user@remote:/dest/

# tar
tar -czf backup.tar.gz /data/
tar -xzf backup.tar.gz -C /restore/

# dd
sudo dd if=/dev/sda of=disk.img bs=64K status=progress

# MySQL
mysqldump -u root -p db > backup.sql
mysql -u root -p db < backup.sql

# Schedule
crontab -e
0 2 * * * /scripts/backup.sh
```
