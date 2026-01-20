# Database Migrations

## What are Migrations?

Migrations are version-controlled database schema changes. They allow you to:
- Track database changes over time
- Apply changes consistently across environments
- Rollback changes if needed
- Collaborate with team on schema changes

## Basic Concept

```
Version 1: CREATE TABLE users
Version 2: ADD COLUMN email
Version 3: CREATE INDEX on email
Version 4: ADD COLUMN phone
```

Each migration has:
- **Up**: Apply change
- **Down**: Revert change

## Manual Migrations

### Simple Versioning

```bash
# File structure
migrations/
  001_create_users.sql
  002_add_email.sql
  003_add_index.sql
```

**001_create_users.sql:**
```sql
-- Up
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL
);

-- Down (in separate file or comments)
-- DROP TABLE users;
```

**002_add_email.sql:**
```sql
-- Up
ALTER TABLE users ADD COLUMN email VARCHAR(100);

-- Down
-- ALTER TABLE users DROP COLUMN email;
```

### Migration Tracking Table

```sql
CREATE TABLE schema_migrations (
    version VARCHAR(50) PRIMARY KEY,
    applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Track applied migrations
INSERT INTO schema_migrations (version) VALUES ('001_create_users');
INSERT INTO schema_migrations (version) VALUES ('002_add_email');

-- Check applied migrations
SELECT * FROM schema_migrations ORDER BY version;
```

### Simple Migration Script

```bash
#!/bin/bash
# apply_migration.sh

MIGRATION_FILE=$1

# Check if already applied
VERSION=$(basename $MIGRATION_FILE .sql)
EXISTS=$(mysql -u root -p -D mydb -se "SELECT COUNT(*) FROM schema_migrations WHERE version='$VERSION'")

if [ "$EXISTS" -eq "1" ]; then
    echo "Migration $VERSION already applied"
    exit 0
fi

# Apply migration
mysql -u root -p -D mydb < $MIGRATION_FILE

# Record migration
mysql -u root -p -D mydb -e "INSERT INTO schema_migrations (version) VALUES ('$VERSION')"

echo "Migration $VERSION applied"
```

## Migration Tools

### Flyway (Java-based)

**Installation:**
```bash
# Download from https://flywaydb.org
# Or use Docker
docker run --rm flyway/flyway info
```

**File Structure:**
```
sql/
  V1__create_users.sql
  V2__add_email.sql
  V3__create_orders.sql
```

**V1__create_users.sql:**
```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL
);
```

**V2__add_email.sql:**
```sql
ALTER TABLE users ADD COLUMN email VARCHAR(100);
```

**Configuration (flyway.conf):**
```properties
flyway.url=jdbc:mysql://localhost:3306/mydb
flyway.user=root
flyway.password=password
flyway.locations=filesystem:./sql
```

**Commands:**
```bash
# Show migration status
flyway info

# Apply migrations
flyway migrate

# Validate migrations
flyway validate

# Undo last migration (paid version)
flyway undo
```

### Liquibase (Java-based)

**Installation:**
```bash
# Download from https://www.liquibase.org
# Or use Docker
docker run --rm liquibase/liquibase --version
```

**Changelog (XML format):**
```xml
<!-- changelog.xml -->
<databaseChangeLog xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
                   http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-4.0.xsd">

    <changeSet id="1" author="john">
        <createTable tableName="users">
            <column name="id" type="int" autoIncrement="true">
                <constraints primaryKey="true"/>
            </column>
            <column name="username" type="varchar(50)">
                <constraints nullable="false"/>
            </column>
        </createTable>
    </changeSet>

    <changeSet id="2" author="john">
        <addColumn tableName="users">
            <column name="email" type="varchar(100)"/>
        </addColumn>
    </changeSet>

</databaseChangeLog>
```

**Changelog (SQL format):**
```sql
-- liquibase formatted sql

-- changeset john:1
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL
);

-- changeset john:2
ALTER TABLE users ADD COLUMN email VARCHAR(100);
```

**Configuration (liquibase.properties):**
```properties
url=jdbc:mysql://localhost:3306/mydb
username=root
password=password
changeLogFile=changelog.xml
```

**Commands:**
```bash
# Show status
liquibase status

# Apply migrations
liquibase update

# Rollback last change
liquibase rollback-count 1

# Rollback to specific tag
liquibase rollback v1.0

# Generate SQL without applying
liquibase update-sql
```

### Alembic (Python)

**Installation:**
```bash
pip install alembic
```

**Initialize:**
```bash
alembic init migrations
```

**Configuration (alembic.ini):**
```ini
sqlalchemy.url = mysql://root:password@localhost/mydb
```

**Create Migration:**
```bash
# Auto-generate from SQLAlchemy models
alembic revision --autogenerate -m "create users table"

# Create empty migration
alembic revision -m "add email column"
```

**Migration File:**
```python
# migrations/versions/001_create_users.py
from alembic import op
import sqlalchemy as sa

# revision identifiers
revision = '001'
down_revision = None

def upgrade():
    op.create_table(
        'users',
        sa.Column('id', sa.Integer, primary_key=True),
        sa.Column('username', sa.String(50), nullable=False)
    )

def downgrade():
    op.drop_table('users')
```

**Commands:**
```bash
# Show current version
alembic current

# Apply migrations
alembic upgrade head

# Apply specific version
alembic upgrade +1

# Rollback
alembic downgrade -1

# Show migration history
alembic history

# Generate SQL without applying
alembic upgrade head --sql
```

### Django Migrations

**Create Migration:**
```bash
# Auto-generate from models
python manage.py makemigrations

# Create empty migration
python manage.py makemigrations --empty myapp
```

**Migration File:**
```python
# myapp/migrations/0001_initial.py
from django.db import migrations, models

class Migration(migrations.Migration):
    initial = True

    dependencies = []

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(primary_key=True)),
                ('username', models.CharField(max_length=50)),
                ('email', models.EmailField()),
            ],
        ),
    ]
```

**Commands:**
```bash
# Show migrations
python manage.py showmigrations

# Apply migrations
python manage.py migrate

# Rollback
python manage.py migrate myapp 0001

# Generate SQL
python manage.py sqlmigrate myapp 0001
```

### Rails Migrations

**Create Migration:**
```bash
rails generate migration CreateUsers
rails generate migration AddEmailToUsers email:string
```

**Migration File:**
```ruby
# db/migrate/20240101120000_create_users.rb
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.timestamps
    end
  end
end
```

**Commands:**
```bash
# Apply migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Rollback multiple
rails db:rollback STEP=3

# Show status
rails db:migrate:status

# Redo last migration
rails db:migrate:redo
```

## Migration Best Practices

### 1. Never Modify Existing Migrations

```sql
-- ❌ Bad: Editing 001_create_users.sql after applied
ALTER TABLE users ADD COLUMN email VARCHAR(100);

-- ✅ Good: Create new migration
-- 002_add_email.sql
ALTER TABLE users ADD COLUMN email VARCHAR(100);
```

### 2. One Change Per Migration

```sql
-- ❌ Bad: Multiple unrelated changes
-- 001_multiple_changes.sql
CREATE TABLE users (...);
CREATE TABLE products (...);
ALTER TABLE orders ADD COLUMN status VARCHAR(20);

-- ✅ Good: Separate migrations
-- 001_create_users.sql
CREATE TABLE users (...);

-- 002_create_products.sql
CREATE TABLE products (...);

-- 003_add_order_status.sql
ALTER TABLE orders ADD COLUMN status VARCHAR(20);
```

### 3. Always Test Rollback

```sql
-- Test both directions
-- Up
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Down
ALTER TABLE users DROP COLUMN phone;

-- Verify: apply, rollback, apply again
```

### 4. Use Transactions

```sql
-- Wrap in transaction
BEGIN;

CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL
);

CREATE INDEX idx_username ON users(username);

COMMIT;
```

### 5. Make Migrations Idempotent

```sql
-- ✅ Good: Safe to run multiple times
CREATE TABLE IF NOT EXISTS users (...);
ALTER TABLE users ADD COLUMN IF NOT EXISTS email VARCHAR(100);
DROP TABLE IF EXISTS temp_table;

-- MySQL: Use conditional logic
DELIMITER //
CREATE PROCEDURE add_email_column()
BEGIN
    IF NOT EXISTS (
        SELECT * FROM information_schema.columns
        WHERE table_name = 'users' AND column_name = 'email'
    ) THEN
        ALTER TABLE users ADD COLUMN email VARCHAR(100);
    END IF;
END//
DELIMITER ;
CALL add_email_column();
DROP PROCEDURE add_email_column;
```

### 6. Handle Data Migration

```sql
-- Migration with data transformation
BEGIN;

-- Add new column
ALTER TABLE users ADD COLUMN full_name VARCHAR(100);

-- Migrate data
UPDATE users SET full_name = CONCAT(first_name, ' ', last_name);

-- Make it required
ALTER TABLE users MODIFY COLUMN full_name VARCHAR(100) NOT NULL;

-- Remove old columns
ALTER TABLE users DROP COLUMN first_name;
ALTER TABLE users DROP COLUMN last_name;

COMMIT;
```

### 7. Avoid Downtime

```sql
-- ❌ Bad: Causes downtime
ALTER TABLE users DROP COLUMN old_column;

-- ✅ Good: Multi-step migration
-- Step 1: Make column nullable (deploy code that doesn't use it)
ALTER TABLE users MODIFY COLUMN old_column VARCHAR(100) NULL;

-- Step 2: Drop column (after code deployed)
ALTER TABLE users DROP COLUMN old_column;
```

## Common Migration Patterns

### Adding Column with Default

```sql
-- Add column
ALTER TABLE users ADD COLUMN status VARCHAR(20);

-- Set default for existing rows
UPDATE users SET status = 'active' WHERE status IS NULL;

-- Make it NOT NULL
ALTER TABLE users MODIFY COLUMN status VARCHAR(20) NOT NULL DEFAULT 'active';
```

### Renaming Column

```sql
-- MySQL 8.0+
ALTER TABLE users RENAME COLUMN old_name TO new_name;

-- PostgreSQL
ALTER TABLE users RENAME COLUMN old_name TO new_name;

-- Older MySQL: Copy and drop
ALTER TABLE users ADD COLUMN new_name VARCHAR(100);
UPDATE users SET new_name = old_name;
ALTER TABLE users DROP COLUMN old_name;
```

### Changing Column Type

```sql
-- Small table: Direct change
ALTER TABLE users MODIFY COLUMN age BIGINT;

-- Large table: Multi-step
-- 1. Add new column
ALTER TABLE users ADD COLUMN age_new BIGINT;

-- 2. Copy data
UPDATE users SET age_new = age;

-- 3. Drop old, rename new
ALTER TABLE users DROP COLUMN age;
ALTER TABLE users RENAME COLUMN age_new TO age;
```

### Adding Foreign Key

```sql
-- Add column
ALTER TABLE orders ADD COLUMN user_id INT;

-- Populate data
UPDATE orders o
SET user_id = (SELECT id FROM users WHERE users.email = o.user_email)
WHERE o.user_id IS NULL;

-- Add constraint
ALTER TABLE orders
ADD CONSTRAINT fk_user
FOREIGN KEY (user_id) REFERENCES users(id);
```

### Creating Index (Large Table)

```sql
-- MySQL: Online DDL (non-blocking in 5.6+)
ALTER TABLE users ADD INDEX idx_email (email), ALGORITHM=INPLACE, LOCK=NONE;

-- PostgreSQL: Concurrent index
CREATE INDEX CONCURRENTLY idx_email ON users(email);
```

## Migration Strategies

### Blue-Green Deployment

```sql
-- 1. Deploy new version to green environment
-- 2. Run migrations on separate database
-- 3. Switch traffic to green
-- 4. Keep blue for rollback
```

### Backward Compatible Migrations

```sql
-- Version 1: Code uses old_column
-- Migration: Add new_column (but don't remove old)
ALTER TABLE users ADD COLUMN new_column VARCHAR(100);

-- Version 2: Code uses new_column
-- Deploy code

-- Migration: Remove old_column
ALTER TABLE users DROP COLUMN old_column;
```

### Feature Flags

```sql
-- Add column for new feature
ALTER TABLE users ADD COLUMN beta_feature BOOLEAN DEFAULT FALSE;

-- Enable for specific users
UPDATE users SET beta_feature = TRUE WHERE id IN (1, 2, 3);

-- After testing: enable for all
UPDATE users SET beta_feature = TRUE;
```

## Troubleshooting

### Migration Failed

```bash
# Check current version
alembic current  # Alembic
flyway info      # Flyway

# Manual fix in database
mysql -u root -p mydb

# Mark migration as applied (if fixed manually)
INSERT INTO schema_migrations (version) VALUES ('001');
```

### Rollback Failed

```sql
-- Check what's blocking
SHOW PROCESSLIST;  -- MySQL
SELECT * FROM pg_stat_activity;  -- PostgreSQL

-- Kill blocking queries
KILL 12345;  -- MySQL
SELECT pg_terminate_backend(12345);  -- PostgreSQL

-- Try rollback again
```

### Merge Conflicts

```bash
# Two developers created migrations with same version
migrations/
  001_add_email.sql    (from dev A)
  001_add_phone.sql    (from dev B)

# Rename one to next version
mv 001_add_phone.sql 002_add_phone.sql
```

## Migration Checklist

```sql
-- Before creating migration:
-- ✅ Is change necessary?
-- ✅ Will it affect existing data?
-- ✅ Can it be rolled back?
-- ✅ Will it cause downtime?

-- After creating migration:
-- ✅ Test on development database
-- ✅ Test rollback
-- ✅ Review with team
-- ✅ Test on staging
-- ✅ Backup production before applying
-- ✅ Have rollback plan
-- ✅ Monitor after applying
```

## Example: Complete Migration Workflow

```bash
# 1. Create migration
alembic revision -m "add user email"

# 2. Edit migration file
# migrations/versions/001_add_email.py

# 3. Test locally
alembic upgrade head
alembic downgrade -1
alembic upgrade head

# 4. Commit to version control
git add migrations/versions/001_add_email.py
git commit -m "Add user email migration"

# 5. Apply to staging
alembic upgrade head

# 6. Test on staging
# Verify application works

# 7. Backup production
mysqldump -u root -p mydb > backup_before_migration.sql

# 8. Apply to production
alembic upgrade head

# 9. Monitor
# Check application logs
# Check database performance

# 10. Rollback if issues
alembic downgrade -1
```
