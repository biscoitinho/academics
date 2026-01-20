# Replication and Backups

## Database Replication

### What is Replication?

Copying data from one database (master/primary) to one or more databases (slaves/replicas).

**Benefits:**
- High availability
- Load balancing (read replicas)
- Backup and disaster recovery
- Geographic distribution

## Replication Types

### Master-Slave Replication

One master (writes), multiple slaves (reads).

```
     Master (writes)
        |
    +---+---+
    |       |
  Slave1  Slave2 (reads)
```

**MySQL Example:**

**Master configuration (my.cnf):**
```ini
[mysqld]
server-id = 1
log-bin = /var/log/mysql/mysql-bin.log
binlog-do-db = mydb
```

**Slave configuration:**
```ini
[mysqld]
server-id = 2
relay-log = /var/log/mysql/mysql-relay-bin
```

**Setup slave:**
```sql
-- On master: Create replication user
CREATE USER 'repl'@'%' IDENTIFIED BY 'password';
GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';
FLUSH PRIVILEGES;
SHOW MASTER STATUS;  -- Note file and position

-- On slave: Configure replication
CHANGE MASTER TO
    MASTER_HOST='master_ip',
    MASTER_USER='repl',
    MASTER_PASSWORD='password',
    MASTER_LOG_FILE='mysql-bin.000001',
    MASTER_LOG_POS=12345;

START SLAVE;
SHOW SLAVE STATUS\G
```

### Master-Master Replication

Both servers can accept writes.

```
  Master1 ←→ Master2
```

**Use Case:** Active-active setup, but careful with conflicts!

### Multi-Master Replication

Multiple servers can all accept writes.

```
  Master1 ←→ Master2
     ↕          ↕
  Master3 ←→ Master4
```

**Use Case:** Distributed systems, but complex conflict resolution.

## PostgreSQL Replication

### Streaming Replication

**Primary configuration (postgresql.conf):**
```ini
wal_level = replica
max_wal_senders = 3
wal_keep_size = 64MB
```

**Setup replica:**
```bash
# On replica: Create base backup
pg_basebackup -h primary_host -D /var/lib/postgresql/data -U replication_user -P --wal-method=stream

# Create standby.signal file
touch /var/lib/postgresql/data/standby.signal

# Configure recovery
echo "primary_conninfo = 'host=primary_host port=5432 user=replication_user password=pass'" >> /var/lib/postgresql/data/postgresql.auto.conf

# Start replica
pg_ctl start
```

**Check replication status:**
```sql
-- On primary
SELECT * FROM pg_stat_replication;

-- On replica
SELECT pg_is_in_recovery();
```

## Replication Lag

Time delay between write on master and replication to slave.

```sql
-- MySQL: Check replication lag
SHOW SLAVE STATUS\G
-- Look at: Seconds_Behind_Master

-- PostgreSQL: Check lag
SELECT
    application_name,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn)) as lag
FROM pg_stat_replication;
```

## Application-Level Load Balancing

```python
# Python example
import pymysql

# Master connection (writes)
master = pymysql.connect(host='master_ip', ...)

# Slave connections (reads)
slaves = [
    pymysql.connect(host='slave1_ip', ...),
    pymysql.connect(host='slave2_ip', ...)
]

def write_query(sql, params):
    cursor = master.cursor()
    cursor.execute(sql, params)
    master.commit()

def read_query(sql, params):
    # Round-robin or random selection
    slave = random.choice(slaves)
    cursor = slave.cursor()
    cursor.execute(sql, params)
    return cursor.fetchall()
```

## Database Backups

### Logical Backups (SQL Dumps)

**MySQL:**
```bash
# Backup single database
mysqldump -u root -p mydb > backup.sql

# Backup all databases
mysqldump -u root -p --all-databases > all_backup.sql

# Backup specific tables
mysqldump -u root -p mydb users orders > tables_backup.sql

# Compressed backup
mysqldump -u root -p mydb | gzip > backup.sql.gz

# Restore
mysql -u root -p mydb < backup.sql
gunzip < backup.sql.gz | mysql -u root -p mydb
```

**PostgreSQL:**
```bash
# Backup
pg_dump dbname > backup.sql
pg_dump -U username -h localhost dbname > backup.sql

# Backup all databases
pg_dumpall > all_backup.sql

# Compressed backup
pg_dump dbname | gzip > backup.sql.gz

# Custom format (faster restore)
pg_dump -Fc dbname > backup.dump

# Restore
psql dbname < backup.sql
gunzip < backup.sql.gz | psql dbname
pg_restore -d dbname backup.dump
```

**SQLite:**
```bash
# Backup
sqlite3 mydb.db ".backup backup.db"
sqlite3 mydb.db ".dump" > backup.sql

# Or simply copy the file
cp mydb.db backup.db

# Restore
sqlite3 newdb.db < backup.sql
```

### Physical Backups (File System)

**MySQL:**
```bash
# Stop MySQL
systemctl stop mysql

# Copy data directory
cp -r /var/lib/mysql /backup/mysql

# Restart MySQL
systemctl start mysql

# Or use Percona XtraBackup (hot backup)
xtrabackup --backup --target-dir=/backup/mysql
xtrabackup --prepare --target-dir=/backup/mysql
xtrabackup --copy-back --target-dir=/backup/mysql
```

**PostgreSQL:**
```bash
# Base backup (while running)
pg_basebackup -D /backup/postgres -Ft -z -P

# Restore: stop PostgreSQL, restore files, start
```

## Backup Strategies

### Full Backup

Complete copy of entire database.

```bash
# Daily full backup
0 2 * * * mysqldump -u root -p mydb | gzip > /backup/$(date +\%Y\%m\%d)_full.sql.gz
```

### Incremental Backup

Only changes since last backup.

```bash
# MySQL: Enable binary logs
# postgresql.conf:
wal_level = replica
archive_mode = on
archive_command = 'cp %p /backup/wal/%f'
```

### Differential Backup

Changes since last full backup.

### Backup Schedule Example

```
Sunday: Full backup
Monday-Saturday: Incremental backups
```

## Point-in-Time Recovery (PITR)

Restore database to specific point in time.

**MySQL:**
```bash
# 1. Restore full backup
mysql -u root -p mydb < full_backup.sql

# 2. Apply binary logs up to specific time
mysqlbinlog --stop-datetime="2024-01-15 10:00:00" \
    mysql-bin.000001 mysql-bin.000002 | mysql -u root -p mydb
```

**PostgreSQL:**
```bash
# 1. Restore base backup
# 2. Configure recovery.conf
restore_command = 'cp /backup/wal/%f %p'
recovery_target_time = '2024-01-15 10:00:00'

# 3. Start PostgreSQL (enters recovery mode)
```

## Automated Backup Scripts

**MySQL Backup Script:**
```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/backup/mysql"
DB_NAME="mydb"
DB_USER="root"
DB_PASS="password"

# Create backup
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME | gzip > $BACKUP_DIR/${DATE}_${DB_NAME}.sql.gz

# Delete backups older than 30 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

# Log
echo "$(date): Backup completed" >> /var/log/mysql_backup.log
```

**Cron job:**
```bash
# Daily at 2 AM
0 2 * * * /path/to/backup_script.sh
```

## Testing Backups

**ALWAYS TEST YOUR BACKUPS!**

```bash
# Create test restore
mysql -u root -p test_db < backup.sql

# Verify data
mysql -u root -p test_db -e "SELECT COUNT(*) FROM users;"

# Check for errors
if [ $? -eq 0 ]; then
    echo "Backup is valid"
else
    echo "Backup is corrupted!"
fi
```

## Backup to Cloud

**AWS S3:**
```bash
# Backup and upload
mysqldump -u root -p mydb | gzip | aws s3 cp - s3://my-bucket/backup.sql.gz

# Download and restore
aws s3 cp s3://my-bucket/backup.sql.gz - | gunzip | mysql -u root -p mydb
```

**Google Cloud Storage:**
```bash
mysqldump -u root -p mydb | gzip | gsutil cp - gs://my-bucket/backup.sql.gz
```

## Disaster Recovery Plan

1. **Regular Backups**: Automated daily backups
2. **Test Restores**: Monthly restore tests
3. **Off-site Storage**: Cloud or remote location
4. **Documentation**: Recovery procedures
5. **Monitoring**: Alert on backup failures
6. **Retention Policy**: Keep backups for X days/months

## High Availability Setup

```
         Load Balancer
              |
    +---------+---------+
    |                   |
  Primary            Standby
  (Active)           (Hot)
    |                   |
  Replica1          Replica2
  (Read)            (Read)
```

**Failover Process:**
1. Primary fails
2. Promote standby to primary
3. Update application connection strings
4. Monitor and restore original primary as standby

## Monitoring Replication

```sql
-- MySQL
SHOW SLAVE STATUS\G

-- Check for:
-- Slave_IO_Running: Yes
-- Slave_SQL_Running: Yes
-- Seconds_Behind_Master: 0

-- PostgreSQL
SELECT * FROM pg_stat_replication;

-- Check:
-- state: streaming
-- sent_lsn vs replay_lsn (lag)
```

## Best Practices

1. **Backup Regularly**: At least daily
2. **Test Restores**: Verify backups work
3. **Multiple Locations**: Local + cloud
4. **Automate**: Scripts + cron jobs
5. **Monitor**: Alert on failures
6. **Document**: Recovery procedures
7. **Encrypt Backups**: Protect sensitive data
8. **Retention Policy**: Balance space vs needs
9. **Point-in-Time Recovery**: Enable binary/WAL logging
10. **Replication Monitoring**: Check lag regularly

## Common Mistakes

```bash
# ❌ No backup verification
mysqldump mydb > backup.sql
# What if backup is corrupt?

# ✅ Verify backup
mysqldump mydb > backup.sql
mysql test_restore < backup.sql
if [ $? -eq 0 ]; then echo "Success"; fi

# ❌ Single backup location
# ✅ Multiple locations (local + cloud)

# ❌ No monitoring
# ✅ Alert on backup failures

# ❌ Never test restore
# ✅ Regular restore drills
```

## Backup Encryption

```bash
# Encrypt backup
mysqldump -u root -p mydb | gzip | openssl enc -aes-256-cbc -salt -out backup.sql.gz.enc

# Decrypt and restore
openssl enc -aes-256-cbc -d -in backup.sql.gz.enc | gunzip | mysql -u root -p mydb
```

## Backup Storage Calculation

```
Daily backup size: 10 GB
Retention: 30 days
Total storage needed: 10 GB × 30 = 300 GB

With compression (assuming 70% reduction):
300 GB × 0.3 = 90 GB
```

## Recovery Time Objective (RTO)

Maximum acceptable downtime.

```
RTO: 1 hour
- Must be able to restore database within 1 hour
```

## Recovery Point Objective (RPO)

Maximum acceptable data loss.

```
RPO: 15 minutes
- Backups must be at most 15 minutes old
- Use binary logs / WAL for point-in-time recovery
```
