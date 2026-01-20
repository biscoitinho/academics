# SQL Optimization and Best Practices

## Query Optimization Basics

### Use EXPLAIN

Always check execution plan before optimizing.

```sql
-- MySQL
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';

-- PostgreSQL
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'john@example.com';

-- SQLite
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = 'john@example.com';
```

### Select Only Needed Columns

```sql
-- ❌ Bad: Returns all columns
SELECT * FROM users;

-- ✅ Good: Returns only needed columns
SELECT id, username, email FROM users;

-- Benefit: Less data transferred, faster queries
```

### Limit Results

```sql
-- ❌ Bad: Returns all rows
SELECT * FROM users ORDER BY created_at DESC;

-- ✅ Good: Limit to needed rows
SELECT * FROM users ORDER BY created_at DESC LIMIT 10;
```

## Indexing for Performance

```sql
-- Create index on frequently queried columns
CREATE INDEX idx_email ON users(email);

-- Verify index is used
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';

-- Composite index for common query patterns
CREATE INDEX idx_country_city ON addresses(country, city);
```

## WHERE Clause Optimization

```sql
-- ✅ Good: Index can be used
SELECT * FROM users WHERE email = 'john@example.com';

-- ❌ Bad: Function on column prevents index use
SELECT * FROM users WHERE LOWER(email) = 'john@example.com';
-- Fix: Use functional index or store lowercase

-- ❌ Bad: Leading wildcard prevents index use
SELECT * FROM users WHERE email LIKE '%@gmail.com';

-- ✅ Good: Index can be used
SELECT * FROM users WHERE email LIKE 'john%';
```

## JOIN Optimization

```sql
-- ✅ Good: Index on join columns
CREATE INDEX idx_user_id ON orders(user_id);

SELECT u.name, o.total
FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- ❌ Bad: Joining large tables without filtering
SELECT * FROM users u
INNER JOIN orders o ON u.id = o.user_id;

-- ✅ Good: Filter before joining
SELECT u.name, o.total
FROM users u
INNER JOIN (
    SELECT * FROM orders WHERE created_at > '2024-01-01'
) o ON u.id = o.user_id;
```

## Subquery Optimization

```sql
-- ❌ Bad: Correlated subquery (runs for each row)
SELECT * FROM users WHERE (
    SELECT COUNT(*) FROM orders WHERE orders.user_id = users.id
) > 5;

-- ✅ Good: Use JOIN instead
SELECT u.*
FROM users u
INNER JOIN (
    SELECT user_id, COUNT(*) as order_count
    FROM orders
    GROUP BY user_id
    HAVING COUNT(*) > 5
) o ON u.id = o.user_id;

-- Or use EXISTS (often faster)
SELECT * FROM users u
WHERE EXISTS (
    SELECT 1 FROM orders o
    WHERE o.user_id = u.id
    GROUP BY o.user_id
    HAVING COUNT(*) > 5
);
```

## DISTINCT vs GROUP BY

```sql
-- ❌ Slower: DISTINCT on multiple columns
SELECT DISTINCT user_id, country FROM orders;

-- ✅ Faster: GROUP BY (especially with index)
SELECT user_id, country FROM orders GROUP BY user_id, country;
```

## Avoid SELECT DISTINCT When Possible

```sql
-- ❌ Bad: DISTINCT without need
SELECT DISTINCT user_id FROM orders;

-- ✅ Good: Use GROUP BY with aggregate
SELECT user_id, COUNT(*) as order_count
FROM orders
GROUP BY user_id;
```

## UNION vs UNION ALL

```sql
-- ❌ Slower: UNION removes duplicates
SELECT name FROM users
UNION
SELECT name FROM admins;

-- ✅ Faster: UNION ALL keeps duplicates (if acceptable)
SELECT name FROM users
UNION ALL
SELECT name FROM admins;
```

## Pagination Optimization

```sql
-- ❌ Bad: Deep pagination with OFFSET
SELECT * FROM users ORDER BY id LIMIT 10 OFFSET 10000;
-- Scans and discards 10,000 rows

-- ✅ Good: Cursor-based pagination
SELECT * FROM users
WHERE id > 10000  -- Last seen id
ORDER BY id
LIMIT 10;
```

## Batch Operations

```sql
-- ❌ Bad: Multiple single inserts
INSERT INTO users (name) VALUES ('Alice');
INSERT INTO users (name) VALUES ('Bob');
INSERT INTO users (name) VALUES ('Charlie');

-- ✅ Good: Batch insert
INSERT INTO users (name) VALUES
    ('Alice'),
    ('Bob'),
    ('Charlie');

-- ❌ Bad: Update in loop
UPDATE users SET active = 1 WHERE id = 1;
UPDATE users SET active = 1 WHERE id = 2;
UPDATE users SET active = 1 WHERE id = 3;

-- ✅ Good: Single update
UPDATE users SET active = 1 WHERE id IN (1, 2, 3);
```

## COUNT Optimization

```sql
-- ❌ Slow: COUNT(*) on large table
SELECT COUNT(*) FROM users;

-- ✅ Faster: Approximate count (PostgreSQL)
SELECT reltuples::bigint FROM pg_class WHERE relname = 'users';

-- ✅ Faster: Use cached count or counter table
CREATE TABLE table_counts (
    table_name VARCHAR(50),
    count INT,
    updated_at TIMESTAMP
);
```

## EXISTS vs IN

```sql
-- ✅ Faster: EXISTS (stops at first match)
SELECT * FROM users
WHERE EXISTS (
    SELECT 1 FROM orders WHERE orders.user_id = users.id
);

-- ❌ Slower: IN (evaluates all)
SELECT * FROM users
WHERE id IN (
    SELECT user_id FROM orders
);
```

## Avoid OR in WHERE

```sql
-- ❌ Bad: OR can prevent index use
SELECT * FROM users WHERE country = 'USA' OR country = 'UK';

-- ✅ Good: Use IN
SELECT * FROM users WHERE country IN ('USA', 'UK');

-- ❌ Bad: OR on different columns
SELECT * FROM users WHERE email = 'john@example.com' OR username = 'john';

-- ✅ Good: Split into UNION
SELECT * FROM users WHERE email = 'john@example.com'
UNION
SELECT * FROM users WHERE username = 'john';
```

## Denormalization for Read Performance

```sql
-- Instead of:
SELECT u.name, COUNT(o.id) as order_count
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id;

-- Store computed value:
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    order_count INT DEFAULT 0
);

-- Update with trigger
CREATE TRIGGER update_order_count
AFTER INSERT ON orders
FOR EACH ROW
BEGIN
    UPDATE users SET order_count = order_count + 1
    WHERE id = NEW.user_id;
END;
```

## Use Appropriate Data Types

```sql
-- ❌ Bad: Oversized types
CREATE TABLE users (
    id BIGINT,              -- INT is enough for most cases
    active VARCHAR(255)     -- BOOLEAN or TINYINT is better
);

-- ✅ Good: Right-sized types
CREATE TABLE users (
    id INT,
    active BOOLEAN
);
```

## Avoid Functions on Indexed Columns

```sql
-- ❌ Bad: Function prevents index use
SELECT * FROM users WHERE YEAR(created_at) = 2024;

-- ✅ Good: Use range
SELECT * FROM users
WHERE created_at >= '2024-01-01' AND created_at < '2025-01-01';
```

## Connection Pooling

```python
# ❌ Bad: New connection per query
import psycopg2

def get_user(user_id):
    conn = psycopg2.connect(...)  # Slow!
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    return cursor.fetchone()

# ✅ Good: Reuse connections
from psycopg2 import pool

connection_pool = pool.SimpleConnectionPool(1, 20, ...)

def get_user(user_id):
    conn = connection_pool.getconn()
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
    result = cursor.fetchone()
    connection_pool.putconn(conn)
    return result
```

## Query Caching

```python
# Application-level caching
import redis
r = redis.Redis()

def get_user(user_id):
    # Check cache first
    cached = r.get(f'user:{user_id}')
    if cached:
        return json.loads(cached)

    # Query database
    result = db.query("SELECT * FROM users WHERE id = %s", user_id)

    # Cache result
    r.setex(f'user:{user_id}', 3600, json.dumps(result))

    return result
```

## Database Configuration

**MySQL:**
```sql
-- Increase buffer pool size (70-80% of RAM for dedicated server)
SET GLOBAL innodb_buffer_pool_size = 2147483648;  -- 2GB

-- Query cache (MySQL < 8.0)
SET GLOBAL query_cache_size = 67108864;  -- 64MB

-- Max connections
SET GLOBAL max_connections = 200;
```

**PostgreSQL:**
```sql
-- Shared buffers (25% of RAM)
shared_buffers = 2GB

-- Work mem (per query operation)
work_mem = 4MB

-- Maintenance work mem (for VACUUM, CREATE INDEX)
maintenance_work_mem = 512MB

-- Max connections
max_connections = 200
```

## Best Practices

### 1. Always Use Prepared Statements

```python
# ❌ Bad: SQL injection risk
query = f"SELECT * FROM users WHERE email = '{email}'"

# ✅ Good: Prevents SQL injection
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

### 2. Use Transactions for Multiple Writes

```sql
BEGIN;
INSERT INTO orders (user_id, total) VALUES (1, 100);
UPDATE users SET order_count = order_count + 1 WHERE id = 1;
COMMIT;
```

### 3. Regular Maintenance

```sql
-- MySQL
OPTIMIZE TABLE users;
ANALYZE TABLE users;

-- PostgreSQL
VACUUM ANALYZE users;
REINDEX TABLE users;

-- SQLite
VACUUM;
ANALYZE;
```

### 4. Monitor Slow Queries

**MySQL:**
```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;  -- Log queries > 1 second

-- Check slow queries
SHOW FULL PROCESSLIST;
```

**PostgreSQL:**
```sql
-- Enable logging
SET log_min_duration_statement = 1000;  -- Log queries > 1 second

-- View slow queries
SELECT * FROM pg_stat_statements
ORDER BY total_time DESC
LIMIT 10;
```

### 5. Avoid N+1 Query Problem

```python
# ❌ Bad: N+1 queries
users = db.query("SELECT * FROM users")
for user in users:
    orders = db.query("SELECT * FROM orders WHERE user_id = %s", user.id)

# ✅ Good: Single query with JOIN
results = db.query("""
    SELECT u.*, o.id as order_id, o.total
    FROM users u
    LEFT JOIN orders o ON u.id = o.user_id
""")
```

### 6. Use Read Replicas

```python
# Write to master
master_db.execute("INSERT INTO users (name) VALUES (%s)", ('Alice',))

# Read from replica
users = replica_db.query("SELECT * FROM users")
```

### 7. Partition Large Tables

```sql
-- Partition by date range
CREATE TABLE orders (
    id INT,
    order_date DATE,
    amount DECIMAL
)
PARTITION BY RANGE (YEAR(order_date)) (
    PARTITION p2023 VALUES LESS THAN (2024),
    PARTITION p2024 VALUES LESS THAN (2025)
);
```

### 8. Use Covering Indexes

```sql
-- Query needs: email, name
CREATE INDEX idx_email_name ON users(email, name);

-- This query uses only the index (no table lookup)
SELECT name FROM users WHERE email = 'john@example.com';
```

### 9. Avoid Using LIKE with Leading Wildcard

```sql
-- ❌ Can't use index
SELECT * FROM users WHERE email LIKE '%@gmail.com';

-- ✅ Can use index
SELECT * FROM users WHERE email LIKE 'john%';

-- For full-text search, use:
-- MySQL: FULLTEXT index
-- PostgreSQL: GIN index with tsvector
-- SQLite: FTS5
```

### 10. Normalize for Writes, Denormalize for Reads

```sql
-- Normalized (good for INSERT/UPDATE)
users: id, name
orders: id, user_id, total

-- Denormalized (good for SELECT)
orders: id, user_id, user_name, total

-- Choose based on your workload (more reads or more writes?)
```
