# MySQL vs PostgreSQL vs SQLite3

## Overview

| Feature | MySQL | PostgreSQL | SQLite3 |
|---------|-------|------------|---------|
| Type | Client-Server | Client-Server | Embedded |
| License | GPL/Commercial | PostgreSQL (MIT-like) | Public Domain |
| ACID | Yes | Yes | Yes |
| Size | Medium | Large | Tiny (~600KB) |
| Best For | Web apps, read-heavy | Complex queries, data integrity | Mobile, embedded, dev |

## Installation & Connection

**MySQL:**
```bash
# Install
sudo apt install mysql-server

# Connect
mysql -u root -p

# Connection string
mysql://user:password@localhost:3306/database
```

**PostgreSQL:**
```bash
# Install
sudo apt install postgresql

# Connect
psql -U postgres

# Connection string
postgresql://user:password@localhost:5432/database
```

**SQLite3:**
```bash
# Install
sudo apt install sqlite3

# Connect (creates file if doesn't exist)
sqlite3 mydb.db

# No server needed - just a file!
```

## Data Types

**MySQL:**
```sql
INT, BIGINT, SMALLINT
VARCHAR(n), CHAR(n), TEXT
DECIMAL(p,s), FLOAT, DOUBLE
DATE, DATETIME, TIMESTAMP
BLOB
ENUM('val1', 'val2')
JSON (MySQL 5.7+)
```

**PostgreSQL:**
```sql
INTEGER, BIGINT, SMALLINT
VARCHAR(n), CHAR(n), TEXT
NUMERIC(p,s), REAL, DOUBLE PRECISION
DATE, TIMESTAMP, TIMESTAMPTZ
BYTEA
ARRAY, HSTORE, JSON, JSONB
UUID, INET, CIDR
ENUM (custom type)
```

**SQLite3:**
```sql
INTEGER, REAL, TEXT, BLOB
-- SQLite uses dynamic typing
-- No VARCHAR(n), just TEXT
-- No separate DATE type (stored as TEXT/INTEGER/REAL)
```

## Auto-Increment

**MySQL:**
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50)
);
```

**PostgreSQL:**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

-- Or with IDENTITY (PostgreSQL 10+)
CREATE TABLE users (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR(50)
);
```

**SQLite3:**
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT
);

-- Or simpler (uses ROWID)
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT
);
```

## String Concatenation

**MySQL:**
```sql
SELECT CONCAT(first_name, ' ', last_name) FROM users;
```

**PostgreSQL:**
```sql
SELECT first_name || ' ' || last_name FROM users;
-- or
SELECT CONCAT(first_name, ' ', last_name) FROM users;
```

**SQLite3:**
```sql
SELECT first_name || ' ' || last_name FROM users;
```

## LIMIT / OFFSET

**MySQL:**
```sql
SELECT * FROM users LIMIT 10 OFFSET 20;
-- or
SELECT * FROM users LIMIT 20, 10;  -- offset, limit
```

**PostgreSQL:**
```sql
SELECT * FROM users LIMIT 10 OFFSET 20;
```

**SQLite3:**
```sql
SELECT * FROM users LIMIT 10 OFFSET 20;
```

## Date Functions

**MySQL:**
```sql
SELECT NOW();
SELECT CURDATE();
SELECT DATE_ADD(created_at, INTERVAL 1 DAY);
SELECT DATEDIFF(date1, date2);
```

**PostgreSQL:**
```sql
SELECT NOW();
SELECT CURRENT_DATE;
SELECT created_at + INTERVAL '1 day';
SELECT date1 - date2;  -- Returns interval
SELECT AGE(date1, date2);
```

**SQLite3:**
```sql
SELECT datetime('now');
SELECT date('now');
SELECT datetime(created_at, '+1 day');
SELECT julianday(date1) - julianday(date2);
```

## UPSERT (Insert or Update)

**MySQL:**
```sql
-- ON DUPLICATE KEY UPDATE
INSERT INTO users (id, name, email)
VALUES (1, 'John', 'john@example.com')
ON DUPLICATE KEY UPDATE name = 'John', email = 'john@example.com';

-- REPLACE (deletes then inserts)
REPLACE INTO users (id, name, email)
VALUES (1, 'John', 'john@example.com');
```

**PostgreSQL:**
```sql
-- ON CONFLICT
INSERT INTO users (id, name, email)
VALUES (1, 'John', 'john@example.com')
ON CONFLICT (id)
DO UPDATE SET name = 'John', email = 'john@example.com';
```

**SQLite3:**
```sql
-- ON CONFLICT
INSERT INTO users (id, name, email)
VALUES (1, 'John', 'john@example.com')
ON CONFLICT(id)
DO UPDATE SET name = 'John', email = 'john@example.com';

-- Or REPLACE
REPLACE INTO users (id, name, email)
VALUES (1, 'John', 'john@example.com');
```

## JSON Support

**MySQL (5.7+):**
```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    data JSON
);

INSERT INTO users VALUES (1, '{"name": "John", "age": 30}');

SELECT JSON_EXTRACT(data, '$.name') FROM users;
SELECT data->'$.name' FROM users;  -- MySQL 8.0+
```

**PostgreSQL:**
```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    data JSONB  -- JSONB is binary, faster
);

INSERT INTO users VALUES (1, '{"name": "John", "age": 30}');

SELECT data->>'name' FROM users;  -- Returns text
SELECT data->'name' FROM users;   -- Returns json
SELECT * FROM users WHERE data->>'age' = '30';
```

**SQLite3 (3.38+):**
```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    data TEXT  -- JSON stored as text
);

INSERT INTO users VALUES (1, '{"name": "John", "age": 30}');

SELECT json_extract(data, '$.name') FROM users;
SELECT data->'$.name' FROM users;  -- SQLite 3.38+
```

## Full-Text Search

**MySQL:**
```sql
CREATE FULLTEXT INDEX idx_content ON articles(content);

SELECT * FROM articles
WHERE MATCH(content) AGAINST('search term');
```

**PostgreSQL:**
```sql
-- Using tsvector
CREATE INDEX idx_content ON articles
USING gin(to_tsvector('english', content));

SELECT * FROM articles
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'search & term');
```

**SQLite3:**
```sql
-- Create FTS5 table
CREATE VIRTUAL TABLE articles_fts USING fts5(content);

INSERT INTO articles_fts VALUES ('search term content');

SELECT * FROM articles_fts WHERE articles_fts MATCH 'search term';
```

## Window Functions

**MySQL (8.0+):**
```sql
SELECT name, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as rank
FROM employees;
```

**PostgreSQL:**
```sql
SELECT name, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as rank,
    LAG(salary) OVER (ORDER BY salary DESC) as prev_salary
FROM employees;
```

**SQLite3 (3.25+):**
```sql
SELECT name, salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) as rank
FROM employees;
```

## Common Table Expressions (CTE)

**MySQL (8.0+):**
```sql
WITH high_earners AS (
    SELECT * FROM employees WHERE salary > 100000
)
SELECT * FROM high_earners;
```

**PostgreSQL:**
```sql
WITH RECURSIVE tree AS (
    SELECT id, parent_id, name FROM categories WHERE parent_id IS NULL
    UNION ALL
    SELECT c.id, c.parent_id, c.name
    FROM categories c
    JOIN tree t ON c.parent_id = t.id
)
SELECT * FROM tree;
```

**SQLite3:**
```sql
WITH high_earners AS (
    SELECT * FROM employees WHERE salary > 100000
)
SELECT * FROM high_earners;
```

## Performance & Features

**MySQL Strengths:**
- Fast read operations
- Replication (master-slave)
- Easy to learn and use
- Wide hosting support
- InnoDB engine (ACID compliant)

**PostgreSQL Strengths:**
- Advanced SQL features
- Better for complex queries
- Strong ACID compliance
- Better concurrency (MVCC)
- Rich data types (arrays, JSON, etc.)
- PostGIS for geographic data
- Better for analytics

**SQLite3 Strengths:**
- Zero configuration
- Single file database
- Perfect for embedded systems
- Great for development/testing
- Small footprint
- ACID compliant
- Cross-platform

## When to Use Each

**Use MySQL when:**
- Building web applications
- Need simple, fast read-heavy workloads
- Want wide hosting compatibility
- Team is familiar with MySQL
- Need good replication

**Use PostgreSQL when:**
- Need advanced SQL features
- Complex queries and analytics
- Strict data integrity requirements
- Need custom data types
- Geographic data (PostGIS)
- Better concurrent writes

**Use SQLite3 when:**
- Mobile applications (iOS, Android)
- Embedded systems
- Development/testing
- Small-to-medium websites
- Desktop applications
- Single-user applications
- Data analysis (with pandas)

## Common Commands Comparison

| Operation | MySQL | PostgreSQL | SQLite3 |
|-----------|-------|------------|---------|
| List databases | `SHOW DATABASES;` | `\l` | `.databases` |
| Use database | `USE dbname;` | `\c dbname` | (open file) |
| List tables | `SHOW TABLES;` | `\dt` | `.tables` |
| Describe table | `DESCRIBE table;` | `\d table` | `.schema table` |
| Show table schema | `SHOW CREATE TABLE t;` | `\d+ table` | `.schema table` |
| Quit | `exit` or `quit` | `\q` | `.quit` or `.exit` |

## Migration Considerations

```sql
-- MySQL to PostgreSQL
-- 1. AUTOINCREMENT → SERIAL
-- 2. LIMIT x, y → LIMIT y OFFSET x
-- 3. ` backticks → " double quotes (or omit)
-- 4. Check date/time functions

-- PostgreSQL to MySQL
-- 1. :: casts → CAST() function
-- 2. RETURNING clause → not supported
-- 3. Array types → JSON or separate tables
-- 4. JSONB → JSON

-- SQLite3 to MySQL/PostgreSQL
-- 1. Dynamic typing → strict types
-- 2. Date storage → proper DATE/TIMESTAMP
-- 3. No stored procedures → reimplement
```
