# SQL Tooling

Recommended tools for working with SQL and databases.

## Database Clients (CLI)

### psql (PostgreSQL)
Interactive terminal for PostgreSQL.

```bash
# Connect to database
psql -U username -d dbname -h localhost

# Common meta-commands
\l          # List databases
\dt         # List tables
\d tablename  # Describe table
\di         # List indexes
\df         # List functions
\x          # Toggle expanded output
\timing     # Toggle query timing
\i file.sql # Execute SQL file
\q          # Quit
```

### mysql / mariadb
CLI client for MySQL/MariaDB.

```bash
# Connect
mysql -u username -p dbname

# Common commands
SHOW DATABASES;
SHOW TABLES;
DESCRIBE tablename;
SOURCE file.sql;
```

### sqlite3
CLI for SQLite databases.

```bash
# Open or create database
sqlite3 mydb.db

# Commands
.tables
.schema tablename
.mode column
.headers on
.import file.csv tablename
.quit
```

## GUI Clients

### DBeaver
Free, open-source. Supports all major databases. Best general-purpose SQL GUI.

- Visual query builder
- ER diagram generation
- Data export/import
- Supports PostgreSQL, MySQL, SQLite, Oracle, SQL Server, and many more

### pgAdmin
PostgreSQL-specific GUI. Web-based interface.

- Dashboard with server metrics
- Query tool with explain visualization
- Backup and restore

### DataGrip
JetBrains commercial IDE for databases. Excellent code completion and refactoring.

### TablePlus
Lightweight, native GUI. Fast and clean interface. macOS, Windows, Linux.

## Query Development

### EXPLAIN / EXPLAIN ANALYZE
Built-in query plan analysis. Essential for optimization.

```sql
-- Show query plan
EXPLAIN SELECT * FROM users WHERE email = 'test@example.com';

-- Show plan with actual execution stats (PostgreSQL)
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'test@example.com';

-- Verbose plan with costs
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM users WHERE email = 'test@example.com';
```

### pg_stat_statements (PostgreSQL)
Extension for tracking query statistics across all queries.

```sql
-- Enable
CREATE EXTENSION pg_stat_statements;

-- View slowest queries
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;
```

## Linting and Formatting

### sqlfluff
SQL linter and formatter. Supports multiple dialects.

```bash
pip install sqlfluff

# Lint
sqlfluff lint query.sql --dialect postgres

# Fix
sqlfluff fix query.sql --dialect postgres

# Format
sqlfluff format query.sql --dialect postgres
```

Configuration in `.sqlfluff`:
```ini
[sqlfluff]
dialect = postgres
max_line_length = 120

[sqlfluff:rules:capitalisation.keywords]
capitalisation_policy = upper
```

### sqlfmt
Opinionated SQL formatter (like black for Python).

```bash
pip install shandy-sqlfmt
sqlfmt query.sql
```

### pgFormatter
PostgreSQL-specific formatter.

```bash
pg_format query.sql
```

## Migration Tools

### dbmate
Database-agnostic migration tool. Simple and lightweight.

```bash
# Create migration
dbmate new create_users_table

# Run migrations
dbmate up

# Rollback
dbmate down

# Status
dbmate status
```

### Flyway
Java-based migration tool. Widely used in enterprise.

```bash
flyway migrate
flyway info
flyway validate
```

### Liquibase
XML/YAML/JSON-based database changelog management.

### sqitch
Change management system for databases. Uses native SQL scripts.

```bash
sqitch init myproject
sqitch add create_users -n "Add users table"
sqitch deploy
sqitch revert
```

### Framework-Specific
- **Rails**: ActiveRecord Migrations (`rails db:migrate`)
- **Django**: Django Migrations (`python manage.py migrate`)
- **Alembic**: SQLAlchemy migrations for Python
- **Knex.js**: Node.js query builder with migrations

## Testing

### pgTAP (PostgreSQL)
Unit testing framework for PostgreSQL written in PL/pgSQL.

```sql
SELECT plan(2);

SELECT has_table('users');
SELECT has_column('users', 'email');

SELECT finish();
```

### tSQLt (SQL Server)
Unit testing framework for SQL Server.

### Application-Level Testing
Most commonly, SQL is tested through application test frameworks:

```python
# Python with pytest
def test_user_creation(db_session):
    user = User(name="Alice", email="alice@example.com")
    db_session.add(user)
    db_session.commit()
    assert db_session.query(User).count() == 1
```

## Data Tools

### pgdump / pg_restore (PostgreSQL)
Backup and restore databases.

```bash
# Backup
pg_dump -U username dbname > backup.sql
pg_dump -Fc dbname > backup.dump   # Custom format (compressed)

# Restore
psql -U username dbname < backup.sql
pg_restore -d dbname backup.dump
```

### mysqldump (MySQL)
```bash
mysqldump -u username -p dbname > backup.sql
```

### csvkit
Command-line tools for working with CSV and databases.

```bash
# Import CSV to database
csvsql --db postgresql:///mydb --insert data.csv

# Query CSV with SQL
csvsql --query "SELECT * FROM data WHERE age > 30" data.csv
```

## Monitoring

### pg_stat_activity (PostgreSQL)
View currently running queries.

```sql
SELECT pid, state, query, query_start
FROM pg_stat_activity
WHERE state != 'idle'
ORDER BY query_start;
```

### pgbadger (PostgreSQL)
Log analyzer that generates detailed reports on query performance.

### Percona Monitoring and Management (MySQL)
Open-source monitoring platform for MySQL.

## Recommended Stack

| Purpose | Tool |
|---------|------|
| CLI client | psql / mysql / sqlite3 |
| GUI client | DBeaver (free) or DataGrip (paid) |
| Linting + formatting | sqlfluff |
| Migrations | dbmate (standalone) or framework-specific |
| Query analysis | EXPLAIN ANALYZE |
| Backups | pg_dump / mysqldump |
| Testing | pgTAP or application-level tests |
| Monitoring | pg_stat_statements + pg_stat_activity |
