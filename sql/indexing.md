# Database Indexing

## What is an Index?

An index is a data structure that improves query speed by creating a quick lookup table. Like a book index - instead of reading every page to find a topic, you check the index.

**Trade-offs:**
- ✅ Faster SELECT queries
- ✅ Faster WHERE, JOIN, ORDER BY
- ❌ Slower INSERT, UPDATE, DELETE
- ❌ Extra storage space

## Creating Indexes

```sql
-- Basic index
CREATE INDEX idx_email ON users(email);

-- Unique index
CREATE UNIQUE INDEX idx_username ON users(username);

-- Composite index (multiple columns)
CREATE INDEX idx_name_age ON users(last_name, first_name, age);

-- Drop index
DROP INDEX idx_email ON users;  -- MySQL
DROP INDEX idx_email;            -- PostgreSQL, SQLite
```

## Index Types

### B-Tree Index (Default)

Best for equality and range queries.

```sql
CREATE INDEX idx_age ON users(age);

-- Good for:
SELECT * FROM users WHERE age = 25;
SELECT * FROM users WHERE age > 18;
SELECT * FROM users WHERE age BETWEEN 18 AND 65;
SELECT * FROM users ORDER BY age;
```

### Hash Index

Best for equality comparisons only (not range).

```sql
-- PostgreSQL
CREATE INDEX idx_email ON users USING HASH(email);

-- Good for:
SELECT * FROM users WHERE email = 'john@example.com';

-- NOT good for:
SELECT * FROM users WHERE email LIKE 'john%';
```

### Full-Text Index

Best for text search.

```sql
-- MySQL
CREATE FULLTEXT INDEX idx_content ON articles(content);
SELECT * FROM articles WHERE MATCH(content) AGAINST('search term');

-- PostgreSQL (GIN index)
CREATE INDEX idx_content ON articles USING GIN(to_tsvector('english', content));
```

### Partial Index (PostgreSQL, SQLite)

Index only specific rows.

```sql
-- Index only active users
CREATE INDEX idx_active_users ON users(email) WHERE active = true;

-- More efficient than indexing all rows
```

## Composite Indexes

Order matters! Index should match query conditions.

```sql
CREATE INDEX idx_user_lookup ON users(last_name, first_name, age);

-- ✅ Uses index (leftmost prefix rule)
SELECT * FROM users WHERE last_name = 'Smith';
SELECT * FROM users WHERE last_name = 'Smith' AND first_name = 'John';
SELECT * FROM users WHERE last_name = 'Smith' AND first_name = 'John' AND age = 30;

-- ❌ Doesn't use index efficiently
SELECT * FROM users WHERE first_name = 'John';  -- Skips last_name
SELECT * FROM users WHERE age = 30;             -- Skips last_name, first_name
```

## When to Create Indexes

**Create indexes on columns used in:**

```sql
-- WHERE clauses
SELECT * FROM users WHERE email = 'john@example.com';
-- Index: email

-- JOIN conditions
SELECT * FROM orders o JOIN users u ON o.user_id = u.id;
-- Index: orders.user_id, users.id

-- ORDER BY
SELECT * FROM users ORDER BY created_at DESC;
-- Index: created_at

-- GROUP BY
SELECT country, COUNT(*) FROM users GROUP BY country;
-- Index: country

-- Foreign keys
CREATE TABLE orders (
    id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
-- Index: user_id
```

## When NOT to Create Indexes

```sql
-- Small tables (< 1000 rows)
-- Full table scan is faster than index lookup

-- Columns with low cardinality (few unique values)
-- Example: gender (M/F/Other)
-- Index doesn't help much

-- Frequently updated columns
-- Index maintenance overhead > query benefit

-- Columns never used in WHERE/JOIN/ORDER BY
```

## Viewing Indexes

**MySQL:**
```sql
SHOW INDEXES FROM users;
SHOW INDEX FROM users;
```

**PostgreSQL:**
```sql
\d+ users
-- or
SELECT * FROM pg_indexes WHERE tablename = 'users';
```

**SQLite:**
```sql
.indexes users
-- or
SELECT * FROM sqlite_master WHERE type = 'index' AND tbl_name = 'users';
```

## Query Execution Plan

Check if index is being used:

**MySQL:**
```sql
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';

-- Output shows:
-- possible_keys: available indexes
-- key: index actually used
-- rows: estimated rows scanned
```

**PostgreSQL:**
```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE email = 'john@example.com';

-- Shows:
-- Index Scan vs Seq Scan
-- Actual execution time
```

**SQLite:**
```sql
EXPLAIN QUERY PLAN SELECT * FROM users WHERE email = 'john@example.com';

-- Shows if index is used
```

## Index Maintenance

```sql
-- Rebuild index (MySQL)
ALTER TABLE users DROP INDEX idx_email, ADD INDEX idx_email(email);

-- Rebuild all indexes (MySQL)
OPTIMIZE TABLE users;

-- Rebuild index (PostgreSQL)
REINDEX INDEX idx_email;
REINDEX TABLE users;

-- Analyze table statistics (helps query optimizer)
ANALYZE TABLE users;  -- MySQL
ANALYZE users;        -- PostgreSQL, SQLite
```

## Covering Indexes

Index that includes all columns needed by query (no table lookup needed).

```sql
-- Query needs: email, age
CREATE INDEX idx_email_age ON users(email, age);

-- This query only reads from index (faster)
SELECT age FROM users WHERE email = 'john@example.com';
```

## Index Best Practices

```sql
-- 1. Index foreign keys
CREATE INDEX idx_user_id ON orders(user_id);

-- 2. Index columns used in JOINs
CREATE INDEX idx_email ON users(email);

-- 3. Composite index order: most selective first
-- If searching by country + city, and country has fewer unique values:
CREATE INDEX idx_location ON addresses(country, city);  -- ❌ Bad
CREATE INDEX idx_location ON addresses(city, country);  -- ✅ Better

-- 4. Don't over-index
-- Too many indexes slow down INSERT/UPDATE/DELETE

-- 5. Monitor unused indexes
-- Remove indexes that aren't being used

-- 6. Consider covering indexes for important queries

-- 7. Use EXPLAIN to verify indexes are used

-- 8. Regularly update statistics
ANALYZE TABLE users;
```

## Index Selectivity

Selectivity = number of distinct values / total rows

```sql
-- High selectivity (good for indexing)
-- email: 10,000 unique / 10,000 rows = 1.0 (perfect)

-- Low selectivity (bad for indexing)
-- gender: 3 unique / 10,000 rows = 0.0003

-- Check selectivity
SELECT
    COUNT(DISTINCT email) / COUNT(*) as email_selectivity,
    COUNT(DISTINCT gender) / COUNT(*) as gender_selectivity
FROM users;
```

## Common Indexing Mistakes

```sql
-- Mistake 1: Index every column
-- Only index columns actually used in queries

-- Mistake 2: Wrong composite index order
CREATE INDEX idx_name ON users(first_name, last_name);
SELECT * FROM users WHERE last_name = 'Smith';  -- Doesn't use index!

-- Fix: Put most selective column first
CREATE INDEX idx_name ON users(last_name, first_name);

-- Mistake 3: Indexing low cardinality columns
CREATE INDEX idx_gender ON users(gender);  -- Usually not helpful

-- Mistake 4: Not using EXPLAIN
-- Always verify index is being used with EXPLAIN

-- Mistake 5: Too many indexes on write-heavy tables
-- Each index slows down INSERT/UPDATE/DELETE
```

## Index Performance Example

```sql
-- Without index:
SELECT * FROM users WHERE email = 'john@example.com';
-- Scans 1,000,000 rows → slow

-- With index:
CREATE INDEX idx_email ON users(email);
SELECT * FROM users WHERE email = 'john@example.com';
-- Scans 1 row → fast

-- Check with EXPLAIN:
EXPLAIN SELECT * FROM users WHERE email = 'john@example.com';
```

## Multi-Column Index vs Multiple Indexes

```sql
-- Option 1: One composite index
CREATE INDEX idx_name_age ON users(name, age);
-- Good for: WHERE name = X AND age = Y
-- Good for: WHERE name = X
-- Bad for: WHERE age = Y

-- Option 2: Two separate indexes
CREATE INDEX idx_name ON users(name);
CREATE INDEX idx_age ON users(age);
-- Database can use both (index merge)
-- More flexible but takes more space

-- Choose based on your most common queries
```

## Index Hints (Use Sparingly)

```sql
-- Force index usage (MySQL)
SELECT * FROM users USE INDEX (idx_email)
WHERE email = 'john@example.com';

-- Ignore index
SELECT * FROM users IGNORE INDEX (idx_email)
WHERE email = 'john@example.com';

-- Usually let the optimizer decide!
```
