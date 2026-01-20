# Database Security and Permissions

## User Management

### MySQL

```sql
-- Create user
CREATE USER 'john'@'localhost' IDENTIFIED BY 'password123';
CREATE USER 'john'@'%' IDENTIFIED BY 'password123';  -- Any host

-- Change password
ALTER USER 'john'@'localhost' IDENTIFIED BY 'newpassword';
SET PASSWORD FOR 'john'@'localhost' = PASSWORD('newpassword');

-- Drop user
DROP USER 'john'@'localhost';

-- List users
SELECT user, host FROM mysql.user;

-- Show current user
SELECT USER(), CURRENT_USER();
```

### PostgreSQL

```sql
-- Create user/role
CREATE USER john WITH PASSWORD 'password123';
CREATE ROLE john WITH LOGIN PASSWORD 'password123';

-- Change password
ALTER USER john WITH PASSWORD 'newpassword';

-- Drop user
DROP USER john;

-- List users
\du
SELECT usename FROM pg_user;

-- Show current user
SELECT current_user;
```

### SQLite

SQLite has no user management - file-level permissions only.

```bash
# File permissions
chmod 600 mydb.db  # Owner read/write only
chmod 640 mydb.db  # Owner read/write, group read
```

## GRANT - Giving Permissions

### MySQL

```sql
-- Grant all privileges on database
GRANT ALL PRIVILEGES ON mydb.* TO 'john'@'localhost';

-- Grant specific privileges
GRANT SELECT, INSERT, UPDATE ON mydb.users TO 'john'@'localhost';

-- Grant on specific table
GRANT SELECT ON mydb.users TO 'john'@'localhost';

-- Grant on specific columns
GRANT SELECT (id, username), UPDATE (email) ON mydb.users TO 'john'@'localhost';

-- Grant with GRANT OPTION (can grant to others)
GRANT SELECT ON mydb.* TO 'john'@'localhost' WITH GRANT OPTION;

-- Apply changes
FLUSH PRIVILEGES;

-- Show grants
SHOW GRANTS FOR 'john'@'localhost';
```

### PostgreSQL

```sql
-- Grant all privileges on database
GRANT ALL PRIVILEGES ON DATABASE mydb TO john;

-- Grant specific privileges on table
GRANT SELECT, INSERT, UPDATE ON users TO john;

-- Grant on all tables in schema
GRANT SELECT ON ALL TABLES IN SCHEMA public TO john;

-- Grant on future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT ON TABLES TO john;

-- Grant usage on schema
GRANT USAGE ON SCHEMA public TO john;

-- Show grants
\dp
SELECT * FROM information_schema.table_privileges WHERE grantee = 'john';
```

## REVOKE - Removing Permissions

### MySQL

```sql
-- Revoke all privileges
REVOKE ALL PRIVILEGES ON mydb.* FROM 'john'@'localhost';

-- Revoke specific privileges
REVOKE INSERT, UPDATE ON mydb.users FROM 'john'@'localhost';

-- Apply changes
FLUSH PRIVILEGES;
```

### PostgreSQL

```sql
-- Revoke all privileges
REVOKE ALL PRIVILEGES ON DATABASE mydb FROM john;

-- Revoke specific privileges
REVOKE INSERT, UPDATE ON users FROM john;

-- Revoke on all tables
REVOKE SELECT ON ALL TABLES IN SCHEMA public FROM john;
```

## Common Permission Levels

```sql
-- Read-only user
GRANT SELECT ON mydb.* TO 'reader'@'localhost';

-- Read-write user
GRANT SELECT, INSERT, UPDATE, DELETE ON mydb.* TO 'app_user'@'localhost';

-- Admin user (not root)
GRANT ALL PRIVILEGES ON mydb.* TO 'admin'@'localhost';

-- Super user (MySQL)
GRANT ALL PRIVILEGES ON *.* TO 'superuser'@'localhost' WITH GRANT OPTION;
```

## Roles (PostgreSQL)

Group permissions together.

```sql
-- Create role
CREATE ROLE readonly;
CREATE ROLE readwrite;

-- Grant privileges to role
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO readwrite;

-- Create user and assign role
CREATE USER john WITH PASSWORD 'password';
GRANT readonly TO john;

-- User can switch roles
SET ROLE readwrite;
RESET ROLE;

-- List roles
\du
```

## Roles (MySQL 8.0+)

```sql
-- Create role
CREATE ROLE 'app_read', 'app_write';

-- Grant privileges to role
GRANT SELECT ON mydb.* TO 'app_read';
GRANT INSERT, UPDATE, DELETE ON mydb.* TO 'app_write';

-- Create user and assign roles
CREATE USER 'john'@'localhost' IDENTIFIED BY 'password';
GRANT 'app_read' TO 'john'@'localhost';

-- Set default role
SET DEFAULT ROLE 'app_read' TO 'john'@'localhost';

-- Show roles
SHOW GRANTS FOR 'john'@'localhost';
```

## Application User Best Practices

```sql
-- ❌ Bad: Use root/postgres user
mysql -u root -p

-- ✅ Good: Create dedicated user per application
CREATE USER 'myapp'@'localhost' IDENTIFIED BY 'strong_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp_db.* TO 'myapp'@'localhost';

-- ✅ Best: Different users for different access levels
CREATE USER 'myapp_read'@'localhost' IDENTIFIED BY 'password1';
GRANT SELECT ON myapp_db.* TO 'myapp_read'@'localhost';

CREATE USER 'myapp_write'@'localhost' IDENTIFIED BY 'password2';
GRANT SELECT, INSERT, UPDATE, DELETE ON myapp_db.* TO 'myapp_write'@'localhost';
```

## Connection Security

### Require SSL/TLS

**MySQL:**
```sql
-- Require SSL for user
CREATE USER 'john'@'%' IDENTIFIED BY 'password' REQUIRE SSL;
ALTER USER 'john'@'%' REQUIRE SSL;

-- Require specific certificate
ALTER USER 'john'@'%' REQUIRE X509;
```

**PostgreSQL:**
```sql
-- In pg_hba.conf
hostssl all all 0.0.0.0/0 md5

-- Force SSL in postgresql.conf
ssl = on
ssl_cert_file = 'server.crt'
ssl_key_file = 'server.key'
```

### Limit Connections

**MySQL:**
```sql
-- Limit max connections per user
CREATE USER 'john'@'localhost' WITH MAX_USER_CONNECTIONS 10;
ALTER USER 'john'@'localhost' WITH MAX_USER_CONNECTIONS 5;
```

**PostgreSQL:**
```sql
-- Set connection limit
ALTER USER john CONNECTION LIMIT 10;
```

## Password Policies

**MySQL:**
```sql
-- Password expiration
CREATE USER 'john'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
ALTER USER 'john'@'localhost' PASSWORD EXPIRE INTERVAL 30 DAY;

-- Password history (can't reuse last 5 passwords)
SET GLOBAL password_history = 5;

-- Minimum password length
SET GLOBAL validate_password.length = 12;
```

**PostgreSQL:**
```sql
-- Password expiration
ALTER USER john VALID UNTIL '2025-12-31';

-- Force password change
ALTER USER john PASSWORD 'temp' VALID UNTIL 'now';
```

## IP Whitelisting

**MySQL:**
```sql
-- Allow from specific IP
CREATE USER 'john'@'192.168.1.100' IDENTIFIED BY 'password';

-- Allow from IP range
CREATE USER 'john'@'192.168.1.%' IDENTIFIED BY 'password';

-- Allow from any IP
CREATE USER 'john'@'%' IDENTIFIED BY 'password';
```

**PostgreSQL (pg_hba.conf):**
```conf
# TYPE  DATABASE  USER   ADDRESS          METHOD
host    mydb      john   192.168.1.0/24   md5
host    mydb      john   10.0.0.100/32    md5
```

## Auditing

**MySQL:**
```sql
-- Enable general query log
SET GLOBAL general_log = 'ON';
SET GLOBAL general_log_file = '/var/log/mysql/query.log';

-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;  -- Log queries > 2 seconds

-- View logs
SELECT * FROM mysql.general_log;
```

**PostgreSQL:**
```sql
-- Enable logging (postgresql.conf)
log_statement = 'all'  -- Log all statements
log_connections = on
log_disconnections = on

-- View logs
tail -f /var/log/postgresql/postgresql.log
```

## SQL Injection Prevention

```python
# ❌ BAD: SQL Injection vulnerability
user_input = "admin' OR '1'='1"
query = f"SELECT * FROM users WHERE username = '{user_input}'"
# Results in: SELECT * FROM users WHERE username = 'admin' OR '1'='1'

# ✅ GOOD: Use parameterized queries
cursor.execute("SELECT * FROM users WHERE username = %s", (user_input,))

# ✅ GOOD: Use ORM
from sqlalchemy import select
stmt = select(User).where(User.username == user_input)
```

## Least Privilege Principle

```sql
-- Application only needs SELECT, INSERT, UPDATE
-- ❌ Don't grant:
GRANT ALL PRIVILEGES ON mydb.* TO 'myapp'@'localhost';

-- ✅ Grant only what's needed:
GRANT SELECT, INSERT, UPDATE ON mydb.* TO 'myapp'@'localhost';

-- ❌ Don't grant DELETE if not needed
-- ❌ Don't grant DROP, ALTER, CREATE
-- ❌ Don't grant FILE, SUPER, PROCESS privileges
```

## Database Encryption

### Encrypt at Rest

**MySQL:**
```sql
-- Enable encryption (my.cnf)
innodb_encrypt_tables = ON
innodb_encrypt_log = ON
```

**PostgreSQL:**
```bash
# File system level encryption (LUKS, dm-crypt)
# Or use pgcrypto extension
```

### Encrypt Columns

**PostgreSQL:**
```sql
-- Install pgcrypto
CREATE EXTENSION pgcrypto;

-- Encrypt data
INSERT INTO users (email, password)
VALUES ('john@example.com', crypt('mypassword', gen_salt('bf')));

-- Verify password
SELECT * FROM users
WHERE email = 'john@example.com'
AND password = crypt('mypassword', password);
```

## Backup Security

```bash
# Encrypt backups
mysqldump -u root -p mydb | gzip | openssl enc -aes-256-cbc -salt > backup.sql.gz.enc

# Decrypt
openssl enc -aes-256-cbc -d -in backup.sql.gz.enc | gunzip | mysql -u root -p mydb

# Restrict backup file permissions
chmod 600 backup.sql
```

## Security Checklist

```sql
-- ✅ Remove default users
DROP USER 'root'@'%';  -- Keep only 'root'@'localhost'
DROP USER ''@'localhost';  -- Anonymous user

-- ✅ Strong passwords
-- Minimum 12 characters, mixed case, numbers, symbols

-- ✅ Limit remote access
-- Only allow from specific IPs

-- ✅ Use SSL/TLS
-- Encrypt data in transit

-- ✅ Regular updates
-- Keep database software updated

-- ✅ Least privilege
-- Grant minimal permissions needed

-- ✅ Audit logging
-- Enable and monitor logs

-- ✅ Backup encryption
-- Encrypt backup files

-- ✅ Disable unnecessary features
-- FILE privilege, LOAD DATA LOCAL INFILE

-- ✅ Firewall
-- Restrict database port access
```

## Common Security Mistakes

```sql
-- ❌ Using root in production
-- ✅ Create dedicated users

-- ❌ Weak passwords
-- ✅ Strong, unique passwords

-- ❌ No SSL/TLS
-- ✅ Encrypt connections

-- ❌ Open to internet (0.0.0.0)
-- ✅ Whitelist specific IPs

-- ❌ Same user for all apps
-- ✅ Different user per application

-- ❌ Storing passwords in plain text
-- ✅ Hash passwords (bcrypt, argon2)

-- ❌ Granting ALL PRIVILEGES
-- ✅ Grant only needed permissions

-- ❌ No audit logging
-- ✅ Enable and monitor logs
```

## Network Security

```bash
# Bind to localhost only (not public interface)
# MySQL (my.cnf):
bind-address = 127.0.0.1

# PostgreSQL (postgresql.conf):
listen_addresses = 'localhost'

# Firewall rules (allow only from app server)
ufw allow from 192.168.1.100 to any port 3306  # MySQL
ufw allow from 192.168.1.100 to any port 5432  # PostgreSQL
```

## Monitoring

```sql
-- MySQL: Show active connections
SHOW PROCESSLIST;
SELECT * FROM information_schema.processlist;

-- Kill suspicious connection
KILL 12345;

-- PostgreSQL: Show active connections
SELECT * FROM pg_stat_activity;

-- Terminate connection
SELECT pg_terminate_backend(12345);

-- Alert on failed logins (check logs)
grep "Access denied" /var/log/mysql/error.log
grep "authentication failed" /var/log/postgresql/postgresql.log
```
