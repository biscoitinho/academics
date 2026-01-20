# Common SQL Patterns

## Pagination

### Offset-Based (Simple)

```sql
-- Page 1 (items 1-10)
SELECT * FROM products ORDER BY id LIMIT 10 OFFSET 0;

-- Page 2 (items 11-20)
SELECT * FROM products ORDER BY id LIMIT 10 OFFSET 10;

-- Page N
SELECT * FROM products ORDER BY id LIMIT 10 OFFSET ((page - 1) * 10);

-- ❌ Problem: Slow for large offsets
-- OFFSET 1000000 scans and discards 1 million rows
```

### Cursor-Based (Fast)

```sql
-- First page
SELECT * FROM products ORDER BY id LIMIT 10;

-- Next page (where last_id = 10)
SELECT * FROM products WHERE id > 10 ORDER BY id LIMIT 10;

-- Previous page (where first_id = 21)
SELECT * FROM products WHERE id < 21 ORDER BY id DESC LIMIT 10;
```

### Keyset Pagination (Complex Ordering)

```sql
-- Order by created_at, id
-- First page
SELECT * FROM posts ORDER BY created_at DESC, id DESC LIMIT 10;

-- Next page (last row: created_at='2024-01-15', id=100)
SELECT * FROM posts
WHERE (created_at, id) < ('2024-01-15', 100)
ORDER BY created_at DESC, id DESC
LIMIT 10;
```

## Running Totals

### Using Window Functions

```sql
-- Running total
SELECT
    date,
    amount,
    SUM(amount) OVER (ORDER BY date) as running_total
FROM transactions
ORDER BY date;

-- Result:
-- date       | amount | running_total
-- 2024-01-01 | 100    | 100
-- 2024-01-02 | 50     | 150
-- 2024-01-03 | 75     | 225
```

### Without Window Functions

```sql
-- Using subquery
SELECT
    t1.date,
    t1.amount,
    (SELECT SUM(t2.amount)
     FROM transactions t2
     WHERE t2.date <= t1.date) as running_total
FROM transactions t1
ORDER BY t1.date;
```

## Ranking

### Row Number

```sql
SELECT
    name,
    score,
    ROW_NUMBER() OVER (ORDER BY score DESC) as rank
FROM students;

-- Result:
-- name  | score | rank
-- Alice | 95    | 1
-- Bob   | 90    | 2
-- Carol | 90    | 3  (different from RANK)
```

### Rank (Same Score = Same Rank)

```sql
SELECT
    name,
    score,
    RANK() OVER (ORDER BY score DESC) as rank
FROM students;

-- Result:
-- name  | score | rank
-- Alice | 95    | 1
-- Bob   | 90    | 2
-- Carol | 90    | 2
-- Dave  | 85    | 4  (skips 3)
```

### Dense Rank (No Gaps)

```sql
SELECT
    name,
    score,
    DENSE_RANK() OVER (ORDER BY score DESC) as rank
FROM students;

-- Result:
-- name  | score | rank
-- Alice | 95    | 1
-- Bob   | 90    | 2
-- Carol | 90    | 2
-- Dave  | 85    | 3  (no gap)
```

### Top N Per Group

```sql
-- Top 3 products per category
SELECT *
FROM (
    SELECT
        category,
        product_name,
        sales,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales DESC) as rank
    FROM products
) ranked
WHERE rank <= 3;
```

## Finding Duplicates

### Find Duplicate Rows

```sql
-- Find duplicate emails
SELECT email, COUNT(*) as count
FROM users
GROUP BY email
HAVING COUNT(*) > 1;
```

### List All Duplicate Rows

```sql
-- Show all users with duplicate emails
SELECT u.*
FROM users u
WHERE email IN (
    SELECT email
    FROM users
    GROUP BY email
    HAVING COUNT(*) > 1
);
```

### Keep First, Delete Duplicates

```sql
-- MySQL
DELETE u1
FROM users u1
INNER JOIN users u2
WHERE u1.id > u2.id AND u1.email = u2.email;

-- PostgreSQL
DELETE FROM users
WHERE id NOT IN (
    SELECT MIN(id)
    FROM users
    GROUP BY email
);
```

## Gap and Island Problems

### Find Missing Numbers

```sql
-- Find missing IDs in sequence
SELECT t1.id + 1 as missing_id
FROM users t1
LEFT JOIN users t2 ON t1.id + 1 = t2.id
WHERE t2.id IS NULL
AND t1.id < (SELECT MAX(id) FROM users);
```

### Find Consecutive Sequences

```sql
-- Find consecutive login days
WITH numbered AS (
    SELECT
        user_id,
        login_date,
        login_date - INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY as grp
    FROM logins
)
SELECT
    user_id,
    MIN(login_date) as streak_start,
    MAX(login_date) as streak_end,
    COUNT(*) as streak_length
FROM numbered
GROUP BY user_id, grp
HAVING COUNT(*) >= 3;  -- Streaks of 3+ days
```

## Hierarchical Data

### Parent-Child Relationship

```sql
-- employees table
-- id | name  | manager_id
-- 1  | Alice | NULL
-- 2  | Bob   | 1
-- 3  | Carol | 1
-- 4  | Dave  | 2

-- Get employee with manager name
SELECT
    e.name as employee,
    m.name as manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

### Get All Subordinates (Recursive CTE)

```sql
-- PostgreSQL, MySQL 8.0+
WITH RECURSIVE subordinates AS (
    -- Anchor: Start with manager
    SELECT id, name, manager_id, 0 as level
    FROM employees
    WHERE id = 1

    UNION ALL

    -- Recursive: Get subordinates
    SELECT e.id, e.name, e.manager_id, s.level + 1
    FROM employees e
    INNER JOIN subordinates s ON e.manager_id = s.id
)
SELECT * FROM subordinates;

-- Result:
-- id | name  | manager_id | level
-- 1  | Alice | NULL       | 0
-- 2  | Bob   | 1          | 1
-- 3  | Carol | 1          | 1
-- 4  | Dave  | 2          | 2
```

### Path to Root

```sql
WITH RECURSIVE path AS (
    SELECT id, name, manager_id, name as path
    FROM employees
    WHERE id = 4  -- Start from Dave

    UNION ALL

    SELECT e.id, e.name, e.manager_id, CONCAT(e.name, ' > ', p.path)
    FROM employees e
    INNER JOIN path p ON e.id = p.manager_id
)
SELECT path FROM path WHERE manager_id IS NULL;

-- Result: Alice > Bob > Dave
```

## Pivot Tables

### Convert Rows to Columns

```sql
-- Data:
-- month | product | sales
-- Jan   | A       | 100
-- Jan   | B       | 150
-- Feb   | A       | 120

-- Result:
-- month | A   | B
-- Jan   | 100 | 150
-- Feb   | 120 | NULL

-- MySQL/PostgreSQL
SELECT
    month,
    SUM(CASE WHEN product = 'A' THEN sales END) as A,
    SUM(CASE WHEN product = 'B' THEN sales END) as B
FROM sales
GROUP BY month;
```

### Unpivot (Columns to Rows)

```sql
-- Data:
-- month | A   | B
-- Jan   | 100 | 150

-- Result:
-- month | product | sales
-- Jan   | A       | 100
-- Jan   | B       | 150

-- Using UNION
SELECT month, 'A' as product, A as sales FROM sales_pivot
UNION ALL
SELECT month, 'B' as product, B as sales FROM sales_pivot;
```

## Date and Time Patterns

### Get First/Last Day of Month

```sql
-- MySQL
SELECT
    DATE_FORMAT(NOW(), '%Y-%m-01') as first_day,
    LAST_DAY(NOW()) as last_day;

-- PostgreSQL
SELECT
    DATE_TRUNC('month', NOW()) as first_day,
    DATE_TRUNC('month', NOW()) + INTERVAL '1 month - 1 day' as last_day;
```

### Group by Week/Month/Year

```sql
-- MySQL
SELECT
    YEAR(created_at) as year,
    MONTH(created_at) as month,
    COUNT(*) as count
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at);

-- PostgreSQL
SELECT
    DATE_TRUNC('month', created_at) as month,
    COUNT(*) as count
FROM orders
GROUP BY DATE_TRUNC('month', created_at);
```

### Calculate Business Days

```sql
-- Days between dates excluding weekends
SELECT
    order_date,
    ship_date,
    DATEDIFF(ship_date, order_date) -
    (WEEK(ship_date) - WEEK(order_date)) * 2 as business_days
FROM orders;
```

## Conditional Aggregation

### Multiple Counts in One Query

```sql
SELECT
    COUNT(*) as total_users,
    COUNT(CASE WHEN age < 18 THEN 1 END) as minors,
    COUNT(CASE WHEN age >= 18 AND age < 65 THEN 1 END) as adults,
    COUNT(CASE WHEN age >= 65 THEN 1 END) as seniors
FROM users;
```

### Conditional Sum

```sql
SELECT
    user_id,
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) as completed_total,
    SUM(CASE WHEN status = 'pending' THEN amount ELSE 0 END) as pending_total
FROM orders
GROUP BY user_id;
```

## Upsert (Insert or Update)

### MySQL (INSERT ... ON DUPLICATE KEY)

```sql
INSERT INTO users (id, name, email, login_count)
VALUES (1, 'John', 'john@example.com', 1)
ON DUPLICATE KEY UPDATE
    login_count = login_count + 1,
    last_login = NOW();
```

### PostgreSQL (INSERT ... ON CONFLICT)

```sql
INSERT INTO users (id, name, email, login_count)
VALUES (1, 'John', 'john@example.com', 1)
ON CONFLICT (id) DO UPDATE SET
    login_count = users.login_count + 1,
    last_login = NOW();
```

### SQLite (INSERT OR REPLACE)

```sql
INSERT OR REPLACE INTO users (id, name, email, login_count)
VALUES (1, 'John', 'john@example.com', 1);

-- Or use INSERT ... ON CONFLICT (SQLite 3.24+)
INSERT INTO users (id, name, email, login_count)
VALUES (1, 'John', 'john@example.com', 1)
ON CONFLICT (id) DO UPDATE SET
    login_count = login_count + 1;
```

## Copying Data

### Copy Table Structure

```sql
-- MySQL
CREATE TABLE users_backup LIKE users;

-- PostgreSQL
CREATE TABLE users_backup (LIKE users INCLUDING ALL);

-- SQLite
CREATE TABLE users_backup AS SELECT * FROM users WHERE 0;
```

### Copy Table with Data

```sql
CREATE TABLE users_backup AS SELECT * FROM users;

-- Copy specific rows
CREATE TABLE active_users AS
SELECT * FROM users WHERE active = 1;
```

### Copy Between Tables

```sql
INSERT INTO users_archive
SELECT * FROM users WHERE created_at < '2023-01-01';

-- Copy specific columns
INSERT INTO user_summary (user_id, order_count)
SELECT user_id, COUNT(*) FROM orders GROUP BY user_id;
```

## Random Sampling

### Random Row

```sql
-- MySQL
SELECT * FROM products ORDER BY RAND() LIMIT 1;

-- PostgreSQL
SELECT * FROM products ORDER BY RANDOM() LIMIT 1;

-- SQLite
SELECT * FROM products ORDER BY RANDOM() LIMIT 1;
```

### Random Sample (N Rows)

```sql
-- 100 random products
SELECT * FROM products ORDER BY RAND() LIMIT 100;

-- ✅ Better for large tables: Random with index
SELECT * FROM products
WHERE id >= (SELECT FLOOR(RAND() * (SELECT MAX(id) FROM products)))
LIMIT 100;
```

## Moving Averages

### 3-Row Moving Average

```sql
SELECT
    date,
    value,
    AVG(value) OVER (
        ORDER BY date
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) as moving_avg_3
FROM measurements;
```

### 7-Day Moving Average

```sql
SELECT
    date,
    value,
    AVG(value) OVER (
        ORDER BY date
        RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
    ) as moving_avg_7day
FROM daily_sales;
```

## Cumulative Distribution

### Percentile

```sql
SELECT
    name,
    score,
    PERCENT_RANK() OVER (ORDER BY score) * 100 as percentile
FROM students;

-- Result:
-- name  | score | percentile
-- Alice | 95    | 100
-- Bob   | 85    | 66.67
-- Carol | 75    | 33.33
-- Dave  | 65    | 0
```

### Quartiles

```sql
SELECT
    name,
    score,
    NTILE(4) OVER (ORDER BY score) as quartile
FROM students;

-- Result:
-- name  | score | quartile
-- Dave  | 65    | 1
-- Carol | 75    | 2
-- Bob   | 85    | 3
-- Alice | 95    | 4
```

## Finding Outliers

### Values Outside 2 Standard Deviations

```sql
WITH stats AS (
    SELECT
        AVG(price) as mean_price,
        STDDEV(price) as stddev_price
    FROM products
)
SELECT p.*
FROM products p, stats
WHERE p.price < stats.mean_price - 2 * stats.stddev_price
   OR p.price > stats.mean_price + 2 * stats.stddev_price;
```

### Using Percentiles

```sql
-- Find products outside 5th-95th percentile
WITH percentiles AS (
    SELECT
        PERCENTILE_CONT(0.05) WITHIN GROUP (ORDER BY price) as p5,
        PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY price) as p95
    FROM products
)
SELECT p.*
FROM products p, percentiles
WHERE p.price < percentiles.p5 OR p.price > percentiles.p95;
```

## Difference Between Consecutive Rows

### Calculate Change

```sql
SELECT
    date,
    value,
    value - LAG(value) OVER (ORDER BY date) as change,
    (value - LAG(value) OVER (ORDER BY date)) / LAG(value) OVER (ORDER BY date) * 100 as pct_change
FROM stock_prices;
```

## JSON Operations

### MySQL

```sql
-- Store JSON
INSERT INTO users (data) VALUES ('{"name": "John", "age": 30}');

-- Query JSON
SELECT data->>'$.name' as name FROM users;
SELECT * FROM users WHERE data->>'$.age' > 25;

-- Update JSON
UPDATE users SET data = JSON_SET(data, '$.age', 31) WHERE id = 1;
```

### PostgreSQL

```sql
-- Store JSON
INSERT INTO users (data) VALUES ('{"name": "John", "age": 30}');

-- Query JSON (-> returns JSON, ->> returns text)
SELECT data->>'name' as name FROM users;
SELECT * FROM users WHERE (data->>'age')::int > 25;

-- Update JSON
UPDATE users SET data = jsonb_set(data, '{age}', '31') WHERE id = 1;
```

## Full-Text Search

### MySQL

```sql
-- Create full-text index
ALTER TABLE articles ADD FULLTEXT(title, content);

-- Search
SELECT * FROM articles
WHERE MATCH(title, content) AGAINST('database optimization');

-- Boolean search
SELECT * FROM articles
WHERE MATCH(title, content) AGAINST('+mysql -oracle' IN BOOLEAN MODE);
```

### PostgreSQL

```sql
-- Create GIN index
CREATE INDEX idx_content ON articles USING GIN(to_tsvector('english', content));

-- Search
SELECT * FROM articles
WHERE to_tsvector('english', content) @@ to_tsquery('english', 'database & optimization');

-- Rank results
SELECT *, ts_rank(to_tsvector('english', content), query) as rank
FROM articles, to_tsquery('english', 'database & optimization') query
WHERE to_tsvector('english', content) @@ query
ORDER BY rank DESC;
```

## Generate Series

### PostgreSQL

```sql
-- Generate numbers 1-10
SELECT generate_series(1, 10);

-- Generate dates
SELECT generate_series(
    '2024-01-01'::date,
    '2024-01-31'::date,
    '1 day'::interval
) as date;

-- Fill missing dates
SELECT d.date, COALESCE(s.sales, 0) as sales
FROM generate_series('2024-01-01'::date, '2024-01-31'::date, '1 day') d(date)
LEFT JOIN sales s ON d.date = s.date;
```

### MySQL (Recursive CTE)

```sql
-- Generate numbers 1-10
WITH RECURSIVE numbers AS (
    SELECT 1 as n
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 10
)
SELECT * FROM numbers;

-- Generate dates
WITH RECURSIVE dates AS (
    SELECT '2024-01-01' as date
    UNION ALL
    SELECT date + INTERVAL 1 DAY FROM dates WHERE date < '2024-01-31'
)
SELECT * FROM dates;
```

## Common Table Expressions (CTEs)

### Multiple CTEs

```sql
WITH
active_users AS (
    SELECT * FROM users WHERE active = 1
),
recent_orders AS (
    SELECT * FROM orders WHERE created_at > NOW() - INTERVAL 30 DAY
)
SELECT u.name, COUNT(o.id) as order_count
FROM active_users u
LEFT JOIN recent_orders o ON u.id = o.user_id
GROUP BY u.id, u.name;
```

### Reusable Queries

```sql
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) as month,
        SUM(total) as sales
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    month,
    sales,
    sales - LAG(sales) OVER (ORDER BY month) as change
FROM monthly_sales;
```

## Performance Patterns

### Exists vs Count

```sql
-- ❌ Slow: Count all
SELECT * FROM users
WHERE (SELECT COUNT(*) FROM orders WHERE orders.user_id = users.id) > 0;

-- ✅ Fast: Exists (stops at first match)
SELECT * FROM users
WHERE EXISTS (SELECT 1 FROM orders WHERE orders.user_id = users.id);
```

### Batch Updates

```sql
-- ❌ Slow: Update one by one
UPDATE products SET price = price * 1.1 WHERE id = 1;
UPDATE products SET price = price * 1.1 WHERE id = 2;
-- ...

-- ✅ Fast: Batch update
UPDATE products SET price = price * 1.1 WHERE id IN (1, 2, 3, ...);

-- ✅ Better: Update all matching criteria
UPDATE products SET price = price * 1.1 WHERE category = 'electronics';
```

### Pre-compute Aggregates

```sql
-- ❌ Slow: Calculate on every query
SELECT
    user_id,
    (SELECT COUNT(*) FROM orders WHERE orders.user_id = users.id) as order_count
FROM users;

-- ✅ Fast: Store pre-computed value
ALTER TABLE users ADD COLUMN order_count INT DEFAULT 0;

-- Update with trigger
CREATE TRIGGER update_order_count
AFTER INSERT ON orders
FOR EACH ROW
UPDATE users SET order_count = order_count + 1 WHERE id = NEW.user_id;
```
