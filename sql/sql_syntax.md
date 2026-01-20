# SQL Syntax

## Basic Query

```sql
-- Select all columns
SELECT * FROM users;

-- Select specific columns
SELECT name, email FROM users;

-- With WHERE clause
SELECT * FROM users WHERE age > 18;

-- Limit results
SELECT * FROM users LIMIT 10;
```

## CREATE TABLE

```sql
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    age INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- With foreign key
CREATE TABLE posts (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200),
    content TEXT,
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

## INSERT

```sql
-- Insert single row
INSERT INTO users (username, email, age)
VALUES ('john', 'john@example.com', 25);

-- Insert multiple rows
INSERT INTO users (username, email, age)
VALUES
    ('alice', 'alice@example.com', 30),
    ('bob', 'bob@example.com', 28);

-- Insert from SELECT
INSERT INTO users_backup
SELECT * FROM users WHERE age > 18;
```

## UPDATE

```sql
-- Update single column
UPDATE users SET age = 26 WHERE username = 'john';

-- Update multiple columns
UPDATE users
SET age = 31, email = 'newemail@example.com'
WHERE username = 'alice';

-- Update with calculation
UPDATE products SET price = price * 1.1;
```

## DELETE

```sql
-- Delete specific rows
DELETE FROM users WHERE age < 18;

-- Delete all rows (keep table structure)
DELETE FROM users;

-- Delete with subquery
DELETE FROM orders WHERE user_id IN (
    SELECT id FROM users WHERE active = 0
);
```

## SELECT - WHERE Conditions

```sql
-- Comparison operators
SELECT * FROM users WHERE age = 25;
SELECT * FROM users WHERE age > 18;
SELECT * FROM users WHERE age >= 21;
SELECT * FROM users WHERE age <> 30;  -- Not equal
SELECT * FROM users WHERE age != 30;  -- Not equal

-- BETWEEN
SELECT * FROM users WHERE age BETWEEN 18 AND 30;

-- IN
SELECT * FROM users WHERE username IN ('john', 'alice', 'bob');

-- LIKE (pattern matching)
SELECT * FROM users WHERE email LIKE '%@gmail.com';
SELECT * FROM users WHERE username LIKE 'j%';     -- Starts with j
SELECT * FROM users WHERE username LIKE '%n';     -- Ends with n
SELECT * FROM users WHERE username LIKE '%oh%';   -- Contains oh

-- IS NULL / IS NOT NULL
SELECT * FROM users WHERE email IS NULL;
SELECT * FROM users WHERE email IS NOT NULL;

-- AND / OR / NOT
SELECT * FROM users WHERE age > 18 AND age < 65;
SELECT * FROM users WHERE age < 18 OR age > 65;
SELECT * FROM users WHERE NOT age = 25;
```

## ORDER BY

```sql
-- Ascending (default)
SELECT * FROM users ORDER BY age;
SELECT * FROM users ORDER BY age ASC;

-- Descending
SELECT * FROM users ORDER BY age DESC;

-- Multiple columns
SELECT * FROM users ORDER BY age DESC, username ASC;
```

## GROUP BY

```sql
-- Count users by age
SELECT age, COUNT(*) as count
FROM users
GROUP BY age;

-- Average age by country
SELECT country, AVG(age) as avg_age
FROM users
GROUP BY country;

-- HAVING (filter groups)
SELECT age, COUNT(*) as count
FROM users
GROUP BY age
HAVING COUNT(*) > 5;
```

## Aggregate Functions

```sql
-- COUNT
SELECT COUNT(*) FROM users;
SELECT COUNT(DISTINCT country) FROM users;

-- SUM
SELECT SUM(price) FROM orders;

-- AVG
SELECT AVG(age) FROM users;

-- MIN / MAX
SELECT MIN(age), MAX(age) FROM users;

-- Multiple aggregates
SELECT
    COUNT(*) as total,
    AVG(age) as avg_age,
    MIN(age) as min_age,
    MAX(age) as max_age
FROM users;
```

## DISTINCT

```sql
-- Get unique values
SELECT DISTINCT country FROM users;

-- Count unique values
SELECT COUNT(DISTINCT country) FROM users;
```

## LIMIT / OFFSET

```sql
-- First 10 rows
SELECT * FROM users LIMIT 10;

-- Rows 11-20 (pagination)
SELECT * FROM users LIMIT 10 OFFSET 10;

-- Alternative syntax (MySQL)
SELECT * FROM users LIMIT 10, 10;  -- OFFSET, LIMIT
```

## Subqueries

```sql
-- Subquery in WHERE
SELECT * FROM users WHERE age > (
    SELECT AVG(age) FROM users
);

-- Subquery in SELECT
SELECT username, (
    SELECT COUNT(*) FROM posts WHERE posts.user_id = users.id
) as post_count
FROM users;

-- Subquery in FROM
SELECT avg_age FROM (
    SELECT AVG(age) as avg_age FROM users GROUP BY country
) as country_averages;
```

## CASE Statement

```sql
SELECT username, age,
    CASE
        WHEN age < 18 THEN 'Minor'
        WHEN age BETWEEN 18 AND 65 THEN 'Adult'
        ELSE 'Senior'
    END as age_group
FROM users;

-- Simple CASE
SELECT username,
    CASE status
        WHEN 1 THEN 'Active'
        WHEN 0 THEN 'Inactive'
        ELSE 'Unknown'
    END as status_text
FROM users;
```

## ALTER TABLE

```sql
-- Add column
ALTER TABLE users ADD COLUMN phone VARCHAR(20);

-- Drop column
ALTER TABLE users DROP COLUMN phone;

-- Modify column
ALTER TABLE users MODIFY COLUMN email VARCHAR(255);

-- Rename column (MySQL 8.0+)
ALTER TABLE users RENAME COLUMN old_name TO new_name;

-- Add constraint
ALTER TABLE users ADD UNIQUE (email);
ALTER TABLE users ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id);
```

## DROP TABLE

```sql
-- Drop table
DROP TABLE users;

-- Drop if exists
DROP TABLE IF EXISTS users;

-- Drop multiple tables
DROP TABLE users, posts, comments;
```

## TRUNCATE

```sql
-- Remove all rows (faster than DELETE, resets auto-increment)
TRUNCATE TABLE users;
```

## Indexes

```sql
-- Create index
CREATE INDEX idx_email ON users(email);

-- Unique index
CREATE UNIQUE INDEX idx_username ON users(username);

-- Composite index
CREATE INDEX idx_name_age ON users(name, age);

-- Drop index
DROP INDEX idx_email ON users;
```

## Views

```sql
-- Create view
CREATE VIEW active_users AS
SELECT * FROM users WHERE active = 1;

-- Use view
SELECT * FROM active_users;

-- Drop view
DROP VIEW active_users;
```

## Transactions

```sql
-- Start transaction
START TRANSACTION;
-- or
BEGIN;

-- Execute queries
UPDATE accounts SET balance = balance - 100 WHERE id = 1;
UPDATE accounts SET balance = balance + 100 WHERE id = 2;

-- Commit changes
COMMIT;

-- Or rollback if error
ROLLBACK;
```

## Common String Functions

```sql
-- Concatenate
SELECT CONCAT(first_name, ' ', last_name) as full_name FROM users;

-- Uppercase / Lowercase
SELECT UPPER(username), LOWER(email) FROM users;

-- Substring
SELECT SUBSTRING(username, 1, 3) FROM users;

-- Length
SELECT LENGTH(username) FROM users;

-- Trim
SELECT TRIM(username) FROM users;

-- Replace
SELECT REPLACE(email, '@', ' at ') FROM users;
```

## Common Date Functions

```sql
-- Current date/time
SELECT NOW();
SELECT CURDATE();
SELECT CURTIME();

-- Extract parts
SELECT YEAR(created_at), MONTH(created_at), DAY(created_at) FROM users;

-- Date arithmetic
SELECT DATE_ADD(created_at, INTERVAL 7 DAY) FROM users;
SELECT DATE_SUB(created_at, INTERVAL 1 MONTH) FROM users;

-- Date difference
SELECT DATEDIFF(NOW(), created_at) as days_old FROM users;

-- Format date
SELECT DATE_FORMAT(created_at, '%Y-%m-%d') FROM users;
```

## Common Math Functions

```sql
SELECT ROUND(price, 2) FROM products;
SELECT CEIL(price) FROM products;
SELECT FLOOR(price) FROM products;
SELECT ABS(difference) FROM calculations;
SELECT RAND();  -- Random number between 0 and 1
```

## NULL Handling

```sql
-- COALESCE (return first non-null value)
SELECT COALESCE(phone, email, 'No contact') FROM users;

-- IFNULL / ISNULL (MySQL)
SELECT IFNULL(phone, 'N/A') FROM users;

-- NULLIF (return NULL if values are equal)
SELECT NULLIF(column1, column2) FROM table1;
```

## UNION

```sql
-- Combine results from multiple queries
SELECT username FROM users
UNION
SELECT username FROM admins;

-- UNION ALL (includes duplicates)
SELECT username FROM users
UNION ALL
SELECT username FROM admins;
```

## Comments

```sql
-- Single line comment

/*
   Multi-line
   comment
*/

SELECT * FROM users;  -- Inline comment
```
